package com.binweevils.engine3D.visuals.creatures.pets
{
   import com.binweevils.Bin;
   
   public class Skill
   {
      
      private var bin:Bin;
      
      private var _id:int;
      
      private var _skillName:String;
      
      private var _obedience:int;
      
      private var _level:Number;
      
      private var _skillBar:SkillBar;
      
      public function Skill(param1:int, param2:String, param3:int, param4:Number = 0)
      {
         super();
         this._id = param1;
         this.skillName = param2;
         this.obedience = param3;
         this.level = param4;
         this.bin = Bin.get_instance();
      }
      
      public function set skillBar(param1:SkillBar) : void
      {
         this._skillBar = param1;
      }
      
      public function get skillBar() : SkillBar
      {
         return this._skillBar;
      }
      
      private function updateSkillBar() : void
      {
         this._skillBar.updateSkillLevel(this.level);
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set skillName(param1:String) : void
      {
         this._skillName = param1;
      }
      
      public function get skillName() : String
      {
         return this._skillName;
      }
      
      public function set obedience(param1:int) : void
      {
         this._obedience = param1;
      }
      
      public function get obedience() : int
      {
         var _loc1_:Array = PetSkillsTricksProgression.getObedienteSkills();
         if(_loc1_.indexOf(this.id) != -1)
         {
            return 100;
         }
         return this._obedience;
      }
      
      public function set level(param1:Number) : void
      {
         this._level = param1;
         if(this._skillBar != null)
         {
            this._skillBar.updateSkillLevel(this.level);
         }
      }
      
      public function get level() : Number
      {
         return this._level;
      }
      
      public function reinforce(param1:int) : void
      {
         this.obedience += param1;
         if(this.obedience > 105)
         {
            this.obedience = 105;
         }
         else if(this.obedience < 20)
         {
            this.obedience = 20;
         }
      }
      
      public function incrSkillLevel(param1:Number) : void
      {
         var _loc2_:int = PetSkillsTricksProgression.convertLevelToTenScale(this.level);
         param1 *= 1 / _loc2_;
         this.level += param1;
         if(this.level > 100)
         {
            this.level = 100;
         }
      }
   }
}

