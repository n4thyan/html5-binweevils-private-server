package com.binweevils.engine3D.visuals
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   internal class SpinnerFactory implements VisualFactory
   {
      
      public function SpinnerFactory()
      {
         super();
      }
      
      public function createVisual(param1:DisplayObject, param2:XML, param3:Object = null) : Visual
      {
         var _loc4_:MovieClip = MovieClip(param1);
         var _loc5_:Number = Number(param2.attribute("scale"));
         var _loc6_:Number = Number(param2.attribute("x"));
         var _loc7_:Number = Number(param2.attribute("y"));
         var _loc8_:Number = Number(param2.attribute("z"));
         var _loc9_:PreRend3D = new PreRend3D(_loc4_,0,0,0,1,0,0,2,28,0,1,1,0,1.5,_loc6_ + "," + _loc7_ + "," + _loc8_);
         return new Spinner(_loc9_,_loc6_,_loc7_,_loc8_,_loc5_);
      }
   }
}

