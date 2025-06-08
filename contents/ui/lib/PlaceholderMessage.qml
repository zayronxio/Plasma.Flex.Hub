import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami

Item {
    anchors.centerIn: parent
    property string iconName
    property int sizeIcon
    property string textByElement
    property var action
    property bool switchActive
    property string type
    property string textButton: "button"
    property var actionbutton

    function actionVar(type){
        if (type === "switch"){
            console.log("funciona?")
        } else if (type === "button") {
            actionbutton()
        }
    }
    Kirigami.Icon {
        id: logo
        width: sizeIcon
        height: width
        source: iconName
        anchors.verticalCenter: parent.verticalCenter
    }
    Kirigami.Heading {
        id: txt
        width: parent.width
        anchors.top: logo.bottom
        level: 1
        verticalAlignment: Text.AlignVCenter
        text: textByElement
    }
    Switch {
        anchors.top: txt.bottom
        visible: type === "switch"
        anchors.topMargin: 24
        anchors.verticalCenter: parent.verticalCenter
        checked: switchActive
        onClicked: actionVar(type)
    }
    Button {
        text: textButton
        visible: type === "button"
        onClicked: {
            actionVar(type)
        }
    }
}
