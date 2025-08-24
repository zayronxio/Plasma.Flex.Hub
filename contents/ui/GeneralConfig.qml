import QtQuick
import QtQuick.Controls
import Qt.labs.platform
import QtQuick.Layouts 1.11
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as P5Support
import org.kde.kquickcontrols as KQControls
//import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: configRoot

    signal configurationChanged

    QtObject {
        id: keysConfig
        property var elements: []
        property var xElements: []
        property var yElements: []
    }
    QtObject {
        id: themes
        property string light: ""
        property string dark: ""
    }
    QtObject {
        id: valueGrids
        property string width: ""
        property string height: ""
    }

    QtObject {
        id:  customColor
        property color customColorValue
        property string currentNameColor
    }

    QtObject {
        id:  sizeIcons
        property var value
        property var margin
    }

    property alias cfg_elements: keysConfig.elements
    property alias cfg_yElements: keysConfig.yElements
    property alias cfg_xElements: keysConfig.xElements
    property alias cfg_darkTheme: themes.dark
    property alias cfg_lightTheme: themes.light

    property alias cfg_shadowOpacity: sliderShadowOpacity.value

    property alias cfg_gridWidth: valueGrids.width
    property alias cfg_gridHeight: valueGrids.height
    property alias cfg_currentNameColor: customColor.currentNameColor
    property alias cfg_enabledCustomColor: enabledCustomColor.checked
    property alias cfg_colorCards: customColor.customColorValue
    property alias cfg_coverByNetwork: downloadMissingCovers.checked

    property alias cfg_usePlasmaDesing: usePlasmaDesing.checked
    property alias cfg_customCardColor: customCardColor.color
    property alias cfg_opacityCardCustom: sliderOpacityCardCustom.value
    property alias cfg_radiusCardCustom: sliderRadiusCardCustom.value
    property alias cfg_sizeGeneralIcons: sizeIcons.value
    property alias cfg_sizeMarginlIcons: sizeIcons.margin
    property alias cfg_labelsToggles: txtMiniButtons.checked
     property alias cfg_usePlasmaColor: usePlasmaColor.checked
    ListModel {
        id: listModel
    }

    P5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []

        onNewData: {
            var exitCode = data["exit code"];
            var exitStatus = data["exit status"];
            var stdout = data["stdout"];
            var stderr = data["stderr"];
            exited(sourceName, exitCode, exitStatus, stdout, stderr);
            disconnectSource(sourceName);
        }

        function exec(cmd) {
            if (cmd) {
                connectSource(cmd);
            }
        }

        signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }

    Connections {
        target: executable
        onExited: {
            // Procesar stdout y agregarlo al modelo
            let lines = stdout.trim().split("\n");
            listModel.clear();
            for (let line of lines) {
                listModel.append({ value: line });
            }
            darkComboBox.currentIndex = determinateIndex(themes.dark)
            lightComboBox.currentIndex = determinateIndex(themes.light)
        }
    }
    function determinateIndex(nameTheme) {
        for (var a = 0; a < listModel.count; a++) {
            if (listModel.get(a).value === nameTheme) {
                return a;
            }
        }
        return -1;  // Si no se encuentra, retorna -1
    }

    Component.onCompleted: {

        executable.exec("plasma-apply-lookandfeel --list"); // Cambia "ls" por el comando que desees ejecutar
        currentIndex = indexOfValue(valueGrids.width)
    }

    ColorDialog {
        id: colorDialog
        color: customColor.customColorValue
        onAccepted: {
            customColor.customColorValue = color
        }
    }

    GridLayout {
        id: fist
        width: parent.width
        columns: 2
        Kirigami.Heading {
            text: i18n("Grid width:")
            Layout.minimumWidth: root.width/2
            horizontalAlignment: Label.AlignRight
            level: 5
        }
        ComboBox {
            textRole: "value"
            valueRole: "value"
            anchors.left: parent.left
            anchors.leftMargin: root.width/2
            id: gridWidth
            model:  [
                {value: 3},
                {value: 4},
                {value: 5},
                {value: 6}
            ]
            onActivated: valueGrids.width = currentValue
            Component.onCompleted: currentIndex = indexOfValue(valueGrids.width)
        }
        Kirigami.Heading {
            text: i18n("Grid Height:")
            Layout.minimumWidth: root.width/2
            horizontalAlignment: Label.AlignRight
            level: 5
        }
        ComboBox {
            textRole: "value"
            valueRole: "value"
            //width: 50
            anchors.left: parent.left
            anchors.leftMargin: root.width/2
            id: gridheight
            model:  [
                {value: 3},
                {value: 4},
                {value: 5},
                {value: 6}
            ]
            onActivated: valueGrids.height = currentValue
            Component.onCompleted: currentIndex = indexOfValue(valueGrids.height)
        }
        Label {
        }
        Label {
        }Label {
        }
        CheckBox {
            id: usePlasmaDesing
            anchors.left: left.right
            width: root.width/2
            text: i18n("Use Plasma Theme")
        }
        Label {
            visible: !usePlasmaDesing.checked
        }
        CheckBox {
            id: usePlasmaColor
            anchors.left: left.right
            visible: !usePlasmaDesing.checked
            width: root.width/2
            text: i18n("Use color of Plasma Theme")
        }
        Kirigami.Heading {
            visible: !usePlasmaDesing.checked
            text: i18n("Color of Cards and buttons:")
            Layout.minimumWidth: root.width/2
            enabled: !usePlasmaColor.checked
            horizontalAlignment: Label.AlignRight
            level: 5
        }
        KQControls.ColorButton {
            id: customCardColor
            visible: !usePlasmaDesing.checked
            enabled: !usePlasmaColor.checked
            Kirigami.FormData.label: i18n('Color:')
            showAlphaChannel: true
        }
        Kirigami.Heading {
            visible: !usePlasmaDesing.checked
            text: i18n("Opacity of Cards and buttons:")
            Layout.minimumWidth: root.width/2
            horizontalAlignment: Label.AlignRight
            level: 5
        }
        Slider {
            id: sliderOpacityCardCustom
            visible: !usePlasmaDesing.checked
            width: parent.width/4
            height: 24
            from: 1
            to: 100
            value: opacityCardCustom
            snapMode: Slider.SnapAlways
        }
        Kirigami.Heading {
            visible: !usePlasmaDesing.checked
            text: i18n("Radius of Cards and buttons:")
            Layout.minimumWidth: root.width/2
            horizontalAlignment: Label.AlignRight
            level: 5
        }
        Slider {
            visible: !usePlasmaDesing.checked
            id: sliderRadiusCardCustom
            width: parent.width/4
            height: 32
            from: 1
            value: radiusCardCustom
            to: Kirigami.Units.gridUnit * 2
            snapMode: Slider.SnapAlways
            onMoved: {
            }
        }
        Label {
        }
        CheckBox {
            id: txtMiniButtons
            anchors.left: left.right
            width: root.width/2
            text: i18n("Mini button/toggle labels")
        }
        Kirigami.Heading {
            text: i18n("Icons Size:")
            Layout.minimumWidth: root.width/2
            horizontalAlignment: Label.AlignRight
            level: 5
        }
        ComboBox {
            textRole: "text"
            valueRole: "value"
            Kirigami.FormData.label: i18n('Icons Size:')
            id: valueSizeIcons
            model: [
                {text: i18n("22"), value: 22},
                {text: i18n("24"), value: 24},
                {text: i18n("32"), value: 32},
                {text: i18n("42"), value: 42},
                {text: i18n("48"), value: 48},
                {text: i18n("64"), value: 64},

            ]
            onActivated: sizeIcons.value = currentValue
            Component.onCompleted: currentIndex = indexOfValue(sizeIcons.value)
        }
        Kirigami.Heading {
            text: i18n("Icon background margin:")
            Layout.minimumWidth: root.width/2
            horizontalAlignment: Label.AlignRight
            level: 5
        }
        ComboBox {
            textRole: "text"
            valueRole: "value"
            Kirigami.FormData.label: i18n('Icon background margi:')
            id: marginsIcons
            model: [
                {text: i18n("4"), value: 4},
                {text: i18n("8"), value: 8},
                {text: i18n("16"), value: 16},
                {text: i18n("20"), value: 20},
                {text: i18n("24"), value: 24},

            ]
            onActivated: sizeIcons.margin = currentValue
            Component.onCompleted: currentIndex = indexOfValue(sizeIcons.margin)
        }
        Kirigami.Heading {
            visible: usePlasmaDesing.checked
            id: txtShadowOpacity
            text: i18n("Shadow Opacity:")
            Layout.minimumWidth: root.width/2
            horizontalAlignment: Label.AlignRight
            level: 5
        }

        Slider {
            id: sliderShadowOpacity
            visible: usePlasmaDesing.checked
            width: parent.width/4
            height: 32
            //anchors.verticalCenter: parent.verticalCenter
            anchors.left: txtShadowOpacity.right
            //anchors.verticalCenter: iconBrightness.verticalCenter
            from: 1
            to: 10
            value: shadowOpacity
            snapMode: Slider.SnapAlways
            onMoved: {
                //value = value
                console.log(value/10, cfg_shadowOpacity)
            }
        }
        Label {
        }Label {
        }
        Label {

        }

        CheckBox {
            id: downloadMissingCovers
            anchors.left: left.right
            width: root.width/2
            text: i18n("Download missing album covers")
        }

        Label {
            id: left
            width: root.width/2
        }
        CheckBox {
            id: enabledCustomColor
            width: root.width/2
            anchors.left: left.right
            text: i18n('Colorizer The Controls')
            Layout.columnSpan: 2
        }
        Kirigami.Heading {
            id: txtCardColor
            visible: enabledCustomColor.checked
            text: i18n("controls Color:")
            Layout.minimumWidth: root.width/2
            horizontalAlignment: Label.AlignRight
            level: 5
        }

        ComboBox {
            id: listColors
            textRole: "name"
            valueRole: "value"
            //width: 50
            visible: enabledCustomColor.checked
            anchors.left: parent.left
            anchors.leftMargin: root.width / 2
            model: [
                { name: "Negative", value: Kirigami.Theme.negativeTextColor },
                { name: "Neutral", value: Kirigami.Theme.neutralTextColor },
                { name: "Positive", value: Kirigami.Theme.positiveTextColor },
                { name: "Visited", value: Kirigami.Theme.visitedTextColor },
                { name: "Custom", value: colorDialog.color || "#000" }
            ]
            onActivated: {
                customColor.customColorValue = currentValue
                customColor.currentNameColor = currentText
                listColors.displayText = currentText
            }
            Component.onCompleted: {

                listColors.displayText = customColor.currentNameColor

                for (var y = 0; y < model.length; y++) {
                    if (model[y].name === customColor.currentNameColor) {
                        listColors.currentIndex = y
                        console.log(listColors.currentIndex, y)
                        break
                    }
                }
            }
        }
        Kirigami.Heading {
            text: i18n("It is not recommended to use Custom Color, in favor of the overall design.")
            visible: enabledCustomColor.checked
            Layout.minimumWidth: root.width - 1
            horizontalAlignment: Text.AlignHCenter
            opacity: 0.5
            level: 5
        }
        Label {
        }
        Label {
        }
        Label {
        }
        Kirigami.Heading {
            id: txt
            text: i18n("Custom Color:")
            Layout.minimumWidth: root.width/2
            horizontalAlignment: Text.AlignRight
            visible: enabledCustomColor.checked && listColors.currentText === "Custom"
            level: 5
        }

        Rectangle {
            id: colorhex
            color: colorDialog.color
            border.color: "#B3FFFFFF"
            border.width: 1
            anchors.left: txt.right
            visible: txt.visible
            width: 64
            radius: 4
            height: 24
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    colorDialog.open()
                }
            }
        }

        Label {
        }
        Label {
        }


    }
    Kirigami.AbstractCard {
        height: Kirigami.Units.gridUnit * 8
        width: root.width /2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: fist.bottom
        anchors.topMargin: Kirigami.Units.mediumSpacing
        header: Kirigami.Heading {
            text: i18n("Seleccted Global Theme's")
             horizontalAlignment: Text.AlignHCenter
            level: 5
        }
        contentItem: Item {
            Column {
                anchors.centerIn: parent
                height: r.implicitHeight + g.implicitHeight
                Row {
                    id:r
                    height: parent.height/2
                    Kirigami.Heading {
                        text: "Dark"
                        height: parent.height
                        level: 5
                        verticalAlignment: Text.AlignVCenter
                    }
                    ComboBox {
                        id: darkComboBox
                        width: 150
                        model: listModel
                        onActivated: themes.dark = currentValue
                        Component.onCompleted: currentIndex = indexOfValue(themes.dark)
                    }
                }
                Row {
                    id: g
                    height: parent.height/2
                    Kirigami.Heading {
                        text: "Light"
                        height: parent.height
                        level: 5
                        verticalAlignment: Text.AlignVCenter
                    }
                    ComboBox {
                        id: lightComboBox
                        width: 150
                        model: listModel
                        onActivated: themes.light = currentValue
                        Component.onCompleted: currentIndex = indexOfValue(themes.light)
                    }
                }
            }
        }
    }
}
