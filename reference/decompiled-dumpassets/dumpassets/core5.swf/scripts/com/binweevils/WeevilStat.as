package com.binweevils
{
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class WeevilStat
   {
      
      private var statBar_mc:MovieClip;
      
      private var _level:Number;
      
      public var decayRate:Number;
      
      private var alertFunction:Function;
      
      public function WeevilStat(param1:MovieClip, param2:Number, param3:Function = null)
      {
         super();
         this.statBar_mc = param1;
         this.decayRate = param2;
         this.alertFunction = param3;
      }
      
      public function set level(param1:*) : void
      {
         this._level = param1;
         this.keepInRange();
         this.updateBar();
      }
      
      public function get level() : int
      {
         return Math.round(this._level);
      }
      
      public function decay() : void
      {
         this.level = this._level - this.decayRate;
      }
      
      public function adjust(param1:Number) : void
      {
         this.level = this._level + param1;
      }
      
      public function keepInRange() : void
      {
         if(this._level < 15)
         {
            this._level = 15;
         }
         if(this._level > 100)
         {
            this._level = 100;
         }
      }
      
      public function getDeficit() : Number
      {
         var _loc1_:Number = 0;
         if(this._level < 35)
         {
            _loc1_ = 1.5 * (35 - this._level);
         }
         return _loc1_;
      }
      
      private function updateBar() : void
      {
         this.statBar_mc.bar_mc.scaleX = 0.01 * this._level;
         if(this._level < 35)
         {
            this.statBar_mc.bar_mc.gotoAndStop(2);
         }
         else
         {
            this.statBar_mc.bar_mc.gotoAndStop(1);
         }
         if(this.alertFunction != null)
         {
            this.alertFunction(this.level);
         }
      }
   }
}

