import QtQuick

QtObject {

    /* Matugen Palette */

    property color background: "#1a1110"

    property color error: "#ffb4ab"
    property color error_container: "#93000a"

    property color inverse_on_surface: "#392e2c"
    property color inverse_primary: "#904a41"
    property color inverse_surface: "#f1dedc"

    property color on_background: "#f1dedc"

    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"

    property color on_primary: "#561e18"
    property color on_primary_container: "#ffdad5"
    property color on_primary_fixed: "#3b0906"
    property color on_primary_fixed_variant: "#73342c"

    property color on_secondary: "#442926"
    property color on_secondary_container: "#ffdad5"
    property color on_secondary_fixed: "#2c1512"
    property color on_secondary_fixed_variant: "#5d3f3b"

    property color on_surface: "#f1dedc"
    property color on_surface_variant: "#d8c2be"

    property color on_tertiary: "#3e2e04"
    property color on_tertiary_container: "#fcdfa6"
    property color on_tertiary_fixed: "#251a00"
    property color on_tertiary_fixed_variant: "#574419"

    property color outline: "#a08c89"
    property color outline_variant: "#534341"

    property color primary: "#ffb4a9"
    property color primary_container: "#73342c"
    property color primary_fixed: "#ffdad5"
    property color primary_fixed_dim: "#ffb4a9"

    property color scrim: "#000000"

    property color secondary: "#e7bdb7"
    property color secondary_container: "#5d3f3b"
    property color secondary_fixed: "#ffdad5"
    property color secondary_fixed_dim: "#e7bdb7"

    property color shadow: "#000000"

    property color source_color: "#d81514"

    property color surface: "#1a1110"
    property color surface_bright: "#423735"
    property color surface_container: "#271d1c"
    property color surface_container_high: "#322826"
    property color surface_container_highest: "#3d3231"
    property color surface_container_low: "#231918"
    property color surface_container_lowest: "#140c0b"
    property color surface_dim: "#1a1110"

    property color surface_tint: "#ffb4a9"

    property color surface_variant: "#534341"

    property color tertiary: "#dfc38c"
    property color tertiary_container: "#574419"
    property color tertiary_fixed: "#fcdfa6"
    property color tertiary_fixed_dim: "#dfc38c"


    /* UI Settings */

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 16


    /* UI Aliases (optional but useful) */

    property color bg: surface
    property color fg: on_surface
    property color muted: outline_variant
    property color accent: tertiary
}
