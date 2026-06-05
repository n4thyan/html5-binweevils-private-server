package com.binweevils.news
{
   import caurina.transitions.Tweener;
   import com.binweevils.BinEvents;
   import com.binweevils.Bin_extInterface;
   import com.binweevils.CustomEvent;
   import com.binweevils.DBaccess.PHP2call;
   import com.binweevils.EventManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class News
   {
      
      private const folderStructure:String = "binConfig/uk/news/news";
      
      private var container:Sprite;
      
      private var newsConfig:XML;
      
      private var contentLoadStarted:Boolean;
      
      private var loadNum:int;
      
      private var newNews:Array;
      
      private var newsHolders:Array;
      
      private var itemsHolderSpr:Sprite;
      
      private const ITEM_HEIGHT:int = 118;
      
      private const ITEM_LEFT:int = 0;
      
      private const ITEM_SPACING:int = 7;
      
      private const ITEM_Y1:int = 0;
      
      private const ITEMS_PER_PAGE:int = 3;
      
      private var contentY1:int;
      
      private var newsMask:Sprite;
      
      private var numPages:int;
      
      private var pageNum:int;
      
      private var pageHeight:int;
      
      private var pageNumTxt:TextField;
      
      private var lastVersionSeen:int;
      
      private var thisVersion:int;
      
      private var numNew:int;
      
      private var pagingButtonsMC:MovieClip;
      
      private var pagePrevBtn:SimpleButton;
      
      private var pageNextBtn:SimpleButton;
      
      internal var newsArr:Array = new Array();
      
      public function News(param1:Sprite, param2:MovieClip)
      {
         super();
         this.container = param1;
         this.newNews = [];
         this.newsHolders = [];
         this.itemsHolderSpr = this.container.getChildByName("itemsHolder_spr") as Sprite;
         this.contentY1 = this.itemsHolderSpr.y;
         this.newsMask = this.container.getChildByName("newsMask_spr") as Sprite;
         this.initPaging(param2);
         EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_NEWS_RECIEVED,this.onNewsLoaded);
         EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_NOTIFICATIONS_RECIEVED,this.onNotificationsRecieved);
      }
      
      public function get version() : int
      {
         return this.thisVersion;
      }
      
      public function loadNews(param1:*) : void
      {
      }
      
      private function onNotificationsRecieved(param1:CustomEvent) : void
      {
         var _loc2_:Object = param1.dataObj;
         if(_loc2_["responseCode"] == 1)
         {
            this.numNew = _loc2_["nest-news"];
            if(this.numNew > 0)
            {
               this.shoutNewNewsAvailable();
            }
         }
      }
      
      private function showNews() : *
      {
         var _loc3_:NestNewsContent = null;
         var _loc4_:newSticker = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.newsArr.length)
         {
            _loc3_ = new NestNewsContent();
            _loc3_.init(this.newsArr[_loc2_]);
            this.itemsHolderSpr.addChild(_loc3_);
            _loc3_.x = 0;
            _loc3_.y = -10 + _loc2_ * (this.ITEM_HEIGHT + this.ITEM_SPACING);
            if(this.newsArr[_loc2_]["new"] == 1)
            {
               _loc4_ = new newSticker();
               _loc3_.addChild(_loc4_);
               _loc4_.x = 210;
               _loc4_.y = -10;
               _loc4_.width /= 2;
               _loc4_.height /= 2;
            }
            _loc2_++;
         }
         this.pageHeight = this.ITEMS_PER_PAGE * (this.ITEM_HEIGHT + this.ITEM_SPACING);
         this.numPages = Math.ceil(this.newsArr.length / this.ITEMS_PER_PAGE);
         this.reset();
         if(this.numPages > 1 && this.pagingButtonsMC.currentFrame < this.pagingButtonsMC.totalFrames)
         {
            this.pagingButtonsMC.play();
         }
      }
      
      private function onNewsLoaded(param1:CustomEvent) : *
      {
         var _loc2_:Object = param1.dataObj;
         if(_loc2_["responseCode"] == 1 && this.container.visible)
         {
            this.newsArr = _loc2_["nest_news"];
            this.showNews();
         }
      }
      
      private function shoutNewNewsAvailable() : void
      {
         this.container.dispatchEvent(new Event("newNewsAvailable",true));
      }
      
      private function initPaging(param1:MovieClip) : void
      {
         this.pagingButtonsMC = param1;
         this.pagingButtonsMC.gotoAndStop(1);
         this.pagePrevBtn = this.pagingButtonsMC.buttons_mc.getChildByName("pagePrev_btn") as SimpleButton;
         this.pagePrevBtn.addEventListener(MouseEvent.CLICK,this.handlePrevPageClick);
         this.pageNextBtn = this.pagingButtonsMC.buttons_mc.getChildByName("pageNext_btn") as SimpleButton;
         this.pageNextBtn.addEventListener(MouseEvent.CLICK,this.handleNextPageClick);
         this.pageNumTxt = Sprite(this.container.getChildByName("pageNum_spr")).getChildByName("pageNum_txt") as TextField;
         this.pageNumTxt.visible = false;
      }
      
      private function handlePrevPageClick(param1:MouseEvent) : void
      {
         --this.pageNum;
         if(this.pageNum < 1)
         {
            this.enableDisablePagingButton(this.pagePrevBtn,false);
         }
         if(this.pageNum == this.numPages - 2)
         {
            this.enableDisablePagingButton(this.pageNextBtn,true);
         }
         this.showPage();
      }
      
      private function handleNextPageClick(param1:MouseEvent) : void
      {
         ++this.pageNum;
         if(this.pageNum == this.numPages - 1)
         {
            this.enableDisablePagingButton(this.pageNextBtn,false);
         }
         if(this.pageNum == 1)
         {
            this.enableDisablePagingButton(this.pagePrevBtn,true);
         }
         this.showPage();
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
      
      private function showPage() : void
      {
         var _loc1_:int = this.contentY1 - this.pageHeight * this.pageNum;
         Tweener.addTween(this.itemsHolderSpr,{
            "y":_loc1_,
            "time":0.4
         });
         this.setPageNumText();
      }
      
      private function setPageNumText() : void
      {
         this.pageNumTxt.text = this.pageNum + 1 + "/" + this.numPages;
      }
      
      private function markAsRead() : void
      {
         var _loc1_:PHP2call = null;
         if(this.thisVersion > this.lastVersionSeen)
         {
            _loc1_ = new PHP2call("news/markRead");
            _loc1_.fireAndForget(["newsVersion"],[this.thisVersion],false);
         }
         this.lastVersionSeen = this.thisVersion;
      }
      
      public function show() : void
      {
         if(this.newsArr.length == 0)
         {
            Bin_extInterface.bin.webSocket.send("nest-news");
         }
         else
         {
            this.showNews();
         }
      }
      
      public function hide() : void
      {
         this.container.visible = false;
         this.hidePaging();
      }
      
      private function hidePaging() : void
      {
         this.pagingButtonsMC.addEventListener(Event.ENTER_FRAME,this.rewindPagingButtonsAnim);
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
      
      public function getNumNewNews() : int
      {
         return this.numNew;
      }
      
      public function getContentLoadStarted() : Boolean
      {
         return this.contentLoadStarted;
      }
      
      public function setLastNewsRead(param1:int) : void
      {
         this.lastVersionSeen = param1;
      }
      
      private function reset() : void
      {
         Tweener.removeTweens(this.itemsHolderSpr);
         this.itemsHolderSpr.y = this.contentY1;
         this.pageNum = 0;
         this.container.visible = true;
         this.enableDisablePagingButton(this.pagePrevBtn,false);
         this.enableDisablePagingButton(this.pageNextBtn,this.numPages > 1);
         this.setPageNumText();
      }
   }
}

