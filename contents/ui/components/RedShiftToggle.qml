import QtQuick
import "../lib" as Lib
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
//import org.kde.plasma.private.brightnesscontrolplugin

Item {
    property bool mouseAreaActive:  false
    property bool nightLight: Plasmoid.configuration.nightMode

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
                        enabled: mouseAreaActive
                        anchors.fill: parent
                        onClicked: {
                            Plasmoid.configuration.nightMode = !nightLight
                            control.nightMode()
                            //nightLight = Plasmoid.configuration.nightMode
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
                    text: !nightLight ? "On" : "Off"
                    //font.pixelSize: labelredfish.height*.35
                    level: 5
                    horizontalAlignment: Text.AlignHCenter
                }
            }



        }
    }
    Timer {
        interval: 500
        running:  true
        repeat:  false
        onTriggered: {
            if (nightLight) {
                control.nightMode()
            }
        }
    }
}
