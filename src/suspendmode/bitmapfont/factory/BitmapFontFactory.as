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
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextFormat;

import org.villekoskela.utils.RectanglePacker;

import suspendmode.bitmapfont.file.FontChar;
import suspendmode.bitmapfont.file.FontFile;
import suspendmode.bitmapfont.file.FontPage;

/**
 *
 * @author developer
 *
 */
public class BitmapFontFactory implements IBitmapFontFactory {
    /**
     *
     */
    public static const CHARS_WHITE:String = " ";

    /**
     *
     */
    public static const CHARS_SPECIAL:String = "~!@#$%^&*()_+|`-=\{}[]:\";'<>?,./"

    /**
     *
     */
    public static const CHARS_NUMBERS:String = "1234567890";

    /**
     *
     */
    public static const CHARS_LATIN:String = "ABCDEFGHIJKLMNOPRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

    /**
     *
     */
    public static const CHARS_PL:String = "ĄĆĘŁÓŚŻŹąćęłóśżźŃń";

    /**
     *
     */
    public static const MAX_TEXTURE_PAGE_SIZE:int = 1024;

    /**
     *
     */
    public const rectanglePacker:RectanglePacker = new RectanglePacker(1, 1);

    /**
     *
     */
    public var packed:Boolean = false;

    /**
     *
     */
    private var notFitt:Vector.<Rectangle>;

    /**
     *
     */
    public const bitmapCharFactory:IBitmapCharFactory = new BitmapCharFactory();

    /**
     *
     * @param styleID
     * @param charset
     * @param textFormat
     * @param textFieldProperties
     * @return
     *
     */
    public function render(styleID:String, charset:String, textFormat:TextFormat, textFieldProperties:Object = null):IBitmapFontStyle {

        // create style

        var style:BitmapFontStyle = new BitmapFontStyle();
        style.id = styleID;
        style.textFormat = textFormat;
        style.textFieldProperties = textFieldProperties;
        style.charset = charset;

        // create chars bitmapData

        bitmapCharFactory.render(style);

        // create font

        packBitmapDataRectangles(style);

        createFontBitmapData(style);

        return style;
    }

    /**
     *
     * @param style
     *
     */
    private function createFontBitmapData(style:IBitmapFontStyle):void {
        var bounding:Rectangle = rectanglePacker.bounding;

        style.bitmapData = new BitmapData(bounding.width, bounding.height, true, 0x00000000);

        var rect:Rectangle;

        for (var j:int = 0; j < rectanglePacker.rectangleCount; j++) {
            rect = rectanglePacker.getRectangle(j, rect);

            var rectangleID:int = rectanglePacker.getRectangleId(j);

            var charBitmapData:ICharBitmapData = getCharBitmapDataByCode(style.charBitmapDatas, rectangleID);

            charBitmapData.rectangle.copyFrom(rect);

            var source:BitmapData = charBitmapData.bitmapData;
            var sourceRectangle:Rectangle = charBitmapData.charBoundaries;
            var targetPoint:Point = rect.topLeft;
            style.bitmapData.merge(source, sourceRectangle, targetPoint, 255, 255, 255, 255);
        }
    }

    /**
     *
     * @param charBitmapDatas
     * @param rectangleID
     * @return
     *
     */
    private function getCharBitmapDataByCode(charBitmapDatas:Vector.<ICharBitmapData>, rectangleID:int):ICharBitmapData {
        for each (var char:ICharBitmapData in charBitmapDatas) {
            if (char.code == rectangleID) {
                return char;
            }
        }
        return null;
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     * @param style
     *
     */
    private function packBitmapDataRectangles(style:IBitmapFontStyle):void {
        rectanglePacker.reset(MAX_TEXTURE_PAGE_SIZE, MAX_TEXTURE_PAGE_SIZE);

        var length:int = style.charBitmapDatas.length
        for (var i:int = 0; i < length; i++) {
            var charBitmapData:ICharBitmapData = style.charBitmapDatas[i];
            var rect:Rectangle = charBitmapData.bitmapData.rect;
            rectanglePacker.insertRectangle(rect.width, rect.height, charBitmapData.code);
        }

        rectanglePacker.packRectangles(true);
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     * @param style
     * @return
     *
     */
    public function createFontFile(style:IBitmapFontStyle):FontFile {

        var font:FontFile = new FontFile()

        font.info.face = style.textFormat.font;
        font.info.size = Number(style.textFormat.size);
        font.info.bold = Number(style.textFormat.bold);
        font.info.italic = Number(style.textFormat.italic);
        font.info.unicode = 0;
        font.info.spacing = "0,0";
        font.info.outline = 0;
        font.info.smooth = 0;
        font.info.padding = "0,0,0,0";

        var page:FontPage = new FontPage();
        page.id = 0;
        page.file = "dynamic";
        font.pages.push(page);

        var count:int = style.charBitmapDatas.length;

        for (var i:int = 0; i < count; i++) {
            var charBitmapData:ICharBitmapData = style.charBitmapDatas[i];

            var fontChar:FontChar = new FontChar();
            fontChar.id = charBitmapData.code;
            fontChar.page = page.id;

            var rect:Rectangle = charBitmapData.rectangle;
            fontChar.x = rect.x;
            fontChar.y = rect.y;
            fontChar.width = rect.width;
            fontChar.height = rect.height;

            fontChar.xadvance = rect.width;

            if (charBitmapData.charBoundaries) {
                fontChar.xadvance -= 2;
            }

            font.common.lineHeight = charBitmapData.metrics.height;
            font.common.base = charBitmapData.metrics.descent;
            font.chars.push(fontChar);
        }

        return font;
    }

    /**
     *
     * @param fromCharCode
     * @param toCharCode
     * @return
     *
     */
    public static function createCharset(fromCharCode:Number, toCharCode:Number):String {
        var text:String = "";
        for (var charCode:Number = fromCharCode; charCode <= toCharCode; charCode++) {
            text += String.fromCharCode(charCode);
        }
        return text;
    }
}
}