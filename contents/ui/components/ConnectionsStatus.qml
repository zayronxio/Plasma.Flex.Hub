import QtQuick
import "../lib" as Lib

Item {
    Lib.Card {
        width: parent.width
        height: parent.height
        Column {
            width: parent.width
            height: parent.height
            ItemNetwork {
                //id: itemNetwork
                width: parent.width
                height: parent.height/3
            }

            ItemBluetooth {
                id: itemBluetooth
                width: parent.width
                height: parent.height/3
            }

            ItemOpenConfigs {
                id: itemOpenConfigs
                width: parent.width
                height: parent.height/3
            }
        }

    }
}
