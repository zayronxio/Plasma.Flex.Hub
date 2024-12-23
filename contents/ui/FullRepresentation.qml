import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import "components" as Components

Item {
    id: menu

    property real spacing: 10
    property int cellWidth:  Kirigami.Units.gridUnit * 4
    property int cellHeight: cellWidth
    property int valueSlider: control.valueSlider
    property int maxSlider: control.maxSlider
    property int heightF: Kirigami.Units.gridUnit * 9

    Layout.preferredWidth: cellWidth*4 + spacing*5
    Layout.preferredHeight: heightF
    Layout.minimumWidth: cellWidth*4 + spacing*5
    Layout.maximumWidth: cellWidth*4 + spacing*5
    Layout.minimumHeight: Layout.preferredHeight
    Layout.maximumHeight: Layout.preferredHeight
    clip: true

    property var elements: Plasmoid.configuration.elements
    property var yElements: Plasmoid.configuration.yElements
    property var xElements: Plasmoid.configuration.xElements

    Model {
        id: itemsModel
    }

    ListModel {
        id: gridModel
    }



    Item {
        id: grid
        anchors.fill: parent

        Repeater {
            model: gridModel
            delegate: Loader {
                source: model.source
                onSourceChanged: {
                    if (status === Loader.Error) {
                        console.warn("Error loading source:", source);
                    } else {
                        console.log("Source updated to:", source);
                    }
                }
                onLoaded: {
                    width = cellWidth * model.widthFactor + spacing * (model.widthFactor - 1);
                    height = cellHeight * model.heightFactor + spacing * (model.heightFactor - 1);
                    x = model.x;
                    y = model.y;
                }
            }
        }
    }

    function createModel() {
        gridModel.clear();  // Clear the model before adding new items
        heightF = cellHeight + spacing*2
        for (var a = 0; a < elements.length; a++) {
            var element = itemsModel.get(elements[a]);
            gridModel.append({
                elementId: element.elementId,
                name: element.name,
                widthFactor: element.widthFactor,
                heightFactor: element.heightFactor,
                source: element.source,
                x: parseFloat(xElements[a]),  // Ensure this is a Number
                y: parseFloat(yElements[a])   // Ensure this is a Number
            });
            heightF = heightF < parseFloat(xElements[a]) + (element.heightFactor*cellHeight )+ (spacing*(element.heightFactor + 1)) ? parseFloat(xElements[a]) + (element.heightFactor*cellHeight )+ (spacing*(element.heightFactor + 1)) : heightF
        }
        //heightF = lastRow() + spacing
    }

    function lastRow() {
        var item = 0;
        var maxRow = 0;
        for (var m = 0; m < gridModel.count; m++) {
            if ((gridModel.get(m).x + ((heightFactor*40) + (heightFactor*spacing))) > maxRow) {
                maxRow = (gridModel.get(m).x + ((heightFactor*40) + (heightFactor*spacing)))
            }
        }
        return maxRow
    }
    onElementsChanged: {
         createModel();
         //heightF = lastRow() + spacing
    }

    Component.onCompleted: {
        //valueSlider = control.valueSlider
        createModel();
    }
}
