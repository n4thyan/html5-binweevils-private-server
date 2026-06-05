package com.binweevils.petProfile
{
   import com.binweevils.engine3D.visuals.creatures.pets.PetSkillsTricksProgression;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class BallsNumberSelectionUI
   {
      
      private var mc:MovieClip;
      
      private var optionSelectedFunc:Function;
      
      public function BallsNumberSelectionUI(param1:MovieClip, param2:Function)
      {
         var _loc3_:MovieClip = null;
         super();
         this.mc = param1;
         this.optionSelectedFunc = param2;
         var _loc4_:int = 1;
         while(_loc4_ <= 9)
         {
            _loc3_ = this.mc["balls_" + _loc4_];
            _loc3_.id = _loc4_;
            this.addListeners(_loc3_);
            _loc3_.groupName = "A";
            _loc4_++;
         }
         _loc3_ = this.mc.balls_3B;
         _loc3_.id = 3;
         this.addListeners(_loc3_);
         _loc3_.groupName = "ELITE";
         _loc3_ = this.mc.balls_3;
         _loc3_.groupName = "PRO";
         this.mc.close_btn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         this.mc.visible = false;
         this.mc.overState_mc.visible = false;
      }
      
      private function addListeners(param1:MovieClip) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.clickBtHandler);
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverBtHandler);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutBtHandler);
         param1.gotoAndStop(1);
         param1.buttonMode = true;
      }
      
      private function closeHandler(param1:MouseEvent) : void
      {
         this.close();
      }
      
      private function close() : void
      {
         this.mc.visible = false;
      }
      
      private function clickBtHandler(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(!_loc2_.locked)
         {
            this.optionSelectedFunc(_loc2_.id,_loc2_.groupName);
         }
      }
      
      private function mouseOutBtHandler(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         this.mc.overState_mc.visible = false;
         _loc2_.gotoAndStop(1);
      }
      
      private function mouseOverBtHandler(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.locked)
         {
            this.mc.overState_mc.x = _loc2_.x + 10;
            this.mc.overState_mc.y = _loc2_.y + 40;
            this.mc.overState_mc.requirements_tx.text = "You need juggling level " + _loc2_.minimumLevel + " to unlock this number of balls.";
            this.mc.overState_mc.visible = true;
         }
         _loc2_.gotoAndStop(2);
      }
      
      public function show(param1:int) : void
      {
         this.configButtons(param1);
         this.mc.visible = true;
      }
      
      public function setBallsRequirements(param1:Array) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 1;
         while(_loc3_ <= 9)
         {
            _loc2_ = this.mc["balls_" + _loc3_];
            _loc2_.minimumLevel = param1[_loc3_];
            _loc3_++;
         }
         _loc2_ = this.mc.balls_3B;
         _loc2_.minimumLevel = param1[3];
      }
      
      private function configButtons(param1:int) : void
      {
         var _loc4_:MovieClip = null;
         var _loc2_:int = 1;
         while(_loc2_ <= 9)
         {
            _loc4_ = this.mc["balls_" + _loc2_];
            if(_loc2_ <= param1)
            {
               this.unlockBt(_loc4_);
            }
            else
            {
               this.lockBt(_loc4_);
            }
            _loc2_++;
         }
         var _loc3_:MovieClip = this.mc.balls_3B;
         if(param1 >= 3)
         {
            this.unlockBt(_loc3_);
         }
         else
         {
            this.lockBt(_loc3_);
         }
      }
      
      private function lockBt(param1:MovieClip) : void
      {
         param1.mouseChildren = false;
         param1.locked = true;
         param1.filters = PetSkillsTricksProgression.getGreyLockedFilter();
      }
      
      private function unlockBt(param1:MovieClip) : void
      {
         param1.mouseChildren = true;
         param1.locked = false;
         param1.filters = [];
      }
   }
}

