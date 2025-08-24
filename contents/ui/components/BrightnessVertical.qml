import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
//import org.kde.kcmutils // KCMLauncher
//import org.kde.plasma.components 3.0 as PlasmaComponents
import "../lib" as Lib
import org.kde.ksvg 1.0 as KSvg
import org.kde.ksysguard.sensors as Sensors
import Qt5Compat.GraphicalEffects

Item {
    property bool mouseAreaActive:  false

    property string code: ""
    property var control

    property string sourceBrightnessPlasma64orPlusQml: `
    import QtQuick
    SourceBrightnessPlasma64orPlus {
        id: dynamic
    }
    `
    property string sourceBrightnessQML: `
    import QtQuick
    SourceBrightness {
        id: dynamic
    }
    `

    Sensors.SensorDataModel {
        id: plasmaVersionModel
        sensors: ["os/plasma/plasmaVersion"]
        enabled: true

        onDataChanged: {
            const value = data(index(0, 0), Sensors.SensorDataModel.Value);
            if (value !== undefined && value !== null) {
                if (value.indexOf("6.4") >= 0) {
                    code = sourceBrightnessPlasma64orPlusQml;
                } else {
                    code = sourceBrightnessQML;
                }

                // Crea el nuevo componente
                control = Qt.createQmlObject(code, root, "control");
            }
        }
    }

    Lib.Card {
        width: parent.width
        height: parent.height

        property real valueBrightness: control.valueSlider/100
        SourceVolume {
            id: vol
        }

        Lib.HelperCard {
            id: mask
            isMask: true
            anchors.fill: parent
            visible: false
            customRadius: Plasmoid.configuration.radiusCardCustom
        }
        //property int value: vol.value/100 // Valor inicial (50%)

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
                height: parent.height * control.valueSlider/100
                color: Kirigami.Theme.highlightColor //Kirigami.Theme.textColor
                anchors.bottom: parent.bottom
            }

            MouseArea {
                id: mouseArea
                enabled: mouseAreaActive
                width: parent.width
                height: parent.height
                anchors.centerIn: parent

                function updateValue(w,y) {
                    var valueSlider = ((w-y)/w)*100
                    control.realValueSlider = valueSlider
                    valueBrightness = valueSlider/100

                }
                onPressed: updateValue(parent.height,mouse.y)
                onPositionChanged: {
                    if (pressed) {
                        updateValue(parent.height,mouse.y)
                    }
                }
            }
        }

        Kirigami.Icon {
            id: iconVolume
            width: Kirigami.Units.iconSizes.mediumSmall
            height: width
            color: Kirigami.Theme.textColor
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Kirigami.Units.largeSpacing
            source: "brightness-high-symbolic"
        }

    }

}
