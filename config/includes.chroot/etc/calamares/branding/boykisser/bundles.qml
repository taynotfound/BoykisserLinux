/* Boykisser Linux — app bundle chooser with real checkboxes :3
 *
 * Loaded by packagechooserq@bundles (see packagechooser-bundles.conf).
 * Writes the ticked bundle ids as a comma-joined string (fixed order:
 * gaming,streaming,dev,office) to config.packageChoice, which the module's
 * "legacy" method stores in GlobalStorage as packagechooser_bundles —
 * exactly what contextualprocess-bundles.conf branches on.
 */
import io.calamares.core 1.0
import io.calamares.ui 1.0

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    width:  parent.width
    height: parent.height

    // Fixed order must match contextualprocess-bundles.conf branch keys.
    property var bundleOrder: [ "gaming", "streaming", "dev", "office" ]
    property var picked: ({ gaming: false, streaming: false, dev: false, office: false })

    function updateChoice() {
        var ids = [];
        for (var i = 0; i < bundleOrder.length; ++i)
            if (picked[bundleOrder[i]])
                ids.push(bundleOrder[i]);
        config.packageChoice = ids.join(",");
    }

    Rectangle {
        anchors.fill: parent
        color: "#f7eef3"

        ColumnLayout {
            anchors.centerIn: parent
            width: Math.min(parent.width - 64, 700)
            spacing: 12

            Text {
                Layout.fillWidth: true
                text: qsTr("<b>App bundles</b><br/>Tick anything you want preinstalled. All bundles need an internet connection during install — no internet, no problem, they're just skipped.")
                font.pointSize: 11
                wrapMode: Text.WordWrap
                color: "#2b2b2b"
            }

            Repeater {
                model: [
                    { id: "gaming",    title: qsTr("Gaming"),                 desc: qsTr("Steam, Lutris, GameMode and MangoHud — ready to game out of the box.") },
                    { id: "streaming", title: qsTr("Streaming & Creation"),   desc: qsTr("OBS Studio, Kdenlive and Audacity for streaming, video and audio work.") },
                    { id: "dev",       title: qsTr("Development"),            desc: qsTr("git, build-essential, Python, Node.js and Podman for hacking on things.") },
                    { id: "office",    title: qsTr("Office & Productivity"),  desc: qsTr("LibreOffice, Thunderbird and Evince for documents, mail and PDFs.") }
                ]

                delegate: Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: row.implicitHeight + 24
                    radius: 10
                    color: "#ffffff"
                    border.color: check.checked ? "#e05a9c" : "#e6dbe1"
                    border.width: check.checked ? 2 : 1

                    RowLayout {
                        id: row
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12

                        CheckBox {
                            id: check
                            checked: false
                            onCheckedChanged: {
                                picked[modelData.id] = checked;
                                updateChoice();
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            Text { text: modelData.title; font.pointSize: 11; font.bold: true; color: "#2b2b2b" }
                            Text { Layout.fillWidth: true; text: modelData.desc; font.pointSize: 9; wrapMode: Text.WordWrap; color: "#5a5257" }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: check.checked = !check.checked
                        z: -1
                    }
                }
            }
        }
    }
}
