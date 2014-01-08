package feathers.app.command {
import flash.errors.IllegalOperationError;

import org.swiftsuspenders.Injector;

import starling.events.Event;
import starling.events.EventDispatcher;

public class Command {

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    [Inject]
    public var injector:Injector;

    [Inject]
    public var eventDispatcher:EventDispatcher;

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public var eventType:String;

    public var data:Object;

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public function execute():void {
        throw new IllegalOperationError("Command.execute(): void is abstract and must be overriden");
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

    protected function dispatchEventWith(type:String, data:Object = null, bubbles:Boolean = false):void {
        eventDispatcher.dispatchEventWith(type, bubbles, data);
    }

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
}