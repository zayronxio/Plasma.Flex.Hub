import QtQuick
import "../lib" as Lib

Item {
    property bool mouseAreaActive:  false

    UserInfo {
        id: userInfo
    }

    Lib.Card {
        width: parent.width
        height: parent.height

        property bool mouseAreaActive:  parent.mouseAreaActive

        Lib.Item {
            id: item
            width: parent.width
            height: parent.height
            activeSub: true
            smallMode: false
            isMaskIcon: false
            sizeIcon: 48
            marginIcons: 0
            circleMask: true
            displayAs: !userInfo.urlAvatar
            textDisplayAs: userInfo.fullName[0]
            title: userInfo.fullName
            sub: userInfo.distroName
            bubble: false
            itemIcon: userInfo.urlAvatar
        }
    }
}
