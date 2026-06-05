package com.binweevils.engine3D.visuals
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   internal class BgFactory implements VisualFactory
   {
      
      public function BgFactory()
      {
         super();
      }
      
      public function createVisual(param1:DisplayObject, param2:XML, param3:Object = null) : Visual
      {
         var _loc4_:Sprite = Sprite(param1);
         return new Bg(_loc4_);
      }
   }
}

