package com.binweevils
{
   import com.binweevils.DBaccess.PHP2call;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class TycoonBusinessVisit
   {
      
      private var tycoonIDX:int;
      
      private var businessID:int;
      
      private var busType:int;
      
      private var visitTimer:Timer;
      
      private var VISITOR_TIME_DELAY:int = 60000;
      
      private var dinamicTimerDelay:int;
      
      private var timerCalledMade:int;
      
      private var businessDetails:Array;
      
      public function TycoonBusinessVisit(param1:int, param2:int, param3:int)
      {
         var _loc4_:String = null;
         super();
         this.tycoonIDX = param1;
         this.businessID = param2;
         this.busType = param3;
         this.timerCalledMade = 0;
         this.visitTimer = new Timer(this.VISITOR_TIME_DELAY);
         this.visitTimer.addEventListener(TimerEvent.TIMER,this.visitTimerListener);
         if(this.tycoonIDX == 0)
         {
            _loc4_ = Bin.get_instance().getHostWeevilName();
            Bin.get_instance().getWeevilData(_loc4_,this.weevilDataReceived);
         }
         else
         {
            this.visitTimer.start();
         }
      }
      
      private function weevilDataReceived(param1:Object) : void
      {
         this.tycoonIDX = param1.idx;
         if(this.tycoonIDX != 0)
         {
            this.visitTimer.start();
         }
      }
      
      public function restartTimer() : void
      {
         this.timerCalledMade = 0;
         this.visitTimer.start();
      }
      
      private function visitTimerListener(param1:TimerEvent) : void
      {
         this.visitTimer.reset();
         if(this.timerCalledMade >= 1)
         {
            this.dinamicTimerDelay = this.VISITOR_TIME_DELAY * 2;
         }
         else
         {
            this.dinamicTimerDelay = this.VISITOR_TIME_DELAY;
         }
         this.visitTimer.delay = this.dinamicTimerDelay;
         this.doCustomerCall();
      }
      
      private function doCustomerCall(param1:Boolean = false) : void
      {
         ++this.timerCalledMade;
         var _loc2_:PHP2call = new PHP2call("nest/partyRoomDwell");
         _loc2_.sendAndAwaitResponse(["visitorIdx","tycoonIdx","step"],[Bin.get_instance().myUserIDX,this.tycoonIDX,this.timerCalledMade],this.onRewardDataResponse,true);
      }
      
      public function onRewardDataResponse(param1:Object) : void
      {
         switch(int(param1.responseCode))
         {
            case 1:
               Bin.get_instance().updateXp(int(param1.visitorXp));
               if(this.timerCalledMade < 3)
               {
                  this.visitTimer.start();
               }
         }
      }
      
      public function compare(param1:int, param2:int) : Boolean
      {
         if(param1 == this.tycoonIDX && param2 == this.businessID)
         {
            return true;
         }
         return false;
      }
      
      public function terminate() : void
      {
         this.visitTimer.reset();
         this.visitTimer.stop();
      }
   }
}

