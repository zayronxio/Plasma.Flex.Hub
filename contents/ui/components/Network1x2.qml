import QtQuick
import "../lib" as Lib
import org.kde.kirigami as Kirigami

Item {
     Lib.Card {
         width: parent.width
         height: parent.height
         ItemNetwork {
             id: source
             width: parent.width
             height: parent.height
             anchors.verticalCenter: parent.verticalCenter
        }
    }
}
