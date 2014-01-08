/**
 * Copyright (c) 2013, Digital Touch sp. z o.o.
 * All rights reserved.
 *
 * Any use, copying, modification, distribution and selling of this source code and it's documentation
 * for any purposes without authors' written permission is hereby prohibited.
 */
package feathers.app.mediator {

import flash.errors.IllegalOperationError;

import logger.Logger;

import org.swiftsuspenders.Injector;

import starling.events.Event;
import starling.events.EventDispatcher;

/**
 *
 * @author developer
 *
 */
public class Mediator {
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    [Inject]
    /**
     *
     */
    public var eventDispatcher:EventDispatcher;

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    [Inject]
    /**
     *
     */
    public var injector:Injector;

    private var _component:Object;

    public final function get component():Object {
        return _component;
    }

    public final function set component(value:Object):void {
        if (_component == value)
            return;
        if (_component) {
            disposeComponent(_component);
        }
        _component = value;
        if (value) {
            initializeComponent(_component);
        }
    }

    protected function disposeComponent(_component:Object):void {
        // TODO Auto Generated method stub

    }

    protected function initializeComponent(_component:Object):void {
        // TODO Auto Generated method stub

    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    [PostConstruct]
    /**
     *
     *
     */
    public final function initialize():void {
		config::debug {
			Logger.log("{0}->initialize component:{1}", this, component);
		}
        initializeMediator();
    }

    /**
     *
     *
     */
    protected function initializeMediator():void {
        throw new IllegalOperationError("Mediator.initializeMediator(): void is abstract and must be overriden");
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    [PreDestroy]
    /**
     *
     *
     */
    public final function dispose():void {
		config::debug {
			Logger.log("{0}->dispose component:{1}", this, component);
		}       
        disposeMediator();
    }

    /**
     *
     *
     */
    protected function disposeMediator():void {
        throw new IllegalOperationError("Mediator.disposeMediator(): void is abstract and must be overriden");
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // bus
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    protected function addEventListener(type:String, listener:Function):void {
        eventDispatcher.addEventListener(type, listener);
    }

    protected function removeEventListener(type:String, listener:Function):void {
        eventDispatcher.removeEventListener(type, listener);
    }

    protected function dispatchEvent(event:Event):void {
        eventDispatcher.dispatchEvent(event);
    }

    protected function dispatchEventWith(type:String, bubbles:Boolean = false, data:Object = null):void {
        eventDispatcher.dispatchEventWith(type, bubbles, data);
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
}