import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami
import org.kde.mauikit 1.0 as Maui
//import FMH 1.0


ColumnLayout
{
    id: control
//    orientation: Qt.Vertical

    height: _browserList.height
    width: _browserList.width
    property alias browser : browser
    property bool terminalVisible : true
    property alias terminal : terminalLoader.item

    Maui.FileBrowser
    {
        id: browser
        Layout.fillWidth: true
        Layout.fillHeight: true
        headBar.visible: true
        headBar.drawBorder: true
        headBar.plegable: false
        itemMenu.contentData: [
            MenuItem
            {
                visible: browser.itemMenu.isDir
                text: qsTr("Open in tab")
                onTriggered: openTab(browser.itemMenu.item.path)
            }
        ]

        menu: [
            MenuItem
            {
                visible: !isMobile
                text: qsTr("Show terminal")
                checkable: true
                checked: terminalVisible
                onTriggered:
                {
                    terminalVisible = !terminalVisible
                    Maui.FM.setDirConf(browser.currentPath+"/.directory", "MAUIFM", "ShowTerminal", terminalVisible)
                }
            }
        ]

        headBar.rightContent: ToolButton
        {
            visible: control.terminal
            icon.name: "akonadiconsole"
            onClicked: control.terminalVisible = !control.terminalVisible
            checked : control.terminalVisible
            checkable: false
        }

        onNewBookmark:
        {
            for(var index in paths)
                placesSidebar.list.addPlace(paths[index])
        }

        onCurrentPathChanged:
        {
//            if(!isAndroid)
//                terminalVisible = Maui.FM.dirConf(currentPath+"/.directory")["showterminal"] === "true" ? true : false

                        if(terminalVisible && !isMobile)
                            terminal.session.sendText("cd '" + currentPath + "'\n")

            for(var i = 0; i < placesSidebar.count; i++)
                if(currentPath === placesSidebar.list.get(i).path)
                    placesSidebar.currentIndex = i
        }

        onItemClicked: openItem(index)

        onItemDoubleClicked:
        {
            var item = list.get(index)
            console.log(item.mime)
            if(Maui.FM.isDir(item.path) || item.mime === "inode/directory")
                browser.openFolder(item.path)
            else
                browser.openFile(item.path)
        }
    }

//    Rectangle
//    {
//        id: handle
//        visible: true

//        Layout.fillWidth: true
//        height: 5
//        color: "transparent"

//        Kirigami.Separator
//        {
//            visible: terminalLoader.visible

//            anchors
//            {
//                bottom: parent.bottom
//                right: parent.right
//                left: parent.left
//            }
//        }

//        MouseArea
//        {
//            visible: terminalLoader.visible

//            anchors.fill: parent
//            drag.target: parent
//            drag.axis: Drag.YAxis
//            drag.smoothed: true
//            cursorShape: Qt.SizeVerCursor
//        }
//    }

//    handle: Rectangle
//    {
//        color: "yellow"
//    }

    Loader
    {
        id: terminalLoader
        visible: terminalVisible && terminal
        focus: true
        Layout.fillWidth: true
//        Layout.fillHeight: true
        Layout.minimumHeight: visible && terminal ? 100 : 0
        Layout.maximumHeight: visible && terminal ? 500 : 0
        Layout.preferredHeight : visible && terminal ? 200 : 0
        source: !isMobile ? "Terminal.qml" : undefined
    }

}
