package com.binweevils.petProfile
{
   import flash.display.MovieClip;
   
   public class ProgressBar
   {
      
      private var bar_mc:MovieClip;
      
      public function ProgressBar(param1:MovieClip)
      {
         super();
         this.bar_mc = param1;
         this.bar_mc.gotoAndStop(1);
      }
      
      public function setPosition(param1:Number, param2:Number) : void
      {
         this.bar_mc.x = param1;
         this.bar_mc.y = param2;
      }
      
      public function updateSkillLevel(param1:Number) : void
      {
         var _loc2_:int = param1 % 10 * 10;
         this.bar_mc.gotoAndStop(_loc2_);
      }
      
      public function updateStatLevel(param1:int) : void
      {
         this.bar_mc.gotoAndStop(param1);
      }
   }
}

