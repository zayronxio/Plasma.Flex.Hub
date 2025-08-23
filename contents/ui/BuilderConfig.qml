import QtQuick
import QtQuick.Controls
import "js/utils.js" as Utils
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import "lib" as Lib
import org.kde.iconthemes as KIconThemes
import "components" as Components

Item {
    id: root

    QtObject {
        id: configParameters
        property var controlNames
        property var controlWidths
        property var controlHeights
        property var controlIcons
        property var controlEnabledIcons
        property var controlIdSensor
        property var controlSubTitle
        property var controlEnabledButton
        property var controlIsPercentage
        property var controlCommand
    }

    property alias cfg_customControlNames: configParameters.controlNames
    property alias cfg_customControlWidths: configParameters.controlWidths
    property alias cfg_customControlHeights: configParameters.controlHeights
    property alias cfg_customControlIcons: configParameters.controlIcons
    property alias cfg_customControlEnabledIcons: configParameters.controlEnabledIcons
    property alias cfg_customControlIdSensor: configParameters.controlIdSensor
    property alias cfg_customControlSubTitle: configParameters.controlSubTitle
    property alias cfg_customControlEnabledButton: configParameters.controlEnabledButton
    property alias cfg_customControlIsPercentage: configParameters.controlIsPercentage
    property alias cfg_customControlCommand: configParameters.controlCommand

    QtObject {
        id: iconObj
        property string name
    }

    property var controlSize: ["1x1", "1x2"]
    property var systemIndicators: ["temperature", "Usage percentage"]
    property bool addmenuVisible: false
    property string nameSensor
    property string idSensor

    // Properties for builder
    property bool enabledIcon: !type.checked ? true : size.currentValue === "1x2"
    property string itemIcon: iconObj.name ? iconObj.name : "null"
    property string itemCommand: commandExe.text ? commandExe.text : "null"
    property var itemSensor: type.checked ? idSensor : "null"
    property string itemSubTitle: subtitleText.text ? subtitleText.text : "null"
    property bool isPercentage: percentage.checked
    property string itemTitle: nameControlTxt.text
    property bool itemButton: size.currentValue === "1x1"
    property int itemWidth: size.currentValue === "1x2" ? 2 : 1
    property int itemHeight: 1
    property string itemName: itemTitle

    function isValidName(name) {
        // Verifica si el nombre ya existe en el array
        if (configParameters.controlNames.indexOf(name) !== -1) {
            return false;
        }

        // Verifica si el nombre contiene caracteres especiales o comas
        const invalidChars = /[^a-zA-Z0-9 ]/;
        if (invalidChars.test(name)) {
            return false;
        }

        return true;
    }

    function createModel() {
        controls.clear()
        for (var j = 0; j < configParameters.controlNames.length; j++) {
            controls.append({
                name: configParameters.controlNames[j],
                controlWidth: configParameters.controlWidths[j],
                controlHeight: configParameters.controlHeights[j],
                icon: configParameters.controlIcons[j],
                controlenabledIcon: configParameters.controlEnabledIcons[j],
                controlIdSensor: configParameters.controlIdSensor[j],
                controlSubtitle: configParameters.controlSubTitle[j],
                controlEnabeldButton: configParameters.controlEnabledButton[j],
                controlIsPercentage: configParameters.controlIsPercentage[j],
                controlCommand: configParameters.controlCommand[j]
            });
        }
        controls.append({
            name: "add",
            controlWidth: "null",
            controlHeight: "null",
            icon: "null",
            controlenabledIcon: "null",
            controlIdSensor: "null",
            controlSubtitle: "null",
            controlEnabeldButton: "null",
            controlIsPercentage: "null",
            controlCommand: "null"
        });
    }

    ListModel {
        id: controls
    }

    Column {
        id: listControls
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        width: Kirigami.Units.gridUnit * 10
        height: parent.width
        visible: !form.visible
        spacing: Kirigami.Units.largeSpacing * 2

        Repeater {
            model: controls
            width: parent.width
            height: Kirigami.Units.gridUnit * 2
            delegate: Item {
                width: Kirigami.Units.gridUnit * 10
                height: Kirigami.Units.gridUnit * 2

                Rectangle {
                    width: Kirigami.Units.gridUnit * 10
                    height: Kirigami.Units.gridUnit * 2
                    anchors.centerIn: parent
                    color: "black"
                    opacity: 0.5
                    radius: Kirigami.Units.cornerRadius
                    border.width: 1
                    border.color: "white"
                }

                Row {
                    width: parent.width - Kirigami.Units.largeSpacing
                    height: parent.height
                    anchors.centerIn: parent
                    spacing: Text.AlignHCenter

                    Kirigami.Icon {
                        width: 22
                        height: 22
                        anchors.verticalCenter: parent.verticalCenter
                        source: model.icon
                        visible: model.name !== "add"
                    }

                    Kirigami.Heading {
                        width: model.name === "add" ? parent.width - parent.spacing : parent.width - parent.spacing - 22
                        height: parent.height
                        horizontalAlignment: model.name === "add" ? Text.AlignHCenter : Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        text: model.name === "add" ? "+" : model.name
                        level: model.name === "add" ? 3 : 5
                    }
                }

                Rectangle {
                    width: 24
                    height: 24
                    anchors.right: parent.right
                    anchors.rightMargin: -height / 3
                    anchors.top: parent.top
                    anchors.topMargin: -width / 3
                    visible: model.name !== "add"
                    radius: height / 2
                    color: Kirigami.Theme.negativeTextColor

                    Rectangle {
                        width: 12
                        height: 4
                        anchors.centerIn: parent
                        color: "white"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            configParameters.controlNames.splice(index, 1)
                            configParameters.controlWidths.splice(index, 1)
                            configParameters.controlHeights.splice(index, 1)
                            configParameters.controlIcons.splice(index, 1)
                            configParameters.controlEnabledIcons.splice(index, 1)
                            configParameters.controlIdSensor.splice(index, 1)
                            configParameters.controlSubTitle.splice(index, 1)
                            configParameters.controlEnabledButton.splice(index, 1)
                            configParameters.controlIsPercentage.splice(index, 1)
                            configParameters.controlCommand.splice(index, 1)
                            createModel()
                        }
                    }
                }

                MouseArea {
                    enabled: model.name === "add"
                    anchors.fill: parent
                    onClicked: {
                        form.visible = true
                    }
                }
            }
        }
    }

    KIconThemes.IconDialog {
        id: iconDialog
        property var iconObj
        onIconNameChanged: iconObj.name = iconName
    }

    Lib.CustomControl {
        id: demo
        width: itemWidth * Kirigami.Units.gridUnit * 4
        height: itemHeight * Kirigami.Units.gridUnit * 4
        anchors.horizontalCenter: parent.horizontalCenter
        isButton: itemButton
        isLarge: !itemButton
        visible: form.visible
        icon: itemIcon === "null" ? "configure" : itemIcon
        controlTitle: nameControlTxt.text ? nameControlTxt.text : "Title Demo"
        subTitle: size.currentValue === "1x1" && !type.checked ? "" : percentage.checked ? "26%" : temperature.checked ? "64°C" : type.checked ? "" : "Subtitle Demo"
    }

    Kirigami.FormLayout {
        id: form
        anchors.top: demo.bottom
        visible: addmenuVisible
        width: parent.width

        ComboBox {
            id: size
            Kirigami.FormData.label: i18n("Size:")
            model: controlSize
            onActivated: {
                widthControl = (size.currentText === "1x1") ? 1 : 2
                heightControl = 1
            }
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        TextField {
            id: nameControlTxt
            Kirigami.FormData.label: i18n("General:")
            placeholderText: i18n("Title")
        }

        TextField {
            id: subtitleText
            visible: !type.checked && !itemButton
            placeholderText: i18n("e.g. Subtitle")
            onVisibleChanged: {
                if (!visible) {
                    subtitleText.text = ""
                }
            }
        }

        CheckBox {
            id: type
            text: i18n("System indicator")
            onCheckedChanged: {
                if (!checked) {
                    percentage.checked = false
                    temperature.checked = false
                }
            }
        }

        CheckBox {
            id: temperature
            visible: type.checked
            text: i18n("Temperature")
            onCheckedChanged: {
                if (checked) {
                    percentage.checked = false
                    nameSensor = null
                    idSensor = null
                }
            }
        }

        CheckBox {
            id: percentage
            visible: type.checked
            text: i18n("Usage percentage")
            onCheckedChanged: {
                if (checked) {
                    temperature.checked = false
                    nameSensor = null
                    idSensor = null
                }
            }
        }

        Button {
            text: nameSensor || "select sensor"
            visible: percentage.checked || temperature.checked
            onClicked: {
                addSensorDialog.open()
            }
        }

        Lib.AddSensorDialog {
            id: addSensorDialog
            sensorType: percentage.checked ? 1 : 0
            width: parent.width * 0.8
            height: Math.min(implicitHeight, parent.height * .6 - Kirigami.Units.gridUnit * 2)
            onAddedSensor: (name, sensorId) => {
                nameSensor = name
                idSensor = sensorId
                addSensorDialog.close()
            }
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        Button {
            id: mainIconName
            //enabled: size.currentValue === "1x2" || !type.checked
            Kirigami.FormData.label: i18n("Icon:")
            icon.width: Kirigami.Units.iconSizes.large
            icon.height: icon.width
            onClicked: {
                iconDialog.open()
                iconDialog.iconObj = mainIconName.icon
            }

            Kirigami.Icon {
                width: parent.width
                height: parent.height
                visible: parent.enabled
                source: iconObj.name
            }
        }

        TextField {
            id: commandExe
            Kirigami.FormData.label: i18n("Command. optional")
            placeholderText: i18n("e.g. lsb_release -d")
        }
    }

    Row {
        anchors.top: form.bottom
        anchors.topMargin: Kirigami.Units.largeSpacing
        spacing: Kirigami.Units.largeSpacing * 2
        anchors.horizontalCenter: form.horizontalCenter
        visible: form.visible

        Button {
            text: i18n("Save")
            enabled: isValidName(itemName) && (
                (!type.checked && itemName && iconObj.name && itemButton) ||
                (type.checked && itemName && idSensor) ||
                (!itemButton && !type.checked && itemName && iconObj.name && subtitleText.text)
            )
            onClicked: {
                configParameters.controlNames.push(itemName)
                configParameters.controlWidths.push(itemWidth)
                configParameters.controlHeights.push(itemHeight)
                configParameters.controlIcons.push(itemIcon)
                configParameters.controlEnabledIcons.push(enabledIcon)
                configParameters.controlIdSensor.push(itemSensor)
                configParameters.controlSubTitle.push(itemSubTitle)
                configParameters.controlEnabledButton.push(itemButton)
                configParameters.controlIsPercentage.push(isPercentage)
                configParameters.controlCommand.push(itemCommand)
                createModel()
                form.visible = false
            }
        }

        Button {
            text: i18n("Cancel")
            onClicked: {
                form.visible = false
            }
        }
    }

    Component.onCompleted: createModel()
}
