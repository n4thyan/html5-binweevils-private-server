package com.binweevils.buddies
{
   import caurina.transitions.Tweener;
   import com.binweevils.CustomEvent;
   import com.binweevils.EventManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   
   public class BuddyMessagesBuddyListConversation implements IPagingUser
   {
      
      private var ui:Object;
      
      private var container:MovieClip;
      
      private var noBuddiesSpr:Sprite;
      
      private var pager:IPagingOwner;
      
      private var numBuddies:int;
      
      private var pageNum:int;
      
      private var numPerPage:Number = 7;
      
      private var numPages:int;
      
      private var itemsHolder:MovieClip;
      
      private var listItems:Array;
      
      private const SPACING_Y:int = -2;
      
      private const FIXED_HEIGHT:int = 50;
      
      private var closeBtn:SimpleButton;
      
      private var searchInput:TextField;
      
      public function BuddyMessagesBuddyListConversation(param1:MovieClip, param2:Object, param3:IPagingOwner)
      {
         super();
         this.init(param1,param2,param3);
      }
      
      protected function init(param1:MovieClip, param2:Object, param3:IPagingOwner) : void
      {
         this.container = param1;
         this.ui = param2;
         this.pager = param3;
         this.noBuddiesSpr = this.container.getChildByName("noBuddies_spr") as Sprite;
         this.closeBtn = this.container.getChildByName("close_btn") as SimpleButton;
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.handleCloseClick);
         this.listItems = [];
         this.searchInput = this.container.getChildByName("searchInput_txt") as TextField;
         this.searchInput.addEventListener(Event.CHANGE,this.handleSearchChange);
         this.searchInput.addEventListener(MouseEvent.CLICK,this.handleSearchInputClick);
         EventManager.get_instance().addEventListener("buddyListStatusUpdate",this.onStatusUpdate);
         EventManager.get_instance().addEventListener("buddyListDefinitionsLoaded",this.onWeevilDefs);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.ON_BUDDY_SELECTED,this.handleBuddySelected);
      }
      
      private function onBuddyListRecieved(param1:CustomEvent) : *
      {
         var _loc2_:Object = param1.dataObj;
         if(_loc2_["responseCode"] == 1)
         {
         }
      }
      
      private function handleSearchInputClick(param1:MouseEvent) : void
      {
         if(this.searchInput.text == "SEARCH")
         {
            this.searchInput.text = "";
         }
      }
      
      private function handleSearchChange(param1:Event) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(this.searchInput.text != "")
         {
            _loc2_ = BuddyData.getSortedList();
            _loc3_ = new Array(0);
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc5_ = _loc2_[_loc4_].name;
               if(_loc5_.indexOf(this.searchInput.text) == 0)
               {
                  _loc3_.push(_loc2_[_loc4_]);
               }
               _loc4_++;
            }
            this.cleanUpList();
            this.populate(_loc3_);
         }
         else
         {
            this.cleanUpList();
            this.populate();
         }
      }
      
      private function handleCloseClick(param1:MouseEvent) : void
      {
         EventManager.get_instance().dispatchEvent(new BuddyMessageEvent(BuddyMessageEvent.HIDE_CONVERSATION_BUDDY_LIST));
      }
      
      private function handleBuddySelected(param1:BuddyMessageEvent) : void
      {
         this.pager.hidePaging();
      }
      
      public function show(param1:Boolean = true) : void
      {
         if(param1)
         {
            if(!this.itemsHolder && BuddyData.defsHaveLoaded())
            {
               this.populate();
            }
            this.pager.setPagingUser(this);
            this.onPaging();
         }
         else if(this.itemsHolder)
         {
            this.reset();
         }
         this.container.visible = param1;
      }
      
      public function hide() : void
      {
         this.show(false);
      }
      
      private function onWeevilDefs(param1:Event) : void
      {
         if(this.itemsHolder)
         {
            this.cleanUpList();
         }
         this.populate();
         this.reset();
         if(this.container.visible)
         {
            this.onPaging();
         }
      }
      
      private function onStatusUpdate(param1:CustomEvent) : void
      {
         if(!this.itemsHolder)
         {
            return;
         }
         this.cleanUpList();
         this.populate();
         this.reset();
         if(this.container.visible)
         {
            this.onPaging();
         }
      }
      
      private function populate(param1:Array = null) : void
      {
         var _loc2_:Array = null;
         if(!this.itemsHolder)
         {
            this.itemsHolder = this.container.holderAndMask_mc.itemsHolder_spr;
         }
         if(param1 == null)
         {
            _loc2_ = BuddyData.getSortedList();
         }
         else
         {
            _loc2_ = param1;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            this.createItem(_loc3_,_loc2_[_loc3_]);
            _loc3_++;
         }
         this.numBuddies = _loc2_.length;
         this.numPages = Math.ceil(this.numBuddies / this.numPerPage);
         if(_loc2_)
         {
            if(_loc2_.length > 0)
            {
               this.noBuddiesSpr.visible = false;
            }
            else
            {
               this.noBuddiesSpr.visible = true;
            }
         }
         else
         {
            this.noBuddiesSpr.visible = true;
         }
         this.onPaging();
      }
      
      private function cleanUpList() : void
      {
         var _loc2_:BuddyMessagesBuddyListConversationItem = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this.listItems.length)
         {
            _loc2_ = this.listItems[_loc1_];
            _loc2_.die();
            this.itemsHolder.removeChild(_loc2_.getMC());
            _loc1_++;
         }
         this.listItems = [];
         this.numPages = 0;
      }
      
      private function createItem(param1:int, param2:Object) : void
      {
         var _loc3_:BuddyMessagesBuddyListConversationItem = new BuddyMessagesBuddyListConversationItem(this,this.newItem("buddyMessagesBuddyListConversationItem"),param1);
         _loc3_.setInfo(param2);
         this.setItemY(param1,_loc3_);
         this.listItems[param1] = _loc3_;
         this.itemsHolder.addChild(_loc3_.getMC());
      }
      
      private function newItem(param1:String) : MovieClip
      {
         var _loc2_:Class = getDefinitionByName(param1) as Class;
         return new _loc2_() as MovieClip;
      }
      
      private function setItemY(param1:int, param2:BuddyMessagesBuddyListConversationItem) : void
      {
         var _loc3_:MovieClip = null;
         if(param1 > 0)
         {
            _loc3_ = this.listItems[param1 - 1].getMC();
            param2.getMC().y = _loc3_.y + (this.FIXED_HEIGHT + this.SPACING_Y);
         }
      }
      
      public function pageNext() : void
      {
         ++this.pageNum;
         this.onPaging();
      }
      
      public function pagePrev() : void
      {
         --this.pageNum;
         this.onPaging();
      }
      
      private function onPaging() : void
      {
         this.updatePagingInfo();
         this.updateListPosition();
         this.enableDisablePaging();
         this.checkHideShowPaging();
      }
      
      private function updatePagingInfo() : void
      {
         var _loc1_:uint = this.pageNum * this.numPerPage;
         var _loc2_:uint = _loc1_ + this.numPerPage > this.numBuddies ? uint(this.numBuddies) : uint(_loc1_ + this.numPerPage);
         var _loc3_:int = _loc1_ == 0 && this.numBuddies == 0 ? int(_loc1_) : _loc1_ + 1;
         this.container.pagingInfo_txt.text = "Buddy List   " + _loc3_ + "-" + _loc2_ + " of " + this.numBuddies;
      }
      
      private function updateListPosition(param1:Boolean = true) : void
      {
         if(this.listItems == null)
         {
            return;
         }
         if(this.listItems.length == 0)
         {
            return;
         }
         var _loc2_:Number = this.FIXED_HEIGHT + this.SPACING_Y;
         var _loc3_:Number = this.pageNum * this.numPerPage * _loc2_;
         if(param1)
         {
            Tweener.addTween(this.itemsHolder,{
               "y":0 - _loc3_,
               "time":0.4
            });
         }
         else
         {
            this.itemsHolder.y = 0 - _loc3_;
         }
      }
      
      private function enableDisablePaging() : void
      {
         this.pager.enableDisablePrev(this.pageNum != 0);
         this.pager.enableDisableNext(this.pageNum < this.numPages - 1);
      }
      
      private function checkHideShowPaging() : void
      {
         if(this.numBuddies <= this.numPerPage)
         {
            this.pager.hidePaging();
         }
         else
         {
            this.pager.showPaging();
         }
      }
      
      public function getUI() : Object
      {
         return this.ui;
      }
      
      private function reset() : void
      {
         Tweener.removeTweens(this.itemsHolder);
         this.itemsHolder.y = 0;
         this.pageNum = 0;
      }
   }
}

