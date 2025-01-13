import org.kde.plasma.private.brightnesscontrolplugin
import QtQuick
import org.kde.plasma.plasmoid
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import org.kde.kitemmodels as KItemModels

Item {

    ScreenBrightnessControl {
        id: systemBrightnessControl
        isSilent: false
    }
    NightLightControl {
        id: nightM

        readonly property bool transitioning: control.currentTemperature != control.targetTemperature
        readonly property bool hasSwitchingTimes: control.mode != 3
        readonly property bool togglable: activeNightMode || !control.inhibited || control.inhibitedFromApplet

    }

    signal nightMode

    onNightMode: {
        nightM.toggleInhibition()
    }

    property bool runningNightToggle: nightM.running
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
        systemBrightnessControl.setBrightness(mainScreen.displayName, Math.max(brightnessMin, Math.min(mainScreen.maxBrightness, (realValueSlider*100)))) ;
    }

    Connections {
        target: systemBrightnessControl
    }
}
