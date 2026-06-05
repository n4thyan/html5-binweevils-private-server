package com.binweevils.engine3D.visuals
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   internal class GardenItemFactory implements VisualFactory
   {
      
      public function GardenItemFactory()
      {
         super();
      }
      
      public function createVisual(param1:DisplayObject, param2:XML, param3:Object = null) : Visual
      {
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc4_:MovieClip = MovieClip(param1);
         if(param2 == null)
         {
            _loc5_ = int(param3.id);
            _loc6_ = Number(param3.x);
            _loc7_ = Number(param3.z);
            _loc8_ = Number(param3.r);
         }
         else
         {
            _loc5_ = int(param2.attribute("id"));
            _loc6_ = Number(param2.attribute("x"));
            _loc7_ = Number(param2.attribute("z"));
            _loc8_ = Number(param2.attribute("r"));
         }
         return new GardenItem(_loc5_,_loc4_,_loc6_,_loc7_,_loc8_);
      }
   }
}

