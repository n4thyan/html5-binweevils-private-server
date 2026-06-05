package com.binweevils.buddies
{
   import com.binweevils.BinEvents;
   import com.binweevils.Bin_extInterface;
   import com.binweevils.CustomEvent;
   import com.binweevils.EventManager;
   import com.binweevils.engine3D.visuals.creatures.weevils.Mugshots;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class BuddyMessageTeaser
   {
      
      private var bin:Object;
      
      private var mc:MovieClip;
      
      private var bgMC:MovieClip;
      
      private var mugshotSpr:Sprite;
      
      private var mugshotMaskSpr:Sprite;
      
      private var msgInfo:BuddyMessageInfoObject;
      
      private var fromTxtReg:TextField;
      
      private var teaserTxtReg:TextField;
      
      private var dateTxtReg:TextField;
      
      private var alphaRead:Number = 0.5;
      
      private var weevilFactoryReady:Boolean;
      
      private var imageLoadedCallBack:Function;
      
      private var mugshotBmp:Bitmap;
      
      private var weevilDef:String = "";
      
      private var conversationID:int;
      
      public function BuddyMessageTeaser(param1:MovieClip, param2:BuddyMessageInfoObject)
      {
         super();
         this.mc = param1;
         this.msgInfo = param2;
         this.weevilDef = this.msgInfo.weevilDef;
         this.init();
      }
      
      private function init() : void
      {
         this.bin = Bin_extInterface.bin;
         this.mc.mouseChildren = false;
         this.mc.tabEnabled = false;
         this.bgMC = this.mc.getChildByName("bg_mc") as MovieClip;
         this.doRollOut();
         this.setFromText();
         this.setTeaserText();
         this.setDateText();
         this.initFormatting();
         this.initListeners();
         this.weevilFactoryReady = this.bin.creatureAssets != null;
         if(this.weevilFactoryReady)
         {
            this.getMugshot();
         }
         else
         {
            EventManager.get_instance().addEventListener("bin_weevilFactoryReady",this.onWeevilFactoryReady);
         }
      }
      
      public function loadImage(param1:Function) : void
      {
         this.imageLoadedCallBack = param1;
         this.weevilFactoryReady = this.bin.creatureAssets != null;
         if(this.weevilFactoryReady)
         {
            this.getMugshot();
         }
         else
         {
            EventManager.get_instance().addEventListener("bin_weevilFactoryReady",this.onWeevilFactoryReady);
         }
      }
      
      private function imageLoaded() : void
      {
      }
      
      private function setFromText() : void
      {
         this.fromTxtReg = this.mc.getChildByName("fromReg_txt") as TextField;
         this.fromTxtReg.text = this.msgInfo.from;
      }
      
      private function setTeaserText() : void
      {
         this.teaserTxtReg = this.mc.getChildByName("teaserReg_txt") as TextField;
         this.teaserTxtReg.text = this.msgInfo.msg.substr(0,80);
         if(this.teaserTxtReg.text.search("<<<st:") != -1)
         {
            this.teaserTxtReg.text = "sticker";
         }
         if(this.msgInfo.isDeleted)
         {
            this.teaserTxtReg.text = "Deleted";
         }
         if(this.msgInfo.msg.length > 80)
         {
            this.teaserTxtReg.appendText("...");
         }
      }
      
      private function setDateText() : void
      {
         this.dateTxtReg = this.mc.getChildByName("dateReg_txt") as TextField;
         var _loc1_:Date = new Date(Number(this.msgInfo.timeSent) * 1000);
         var _loc2_:String = "" + _loc1_.getDate() + "/" + (_loc1_.getMonth() + 1) + "/" + _loc1_.getFullYear() + " " + (_loc1_.getHours() < 10 ? "0" + _loc1_.getHours() : _loc1_.getHours()) + ":" + (_loc1_.getMinutes() < 10 ? "0" + _loc1_.getMinutes() : _loc1_.getMinutes());
         this.dateTxtReg.text = _loc2_;
      }
      
      private function initFormatting() : void
      {
         this.showRead(this.msgInfo.isNew == 1);
      }
      
      private function initListeners() : void
      {
         this.enable();
         EventManager.get_instance().addEventListener(BuddyMessageEvent.ON_MESSAGE_SELECTED,this.handleMessageSelected);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.ON_MESSAGES_CLOSED,this.handleMessagesClosed);
      }
      
      public function showRead(param1:Boolean) : void
      {
         this.mc.newMC.visible = param1;
      }
      
      private function getMugshot() : void
      {
         var _loc2_:Object = null;
         this.mugshotSpr = this.mc.getChildByName("mugshot_spr") as Sprite;
         this.mugshotMaskSpr = this.mugshotSpr.getChildByName("mask_spr") as Sprite;
         this.mugshotMaskSpr.alpha = 0;
         var _loc1_:Bitmap = Mugshots.getMugshot(this.msgInfo.from);
         if(_loc1_ == null)
         {
            _loc2_ = {"weevilDef":this.weevilDef};
            _loc2_.king = 0;
            _loc1_ = this.bin.getWeevilMugshot(this.msgInfo.from,_loc2_,0);
            this.addMugshot(_loc1_);
         }
         else
         {
            this.addMugshot(_loc1_);
         }
      }
      
      public function addMugshot(param1:Bitmap) : void
      {
         if(this.mugshotBmp != null)
         {
            this.mugshotSpr.removeChild(this.mugshotBmp);
         }
         this.mugshotBmp = param1;
         this.mugshotSpr.addChildAt(param1,this.mugshotSpr.getChildIndex(this.mugshotMaskSpr));
         param1.mask = this.mugshotMaskSpr;
         param1.smoothing = true;
         param1.width = param1.height = 42;
         param1.y = -4;
         param1.x = -2;
         this.imageLoaded();
      }
      
      public function weevilDefReceived(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Bitmap = null;
         if(String(param1.weevilDef) != this.weevilDef || this.weevilDef == "")
         {
            _loc2_ = {"weevilDef":param1.weevilDef};
            _loc2_.king = 0;
            _loc3_ = this.bin.getWeevilMugshot(this.msgInfo.from,_loc2_,0);
            this.addMugshot(_loc3_);
            this.weevilDef = param1.weevilDef;
         }
         else
         {
            this.imageLoaded();
         }
      }
      
      private function doClick(param1:MouseEvent = null) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.conversation_id = this.msgInfo.conversationID;
         this.conversationID = this.msgInfo.conversationID;
         _loc2_.page = 1;
         Bin_extInterface.bin.webSocket.send("conversation/load",_loc2_);
         EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_CONVERSATION_RECIEVED,this.onConversationRecieved);
      }
      
      private function onConversationRecieved(param1:CustomEvent) : void
      {
         var _loc3_:BuddyMessageEvent = null;
         var _loc4_:Array = null;
         var _loc5_:BuddyMessageInfoObject = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         EventManager.get_instance().removeEventListener(BinEvents.WEB_SOCKET_CONVERSATION_RECIEVED,this.onConversationRecieved);
         var _loc2_:Object = param1.dataObj;
         if(_loc2_["responseCode"] == 1)
         {
            if(this.msgInfo.isNew == 1)
            {
               EventManager.get_instance().dispatchEvent(new BuddyMessageEvent(BuddyMessageEvent.ON_NEW_MESSAGE_READ));
            }
            this.doSelected();
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
                     _loc5_.from = this.msgInfo.from;
                     _loc5_.fromIDX = _loc4_[_loc7_]["sender_idx"];
                     _loc5_.msg = _loc4_[_loc7_]["body"];
                     _loc5_.isDeleted = _loc4_[_loc7_]["deleted"];
                     _loc5_.timeSent = _loc4_[_loc7_]["sent_on"];
                     _loc5_.messageID = _loc4_[_loc7_]["id"];
                     _loc6_.push(_loc5_);
                     _loc7_++;
                  }
                  _loc3_.msgInfoArr = _loc6_;
               }
            }
            _loc3_.teaser = this;
            _loc3_.msgInfo = this.msgInfo;
            _loc3_.msgInfo.conversationID = this.conversationID;
            EventManager.get_instance().dispatchEvent(_loc3_);
         }
      }
      
      private function doRollOver(param1:MouseEvent = null) : void
      {
      }
      
      private function doRollOut(param1:MouseEvent = null) : void
      {
      }
      
      public function doSelected() : void
      {
         this.disable();
      }
      
      private function handleMessageSelected(param1:BuddyMessageEvent) : void
      {
      }
      
      private function handleMessagesClosed(param1:BuddyMessageEvent) : void
      {
         this.reset();
      }
      
      private function onWeevilFactoryReady(param1:Event) : void
      {
         this.weevilFactoryReady = true;
         this.getMugshot();
      }
      
      public function getMsgInfo() : BuddyMessageInfoObject
      {
         return this.msgInfo;
      }
      
      public function getMC() : MovieClip
      {
         return this.mc;
      }
      
      private function enable() : void
      {
         this.mc.addEventListener(MouseEvent.MOUSE_OVER,this.doRollOver);
         this.mc.addEventListener(MouseEvent.MOUSE_OUT,this.doRollOut);
         this.mc.addEventListener(MouseEvent.MOUSE_DOWN,this.doClick);
         this.mc.buttonMode = true;
      }
      
      private function disable() : void
      {
         this.mc.removeEventListener(MouseEvent.MOUSE_OVER,this.doRollOver);
         this.mc.removeEventListener(MouseEvent.MOUSE_OUT,this.doRollOut);
         this.mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.doClick);
         this.mc.buttonMode = false;
      }
      
      public function reset() : void
      {
         this.doRollOut();
         this.enable();
         this.showRead(this.msgInfo.isNew == 1);
      }
   }
}

