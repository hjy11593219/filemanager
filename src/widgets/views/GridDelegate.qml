import QtQuick 2.9
import org.kde.kirigami 2.15 as Kirigami
import org.kde.mauikit 1.3 as Maui
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.14

Rectangle {
    id: listViewDelegate

    property string iconSource
    property string tagSource
    property string fileSize
    property string fileName
    property string fileDate
    property string tagColor
    property bool isFolder
    property int textDefaultSize: theme.defaultFont.pointSize
    property bool checked: _selectionBar.contains(path)
    property bool isRename: _renameSelectionBar.contains(path)
    property string tmpName
    property var clickMouse

    // property int refreshIndex: -1
    /**
      * draggable :
      */
    property bool draggable: false


    /**
      * pressed :
      */
    signal pressed(var mouse)

    /**
      * pressAndHold :
      */
    signal pressAndHold(var mouse)

    /**
      * clicked :
      */
    signal clicked(var mouse)

    /**
      * rightClicked :
      */
    signal rightClicked(var mouse)

    /**
      * doubleClicked :
      */
    signal doubleClicked(var mouse)

    signal contentDropped(var drop)

    /**
      * toggled :
      */
    signal toggled(bool state)

    radius: 20
    color: "#FFFFFFFF"

    Item//上方的图片
    {
        id:iconItem
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        width: 70
        height: width

        Image
        {
            id: iconImage
            asynchronous: true
            cache: true
            smooth: false
            width: 70
            height: width

            sourceSize.width: 70
            sourceSize.height: 70

            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter

            //fillMode: Image.PreserveAspectCrop
            fillMode: Image.PreserveAspectFit
            // fillMode: Image.Pad

            

            visible: !root_zipList._uris.includes(model.path)
            
            source: 
            {
                iconSource
            }

            layer.enabled: Maui.Style.radiusV
            layer.effect: OpacityMask
            {
                maskSource: Item
                {
                    width: iconImage.width
                    height: iconImage.height
                    
                    Rectangle
                    {
                        anchors.centerIn: parent
                        width: Math.min(parent.width, iconImage.paintedWidth)
                        height: Math.min(parent.height, iconImage.paintedHeight)
                        radius: Maui.Style.radiusV
                    }
                }
            }

            Connections
            {
                target: leftMenuData
                onRefreshImageSource: 
                {
                    if(iconSource == imagePath)
                    {
                        if(mime.indexOf("image") != -1)
                        {
                           iconImage.source = "qrc:/assets/image_default.png"
                        }else if(mime.indexOf("video") != -1)
                        {
                           iconImage.source = "qrc:/assets/video_default.png"
                        }
                        iconImage.source = imagePath
                    }
                }
            }
        }

        AnimatedImage
        {
            id: gifImage

            width: 70
            height: width

            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent.centerIn

            source: 
            {
                if(model.label.indexOf(".zip") != -1)
                {
                    "qrc:/assets/zip.gif"
                }else
                {
                    "qrc:/assets/unzip.gif"
                }
            }

            visible: root_zipList._uris.includes(model.path)

            playing: visible
            
            MouseArea 
            {
            }
        }

        Kirigami.Icon
        {
            visible: iconImage.status !== Image.Ready
            anchors.centerIn: iconItem.centerIn
            height: width
            width: 70
            source: 
            {
                if(mime.indexOf("image") != -1)
                {
                     "qrc:/assets/image_default.png"
                }else if(mime.indexOf("video") != -1)
                {
                    "qrc:/assets/video_default.png"
                }else
                {
                    "qrc:/assets/default.png"
                }
            }
            isMask: false
            opacity: 0.5
        }
    }

    Rectangle{
        id:fileNameSize

        anchors{
            top: iconItem.bottom
            topMargin: 8
            horizontalCenter : iconItem.horizontalCenter
        }
        width: parent.width
        height: 115 - 70 - 6//26 + 52//fileNameText.contentHeight + fileSizeText.contentHeight + 4
        color: "transparent"

        Image //编辑态时的选中 非选中状态
        {
            id: checkStatusImage

            anchors{
                left: parent.left
                top: parent.top
                topMargin: -10
            }

            width: 22
            height: 22

            cache: false
            source: 
            {
                if(checked)
                {
                    "qrc:/assets/select_all.png"
                }else{
                    "qrc:/assets/unselect_rect.png"
                }
            }
            
            visible: 
            {
                if(root.selectionMode)
                {
                    true
                }else
                {
                    false
                }
            }
        }

        Item//文件名称和size
        {
            id: midRect
            width: 
            {
                if(root.selectionMode)
                {
                    if(tagRect.width > 0)
                    {
                        parent.width - checkStatusImage.width - tagRect.width
                    }else
                    {
                        parent.width - checkStatusImage.width - 16
                    }
                    
                }else
                {
                    
                    if(fileNameText1.contentWidth + (tagRect.width * 2) > width)
                    {
                        parent.width - (tagRect.width * 2)
                    }else
                    {
                        parent.width
                    }
                }
            }
            height: {
                if(fileNameText.visible)
                {
                    fileNameText.height
                }else
                {
                    fileNameText1.height
                }
            }
            anchors.top: parent.top
            anchors.topMargin: -6
            anchors.left: 
            {
                if(root.selectionMode)
                {
                    checkStatusImage.right
                }else
                {
                    parent.left
                }
            }
            anchors.leftMargin:
            {
                if(root.selectionMode)
                {
                    if(tagRect.width > 0)
                    {
                        tagRect.width
                    }else
                    {
                        8
                    }
                }else
                {
                    if(fileNameText1.contentWidth + (tagRect.width * 2) > width)
                    {
                        tagRect.width
                    }else
                    {
                        0
                    }
                }
            }

            Item
            {
                visible: !fileNameText.visible
                width: parent.width
                height: {
                        fileNameText1.height
                }
                anchors.top: parent.top
                anchors.left: 
                {
                    parent.left
                }
                anchors.leftMargin: 
                {
                    if(root.selectionMode)
                    {
                        0
                    }else
                    {
                        (midRect.width - fileNameText1.contentWidth) / 2
                    }
                }

                Image{
                    id:tagRect
                    anchors{
                        top: fileNameText1.top
                        topMargin: -3
                        right:
                        {
                            fileNameText1.left
                        } 
                    }
                    width: (tagSource !== "" && visible) ? 16 : 0
                    height: 16
                    source: tagSource
                    visible:{
                        // if(root_renameSelectionBar.count == 0)
                        if(!isRename)
                        {
                            true
                        }else
                        {
                            false
                        }
                    }
                }

                Text {
                    visible:
                    {
                        // if(root_renameSelectionBar.count == 0)
                        if(!isRename)
                        {
                            true
                        }else
                        {
                            false
                        }
                    } 
                    id: fileNameText1
                    anchors{
                        top: parent.top
                        left:
                        {
                            parent.left
                        }
                    }
                    width: 
                    {
                        parent.width
                    }
                    text: fileName
                    font.pixelSize: 11
                    color: "black"
                    wrapMode: Text.WrapAnywhere
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    clip: true
                }
            }

            TextField  {
                background: Rectangle
                {
                    // width: contentWidth
                    // height: contentHeight
                    color: "#00000000"
                }
                visible: 
                {
                    // if(root_renameSelectionBar.count == 0)
                    if(!isRename)
                    {
                        false
                    }else
                    {
                        true
                    }
                }
                id: fileNameText
                anchors{
                    top: parent.top
                    topMargin: -6
                    left: parent.left
                    // horizontalCenter: parent.horizontalCenter
                }
                text:
                {
                    fileName
                } 
                maximumLength: 50
                font.pixelSize: 11
                color: "black"
                horizontalAlignment: Text.AlignHCenter
                // horizontalAlignment: Text.AlignLeft
                clip: true
                selectionColor: "#FF3C4BE8"
                width: parent.width

                onEditingFinished: {
                    if((fileNameText.text.indexOf("#") != -1)
                    || (fileNameText.text.indexOf("/") != -1)
                    || (fileNameText.text.indexOf("?") != -1))
                    {//不允许包含特殊字符
                        fileNameText.text = tmpName
                        showToast(i18n("The file name cannot contain the following characters: '# / ?'"))
                    }else if(fileNameText.text.startsWith("."))
                    {
                        fileNameText.text = tmpName
                        showToast(i18n("The file name cannot starts whit character: '.'"))
                    }else
                    {
                        var canRename = true
                        var userNotRename = false //处理用户rename了，但是没有任何修改直接退出了rename状态
                        for(var i = 0; i < currentBrowser.currentFMList.count; i++)
                        {
                            var item = currentFMModel.get(i)
                            if(item.label == fileNameText.text)
                            {
                                if(item.path != model.path)
                                {
                                    canRename = false
                                }else
                                {
                                    userNotRename = true
                                }
                                break
                            }
                        }

                        if(!userNotRename)
                        {
                            if(canRename)
                            {
                                var collectionList = leftMenuData.getCollectionList();
                                var needRefreshCollection = false
                                if(leftMenuData.isCollectionFolder(path))
                                {
                                    leftMenuData.addFolderToCollection(path.toString(), true, false)
                                    needRefreshCollection = true
                                }

                                // if(root.isSpecialPath)//先记录需要刷新的index
                                // {
                                //     for(var j = 0; j < root.currentBrowser.currentFMList.count; j++)
                                //     {
                                //         var listItem = root.currentBrowser.currentFMModel.get(j)
                                //         if(listItem.path == path)
                                //         {
                                //             refreshIndex = j
                                //             break
                                //         }
                                //     }
                                // }

                                Maui.FM.rename(path, fileNameText.text)

                                if(item.mime.indexOf("image/jpeg") != -1
                                || item.mime.indexOf("video") != -1)//对于生成了缩略图的文件来说 重命名时 会连带缩略图一起
                                {
                                    var index = item.path.lastIndexOf(".")
                                    var newPath = item.path.substring(0, index)//path/name
                                    index = newPath.lastIndexOf("/")
                                    var startPath = newPath.substring(0, index + 1);//path/
                                    var endPath = newPath.substring(index + 1, newPath.length)//name
                                    var tmpPreview = startPath + "." + endPath + ".jpg"
                                    Maui.FM.rename(tmpPreview, "." + fileNameText.text)
                                }

                                if(root.isSpecialPath)//如果是特殊目录，系统不会自动刷新，那么需要自行刷新
                                {
                                    timer_refresh.start()
                                }

                                if(needRefreshCollection)
                                {
                                    timer_fav.start();
                                }
                            }else
                            {
                                fileNameText.text = tmpName
                                showToast(i18n("The file name already exists."))
                            }
                        }
                    }
                    root_renameSelectionBar.clear()
                }

                onFocusChanged:
                {
                    if(focus)
                    {
                        tmpName = fileNameText.text
                    }
                }
            }
        }

        Text {//非编辑态的filesize
            id: fileSizeText
            anchors{
                top: {
                    midRect.bottom
                }
                topMargin:{
                    // if(root_renameSelectionBar.count == 0)
                    if(!isRename)
                    {
                        5
                    }else
                    {
                        -10
                    }
                } 
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width - 5
            horizontalAlignment: Text.AlignHCenter
            text: fileSize
            font.pixelSize: 10
            color: "#4D000000"
            visible:
            {
                if(String(root.currentPath).startsWith("trash:/") && model.isdir == "true")
                {
                    false
                }else
                {
                    if(root.selectionMode)
                    {
                        false
                    }else
                    {
                        true
                    }
                }
            }
        }

        Text {//编辑态的filesize
            id: fileSizeText1
            anchors{
                top: 
                {
                    midRect.bottom
                }
                topMargin: 5
                left: parent.left
                leftMargin:
                {
                    if(tagRect.width > 0)
                    {
                        checkStatusImage.width + tagRect.width
                    }else
                    {
                        checkStatusImage.width + 16
                    }
                }
            }
            width: contentWidth
            text: fileSize
            font.pixelSize: 10
            color: "#4D000000"
            visible:
            {
                if(root.selectionMode)
                {
                    true
                }else
                {
                    false
                }
        }
        }
    }

    DropArea
    {
        id: _dropArea
        anchors.fill: parent
        enabled: listViewDelegate.draggable

        Rectangle
        {
            anchors.fill: parent
            radius: 20
            color: "blue"
            visible: parent.containsDrag
            opacity: 0.3
        }

        onDropped:
        {
            listViewDelegate.contentDropped(drop)
        }
    }

    MouseArea
    {
        id: _mouseArea
        anchors.fill: parent
        acceptedButtons:  Qt.RightButton | Qt.LeftButton
        property bool pressAndHoldIgnored : false
        drag.axis: Drag.XAndYAxis

        onCanceled:
        {
            if(listViewDelegate.draggable)
            {
                drag.target = null
            }
        }

        onClicked:
        {
            if(mouse.button === Qt.RightButton)
            {
                listViewDelegate.rightClicked(mouse)
            }
            else
            {
                listViewDelegate.color = "#1F767680"
                clickMouse = mouse
                timer.start()
            }
        }

        onDoubleClicked:
        {
            listViewDelegate.doubleClicked(mouse)
        }

        onPressAndHold :
        {
            drag.target = null
            listViewDelegate.pressAndHold(mouse)
        }
    }

    Connections//编辑态的多选
    {
        target: root_selectionBar

        onUriRemoved:
        {
            if(String(root.currentPath).startsWith("trash:/"))    
            {
                if(uri === model.nickname)
                {
                    listViewDelegate.checked = false
                }
            }else
            {
                if(uri === model.path)
                {
                    listViewDelegate.checked = false
                }
            }
        }

        onUriAdded:
        {
            if(String(root.currentPath).startsWith("trash:/"))    
            {
                if(uri === model.nickname)
                {
                    listViewDelegate.checked = true
                }
            }else
            {
                if(uri === model.path)
                {
                    listViewDelegate.checked = true
                }
            }
        }

        onCleared: 
        {
            listViewDelegate.checked = false
        }
    }

    Connections//重命名
    {
        target: root_renameSelectionBar
        
        onUriRemoved:
        {
            if(uri === model.path)
            {
                fileNameText.focus = false
                isRename = false
            }
        }

        onUriAdded:
        {
            if(uri === model.path)
            {
                fileNameText.forceActiveFocus()
                var indexOfd = fileNameText.text.lastIndexOf(".")
                if(indexOfd != -1)
                {
                    fileNameText.select(0, indexOfd)
                }else
                {
                    fileNameText.selectAll()
                }
                isRename = true
            }
        }

        onCleared: 
        {
            fileNameText.focus = false
            isRename = false
        }
    }

    Connections//右键menu时候的背景效果
    {
        target: root_menuSelectionBar

        onUriRemoved:
        {
            if(uri === model.path)
                listViewDelegate.color = "#FFFFFFFF"
        }

        onUriAdded:
        {
            if(uri === model.path)
                listViewDelegate.color = "#1F9F9FAA"
        }

        onCleared: 
        {
            listViewDelegate.color = "#FFFFFFFF"
        }
    }

    Timer {//点击时候的背景效果
        id: timer
        running: false
        repeat: false
        interval: 50
        onTriggered: {
            listViewDelegate.color = "#FFFFFFFF"
            listViewDelegate.clicked(clickMouse)
        }
    }

    Timer {
        id: timer_fav
        running: false
        repeat: false
        interval: 50
        onTriggered: {
            var index = path.lastIndexOf("/")
            var startPath = path.substring(0, index + 1)
            leftMenuData.addFolderToCollection((startPath + fileNameText.text).toString(), false, true)
        }
    }

    Timer {
        id: timer_refresh
        running: false
        repeat: false
        interval: 100
        onTriggered: {
            root.currentBrowser.currentFMList.refresh()
            // for(var j = 0; j < root.currentBrowser.currentFMList.count; j++)
            // {
            //     var listItem = root.currentBrowser.currentFMModel.get(j)
            //     if(listItem.path == path)
            //     {
                    // root.currentBrowser.currentFMList.refreshItem(j, listItem.path)
            //         break
            //     }
            // }
            // root.currentBrowser.currentFMList.refreshItem(refreshIndex, fileNameText.text)
        }
    }

    
}
