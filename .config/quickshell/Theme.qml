import QtQuick

QtObject {

    /* Matugen Palette */

    property color background: "#191114"

    property color error: "#ffb4ab"
    property color error_container: "#93000a"

    property color inverse_on_surface: "#372e30"
    property color inverse_primary: "#8b4a61"
    property color inverse_surface: "#efdfe2"

    property color on_background: "#efdfe2"

    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"

    property color on_primary: "#541d33"
    property color on_primary_container: "#ffd9e3"
    property color on_primary_fixed: "#3a071e"
    property color on_primary_fixed_variant: "#6f334a"

    property color on_secondary: "#422931"
    property color on_secondary_container: "#ffd9e3"
    property color on_secondary_fixed: "#2b151d"
    property color on_secondary_fixed_variant: "#5a3f48"

    property color on_surface: "#efdfe2"
    property color on_surface_variant: "#d5c2c6"

    property color on_tertiary: "#48290c"
    property color on_tertiary_container: "#ffdcc2"
    property color on_tertiary_fixed: "#2e1500"
    property color on_tertiary_fixed_variant: "#623f20"

    property color outline: "#9e8c90"
    property color outline_variant: "#514347"

    property color primary: "#ffb0ca"
    property color primary_container: "#6f334a"
    property color primary_fixed: "#ffd9e3"
    property color primary_fixed_dim: "#ffb0ca"

    property color scrim: "#000000"

    property color secondary: "#e2bdc7"
    property color secondary_container: "#5a3f48"
    property color secondary_fixed: "#ffd9e3"
    property color secondary_fixed_dim: "#e2bdc7"

    property color shadow: "#000000"

    property color source_color: "#ed629a"

    property color surface: "#191114"
    property color surface_bright: "#403739"
    property color surface_container: "#261d20"
    property color surface_container_high: "#31282a"
    property color surface_container_highest: "#3c3235"
    property color surface_container_low: "#22191c"
    property color surface_container_lowest: "#140c0e"
    property color surface_dim: "#191114"

    property color surface_tint: "#ffb0ca"

    property color surface_variant: "#514347"

    property color tertiary: "#efbc94"
    property color tertiary_container: "#623f20"
    property color tertiary_fixed: "#ffdcc2"
    property color tertiary_fixed_dim: "#efbc94"


    /* UI Settings */

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 16


    /* UI Aliases (optional but useful) */

    property color bg: surface
    property color fg: on_surface
    property color muted: outline_variant
    property color accent: tertiary
}
