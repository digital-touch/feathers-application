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

import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.Texture;

import suspendmode.bitmapfont.factory.BitmapFontFactory;
import suspendmode.bitmapfont.factory.IBitmapFontFactory;
import suspendmode.bitmapfont.factory.IBitmapFontStyle;

/**
 *
 * @author developer
 *
 */
public class BitmapFontStyleManager implements IBitmapFontStyleManager {

    /**
     *
     */
    private const styles:Vector.<IBitmapFontStyle> = new Vector.<IBitmapFontStyle>();

    /**
     *
     */
    private const fonts:Vector.<BitmapFont> = new Vector.<BitmapFont>();

    /**
     *
     */
    private const STYLE_NOT_FOUND_ERROR:String = "Style not found";

    /**
     *
     */
    private var _bitmapFontTextFormatClass:Class = BitmapFontTextFormat;

    /**
     *
     * @return
     *
     */
    public function get bitmapFontTextFormatClass():Class {
        return _bitmapFontTextFormatClass;
    }

    /**
     *
     * @param value
     *
     */
    public function set bitmapFontTextFormatClass(value:Class):void {
        if (_bitmapFontTextFormatClass == value)
            return;
        _bitmapFontTextFormatClass = value;
    }

    /**
     *
     * @param styleID
     * @param align
     * @param properties
     * @return
     *
     */
    public function getBitmapFontTextFormat(styleID:String, align:String, properties:Object = null):BitmapFontTextFormat {
        var style:IBitmapFontStyle = getStyle(styleID);
        if (!style) {
            throw STYLE_NOT_FOUND_ERROR;
        }
        var index:int = styles.indexOf(style);
        var font:BitmapFont = fonts[index];
        var generator:Class = bitmapFontTextFormatClass;
        var format:BitmapFontTextFormat = new generator(font, NaN, 0xFFFFFF, align);
        return format;
    }

    /**
     *
     * @param styleID
     * @param charset
     * @param textFormat
     * @param textFormatProperties
     *
     */
    public function addStyle(styleID:String, charset:String, textFormat:TextFormat, textFormatProperties:Object = null):void {
        var factory:IBitmapFontFactory = new BitmapFontFactory();

        var style:IBitmapFontStyle = factory.render(styleID, charset, textFormat, textFormatProperties);
        styles.push(style);

        var font:BitmapFont = new BitmapFont(Texture.fromBitmapData(style.bitmapData), factory.createFontFile(style).toXML());
        TextField.registerBitmapFont(font, styleID);
        fonts.push(font);
    }

    /**
     *
     * @param styleID
     * @return
     *
     */
    public function getStyle(styleID:String):IBitmapFontStyle {
        var length:int = styles.length;
        for (var i:int = 0; i < length; i++) {
            var style:IBitmapFontStyle = styles[i];
            if (style.id == styleID) {
                return style;
            }
        }
        return null;
    }

    /**
     *
     * @param styleID
     *
     */
    public function removeStyle(styleID:String):void {
        var style:IBitmapFontStyle = getStyle(styleID);
        if (!style) {
            throw STYLE_NOT_FOUND_ERROR;
        }
        var index:int = styles.indexOf(style);
        styles.splice(index, 1);

        var font:BitmapFont = fonts[index];
        TextField.unregisterBitmapFont(styleID, true);
        fonts.splice(index, 1);
    }

    /**
     *
     * @return
     *
     */
    public function getAllStyles():Vector.<IBitmapFontStyle> {
        return styles.concat();
    }
}
}
