import QtQuick
import "../lib" as Lib
import QtQuick.Controls
import QtQuick.Layouts 1.1
import org.kde.kirigami as Kirigami
import org.kde.taskmanager 0.1 as TaskManager
import org.kde.plasma.private.quicklaunch 1.0
import org.kde.plasma.components as PlasmaComponents

Item {

    id: main
    property var selectedAppPid: 0
    property string selectedAppName: ""

    function action() {
        page = ""
    }
    TaskManager.TasksModel {
        id: tasksModel

        sortMode: TaskManager.TasksModel.SortVirtualDesktop
        groupMode: TaskManager.TasksModel.GroupApplications
    }

    Logic {
        id: logic
    }

    Lib.Pages {
        width: parent.width
        height: parent.height
        actionArrow: action
        enabledFooter: false

        headerContent: Item {
            anchors.fill: parent
            anchors.centerIn: parent
             Kirigami.Heading {
                 width: parent.width
                 height: parent.height
                 level: 3
                 verticalAlignment: Text.AlignVCenter
                 text: i18n("Force Quit")
            }
        }
        mainContent: Item {
            width: parent.width
            height: parent.height
            Flickable {
                id: fli
                width: parent.width
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                contentWidth: parent.width // O usa la suma total de los elementos si el ancho es dinámico
                contentHeight: parent.height < (Kirigami.Units.iconSizes.sizeForLabels+Kirigami.Units.smallSpacing) * tasksModel.count ? (Kirigami.Units.iconSizes.sizeForLabels+Kirigami.Units.smallSpacing) * tasksModel.count :  parent.height
                clip: true
                visible: !menuForce.visible

                ListView {
                    clip: true
                    focus: true
                    id: windowList
                    height: parent.height
                    width: parent.width
                    model: tasksModel
                    delegate: PlasmaComponents.ItemDelegate {
                        highlighted: ListView.isCurrentItem
                        width: ListView.view.width

                        contentItem: RowLayout {
                            spacing: Kirigami.Units.smallSpacing

                            Kirigami.Icon {
                                id: iconItem

                                source: model.decoration
                                visible: source !== "" && iconItem.valid

                                implicitWidth: Kirigami.Units.iconSizes.sizeForLabels
                                implicitHeight: Kirigami.Units.iconSizes.sizeForLabels
                            }

                            Kirigami.Icon {
                                source: "preferences-system-windows"
                                visible: !iconItem.valid

                                implicitWidth: Kirigami.Units.iconSizes.sizeForLabels
                                implicitHeight: Kirigami.Units.iconSizes.sizeForLabels
                            }
                            PlasmaComponents.Label {
                                Layout.fillWidth: true
                                text: model.AppName
                                elide: Text.ElideRight
                            }
                        }

                        onClicked:  {
                            windowList.currentIndex = index
                            fli.visible = false
                            menuForce.visible = true
                        }
                    }
                    onCurrentItemChanged: {
                        const modelIndex = model.makePersistentModelIndex(windowList.currentIndex)
                        selectedAppPid = tasksModel.data(
                            modelIndex,
                            TaskManager.AbstractTasksModel.AppPid
                        ) ?? 0
                        selectedAppName = tasksModel.data(
                            modelIndex,
                            TaskManager.AbstractTasksModel.AppName
                        ) ?? ""
                    }
                }
            }
            Item {
                id: menuForce

                height: parent.height
                width: parent.width
                visible: false
                Kirigami.Heading {
                    text: i18n("Force Quit ") + selectedAppName
                    font.weight: Font.DemiBold
                    level: 4
                    anchors.centerIn: parent
                }
                Row {
                    width: quit.implicitWidth + cancel.implicitWidth + spacing
                    height: cancel.implicitHeight
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: Kirigami.Units.iconSizes.sizeForLabels
                    spacing: 20
                    Button {
                        id: quit
                        text: i18n("Quit")
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                logic.openExec(`kill ${selectedAppPid}`)
                                menuForce.visible = false
                                fli.visible = true

                            }
                        }
                    }
                    Button {
                        id: cancel
                        text: i18n("Cancel")
                        onClicked: {
                            fli.visible = true
                            menuForce.visible = false
                            //fli.visible = true
                        }
                    }
                }
            }
        }
    }
}
