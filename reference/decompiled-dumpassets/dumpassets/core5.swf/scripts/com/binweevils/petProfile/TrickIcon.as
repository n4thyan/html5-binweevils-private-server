package com.binweevils.petProfile
{
   import com.binweevils.engine3D.visuals.creatures.pets.JugglingTrick;
   import com.binweevils.engine3D.visuals.creatures.pets.JugglingTrickRequired;
   import com.binweevils.engine3D.visuals.creatures.pets.PetSkillNames;
   import com.binweevils.engine3D.visuals.creatures.pets.SkillBar;
   import com.binweevils.engine3D.visuals.creatures.pets.SkillRequired;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TrickIcon
   {
      
      private var petCommandsUI:PetCommandsUI;
      
      private var btn:Sprite;
      
      private var difficulty_txt:TextField;
      
      private var difficultyRating_spr:Sprite;
      
      private var difficultyRating_txt:TextField;
      
      private var ringOfBalls_mc:MovieClip;
      
      private var index:int;
      
      private var skillBar:SkillBar;
      
      private var locked:Boolean;
      
      public function TrickIcon(param1:PetCommandsUI, param2:int, param3:Sprite)
      {
         super();
         this.petCommandsUI = param1;
         this.index = param2;
         this.btn = param3;
         this.btn.x = 12 + 44 * (param2 % 4);
         this.btn.y = 32 + 44 * int(param2 / 4);
         this.difficulty_txt = TextField(this.btn.getChildByName("difficulty_txt"));
         this.difficultyRating_spr = Sprite(this.btn.getChildByName("difficultyRating_spr"));
         this.difficultyRating_txt = TextField(this.difficultyRating_spr.getChildByName("difficultyRating_txt"));
         this.ringOfBalls_mc = MovieClip(this.btn.getChildByName("ringOfBalls_mc"));
         this.btn.addEventListener(MouseEvent.CLICK,this.btn_CLICK);
         this.btn.addEventListener(MouseEvent.MOUSE_OVER,this.btn_MOUSE_OVER);
         this.btn.addEventListener(MouseEvent.MOUSE_OUT,this.btn_MOUSE_OUT);
      }
      
      public function setTrickAttributes(param1:int, param2:int, param3:JugglingTrick = null) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TextField = null;
         var _loc9_:JugglingTrickRequired = null;
         var _loc10_:String = null;
         var _loc11_:SkillRequired = null;
         var _loc12_:String = null;
         this.ringOfBalls_mc.gotoAndStop(param1);
         this.difficultyRating_spr.visible = false;
         this.difficulty_txt.text = String(param3.id);
         this.difficultyRating_txt.text = "difficulty rating: " + String(param2 - 9);
         if(param3 != null)
         {
            if(this.skillBar == null)
            {
               this.skillBar = new SkillBar();
               _loc8_ = MovieClip(this.btn).level_tx;
               this.skillBar.setPosition(0,30,this.btn,_loc8_);
            }
            this.skillBar.updateSkillLevel(param3.aptitude);
            this.checkTrickLocked(param3);
            this.difficultyRating_txt.text = param3.name + param3.id + "\n";
            _loc4_ = param3.requirements.tricksAr;
            _loc5_ = param3.requirements.skillAr;
            if(_loc4_.length > 0 || _loc5_.length > 0)
            {
               this.difficultyRating_txt.appendText("To unlock you need:\n");
            }
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               _loc9_ = _loc4_[_loc6_];
               _loc10_ = this.petCommandsUI.crntPet.getJugglingTrickNameByID(_loc9_.id);
               this.difficultyRating_txt.appendText(_loc10_ + _loc9_.id + " level " + _loc9_.level + "\n");
               if(_loc6_ < _loc4_.length - 1)
               {
                  this.difficultyRating_txt.appendText(" OR \n");
               }
               _loc6_++;
            }
            if(_loc5_.length > 0)
            {
               this.difficultyRating_txt.appendText("AND \n");
            }
            _loc7_ = 0;
            while(_loc7_ < _loc5_.length)
            {
               _loc11_ = _loc5_[_loc7_];
               _loc12_ = PetSkillNames.getName(_loc11_.id);
               this.difficultyRating_txt.appendText(_loc12_ + " level " + _loc11_.level + "\n");
               _loc7_++;
            }
         }
      }
      
      private function checkTrickLocked(param1:JugglingTrick) : void
      {
         if(param1.locked)
         {
            this.btn.alpha = 0.6;
            this.locked = true;
         }
         else
         {
            this.btn.alpha = 1;
            this.locked = false;
         }
      }
      
      public function set vis(param1:Boolean) : void
      {
         this.btn.visible = param1;
      }
      
      private function btn_CLICK(param1:MouseEvent) : void
      {
         if(!this.locked)
         {
            this.petCommandsUI.jugglingTrickSelected(this.index);
         }
      }
      
      private function btn_MOUSE_OVER(param1:MouseEvent) : void
      {
         this.difficultyRating_spr.visible = true;
      }
      
      private function btn_MOUSE_OUT(param1:MouseEvent) : void
      {
         this.difficultyRating_spr.visible = false;
      }
   }
}

