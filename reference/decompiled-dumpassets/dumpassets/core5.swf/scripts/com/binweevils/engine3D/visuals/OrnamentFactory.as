package com.binweevils.engine3D.visuals
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   internal class OrnamentFactory implements VisualFactory
   {
      
      public function OrnamentFactory()
      {
         super();
      }
      
      public function createVisual(param1:DisplayObject, param2:XML, param3:Object = null) : Visual
      {
         var _loc4_:int = int(param3.id);
         var _loc5_:int = int(param3.fID);
         var _loc6_:int = int(param3.spotID);
         var _loc7_:MovieClip = MovieClip(param1);
         var _loc8_:Number = Number(param2.attribute("scale"));
         var _loc9_:Number = Number(param2.attribute("ry"));
         var _loc10_:Number = Number(param2.attribute("x"));
         var _loc11_:Number = Number(param2.attribute("y"));
         var _loc12_:Number = Number(param2.attribute("z"));
         var _loc13_:Number = Number(param2.attribute("rxMin"));
         var _loc14_:Number = Number(param2.attribute("rxMax"));
         var _loc15_:Number = Number(param2.attribute("ryMin"));
         var _loc16_:Number = Number(param2.attribute("ryMax"));
         var _loc17_:Number = Number(param2.attribute("framesY"));
         var _loc18_:Number = Number(param2.attribute("symAxes"));
         var _loc19_:Number = Number(param2.attribute("rIncr"));
         if(_loc19_ == 0)
         {
            _loc19_ = 5;
         }
         var _loc20_:PreRend3D = new PreRend3D(_loc7_,0,0,0,1,0,0,_loc13_,_loc14_,_loc15_,_loc16_,_loc17_,_loc18_,_loc19_);
         var _loc21_:Ornament = new Ornament(_loc4_,_loc5_,_loc6_,_loc20_,_loc10_,_loc11_,_loc12_,_loc8_,_loc9_);
         if(param2.attribute("clickable") == "yes")
         {
            _loc21_.setClickHandler(_loc7_.clicked);
         }
         return _loc21_;
      }
   }
}

