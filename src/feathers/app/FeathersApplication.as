package feathers.app {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.geom.Rectangle;

import feathers.app.command.CommandMap;
import feathers.app.mediator.MediatorMap;
import feathers.app.skin.Skin;
import feathers.app.splash.SplashConfig;
import feathers.controls.LayoutGroup;

import logger.Logger;

import org.swiftsuspenders.Injector;

import starling.core.Starling;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.utils.AssetManager;

import utils.ObjectUtils;
import utils.ScreenScale;

[Event(name="complete", type="flash.events.Event")]

public class FeathersApplication extends Sprite {

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public var splashConfig:SplashConfig;

    public var feathersConfig:FeathersConfig;

    public var designConfig:DesignConfig;

    public var screenScale:ScreenScale;

    public var injector:Injector = new Injector();

    public var commandMap:CommandMap = new CommandMap();

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public var assetManager:AssetManager;

    public var mediatorMap:MediatorMap;

    public var skins:Vector.<Skin> = new Vector.<Skin>();

    public var eventDispatcher:EventDispatcher = new EventDispatcher();

    /**
     *
     * @param splash
     * @param designWidth
     * @param designHeight
     * @param autoShowSplash
     * @param autoInitialize
     * @param autoDispose
     *
     */
    public function FeathersApplication(splashConfig:SplashConfig = null, feathersConfig:FeathersConfig = null, designConfig:DesignConfig = null) {

        super();

        initializeLogger();

        if (!feathersConfig) {
            feathersConfig = new FeathersConfig();
        }
        if (!feathersConfig.mainClass) {
            feathersConfig.mainClass = LayoutGroup;
        }

        this.splashConfig = splashConfig;
        this.feathersConfig = feathersConfig;
        this.designConfig = designConfig;

        setupNativeStage();
        setupSplash();
        setupLifecycle();
    }

    private function setupNativeStage():void {
		config::debug {
        	Logger.log("{0}->setupNativeStage", this);
		}

        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
    }

    private function setupLifecycle():void {

		config::debug {
			Logger.log("{0}->setupLifecycle", this);
		}

        if (stage) {
            initialize();
        } else {
            var onAddedToStage:Function = function (event:Object):void {
                removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
                initialize();
            }
            addEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
        }

        if (!stage) {
            dispose();
        } else {
            var onRemovedFromStage:Function = function (event:Object):void {
                removeEventListener(flash.events.Event.REMOVED_FROM_STAGE, onRemovedFromStage);
                dispose();
            }
            addEventListener(flash.events.Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        }
    }

    /**
     *
     *
     */
    public function initialize():void {
        stage.addEventListener(flash.events.Event.RESIZE, onStageResize);

		config::debug {
			Logger.log("{0}->initialize", this);
		}

        if (!injector.hasDirectMapping(EventDispatcher)) {
            injector.map(EventDispatcher).toValue(eventDispatcher);
        }

        if (!injector.hasDirectMapping(Injector)) {
            injector.map(Injector).toValue(injector);
        }

        initializeAssetManager();
        initializeCommandMap();
        initializeStarling();
    }

    protected function onStarlingRootInitialized():void {
        initializeScreenScale();
        initializeApplication();
        initializeMediatorMap();
    }

    /**
     *
     *
     */
    public function dispose():void {

		config::debug {
			Logger.log("{0}->dispose", this);
		}

        stage.removeEventListener(flash.events.Event.RESIZE, onStageResize);

        disposeAssetManager();
        disposeApplication();

        disposeMediatorMap();
        disposeScreenScale();
        disposeStarling();
        disposeCommandMap();

        if (injector.hasDirectMapping(Injector)) {
            injector.unmap(Injector);
        }

        if (injector.hasDirectMapping(EventDispatcher)) {
            injector.unmap(EventDispatcher);
        }

    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // splash
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     */
    private var _splash:DisplayObject;

    /**
     *
     * @return
     *
     */
    public function get splash():DisplayObject {
        return _splash;
    }

    /**
     *
     * @param value
     *
     */
    public function set splash(value:DisplayObject):void {
        if (_splash == value)
            return;
        if (_splash) {
			config::debug {
				Logger.log("{0}->remove splash:{1}", this, _splash);
			}
            removeChild(_splash);
        }
        _splash = value;
        if (value) {
			config::debug {
				Logger.log("{0}->add splash:{1}", this, value);
			}
            addChild(value);
            validateSize();
        }
    }

    private function setupSplash():void {
        if (!splashConfig) {
            return;
        }
		config::debug {
			Logger.log("{0}->setupSplash", this);
		}

        if (splashConfig.classOrInstance is Class) {
            splash = new splashConfig.classOrInstance();
        } else {
            splash = splashConfig.classOrInstance as DisplayObject;
        }
    }

    private function hideSplash():void {

        if (!splash) {
            return;
        }

		if (!splashConfig.animatedHide) {
			splash = null;
			return;
		}
		
		if (splashConfig.splashHideAnimationFunction != null) {
			
			config::debug {
				Logger.log("{0}->hideSplash splashHideAnimationFunction", this);
			}
				
			splashConfig.splashHideAnimationFunction();
			
		} else if (splashConfig.autoHide) {
		
			config::debug {
				Logger.log("{0}->hideSplash autoHide", this);
			}
			
			var duration:Number = 0.2;
			var fadeStep:Number = 1 / stage.frameRate / duration;
			
			var splashHidden:Function = function ():void {
					splash = null;
					
					config::debug {
						Logger.log("{0}->splashHidden autoHide", this);
					}				
			}
			
			var onEnterFrame:Function = function (event:Object):void {
				splash.alpha -= fadeStep;
				if (splash.alpha <= 0) {
					removeEventListener(flash.events.Event.ENTER_FRAME, onEnterFrame);
					splashHidden();
				}
			}
			
			addEventListener(flash.events.Event.ENTER_FRAME, onEnterFrame);
		}
		
        
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // starling
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function initializeStarling():void {

		config::debug {
			Logger.log("{0}->initializeStarling", this);
		}

        Starling.handleLostContext = true;
        var current:Starling = new Starling(feathersConfig.mainClass, stage, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
        ObjectUtils.applyProperties(current, feathersConfig.starlingProperties);
        current.stage.color = feathersConfig.backgroundColor;
        current.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
        current.start();
    }

    private function disposeStarling():void {

		config::debug {
			Logger.log("{0}->disposeStarling", this);
		}

        var current:Starling = Starling.current;
        current.stop();
        current.dispose();
        current = null;
    }

    protected function initializeApplication():void {
        throw new IllegalOperationError("FeathersApplication.initializeApplication(): void is abstract and must be overriden");
    }

    protected function disposeApplication():void {
        throw new IllegalOperationError("FeathersApplication.disposeApplication(): void is abstract and must be overriden");
    }

    private function onRootCreated():void {

		config::debug {
			Logger.log("{0}->onRootCreated", this);
		}

        Starling.current.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);

        onStarlingRootInitialized();

        validateSize();

        var event:flash.events.Event = new flash.events.Event(flash.events.Event.COMPLETE);
        dispatchEvent(event);
        if (!event.isDefaultPrevented()) {
            hideSplash();
        }
				
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // logger
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private var _loggerEnabled:Boolean = true;

    public function set loggerEnabled(value:Boolean):void {
		config::debug {
			Logger.log("{0}->loggerEnabled {1}", this, value);
		}
        if (_loggerEnabled != value) {
            _loggerEnabled = value;
            validateAssetManager();
            validateLogger();
        }
    }

    public function get loggerEnabled():Boolean {
        return _loggerEnabled;
    }

    /**
     *
     *
     */
    private function initializeLogger():void {
        Logger.addTraceTarget(trace);
    }

    private function disposeLogger():void {
        Logger.removeTraceTarget(trace);
    }

    private function validateLogger():void {
        if (loggerEnabled) {
            if (!Logger.hasTraceTarget(trace)) {
                initializeLogger();
            }
        } else {
            if (Logger.hasTraceTarget(trace)) {
                disposeLogger();
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // asset manager
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function validateAssetManager():void {

		config::debug {
			Logger.log("{0}->validateAssetManager", this);
		}


        if (loggerEnabled) {
            assetManager.verbose = true;
        } else {
            assetManager.verbose = false;
        }
    }

    private function initializeAssetManager():void {

		config::debug {
			Logger.log("{0}->initializeAssetManager", this);
		}


        if (!assetManager) {
            assetManager = new AssetManager();
            if (loggerEnabled) {
                assetManager.verbose = false;
            }
            if (!injector.hasDirectMapping(AssetManager)) {
                injector.map(AssetManager).toValue(assetManager);
            }
            injector.injectInto(assetManager);
        }
    }

    private function disposeAssetManager():void {

		config::debug {
			Logger.log("{0}->disposeAssetManager", this);
		}


        if (injector.hasDirectMapping(AssetManager)) {
            injector.unmap(AssetManager);
        }
        if (assetManager) {
            injector.destroyInstance(assetManager);
            assetManager = null;
        }
    }


    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // mediator map
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function initializeMediatorMap():void {

		config::debug {
			Logger.log("{0}->initializeMediatorMap", this);
		}


        if (!mediatorMap) {
            mediatorMap = new MediatorMap();

            if (!injector.hasDirectMapping(MediatorMap)) {
                injector.map(MediatorMap).toValue(mediatorMap);
            }
            injector.injectInto(mediatorMap);
        }
    }

    private function disposeMediatorMap():void {

		config::debug {
			Logger.log("{0}->disposeMediatorMap", this);
		}


        if (injector.hasDirectMapping(MediatorMap)) {
            injector.unmap(MediatorMap);
        }
        if (mediatorMap) {
            injector.destroyInstance(mediatorMap);
            mediatorMap = null;
        }
    }

    public function registerMediator(type:Class, mediatorClassOrInstance:Object):void {

		config::debug {
			Logger.log("{0}->registerMediator type:{1} classOrInstance:{2}", this, type, mediatorClassOrInstance);
		}
			
               injector.map(type).toValue(mediatorClassOrInstance);			
    }

    public function unregisterMediator(type:Class, mediatorClassOrInstance:Object):void {

		config::debug {
			Logger.log("{0}->unregisterMediator type:{1} classOrInstance:{2}", this, type, mediatorClassOrInstance);
		}

        injector.unmap(type);

    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // screen scale
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function initializeScreenScale():void {

		config::debug {
			Logger.log("{0}->initializeScreenScale", this);
		}

        if (!screenScale) {
            screenScale = new ScreenScale(designConfig.width, designConfig.height, designConfig.ppi, stage);
            if (!injector.hasDirectMapping(ScreenScale)) {
                injector.map(ScreenScale).toValue(screenScale);
            }
            injector.injectInto(screenScale);
        }
    }

    private function disposeScreenScale():void {

		config::debug {
			Logger.log("{0}->disposeScreenScale", this);
		}

        if (screenScale) {
            screenScale = null;
            if (injector.hasDirectMapping(ScreenScale)) {
                injector.unmap(ScreenScale);
            }
            injector.destroyInstance(screenScale);
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // skins
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public function addSkin(skin:Skin):void {

		config::debug {
			Logger.log("{0}->addSkin skin:{1}", this, skin);
		}

        var type:Class = Object(skin).constructor;
        injector.map(type).toValue(skin);
        injector.injectInto(skin);
        skins.push(skin);
    }

    public function removeSkin(skin:Skin):void {

		config::debug {
			Logger.log("{0}->removeSkin skin:{1}", this, skin);
		}

        var type:Class = Object(skin).constructor;
        if (injector.hasDirectMapping(type)) {
            injector.unmap(type);
        }
        injector.destroyInstance(skin);
        skins.splice(skins.indexOf(skin), 1);
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // commands
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function initializeCommandMap():void {
		
		config::debug {
			Logger.log("{0}->initializeCommandMap", this);
		}
			
        commandMap = new CommandMap();
        injector.injectInto(commandMap);
        injector.map(CommandMap).toValue(commandMap);
    }

    private function disposeCommandMap():void {
		
		config::debug {
			Logger.log("{0}->disposeCommandMap", this);
		}
			
        injector.destroyInstance(commandMap);
        injector.unmap(CommandMap);
        commandMap = null;
    }

    public function registerCommand(eventType:String, command:Class):void {

		config::debug {
			Logger.log("{0}->registerCommand eventType:{1} command:{2}", this, eventType, command);
		}

        commandMap.register(eventType, command);
    }

    public function unregisterCommand(eventType:String, command:Class):void {

		config::debug {
			Logger.log("{0}->unregisterCommand eventType:{1} command:{2}", this, eventType, command);
		}

        commandMap.register(eventType, command);
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     * @param event
     *
     */
    private function onStageResize(event:flash.events.Event):void {
		config::debug {			
			Logger.log("{0}->onStageResize. {1}x{2}", this, stage.stageWidth, stage.stageHeight);
		}
			
        

        validateSize();
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     *
     */
    private function validateSize():void {

		config::debug {
			Logger.log("{0}->validateSize", this);
		}

        validateSplash()
        validateStarlingSize();
    }

    /**
     *
     *
     */
    private function validateSplash():void {

        if (!splash) {
            return;
        }

		config::debug {
			Logger.log("{0}->validateSplash", this);
		}

        var screenWidth:int = stage.stageWidth;
        var screenHeight:int = stage.stageHeight;

        splash.x = 0;
        splash.y = 0;
        splash.width = screenWidth;
        splash.height = screenHeight;
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     *
     */
    private function validateStarlingSize():void {


        if (!Starling.current) {
            return;
        }

		config::debug {
			Logger.log("{0}->validateStarlingSize", this);
		}

        validateStarlingStageSize();
        validateStarlingViewportSize();

        if (Starling.current.root) {
            validateStarlingRootSize();
        } else {
            var onRootCreated:Function = function ():void {
                Starling.current.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
                validateStarlingRootSize();
            }
            Starling.current.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
        }

    }

    /**
     *
     *
     */
    private function validateStarlingStageSize():void {

		config::debug {
			Logger.log("{0}->validateStarlingStageSize", this);
		}

        var stageWidth:int = stage.stageWidth;
        var stageHeight:int = stage.stageHeight;

        Starling.current.stage.stageWidth = stage.stageWidth;
        Starling.current.stage.stageHeight = stage.stageHeight;
    }

    /**
     *
     *
     */
    private function validateStarlingViewportSize():void {

		config::debug {
			Logger.log("{0}->validateStarlingViewportSize", this);
		}

        var stageWidth:int = stage.stageWidth;
        var stageHeight:int = stage.stageHeight;

        var viewPort:Rectangle = new Rectangle(0, 0, stageWidth, stageHeight)
        Starling.current.viewPort = viewPort;

    }

    /**
     *
     *
     */
    private function validateStarlingRootSize():void {

		config::debug {
			Logger.log("{0}->validateStarlingRootSize", this);
		}

        var stageWidth:int = stage.stageWidth;
        var stageHeight:int = stage.stageHeight;

        Starling.current.root.width = stageWidth;
        Starling.current.root.height = stageHeight;
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}
}