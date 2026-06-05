package com.binweevils.engine3D.visuals
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   internal class FixedAssetFactory implements VisualFactory
   {
      
      public function FixedAssetFactory()
      {
         super();
      }
      
      public function createVisual(param1:DisplayObject, param2:XML, param3:Object = null) : Visual
      {
         var _loc4_:MovieClip = MovieClip(param1);
         var _loc5_:Number = Number(param2.attribute("x"));
         var _loc6_:Number = Number(param2.attribute("y"));
         var _loc7_:Number = Number(param2.attribute("z"));
         return new FixedAsset(_loc4_,_loc5_,_loc6_,_loc7_);
      }
   }
}

