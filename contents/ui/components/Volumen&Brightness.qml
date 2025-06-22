import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import "../lib" as Lib

Item {

   property bool mouseAreaActive:  false

   Lib.Card {
        width: parent.width
        height: parent.height
        globalBool: false

        SourceVolume {
            id: vol
        }

        Column {
            width:  parent.width - 20
            height: parent.height - 20
            anchors.centerIn: parent
            spacing: 10
            Row {
                width: parent.width
                height: parent.height/2

                Kirigami.Icon {
                    id: iconBrightness
                    width: 22//Kirigami.Units.iconSizes.mediumSmall
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
