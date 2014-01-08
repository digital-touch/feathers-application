/**
 *
 * Copyright (C) Piotr Kucharski 2012 email: suspendmode@gmail.com
 * mobile: +48 791 630 277
 *
 * All rights reserved. Any use, copying, modification,
 * distribution and selling of this software and it's documentation
 * for any purposes without authors' written permission is hereby prohibited.
 *
 * Use this code to do whatever you want, just don't claim it as your own, because
 * I wrote it. Not you!
 *
 */
package feathers.app.mediator {

import flash.errors.IllegalOperationError;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import feathers.core.IFeathersControl;
import feathers.events.FeathersEventType;

import logger.Logger;

import starling.core.Starling;
import starling.events.Event;

/**
 *
 * @author suspendmode@gmail.com
 *
 */
public class FeathersMediator extends ViewMediator {

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Optional callback for the back hardware key. Automatically handles
     * keyboard events to cancel the default behavior.
     */
    protected var backButtonHandler:Function;

    /**
     * Optional callback for the menu hardware key. Automatically handles
     * keyboard events to cancel the default behavior.
     */
    protected var menuButtonHandler:Function;

    /**
     * Optional callback for the search hardware key. Automatically handles
     * keyboard events to cancel the default behavior.
     */
    protected var searchButtonHandler:Function;

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     */
    public var keyDownHandlerPriority:int = 0;

    /**
     *
     *
     */
    override protected function initializeMediator():void {
        super.initializeMediator();

        if (viewComponent is IFeathersControl && !feathersControl.isInitialized) {
            feathersControl.addEventListener(FeathersEventType.INITIALIZE, onViewInitialize);
        }
        else {
            Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, screen_stage_keyDownHandler, false, keyDownHandlerPriority, true);
            viewInitialized();
        }

    }

    /**
     *
     *
     */
    override protected function disposeMediator():void {
        super.disposeMediator();

        Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, screen_stage_keyDownHandler, false);
        backButtonHandler = null;
    }

    /**
     * @private
     */
    protected function screen_stage_keyDownHandler(event:KeyboardEvent):void {

        //we're accessing Keyboard.BACK (and others) using a string because
        //this code may be compiled for both Flash Player and AIR.
        if (!event.isDefaultPrevented() && this.backButtonHandler != null && Object(Keyboard).hasOwnProperty("BACK") && event.keyCode == Keyboard["BACK"]) {
            event.preventDefault();
            event.stopImmediatePropagation();
            this.backButtonHandler();
        }

        if (!event.isDefaultPrevented() && this.menuButtonHandler != null && Object(Keyboard).hasOwnProperty("MENU") && event.keyCode == Keyboard["MENU"]) {

            event.preventDefault();
            event.stopImmediatePropagation();
            this.menuButtonHandler();
        }

        if (!event.isDefaultPrevented() && this.searchButtonHandler != null && Object(Keyboard).hasOwnProperty("SEARCH") && event.keyCode == Keyboard["SEARCH"]) {
            event.preventDefault();
            event.stopImmediatePropagation();
            this.searchButtonHandler();
        }

    }

    /**
     *
     * @param event
     *
     */
    private function onViewInitialize(event:Event):void {
        Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, screen_stage_keyDownHandler, false, keyDownHandlerPriority, true);
        feathersControl.removeEventListener(FeathersEventType.INITIALIZE, onViewInitialize);
		config::debug {
			Logger.log("{0}->viewInitialized view:{1}", this, feathersControl);				
		}
        viewInitialized();
    }

    /**
     *
     *
     */
    protected function viewInitialized():void {
		throw new IllegalOperationError("abstract method");
    }

    private function get feathersControl():IFeathersControl {
        return viewComponent as IFeathersControl;
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
}
