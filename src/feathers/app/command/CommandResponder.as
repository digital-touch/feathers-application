package feathers.app.command {
import logger.Logger;

import starling.events.Event;
import starling.events.EventDispatcher;

public class CommandResponder {
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    public function CommandResponder(eventDispatcher:EventDispatcher, executeEventType:String, data:Object = null, completeEventType:String = null, completeCallback:Function = null, errorEventType:String = null, errorCallback:Function = null) {
		
		config::debug {
			Logger.log("{0}->create responder executeEventType:{1} completeEventType:{2} errorEventType:{3}", this, executeEventType, completeEventType, errorEventType);
		}
			
        var onComplete:Function = function (event:Event):void {
			disposeListeners();
            if (completeCallback != null) {
				config::debug {
					Logger.log("{0}->completeCallback data:{1}", this, event.data);
				}
					applyCallback(completeCallback, event.data);
            }
        }				

        var onError:Function = function (event:Event):void {
            disposeListeners();
				if (errorCallback != null) {
			config::debug {
				Logger.log("{0}->errorCallback data:{1}", this, event.data);
			}
			applyCallback(errorCallback, event.data);
				}
			        
        }

        var initializeListeners:Function = function ():void {
            if (completeEventType) {
                eventDispatcher.addEventListener(completeEventType, onComplete);
            }

            if (errorEventType) {
                eventDispatcher.addEventListener(errorEventType, onError);
            }
        }

        var disposeListeners:Function = function ():void {
            if (completeEventType) {
                eventDispatcher.removeEventListener(completeEventType, onComplete);
            }

            if (errorEventType) {
                eventDispatcher.removeEventListener(errorEventType, onError);
            }
        }

        initializeListeners();
        eventDispatcher.dispatchEventWith(executeEventType, false, data);
    }
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	private function applyCallback(callback: Function, data: Object = null): void {
		if (callback.length == 1) {
			callback(data);
		} else {					
			callback();
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
}