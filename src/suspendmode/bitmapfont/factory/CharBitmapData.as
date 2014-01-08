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
package suspendmode.bitmapfont.factory {
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.text.TextLineMetrics;

/**
 *
 * @author developer
 *
 */
public class CharBitmapData implements ICharBitmapData {

    /**
     *
     */
    private var _code:Number;
    /**
     *
     * @return
     *
     */
    public function get code():Number {
        return _code;
    }

    /**
     *
     * @param value
     *
     */
    public function set code(value:Number):void {
        if (_code == value)
            return;
        _code = value;
    }

    /**
     *
     */
    private var _metrics:TextLineMetrics;
    /**
     *
     * @return
     *
     */
    public function get metrics():TextLineMetrics {
        return _metrics;
    }

    /**
     *
     * @param value
     *
     */
    public function set metrics(value:TextLineMetrics):void {
        if (_metrics == value)
            return;
        _metrics = value;
    }

    /**
     *
     */
    private var _bitmapData:BitmapData;

    /**
     *
     * @return
     *
     */
    public function get bitmapData():BitmapData {
        return _bitmapData;
    }

    /**
     *
     * @param value
     *
     */
    public function set bitmapData(value:BitmapData):void {
        if (_bitmapData == value)
            return;
        _bitmapData = value;

        if (value) {
            _rectangle.width = value.width;
            _rectangle.height = value.height;
        } else {
            _rectangle.width = 0;
            _rectangle.height = 0;
        }
    }

    /**
     *
     */
    private const _rectangle:Rectangle = new Rectangle();

    /**
     *
     * @return
     *
     */
    public function get rectangle():Rectangle {
        return _rectangle;
    }

    /**
     *
     */
    private const _charBoundaries:Rectangle = new Rectangle();

    /**
     *
     * @return
     *
     */
    public function get charBoundaries():Rectangle {
        return _charBoundaries;
    }


}
}