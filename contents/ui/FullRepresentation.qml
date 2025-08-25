/*
SPDX-FileCopyrightText: zayronxio
SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import "components" as Components
import "pages" as Pages
import org.kde.ksysguard.sensors as Sensors
import "lib" as Lib

Item {
    id:root

    property string code: ""
    property var control

    property string sourceBrightnessPlasma64orPlusQml: `
    import QtQuick
    import "components" as Components
    Components.SourceBrightnessPlasma64orPlus {
        id: dynamic
    }
    `
    property string sourceBrightnessQML: `
    import QtQuick
    import "components" as Components
    Components.SourceBrightness {
        id: dynamic
    }
    `

    Sensors.SensorDataModel {
        id: plasmaVersionModel
        sensors: ["os/plasma/plasmaVersion"]
        enabled: true

        onDataChanged: {
            const value = data(index(0, 0), Sensors.SensorDataModel.Value);
            if (value !== undefined && value !== null) {
                if (value.indexOf("6.4") >= 0) {
                    code = sourceBrightnessPlasma64orPlusQml;
                } else {
                    code = sourceBrightnessQML;
                }

                // Crea el nuevo componente
                control = Qt.createQmlObject(code, root, "control");
            }
        }
    }

    TextConstants {
        id: textConstants
    }
    property var listElements: []
    property var list_y: []
    property var list_x: []
    property var listCustomControls: []
    property var listControlsX: []
    property var listControlsY: []

    property int mainLastRow: 0

    property bool sideBarEnabled: false
    property int defaultWidth: widthFactor*4 + spacing*5
    property int widthFactor: Kirigami.Units.gridUnit * 4
    property int heightFactor: Kirigami.Units.gridUnit * 4
    property int footer_height: 32
    property var mainGridsFilled: []
    property int spacing: Kirigami.Units.gridUnit/2
    property int factorX: spacing + widthFactor
    property int factorY: spacing + heightFactor
    property int rows: gridModel.count > 0 ? lastR() : 2
    property int exedent: sideBarEnabled ? 2 : 0
    property int heightF: (rows + exedent) * factorY + footer_height

    property int generalMargin: heightFactor/2
    property int miniIconsSize: 22

    property var namesCustomControls: Plasmoid.configuration.customControlNames

    property string nameTh: Plasmoid.configuration.selected_theme

    property var page: ""

    Layout.preferredWidth: sideBarEnabled ? (widthFactor*8 + spacing*11) : defaultWidth
    Layout.preferredHeight: heightF
    Layout.minimumWidth: preferredWidth
    Layout.maximumWidth: preferredWidth
    Layout.minimumHeight: Layout.preferredHeight
    Layout.maximumHeight: Layout.preferredHeight
    //clip: true

    onSideBarEnabledChanged: {
        console.log("change Enable sidebar")
        Layout.preferredWidth = sideBarEnabled ? (widthFactor * 8 + spacing * 11) : (widthFactor * 4 + spacing * 5);
        Layout.minimumWidth = sideBarEnabled ? (widthFactor * 8 + spacing * 11) : (widthFactor * 4 + spacing * 5);
        Layout.maximumWidth = sideBarEnabled ? (widthFactor * 8 + spacing * 11) : (widthFactor * 4 + spacing * 5);
        Layout.preferredHeight = heightF;
    }
    onRowsChanged: {
        calculateHeight()
    }

    onSideBarEnabled: {
        updateHeight()
    }
    onNameThChanged: {
        updateModel()
    }

    onPageChanged: {
        if (page !== "") {
            leftPanel.visible = false
        } else {
            leftPanel.visible = true
        }
    }

    Model {
        id: namesModel
    }

    ListModel {
        id: gridModel
    }

    function updateModel() {

        gridModel.clear()
        mainGridsFilled = []

        listElements = Plasmoid.configuration.elements
        list_y = Plasmoid.configuration.yElements
        list_x = Plasmoid.configuration.xElements

        listCustomControls = Plasmoid.configuration.listCustomControls
        listControlsX = Plasmoid.configuration.listControlsX
        listControlsY = Plasmoid.configuration.listControlsY


        for (var v = 0; v < listElements.length; v++) {
            gridModel.append({
                //namesModel es el model que contine la informacion original antes de ser procesadas, para la primera carga no es necesario usar SideBar para crear el modelo que genera los primero elementos, estos se actualizan al inicio en funcion de la informacion guarda en las configuracions de el plasmoid
                elementId: namesModel.get(listElements[v]).elementId,
                             w: namesModel.get(listElements[v]).w,
                             indexOrigin: listElements[v],
                             h: namesModel.get(listElements[v]).h,
                             source: namesModel.get(listElements[v]).source,
                             isCustomControl: false,
                             x: parseInt(list_x[v]),
                             y: parseInt(list_y[v])
            });
            addedGridsFilled(parseInt(list_x[v]), parseInt(list_y[v]), namesModel.get(listElements[v]).h, namesModel.get(listElements[v]).w)
        }
        for (var y = 0; y < listCustomControls.length; y++) {
            var dinamicArray = Plasmoid.configuration.customControlNames
            var ind = dinamicArray.indexOf(listCustomControls[y])
            gridModel.append({

                elementId: listCustomControls[y],
                w: Plasmoid.configuration.customControlWidths[ind] === "1" ? 1 : 2,
                indexOrigin: listCustomControls[y],
                h: 1,
                source: "",
                isCustomControl: true,
                x: parseInt(listControlsX[y]),
                             y: parseInt(listControlsY[y])

            });
            addedGridsFilled(parseInt(listControlsX[y]), parseInt(listControlsY[y]), Plasmoid.configuration.customControlHeights[ind],  Plasmoid.configuration.customControlWidths[ind])

        }


        Layout.preferredWidth = (widthFactor * 4 + spacing * 5);
        Layout.minimumWidth = (widthFactor * 4 + spacing * 5);
        Layout.maximumWidth = (widthFactor * 4 + spacing * 5);
        Layout.preferredHeight = heightF;
        calculateHeight()
    }

    Component.onCompleted: {
         updateModel()
         rows = gridModel.count > 0 ? lastR() : 2
    }

    function addedGridsFilled(x, y, h, w){
        for (var z = 0; z < h; z++) {
            for (var i = 0; i < w; i++) {
                var value = (y+z) + " " + (x+i)
                mainGridsFilled.push(value)
            }
        }
    }

    function updateConfigs() {
        Plasmoid.configuration.elements = listElements;
        Plasmoid.configuration.yElements = list_y;
        Plasmoid.configuration.xElements = list_x;
        Plasmoid.configuration.selected_theme = "Custom"
        // custom customControl
        Plasmoid.configuration.listCustomControls = listCustomControls
        Plasmoid.configuration.listControlsX = listControlsX
        Plasmoid.configuration.listControlsY = listControlsY
    }

    function calculateHeight() {
        exedent = sideBarEnabled ? 2 : 0
        heightF = (rows + exedent) * factorY + footer_height
        let value = lastR(gridModel)
        rows = value !== 0 ? lastR(gridModel) : 2
        Layout.preferredHeight = heightF;
        Layout.minimumHeight = heightF;
        Layout.maximumHeight = heightF;
    }

    function lastR() {

        let row = 0
        for (var u = 0; u < mainGridsFilled.length; u++){
            let numbers = mainGridsFilled[u].split(" ")
            if (numbers[0] > row) {
                row = numbers[0]
            }
        }
        return ( parseFloat(row) + 1)
    }

    function removeItem(item,h,w){
        // This function searches through the elements of the configuration arrays for a match to remove the specified element.

        for (var k = 0; k < listElements.length; k++) {

            if (listElements[k] === item) {
                for (var z = 0; z < h; z++) {
                    for (var i = 0; i < w; i++) {
                        var value = (parseInt(list_y[k]) + z) + " " + (parseInt(list_x[k]) + i);
                        var index = mainGridsFilled.indexOf(value);
                        if (index !== -1) {
                            mainGridsFilled.splice(index, 1); // Dalate value
                        }
                    }
                }
                listElements.splice(k, 1);
                list_y.splice(k, 1);
                list_x.splice(k, 1);
                updateConfigs()
            }
        }
        for (var t = 0; t < listCustomControls.length; t++){
            if (listCustomControls[t] === item) {
                for (var z = 0; z < h; z++) {
                    for (var i = 0; i < w; i++) {
                        var value = (parseInt(listControlsY[t]) + z) + " " + (parseInt(listControlsX[t]) + i);
                        var index = mainGridsFilled.indexOf(value);
                        if (index !== -1) {
                            mainGridsFilled.splice(index, 1); // Dalate value
                        }
                    }
                }
                listCustomControls.splice(t, 1);
                listControlsY.splice(t, 1);
                listControlsX.splice(t, 1);
                updateConfigs()
            }
        }


    }


    //inferior del plasmoid
    Rectangle {
        height: Kirigami.Units.iconSizes.small + 8
        width: txtEdith.implicitWidth + Kirigami.Units.iconSizes.small
        radius: height/2
        color: "transparent" //Kirigami.Theme.highlightColor
        visible: !sideBarEnabled
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: root.horizontalCenter

        Rectangle {
            height: Kirigami.Units.iconSizes.small + 8
            width: txtEdith.implicitWidth + Kirigami.Units.iconSizes.small
            radius: height/2
            color: "transparent"
            anchors.centerIn: parent
            border.color: "transparent"//Kirigami.Theme.highlightedTextColor
            //border.width: 2
            opacity: 0.3
        }
        Kirigami.Heading {
            id: txtEdith
            text: textConstants.edit
            width: parent.width
            height: parent.height
            color: Kirigami.Theme.textColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            level: 5
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {

                sideBarEnabled = true
                rows = rows + 2
            }
        }
    }

    Loader {
        id: pageLoader
        source: page
        width: parent.width
        height: parent.height

        // Contenedor para la animación de opacidad
        opacity: 0 // Comienza invisible
        Behavior on opacity { NumberAnimation { duration: 600 } } // Animación de opacidad (500 ms)

        onLoaded: {
            if (page !== "") {
                opacity = 1 // Aparece gradualmente cuando se carga
            }
        }

        onStatusChanged: {
            if (status === Loader.Error) {
                page = ""
                opacity = 0 // Oculta el contenido si hay un error
                leftPanel.visible = true
            }
        }
    }
    Component {
        id: customControl
        Lib.CustomControl {
        }
    }


    Item {
        id: leftPanel
        width: parent.width/2
        height: rows * factorY
        //visible: false
        Repeater {
            model: gridModel
            delegate: Loader {
                id: rect
                source:  model.isCustomControl ? undefined : model.source
                sourceComponent: model.isCustomControl ? customControl : undefined

                onLoaded: {
                    if (item && item.hasOwnProperty("mouseAreaActive")) {
                        item.mouseAreaActive = true;
                    }
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
                Kirigami.Icon {
                    width: 24
                    height: 24
                    source: "dialog-close-symbolic"
                    visible: sideBarEnabled
                    z: 5
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            removeItem(model.indexOrigin,model.h,model.w) // delate item of config
                            gridModel.remove(model.index) // delate item of model
                        }
                    }
                }

            }

        }


    }

    Loader {
        id: sideBarLoader
        sourceComponent: sideBarEnabled ? sideBarComponent : null // Cargar solo si está habilitado
        anchors.right: parent.right
        width: (widthFactor*4 + spacing*5)
        height: parent.height
    }


    Component {
        id: sideBarComponent
        SideBar {
            id: sideBar
            max_x: (widthFactor*4 + spacing*5)
            max_y: parent.height
            anchors.right: parent.right
            width: max_x
            gridsFilled: mainGridsFilled
            lastRow: rows// mainLastRow
            height: parent.height
            opacity: 0.8

            onReadyModel: {
                /// se cambiara de enfoque, se elimanara el proceso para
                var varCustomControl = sideBar.desingModel.get(sideBar.desingModel.count-1).isCustomControl
                gridModel.append({
                    isCustomControl: varCustomControl,
                    elementId: sideBar.desingModel.get(sideBar.desingModel.count-1).elementId,
                    w: sideBar.desingModel.get(sideBar.desingModel.count-1).w,
                    h: sideBar.desingModel.get(sideBar.desingModel.count-1).h,
                    source: sideBar.desingModel.get(sideBar.desingModel.count-1).source,
                    indexOrigin: (sideBar.desingModel.get(sideBar.desingModel.count-1).indexOrigin).toString(),
                    x: parseInt(sideBar.desingModel.get(sideBar.desingModel.count-1).x),
                    y: parseInt(sideBar.desingModel.get(sideBar.desingModel.count-1).y)
                });
                // logic to add the new elements to the plasmoid configuration, used for the first load
                if (varCustomControl) {
                    listCustomControls.push(sideBar.desingModel.get(sideBar.desingModel.count-1).elementId)
                    listControlsX.push(parseInt(sideBar.desingModel.get(sideBar.desingModel.count-1).x))
                    listControlsY.push(parseInt(sideBar.desingModel.get(sideBar.desingModel.count-1).y))
                } else {
                    listElements.push(sideBar.desingModel.get(sideBar.desingModel.count-1).indexOrigin)
                    list_y.push(parseInt(sideBar.desingModel.get(sideBar.desingModel.count-1).y))
                    list_x.push(parseInt(sideBar.desingModel.get(sideBar.desingModel.count-1).x))
                }

                updateConfigs()
                calculateHeight()
                Plasmoid.configuration.selected_theme = "Custom"
            }

            onClose: {
                sideBarEnabled = false
                root.width = (widthFactor * 4 + spacing * 5);
                Layout.preferredWidth = (widthFactor * 4 + spacing * 5);
                Layout.minimumWidth = (widthFactor * 4 + spacing * 5);
                Layout.maximumWidth = (widthFactor * 4 + spacing * 5);
                calculateHeight()

            }
        }
    }
}
