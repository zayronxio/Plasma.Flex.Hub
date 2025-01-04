import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1.11
import Qt.labs.folderlistmodel
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as Plasma5Support

Item  {
    FolderListModel {
        id: folderThemesModel
        folder: Qt.resolvedUrl("../Themes")
    }
    property int currentIndex: 0
    property string nameNewTheme: ""
    property string pathScript:  Qt.resolvedUrl("code/themeGenerator.sh")
    property string folderThemeForBash: Qt.resolvedUrl("../Themes")
    property string pathThemeFolder: folderThemeForBash.replace("file://", '')
    property string subCommand: pathThemeFolder + " " + Plasmoid.configuration.elements + " " + Plasmoid.configuration.yElements + " " + Plasmoid.configuration.yElements

    Column {
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        spacing: 10
        Component.onCompleted: {
            console.log("Ruta resuelta:", subCommand);
        }

        ListView {
            id: carouselView
            width: parent.width
            height: parent.height*.75
            model: 5 // Número de elementos en el carrusel
            interactive: false
            currentIndex: currentIndex
            highlight: null
            orientation : Qt.Horizontal
            delegate: Rectangle {
                width: carouselView.width
                height: carouselView.height
                color: model.index % 2 === 0 ? "lightblue" : "lightcoral"
                radius: 10
                Text {
                    anchors.centerIn: parent
                    text: "Elemento " + (model.index + 1)
                    font.pixelSize: 24
                }
            }
        }

        Row {
            spacing: 10
            Button {
                text: "Anterior"
                enabled: carouselView.currentIndex > 0
                onClicked: carouselView.currentIndex--
            }
            Button {
                text: "Siguiente"
                enabled: currentIndex < carouselView.count - 1
                onClicked: carouselView.currentIndex++
            }
        }



        Dialog {
            id: dialog
            width: 400
            height: 150
            opacity: 1
            //color: "red"
            title: i18n("Save Your Theme")
            anchors.centerIn: parent
            //text: "¿Estás seguro de que deseas iniciar metaDateGenerator.detonator()?"
            standardButtons: Dialog.Cancel
            contentItem: Item {
                Row {
                    height: parent.height/2
                    Kirigami.Heading {
                        id: tx
                        text: i18n("Name: ")
                        height: parent.height
                        level: 4
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {
                        id: nameTheme
                        width: 250
                        anchors.verticalCenter: tx.verticalCenter
                        onTextChanged: {
                            nameNewTheme = nameTheme.text
                            var exists = false;
                            for (var i = 0; i < folderThemesModel.count; i++) {
                                var item = folderThemesModel.get(i, "fileName");
                                if (item === nameTheme.text) {
                                    exists = true;
                                    break;
                                }
                            }
                            dialog.standardButtons = exists || nameTheme.text === ""
                            ? Dialog.Cancel
                            : Dialog.Save | Dialog.Cancel;
                        }
                    }
                }

            }
            onAccepted: {
                executable.connectedSources = ("bash " + pathScript.replace("file://", '') + " " + subCommand + " " + nameNewTheme)
            }
        }

        Button {
            text: i18n("Save Theme")
            onClicked: {
                dialog.open()
            }
        }
        Plasma5Support.DataSource {
            id: executable
            engine: "executable"
            connectedSources: []
            onNewData: function(source, data) {
                disconnectSource(source)
            }
        }
    }
}
