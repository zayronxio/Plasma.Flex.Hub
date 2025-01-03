import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1.11
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as P5Support

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

    property alias cfg_elements: keysConfig.elements
    property alias cfg_yElements: keysConfig.yElements
    property alias cfg_xElements: keysConfig.xElements
    property alias cfg_darkTheme: themes.dark
    property alias cfg_lightTheme: themes.light

    property alias cfg_gridWidth: valueGrids.width
    property alias cfg_gridHeight: valueGrids.height

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
            level: 4
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
            level: 4
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
            level: 4
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
                        level: 4
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
                        level: 4
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
