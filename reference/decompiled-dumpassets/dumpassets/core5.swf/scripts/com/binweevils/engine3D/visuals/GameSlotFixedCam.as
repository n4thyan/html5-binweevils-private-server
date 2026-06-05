package com.binweevils.engine3D.visuals
{
   import com.binweevils.Bin;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Point;
   
   public class GameSlotFixedCam implements GameSlot
   {
      
      private var mc:MovieClip;
      
      private var spr:Sprite;
      
      private var hintText:String;
      
      private var _gamePath:String;
      
      private var _slot:String;
      
      private var arrivalPoints:Array;
      
      private var playerPositions1:Array;
      
      private var playerPositions2:Array;
      
      private var loc:Loc;
      
      private var bin:Bin;
      
      public function GameSlotFixedCam(param1:String, param2:String, param3:String, param4:String, param5:String, param6:Sprite)
      {
         super();
         this.spr = param6;
         this._gamePath = param2;
         this._slot = param3;
         this.hintText = param1;
         var _loc7_:Array = param4.split(",");
         var _loc8_:Number = 6 - 12 * Math.random();
         var _loc9_:Number = 6 - 12 * Math.random();
         this.arrivalPoints = [new Point(Number(_loc7_[0]) + _loc8_,Number(_loc7_[1]) + _loc9_),new Point(Number(_loc7_[2]) + _loc8_,Number(_loc7_[3]) + _loc9_)];
         var _loc10_:Array = param5.split(",");
         this.playerPositions1 = [new Point(_loc10_[0],_loc10_[1]),new Point(_loc10_[2],_loc10_[3]),new Point(_loc10_[4],_loc10_[5])];
         this.playerPositions2 = [new Point(_loc10_[6],_loc10_[7]),new Point(_loc10_[8],_loc10_[9]),new Point(_loc10_[10],_loc10_[11])];
      }
      
      public function get gamePath() : String
      {
         return this._gamePath;
      }
      
      public function get slot() : String
      {
         return this._slot;
      }
      
      public function setLoc(param1:Loc) : void
      {
         this.loc = param1;
         this.bin = Bin.get_instance();
         this.spr.addEventListener(MouseEvent.CLICK,this.gotoIt);
         this.spr.addEventListener(MouseEvent.MOUSE_OVER,this.showHint);
         this.spr.addEventListener(MouseEvent.MOUSE_OUT,this.hideHint);
         this.spr.buttonMode = true;
      }
      
      private function showHint(param1:MouseEvent) : void
      {
         this.bin.showHint(this.hintText,param1.stageX,param1.stageY - 40);
      }
      
      public function hideHint(param1:MouseEvent) : void
      {
         this.bin.hideHint();
      }
      
      public function getNearestArrivalPoint(param1:Number, param2:Number) : Point
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:Point = null;
         var _loc6_:* = undefined;
         var _loc7_:Number = 999999;
         _loc3_ = new Point(param1,param2);
         for each(_loc4_ in this.arrivalPoints)
         {
            _loc6_ = Point.distance(_loc3_,_loc4_);
            if(_loc6_ < _loc7_)
            {
               _loc7_ = _loc6_;
               _loc5_ = _loc4_;
            }
         }
         return _loc5_;
      }
      
      private function gotoIt(param1:MouseEvent) : void
      {
         this.loc.gotoGameSlot(this);
      }
      
      public function getPlayerPositionData(param1:int) : Array
      {
         return this["playerPositions" + param1];
      }
   }
}

