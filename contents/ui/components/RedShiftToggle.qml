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

        Lib.MiniButton {
            width: parent.width
            height: parent.height
            title: !nightLight ? "On" : "Off"
            itemIcon: nightLight ? "redshift-status-on" : "redshift-status-off"
            onIconClicked: {
                Plasmoid.configuration.nightMode = !nightLight
                control.nightMode()
            }
        }
    }
}
