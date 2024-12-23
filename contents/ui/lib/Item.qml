import QtQuick
import org.kde.kirigami as Kirigami

Item {
    property bool smallMode: false
    property bool activeSub: true
    property bool activeTitle: true
    property bool bubble: true
    property string sub: ""
    property color backgroundColor: "red"
    property string title: ""
    property string itemIcon: ""
    property var onIconClicked // Propiedad para definir la función desde el exterior
    property string anchorsDinamic: "center"


    Column {
        width: parent.width - 10
        height: parent.height
        spacing: 8
        anchors.centerIn: parent

        Row {
            width: parent.width
            height: activeTitle && smallMode ? parent.height : parent.height/2
            spacing: 5
            anchors.verticalCenter: anchorsDinamic === "center" ? parent.verticalCenter : undefined
            anchors.top: anchorsDinamic === "top" ? parent.top : undefined
            anchors.topMargin: 5
            anchors.bottomMargin: 5
            anchors.bottom: anchorsDinamic === "bottom" ? parent.bottom : undefined


            //anchors.horizontalCenter: !smallMode ? parent.horizontalCenter : undefined
            Rectangle {
                id: circle
                width: icon.width
                height: icon.height
                radius: height/2
                color: bubble ? backgroundColor : "transparent"
                anchors.horizontalCenter: smallMode ? parent.horizontalCenter : undefined
                anchors.verticalCenter: parent.verticalCenter


                Kirigami.Icon {
                    id: icon
                    width: Kirigami.Units.iconSizes.mediumSmall
                    height: width
                    source: itemIcon
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (onIconClicked) {
                            onIconClicked() // Llama la función definida desde el exterior
                        }
                    }
                }

            }
            Column {
                width: parent.width - circle.width
                height: circle.height
                anchors.verticalCenter: parent.verticalCenter
                Kirigami.Heading {
                    text: title
                    visible: !smallMode
                    width: parent.width
                    font.weight: Font.DemiBold
                    height: activeSub ? parent.height /2 : parent.height
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    level: 5
                }

                Kirigami.Heading {
                    text: sub
                    visible: activeSub
                    width: parent.width
                    height: parent.height /2
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    level: 5

                }
            }


        }
        Kirigami.Heading {
            text: title
            visible: activeTitle && smallMode
            width: parent.width
            //anchors.top: circle.bottom
            height: parent.height - circle.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            level: 5

        }


    }
}
