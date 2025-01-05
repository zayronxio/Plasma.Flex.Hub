import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1.11
import Qt.labs.folderlistmodel
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as Plasma5Support
import QtQuick.LocalStorage

Item  {

    QtObject {
        id: themes
        property var namesSkins: []
        property var combined_index: []
        property var combined_x: []
        property var combined_y: []
        property string theme_current: ""
    }

    property alias cfg_names_themes: themes.namesSkins
    property alias cfg_index_themes: themes.combined_index
    property alias cfg_seriesX_themes: themes.combined_x
    property alias cfg_seriesY_themes: themes.combined_y
    property alias cfg_selected_theme: themes.theme_current

    property int currentIndex: 0

    property string nameNewTheme: ""
    property string folderTheme: Qt.resolvedUrl("../Themes")


    ListModel {
        id: layoutsSkins
    }

    function createArray(list) {
        let array = [], n_arrays = 0;

        function added(element) {
            array[n_arrays] = array[n_arrays] || [];
            var elementt = element.includes("[") ? element.replace("[", '') : element
            array[n_arrays].push(parseInt(elementt.replace(/^\s+|\s+$/g, '')));
        }

        list.forEach(item => {
            if (item[0] + item[1] === "[ ") {
                added(item.replace("[ [", ''));
            } else if (item[item.length - 1] === "]") {
                added(item.replace("]", ''));
                n_arrays++;
            } else if (item[0] === "[" || item[1] === "[") {
                added(item.replace("[", ''));
            } else if (item !== "]") {
                added(item);
            }
        });

        return array;
    }

    function added(list, element) {
        var newList = []
        newList = list
        newList.push("["+element[0])
        for (var i = 1; i < element.length; i++) {
            if (i === element.length -1) {
                newList.push(element[i] + "]")
            } else {
                newList.push(element[i])
            }
        }
        return createArray(newList)// Devuelve la lista modificada
    }
    function createModel_themes(){
        console.log("creado model")
        layoutsSkins.clear()
        var current = Infinity // "unk"

        //console.log(themes.combined_index, "numerod e elemt", createArray(themes.combined_index), themes.namesSkins.length)
        for (var j =0; j < themes.namesSkins.length; j++) {
            const combined_index = createArray(themes.combined_index)[j].join()
            const combined_x = createArray(themes.combined_x)[j].join()
            const combined_y = createArray(themes.combined_y)[j].join()
            const namesSkins = themes.namesSkins[j]

            if (combined_index === Plasmoid.configuration.elements.join() && combined_x === Plasmoid.configuration.xElements.join() && combined_y === Plasmoid.configuration.yElements.join()) {
                current = j //the current layout was identified
            }

            layoutsSkins.append({
                series_index: combined_index,
                series_x: combined_x,
                series_y: combined_y,
                name: namesSkins
            });
        }

        if (current !== Infinity){
            // The index is established based on the current layout
            carouselView.currentIndex = current
            themes.theme_current = layoutsSkins.get(current).name
        } else {
            // A custom theme is added by the user, it can be saved if the user decides so
            layoutsSkins.append({
                series_index: 0,
                series_x: 0,
                series_y: 0,
                name: i18n("Custom")
            });
            carouselView.currentIndex = (layoutsSkins.count - 1)
            themes.theme_current = i18n("Custom")
        }
    }

    function saveConfigs(name, xs, ys, ids) {
        themes.namesSkins.push(name)
        added(themes.combined_y,ys)
        added(themes.combined_x,xs)
        added(themes.combined_index,ids)
        /*/
        var indexDelate = 0
        for (var u = 0; u < layoutsSkins.count; u++){
            if (layoutsSkins.get(u).name === i18n("Custom")) {
                layoutsSkins.remove(indexDelate)
            }
        }/*/
        createModel_themes()
    }

    Component.onCompleted: {
        /*/
        themes.namesSkins = []
        themes.combined_index = []
        themes.combined_x = []
        themes.combined_y = []
        console.log(themes.namesSkins, "a borrar")
        Plasmoid.configuration.names_themes = themes.namesSkins
        Plasmoid.configuration.index_themes = themes.combined_index
        Plasmoid.configuration.seriesX_themes = themes.combined_x
        Plasmoid.configuration.seriesY_themes = themes.combined_y
        /*/
        createModel_themes()
    }


    Column {
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        spacing: 10
        ListView {
            id: carouselView
            width: parent.width
            height: parent.height*.75
            model: layoutsSkins // Número de elementos en el carrusel
            interactive: false
            currentIndex: 0
            highlight: null
            orientation : Qt.Horizontal
            delegate: Rectangle {
                width: carouselView.width
                height: carouselView.height
                color: "lightblue"// model.index % 2 === 0 ? "lightblue" : "lightcoral"
                radius: 10
                Text {
                    anchors.centerIn: parent
                    text: model.name//layoutsSkins.get(1).x //"Elemento " + (model.index + 1)
                    font.pixelSize: 24
                }
            }
        }
        Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                text: i18n("Activate")
                enabled: layoutsSkins.get(carouselView.currentIndex).name !== themes.theme_current
                onClicked: {
                    Plasmoid.configuration.elements = layoutsSkins.get(carouselView.currentIndex).series_index.split(",");
                    Plasmoid.configuration.yElements = layoutsSkins.get(carouselView.currentIndex).series_y.split(",");
                    Plasmoid.configuration.xElements = layoutsSkins.get(carouselView.currentIndex).series_x.split(",");
                }
            }
            Button {
                text: "<"
                enabled: carouselView.currentIndex > 0
                onClicked: carouselView.currentIndex--
            }
            Button {
                text: ">"
                enabled: carouselView.currentIndex < carouselView.model.count - 1
                onClicked: carouselView.currentIndex++
            }
            Button {
                text: i18n("Save Theme")
                enabled: themes.theme_current === i18n("Custom")
                onClicked: {
                    dialog.open()
                }
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
                    width:parent.width
                    height: parent.height/2
                    Kirigami.Heading {
                        id: tx
                        text: i18n("Name: ")
                        width: parent.width/2
                        height: parent.height
                        level: 4
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {
                        id: nameTheme
                        width: parent.width*.4
                        anchors.verticalCenter: tx.verticalCenter
                        onTextChanged: {
                            nameNewTheme = nameTheme.text
                            var exists = false;
                            for (var i = 0; i < layoutsSkins.count; i++) {
                                var item = layoutsSkins.get(i).name;
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
                saveConfigs(nameNewTheme, Plasmoid.configuration.xElements,  Plasmoid.configuration.yElements, Plasmoid.configuration.elements )
                //executable.connectedSources = ("bash " + pathScript.replace("file://", '') + " " + subCommand + " " + nameNewTheme)
            }
        }


    }
}
