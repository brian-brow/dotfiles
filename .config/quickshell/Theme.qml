import QtQuick

QtObject {

    /* Matugen Palette */

    property color background: "#131318"

    property color error: "#ffb4ab"
    property color error_container: "#93000a"

    property color inverse_on_surface: "#303036"
    property color inverse_primary: "#555a92"
    property color inverse_surface: "#e4e1e9"

    property color on_background: "#e4e1e9"

    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"

    property color on_primary: "#262b61"
    property color on_primary_container: "#e0e0ff"
    property color on_primary_fixed: "#10144b"
    property color on_primary_fixed_variant: "#3d4279"

    property color on_secondary: "#2e2f42"
    property color on_secondary_container: "#e1e0f9"
    property color on_secondary_fixed: "#191a2c"
    property color on_secondary_fixed_variant: "#444559"

    property color on_surface: "#e4e1e9"
    property color on_surface_variant: "#c7c5d0"

    property color on_tertiary: "#45263c"
    property color on_tertiary_container: "#ffd8ee"
    property color on_tertiary_fixed: "#2e1126"
    property color on_tertiary_fixed_variant: "#5e3c53"

    property color outline: "#91909a"
    property color outline_variant: "#46464f"

    property color primary: "#bec2ff"
    property color primary_container: "#3d4279"
    property color primary_fixed: "#e0e0ff"
    property color primary_fixed_dim: "#bec2ff"

    property color scrim: "#000000"

    property color secondary: "#c5c4dd"
    property color secondary_container: "#444559"
    property color secondary_fixed: "#e1e0f9"
    property color secondary_fixed_dim: "#c5c4dd"

    property color shadow: "#000000"

    property color source_color: "#8086cd"

    property color surface: "#131318"
    property color surface_bright: "#39393f"
    property color surface_container: "#1f1f25"
    property color surface_container_high: "#2a292f"
    property color surface_container_highest: "#34343a"
    property color surface_container_low: "#1b1b21"
    property color surface_container_lowest: "#0e0e13"
    property color surface_dim: "#131318"

    property color surface_tint: "#bec2ff"

    property color surface_variant: "#46464f"

    property color tertiary: "#e7b9d5"
    property color tertiary_container: "#5e3c53"
    property color tertiary_fixed: "#ffd8ee"
    property color tertiary_fixed_dim: "#e7b9d5"


    /* UI Settings */

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 16


    /* UI Aliases (optional but useful) */

    property color bg: surface
    property color fg: on_surface
    property color muted: outline_variant
    property color accent: tertiary
}
