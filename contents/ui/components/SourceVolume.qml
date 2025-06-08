import QtQuick
import org.kde.plasma.private.volume

QtObject {

    property var sink: PreferredDevice.sink
    readonly property bool sinkAvailable: sink && !(sink && sink.name == "auto_null")
    readonly property int normalVolume: PulseAudio.NormalVolume
    readonly property int volume: sink.volume
    property int sliderValue: value
    property int value: (sink.volume / PulseAudio.NormalVolume * 100)
}
