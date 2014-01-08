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
public interface ICharBitmapData {
    /**
     *
     * @return
     *
     */
    function get code():Number;

    /**
     *
     * @return
     *
     */
    function get bitmapData():BitmapData;

    /**
     *
     * @return
     *
     */
    function get metrics():TextLineMetrics;

    /**
     *
     * @return
     *
     */
    function get rectangle():Rectangle;

    /**
     *
     * @return
     *
     */
    function get charBoundaries():Rectangle;
}
}