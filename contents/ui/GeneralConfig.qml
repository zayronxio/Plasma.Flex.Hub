import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1.11
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as P5Support
import org.kde.plasma.core 2.0 as PlasmaCore

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
        property color customColorValue: "#000000"
    }

    property alias cfg_elements: keysConfig.elements
    property alias cfg_yElements: keysConfig.yElements
    property alias cfg_xElements: keysConfig.xElements
    property alias cfg_darkTheme: themes.dark
    property alias cfg_lightTheme: themes.light

    property alias cfg_shadowOpacity: sliderShadowOpacity.value

    property alias cfg_gridWidth: valueGrids.width
    property alias cfg_gridHeight: valueGrids.height
    property alias cfg_enabledCustomColor: enabledCustomColor.checked
    property alias cfg_colorCards: customColor.customColorValue


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

        Kirigami.Heading {
            id: txtShadowOpacity
            text: i18n("Shadow Opacity:")
            Layout.minimumWidth: root.width/2
            horizontalAlignment: Label.AlignRight
            level: 5
        }

        Slider {
            id: sliderShadowOpacity
            width: parent.width/4
            height: 24
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
            anchors.leftMargin: root.width/2
            model:  [
                {name: "Negative", value: Kirigami.Theme.negativeTextColor},
                {name: "Neutral", value: Kirigami.Theme.neutralTextColor},
                {name: "Positive", value: Kirigami.Theme.positiveTextColor},
                {name: "Visited", value: Kirigami.Theme.visitedTextColor},
                {name: "Custom", value: colorAssigned.Text}
            ]
            onActivated: {
                console.log("clocjk", currentValue)
                customColor.customColorValue = currentValue
                console.log("clocjk", currentValue, Plasmoid.condfiguration.colorCards)

            }
            Component.onCompleted: currentIndex = indexOfValue(customColor.customColorValue)
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
            visible: enabledCustomColor.checked
            level: 5
        }
        TextField {
            id: colorAssigned
            anchors.left: txt.right
            visible: enabledCustomColor.checked
            placeholderText: qsTr("e.g. #ffff7e")
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
