package feathers.app.view.fonts {

import feathers.core.ITextRenderer;

/**
 *
 * @author developer
 *
 */
public interface ITextFormatMap {

    /**
     *
     * @param id
     * @param properties
     *
     */
    function addStyle(id:String, properties:Object = null):void;

    /**
     *
     * @param id
     * @return
     *
     */
    function getStyle(id:String):ITextFormat;

    /**
     *
     * @return
     *
     */
    function textRendererFactory():ITextRenderer;

}
}
