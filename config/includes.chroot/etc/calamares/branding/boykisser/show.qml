import QtQuick 2.0
import calamares.slideshow 1.0

Presentation {
    id: presentation

    function onActivate() { presentation.startAutoAdvance(); }
    function onLeave()    { presentation.stopAutoAdvance(); }

    Timer {
        interval: 7000
        running: true
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }

    Slide {
        Image {
            anchors.fill: parent
            source: "/usr/share/backgrounds/boykisser/boykisser1.png"
            fillMode: Image.PreserveAspectCrop
        }
        Rectangle {
            anchors.fill: parent
            color: "#99000000"
        }
        Column {
            anchors.centerIn: parent
            spacing: 12
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Welcome to Boykisser Linux :3"
                color: "#ff8fc7"
                font.pixelSize: 32
                font.bold: true
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "The cutest Debian out there."
                color: "#ffffff"
                font.pixelSize: 20
            }
        }
    }

    Slide {
        Image {
            anchors.fill: parent
            source: "/usr/share/backgrounds/boykisser/boykisser2.png"
            fillMode: Image.PreserveAspectCrop
        }
        Rectangle {
            anchors.fill: parent
            color: "#99000000"
        }
        Column {
            anchors.centerIn: parent
            spacing: 12
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Everything works out of the box"
                color: "#ff8fc7"
                font.pixelSize: 28
                font.bold: true
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Firefox · Steam · OBS · VS Code\nFlatpak + Flathub · NVIDIA support"
                color: "#ffffff"
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Slide {
        Image {
            anchors.fill: parent
            source: "/usr/share/backgrounds/boykisser/boykisser3.jpg"
            fillMode: Image.PreserveAspectCrop
        }
        Rectangle {
            anchors.fill: parent
            color: "#99000000"
        }
        Column {
            anchors.centerIn: parent
            spacing: 12
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Light or dark — always gay."
                color: "#7fd4ff"
                font.pixelSize: 28
                font.bold: true
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Switch themes anytime with Boykisser Theme Toggle.\nThank you for installing! :3"
                color: "#ffffff"
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
