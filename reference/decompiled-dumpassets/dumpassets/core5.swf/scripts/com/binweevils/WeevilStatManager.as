package com.binweevils
{
   import com.binweevils.DBaccess.PHPcall;
   import com.binweevils.engine3D.sin;
   import com.binweevils.newUserTutorial.NewUserProgressManager;
   import com.binweevils.utilities.StarColourer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.media.Sound;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class WeevilStatManager
   {
      
      private var bin:Bin;
      
      private var UI_main:UImain;
      
      private var weevilActionsUI:WeevilActionsUI;
      
      private var levelDisplay_spr:Sprite;
      
      private var mulchDisplay_spr:Sprite;
      
      private var mulchIcon_mc:MovieClip;
      
      private var doshDisplay_spr:Sprite;
      
      private var doshIcon_mc:MovieClip;
      
      private var levelIndicator_spr:Sprite;
      
      private var levelStar_spr:Sprite;
      
      private var levelProgress_mc:MovieClip;
      
      private var levelProgressBar_spr:Sprite;
      
      private var levelNum_txt:TextField;
      
      private var mulch_txt:TextField;
      
      private var dosh_txt:TextField;
      
      private var weevilStats_mc:MovieClip;
      
      private var nestBtnGlow_mc:MovieClip;
      
      private var decayTimer:Timer;
      
      private var tingSound:Sound;
      
      private var xp:int;
      
      private var _level:int;
      
      private var newLevel:int;
      
      private var _levelUpDue:Boolean;
      
      private var xp_threshold1:*;
      
      private var xp_threshold2:*;
      
      private var dxp:*;
      
      private var _mulch:int;
      
      private var mulchTemp:int;
      
      private var mulchIncr:int;
      
      private var incrMulchTimer:Timer;
      
      private var _dosh:int;
      
      private var doshTemp:int;
      
      private var doshIncr:int;
      
      private var incrDoshTimer:Timer;
      
      private var spinStarTimer:*;
      
      private var jiggleStarTimer:Timer;
      
      private var rotIncr:Number;
      
      private var t:Number;
      
      private var speedUp:Boolean;
      
      private var resetX:*;
      
      private var resetY:Number;
      
      private var food:WeevilStat;
      
      private var foodCost:int;
      
      private var foodEnergyValue:int;
      
      private var foodCallBack_fn:Function;
      
      private var updateDBTimer:Timer;
      
      private var foodType:String;
      
      public function WeevilStatManager(param1:UImain, param2:Sprite, param3:Sprite, param4:Sprite, param5:MovieClip, param6:MovieClip)
      {
         super();
         this.bin = Bin.get_instance();
         this.UI_main = param1;
         this.levelDisplay_spr = param2;
         this.mulchDisplay_spr = param3;
         this.mulchIcon_mc = MovieClip(this.mulchDisplay_spr.getChildByName("mulchIcon_mc"));
         this.doshDisplay_spr = param4;
         this.doshIcon_mc = MovieClip(this.doshDisplay_spr.getChildByName("doshIcon_mc"));
         this.weevilStats_mc = param5;
         this.nestBtnGlow_mc = param6;
         this.nestBtnGlow_mc.mouseEnabled = false;
         this.nestBtnGlow_mc.mouseChildren = false;
         this.nestBtnGlow_mc.visible = false;
         this.nestBtnGlow_mc.gotoAndStop(1);
         param2.visible = false;
         param3.visible = false;
         param4.visible = false;
         param5.visible = false;
         this.levelIndicator_spr = Sprite(param2.getChildByName("levelIndicator_spr"));
         this.levelStar_spr = Sprite(this.levelIndicator_spr.getChildByName("levelStar_spr"));
         this.levelNum_txt = TextField(this.levelIndicator_spr.getChildByName("levelNum_txt"));
         this.levelProgress_mc = MovieClip(param2.getChildByName("levelProgress_mc"));
         this.levelProgressBar_spr = Sprite(this.levelProgress_mc.getChildByName("bar_spr"));
         param2.addEventListener(MouseEvent.ROLL_OVER,this.showXp);
         param2.addEventListener(MouseEvent.ROLL_OUT,this.hideHint);
         this.weevilStats_mc.rollOver_food_btn.addEventListener(MouseEvent.ROLL_OVER,this.showFood);
         this.weevilStats_mc.rollOver_food_btn.addEventListener(MouseEvent.ROLL_OUT,this.hideHint);
         this.mulch_txt = TextField(param3.getChildByName("mulch_txt"));
         this.dosh_txt = TextField(param4.getChildByName("dosh_txt"));
         param3.addEventListener(MouseEvent.ROLL_OVER,this.showMulchHint);
         param3.addEventListener(MouseEvent.ROLL_OUT,this.hideHint);
         param4.addEventListener(MouseEvent.ROLL_OVER,this.showDoshHint);
         param4.addEventListener(MouseEvent.ROLL_OUT,this.hideHint);
         this.food = new WeevilStat(this.weevilStats_mc.foodBar_mc,0.1,this.foodStatusAlert);
         this.incrMulchTimer = new Timer(50,0);
         this.incrMulchTimer.addEventListener("timer",this.incrMulch);
         this.incrDoshTimer = new Timer(50,0);
         this.incrDoshTimer.addEventListener("timer",this.incrDosh);
         this.spinStarTimer = new Timer(20,0);
         this.spinStarTimer.addEventListener("timer",this.spinStar);
         this.jiggleStarTimer = new Timer(20,0);
         this.jiggleStarTimer.addEventListener("timer",this.jiggleStar);
         this.updateDBTimer = new Timer(120000,0);
         this.updateDBTimer.addEventListener("timer",this.sendUpdate);
         this.tingSound = new ting();
      }
      
      public function set_weevilActionsUI(param1:*) : void
      {
         this.weevilActionsUI = param1;
      }
      
      public function setStats(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:Number) : void
      {
         this.level = param1;
         this.setXpThresholds(param3,param4);
         this.setXp(param2);
         this.mulch = param5;
         this.dosh = param6;
         this.foodLevel = param7;
         this.levelDisplay_spr.visible = true;
         this.mulchDisplay_spr.visible = true;
         this.doshDisplay_spr.visible = true;
         this.weevilStats_mc.visible = true;
         this.decayTimer = new Timer(60000,0);
         this.decayTimer.addEventListener("timer",this.decay);
         this.decayTimer.start();
         this.updateDBTimer.start();
      }
      
      private function setXpThresholds(param1:int, param2:int) : void
      {
         this.xp_threshold1 = param1;
         this.xp_threshold2 = param2;
         this.dxp = this.xp_threshold2 - this.xp_threshold1;
      }
      
      public function set level(param1:int) : void
      {
         this._level = param1;
         this.levelNum_txt.text = String(this._level);
         this.setStarClr(this.levelStar_spr,this._level);
         this.weevilActionsUI.setLevel(this.level);
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function get levelUpDue() : Boolean
      {
         return this._levelUpDue;
      }
      
      public function levelUp(param1:*, param2:int, param3:int) : void
      {
         this.setXpThresholds(param2,param3);
         this.updateLevelProgressBar();
         this.newLevel = param1;
         this.rotIncr = 1;
         this.t = 0;
         this.resetX = this.levelIndicator_spr.x;
         this.resetY = this.levelIndicator_spr.y;
         this.speedUp = true;
         this.spinStarTimer.start();
      }
      
      private function spinStar(param1:TimerEvent) : void
      {
         var _loc2_:Event = null;
         this.levelStar_spr.rotation += this.rotIncr;
         if(this.speedUp)
         {
            this.rotIncr += 1;
            if(this.rotIncr > 50)
            {
               this.speedUp = false;
            }
         }
         else if(this.rotIncr > 8)
         {
            --this.rotIncr;
         }
         else if(this.levelStar_spr.rotation < 9 && this.levelStar_spr.rotation > -9)
         {
            this.spinStarTimer.stop();
            this.levelStar_spr.rotation = 0;
            this.level = this.newLevel;
            new gong().play();
            this.jiggleStarTimer.start();
            _loc2_ = new Event(BinEvents.LEVEL_UP);
            EventManager.get_instance().dispatchEvent(_loc2_);
         }
      }
      
      private function jiggleStar(param1:TimerEvent) : void
      {
         var _loc2_:Number = (80 - this.t) * 0.04;
         this.levelIndicator_spr.x = this.resetX + _loc2_ * sin(3.3 * this.t);
         this.levelIndicator_spr.y = this.resetY + _loc2_ * sin(2.7 * this.t);
         this.levelIndicator_spr.scaleX = this.levelIndicator_spr.scaleY = 1 + 0.25 * _loc2_ * sin(0.2 * this.t);
         ++this.t;
         if(_loc2_ < 0.2)
         {
            this.jiggleStarTimer.stop();
            this.levelIndicator_spr.x = this.resetX;
            this.levelIndicator_spr.y = this.resetY;
            this.levelIndicator_spr.scaleX = this.levelIndicator_spr.scaleY = 1;
         }
      }
      
      public function setXp(param1:int) : void
      {
         if(param1 > this.xp)
         {
            this.levelProgress_mc.gotoAndPlay(2);
         }
         this.xp = param1;
         this.updateLevelProgressBar();
      }
      
      public function getXp() : int
      {
         return this.xp;
      }
      
      public function updateXp(param1:int) : void
      {
         var _loc2_:Object = {"value":param1 - this.xp};
         var _loc3_:CustomEvent = new CustomEvent(BinEvents.UI_MAIN_ADDED_XP,_loc2_);
         EventManager.get_instance().dispatchEvent(_loc3_);
         this.setXp(param1);
      }
      
      private function updateLevelProgressBar() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         if(this.xp < this.xp_threshold2)
         {
            _loc1_ = this.xp - this.xp_threshold1;
            _loc2_ = _loc1_ / this.dxp;
            this.levelProgressBar_spr.scaleX = Math.max(_loc2_,0);
            this.nestBtnGlow_mc.visible = false;
            this.nestBtnGlow_mc.gotoAndStop(1);
            this._levelUpDue = false;
         }
         else if(this.xp_threshold2 > this.xp_threshold1)
         {
            this.levelProgressBar_spr.scaleX = 1;
            this.nestBtnGlow_mc.visible = true;
            this.nestBtnGlow_mc.play();
            this._levelUpDue = true;
         }
         else
         {
            this.nestBtnGlow_mc.visible = false;
            this.nestBtnGlow_mc.gotoAndStop(1);
            this._levelUpDue = false;
         }
      }
      
      public function setStarClr(param1:Sprite, param2:int) : void
      {
         StarColourer.applyColour(param1,param2);
      }
      
      public function set mulch(param1:int) : void
      {
         if(param1 >= 0)
         {
            this._mulch = param1;
            this.mulch_txt.text = String(this._mulch);
         }
      }
      
      public function get mulch() : int
      {
         return this._mulch;
      }
      
      public function updateMulch(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:CustomEvent = null;
         if(param1 >= 0 && param1 != this.mulch)
         {
            this.mulchTemp = this.mulch;
            this.mulch = param1;
            _loc2_ = Math.abs(this._mulch - this.mulchTemp);
            this.mulchIncr = int(Math.pow(_loc2_,0.45));
            if(param1 < this.mulchTemp)
            {
               this.mulchIncr = -this.mulchIncr;
               new CashRegister().play();
            }
            else
            {
               this.mulchIcon_mc.gotoAndPlay(2);
               _loc3_ = {"value":this.mulch - this.mulchTemp};
               _loc4_ = new CustomEvent(BinEvents.UI_MAIN_ADDED_MULCH,_loc3_);
               EventManager.get_instance().dispatchEvent(_loc4_);
            }
            this.incrMulchTimer.start();
         }
      }
      
      public function incrMulch(param1:TimerEvent) : void
      {
         var _loc2_:Number = this._mulch - this.mulchTemp;
         if(this.mulchIncr > 0 && _loc2_ > this.mulchIncr || this.mulchIncr < 0 && _loc2_ < this.mulchIncr)
         {
            this.mulchTemp += this.mulchIncr;
            if(this.mulchIncr > 0)
            {
               this.tingSound.play();
            }
         }
         else
         {
            this.mulchTemp = this._mulch;
            this.incrMulchTimer.stop();
         }
         this.mulch_txt.text = String(this.mulchTemp);
      }
      
      public function set dosh(param1:int) : void
      {
         if(param1 >= 0)
         {
            this._dosh = param1;
            this.dosh_txt.text = String(this._dosh);
         }
      }
      
      public function get dosh() : int
      {
         return this._dosh;
      }
      
      public function updateDosh(param1:int) : void
      {
         var _loc2_:int = 0;
         if(param1 >= 0 && param1 != this.dosh)
         {
            this.doshTemp = this.dosh;
            this.dosh = param1;
            _loc2_ = Math.abs(this._dosh - this.doshTemp);
            this.doshIncr = int(Math.pow(_loc2_,0.3));
            if(param1 < this.doshTemp)
            {
               this.doshIncr = -this.doshIncr;
               new CashRegister().play();
            }
            else
            {
               this.doshIcon_mc.gotoAndPlay(2);
            }
            this.incrDoshTimer.start();
         }
      }
      
      public function incrDosh(param1:TimerEvent) : void
      {
         var _loc2_:Number = this._dosh - this.doshTemp;
         if(this.doshIncr > 0 && _loc2_ > this.doshIncr || this.doshIncr < 0 && _loc2_ < this.doshIncr)
         {
            this.doshTemp += this.doshIncr;
            if(this.doshIncr > 0)
            {
            }
         }
         else
         {
            this.doshTemp = this._dosh;
            this.incrDoshTimer.stop();
         }
         this.dosh_txt.text = String(this.doshTemp);
      }
      
      private function showXp(param1:MouseEvent) : void
      {
         var _loc5_:int = 0;
         var _loc2_:String = "XP: " + this.xp;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         if(this.xp_threshold2 == -1)
         {
            _loc4_ = 75;
         }
         else if(this.xp >= this.xp_threshold2)
         {
            if(this.xp_threshold2 > this.xp_threshold1)
            {
               _loc2_ += "<br><font color=\'" + this.UI_main.infoTxtColour + "\'>Go back to your nest to level up!</font>";
            }
            else
            {
               _loc4_ = 75;
            }
         }
         else
         {
            _loc5_ = this.xp_threshold2 - this.xp;
            _loc2_ += "<br><font color=\'" + this.UI_main.infoTxtColour + "\'>You need another " + _loc5_ + " XP to get to level " + (this._level + 1) + ".<br>Earn XP by buying nest items, harvesting plants and completing missions!</font>";
         }
         this.UI_main.showHint(_loc2_,_loc3_,_loc4_);
      }
      
      private function showMulchHint(param1:MouseEvent) : void
      {
         this.UI_main.showHint("Mulch <font color=\'" + this.UI_main.infoTxtColour + "\'>- Spend this on nest items!<br>Earn Mulch by playing games & harvesting plants!</font>",0,140);
      }
      
      private function showDoshHint(param1:MouseEvent) : void
      {
         this.UI_main.showHint("Dosh <font color=\'" + this.UI_main.infoTxtColour + "\'>- spend on extra cool nest items or funky hats.<br>Earn Dosh by becoming a Bin Tycoon member.</font>",0,220);
      }
      
      private function showFood(param1:MouseEvent) : void
      {
         var _loc2_:String = "Food: " + this.foodLevel;
         _loc2_ += "<br><font color=\'" + this.UI_main.infoTxtColour + "\'>Go to Tum\'s diner or Figgs Cafe for food<br>- find it on the map.</font>";
         this.UI_main.showHint(_loc2_,0,300);
      }
      
      private function hideHint(param1:MouseEvent) : void
      {
         this.UI_main.hideHint();
      }
      
      public function get foodLevel() : Number
      {
         return this.food.level;
      }
      
      public function set foodLevel(param1:Number) : void
      {
         if(param1 >= 0 && param1 <= 100)
         {
            this.food.level = param1;
         }
      }
      
      public function requestToEatFood(param1:Boolean, param2:int, param3:int, param4:Function, param5:String = "OTHERS") : void
      {
         var _loc6_:String = null;
         if(this.mulch > param2)
         {
            this.foodCost = param2;
            this.foodType = param5;
            this.foodEnergyValue = param3;
            this.foodCallBack_fn = param4;
            _loc6_ = param1 == true ? "eat" : "drink";
            this.bin.showDialogueBox("This costs " + param2 + " Mulch. Do you want to " + _loc6_ + " it?",this.attemptToEatFood);
         }
         else
         {
            this.bin.showAlertBox("You don\'t have enough Mulch to pay for this food!");
         }
      }
      
      private function attemptToEatFood(param1:Event = null) : void
      {
         var _loc2_:PHPcall = null;
         if(this.mulch > this.foodCost)
         {
            _loc2_ = new PHPcall("weevil/buy-food",true);
            _loc2_.sendAndAwaitResponse(["cost","energyValue","type"],[this.foodCost,this.foodEnergyValue,this.foodType],this.foodEaten,true);
         }
         else
         {
            this.bin.showAlertBox("You don\'t have enough mulch to pay for this!");
         }
      }
      
      private function foodEaten(param1:Object) : void
      {
         this.bin.hideDialogueBox();
         if(param1.success == "1")
         {
            this.foodCallBack_fn();
            this.foodLevel = param1.food;
            this.updateMulch(param1.mulch);
            this.bin.completedNewUserTask(NewUserProgressManager.FEED_WEEVIL_TASK);
         }
         else
         {
            this.bin.showAlertBox("You don\'t have enough mulch to pay for this!");
         }
      }
      
      public function foodStatusAlert(param1:Number) : void
      {
         if(param1 < 35)
         {
            this.weevilActionsUI.setEnergyCap(param1);
         }
         else
         {
            this.weevilActionsUI.setEnergyCap(100);
         }
      }
      
      public function get happinessLevel() : Number
      {
         return 100;
      }
      
      public function set happinessLevel(param1:Number) : void
      {
      }
      
      public function adjustFood(param1:Number) : void
      {
         this.food.adjust(param1);
         if(param1 > 0)
         {
            this.sendUpdate();
         }
      }
      
      public function adjustFitness(param1:Number) : void
      {
      }
      
      public function adjustHappiness(param1:Number, param2:Boolean = true) : void
      {
      }
      
      private function decay(param1:TimerEvent) : void
      {
         this.food.decay();
         if(this.foodLevel < 35)
         {
            this.weevilActionsUI.setEnergyCap(this.foodLevel);
         }
      }
      
      public function getExpMultFactor() : Number
      {
         var _loc1_:Number = 3 * this.food.getDeficit();
         return 0.01 * (100 - _loc1_);
      }
      
      public function sendUpdate(param1:TimerEvent = null) : void
      {
         this.updateDBTimer.reset();
         this.updateDBTimer.start();
         var _loc2_:PHPcall = new PHPcall("weevil/update-stats",true);
         _loc2_.fireAndForget(["food","fitness","happiness"],[this.foodLevel,100,100],true);
      }
   }
}

