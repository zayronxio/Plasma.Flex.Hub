import QtQuick
import "../lib" as Lib
import "../js/funcs.js" as Funcs
import org.kde.bluezqt 1.0 as BluezQt

Item {
    property QtObject btManager : BluezQt.Manager

    Lib.Item {
        id: item
        width: parent.width
        height: parent.height
        activeSub: true
        smallMode: false
        isMaskIcon: true
        title: i18n("Bluetooth")
        sub: Funcs.getBtDevice()
        itemIcon:  Funcs.getBtDevice() === i18n("Disabled") || Funcs.getBtDevice() === i18n("Unavailable")  ? "network-bluetooth-inactive-symbolic" : Funcs.getBtDevice() === i18n("Not Connected") ? "network-bluetooth-symbolic" : Funcs.getBtDevice() === i18n("Offline") ? "network-bluetooth-inactive-symbolic" : "network-bluetooth-activated"
        onIconClicked: Funcs.toggleBluetooth // Role Assignment
    }
}
