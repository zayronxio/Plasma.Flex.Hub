import QtQuick
import org.kde.coreaddons 1.0 as KCoreAddons

QtObject {

    property string codeleng: ((Qt.locale().name)[0]+(Qt.locale().name)[1])

    property var kuser: KCoreAddons.KUser {
    }

    function capitalizeFirstLetter(string) {
        if (!string || string.length === 0) {
            return "";
        }
        return string.charAt(0).toUpperCase() + string.slice(1);
    }

    property string distroName: KCoreAddons.KOSRelease.prettyName
    property string fullName: capitalizeFirstLetter(kuser.fullName)
    property string name: i18n("Hi") + " " + capitalizeFirstLetter(kuser.fullName)
    property string urlAvatar: kuser.faceIconUrl

}
