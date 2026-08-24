/*
    SPDX-FileCopyrightText: 2016 Boudhayan Gupta <bgupta@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick
import Qt.labs.folderlistmodel

FocusScope {
    id: sceneBackground

    property var sceneBackgroundType
    property alias sceneBackgroundColor: sceneColorBackground.color
    property alias sceneBackgroundImage: sceneImageBackground.source
    property string sceneBackgroundDirectory: config.backgroundDirectory || ""
    property int sceneBackgroundInterval: parseInt(config.backgroundInterval || "30") * 1000
    property int sceneBackgroundTransition: parseInt(config.backgroundTransition || "1") * 1000

    Rectangle {
        id: sceneColorBackground
        anchors.fill: parent
    }

    Image {
        id: sceneImageBackground
        anchors.fill: parent
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        fillMode: Image.PreserveAspectCrop
        smooth: true
        visible: sceneBackgroundType !== "imageDirectory"
    }

    // Use two images and crossfade between them when cycling a directory
    Image {
        id: bgImageA
        anchors.fill: parent
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        fillMode: Image.PreserveAspectCrop
        smooth: true
        visible: opacity > 0
        opacity: _imageAActive ? 1 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: sceneBackgroundTransition
                easing.type: Easing.InOutQuad
            }
        }
    }

    Image {
        id: bgImageB
        anchors.fill: parent
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        fillMode: Image.PreserveAspectCrop
        smooth: true
        visible: opacity > 0
        opacity: _imageAActive ? 0 : 1
        Behavior on opacity {
            NumberAnimation {
                duration: sceneBackgroundTransition
                easing.type: Easing.InOutQuad
            }
        }
    }

    FolderListModel {
        id: wallpaperFolderModel
        folder: sceneBackgroundType === "imageDirectory" && sceneBackgroundDirectory !== "" ?
                (sceneBackgroundDirectory.indexOf(":/") === -1 && sceneBackgroundDirectory.indexOf("/") !== 0 ?
                 Qt.resolvedUrl(sceneBackgroundDirectory) : sceneBackgroundDirectory) : ""
        nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp", "*.bmp", "*.svg"]
        sortField: FolderListModel.Unsorted
        showDirs: false
        showHidden: false
    }

    property int _currentImageIndex: 0
    property bool _imageAActive: true

    function _loadImage(target, index) {
        if (wallpaperFolderModel.count === 0 || index < 0 || index >= wallpaperFolderModel.count) {
            return;
        }
        var fileUrl = wallpaperFolderModel.get(index, "fileUrl");
        target.source = fileUrl;
    }

    function _advanceBackground() {
        if (wallpaperFolderModel.count === 0) {
            return;
        }
        var nextIndex = (_currentImageIndex + 1) % wallpaperFolderModel.count;
        var nextTarget = _imageAActive ? bgImageB : bgImageA;
        _loadImage(nextTarget, nextIndex);
        _imageAActive = !_imageAActive;
        _currentImageIndex = nextIndex;
    }

    Timer {
        id: backgroundCycleTimer
        interval: sceneBackgroundInterval
        running: sceneBackgroundType === "imageDirectory" && wallpaperFolderModel.count > 1
        repeat: true
        triggeredOnStart: false
        onTriggered: _advanceBackground()
    }

    states: [
        State {
            name: "imageBackground"
            when: sceneBackgroundType === "image"
            PropertyChanges { sceneColorBackground.visible: false }
            PropertyChanges { sceneImageBackground.visible: true }
        },
        State {
            name: "imageDirectoryBackground"
            when: sceneBackgroundType === "imageDirectory"
            PropertyChanges { sceneColorBackground.visible: false }
        },
        State {
            name: "colorBackground"
            when: sceneBackgroundType !== "image" && sceneBackgroundType !== "imageDirectory"
            PropertyChanges { sceneColorBackground.visible: true }
            PropertyChanges { sceneImageBackground.visible: false }
        }
    ]

    onSceneBackgroundDirectoryChanged: {
        if (sceneBackgroundType === "imageDirectory") {
            bgImageA.source = "";
            bgImageB.source = "";
            _currentImageIndex = 0;
            _imageAActive = true;
            wallpaperFolderModel.folder = Qt.binding(function() {
                if (sceneBackgroundDirectory === "") return "";
                if (sceneBackgroundDirectory.indexOf(":/") === -1 && sceneBackgroundDirectory.indexOf("/") !== 0) {
                    return Qt.resolvedUrl(sceneBackgroundDirectory);
                }
                return sceneBackgroundDirectory;
            });
        }
    }

    Connections {
        target: wallpaperFolderModel
        function onCountChanged() {
            if (sceneBackgroundType === "imageDirectory" && wallpaperFolderModel.count > 0) {
                _currentImageIndex = 0;
                _imageAActive = true;
                _loadImage(bgImageA, 0);
                if (wallpaperFolderModel.count > 1) {
                    _loadImage(bgImageB, 1);
                }
                backgroundCycleTimer.restart();
            }
        }
    }
}
