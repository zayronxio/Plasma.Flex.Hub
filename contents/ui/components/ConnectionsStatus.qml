import QtQuick
import "../lib" as Lib

Item {

    property bool mouseAreaActive:  false
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
                MouseArea {
                    anchors.fill: parent
                    anchors.centerIn: parent
                    enabled: mouseAreaActive
                    onClicked: {
                        page = Qt.resolvedUrl("../pages/Network.qml")
                    }
                }
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
