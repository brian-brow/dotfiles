import QtQuick

QtObject {

    /* Matugen Palette */

    property color background: "#0e1513"

    property color error: "#ffb4ab"
    property color error_container: "#93000a"

    property color inverse_on_surface: "#2b3230"
    property color inverse_primary: "#066b5b"
    property color inverse_surface: "#dee4e0"

    property color on_background: "#dee4e0"

    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"

    property color on_primary: "#00382e"
    property color on_primary_container: "#a0f2de"
    property color on_primary_fixed: "#00201a"
    property color on_primary_fixed_variant: "#005144"

    property color on_secondary: "#1d352f"
    property color on_secondary_container: "#cde8e0"
    property color on_secondary_fixed: "#06201a"
    property color on_secondary_fixed_variant: "#334b45"

    property color on_surface: "#dee4e0"
    property color on_surface_variant: "#bfc9c4"

    property color on_tertiary: "#113348"
    property color on_tertiary_container: "#c8e6ff"
    property color on_tertiary_fixed: "#001e2e"
    property color on_tertiary_fixed_variant: "#2a4a5f"

    property color outline: "#89938f"
    property color outline_variant: "#3f4946"

    property color primary: "#84d6c2"
    property color primary_container: "#005144"
    property color primary_fixed: "#a0f2de"
    property color primary_fixed_dim: "#84d6c2"

    property color scrim: "#000000"

    property color secondary: "#b1ccc4"
    property color secondary_container: "#334b45"
    property color secondary_fixed: "#cde8e0"
    property color secondary_fixed_dim: "#b1ccc4"

    property color shadow: "#000000"

    property color source_color: "#047b69"

    property color surface: "#0e1513"
    property color surface_bright: "#343b38"
    property color surface_container: "#1b211f"
    property color surface_container_high: "#252b29"
    property color surface_container_highest: "#303634"
    property color surface_container_low: "#171d1b"
    property color surface_container_lowest: "#090f0e"
    property color surface_dim: "#0e1513"

    property color surface_tint: "#84d6c2"

    property color surface_variant: "#3f4946"

    property color tertiary: "#aacbe4"
    property color tertiary_container: "#2a4a5f"
    property color tertiary_fixed: "#c8e6ff"
    property color tertiary_fixed_dim: "#aacbe4"


    /* UI Settings */

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 16


    /* UI Aliases (optional but useful) */

    property color bg: surface
    property color fg: on_surface
    property color muted: outline_variant
    property color accent: tertiary
}
