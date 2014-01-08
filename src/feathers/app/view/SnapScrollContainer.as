/**
 *
 * Copyright 2012(C) by Piotr Kucharski.
 * email: suspendmode@gmail.com
 * mobile: +48 791 630 277
 *
 * All rights reserved. Any use, copying, modification, distribution and selling of this software and it's documentation
 * for any purposes without authors' written permission is hereby prohibited.
 *
 */
package feathers.app.view {
import feathers.controls.ScrollContainer;
import feathers.system.DeviceCapabilities;
import feathers.utils.math.clamp;
import feathers.utils.math.roundDownToNearest;
import feathers.utils.math.roundToNearest;
import feathers.utils.math.roundUpToNearest;

import starling.core.Starling;
import starling.events.Event;

/**
 *
 * @author Peter
 *
 */
public class SnapScrollContainer extends ScrollContainer {
	
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * @private
     * The friction applied every frame when the scroller is "thrown".
     */
    private static const FRICTION:Number = 0.998;

    /**
     * @private
     * Extra friction applied when the scroller is beyond its bounds and
     * needs to bounce back.
     */
    private static const EXTRA_FRICTION:Number = 0.95;

    /**
     * @private
     * The minimum physical velocity (in inches per second) that a touch
     * must move before the scroller will "throw" to the next page.
     * Otherwise, it will settle to the nearest page.
     */
    private static const MINIMUM_PAGE_VELOCITY:Number = 5;

    /**
     * @private
     * The point where we stop calculating velocity changes because floating
     * point issues can start to appear.
     */
    private static const MINIMUM_VELOCITY:Number = 0.02;

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     */
    private var _pageWidth:Number;

    /**
     *
     * @return
     *
     */
    override public function get pageWidth():Number {
        return isNaN(_pageWidth) ? this.actualWidth : _pageWidth;
    }

    /**
     *
     * @param value
     *
     */
    override public function set pageWidth(value:Number):void {
        if (_pageWidth == value)
            return;
        _pageWidth = value;
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     */
    private var _pageHeight:Number;

    /**
     *
     * @return
     *
     */
    override public function get pageHeight():Number {
        return isNaN(_pageHeight) ? this.actualHeight : _pageHeight;
    }

    /**
     *
     * @param value
     *
     */
    override public function set pageHeight(value:Number):void {
        if (_pageHeight == value)
            return;
        _pageHeight = value;
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * @private
     */
    override protected function refreshScrollValues(isScrollInvalid:Boolean):void {
        if (isNaN(this.explicitHorizontalScrollStep)) {
            if (this._viewPort) {
                this.actualHorizontalScrollStep = this._viewPort.horizontalScrollStep;
            }
            else {
                this.actualHorizontalScrollStep = 1;
            }
        }
        else {
            this.actualHorizontalScrollStep = this.explicitHorizontalScrollStep;
        }
        if (isNaN(this.explicitVerticalScrollStep)) {
            if (this._viewPort) {
                this.actualVerticalScrollStep = this._viewPort.verticalScrollStep;
            }
            else {
                this.actualVerticalScrollStep = 1;
            }
        }
        else {
            this.actualVerticalScrollStep = this.explicitVerticalScrollStep;
        }

        const oldMaxHSP:Number = this._maxHorizontalScrollPosition;
        const oldMaxVSP:Number = this._maxVerticalScrollPosition;
        if (this._viewPort) {
            this._maxHorizontalScrollPosition = Math.max(0, this._viewPort.width + this._rightViewPortOffset - this.actualWidth);
            this._maxVerticalScrollPosition = Math.max(0, this._viewPort.height + this._bottomViewPortOffset - this.actualHeight);
            if (this._snapScrollPositionsToPixels) {
                this._maxHorizontalScrollPosition = Math.round(this._maxHorizontalScrollPosition);
                this._maxVerticalScrollPosition = Math.round(this._maxVerticalScrollPosition);
            }
        }
        else {
            this._maxHorizontalScrollPosition = 0;
            this._maxVerticalScrollPosition = 0;
        }

        const maximumPositionsChanged:Boolean = this._maxHorizontalScrollPosition != oldMaxHSP || this._maxVerticalScrollPosition != oldMaxVSP;
        if (maximumPositionsChanged) {
            if (this._touchPointID < 0 && !this._horizontalAutoScrollTween) {
                if (this._snapToPages) {
                    this._horizontalScrollPosition = Math.max(0, roundToNearest(this._horizontalScrollPosition, this.pageWidth));
                }
                this._horizontalScrollPosition = clamp(this._horizontalScrollPosition, 0, this._maxHorizontalScrollPosition);
            }
            if (this._touchPointID < 0 && !this._verticalAutoScrollTween) {
                if (this._snapToPages) {
                    this._verticalScrollPosition = Math.max(0, roundToNearest(this._verticalScrollPosition, this.pageHeight));
                }
                this._verticalScrollPosition = clamp(this._verticalScrollPosition, 0, this._maxVerticalScrollPosition);
            }
        }

        if (this._snapToPages) {
            if (isScrollInvalid && !this._isDraggingHorizontally && !this._horizontalAutoScrollTween) {
                this._horizontalPageIndex = Math.max(0, Math.floor(this._horizontalScrollPosition / this.pageWidth));
            }
            if (isScrollInvalid && !this._isDraggingVertically && !this._verticalAutoScrollTween) {
                this._verticalPageIndex = Math.max(0, Math.floor(this._verticalScrollPosition / this.pageHeight));
            }
        }
        else {
            this._horizontalPageIndex = this._verticalPageIndex = 0;
        }

        if (maximumPositionsChanged) {
            if (this._horizontalAutoScrollTween && this._targetHorizontalScrollPosition > this._maxHorizontalScrollPosition && oldMaxHSP > this._maxHorizontalScrollPosition) {
                this._targetHorizontalScrollPosition -= (oldMaxHSP - this._maxHorizontalScrollPosition);
                this.throwTo(this._targetHorizontalScrollPosition, NaN, this._horizontalAutoScrollTween.totalTime - this._horizontalAutoScrollTween.currentTime);
            }
            if (this._verticalAutoScrollTween && this._targetVerticalScrollPosition > this._maxVerticalScrollPosition && oldMaxVSP > this._maxVerticalScrollPosition) {
                this._targetVerticalScrollPosition -= (oldMaxVSP - this._maxVerticalScrollPosition);
                this.throwTo(NaN, this._targetVerticalScrollPosition, this._verticalAutoScrollTween.totalTime - this._verticalAutoScrollTween.currentTime);
            }

            //if we clamped the scroll position above, we need to inform
            //the view port about the new scroll position
            this._viewPort.horizontalScrollPosition = this._horizontalScrollPosition;
            this._viewPort.verticalScrollPosition = this._verticalScrollPosition;
        }
        if (maximumPositionsChanged || isScrollInvalid) {
            this.dispatchEventWith(Event.SCROLL);
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * @private
     */
    override protected function throwHorizontally(pixelsPerMS:Number):void {
        if (this._snapToPages) {
            const inchesPerSecond:Number = 1000 * pixelsPerMS / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
            if (inchesPerSecond > MINIMUM_PAGE_VELOCITY) {
                var snappedPageHorizontalScrollPosition:Number = roundDownToNearest(this._horizontalScrollPosition, this.pageWidth);
            }
            else if (inchesPerSecond < -MINIMUM_PAGE_VELOCITY) {
                snappedPageHorizontalScrollPosition = roundUpToNearest(this._horizontalScrollPosition, this.pageWidth);
            }
            else {
                snappedPageHorizontalScrollPosition = roundToNearest(this._horizontalScrollPosition, this.pageWidth);
            }
            snappedPageHorizontalScrollPosition = Math.max(0, Math.min(this._maxHorizontalScrollPosition, snappedPageHorizontalScrollPosition));
            this.throwToPage(snappedPageHorizontalScrollPosition / this.actualWidth, -1, this._pageThrowDuration);
            return;
        }

        var absPixelsPerMS:Number = Math.abs(pixelsPerMS);
        if (absPixelsPerMS <= MINIMUM_VELOCITY) {
            this.finishScrollingHorizontally();
            return;
        }
        var targetHorizontalScrollPosition:Number = this._horizontalScrollPosition + (pixelsPerMS - MINIMUM_VELOCITY) / Math.log(FRICTION);
        if (targetHorizontalScrollPosition < 0 || targetHorizontalScrollPosition > this._maxHorizontalScrollPosition) {
            var duration:Number = 0;
            targetHorizontalScrollPosition = this._horizontalScrollPosition;
            while (Math.abs(pixelsPerMS) > MINIMUM_VELOCITY) {
                targetHorizontalScrollPosition -= pixelsPerMS;
                if (targetHorizontalScrollPosition < 0 || targetHorizontalScrollPosition > this._maxHorizontalScrollPosition) {
                    if (this._hasElasticEdges) {
                        pixelsPerMS *= FRICTION * EXTRA_FRICTION;
                    }
                    else {
                        targetHorizontalScrollPosition = clamp(targetHorizontalScrollPosition, 0, this._maxHorizontalScrollPosition);
                        duration++;
                        break;
                    }
                }
                else {
                    pixelsPerMS *= FRICTION;
                }
                duration++;
            }
        }
        else {
            duration = Math.log(MINIMUM_VELOCITY / absPixelsPerMS) / Math.log(FRICTION);
        }
        this.throwTo(targetHorizontalScrollPosition, NaN, duration / 1000);
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * @private
     */
    override protected function throwVertically(pixelsPerMS:Number):void {
        if (this._snapToPages) {
            const inchesPerSecond:Number = 1000 * pixelsPerMS / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
            if (inchesPerSecond > MINIMUM_PAGE_VELOCITY) {
                var snappedPageVerticalScrollPosition:Number = roundDownToNearest(this._verticalScrollPosition, this.pageHeight);
            }
            else if (inchesPerSecond < -MINIMUM_PAGE_VELOCITY) {
                snappedPageVerticalScrollPosition = roundUpToNearest(this._verticalScrollPosition, this.pageHeight);
            }
            else {
                snappedPageVerticalScrollPosition = roundToNearest(this._verticalScrollPosition, this.pageHeight);
            }
            snappedPageVerticalScrollPosition = Math.max(0, Math.min(this._maxVerticalScrollPosition, snappedPageVerticalScrollPosition));
            this.throwToPage(-1, snappedPageVerticalScrollPosition / this.actualHeight, this._pageThrowDuration);
            return;
        }

        var absPixelsPerMS:Number = Math.abs(pixelsPerMS);
        if (absPixelsPerMS <= MINIMUM_VELOCITY) {
            this.finishScrollingVertically();
            return;
        }

        var targetVerticalScrollPosition:Number = this._verticalScrollPosition + (pixelsPerMS - MINIMUM_VELOCITY) / Math.log(FRICTION);
        if (targetVerticalScrollPosition < 0 || targetVerticalScrollPosition > this._maxVerticalScrollPosition) {
            var duration:Number = 0;
            targetVerticalScrollPosition = this._verticalScrollPosition;
            while (Math.abs(pixelsPerMS) > MINIMUM_VELOCITY) {
                targetVerticalScrollPosition -= pixelsPerMS;
                if (targetVerticalScrollPosition < 0 || targetVerticalScrollPosition > this._maxVerticalScrollPosition) {
                    if (this._hasElasticEdges) {
                        pixelsPerMS *= FRICTION * EXTRA_FRICTION;
                    }
                    else {
                        targetVerticalScrollPosition = clamp(targetVerticalScrollPosition, 0, this._maxVerticalScrollPosition);
                        duration++;
                        break;
                    }
                }
                else {
                    pixelsPerMS *= FRICTION;
                }
                duration++;
            }
        }
        else {
            duration = Math.log(MINIMUM_VELOCITY / absPixelsPerMS) / Math.log(FRICTION);
        }
        this.throwTo(NaN, targetVerticalScrollPosition, duration / 1000);
    }
}
}
