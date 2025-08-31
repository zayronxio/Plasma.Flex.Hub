import QtQuick
import "../lib" as Lib
import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors

Item {

    id: root

    property string code

    property var inhibitionControl: Qt.createQmlObject(code, root, "inhibitionControl");

    property bool mouseAreaActive:  false

    property var inhibitions: inhibitionControl.inhibitions
    property bool isManuallyInhibited: inhibitionControl.isManuallyInhibited
    property bool active: inhibitions.length > 0 || isManuallyInhibited

    signal inhibitionChangeRequested(bool inhibit)

    property string powerManagementControlQml: `
    import org.kde.plasma.private.batterymonitor
    PowerManagementControl {
        id: powerManagementControl
        // Configuración adicional para PowerManagementControl
    }
    `

    property string inhibitionControlQml: `
    import org.kde.plasma.private.batterymonitor
    InhibitionControl {
        id: powerManagementControl
        // Configuración adicional para InhibitionControl
    }
    `
    Sensors.SensorDataModel {
        id: plasmaVersionModel
        sensors: ["os/plasma/plasmaVersion"]
        enabled: true

        onDataChanged: {
            const value = data(index(0, 0), Sensors.SensorDataModel.Value);
            if (value !== undefined && value !== null) {
                if (value.indexOf("6.3") >= 0 || value.indexOf("6.4") >= 0) {
                    code = inhibitionControlQml
                } else {
                    code = powerManagementControlQml
                }
            }
        }
    }


    onInhibitionChangeRequested: inhibit => {

        if (inhibit) {
            const reason = i18n("The battery applet has enabled suppressing sleep and screen locking");
            inhibitionControl.inhibit(reason)
        } else {
            inhibitionControl.uninhibit()
        }
    }

    Lib.Card {
        width: parent.width
        height: parent.height
        Kirigami.Icon {
            id: logo
            anchors.top: parent.top
            anchors.topMargin: Kirigami.Units.largepacing
            width: Kirigami.Units.iconSizes.mediumSmall
            height: width
            source: active ? "caffeine-cup-full" : "caffeine-cup-empty"
            anchors.horizontalCenter: parent.horizontalCenter

        }

        Kirigami.Heading {
            id: textdontDis
            text: active ? i18n("On") : i18n("Off")
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
                logo.source = active ? "caffeine-cup-empty" : "caffeine-cup-full"
            }
        }

    }
    Component.onCompleted: {
        if(!isManuallyInhibited){
            isManuallyInhibited = true
        }
    }
}
