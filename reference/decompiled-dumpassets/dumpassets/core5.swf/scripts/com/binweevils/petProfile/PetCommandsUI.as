package com.binweevils.petProfile
{
   import com.binweevils.Bin_extInterface;
   import com.binweevils.UImain;
   import com.binweevils.engine3D.visuals.creatures.pets.Pet;
   import com.binweevils.engine3D.visuals.creatures.pets.PetSkillNames;
   import com.binweevils.engine3D.visuals.creatures.pets.PetSkillsTricksProgression;
   import com.binweevils.engine3D.visuals.creatures.pets.behaviours.Ball;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class PetCommandsUI
   {
      
      private var _UI:UImain;
      
      private var petCommands_spr:Sprite;
      
      private var jugglingTricksUI_spr:Sprite;
      
      private var jugglingTricksPanel_spr:Sprite;
      
      private var jugglingTricksPanelShadow_spr:Sprite;
      
      private var cmdBtns:Array;
      
      private var balls:Array;
      
      private var maxBalls:int;
      
      public var ballToThrowID:int;
      
      private var numBalls:int;
      
      private var trickIcons:Array;
      
      private var skillBarsAr:Array = new Array();
      
      private var actionBts:Array;
      
      private var ballsSelectorUI:BallsNumberSelectionUI;
      
      private var trickSelector:TricksSelectionUI;
      
      private var petProfile_mc:MovieClip;
      
      public var crntPet:Pet;
      
      public function PetCommandsUI(param1:UImain, param2:Sprite, param3:Sprite, param4:MovieClip, param5:MovieClip)
      {
         super();
         this._UI = param1;
         this.petProfile_mc = param5;
         this.petProfile_mc.petCommands_bt.addEventListener(MouseEvent.CLICK,this.petCommandsBtClickHandler);
         this.petProfile_mc.petProfile_bt.addEventListener(MouseEvent.CLICK,this.petProfileBtClickHandler);
         this.petCommands_spr = param2;
         this.jugglingTricksUI_spr = param3;
         this.ballsSelectorUI = new BallsNumberSelectionUI(MovieClip(this.jugglingTricksUI_spr),this.selectedNumberBallsHandler);
         var _loc6_:Array = PetSkillsTricksProgression.getUnlockBallRequirements();
         var _loc7_:Array = new Array();
         var _loc8_:int = 1;
         while(_loc8_ < _loc6_.length)
         {
            _loc7_[_loc8_] = PetSkillsTricksProgression.convertLevelToTenScale(_loc6_[_loc8_]);
            _loc8_++;
         }
         this.ballsSelectorUI.setBallsRequirements(_loc7_);
         this.jugglingTricksPanel_spr = Sprite(this.jugglingTricksUI_spr.getChildByName("panelBG_spr"));
         this.jugglingTricksPanelShadow_spr = Sprite(this.jugglingTricksUI_spr.getChildByName("panelShadow_spr"));
         var _loc9_:SimpleButton = SimpleButton(this.jugglingTricksUI_spr.getChildByName("close_btn"));
         _loc9_.addEventListener(MouseEvent.CLICK,this.hideJugglingTricks);
         this.trickIcons = new Array();
         this.balls = new Array();
         var _loc10_:Sprite = Sprite(this.petCommands_spr.getChildByName("balls_spr"));
         var _loc11_:int = 1;
         while(_loc11_ <= 9)
         {
            this.balls[_loc11_ - 1] = _loc10_.getChildByName("ball" + _loc11_ + "_spr");
            _loc11_++;
         }
      }
      
      private function petProfileBtClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:Object = Bin_extInterface.bin;
         _loc2_.showPetProfile(this.crntPet,true);
      }
      
      private function petCommandsBtClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:Object = Bin_extInterface.bin;
         _loc2_.showPetProfile(this.crntPet,false);
      }
      
      public function setUpCmdBtns() : void
      {
         var _loc1_:PetCommandsUIactionBt = null;
         var _loc4_:PetCommandsUIactionBt = null;
         var _loc2_:MovieClip = MovieClip(this.petCommands_spr);
         this.actionBts = new Array();
         this.actionBts.push(new PetCommandsUIactionBt(_loc2_.action_0,PetSkillNames.CALL));
         this.actionBts.push(new PetCommandsUIactionBt(_loc2_.action_1,PetSkillNames.COME_HERE));
         this.actionBts.push(new PetCommandsUIactionBt(_loc2_.action_19,PetSkillNames.GO_THERE));
         this.actionBts.push(new PetCommandsUIactionBt(_loc2_.action_2,PetSkillNames.SIT));
         this.actionBts.push(new PetCommandsUIactionBt(_loc2_.action_4,PetSkillNames.GO_TO_BED));
         this.actionBts.push(new PetCommandsUIactionBt(_loc2_.action_5,PetSkillNames.JUMP_ON));
         this.actionBts.push(new PetCommandsUIactionBt(_loc2_.action_10,PetSkillNames.SPIN,true));
         this.actionBts.push(new PetCommandsUIactionBt(_loc2_.action_15,PetSkillNames.JUMP,true));
         _loc2_.action_15.mouseChildren = false;
         this.actionBts.push(new PetCommandsUIactionBt(_loc2_.action_11,PetSkillNames.FAST_SPIN,true));
         this.actionBts.push(new PetCommandsUIactionBt(_loc2_.action_12,PetSkillNames.JUMP_SPIN,true));
         this.actionBts.push(new PetCommandsUIactionBt(_loc2_.action_13,PetSkillNames.SUPER_SPIN,true));
         this.actionBts.push(new PetCommandsUIactionBt(_loc2_.action_14,PetSkillNames.BOUNCE_SPIN,true));
         this.actionBts.push(new PetCommandsUIactionBt(_loc2_.action_20,PetSkillNames.WEEVIL_THROW_BALL));
         this.actionBts.push(new PetCommandsUIactionBt(_loc2_.action_6,PetSkillNames.FETCH,true));
         this.actionBts.push(new PetCommandsUIactionBt(_loc2_.action_7,PetSkillNames.THROW_TO_ME,true));
         this.actionBts.push(new PetCommandsUIactionBt(_loc2_.action_8,PetSkillNames.JUGGLE,true));
         var _loc3_:int = 0;
         while(_loc3_ < this.actionBts.length)
         {
            _loc4_ = this.actionBts[_loc3_];
            _loc4_.addEventListener(PetCommandsUIEvent.MOUSE_DOWN,this.cmd_MOUSE_DOWN);
            _loc4_.addEventListener(PetCommandsUIEvent.MOUSE_CLICK,this.cmd_CLICK);
            _loc4_.addEventListener(PetCommandsUIEvent.MOUSE_OVER,this.cmd_MOUSE_OVER);
            _loc4_.addEventListener(PetCommandsUIEvent.MOUSE_OUT,this.cmd_MOUSE_OUT);
            _loc3_++;
         }
      }
      
      private function changeCurrentPet(param1:Pet) : void
      {
         if(this.crntPet != null)
         {
            this.removePetSkillUpdateListener(this.crntPet);
         }
         this.crntPet = param1;
         this.addPetSkillUpdateListener(this.crntPet);
      }
      
      private function addPetSkillUpdateListener(param1:Pet) : void
      {
         param1.events.addEventListener(Pet.SKILLS_UPDATED_EVENT,this.updateUI);
      }
      
      private function removePetSkillUpdateListener(param1:Pet) : void
      {
         param1.events.removeEventListener(Pet.SKILLS_UPDATED_EVENT,this.updateUI);
      }
      
      public function showPublicProfile(param1:Pet = null) : void
      {
         this.petCommands_spr.visible = false;
         this.hideJugglingTricks();
         this.petProfile_mc.petCommands_bt.visible = false;
         if(param1 != null)
         {
            this.changeCurrentPet(param1);
            if(param1.mine)
            {
               this.petProfile_mc.petCommands_bt.visible = true;
            }
         }
         this.petProfile_mc.petProfile_bt.visible = false;
         this.petProfile_mc.help_btn.visible = false;
      }
      
      public function showAvailableCmds(param1:Pet) : void
      {
         this.changeCurrentPet(param1);
         this.reset();
         this.updateUI();
         this.petCommands_spr.visible = true;
         this.petProfile_mc.petCommands_bt.visible = false;
         if(param1.mine)
         {
            this.petProfile_mc.petProfile_bt.visible = true;
            this.petProfile_mc.help_btn.visible = true;
         }
         else
         {
            this.petProfile_mc.petProfile_bt.visible = false;
            this.petProfile_mc.help_btn.visible = false;
         }
      }
      
      private function updateUI(param1:Event = null) : void
      {
         var _loc2_:Number = this.crntPet.getSkillLevel(PetSkillNames.JUGGLE);
         this.maxBalls = PetSkillsTricksProgression.getNumBallsUnlocked(_loc2_);
         var _loc3_:int = 0;
         while(_loc3_ < 9)
         {
            if(_loc3_ < this.maxBalls)
            {
               this.balls[_loc3_].visible = true;
            }
            else
            {
               this.balls[_loc3_].visible = false;
            }
            _loc3_++;
         }
         this.updateAllSkillBars();
      }
      
      private function updateAllSkillBars() : void
      {
         var _loc2_:PetCommandsUIactionBt = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.actionBts.length)
         {
            _loc2_ = this.actionBts[_loc1_];
            _loc2_.updateBtForCurrentPet(this.crntPet);
            _loc1_++;
         }
      }
      
      public function reset() : void
      {
         this.hideJugglingTricks();
         this._UI.activateCrosshairs(false);
      }
      
      private function showNumberBallsSelector() : void
      {
         this.ballsSelectorUI.show(this.maxBalls);
         this.selectedNumberBallsHandler(1);
      }
      
      private function selectedNumberBallsHandler(param1:int, param2:String = "A") : void
      {
         if(this.trickSelector != null)
         {
            this.trickSelector.clear();
            this.trickSelector = null;
         }
         var _loc3_:Array = this.crntPet.getJugglingTricks(param1);
         this.jugglingTricksUI_spr.visible = true;
         this.numBalls = param1;
         this.trickSelector = new TricksSelectionUI(param1,_loc3_,this.jugglingTrickSelected,param2);
         this.jugglingTricksUI_spr.addChild(this.trickSelector);
      }
      
      public function showJugglingTricks(param1:int) : void
      {
         var _loc4_:int = 0;
         this.numBalls = param1;
         var _loc2_:Array = this.crntPet.getJugglingTricks(param1);
         var _loc3_:int = int(_loc2_.length);
         var _loc5_:int = int(this.trickIcons.length);
         if(_loc3_ > _loc5_)
         {
            _loc4_ = _loc5_ + 1;
            while(_loc4_ <= _loc3_)
            {
               this.setUpJugglingTrickBtn(_loc4_ - 1);
               _loc4_++;
            }
            _loc5_ = _loc3_;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(_loc4_ < _loc3_)
            {
               this.trickIcons[_loc4_].setTrickAttributes(param1,_loc2_[_loc4_].difficulty,_loc2_[_loc4_]);
               this.trickIcons[_loc4_].vis = true;
            }
            else
            {
               this.trickIcons[_loc4_].vis = false;
            }
            _loc4_++;
         }
         var _loc6_:Number = 78 + 44 * int((_loc3_ - 1) / 4);
         this.jugglingTricksPanel_spr.height = _loc6_;
         this.jugglingTricksPanelShadow_spr.height = _loc6_;
         if(this.jugglingTricksUI_spr.y < 0)
         {
            this.jugglingTricksUI_spr.y = 0;
         }
         this.jugglingTricksUI_spr.visible = true;
      }
      
      private function setUpJugglingTrickBtn(param1:int) : void
      {
         var _loc2_:MovieClip = new trickIconSpr();
         this.trickIcons[param1] = new TrickIcon(this,param1,_loc2_);
         this.jugglingTricksUI_spr.addChildAt(_loc2_,3);
      }
      
      public function hideJugglingTricks(param1:MouseEvent = null) : void
      {
         this.jugglingTricksUI_spr.visible = false;
      }
      
      public function jugglingTrickSelected(param1:int) : void
      {
         this.hideJugglingTricks();
         this.crntPet.juggle(this.numBalls,param1);
      }
      
      private function cmd_MOUSE_OVER(param1:PetCommandsUIEvent) : void
      {
         var _loc2_:PetCommandsUIactionBt = param1.petCommandsBT;
         var _loc3_:Point = _loc2_.getGlobalPosition();
         _loc3_.x += 15;
         _loc3_.y += 40;
         var _loc4_:String = _loc2_.getHintForCurrentPet(this.crntPet);
         this._UI.showHint(_loc4_,_loc3_.x,_loc3_.y);
      }
      
      public function cmd_MOUSE_OUT(param1:PetCommandsUIEvent) : void
      {
         this._UI.hideHint();
      }
      
      public function cmd_MOUSE_DOWN(param1:PetCommandsUIEvent) : void
      {
         this._UI.hideMySpeachBubble();
         this._UI.hideHint();
      }
      
      private function cmd_CLICK(param1:PetCommandsUIEvent) : void
      {
         var _loc2_:PetCommandsUIactionBt = param1.petCommandsBT;
         var _loc3_:int = _loc2_.getActionForCurrentPet(this.crntPet);
         if(_loc3_ == PetSkillNames.WEEVIL_THROW_BALL)
         {
            this.weevilThrowBall();
         }
         else
         {
            if(_loc3_ == PetSkillNames.JUGGLE)
            {
               this.showNumberBallsSelector();
            }
            else if(_loc3_ == PetSkillNames.GO_THERE)
            {
               this._UI.specialTransMove = 6;
               this._UI.activateCrosshairs(true);
            }
            this.issueCmd(_loc3_);
         }
      }
      
      private function weevilThrowBall() : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:Number = NaN;
         var _loc7_:* = undefined;
         var _loc8_:Ball = null;
         var _loc1_:Number = this.crntPet.owner.x;
         var _loc2_:Number = this.crntPet.owner.z;
         var _loc6_:Number = this.crntPet.scale * 300;
         var _loc9_:Array = this.crntPet.balls;
         var _loc10_:int = int(_loc9_.length);
         for each(_loc7_ in _loc9_)
         {
            if(_loc7_.y <= 0.52)
            {
               _loc3_ = _loc1_ - _loc7_.x;
               _loc4_ = _loc2_ - _loc7_.z;
               _loc5_ = Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
               if(_loc5_ < _loc6_)
               {
                  _loc6_ = _loc5_;
                  _loc8_ = _loc7_;
               }
            }
         }
         this.ballToThrowID = -1;
         if(_loc8_ == null)
         {
            if(_loc10_ < this.maxBalls)
            {
               this.ballToThrowID = _loc10_;
            }
         }
         else
         {
            this.ballToThrowID = _loc8_.id;
         }
         if(this.ballToThrowID > -1)
         {
            this._UI.activateCrosshairs(true);
         }
      }
      
      public function issueCmd(param1:int) : void
      {
         this._UI.sendPetCmd(this.crntPet.name,this.crntPet.nameHash,param1);
      }
   }
}

