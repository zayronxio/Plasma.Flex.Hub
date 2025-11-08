import QtQuick
import "../lib" as Lib
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami as Kirigami

Item {
    // test
    property bool mouseAreaActive: false
    property var titles: ["Feels like", "Wind", "UV", "Rain"]
    property var values: ["23", "15 km/h", "Low", "78%"] // This data will be replaced by data obtained through the API once the library is ready.

    Lib.Card {
        width: parent.width
        height: parent.height

        Column {
            width: parent.width - generalMargin
            height: parent.height - generalMargin
            anchors.centerIn: parent
            spacing: 4
            Item {
                id: headerSection //weatherTxt
                width: parent.width
                height: headerText.implicitHeight

                Kirigami.Heading {
                    id: headerText
                    width: parent.width
                    text: "Weather"
                    font.weight: Font.DemiBold
                    level: 5
                }
                Kirigami.Icon {
                    width: headerText.implicitHeight
                    height: width
                    source: "draw-arrow-forward-symbolic"
                    anchors.right: parent.right
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {

                        }
                    }
                }

            }


            Item {
                id: currentConditionsSection
                width: parent.width
                height: Plasmoid.configuration.sizeGeneralIcons + Plasmoid.configuration.sizeMarginlIcons

                Text {
                    id: currentTemp
                    height: currentConditionsSection.height
                    text: "34"
                    color: Kirigami.Theme.textColor
                    font.pixelSize: height
                }

                Text {
                    id: tempUnit
                    anchors.left: parent.left
                    anchors.leftMargin: currentTemp.implicitWidth + 4
                    anchors.top: parent.top
                    text: "°C"
                    color: Kirigami.Theme.textColor
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height - cityText.implicitHeight - 4
                    font.pixelSize: height
                }
                Kirigami.Heading  {
                    id: maxMin
                    anchors.left: tempUnit.right
                    anchors.leftMargin: 4
                    anchors.top: parent.top
                    text: "25|30"
                    font.weight: Font.DemiBold
                    level: 5
                    color: Kirigami.Theme.textColor
                    opacity: 0.6
                    height: tempUnit.height
                    verticalAlignment: Text.AlignVCenter

                }

                Kirigami.Heading {
                    id: cityText
                    anchors.left: parent.left
                    anchors.leftMargin: currentTemp.implicitWidth + 4
                    anchors.bottom: parent.bottom
                    text: "Chiapas"
                    font.weight: Font.DemiBold
                    level: 5
                }

                Kirigami.Icon {
                    id: weatherIcon
                    width: parent.height
                    height: width
                    source: "weather-snow-symbolic" //It will be defined based on the API and the weather lib
                    anchors.right: parent.right
                }
            }

            Item {
                id: detailsSection
                width: parent.width
                height: (parent.height - currentConditionsSection.height - headerSection.height)
                Flow {
                    id: detailFlow
                    width: parent.width
                    height: Kirigami.Units.gridUnit*2
                    anchors.bottom: parent.bottom

                    Repeater {
                        model: titles.length

                        Row {

                            width: detailFlow.width / 2
                            height: childrenRect.height
                            spacing: 4

                            Kirigami.Heading {
                                text: titles[modelData]
                                font.weight: Font.DemiBold
                                level: 5
                            }

                            Kirigami.Heading {
                                text: values[modelData]
                                font.weight: Font.DemiBold
                                opacity: 0.7
                                level: 5
                            }
                        }
                    }
                }
            }
        }
    }
}
