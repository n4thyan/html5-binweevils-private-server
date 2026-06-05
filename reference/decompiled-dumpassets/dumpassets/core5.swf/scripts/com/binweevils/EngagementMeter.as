package com.binweevils
{
   import com.binweevils.DBaccess.PHP2call;
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class EngagementMeter
   {
      
      private var mainStage:Stage;
      
      private var userIsEngaged:Boolean = false;
      
      private var bin:Object;
      
      private var ssclient:SSclient;
      
      private var timer:Timer;
      
      public function EngagementMeter(param1:Stage, param2:SSclient)
      {
         super();
         this.bin = Bin_extInterface.bin;
         this.ssclient = param2;
         this.mainStage = param1;
         this.mainStage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         this.mainStage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyBoardEventHandler);
         var _loc3_:Number = 90000;
         this.timer = new Timer(_loc3_);
         this.timer.addEventListener(TimerEvent.TIMER,this.timerEventHandler);
      }
      
      public function init() : void
      {
         this.timer.start();
      }
      
      private function timerEventHandler(param1:TimerEvent) : void
      {
         var _loc2_:PHP2call = null;
         if(this.userIsEngaged)
         {
            _loc2_ = new PHP2call("login/activity");
            _loc2_.fireAndForget([],[]);
         }
         this.userIsEngaged = false;
         this.keepConnectionActive();
      }
      
      private function keyBoardEventHandler(param1:KeyboardEvent) : void
      {
         this.userIsEngaged = true;
      }
      
      private function mouseMoveHandler(param1:MouseEvent) : void
      {
         this.userIsEngaged = true;
      }
      
      private function keepConnectionActive() : void
      {
         var _loc1_:int = int(this.bin.UI.getCrntMouthID());
         this.bin.myWeevil.setMouth(_loc1_);
         if(this.bin.broadcastMoves)
         {
            this.ssclient.sendExpression(_loc1_);
         }
      }
   }
}

