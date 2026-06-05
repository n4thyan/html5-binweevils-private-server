package com.binweevils.engine3D.visuals
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   internal class GardenFenceFactory implements VisualFactory
   {
      
      public function GardenFenceFactory()
      {
         super();
      }
      
      public function createVisual(param1:DisplayObject, param2:XML, param3:Object = null) : Visual
      {
         var _loc4_:int = 0;
         if(param2 == null)
         {
            _loc4_ = int(param3.id);
         }
         else
         {
            _loc4_ = int(param2.attribute("id"));
         }
         var _loc5_:Sprite = Sprite(param1);
         return new GardenFence(_loc4_,_loc5_);
      }
   }
}

