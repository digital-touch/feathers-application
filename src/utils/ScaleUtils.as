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

import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;

import starling.display.DisplayObject;

/**
 *
 * Narzędzie skalowania
 *
 * @author suspendmode@gmail.com
 *
 */
public class ScaleUtils {
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     */
    public static const ZOOM:String = "zoom";

    /**
     *
     */
    public static const LETTERBOX:String = "letterbox";

    /**
     *
     */
    public static const STRETCH:String = "stretch";

    /**
     *
     */
    public static const NONE:String = "none";

    /**
     *
     * @param sourceWidth
     * @param sourceHeight
     * @param targetWidth
     * @param targetHeight
     * @return
     *
     */
    public static function getScaleFactor(sourceWidth:int, sourceHeight:int, targetWidth:int, targetHeight:int):Point {

        var scaleFactor:Point = new Point(targetWidth / sourceWidth, targetHeight / sourceHeight);
        return scaleFactor;

    }

    /**
     *
     * @param data
     * @param targetWidth
     * @param targetHeight
     * @return
     *
     */
    public static function scaleBitmapData(data:BitmapData, targetWidth:int, targetHeight:int):BitmapData {

        var scaleFactor:Point = getScaleFactor(data.width, data.height, targetWidth, targetHeight);
        var mat:Matrix = new Matrix();
        mat.scale(scaleFactor.x, scaleFactor.y);
        var bmpd_draw:BitmapData = new BitmapData(targetWidth, targetHeight, true, 0xFFFFFF);
        bmpd_draw.draw(data, mat, null, null, null, false);
        return bmpd_draw;

    }

    /**
     *
     * @param target
     * @param scaleMode
     * @param availableWidth
     * @param availableHeight
     * @param intrinsicWidth
     * @param intrinsicHeight
     * @return
     *
     */
    public static function scaleDisplayObjectTo(target:DisplayObject, scaleMode:String, availableWidth:Number, availableHeight:Number, intrinsicWidth:Number, intrinsicHeight:Number):void {

        var size:Point = getScaledSize(scaleMode, availableWidth, availableHeight, intrinsicWidth, intrinsicHeight);
        target.width = size.x;
        target.height = size.y;

    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     * @param scaleMode
     * @param availableWidth
     * @param availableHeight
     * @param intrinsicWidth
     * @param intrinsicHeight
     * @return
     *
     */
    public static function getScaledSize(scaleMode:String, availableWidth:Number, availableHeight:Number, intrinsicWidth:Number, intrinsicHeight:Number):Point {

        var result:Point;

        switch (scaleMode) {
            case ScaleUtils.ZOOM:
            case ScaleUtils.LETTERBOX:

                var availableRatio:Number = availableWidth / availableHeight;

                var componentRatio:Number = (intrinsicWidth || availableWidth) / (intrinsicHeight || availableHeight);

                if ((scaleMode == ScaleUtils.ZOOM && componentRatio < availableRatio) || (scaleMode == ScaleUtils.LETTERBOX && componentRatio > availableRatio)) {
                    result = new Point(availableWidth, availableWidth / componentRatio);
                }
                else {
                    result = new Point(availableHeight * componentRatio, availableHeight);
                }

                break;

            case ScaleUtils.STRETCH:

                result = new Point(availableWidth, availableHeight);
                break;

            case ScaleUtils.NONE:

                result = new Point(intrinsicWidth || availableWidth, intrinsicHeight || availableHeight);

                break;
        }

        return result;

    }

    /**
     *
     * @param value
     * @return
     *
     */
    public static function nextPowerOfTwoA(value:int):int {

        return value < 2 ? 1 : 1 << (value - 1).toString(2).length;

    }

    /**
     *
     * @param value
     * @return
     *
     */
    public static function nextPowerOfTwoB(value:int):int {

        return int(Math.pow(2, Math.ceil(Math.log(value) / Math.log(2))));

    }

    /**
     *
     * @param value
     * @return
     *
     */
    public static function nextPowerOfTwoC(value:int):int {

        value--;
        value = (value >> 1) | value;
        value = (value >> 2) | value;
        value = (value >> 4) | value;
        value = (value >> 8) | value;
        value = (value >> 16) | value;
        value++;
        return value;

    }

    /**
     *
     * @param target
     * @param intrinsicWidth
     * @param intrinsicHeight
     * @param scale
     *
     */
    public static function scaleDisplayObject(target:DisplayObject, intrinsicWidth:Number, intrinsicHeight:Number, scale:Number):void {

        target.width = intrinsicWidth * scale;
        target.height = intrinsicHeight * scale;

    }
}
}
