import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import org.kde.ksvg 1.0 as KSvg
import QtQuick.Effects

Item {

    id: card

    property bool isShadow: false
    property bool isMask: false
    property bool colorizer: false
    property bool isCustom: true

    property int shadowHintLeftWidth: shadowHintLeftMargin.width
    property int shadowHintTopHeight: shadowHintTopMargin.height
    property int hintInsetWidth: hintInset.width

    property int excessWidth: isShadow ? shadowHintLeftWidth * 2 : 0
    property int excessHeight: isShadow ? shadowHintTopHeight * 2 : 0
    property int plasmaHintInset: isShadow ? hintInsetWidth : 0
    property int marginX: excessWidth + plasmaHintInset - shadowHintLeftWidth
    property int marginY: excessHeight + plasmaHintInset - shadowHintTopHeight

    property var placeHolderCurrent: isMask ? placeHolderMask : isShadow ? placeHolderShadow : placeHolderNormal
    property string prefix: isMask ? "mask-" : isShadow ? "shadow-" : ""
    property string pathSvg: "dialogs/background"
    property var namesItemsSvg: ["topleft", "top", "topright",
    "left", "center", "right",
    "bottomleft", "bottom", "bottomright"]

    property color customColorbg: "white"
    property int customOpacity: 30
    property int customRadius: 30

    KSvg.SvgItem {
        id: shadowHintLeftMargin
        imagePath: pathSvg
        elementId: "shadow-hint-left-margin"
        visible: false
    }
    KSvg.SvgItem {
        id: shadowHintTopMargin
        imagePath: pathSvg
        elementId: "shadow-hint-top-margin"
        visible: false
    }
    KSvg.SvgItem {
        id: hintInset
        imagePath: pathSvg
        elementId: "hint-left-inset"
        visible: false
    }
    KSvg.SvgItem {
        id: placeHolderNormal
        imagePath: pathSvg
        elementId: "topleft"
        visible: false
    }
    KSvg.SvgItem {
        id: placeHolderMask
        imagePath: pathSvg
        elementId: "mask-topleft"
        visible: false
    }
    KSvg.SvgItem {
        id: placeHolderShadow
        imagePath: pathSvg
        elementId: "shadow-topleft"
        visible: false
    }

    Loader {
        anchors.fill: parent
        sourceComponent: isCustom ? customRect : undefined
    }

    Component {
        id: customRect
        Item {
            anchors.fill: parent
            opacity: isShadow ? 0 : 1
            Item {
                anchors.fill: parent
                anchors.margins: - 6
                layer.enabled: true
                opacity: isMask ? 0 : 0.1
                // Rectángulo invisible: solo define la forma de la sombra
                Rectangle {
                    id: shadowWidget
                    anchors.fill: parent
                    anchors.margins: 6
                    color: customColorbg
                    visible: false    // 👈 nunca se dibuja
                    radius: customRadius
                }

                // La sombra se dibuja en base al shadowWidget invisible
                DropShadow {
                    anchors.fill: shadowWidget
                    source: shadowWidget
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 1
                    radius: 12
                    samples: 25
                    color: "black"
                }

            }
            Rectangle {
                id: bgColor
                anchors.fill: parent
                color:  customColorbg
                opacity: isMask ? 1 : customOpacity/100
                radius: customRadius
            }
            Rectangle {
                id: balckBorder
                anchors.fill: parent
                color: "transparent"
                border.color: "black"
                border.width: 1
                opacity: isMask ? 0 : 0.1
                radius: customRadius
            }
            Rectangle {
                id: lightBorder
                width: parent.width -2
                height: parent.height -2
                anchors.centerIn: parent
                color: "transparent"
                border.color: "white"
                border.width: 1
                opacity: isMask ? 0 : 0.1
                radius: customRadius
            }
        }
    }


    Flow {
        width: parent.width + excessWidth
        height: parent.height + excessHeight
        anchors.left: parent.left
        anchors.leftMargin: isShadow ? -marginX : 0
        anchors.top: parent.top
        anchors.topMargin: isShadow ? -marginY : 0
        visible: !isCustom

        Repeater {
            model: namesItemsSvg
            delegate: KSvg.SvgItem {
                imagePath: pathSvg
                elementId: prefix + modelData
                width: (modelData === "top" || modelData === "center" || modelData === "bottom") ? parent.width - placeHolderCurrent.width * 2 : placeHolderCurrent.width
                height: (modelData === "left" || modelData === "center" || modelData === "right") ? parent.height - placeHolderCurrent.height * 2 : placeHolderCurrent.height
            }
        }
    }
}
