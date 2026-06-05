package com.binweevils.utilities
{
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.text.StyleSheet;
   import flash.utils.Timer;
   
   public class ToolTipText
   {
      
      private var tttMC:MovieClip;
      
      private var showTimer:Timer;
      
      private var scaleChange:Number;
      
      private var bgMC:MovieClip;
      
      private var padTB:uint = 6;
      
      private var padLR:uint = 14;
      
      private var bgWidthTo:Number;
      
      private var multiLineExtraPadBottom:uint = 3;
      
      private var timerWaitCount:uint;
      
      private var timerMaxCount:uint;
      
      public function ToolTipText(param1:MovieClip)
      {
         super();
         this.tttMC = param1;
         this.bgMC = this.tttMC.bg_mc;
         var _loc2_:Number = 100;
         var _loc3_:Number = 12;
         var _loc4_:Number = -6;
         var _loc5_:Number = -50;
         var _loc6_:Rectangle = new Rectangle(_loc5_,_loc4_,_loc2_,_loc3_);
         this.bgMC.scale9Grid = _loc6_;
         this.tttMC.visible = false;
         this.tttMC.mouseEnabled = false;
         this.tttMC.mouseChildren = false;
         this.timerWaitCount = 6;
         this.timerMaxCount = 11;
         this.showTimer = new Timer(20,this.timerMaxCount);
         this.showTimer.addEventListener(TimerEvent.TIMER,this.doTransition);
      }
      
      public function setText(param1:String = "") : void
      {
         this.tttMC._txt.autoSize = "left";
         var _loc2_:StyleSheet = new StyleSheet();
         var _loc3_:Object = new Object();
         if(param1.indexOf("<br>") == -1)
         {
            this.tttMC._txt.multiline = false;
            _loc3_["textAlign"] = "left";
         }
         else
         {
            this.tttMC._txt.multiline = true;
            _loc3_["textAlign"] = "center";
         }
         _loc2_.setStyle("body",_loc3_);
         this.tttMC._txt.styleSheet = _loc2_;
         this.tttMC._txt.htmlText = "<body>" + param1 + "<body>";
         this.tttMC._txt.visible = false;
         this.drawBG();
      }
      
      public function setPosition(param1:Object = null) : void
      {
         var _loc3_:uint = 0;
         if(param1 == null)
         {
            _loc3_ = 5;
            this.tttMC.x = this.tttMC.stage.mouseX - this.tttMC._txt.width / 2;
            this.tttMC.y = this.tttMC.stage.mouseY - _loc3_ - this.tttMC._txt.height;
         }
         else
         {
            if(param1.x != null)
            {
               this.tttMC.x = Number(param1.x) - this.tttMC._txt.width / 2;
            }
            if(param1.y != null)
            {
               this.tttMC.y = Number(param1.y);
            }
         }
         var _loc2_:uint = 40;
         if(this.tttMC.x - this.padLR < _loc2_)
         {
            this.tttMC.x = _loc2_ + this.padLR;
         }
         else if(this.tttMC.x + this.tttMC._txt.width + this.padLR > this.tttMC.stage.stageWidth - _loc2_)
         {
            this.tttMC.x = this.tttMC.stage.stageWidth - this.tttMC._txt.width - _loc2_ - this.padLR;
         }
         if(this.tttMC.y - this.padTB < _loc2_)
         {
            this.tttMC.y = _loc2_ + this.padTB;
         }
         else if(this.tttMC.y + this.tttMC.height + this.padTB > this.tttMC.stage.stageHeight - _loc2_)
         {
            this.tttMC.y = this.tttMC.stage.stageHeight - this.tttMC.height - _loc2_ + this.padTB;
         }
      }
      
      public function show() : void
      {
         this.bgMC.scaleX = 0;
         this.tttMC.visible = true;
         this.showTimer.start();
      }
      
      private function doTransition(param1:TimerEvent) : void
      {
         if(this.showTimer.currentCount > this.timerWaitCount)
         {
            this.bgMC.width = this.bgWidthTo / 5 * (this.showTimer.currentCount - this.timerWaitCount);
         }
         if(this.showTimer.currentCount == this.showTimer.repeatCount)
         {
            this.tttMC._txt.visible = true;
         }
      }
      
      public function hide() : void
      {
         this.tttMC.visible = false;
         this.showTimer.reset();
      }
      
      private function drawBG() : void
      {
         this.bgWidthTo = this.tttMC._txt.width + 2 * this.padLR;
         this.bgMC.height = this.tttMC._txt.height + 2 * this.padTB;
         this.bgMC.y = this.bgMC.height / 2 - this.padTB;
         if(this.tttMC._txt.multiline)
         {
            this.bgMC.height += this.multiLineExtraPadBottom;
            this.bgMC.y += this.multiLineExtraPadBottom / 2;
         }
         this.bgMC.x = this.bgWidthTo / 2 - this.padLR;
      }
   }
}

