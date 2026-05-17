//@ pragma IconTheme Adwaita

import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "."
import "modules"
import "widgets"
import "services" as Services

ShellRoot {
  id: root

  Theme { id: systemTheme }

  Variants {
    model: Quickshell.screens
    delegate: Bar {
      // Pass the screen and theme into each instance
      screen: modelData 
      theme: systemTheme
    }
  }

  // Variants {
  //   model: Quickshell.screens
  //   delegate: Dock {
  //     screen: modelData
  //     theme: systemTheme
  //   }
  // }

  Wallpaper {
    id: wallpaper
    theme: systemTheme
  }

  IpcHandler {
    target: "wallpaper"

    function open() {
      wallpaper.visible = true
    }

    function close() {
      wallpaper.visible = false
    }

    function toggle() {
      wallpaper.visible = !wallpaper.visible
    }
  }

  // Screenshot {
  //   id: screenshot
  //   theme: systemTheme
  // }

  // IpcHandler {
  //   target: "screenshot"

  //   function open() {
  //     screenshot.visible = true
  //   }

  //   function close() {
  //     screenshot.visible = false
  //   }

  //   function toggle() {
  //     screenshot.visible = !screenshot.visible
  //   }
  // }

  NetworkManager {
    id: networkManager
    theme: systemTheme
  }

  IpcHandler {
    target: "network"

    function open() {
      networkManager.visible = true
    }

    function close() {
      networkManager.visible = false
    }

    function toggle() {
      networkManager.visible = !networkManager.visible
    }
  }

  BluetoothManager {
    id: bluetoothManager
    theme: systemTheme
  }

  IpcHandler {
    target: "bluetooth"

    function open() {
      bluetoothManager.visible = true
    }

    function close() {
      bluetoothManager.visible = false
    }

    function toggle() {
      bluetoothManager.visible = !bluetoothManager.visible
    }
  }

  Magic8Ball {
    id: magic8Ball
  }

  IpcHandler {
    target: "8ball"

    function open() {
      magic8Ball.visible = true
    }

    function close() {
      magic8Ball.visible = false
    }

    function toggle() {
      magic8Ball.visible = !magic8Ball.visible
      magic8Ball.dragging = true
    }
  }
}
