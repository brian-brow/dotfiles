#!/usr/bin/env python3
"""
Rewrites a compiled GTK3 gtk.css so it references an external colors.css
(the matugen-generated @define-color file) instead of baking hex literals
into every rule.

Usage:
    python3 make_dynamic_gtk_css.py gtk.css > gtk.css.new
    mv gtk.css.new gtk.css

Then place colors.css next to it (same dir) — the @import at the top
pulls in the @define-color block matugen writes out.
"""
import re
import sys

if len(sys.argv) != 2:
    print("usage: make_dynamic_gtk_css.py <path-to-gtk.css>", file=sys.stderr)
    sys.exit(1)

with open(sys.argv[1], encoding="utf-8") as f:
    css = f.read()

# --- 1. Strip the theme's own @define-color block (colors.css replaces it) ---
# Matches from the "GTK NAMED COLORS" comment banner to end of file.
css = re.sub(
    r"/\* GTK NAMED COLORS.*", "", css, flags=re.DOTALL
)

# --- 2. Literal -> named-color substitutions -------------------------------
# Order matters: rgba()/alpha() patterns before bare hex, longer hex before
# any prefix collisions.
replacements = [
    # accent / selection blue
    (r"rgba\(50,\s*129,\s*234,\s*([0-9.]+)\)", r"alpha(@theme_selected_bg_color, \1)"),
    (r"#3281EA\b", "@theme_selected_bg_color"),
    (r"#1b73e8\b", "@theme_selected_bg_color"),  # hover-darkened accent
    (r"#428bec\b", "@theme_selected_bg_color"),  # hover-lightened accent
    (r"#70a7f0\b", "@theme_selected_bg_color"),  # checked-lightened accent

    # error / destructive red
    (r"rgba\(244,\s*67,\s*54,\s*([0-9.]+)\)", r"alpha(@error_color, \1)"),
    (r"#F44336\b", "@error_color"),
    (r"#f32c1e\b", "@error_color"),
    (r"#f77b72\b", "@error_color"),

    # warning yellow
    (r"#FBC02D\b", "@warning_color"),
    (r"#fbb814\b", "@warning_color"),

    # success green
    (r"#81C995\b", "@success_color"),

    # visited-link purple
    (r"#BA68C8\b", "@visited_link_color"),

    # base window background
    (r"#212121\b", "@theme_bg_color"),

    # primary surface / view background
    (r"#2C2C2C\b", "@theme_base_color"),

    # secondary surface (sidebars, headerbars, darker panels)
    (r"#242424\b", "@content_view_bg"),

    # popovers / menus / tooltips-adjacent surface
    (r"#3C3C3C\b", "@wm_unfocused_bg"),

    # foreground white, as a bare CSS keyword value (word-boundaried)
    (r"(?<![\w#-])white\b", "@theme_fg_color"),

    # foreground white with alpha
    (r"rgba\(255,\s*255,\s*255,\s*([0-9.]+)\)", r"alpha(@theme_fg_color, \1)"),
]

for pattern, repl in replacements:
    css = re.sub(pattern, repl, css)

# --- 3. Prepend the colors.css import --------------------------------------
header = '@import url("colors.css");\n\n'
css = header + css.lstrip("\n")

sys.stdout.write(css)
