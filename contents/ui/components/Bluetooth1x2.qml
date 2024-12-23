import QtQuick
import "../lib" as Lib

Item {
     Lib.Card {
         width: parent.width
         height: parent.height
         ItemBluetooth {
             id: source
             width: parent.width
             height: parent.height
             //anchors.verticalCenter: parent.verticalCenter
        }
    }
}
