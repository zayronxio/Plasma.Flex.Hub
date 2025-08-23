import QtQuick
import "../lib" as Lib
import org.kde.kirigami as Kirigami
//import "../pages/ForceQuit.qml" as fq

Item {
    property bool mouseAreaActive:  false
    Lib.Card {
        width: parent.width
        height: parent.height
        //enabledColor: true
        //elementBackgroundColor: Kirigami.Theme.negativeTextColor

        Lib.MiniButton {
            width: parent.width
            height: parent.height
            title: i18n("Force Quit")
            itemIcon: "application-exit"
            onIconClicked: {
                page = Qt.resolvedUrl("../pages/ForceQuit.qml")
            }
        }

    }
}
