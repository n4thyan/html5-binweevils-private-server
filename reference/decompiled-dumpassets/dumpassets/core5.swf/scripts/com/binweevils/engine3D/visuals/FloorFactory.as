package com.binweevils.engine3D.visuals
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   
   internal class FloorFactory implements VisualFactory
   {
      
      public function FloorFactory()
      {
         super();
      }
      
      public function createVisual(param1:DisplayObject, param2:XML, param3:Object = null) : Visual
      {
         var _loc4_:int = param1.width;
         var _loc5_:BitmapData = new BitmapData(_loc4_,_loc4_,true,0);
         _loc5_.draw(param1);
         var _loc6_:Bitmap = new Bitmap();
         _loc6_.bitmapData = _loc5_;
         return new Floor(_loc6_);
      }
   }
}

