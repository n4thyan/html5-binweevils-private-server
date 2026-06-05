package com.binweevils.petProfile
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class PetStatsUI
   {
      
      private var UImc:MovieClip;
      
      private var foodBar:ProgressBar;
      
      private var vitalityBar:ProgressBar;
      
      private var fitnessBar:ProgressBar;
      
      private var enduranceBar:ProgressBar;
      
      public function PetStatsUI(param1:MovieClip)
      {
         super();
         this.UImc = param1;
         this.foodBar = new ProgressBar(this.UImc.food_mc.bar_mc);
         this.vitalityBar = new ProgressBar(this.UImc.vitality_mc.bar_mc);
         this.fitnessBar = new ProgressBar(this.UImc.fitness_mc.bar_mc);
         this.enduranceBar = new ProgressBar(this.UImc.endurance_mc.bar_mc);
         this.setListener(this.UImc.food_mc);
         this.setListener(this.UImc.vitality_mc);
         this.setListener(this.UImc.fitness_mc);
         this.setListener(this.UImc.endurance_mc);
      }
      
      private function setListener(param1:MovieClip) : void
      {
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         param1.buttonMode = true;
         param1.stop();
      }
      
      private function outHandler(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.gotoAndStop(1);
      }
      
      private function overHandler(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.gotoAndStop(2);
      }
      
      public function updateStats(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this.foodBar.updateStatLevel(param1);
         this.vitalityBar.updateStatLevel(param2);
         this.fitnessBar.updateStatLevel(param3);
         this.enduranceBar.updateStatLevel(param4);
      }
   }
}

