import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import "../lib" as Lib
import org.kde.ksysguard.sensors as Sensors

Item {

    property bool mouseAreaActive:  false

    property string code: ""
    property var control

    property string sourceBrightnessPlasma64orPlusQml: `
    import QtQuick
    SourceBrightnessPlasma64orPlus {
        id: dynamic
    }
    `
    property string sourceBrightnessQML: `
    import QtQuick
    SourceBrightness {
        id: dynamic
    }
    `

    Sensors.SensorDataModel {
        id: plasmaVersionModel
        sensors: ["os/plasma/plasmaVersion"]
        enabled: true

        onDataChanged: {
            const value = data(index(0, 0), Sensors.SensorDataModel.Value);
            if (value !== undefined && value !== null) {
                if (value.indexOf("6.4") >= 0) {
                    code = sourceBrightnessPlasma64orPlusQml;
                } else {
                    code = sourceBrightnessQML;
                }

                // Crea el nuevo componente
                control = Qt.createQmlObject(code, root, "control");
            }
        }
    }

    Lib.Card {
        width: parent.width
        height: parent.height



        Column {
            width:  parent.width - generalMargin - (miniIconsSize/2)
            height: parent.height - 20
            anchors.centerIn: parent
            spacing: 10

            Kirigami.Heading {
                id: name
                text: i18n("Brightness")
                font.weight: Font.DemiBold
                level: 5
                anchors.left: slider.left
                anchors.top: parent.top
                anchors.topMargin: Kirigami.Units.gridUnit /2
            }

            Slider {
                id: slider
                width: parent.width - Kirigami.Units.gridUnit
                height: 24
                //anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: ((parent.height - height)/2) + name.implicitHeight/2
                from: control.brightnessMin
                value: control.valueSlider
                to: control.maxSlider
                snapMode: Slider.SnapAlways
                enabled: mouseAreaActive
                onMoved: {
                    control.realValueSlider = value
                    value = value
                }
            }
        }

    }

}
