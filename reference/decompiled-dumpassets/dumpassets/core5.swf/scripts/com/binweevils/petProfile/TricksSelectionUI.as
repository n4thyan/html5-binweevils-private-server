package com.binweevils.petProfile
{
   import com.binweevils.Bin_extInterface;
   import com.binweevils.engine3D.visuals.creatures.pets.JugglingTrick;
   import com.binweevils.engine3D.visuals.creatures.pets.JugglingTrickRequired;
   import com.binweevils.engine3D.visuals.creatures.pets.Pet;
   import com.binweevils.engine3D.visuals.creatures.pets.PetSkillNames;
   import com.binweevils.engine3D.visuals.creatures.pets.PetSkillsTricksProgression;
   import com.binweevils.engine3D.visuals.creatures.pets.SkillRequired;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TricksSelectionUI extends MovieClip
   {
      
      private var tricksData:Array;
      
      private var trickSelectedFunc:Function;
      
      private var mc:MovieClip;
      
      private var buttons:Array;
      
      private var numBalls:int;
      
      public function TricksSelectionUI(param1:Number, param2:Array, param3:Function, param4:String = "")
      {
         super();
         this.tricksData = param2;
         this.trickSelectedFunc = param3;
         this.numBalls = param1;
         this.mc = this.getMovieClipForTricksGroup(param1,param4);
         addChild(this.mc);
         this.configTricks();
      }
      
      private function getMovieClipForTricksGroup(param1:Number, param2:String) : MovieClip
      {
         switch(param1)
         {
            case 1:
               return new jugglingTricksOneBall();
            case 2:
               return new jugglingTricksTwoBalls();
            case 3:
               if(param2 == "PRO")
               {
                  return new jugglingTricksThreeBalls();
               }
               return new jugglingTricksThreeBallsElite();
               break;
            case 4:
               return new jugglingTricksFourBalls();
            case 5:
               return new jugglingTricksFiveBalls();
            case 6:
               return new jugglingTricksSixBalls();
            case 7:
               return new jugglingTricksSevenBalls();
            case 8:
               return new jugglingTricksEightBalls();
            case 9:
               return new jugglingTricksNineBalls();
            default:
               return new MovieClip();
         }
      }
      
      private function configTricks() : void
      {
         var _loc2_:JugglingTrick = null;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         this.buttons = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < this.tricksData.length)
         {
            _loc2_ = this.tricksData[_loc1_];
            _loc3_ = 1;
            _loc4_ = this.mc["t" + _loc2_.id];
            if(_loc4_ != null)
            {
               _loc4_.locked = false;
               if(_loc2_.locked)
               {
                  _loc4_.locked = true;
                  _loc3_ = 4;
               }
               else if(_loc2_.isNew)
               {
                  _loc3_ = 2;
               }
               else if(_loc2_.isMastered)
               {
                  _loc3_ = 3;
               }
               _loc4_.gotoAndStop(_loc3_);
               _loc4_.addEventListener(MouseEvent.CLICK,this.clickedBtHandler);
               _loc4_.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverBtHandler);
               _loc4_.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutBtHandler);
               _loc4_.index = _loc1_;
               _loc4_.trick = _loc2_;
               if(_loc4_.over_mc == null)
               {
                  _loc4_.over_mc = this.mc.over_mc;
               }
               _loc4_.over_mc.visible = false;
               this.buttons.push(_loc4_);
            }
            _loc1_++;
         }
      }
      
      private function mouseOutBtHandler(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.over_mc.visible = false;
      }
      
      private function mouseOverBtHandler(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.over_mc.visible = true;
         this.mc.over_mc.x = _loc2_.x + _loc2_.width / 2;
         this.mc.over_mc.y = _loc2_.y + _loc2_.height;
         var _loc3_:JugglingTrick = _loc2_.trick;
         var _loc4_:String = this.setTrickOverStateString(_loc3_);
         var _loc5_:TextField = _loc2_.over_mc.requirements_tx;
         _loc2_.over_mc.requirements_tx.text = _loc4_;
         _loc2_.over_mc.trickName_tx.text = "Trick " + _loc3_.name;
         var _loc6_:int = PetSkillsTricksProgression.convertLevelToTenScale(_loc3_.aptitude);
         _loc2_.over_mc.levelDisplay_mc.gotoAndStop(_loc6_);
         var _loc7_:ProgressBar = new ProgressBar(_loc2_.over_mc.levelDisplay_mc.progressBar);
         _loc7_.updateSkillLevel(_loc3_.aptitude);
         if(_loc3_.locked)
         {
            _loc2_.over_mc.bg_mc.height = _loc5_.textHeight + 35;
            _loc2_.over_mc.levelDisplay_mc.visible = false;
         }
         else
         {
            _loc2_.over_mc.bg_mc.height = 55;
            _loc2_.over_mc.levelDisplay_mc.visible = true;
         }
      }
      
      private function clickedBtHandler(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.locked == false)
         {
            this.trickSelectedFunc(_loc2_.index);
         }
      }
      
      public function updateData() : void
      {
      }
      
      public function clear() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.buttons.length)
         {
            _loc2_ = this.buttons[_loc1_];
            _loc2_.removeEventListener(MouseEvent.CLICK,this.clickedBtHandler);
            _loc1_++;
         }
         removeChild(this.mc);
         this.parent.removeChild(this);
      }
      
      private function setTrickOverStateString(param1:JugglingTrick) : String
      {
         var _loc7_:JugglingTrickRequired = null;
         var _loc8_:Object = null;
         var _loc9_:Pet = null;
         var _loc10_:String = null;
         var _loc11_:SkillRequired = null;
         var _loc12_:String = null;
         var _loc2_:* = "";
         var _loc3_:Array = param1.requirements.tricksAr;
         var _loc4_:Array = param1.requirements.skillAr;
         if(!param1.locked)
         {
            return _loc2_;
         }
         if(_loc3_.length > 0 || _loc4_.length > 0)
         {
            _loc2_ += "TO UNLOCK:\n";
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc7_ = _loc3_[_loc5_];
            _loc8_ = Bin_extInterface.bin;
            _loc9_ = _loc8_.UI.getCrntPet();
            _loc10_ = _loc9_.getJugglingTrickNameByID(_loc7_.id);
            _loc2_ += "Trick " + _loc10_ + " Level " + _loc7_.level + "\n";
            if(_loc5_ < _loc3_.length - 1)
            {
               _loc2_ += "   OR \n";
            }
            _loc5_++;
         }
         if(_loc4_.length > 0)
         {
            _loc2_ += "   AND \n";
         }
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc11_ = _loc4_[_loc6_];
            _loc12_ = PetSkillNames.getName(_loc11_.id);
            _loc2_ += "Skill " + _loc12_ + " Level " + _loc11_.level + "\n";
            _loc6_++;
         }
         return _loc2_;
      }
   }
}

