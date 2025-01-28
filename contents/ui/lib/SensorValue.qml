import QtQuick
import org.kde.ksysguard.sensors as Sensors
import org.kde.quickcharts as Charts
import "../js/formatter.js" as Formatter

Item {

    property string name
    property string currentSensor: "cpu/cpu0/temperature"

    property int unit: -1

    readonly property var value: Math.round(sensor.isValueReady
    ? Formatter.convertUnit(sensor.value, Formatter.Units.Celsius, 0)
    : undefined)


    Sensors.Sensor {
        id: sensor
        sensorId: currentSensor
        property bool isValueReady: false

        onValueChanged: {
            if (!isValueReady && value !== 0 && value !== undefined) {
                isValueReady = true;
            }
        }

        updateRateLimit: 10 * 1000 // pendiente
    }

    Component.onCompleted: sensorItem.unit = 0

    Timer {
        id: history

        property int maximumLength: (Plasmoid.configuration.statsHistory * 1000) / interval
        property list<var> values: Array(maximumLength).fill(undefined)
        property list<int> filteredValues: values.filter(value => value !== undefined)

        interval: 5000
        repeat: true
        running: true// sensor.isValueReady
        triggeredOnStart: true

        onTriggered: {

            console.log("Se rept", Math.round(value))

        }

        onIntervalChanged: {
            values = Array(maximumLength).fill(undefined);
        }

        onMaximumLengthChanged: {
            let fillCount = Math.max(0, maximumLength - values.length);
            values = [...values.slice(0, maximumLength), ...Array(fillCount).fill(undefined)];
        }
    }


}
