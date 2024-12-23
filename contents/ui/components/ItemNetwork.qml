import QtQuick
import "../lib" as Lib

Item {
    SourceNetwork {
        id: network
    }
     Lib.Item {
         width: parent.width
         height: parent.height
         activeSub: true
         smallMode: false
         title: i18n("Network")
         sub: network.textConnetion
         itemIcon: network.icon
     }
}
