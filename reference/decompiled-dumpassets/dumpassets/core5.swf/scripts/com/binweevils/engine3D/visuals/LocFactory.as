package com.binweevils.engine3D.visuals
{
   import com.binweevils.utilities.URLhandler;
   import flash.display.Sprite;
   
   public class LocFactory
   {
      
      public static const STANDARD:int = 1;
      
      public static const FIXEDCAM:int = 2;
      
      public static const NEST:int = 3;
      
      public function LocFactory()
      {
         super();
      }
      
      public function createLoc(param1:XML, param2:Boolean = false) : Loc
      {
         var _loc25_:Loc = null;
         var _loc26_:XMLList = null;
         var _loc27_:XMLList = null;
         var _loc28_:XMLList = null;
         var _loc37_:XML = null;
         var _loc38_:* = undefined;
         var _loc39_:* = false;
         var _loc40_:Array = null;
         var _loc41_:int = 0;
         var _loc42_:int = 0;
         var _loc43_:int = 0;
         var _loc44_:int = 0;
         var _loc45_:int = 0;
         var _loc46_:Array = null;
         var _loc47_:String = null;
         var _loc3_:int = int(param1.attribute("id"));
         if(param2)
         {
            _loc3_ = -_loc3_;
         }
         var _loc4_:String = param1.attribute("name");
         var _loc5_:int = int(param1.attribute("type"));
         var _loc6_:Number = Number(param1.attribute("weevilScale"));
         var _loc7_:Sprite = new Sprite();
         var _loc8_:* = {};
         var _loc9_:Array = param1.attribute("camPos").split(",");
         var _loc10_:Array = param1.attribute("camAim").split(",");
         _loc8_.camX = _loc9_[0];
         _loc8_.camY = _loc9_[1];
         _loc8_.camZ = _loc9_[2];
         _loc8_.aimX = _loc10_[0];
         _loc8_.aimY = _loc10_[1];
         _loc8_.aimZ = _loc10_[2];
         var _loc11_:Array = param1.attribute("entryPos").split(",");
         var _loc12_:Number = Number(param1.attribute("entryDir"));
         var _loc13_:String = param1.attribute("boundType");
         var _loc14_:Array = param1.attribute("boundary").split(",");
         var _loc15_:String = param1.attribute("inventory");
         if(_loc15_ == "")
         {
            _loc15_ = null;
         }
         else
         {
            _loc15_ = URLhandler.getPath(_loc15_);
         }
         var _loc16_:String = param1.attribute("playList");
         var _loc17_:Boolean = param1.attribute("clickAnywhere") == "yes" ? true : false;
         var _loc18_:Boolean = param1.attribute("slippery") == "yes" ? true : false;
         var _loc19_:Boolean = param1.attribute("upSideDown") == "yes" ? true : false;
         var _loc20_:Boolean = param1.attribute("specialColours") == "yes" ? true : false;
         var _loc21_:Boolean = param1.attribute("maintainY") == "yes" ? true : false;
         var _loc22_:Boolean = param1.attribute("roomEvents") == "yes" ? true : false;
         var _loc23_:int = int(param1.attribute("timerID"));
         var _loc24_:Boolean = param1.attribute("noZoom") == "yes" ? true : false;
         switch(_loc5_)
         {
            case STANDARD:
               _loc39_ = param1.attribute("camBoundType") == "rad";
               _loc40_ = param1.attribute("camBounds").split(",");
               if(_loc39_)
               {
                  _loc8_.radBound = true;
                  _loc8_.x0 = _loc40_[0];
                  _loc8_.z0 = _loc40_[1];
                  _loc8_.rad = _loc40_[2];
                  _loc8_.yMin = _loc40_[3];
                  _loc8_.yMax = _loc40_[4];
                  _loc8_.xMin = 0;
                  _loc8_.zMin = 0;
                  _loc8_.xMax = 0;
                  _loc8_.zMax = 0;
               }
               else
               {
                  _loc8_.radBound = false;
                  _loc8_.xMin = _loc40_[0];
                  _loc8_.yMin = _loc40_[1];
                  _loc8_.zMin = _loc40_[2];
                  _loc8_.xMax = _loc40_[3];
                  _loc8_.yMax = _loc40_[4];
                  _loc8_.zMax = _loc40_[5];
                  _loc8_.x0 = 0;
                  _loc8_.z0 = 0;
                  _loc8_.rad = 0;
               }
               _loc41_ = int(param1.attribute("xWall"));
               _loc42_ = int(param1.attribute("zWall"));
               _loc43_ = int(param1.attribute("camMode"));
               _loc25_ = new LocStandard(_loc7_,_loc3_,_loc4_,_loc13_,_loc14_,_loc8_,_loc43_,_loc6_,_loc11_[0],_loc11_[1],_loc12_,_loc22_,_loc15_,_loc41_,_loc42_);
               break;
            case FIXEDCAM:
               _loc25_ = new LocFixedCam(_loc7_,_loc3_,_loc4_,_loc13_,_loc14_,_loc8_,_loc6_,_loc11_[0],_loc11_[1],_loc12_,_loc22_,_loc15_);
               _loc26_ = param1.descendants("object");
               LocFixedCam(_loc25_).setObjects(_loc26_);
               _loc27_ = param1.descendants("target");
               LocFixedCam(_loc25_).setTargets(_loc27_);
               _loc28_ = param1.descendants("character");
               LocFixedCam(_loc25_).setCharacters(_loc28_);
               break;
            case NEST:
               _loc44_ = int(param1.attribute("cat"));
               _loc45_ = int(param1.attribute("instanceID"));
               _loc46_ = param1.attribute("keepFree").split(",");
               _loc47_ = param1.attribute("colour");
               if(_loc13_ == null || _loc13_ == "")
               {
                  _loc13_ = "rect";
               }
               if(_loc44_ == 5)
               {
                  _loc25_ = new LocGarden(_loc7_,_loc3_,_loc45_,_loc4_,_loc13_,_loc14_,_loc8_,_loc6_,_loc11_[0],_loc11_[1],_loc46_,_loc44_,_loc47_);
               }
               else
               {
                  _loc25_ = new LocNest(_loc7_,_loc3_,_loc45_,_loc4_,_loc13_,_loc14_,_loc8_,_loc6_,_loc11_[0],_loc11_[1],_loc46_,_loc44_,_loc47_);
               }
               _loc26_ = param1.descendants("object");
               LocNest(_loc25_).setObjects(_loc26_);
         }
         _loc25_.clickAnywhere = _loc17_;
         _loc25_.slippery = _loc18_;
         _loc25_.maintainY = _loc21_;
         _loc25_.timerID = _loc23_;
         _loc25_.setPlayList(_loc16_);
         _loc25_.noZoom = _loc24_;
         _loc25_.upSideDown = _loc19_;
         _loc25_.specialColours = _loc20_;
         if(_loc19_)
         {
            _loc7_.rotation = -180;
            _loc7_.y = 490;
            _loc7_.x = 825;
         }
         var _loc29_:XMLList = param1.descendants("GUI");
         _loc25_.setGUI(_loc29_);
         var _loc30_:XMLList = param1.descendants("door");
         _loc25_.setDoorList(_loc30_);
         var _loc31_:XMLList = param1.descendants("cta");
         _loc25_.setCtaList(_loc31_);
         var _loc32_:XMLList = param1.descendants("timeTrial");
         _loc25_.setTimeTrialList(_loc32_);
         var _loc33_:XMLList = param1.descendants("interactive");
         _loc25_.setInteractiveList(_loc33_);
         var _loc34_:XMLList = param1.descendants("anim");
         _loc25_.setAnimList(_loc34_);
         var _loc35_:XMLList = param1.descendants("noGoArea");
         _loc25_.setNoGoList(_loc35_);
         var _loc36_:XMLList = param1.descendants("walkMask");
         _loc25_.setWalkMaskList(_loc36_);
         for(_loc38_ in param1.children())
         {
            _loc37_ = param1.children()[_loc38_];
            if(_loc37_.name() != "door" && _loc37_.name() != "cta" && _loc37_.name() != "interactive" && _loc37_.name() != "noGoArea" && _loc37_.name() != "walkMask" && _loc37_.name() != "object" && _loc37_.name() != "anim" && _loc37_.name() != "timeTrial" && _loc37_.name() != "target" && _loc37_.name() != "character" && _loc37_.name() != "GUI")
            {
               _loc25_.addAssetInfo(_loc37_);
            }
         }
         return _loc25_;
      }
   }
}

