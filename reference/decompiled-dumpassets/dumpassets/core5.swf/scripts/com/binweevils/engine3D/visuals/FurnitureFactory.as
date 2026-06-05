package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Vector3D;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   internal class FurnitureFactory implements VisualFactory
   {
      
      public function FurnitureFactory()
      {
         super();
      }
      
      public function createVisual(param1:DisplayObject, param2:XML, param3:Object = null) : Visual
      {
         var _loc5_:int = 0;
         var _loc13_:XML = null;
         var _loc14_:int = 0;
         var _loc15_:Array = null;
         var _loc16_:Vector3D = null;
         var _loc17_:Number = NaN;
         var _loc20_:Array = null;
         var _loc21_:* = undefined;
         var _loc4_:MovieClip = MovieClip(param1);
         var _loc6_:int = int(param3.id);
         var _loc7_:String = param2.attribute("name");
         var _loc8_:Boolean = param2.attribute("bg") == "yes" ? true : false;
         var _loc9_:Number = Number(param3.crntPos);
         var _loc10_:String = param2.attribute("boundType");
         var _loc11_:Number = 0;
         switch(_loc10_)
         {
            case "0":
               _loc5_ = 0;
               break;
            case "rect":
               _loc5_ = 1;
               break;
            case "radial":
               _loc5_ = 2;
               _loc11_ = Number(param2.attribute("boundRadius"));
         }
         var _loc12_:Furniture = new Furniture(_loc6_,_loc7_,_loc4_,_loc9_,_loc8_);
         var _loc18_:Number = Number(param2.attribute("h"));
         _loc12_.h = _loc18_;
         var _loc19_:int = int(param2.attribute("numSpots"));
         _loc12_.numSurfaceSpots = _loc19_;
         if(param2.attribute("clickable") == "yes")
         {
            _loc12_.setClickHandler(_loc4_.clicked);
            _loc4_.setFurniture(_loc12_);
         }
         if(param2.attribute("setID") == "yes")
         {
            _loc4_.setItemID(_loc6_);
         }
         for(_loc21_ in param2.children())
         {
            if(param2.children()[_loc21_].name() == "pos")
            {
               _loc13_ = param2.children()[_loc21_];
               _loc14_ = int(_loc13_.attribute("frame"));
               _loc15_ = _loc13_.attribute("bounds").split(",");
               _loc16_ = new Vector3D(_loc13_.attribute("x"),_loc13_.attribute("y"),_loc13_.attribute("z"));
               _loc17_ = Number(_loc13_.attribute("ry"));
               _loc20_ = _loc13_.attribute("gridSqs").split(",");
               _loc12_.addPos(_loc14_,_loc15_,_loc16_,_loc17_,_loc20_,_loc5_,_loc11_);
            }
         }
         _loc12_.setPos(_loc9_);
         return _loc12_;
      }
   }
}

