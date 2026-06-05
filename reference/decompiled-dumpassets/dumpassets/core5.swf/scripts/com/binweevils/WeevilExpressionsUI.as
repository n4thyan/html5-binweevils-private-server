package com.binweevils
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.utils.Timer;
   
   public class WeevilExpressionsUI
   {
      
      private var bin:Bin;
      
      private var UI_main:UImain;
      
      private var expressions_btn:SimpleButton;
      
      private var mouths_mc:MovieClip;
      
      private var mouthBtnIcons_mc:MovieClip;
      
      public var crntMouthID:int;
      
      private var hideTimer:Timer;
      
      public function WeevilExpressionsUI(param1:UImain, param2:SimpleButton, param3:MovieClip, param4:MovieClip)
      {
         var _loc6_:SimpleButton = null;
         super();
         this.bin = Bin.get_instance();
         this.UI_main = param1;
         this.expressions_btn = param2;
         this.mouths_mc = param3;
         this.mouthBtnIcons_mc = param4;
         this.mouthBtnIcons_mc.mouseChildren = false;
         this.mouthBtnIcons_mc.mouseEnabled = false;
         this.hideMouthBtns();
         this.mouths_mc.addEventListener(MouseEvent.ROLL_OUT,this.startHideTimer);
         this.mouths_mc.addEventListener(MouseEvent.ROLL_OVER,this.stopHideTimer);
         this.hideTimer = new Timer(600,1);
         this.hideTimer.addEventListener("timer",this.hideTimerListener);
         this.expressions_btn.addEventListener(MouseEvent.CLICK,this.showHideMouthBtns);
         var _loc5_:Array = [this.mouths_mc.mouth0_btn,this.mouths_mc.mouth1_btn,this.mouths_mc.mouth2_btn,this.mouths_mc.mouth3_btn,this.mouths_mc.mouth4_btn,this.mouths_mc.mouth5_btn,this.mouths_mc.mouth6_btn];
         for each(_loc6_ in _loc5_)
         {
            _loc6_.addEventListener(MouseEvent.MOUSE_DOWN,this.mouthBtn_CLICKED);
         }
         this.UI_main.setHint(this.expressions_btn,"Change your weevil\'s expression",228,501);
      }
      
      private function mouthBtn_CLICKED(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         switch(param1.target.name)
         {
            case "mouth0_btn":
               _loc2_ = 0;
               break;
            case "mouth1_btn":
               _loc2_ = 1;
               break;
            case "mouth2_btn":
               _loc2_ = 2;
               break;
            case "mouth3_btn":
               _loc2_ = 3;
               break;
            case "mouth4_btn":
               _loc2_ = 4;
               break;
            case "mouth5_btn":
               _loc2_ = 5;
               break;
            case "mouth6_btn":
               _loc2_ = 6;
         }
         this.crntMouthID = _loc2_;
         this.UI_main.setMouth(_loc2_);
         this.mouthBtnIcons_mc.gotoAndStop(_loc2_ + 1);
      }
      
      private function showHideMouthBtns(param1:MouseEvent) : void
      {
         if(!this.mouths_mc.visible)
         {
            this.showMouthBtns();
         }
         else
         {
            this.hideMouthBtns();
         }
      }
      
      private function showMouthBtns(param1:MouseEvent = null) : void
      {
         this.hideTimer.stop();
         this.mouths_mc.visible = true;
         this.UI_main.hideWeevilActions();
         this.UI_main.hideHint();
      }
      
      private function startHideTimer(param1:MouseEvent) : void
      {
         this.hideTimer.reset();
         this.hideTimer.start();
      }
      
      private function stopHideTimer(param1:MouseEvent) : void
      {
         this.hideTimer.stop();
      }
      
      private function hideTimerListener(param1:TimerEvent) : void
      {
         this.hideMouthBtns();
      }
      
      public function hideMouthBtns(param1:MouseEvent = null) : void
      {
         this.mouths_mc.visible = false;
      }
   }
}

