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
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.text.AntiAliasType;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextLineMetrics;

/**
 *
 * @author developer
 *
 */
public class BitmapCharFactory implements IBitmapCharFactory {

    /**
     *
     */
    public var textField:TextField = new TextField();

    /**
     *
     */
    public var metrics:TextLineMetrics;

    /**
     *
     * @param properties
     *
     */
    public function updateTextFieldProperties(properties:Object):void {
        for (var n:String in properties) {
            textField[n] = properties[n];
        }
    }

    /**
     *
     * @param textFormat
     *
     */
    public function updateTextFormat(textFormat:TextFormat):void {
        textField.defaultTextFormat = textFormat;

        if (!textField.autoSize || textField.autoSize == TextFieldAutoSize.NONE) {
            textField.autoSize = TextFieldAutoSize.LEFT;
        }

        metrics = textField.getLineMetrics(0);
        textField.antiAliasType = AntiAliasType.ADVANCED;
        textField.gridFitType = GridFitType.SUBPIXEL;
        textField.selectable = false;
    }

    /**
     *
     * @param style
     *
     */
    public function render(style:IBitmapFontStyle):void {

        updateTextFieldProperties(style.textFieldProperties);
        updateTextFormat(style.textFormat);

        createCharacterBitmapDatas(style.charset, style.charBitmapDatas);
    }

    /**
     *
     * @param charset
     * @param charBitmapDatas
     *
     */
    public function createCharacterBitmapDatas(charset:String, charBitmapDatas:Vector.<ICharBitmapData>):void {
        charBitmapDatas.length = 0;

        var count:int = charset.length;

        for (var i:int = 0; i < count; i++) {
            var code:Number = charset.charCodeAt(i);
            var data:ICharBitmapData = createCharacterBitmapData(code);
            charBitmapDatas.push(data);
        }
    }

    /**
     *
     * @param code
     * @return
     *
     */
    public function createCharacterBitmapData(code:Number):ICharBitmapData {

        var charBitmapData:CharBitmapData = new CharBitmapData();

        charBitmapData.code = code;

        // create BitmapData

        charBitmapData.bitmapData = renderTextField(charBitmapData.code);
        var boundaries:Rectangle = textField.getCharBoundaries(0);
        if (boundaries) {
            charBitmapData.charBoundaries.copyFrom(boundaries);
        }
        // props

        charBitmapData.metrics = metrics;

        return charBitmapData;
    }

    /**
     *
     * @param code
     * @return
     *
     */
    public function renderTextField(code:Number):BitmapData {
        textField.text = String.fromCharCode(code);

        var metrics:TextLineMetrics = textField.getLineMetrics(0);
        var width:Number;
        var height:Number;
        if (!metrics || !metrics.width || !metrics.height) {
            width = Math.ceil(textField.width);
            height = Math.ceil(textField.height);
        }
        else {
            width = Math.ceil(metrics.width);
            height = Math.ceil(metrics.height);
        }

        width += 1
        if (textField.defaultTextFormat.bold || textField.defaultTextFormat.italic) {
            //width++;
        }
        var bitmapData:BitmapData = new BitmapData(width, height, true, 0x00000000);

        const matrix:Matrix = new Matrix();

        if (metrics) {
            matrix.translate(Math.ceil(-metrics.x + 1), 0);
        }
        bitmapData.draw(textField, matrix, null, null, null, true);
        return bitmapData;
    }
}
}
