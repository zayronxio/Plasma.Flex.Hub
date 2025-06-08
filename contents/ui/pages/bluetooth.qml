import QtQuick
import "../lib" as Lib
import org.kde.bluezqt as BluezQt
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import org.kde.ksvg as KSvg
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.plasmoid
import "../js/funcs.js" as Funcs
import org.kde.plasma.private.bluetooth as PlasmaBt
import "components/bluetooth" as BluetoothComponents
import org.kde.kcmutils

Item {

    id: main

    readonly property bool emptyList: BluezQt.Manager.devices.length === 0

    PlasmaBt.DevicesProxyModel {
        id: devicesModel
        hideBlockedDevices: true
        sourceModel: PlasmaBt.SharedDevicesStateProxyModel
    }

    function action() {
        page = ""
    }

    function addDeviceAction() {
        PlasmaBt.LaunchApp.launchWizard()
    }
    function setBluetoothEnabled(enable: bool): void {
        BluezQt.Manager.bluetoothBlocked = !enable;

        BluezQt.Manager.adapters.forEach(adapter => {
            adapter.powered = enable;
        });
    }

    Kirigami.Action {
        id: addDeviceActionA
        text: i18n("Pair Device…")
        icon.name: "list-add-symbolic"
        visible: !BluezQt.Manager.bluetoothBlocked
        onTriggered: addDeviceAction()
    }

    Lib.Pages{
        id: page
        width: parent.width
        height: parent.height
        actionArrow: action
        enabledFooter: false

        headerContent: Item {
            anchors.fill: parent
            anchors.centerIn: parent
            Kirigami.Heading {
                width: parent.width
                height: parent.height
                level: 3
                verticalAlignment: Text.AlignVCenter
                text: i18n("Bluetooth")
            }
            Row {
                width: 92
                spacing: 4
                height: parent.height
                anchors.left: parent.left
                anchors.leftMargin: parent.width - width
                Switch {
                    width: 32
                    anchors.topMargin: 24
                    anchors.verticalCenter: parent.verticalCenter
                    checked: !BluezQt.Manager.bluetoothBlocked
                    onClicked: setBluetoothEnabled(checked)
                }
                Kirigami.Icon {
                    source: "spinbox-increase"
                    width: 24
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            addDeviceAction()
                        }
                    }
                }
                Kirigami.Icon {
                    source: "configure"
                    width: 24
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            KCMLauncher.openSystemSettings("kcm_bluetooth")
                        }
                    }
                }
            }


        }
        mainContent: Item {
            width: parent.width
            height: parent.height

            Kirigami.PlaceholderMessage {
                width: parent.width
                visible: emptyList || BluezQt.Manager.bluetoothBlocked
                height: parent.height
                icon.name: BluezQt.Manager.rfkill.state === BluezQt.Rfkill.Unknown || BluezQt.Manager.bluetoothBlocked ? "network-bluetooth" : "network-bluetooth-activated"

                text: {
                    // We cannot use the adapter count here because that can be zero when
                    // bluetooth is disabled even when there are physical devices
                    if (BluezQt.Manager.rfkill.state === BluezQt.Rfkill.Unknown) {
                        return i18n("No Bluetooth adapters available");
                    } else if (BluezQt.Manager.bluetoothBlocked) {
                        return i18n("Bluetooth is disabled");
                    } else if (main.emptyList) {
                        return i18n("No devices paired");
                    } else {
                        return "";
                    }
                }
                helpfulAction: {
                    if (BluezQt.Manager.rfkill.state === BluezQt.Rfkill.Unknown) {
                        return null;
                    }  else if (main.emptyList && !BluezQt.Manager.bluetoothBlocked) {
                        return addDeviceActionA;
                    } else {
                        return null;
                    }
                }
            }




            ListView {
                id: listView
                height: 100
                width: parent.width
                model: BluezQt.Manager.adapters.length > 0 && !BluezQt.Manager.bluetoothBlocked ? devicesModel : null
                clip: true
                currentIndex: -1
                boundsBehavior: Flickable.StopAtBounds

                spacing: Kirigami.Units.smallSpacing
                topMargin: Kirigami.Units.largeSpacing
                leftMargin: Kirigami.Units.largeSpacing
                rightMargin: Kirigami.Units.largeSpacing
                bottomMargin: Kirigami.Units.largeSpacing

                section.property: "Section"
                // We want to hide the section delegate for the "Connected"
                // group because it's unnecessary; all we want to do here is
                // separate the connected devices from the available ones
                section.delegate: Loader {
                    required property string section

                    active: section !== "Connected" && BluezQt.Manager.connectedDevices.length > 0

                    width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
                    // Need to manually set the height or else the loader takes up
                    // space after the first time it unloads a previously-loaded item
                    height: active ? Kirigami.Units.gridUnit : 0

                    // give us 2 frames to try and figure out a layout, this reduces jumpyness quite a bit but doesn't
                    // entirely eliminate it https://bugs.kde.org/show_bug.cgi?id=438610
                    Behavior on height { PropertyAnimation { duration: 32 } }

                    sourceComponent: Item {
                        KSvg.SvgItem {
                            width: parent.width - Kirigami.Units.gridUnit * 2
                            anchors.centerIn: parent
                            imagePath: "widgets/line"
                            elementId: "horizontal-line"
                        }
                    }
                }
                highlight: PlasmaExtras.Highlight {}
                highlightMoveDuration: Kirigami.Units.shortDuration
                highlightResizeDuration: Kirigami.Units.shortDuration
                delegate: BluetoothComponents.DeviceItem {}

                Keys.onUpPressed: event => {
                    if (listView.currentIndex === 0) {
                        listView.currentIndex = -1;
                        toolbar.onSwitch.forceActiveFocus(Qt.BacktabFocusReason);
                    } else {
                        event.accepted = false;
                    }
                }


            }
        }
    }
}

