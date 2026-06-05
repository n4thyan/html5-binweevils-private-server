package com.binweevils
{
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class WeevilActionTrigger
   {
      
      private var weevilActionsUI:WeevilActionsUI;
      
      private var actionBtn_mc:MovieClip;
      
      private var actionID:int;
      
      private var transMoveID:int;
      
      private var maxRange:Number;
      
      private var endPoseID:int;
      
      public var maxPowerLevel:int;
      
      private var selectedPowerLevel:int;
      
      private var incrPowerTimer:Timer;
      
      public var energyRequirement:Number;
      
      private var keyCode:int;
      
      private var shortcutKeyDown:Boolean;
      
      public var enabled:Boolean = false;
      
      public var tycoonOnly:Boolean = false;
      
      public function WeevilActionTrigger(param1:WeevilActionsUI, param2:MovieClip, param3:int, param4:int, param5:Number, param6:int = 0, param7:int = 0, param8:int = -1, param9:int = -1)
      {
         super();
         this.weevilActionsUI = param1;
         this.actionBtn_mc = param2;
         this.actionID = param4;
         this.energyRequirement = param5;
         this.maxPowerLevel = param6;
         this.transMoveID = param7;
         this.endPoseID = param8;
         this.keyCode = param9;
         this.actionBtn_mc.icon_mc.gotoAndStop(param3);
         if(this.maxPowerLevel == 0 && this.transMoveID == 0)
         {
            this.actionBtn_mc.btn.addEventListener(MouseEvent.MOUSE_DOWN,this.triggerAction);
            if(this.keyCode != -1)
            {
               STAGE.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler_simple);
               STAGE.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler_simple);
            }
         }
         else
         {
            this.actionBtn_mc.bg_mc.gotoAndStop(this.maxPowerLevel + 1);
            if(this.maxPowerLevel > 0 && param7 != 1)
            {
               this.actionBtn_mc.btn.addEventListener(MouseEvent.MOUSE_DOWN,this.initialiseActionPower);
            }
            this.actionBtn_mc.btn.addEventListener(MouseEvent.CLICK,this.triggerAction);
            this.incrPowerTimer = new Timer(250,0);
            this.incrPowerTimer.addEventListener("timer",this.incrPowerLevel);
            if(this.keyCode != -1)
            {
               STAGE.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
               STAGE.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
            }
         }
         if(this.maxPowerLevel > 0)
         {
            this.actionBtn_mc.btn.addEventListener(MouseEvent.ROLL_OVER,this.showPowerLevelHint);
            this.actionBtn_mc.btn.addEventListener(MouseEvent.ROLL_OUT,this.hidePowerLevelHint);
         }
      }
      
      private function showPowerLevelHint(param1:MouseEvent) : void
      {
         var _loc2_:Point = this.actionBtn_mc.parent.localToGlobal(new Point(this.actionBtn_mc.x,this.actionBtn_mc.y));
         Bin.get_instance().showHint("power: " + this.maxPowerLevel,_loc2_.x + 23,_loc2_.y - 25);
      }
      
      private function hidePowerLevelHint(param1:MouseEvent) : void
      {
         Bin.get_instance().hideHint();
      }
      
      public function set vis(param1:*) : void
      {
         this.actionBtn_mc.visible = param1;
      }
      
      public function enable() : void
      {
         this.enabled = true;
         this.actionBtn_mc.icon_mc.visible = true;
         this.actionBtn_mc.bg_mc.visible = true;
         this.actionBtn_mc.btn.mouseEnabled = true;
      }
      
      public function disable() : void
      {
         this.enabled = false;
         this.actionBtn_mc.icon_mc.visible = false;
         this.actionBtn_mc.bg_mc.visible = false;
         this.actionBtn_mc.btn.mouseEnabled = false;
      }
      
      public function setMaxPowerLevel(param1:int) : void
      {
         this.maxPowerLevel = param1;
         this.actionBtn_mc.bg_mc.gotoAndStop(this.maxPowerLevel + 1);
      }
      
      public function resetClr() : void
      {
         this.actionBtn_mc.bg_mc.gotoAndStop(this.maxPowerLevel + 1);
      }
      
      private function keyDownHandler_simple(param1:KeyboardEvent) : void
      {
         if(this.keyCode == param1.keyCode)
         {
            if(!this.shortcutKeyDown)
            {
               this.shortcutKeyDown = true;
               this.triggerAction();
            }
         }
      }
      
      private function keyUpHandler_simple(param1:KeyboardEvent) : void
      {
         if(this.keyCode == param1.keyCode)
         {
            this.shortcutKeyDown = false;
         }
      }
      
      private function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(this.keyCode == param1.keyCode)
         {
            if(!this.shortcutKeyDown)
            {
               this.shortcutKeyDown = true;
               this.initialiseActionPower();
            }
         }
      }
      
      private function keyUpHandler(param1:KeyboardEvent) : void
      {
         if(this.keyCode == param1.keyCode)
         {
            this.shortcutKeyDown = false;
            this.triggerAction();
         }
      }
      
      private function initialiseActionPower(param1:MouseEvent = null) : void
      {
         this.selectedPowerLevel = 1;
         this.actionBtn_mc.bg_mc.gotoAndStop(2);
         this.incrPowerTimer.start();
      }
      
      private function incrPowerLevel(param1:TimerEvent) : void
      {
         if(this.selectedPowerLevel < this.maxPowerLevel)
         {
            ++this.selectedPowerLevel;
            this.actionBtn_mc.bg_mc.gotoAndStop(this.selectedPowerLevel + 1);
         }
         else
         {
            this.incrPowerTimer.stop();
         }
      }
      
      private function triggerAction(param1:MouseEvent = null) : void
      {
         if(this.selectedPowerLevel > 0)
         {
            this.incrPowerTimer.stop();
         }
         if(this.transMoveID == 0)
         {
            this.weevilActionsUI.triggerAction(this.actionID,this.energyRequirement,this.selectedPowerLevel,this.endPoseID);
         }
         else
         {
            this.weevilActionsUI.initSpecialTransMove(this.energyRequirement,this.transMoveID,this.selectedPowerLevel,this.endPoseID);
         }
      }
      
      public function get bt() : MovieClip
      {
         return this.actionBtn_mc;
      }
   }
}

