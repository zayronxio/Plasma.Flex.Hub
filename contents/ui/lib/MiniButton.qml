import QtQuick
import org.kde.kirigami as Kirigami

Column {
    id: root
    property string title: ""
    property string bigText: "per"
    property string itemIcon: ""
    property var onIconClicked
    property bool bashExe: false
    property string cmd
    property bool isMask: true
    property bool headerText: false


    width: parent.width - Kirigami.Units.smallSpacing
    height: parent.height - Kirigami.Units.smallSpacing

    anchors.centerIn: parent

    Executor {
        id: exe
        command: cmd
    }

    Kirigami.Icon {
        id: logo
        width: Kirigami.Units.iconSizes.medium
        height: width
        source: itemIcon
        color: Kirigami.Theme.textColor
        isMask: parent.isMask
        visible: !headerText
        anchors.top: parent.top
        anchors.topMargin: Kirigami.Units.largeSpacing
        anchors.horizontalCenter: parent.horizontalCenter

        MouseArea {
            enabled: parent.mouseAreaActive
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if (bashExe) {
                    exe.execute()
                } else {
                    onIconClicked()
                }
            }
        }
    }
    Kirigami.Heading {
        id: bigTxt
        text: bigText
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: Kirigami.Units.largeSpacing
        anchors.horizontalCenter: parent.horizontalCenter
        height: 24
        level: 1
        visible: !logo.visible
        //font.pixelSize: weatherToggle.height < weatherToggle.width ? weatherToggle.height*.15 : weatherToggle.width*.15
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        maximumLineCount: 1
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        font.weight: Font.DemiBold
    }

    Kirigami.Heading {
        id: txt
        text: title
        width: parent.width
        anchors.top: logo.visible ? logo.bottom : bigTxt.bottom
        height: parent.height - logo.height
        level: 5
        //font.pixelSize: weatherToggle.height < weatherToggle.width ? weatherToggle.height*.15 : weatherToggle.width*.15
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        maximumLineCount: 2
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        //font.weight: Font.DemiBold
    }

}
