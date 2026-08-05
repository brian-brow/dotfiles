#!/usr/bin/env node
'use strict';

// ── Metaballs — terminal edition (optimized) ────────────────────────────────
// Controls: b = toggle bold shading, d = toggle debug (ball centers),
//           r = reset balls, q / Ctrl-C = quit

const COLOR = 32; // 30 black 31 red 32 green 33 yellow 34 blue 35 magenta 36 cyan 37 white

let bold = true;
let debug = false;

// Precompute the fixed color codes once — never recomputed in the hot path.
const FG_NORMAL = COLOR;
const FG_BRIGHT = COLOR - 30 + 90;
const BG_NORMAL = COLOR + 10;
const BG_BRIGHT = COLOR - 30 + 100;

// Precompute the actual output strings for every (state) combination once,
// so the per-cell hot loop never builds a template literal or does string
// concatenation — it just picks a ready-made constant.
const SEQ_TRANSPARENT = '\x1b[0m ';
const SEQ = {
  full:   { normal: `\x1b[0;${BG_NORMAL}m `,          bright: `\x1b[0;${BG_BRIGHT}m ` },
  top:    { normal: `\x1b[0;${FG_NORMAL};49m\u2580`,  bright: `\x1b[0;${FG_BRIGHT};49m\u2580` },
  bottom: { normal: `\x1b[0;${FG_NORMAL};49m\u2584`,  bright: `\x1b[0;${FG_BRIGHT};49m\u2584` },
};

class Ball {
  constructor(w, h) {
    this.w = w; this.h = h;
    this.x = Math.random() * w;
    this.y = Math.random() * h;
    this.vx = Math.random() * 3 - 1.5;
    this.vy = Math.random() * 3 - 1.5;
    this.r = Math.random() * (Math.min(w, h) * 0.10) + Math.min(w, h) * 0.03;
    this.rSq = this.r * this.r; // precomputed once — never changes after creation
  }
  update() {
    this.x += this.vx;
    this.y += this.vy;
    if (this.x > this.w - this.r) { this.vx = -this.vx; this.x = this.w - this.r; }
    if (this.x < this.r)          { this.vx = -this.vx; this.x = this.r; }
    if (this.y > this.h - this.r) { this.vy = -this.vy; this.y = this.h - this.r; }
    if (this.y < this.r)          { this.vy = -this.vy; this.y = this.r; }
  }
}

function getSize() {
  return { cols: process.stdout.columns || 80, rows: process.stdout.rows || 24 };
}

let { cols, rows } = getSize();
let W = cols;
let H = rows * 2;
let needsClear = true; // only pay for a full \x1b[2J when the frame geometry actually changed

// Flat typed arrays for ball state instead of an array of objects — better
// cache locality and avoids megamorphic property access in the hot loop.
const BALL_COUNT = 16;
let bx = new Float64Array(BALL_COUNT);
let by = new Float64Array(BALL_COUNT);
let bvx = new Float64Array(BALL_COUNT);
let bvy = new Float64Array(BALL_COUNT);
let br = new Float64Array(BALL_COUNT);
let brSq = new Float64Array(BALL_COUNT);

function resetBalls() {
  for (let i = 0; i < BALL_COUNT; i++) {
    bx[i] = Math.random() * W;
    by[i] = Math.random() * H;
    bvx[i] = Math.random() * 3 - 1.5;
    bvy[i] = Math.random() * 3 - 1.5;
    br[i] = Math.random() * (Math.min(W, H) * 0.10) + Math.min(W, H) * 0.03;
    brSq[i] = br[i] * br[i];
  }
}
resetBalls();

process.stdout.on('resize', () => {
  ({ cols, rows } = getSize());
  W = cols;
  H = rows * 2;
  for (let i = 0; i < BALL_COUNT; i++) {
    bx[i] = Math.min(bx[i], W - br[i]);
    by[i] = Math.min(by[i], H - br[i]);
  }
  needsClear = true; // geometry changed — old leftover glyphs may linger, clear once
});

function updateBalls() {
  for (let i = 0; i < BALL_COUNT; i++) {
    bx[i] += bvx[i];
    by[i] += bvy[i];
    const r = br[i];
    if (bx[i] > W - r) { bvx[i] = -bvx[i]; bx[i] = W - r; }
    if (bx[i] < r)     { bvx[i] = -bvx[i]; bx[i] = r; }
    if (by[i] > H - r) { bvy[i] = -bvy[i]; by[i] = H - r; }
    if (by[i] < r)     { bvy[i] = -bvy[i]; by[i] = r; }
  }
}

// Returns: 0 = background, 1 = inside a metaball, 2 = ball center (debug marker)
function sampleAt(x, y) {
  let sum = 0;
  if (debug) {
    // Debug mode: must check every ball (can't early-exit) so centers are never missed.
    for (let l = 0; l < BALL_COUNT; l++) {
      const dx = x - bx[l];
      const dy = y - by[l];
      const dsq = dx * dx + dy * dy;
      if (dsq < 2) return 2;
      sum += brSq[l] / dsq;
    }
    return sum > 1 ? 1 : 0;
  }
  // Fast path: bail the instant we know the pixel is inside — skips
  // remaining balls entirely, which matters most in dense/overlapping areas.
  for (let l = 0; l < BALL_COUNT; l++) {
    const dx = x - bx[l];
    const dy = y - by[l];
    const dsq = dx * dx + dy * dy;
    sum += brSq[l] / dsq;
    if (sum > 1) return 1;
  }
  return 0;
}

function render() {
  const parts = [needsClear ? '\x1b[2J\x1b[H' : '\x1b[H'];
  needsClear = false;

  const brightKey = bold ? 'bright' : 'normal';

  for (let ry = 0; ry < rows; ry++) {
    const y0 = ry * 2;
    const y1 = y0 + 1;
    let line = '';
    for (let cx = 0; cx < cols; cx++) {
      const top = sampleAt(cx, y0);
      const bot = sampleAt(cx, y1);

      if (!top && !bot) {
        line += SEQ_TRANSPARENT;
        continue;
      }

      const isCenter = (top === 2 || bot === 2);
      const key = (bold || isCenter) ? 'bright' : brightKey;

      if (top && bot) line += SEQ.full[key];
      else if (top)   line += SEQ.top[key];
      else            line += SEQ.bottom[key];
    }
    parts.push(line, '\x1b[0m\n');
  }
  process.stdout.write(parts.join(''));
}

function loop() {
  updateBalls();
  render();
}

// ── Keyboard controls ────────────────────────────────────────────────────
const readline = require('readline');
readline.emitKeypressEvents(process.stdin);
if (process.stdin.isTTY) process.stdin.setRawMode(true);

process.stdin.on('keypress', (str, key) => {
  if (!key) return;
  if (key.name === 'q' || (key.ctrl && key.name === 'c')) {
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

function cleanup() {
  process.stdout.write('\x1b[0m\x1b[2J\x1b[H\x1b[?25h');
  if (process.stdin.isTTY) process.stdin.setRawMode(false);
}

process.stdout.write('\x1b[2J\x1b[?25l');
const timer = setInterval(loop, 50);
process.on('exit', cleanup);
