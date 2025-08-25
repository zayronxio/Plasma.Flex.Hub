import QtQuick
import "../lib" as Lib
import "../js/utils.js" as Utils
import org.kde.plasma.plasma5support as Plasma5Support

Item {
    width: parent.width
    height: parent.height

    property var transferDataTs: 0
    property var transferData: {}
    property var speedData: {}
    property string interfaceName//: "wlp3s0" // Asegúrate de asignar un nombre de interfaz válido


    Plasma5Support.DataSource {
        id: dataSource
        engine: 'executable'
        connectedSources: [Utils.NET_DATA_SOURCE]
        interval: 1.0 * 1000

        onNewData: (sourceName, data) => {

            if (data['exit code'] > 0 || !data.stdout) {
                return;
            }

            const lines = data.stdout.trim().split("\n");

            for (let i = 0; i < lines.length; i++) {
                const parts = lines[i].split(",");
                if (parts.length < 3) continue;

                const name = parts[0].trim();
                const rx = parseInt(parts[1]);
                const tx = parseInt(parts[2]);

                if ((rx > 0 || tx > 0) && name !== "lo" && !name.startsWith("virbr")) {
                    if (interfaceName !== name) {
                        console.log("Interfaz activa detectada:", name);
                    }
                    interfaceName = name;
                    break; // Solo tomamos la primera interfaz con tráfico real
                }
            }

            const now = Date.now();
            const duration = now - transferDataTs;
            const nextTransferData = Utils.parseTransferData(data.stdout);

            if (Object.keys(nextTransferData).length === 0) {
                return;
            }

            if (transferDataTs > 0 && Object.keys(transferData).length > 0) {
                speedData = Utils.calcSpeedData(transferData, nextTransferData, duration);
            } else {
                console.warn("Skipping speed calculation, missing previous data.");
            }

            transferDataTs = now;
            transferData = nextTransferData;
        }
    }

    Lib.Item {
        width: parent.width
        height: parent.height
        activeSub: true
        smallMode: false
        anchorsDinamic: "bottom"
        customMarginBottom: ((heightFactor - sizeIcon - marginIcons)/2) + spacing/2
        title: textConstants.usageNetwork
        isMaskIcon: true
        sub: {
            // Obtener los valores de velocidad de la interfaz seleccionada
            const iface = speedData[interfaceName];
            if (iface) {
                // Función para convertir kB a MB o GB
                function formatSpeed(value) {
                    if (value >= 1000000) { // Si es mayor o igual a 1GB
                        return (value / 1024 / 1024).toFixed(1) + " GB"; // Convertir a GB y limitar a 1 decimal
                    } else if (value >= 1000) { // Si es mayor o igual a 1000kB
                        return (value / 1024).toFixed(1) + " MB"; // Convertir a MB y limitar a 1 decimal
                    } else {
                        return Math.round(value) + " kB"; // Mostrar kB si es menor a 1000
                    }
                }

                const downSpeed = formatSpeed(iface.down || 0);
                const upSpeed = formatSpeed(iface.up || 0);

                return `${downSpeed} ↓, ${upSpeed} ↑`;
            } else {
                return "No data for interface"; // Mensaje si no hay datos para la interfaz
            }
        }
        itemIcon: Qt.resolvedUrl("../icons/network")
    }
}

