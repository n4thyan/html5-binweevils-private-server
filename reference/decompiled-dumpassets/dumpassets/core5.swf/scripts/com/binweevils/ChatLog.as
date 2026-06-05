package com.binweevils
{
   import fl.controls.UIScrollBar;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.*;
   
   public class ChatLog
   {
      
      private var chatLog_spr:Sprite;
      
      private var chatLog_txt:TextField;
      
      private var scrollBar:UIScrollBar;
      
      private var scrollTop_btn:*;
      
      private var scrollBottom_btn:SimpleButton;
      
      private var _UImain:UImain;
      
      private var stayAtBottom:Boolean;
      
      private var crntScrollPos:int;
      
      public function ChatLog(param1:UImain, param2:Sprite)
      {
         super();
         this._UImain = param1;
         this.chatLog_spr = param2;
         this.chatLog_txt = TextField(this.chatLog_spr.getChildByName("chatLog_txt"));
         this.scrollBar = UIScrollBar(this.chatLog_spr.getChildByName("scrollBar"));
         this.scrollBar.scrollTarget = this.chatLog_txt;
         this.scrollBar.addEventListener(MouseEvent.CLICK,this.disableStayAtBottom);
         this.scrollBar.addEventListener(MouseEvent.MOUSE_UP,this.disableStayAtBottom);
         var _loc3_:StyleSheet = new StyleSheet();
         var _loc4_:Object = new Object();
         _loc4_.color = "#880000";
         var _loc5_:Object = new Object();
         _loc5_.color = "#FF0000";
         _loc3_.setStyle("a:link",_loc4_);
         _loc3_.setStyle("a:hover",_loc5_);
         this.chatLog_txt.styleSheet = _loc3_;
         this.chatLog_txt.addEventListener(TextEvent.LINK,this.showProfile_handler);
         this.scrollTop_btn = SimpleButton(this.chatLog_spr.getChildByName("scrollTop_btn"));
         this.scrollTop_btn.addEventListener(MouseEvent.CLICK,this.scrollTop);
         this.scrollBottom_btn = SimpleButton(this.chatLog_spr.getChildByName("scrollBottom_btn"));
         this.scrollBottom_btn.addEventListener(MouseEvent.CLICK,this.scrollBottom_handler);
         var _loc6_:SimpleButton = SimpleButton(this.chatLog_spr.getChildByName("close_btn"));
         _loc6_.addEventListener(MouseEvent.CLICK,this.hideIt);
      }
      
      private function hideIt(param1:MouseEvent) : void
      {
         this._UImain.hideChatLog();
      }
      
      public function set vis(param1:Boolean) : void
      {
         this.stayAtBottom = true;
         this.scrollBottom();
         this.setScrollBtnVis();
         this.chatLog_spr.visible = param1;
      }
      
      public function get vis() : Boolean
      {
         return this.chatLog_spr.visible;
      }
      
      public function clearLog() : void
      {
         this.chatLog_txt.htmlText = " ------------- CHAT LOG ------------";
         this._UImain.hideChatLog();
      }
      
      public function addMsg(param1:int, param2:String, param3:String) : void
      {
         this.crntScrollPos = this.chatLog_txt.scrollV;
         this.chatLog_txt.htmlText += "<br><a href=\'event:" + param1 + "\'>" + param2 + " says:</a> " + param3;
         this.scrollBar.scrollTarget = this.chatLog_txt;
         this.setScrollBtnVis();
         this.scrollBottom();
      }
      
      private function disableStayAtBottom(param1:MouseEvent) : void
      {
         this.stayAtBottom = false;
      }
      
      private function showProfile_handler(param1:TextEvent) : void
      {
         this._UImain.getWeevilProfile(int(param1.text));
      }
      
      private function scrollTop(param1:MouseEvent) : void
      {
         this.stayAtBottom = false;
         this.chatLog_txt.scrollV = 0;
      }
      
      private function scrollBottom_handler(param1:MouseEvent) : void
      {
         this.stayAtBottom = true;
         this.scrollBottom();
      }
      
      private function scrollBottom() : void
      {
         if(this.stayAtBottom)
         {
            this.chatLog_txt.scrollV = this.chatLog_txt.maxScrollV;
         }
         else
         {
            this.chatLog_txt.scrollV = this.crntScrollPos;
         }
      }
      
      private function setScrollBtnVis() : void
      {
         if(this.chatLog_txt.maxScrollV > 1)
         {
            this.scrollBottom_btn.visible = this.scrollTop_btn.visible = true;
         }
         else
         {
            this.scrollBottom_btn.visible = this.scrollTop_btn.visible = false;
         }
      }
   }
}

