import QtQuick

QtObject {

    /* Matugen Palette */

    property color background: "#101418"

    property color error: "#ffb4ab"
    property color error_container: "#93000a"

    property color inverse_on_surface: "#2d3135"
    property color inverse_primary: "#31628d"
    property color inverse_surface: "#e0e2e8"

    property color on_background: "#e0e2e8"

    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"

    property color on_primary: "#003354"
    property color on_primary_container: "#cfe5ff"
    property color on_primary_fixed: "#001d33"
    property color on_primary_fixed_variant: "#114a73"

    property color on_secondary: "#243240"
    property color on_secondary_container: "#d5e4f7"
    property color on_secondary_fixed: "#0e1d2a"
    property color on_secondary_fixed_variant: "#3a4857"

    property color on_surface: "#e0e2e8"
    property color on_surface_variant: "#c2c7cf"

    property color on_tertiary: "#392a49"
    property color on_tertiary_container: "#efdbff"
    property color on_tertiary_fixed: "#231533"
    property color on_tertiary_fixed_variant: "#504060"

    property color outline: "#8c9199"
    property color outline_variant: "#42474e"

    property color primary: "#9ccbfb"
    property color primary_container: "#114a73"
    property color primary_fixed: "#cfe5ff"
    property color primary_fixed_dim: "#9ccbfb"

    property color scrim: "#000000"

    property color secondary: "#b9c8da"
    property color secondary_container: "#3a4857"
    property color secondary_fixed: "#d5e4f7"
    property color secondary_fixed_dim: "#b9c8da"

    property color shadow: "#000000"

    property color source_color: "#436688"

    property color surface: "#101418"
    property color surface_bright: "#36393e"
    property color surface_container: "#1c2024"
    property color surface_container_high: "#272a2f"
    property color surface_container_highest: "#32353a"
    property color surface_container_low: "#181c20"
    property color surface_container_lowest: "#0b0e12"
    property color surface_dim: "#101418"

    property color surface_tint: "#9ccbfb"

    property color surface_variant: "#42474e"

    property color tertiary: "#d4bee6"
    property color tertiary_container: "#504060"
    property color tertiary_fixed: "#efdbff"
    property color tertiary_fixed_dim: "#d4bee6"


    /* UI Settings */

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 16


    /* UI Aliases (optional but useful) */

    property color bg: surface
    property color fg: on_surface
    property color muted: outline_variant
    property color accent: tertiary
}
