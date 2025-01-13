import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import "../lib" as Lib

Item {
   property bool mouseAreaActive:  false
   Lib.Card {
       width: parent.width
       height: parent.height
       //console.log("este es:",elements.length)
       SourceMultimedia {
           id: multimedia
       }
       Item {
           width: parent.width - 20
           height: parent.height - 20
           anchors.centerIn: parent

           MouseArea {
               width: parent.width
               height: parent.height
               preventStealing: true
               anchors.centerIn: parent
               hoverEnabled: true
               enabled: mouseAreaActive
               onEntered: {
                   control.visible = true
                   infoTrack.visible = false
               }
               onExited: {
                   control.visible = false
                   infoTrack.visible = true
               }
           }
           Cover {
               id: cover
               width: parent.height - Kirigami.Units.smallSpacing
               height: width
               anchors.verticalCenter: parent.verticalCenter
           }
           Column {
               id: infoTrack
               height: track.implicitHeight + artist.implicitHeight
               width:  parent.width - cover.width - anchors.leftMargin
               anchors.left: cover.right
               anchors.leftMargin: Kirigami.Units.mediumSpacing
               anchors.verticalCenter: parent.verticalCenter
               Kirigami.Heading {
                   id: track
                   width: parent.width
                   text: multimedia.trackName
                   elide: Text.ElideRight
                   font.weight: Font.DemiBold
                   level: 5
               }
               Kirigami.Heading {
                   id: artist
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
               height: Kirigami.Units.iconSizes.small
               anchors.centerIn: infoTrack
               visible: false
               spacing: 10
               Kirigami.Icon {
                   width: Kirigami.Units.iconSizes.small
                   height: width
                   source: "media-skip-backward"
                   MouseArea {
                       enabled: mouseAreaActive
                       anchors.fill: parent
                       onClicked: multimedia.prev()
                   }
               }
               Kirigami.Icon {
                   width: Kirigami.Units.iconSizes.small
                   height: width
                   source: "media-playback-start"
                   MouseArea {
                       enabled: mouseAreaActive
                       anchors.fill: parent
                       onClicked: multimedia.playPause()
                   }
               }
               Kirigami.Icon {
                   width: Kirigami.Units.iconSizes.small
                   height: width
                   source: "media-skip-forward"
                   MouseArea {
                       enabled: mouseAreaActive
                       anchors.fill: parent
                       onClicked: multimedia.nextTrack()
                   }
               }
           }
       }
   }
}
