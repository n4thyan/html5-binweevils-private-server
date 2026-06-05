package com.binweevils.engine3D.visuals
{
   import com.binweevils.overlayUIs.gardenItemControl.SeedGroupData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   internal class PlantFactory implements VisualFactory
   {
      
      public function PlantFactory()
      {
         super();
      }
      
      public function createVisual(param1:DisplayObject, param2:XML, param3:Object = null) : Visual
      {
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:* = false;
         var _loc17_:Plant = null;
         var _loc18_:SeedGroupData = null;
         var _loc4_:MovieClip = MovieClip(param1);
         if(param2 == null && param3 != null)
         {
            _loc18_ = SeedGroupData(param3);
            _loc5_ = _loc18_.id;
            _loc6_ = _loc18_.name;
            _loc7_ = _loc18_.category;
            _loc8_ = _loc18_.age;
            _loc9_ = _loc18_.growTime;
            _loc10_ = _loc18_.cycleTime;
            _loc11_ = _loc18_.mulch;
            _loc12_ = _loc18_.xp;
            _loc13_ = _loc18_.x;
            _loc14_ = _loc18_.z;
            _loc15_ = _loc18_.r;
            _loc16_ = false;
         }
         else
         {
            _loc5_ = int(param2.attribute("id"));
            _loc6_ = param2.attribute("name");
            _loc7_ = int(param2.attribute("cat"));
            _loc8_ = int(param2.attribute("age"));
            _loc9_ = int(param2.attribute("growTime"));
            _loc10_ = int(param2.attribute("cycleTime"));
            _loc11_ = int(param2.attribute("mulch"));
            _loc12_ = int(param2.attribute("xp"));
            _loc13_ = Number(param2.attribute("x"));
            _loc14_ = Number(param2.attribute("z"));
            _loc15_ = Number(param2.attribute("r"));
            _loc16_ = param2.attribute("watered") == "1";
         }
         if(_loc7_ == 1)
         {
            _loc17_ = new Plant_perishable(_loc5_,_loc4_,_loc6_,_loc13_,_loc14_,_loc15_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc16_);
         }
         else
         {
            _loc17_ = new Plant_nonperishable(_loc5_,_loc4_,_loc6_,_loc13_,_loc14_,_loc15_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_);
         }
         return _loc17_;
      }
   }
}

