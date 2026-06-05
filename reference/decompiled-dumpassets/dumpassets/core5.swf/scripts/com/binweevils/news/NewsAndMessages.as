package com.binweevils.news
{
   import com.binweevils.EventManager;
   import com.binweevils.buddies.BuddyMessageEvent;
   import com.binweevils.buddies.BuddyMessages;
   import com.binweevils.buddies.BuddyWall;
   import com.binweevils.utilities.GoogleAnalytics;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class NewsAndMessages
   {
      
      protected var container:MovieClip;
      
      protected var news:News;
      
      protected var messages:BuddyMessages;
      
      protected var alerts:BuddyWall;
      
      protected var closeBtn:SimpleButton;
      
      protected var newsTabBtn:SimpleButton;
      
      protected var messagesTabBtn:SimpleButton;
      
      protected var buddyListBtn:SimpleButton;
      
      protected var buddyAlertsBtn:SimpleButton;
      
      protected var deviceMainMC:MovieClip;
      
      protected var bgMC:MovieClip;
      
      public function NewsAndMessages(param1:Object, param2:MovieClip)
      {
         super();
         this.init(param1,param2);
      }
      
      protected function init(param1:Object, param2:MovieClip) : void
      {
         this.container = param2;
         this.deviceMainMC = this.container.getChildByName("deviceMain_mc") as MovieClip;
         this.news = new News(this.deviceMainMC.getChildByName("news") as Sprite,this.deviceMainMC.getChildByName("pagingButtonsNews_mc") as MovieClip);
         this.messages = new BuddyMessages(this.deviceMainMC,param1);
         this.alerts = new BuddyWall(param1,this.deviceMainMC.getChildByName("buddyWall_mc") as MovieClip);
         this.bgMC = this.deviceMainMC.getChildByName("bg_mc") as MovieClip;
         this.bgMC.stop();
         this.closeBtn = this.deviceMainMC.getChildByName("close_btn") as SimpleButton;
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.handleCloseClick);
         this.newsTabBtn = this.deviceMainMC.getChildByName("newsTab_btn") as SimpleButton;
         this.newsTabBtn.addEventListener(MouseEvent.CLICK,this.handleTabClick);
         this.messagesTabBtn = this.deviceMainMC.getChildByName("messagesTab_btn") as SimpleButton;
         this.messagesTabBtn.addEventListener(MouseEvent.CLICK,this.handleTabClick);
         this.buddyListBtn = this.deviceMainMC.getChildByName("buddyListTab_btn") as SimpleButton;
         this.buddyListBtn.addEventListener(MouseEvent.CLICK,this.handleTabClick);
         this.buddyAlertsBtn = this.deviceMainMC.getChildByName("buddyAlertTab_mc") as SimpleButton;
         this.buddyAlertsBtn.addEventListener(MouseEvent.CLICK,this.handleTabClick);
         this.hide(false);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.SHOW_BUDDY_ALERTS,this.showBuddyAlerts);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.SHOW_BUDDY_LIST,this.showBuddyList);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.SHOW_CONVERSATION_LIST,this.showBuddyInbox);
      }
      
      public function loadNews(param1:*) : void
      {
         this.news.loadNews(param1);
      }
      
      public function initMessages() : void
      {
         this.messages.initMessages();
      }
      
      protected function handleCloseClick(param1:MouseEvent) : void
      {
         this.hide();
      }
      
      protected function handleTabClick(param1:MouseEvent) : void
      {
         if(param1.target == this.newsTabBtn)
         {
            this.enableDisableButton(this.newsTabBtn,false);
            this.showNews();
         }
         else if(param1.target == this.messagesTabBtn)
         {
            this.enableDisableButton(this.messagesTabBtn,false);
            this.showMessages();
         }
         else if(param1.target == this.buddyListBtn)
         {
            this.enableDisableButton(this.buddyListBtn,false);
            this.showBuddies();
         }
         else if(param1.target == this.buddyAlertsBtn)
         {
            this.enableDisableButton(this.buddyAlertsBtn,false);
            this.showBuddyAlerts();
         }
      }
      
      private function enableDisableButton(param1:SimpleButton, param2:Boolean) : void
      {
      }
      
      public function show() : void
      {
         this.messages.hide(false);
         this.showNews();
         this.container.visible = true;
      }
      
      public function hide(param1:Boolean = true) : void
      {
         this.container.visible = false;
      }
      
      public function toggleVisibility() : void
      {
         if(this.container.visible)
         {
            this.hide();
         }
         else
         {
            this.show();
         }
      }
      
      protected function showNews() : void
      {
         this.news.show();
         this.messages.hide();
         this.alerts.hide();
         GoogleAnalytics.trackUser("NestNews/open_" + this.news.version);
      }
      
      protected function showMessages() : void
      {
         this.messages.hide();
         this.news.hide();
         this.alerts.hide();
         this.messages.show();
      }
      
      protected function showBuddies() : void
      {
         this.messages.hide();
         this.news.hide();
         this.alerts.hide();
         this.messages.showBuddyList(null);
      }
      
      protected function showBuddyAlerts(param1:BuddyMessageEvent = null) : void
      {
         if(param1 != null)
         {
            this.messages.hide(false);
            this.container.visible = true;
         }
         this.messages.hide();
         this.news.hide();
         this.alerts.show();
      }
      
      public function showBuddyList(param1:BuddyMessageEvent) : void
      {
         this.messages.hide(false);
         this.container.visible = true;
         this.news.hide();
         this.alerts.hide();
         this.messages.showBuddyList(null);
      }
      
      public function showBuddyInbox(param1:BuddyMessageEvent) : void
      {
         this.messages.hide(false);
         this.container.visible = true;
         this.news.hide();
         this.alerts.hide();
         this.messages.show();
      }
      
      public function setLastNewsRead(param1:int) : void
      {
         this.news.setLastNewsRead(param1);
      }
      
      public function getNumNewNews() : int
      {
         return this.news.getNumNewNews();
      }
      
      public function sendBuddyMessageTo(param1:String, param2:int) : void
      {
         this.show();
         this.showMessages();
      }
   }
}

