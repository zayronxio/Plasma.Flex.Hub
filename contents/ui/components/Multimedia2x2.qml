import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import "../lib" as Lib

Item {

   Lib.Card {
    width: parent.width
    height: parent.height

    SourceMultimedia {
        id: multimedia
    }

    Column {
        width:  parent.width - 20
        height: parent.height - 20
        anchors.centerIn: parent
        spacing: 10
        Cover {
            id: cover
            width: 50
            height: 50
            //anchors.horizontalCenter: parent.horizontalCenter
        }
        Column {
            width: parent.width
            Kirigami.Heading {
                text: multimedia.trackName
                width: parent.width
                font.weight: Font.DemiBold
                level: 5
                elide: Text.ElideRight
            }
            Kirigami.Heading {
                width: parent.width
                text: multimedia.artistName
                //font.weight: Font.DemiBold
                elide: Text.ElideRight
                level: 5
            }
        }


        Row {
            id: control
            width: Kirigami.Units.iconSizes.small*3 + spacing*2
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            Kirigami.Icon {
                width: Kirigami.Units.iconSizes.small
                height: width
                source: "media-skip-backward"
                MouseArea {
                    anchors.fill: parent
                    onClicked: multimedia.prev()
                }
            }
            Kirigami.Icon {
                width: Kirigami.Units.iconSizes.small
                height: width
                source: "media-playback-start"
                MouseArea {
                    anchors.fill: parent
                    onClicked: multimedia.playPause()
                }
            }
            Kirigami.Icon {
                width: Kirigami.Units.iconSizes.small
                height: width
                source: "media-skip-forward"
                MouseArea {
                    anchors.fill: parent
                    onClicked: multimedia.nextTrack()
                }
            }
        }
    }
   }
}
