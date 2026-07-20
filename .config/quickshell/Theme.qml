import QtQuick

QtObject {

    /* Matugen Palette */

    property color background: "#10140f"

    property color error: "#ffb4ab"
    property color error_container: "#93000a"

    property color inverse_on_surface: "#2d322b"
    property color inverse_primary: "#3d6838"
    property color inverse_surface: "#e0e4da"

    property color on_background: "#e0e4da"

    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"

    property color on_primary: "#0d380d"
    property color on_primary_container: "#bef0b2"
    property color on_primary_fixed: "#002202"
    property color on_primary_fixed_variant: "#265022"

    property color on_secondary: "#263422"
    property color on_secondary_container: "#d6e8ce"
    property color on_secondary_fixed: "#111f0f"
    property color on_secondary_fixed_variant: "#3c4b38"

    property color on_surface: "#e0e4da"
    property color on_surface_variant: "#c2c8bc"

    property color on_tertiary: "#00363a"
    property color on_tertiary_container: "#bcebef"
    property color on_tertiary_fixed: "#002022"
    property color on_tertiary_fixed_variant: "#1e4d51"

    property color outline: "#8c9388"
    property color outline_variant: "#42493f"

    property color primary: "#a3d398"
    property color primary_container: "#265022"
    property color primary_fixed: "#bef0b2"
    property color primary_fixed_dim: "#a3d398"

    property color scrim: "#000000"

    property color secondary: "#baccb3"
    property color secondary_container: "#3c4b38"
    property color secondary_fixed: "#d6e8ce"
    property color secondary_fixed_dim: "#baccb3"

    property color shadow: "#000000"

    property color source_color: "#466a40"

    property color surface: "#10140f"
    property color surface_bright: "#363a34"
    property color surface_container: "#1d211b"
    property color surface_container_high: "#272b25"
    property color surface_container_highest: "#323630"
    property color surface_container_low: "#191d17"
    property color surface_container_lowest: "#0b0f0a"
    property color surface_dim: "#10140f"

    property color surface_tint: "#a3d398"

    property color surface_variant: "#42493f"

    property color tertiary: "#a0cfd3"
    property color tertiary_container: "#1e4d51"
    property color tertiary_fixed: "#bcebef"
    property color tertiary_fixed_dim: "#a0cfd3"


    /* UI Settings */

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 16


    /* UI Aliases (optional but useful) */

    property color bg: surface
    property color fg: on_surface
    property color muted: outline_variant
    property color accent: tertiary
}
