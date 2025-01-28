/*
    SPDX-FileCopyrightText: 2023 Oliver Beard <olib141@outlook.com>
    SPDX-License-Identifier: MIT
*/

import QtQuick

import org.kde.kitemmodels 1.0 as KItemModels
import org.kde.ksysguard.sensors as Sensors

import org.kde.kirigami as Kirigami

Item {
    id: availableSensors

    property list<string> sensorTypes: ["(°C)", "(%)"] // Lista de tipos aceptados para el filtro
    property int type: 0 // Tipo actual para filtrar

    readonly property var sensorRole: Sensors.SensorTreeModel.SensorId
    property alias model: model

    Sensors.SensorTreeModel {
        id: sensorTreeModel
    }

    KItemModels.KDescendantsProxyModel {
        id: descendantsModel

        model: sensorTreeModel
    }

    KItemModels.KSortFilterProxyModel {
        id: filterModel

        sourceModel: descendantsModel
        filterRowCallback: (row, parent) => {
            let display = sourceModel.data(sourceModel.index(row, 0, parent), Qt.DisplayRole);
            let sensorId = sourceModel.data(sourceModel.index(row, 0, parent), sensorRole);

            // Filter: remove non-sensors, only selected type and remove groups
            return sensorId.length > 0 && display.includes(sensorTypes[type]) && !display.includes("[");
        }

        onRowCountChanged: model.update()
    }

    // Custom model, so we can give sensors better names and categorise them
    ListModel {
        id: model

        function update() : void {
            clear();
            for (let i = 0; i < filterModel.rowCount(); ++i) {
                let index = filterModel.index(i, 0);

                // Get name without unit, and sensorId
                let name = filterModel.data(index, Qt.DisplayRole).replace(" (°C)", "").replace(" (%)", "");
                let sensorId = filterModel.data(index, sensorRole);

                // Get category and subcategory indexes
                let categoryIndex = descendantsModel.mapToSource(filterModel.mapToSource(index));
                let subcategoryIndex = null;
                while (categoryIndex.parent.valid) {
                    subcategoryIndex = categoryIndex;
                    categoryIndex = categoryIndex.parent;
                }

                // For Hardware Sensors, prepend the subcategory name
                if (sensorId.includes("lmsensors") && subcategoryIndex != null) {
                    let subcategoryName = sensorTreeModel.data(subcategoryIndex, Qt.DisplayRole);
                    name = subcategoryName + ": " + name;
                }

                let categoryName = sensorTreeModel.data(categoryIndex, Qt.DisplayRole);
                model.set(i, { "name": name, "sensorId": sensorId, "section": categoryName });

                //console.log("adding sensor:", name, "(" + categoryName + ", " + sensorId + ")");
            }
        }
    }

    // Reload filterModel and model when the filter type changes
    Connections {
        target: availableSensors

        onTypeChanged: {
            filterModel.invalidate(); // Force filterModel to re-evaluate its filter
            model.update();          // Update the custom ListModel
        }
    }
}


