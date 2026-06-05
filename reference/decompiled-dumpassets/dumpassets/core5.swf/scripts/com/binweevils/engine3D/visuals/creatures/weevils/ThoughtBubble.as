package com.binweevils.engine3D.visuals.creatures.weevils
{
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.visuals.Element;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Point;
   import flash.text.*;
   import flash.utils.Timer;
   
   public class ThoughtBubble extends Element
   {
      
      private var bubble_mc:MovieClip;
      
      private var thought_txt:TextField;
      
      private var tf_fmt:TextFormat;
      
      public var p_ratio:Number;
      
      private var fadeTimer:Timer;
      
      public function ThoughtBubble(param1:MovieClip, param2:Number, param3:Number, param4:Number, param5:Number)
      {
         super(param2,param3,param4,1,0);
         d_o = new Sprite();
         d_o.visible = false;
         this.bubble_mc = param1;
         this.bubble_mc.gotoAndStop(1);
         this.bubble_mc.addEventListener(MouseEvent.CLICK,this.thoughtFinished);
         d_o.addChildAt(this.bubble_mc,0);
         this.thought_txt = new TextField();
         this.thought_txt.selectable = false;
         this.thought_txt.wordWrap = true;
         this.thought_txt.width = 110;
         d_o.addChild(this.thought_txt);
         this.thought_txt.x = 34;
         this.thought_txt.y = -158;
         this.tf_fmt = new TextFormat();
         this.tf_fmt.font = "GosmickSans";
         this.tf_fmt.size = 14;
         this.tf_fmt.align = TextFormatAlign.CENTER;
         this.tf_fmt.color = 2970263;
         this.thought_txt.mouseEnabled = false;
         this.fadeTimer = new Timer(7000,1);
         this.fadeTimer.addEventListener("timer",this.fadeOut);
         this.createHash();
      }
      
      override public function createHash(param1:Boolean = false) : void
      {
         hash = new HashSB(p,param1);
         useHash = true;
      }
      
      public function setText(param1:String) : void
      {
         this.thought_txt.visible = false;
         this.thought_txt.text = param1;
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.font = "GosmickSans";
         _loc2_.size = 14;
         _loc2_.align = TextFormatAlign.CENTER;
         _loc2_.color = 2970263;
         this.thought_txt.setTextFormat(_loc2_);
         this.thought_txt.embedFonts = true;
         var _loc3_:Number = -124 - 0.5 * this.thought_txt.textHeight;
         if(_loc3_ < -158)
         {
            _loc3_ = -158;
         }
         this.thought_txt.y = _loc3_;
         d_o.visible = true;
         this.fadeTimer.reset();
         this.fadeTimer.start();
         this.positionThoughtBubble();
         this.fadeIn();
      }
      
      private function positionThoughtBubble() : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc1_:Point = new Point(this.bubble_mc.x,this.bubble_mc.y);
         _loc1_ = this.bubble_mc.localToGlobal(_loc1_);
         var _loc2_:int = 820;
         if(this.bubble_mc.bub_main != null)
         {
            _loc3_ = [[87,-122],[21.15,-33],[38,-58],[34,-158]];
            _loc4_ = new Vector3D(1,1,0);
            if(_loc1_.x + _loc3_[0][0] + this.bubble_mc.bub_main.width / 2 > _loc2_)
            {
               _loc4_.x *= -1;
            }
            if(_loc1_.y + _loc3_[0][1] - this.bubble_mc.bub_main.height / 2 < 0)
            {
               _loc4_.y *= -1;
            }
            this.bubble_mc.bub_main.x = _loc4_.x * _loc3_[0][0];
            this.bubble_mc.bub_main.y = _loc4_.y * _loc3_[0][1];
            this.bubble_mc.bub_sub1.x = _loc4_.x * _loc3_[1][0];
            this.bubble_mc.bub_sub1.y = _loc4_.y * _loc3_[1][1];
            this.bubble_mc.bub_sub2.x = _loc4_.x * _loc3_[2][0];
            this.bubble_mc.bub_sub2.y = _loc4_.y * _loc3_[2][1];
            this.thought_txt.x = _loc4_.x * _loc3_[3][0];
            this.thought_txt.y = _loc4_.y * _loc3_[3][1];
            if(_loc4_.y < 0)
            {
               this.thought_txt.y -= 75;
            }
            if(_loc4_.x < 0)
            {
               this.thought_txt.x -= this.thought_txt.width;
            }
         }
      }
      
      private function showText(param1:Event) : void
      {
         this.thought_txt.visible = true;
      }
      
      private function thoughtFinished(param1:MouseEvent = null) : void
      {
         this.bubble_mc.dispatchEvent(new Event("thoughtFinished"));
      }
      
      public function hideIt() : void
      {
         this.bubble_mc.gotoAndStop(1);
         this.thought_txt.visible = false;
         this.thought_txt.text = "";
         this.fadeTimer.stop();
         d_o.visible = false;
      }
      
      internal function fadeIn(param1:* = null) : *
      {
         var myCD:* = undefined;
         var myIncrement:* = undefined;
         var myCdFunc:* = undefined;
         var e:* = param1;
         myCD = 10;
         this.bubble_mc.alpha = 0;
         myIncrement = 1 / myCD;
         myCdFunc = function(param1:*):*
         {
            --myCD;
            bubble_mc.scaleY = bubble_mc.scaleX = (10 - myCD) * myIncrement;
            bubble_mc.alpha = 1;
            if(myCD <= 0)
            {
               thought_txt.visible = true;
               bubble_mc.removeEventListener(Event.ENTER_FRAME,myCdFunc);
            }
         };
         this.bubble_mc.addEventListener(Event.ENTER_FRAME,myCdFunc);
      }
      
      public function fadeOut(param1:TimerEvent) : void
      {
         var myCD:* = undefined;
         var myIncrement:* = undefined;
         var myCdFunc:* = undefined;
         var event:TimerEvent = param1;
         this.fadeTimer.stop();
         myCD = 10;
         myIncrement = this.bubble_mc.alpha / myCD;
         myCdFunc = function(param1:*):*
         {
            --myCD;
            bubble_mc.alpha -= myIncrement;
            if(myCD <= 0)
            {
               thoughtFinished();
               bubble_mc.removeEventListener(Event.ENTER_FRAME,myCdFunc);
            }
         };
         this.bubble_mc.addEventListener(Event.ENTER_FRAME,myCdFunc);
      }
      
      public function set_p_ratio(param1:Number) : void
      {
         var _loc2_:HashSB = hash as HashSB;
         _loc2_.p_ratio = param1;
      }
   }
}

