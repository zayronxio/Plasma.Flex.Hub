import QtQuick
import "../lib" as Lib
import org.kde.kcmutils // KCMLauncher

Item {
    Lib.Item {
        id: item
        width: parent.width
        height: parent.height
        activeSub: true
        smallMode: false
        isMaskIcon: true
        title: i18n("Settings")
        sub: i18n("System Settings")
        itemIcon: "configure"
        onClick: onClickAction()
    }

    // Definimos la función `onClickAction` para evitar la ejecución automática
    function onClickAction() {
        KCMLauncher.openSystemSettings("")
    }
}
