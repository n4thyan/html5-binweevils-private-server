package com.binweevils.engine3D.visuals.creatures.pets
{
   public class JugglingTrickRequirements
   {
      
      public var tricksAr:Array = new Array();
      
      public var skillAr:Array = new Array();
      
      public function JugglingTrickRequirements()
      {
         super();
         this.tricksAr = new Array();
         this.skillAr = new Array();
      }
      
      public function addTrickRequired(param1:int, param2:int) : void
      {
         this.tricksAr.push(new JugglingTrickRequired(param1,param2));
      }
      
      public function addSkillRequirement(param1:int, param2:int) : void
      {
         this.skillAr.push(new SkillRequired(param1,param2));
      }
   }
}

