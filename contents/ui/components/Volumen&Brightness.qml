import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors
import "../lib" as Lib

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
        globalBool: false

        SourceVolume {
            id: vol
        }

        Column {
            width:  parent.width - generalMargin - (miniIconsSize/2)
            height: parent.height - 20
            anchors.centerIn: parent
            spacing: 10
            Row {
                width: parent.width
                height: parent.height/2

                Kirigami.Icon {
                    id: iconBrightness
                    width: miniIconsSize//Kirigami.Units.iconSizes.mediumSmall
                    height: width
                    source: "brightness-high-symbolic"
                }

                Slider {
                    id: slider
                    width: parent.width - iconBrightness.width
                    height: 24
                    //anchors.verticalCenter: parent.verticalCenter
                    //anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: iconBrightness.verticalCenter
                    from: control.brightnessMin
                    value: control.valueSlider
                    to: control.maxSlider
                    snapMode: Slider.SnapAlways
                    enabled: mouseAreaActive
                    onMoved: {
                        console.log(control.realValueSlider)
                        control.realValueSlider = value
                    }
                }


            }
            Row {
                width: parent.width
                height: parent.height/2

                Kirigami.Icon {
                    id: iconVolume
                    width: 22 //Kirigami.Units.iconSizes.mediumSmall
                    height: width
                    source: "audio-volume-high"
                }

                Slider {
                    id: sliderVolumen
                    width: parent.width - iconBrightness.width
                    height: 24
                    //anchors.verticalCenter: parent.verticalCenter
                    //anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: iconVolume.verticalCenter
                    from: 0
                    value: vol.sliderValue
                    to: 100
                    snapMode: Slider.SnapAlways
                    enabled: mouseAreaActive
                    //stepSize: 5
                    onMoved: {
                        vol.sink.volume = value * vol.normalVolume / 100
                    }
                }
            }

        }

    }

}
