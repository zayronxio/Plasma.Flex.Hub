import QtQuick

ListModel {
    ListElement { elementId: "item1"; name: "Music Card 3x2"; widthFactor: 2; heightFactor: 2; source: "components/Multimedia2x2.qml" }
    ListElement { elementId: "item2"; name: "Music Card 1x4"; widthFactor: 4; heightFactor: 1; source: "components/Multimedia1x4.qml"}
    ListElement { elementId: "item3"; name: "Volume 1x2"; widthFactor: 2; heightFactor: 1; source: "components/Volume1x2.qml"}
    ListElement { elementId: "item4"; name: "DND botton"; widthFactor: 1; heightFactor: 1; source: "components/Dnd1x1.qml"}
    ListElement { elementId: "item5"; name: "Brightness1x2"; widthFactor: 2; heightFactor: 1; source: "components/BrightnessDinamic.qml"}
    ListElement { elementId: "item6"; name: "Brightness1x4"; widthFactor: 4; heightFactor: 1; source: "components/BrightnessDinamic.qml"}
    ListElement { elementId: "item6"; name: "NightLightControl1x1"; widthFactor: 1; heightFactor: 1; source: "components/RedShiftToggle.qml"}
    ListElement { elementId: "item7"; name: "Nectowork1x2"; widthFactor: 2; heightFactor: 1; source: "components/Network1x2.qml"}
    ListElement { elementId: "item8"; name: "Bluetooth1x2"; widthFactor: 2; heightFactor: 1; source: "components/Bluetooth1x2.qml"}
    ListElement { elementId: "item9"; name: "Status1x2"; widthFactor: 2; heightFactor: 1; source: "components/StatusPanel.qml"}

}

