import QtQuick 2.0;
import calamares.slideshow 1.0;

Presentation {
    id: presentation

    Timer {
        interval: 7000
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }

    Slide {
        Image {
            source: "slide1.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
        }
        Rectangle {
            anchors.fill: parent
            color: "#99120b1e"
        }
        Text {
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            text: "Welcome to Boykisser Linux :3\n\nThe cutest Debian out there."
            color: "#ff8fc7"
            font.pixelSize: 28
            font.bold: true
        }
    }

    Slide {
        Image {
            source: "slide2.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
        }
        Rectangle {
            anchors.fill: parent
            color: "#99120b1e"
        }
        Text {
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            text: "Everything works out of the box.\n\nFirefox · Steam · OBS · VS Code\nFlatpak + Flathub · NVIDIA support"
            color: "#ffffff"
            font.pixelSize: 22
        }
    }

    Slide {
        Image {
            source: "slide3.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
        }
        Rectangle {
            anchors.fill: parent
            color: "#99120b1e"
        }
        Text {
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            text: "Light or dark — always gay.\n\nThank you for installing! :3"
            color: "#7fd4ff"
            font.pixelSize: 26
            font.bold: true
        }
    }
}
