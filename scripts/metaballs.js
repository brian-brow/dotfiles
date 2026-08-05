#!/usr/bin/env node
'use strict';

// ── Metaballs — terminal edition ───────────────────────────────────────────
// Controls: b = toggle bold shading, d = toggle debug (ball centers),
//           r = reset balls, q / Ctrl-C = quit

const COLOR = 32; // 30 black 31 red 32 green 33 yellow 34 blue 35 magenta 36 cyan 37 white
const TARGET_FPS = 60;
const FRAME_MS = 1000 / TARGET_FPS;

let bold = true;
let debug = false;

// Precompute the fixed color codes once — never recomputed in the hot path.
const FG_NORMAL = COLOR;
const FG_BRIGHT = COLOR - 30 + 90;
const BG_NORMAL = COLOR + 10;
const BG_BRIGHT = COLOR - 30 + 100;

// ── Cell states ────────────────────────────────────────────────────────────
// A cell is one of 4 shapes, optionally bright. Encoded as shape | BRIGHT so
// the whole frame fits in a Uint8Array we can diff cheaply against the last one.
const EMPTY = 0, FULL = 1, TOP = 2, BOTTOM = 3;
const BRIGHT = 4;

// Split into prefix (the SGR sequence) and glyph so a run of identical cells
// emits the escape sequence once and then just the glyphs — the single biggest
// reduction in bytes-per-frame, which is what Ghostty actually has to parse.
const PREFIX = [];
const GLYPH = [];
PREFIX[EMPTY]           = '\x1b[0m';                    GLYPH[EMPTY]           = ' ';
PREFIX[FULL]            = `\x1b[0;${BG_NORMAL}m`;       GLYPH[FULL]            = ' ';
PREFIX[TOP]             = `\x1b[0;${FG_NORMAL};49m`;    GLYPH[TOP]             = '▀';
PREFIX[BOTTOM]          = `\x1b[0;${FG_NORMAL};49m`;    GLYPH[BOTTOM]          = '▄';
PREFIX[EMPTY  | BRIGHT] = '\x1b[0m';                    GLYPH[EMPTY  | BRIGHT] = ' ';
PREFIX[FULL   | BRIGHT] = `\x1b[0;${BG_BRIGHT}m`;       GLYPH[FULL   | BRIGHT] = ' ';
PREFIX[TOP    | BRIGHT] = `\x1b[0;${FG_BRIGHT};49m`;    GLYPH[TOP    | BRIGHT] = '▀';
PREFIX[BOTTOM | BRIGHT] = `\x1b[0;${FG_BRIGHT};49m`;    GLYPH[BOTTOM | BRIGHT] = '▄';

// ── Terminal geometry & buffers ────────────────────────────────────────────
let cols, rows, W, H;
let front, back;      // current / previously-drawn frame, one byte per cell
let sampTop, sampBot; // one subpixel row of samples, reused every row
let needsClear = true;

function allocate() {
  cols = process.stdout.columns || 80;
  rows = process.stdout.rows || 24;
  W = cols;
  H = rows * 2;
  const n = cols * rows;
  front = new Uint8Array(n);
  back = new Uint8Array(n);
  back.fill(0xff); // sentinel: nothing on screen matches, so the first frame is a full paint
  sampTop = new Uint8Array(cols);
  sampBot = new Uint8Array(cols);
  needsClear = true;
}

// ── Ball state ─────────────────────────────────────────────────────────────
// Flat typed arrays instead of an array of objects — better cache locality and
// no megamorphic property access in the hot loop. Velocities are in cells per
// *second*, so motion is identical no matter what frame rate we actually hit.
const BALL_COUNT = 16;
const SPEED = 30; // cells/sec at full tilt
const bx = new Float64Array(BALL_COUNT);
const by = new Float64Array(BALL_COUNT);
const bvx = new Float64Array(BALL_COUNT);
const bvy = new Float64Array(BALL_COUNT);
const br = new Float64Array(BALL_COUNT);
const brSq = new Float64Array(BALL_COUNT);
const bdySq = new Float64Array(BALL_COUNT); // per-row scratch, see sampleRow

