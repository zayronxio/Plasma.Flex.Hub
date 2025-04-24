import QtQuick
import "../lib" as Lib

Item {
    property bool mouseAreaActive:  false

    Lib.Card {
        width: parent.width
        height: parent.height

        property bool mouseAreaActive:  parent.mouseAreaActive

        ItemBluetooth {
            id: source
            width: parent.width
            height: parent.height
        }
    }
}
