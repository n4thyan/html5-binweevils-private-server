package com.binweevils
{
   public class WeevilActionEnabler
   {
      
      private var actionTrigger:WeevilActionTrigger;
      
      private var levelRequired:int;
      
      private var powerLevel:int;
      
      public function WeevilActionEnabler(param1:WeevilActionTrigger, param2:int, param3:int)
      {
         super();
         this.actionTrigger = param1;
         this.levelRequired = param2;
         this.powerLevel = param3;
      }
      
      public function enableIfAuthorised(param1:int) : void
      {
         if(param1 >= this.levelRequired)
         {
            this.actionTrigger.vis = true;
            this.actionTrigger.setMaxPowerLevel(this.powerLevel);
         }
      }
   }
}

