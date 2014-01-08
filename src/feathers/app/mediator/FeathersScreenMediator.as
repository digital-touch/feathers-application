package feathers.app.mediator {

import feathers.controls.IScreen;
import feathers.events.FeathersEventType;

import logger.Logger;

public class FeathersScreenMediator extends FeathersMediator {
	
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private var _isShown:Boolean = false;

    public function get isShown():Boolean {
        return _isShown;
    }

    public function set isShown(value:Boolean):void {
        if (_isShown == value)
            return;
        _isShown = value;
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     *
     */
    override protected function initializeMediator():void {
        super.initializeMediator();
        if (!screen.owner) {
            return;
        }

        screen.owner.addEventListener(FeathersEventType.TRANSITION_START, onShowTransitionStart);
        screen.owner.addEventListener(FeathersEventType.TRANSITION_COMPLETE, onShowTransitionComplete);

    }

    private function onShowTransitionStart():void {
        showTransitionStart();
    }

    private function onShowTransitionComplete():void {

        isShown = true;

        screen.owner.removeEventListener(FeathersEventType.TRANSITION_COMPLETE, onShowTransitionComplete);

        var onHideTransitionStart:Function = function ():void {			
            screen.owner.removeEventListener(FeathersEventType.TRANSITION_START, onHideTransitionStart);
            screen.touchable = false;
            hideTransitionStart();
        }
        var onHideTransitionComplete:Function = function ():void {
            screen.owner.removeEventListener(FeathersEventType.TRANSITION_COMPLETE, onHideTransitionComplete);
            screen.touchable = true;
            isShown = false;
            hideTransitionCompleted();
            screen.owner.addEventListener(FeathersEventType.TRANSITION_COMPLETE, onShowTransitionComplete);
        }
        screen.owner.addEventListener(FeathersEventType.TRANSITION_START, onHideTransitionStart);
        screen.owner.addEventListener(FeathersEventType.TRANSITION_COMPLETE, onHideTransitionComplete);
        showTransitionCompleted();
    }

    override protected function disposeMediator():void {
        super.disposeMediator();
        // nothing to do
        //screen.owner.removeEventListener(FeathersEventType.TRANSITION_COMPLETE, onShowTransitionComplete);
    }

    /**
     *
     *
     */
    protected function hideTransitionStart():void {
		config::debug {
			Logger.log("{0}->hideTransitionStart screen:{1}", this, screen);
		}
    }

    /**
     *
     *
     */
    protected function hideTransitionCompleted():void {
		config::debug {
			Logger.log("{0}->hideTransitionCompleted screen:{1}", this, screen);
		}
    }

    /**
     *
     *
     */
    protected function showTransitionStart():void {
       
		config::debug {
			Logger.log("{0}->showTransitionStart screen:{1}", this, screen);	
		}
    }

    /**
     *
     *
     */
    protected function showTransitionCompleted():void {
		config::debug {
			Logger.log("{0}->showTransitionCompleted screen:{1}", this, screen);
		}
    }

    /**
     *
     * @return
     *
     */
    public function get screen():IScreen {
        return component as IScreen;
    }
}
}
