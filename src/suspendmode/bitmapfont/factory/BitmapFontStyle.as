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
public class BitmapFontStyle implements IBitmapFontStyle {
    /**
     *
     *
     */
    public function BitmapFontStyle() {
        super();
    }

    /**
     *
     */
    private var _id:String;

    /**
     *
     * @return
     *
     */
    public function get id():String {
        return _id;
    }

    /**
     *
     * @param value
     *
     */
    public function set id(value:String):void {
        if (_id == value)
            return;
        _id = value;
    }

    /**
     *
     */
    private var _textFormat:TextFormat;

    /**
     *
     * @return
     *
     */
    public function get textFormat():TextFormat {
        return _textFormat;
    }

    /**
     *
     * @param value
     *
     */
    public function set textFormat(value:TextFormat):void {
        if (_textFormat == value)
            return;
        _textFormat = value;
    }

    /**
     *
     */
    private var _textFieldProperties:Object;

    /**
     *
     * @return
     *
     */
    public function get textFieldProperties():Object {
        return _textFieldProperties;
    }

    /**
     *
     * @param value
     *
     */
    public function set textFieldProperties(value:Object):void {
        if (_textFieldProperties == value)
            return;
        _textFieldProperties = value;
    }

    /**
     *
     */
    private var _charset:String;

    /**
     *
     * @return
     *
     */
    public function get charset():String {
        return _charset;
    }

    /**
     *
     * @param value
     *
     */
    public function set charset(value:String):void {
        if (_charset == value)
            return;
        _charset = value;
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
    }

    /**
     *
     */
    private const _charBitmapDatas:Vector.<ICharBitmapData> = new Vector.<ICharBitmapData>();

    /**
     *
     * @return
     *
     */
    public function get charBitmapDatas():Vector.<ICharBitmapData> {
        return _charBitmapDatas;
    }

}
}