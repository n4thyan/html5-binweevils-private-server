package com.binweevils
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.*;
   import flash.utils.Timer;
   
   public class LottoResults
   {
      
      private var lottoResults_mc:MovieClip;
      
      private var res:Array;
      
      private var myTicketsList:ScrollingList;
      
      private var winnerList:UserList;
      
      private var ticketHolder_spr:Sprite;
      
      private var myTickets:Array;
      
      private var jackpot:int;
      
      private var resData:Array;
      
      private var winners:Array;
      
      private var crntItemIdx:int;
      
      private var resultTimer:Timer;
      
      private var nextDrawDate:String;
      
      private var alreadyGotTicket:Boolean;
      
      public function LottoResults(param1:UImain, param2:MovieClip)
      {
         var _loc3_:* = undefined;
         super();
         this.lottoResults_mc = param2;
         this.hideIt();
         this.lottoResults_mc.close_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.hideIt);
         this.res = [this.lottoResults_mc.result0_mc,this.lottoResults_mc.result1_mc,this.lottoResults_mc.result2_mc,this.lottoResults_mc.result3_mc];
         for(_loc3_ in this.res)
         {
            this.res[_loc3_].item_mc.gotoAndStop(1);
         }
         this.ticketHolder_spr = new Sprite();
         this.myTickets = new Array();
         this.myTicketsList = new ScrollingList(this.lottoResults_mc.tickets_sp);
         this.winnerList = new UserList(param1,this.lottoResults_mc.winners_sp,1,255,255,255);
         this.resultTimer = new Timer(5000,5);
         this.resultTimer.addEventListener("timer",this.resultManager);
      }
      
      private function resetResultDisplay() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.res)
         {
            this.res[_loc1_].item_mc.visible = false;
            this.res[_loc1_].item_mc.ring_spr.visible = false;
            this.res[_loc1_].qMark_spr.visible = true;
         }
      }
      
      private function removeAllTickets() : void
      {
         this.myTicketsList.removeAllItems();
         this.myTickets = [];
      }
      
      private function addTicket(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:LottoTicket = new LottoTicket(this.ticketHolder_spr,param1,param2,param3,param4);
         this.myTicketsList.addItem(_loc5_.ticket_mc);
         this.myTickets.push(_loc5_);
      }
      
      public function liveResultReceived(param1:int, param2:String, param3:String, param4:int, param5:String) : void
      {
         var _loc6_:Array = null;
         var _loc7_:* = undefined;
         LottoData.nextDrawID = param4;
         LottoData.nextDrawDate = param5;
         LottoData.alreadyGotTicket = false;
         if(LottoData.initialised && LottoData.numTickets > 0)
         {
            LottoData.drawInProgress = true;
            this.resetResultDisplay();
            this.removeAllTickets();
            _loc6_ = LottoData.tickets;
            for(_loc7_ in LottoData.tickets)
            {
               this.addTicket(_loc6_[_loc7_][0],_loc6_[_loc7_][1],_loc6_[_loc7_][2],_loc6_[_loc7_][3]);
            }
            this.lottoResults_mc.winnings_txt.visible = false;
            this.lottoResults_mc.amountWon_txt.visible = false;
            this.lottoResults_mc.numWinners_txt.visible = false;
            this.lottoResults_mc.rollover_txt.visible = false;
            LottoData.removeAllTickets();
            this.jackpot = param1;
            this.lottoResults_mc.jackpot_txt.text = "TOP PRIZE: " + this.jackpot + " Mulch";
            this.resData = param2.split("");
            if(param3 != "0")
            {
               this.winners = param3.split(",");
            }
            else
            {
               this.winners = [];
            }
            this.winnerList.cleanUpList();
            this.crntItemIdx = 0;
            this.showIt();
            this.resultTimer.reset();
            this.resultTimer.start();
         }
         else
         {
            this.hideIt();
         }
      }
      
      private function resultManager(param1:TimerEvent = null) : void
      {
         var _loc2_:LottoTicket = null;
         var _loc3_:MovieClip = null;
         if(this.crntItemIdx > 0)
         {
            this.res[this.crntItemIdx - 1].item_mc.gotoAndStop(int(this.resData[this.crntItemIdx - 1]) + 1);
            new toc().play(220);
            for each(_loc2_ in this.myTickets)
            {
               if(_loc2_.checkItem(this.crntItemIdx - 1,this.resData[this.crntItemIdx - 1]))
               {
                  new ting().play();
               }
            }
         }
         if(this.crntItemIdx < 4)
         {
            _loc3_ = this.res[this.crntItemIdx];
            _loc3_.qMark_spr.visible = false;
            _loc3_.item_mc.visible = true;
            _loc3_.item_mc.play();
            ++this.crntItemIdx;
         }
         else
         {
            LottoData.drawInProgress = false;
            this.resultTimer.stop();
            this.countWinnings();
            this.showWinners();
         }
      }
      
      private function countWinnings() : void
      {
         var _loc2_:LottoTicket = null;
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         for each(_loc2_ in this.myTickets)
         {
            _loc3_ = int(_loc2_.countAllMatches(this.resData));
            switch(_loc3_)
            {
               case 1:
                  _loc1_ += LottoData.oneMatchValue;
                  break;
               case 2:
                  _loc1_ += LottoData.twoMatchesValue;
                  break;
               case 3:
                  _loc1_ += LottoData.threeMatchesValue;
                  break;
               case 4:
                  new tada().play();
                  _loc1_ += Math.max(LottoData.minJackpotToAward,this.jackpot / this.winners.length);
                  Bin.get_instance().showAlertBox("Congratulations!!! \n You have won the TOP PRIZE!!!");
                  break;
            }
         }
         this.lottoResults_mc.amountWon_txt.text = _loc1_ + " Mulch";
         this.lottoResults_mc.winnings_txt.visible = true;
         this.lottoResults_mc.amountWon_txt.visible = true;
         if(_loc1_ > 0)
         {
            this.showIt();
         }
      }
      
      private function showWinners() : void
      {
         var _loc1_:String = null;
         if(this.winners.length == 1)
         {
            _loc1_ = "winner";
         }
         else
         {
            _loc1_ = "winners";
         }
         this.lottoResults_mc.numWinners_txt.text = this.winners.length + " TOP PRIZE " + _loc1_;
         this.lottoResults_mc.numWinners_txt.visible = true;
         if(this.winners.length == 0)
         {
            this.lottoResults_mc.rollover_txt.visible = true;
         }
         else
         {
            this.winnerList.populate2(this.winners);
            this.winnerList.highlightAll();
         }
      }
      
      public function showIt() : void
      {
         this.lottoResults_mc.visible = true;
      }
      
      public function hideIt(param1:MouseEvent = null) : void
      {
         this.lottoResults_mc.visible = false;
      }
   }
}

