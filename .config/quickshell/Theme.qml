import QtQuick

QtObject {

    /* Matugen Palette */

    property color background: "#101418"

    property color error: "#ffb4ab"
    property color error_container: "#93000a"

    property color inverse_on_surface: "#2d3135"
    property color inverse_primary: "#34618e"
    property color inverse_surface: "#e1e2e8"

    property color on_background: "#e1e2e8"

    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"

    property color on_primary: "#003257"
    property color on_primary_container: "#d0e4ff"
    property color on_primary_fixed: "#001d35"
    property color on_primary_fixed_variant: "#174974"

    property color on_secondary: "#253140"
    property color on_secondary_container: "#d6e4f7"
    property color on_secondary_fixed: "#0f1c2b"
    property color on_secondary_fixed_variant: "#3b4857"

    property color on_surface: "#e1e2e8"
    property color on_surface_variant: "#c2c7cf"

    property color on_tertiary: "#3a2948"
    property color on_tertiary_container: "#f1daff"
    property color on_tertiary_fixed: "#241432"
    property color on_tertiary_fixed_variant: "#524060"

    property color outline: "#8c9199"
    property color outline_variant: "#42474e"

    property color primary: "#9fcafc"
    property color primary_container: "#174974"
    property color primary_fixed: "#d0e4ff"
    property color primary_fixed_dim: "#9fcafc"

    property color scrim: "#000000"

    property color secondary: "#bac8db"
    property color secondary_container: "#3b4857"
    property color secondary_fixed: "#d6e4f7"
    property color secondary_fixed_dim: "#bac8db"

    property color shadow: "#000000"

    property color source_color: "#556b85"

    property color surface: "#101418"
    property color surface_bright: "#36393e"
    property color surface_container: "#1d2024"
    property color surface_container_high: "#272a2f"
    property color surface_container_highest: "#32353a"
    property color surface_container_low: "#191c20"
    property color surface_container_lowest: "#0b0e13"
    property color surface_dim: "#101418"

    property color surface_tint: "#9fcafc"

    property color surface_variant: "#42474e"

    property color tertiary: "#d6bee5"
    property color tertiary_container: "#524060"
    property color tertiary_fixed: "#f1daff"
    property color tertiary_fixed_dim: "#d6bee5"


    /* UI Settings */

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 16


    /* UI Aliases (optional but useful) */

    property color bg: surface
    property color fg: on_surface
    property color muted: outline_variant
    property color accent: tertiary
}
