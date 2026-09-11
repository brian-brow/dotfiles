import os, select, sys, termios, time, tty
flags = sys.argv[1] if len(sys.argv) > 1 else None
fd = os.open("/dev/tty", os.O_RDWR)
old = termios.tcgetattr(fd)
out, start, last = [], time.monotonic(), None
try:
    tty.setraw(fd)
    if flags:
        os.write(fd, b"\x1b[>" + flags.encode() + b"u")
    os.write(fd, b"\r\npress Backspace, then q\r\n")
    while time.monotonic() - start < 60:
        if not select.select([fd], [], [], 1)[0]:
            continue
        d = os.read(fd, 256)
        now = time.monotonic() - start
        gap = "" if last is None else f"  +{(now - last) * 1000:.0f}ms"
        last = now
        out.append(f"{now:7.3f}s  {d.hex(' '):<20} {d!r}{gap}")
        if b"q" in d:
            break
finally:
    if flags:
        os.write(fd, b"\x1b[<u")
    termios.tcsetattr(fd, termios.TCSADRAIN, old)
    os.close(fd)
print("\n".join(out))
