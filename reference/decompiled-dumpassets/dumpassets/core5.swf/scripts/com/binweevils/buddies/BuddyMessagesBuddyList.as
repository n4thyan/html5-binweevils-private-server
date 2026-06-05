package com.binweevils.buddies
{
   import caurina.transitions.Tweener;
   import com.binweevils.BinEvents;
   import com.binweevils.Bin_extInterface;
   import com.binweevils.CustomEvent;
   import com.binweevils.EventManager;
   import com.binweevils.STAGE;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   
   public class BuddyMessagesBuddyList implements IPagingUser
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
      
      private var searchBtn:SimpleButton;
      
      private var searchInput:TextField;
      
      private var invites:Array;
      
      private var doPopulate:Boolean = false;
      
      public function BuddyMessagesBuddyList(param1:MovieClip, param2:Object, param3:IPagingOwner)
      {
         super();
         this.init(param1,param2,param3);
      }
      
      protected function init(param1:MovieClip, param2:Object, param3:IPagingOwner) : void
      {
         Bin_extInterface.bin.webSocket.send("friends/get-list");
         EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_BUDDYLIST_RECIEVED,this.onBuddyListRecieved);
         EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_NOTIFY_NEWINVITE,this.onNewInviteNotify);
         EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_NOTIFY_BUDDYLOGIN,this.onBuddyLogin);
         EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_NOTIFY_BUDDYLOGOUT,this.onBuddyLogout);
         EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_BUDDYREQUEST_HANDLED,this.onBuddyRequestHandled);
         EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_NOTIFY_DELETED,this.onBuddyDeletedMe);
         this.container = param1;
         this.ui = param2;
         this.pager = param3;
         this.noBuddiesSpr = this.container.getChildByName("noBuddies_spr") as Sprite;
         this.searchBtn = this.container.getChildByName("search_btn") as SimpleButton;
         this.searchBtn.addEventListener(MouseEvent.CLICK,this.handleSearchClick);
         this.searchInput = this.container.getChildByName("searchInput_txt") as TextField;
         this.searchInput.addEventListener(Event.CHANGE,this.handleSearchChange);
         this.searchInput.addEventListener(MouseEvent.CLICK,this.handleSearchInputClick);
         this.listItems = [];
         EventManager.get_instance().addEventListener("buddyListStatusUpdate",this.onStatusUpdate);
         EventManager.get_instance().addEventListener("buddyListDefinitionsLoaded",this.onWeevilDefs);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.ON_BUDDY_SELECTED,this.handleBuddySelected);
      }
      
      private function onBuddyListRecieved(param1:CustomEvent) : *
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc2_:Object = param1.dataObj;
         if(_loc2_["responseCode"] == 1)
         {
            _loc3_ = new Array();
            _loc3_ = _loc2_["invites"];
            this.invites = new Array(0);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc7_ = new Object();
               _loc7_.name = _loc3_[_loc4_]["username"];
               _loc7_.idx = _loc3_[_loc4_]["idx"];
               _loc7_.weevilDef = _loc3_[_loc4_]["weevilDef"];
               _loc7_.isOnline = _loc3_[_loc4_]["on"];
               _loc7_.isInvite = true;
               this.invites.push(_loc7_);
               _loc4_++;
            }
            _loc3_ = _loc2_["buddies"];
            _loc5_ = [];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc8_ = new Object();
               _loc8_.idx = _loc3_[_loc4_]["idx"];
               _loc8_.name = _loc3_[_loc4_]["username"];
               _loc8_.weevilDef = _loc3_[_loc4_]["weevilDef"];
               _loc8_.level = _loc3_[_loc4_]["level"];
               _loc8_.tycoon = _loc3_[_loc4_]["tycoon"];
               _loc8_.lastLog = _loc3_[_loc4_]["lastLog"];
               _loc8_.isOnline = _loc3_[_loc4_]["on"];
               _loc5_.push(_loc8_);
               _loc4_++;
            }
            BuddyData.setBuddyListInfo(_loc5_);
            _loc6_ = BuddyData.getSortedList().length > 100 ? 100 : int(BuddyData.getSortedList().length);
            this.container.buddyCount_txt.text = "" + _loc6_ + "/100";
            if(this.doPopulate)
            {
               this.cleanUpList();
               this.populate();
               this.doPopulate = false;
            }
         }
      }
      
      private function onSearchResults(param1:CustomEvent) : *
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc2_:Object = param1.dataObj;
         if(_loc2_["responseCode"] == 1)
         {
            _loc3_ = new Array(1);
            _loc4_ = new Object();
            _loc4_.name = _loc2_["weevil"]["username"];
            _loc4_.idx = _loc2_["weevil"]["idx"];
            _loc4_.weevilDef = _loc2_["weevil"]["weevilDef"];
            _loc4_.isOnline = _loc2_["weevil"]["on"];
            _loc4_.searchResult = true;
            _loc3_[0] = _loc4_;
            this.cleanUpList();
            this.populate(_loc3_);
         }
      }
      
      private function handleSearchClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         if(this.searchInput.text != "")
         {
            if(BuddyData.getInfoForWeevil(this.searchInput.text) == null && this.searchInput.text != Bin_extInterface.bin.myUserName)
            {
               _loc2_ = new Object();
               _loc2_.username = this.searchInput.text;
               Bin_extInterface.bin.webSocket.send("friends/get-weevil",_loc2_);
               EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_BUDDYSEARCH_RECIEVED,this.onSearchResults);
            }
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
            if(_loc2_ != null)
            {
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
         }
         else
         {
            this.cleanUpList();
            this.populate();
         }
      }
      
      private function handleBuddySelected(param1:BuddyMessageEvent) : void
      {
         this.pager.hidePaging();
      }
      
      public function show(param1:Boolean = true) : void
      {
         if(param1)
         {
            STAGE.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            this.cleanUpList();
            if(!this.itemsHolder && BuddyData.defsHaveLoaded())
            {
               this.populate();
            }
            else if(this.itemsHolder)
            {
               this.populate();
            }
            this.pager.setPagingUser(this);
            this.onPaging();
         }
         else
         {
            STAGE.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            if(this.itemsHolder)
            {
               this.reset();
            }
         }
         this.container.visible = param1;
      }
      
      public function hide() : void
      {
         this.show(false);
      }
      
      private function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:int = 0;
         if(this.container.visible && STAGE.focus == this.searchInput)
         {
            _loc2_ = int(param1.keyCode);
            if(_loc2_ == 13)
            {
               this.handleSearchClick(null);
            }
         }
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
         var _loc5_:int = 0;
         var _loc6_:int = 0;
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
         var _loc4_:int = 0;
         if(this.invites != null)
         {
            _loc4_ = this.invites.length < 5 ? int(this.invites.length) : 5;
            if(this.invites.length > 0 && param1 == null)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  this.createInvite(_loc5_,this.invites[_loc5_]);
                  _loc5_++;
               }
               _loc3_ = _loc4_;
            }
         }
         if(_loc2_ != null)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc2_.length)
            {
               this.createItem(_loc3_ + _loc6_,_loc2_[_loc6_]);
               _loc6_++;
            }
            this.numBuddies = _loc2_.length + _loc4_;
            this.numPages = Math.ceil(this.numBuddies / this.numPerPage);
         }
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
      
      public function removeInvite(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.invites.length)
         {
            if(this.invites[_loc2_].idx == param1)
            {
               this.invites.slice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
      }
      
      private function cleanUpList() : void
      {
         var _loc2_:BuddyMessagesBuddyListItem = null;
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
      
      private function createInvite(param1:int, param2:Object) : void
      {
         var _loc3_:BuddyMessagesBuddyListItem = new BuddyMessagesBuddyListItem(this,this.newItem("buddyMessagesBuddyListItem"),param1);
         _loc3_.setInfo(param2);
         this.setItemY(param1,_loc3_);
         this.listItems[param1] = _loc3_;
         this.itemsHolder.addChild(_loc3_.getMC());
      }
      
      private function createItem(param1:int, param2:Object) : void
      {
         var _loc3_:BuddyMessagesBuddyListItem = new BuddyMessagesBuddyListItem(this,this.newItem("buddyMessagesBuddyListItem"),param1);
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
      
      private function setItemY(param1:int, param2:BuddyMessagesBuddyListItem) : void
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
         this.updateListPosition();
         this.enableDisablePaging();
         this.checkHideShowPaging();
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
      
      public function reloadList(param1:Boolean = true) : void
      {
         this.cleanUpList();
         this.doPopulate = true;
         if(param1)
         {
            Bin_extInterface.bin.webSocket.send("friends/get-list");
         }
         else
         {
            this.populate();
         }
      }
      
      private function onBuddyLogin(param1:CustomEvent) : void
      {
         var _loc2_:Object = param1.dataObj;
         var _loc3_:Array = BuddyData.getList();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_].idx == _loc2_["idx"])
            {
               _loc3_[_loc4_].isOnline = 2 - _loc2_["ws"];
               BuddyData.setBuddyListInfo(_loc3_);
               return;
            }
            _loc4_++;
         }
      }
      
      private function onBuddyLogout(param1:CustomEvent) : void
      {
         var _loc2_:Object = param1.dataObj;
         var _loc3_:Array = BuddyData.getList();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_].idx == _loc2_["idx"])
            {
               _loc3_[_loc4_].isOnline = false;
               BuddyData.setBuddyListInfo(_loc3_);
               this.reloadList(false);
               return;
            }
            _loc4_++;
         }
      }
      
      private function onBuddyDeletedMe(param1:CustomEvent) : *
      {
         var _loc2_:Object = param1.dataObj;
         Bin_extInterface.bin.get_ssclient().syncBuddy(_loc2_["username"]);
         var _loc3_:Array = BuddyData.getList();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_].idx == _loc2_["idx"])
            {
               _loc3_.splice(_loc4_,1);
            }
            _loc4_++;
         }
         BuddyData.setBuddyListInfo(_loc3_);
         this.reloadList(false);
      }
      
      private function onNewInviteNotify(param1:CustomEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         try
         {
            _loc2_ = param1.dataObj;
            _loc3_ = new Object();
            _loc3_.name = _loc2_["username"];
            _loc3_.idx = _loc2_["idx"];
            _loc3_.weevilDef = _loc2_["weevil_def"];
            _loc3_.isOnline = false;
            _loc3_.isInvite = true;
            this.invites.push(_loc3_);
            this.reloadList(false);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onBuddyRequestHandled(param1:CustomEvent) : void
      {
         var _loc2_:Object = param1.dataObj;
         Bin_extInterface.bin.get_ssclient().syncBuddy(_loc2_.username);
         this.reloadList();
      }
   }
}

