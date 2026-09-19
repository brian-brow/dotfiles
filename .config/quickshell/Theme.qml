import QtQuick

QtObject {

    /* Matugen Palette */

    property color background: "#111318"

    property color error: "#ffb4ab"
    property color error_container: "#93000a"

    property color inverse_on_surface: "#2e3035"
    property color inverse_primary: "#3e5f90"
    property color inverse_surface: "#e1e2e9"

    property color on_background: "#e1e2e9"

    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"

    property color on_primary: "#03305f"
    property color on_primary_container: "#d5e3ff"
    property color on_primary_fixed: "#001b3b"
    property color on_primary_fixed_variant: "#244777"

    property color on_secondary: "#273141"
    property color on_secondary_container: "#d9e3f8"
    property color on_secondary_fixed: "#121c2b"
    property color on_secondary_fixed_variant: "#3d4758"

    property color on_surface: "#e1e2e9"
    property color on_surface_variant: "#c4c6cf"

    property color on_tertiary: "#3e2845"
    property color on_tertiary_container: "#f8d8fe"
    property color on_tertiary_fixed: "#27132f"
    property color on_tertiary_fixed_variant: "#553e5d"

    property color outline: "#8e9199"
    property color outline_variant: "#43474e"

    property color primary: "#a7c8ff"
    property color primary_container: "#244777"
    property color primary_fixed: "#d5e3ff"
    property color primary_fixed_dim: "#a7c8ff"

    property color scrim: "#000000"

    property color secondary: "#bdc7dc"
    property color secondary_container: "#3d4758"
    property color secondary_fixed: "#d9e3f8"
    property color secondary_fixed_dim: "#bdc7dc"

    property color shadow: "#000000"

    property color source_color: "#40587d"

    property color surface: "#111318"
    property color surface_bright: "#37393e"
    property color surface_container: "#1d2024"
    property color surface_container_high: "#282a2f"
    property color surface_container_highest: "#32353a"
    property color surface_container_low: "#191c20"
    property color surface_container_lowest: "#0c0e13"
    property color surface_dim: "#111318"

    property color surface_tint: "#a7c8ff"

    property color surface_variant: "#43474e"

    property color tertiary: "#dbbde2"
    property color tertiary_container: "#553e5d"
    property color tertiary_fixed: "#f8d8fe"
    property color tertiary_fixed_dim: "#dbbde2"


    /* UI Settings */

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 16


    /* UI Aliases (optional but useful) */

    property color bg: surface
    property color fg: on_surface
    property color muted: outline_variant
    property color accent: tertiary
}
