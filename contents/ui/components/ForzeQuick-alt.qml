import QtQuick
import QtQuick
import "../lib" as Lib
import org.kde.kirigami as Kirigami

Item {

    property bool mouseAreaActive:  false

    Lib.Card {
        width: parent.width
        height: parent.height
        enabledColor: true
        elementBackgroundColor: Kirigami.Theme.negativeTextColor
        backgroundColorOpacity: 1


        Kirigami.Icon {
            id: iconVolume
            width: Kirigami.Units.iconSizes.mediumSmall
            height: width
            color: "white"
            anchors.centerIn: parent
            source: "application-exit-symbolic"
        }

        MouseArea {
            anchors.fill: parent
            enabled: mouseAreaActive
            onClicked: {
                page = Qt.resolvedUrl("../pages/ForceQuit.qml")
            }
        }
    }

}
