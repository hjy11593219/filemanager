/*
 *   Copyright 2018 Camilo Higuita <milo.h@aol.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.kde.mauikit 1.2 as Maui
import org.kde.kirigami 2.15 as Kirigami

/**
 * ListBrowser
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
Item
{
    id: control

    implicitHeight: contentHeight + margins*2
    implicitWidth: contentWidth + margins*2

    /**
      * model : var
      */
    property alias model : _listView.model

    /**
      * delegate : Component
      */
    property alias delegate : _listView.delegate

    /**
      * section : ListView.section
      */
    property alias section : _listView.section

    /**
      * contentY : int
      */
    property alias contentY: _listView.contentY

    /**
      * currentIndex : int
      */
    property alias currentIndex : _listView.currentIndex

    /**
      * currentItem : Item
      */
    property alias currentItem : _listView.currentItem

    /**
      * count : int
      */
    property alias count : _listView.count

    /**
      * cacheBuffer : int
      */
    property alias cacheBuffer : _listView.cacheBuffer

    /**
      * orientation : ListView.orientation
      */
    property alias orientation: _listView.orientation

    /**
      * snapMode : ListView.snapMode
      */
    property alias snapMode: _listView.snapMode

    /**
      * spacing : int
      */
    property alias spacing: _listView.spacing

    /**
      * flickable : Flickable
      */
    property alias flickable : _listView

    /**
      * scrollView : ScrollView
      */
    // property alias scrollView : _scrollView

    /**
      * contentHeight : int
      */
    property alias contentHeight : _listView.contentHeight

        /**
      * contentWidth : int
      */
    property alias contentWidth : _listView.contentWidth

    /**
      * atYEnd : bool
      */
    property alias atYEnd : _listView.atYEnd

        /**
      * atYBeginning : bool
      */
    property alias atYBeginning : _listView.atYBeginning

    /**
      * margins : int
      */
    property int margins : control.enableLassoSelection ?  Maui.Style.space.medium : Maui.Style.space.small

    /**
      * topMargin : int
      */
    property int topMargin: margins

    /**
      * bottomMargin : int
      */
    property int bottomMargin: margins

    /**
      * bottomMargin : int
      */
    property int rightMargin: margins

    /**
      * leftMargin : int
      */
    property int leftMargin: margins

    /**
      * leftMargin : int
      */
    property int verticalScrollBarPolicy: ScrollBar.AlwaysOff //ScrollBar.AlwaysOn

    /**
      * horizontalScrollBarPolicy : ScrollBar.policy
      */
    property int horizontalScrollBarPolicy:  _listView.orientation === Qt.Horizontal ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff //ScrollBar.AlwaysOn

    /**
      * holder : Holder
      */
    // property alias holder : _holder

    /**
      * enableLassoSelection : bool
      */
    property bool enableLassoSelection : false

    /**
      * selectionMode : bool
      */
    property bool selectionMode: false

    /**
      * lassoRec : Rectangle
      */
    // property alias lassoRec : selectLayer
    property string backColor : "#FFFFFF"

    /**
      * itemsSelected :
      */
    signal itemsSelected(var indexes)

    /**
      * areaClicked :
      */
    signal areaClicked(var mouse)

    /**
      * areaRightClicked :
      */
    signal areaRightClicked(var mouse)

    /**
      * keyPress :
      */
    signal keyPress(var event)

    Kirigami.Theme.colorSet: Kirigami.Theme.View

    Keys.enabled : true
    Keys.forwardTo : _listView

    Rectangle{
        anchors.fill: parent
        color: backColor
    }

    // ScrollView
    // {
    //     id: _scrollView
    //     anchors.fill: parent
    //     ScrollBar.horizontal.policy: control.horizontalScrollBarPolicy
    //     ScrollBar.vertical.policy: control.verticalScrollBarPolicy

        ListView
        {
            id: _listView

            // property alias position : _hoverHandler.point.position
            property var selectedIndexes : []

            anchors.fill: parent
            // anchors.rightMargin: wholeScreen.width / 43.63 + wholeScreen.height / 120 + wholeScreen.width / 24
            // anchors.rightMargin: Kirigami.Settings.hasTransientTouchInput ? control.rightMargin: parent.ScrollBar.vertical.visible ? parent.ScrollBar.vertical.width + control.rightMargin : control.rightMargin
            // anchors.bottomMargin: Kirigami.Settings.hasTransientTouchInput ? control.bottomMargin : parent.ScrollBar.horizontal.visible ? parent.ScrollBar.horizontal.height + control.bottomMargin : control.bottomMargin

            anchors.leftMargin: 45//control.leftMargin
            anchors.rightMargin: 45//30
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            // anchors.topMargin: control.topMargin
            // anchors.margins: control.margins

            focus: true
            // clip: true
            cacheBuffer: _listView.height * 1.5   
            spacing: 20//40//control.enableLassoSelection ? Maui.Style.space.medium : Maui.Style.space.small
            boundsBehavior: !Kirigami.Settings.isMobile? Flickable.StopAtBounds :
                                                         Flickable.OvershootBounds

            //动画添加 start
            // populate: Transition{
                // NumberAnimation{
                //     property: "opacity"
                //     from: 0
                //     to: 1.0
                //     duration: 1000
                // }
                // NumberAnimation { properties: "x,y"; duration: 1000 }
            // }//populate Transition is end

            // add:Transition {
            //     ParallelAnimation{
            //         NumberAnimation{
            //             property: "opacity"
            //             from: 0
            //             to : 1.0
            //             duration: 1000
            //         }

            //         NumberAnimation{
            //             property: "y"
            //             from: 0
            //             duration:  1000
            //         }
            //     }
            // }// add transition is end

            /*  displaced属性
            *  此属性用于指定通用的、由于model变化导致Item位移时的动画效果，还有removeDisplaced、moveDisplaced
            *  如果同时指定了displaced 和xxxDisplaced,那么xxxDisplaced生效
            */
            // displaced: Transition {
            //     SpringAnimation{
            //         property: "y"
            //         spring: 3
            //         damping: 0.1
            //         epsilon: 0.25
            //     }
            // NumberAnimation { properties: "x,y"; duration: 1000 }
            // }

            // remove: Transition {
            //     SequentialAnimation{
            //         NumberAnimation{
            //             property: "y"
            //             to: 0
            //             duration: 600
            //         }

            //         NumberAnimation{
            //             property: "opacity"
            //             to:0
            //             duration: 600
            //         }
            //     }
            // }//remove Transition is end
            //动画添加 end

            // interactive: Kirigami.Settings.hasTransientTouchInput
            // highlightFollowsCurrentItem: true
            // highlightMoveDuration: 0
            // highlightResizeDuration : 0

            // keyNavigationEnabled : true
            // keyNavigationWraps : true
            // Keys.onPressed: control.keyPress(event)

            // onPositionChanged:
            // {
            //     if(_hoverHandler.hovered && position.x < control.width * 0.25 &&  _hoverHandler.point.pressPosition.y != position.y)
            //     {
            //         const index = _listView.indexAt(position.x, position.y)
            //         if(!selectedIndexes.includes(index) && index > -1 && index < _listView.count)
            //         {
            //              selectedIndexes.push(index)
            //              control.itemsSelected([index])
            //         }
            //     }
            // }

            // HoverHandler
            // {
            //     id: _hoverHandler
            //     margin: Maui.Style.space.big
            //     enabled: control.enableLassoSelection && control.selectionMode && !_listView.flicking
            //     acceptedDevices: PointerDevice.TouchScreen
            //     acceptedPointerTypes : PointerDevice.Finger
            //     grabPermissions : PointerHandler.CanTakeOverFromAnything

            //     onHoveredChanged:
            //     {
            //         if(!hovered)
            //         {
            //             _listView.selectedIndexes = []
            //         }
            //     }
            // }

            // Maui.Holder
            // {
            //     id: _holder
            //     anchors.fill : parent
            // }

            MouseArea
            {
                id: _mouseArea
                z: -1
                enabled: true//!Kirigami.Settings.hasTransientTouchInput && !Maui.Handy.isAndroid
                anchors.fill: parent
                propagateComposedEvents: true
                //             preventStealing: true
                acceptedButtons:  Qt.RightButton | Qt.LeftButton

                onClicked:
                {
                    control.areaClicked(mouse)
                    control.forceActiveFocus()

                    if(mouse.button === Qt.RightButton)
                    {
                        var realMap = mapToItem(wholeScreen, mouse.x, mouse.y)
                        menuX = realMap.x
                        menuY = realMap.y
                        control.areaRightClicked(mouse)
                        return
                    }
                }

                onPositionChanged:
                {
                    // if(_mouseArea.pressed && control.enableLassoSelection && selectLayer.visible)
                    // {
                    //     if(mouseX >= selectLayer.newX)
                    //     {
                    //         selectLayer.width = (mouseX + 10) < (control.x + control.width) ? (mouseX - selectLayer.x) : selectLayer.width;
                    //     } else {
                    //         selectLayer.x = mouseX < control.x ? control.x : mouseX;
                    //         selectLayer.width = selectLayer.newX - selectLayer.x;
                    //     }

                    //     if(mouseY >= selectLayer.newY) {
                    //         selectLayer.height = (mouseY + 10) < (control.y + control.height) ? (mouseY - selectLayer.y) : selectLayer.height;
                    //         if(!_listView.atYEnd &&  mouseY > (control.y + control.height))
                    //             _listView.contentY += 10
                    //     } else {
                    //         selectLayer.y = mouseY < control.y ? control.y : mouseY;
                    //         selectLayer.height = selectLayer.newY - selectLayer.y;

                    //         if(!_listView.atYBeginning && selectLayer.y === 0)
                    //             _listView.contentY -= 10
                    //     }
                    // }
                }

                onPressed:
                {
                    if (mouse.source === Qt.MouseEventNotSynthesized)
                    {
                        if(control.enableLassoSelection && mouse.button === Qt.LeftButton )
                        {
                            // selectLayer.visible = true;
                            // selectLayer.x = mouseX;
                            // selectLayer.y = mouseY;
                            // selectLayer.newX = mouseX;
                            // selectLayer.newY = mouseY;
                            // selectLayer.width = 0
                            // selectLayer.height = 0;
                        }
                    }
                }

                onPressAndHold:
                {
                    if ( mouse.source !== Qt.MouseEventNotSynthesized && control.enableLassoSelection && /*!selectLayer.visible*/ true )
                    {
                        // selectLayer.visible = true;
                        // selectLayer.x = mouseX;
                        // selectLayer.y = mouseY;
                        // selectLayer.newX = mouseX;
                        // selectLayer.newY = mouseY;
                        // selectLayer.width = 0
                        // selectLayer.height = 0;
                        mouse.accepted = true
                    }else
                    {
                        mouse.accepted = false
                    }
                    var realMap = mapToItem(wholeScreen, mouse.x, mouse.y)
                    menuX = realMap.x
                    menuY = realMap.y
                    control.areaRightClicked(mouse)
                }

                onReleased:
                {
                    if(mouse.button !== Qt.LeftButton || !control.enableLassoSelection || /*!selectLayer.visible*/ true)
                    {
                        mouse.accepted = false
                        return;
                    }

                    // if(selectLayer.y > _listView.contentHeight)
                    // {
                    //     return selectLayer.reset();
                    // }

                    // var lassoIndexes = []
                    // var limitY =  mouse.y === lassoRec.y ?  lassoRec.y+lassoRec.height : mouse.y

                    // for(var y = lassoRec.y; y < limitY; y+=10)
                    // {
                    //     const index = _listView.indexAt(_listView.width/2,y+_listView.contentY)
                    //     if(!lassoIndexes.includes(index) && index>-1 && index< _listView.count)
                    //         lassoIndexes.push(index)
                    // }

                    // control.itemsSelected(lassoIndexes)
                    // selectLayer.reset()
                }
            }

            // Maui.Rectangle
            // {
            //     id: selectLayer
            //     property int newX: 0
            //     property int newY: 0
            //     height: 0
            //     width: 0
            //     x: 0
            //     y: 0
            //     visible: false
            //     color: Qt.rgba(control.Kirigami.Theme.highlightColor.r,control.Kirigami.Theme.highlightColor.g, control.Kirigami.Theme.highlightColor.b, 0.2)
            //     opacity: 0.7

            //     borderColor: control.Kirigami.Theme.highlightColor
            //     borderWidth: 2
            //     solidBorder: false

            //     function reset()
            //     {
            //       selectLayer.x = 0;
            //       selectLayer.y = 0;
            //       selectLayer.newX = 0;
            //       selectLayer.newY = 0;
            //       selectLayer.visible = false;
            //       selectLayer.width = 0;
            //       selectLayer.height = 0;
            //     }
            // }
        }
    // }

}


