import QtQuick
import "../lib" as Lib
import QtQuick.Controls
import "../components" as Components
import org.kde.kirigami as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.networkmanagement as PlasmaNM

Item {

    Components.SourceNetwork {
        id: network
    }

    Lib.Pages {
        width: parent.width
        height: parent.height
        //actionArrow: action
        enabledFooter: false

        headerContent: Row {
            width: parent.width - (wifiSwitchButton.implicitWidth*2) - Kirigami.Units.iconSizes.sizeForLabels
            height: parent.height
            Kirigami.Heading {
                width: parent.width
                height: parent.height
                level: 3
                verticalAlignment: Text.AlignVCenter
                text: i18n("Network Connections")
            }



            PlasmaComponents3.CheckBox {
                id: wifiSwitchButton

                readonly property bool administrativelyEnabled: network.availableDevices.wirelessDeviceAvailable && network.enabledConnections.wirelessHwEnabled

                //Layout.rightMargin: root.smallSpacing
                checked: administrativelyEnabled && network.enabledConnections.wirelessEnabled
                enabled: administrativelyEnabled
                icon.name: administrativelyEnabled && network.enabledConnections.wirelessEnabled ? "network-wireless-on" : "network-wireless-off"
                visible: network.availableDevices.wirelessDeviceAvailable
                onToggled: network.handler.enableWireless(checked)

                PlasmaComponents3.ToolTip {
                    text: wifiSwitchButton.checked ? i18n("Disable Wi-Fi") : i18n("Enable Wi-Fi")
                }

                PlasmaComponents3.BusyIndicator {
                    parent: wifiSwitchButton
                    running: network.handler.scanning || timer.running

                    anchors {
                        fill: wifiSwitchButton.contentItem
                        leftMargin: wifiSwitchButton.indicator.width + wifiSwitchButton.spacing
                    }

                    Timer {
                        id: timer

                        interval: Kirigami.Units.humanMoment
                    }

                    Connections {
                        function onScanningChanged() {
                            if (network.handler.scanning)
                                timer.restart();

                        }

                        target: network.handler
                    }

                }

            }

            // Airplane mode section
            PlasmaComponents3.CheckBox {
                id: airPlaneModeSwitchButton
                width: 22
                height: 22
                property bool initialized: false

                checked: PlasmaNM.Configuration.airplaneModeEnabled
                icon.name: PlasmaNM.Configuration.airplaneModeEnabled ? "network-flightmode-on" : "network-flightmode-off"
                visible: network.availableDevices.modemDeviceAvailable || network.availableDevices.wirelessDeviceAvailable
                onToggled: {
                    network.handler.enableAirplaneMode(checked);
                    PlasmaNM.Configuration.airplaneModeEnabled = checked;
                }

                PlasmaComponents3.ToolTip {
                    text: airPlaneModeSwitchButton.checked ? i18n("Disable airplane mode") : i18n("Enable airplane mode")
                }

            }

        }
        mainContent: Item {
            anchors.fill: parent
            anchors.margins: root.smallSpacing
            clip: true

            ListView {
                anchors.fill: parent
                model: network.appletProxyModel

                ScrollBar.vertical: ScrollBar {
                }

                delegate: Components.ConnectionItem {
                    width: parent.width
                    height: Kirigami.Units.iconSizes.sizeForLabels*3
                }

            }

        }
    }
}
