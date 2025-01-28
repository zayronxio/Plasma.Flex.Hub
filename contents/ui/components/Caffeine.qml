import QtQuick
import "../lib" as Lib
import org.kde.kirigami as Kirigami
import org.kde.plasma.private.batterymonitor

Item {

    PowerManagementControl {
        id: powerManagementControl
    }
    property bool mouseAreaActive:  false
    property bool isManuallyInhibited: powerManagementControl.isManuallyInhibited

    signal inhibitionChangeRequested(bool inhibit)

    onInhibitionChangeRequested: inhibit => {

        if (inhibit) {
            const reason = i18n("The battery applet has enabled suppressing sleep and screen locking");
            powerManagementControl.inhibit(reason)
        } else {
            powerManagementControl.uninhibit()
        }
    }
    Lib.Card {
        width: parent.width
        height: parent.height
        Kirigami.Icon {
            id: logo
            width: Kirigami.Units.iconSizes.mediumSmall
            height: width
            source: isManuallyInhibited ? "system-suspend-inhibited" : "system-suspend-uninhibited"
            anchors.horizontalCenter: parent.horizontalCenter

        }

        Kirigami.Heading {
            id: textdontDis
            text: isManuallyInhibited ? i18n("On") : i18n("Off")
            width: parent.width
            anchors.top: logo.bottom
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
        MouseArea {
            enabled: mouseAreaActive
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                isManuallyInhibited = !isManuallyInhibited
                inhibitionChangeRequested(!isManuallyInhibited)
            }
        }

    }
}
