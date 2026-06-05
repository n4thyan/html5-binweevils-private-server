package fl.controls.listClasses
{
   import fl.containers.UILoader;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.events.IOErrorEvent;
   
   public class ImageCell extends CellRenderer implements ICellRenderer
   {
      
      private static var defaultStyles:Object = {
         "imagePadding":1,
         "textOverlayAlpha":0.7
      };
      
      protected var loader:UILoader;
      
      protected var textOverlay:Shape;
      
      public function ImageCell()
      {
         super();
         loader = new UILoader();
         loader.addEventListener(IOErrorEvent.IO_ERROR,handleErrorEvent,false,0,true);
         loader.autoLoad = true;
         loader.scaleContent = true;
         addChild(loader);
      }
      
      public static function getStyleDefinition() : Object
      {
         return mergeStyles(defaultStyles,CellRenderer.getStyleDefinition());
      }
      
      public function get source() : Object
      {
         return loader.source;
      }
      
      public function set source(param1:Object) : void
      {
         loader.source = param1;
      }
      
      override public function set listData(param1:ListData) : void
      {
         var _loc2_:Object = null;
         _listData = param1;
         label = _listData.label;
         _loc2_ = (_listData as TileListData).source;
         if(source != _loc2_)
         {
            source = _loc2_;
         }
      }
      
      override protected function draw() : void
      {
         super.draw();
      }
      
      override protected function configUI() : void
      {
         var _loc1_:Graphics = null;
         super.configUI();
         textOverlay = new Shape();
         _loc1_ = textOverlay.graphics;
         _loc1_.beginFill(16777215);
         _loc1_.drawRect(0,0,100,100);
         _loc1_.endFill();
      }
      
      override public function get listData() : ListData
      {
         return _listData;
      }
      
      override protected function drawLayout() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         _loc1_ = getStyleValue("imagePadding") as Number;
         loader.move(_loc1_,_loc1_);
         _loc2_ = width - _loc1_ * 2;
         _loc3_ = height - _loc1_ * 2;
         if(loader.width != _loc2_ && loader.height != _loc3_)
         {
            loader.setSize(_loc2_,_loc3_);
         }
         loader.drawNow();
         if(_label == "" || _label == null)
         {
            if(contains(textField))
            {
               removeChild(textField);
            }
            if(contains(textOverlay))
            {
               removeChild(textOverlay);
            }
         }
         else
         {
            _loc4_ = getStyleValue("textPadding") as Number;
            textField.width = Math.min(width - _loc4_ * 2,textField.textWidth + 5);
            textField.height = textField.textHeight + 5;
            textField.x = Math.max(_loc4_,width / 2 - textField.width / 2);
            textField.y = height - textField.height - _loc4_;
            textOverlay.x = _loc1_;
            textOverlay.height = textField.height + _loc4_ * 2;
            textOverlay.y = height - textOverlay.height - _loc1_;
            textOverlay.width = width - _loc1_ * 2;
            textOverlay.alpha = getStyleValue("textOverlayAlpha") as Number;
            addChild(textOverlay);
            addChild(textField);
         }
         background.width = width;
         background.height = height;
      }
      
      protected function handleErrorEvent(param1:IOErrorEvent) : void
      {
         dispatchEvent(param1);
      }
   }
}

