package feathers.app.command {
import flash.utils.Dictionary;

import logger.Logger;

import org.swiftsuspenders.Injector;

import starling.events.Event;
import starling.events.EventDispatcher;

public class CommandMap {

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    [Inject]
    /**
     *
     */
    public var injector:Injector;

    [Inject]
    /**
     *
     */
    public var eventDispatcher:EventDispatcher;

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     */
    public var mappings:Dictionary = new Dictionary();

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     * @param eventType
     * @param command
     *
     */
    public function register(eventType:String, command:Class):void {
		config::debug {
			Logger.log("{0}->register eventType:{1} command:{2}", this, eventType, command);          
		}
        var map:Vector.<Class> = getMap(eventType);
        map.push(command);
    }

    /**
     *
     * @param eventType
     * @param command
     *
     */
    public function unregister(eventType:String, command:Class):void {
		config::debug {
			Logger.log("{0}->unregister eventType:{1} command:{2}", this, eventType, command);
		}
        var map:Vector.<Class> = getMap(eventType);
        var index:int = map.indexOf(command);
        map.splice(index, 1);
        if (map.length == 0) {
            delete mappings[eventType];
            eventDispatcher.removeEventListener(eventType, handleEvent);
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     * @param event
     *
     */
    private function handleEvent(event:Event):void {
		config::debug {
			Logger.log("{0}->handleEvent type:{1} event:{2}", this, event.type, event);
		}
		
        var map:Vector.<Class> = getMap(event.type);
        for (var i:int = 0; i < map.length; i++) {
            var commandClass:Class = map[i];
            var command:Command = new commandClass();
            command.eventType = event.type;
            command.data = event.data;
            injector.injectInto(command);
			config::debug {
				Logger.log("{0}->execute command:{1}", this, command);
			}
            command.execute();
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function getMap(eventType:String):Vector.<Class> {
        if (eventType in mappings) {
			config::debug {
				Logger.log("{0}->getMap eventType:{1}", this, eventType);
			}
            return mappings[eventType];
        } else {
			config::debug {
				Logger.log("{0}->createMap eventType:{1}", this, eventType);
			}
            var list:Vector.<Class> = new Vector.<Class>();
            mappings[eventType] = list;
            eventDispatcher.addEventListener(eventType, handleEvent);
            return list;
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}
}