import QtQuick
import "../js/funcs.js" as Funcs
import "../lib" as Lib
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import org.kde.plasma.private.battery
import org.kde.ksvg 1.0 as KSvg
import Qt5Compat.GraphicalEffects

Item {

    property bool hasBattery: batteryControl.hasBatteries
    property bool batteryChargid: batteryControl.state === BatteryControlModel.Charging
    property int percent: !hasBattery ? 100: batteryControl.percent

    BatteryControlModel {
        id: batteryControl

        readonly property int remainingTime: batteryControl.smoothedRemainingMsec
        readonly property bool isSomehowFullyCharged: batteryControl.pluggedIn && batteryControl.state === BatteryControlModel.FullyCharged
    }

    function determineIcon(value) {
        var icon = "";
        if (value < 10) {
            icon = "battery-000";
        } else if (value < 20) {
            icon = "battery-010";
        } else if (value < 30) {
            icon = "battery-020";
        } else if (value < 40) {
            icon = "battery-030";
        } else if (value < 50) {
            icon = "battery-040";
        } else if (value < 60) {
            icon = "battery-050";
        } else if (value < 70) {
            icon = "battery-060";
        } else if (value < 80) {
            icon = "battery-070";
        } else if (value < 90) {
            icon = "battery-080";
        } else if (value < 100) {
            icon = "battery-090";
        } else {
            icon = "battery-100";
        }

        if (batteryChargid) {
            return icon + "-charging-symbolic"
        } else {
            return icon + "-symbolic"
        }

    }


    Lib.Card {
        width: parent.width
        height: parent.height

        Lib.HelperCard {
            id: mask
            isMask: true
            anchors.fill: parent
            visible: false
            customRadius: Plasmoid.configuration.radiusCardCustom
        }

        Item {
            id: maskSvg2
            width: parent.width
            height: parent.height
            visible: false
            Grid {
                width: parent.width
                height: parent.height
                columns: 3
                property var marg: topleft2.implicitWidth

                KSvg.SvgItem {
                    id: topleft2
                    imagePath: "dialogs/background"
                    elementId: "topleft"
                }
                KSvg.SvgItem {
                    id: top2
                    imagePath: "dialogs/background"
                    elementId: "top"
                    width: parent.width - topleft2.implicitWidth *2
                }
                KSvg.SvgItem {
                    id: topright
                    imagePath: "dialogs/background"
                    elementId: "topright"
                }

                KSvg.SvgItem {
                    id: left2
                    imagePath: "dialogs/background"
                    elementId: "left"
                    height: parent.height - topleft2.implicitHeight*2
                }
                KSvg.SvgItem {
                    imagePath: "dialogs/background"
                    elementId: "center"
                    height: parent.height - topleft2.implicitHeight*2
                    width: top2.width
                }
                KSvg.SvgItem {
                    id: right
                    imagePath: "dialogs/background"
                    elementId: "right"
                    height: left2.height
                }

                KSvg.SvgItem {
                    id: bottomleft2
                    imagePath: "dialogs/background"
                    elementId: "bottomleft"
                }
                KSvg.SvgItem {
                    id: bottom2
                    imagePath: "dialogs/background"
                    elementId: "bottom"
                    width: top2.width
                }
                KSvg.SvgItem {
                    id: bottomright
                    imagePath: "dialogs/background"
                    elementId: "bottomright"
                }
            }
        }
        Rectangle {
            width: parent.width
            height: parent.height
            color: "transparent"
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Plasmoid.configuration.usePlasmaDesing ? maskSvg2 : mask
            }



            Rectangle {
                id: progress
                width: parent.width
                height: parent.height * percent/100
                color: Kirigami.Theme.highlightColor //Kirigami.Theme.textColor
                anchors.bottom: parent.bottom
            }

        }

        Column {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Kirigami.Units.largeSpacing
            anchors.left: parent.left
            anchors.leftMargin: Kirigami.Units.largeSpacing
            Kirigami.Heading {
                text: percent + "%"
                font.weight: Font.DemiBold
                level: 1
            }
            Kirigami.Heading {
                text: textConstants.battery
                font.weight: Font.DemiBold
                level: 5
            }
        }
    }
}