function resetBalls() {
  const minDim = Math.min(W, H);
  for (let i = 0; i < BALL_COUNT; i++) {
    bx[i] = Math.random() * W;
    by[i] = Math.random() * H;
    bvx[i] = (Math.random() * 2 - 1) * SPEED;
    bvy[i] = (Math.random() * 2 - 1) * SPEED;
    br[i] = Math.random() * (minDim * 0.10) + minDim * 0.03;
    brSq[i] = br[i] * br[i];
  }
}

function updateBalls(dt) {
  for (let i = 0; i < BALL_COUNT; i++) {
    const r = br[i];
    let x = bx[i] + bvx[i] * dt;
    let y = by[i] + bvy[i] * dt;
    if (x > W - r) { bvx[i] = -bvx[i]; x = W - r; }
    if (x < r)     { bvx[i] = -bvx[i]; x = r; }
    if (y > H - r) { bvy[i] = -bvy[i]; y = H - r; }
    if (y < r)     { bvy[i] = -bvy[i]; y = r; }
    bx[i] = x;
    by[i] = y;
  }
}

// Fill `out` with one subpixel row of samples.
// 0 = background, 1 = inside a metaball, 2 = ball center (debug marker).
// Hoisting dy² out of the column loop makes the inner loop two ops shorter per
// ball per cell, which is where essentially all the frame time goes.
function sampleRow(y, out) {
  for (let l = 0; l < BALL_COUNT; l++) {
    const dy = y - by[l];
    bdySq[l] = dy * dy;
  }
  if (debug) {
    // Debug mode can't early-exit — a center must never be missed by a pixel
    // that already summed past the threshold.
    for (let x = 0; x < cols; x++) {
      let sum = 0;
      let hit = 0;
      for (let l = 0; l < BALL_COUNT; l++) {
        const dx = x - bx[l];
        const dsq = dx * dx + bdySq[l];
        if (dsq < 2) { hit = 2; break; }
        sum += brSq[l] / dsq;
      }
      out[x] = hit === 2 ? 2 : (sum > 1 ? 1 : 0);
    }
    return;
  }
  for (let x = 0; x < cols; x++) {
    let sum = 0;
    let hit = 0;
    for (let l = 0; l < BALL_COUNT; l++) {
      const dx = x - bx[l];
      sum += brSq[l] / (dx * dx + bdySq[l]);
      if (sum > 1) { hit = 1; break; } // bail the instant the pixel is known inside
    }
    out[x] = hit;
  }
}

// Rasterize the field into `front`.
function rasterize() {
  const brightBit = bold ? BRIGHT : 0;
  for (let ry = 0; ry < rows; ry++) {
    sampleRow(ry * 2, sampTop);
    sampleRow(ry * 2 + 1, sampBot);
    const base = ry * cols;
    for (let cx = 0; cx < cols; cx++) {
      const t = sampTop[cx];
      const b = sampBot[cx];
      let shape;
      if (t && b) shape = FULL;
      else if (t) shape = TOP;
      else if (b) shape = BOTTOM;
      else { front[base + cx] = EMPTY; continue; }
      // Debug centers are always drawn bright so they stay visible unshaded.
      front[base + cx] = shape | ((t === 2 || b === 2) ? BRIGHT : brightBit);
    }
  }
}

