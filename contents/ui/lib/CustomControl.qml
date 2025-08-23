import QtQuick
//import "lib" as Lib

Item {
    id: root

    property bool mouseAreaActive:  false
    property bool bashExecutable:  true
    property bool isButton: false
    property bool isPercentage: false
    property bool indicator: false
    property bool isIndicator: false
    property bool isLarge: false
    property bool valueInLogo: false
    property string controlTitle: ""
    property string subTitle: ""
    property int controlValue: 0
    property var action: null
    property string icon: "configure"
    property var idSensor: null
    property string valueSensor
    property string exeCommand: ""
    property bool enabledIcon: true
    //property var urlLoader: isButton ? miniButton : isLarge ? buttonLarge : null

    Card {
        width: parent.width
        height: parent.height

        Loader {
            sourceComponent: isButton ? miniButton : isLarge ? buttonLarge : null
            width: parent.width
            height: parent.height
        }

        Loader {
            sourceComponent: !enabledIcon || (isLarge && idSensor) ? sensors : null
        }

        Component {
            id: miniButton
            MiniButton {
                width: parent.width
                height: parent.height
                title: enabledIcon ? controlTitle : root.valueSensor + (isPercentage ? "%" : "°C")
                itemIcon: icon
                isSensor: !enabledIcon
               // bigText: !enabledIcon ? root.valueSensor + (isPercentage ? "%" : "°C") : subTitle
                cmd: exeCommand
                bashExe: bashExecutable
                //onIconClicked: action
               // onIconClicked: bashExecutable ? exeCmd : undefined

            }
        }
        Component {
            id: buttonLarge
            ButtonLarge {
                width: parent.width
                height: parent.height
                itemIcon: icon
                title: controlTitle
                cmd: exeCommand
                bashExe: bashExecutable
                sub: idSensor ? root.valueSensor + (isPercentage ? "%" : "°C")  : subTitle
                onIconClicked: action
            }
        }
        Component {
            id: sensors
            SensorValue {
                id: sensor
                currentSensor: idSensor
                onValueChanged: {
                    console.log(value)
                    root.valueSensor = value
                }
            }
        }
    }

}
