import QtQuick
import QtQuick.Layouts

import org.kde.coreaddons as KCoreAddons
import org.kde.kcmutils // KCMLauncher
import org.kde.config as KConfig  // KAuthorized.authorizeControlModule
import org.kde.notification
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.kitemmodels as KItemModels

import org.kde.plasma.private.brightnesscontrolplugin
import org.kde.plasma.workspace.dbus as DBus

Item {
    id: root

    //required property DBus.Properties nightLightControl

    property int realValueSlider: 0
    property int cnValue: displayModelConnections.brightness
    property var mainScreen: displayModelConnections.screenBrightnessInfo[0]
    property var valueSlider: mainScreen.brightness /20
    property var maxSlider: mainScreen.maxBrightness /20
    property bool readyData: false
    readonly property int brightnessMin: (maxSlider.maxBrightness / 200)

    property bool activeNightLight: nightLightControl.inhibited

    property bool runningNightToggle: nightLightControl.running

    signal nightMode

    ScreenBrightnessControl {
        id: screenBrightnessControl
        //isSilent: brightnessAndColorControl.expanded
    }

    Connections {
        id: displayModelConnections
        target: screenBrightnessControl.displays
        property var screenBrightnessInfo: []

        function update() {
            const [labelRole, brightnessRole, maxBrightnessRole] = ["label", "brightness", "maxBrightness"].map(
                (roleName) => target.KItemModels.KRoleNames.role(roleName));

            screenBrightnessInfo = [...Array(target.rowCount()).keys()].map((i) => { // for each display index
                const modelIndex = target.index(i, 0);
                return {
                    label: target.data(modelIndex, labelRole),
                                                                            brightness: target.data(modelIndex, brightnessRole),
                                                                            maxBrightness: target.data(modelIndex, maxBrightnessRole),
                };
            });
        }
        function onDataChanged() { update(); }
        function onModelReset() { update(); }
        function onRowsInserted() { update(); }
        function onRowsMoved() { update(); }
        function onRowsRemoved() { update(); }
    }

    Connections {
        target: screenBrightnessControl
    }

    onRealValueSliderChanged: {
        var delta = realValueSlider - valueSlider
        screenBrightnessControl.adjustBrightnessStep(
            delta < 0 ? ScreenBrightnessControl.Decrease : ScreenBrightnessControl.Increase) ;
    }

    DBus.Properties {
        id: nightLightControl
        busType: DBus.BusType.Session
        service: "org.kde.KWin.NightLight"
        path: "/org/kde/KWin/NightLight"
        iface: "org.kde.KWin.NightLight"

        // This property holds a value to indicate if Night Light is available.
        readonly property bool available: Boolean(properties.available)
        // This property holds a value to indicate if Night Light is enabled.
        readonly property bool enabled: Boolean(properties.enabled)
        // This property holds a value to indicate if Night Light is running.
        readonly property bool running: Boolean(properties.running)
        // This property holds a value to indicate whether night light is currently inhibited.
        readonly property bool inhibited: Boolean(properties.inhibited)
        // This property holds a value to indicate whether night light is currently inhibited from the applet can be uninhibited through it.
        readonly property bool inhibitedFromApplet: NightLightInhibitor.inhibited
        // This property holds a value to indicate which mode is set for transitions (0 - automatic location, 1 - manual location, 2 - manual timings, 3 - constant)

        readonly property bool transitioning: currentTemperature != targetTemperature
        readonly property bool hasSwitchingTimes: mode != 3
        readonly property bool togglable: !inhibited || inhibitedFromApplet
    }

    onNightMode: {
        NightLightInhibitor.toggleInhibition()
    }
}
