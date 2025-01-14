import QtQuick
import "../lib" as Lib
import org.kde.kirigami as Kirigami

Item {

     property bool mouseAreaActive:  false

     Lib.Card {
         width: parent.width
         height: parent.height
         ItemNetwork {
             id: source
             width: parent.width
             height: parent.height
             anchors.verticalCenter: parent.verticalCenter
             MouseArea {
                 anchors.fill: parent
                 anchors.centerIn: parent
                 enabled: mouseAreaActive
                 onClicked: {
                     page = Qt.resolvedUrl("../pages/Network.qml")
                 }
            }
        }
    }
}
