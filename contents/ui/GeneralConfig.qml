import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import org.kde.kirigami as Kirigami

Item {
    id: configRoot

    signal configurationChanged

    property real spacing: 10
    property int cellWidth: 40
    property int cellHeight: cellWidth
    property int cellWidthFilled: 0
    property int rowsFilled: 0
    property int widthAveilable: 4

    ListModel {
        id: namesModel
        // Initial model with valid IDs
        ListElement { elementId: "item1"; name: "Music Card 2x2"; widthFactor: 2; heightFactor: 2 }
        ListElement { elementId: "item2"; name: "Music Card 1x4"; widthFactor: 4; heightFactor: 1 }
        ListElement { elementId: "item3"; name: "Connections and Quick Settings 2x2"; widthFactor: 2; heightFactor: 4 }
        ListElement { elementId: "item4"; name: "Volume Slider 1x2"; widthFactor: 2; heightFactor: 1 }
        ListElement { elementId: "item5"; name: "Toggle 1x1"; widthFactor: 1; heightFactor: 1 }
    }

    ListModel {
        id: gridModel
    }

    // Determine attributes for the last row based on specific criteria
    function lastRowDeterminate(f) {
        var min = Infinity;

        for (var e = 0; e < gridModel.count; e++) {
            if (gridModel.get(e).lastRow < min && gridModel.get(e).lastRow > rowsFilled) {
                min = gridModel.get(e).lastRow;
            }
        }

        if (f === "wAveilable") {
            var max_items = [];
            for (var u = 0; u < gridModel.count; u++) {
                var valueMin = Infinity;
                if (gridModel.get(u).lastRow > valueMin) {
                    max_items.push(u);
                }
            }
            if (max_items.length > 0) {
                var value = Infinity;
                for (var x = 0; x < max_items.length; x++) {
                    if (gridModel.get(max_items[x]).x < value) {
                        value = gridModel.get(max_items[x]).x;
                    }
                }
                return Math.floor(value / (cellWidth + spacing));
            } else {
                return 4;
            }
        }

        if (f === "last") {
            return min;
        }
    }

    // Compute symmetric difference between filled and total spaces
    function symmetricDifference(array1) {
        let set1 = new Set(array1);
        let array2 = [0, 1, 2, 3];
        let set2 = new Set(array2);

        return Array.from(new Set([
            ...Array.from(set1).filter(item => !set2.has(item)),
                                  ...Array.from(set2).filter(item => !set1.has(item))
        ]));
    }

    // Calculate available x position for the next element
    function setx() {
        var items = [];
        var plusrows = fucss(rowsFilled + 1) === 4 ? 2 : 1;

        for (var i = 0; i < gridModel.count; i++) {
            if (gridModel.get(i).lastRow >= rowsFilled + plusrows) {
                if (gridModel.get(i).widthFactor > 1) {
                    for (var p = 0; p < gridModel.get(i).widthFactor; p++) {
                        items.push(((gridModel.get(i).x) - spacing) / (cellWidth + spacing) + p);
                    }
                } else {
                    items.push(((gridModel.get(i).x) - spacing) / (cellWidth + spacing));
                }
            }
        }
        return Math.min(...symmetricDifference(items));
    }

    // Count filled cells in the given row
    function fucss(line) {
        var value = 0;
        for (var h = 0; h < gridModel.count; h++) {
            if (gridModel.get(h).lastRow >= line) {
                value += gridModel.get(h).widthFactor;
            }
        }
        return value;
    }

    // Find the next row with enough free space for the new element
    function nextRowFree(w) {
        var maxRow = 0;
        var lastRow = 0;
        var found = false;

        for (var m = 0; m < gridModel.count; m++) {
            if (gridModel.get(m).lastRow > maxRow) {
                maxRow = gridModel.get(m).lastRow;
            }
        }

        for (var f = rowsFilled; f < maxRow; f++) {
            if (fucss(f + 1) < 4) {
                lastRow = f;
                found = true;
                break;
            }
        }
        return found ? lastRow : rowsFilled + w;
    }

    GridLayout {
        columns: 2

        Rectangle {
            id: base
            color: Kirigami.Theme.textColor
            width: (cellWidth * 4) + spacing * 5
            radius: 12
            opacity: 0.4
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: configRoot.width * 0.05
            height: grid.implicitHeight || 100

            Item {
                id: grid
                anchors.fill: parent

                Repeater {
                    model: gridModel
                    delegate: Rectangle {
                        width: cellWidth * model.widthFactor + spacing * (model.widthFactor - 1)
                        height: cellHeight * model.heightFactor + spacing * (model.heightFactor - 1)
                        color: model.color || "lightblue"
                        radius: 10
                        border.color: "black"
                        border.width: 2
                        x: model.x
                        y: model.y
                    }
                }
            }
        }

        ListView {
            id: listview
            model: namesModel
            width: base.width
            height: namesModel.count * 40
            anchors.left: parent.left
            anchors.leftMargin: configRoot.width / 2

            delegate: Item {
                width: parent.width
                height: 40

                RowLayout {
                    anchors.fill: parent

                    Text {
                        text: model.name
                        Layout.fillWidth: true
                    }

                    MouseArea {
                        id: dragSource
                        anchors.fill: parent
                        drag.target: dragSource

                        onClicked: {

                            function added(varx, vary) {
                                gridModel.append({
                                    elementId: model.elementId,
                                    name: model.name,
                                    widthFactor: model.widthFactor,
                                    heightFactor: model.heightFactor,
                                    lastRow: rowsFilled + model.heightFactor,
                                    x: varx,
                                    y: vary
                                });
                            }

                            if (gridModel.count === 0) {
                                var varx = spacing;
                                var vary = spacing;
                                added(varx, vary);

                                if (model.widthFactor === 4) {
                                    rowsFilled = model.heightFactor;
                                    cellWidthFilled = 0;
                                } else {
                                    cellWidthFilled += model.widthFactor;
                                }
                                cellHeightFilled += model.heightFactor;
                                widthAveilable = lastRowDeterminate("wAveilable");
                            } else {
                                if (model.widthFactor <= (4 - fucss(lastRowDeterminate("last")))) {
                                    varx = cellWidthFilled * (spacing + cellWidth) + spacing;
                                    vary = (rowsFilled * cellHeight) + (rowsFilled + 1) * spacing;
                                    added(varx, vary);
                                    rowsFilled = nextRowFree(model.heightFactor);
                                    cellWidthFilled = rowsFilled === 0 ? fucss(rowsFilled + 1) : setx();
                                    widthAveilable = lastRowDeterminate("wAveilable");
                                } else {
                                    console.log("Element exceeds available space. Element must be smaller or equal to", (widthAveilable - 4), fucss(rowsFilled + 1), rowsFilled);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
