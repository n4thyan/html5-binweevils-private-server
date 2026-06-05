package com.binweevils.buddies
{
   import caurina.transitions.Tweener;
   import com.binweevils.BinEvents;
   import com.binweevils.Bin_extInterface;
   import com.binweevils.CustomEvent;
   import com.binweevils.EventManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class BuddyMessagesBuddyListConversationItem
   {
      
      private const MUGSHOT_INDENT_X:int = 10;
      
      private const MUGSHOT_WIDTH:int = 40;
      
      private const PADDING_ICON:int = 4;
      
      private const DELAY_LOAD_ICON:Number = 0.1;
      
      private const COLOUR_ONLINE:Number = 255;
      
      private const COLOUR_OFFLINE:Number = 8560045;
      
      private var bin:Object;
      
      private var buddyList:BuddyMessagesBuddyListConversation;
      
      private var itemMC:MovieClip;
      
      private var nameTxt:TextField;
      
      private var info:Object;
      
      private var loadNum:int;
      
      private var mugshotSpr:Sprite;
      
      private var mugshotMaskSpr:Sprite;
      
      private var weevilDef:String;
      
      private var conversationID:int;
      
      public function BuddyMessagesBuddyListConversationItem(param1:BuddyMessagesBuddyListConversation, param2:MovieClip, param3:int)
      {
         super();
         this.itemMC = param2;
         this.nameTxt = this.itemMC.name_txt;
         this.bin = Bin_extInterface.bin;
         this.buddyList = param1;
         this.loadNum = param3;
         this.itemMC.mouseChildren = true;
         this.mugshotSpr = this.itemMC.getChildByName("mugshot_spr") as Sprite;
         this.mugshotMaskSpr = this.mugshotSpr.getChildByName("mask_spr") as Sprite;
         this.mugshotMaskSpr.alpha = 0;
         MovieClip(this.itemMC.newMessageBtn).addEventListener(MouseEvent.CLICK,this.handleNewMessageClicked);
         MovieClip(this.itemMC.newMessageBtn).buttonMode = true;
         MovieClip(this.itemMC.newMessageBtn).mouseEnabled = true;
      }
      
      private function handleNewMessageClicked(param1:MouseEvent) : void
      {
         MovieClip(this.itemMC.newMessageBtn).removeEventListener(MouseEvent.CLICK,this.handleNewMessageClicked);
         var _loc2_:Object = new Object();
         _loc2_.recipient_idx = this.info.idx;
         Bin_extInterface.bin.webSocket.send("conversation/new",_loc2_);
         EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_CREATECONVERSATION_RECIEVED,this.onConversationCreated);
      }
      
      private function onConversationCreated(param1:CustomEvent) : *
      {
         var _loc3_:Object = null;
         var _loc2_:Object = param1.dataObj;
         if(_loc2_["responseCode"] == 1)
         {
            _loc3_ = new Object();
            _loc3_.conversation_id = _loc2_["id"];
            this.conversationID = _loc2_["id"];
            _loc3_.page = 1;
            Bin_extInterface.bin.webSocket.send("conversation/load",_loc3_);
            EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_CONVERSATION_RECIEVED,this.onConversationRecieved);
         }
      }
      
      private function onConversationRecieved(param1:CustomEvent) : void
      {
         var _loc3_:BuddyMessageEvent = null;
         var _loc4_:Array = null;
         var _loc5_:BuddyMessageInfoObject = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc2_:Object = param1.dataObj;
         if(_loc2_["responseCode"] == 1)
         {
            _loc3_ = new BuddyMessageEvent(BuddyMessageEvent.ON_MESSAGE_SELECTED);
            if(_loc2_["messages"] != null)
            {
               _loc4_ = _loc2_["messages"];
               if(_loc4_ != null)
               {
                  _loc6_ = new Array();
                  _loc7_ = 0;
                  while(_loc7_ < _loc4_.length)
                  {
                     _loc5_ = new BuddyMessageInfoObject();
                     _loc5_.conversationID = _loc4_[_loc7_]["id"];
                     _loc5_.from = this.nameTxt.text;
                     _loc5_.fromIDX = _loc4_[_loc7_]["sender_idx"];
                     _loc5_.msg = _loc4_[_loc7_]["body"];
                     _loc5_.isNew = _loc4_[_loc7_]["deleted"];
                     _loc5_.timeSent = _loc4_[_loc7_]["sent_on"];
                     _loc6_.push(_loc5_);
                     _loc7_++;
                  }
                  _loc3_.msgInfoArr = _loc6_;
               }
            }
            _loc3_.msgInfo = new BuddyMessageInfoObject();
            _loc3_.msgInfo.from = this.nameTxt.text;
            _loc3_.msgInfo.weevilDef = this.weevilDef;
            _loc3_.msgInfo.conversationID = this.conversationID;
            this.buddyList.hide();
            EventManager.get_instance().dispatchEvent(_loc3_);
         }
      }
      
      public function getMC() : MovieClip
      {
         return this.itemMC;
      }
      
      public function setInfo(param1:Object) : void
      {
         this.info = param1;
         this.weevilDef = param1.weevilDef;
         this.setName(param1.name);
         this.setOnline(param1.isOnline);
         Tweener.addTween(this.itemMC,{
            "delay":this.DELAY_LOAD_ICON * this.loadNum,
            "onComplete":this.addMugshot,
            "onCompleteParams":[param1.weevilDef]
         });
      }
      
      private function setName(param1:String) : void
      {
         this.nameTxt.multiline = true;
         this.nameTxt.wordWrap = true;
         this.nameTxt.autoSize = TextFieldAutoSize.NONE;
         this.nameTxt.htmlText = param1;
      }
      
      public function getName() : String
      {
         return this.info.name;
      }
      
      public function setOnline(param1:Boolean) : void
      {
         this.itemMC.onlineIndicator.visible = param1;
      }
      
      private function addMugshot(param1:String) : void
      {
         var _loc3_:Bitmap = null;
         var _loc2_:BitmapData = BuddyMugshots.getMugshotData(param1);
         if(_loc2_)
         {
            _loc3_ = new Bitmap(BuddyMugshots.getMugshotData(param1),"auto",true);
         }
         else
         {
            _loc3_ = this.bin.getWeevilMugshot(null,{"weevilDef":param1},0);
            BuddyMugshots.setMugshotData(param1,_loc3_.bitmapData);
         }
         this.mugshotSpr.addChildAt(_loc3_,this.mugshotSpr.getChildIndex(this.mugshotMaskSpr));
         _loc3_.mask = this.mugshotMaskSpr;
         _loc3_.smoothing = true;
         _loc3_.width = _loc3_.height = 42;
         _loc3_.y = -4;
         _loc3_.x = -2;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:BuddyMessageInfoObject = null;
         var _loc3_:BuddyMessageEvent = null;
         if(this.info.lastLog == undefined && this.info.level == undefined)
         {
            this.buddyList.getUI().listedUserInvalid("newBuddyList",this.getName());
         }
         else
         {
            _loc2_ = new BuddyMessageInfoObject();
            _loc2_.from = this.getName();
            _loc2_.fromIDX = this.info.idx;
            _loc3_ = new BuddyMessageEvent(BuddyMessageEvent.ON_BUDDY_SELECTED);
            _loc3_.msgInfo = _loc2_;
            EventManager.get_instance().dispatchEvent(_loc3_);
         }
      }
      
      public function die() : void
      {
         this.itemMC.removeEventListener(MouseEvent.CLICK,this.onClick);
      }
   }
}

