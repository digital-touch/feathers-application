package feathers.app.mediator {
import logger.Logger;

import starling.display.DisplayObject;
import starling.events.Event;

public class ViewMediator extends Mediator {

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    override protected function initializeComponent(component:Object):void {
		config::debug {
			Logger.log("{0}->initializeComponent {1}", this, component);
		}
    }

    override protected function disposeComponent(component:Object):void {
		config::debug {
			Logger.log("{0}->disposeComponent {1}", this, component);
		}
    }

    public function get viewComponent():DisplayObject {
        return component as DisplayObject;
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     *
     *
     */
    override protected function initializeMediator():void {
		
		config::debug {
			Logger.log("{0}->initializeMediator", this);
		}
			        
        viewComponent.addEventListener(Event.ADDED_TO_STAGE, onViewAdded);
        viewComponent.addEventListener(Event.REMOVED_FROM_STAGE, onViewRemoved);
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    override protected function disposeMediator():void {
		
		config::debug {
			Logger.log("{0}->disposeMediator", this);
		}
			
        viewComponent.removeEventListener(Event.ADDED_TO_STAGE, onViewAdded);
        viewComponent.removeEventListener(Event.REMOVED_FROM_STAGE, onViewRemoved);
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     * added to stage
     *
     */
    protected function onViewAdded():void {
		config::debug {
			Logger.log("{0}->onViewAdded", this);
		}
    }

    /**
     *
     * removed from stage
     *
     */
    protected function onViewRemoved():void {
		config::debug {
			Logger.log("{0}->onViewRemoved", this);
		}
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
}