package com.binweevils.engine3D.visuals
{
   import com.binweevils.Bin;
   import com.binweevils.engine3D.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Point;
   
   public class GameSlot3D extends Object3D implements GameSlot
   {
      
      private var spr:Sprite;
      
      private var hintText:String;
      
      private var _gamePath:String;
      
      private var _slot:String;
      
      private var arrivalPoints:Array;
      
      private var playerPositions1:Array;
      
      private var playerPositions2:Array;
      
      private var loc:Loc;
      
      private var bin:Bin;
      
      public function GameSlot3D(param1:String, param2:String, param3:String, param4:String, param5:String, param6:Element, param7:Number, param8:Number, param9:Number, param10:Number = 1, param11:Number = 0)
      {
         super(param6,param7,param8,param9,param10,param11);
         this.spr = Sprite(d_o);
         this._gamePath = param2;
         this._slot = param3;
         this.hintText = param1;
         var _loc12_:Array = param4.split(",");
         var _loc13_:Number = 6 - 12 * Math.random();
         var _loc14_:Number = 6 - 12 * Math.random();
         this.arrivalPoints = [new Point(Number(_loc12_[0]) + _loc13_,Number(_loc12_[1]) + _loc14_),new Point(Number(_loc12_[2]) + _loc13_,Number(_loc12_[3]) + _loc14_)];
         var _loc15_:Array = param5.split(",");
         this.playerPositions1 = [new Point(_loc15_[0],_loc15_[1]),new Point(_loc15_[2],_loc15_[3]),new Point(_loc15_[4],_loc15_[5])];
         this.playerPositions2 = [new Point(_loc15_[6],_loc15_[7]),new Point(_loc15_[8],_loc15_[9]),new Point(_loc15_[10],_loc15_[11])];
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
         container_spr.addEventListener(MouseEvent.CLICK,this.gotoIt);
         container_spr.addEventListener(MouseEvent.MOUSE_OVER,this.showHint);
         container_spr.addEventListener(MouseEvent.MOUSE_OUT,this.hideHint);
         container_spr.buttonMode = true;
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

