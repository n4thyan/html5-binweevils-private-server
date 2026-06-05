package com.binweevils
{
   import com.binweevils.engine3D.visuals.creatures.weevils.behaviours.WeevilBehaviours;
   import com.binweevils.newUserTutorial.NewUserProgressManager;
   import com.binweevils.utilities.Utils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class WeevilActionsUI
   {
      
      private var bin:Bin;
      
      private var UI_main:UImain;
      
      private var weevilStatManager:WeevilStatManager;
      
      private var actionsBtn_mc:MovieClip;
      
      private var actionBtns_mc:MovieClip;
      
      private var energyBar_spr:Sprite;
      
      private var energyBarBG_mc:MovieClip;
      
      private var actionTriggers:Array;
      
      private var actionEnablers:Array;
      
      private var acquiredMoves:Array;
      
      public var transMoveID:int;
      
      public var selectedPowerLevel:int;
      
      private var energy:Number;
      
      private var energyCap:Number;
      
      private var level:int;
      
      private var rechargeTimer:Timer;
      
      private var rechargeRate:Number;
      
      private var hideTimer:Timer;
      
      private var actionsBtnFlashTimer:Timer;
      
      private var specialMoveBts:Array;
      
      private var specialMoveIndexs:Array;
      
      private var currentIndex:int;
      
      public function WeevilActionsUI(param1:UImain, param2:WeevilStatManager, param3:MovieClip, param4:MovieClip)
      {
         var _loc7_:* = 0;
         var _loc8_:int = 0;
         super();
         this.bin = Bin.get_instance();
         this.UI_main = param1;
         this.weevilStatManager = param2;
         this.actionsBtn_mc = param3;
         this.actionBtns_mc = param4;
         this.energyBar_spr = this.actionsBtn_mc.energyBar_spr;
         this.energyBarBG_mc = this.actionsBtn_mc.energyBarBG_mc;
         this.energy = Number(100);
         this.energyCap = Number(100);
         this.hideActionBtns();
         this.actionTriggers = new Array();
         this.actionTriggers[0] = new WeevilActionTrigger(this,this.actionBtns_mc.a0,6,6,5,0,0,6);
         this.actionTriggers[1] = new WeevilActionTrigger(this,this.actionBtns_mc.a1,2,2,3,0,0,-1,50);
         this.actionTriggers[2] = new WeevilActionTrigger(this,this.actionBtns_mc.a2,3,3,3,0,0,-1,51);
         this.actionTriggers[3] = new WeevilActionTrigger(this,this.actionBtns_mc.a3,1,0,5,0,5);
         this.actionTriggers[4] = new WeevilActionTrigger(this,this.actionBtns_mc.a4,7,7,25,0,0,7);
         this.actionTriggers[5] = new WeevilActionTrigger(this,this.actionBtns_mc.a5,4,4,2,0,0,-1,52);
         this.actionTriggers[6] = new WeevilActionTrigger(this,this.actionBtns_mc.a6,5,5,2,0,0,-1,53);
         this.actionTriggers[7] = new WeevilActionTrigger(this,this.actionBtns_mc.a7,8,1,10,1,0,-1,49);
         this.actionTriggers[8] = new WeevilActionTrigger(this,this.actionBtns_mc.a8,9,14,48);
         this.actionTriggers[9] = new WeevilActionTrigger(this,this.actionBtns_mc.a9,12,10,0.1,1,1,0);
         this.actionTriggers[10] = new WeevilActionTrigger(this,this.actionBtns_mc.a10,10,13,58,1);
         this.actionTriggers[11] = new WeevilActionTrigger(this,this.actionBtns_mc.a11,11,12,78,1);
         this.actionTriggers[12] = new WeevilActionTrigger(this,this.actionBtns_mc.a12,13,23,50,0,3);
         this.actionTriggers[13] = new WeevilActionTrigger(this,this.actionBtns_mc.a13,15,0,0,1,4,0);
         this.actionTriggers[13].setMaxPowerLevel(0);
         this.actionTriggers[14] = new WeevilActionTrigger(this,this.actionBtns_mc.a14,14,22,150,1,2,0);
         this.actionTriggers[15] = new WeevilActionTrigger(this,this.actionBtns_mc.a15,15,5,48,1,0);
         this.actionTriggers[16] = new WeevilActionTrigger(this,this.actionBtns_mc.a16,15,5,48,1,0);
         this.actionTriggers[17] = new WeevilActionTrigger(this,this.actionBtns_mc.a17,15,5,48,1,0);
         this.actionTriggers[18] = new WeevilActionTrigger(this,this.actionBtns_mc.a18,15,5,48,1,0);
         this.actionTriggers[19] = new WeevilActionTrigger(this,this.actionBtns_mc.a19,15,5,48,1,0);
         var _loc5_:int = int(this.actionTriggers.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(_loc6_ < 7)
            {
               this.actionTriggers[_loc6_].vis = true;
            }
            else
            {
               this.actionTriggers[_loc6_].vis = false;
            }
            _loc6_++;
         }
         this.actionEnablers = new Array();
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[7],2,1));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[8],3,0));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[9],4,1));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[10],5,1));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[9],6,2));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[7],7,2));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[11],8,1));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[10],9,2));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[9],10,3));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[7],11,3));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[11],12,2));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[9],13,4));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[10],14,3));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[11],15,3));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[12],16,0));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[7],17,4));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[13],18,1));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[10],19,4));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[14],20,1));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[7],21,5));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[13],22,2));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[11],23,4));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[14],24,2));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[10],26,5));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[11],28,5));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[13],30,3));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[14],32,3));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[13],34,4));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[14],36,4));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[9],38,5));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[14],40,5));
         this.actionEnablers.push(new WeevilActionEnabler(this.actionTriggers[13],42,5));
         this.specialMoveBts = new Array();
         this.hideAllSpecialMovesBts();
         this.specialMoveIndexs = new Array();
         this.currentIndex = 20;
         var _loc9_:Boolean = true;
         _loc8_ = 23;
         _loc7_ = WeevilBehaviours.BECOME_SNOW_WEEVIL;
         this.addSpecialMoveBt(_loc8_,_loc7_);
         _loc8_ = 24;
         _loc7_ = WeevilBehaviours.BECOME_TYCOON_HAT;
         this.addSpecialMoveBt(_loc8_,_loc7_,_loc9_);
         _loc8_ = 27;
         _loc7_ = WeevilBehaviours.BECOME_FROG;
         this.addSpecialMoveBt(_loc8_,_loc7_,_loc9_);
         _loc8_ = 28;
         _loc7_ = WeevilBehaviours.BECOME_RUBBER_DUCK;
         this.addSpecialMoveBt(_loc8_,_loc7_,_loc9_);
         var _loc10_:int = 20;
         while(_loc10_ < this.currentIndex)
         {
            this.actionTriggers[_loc10_].vis = false;
            _loc10_++;
         }
         this.acquiredMoves = new Array();
         this.actionsBtn_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.showHideActionBtns);
         this.actionsBtn_mc.addEventListener(MouseEvent.MOUSE_OVER,this.actionsBtn_MOUSE_OVER);
         this.actionsBtn_mc.addEventListener(MouseEvent.MOUSE_OUT,this.actionsBtn_MOUSE_OUT);
         this.actionsBtn_mc.mouseChildren = false;
         this.actionsBtn_mc.buttonMode = true;
         this.actionBtns_mc.addEventListener(MouseEvent.ROLL_OUT,this.startHideTimer);
         this.actionBtns_mc.addEventListener(MouseEvent.ROLL_OVER,this.stopHideTimer);
         this.rechargeTimer = new Timer(100,0);
         this.rechargeTimer.addEventListener("timer",this.recharge);
         this.hideTimer = new Timer(600,1);
         this.hideTimer.addEventListener("timer",this.hideTimerListener);
         this.actionsBtnFlashTimer = new Timer(500,0);
         this.actionsBtnFlashTimer.addEventListener("timer",this.flashActionsBtn);
         EventManager.get_instance().addEventListener(BinEvents.LEVEL_UP,this.startActionsBtnFlash);
         this.placeSpecialMoveBts();
      }
      
      private function addSpecialMoveBt(param1:int, param2:int, param3:Boolean = false) : void
      {
         var _loc5_:WeevilActionTrigger = null;
         var _loc4_:MovieClip = this.actionBtns_mc["a" + this.currentIndex];
         _loc5_ = new WeevilActionTrigger(this,_loc4_,param1,param2,50,0,0);
         _loc5_.tycoonOnly = param3;
         this.actionTriggers[this.currentIndex] = _loc5_;
         this.specialMoveBts.push(_loc5_);
         this.specialMoveIndexs[param2] = this.currentIndex;
         this.actionEnablers.push(new WeevilActionEnabler(_loc5_,1,5));
         ++this.currentIndex;
      }
      
      public function setAcquiredMoves(param1:String) : void
      {
         if(param1.length > 0)
         {
            this.acquiredMoves = param1.split(";");
         }
         this.acquiredMoves.push(WeevilBehaviours.BECOME_TYCOON_HAT);
         this.acquiredMoves.push(WeevilBehaviours.BECOME_FROG);
         this.acquiredMoves.push(WeevilBehaviours.BECOME_RUBBER_DUCK);
         this.setLevel(this.level);
      }
      
      public function getAcquiredMoveStr() : String
      {
         return this.acquiredMoves.join(";");
      }
      
      public function addAcquiredMove(param1:int) : Boolean
      {
         if(!this.specialMoveAcquired(param1))
         {
            this.acquiredMoves.push(param1);
            this.startActionsBtnFlash();
            this.setLevel(this.level);
            return true;
         }
         return false;
      }
      
      private function showHideActionBtns(param1:MouseEvent) : void
      {
         if(!this.actionBtns_mc.visible)
         {
            this.showActionBtns();
         }
         else
         {
            this.hideActionBtns();
         }
      }
      
      public function startActionsBtnFlash(param1:Event = null) : void
      {
         if(QuestControl.isTaskComplete(NewUserProgressManager.DECORATE_NEST_TASK))
         {
            this.actionsBtnFlashTimer.start();
         }
      }
      
      private function flashActionsBtn(param1:TimerEvent) : void
      {
         if(this.actionsBtn_mc.currentFrame == 1)
         {
            this.actionsBtn_mc.gotoAndStop(2);
         }
         else
         {
            this.actionsBtn_mc.gotoAndStop(1);
         }
      }
      
      private function actionsBtn_MOUSE_OVER(param1:MouseEvent) : void
      {
         this.actionsBtn_mc.gotoAndStop(2);
         this.UI_main.showHint("Actions<br><font color=\'" + this.UI_main.infoTxtColour + "\'>Do loads of cool moves to impress your friends!<br>Get new moves when you level up.</font>",350,550);
      }
      
      private function actionsBtn_MOUSE_OUT(param1:MouseEvent) : void
      {
         this.actionsBtn_mc.gotoAndStop(1);
         this.UI_main.hideHint();
      }
      
      private function showActionBtns(param1:MouseEvent = null) : void
      {
         var _loc2_:* = undefined;
         this.hideTimer.stop();
         this.actionsBtnFlashTimer.stop();
         for(_loc2_ in this.actionTriggers)
         {
            this.actionTriggers[_loc2_].resetClr();
         }
         this.actionBtns_mc.visible = true;
         this.UI_main.hideWeevilExpressions();
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
         this.hideActionBtns();
      }
      
      public function hideActionBtns(param1:MouseEvent = null) : void
      {
         this.actionBtns_mc.visible = false;
      }
      
      public function setLevel(param1:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         this.level = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this.actionEnablers.length)
         {
            this.actionEnablers[_loc2_].enableIfAuthorised(this.level);
            _loc2_++;
         }
         if(this.specialMoveAcquired(23))
         {
            this.actionTriggers[12].enable();
         }
         else
         {
            this.actionTriggers[12].disable();
         }
         var _loc3_:Array = WeevilBehaviours.SPECIAL_MOVES;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = int(_loc3_[_loc4_]);
            _loc6_ = int(this.specialMoveIndexs[_loc5_]);
            if(_loc6_ != 0)
            {
               _loc7_ = this.specialMoveAcquired(_loc5_);
               _loc8_ = false;
               if(!this.actionTriggers[_loc6_].tycoonOnly || this.bin.tycoon)
               {
                  _loc8_ = true;
               }
               if(_loc7_ && _loc8_)
               {
                  this.actionTriggers[_loc6_].enable();
               }
               else
               {
                  this.actionTriggers[_loc6_].disable();
               }
            }
            _loc4_++;
         }
         this.placeSpecialMoveBts();
      }
      
      private function specialMoveAcquired(param1:int) : Boolean
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.acquiredMoves)
         {
            if(int(this.acquiredMoves[_loc2_]) == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function setEnergyCap(param1:Number) : void
      {
         if(param1 > this.energyCap)
         {
            this.energyCap = param1;
            this.startEnergyRecharge();
         }
         else
         {
            this.energyCap = param1;
         }
      }
      
      private function recharge(param1:TimerEvent) : void
      {
         if(this.energy < this.energyCap)
         {
            this.energy = Number(this.energy + this.rechargeRate);
         }
         else
         {
            this.energy = this.energyCap;
            this.rechargeTimer.stop();
         }
         this.energyBar_spr.scaleX = 0.01 * this.energy;
      }
      
      public function triggerAction(param1:int, param2:Number, param3:int, param4:int) : void
      {
         var _loc5_:* = NaN;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         if(Bin.controlsEnabled)
         {
            _loc5_ = param2;
            if(param3 > 1)
            {
               _loc5_ *= param3;
            }
            if(this.energyUpdate(_loc5_))
            {
               this.energyBarBG_mc.gotoAndStop(1);
               _loc6_ = "-1";
               if(param3 > 0)
               {
                  _loc6_ = String(param3);
               }
               else if(param1 == 14)
               {
                  _loc7_ = Utils.getRndInt(0,3);
                  _loc6_ = String(_loc7_);
               }
               if(Bin.controlsEnabled)
               {
                  this.bin.myWeevilAct(param1,param4,_loc6_);
               }
            }
         }
      }
      
      public function initSpecialTransMove(param1:Number, param2:int, param3:int, param4:int) : void
      {
         if(param2 == 3)
         {
            this.bin.myWeevil.cancelAllMoves();
         }
         if(Bin.controlsEnabled)
         {
            this.transMoveID = param2;
            if(param2 == 2)
            {
               this.bin.resetTransMoves();
               this.UI_main.keepCrosshairsCount = uint(param3);
            }
            this.selectedPowerLevel = param3;
            this.UI_main.activateCrosshairs(true);
         }
      }
      
      public function get maxSuperJumpRange() : Number
      {
         var _loc1_:Number = NaN;
         switch(this.actionTriggers[9].maxPowerLevel)
         {
            case 0:
               _loc1_ = 0;
               break;
            case 1:
               _loc1_ = 300;
               break;
            case 2:
               _loc1_ = 600;
               break;
            case 3:
               _loc1_ = 950;
               break;
            case 4:
               _loc1_ = 1400;
               break;
            case 5:
               _loc1_ = 5000;
         }
         return _loc1_;
      }
      
      public function get maxSuperSpeedLevel() : int
      {
         return this.actionTriggers[13].maxPowerLevel;
      }
      
      public function incrSuperSpeedLevel() : int
      {
         if(this.selectedPowerLevel < this.maxSuperSpeedLevel)
         {
            ++this.selectedPowerLevel;
         }
         return this.selectedPowerLevel;
      }
      
      public function checkEnergySufficient(param1:int, param2:Number) : Boolean
      {
         var _loc3_:Number = 0;
         switch(param1)
         {
            case 1:
               _loc3_ = this.actionTriggers[9].energyRequirement * param2;
               break;
            case 2:
               _loc3_ = this.actionTriggers[14].energyRequirement * this.selectedPowerLevel;
               break;
            case 3:
               _loc3_ = Number(this.actionTriggers[12].energyRequirement);
         }
         return this.energyUpdate(_loc3_);
      }
      
      private function applyLevelAdjustment(param1:*) : Number
      {
         return 5 * param1 / (this.level + 2);
      }
      
      public function energyUpdate(param1:Number) : Boolean
      {
         param1 = this.applyLevelAdjustment(param1);
         if(param1 < this.energy)
         {
            this.energy = Number(this.energy - param1);
            this.weevilStatManager.adjustFood(-0.005 * param1);
            this.energyBar_spr.scaleX = 0.01 * this.energy;
            this.startEnergyRecharge();
            return true;
         }
         this.energyBarBG_mc.gotoAndPlay(2);
         this.UI_main.setMouth(3);
         return false;
      }
      
      private function startEnergyRecharge() : void
      {
         this.rechargeRate = Number(1.5);
         this.rechargeTimer.start();
      }
      
      private function placeSpecialMoveBts() : void
      {
         var _loc3_:WeevilActionTrigger = null;
         var _loc4_:MovieClip = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.specialMoveBts.length)
         {
            _loc3_ = this.specialMoveBts[_loc2_];
            if(_loc3_.enabled)
            {
               _loc4_ = _loc3_.bt;
               _loc4_.x = 197 + 47 * _loc1_;
               _loc4_.y = -45.35;
               _loc1_++;
            }
            _loc2_++;
         }
      }
      
      private function hideAllSpecialMovesBts() : void
      {
         var _loc1_:int = 20;
         while(_loc1_ < 70)
         {
            this.actionBtns_mc["a" + _loc1_].visible = false;
            _loc1_++;
         }
      }
   }
}

