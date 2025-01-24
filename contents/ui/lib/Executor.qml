import QtQuick
import org.kde.plasma.plasma5support as Plasma5Support

Item {
    property string command
    property string value: ""
    property bool exePeriodically: false
    property int frecuency: 3000

    signal execute

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

    Connections {
        target: executable
        onExited: {
            if (stdout !== undefined && stdout !== null) {
                value = stdout
            } else {
                value = ""
            }
        }
    }

    Timer {
        interval: frecuency
        running: exePeriodically
        repeat: exePeriodically
        onTriggered: executable.exec(command)
    }

    onExecute: {
        if (!exePeriodically) {
            executable.exec(command)
        }
    }
    Component.onCompleted: {
        execute.connect(onExecute)
    }
}
