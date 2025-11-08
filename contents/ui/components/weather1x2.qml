import QtQuick
import "../lib" as Lib
import org.kde.kirigami as Kirigami

Item {
    property bool mouseAreaActive:  false


    Lib.Card {
        width: parent.width
        height: parent.height

        property bool mouseAreaActive:  parent.mouseAreaActive

        Kirigami.Icon {
            source: "weather"
            width: 48
            height: width
            anchors.centerIn: parent
            visible: !mouseAreaActive
            opacity: 0.5
        }

        Lib.Item {
            id: item
            visible: mouseAreaActive
            width: parent.width
            height: parent.height
            activeSub: true
            smallMode: false
            isMaskIcon: true
            circleMask: true
            title: "Tormenta"
            sub: "32°C"
            itemIcon: "weather-snow-symbolic"
        }
    }
}
