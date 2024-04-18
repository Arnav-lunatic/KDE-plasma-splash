import QtQuick 2.5


Image {
    id: root
    source: "images/bg.jpg"

    property int stage

    onStageChanged: {
        if (stage == 1) {
            introAnimation.running = true
        }
    }

    Item {
        id: content
        anchors.fill: parent
        opacity: 0
        TextMetrics {
            id: units
            text: "M"
            property int gridUnit: boundingRect.height
            property int largeSpacing: units.gridUnit
            property int smallSpacing: Math.max(2, gridUnit/4)
        }

        Image {
            id: logo
            //match SDDM/lockscreen avatar positioning
            property real size: units.gridUnit * 20

            anchors.centerIn: parent

            source: "images/logo.png"

            sourceSize.width: size
            sourceSize.height: size

            ParallelAnimation {
                running: true

                ScaleAnimator {
                    target: logo
                    from: 0
                    to: 1
                    duration: 700
                }

                SequentialAnimation {
                    loops: Animation.Infinite

                    ScaleAnimator {
                        target: logo
                        from: 0.97
                        to: 1
                        duration: 1000
                    }
                    ScaleAnimator {
                        target: logo
                        from: 1
                        to: 0.97
                        duration: 1000
                    }
                }
            }
        
        }


        Rectangle {
            radius: 4
            color: "#232831"
            opacity: 0.9
            y: parent.height - (parent.height - logo.y) / 3 - height/2
            anchors.horizontalCenter: parent.horizontalCenter
            height: 6
            width: height*32
            Rectangle {
                radius: 3
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }
                width: (parent.width / 6) * (stage - 1)
                color: "#4c566a"
                Behavior on width { 
                    PropertyAnimation {
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        Row {
            spacing: units.smallSpacing*2
            anchors {
                bottom: parent.bottom
                // right: parent.right
                margins: units.gridUnit
            }
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                color: "#eff0f1"
                // Work around Qt bug where NativeRendering breaks for non-integer scale factors
                // https://bugreports.qt.io/browse/QTBUG-67007
                renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering
                anchors.verticalCenter: parent.verticalCenter
                text: "Not For Noobs"
                font.bold : bool
                font.pointSize: 20
            }
        }

    }

    OpacityAnimator {
        id: introAnimation
        running: false
        target: content
        from: 0
        to: 1
        duration: 1000
        easing.type: Easing.InOutQuad
    }
}
