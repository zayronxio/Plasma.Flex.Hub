import QtQuick
import "../lib" as Lib
import org.kde.ksysguard.sensors as Sensors

Item {
    width: parent.width
    height: parent.height

    signal ready

    property var value: 0

    Sensors.SensorDataModel {
        id: root
        updateRateLimit: -1

        property int _coreCount: 0

        property string aggregator: "average" // Possible value: average, minimum, maximum
        property int eCoresCount: 0



        function getFormattedValue(eCores = false) {
            const value = getValue(eCores);
            return value !== undefined ? value.toFixed(2) + "%" : "N/A"; // Mostrar con dos decimales y un símbolo de porcentaje
        }

        function getValue(eCores = false) {
            if (_coreCount === 0) {
                return undefined;
            }
            const pCoresCount = _coreCount - eCoresCount;

            // Retrieve cores frequencies
            let values = [];
            const start = eCores ? pCoresCount : 0;
            const end = eCores ? _coreCount : pCoresCount;

            for (let i = start; i < end; i++) {
                // Verificar si el índice es válido antes de acceder a los datos
                if (!root.hasIndex(0, i)) {
                    continue;
                }
                values[i] = data(index(0, i), Sensors.SensorDataModel.Value);
            }
            if (values.length == 0) {
                return undefined;
            }

            // Agregar valores
            if (aggregator === "average") {
                return values.reduce((a, b) => a + b, 0) / values.length;
            } else if (aggregator === "minimum") {
                return Math.min(...values);
            } else if (aggregator === "maximum") {
                return Math.max(...values);
            }
            return undefined;
        }

        // Initialize sensors by retrieving core count, then set to N frequency sensor
        sensors: ["cpu/all/coreCount"]
        readonly property Timer _initialize: Timer {
            running: enabled
            triggeredOnStart: true

            // Wait to be sure all sensors metadata has retrieved
            repeat: true
            interval: 100

            onTriggered: {
                if (!root.hasIndex(0, 0)) {
                    return;
                }

                const valueVar = parseInt(root.data(root.index(0, 0), Sensors.SensorDataModel.Value));
                if (isNaN(valueVar) || valueVar <= 0) {
                    return;
                }

                // Llenar los sensores con los núcleos de CPU
                root._coreCount = valueVar;
                const sensors = [];
                for (let i = 0; i < root._coreCount; i++) {
                    sensors[i] = "cpu/cpu" + i + "/usage";
                }
                root.sensors = sensors;
                ready()
            }
        }
    }
    onReady: {
        const formattedValue = root.getFormattedValue(false);
        if (!isNaN(parseInt(formattedValue))) {
            value = Math.round(parseInt(formattedValue)) + "%";
        }
    }

    Lib.Item {
        width: parent.width
        height: parent.height
        activeSub: true
        smallMode: false
        isMaskIcon: true
        anchorsDinamic: "center"
        customMarginTop: 0
        customMarginBottom: 0
        title: i18n("CPU Usage")
        sub: value
        itemIcon: Qt.resolvedUrl("../icons/CPU.svg")
    }
}
