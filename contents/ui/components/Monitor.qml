import QtQuick
import "../lib" as Lib

Item {
    Lib.Card {
        width: parent.width
        height: parent.height
        Column {
            width: parent.width
            height: parent.height
            MN_ram {
                id: ram
                height: parent.height/3
            }
            MN_cpu {
                id: cpu
                height: parent.height/3
            }
            MN_network {
                id: network
                height: parent.height/3
            }
        }

    }
}
