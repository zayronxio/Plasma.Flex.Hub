import QtQuick
import "../lib" as Lib

Item {

    property bool mouseAreaActive:  false

    Lib.Card {
        width: parent.width
        height: parent.height

        Lib.MiniButton {
            width: parent.width
            height: parent.height
            bashExe: true
            cmd: "spectacle -b"
            title: i18n("Screenshot")
            itemIcon: "camera-photo-symbolic"
        }
    }
}