// Emit only what changed, wrapped in synchronized output so Ghostty presents
// the frame atomically instead of mid-repaint — this is what kills the tearing.
function paint() {
  let out = '\x1b[?2026h'; // begin synchronized update
  if (needsClear) {
    out += '\x1b[2J';
    needsClear = false;
  }

  for (let ry = 0; ry < rows; ry++) {
    const base = ry * cols;

    // Find the changed span in this row; most rows are untouched most frames.
    let first = -1;
    for (let cx = 0; cx < cols; cx++) {
      if (front[base + cx] !== back[base + cx]) { first = cx; break; }
    }
    if (first === -1) continue;
    let last = first;
    for (let cx = cols - 1; cx > first; cx--) {
      if (front[base + cx] !== back[base + cx]) { last = cx; break; }
    }

    out += `\x1b[${ry + 1};${first + 1}H`;
    let run = -1; // state whose SGR prefix is currently active
    for (let cx = first; cx <= last; cx++) {
      const s = front[base + cx];
      if (s !== run) { out += PREFIX[s]; run = s; }
      out += GLYPH[s];
      back[base + cx] = s;
    }
  }

  out += '\x1b[0m\x1b[?2026l'; // end synchronized update
  return process.stdout.write(out);
}

// ── Main loop ──────────────────────────────────────────────────────────────
// Self-scheduling timeout with measured dt: no drift, no pile-up of overdue
// setInterval callbacks, and physics that stays correct if a frame runs long.
let last = 0;
let running = true;
let drained = true;

function frame() {
  if (!running) return;
  const now = Date.now();
  const dt = Math.min((now - last) / 1000, 0.1); // clamp so a stall doesn't teleport balls
  last = now;

  updateBalls(dt);

  // If the terminal hasn't kept up, skip the paint rather than queueing another
  // frame behind it — queued frames are what turns a slow moment into lag.
  if (drained) {
    rasterize();
    if (!paint()) {
      drained = false;
      process.stdout.once('drain', () => { drained = true; });
    }
  }

  const elapsed = Date.now() - now;
  setTimeout(frame, Math.max(0, FRAME_MS - elapsed));
}

// ── Keyboard controls ──────────────────────────────────────────────────────
const readline = require('readline');
readline.emitKeypressEvents(process.stdin);
if (process.stdin.isTTY) process.stdin.setRawMode(true);
process.stdin.resume();

process.stdin.on('keypress', (str, key) => {
  if (!key) return;
  if (key.name === 'q' || (key.ctrl && key.name === 'c')) {
    running = false;
    cleanup();
    process.exit(0);
  } else if (key.name === 'b') {
    bold = !bold;
  } else if (key.name === 'd') {
    debug = !debug;
  } else if (key.name === 'r') {
    resetBalls();
  }
});

let resizeTimer = null;
process.stdout.on('resize', () => {
  // Ghostty streams resize events during a drag; coalesce them so we reallocate
  // and full-clear once at the end instead of on every intermediate size.
  if (resizeTimer) clearTimeout(resizeTimer);
  resizeTimer = setTimeout(() => {
    resizeTimer = null;
    const oldW = W, oldH = H;
    allocate();
    for (let i = 0; i < BALL_COUNT; i++) {
      bx[i] = Math.min(Math.max(bx[i] * (W / oldW), br[i]), Math.max(br[i], W - br[i]));
      by[i] = Math.min(Math.max(by[i] * (H / oldH), br[i]), Math.max(br[i], H - br[i]));
    }
  }, 40);
});

// ── Terminal setup / teardown ──────────────────────────────────────────────
let cleaned = false;
function cleanup() {
  if (cleaned) return;
  cleaned = true;
  process.stdout.write(
    '\x1b[0m' +
    '\x1b[?25h' +  // show cursor
    '\x1b[?7h' +   // restore autowrap
    '\x1b[?1049l'  // leave alt screen — scrollback comes back untouched
  );
  if (process.stdin.isTTY) process.stdin.setRawMode(false);
}

process.stdout.write(
  '\x1b[?1049h' + // alt screen: the animation can't scroll the real buffer or eat scrollback
  '\x1b[?7l' +    // autowrap off, so writing the bottom-right cell can't scroll the view
  '\x1b[?25l' +   // hide cursor
  '\x1b[2J\x1b[H'
);

allocate();
resetBalls();
process.on('exit', cleanup);
process.on('SIGTERM', () => { cleanup(); process.exit(0); });
process.on('SIGHUP', () => { cleanup(); process.exit(0); });

last = Date.now();
frame();
