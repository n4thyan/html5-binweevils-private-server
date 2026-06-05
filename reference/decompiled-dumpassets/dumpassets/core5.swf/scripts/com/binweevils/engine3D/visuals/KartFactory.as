package com.binweevils.engine3D.visuals
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.*;
   
   internal class KartFactory implements VisualFactory
   {
      
      public function KartFactory()
      {
         super();
      }
      
      public function createVisual(param1:DisplayObject, param2:XML, param3:Object = null) : Visual
      {
         var _loc4_:int = int(param2.attribute("id"));
         var _loc5_:String = param2.attribute("gamePath");
         var _loc6_:String = param2.attribute("track");
         var _loc7_:int = int(param2.attribute("numPlayers"));
         var _loc8_:int = int(param2.attribute("playerID"));
         var _loc9_:String = param2.attribute("clr");
         var _loc10_:String = param2.attribute("arrivalPos");
         var _loc11_:String = param2.attribute("exitDest");
         var _loc12_:MovieClip = MovieClip(param1);
         var _loc13_:Number = Number(param2.attribute("scale"));
         var _loc14_:Number = Number(param2.attribute("ry"));
         var _loc15_:Number = Number(param2.attribute("x"));
         var _loc16_:Number = Number(param2.attribute("y"));
         var _loc17_:Number = Number(param2.attribute("z"));
         var _loc18_:PreRend3D = new PreRend3D(_loc12_,0,0,0,1,0,0,10,40,0,360,37,1,5);
         return new Kart(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc18_,_loc15_,_loc16_,_loc17_,_loc13_,_loc14_);
      }
   }
}

