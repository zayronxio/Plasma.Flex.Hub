import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

Item {
    id:root

    QtObject {
        id: lastRow
        property int value: 0
    }

    property var listElements: []
    property var list_y: []
    property var list_x: []

    property alias cfg_lastRow: lastRow.value

    property bool sideBarEnabled: false
    property int widthFactor: Kirigami.Units.gridUnit * 4
    property int heightFactor: Kirigami.Units.gridUnit * 4
    property int footer_height: 22
    property int spacing: Kirigami.Units.gridUnit/2
    property int factorX: spacing + widthFactor
    property int factorY: spacing + heightFactor
    property int rows: gridModel.count > 0 ? lastR(gridModel) : 2
    property int exedent: sideBarEnabled ? 2 : 0
    property int heightF: (rows + exedent) * factorY + footer_height


    Layout.preferredWidth: sideBarEnabled ? (widthFactor*8 + spacing*11) : (widthFactor*4 + spacing*5)
    Layout.preferredHeight: heightF
    Layout.minimumWidth: preferredWidth
    Layout.maximumWidth: preferredWidth
    Layout.minimumHeight: Layout.preferredHeight
    Layout.maximumHeight: Layout.preferredHeight
    clip: true

    //signal updateConfigs

    onSideBarEnabledChanged: {
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

    Model {
        id: namesModel
    }

    ListModel {
        id: gridModel
    }

    Component.onCompleted: {
        // change when public released
        /*/
        Plasmoid.configuration.xElements = list_x
        Plasmoid.configuration.yElements = list_y
        Plasmoid.configuration.elements = listElements
        /*/
        listElements = Plasmoid.configuration.elements
        list_y = Plasmoid.configuration.yElements
        list_x = Plasmoid.configuration.xElements
        for (var v = 0; v < listElements.length; v++) {
            gridModel.append({
                //namesModel es el model que contine la informacion original antes de ser procesadas, para la primera carga no es necesario usar SideBar para crear el modelo que genera los primero elementos, estos se actualizan al inicio en funcion de la informacion guarda en las configuracions de el plasmoid
                elementId: namesModel.get(listElements[v]).elementId,
                w: namesModel.get(listElements[v]).w,
                indexOrigin: listElements[v],
                h: namesModel.get(listElements[v]).h,
                source: namesModel.get(listElements[v]).source,
                x: parseInt(list_x[v]),
                y: parseInt(list_y[v])
            });
        }
        calculateHeight()
    }


    function updateConfigs() {
        Plasmoid.configuration.elements = listElements;
        Plasmoid.configuration.yElements = list_y;
        Plasmoid.configuration.xElements = list_x;
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

    function lastR(model) {
        let row = 0
        for (var i = 0; i < model.count; i++) {
            var lastRow = model.get(i).y + model.get(i).h
            if (lastRow > row) {
                row = lastRow
            }
        }
        return row
    }

    function removeItem(item){
        console.log(item)
        // This function searches through the elements of the configuration arrays for a match to remove the specified element.
        for (var k = 0; k < listElements.length; k++) {
            if (listElements[k] === item) {
                listElements.splice(k, 1);
                list_y.splice(k, 1);
                list_x.splice(k, 1);
                updateConfigs()
                //break
            }
        }

    }


    Kirigami.Icon {
        width: Kirigami.Units.iconSizes.small
        height: width
        visible: !sideBarEnabled
        source: "document-edit"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        MouseArea {
            anchors.fill: parent
            onClicked: {

                sideBarEnabled = true
                rows = rows + 2
            }
        }
    }

    Item {
        id: leftPanel
        width: parent.width/2
        height: rows * factorY

        Repeater {
            model: gridModel
            delegate: Loader {
                id: rect
                source: model.source

                onLoaded: {
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
                            removeItem(model.indexOrigin) // delate item of config
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
            height: parent.height
            opacity: 0.8

            onReadyModel: {
                gridModel.append({
                    w: sideBar.desingModel.get(sideBar.desingModel.count-1).w,
                    h: sideBar.desingModel.get(sideBar.desingModel.count-1).h,
                    source: sideBar.desingModel.get(sideBar.desingModel.count-1).source,
                    indexOrigin: sideBar.desingModel.get(sideBar.desingModel.count-1).indexOrigin,
                    x: parseInt(sideBar.desingModel.get(sideBar.desingModel.count-1).x),
                    y: parseInt(sideBar.desingModel.get(sideBar.desingModel.count-1).y)
                });
                // logic to add the new elements to the plasmoid configuration, used for the first load
                listElements.push(sideBar.desingModel.get(sideBar.desingModel.count-1).indexOrigin)
                list_y.push(parseInt(sideBar.desingModel.get(sideBar.desingModel.count-1).y))
                list_x.push(parseInt(sideBar.desingModel.get(sideBar.desingModel.count-1).x))
                updateConfigs()
                calculateHeight()
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
