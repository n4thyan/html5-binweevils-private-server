package com.binweevils.engine3D.visuals
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   internal class BackdropFactory implements VisualFactory
   {
      
      public function BackdropFactory()
      {
         super();
      }
      
      public function createVisual(param1:DisplayObject, param2:XML, param3:Object = null) : Visual
      {
         var _loc4_:Number = Number(param2.attribute("x"));
         var _loc5_:Number = Number(param2.attribute("y"));
         var _loc6_:Number = Number(param2.attribute("z"));
         return new Backdrop(Sprite(param1),_loc4_,_loc5_,_loc6_);
      }
   }
}

