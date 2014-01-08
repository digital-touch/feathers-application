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
import flash.text.TextFormat;

/**
 *
 * @author developer
 *
 */
public interface IBitmapFontStyle {
    /**
     *
     * @return
     *
     */
    function get id():String;

    /**
     *
     * @return
     *
     */
    function get textFormat():TextFormat;

    /**
     *
     * @return
     *
     */
    function get textFieldProperties():Object;

    /**
     *
     * @return
     *
     */
    function get charset():String;

    /**
     *
     * @param value
     *
     */
    function set bitmapData(value:BitmapData):void;

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
    function get charBitmapDatas():Vector.<ICharBitmapData>;

}
}