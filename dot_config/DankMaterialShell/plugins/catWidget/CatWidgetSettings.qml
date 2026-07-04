import QtQuick
import qs.Common
import qs.Modules.Plugins
import qs.Widgets

PluginSettings {
    id: root
    pluginId: "catWidget"

    SliderSetting {
        settingKey: "catSize"
        label: "Cat Size"
        description: "Size of the cat sprite in the bar"
        defaultValue: 24
        minimum: 12
        maximum: 48
        unit: "px"
    }

    SliderSetting {
        settingKey: "idleThreshold"
        label: "Idle Threshold"
        description: "CPU % below which the cat sleeps (0 = never sleep)"
        defaultValue: 15
        minimum: 0
        maximum: 50
        unit: "%"
    }

    SliderSetting {
        settingKey: "updateInterval"
        label: "CPU Poll Interval"
        description: "How often to read CPU usage"
        defaultValue: 2
        minimum: 1
        maximum: 10
        unit: "sec"
    }

    ToggleSetting {
        settingKey: "showCpuPercent"
        label: "Show CPU %"
        description: "Display CPU usage next to the cat"
        defaultValue: false
    }
}
