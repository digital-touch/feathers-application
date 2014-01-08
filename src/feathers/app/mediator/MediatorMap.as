package feathers.app.mediator {

import flash.utils.Dictionary;

import feathers.core.DisplayListWatcher;
import feathers.core.FeathersControl;

import logger.Logger;

import org.swiftsuspenders.Injector;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;

import utils.TypeUtils;

public class MediatorMap extends DisplayListWatcher {

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    /**
     *
     */
    private var mediators:Vector.<Mediator> = new Vector.<Mediator>();
	
	/**
	 *
	 */
	private var map:Dictionary = new Dictionary();

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    [Inject]
    /**
     *
     */
    public var injector:Injector;

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    /**
     *
     * @param injector
     *
     */
    public function MediatorMap() {
        this.injector = injector;
        super(Starling.current.stage);
    }

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    public function invalidateStage():void {
        initializeObject(Starling.current.stage);
    }

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    /**
     *
     * @param view
     *
     */
    private function mediatorInitializer(view:FeathersControl):void {
		
		
        var generator:Class = Object(view).constructor;

        if (!injector.hasDirectMapping(generator)) {
			initializeChildren(view);
            return;
        }
        
        view.addEventListener(Event.REMOVED_FROM_STAGE, onViewRemovedFromStage);

        var result:Object = injector.getInstance(generator);

        if (!(result is Class)) {
			initializeChildren(view);
            return;
        }

        if (!TypeUtils.isImplementing(result as Class, Mediator)) {
			initializeChildren(view);
            return;
        }
        var mediatorFactory:Class = result as Class;

        var mediator:Mediator = new mediatorFactory();

        mediators.push(mediator);
		
		map[view] = mediator;
		
        mediator.component = view;

        injector.injectInto(mediator);

		config::debug {
			Logger.log("{0}->mediatorInitializer view:{1} mediator:{2} generator:{3}", this, view, mediator, generator);
		}		
			
		initializeChildren(view);
	}
	
	private function onViewRemovedFromStage(event: Event):void {
		
		var view: DisplayObject = event.currentTarget as DisplayObject;
		view.removeEventListener(Event.REMOVED_FROM_STAGE, onViewRemovedFromStage);
		if (view is FeathersControl) {
			mediatorDisposer(FeathersControl(view));
		}
	}
	
	private function mediatorDisposer(view: FeathersControl): void {
		var mediator: Mediator = map[view];
		config::debug {
			Logger.log("{0}->onViewRemovedFromStage view:{1} mediator:{2}", this, view, mediator);
		}
		
		injector.destroyInstance(mediator);
		
		var mediatorIndex:int = mediators.indexOf(mediator);
		mediators.splice(mediatorIndex, 1);		
		
		disposeChildren(view);
		
	}

	
	private function initializeChildren(view: FeathersControl): void {
		config::debug {
			Logger.log("{0}->initializeChildren for:{1}", this, view);
		}
		for (var i: int = 0 ; i < view.numChildren; i++) {
			var child: DisplayObject = view.getChildAt(i);
			if (child is FeathersControl) {
				mediatorInitializer(FeathersControl(child));
			}
		}			
    }
	
	private function disposeChildren(view: FeathersControl): void {
		config::debug {
			Logger.log("{0}->disposeChildren for:{1}", this, view);
		}
		for (var i: int = 0 ; i < view.numChildren; i++) {
			var child: DisplayObject = view.getChildAt(i);
			if (child is FeathersControl) {
				mediatorDisposer(FeathersControl(child));
			}
		}			
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    [PostConstruct]
    /**
     *
     *
     */
    public function initialize():void {
		config::debug {
			Logger.log("{0}->initialize", this);
		}
        setInitializerForClassAndSubclasses(FeathersControl, mediatorInitializer);
        if (Starling.current.root is FeathersControl) {
            mediatorInitializer(Starling.current.root as FeathersControl);
        }
    }

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    [PreDestroy]
    /**
     *
     *
     */
    override public function dispose():void {
		config::debug {
			Logger.log("{0}->dispose", this);
		}
        clearInitializerForClass(FeathersControl);
        super.dispose();

    }
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
}