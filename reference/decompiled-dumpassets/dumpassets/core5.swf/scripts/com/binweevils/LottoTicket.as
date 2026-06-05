package com.binweevils
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class LottoTicket
   {
      
      public var ticket_mc:MovieClip;
      
      private var itemVals:Array;
      
      private var item_mcs:Array;
      
      public function LottoTicket(param1:Sprite, param2:int, param3:int, param4:int, param5:int)
      {
         var _loc6_:* = undefined;
         super();
         this.ticket_mc = new TicketResult_mc();
         this.itemVals = [param2,param3,param4,param5];
         this.item_mcs = [this.ticket_mc.item0_mc,this.ticket_mc.item1_mc,this.ticket_mc.item2_mc,this.ticket_mc.item3_mc];
         for(_loc6_ in this.item_mcs)
         {
            this.item_mcs[_loc6_].ring_spr.visible = false;
            this.item_mcs[_loc6_].gotoAndStop(this.itemVals[_loc6_] + 1);
         }
         this.ticket_mc.numMatches_txt.text = "";
         param1.addChild(this.ticket_mc);
      }
      
      public function setPos(param1:Number, param2:Number, param3:Number) : void
      {
         this.ticket_mc.x = param1;
         this.ticket_mc.y = param2;
         this.ticket_mc.scaleX = this.ticket_mc.scaleY = param3;
      }
      
      public function checkItem(param1:int, param2:int) : Boolean
      {
         if(this.itemVals[param1] == param2)
         {
            this.item_mcs[param1].ring_spr.visible = true;
            return true;
         }
         return false;
      }
      
      public function countAllMatches(param1:Array) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            if(this.itemVals[_loc3_] == param1[_loc3_])
            {
               _loc2_++;
               this.item_mcs[_loc3_].ring_spr.visible = true;
            }
            _loc3_++;
         }
         this.ticket_mc.numMatches_txt.text = _loc2_;
         return _loc2_;
      }
   }
}

