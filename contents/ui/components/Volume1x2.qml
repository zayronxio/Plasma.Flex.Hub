import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami
//import org.kde.kcmutils // KCMLauncher
//import org.kde.plasma.components 3.0 as PlasmaComponents
import "../lib" as Lib

Item {
    property bool mouseAreaActive:  false
    Lib.Card {
        width: parent.width
        height: parent.height

        SourceVolume {
            id: vol
        }
        Column {
            width:  parent.width - generalMargin - (miniIconsSize/2)
            height: parent.height - 20
            anchors.centerIn: parent
            spacing: 10

            Kirigami.Heading {
                id: name
                text: textConstants.volume
                font.weight: Font.DemiBold
                level: 5
                anchors.left: slider.left
                anchors.top: parent.top
                anchors.topMargin: Kirigami.Units.gridUnit /2
            }

            Slider {
                id: slider
                width: parent.width - Kirigami.Units.gridUnit
                height: 24
                //anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: ((parent.height - height)/2) + name.implicitHeight/2
                from: 0
                value: vol.sliderValue
                to: 100
                snapMode: Slider.SnapAlways
                enabled: mouseAreaActive
                //stepSize: 5
                onMoved: {
                    vol.sink.volume = value * vol.normalVolume / 100
                }
            }
        }

    }

}
