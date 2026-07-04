import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    property real cpuUsage: 0.0
    property string prevIdle: ""
    property string prevTotal: ""

    property real catSize: pluginData.catSize ?? 24
    property bool showCpuPercent: pluginData.showCpuPercent ?? false
    property int idleThreshold: pluginData.idleThreshold ?? 15
    property int updateInterval: (pluginData.updateInterval ?? 2) * 1000

    property int frameCount: 5
    property int currentFrame: 0
    property int frameDuration: Math.max(30, Math.ceil(5000 / Math.sqrt(cpuUsage + 35) - 400))

    property string spriteBase: Qt.resolvedUrl("./assets/")
    property string currentSprite: cpuUsage < idleThreshold
        ? spriteBase + "cat-idle.svg"
        : spriteBase + "cat-active-" + currentFrame + ".svg"

    Process {
        id: cpuProcess
        command: ["sh", "-c", "head -1 /proc/stat"]
        running: false

        stdout: SplitParser {
            onRead: function(line) {
                var parts = line.trim().split(/\s+/);
                if (parts.length < 5 || parts[0] !== "cpu") return;

                var user = parseInt(parts[1]) || 0;
                var nice = parseInt(parts[2]) || 0;
                var system = parseInt(parts[3]) || 0;
                var idle = parseInt(parts[4]) || 0;
                var iowait = parseInt(parts[5]) || 0;
                var irq = parseInt(parts[6]) || 0;
                var softirq = parseInt(parts[7]) || 0;
                var steal = parseInt(parts[8]) || 0;

                var totalIdle = idle + iowait;
                var total = user + nice + system + idle + iowait + irq + softirq + steal;

                if (root.prevTotal !== "") {
                    var diffIdle = totalIdle - parseInt(root.prevIdle);
                    var diffTotal = total - parseInt(root.prevTotal);
                    if (diffTotal > 0) {
                        root.cpuUsage = Math.round(((diffTotal - diffIdle) / diffTotal) * 100);
                    }
                }

                root.prevIdle = totalIdle.toString();
                root.prevTotal = total.toString();
            }
        }
    }

    Timer {
        id: cpuTimer
        interval: root.updateInterval
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: cpuProcess.running = true
    }

    Timer {
        id: animTimer
        interval: root.frameDuration
        running: true
        repeat: true
        onTriggered: root.currentFrame = (root.currentFrame + 1) % root.frameCount
    }

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingS

            Image {
                source: root.currentSprite
                sourceSize.width: root.catSize
                sourceSize.height: root.catSize
                width: root.catSize
                height: root.catSize
                fillMode: Image.PreserveAspectFit
                smooth: true
                layer.enabled: true
                layer.effect: MultiEffect {
                    colorization: 1
                    colorizationColor: Theme.surfaceText
                }
                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                visible: root.showCpuPercent
                text: Math.round(root.cpuUsage) + "%"
                font.pixelSize: Theme.fontSizeSmall
                color: root.cpuUsage > 80 ? Theme.error
                     : root.cpuUsage > 50 ? Theme.warning
                     : Theme.surfaceText
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: Theme.spacingXXS

            Image {
                source: root.currentSprite
                sourceSize.width: root.catSize
                sourceSize.height: root.catSize
                width: root.catSize
                height: root.catSize
                fillMode: Image.PreserveAspectFit
                smooth: true
                layer.enabled: true
                layer.effect: MultiEffect {
                    colorization: 1
                    colorizationColor: Theme.surfaceText
                }
                anchors.horizontalCenter: parent.horizontalCenter
            }

            StyledText {
                visible: root.showCpuPercent
                text: Math.round(root.cpuUsage) + "%"
                font.pixelSize: Theme.fontSizeSmall
                color: root.cpuUsage > 80 ? Theme.error
                     : root.cpuUsage > 50 ? Theme.warning
                     : Theme.surfaceText
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    popoutContent: Component {
        PopoutComponent {
            headerText: "Cat Monitor"
            detailsText: "CPU: " + Math.round(root.cpuUsage) + "%"
            showCloseButton: true

            Item {
                width: parent.width
                implicitHeight: popoutColumn.implicitHeight

                Column {
                    id: popoutColumn
                    width: parent.width
                    spacing: Theme.spacingM

                    Rectangle {
                        width: parent.width
                        height: 120
                        radius: Theme.cornerRadius
                        color: Theme.surfaceContainerHigh

                        Image {
                            anchors.centerIn: parent
                            source: root.currentSprite
                            sourceSize.width: 96
                            sourceSize.height: 96
                            width: 96
                            height: 96
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                colorization: 1
                                colorizationColor: Theme.surfaceText
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingXS

                        Row {
                            width: parent.width

                            StyledText {
                                id: cpuLabel
                                text: "CPU Usage"
                                font.pixelSize: Theme.fontSizeMedium
                                color: Theme.surfaceText
                            }

                            Item { width: parent.width - cpuLabel.width - cpuValue.width; height: 1 }

                            StyledText {
                                id: cpuValue
                                text: Math.round(root.cpuUsage) + "%"
                                font.pixelSize: Theme.fontSizeMedium
                                color: root.cpuUsage > 80 ? Theme.error
                                     : root.cpuUsage > 50 ? Theme.warning
                                     : Theme.success
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 8
                            radius: 4
                            color: Theme.surfaceContainer

                            Rectangle {
                                width: parent.width * (root.cpuUsage / 100)
                                height: parent.height
                                radius: 4
                                color: root.cpuUsage > 80 ? Theme.error
                                     : root.cpuUsage > 50 ? Theme.warning
                                     : Theme.success

                                Behavior on width {
                                    NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
                                }
                            }
                        }
                    }

                    Row {
                        spacing: Theme.spacingS

                        DankIcon {
                            name: "speed"
                            size: Theme.iconSize
                            color: Theme.surfaceVariantText
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: {
                                if (root.cpuUsage < root.idleThreshold) return "Cat is sleeping...";
                                if (root.cpuUsage < 15) return "Cat is strolling";
                                if (root.cpuUsage < 40) return "Cat is walking";
                                if (root.cpuUsage < 70) return "Cat is trotting";
                                if (root.cpuUsage < 90) return "Cat is running!";
                                return "Cat is ZOOMING!!";
                            }
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }
    }

    popoutWidth: 320
    popoutHeight: 300
}
