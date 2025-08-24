import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    property var elements: Plasmoid.configuration.elements
    property var yElements: Plasmoid.configuration.yElements
    property var xElements: Plasmoid.configuration.xElements


    compactRepresentation: MouseArea {
        id: compactRoot

        readonly property bool tooSmall: Plasmoid.formFactor === PlasmaCore.Types.Horizontal && Math.round(2 * (compactRoot.height / 5)) <= PlasmaCore.Theme.smallestFont.pixelSize

        Layout.minimumWidth: isVertical ? 0 : compactRow.implicitWidth
        Layout.maximumWidth: isVertical ? Infinity : Layout.minimumWidth
        Layout.preferredWidth: isVertical ? undefined : Layout.minimumWidth

        Layout.minimumHeight: isVertical ? label.height : Kirigami.Theme.smallestFont.pixelSize
        Layout.maximumHeight: isVertical ? Layout.minimumHeight : Infinity
        Layout.preferredHeight: isVertical ? Layout.minimumHeight : Kirigami.Theme.mSize(Kirigami.Theme.defaultFont).height * 2

        property bool wasExpanded
        onPressed: wasExpanded = root.expanded
        onClicked: root.expanded = !wasExpanded

        Kirigami.Icon {
            id: logoPlasmoid
            width: 22
            height: 22
            source: Plasmoid.icon
            //isMask: true
            color: Kirigami.Themes.textColor
            anchors.centerIn: parent
        }
    }
    fullRepresentation: FullRepresentation {
    }
}

