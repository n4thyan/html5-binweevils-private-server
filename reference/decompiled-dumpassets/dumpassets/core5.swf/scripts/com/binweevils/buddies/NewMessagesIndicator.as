package com.binweevils.buddies
{
   import com.binweevils.BinEvents;
   import com.binweevils.Bin_extInterface;
   import com.binweevils.CustomEvent;
   import com.binweevils.EventManager;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class NewMessagesIndicator
   {
      
      private var messengerContainer:Sprite;
      
      private var conversationContainer:Sprite;
      
      private var buddiesContainer:Sprite;
      
      private var messengerNumTxt:TextField;
      
      private var conversationNumTxt:TextField;
      
      private var buddiesNumTxt:TextField;
      
      private var numNew:int;
      
      private var convCount:int;
      
      private var buddyCount:int;
      
      private var messengerBgSpr:Sprite;
      
      private var conversationBgSpr:Sprite;
      
      private var buddiesBgSpr:Sprite;
      
      public function NewMessagesIndicator(param1:Sprite, param2:Sprite, param3:Sprite)
      {
         super();
         this.messengerContainer = param1;
         this.conversationContainer = param2;
         this.buddiesContainer = param3;
         this.init();
      }
      
      private function init() : void
      {
         this.messengerContainer.visible = false;
         this.messengerBgSpr = new Sprite();
         this.conversationBgSpr = new Sprite();
         this.buddiesBgSpr = new Sprite();
         this.messengerContainer.addChildAt(this.messengerBgSpr,0);
         this.conversationContainer.addChildAt(this.conversationBgSpr,0);
         this.buddiesContainer.addChildAt(this.buddiesBgSpr,0);
         this.messengerNumTxt = this.messengerContainer.getChildByName("_txt") as TextField;
         this.conversationNumTxt = this.conversationContainer.getChildByName("_txt") as TextField;
         this.buddiesNumTxt = this.buddiesContainer.getChildByName("_txt") as TextField;
         EventManager.get_instance().addEventListener(BuddyMessageEvent.ON_NUM_NEW_MESSAGES,this.onBuddyMessagesNew);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.ON_NEW_MESSAGE_READ,this.onNewMessageRead,false,999);
         Bin_extInterface.bin.webSocket.send("weevil/get-notifications");
         EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_NOTIFICATIONS_RECIEVED,this.onNotificationsRecieved);
         EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_NOTIFY_NEWMESSAGE,this.onNewMessageNotify);
         EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_NOTIFY_NEWINVITE,this.onNewInviteNotify);
         EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_BUDDYREQUESTREPLIED_RECIEVED,this.onInviteHandled);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.ON_NEW_MESSAGE_READ,this.onNewBuddyMessageRead);
      }
      
      private function onNotificationsRecieved(param1:CustomEvent) : void
      {
         var _loc2_:Object = param1.dataObj;
         if(_loc2_["responseCode"] == 1)
         {
            if(_loc2_["conversations"] > 0)
            {
               this.convCount = 1;
            }
            this.buddyCount = _loc2_["buddy-requests"];
            if(_loc2_["buddy-requests"] > 0)
            {
               this.buddyCount = 1;
            }
            this.numNew = this.convCount + this.buddyCount;
            this.updateDisplay();
         }
      }
      
      private function onNewInviteNotify(param1:CustomEvent) : void
      {
         this.buddyCount = 1;
         this.updateDisplay();
      }
      
      private function onNewBuddyMessageRead(param1:BuddyMessageEvent) : void
      {
         --this.convCount;
         this.updateDisplay();
      }
      
      private function onInviteHandled(param1:CustomEvent) : void
      {
         --this.buddyCount;
         this.updateDisplay();
      }
      
      private function onNewMessageNotify(param1:CustomEvent) : void
      {
         var _loc2_:Object = param1.dataObj;
         if(_loc2_["conversation_id"] != BuddyMessageReader.currentConversationID)
         {
            this.convCount = 1;
            this.updateDisplay();
         }
      }
      
      private function onBuddyMessagesNew(param1:BuddyMessageEvent) : void
      {
         this.numNew = param1.numNew;
         this.updateDisplay();
      }
      
      private function onNewMessageRead(param1:BuddyMessageEvent) : void
      {
         --this.numNew;
         this.updateDisplay();
      }
      
      private function updateDisplay() : void
      {
         this.numNew = this.convCount + this.buddyCount;
         if(this.numNew < 0)
         {
            this.numNew = 0;
         }
         this.messengerNumTxt.text = "!";
         this.messengerContainer.visible = this.numNew > 0;
         this.conversationNumTxt.text = "!";
         this.conversationContainer.visible = this.convCount > 0;
         this.buddiesNumTxt.text = "!";
         this.buddiesContainer.visible = this.buddyCount > 0;
         if(this.messengerContainer.visible)
         {
            this.updateBG(this.messengerBgSpr,this.messengerNumTxt);
         }
         if(this.conversationContainer.visible)
         {
            this.updateBG(this.conversationBgSpr,this.conversationNumTxt);
         }
         if(this.buddiesContainer.visible)
         {
            this.updateBG(this.buddiesBgSpr,this.buddiesNumTxt);
         }
      }
      
      private function updateBG(param1:Sprite, param2:TextField) : void
      {
         var _loc3_:int = 12;
         var _loc4_:int = 6;
         var _loc5_:Number = param2.textWidth > _loc3_ ? param2.textWidth : _loc3_;
         _loc5_ = _loc5_ + _loc4_;
         var _loc6_:int = 12;
         param1.graphics.clear();
         param1.graphics.lineStyle(1);
         param1.graphics.beginFill(16719363);
         param1.graphics.drawRoundRect(0 - _loc5_ / 2,0 - _loc6_ / 2,_loc5_,_loc6_,_loc6_,_loc6_);
         param1.graphics.endFill();
      }
   }
}

