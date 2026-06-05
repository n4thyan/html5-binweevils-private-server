package com.binweevils.petProfile
{
   import com.binweevils.engine3D.visuals.creatures.pets.Pet;
   import com.binweevils.engine3D.visuals.creatures.pets.PetSkillNames;
   import com.binweevils.engine3D.visuals.creatures.pets.PetSkillsTricksProgression;
   import com.binweevils.engine3D.visuals.creatures.pets.SkillRequired;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class PetCommandsUIactionBt extends EventDispatcher
   {
      
      private var skillBar:ProgressBar;
      
      private var hasProgressBar:Boolean;
      
      private var skillRequirements:Array;
      
      private var currentPet:Pet;
      
      private var locked:Boolean;
      
      public var skill:int;
      
      public var mc:MovieClip;
      
      public function PetCommandsUIactionBt(param1:MovieClip, param2:int, param3:Boolean = false)
      {
         super();
         this.skill = param2;
         this.mc = param1;
         this.hasProgressBar = param3;
         this.skillRequirements = PetSkillsTricksProgression.skillRequirements(param2);
         if(this.hasProgressBar)
         {
            this.skillBar = new ProgressBar(this.mc.progressBar);
            this.mc.stop();
            this.mc.progressBar.mouseChildren = false;
         }
         else
         {
            this.mc.gotoAndStop(12);
         }
         this.mc.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this.mc.addEventListener(MouseEvent.CLICK,this.mouseClickHandler);
         this.mc.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
         this.mc.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
         this.mc.unlockedAnim_mc.visible = false;
      }
      
      public function getActionForCurrentPet(param1:Pet) : int
      {
         if(this.skill == PetSkillNames.SIT)
         {
            if(param1.sitting)
            {
               return PetSkillNames.STAY;
            }
         }
         else if(this.skill == PetSkillNames.JUMP_ON)
         {
            if(param1.ridingOwner)
            {
               return PetSkillNames.JUMP_OFF;
            }
         }
         else if(this.skill == PetSkillNames.JUGGLE && param1.juggling)
         {
            return PetSkillNames.STOP_JUGGLING;
         }
         return this.skill;
      }
      
      public function getHintForCurrentPet(param1:Pet) : String
      {
         var _loc3_:* = null;
         var _loc5_:int = 0;
         var _loc6_:SkillRequired = null;
         var _loc7_:int = 0;
         var _loc2_:int = this.getActionForCurrentPet(param1);
         if(_loc2_ == PetSkillNames.CALL)
         {
            _loc3_ = param1.name + param1.getSkillNameByID(PetSkillNames.CALL);
         }
         else
         {
            _loc3_ = param1.getSkillNameByID(_loc2_).toUpperCase();
         }
         var _loc4_:Array = PetSkillsTricksProgression.getMimicSkills();
         if(_loc2_ == PetSkillNames.JUMP)
         {
            _loc3_ += "\nCopycat! Jump and your pet will jump too!";
         }
         else if(this.locked)
         {
            _loc3_ += "\n To unlock you need:";
            _loc5_ = 0;
            while(_loc5_ < this.skillRequirements.length)
            {
               _loc6_ = this.skillRequirements[_loc5_];
               _loc7_ = _loc6_.level;
               _loc3_ += "\nLevel " + _loc7_ + " " + param1.getSkillNameByID(_loc6_.id);
               _loc5_++;
            }
         }
         return _loc3_;
      }
      
      public function getGlobalPosition() : Point
      {
         return this.mc.parent.localToGlobal(new Point(this.mc.x,this.mc.y));
      }
      
      public function updateBtForCurrentPet(param1:Pet) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         this.currentPet = param1;
         if(this.meetsAllrequirements())
         {
            if(this.locked)
            {
               this.mc.unlockedAnim_mc.visible = true;
               this.mc.unlockedAnim_mc.gotoAndPlay(2);
            }
            this.locked = false;
            this.mc.alpha = 1;
            this.mc.filters = [];
            if(this.hasProgressBar)
            {
               _loc2_ = param1.getSkillLevel(this.skill);
               this.skillBar.updateSkillLevel(_loc2_);
               _loc3_ = PetSkillsTricksProgression.convertLevelToTenScale(_loc2_);
               this.mc.gotoAndStop(_loc3_);
            }
         }
         else
         {
            this.locked = true;
            this.mc.alpha = 0.6;
            this.mc.gotoAndStop(12);
            this.mc.filters = PetSkillsTricksProgression.getGreyLockedFilter();
         }
      }
      
      public function meetsAllrequirements() : Boolean
      {
         var _loc2_:SkillRequired = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc1_:int = 0;
         while(_loc1_ < this.skillRequirements.length)
         {
            _loc2_ = this.skillRequirements[_loc1_];
            _loc3_ = this.currentPet.getSkillLevel(_loc2_.id);
            _loc4_ = PetSkillsTricksProgression.convertLevelToHundredScale(_loc2_.level);
            if(_loc3_ < _loc4_)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      private function mouseDownHandler(param1:MouseEvent) : void
      {
         if(!this.locked)
         {
            dispatchEvent(new PetCommandsUIEvent(PetCommandsUIEvent.MOUSE_DOWN,this));
         }
      }
      
      private function mouseClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:Array = PetSkillsTricksProgression.getMimicSkills();
         if(!this.locked && _loc2_.indexOf(this.skill) == -1)
         {
            dispatchEvent(new PetCommandsUIEvent(PetCommandsUIEvent.MOUSE_CLICK,this));
         }
      }
      
      private function mouseOverHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new PetCommandsUIEvent(PetCommandsUIEvent.MOUSE_OVER,this));
      }
      
      private function mouseOutHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new PetCommandsUIEvent(PetCommandsUIEvent.MOUSE_OUT,this));
      }
   }
}

