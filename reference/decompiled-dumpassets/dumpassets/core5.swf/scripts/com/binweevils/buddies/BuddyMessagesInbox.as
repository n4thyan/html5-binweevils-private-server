package com.binweevils.buddies
{
   import caurina.transitions.Tweener;
   import com.binweevils.BinEvents;
   import com.binweevils.Bin_extInterface;
   import com.binweevils.CustomEvent;
   import com.binweevils.DBaccess.PHPcall;
   import com.binweevils.EventManager;
   import com.binweevils.utilities.ToolTipEvent;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BuddyMessagesInbox implements IPagingUser
   {
      
      private var numMessages:uint;
      
      private var bin:Object;
      
      private var container:MovieClip;
      
      private var itemsHolderSpr:Sprite;
      
      private var teasers:Array = [];
      
      private var newMessageBtn:SimpleButton;
      
      private var hasLoaded:Boolean;
      
      private var checkInterval:int;
      
      private var highestUnreadMessageIDX:int;
      
      private var numPerPage:Number = 6;
      
      private var pageNum:int = 0;
      
      private var numPages:uint;
      
      private var backendPageNum:* = 0;
      
      private const START_Y:int = 0;
      
      private const SPACING_Y:int = 2;
      
      private const X_TEASER:int = 0;
      
      private var pager:IPagingOwner;
      
      private const INTERVAL_PING_FOR_NEW:int = 60000;
      
      private var selectedTeaser:BuddyMessageTeaser;
      
      private var teasersToLoad:Array;
      
      private var nextLoadingIndex:int;
      
      private var loadingTeaserImages:Boolean;
      
      public function BuddyMessagesInbox(param1:MovieClip, param2:IPagingOwner)
      {
         super();
         this.container = param1;
         this.pager = param2;
         this.init();
      }
      
      private function init() : void
      {
         this.bin = Bin_extInterface.bin;
         this.itemsHolderSpr = this.container.holderAndMask_mc.getChildByName("itemsHolder_spr") as Sprite;
         this.newMessageBtn = this.container.getChildByName("newMessage_btn") as SimpleButton;
         this.newMessageBtn.addEventListener(MouseEvent.CLICK,this.handleNewMessageClick);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.DELETE_MESSAGE,this.handleDeleteRequest);
         this.registerForTooltips();
      }
      
      private function registerForTooltips() : void
      {
         var _loc1_:ToolTipEvent = new ToolTipEvent(ToolTipEvent.REGISTER_TOOLTIP);
         _loc1_.io = this.newMessageBtn;
         _loc1_.x = 745;
         _loc1_.y = 395;
         _loc1_.tipText = "New Message";
         EventManager.get_instance().dispatchEvent(_loc1_);
      }
      
      private function setNoMessagesText(param1:String) : void
      {
         this.container.noMessages_spr.visible = true;
         this.container.noMessages_spr.text = param1;
      }
      
      private function getMessagesPage() : void
      {
         var _loc1_:Object = null;
         if(Math.abs(this.pageNum) == this.backendPageNum * 2 - 1 || this.backendPageNum == 0)
         {
            this.setNoMessagesText("Loading...");
            _loc1_ = new Object();
            _loc1_.page = this.backendPageNum + 1;
            ++this.backendPageNum;
            Bin_extInterface.bin.webSocket.send("conversation/list",_loc1_);
            EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_CONVERSATIONLIST_RECIEVED,this.onConversationListRecieved);
         }
      }
      
      private function onUnreadMsgResponse(param1:Object) : void
      {
         if(param1.res > 0 && param1.id > this.highestUnreadMessageIDX)
         {
            this.highestUnreadMessageIDX = param1.id;
            this.teasers = [];
            this.backendPageNum = 0;
            this.getMessagesPage();
         }
         else if(!this.hasLoaded)
         {
            this.getMessagesPage();
         }
      }
      
      private function shoutNumNew(param1:int) : void
      {
         var _loc2_:BuddyMessageEvent = new BuddyMessageEvent(BuddyMessageEvent.ON_NUM_NEW_MESSAGES,true);
         _loc2_.numNew = param1;
         EventManager.get_instance().dispatchEvent(_loc2_);
      }
      
      private function onConversationListRecieved(param1:CustomEvent) : *
      {
         var _loc3_:Array = null;
         var _loc4_:BuddyMessageInfoObject = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc2_:Object = param1.dataObj;
         if(_loc2_["responseCode"] == 1)
         {
            this.hasLoaded = true;
            if(_loc2_["conversations"] != null)
            {
               _loc3_ = _loc2_["conversations"];
               if(_loc3_ == null)
               {
                  this.noMessages();
                  this.setNoMessagesText("No conversations");
               }
               else
               {
                  this.container.noMessages_spr.visible = false;
                  _loc5_ = [];
                  _loc6_ = 0;
                  while(_loc6_ < _loc3_.length)
                  {
                     _loc4_ = new BuddyMessageInfoObject();
                     _loc4_.conversationID = _loc3_[_loc6_]["id"];
                     _loc4_.from = _loc3_[_loc6_]["username"];
                     _loc4_.fromIDX = _loc3_[_loc6_]["idx"];
                     _loc4_.weevilDef = _loc3_[_loc6_]["weevil_def"];
                     _loc4_.msg = _loc3_[_loc6_]["body"];
                     _loc4_.isNew = _loc3_[_loc6_]["new"];
                     _loc4_.isDeleted = _loc3_[_loc6_]["deleted"];
                     _loc4_.timeSent = _loc3_[_loc6_]["sent_on"];
                     _loc5_[_loc6_] = _loc4_;
                     _loc6_++;
                  }
                  _loc5_ = this.sortMessages(_loc5_);
                  this.createMessageList(_loc5_);
                  this.numMessages = this.teasers.length;
                  this.numPages = Math.ceil(this.numMessages / this.numPerPage);
                  this.onPaging();
                  this.checkHideShowPaging();
               }
            }
         }
      }
      
      private function sortMessages(param1:Array) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:BuddyMessageInfoObject = null;
         if(param1.length > 1)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = 0;
               while(_loc3_ < param1.length - 1)
               {
                  _loc4_ = Number(param1[_loc3_ + 1].timeSent);
                  _loc5_ = Number(param1[_loc3_].timeSent);
                  if(_loc5_ < _loc4_)
                  {
                     _loc6_ = param1[_loc3_];
                     param1[_loc3_] = param1[_loc3_ + 1];
                     param1[_loc3_ + 1] = _loc6_;
                  }
                  _loc3_++;
               }
               _loc2_++;
            }
         }
         return param1;
      }
      
      private function onMessages(param1:Object) : void
      {
         var _loc2_:int = this.pageNum;
         this.hasLoaded = true;
         if(param1.success == "false")
         {
            this.noMessages();
         }
         else if(this.validateMessageListFromBuddies(param1))
         {
            if(param1.numMessages == 0)
            {
               this.noMessages();
            }
            else
            {
               this.parseMessageData(param1);
            }
         }
      }
      
      private function handleMessageSelected(param1:BuddyMessageEvent) : void
      {
      }
      
      private function handleNewMessageClick(param1:MouseEvent) : void
      {
         EventManager.get_instance().dispatchEvent(new BuddyMessageEvent(BuddyMessageEvent.SHOW_CONVERSATION_BUDDY_LIST));
      }
      
      private function enableDisableButton(param1:SimpleButton, param2:Boolean) : void
      {
         param1.mouseEnabled = param2;
         param1.alpha = param2 ? 1 : 0.3;
      }
      
      private function validateMessageListFromBuddies(param1:Object) : Boolean
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:Number = Number(param1.numMessages);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = String(param1["from" + _loc4_]);
            _loc6_ = int(param1["fromIDX" + _loc4_]);
            if(!this.bin.isOnBuddyList(_loc5_) && !this.isFamousWeevil(_loc6_))
            {
               _loc2_.push(param1["id" + _loc4_]);
            }
            _loc4_++;
         }
         if(_loc2_.length == 0)
         {
            return true;
         }
         new PHPcall("buddy-messages/delete-no-from-buddy",true).sendAndAwaitResponse(["ids"],[_loc2_.toString()],this.onMessages);
         return false;
      }
      
      private function isFamousWeevil(param1:Number) : Boolean
      {
         var _loc2_:Array = new Array();
         _loc2_.push(192170);
         _loc2_.push(1162302);
         _loc2_.push(1408439);
         _loc2_.push(1914039);
         _loc2_.push(1914029);
         _loc2_.push(211975399);
         if(_loc2_.indexOf(param1) == -1)
         {
            return false;
         }
         return true;
      }
      
      private function noMessages() : void
      {
         var _loc1_:int = 0;
         if(this.teasers != null)
         {
            if(this.teasers.length > 0)
            {
               _loc1_ = int(this.teasers.length - 1);
               while(_loc1_ > 0)
               {
                  this.removeItem(this.teasers[_loc1_] as BuddyMessageTeaser);
                  _loc1_--;
               }
            }
         }
         this.numMessages = 0;
         Tweener.removeTweens(this.itemsHolderSpr);
         this.itemsHolderSpr.y = 0;
         this.shoutNumNew(0);
      }
      
      private function parseMessageData(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:BuddyMessageInfoObject = null;
         var _loc7_:BuddyMessageTeaser = null;
         var _loc8_:int = 0;
         var _loc9_:MovieClip = null;
         var _loc10_:int = 0;
         var _loc11_:BuddyMessageInfoObject = null;
         var _loc12_:int = 0;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc4_:Array = [];
         var _loc5_:Object = {};
         var _loc6_:Array = [];
         _loc8_ = 0;
         while(_loc8_ < param1.numMessages)
         {
            _loc3_ = new BuddyMessageInfoObject();
            _loc3_.conversationID = param1["id" + _loc8_];
            _loc3_.from = param1["from" + _loc8_];
            _loc3_.fromIDX = param1["fromIDX" + _loc8_];
            _loc3_.msg = param1["msg" + _loc8_];
            _loc3_.isNew = param1["read" + _loc8_];
            if(_loc3_.isNew == 0)
            {
               _loc2_++;
            }
            _loc3_.timeSent = param1["timeSent" + _loc8_];
            _loc4_[_loc8_] = _loc3_;
            _loc5_[_loc3_.conversationID] = _loc3_;
            _loc6_[_loc8_] = _loc3_.conversationID;
            _loc8_++;
         }
         this.shoutNumNew(_loc2_);
         if(this.teasers == null)
         {
            this.teasers = [];
            this.createMessageList(_loc4_);
            this.numMessages = this.teasers.length;
         }
         else
         {
            _loc10_ = int(this.teasers.length);
            if(_loc10_ > 0)
            {
               _loc8_ = _loc10_ - 1;
               while(_loc8_ >= 0)
               {
                  _loc7_ = BuddyMessageTeaser(this.teasers[_loc8_]);
                  _loc12_ = int(_loc7_.getMsgInfo().conversationID);
                  if(_loc6_.indexOf(_loc12_) == -1)
                  {
                     this.removeItem(_loc7_);
                  }
                  else
                  {
                     _loc11_ = _loc5_[_loc12_];
                     if(_loc11_.isNew == 1 && _loc7_.getMsgInfo().isNew == 0)
                     {
                        _loc7_.getMsgInfo().isNew = 1;
                        _loc7_.showRead(true);
                     }
                     _loc6_.splice(_loc6_.indexOf(_loc12_),1);
                  }
                  _loc8_--;
               }
            }
            if(_loc6_.length > 0)
            {
               _loc14_ = 0;
               _loc6_.sort(Array.DESCENDING);
               if(this.teasers[0] != null)
               {
                  _loc14_ = BuddyMessageTeaser(this.teasers[0]).getMC().y;
               }
               _loc8_ = 0;
               while(_loc8_ < _loc6_.length)
               {
                  _loc9_ = new msgteaser() as MovieClip;
                  _loc7_ = new BuddyMessageTeaser(_loc9_,BuddyMessageInfoObject(_loc5_[_loc6_[_loc8_]]));
                  this.teasers.unshift(_loc7_);
                  _loc9_.y = _loc14_ - (_loc9_.height + this.SPACING_Y);
                  _loc9_.x = this.X_TEASER;
                  this.itemsHolderSpr.addChild(_loc9_);
                  _loc14_ = _loc9_.y;
                  _loc8_++;
               }
            }
            this.numMessages = this.teasers.length;
            _loc8_ = 0;
            while(_loc8_ < this.numMessages)
            {
               _loc7_ = this.teasers[_loc8_] as BuddyMessageTeaser;
               _loc9_ = _loc7_.getMC();
               _loc13_ = _loc8_ * (_loc9_.height + this.SPACING_Y);
               Tweener.addTween(_loc9_,{
                  "y":_loc13_,
                  "time":0.15
               });
               _loc8_++;
            }
         }
         this.numPages = Math.ceil(this.numMessages / this.numPerPage);
         this.updatePagingInfo();
         this.enableDisablePaging();
         this.checkHideShowPaging();
         this.container.noMessages_spr.visible = false;
      }
      
      private function createMessageList(param1:Array) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc6_:BuddyMessageTeaser = null;
         this.numPages = Math.ceil(param1.length / this.numPerPage);
         var _loc4_:int = int(this.teasers.length);
         var _loc5_:uint = 0;
         while(_loc5_ < param1.length)
         {
            _loc2_ = new msgteaser() as MovieClip;
            _loc6_ = new BuddyMessageTeaser(_loc2_,BuddyMessageInfoObject(param1[_loc5_]));
            if(this.teasers.length > 0)
            {
               _loc3_ = BuddyMessageTeaser(this.teasers[_loc4_ + (_loc5_ - 1)]).getMC();
               _loc2_.y = _loc3_.y + _loc3_.height + this.SPACING_Y;
            }
            else
            {
               _loc2_.y = this.START_Y;
            }
            _loc2_.x = this.X_TEASER;
            this.itemsHolderSpr.addChild(_loc2_);
            this.teasers[_loc4_ + _loc5_] = _loc6_;
            _loc5_++;
         }
         EventManager.get_instance().addEventListener(BuddyMessageEvent.ON_MESSAGE_SELECTED,this.handleMessageSelected);
      }
      
      private function removeItem(param1:BuddyMessageTeaser) : void
      {
         if(param1 == this.selectedTeaser)
         {
         }
         this.itemsHolderSpr.removeChild(param1.getMC());
         var _loc2_:int = int(this.teasers.indexOf(param1));
         this.teasers.splice(_loc2_,1);
      }
      
      private function addItem(param1:BuddyMessageInfoObject) : void
      {
      }
      
      public function pageNext() : void
      {
         ++this.pageNum;
         this.onPaging();
         this.getMessagesPage();
      }
      
      public function pagePrev() : void
      {
         --this.pageNum;
         this.onPaging();
      }
      
      private function onPaging() : void
      {
         this.updatePagingInfo();
         this.updateMsgListPosition();
         this.enableDisablePaging();
      }
      
      private function updatePagingInfo() : void
      {
         var _loc1_:uint = this.pageNum * this.numPerPage;
         var _loc2_:uint = _loc1_ + this.numPerPage > this.numMessages ? this.numMessages : uint(_loc1_ + this.numPerPage);
         var _loc3_:int = _loc1_ == 0 && this.numMessages == 0 ? int(_loc1_) : _loc1_ + 1;
         this.container.pagingInfo_txt.text = _loc3_ + "-" + _loc2_ + " of " + this.numMessages;
         if(this.numMessages == 0)
         {
            this.noMessages();
            return;
         }
         this.startLoadingPageImages();
      }
      
      private function updateMsgListPosition(param1:Boolean = true) : void
      {
         var _loc2_:Number = this.teasers[0].getMC().height + this.SPACING_Y;
         var _loc3_:Number = this.pageNum * this.numPerPage * _loc2_;
         if(param1)
         {
            Tweener.addTween(this.itemsHolderSpr,{
               "y":this.START_Y - _loc3_,
               "time":0.4
            });
         }
         else
         {
            this.itemsHolderSpr.y = this.START_Y - _loc3_;
         }
      }
      
      private function enableDisablePaging() : void
      {
         this.pager.enableDisablePrev(this.pageNum != 0);
         this.pager.enableDisableNext(this.pageNum < this.numPages - 1);
      }
      
      private function startLoadingPageImages() : void
      {
         var _loc1_:int = 0;
         if(this.pageNum == 0 || this.pageNum % 5 == 0)
         {
            _loc1_ = (this.pageNum + 5) * this.numPerPage + 1;
         }
         else
         {
            _loc1_ = (this.pageNum + 1) * this.numPerPage + 1;
         }
         this.teasersToLoad = new Array();
         this.nextLoadingIndex = 0;
         var _loc2_:int = this.pageNum * this.numPerPage;
         if(_loc1_ > this.teasers.length)
         {
            _loc1_ = int(this.teasers.length);
         }
         var _loc3_:int = _loc2_;
         while(_loc3_ < _loc1_)
         {
            this.teasersToLoad.push(this.teasers[_loc3_]);
            _loc3_++;
         }
         if(!this.loadingTeaserImages)
         {
            this.loadingTeaserImages = true;
            this.loadTeaserImage();
         }
      }
      
      private function loadTeaserImage() : void
      {
         var _loc1_:BuddyMessageTeaser = null;
         if(this.nextLoadingIndex >= this.teasersToLoad.length)
         {
            this.loadingTeaserImages = false;
         }
         else
         {
            _loc1_ = this.teasersToLoad[this.nextLoadingIndex];
            ++this.nextLoadingIndex;
            _loc1_.loadImage(this.loadTeaserImage);
         }
      }
      
      private function handleDeleteRequest(param1:BuddyMessageEvent) : void
      {
         var _loc5_:MovieClip = null;
         var _loc6_:BuddyMessageTeaser = null;
         var _loc2_:int = int(param1.msgInfo.conversationID);
         new PHPcall("buddy-messages/delete",true).fireAndForget(["id"],[_loc2_]);
         this.itemsHolderSpr.removeChild(this.selectedTeaser.getMC());
         var _loc3_:int = this.selectedTeaser.getMC().height + this.SPACING_Y;
         var _loc4_:int = int(this.teasers.indexOf(this.selectedTeaser));
         var _loc7_:uint = uint(_loc4_ + 1);
         while(_loc7_ < this.numMessages)
         {
            _loc6_ = this.teasers[_loc7_] as BuddyMessageTeaser;
            _loc5_ = _loc6_.getMC();
            Tweener.addTween(_loc5_,{
               "y":_loc5_.y - _loc3_,
               "time":0.15
            });
            _loc7_++;
         }
         this.teasers.splice(_loc4_,1);
         this.numMessages = this.teasers.length;
         if(this.teasers.length == 0)
         {
            this.teasers = null;
         }
         this.selectedTeaser = null;
         this.numPages = Math.ceil(this.numMessages / this.numPerPage);
         if(this.pageNum == this.numPages && this.pageNum > 0)
         {
            --this.pageNum;
         }
         this.updatePagingInfo();
         this.enableDisablePaging();
         this.checkHideShowPaging();
         if(this.numMessages > 0)
         {
            this.updateMsgListPosition();
         }
         else
         {
            this.noMessages();
         }
      }
      
      public function show(param1:Boolean = true) : void
      {
         this.backendPageNum = 0;
         this.teasers = [];
         this.getMessagesPage();
         if(param1)
         {
            this.reset();
         }
         this.container.visible = true;
      }
      
      public function hide() : void
      {
         while(this.itemsHolderSpr.numChildren > 0)
         {
            this.itemsHolderSpr.removeChildAt(0);
         }
         this.container.visible = false;
      }
      
      private function checkHideShowPaging() : void
      {
         if(this.numMessages <= this.numPerPage)
         {
            this.pager.hidePaging();
         }
         else
         {
            this.pager.showPaging();
         }
      }
      
      private function reset() : void
      {
         this.pager.setPagingUser(this);
         Tweener.removeTweens(this.itemsHolderSpr);
         this.itemsHolderSpr.y = 0;
         this.pageNum = 0;
         this.checkHideShowPaging();
         this.enableDisablePaging();
         this.updatePagingInfo();
         if(this.selectedTeaser)
         {
            this.selectedTeaser.reset();
         }
         this.selectedTeaser = null;
      }
   }
}

