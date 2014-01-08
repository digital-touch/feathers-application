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
/**
 *
 * @author developer
 *
 */
public class FontCommon {
    /**
     *
     */
    public var lineHeight:Number = 0;

    /**
     *
     */
    public var base:Number = 0;

    /**
     *
     */
    public var scaleW:Number = 0;

    /**
     *
     */
    public var scaleH:Number = 0;
    /**
     *
     */
    public var pages:Number = 0;

    /**
     *
     */
    public var packed:Number = 0;

    /**
     *
     */
    public var alphaChnl:Number = 0;

    /**
     *
     */
    public var redChnl:Number = 0;

    /**
     *
     */
    public var greenChnl:Number = 0;

    /**
     *
     */
    public var blueChnl:Number = 0;

    /**
     *
     * @param xml
     *
     */
    public function fromXML(xml:XML):void {
        lineHeight = xml.@lineHeight;
        base = xml.@base;
        scaleW = xml.@scaleW;

        scaleH = xml.@scaleH;
        pages = xml.@pages;
        packed = xml.@packed;

        alphaChnl = xml.@alphaChnl;
        redChnl = xml.@redChnl;
        greenChnl = xml.@greenChnl;
        blueChnl = xml.@blueChnl;
    }

    /**
     *
     * @param xml
     *
     */
    public function toXML(xml:XML):void {
        xml.@lineHeight = lineHeight;
        xml.@base = base;
        xml.@scaleW = scaleW;

        xml.@scaleH = scaleH;
        xml.@pages = pages;
        xml.@packed = packed;

        xml.@alphaChnl = alphaChnl;
        xml.@redChnl = redChnl;
        xml.@greenChnl = greenChnl;
        xml.@blueChnl = blueChnl;
    }
}
}