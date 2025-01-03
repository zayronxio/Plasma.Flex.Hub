import QtQuick
import Qt5Compat.GraphicalEffects

Item {

    SourceMultimedia {
        id: multimedia
    }


    Rectangle {
        id: mask
        width: parent.width
        height: parent.height
        radius: 12
        visible: false
    }
    Image {
        width: parent.width
        height: parent.height
        source: multimedia.cover
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: mask
        }
    }
}
