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
package utils {

import flash.display.Stage;
import flash.system.Capabilities;

import logger.Logger;

import org.swiftsuspenders.Injector;

import starling.core.Starling;
import starling.events.EventDispatcher;

[Event(name="scaleChange", type="starling.events.Event")]
/**
 *
 * @author suspendmode@gmail.com
 *
 */
public class ScreenScale {

    [Inject]
    /**
     *
     */
    public var eventDispatcher:EventDispatcher;

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public static const SCALE_CHANGE_EVENT:String = "scaleChangeEvent";

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     */
    public static const SCALE_VALUE_MAPPING_NAME:String = "scale";

    /**
     *
     */
    public static const DESKTOP:String = "desktop";

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    [Inject]
    /**
     *
     */
    public var injector:Injector;
   
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private var designWidth:Number = 640;
    private var designHeight:Number = 960;
    private var designPPI:Number = 326;
    private var simulateScale:Boolean = false
    private var simulatedScale:Number = 1;
	private var stage:Stage;

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    public function ScreenScale(designWidth:Number, designHeight:Number, designPPI:Number, stage: Stage, simulateScale:Boolean = false, simulatedScale = 1) {
        this.designWidth = designWidth;
        this.designHeight = designHeight;
        this.designPPI = designPPI;
        this.simulateScale = simulateScale;
        this.simulatedScale = simulatedScale;
		this.stage = stage;
    }

    [PostConstruct]
    public function initialize():void {
		config::debug {
			Logger.log("{0}->initialize", this);
		}
        update();

    }

	public static function calculateScaleFactor(designWidth:Number, designHeight:Number, designPPI:Number, stage:Stage):Number {
		
		var screenWidth:Number = stage.fullScreenWidth;
		var screenHeight:Number = stage.fullScreenHeight;
		var screenPPI:Number = Capabilities.screenDPI;
		
		var designSize:Number = getSize(designWidth, designHeight, designPPI);
		var screenSize:Number = getSize(screenWidth, screenHeight, screenPPI);
		var factor:Number = screenSize / designSize;
		
		return (screenPPI / designPPI) * factor;
		
	}
    public function update():void {

        if (!enabled) {
            return;
        }
        if (Capabilities.playerType == "Desktop" && simulateScale) {
            scale = simulatedScale;
        } else {
            scale = calculateScaleFactor(designWidth, designHeight, designPPI, stage);
        }

		config::debug {
			Logger.log("{0}->update scale:{1} isSD:{1} isTablet:{2}", this, scale, isSD, isTablet);
		}	
			
        if (injector.hasMapping(Number, SCALE_VALUE_MAPPING_NAME)) {
            injector.unmap(Number, SCALE_VALUE_MAPPING_NAME);
        }
        injector.map(Number, SCALE_VALUE_MAPPING_NAME).toValue(scale);
        if (eventDispatcher) {
            eventDispatcher.dispatchEventWith(SCALE_CHANGE_EVENT);
        }

    }

    // is tablet
    public function get isTablet():Boolean {
        
        var screenWidth:Number = stage.fullScreenWidth;
        var screenHeight:Number = stage.fullScreenHeight;
        var screenPPI:Number = Capabilities.screenDPI;
        var sizeInInches:Number = getSize(screenWidth, screenHeight, screenPPI);
        var is7inchTablet:Boolean = sizeInInches >= 7;
        return is7inchTablet;

    }

    public static function getSize(width:Number, height:Number, ppi:Number):Number {

        var widthInInches:Number = width / ppi;
        var heightInInches:Number = height / ppi;
        var sizeInInches:Number = Math.sqrt(Math.pow(widthInInches, 2) + Math.pow(heightInInches, 2));
        return sizeInInches;

    }

    [PreDestroy]
    public function dispose():void {

		config::debug {
			Logger.log("{0}->dispose", this);
		}
			
        if (injector.hasMapping(Number, SCALE_VALUE_MAPPING_NAME)) {
            injector.unmap(Number, SCALE_VALUE_MAPPING_NAME);
        }

    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     */

    private var _enabled:Boolean = true;

    /**
     *
     * @return
     *
     */
    public function get enabled():Boolean {

        return _enabled;

    }

    /**
     *
     * @param value
     *
     */
    public function set enabled(value:Boolean):void {

        if (_enabled == value)
            return;
        _enabled = value;
        update();

    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public function get isSD():Boolean {

        return scale <= 0.52;

    }

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 *
	 */
	private var _scale:Number = 1;
	
	/**
	 *
	 * @return
	 *
	 */
	public function get scale():Number {
		
		return _scale;
		
	}
	
	/**
	 *
	 * @param value
	 *
	 */
	public function set scale(value:Number):void {
		
		if (_scale == value)
			return;
		_scale = value;
		
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 *
	 */
	protected var _originalDPI:int;
	
	/**
	 *
	 * @return
	 *
	 */
	public function get originalDPI():int {
		
		return _originalDPI;
		
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 *
	 */
	protected var _scaleToDPI:Boolean = true;
	
	/**
	 *
	 * @return
	 *
	 */
	public function get scaleToDPI():Boolean {
		
		return _scaleToDPI;
		
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
}
