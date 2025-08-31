import QtQuick
import "../lib" as Lib
import Qt5Compat.GraphicalEffects
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami as Kirigami
import org.kde.plasma.private.sessions as Sessions

Item {
    UserInfo {
        id: us
    }

    Sessions.SessionManagement {
        id: sm
    }

    Lib.Card {
        id: wrapper
        width: parent.width
        height: parent.height
        globalBool: false

        Rectangle {
            id: maskavatar
            height: Plasmoid.configuration.sizeGeneralIcons + Plasmoid.configuration.sizeMarginlIcons
            width: height
            radius: height/2
            color: Kirigami.Theme.highlightColor
            visible: !us.urlAvatar
        }
        Image {
            id: avatar
            source: us.urlAvatar
            height: Plasmoid.configuration.sizeGeneralIcons + Plasmoid.configuration.sizeMarginlIcons
            width: height
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: maskavatar
            }
            Text {
                visible: !us.urlAvatar
                font.pixelSize: parent.height/2
                text: us.fullName
                color: Kirigami.Theme.highlightTextColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.capitalization: Font.Capitalize

            }
        }

        Kirigami.Heading {
            id: name
            //height: parent.height
            anchors.left: avatar.right
            anchors.leftMargin: 10
            anchors.top: avatar.top
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.DemiBold
            text: us.name
            level: 5
        }

        Kirigami.Icon {
            source: "system-shutdown.svg"
            width: 24
            height: width
            anchors.left: avatar.right
            anchors.verticalCenter: name.verticalCenter
            anchors.leftMargin: name.implicitWidth + 10
            MouseArea {
                height: parent.height
                width: parent.width
                anchors.centerIn: parent
                onClicked: {
                    sm.requestLogoutPrompt()
                }
            }
        }

        Battery {
            height: 24
            anchors.top: name.top
            anchors.topMargin: name.implicitHeight
            anchors.left: name.left
        }
    }
}
