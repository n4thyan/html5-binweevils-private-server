package com.binweevils.buddies
{
   import com.binweevils.Bin_extInterface;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   
   public class BuddyMessage
   {
      
      private var bin:Object;
      
      protected var msgSpr:Sprite;
      
      protected var msgInfo:BuddyMessageInfoObject;
      
      protected var dateText:TextField;
      
      protected var messageText:TextField;
      
      public var buddyMessage:MovieClip;
      
      public var myMessage:MovieClip;
      
      public var clickButton:MovieClip;
      
      public var isMine:Boolean;
      
      public var isSticker:Boolean;
      
      public var stickerID:int;
      
      public function BuddyMessage(param1:Sprite, param2:BuddyMessageInfoObject)
      {
         super();
         this.init(param1,param2);
      }
      
      public function init(param1:Sprite, param2:BuddyMessageInfoObject) : void
      {
         this.bin = Bin_extInterface.bin;
         this.msgSpr = param1;
         this.msgInfo = param2;
         this.isMine = false;
         this.isSticker = this.msgInfo.msg.search("<<<st:") != -1;
         if(this.isSticker)
         {
            this.stickerID = int(this.msgInfo.msg.replace("<<<st:","").replace(">>>",""));
         }
         this.dateText = TextField(this.msgSpr.getChildByName("date_txt"));
         this.messageText = TextField(this.msgSpr.getChildByName("msg_txt"));
         this.buddyMessage = this.msgSpr.getChildByName("buddysmessage") as MovieClip;
         this.myMessage = this.msgSpr.getChildByName("mymessage") as MovieClip;
         this.clickButton = this.msgSpr.getChildByName("ClickButton") as MovieClip;
         this.setMessageText(this.msgInfo.msg);
         this.setDateText(this.msgInfo.timeSent);
         var _loc3_:* = this.msgSpr.width;
         if(this.dateText.textWidth > this.messageText.textWidth)
         {
            this.dateText.x = this.messageText.x + 10;
         }
         else
         {
            this.dateText.x = this.messageText.textWidth - this.dateText.textWidth + 20;
         }
         var _loc4_:* = this.dateText.x + this.dateText.textWidth + 10;
         var _loc5_:* = this.messageText.textHeight + this.dateText.height + 10;
         if(this.msgInfo.fromIDX == this.bin.myUserIDX)
         {
            this.msgSpr.mouseEnabled = false;
            this.msgSpr.mouseChildren = false;
            this.clickButton.visible = false;
            this.clickButton.mouseEnabled = false;
            this.buddyMessage.visible = false;
            this.buddyMessage.mouseEnabled = false;
            this.dateText.mouseEnabled = false;
            this.messageText.mouseEnabled = false;
            this.msgSpr.getChildByName("theirMessageTail").visible = false;
            this.myMessage.height = _loc5_;
            this.myMessage.width = _loc4_;
            this.myMessage.x = this.messageText.x - 10;
            this.myMessage.y = this.messageText.y + _loc5_;
            this.msgSpr.getChildByName("myMessageTail").x = this.myMessage.x + this.myMessage.width;
            this.isMine = true;
         }
         else
         {
            this.msgSpr.mouseEnabled = false;
            this.msgSpr.mouseChildren = true;
            this.clickButton.addEventListener(MouseEvent.CLICK,this.onMessageClicked);
            this.clickButton.buttonMode = true;
            this.clickButton.mouseEnabled = true;
            this.myMessage.visible = false;
            this.myMessage.mouseEnabled = false;
            this.dateText.mouseEnabled = false;
            this.messageText.mouseEnabled = false;
            this.msgSpr.getChildByName("myMessageTail").visible = false;
            this.clickButton.height = this.buddyMessage.height = _loc5_;
            this.clickButton.width = this.buddyMessage.width = _loc4_;
            this.clickButton.x = this.buddyMessage.x = this.messageText.x - 10;
            this.clickButton.y = this.buddyMessage.y = this.messageText.y + _loc5_;
         }
         if(this.isSticker)
         {
            this.addSticker();
         }
         if(this.msgInfo.isDeleted)
         {
            this.clickButton.mouseEnabled = false;
         }
      }
      
      private function onMessageClicked(param1:MouseEvent) : void
      {
         this.bin.showDialogueBox("Do you want to delete this message?",this.deleteMessage);
      }
      
      private function deleteMessage(param1:MouseEvent = null) : void
      {
         this.bin.hideDialogueBox();
         this.messageText.text = "Message Deleted";
         this.msgInfo.isDeleted = 1;
         if(this.dateText.textWidth > this.messageText.textWidth)
         {
            this.dateText.x = this.messageText.x + 10;
         }
         else
         {
            this.dateText.x = this.messageText.textWidth - this.dateText.textWidth + 20;
         }
         var _loc2_:* = this.dateText.x + this.dateText.textWidth + 10;
         this.buddyMessage.width = _loc2_;
         this.buddyMessage.x = this.messageText.x - 10;
         this.clickButton.mouseEnabled = false;
         if(this.isSticker)
         {
            this.msgSpr.removeChildAt(this.msgSpr.numChildren - 2);
         }
         var _loc3_:Object = new Object();
         _loc3_.id = this.msgInfo.messageID;
         this.bin.webSocket.send("conversation/delete-message",_loc3_);
      }
      
      protected function setMessageText(param1:String) : void
      {
         if(this.isSticker)
         {
            this.messageText.text = "";
            return;
         }
         if(this.msgInfo.isDeleted)
         {
            this.messageText.text = "Message Deleted";
            return;
         }
         this.messageText.text = param1;
      }
      
      protected function setDateText(param1:String) : void
      {
         var _loc2_:Date = new Date(Number(param1) * 1000);
         var _loc3_:String = "" + _loc2_.getDate() + "/" + (_loc2_.getMonth() + 1) + "/" + _loc2_.getFullYear() + " " + (_loc2_.getHours() < 10 ? "0" + _loc2_.getHours() : _loc2_.getHours()) + ":" + (_loc2_.getMinutes() < 10 ? "0" + _loc2_.getMinutes() : _loc2_.getMinutes());
         this.dateText.text = _loc3_;
         this.dateText.y = this.messageText.y + this.messageText.textHeight + 5;
      }
      
      private function addSticker() : void
      {
         var _loc1_:MovieClip = null;
         switch(this.stickerID)
         {
            case 1:
            default:
               _loc1_ = this.newItem("emojii_1");
               break;
            case 2:
               _loc1_ = this.newItem("emojii_2");
               break;
            case 3:
               _loc1_ = this.newItem("emojii_3");
               break;
            case 4:
               _loc1_ = this.newItem("emojii_4");
               break;
            case 5:
               _loc1_ = this.newItem("emojii_5");
               break;
            case 6:
               _loc1_ = this.newItem("emojii_6");
               break;
            case 7:
               _loc1_ = this.newItem("emojii_7");
               break;
            case 8:
               _loc1_ = this.newItem("emojii_8");
               break;
            case 9:
               _loc1_ = this.newItem("emojii_9");
               break;
            case 10:
               _loc1_ = this.newItem("emojii_10");
               break;
            case 11:
               _loc1_ = this.newItem("emojii_11");
               break;
            case 12:
               _loc1_ = this.newItem("emojii_12");
               break;
            case 13:
               _loc1_ = this.newItem("emojii_13");
               break;
            case 14:
               _loc1_ = this.newItem("emojii_14");
               break;
            case 15:
               _loc1_ = this.newItem("emojii_15");
               break;
            case 16:
               _loc1_ = this.newItem("emojii_16");
               break;
            case 17:
               _loc1_ = this.newItem("emojii_17");
               break;
            case 18:
               _loc1_ = this.newItem("emojii_18");
               break;
            case 19:
               _loc1_ = this.newItem("emojii_19");
               break;
            case 20:
               _loc1_ = this.newItem("emojii_20");
               break;
            case 21:
               _loc1_ = this.newItem("emojii_21");
               break;
            case 22:
               _loc1_ = this.newItem("emojii_22");
               break;
            case 23:
               _loc1_ = this.newItem("emojii_23");
               break;
            case 24:
               _loc1_ = this.newItem("emojii_24");
               break;
            case 25:
               _loc1_ = this.newItem("emojii_25");
               break;
            case 26:
               _loc1_ = this.newItem("emojii_26");
               break;
            case 27:
               _loc1_ = this.newItem("emojii_27");
               break;
            case 28:
               _loc1_ = this.newItem("emojii_28");
               break;
            case 29:
               _loc1_ = this.newItem("emojii_29");
               break;
            case 30:
               _loc1_ = this.newItem("emojii_30");
               break;
            case 31:
               _loc1_ = this.newItem("emojii_31");
               break;
            case 32:
               _loc1_ = this.newItem("emojii_32");
               break;
            case 33:
               _loc1_ = this.newItem("emojii_33");
               break;
            case 34:
               _loc1_ = this.newItem("emojii_34");
               break;
            case 35:
               _loc1_ = this.newItem("emojii_35");
               break;
            case 36:
               _loc1_ = this.newItem("emojii_36");
               break;
            case 37:
               _loc1_ = this.newItem("emojii_37");
               break;
            case 38:
               _loc1_ = this.newItem("emojii_37b");
               break;
            case 39:
               _loc1_ = this.newItem("emojii_37c");
               break;
            case 40:
               _loc1_ = this.newItem("emojii_38");
               break;
            case 41:
               _loc1_ = this.newItem("emojii_39");
               break;
            case 42:
               _loc1_ = this.newItem("emojii_40");
               break;
            case 43:
               _loc1_ = this.newItem("phrase_awesome");
               break;
            case 44:
               _loc1_ = this.newItem("phrase_best_bin_buddy");
               break;
            case 45:
               _loc1_ = this.newItem("phrase_bintastic");
               break;
            case 46:
               _loc1_ = this.newItem("phrase_bintastic2");
               break;
            case 47:
               _loc1_ = this.newItem("phrase_bye");
               break;
            case 48:
               _loc1_ = this.newItem("phrase_cool");
               break;
            case 49:
               _loc1_ = this.newItem("phrase_dosh");
               break;
            case 50:
               _loc1_ = this.newItem("phrase_good_luck");
               break;
            case 51:
               _loc1_ = this.newItem("phrase_great");
               break;
            case 52:
               _loc1_ = this.newItem("phrase_hello");
               break;
            case 53:
               _loc1_ = this.newItem("phrase_hi");
               break;
            case 54:
               _loc1_ = this.newItem("phrase_lol");
               break;
            case 55:
               _loc1_ = this.newItem("phrase_meet_me_at");
               break;
            case 56:
               _loc1_ = this.newItem("phrase_mulch");
               break;
            case 57:
               _loc1_ = this.newItem("phrase_no");
               break;
            case 58:
               _loc1_ = this.newItem("phrase_see_ya");
               break;
            case 59:
               _loc1_ = this.newItem("phrase_see_you_in_the_binscape");
               break;
            case 60:
               _loc1_ = this.newItem("phrase_super");
               break;
            case 61:
               _loc1_ = this.newItem("phrase_sws_agent");
               break;
            case 62:
               _loc1_ = this.newItem("phrase_thank_you");
               break;
            case 63:
               _loc1_ = this.newItem("phrase_weevily_wow");
               break;
            case 64:
               _loc1_ = this.newItem("phrase_whats_up");
               break;
            case 65:
               _loc1_ = this.newItem("phrase_wow");
               break;
            case 66:
               _loc1_ = this.newItem("phrase_yes");
               break;
            case 67:
               _loc1_ = this.newItem("phrase_yolo");
               break;
            case 68:
               _loc1_ = this.newItem("phrase_youre_the_best");
               break;
            case 69:
               _loc1_ = this.newItem("clott_angry");
               break;
            case 70:
               _loc1_ = this.newItem("clott_chilling_out");
               break;
            case 71:
               _loc1_ = this.newItem("clott_confused");
               break;
            case 72:
               _loc1_ = this.newItem("clott_dizzy");
               break;
            case 73:
               _loc1_ = this.newItem("clott_eating");
               break;
            case 74:
               _loc1_ = this.newItem("clott_laughing");
               break;
            case 75:
               _loc1_ = this.newItem("clott_shocked");
               break;
            case 76:
               _loc1_ = this.newItem("clott_sleeping");
               break;
            case 77:
               _loc1_ = this.newItem("clott_stress_out");
               break;
            case 78:
               _loc1_ = this.newItem("clott_super_happy");
               break;
            case 79:
               _loc1_ = this.newItem("xmas_celeb_bin_pet");
               break;
            case 80:
               _loc1_ = this.newItem("xmas_celeb_bing");
               break;
            case 81:
               _loc1_ = this.newItem("xmas_celeb_posh_bunty");
               break;
            case 82:
               _loc1_ = this.newItem("xmas_celeb_tink_clott");
               break;
            case 83:
               _loc1_ = this.newItem("xmas_emojii_1");
               break;
            case 84:
               _loc1_ = this.newItem("xmas_emojii_11");
               break;
            case 85:
               _loc1_ = this.newItem("xmas_emojii_14");
               break;
            case 86:
               _loc1_ = this.newItem("xmas_emojii_29");
               break;
            case 87:
               _loc1_ = this.newItem("xmas_phrase_happy_holidays");
               break;
            case 88:
               _loc1_ = this.newItem("xmas_phrase_happy_new_year");
               break;
            case 89:
               _loc1_ = this.newItem("xmas_phrase_its_snowing");
               break;
            case 90:
               _loc1_ = this.newItem("xmas_phrase_jingle_bells");
               break;
            case 91:
               _loc1_ = this.newItem("xmas_things_pile_of_presents");
               break;
            case 92:
               _loc1_ = this.newItem("xmas_things_present");
               break;
            case 93:
               _loc1_ = this.newItem("xmas_things_present_002");
               break;
            case 94:
               _loc1_ = this.newItem("xmas_things_snowflake");
               break;
            case 95:
               _loc1_ = this.newItem("xmas_things_xmas_tree");
         }
         _loc1_.scaleX = 0.5;
         _loc1_.scaleY = 0.5;
         if(this.dateText.textWidth > _loc1_.width)
         {
            this.dateText.x = _loc1_.x + 10;
         }
         else
         {
            this.dateText.x = _loc1_.width - this.dateText.textWidth + 20;
         }
         var _loc2_:* = this.dateText.x + this.dateText.textWidth + 10;
         var _loc3_:* = _loc1_.height;
         if(this.stickerID <= 42)
         {
            _loc1_.x = (_loc2_ - _loc1_.width) / 6;
            _loc1_.y = _loc1_.height * 2.1;
         }
         else if(this.stickerID <= 68)
         {
            _loc1_.x = (_loc2_ - _loc1_.width) / 2;
            _loc1_.y = _loc1_.height * 2;
         }
         else if(this.stickerID <= 78)
         {
            _loc1_.x = (_loc2_ - _loc1_.width) / 2;
            _loc1_.y = 150;
            _loc3_ = 70;
         }
         else if(this.stickerID <= 82)
         {
            _loc1_.x = (_loc2_ - _loc1_.width) / 2;
            _loc1_.y = 150;
            _loc3_ = 70;
         }
         else if(this.stickerID <= 86)
         {
            _loc1_.x = (_loc2_ - _loc1_.width) / 6;
            _loc1_.y = _loc1_.height * 2.1;
         }
         else if(this.stickerID <= 90)
         {
            _loc1_.x = (_loc2_ - _loc1_.width) / 2;
            _loc1_.y = 150;
            _loc3_ = 70;
         }
         else if(this.stickerID <= 95)
         {
            _loc1_.x = (_loc2_ - _loc1_.width) / 2;
            _loc1_.y = 150;
            _loc3_ = 70;
         }
         var _loc4_:* = _loc3_ + 15 + this.dateText.textHeight;
         this.dateText.y = _loc1_.y + _loc3_ + 5;
         if(this.msgInfo.fromIDX == this.bin.myUserIDX)
         {
            this.msgSpr.mouseEnabled = false;
            this.msgSpr.mouseChildren = false;
            this.clickButton.visible = false;
            this.buddyMessage.visible = false;
            this.buddyMessage.mouseEnabled = false;
            this.myMessage.height = _loc4_;
            this.myMessage.width = _loc2_;
            this.myMessage.x = this.messageText.x - 10;
            this.myMessage.y = this.messageText.y + _loc4_;
            this.msgSpr.getChildByName("myMessageTail").x = this.myMessage.x + this.myMessage.width;
            this.isMine = true;
         }
         else
         {
            this.myMessage.visible = false;
            this.myMessage.mouseEnabled = false;
            this.clickButton.height = this.buddyMessage.height = _loc4_;
            this.clickButton.width = this.buddyMessage.width = _loc2_;
            this.clickButton.x = this.buddyMessage.x = this.messageText.x - 10;
            this.clickButton.y = this.buddyMessage.y = this.messageText.y + _loc4_;
         }
         this.msgSpr.addChildAt(_loc1_,this.msgSpr.numChildren - 1);
         this.msgSpr.setChildIndex(this.clickButton,this.msgSpr.numChildren - 1);
      }
      
      private function newItem(param1:String) : MovieClip
      {
         var _loc2_:Class = getDefinitionByName(param1) as Class;
         return new _loc2_() as MovieClip;
      }
      
      public function getMsgInfo() : BuddyMessageInfoObject
      {
         return this.msgInfo;
      }
      
      public function getMsgSpr() : Sprite
      {
         return this.msgSpr;
      }
   }
}

