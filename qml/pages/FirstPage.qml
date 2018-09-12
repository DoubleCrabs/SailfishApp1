import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    XmlListModel {
        id: m
        source: "http://www.cbr.ru/scripts/XML_daily.asp"
        query: "/ValCurs/Valute"
        XmlRole {
            name: "valute";
            query: "CharCode/string()"
        }
        XmlRole {
            name: "rate";
            query: "Value/string()"
        }
        onStatusChanged: {
            if (status == XmlListModel.Ready) {
                for (var i = 0; i < m.count; i++) {
                    if (m.get(i).valute === "EUR") {
                        main_w.rate = m.get(i).rate;
                        main_w.valute = m.get(i).valute;
                    }
                }
            }
        }
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Конвертер валют")
            }
            Label {
                x: Theme.horizontalPageMargin
                text: qsTr("RUB")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            TextField {
                id: rub_input
                width: parent.width - 2 * x
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeLarge
                validator: DoubleValidator {
                    notation: DoubleValidator.StandardNotation
                    decimals: 2
                    bottom: 0
                }
            }
            Label {
                x: Theme.horizontalPageMargin
                text: main_w.valute
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            TextField {
                id: usd_output
                width: parent.width - 2 * x
                color: Theme.secondaryColor
                font.pixelSize:  Theme.fontSizeLarge
            }
            Button {
                id: b
                text: qsTr("Конвертировать")

                onClicked: {
                    usd_output.text = (rub_input.text / main_w.rate.replace(',', '.')).toFixed(2)
                }
            }
        }
    }
}
