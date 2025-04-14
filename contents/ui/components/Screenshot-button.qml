import QtQuick
import "../lib" as Lib
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami as Kirigami

Item {

    property bool mouseAreaActive:  false

    Lib.Card {
        width: parent.width
        height: parent.height
        Lib.Executor {
            id: source
            command: "spectacle -b"
        }


        Column {
            width: parent.width - 10
            height: parent.height - 10
            anchors.centerIn: parent

            Kirigami.Icon {
                id: logo
                width: Kirigami.Units.iconSizes.mediumSmall
                height: width
                source: "camera-photo-symbolic.svg"
                anchors.horizontalCenter: parent.horizontalCenter
                MouseArea {
                    anchors.fill: parent
                    enabled: mouseAreaActive
                    hoverEnabled: true
                    onClicked: {
                        source.execute()
                    }
                }
            }

            Kirigami.Heading {
                id: textdontDis
                text: i18n("Screenshot")
                width: parent.width
                anchors.top: logo.bottom
                height: parent.height - logo.height
                level: 5
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
                maximumLineCount: 2
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                //font.weight: Font.DemiBold
                MouseArea {
                    enabled: mouseAreaActive
                    anchors.fill: parent
                    onClicked: {
                        source.execute()
                    }
                }
            }
        }
    }
}
