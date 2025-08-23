import QtQuick
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami as Kirigami

Item {
    property bool smallMode: false
    property bool activeSub: true
    property bool activeTitle: true
    property bool bubble: true
    property string sub: ""
    property int textValue
    property bool valueInBubble: false
    property color backgroundColor: Kirigami.Theme.highlightColor
    property color iconColor: isColorLight(backgroundColor) ? "white" : "black"
    property bool isMaskIcon: false
    property string title: ""
    property string itemIcon: ""
    property var onIconClicked // Propiedad para definir la función desde el exterior
    property string anchorsDinamic: "center"
    property int sizeIcon: Plasmoid.configuration.sizeGeneralIcons
    property int marginIcons: Plasmoid.configuration.sizeMarginlIcons

    signal click

    onBackgroundColorChanged: {
        iconColor = isColorLight(backgroundColor) ? "white" : "black"
    }
    function isColorLight(color) {
        const luminance = 0.299 * color.r + 0.587 * color.g + 0.114 * color.b;
        return luminance < 0.6; // 80.5 / 255
    }

    Column {
        width: parent.width - (parent.height - (sizeIcon + marginIcons))
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
                width: sizeIcon + marginIcons
                height: sizeIcon + marginIcons
                radius: height/2
                color: bubble ? backgroundColor : "transparent"
                anchors.horizontalCenter: smallMode ? parent.horizontalCenter : undefined
                anchors.verticalCenter: parent.verticalCenter


                Kirigami.Icon {
                    id: icon
                    width: sizeIcon //22//Kirigami.Units.iconSizes.mediumSmall
                    height: width
                    isMask: isMaskIcon
                    visible: !valueInBubble
                    color: isMaskIcon ? iconColor : undefined
                    source: itemIcon
                    anchors.centerIn: parent
                }
                Kirigami.Heading {
                    text: textValue
                    visible: valueInBubble
                    width: parent.width
                    height: parent.height /2
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    level: 3
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        click()
                        if (onIconClicked) {
                            onIconClicked()
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
