package com.binweevils.engine3D.visuals
{
   import com.binweevils.Bin;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class Teleporter extends Object3D
   {
      
      private var _destLocID:int;
      
      private var _departX:*;
      
      private var _departZ:int;
      
      private var _destX:*;
      
      private var _destY:*;
      
      private var _destZ:int;
      
      private var loc:Loc;
      
      private var bin:Bin;
      
      private var _active:Boolean;
      
      public function Teleporter(param1:Element, param2:Number, param3:Number, param4:Number, param5:Number, param6:int, param7:int, param8:int, param9:int)
      {
         super(param1,param2,param3,param4,param5,0,"");
         this._departX = param2;
         this._departZ = param4;
         this._destX = param6;
         this._destY = param7;
         this._destZ = param8;
         this._destLocID = param9;
      }
      
      public function get departX() : Number
      {
         return this._departX;
      }
      
      public function get departZ() : Number
      {
         return this._departZ;
      }
      
      public function get destX() : Number
      {
         return this._destX;
      }
      
      public function get destY() : Number
      {
         return this._destY;
      }
      
      public function get destZ() : Number
      {
         return this._destZ;
      }
      
      public function get destLocID() : int
      {
         return this._destLocID;
      }
      
      public function setLoc(param1:Loc) : void
      {
         this.loc = param1;
         this.bin = Bin.get_instance();
         Sprite(d_o).addEventListener(MouseEvent.CLICK,this.gotoIt);
         this.active = true;
      }
      
      public function set active(param1:Boolean) : void
      {
         this._active = param1;
         Sprite(d_o).buttonMode = param1;
         d_o.alpha = this._active ? 1 : 0.15;
      }
      
      private function gotoIt(param1:MouseEvent) : void
      {
         if(Bin.controlsEnabled && this._active)
         {
            this.loc.gotoTeleporter(this);
         }
      }
      
      public function inRange(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Number = param1 - this._departX;
         var _loc4_:Number = param2 - this._departZ;
         var _loc5_:Number = Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
         return _loc5_ < 10 ? true : false;
      }
   }
}

