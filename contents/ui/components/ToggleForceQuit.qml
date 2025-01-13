import QtQuick
import "../lib" as Lib
import org.kde.kirigami as Kirigami
//import "../pages/ForceQuit.qml" as fq

Item {
    property bool mouseAreaActive:  false
    Lib.Card {
        width: parent.width
        height: parent.height

        Column {
            width: parent.width - 10
            height: parent.height - 10
            anchors.centerIn: parent

            Kirigami.Icon {
                id: logo
                width: Kirigami.Units.iconSizes.mediumSmall
                height: width
                source: "application-exit"
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea {
                    enabled: mouseAreaActive
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        page = Qt.resolvedUrl("../pages/ForceQuit.qml")
                    }
                }
            }

            Kirigami.Heading {
                id: textdontDis
                text: i18n("Force Quit")
                width: parent.width
                anchors.top: logo.bottom
                height: parent.height - logo.height
                level: 5
                //font.pixelSize: weatherToggle.height < weatherToggle.width ? weatherToggle.height*.15 : weatherToggle.width*.15
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
                maximumLineCount: 2
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                //font.weight: Font.DemiBold
            }

        }

    }
}
