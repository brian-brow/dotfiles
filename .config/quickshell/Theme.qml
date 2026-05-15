import QtQuick

QtObject {

    /* Matugen Palette */

    property color background: "#1a1111"

    property color error: "#ffb4ab"
    property color error_container: "#93000a"

    property color inverse_on_surface: "#382e2e"
    property color inverse_primary: "#8f4a4e"
    property color inverse_surface: "#f0dede"

    property color on_background: "#f0dede"

    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"

    property color on_primary: "#561d23"
    property color on_primary_container: "#ffdada"
    property color on_primary_fixed: "#3b080f"
    property color on_primary_fixed_variant: "#723338"

    property color on_secondary: "#44292a"
    property color on_secondary_container: "#ffdada"
    property color on_secondary_fixed: "#2c1516"
    property color on_secondary_fixed_variant: "#5d3f40"

    property color on_surface: "#f0dede"
    property color on_surface_variant: "#d7c1c1"

    property color on_tertiary: "#432c06"
    property color on_tertiary_container: "#ffddb2"
    property color on_tertiary_fixed: "#291800"
    property color on_tertiary_fixed_variant: "#5c421a"

    property color outline: "#9f8c8c"
    property color outline_variant: "#524343"

    property color primary: "#ffb3b6"
    property color primary_container: "#723338"
    property color primary_fixed: "#ffdada"
    property color primary_fixed_dim: "#ffb3b6"

    property color scrim: "#000000"

    property color secondary: "#e6bdbd"
    property color secondary_container: "#5d3f40"
    property color secondary_fixed: "#ffdada"
    property color secondary_fixed_dim: "#e6bdbd"

    property color shadow: "#000000"

    property color source_color: "#f6204f"

    property color surface: "#1a1111"
    property color surface_bright: "#413737"
    property color surface_container: "#271d1e"
    property color surface_container_high: "#322828"
    property color surface_container_highest: "#3d3232"
    property color surface_container_low: "#22191a"
    property color surface_container_lowest: "#140c0c"
    property color surface_dim: "#1a1111"

    property color surface_tint: "#ffb3b6"

    property color surface_variant: "#524343"

    property color tertiary: "#e6c08d"
    property color tertiary_container: "#5c421a"
    property color tertiary_fixed: "#ffddb2"
    property color tertiary_fixed_dim: "#e6c08d"


    /* UI Settings */

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 16


    /* UI Aliases (optional but useful) */

    property color bg: surface
    property color fg: on_surface
    property color muted: outline_variant
    property color accent: tertiary
}
