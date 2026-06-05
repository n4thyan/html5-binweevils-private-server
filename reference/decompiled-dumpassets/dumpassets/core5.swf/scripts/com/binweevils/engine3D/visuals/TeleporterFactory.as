package com.binweevils.engine3D.visuals
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   internal class TeleporterFactory implements VisualFactory
   {
      
      public function TeleporterFactory()
      {
         super();
      }
      
      public function createVisual(param1:DisplayObject, param2:XML, param3:Object = null) : Visual
      {
         var _loc13_:Array = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc4_:MovieClip = MovieClip(param1);
         var _loc5_:Number = Number(param2.attribute("scale"));
         var _loc6_:Number = Number(param2.attribute("x"));
         var _loc7_:Number = Number(param2.attribute("y"));
         var _loc8_:Number = Number(param2.attribute("z"));
         var _loc9_:String = param2.attribute("dest");
         if(_loc9_ != null && _loc9_ != "")
         {
            _loc13_ = _loc9_.split(",");
            _loc14_ = int(_loc13_[0]);
            _loc15_ = int(_loc13_[1]);
            _loc16_ = int(_loc13_[2]);
         }
         var _loc10_:int = int(param2.attribute("destLocID"));
         var _loc11_:PreRend3D = new PreRend3D(_loc4_,0,0,0,1,0,0,2,50,0,1,1,0,1.5,_loc6_ + "," + _loc7_ + "," + _loc8_);
         return new Teleporter(_loc11_,_loc6_,_loc7_,_loc8_,_loc5_,_loc14_,_loc15_,_loc16_,_loc10_);
      }
   }
}

