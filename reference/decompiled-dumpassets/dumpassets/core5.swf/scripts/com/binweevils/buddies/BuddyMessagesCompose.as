package com.binweevils.buddies
{
   import com.binweevils.Bin_extInterface;
   import com.binweevils.EventManager;
   import com.binweevils.engine3D.visuals.creatures.weevils.Mugshots;
   import com.binweevils.utilities.ToolTipEvent;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class BuddyMessagesCompose
   {
      
      private var bin:Object;
      
      private var container:MovieClip;
      
      private var closeReplyBtn:SimpleButton;
      
      private var sendReplyBtn:SimpleButton;
      
      private var toTxt:TextField;
      
      private var msgTxt:TextField;
      
      private var msgInfo:BuddyMessageInfoObject;
      
      private var mugshotFrom:Bitmap;
      
      private var mugshotTo:Bitmap;
      
      private var dialogueBox:DialogueBox;
      
      private const MESSAGE_EMPTY:String = "messageEmpty";
      
      private const MESSAGE_SENT:String = "messageSent";
      
      private var undoContent:String;
      
      public function BuddyMessagesCompose(param1:MovieClip)
      {
         super();
         this.container = param1;
         this.init();
      }
      
      private function init() : void
      {
         this.bin = Bin_extInterface.bin;
         this.closeReplyBtn = this.container.getChildByName("closeMessage_btn") as SimpleButton;
         this.sendReplyBtn = this.container.getChildByName("sendReply_btn") as SimpleButton;
         this.msgTxt = this.container.getChildByName("msg_txt") as TextField;
         this.msgTxt.restrict = "a-z A-Z ? ! \\- . & ,";
         this.toTxt = this.container.getChildByName("to_txt") as TextField;
         this.dialogueBox = new DialogueBox(this.container.getChildByName("messages_mc") as MovieClip);
         this.initListeners();
         this.registerForTooltips();
         this.reset();
      }
      
      private function initListeners() : void
      {
         this.closeReplyBtn.addEventListener(MouseEvent.CLICK,this.handleCloseReplyClick);
         this.sendReplyBtn.addEventListener(MouseEvent.CLICK,this.sendReply);
         this.msgTxt.addEventListener(Event.CHANGE,this.onTextChange);
         this.msgTxt.addEventListener(Event.SCROLL,this.onTextChange);
      }
      
      private function registerForTooltips() : void
      {
         var _loc1_:ToolTipEvent = new ToolTipEvent(ToolTipEvent.REGISTER_TOOLTIP);
         _loc1_.io = this.closeReplyBtn;
         _loc1_.x = 688;
         _loc1_.y = 390;
         _loc1_.tipText = "Close";
         EventManager.get_instance().dispatchEvent(_loc1_);
         var _loc2_:ToolTipEvent = new ToolTipEvent(ToolTipEvent.REGISTER_TOOLTIP);
         _loc2_.io = this.sendReplyBtn;
         _loc2_.x = 800;
         _loc2_.y = 390;
         _loc2_.tipText = "Send";
         EventManager.get_instance().dispatchEvent(_loc2_);
      }
      
      private function handleCloseReplyClick(param1:MouseEvent) : void
      {
         this.hide();
         this.reset();
         EventManager.get_instance().dispatchEvent(new BuddyMessageEvent(BuddyMessageEvent.ON_COMPOSER_CLOSED));
      }
      
      public function show(param1:BuddyMessageInfoObject) : void
      {
         this.msgInfo = param1;
         this.toTxt.text = this.msgInfo.from;
         if(this.mugshotFrom == null)
         {
            this.getMugshotFrom();
         }
         this.getMugshotTo();
         this.container.stage.focus = this.msgTxt;
         this.container.visible = true;
      }
      
      public function hide() : void
      {
         this.container.visible = false;
         this.reset();
      }
      
      private function getMugshotFrom() : void
      {
         this.mugshotFrom = Mugshots.getMugshot(this.bin.myUserName);
         if(this.mugshotFrom == null)
         {
            this.bin.getWeevilDef(this.bin.myUserName,this.weevilDefFromReceived);
         }
         else
         {
            this.addMugshotFrom(this.mugshotFrom);
         }
      }
      
      public function addMugshotFrom(param1:Bitmap) : void
      {
         this.container.addChild(param1);
         param1.smoothing = true;
         param1.scaleY = param1.scaleX = 0.8660714285714286;
         param1.y = 8;
         param1.x = 0;
         param1.scaleX *= -1;
         param1.x += param1.width;
      }
      
      public function weevilDefFromReceived(param1:Object) : void
      {
         var _loc2_:Object = {"weevilDef":param1.weevilDef};
         _loc2_.king = 0;
         this.mugshotFrom = this.bin.getWeevilMugshot(this.bin.myUserName,_loc2_,2);
         this.addMugshotFrom(this.mugshotFrom);
      }
      
      private function getMugshotTo() : void
      {
         this.mugshotTo = Mugshots.getMugshot(this.msgInfo.from);
         if(this.mugshotTo == null)
         {
            this.bin.getWeevilDef(this.msgInfo.from,this.weevilDefToReceived);
         }
         else
         {
            this.addMugshotTo(this.mugshotTo);
         }
      }
      
      public function addMugshotTo(param1:Bitmap) : void
      {
         this.container.addChild(param1);
         param1.smoothing = true;
         param1.width = 67;
         param1.scaleY = param1.scaleX;
         param1.y = 20;
         param1.x = 167;
      }
      
      public function weevilDefToReceived(param1:Object) : void
      {
         var _loc2_:Object = {"weevilDef":param1.weevilDef};
         _loc2_.king = 0;
         this.mugshotTo = this.bin.getWeevilMugshot(this.msgInfo.from,_loc2_,2);
         this.addMugshotTo(this.mugshotTo);
      }
      
      private function reset() : void
      {
         this.msgTxt.text = "";
         this.toTxt.text = "";
         this.undoContent = "";
         if(this.mugshotTo != null)
         {
            this.container.removeChild(this.mugshotTo);
            this.mugshotTo = null;
         }
         this.dialogueBox.hide(false);
      }
      
      private function sendReply(param1:MouseEvent) : void
      {
         if(this.msgTxt.text == "")
         {
            this.dialogueBox.showMessage(this.MESSAGE_EMPTY);
            return;
         }
         var _loc2_:Number = this.msgInfo.fromIDX;
         var _loc3_:String = this.msgInfo.from;
         var _loc4_:String = this.msgTxt.text;
         if(this.bin.sendBuddyMsg(_loc4_,_loc3_,_loc2_))
         {
            this.dialogueBox.showMessage(this.MESSAGE_SENT,this.onMessageSentOK);
         }
      }
      
      private function onTextChange(param1:Event = null) : void
      {
         if(this.msgTxt.textHeight > this.msgTxt.height - 4)
         {
            this.undo();
         }
         else
         {
            this.undoContent = this.msgTxt.text;
         }
      }
      
      private function undo() : void
      {
         this.msgTxt.text = this.undoContent;
         this.msgTxt.scrollV = 0;
      }
      
      private function onMessageSentOK() : void
      {
         this.hide();
         EventManager.get_instance().dispatchEvent(new BuddyMessageEvent(BuddyMessageEvent.ON_MESSAGE_SENT));
      }
   }
}

