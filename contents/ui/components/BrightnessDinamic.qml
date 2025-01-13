import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import "../lib" as Lib

Item {

    property bool mouseAreaActive:  false

    Lib.Card {
        width: parent.width
        height: parent.height



        Column {
            width:  parent.width - 20
            height: parent.height - 20
            anchors.centerIn: parent
            spacing: 10

            Kirigami.Heading {
                id: name
                text: i18n("Brightness")
                font.weight: Font.DemiBold
                level: 5
                anchors.left: slider.left
                anchors.top: parent.top
                anchors.topMargin: Kirigami.Units.gridUnit /2
            }

            Slider {
                id: slider
                width: parent.width - Kirigami.Units.gridUnit
                height: 24
                //anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: ((parent.height - height)/2) + name.implicitHeight/2
                from: 0
                to: maxSlider
                value: control.valueSlider
                snapMode: Slider.SnapAlways
                enabled: mouseAreaActive
                onMoved: {
                    control.realValueSlider = value*100
                    value = value
                }
            }
        }

    }

}
