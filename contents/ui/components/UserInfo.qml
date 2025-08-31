import QtQuick
import org.kde.coreaddons 1.0 as KCoreAddons

Item {

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
    property string fullName: kuser.fullName
    property string name: i18n("Hi") + " " + capitalizeFirstLetter(kuser.fullName)
    property string urlAvatar: kuser.faceIconUrl
    property bool hasAvatarImage: imageLoader.status === Image.Ready

    Image {
        id: imageLoader
        source: urlAvatar
        // Establece el tamaño a cero para que no sea visible
        width: 0
        height: 0
        // Asegúrate de que no se cargue en el background para que se sepa de inmediato si se tiene imagen o no
        asynchronous: false
    }
}
