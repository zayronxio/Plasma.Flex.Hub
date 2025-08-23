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

        Lib.MiniButton {
            width: parent.width
            height: parent.height
            title: i18n("DND")
            itemIcon: {
                return (Funcs.checkInhibition() ? "notifications-disabled" : "notifications");
            }
            onIconClicked: {
                Funcs.toggleDnd();
            }
        }
    }
}
