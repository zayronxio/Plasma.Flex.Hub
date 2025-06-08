import QtQuick
import org.kde.ksvg as KSvg
import org.kde.kirigami as Kirigami

Column {

    property bool enabledHeader: true
    property bool enabledFooter: true

    property int widthSeparator: (marginPlasma.width * 2) + parent.width

    property var actionArrow: ""
    property alias headerContent: headerTitle.children
    property alias mainContent: content.children
    property alias footerContent: footer.children
    property int heightHeadarAndFooter: Kirigami.Units.iconSizes.sizeForLabels*2

    width: parent.width
    height: parent.height

    function action() {
        root.page = ""
    }

    KSvg.SvgItem {
        id: marginPlasma
        imagePath: "dialogs/background"
        elementId: "topleft"
        visible: false
    }

    Item {
        id: header
        width: parent.width
        visible: enabledHeader
        height: Kirigami.Units.iconSizes.sizeForLabels*2
        Row {
            width: parent.width
            height: parent.height
            spacing: Kirigami.Units.iconSizes.sizeForLabels
            Kirigami.Icon {
                width: Kirigami.Units.iconSizes.sizeForLabels
                height: width
                source: "arrow-left"
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: actionArrow !== "" ? actionArrow() : action()
                }
            }
            Item {
                id: headerTitle
                width: parent.width - Kirigami.Units.iconSizes.sizeForLabels*2
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
            }
        }


        KSvg.SvgItem {
            id: separator
            width: widthSeparator
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: - marginPlasma.implicitWidth
            imagePath: "widgets/line"
            elementId: "horizontal-line"
        }

    }
    Item {
        id: content
        width: parent.width
        height: parent.height - header.height - footer.height
    }
    Item {
        id: footer
        width: parent.width
        visible: enabledFooter
        height: Kirigami.Units.iconSizes.sizeForLabels*2
        KSvg.SvgItem {
            id: separatorTop
            width: widthSeparator
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: - marginPlasma.implicitWidth
            imagePath: "widgets/line"
            elementId: "horizontal-line"
        }
    }
}
