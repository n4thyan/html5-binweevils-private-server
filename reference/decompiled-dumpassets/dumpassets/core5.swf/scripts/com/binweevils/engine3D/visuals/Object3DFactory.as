package com.binweevils.engine3D.visuals
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class Object3DFactory implements VisualFactory
   {
      
      public function Object3DFactory()
      {
         super();
      }
      
      public function createVisual(param1:DisplayObject, param2:XML, param3:Object = null) : Visual
      {
         var _loc4_:MovieClip = MovieClip(param1);
         var _loc5_:Number = Number(param2.attribute("scale"));
         var _loc6_:int = int(param2.attribute("rx"));
         var _loc7_:Number = Number(param2.attribute("ry"));
         var _loc8_:Number = Number(param2.attribute("x"));
         var _loc9_:Number = Number(param2.attribute("y"));
         var _loc10_:Number = Number(param2.attribute("z"));
         var _loc11_:Number = Number(param2.attribute("rxMin"));
         var _loc12_:Number = Number(param2.attribute("rxMax"));
         var _loc13_:Number = Number(param2.attribute("ryMin"));
         var _loc14_:Number = Number(param2.attribute("ryMax"));
         var _loc15_:Number = Number(param2.attribute("framesY"));
         var _loc16_:Number = Number(param2.attribute("symAxes"));
         var _loc17_:Number = Number(param2.attribute("rIncr"));
         var _loc18_:Boolean = param2.attribute("bg") == "true" ? true : false;
         var _loc19_:PreRend3D = new PreRend3D(_loc4_,0,0,0,1,_loc6_,_loc7_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_,_loc16_,_loc17_,_loc8_ + "," + _loc9_ + "," + _loc10_);
         var _loc20_:String = param2.attribute("clr");
         var _loc21_:Boolean = param2.attribute("blueFade") == "yes" ? true : false;
         var _loc22_:Object3D = new Object3D(_loc19_,_loc8_,_loc9_,_loc10_,_loc5_,_loc7_,_loc20_,_loc21_);
         _loc22_.bg = _loc18_;
         return _loc22_;
      }
   }
}

