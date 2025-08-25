import QtQuick
import "../lib" as Lib
import org.kde.ksysguard.sensors as Sensors

Item {
    width: parent.width
    height: parent.height
    property var valueUsage: 0
    Sensors.SensorDataModel {
        id: maxQueryModel
        sensors: ["memory/physical/total", "memory/physical/free"]
        enabled: true
        property var maxMemory: [-1, -1]

        onDataChanged: topLeft => {
            // Actualizar valores
            const value = parseInt(data(topLeft, Sensors.SensorDataModel.Value));
            if (isNaN(value) || (topLeft.column === 0 && value <= 0)) {
                return;
            }
            maxMemory[topLeft.column] = value;

            // Mostrar los valores actualizados
            if (maxMemory[0] > 0 && maxMemory[1] >= 0) {
                valueUsage = (maxMemory[0]-maxMemory[1])/maxMemory[0]
            }
        }
    }

    Timer {
        interval: 2000 // 1 segundo
        running: true
        repeat: true

        onTriggered: {
            // El modelo ya está activado, pero podemos forzar la consulta de datos.
            maxQueryModel.enabled = false;
            maxQueryModel.enabled = true;
        }
    }
    Lib.Item {
        width: parent.width
        height: parent.height
        activeSub: true
        smallMode: false
        isMaskIcon: true
        anchorsDinamic: "top"
        customMarginTop: (heightFactor - sizeIcon - marginIcons)/2
        title: i18n("Ram Usage")
        sub: Math.round(valueUsage*100) + "%"
        itemIcon: Qt.resolvedUrl("../icons/ram")
    }

}
