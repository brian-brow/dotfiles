import QtQuick

QtObject {

    /* Matugen Palette */

    property color background: "#0e1514"

    property color error: "#ffb4ab"
    property color error_container: "#93000a"

    property color inverse_on_surface: "#2b3231"
    property color inverse_primary: "#006a68"
    property color inverse_surface: "#dde4e3"

    property color on_background: "#dde4e3"

    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"

    property color on_primary: "#003736"
    property color on_primary_container: "#9cf1ee"
    property color on_primary_fixed: "#00201f"
    property color on_primary_fixed_variant: "#00504e"

    property color on_secondary: "#1b3534"
    property color on_secondary_container: "#cce8e6"
    property color on_secondary_fixed: "#051f1f"
    property color on_secondary_fixed_variant: "#324b4a"

    property color on_surface: "#dde4e3"
    property color on_surface_variant: "#bec9c7"

    property color on_tertiary: "#1b324b"
    property color on_tertiary_container: "#d2e4ff"
    property color on_tertiary_fixed: "#031c35"
    property color on_tertiary_fixed_variant: "#324863"

    property color outline: "#889392"
    property color outline_variant: "#3f4948"

    property color primary: "#80d5d2"
    property color primary_container: "#00504e"
    property color primary_fixed: "#9cf1ee"
    property color primary_fixed_dim: "#80d5d2"

    property color scrim: "#000000"

    property color secondary: "#b0ccca"
    property color secondary_container: "#324b4a"
    property color secondary_fixed: "#cce8e6"
    property color secondary_fixed_dim: "#b0ccca"

    property color shadow: "#000000"

    property color source_color: "#6d7e7d"

    property color surface: "#0e1514"
    property color surface_bright: "#343a3a"
    property color surface_container: "#1a2120"
    property color surface_container_high: "#252b2b"
    property color surface_container_highest: "#2f3636"
    property color surface_container_low: "#161d1c"
    property color surface_container_lowest: "#090f0f"
    property color surface_dim: "#0e1514"

    property color surface_tint: "#80d5d2"

    property color surface_variant: "#3f4948"

    property color tertiary: "#b2c8e8"
    property color tertiary_container: "#324863"
    property color tertiary_fixed: "#d2e4ff"
    property color tertiary_fixed_dim: "#b2c8e8"


    /* UI Settings */

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 16


    /* UI Aliases (optional but useful) */

    property color bg: surface
    property color fg: on_surface
    property color muted: outline_variant
    property color accent: tertiary
}
