package com.binweevils.engine3D.visuals
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.*;
   
   internal class GameSlotFactory implements VisualFactory
   {
      
      public function GameSlotFactory()
      {
         super();
      }
      
      public function createVisual(param1:DisplayObject, param2:XML, param3:Object = null) : Visual
      {
         var _loc4_:String = param2.attribute("lbl");
         var _loc5_:String = param2.attribute("gamePath");
         var _loc6_:String = param2.attribute("slot");
         var _loc7_:String = param2.attribute("arrivalPoints");
         var _loc8_:String = param2.attribute("playerPositions");
         var _loc9_:MovieClip = MovieClip(param1);
         var _loc10_:Number = Number(param2.attribute("scale"));
         var _loc11_:Number = Number(param2.attribute("ry"));
         var _loc12_:Number = Number(param2.attribute("x"));
         var _loc13_:Number = Number(param2.attribute("y"));
         var _loc14_:Number = Number(param2.attribute("z"));
         var _loc15_:Number = Number(param2.attribute("rxMin"));
         var _loc16_:Number = Number(param2.attribute("rxMax"));
         var _loc17_:Number = Number(param2.attribute("ryMin"));
         var _loc18_:Number = Number(param2.attribute("ryMax"));
         var _loc19_:Number = Number(param2.attribute("framesY"));
         var _loc20_:Number = Number(param2.attribute("symAxes"));
         var _loc21_:Number = Number(param2.attribute("rIncr"));
         var _loc22_:PreRend3D = new PreRend3D(_loc9_,0,0,0,1,0,0,_loc15_,_loc16_,_loc17_,_loc18_,_loc19_,_loc20_,_loc21_);
         return new GameSlot3D(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc22_,_loc12_,_loc13_,_loc14_,_loc10_,_loc11_);
      }
   }
}

