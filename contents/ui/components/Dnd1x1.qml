import QtQuick
import "../js/funcs.js" as Funcs
import "../lib" as Lib
import org.kde.kirigami as Kirigami
import org.kde.notificationmanager as NotificationManager

Item {

    NotificationManager.Settings {
        id: notificationSettings
    }

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
                source: "notifications" //Funcs.checkInhibition() ? "notifications-disabled" : "notifications"
                //anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Funcs.toggleDnd();
                }
            }

            Kirigami.Heading {
                id: textdontDis
                text: i18n("DND")
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
