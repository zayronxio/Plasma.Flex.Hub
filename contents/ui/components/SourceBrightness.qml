import org.kde.plasma.private.brightnesscontrolplugin
import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import org.kde.kitemmodels as KItemModels

Item {

    ScreenBrightnessControl {
        id: systemBrightnessControl
        isSilent: false
    }

    property bool active: systemBrightnessControl.isBrightnessAvailable


    Connections {
        id: displayModelConnections
        target: systemBrightnessControl.displays
        property var screenBrightnessInfo: []

        function update() {
            const [labelRole, brightnessRole, maxBrightnessRole, displayNameRole] = ["label", "brightness", "maxBrightness", "displayName"].map(
                (roleName) => target.KItemModels.KRoleNames.role(roleName));

            screenBrightnessInfo = [...Array(target.rowCount()).keys()].map((i) => { // for each display index
                const modelIndex = target.index(i, 0);
                return {
                    displayName: target.data(modelIndex, displayNameRole),
                                                                            label: target.data(modelIndex, labelRole),
                                                                            brightness: target.data(modelIndex, brightnessRole),
                                                                            maxBrightness: target.data(modelIndex, maxBrightnessRole),
                };
            });
            brightnessControl.mainScreen = screenBrightnessInfo[0];
        }
        function onDataChanged() { update(); }
        function onModelReset() { update(); }
        function onRowsInserted() { update(); }
        function onRowsMoved() { update(); }
        function onRowsRemoved() { update(); }
    }

    property int realValueSlider: 0
    property int cnValue: mainScreen.brightness
    property var mainScreen: displayModelConnections.screenBrightnessInfo[0]
    property var valueSlider: mainScreen.brightness
    property var maxSlider: mainScreen.maxBrightness
    property bool disableBrightnessUpdate: true
    readonly property int brightnessMin: (mainScreen.maxBrightness > 100 ? 1 : 0)


    onRealValueSliderChanged: {
        console.log("si se actualiza")
        systemBrightnessControl.setBrightness(mainScreen.displayName, Math.max(brightnessMin, Math.min(mainScreen.maxBrightness, realValueSlider))) ;
    }

    Connections {
        target: systemBrightnessControl
    }


}
