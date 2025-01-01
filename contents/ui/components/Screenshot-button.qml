import QtQuick
import "../lib" as Lib
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as Plasma5Support

Item {
    property string command: "spectacle -b"

    Lib.Card {
        width: parent.width
        height: parent.height

        Plasma5Support.DataSource {
            id: executable
            engine: "executable"
            connectedSources: []
            onNewData: {
                var exitCode = data["exit code"]
                var exitStatus = data["exit status"]
                var stdout = data["stdout"]
                var stderr = data["stderr"]
                exited(sourceName, exitCode, exitStatus, stdout, stderr)
                disconnectSource(sourceName)
            }

            function exec(cmd) {
                if (cmd) {
                    connectSource(cmd)
                }
            }

            signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
        }

        Column {
            width: parent.width - 10
            height: parent.height - 10
            anchors.centerIn: parent

            Kirigami.Icon {
                id: logo
                width: Kirigami.Units.iconSizes.mediumSmall
                height: width
                source: "photo-symbolic"
                anchors.horizontalCenter: parent.horizontalCenter
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        executable.exec(command)
                    }
                }
            }

            Kirigami.Heading {
                id: textdontDis
                text: i18n("Screenshot")
                width: parent.width
                anchors.top: logo.bottom
                height: parent.height - logo.height
                level: 5
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
                maximumLineCount: 2
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                //font.weight: Font.DemiBold
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        executable.exec(command)
                    }
                }
            }
        }
    }
}
