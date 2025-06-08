import QtQuick
import QtQuick.Controls
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

Item  {

    property alias cfg_names_themes: themes.namesSkins
    property alias cfg_index_themes: themes.combined_index
    property alias cfg_seriesX_themes: themes.combined_x
    property alias cfg_seriesY_themes: themes.combined_y
    property alias cfg_selected_theme: themes.theme_current

    property string nameNewTheme: ""

    QtObject {
        id: themes
        property var namesSkins: []
        property var combined_index: []
        property var combined_x: []
        property var combined_y: []
        property string theme_current: ""
    }

    Model {
        id: rootModel
    }

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
        layoutsSkins.clear() // The model is cleaned before creating another, useful especially when adding new layouts
        var current = Infinity // "unk"

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

        createModel_themes()
    }

    Component.onCompleted: {
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
            model: layoutsSkins
            interactive: false
            currentIndex: 0
            highlight: null
            orientation : Qt.Horizontal

            delegate: Rectangle {
                width: carouselView.width
                height: carouselView.height
                color: "transparent"// model.index % 2 === 0 ? "lightblue" : "lightcoral"
                radius: 10


                Item {
                    width: card.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    Kirigami.AbstractCard {
                        id: card
                        height: ((contentItem.rows * (Kirigami.Units.gridUnit * 3)) + (Kirigami.Units.gridUnit/2) * (contentItem.rows-1)) + Kirigami.Units.gridUnit *2
                        width: (Kirigami.Units.gridUnit * 12) + Kirigami.Units.gridUnit *3.5


                        contentItem: Item {
                            property int rows: 0
                            property var ind: []// model.series_index.split(",")
                            property var xs: [] //model.series_x.split(",")
                            property var ys: [] //model.series_x.split(",")

                            ListModel {
                                id: rectangleData
                            }

                            Component.onCompleted: {
                                ind = model.series_index.split(",")
                                xs = model.series_x.split(",")
                                ys = model.series_y.split(",")

                                for (var g = 0; g < ind.length; g++){

                                    rectangleData.append({
                                        nameRec: rootModel.get(ind[g]).name,
                                        width: ((rootModel.get(ind[g]).w) * (Kirigami.Units.gridUnit * 3)) + (Kirigami.Units.gridUnit/2) * ((rootModel.get(ind[g]).w)-1),
                                        height: ((rootModel.get(ind[g]).h) * (Kirigami.Units.gridUnit * 3)) + (Kirigami.Units.gridUnit/2) * ((rootModel.get(ind[g]).h)-1),
                                        x: parseInt(xs[g]),
                                        y: parseInt(ys[g]),
                                    });
                                    rows = Math.max(rows, parseInt(ys[g]) + (rootModel.get(ind[g]).h));
                                }
                            }
                            Repeater {
                                model: rectangleData
                                delegate: Item {
                                    width: model.width
                                    height: model.height
                                    x: model.x * (Kirigami.Units.gridUnit * 3) + (Kirigami.Units.gridUnit/2) + (Kirigami.Units.gridUnit/2) * model.x
                                    y: model.y * (Kirigami.Units.gridUnit * 3) + (Kirigami.Units.gridUnit/2) + (Kirigami.Units.gridUnit/2) * model.y

                                    Rectangle {
                                        anchors.fill: parent
                                        anchors.centerIn: parent
                                        color: Kirigami.Theme.textColor
                                        radius: 12
                                        opacity: 0.7
                                    }
                                    Kirigami.Heading {
                                        text: model.nameRec
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: model.width
                                        level: 5
                                        color: Kirigami.Theme.background
                                        wrapMode: Text.Wrap
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }
                            }
                        }
                    }
                }

                Kirigami.Heading  {
                    font.weight: Font.DemiBold
                    style: Text.Outline;
                    styleColor: "#AAAAAA"
                    anchors.centerIn: parent
                    text: model.name
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
                    Plasmoid.configuration.selected_theme = layoutsSkins.get(carouselView.currentIndex).name //forza la actulizacion
                    themes.theme_current = layoutsSkins.get(carouselView.currentIndex).name
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
            title: i18n("Save Your Theme")
            anchors.centerIn: parent
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
            }
        }


    }
}
