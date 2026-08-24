import QtQuick

QtObject {

    /* Matugen Palette */

    property color background: "#181115"

    property color error: "#ffb4ab"
    property color error_container: "#93000a"

    property color inverse_on_surface: "#372e32"
    property color inverse_primary: "#884b6b"
    property color inverse_surface: "#eedfe3"

    property color on_background: "#eedfe3"

    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"

    property color on_primary: "#521d3c"
    property color on_primary_container: "#ffd8e9"
    property color on_primary_fixed: "#380726"
    property color on_primary_fixed_variant: "#6c3453"

    property color on_secondary: "#402a35"
    property color on_secondary_container: "#fdd9e8"
    property color on_secondary_fixed: "#291520"
    property color on_secondary_fixed_variant: "#58404b"

    property color on_surface: "#eedfe3"
    property color on_surface_variant: "#d4c2c8"

    property color on_tertiary: "#4a2811"
    property color on_tertiary_container: "#ffdbc9"
    property color on_tertiary_fixed: "#311302"
    property color on_tertiary_fixed_variant: "#643d25"

    property color outline: "#9c8d92"
    property color outline_variant: "#504349"

    property color primary: "#fcb0d6"
    property color primary_container: "#6c3453"
    property color primary_fixed: "#ffd8e9"
    property color primary_fixed_dim: "#fcb0d6"

    property color scrim: "#000000"

    property color secondary: "#dfbdcc"
    property color secondary_container: "#58404b"
    property color secondary_fixed: "#fdd9e8"
    property color secondary_fixed_dim: "#dfbdcc"

    property color shadow: "#000000"

    property color source_color: "#e13ca5"

    property color surface: "#181115"
    property color surface_bright: "#40373a"
    property color surface_container: "#251d21"
    property color surface_container_high: "#30282b"
    property color surface_container_highest: "#3b3236"
    property color surface_container_low: "#21191d"
    property color surface_container_lowest: "#130c0f"
    property color surface_dim: "#181115"

    property color surface_tint: "#fcb0d6"

    property color surface_variant: "#504349"

    property color tertiary: "#f3ba9b"
    property color tertiary_container: "#643d25"
    property color tertiary_fixed: "#ffdbc9"
    property color tertiary_fixed_dim: "#f3ba9b"


    /* UI Settings */

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 16


    /* UI Aliases (optional but useful) */

    property color bg: surface
    property color fg: on_surface
    property color muted: outline_variant
    property color accent: tertiary
}
