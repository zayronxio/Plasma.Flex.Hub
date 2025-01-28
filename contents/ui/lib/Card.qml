/*
 *    SPDX-FileCopyrightText: zayronxio
 *    SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import Qt5Compat.GraphicalEffects
import org.kde.plasma.plasmoid 2.0

Item {
    id: root
    property color customColor: Plasmoid.configuration.colorCards
    property color elementBackgroundColor: "red"
    property color backgrounfColor: !enabledColor ? customColor : elementBackgroundColor
    property bool globalBool: true
    property bool enabledColor: false
    property bool enabledCustomColor: Plasmoid.configuration.enabledCustomColor
    property bool colorizer: Plasmoid.configuration.enabledCustomColor
    property int shadowOpacity: Plasmoid.configuration.shadowOpacity

    Rectangle {
        color: backgrounfColor
        width: parent.width
        height: parent.height
        visible: globalBool && enabledCustomColor || enabledColor
        opacity: enabledCustomColor || enabledColor ? 0.7 :  1
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: mask
        }
    }
    HelperCard {
        id: background
        isShadow: false
        width: parent.width
        height:  parent.height
        opacity: enabledCustomColor || enabledColor ? 0.8 : 1.0
        visible: globalBool
    }
    HelperCard {
        id: shadow
        isShadow: true
        width: parent.width
        height:  parent.height
        visible: globalBool
        opacity: shadowOpacity/10
    }
    HelperCard {
        id: mask
        isMask: true
        height:  parent.height
        width: parent.width
        visible: false
    }
    Rectangle {
        color: backgrounfColor
        width: parent.width
        height: parent.height
        visible: globalBool && enabledCustomColor || enabledColor
        opacity: enabledCustomColor || enabledColor ? 0.2 : 1.0
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: mask
        }
    }
}
