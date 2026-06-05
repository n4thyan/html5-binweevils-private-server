package com.binweevils.engine3D.visuals.creatures.pets
{
   public class JugglingTrick
   {
      
      private var brain:Brain;
      
      public var name:String;
      
      public var requirements:JugglingTrickRequirements;
      
      public var id:int;
      
      public var numBalls:int;
      
      public var patternStr:String;
      
      public var difficulty:int;
      
      public var aptitude:Number;
      
      public function JugglingTrick(param1:int, param2:int, param3:String, param4:int, param5:Number, param6:JugglingTrickRequirements, param7:Brain, param8:String)
      {
         super();
         this.id = param1;
         this.numBalls = param2;
         this.patternStr = param3;
         this.difficulty = param4;
         this.aptitude = param5;
         this.requirements = param6;
         this.brain = param7;
         this.name = param8;
      }
      
      public function improve(param1:Number) : void
      {
         var _loc2_:Number = 10 * param1;
         this.aptitude += _loc2_ / this.difficulty;
         if(this.aptitude > 99)
         {
            this.aptitude = 99;
         }
      }
      
      public function get locked() : Boolean
      {
         if(this.aptitude > 0)
         {
            return false;
         }
         if(this.hasTrickRequirements() && this.hasSkillRequirements())
         {
            return false;
         }
         return true;
      }
      
      private function hasTrickRequirements() : Boolean
      {
         var _loc3_:JugglingTrickRequired = null;
         var _loc4_:JugglingTrick = null;
         var _loc5_:Number = NaN;
         var _loc1_:Array = this.requirements.tricksAr;
         if(_loc1_.length == 0)
         {
            return true;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            _loc4_ = this.brain.getJugglingTrickByID(_loc3_.id);
            _loc5_ = PetSkillsTricksProgression.convertLevelToHundredScale(_loc3_.level);
            if(_loc5_ <= _loc4_.aptitude)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function hasSkillRequirements() : Boolean
      {
         var _loc3_:SkillRequired = null;
         var _loc4_:Skill = null;
         var _loc5_:Number = NaN;
         var _loc1_:Array = this.requirements.skillAr;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            _loc4_ = this.brain.getSkillByID(_loc3_.id);
            _loc5_ = PetSkillsTricksProgression.convertLevelToHundredScale(_loc3_.level);
            if(_loc5_ > _loc4_.level)
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      public function get isNew() : Boolean
      {
         if(this.aptitude == 0 && !this.locked)
         {
            return true;
         }
         return false;
      }
      
      public function get isMastered() : Boolean
      {
         if(this.aptitude >= 100 && !this.locked)
         {
            return true;
         }
         return false;
      }
   }
}

