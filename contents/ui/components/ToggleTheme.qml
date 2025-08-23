import QtQuick
import "../lib" as Lib
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support

Item {

    property bool mouseAreaActive:  false

    function isColorLight(color) {
        const luminance = 0.299 * color.r + 0.587 * color.g + 0.114 * color.b;
        return luminance < 0.3157; // 80.5 / 255
    }

    property var plasmaTheme: PlasmaCore.Theme.themeName
    property var plasmaColor: PlasmaCore.Theme.palette
    property bool isDark
    property string theme: !isDark ? Plasmoid.configuration.darkTheme : Plasmoid.configuration.lightTheme
    property string command: "plasma-apply-lookandfeel -a " + theme

    onPlasmaThemeChanged: {
        isDark = isColorLight(Kirigami.Theme.backgroundColor)
    }
    onPlasmaColorChanged: {
        isDark = isColorLight(Kirigami.Theme.backgroundColor)
    }
    Lib.Card {
        width: parent.width
        height: parent.height

        Lib.MiniButton {
            width: parent.width
            height: parent.height
            bashExe: true
            cmd: command
            exeDual: true
            title: isDark ? i18n("Dark") : i18n("Light")
            itemIcon: "edit-select-invert"
            onIconClicked: {
                isDark = !isDark
            }
        }
    }
    Component.onCompleted: {
        isDark = Kirigami.Theme.isDark
    }
}
