package com.binweevils.engine3D.visuals
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   internal class BgItemFactory implements VisualFactory
   {
      
      public function BgItemFactory()
      {
         super();
      }
      
      public function createVisual(param1:DisplayObject, param2:XML, param3:Object = null) : Visual
      {
         var _loc4_:int = int(param3.id);
         var _loc5_:Sprite = Sprite(param1);
         return new BgItem(_loc4_,_loc5_);
      }
   }
}

