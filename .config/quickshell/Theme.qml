import QtQuick

QtObject {

    /* Matugen Palette */

    property color background: "#1a120e"

    property color error: "#ffb4ab"
    property color error_container: "#93000a"

    property color inverse_on_surface: "#382e2a"
    property color inverse_primary: "#8d4e2b"
    property color inverse_surface: "#f0dfd8"

    property color on_background: "#f0dfd8"

    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"

    property color on_primary: "#542103"
    property color on_primary_container: "#ffdbcb"
    property color on_primary_fixed: "#341100"
    property color on_primary_fixed_variant: "#703716"

    property color on_secondary: "#432b1e"
    property color on_secondary_container: "#ffdbcb"
    property color on_secondary_fixed: "#2b160b"
    property color on_secondary_fixed_variant: "#5c4033"

    property color on_surface: "#f0dfd8"
    property color on_surface_variant: "#d7c2b9"

    property color on_tertiary: "#353107"
    property color on_tertiary_container: "#ece4aa"
    property color on_tertiary_fixed: "#1f1c00"
    property color on_tertiary_fixed_variant: "#4c481c"

    property color outline: "#a08d85"
    property color outline_variant: "#52443d"

    property color primary: "#ffb691"
    property color primary_container: "#703716"
    property color primary_fixed: "#ffdbcb"
    property color primary_fixed_dim: "#ffb691"

    property color scrim: "#000000"

    property color secondary: "#e6beac"
    property color secondary_container: "#5c4033"
    property color secondary_fixed: "#ffdbcb"
    property color secondary_fixed_dim: "#e6beac"

    property color shadow: "#000000"

    property color source_color: "#ea9467"

    property color surface: "#1a120e"
    property color surface_bright: "#423732"
    property color surface_container: "#271e19"
    property color surface_container_high: "#322823"
    property color surface_container_highest: "#3d332e"
    property color surface_container_low: "#221a16"
    property color surface_container_lowest: "#140c09"
    property color surface_dim: "#1a120e"

    property color surface_tint: "#ffb691"

    property color surface_variant: "#52443d"

    property color tertiary: "#cfc890"
    property color tertiary_container: "#4c481c"
    property color tertiary_fixed: "#ece4aa"
    property color tertiary_fixed_dim: "#cfc890"


    /* UI Settings */

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 16


    /* UI Aliases (optional but useful) */

    property color bg: surface
    property color fg: on_surface
    property color muted: outline_variant
    property color accent: tertiary
}
