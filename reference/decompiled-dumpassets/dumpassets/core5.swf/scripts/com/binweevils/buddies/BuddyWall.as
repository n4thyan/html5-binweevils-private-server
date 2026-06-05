package com.binweevils.buddies
{
   import caurina.transitions.Tweener;
   import com.binweevils.Bin_extInterface;
   import com.binweevils.DBaccess.PHP2call;
   import com.binweevils.ui.ScrollPain;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   
   public class BuddyWall
   {
      
      public static const SPACING_ITEM_Y:int = 4;
      
      private const RESPONSE_NO_POSTS:int = 2;
      
      private const RESPONSE_ERROR:int = 999;
      
      private const MSG_EMPTY:int = 1;
      
      private const MSG_ERROR_NO_POSTS:int = 2;
      
      private const MSG_ERROR_UNDEFINED:int = 3;
      
      private const MSG_LOADING:int = 4;
      
      private const MAX_RESPONSE_TIME:int = 10000;
      
      private var wallMC:MovieClip;
      
      private var itemsContainer:MovieClip;
      
      private var INFO_PATH:String = "social/getPosts";
      
      private var wallItems:Array;
      
      private var bin:Object;
      
      private var UI:Object;
      
      private var periodNum:int;
      
      private var paging:BuddyWallPaging;
      
      private var scrollPain:ScrollPain;
      
      private var postResponseTimer:Timer;
      
      private var awaitingResponse:Boolean;
      
      public function BuddyWall(param1:Object, param2:MovieClip)
      {
         super();
         this.wallMC = param2;
         this.bin = Bin_extInterface.bin;
         this.wallMC.mask_mc.visible = false;
         this.wallMC.visible = false;
         this.paging = new BuddyWallPaging(this,this.wallMC);
         this.initScroller();
         this.UI = param1;
         this.postResponseTimer = new Timer(6000,1);
         this.postResponseTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.clearResponseTimer);
      }
      
      private function clearResponseTimer(param1:TimerEvent = null) : void
      {
         this.awaitingResponse = false;
         this.postResponseTimer.reset();
         if(param1 != null)
         {
            this.paging.show();
         }
      }
      
      private function getPosts() : void
      {
         if(this.awaitingResponse)
         {
            return;
         }
         this.scrollPain.disable();
         this.scrollPain.reset();
         this.awaitingResponse = true;
         this.postResponseTimer.start();
         new PHP2call(this.INFO_PATH).sendAndAwaitResponse(["idx","period"],[this.bin.myUserIDX,this.periodNum],this.onPostsReceived,true,true);
      }
      
      private function onPostsReceived(param1:Object, param2:Event) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         if(this.itemsContainer)
         {
            _loc3_ = 0;
            while(_loc3_ < this.wallItems.length)
            {
               Tweener.removeTweens(this.wallItems[_loc5_].getMC());
               _loc3_++;
            }
            this.wallMC.removeChild(this.itemsContainer);
            this.itemsContainer = null;
         }
         this.clearResponseTimer();
         this.paging.show();
         this.wallMC.period_txt.text = param1.period;
         if(!this.isValidResponse(param1))
         {
            return;
         }
         if(param1.posts is Array)
         {
            _loc4_ = param1.posts;
            this.wallItems = [];
            this.itemsContainer = new MovieClip();
            this.itemsContainer.y = this.wallMC.mask_mc.y + 10;
            this.itemsContainer.x = 80;
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               this.createItem(_loc5_,_loc4_[_loc5_]);
               _loc5_++;
            }
            this.scrollPain.setContent(this.itemsContainer);
            this.wallMC.addChild(this.itemsContainer);
            this.itemsContainer.mask = this.wallMC.mask_mc;
            this.showMessage(this.MSG_EMPTY);
            return;
         }
      }
      
      private function isValidResponse(param1:Object) : Boolean
      {
         if(int(param1.responseCode) == 1)
         {
            return true;
         }
         if(int(param1.responseCode) == this.RESPONSE_NO_POSTS)
         {
            this.showMessage(this.MSG_ERROR_NO_POSTS);
         }
         else if(int(param1.responseCode) == this.RESPONSE_ERROR)
         {
            this.showMessage(this.MSG_ERROR_UNDEFINED);
         }
         return false;
      }
      
      private function showMessage(param1:int) : void
      {
         this.wallMC.messages_mc.gotoAndStop(param1);
      }
      
      private function createItem(param1:int, param2:Object) : void
      {
         var _loc6_:MovieClip = null;
         var _loc3_:Class = getDefinitionByName("buddyNewsWallItem") as Class;
         var _loc4_:Object = new _loc3_();
         var _loc5_:BuddyWallItem = new BuddyWallItem(this,_loc4_ as MovieClip);
         _loc5_.setInfo(param2,param1);
         this.itemsContainer.addChild(_loc5_.getMC());
         this.wallItems[param1] = _loc5_;
         _loc5_.getMC().x = 15;
         if(param1 > 0)
         {
            _loc6_ = this.wallItems[param1 - 1].getMC();
            _loc5_.getMC().y = _loc5_.getMC().y + (Math.floor(_loc6_.y) + Math.floor(_loc6_.height) + SPACING_ITEM_Y);
         }
      }
      
      public function doPaging(param1:int) : void
      {
         this.hide();
         switch(param1)
         {
            case BuddyWallPaging.PAGING_OLDER:
               ++this.periodNum;
               break;
            case BuddyWallPaging.PAGING_NEWER:
               if(this.periodNum > 0)
               {
                  --this.periodNum;
               }
               break;
            case BuddyWallPaging.PAGING_LATEST:
               this.periodNum = 0;
         }
         this.show(true,this.periodNum);
      }
      
      public function getPeriodNum() : int
      {
         return this.periodNum;
      }
      
      public function show(param1:Boolean = true, param2:* = 0) : void
      {
         var _loc3_:uint = 0;
         this.paging.hide();
         this.wallMC.period_txt.text = "";
         this.showMessage(this.MSG_LOADING);
         if(param1)
         {
            this.periodNum = param2;
            this.getPosts();
         }
         else if(this.itemsContainer)
         {
            _loc3_ = 0;
            while(_loc3_ < this.wallItems.length)
            {
               Tweener.removeTweens(this.wallItems[_loc3_].getMC());
               _loc3_++;
            }
            this.wallMC.removeChild(this.itemsContainer);
            this.itemsContainer = null;
         }
         this.wallMC.visible = param1;
      }
      
      public function hide(param1:MouseEvent = null) : void
      {
         this.show(false);
      }
      
      public function getUI() : Object
      {
         return this.UI;
      }
      
      private function initScroller() : void
      {
         this.scrollPain = new ScrollPain(this.wallMC.scrollbar_mc,this.wallMC.mask_mc,null,12);
         this.scrollPain.scale9TheDragger();
      }
   }
}

