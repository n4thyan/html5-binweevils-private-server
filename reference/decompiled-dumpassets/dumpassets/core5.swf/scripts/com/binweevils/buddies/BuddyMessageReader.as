package com.binweevils.buddies
{
   import caurina.transitions.Tweener;
   import caurina.transitions.properties.DisplayShortcuts;
   import com.binweevils.BinEvents;
   import com.binweevils.Bin_extInterface;
   import com.binweevils.CustomEvent;
   import com.binweevils.EventManager;
   import com.binweevils.STAGE;
   import com.binweevils.engine3D.visuals.creatures.weevils.Mugshots;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   
   public class BuddyMessageReader implements IPagingUser
   {
      
      public static var currentConversationID:int;
      
      private var container:Sprite;
      
      private var msgArr:Array;
      
      private var xOpen:int;
      
      private var xClosed:int = 300;
      
      private var bin:Object;
      
      private var weevilDef:String = "";
      
      private var itemsHolder:MovieClip;
      
      private var stickerPanel:StickerPanel;
      
      private var sendBtn:SimpleButton;
      
      private var stickerBtn:SimpleButton;
      
      private var chatText:TextField;
      
      private var pager:IPagingOwner;
      
      private var pageNum:int;
      
      private var numPerPage:Number = 2;
      
      private var numPages:int;
      
      private const SPACING_Y:int = 25;
      
      private var backendPageNum:* = 1;
      
      private var msgInfo:BuddyMessageInfoObject;
      
      public var itemHolderYPos:Number = 0;
      
      public function BuddyMessageReader(param1:MovieClip, param2:IPagingOwner)
      {
         super();
         this.bin = Bin_extInterface.bin;
         this.container = param1;
         this.itemsHolder = MovieClip(this.container.getChildByName("holderAndMask_mc")).itemsHolder_spr;
         this.stickerPanel = new StickerPanel(MovieClip(this.container.getChildByName("StickerPanel")),this,this.itemsHolder);
         this.sendBtn = param1.sendBtn;
         this.sendBtn.addEventListener(MouseEvent.CLICK,this.sendBtnClicked);
         this.stickerBtn = param1.StickerButton;
         this.stickerBtn.addEventListener(MouseEvent.CLICK,this.stickerBtnClicked);
         this.chatText = param1.chatText;
         this.chatText.restrict = "a-z A-Z ? ! . &";
         this.pager = param2;
         this.pageNum = 0;
         this.init();
      }
      
      private function init() : void
      {
         DisplayShortcuts.init();
         this.initListeners();
      }
      
      private function initListeners() : void
      {
         EventManager.get_instance().addEventListener(BuddyMessageEvent.ON_MESSAGE_SELECTED,this.handleMessageSelected);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.ON_COMPOSER_CLOSED,this.onComposerClosed);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.ON_MESSAGE_SENT,this.onMessageSent);
         EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_NOTIFY_NEWMESSAGE,this.onNewMessageNotify);
      }
      
      private function enableChatInput(param1:Boolean) : *
      {
         this.chatText.visible = param1;
         this.sendBtn.mouseEnabled = param1;
         var _loc2_:ColorTransform = new ColorTransform(0.5,0.5,0.5);
         if(param1)
         {
            _loc2_ = new ColorTransform();
         }
         else
         {
            _loc2_ = new ColorTransform(0.5,0.5,0.5);
         }
         MovieClip(this.container.getChildByName("chatInputBG")).transform.colorTransform = _loc2_;
         this.sendBtn.transform.colorTransform = _loc2_;
      }
      
      private function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:int = 0;
         if(this.container.visible && STAGE.focus == this.chatText)
         {
            _loc2_ = int(param1.keyCode);
            if(_loc2_ == 13)
            {
               this.sendBtnClicked(null);
            }
         }
      }
      
      private function onChatChange(param1:Event) : void
      {
         var _loc3_:* = false;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:* = false;
         var _loc8_:* = false;
         var _loc2_:String = this.chatText.text;
         if(_loc2_ != "")
         {
            if(_loc2_ == " ")
            {
               this.chatText.text = "";
               return;
            }
            _loc3_ = _loc2_.charAt(_loc2_.length - 1) == " ";
            _loc2_.replace(/\s{2,}/g," ");
            while(_loc2_.charAt(_loc2_.length - 1) == " ")
            {
               _loc2_ = _loc2_.slice(0,-1);
            }
            _loc4_ = _loc2_.split(" ");
            _loc2_ = "";
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc6_ = _loc4_[_loc5_];
               if(_loc6_.length > 1)
               {
                  _loc7_ = _loc6_.charAt(0) == _loc6_.charAt(0).toUpperCase();
                  _loc8_ = _loc6_.charAt(1) == _loc6_.charAt(1).toUpperCase();
                  if(_loc7_)
                  {
                     if(_loc8_)
                     {
                        _loc4_[_loc5_] = _loc4_[_loc5_].toUpperCase();
                     }
                     else
                     {
                        _loc4_[_loc5_] = _loc4_[_loc5_].charAt(0).toUpperCase() + _loc4_[_loc5_].substr(1).toLowerCase();
                     }
                  }
                  else
                  {
                     _loc4_[_loc5_] = _loc4_[_loc5_].toLowerCase();
                  }
               }
               _loc2_ += _loc4_[_loc5_] + " ";
               _loc5_++;
            }
            if(!_loc3_)
            {
               _loc2_ = _loc2_.slice(0,-1);
            }
            this.chatText.text = _loc2_;
         }
      }
      
      private function sendBtnClicked(param1:MouseEvent) : void
      {
         var _loc2_:BuddyMessageInfoObject = new BuddyMessageInfoObject();
         _loc2_.fromIDX = this.bin.myUserIDX;
         _loc2_.msg = this.chatText.text;
         var _loc3_:Date = new Date();
         _loc2_.timeSent = "" + _loc3_.time / 1000;
         this.pushMessageToChat(_loc2_);
         var _loc4_:Object = new Object();
         _loc4_.body = this.chatText.text;
         this.chatText.text = "";
         _loc4_.conversation_id = this.msgInfo.conversationID;
         Bin_extInterface.bin.webSocket.send("conversation/new-message",_loc4_);
         EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_NEWMESSAGESENT_RECIEVED,this.onNewMessageSent);
      }
      
      public function sendSticker(param1:int) : void
      {
         var _loc2_:BuddyMessageInfoObject = new BuddyMessageInfoObject();
         _loc2_.fromIDX = this.bin.myUserIDX;
         _loc2_.msg = "<<<st:" + param1 + ">>>";
         var _loc3_:Date = new Date();
         _loc2_.timeSent = "" + _loc3_.time / 1000;
         this.pushMessageToChat(_loc2_);
         var _loc4_:Object = new Object();
         _loc4_.body = _loc2_.msg;
         _loc4_.conversation_id = this.msgInfo.conversationID;
         Bin_extInterface.bin.webSocket.send("conversation/new-message",_loc4_);
         EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_NEWMESSAGESENT_RECIEVED,this.onNewMessageSent);
      }
      
      private function stickerBtnClicked(param1:MouseEvent) : void
      {
         this.stickerPanel.show();
      }
      
      private function onNewMessageSent(param1:CustomEvent) : void
      {
         var _loc2_:Object = param1.dataObj;
         if(_loc2_["responseCode"] == 1)
         {
         }
      }
      
      private function onNewMessageNotify(param1:CustomEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:BuddyMessageInfoObject = null;
         try
         {
            if(this.container.visible)
            {
               _loc2_ = param1.dataObj;
               if(_loc2_["conversation_id"] == this.msgInfo.conversationID)
               {
                  _loc3_ = new BuddyMessageInfoObject();
                  _loc3_.fromIDX = _loc2_["sender_idx"];
                  _loc3_.messageID = _loc2_["msg_id"];
                  _loc3_.msg = _loc2_["body"];
                  _loc3_.timeSent = _loc2_["sent_on"];
                  this.pushMessageToChat(_loc3_);
               }
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function handleMessageSelected(param1:BuddyMessageEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         this.resetMessage();
         this.pageNum = 0;
         if(param1.msgInfoArr != null)
         {
            this.msgInfo = param1.msgInfo;
            currentConversationID = this.msgInfo.conversationID;
            this.msgArr = new Array();
            _loc2_ = -1;
            _loc3_ = 0;
            while(_loc3_ < param1.msgInfoArr.length)
            {
               if(param1.msgInfoArr[_loc3_].fromIDX != this.bin.myUserIDX)
               {
                  _loc2_ = Number(param1.msgInfoArr[_loc3_].fromIDX);
               }
               this.addMessage(param1.msgInfoArr[_loc3_]);
               _loc3_++;
            }
            if(_loc2_ != -1)
            {
               this.enableChatInput(!(_loc2_ == 192170 || _loc2_ == 1408439));
            }
            this.setMessagePositions();
            this.calculateNumPages();
            (this.container.getChildByName("nameText") as TextField).text = param1.msgInfo.from;
            this.weevilDef = this.msgInfo.weevilDef;
            this.getMugshot();
            this.show();
         }
      }
      
      private function handleReplyClick(param1:MouseEvent) : void
      {
      }
      
      private function handleDeleteClick(param1:MouseEvent) : void
      {
      }
      
      private function onComposerClosed(param1:BuddyMessageEvent) : void
      {
      }
      
      private function onMessageSent(param1:BuddyMessageEvent) : void
      {
      }
      
      private function getMugshot() : void
      {
         var _loc2_:Object = null;
         var _loc1_:Bitmap = Mugshots.getMugshot(this.msgInfo.from);
         if(_loc1_ == null)
         {
            _loc2_ = {"weevilDef":this.weevilDef};
            _loc2_.king = 0;
            _loc1_ = this.bin.getWeevilMugshot(this.msgInfo.from,_loc2_,2);
         }
         this.addMugshot(_loc1_);
      }
      
      public function addMugshot(param1:Bitmap) : void
      {
         var _loc2_:MovieClip = MovieClip(this.container.getChildByName("mugshot_spr"));
         var _loc3_:Sprite = _loc2_.getChildByName("mask_spr") as Sprite;
         _loc3_.alpha = 0;
         _loc2_.addChild(param1);
         param1.name = "mugshot";
         param1.mask = _loc3_;
         param1.smoothing = true;
         param1.scaleY = param1.scaleX = 0.3;
         param1.y -= 7;
         --param1.x;
      }
      
      private function addMessage(param1:BuddyMessageInfoObject) : void
      {
         this.msgArr.push(new BuddyMessage(new buddymessage(),param1));
         this.itemsHolder.addChild(this.msgArr[this.msgArr.length - 1].getMsgSpr());
      }
      
      private function removeMessage() : void
      {
         var _loc1_:MovieClip = MovieClip(this.container.getChildByName("mugshot_spr"));
         _loc1_.removeChild(_loc1_.getChildByName("mugshot"));
         var _loc2_:int = 0;
         while(_loc2_ < this.msgArr.length)
         {
            this.itemsHolder.removeChild(this.msgArr[_loc2_].getMsgSpr());
            _loc2_++;
         }
         this.msgArr = null;
      }
      
      private function setMessagePositions() : void
      {
         var _loc1_:* = -160;
         var _loc2_:int = 0;
         while(_loc2_ < this.msgArr.length)
         {
            if(this.msgArr[_loc2_].isMine)
            {
               _loc1_ += this.msgArr[_loc2_].myMessage.height + this.SPACING_Y;
               this.msgArr[_loc2_].getMsgSpr().x = 240 - this.msgArr[_loc2_].myMessage.width;
               this.msgArr[_loc2_].getMsgSpr().y = -_loc1_ - 5;
            }
            else
            {
               _loc1_ += this.msgArr[_loc2_].buddyMessage.height + this.SPACING_Y;
               this.msgArr[_loc2_].getMsgSpr().x = -3;
               this.msgArr[_loc2_].getMsgSpr().y = -_loc1_ - 5;
            }
            _loc2_++;
         }
      }
      
      public function pushMessageToChat(param1:BuddyMessageInfoObject) : void
      {
         this.msgArr.reverse();
         this.msgArr.push(new BuddyMessage(new buddymessage(),param1));
         this.itemsHolder.addChild(this.msgArr[this.msgArr.length - 1].getMsgSpr());
         this.msgArr.reverse();
         this.setMessagePositions();
         this.calculateNumPages();
         this.pageNum = 0;
         this.onPaging();
      }
      
      public function show() : void
      {
         this.backendPageNum = 1;
         this.container.visible = true;
         this.pager.setPagingUser(this);
         this.onPaging();
         this.chatText.addEventListener(Event.CHANGE,this.onChatChange,false,0,true);
         STAGE.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
      }
      
      public function hide() : void
      {
         currentConversationID = -1;
         this.resetMessage();
         this.container.visible = false;
         this.chatText.removeEventListener(Event.CHANGE,this.onChatChange);
         STAGE.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
      }
      
      public function pageNext() : void
      {
         this.stickerPanel.hide();
         ++this.pageNum;
         this.onPaging();
      }
      
      public function pagePrev() : void
      {
         this.stickerPanel.hide();
         --this.pageNum;
         this.onPaging();
         this.getNextMessages();
      }
      
      private function getNextMessages() : void
      {
         var _loc1_:Object = null;
         if(Math.abs(this.pageNum) == this.backendPageNum * 2)
         {
            _loc1_ = new Object();
            _loc1_.conversation_id = this.msgInfo.conversationID;
            _loc1_.page = this.backendPageNum + 1;
            Bin_extInterface.bin.webSocket.send("conversation/load",_loc1_);
            EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_CONVERSATION_RECIEVED,this.onConversationRecieved);
         }
      }
      
      private function onConversationRecieved(param1:CustomEvent) : void
      {
         var _loc3_:Array = null;
         var _loc4_:BuddyMessageInfoObject = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         EventManager.get_instance().removeEventListener(BinEvents.WEB_SOCKET_CONVERSATION_RECIEVED,this.onConversationRecieved);
         var _loc2_:Object = param1.dataObj;
         if(_loc2_["responseCode"] == 1)
         {
            if(_loc2_["messages"] != null)
            {
               _loc3_ = _loc2_["messages"];
               if(_loc3_ != null)
               {
                  _loc5_ = new Array();
                  _loc6_ = 0;
                  while(_loc6_ < _loc3_.length)
                  {
                     _loc4_ = new BuddyMessageInfoObject();
                     _loc4_.conversationID = _loc3_[_loc6_]["id"];
                     _loc4_.fromIDX = _loc3_[_loc6_]["sender_idx"];
                     _loc4_.msg = _loc3_[_loc6_]["body"];
                     _loc4_.isDeleted = _loc3_[_loc6_]["deleted"];
                     _loc4_.timeSent = _loc3_[_loc6_]["sent_on"];
                     _loc4_.messageID = _loc3_[_loc6_]["id"];
                     _loc5_.push(_loc4_);
                     this.addMessage(_loc4_);
                     _loc6_++;
                  }
                  this.msgArr.concat(_loc5_);
               }
               this.setMessagePositions();
               ++this.backendPageNum;
               this.calculateNumPages();
               this.onPaging();
            }
         }
      }
      
      private function calculateNumPages() : void
      {
         var _loc3_:BuddyMessage = null;
         var _loc1_:Number = -20;
         var _loc2_:int = 0;
         while(_loc2_ < this.msgArr.length)
         {
            _loc3_ = this.msgArr[_loc2_];
            if(_loc3_.isMine)
            {
               _loc1_ += _loc3_.myMessage.height + this.SPACING_Y;
            }
            else
            {
               _loc1_ += _loc3_.buddyMessage.height + this.SPACING_Y;
            }
            _loc2_++;
         }
         this.numPages = Math.ceil(_loc1_ / 300);
      }
      
      private function onPaging() : void
      {
         this.updateListPosition();
         this.enableDisablePaging();
         this.checkHideShowPaging();
      }
      
      private function updateListPosition(param1:Boolean = true) : void
      {
         if(this.msgArr == null)
         {
            return;
         }
         if(this.msgArr.length == 0)
         {
            return;
         }
         var _loc2_:Number = this.pageNum * 300;
         if(param1)
         {
            Tweener.addTween(this.itemsHolder,{
               "y":this.itemHolderYPos - _loc2_,
               "time":0.4
            });
         }
         else
         {
            this.itemsHolder.y = this.itemHolderYPos - _loc2_;
         }
      }
      
      private function enableDisablePaging() : void
      {
         this.pager.enableDisablePrev(this.pageNum > -this.numPages + 1);
         this.pager.enableDisableNext(this.pageNum < 0);
      }
      
      private function checkHideShowPaging() : void
      {
         if(this.msgArr.length <= this.numPerPage)
         {
            this.pager.hidePaging();
         }
         else
         {
            this.pager.showPaging();
         }
      }
      
      private function enableDisableButton(param1:SimpleButton, param2:Boolean) : void
      {
         param1.mouseEnabled = param2;
         param1.alpha = param2 ? 1 : 0.3;
      }
      
      public function resetMessage() : void
      {
         if(this.msgArr != null)
         {
            this.removeMessage();
         }
      }
      
      private function resetButtons() : void
      {
      }
   }
}

