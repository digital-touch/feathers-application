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
public class FontChar {
    /**
     *
     */
    public var id:Number = -1;
    /**
     *
     */
    public var x:Number = 0;
    /**
     *
     */
    public var y:Number = 0;

    /**
     *
     */
    public var width:Number = 0;
    /**
     *
     */
    public var height:Number = 0;
    /**
     *
     */
    public var xoffset:Number = 0;

    /**
     *
     */
    public var yoffset:Number = 0;
    /**
     *
     */
    public var xadvance:Number = 0;
    /**
     *
     */
    public var page:Number = -1;
    /**
     *
     */
    public var chnl:Number = 0;

    /**
     *
     * @param xml
     *
     */
    public function fromXML(xml:XML):void {
        id = xml.@id;
        x = xml.@x;
        y = xml.@y;

        width = xml.@width;
        height = xml.@height;
        xoffset = xml.@xoffset;

        yoffset = xml.@yoffset;
        xadvance = xml.@xadvance;
        page = xml.@page;
        chnl = xml.@chnl;
    }

    /**
     *
     * @param xml
     *
     */
    public function toXML(xml:XML):void {
        xml.@id = id;
        xml.@x = x;
        xml.@y = y;

        xml.@width = width;
        xml.@height = height;
        xml.@xoffset = xoffset;

        xml.@yoffset = yoffset;
        xml.@xadvance = xadvance;
        xml.@page = page;
        xml.@chnl = chnl;
    }
}

}
