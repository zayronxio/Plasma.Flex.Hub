import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import "../lib" as Lib
import org.kde.ksvg 1.0 as KSvg
import Qt5Compat.GraphicalEffects
import "../js/funcs.js" as Funcs
import org.kde.bluezqt 1.0 as BluezQt

Item {

    property QtObject btManager : BluezQt.Manager

    property bool mouseAreaActive:  false

    property bool activeColor: Funcs.getBtDevice() === i18n("Disabled") || Funcs.getBtDevice() === i18n("Unavailable")  ? false : Funcs.getBtDevice() === i18n("Not Connected") ? false : Funcs.getBtDevice() === i18n("Offline") ? false : true

    Lib.Card {
        width: parent.width
        height: parent.height
        enabledColor: true
        elementBackgroundColor: activeColor ?  Kirigami.Theme.highlightColor : Kirigami.Theme.textColor
        backgroundColorOpacity: 1


        Kirigami.Icon {
            id: iconVolume
            width: Kirigami.Units.iconSizes.mediumSmall
            height: width
            isMask: true
            color:  Kirigami.Theme.highlightColor //activeColor ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.frameContrast //Kirigami.Theme.textColor
            anchors.centerIn: parent
            source: activeColor ? "network-bluetooth-activated-symbolic" : "network-bluetooth-inactive-symbolic"
        }

        MouseArea {
            anchors.fill: parent
            enabled: mouseAreaActive
            onClicked: {
                page = Qt.resolvedUrl("../pages/bluetooth.qml")
            }
        }
    }

}
