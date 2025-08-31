import QtQuick
import org.kde.plasma.plasmoid 2.0
import Qt5Compat.GraphicalEffects
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
    property bool circleMask: false
    property string title: ""
    property bool displayAs: false
    property string textDisplayAs
    property string itemIcon: ""
    property var onIconClicked // Propiedad para definir la función desde el exterior
    property string anchorsDinamic: "center" // center or top
    property int sizeIcon: Plasmoid.configuration.sizeGeneralIcons
    property int marginIcons: Plasmoid.configuration.sizeMarginlIcons
    // property temp, It is used to set the standard width of an element and to be able to set the margins more correctly.
    property int customMarginTop: 5
    property int customMarginBottom: 5
    property int bubbleDiameter: circle.width

    signal click

    onBackgroundColorChanged: {
        iconColor = isColorLight(backgroundColor) ? "white" : "black"
    }
    function isColorLight(color) {
        const luminance = 0.299 * color.r + 0.587 * color.g + 0.114 * color.b;
        return luminance < 0.6; // 80.5 / 255
    }

    Column {
        width: parent.width - (heightFactor - (sizeIcon + marginIcons))
        height: parent.height
        spacing: 0
        anchors.horizontalCenter: parent.horizontalCenter


        Row {
            width: parent.width
            height: bubbleDiameter //activeTitle && smallMode ? parent.height : parent.height/2
            spacing: 5
            anchors.verticalCenter: anchorsDinamic === "center" ? parent.verticalCenter : undefined
            anchors.top: parent.top //anchorsDinamic === "top" ? parent.top : undefined
            anchors.topMargin: anchorsDinamic === "top" ? customMarginTop : undefined
            anchors.bottomMargin: anchorsDinamic === "bottom" ? customMarginBottom : undefined
            anchors.bottom: anchorsDinamic === "bottom" ? parent.bottom : undefined


            //anchors.horizontalCenter: !smallMode ? parent.horizontalCenter : undefined
            Rectangle {
                id: circle
                width: sizeIcon + marginIcons
                height: sizeIcon + marginIcons
                radius: height/2
                color: bubble || displayAs ? backgroundColor : "transparent"
                anchors.horizontalCenter: smallMode ? parent.horizontalCenter : undefined
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    visible: displayAs
                    width: sizeIcon
                    height: sizeIcon
                    text: textDisplayAs
                    font.pixelSize: sizeIcon/2
                    color: Kirigami.Theme.highlightedTextColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.capitalization: Font.Capitalize
                }

                Rectangle {
                    id: mask
                    visible: false
                    width: sizeIcon
                    height: sizeIcon
                    radius: height/2
                }

                Kirigami.Icon {
                    id: icon
                    width: sizeIcon //22//Kirigami.Units.iconSizes.mediumSmall
                    height: width
                    isMask: isMaskIcon
                    visible: !valueInBubble
                    color: isMaskIcon ? iconColor : undefined
                    source: itemIcon
                    anchors.centerIn: parent
                    layer.enabled: circleMask
                    layer.effect: OpacityMask {
                        maskSource: mask
                    }
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
