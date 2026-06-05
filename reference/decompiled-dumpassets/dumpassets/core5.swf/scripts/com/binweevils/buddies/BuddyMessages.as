package com.binweevils.buddies
{
   import com.binweevils.EventManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BuddyMessages implements IPagingOwner
   {
      
      private var ui:Object;
      
      private var deviceMainMC:MovieClip;
      
      private var inbox:BuddyMessagesInbox;
      
      private var reader:BuddyMessageReader;
      
      private var composer:BuddyMessagesCompose;
      
      private var buddyList:BuddyMessagesBuddyList;
      
      private var buddyListConversation:BuddyMessagesBuddyListConversation;
      
      private var pagingButtonsMC:MovieClip;
      
      private var pagePrevBtn:SimpleButton;
      
      private var pageNextBtn:SimpleButton;
      
      private var currentPagingUser:IPagingUser;
      
      private var composerMode:int = -1;
      
      private const MODE_REPLY:int = 1;
      
      private const MODE_NEW_MESSAGE:int = 2;
      
      public function BuddyMessages(param1:MovieClip, param2:Object)
      {
         super();
         this.init(param1,param2);
      }
      
      private function init(param1:MovieClip, param2:Object) : void
      {
         this.ui = param2;
         this.deviceMainMC = param1;
         this.initPaging(this.deviceMainMC.getChildByName("pagingButtonsMessages_mc") as MovieClip);
         this.inbox = new BuddyMessagesInbox(param1.getChildByName("inbox_spr") as MovieClip,this as IPagingOwner);
         this.reader = new BuddyMessageReader(param1.getChildByName("readMessage_mc") as MovieClip,this as IPagingOwner);
         this.composer = new BuddyMessagesCompose(param1.getChildByName("messageCompose_mc") as MovieClip);
         this.buddyList = new BuddyMessagesBuddyList(param1.getChildByName("buddyList_mc") as MovieClip,param2,this as IPagingOwner);
         this.buddyListConversation = new BuddyMessagesBuddyListConversation(param1.getChildByName("buddyListConvo_mc") as MovieClip,param2,this as IPagingOwner);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.ON_REPLY_SELECTED,this.handleReplySelected);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.ON_COMPOSER_CLOSED,this.handleComposerClosed);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.ON_MESSAGE_SENT,this.onMessageSent);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.SHOW_BUDDY_LIST,this.showBuddyList);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.SHOW_CONVERSATION_BUDDY_LIST,this.showConversationBuddyList);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.HIDE_CONVERSATION_BUDDY_LIST,this.hideConversationBuddyList);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.HIDE_BUDDY_LIST,this.hideBuddyList);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.ON_BUDDY_SELECTED,this.handleBuddySelected);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.ON_MESSAGE_SELECTED,this.handleBuddySelected);
      }
      
      private function initPaging(param1:MovieClip) : void
      {
         this.pagingButtonsMC = param1;
         this.pagingButtonsMC.gotoAndStop(1);
         this.pagePrevBtn = this.pagingButtonsMC.buttons_mc.getChildByName("pagePrev_btn") as SimpleButton;
         this.pagePrevBtn.addEventListener(MouseEvent.CLICK,this.handlePrevPageClick);
         this.pageNextBtn = this.pagingButtonsMC.buttons_mc.getChildByName("pageNext_btn") as SimpleButton;
         this.pageNextBtn.addEventListener(MouseEvent.CLICK,this.handleNextPageClick);
      }
      
      public function setPagingUser(param1:IPagingUser) : void
      {
         this.currentPagingUser = param1;
      }
      
      private function handlePrevPageClick(param1:MouseEvent) : void
      {
         if(this.currentPagingUser)
         {
            this.currentPagingUser.pagePrev();
         }
      }
      
      private function handleNextPageClick(param1:MouseEvent) : void
      {
         if(this.currentPagingUser)
         {
            this.currentPagingUser.pageNext();
         }
      }
      
      public function enableDisableNext(param1:Boolean) : void
      {
         this.enableDisablePagingButton(this.pageNextBtn,param1);
      }
      
      public function enableDisablePrev(param1:Boolean) : void
      {
         this.enableDisablePagingButton(this.pagePrevBtn,param1);
      }
      
      public function showPaging() : void
      {
         this.pagingButtonsMC.removeEventListener(Event.ENTER_FRAME,this.rewindPagingButtonsAnim);
         if(this.pagingButtonsMC.currentFrame < this.pagingButtonsMC.totalFrames)
         {
            this.pagingButtonsMC.play();
         }
      }
      
      public function hidePaging(param1:Boolean = true) : void
      {
         if(param1)
         {
            this.pagingButtonsMC.addEventListener(Event.ENTER_FRAME,this.rewindPagingButtonsAnim);
         }
         else
         {
            this.pagingButtonsMC.gotoAndStop(1);
         }
      }
      
      protected function rewindPagingButtonsAnim(param1:Event) : void
      {
         this.checkStopRewind();
         this.pagingButtonsMC.prevFrame();
         this.checkStopRewind();
      }
      
      private function checkStopRewind() : void
      {
         if(this.pagingButtonsMC.currentFrame == 1)
         {
            this.pagingButtonsMC.removeEventListener(Event.ENTER_FRAME,this.rewindPagingButtonsAnim);
         }
      }
      
      private function enableDisablePagingButton(param1:SimpleButton, param2:Boolean) : void
      {
         param1.mouseEnabled = param2;
         if(param2)
         {
            param1.alpha = 1;
         }
         else
         {
            param1.alpha = 0.5;
         }
      }
      
      public function show() : void
      {
         this.composerMode = -1;
         this.inbox.show();
      }
      
      public function hide(param1:Boolean = true) : void
      {
         this.inbox.hide();
         this.composer.hide();
         this.reader.hide();
         this.buddyList.hide();
         this.buddyListConversation.hide();
         EventManager.get_instance().dispatchEvent(new BuddyMessageEvent(BuddyMessageEvent.ON_MESSAGES_CLOSED));
         this.hidePaging(param1);
      }
      
      private function handleReplySelected(param1:BuddyMessageEvent) : void
      {
         this.composerMode = this.MODE_REPLY;
         this.inbox.hide();
         this.composer.show(param1.msgInfo);
      }
      
      private function handleComposerClosed(param1:BuddyMessageEvent) : void
      {
         this.inbox.show(this.composerMode == this.MODE_NEW_MESSAGE);
      }
      
      private function onMessageSent(param1:BuddyMessageEvent) : void
      {
         this.inbox.show(this.composerMode == this.MODE_NEW_MESSAGE);
      }
      
      public function showBuddyList(param1:BuddyMessageEvent) : void
      {
         this.inbox.hide();
         this.buddyList.show();
         this.reader.hide();
      }
      
      public function showConversationBuddyList(param1:BuddyMessageEvent) : void
      {
         this.inbox.hide();
         this.buddyListConversation.show();
         this.reader.hide();
      }
      
      private function hideBuddyList(param1:BuddyMessageEvent) : void
      {
         this.inbox.show(true);
         this.buddyList.hide();
      }
      
      private function hideConversationBuddyList(param1:BuddyMessageEvent) : void
      {
         this.inbox.show(true);
         this.buddyListConversation.hide();
      }
      
      private function handleBuddySelected(param1:BuddyMessageEvent) : void
      {
         this.buddyList.hide();
         this.inbox.hide();
         this.reader.show();
      }
      
      public function initMessages() : void
      {
      }
      
      private function reset() : void
      {
      }
      
      public function sendBuddyMessageTo(param1:String, param2:int) : void
      {
         var _loc3_:BuddyMessageInfoObject = new BuddyMessageInfoObject();
         _loc3_.from = param1;
         _loc3_.fromIDX = param2;
         this.inbox.hide();
         this.composerMode = this.MODE_NEW_MESSAGE;
         this.composer.show(_loc3_);
      }
   }
}

