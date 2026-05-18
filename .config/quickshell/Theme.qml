import QtQuick

QtObject {

    /* Matugen Palette */

    property color background: "#111318"

    property color error: "#ffb4ab"
    property color error_container: "#93000a"

    property color inverse_on_surface: "#2e3035"
    property color inverse_primary: "#3b608f"
    property color inverse_surface: "#e1e2e9"

    property color on_background: "#e1e2e9"

    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"

    property color on_primary: "#00315d"
    property color on_primary_container: "#d4e3ff"
    property color on_primary_fixed: "#001c39"
    property color on_primary_fixed_variant: "#204876"

    property color on_secondary: "#263141"
    property color on_secondary_container: "#d8e3f8"
    property color on_secondary_fixed: "#111c2b"
    property color on_secondary_fixed_variant: "#3d4758"

    property color on_surface: "#e1e2e9"
    property color on_surface_variant: "#c3c6cf"

    property color on_tertiary: "#3d2946"
    property color on_tertiary_container: "#f6d9ff"
    property color on_tertiary_fixed: "#261430"
    property color on_tertiary_fixed_variant: "#543f5e"

    property color outline: "#8d9199"
    property color outline_variant: "#43474e"

    property color primary: "#a4c9fe"
    property color primary_container: "#204876"
    property color primary_fixed: "#d4e3ff"
    property color primary_fixed_dim: "#a4c9fe"

    property color scrim: "#000000"

    property color secondary: "#bcc7db"
    property color secondary_container: "#3d4758"
    property color secondary_fixed: "#d8e3f8"
    property color secondary_fixed_dim: "#bcc7db"

    property color shadow: "#000000"

    property color source_color: "#2b394d"

    property color surface: "#111318"
    property color surface_bright: "#37393e"
    property color surface_container: "#1d2024"
    property color surface_container_high: "#272a2f"
    property color surface_container_highest: "#32353a"
    property color surface_container_low: "#191c20"
    property color surface_container_lowest: "#0c0e13"
    property color surface_dim: "#111318"

    property color surface_tint: "#a4c9fe"

    property color surface_variant: "#43474e"

    property color tertiary: "#d9bde3"
    property color tertiary_container: "#543f5e"
    property color tertiary_fixed: "#f6d9ff"
    property color tertiary_fixed_dim: "#d9bde3"


    /* UI Settings */

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 16


    /* UI Aliases (optional but useful) */

    property color bg: surface
    property color fg: on_surface
    property color muted: outline_variant
    property color accent: tertiary
}
