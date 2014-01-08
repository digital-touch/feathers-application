package feathers.app.view.fonts {
import feathers.core.ITextEditor;
import feathers.core.ITextRenderer;

import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;

public class AbstractTextFormatMap implements ITextFormatMap {
    public var styles:Dictionary = new Dictionary();

    public function addStyle(id:String, properties:Object = null):void {
        styles[id] = createTextFormat(properties);
    }

    protected function createTextFormat(properties:Object):ITextFormat {
        throw new IllegalOperationError("FontManager.createTextFormat(properties: Object):ITextFormat is abstract and must be overriden");
    }

    public function getStyle(id:String):ITextFormat {
        return styles[id];
    }

    public function textRendererFactory():ITextRenderer {
        throw new IllegalOperationError("FontManager.textRendererFactory():ITextRenderer is abstract and must be overriden");
    }

    public function textEditorFactory():ITextEditor {
        throw new IllegalOperationError("FontManager.textEditorFactory():ITextEditor is abstract and must be overriden");
    }
}
}