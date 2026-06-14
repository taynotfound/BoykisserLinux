import QtQuick 2.0
import calamares.slideshow 1.0

Presentation {
    id: presentation

    function onActivate() { presentation.startAutoAdvance(); }
    function onLeave()    { presentation.stopAutoAdvance(); }

    Timer {
        interval: 6000
        running: true
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#241447"
            Text {
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                text: "Welcome to Boykisser Linux  :3\n\nThe cutest Debian out there."
                color: "#ff8fc7"
                font.pixelSize: 30
                font.bold: true
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#241447"
            Text {
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                text: "Everything is ready to go:\nFirefox · Steam · OBS (+ Virtual Camera)\nVS Code Insiders · Flatpak + Flathub\nGNOME Software · NVIDIA support"
                color: "#ffffff"
                font.pixelSize: 24
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#241447"
            Text {
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                text: "Light or dark — always gay.\nUse the Boykisser Theme Toggle anytime.\n\nThank you for installing!  :3"
                color: "#7fd4ff"
                font.pixelSize: 26
                font.bold: true
            }
        }
    }
}
