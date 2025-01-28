import QtQuick
import "lib" as Lib
import QtQuick.Controls
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import "js/manager.js" as Manager

Item {
    id: wrapper
    property int max_x: 0
    property int max_y: 0
    property int lastRow: 2
    property int widthFactor: Kirigami.Units.gridUnit * 4
    property int heightFactor: Kirigami.Units.gridUnit * 4
    property int spacing: Kirigami.Units.gridUnit/2
    property int ajustWidthX: width + 10
    property int factorX: spacing + widthFactor
    property int factorY: spacing + heightFactor
    property var gridsFilled: []

    property var namesByCustom: []
    property var arrayDinamic: []
    //property int currentIndex: 0
    property alias desingModel: gridModel

    property var gridsX: [spacing - ajustWidthX, factorX + spacing - ajustWidthX, (factorX * 2) + spacing - ajustWidthX, (factorX * 3) + spacing - ajustWidthX ]
    property var gridsY: []

    signal readyModel
    signal close

    function createGridsY() {
        gridsY = []
        //var lastRow = Manager.getHighestSecondValue(gridsFilled)
        var rowForFuct = lastRow + 2
        for (var y = 0; y < rowForFuct; y++) {
            var value = factorY*(y) + spacing
            gridsY.push(value)
        }
        console.log(gridsY)

    }

    Model {
        id: namesModel
    }
    ListModel {
        id: customControlModel
    }

    ListModel {
        id: readyModel
    }
    ListModel {
        id: gridModel
    }
    function secondModel() {
        // Limpiar el modelo antes de agregar nuevos elementos
        //customControlModel.clear();

        // Iterar sobre los elementos en Plasmoid.configuration.customControlNames
        for (var u = 0; u < Plasmoid.configuration.customControlNames.length; u++) {
            namesModel.append({
                name: Plasmoid.configuration.customControlNames[u],
                elementId: Plasmoid.configuration.customControlNames[u],
                w: parseInt(Plasmoid.configuration.customControlWidths[u]),
                h: parseInt(Plasmoid.configuration.customControlHeights[u]),
                isCustomControl: true
            });
        }
    }
    Component.onCompleted: {
        secondModel()
        createGridsY()
        Manager.autoOrganizer(namesModel)
    }

    Component {
        id: customControl
        Lib.CustomControl {
        }
    }

    Flickable {
        id: fli
        width: parent.width
        height: parent.height
        contentWidth: parent.width // O usa la suma total de los elementos si el ancho es dinámico
        contentHeight: Math.max(parent.height, rectRepeater.count * (heightFactor + spacing)) // Calcula la altura total
        clip: true

        Repeater {
            id: rectRepeater
            model: readyModel

            delegate: Loader {
                id: rect
                source:  model.isCustomControl ? undefined : model.source
                sourceComponent: model.isCustomControl ? customControl : undefined
                property int originalX: model.x * widthFactor + model.x*spacing + spacing;
                property int originalY: model.y * heightFactor + model.y*spacing + spacing;
                property int elements: 0


                onLoaded: {
                    if (model.isCustomControl) {
                        var dinamicArray = Plasmoid.configuration.customControlNames
                        var ind = dinamicArray.indexOf(model.elementId)
                         item.isButton = Plasmoid.configuration.customControlEnabledButton[ind] === "true"
                         item.icon = Plasmoid.configuration.customControlIcons[ind]
                         item.controlTitle = model.elementId
                         item.enabledIcon = Plasmoid.configuration.customControlEnabledIcons[ind] === "true"
                         item.exeCommand = Plasmoid.configuration.customControlCommand[ind]
                         item.isPercentage = Plasmoid.configuration.customControlIsPercentage[ind] === "true"
                         item.isLarge = !item.isButton
                         item.subTitle = Plasmoid.configuration.customControlSubTitle[ind]
                         item.idSensor = Plasmoid.configuration.customControlIdSensor[ind]

                    }

                    width = widthFactor * model.w + spacing * (model.w - 1);
                    height = heightFactor * model.h + spacing * (model.h - 1);
                    x = model.x * widthFactor + model.x*spacing + spacing;
                    y = model.y * heightFactor + model.y*spacing + spacing;
                }
                Rectangle {
                    width: 22
                    height: 22
                    color: Kirigami.Theme.highlightColor
                    radius: height/2
                    visible: elements !== 0
                    opacity: 0.8
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: - Kirigami.Units.smallSpacing
                    anchors.rightMargin: - Kirigami.Units.smallSpacing
                    //borde.colo
                    z: 2
                    Text {
                        width: parent.width
                        height: parent.height
                        font.bold: true
                        text: elements
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    drag.target: parent
                    onEntered: {
                        //console.log("pruebas:",mouseY, rect.y)
                        //originalX = rect.x
                        //originalY = rect.y

                        const globalPos = rect.mapToItem(null, rect.x, rect.y);

                        // Cambiar el padre al contenedor adecuado
                        rect.parent = wrapper;

                        // Convertir las coordenadas globales al sistema del nuevo padre
                        const newLocalPos = rect.mapFromItem(null, globalPos.x, globalPos.y);
                        rect.x = newLocalPos.x;
                        rect.y = newLocalPos.y;
                    }
                    onReleased: {
                        function resetPosition() {
                            rect.parent = rectRepeater
                            rect.y =  originalY
                            rect.x = originalX
                        }
                        const realx = rect.x //+ ((rect.width - (model.x*widthFactor)) - rect.x)
                        const realy = rect.y //+ rect.height /*/+ originalY/*/)

                        if (realx > (- max_x - 10) && realx < 10 && rect.y > 0 && rect.y < max_y ) /*/esta condicion evita que los elemenos que se arrastren fuera de el elemento, sean considerados/*/ {
                            var maxX = Manager.findClosest(gridsX, realx) // ESTABLECE EL EXPACIO MAS PROXIMO
                            var maxY = Manager.findClosest(gridsY, realy)
                            if ( Manager.isSpaceAvailable(maxX, maxY, model.w, model.h) ) {
                                gridModel.append({
                                    w: model.w,
                                    h: model.h,
                                    isCustomControl:  model.isCustomControl ? model.isCustomControl  : false,
                                    indexOrigin: model.indexOrigin,
                                    elementId: model.elementId,
                                    source: model.source,
                                    x: maxX,
                                    y: maxY
                                });
                                elements = elements + 1
                                Manager.addedGridsFilled(maxX, maxY, model.h, model.w)
                                if ((model.h + model.x) > lastRow ) {
                                    lastRow = (model.h + model.x)
                                }
                                createGridsY()
                                wrapper.readyModel()
                            }

                        }
                        resetPosition()
                    }
                }
            }
        }
    }
    Rectangle {
        width: 24
        height: 24
        color: Kirigami.Theme.backgroundColor
        radius: height/2
        z: 3
        Kirigami.Icon {
            width: 22
            height: 22
            source:  "arrow-left-symbolic"
            anchors.centerIn: parent
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                close()
            }
        }
    }


}
