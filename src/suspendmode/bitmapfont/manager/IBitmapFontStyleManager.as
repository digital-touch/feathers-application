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
package suspendmode.bitmapfont.manager {
import feathers.text.BitmapFontTextFormat;

import flash.text.TextFormat;

import suspendmode.bitmapfont.factory.IBitmapFontStyle;

/**
 *
 * @author developer
 *
 */
public interface IBitmapFontStyleManager {
    /**
     *
     * @param bitmapFontTextFormat
     *
     */
    function set bitmapFontTextFormatClass(bitmapFontTextFormat:Class):void;

    /**
     *
     * @param styleID
     * @param align
     * @param properties
     * @return
     *
     */
    function getBitmapFontTextFormat(styleID:String, align:String, properties:Object = null):BitmapFontTextFormat;

    /**
     *
     * @param styleID
     * @param charset
     * @param textFormat
     * @param textFormatProperties
     *
     */
    function addStyle(styleID:String, charset:String, textFormat:TextFormat, textFormatProperties:Object = null):void;

    /**
     *
     * @param styleID
     *
     */
    function removeStyle(styleID:String):void;

    /**
     *
     * @return
     *
     */
    function getAllStyles():Vector.<IBitmapFontStyle>;

    /**
     *
     * @param id
     * @return
     *
     */
    function getStyle(id:String):IBitmapFontStyle;
}
}
