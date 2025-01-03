import QtQuick
import "../lib" as Lib
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import org.kde.kirigami as Kirigami
import org.kde.ksvg 1.0 as KSvg

Item {

   Lib.Card {
    width: parent.width
    height: parent.height
    //globalBool: true
    SourceMultimedia {
        id: multimedia
    }
    Item {
        id: maskSvg2
        width: parent.width
        height: parent.height
        visible: false
        Grid {
            width: parent.width
            height: parent.height
            columns: 3
            property var marg: topleft2.implicitWidth

            KSvg.SvgItem {
                id: topleft2
                imagePath: "dialogs/background"
                elementId: "topleft"
            }
            KSvg.SvgItem {
                id: top2
                imagePath: "dialogs/background"
                elementId: "top"
                width: parent.width - topleft2.implicitWidth *2
            }
            KSvg.SvgItem {
                id: topright
                imagePath: "dialogs/background"
                elementId: "topright"
            }

            KSvg.SvgItem {
                id: left2
                imagePath: "dialogs/background"
                elementId: "left"
                height: parent.height - topleft2.implicitHeight*2
            }
            KSvg.SvgItem {
                imagePath: "dialogs/background"
                elementId: "center"
                height: parent.height - topleft2.implicitHeight*2
                width: top2.width
            }
            KSvg.SvgItem {
                id: right
                imagePath: "dialogs/background"
                elementId: "right"
                height: left2.height
            }

            KSvg.SvgItem {
                id: bottomleft2
                imagePath: "dialogs/background"
                elementId: "bottomleft"
            }
            KSvg.SvgItem {
                id: bottom2
                imagePath: "dialogs/background"
                elementId: "bottom"
                width: top2.width
            }
            KSvg.SvgItem {
                id: bottomright
                imagePath: "dialogs/background"
                elementId: "bottomright"
            }
        }
    }
    Image {
        source: multimedia.cover
        width: parent.width
        height: parent.height
        opacity: 0.5
        fillMode: Image.PreserveAspectCrop
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: maskSvg2
        }

    }


    Column {
        width:  parent.width - 20
        height: text.implicitHeight + control.implicitHeight
        anchors.centerIn: parent
        spacing: 10

        Column {
            id: texts
            width: parent.width
            Kirigami.Heading {
                text: multimedia.trackName
                width: parent.width
                font.weight: Font.DemiBold
                level: 5
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
            }
            Kirigami.Heading {
                width: parent.width
                text: multimedia.artistName
                //font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
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
