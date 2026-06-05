package com.binweevils.engine3D.visuals.creatures
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class Brain_NPC
   {
      
      private var npc:NPC;
      
      private var actTimer:Timer;
      
      public function Brain_NPC(param1:NPC)
      {
         super();
         this.npc = param1;
      }
      
      protected function act(param1:TimerEvent) : void
      {
         var _loc2_:Number = -100 + 100 * Math.random();
         var _loc3_:Number = 180 * Math.random();
         var _loc4_:Number = 45;
         this.npc.doAction(0,{
            "x":_loc2_,
            "z":_loc3_,
            "r":_loc4_
         });
      }
   }
}

