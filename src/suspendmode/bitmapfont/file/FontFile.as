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
public class FontFile {
    /**
     *
     */
    public var info:FontInfo = new FontInfo();

    /**
     *
     */
    public var common:FontCommon = new FontCommon();

    /**
     *
     */
    public var pages:Vector.<FontPage> = new Vector.<FontPage>();

    /**
     *
     */
    public var chars:Vector.<FontChar> = new Vector.<FontChar>();

    /**
     *
     */
    public var kernings:Vector.<FontKerning> = new Vector.<FontKerning>();

    /**
     *
     * @param xml
     *
     */
    public function fromXML(xml:XML):void {
        info.fromXML(xml.info);
        common.fromXML(xml.common);

        pages.length = 0;
        for each (var pageXML:XML in xml.pages) {
            var page:FontPage = new FontPage();
            page.fromXML(pageXML);
            pages.push(page);
        }

        chars.length = 0;
        for each (var charXML:XML in xml.chars) {
            var char:FontChar = new FontChar();
            char.fromXML(charXML);
            chars.push(char);
        }
        kernings.length = 0;
        for each (var kerningXML:XML in xml.kernings) {
            var kerning:FontKerning = new FontKerning();
            kerning.fromXML(kerningXML);
            kernings.push(kerning);
        }
    }

    /**
     *
     * @return
     *
     */
    public function toXML():XML {
        var xml:XML = <font/>;
        xml.info = <info/>;
        info.toXML(XML(xml.info));
        xml.common = <common/>;
        common.toXML(XML(xml.common));
        xml.pages = <pages/>;
        for each (var page:FontPage in pages) {
            var pageXML:XML = <page/>;
            page.toXML(pageXML);
            xml.pages.appendChild(pageXML);
        }
        xml.chars = <chars/>;
        for each (var char:FontChar in chars) {
            var charXML:XML = <char/>;
            char.toXML(charXML);
            xml.chars.appendChild(charXML);
        }
        xml.kernings = <kernings/>;
        for each (var kerning:FontKerning in kernings) {
            var kerningXML:XML = <kerning/>;
            kerning.toXML(kerningXML);
            xml.kernings.appendChild(kerningXML);

        }

        return xml;
    }

    /**
     *
     * @return
     *
     */
    public function toString():String {
        return toXML().toXMLString();
    }
}
}
