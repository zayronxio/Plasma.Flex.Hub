/*
 *    SPDX-FileCopyrightText: zayronxio
 *    SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.15
import org.kde.plasma.plasmoid 2.0
import org.kde.ksvg as KSvg

Item {
    id: root
    width: 100
    height: 100

    property int marginLeft: shadowHintLeftMargin.implicitWidth*3
    property int marginTop: shadowHintTopMargin.implicitHeight
    property bool globalBool: true

    KSvg.SvgItem {
        id: shadowHintLeftMargin
        imagePath: "dialogs/background"
        elementId: "shadow-hint-left-margin"
        visible: false
    }

    KSvg.SvgItem {
        id: hintInset
        imagePath: "dialogs/background"
        elementId: "hint-left-inset"
        visible: false
    }
    KSvg.SvgItem {
        id: shadowHintTopMargin
        imagePath: "dialogs/background"
        elementId: "shadow-hint-top-margin"
        visible: false
    }

    KSvg.SvgItem {
        id: shadowHintLeftInset
        imagePath: "dialogs/background"
        elementId: "shadow-hint-right-inset"
        visible: false
    }

    KSvg.SvgItem {
        id: shadowHintTopInset
        imagePath: "dialogs/background"
        elementId: "shadow-hint-top-inset"
        visible: false
    }


    Grid {
        id: maskSvg
        width: root.width
        height: root.height
        visible: globalBool
        opacity: 0.8
        columns: 3
        anchors.left: parent.left
        anchors.leftMargin: - shadowHintLeftMargin.implicitWidth - hintInset.implicitWidth
        anchors.top:  parent.top
        anchors.topMargin: - shadowHintTopMargin.implicitHeight - hintInset.implicitWidth

        KSvg.SvgItem {
            id: topleft
            imagePath: "dialogs/background"
            elementId: "shadow-topleft"
        }
        KSvg.SvgItem {
            id: top
            imagePath: "dialogs/background"
            elementId: "shadow-top"
            width: parent.width - topleft.implicitWidth*2 + shadowHintLeftMargin.implicitWidth*2 //shadowHintLeftInset.implicitWidth*2 //- hintInset.implicitWidth*4
        }
        KSvg.SvgItem {
            id: topright
            imagePath: "dialogs/background"
            elementId: "shadow-topright"
        }
        KSvg.SvgItem {
            id: left
            imagePath: "dialogs/background"
            elementId: "shadow-left"
            height: parent.height - topright.implicitHeight* 2 + shadowHintTopMargin.implicitHeight*2 //- hintInset.implicitWidth*4
        }
        Rectangle {
            width: top.width
            height: left.height
            color: "transparent"
        }
        KSvg.SvgItem {
            id: right
            imagePath: "dialogs/background"
            elementId: "shadow-right"
            height: left.height
        }
        KSvg.SvgItem {
            id: bottomleft
            imagePath: "dialogs/background"
            elementId: "shadow-bottomleft"
        }
        KSvg.SvgItem {
            id: bottom
            imagePath: "dialogs/background"
            elementId: "shadow-bottom"
            width: top.width
        }
        KSvg.SvgItem {
            id: bottomright
            imagePath: "dialogs/background"
            elementId: "shadow-bottomright"
        }

    }


    Grid {
        id: maskSvg2
        width: root.width - left2.implicitWidth*2
        height: root.height - top2.implicitHeight*2
        visible: globalBool
        columns: 3



        KSvg.SvgItem {
            id: topleft2
            imagePath: "dialogs/background"
            elementId: "topleft"
        }
        KSvg.SvgItem {
            id: top2
            imagePath: "dialogs/background"
            elementId: "top"
            width: root.width - topleft2.implicitWidth*2
        }
        KSvg.SvgItem {
            id: topright2
            imagePath: "dialogs/background"
            elementId: "topright"
        }
        KSvg.SvgItem {
            id: left2
            imagePath: "dialogs/background"
            elementId: "left"
            height: root.height - topright2.implicitHeight*2
        }
        KSvg.SvgItem {
            imagePath: "dialogs/background"
            elementId: "center"
            height: root.height - topright2.implicitHeight*2
            width: root.width - topleft2.implicitWidth*2
        }
        KSvg.SvgItem {
            id: right2
            imagePath: "dialogs/background"
            elementId: "right"
            height: root.height - topright2.implicitHeight*2
        }
        KSvg.SvgItem {
            id: bottomleft2
            imagePath: "dialogs/background"
            elementId: "bottomleft"
        }
        KSvg.SvgItem {
            id: bottom2
            imagePath: "dialogs/background"
            elementId: "bottom"
            width: root.width - topleft2.implicitWidth*2
        }
        KSvg.SvgItem {
            id: bottomright2
            imagePath: "dialogs/background"
            elementId: "bottomright"
        }
    }


}
