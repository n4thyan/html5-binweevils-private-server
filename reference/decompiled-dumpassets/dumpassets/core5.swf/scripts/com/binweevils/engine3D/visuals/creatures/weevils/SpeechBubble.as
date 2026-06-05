package com.binweevils.engine3D.visuals.creatures.weevils
{
   import com.binweevils.engine3D.ViewPort;
   import com.binweevils.engine3D.visuals.Element;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   
   public class SpeechBubble extends Element
   {
      
      private var bubble_mc:MovieClip;
      
      private var fin_mc:MovieClip;
      
      private var tf:TextField;
      
      public var p_ratio:Number;
      
      private var fadeTimer:Timer;
      
      private var faderTimer:Timer;
      
      public function SpeechBubble(param1:MovieClip, param2:MovieClip, param3:Number, param4:Number, param5:Number, param6:Number)
      {
         super(param3,param4,param5,1,0);
         d_o = new Sprite();
         this.bubble_mc = param1;
         this.fin_mc = param2;
         d_o.addChildAt(this.bubble_mc,0);
         d_o.addChildAt(this.fin_mc,1);
         this.tf = new TextField();
         this.tf.selectable = false;
         this.tf.wordWrap = true;
         this.tf.autoSize = TextFieldAutoSize.LEFT;
         d_o.mouseEnabled = false;
         d_o.mouseChildren = false;
         this.tf.mouseEnabled = false;
         this.fadeTimer = new Timer(7000,1);
         this.fadeTimer.addEventListener("timer",this.fade);
         this.faderTimer = new Timer(40,0);
         this.faderTimer.addEventListener("timer",this.fader);
         this.createHash();
      }
      
      override public function createHash(param1:Boolean = false) : void
      {
         hash = new HashSB(p,param1);
         useHash = true;
      }
      
      public function setText(param1:String) : void
      {
         param1 = param1.split("\n").join("");
         param1 = param1.split("\r").join("");
         param1 = param1.substr(0,38);
         this.faderTimer.stop();
         d_o.addChildAt(this.tf,2);
         this.tf.text = param1;
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.font = "Andy Bold";
         if(ViewPort.zoomFactor == 1)
         {
            _loc2_.size = 15;
         }
         else
         {
            _loc2_.size = 13;
         }
         this.tf.setTextFormat(_loc2_);
         this.tf.embedFonts = true;
         var _loc3_:int = 220;
         _loc3_ = Math.max(this.tf.textWidth,18);
         var _loc4_:int = this.tf.textHeight;
         this.tf.x = -0.5 * _loc3_ + 10;
         this.tf.y = -_loc4_ - 16;
         this.bubble_mc.scale9Grid = new Rectangle(8,8,84,24);
         this.bubble_mc.width = _loc3_ + 16;
         this.bubble_mc.height = _loc4_ + 11;
         this.bubble_mc.x = -0.5 * this.bubble_mc.width + 14;
         this.bubble_mc.y = -this.bubble_mc.height - 7;
         d_o.alpha = 1;
         d_o.visible = true;
         this.fadeTimer.reset();
         this.fadeTimer.start();
         this.tf.autoSize = TextFieldAutoSize.LEFT;
         d_o.mouseChildren = false;
         this.tf.mouseEnabled = false;
      }
      
      public function hideIt() : void
      {
         this.fadeTimer.stop();
         this.faderTimer.stop();
         d_o.visible = false;
      }
      
      public function fade(param1:TimerEvent) : void
      {
         this.fadeTimer.stop();
         this.faderTimer.reset();
         this.faderTimer.start();
      }
      
      private function fader(param1:TimerEvent) : void
      {
         if(d_o.alpha > 0)
         {
            d_o.alpha -= 0.3;
         }
         else
         {
            this.faderTimer.stop();
            d_o.visible = false;
            d_o.alpha = 0;
         }
      }
      
      public function set_p_ratio(param1:Number) : void
      {
         var _loc2_:HashSB = hash as HashSB;
         _loc2_.p_ratio = param1;
      }
   }
}

