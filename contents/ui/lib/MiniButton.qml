import QtQuick
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami as Kirigami

Column {
    id: root
    property string title: ""
    property string bigText: "per"
    property string itemIcon: ""
    property var onIconClicked
    property bool bashExe: false
    property string cmd
    property bool exeDual: false
    property bool isMask: true
    property bool isSensor: false
    property int sizeIcon: Plasmoid.configuration.sizeGeneralIcons

    property bool enableTitle: Plasmoid.configuration.labelsToggles

    signal iconClicked()

    width: parent.width - Kirigami.Units.smallSpacing
    height: parent.height - Kirigami.Units.smallSpacing
    clip: true

    anchors.centerIn: parent

    Executor {
        id: exe
        command: cmd
    }

    Kirigami.Icon {
        id: logo
        width: sizeIcon// Kirigami.Units.iconSizes.medium
        height: width
        source: itemIcon
        color: Kirigami.Theme.textColor
        isMask: parent.isMask
        //visible: !headerText
        anchors.top:  parent.top
        anchors.topMargin: !enableTitle ? (parent.height - sizeIcon)/2 : (parent.height/2 - sizeIcon) /2
        anchors.horizontalCenter: parent.horizontalCenter


        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if (exeDual) {
                    root.iconClicked()
                    exe.execute()
                } else {
                    if (bashExe) {
                        exe.execute()
                    } else {
                        root.iconClicked()
                    }
                }
            }
        }
    }

    Kirigami.Heading {
        id: txt
        text: title
        width: parent.width - 4
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
        height: (parent.height/2) - 4
        level: 5
        visible: enableTitle
        //font.pixelSize: weatherToggle.height < weatherToggle.width ? weatherToggle.height*.15 : weatherToggle.width*.15
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        maximumLineCount: 2
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

}
