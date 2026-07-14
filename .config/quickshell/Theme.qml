import QtQuick

QtObject {

    /* Matugen Palette */

    property color background: "#131318"

    property color error: "#ffb4ab"
    property color error_container: "#93000a"

    property color inverse_on_surface: "#313036"
    property color inverse_primary: "#5b5891"
    property color inverse_surface: "#e5e1e9"

    property color on_background: "#e5e1e9"

    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"

    property color on_primary: "#2d2960"
    property color on_primary_container: "#e3dfff"
    property color on_primary_fixed: "#18124a"
    property color on_primary_fixed_variant: "#444078"

    property color on_secondary: "#302e42"
    property color on_secondary_container: "#e4dff9"
    property color on_secondary_fixed: "#1b1a2c"
    property color on_secondary_fixed_variant: "#464559"

    property color on_surface: "#e5e1e9"
    property color on_surface_variant: "#c8c5d0"

    property color on_tertiary: "#472538"
    property color on_tertiary_container: "#ffd8e9"
    property color on_tertiary_fixed: "#2f1123"
    property color on_tertiary_fixed_variant: "#603b4f"

    property color outline: "#928f99"
    property color outline_variant: "#47464f"

    property color primary: "#c5c0ff"
    property color primary_container: "#444078"
    property color primary_fixed: "#e3dfff"
    property color primary_fixed_dim: "#c5c0ff"

    property color scrim: "#000000"

    property color secondary: "#c7c4dc"
    property color secondary_container: "#464559"
    property color secondary_fixed: "#e4dff9"
    property color secondary_fixed_dim: "#c7c4dc"

    property color shadow: "#000000"

    property color source_color: "#4233bf"

    property color surface: "#131318"
    property color surface_bright: "#3a383f"
    property color surface_container: "#201f25"
    property color surface_container_high: "#2a292f"
    property color surface_container_highest: "#35343a"
    property color surface_container_low: "#1c1b20"
    property color surface_container_lowest: "#0e0e13"
    property color surface_dim: "#131318"

    property color surface_tint: "#c5c0ff"

    property color surface_variant: "#47464f"

    property color tertiary: "#ebb9d0"
    property color tertiary_container: "#603b4f"
    property color tertiary_fixed: "#ffd8e9"
    property color tertiary_fixed_dim: "#ebb9d0"


    /* UI Settings */

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 16


    /* UI Aliases (optional but useful) */

    property color bg: surface
    property color fg: on_surface
    property color muted: outline_variant
    property color accent: tertiary
}
