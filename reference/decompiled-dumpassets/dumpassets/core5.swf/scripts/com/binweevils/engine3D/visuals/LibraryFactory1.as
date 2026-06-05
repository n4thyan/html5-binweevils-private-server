package com.binweevils.engine3D.visuals
{
   import assetsLibrary.library1.*;
   import com.binweevils.engine3D.Vector3D;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   internal class LibraryFactory1 implements VisualFactory
   {
      
      public function LibraryFactory1()
      {
         super();
      }
      
      public function set_library() : void
      {
      }
      
      public function createVisual(param1:DisplayObject, param2:XML, param3:Object = null) : Visual
      {
         var _loc5_:Visual = null;
         var _loc6_:MovieClip = null;
         var _loc7_:MovieClip = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Vector3D = null;
         var _loc16_:Vector3D = null;
         var _loc17_:Array = null;
         var _loc4_:String = param2.name();
         switch(_loc4_)
         {
            case "pin":
               _loc6_ = new PinHead_mc();
               _loc7_ = new PinShaft_mc();
               _loc8_ = Number(param2.attribute("x1"));
               _loc9_ = Number(param2.attribute("y1"));
               _loc10_ = Number(param2.attribute("z1"));
               _loc11_ = Number(param2.attribute("x2"));
               _loc12_ = Number(param2.attribute("y2"));
               _loc13_ = Number(param2.attribute("z2"));
               _loc14_ = Number(param2.attribute("scale"));
               _loc15_ = new Vector3D(_loc8_,_loc9_,_loc10_);
               _loc16_ = new Vector3D(_loc11_,_loc12_,_loc13_);
               _loc5_ = new Pin(_loc6_,_loc7_,_loc15_,_loc16_,_loc14_);
               break;
            case "lightning":
               _loc17_ = [new Thunder(),new Thunder1(),new Thunder2(),new Thunder3()];
               _loc5_ = new Lightning(new Lightning1_mc(),new Lightning2_mc(),new Flash_mc(),_loc17_);
         }
         return _loc5_;
      }
   }
}

