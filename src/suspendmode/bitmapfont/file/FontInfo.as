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
package suspendmode.bitmapfont.file {
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 *
 * @author developer
 *
 */
public class FontInfo {
    /**
     *
     */
    public var face:String = "";

    /**
     *
     */
    public var size:Number = 0;

    /**
     *
     */
    public var bold:Number = 0;

    /**
     *
     */
    public var italic:Number = 0;

    /**
     *
     */
    public var charSet:String = "";

    /**
     *
     */
    public var unicode:Number = 0;

    /**
     *
     */
    public var stretchHeight:Number = 0;

    /**
     *
     */
    public var smooth:Number = 0;

    /**
     *
     */
    public var superSampling:Number = 0;

    /**
     *
     */
    private const _padding:Rectangle = new Rectangle();

    /**
     *
     * @return
     *
     */
    public function get padding():String {
        return _padding.x + "," + _padding.y + "," + _padding.width + "," + _padding.height;
    }

    /**
     *
     * @param value
     *
     */
    public function set padding(value:String):void {
        var values:Array = value.split(",");
        _padding.setTo(values[0], values[1], values[2], values[3]);
    }

    /**
     *
     */
    private const _spacing:Point = new Point();

    /**
     *
     * @return
     *
     */
    public function get spacing():String {
        return _spacing.x + "," + _spacing.y
    }

    /**
     *
     * @param value
     *
     */
    public function set spacing(value:String):void {
        var values:Array = value.split(",");
        _spacing.setTo(values[0], values[1]);
    }

    /**
     *
     */
    public var outline:Number = 0;

    /**
     *
     * @param xml
     *
     */
    public function fromXML(xml:XML):void {
        face = xml.@face;
        size = xml.@size;
        bold = xml.@bold;
        italic = xml.@italic;

        charSet = xml.@charSet;
        unicode = xml.@unicode;
        stretchHeight = xml.@stretchHeight;
        smooth = xml.@smooth;

        superSampling = xml.@superSampling;
        padding = xml.@padding;
        spacing = xml.@spacing;
        outline = xml.@outline;
    }

    /**
     *
     * @param xml
     *
     */
    public function toXML(xml:XML):void {
        xml.@face = face;
        xml.@size = size;
        xml.@bold = bold;
        xml.@italic = italic;

        xml.@charSet = charSet;
        xml.@unicode = unicode;
        xml.@stretchHeight = stretchHeight;
        xml.@smooth = smooth;

        xml.@superSampling = superSampling;
        xml.@padding = padding;
        xml.@spacing = spacing;
        xml.@outline = outline;
    }
}
}