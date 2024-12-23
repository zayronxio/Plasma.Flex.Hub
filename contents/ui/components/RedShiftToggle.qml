import QtQuick
import QtCore
import org.kde.kirigami as Kirigami
import org.kde.plasma.private.brightnesscontrolplugin
import "../js/funcs.js" as Funcs
import "../lib" as Lib

Item {

    Settings {
        id: plasmaHubNightLightControl
        category: "NightLightControl"
        // property var files: []
    }
    NightLightControl {
        id: control

        readonly property bool transitioning: control.currentTemperature != control.targetTemperature
        readonly property bool hasSwitchingTimes: control.mode != 3
        readonly property bool togglable: nightLight || !control.inhibited || control.inhibitedFromApplet

    }

     property bool nightLight: plasmaHubNightLightControl.value("toggleInhibition") !== undefined ? typeof plasmaHubNightLightControl.value("toggleInhibition") !== "boolean" ? plasmaHubNightLightControl.value("toggleInhibition") === "true" ? true : (false) : plasmaHubNightLightControl.value("toggleInhibition") : false
    Lib.Card {
        width: parent.width
        height:parent.height

        Column {
            width: parent.width
            height: parent.height
            Item {
                width: parent.width
                height: parent.height*.6
                Kirigami.Icon {
                    id: iconOfRedshift
                    implicitHeight: parent.height*.9

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: nightLight ? "redshift-status-on" : "redshift-status-off"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            control.toggleInhibition()
                            plasmaHubNightLightControl.setValue("toggleInhibition", !nightLight)
                            nightLight = plasmaHubNightLightControl.value("toggleInhibition") !== undefined ? typeof plasmaHubNightLightControl.value("toggleInhibition") !== "boolean" ? plasmaHubNightLightControl.value("toggleInhibition") === "true" ? true : (false) : plasmaHubNightLightControl.value("toggleInhibition") : false
                        }
                    }
                }
            }
            Item {
                id: labelredfish
                width: parent.width
                height: parent.height*.4
                Kirigami.Heading {
                    id: textOfNightLight
                    width: parent.width
                    text: nightLight ? "On" : "Off"
                    //font.pixelSize: labelredfish.height*.35
                    level: 5
                    horizontalAlignment: Text.AlignHCenter
                }
            }



        }
    }
}
