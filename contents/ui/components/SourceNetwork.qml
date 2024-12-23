import QtQuick
import org.kde.plasma.networkmanagement as PlasmaNM

QtObject {

    property bool activeConnection: netStatusText.connectivity === 4
    //property var appletProxyModel: appletProxyModel
    //property var netStatusText: netStatus.activeConnections
    property var icon: activeConnectionIcon.connectionIcon
    //property var enabledConnections: enabledConnections
    //property var availableDevices: availableDevices
    //property var handler: handler
    property string textConnetion: activeConnection ? i18n("Connect") : i18n("Disconnect")


    property var activeConnectionIcon: PlasmaNM.ConnectionIcon {
        connectivity: netStatus.connectivity
    }
    property var handler: PlasmaNM.Handler {
    }
    property var netStatusText: PlasmaNM.NetworkStatus {
    }
    property var appletProxyModel: PlasmaNM.AppletProxyModel {
        sourceModel: PlasmaNM.NetworkModel{}
    }
    property var enabledConnections: PlasmaNM.EnabledConnections {
    }
    property var availableDevices: PlasmaNM.AvailableDevices {
    }




}
