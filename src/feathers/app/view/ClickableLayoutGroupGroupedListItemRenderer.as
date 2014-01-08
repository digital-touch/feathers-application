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
package feathers.app.view {

import flash.geom.Point;

import feathers.controls.GroupedList;
import feathers.controls.renderers.LayoutGroupGroupedListItemRenderer;
import feathers.events.FeathersEventType;

import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class ClickableLayoutGroupGroupedListItemRenderer extends LayoutGroupGroupedListItemRenderer {
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	private static const HELPER_POINT:Point = new Point();
	
	protected var touchPointID:int = -1;
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function ClickableLayoutGroupGroupedListItemRenderer()
	{
		super();
		isQuickHitAreaEnabled = true;
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	override protected function initialize():void {
		super.initialize();
		addEventListener(TouchEvent.TOUCH, onTouch);
	}
	
	override public function dispose():void {
		super.dispose();
		removeEventListener(TouchEvent.TOUCH, onTouch);
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	override public function set owner(value:GroupedList):void
	{
		if(super.owner == value)
		{
			return;
		}
		if(super.owner)
		{
			this._owner.removeEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
			this._owner.removeEventListener(FeathersEventType.SCROLL_COMPLETE, owner_scrollCompleteHandler);
		}
		super.owner = value;
		if(super.owner)
		{
			const list:GroupedList = GroupedList(super.owner);				
			super.owner.addEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
			super.owner.addEventListener(FeathersEventType.SCROLL_COMPLETE, owner_scrollCompleteHandler);
		}
		this.invalidate(INVALIDATION_FLAG_DATA);
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * @private
	 */
	protected function owner_scrollStartHandler(event:Event):void
	{
		if(this.touchPointID < 0)
		{
			return;
		}
		this.resetTouchState();
	}
	
	/**
	 * @private
	 */
	protected function owner_scrollCompleteHandler(event:Event):void
	{
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	protected function resetTouchState(touch:Touch = null):void
	{
		this.touchPointID = -1;
		
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	protected function onTouch(event: TouchEvent):void
	{
		if(!this._isEnabled)
		{
			this.touchPointID = -1;
			return;
		}
		
		if(this.touchPointID >= 0)
		{
			var touch:Touch = event.getTouch(this, null, this.touchPointID);
			if(!touch)
			{
				//this should never happen
				return;
			}
			
			
			touch.getLocation(this.stage, HELPER_POINT);
			const isInBounds:Boolean = this.contains(this.stage.hitTest(HELPER_POINT, true));
			
			if(touch.phase == TouchPhase.ENDED)
			{				
				if(isInBounds)
				{
					this.dispatchEventWith(Event.TRIGGERED);					
				}
			}
		} else //if we get here, we don't have a saved touch ID yet
		{
			touch = event.getTouch(this, TouchPhase.BEGAN);
			if(touch)
			{
				
				this.touchPointID = touch.id;
				
				return;
			}
			
		}
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
}
