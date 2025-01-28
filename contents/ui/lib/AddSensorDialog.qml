/*
    SPDX-FileCopyrightText: 2024 Oliver Beard <olib141@outlook.com>
    SPDX-License-Identifier: MIT
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami

Kirigami.Dialog {
    id: dialog

    property int sensorType
    property list<string> addedSensorIds: []

    signal addedSensor(name: string, sensorId: string)


    title: "Add Sensor"

    showCloseButton: true
    standardButtons: Kirigami.Dialog.NoButton

    ListView {
        id: view

        AvailableSensors {
            id: availableSensorsItem
            type: sensorType
        }

        model: availableSensorsItem.model

        implicitWidth: Kirigami.Units.gridUnit * 24
        implicitHeight: Kirigami.Units.gridUnit * 16

        section {
            property: "section"
            delegate: Kirigami.ListSectionHeader {
                required property string section
                width: view.width
                text: section
            }
        }

        delegate: QQC2.ItemDelegate {

            required property int index
            required property string name
            required property string sensorId

            readonly property bool added: dialog.addedSensorIds.includes(sensorId)

            width: view.width
            // HACK: Workaround for some unknown Qt bug
            // First item created (first sensor delegate) has the wrong width,
            // and is not updated to match the other correct delegates.
            // This can be debugged with Component.onCompleted and
            // onWidthChanged logging width & view.width to console.
            onWidthChanged: if (width != view.width) { width = view.width; }

            down: false
            highlighted: false
            hoverEnabled: false
            Kirigami.Theme.useAlternateBackgroundColor: true

            contentItem: RowLayout {
                spacing: Kirigami.Units.smallSpacing

                QQC2.Label {
                    text: name
                    elide: Text.ElideRight

                    opacity: added ? 0.6 : 1

                    QQC2.ToolTip.visible: nameHoverHandler.hovered
                    QQC2.ToolTip.delay: Application.styleHints.mousePressAndHoldInterval
                    QQC2.ToolTip.text: (truncated ? name + "\n" : "" ) + sensorId
                    HoverHandler { id: nameHoverHandler }
                }

                Item {
                    Layout.fillWidth: true
                }

                QQC2.ToolButton {
                    icon.name: added ? "edit-undo-symbolic" : "list-add-symbolic"
                    onClicked: added ? dialog.removedSensor(sensorId) : dialog.addedSensor(name, sensorId)

                    QQC2.ToolTip {
                        text: added ? "Undo" : "Add"
                    }
                }
            }
        }
    }

    footer: ColumnLayout {
        spacing: 0

        Kirigami.Separator {
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.margins: Kirigami.Units.largeSpacing

            spacing: Kirigami.Units.smallSpacing

            QQC2.Label {
                text: "My sensor isn't listed"
            }

            Kirigami.ContextualHelpButton {
                Layout.alignment: Qt.AlignLeft

                toolTipText: "Sensors are provided by <i><b>ksystemstats</b></i>, which uses plugins to retrieve sensor data.<br/><br/>Any missing sensors should be reported to KDE as a feature request bug against that product."
            }
        }
    }
}
