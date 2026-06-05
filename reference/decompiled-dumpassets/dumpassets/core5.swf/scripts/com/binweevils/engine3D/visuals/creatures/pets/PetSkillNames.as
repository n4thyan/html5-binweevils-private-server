package com.binweevils.engine3D.visuals.creatures.pets
{
   public class PetSkillNames
   {
      
      public static const CALL:int = 0;
      
      public static const COME_HERE:int = 1;
      
      public static const SIT:int = 2;
      
      public static const STAY:int = 3;
      
      public static const GO_TO_BED:int = 4;
      
      public static const JUMP_ON:int = 5;
      
      public static const FETCH:int = 6;
      
      public static const THROW_TO_ME:int = 7;
      
      public static const JUGGLE:int = 8;
      
      public static const HEADER:int = 9;
      
      public static const SPIN:int = 10;
      
      public static const FAST_SPIN:int = 11;
      
      public static const JUMP_SPIN:int = 12;
      
      public static const SUPER_SPIN:int = 13;
      
      public static const BOUNCE_SPIN:int = 14;
      
      public static const JUMP:int = 15;
      
      public static const STAND_UP:int = 16;
      
      public static const WAVE:int = 17;
      
      public static const JUMP_OFF:int = 18;
      
      public static const GO_THERE:int = 19;
      
      public static const WEEVIL_THROW_BALL:int = 20;
      
      public static const STOP_JUGGLING:int = 21;
      
      private static var _skillNames:Array = [];
      
      _skillNames[0] = "!!";
      _skillNames[1] = "come here";
      _skillNames[2] = "sit";
      _skillNames[3] = "stay";
      _skillNames[4] = "go to bed";
      _skillNames[5] = "jump on";
      _skillNames[6] = "fetch";
      _skillNames[7] = "throw to me";
      _skillNames[8] = "juggle";
      _skillNames[9] = "header";
      _skillNames[10] = "spin";
      _skillNames[11] = "fast spin";
      _skillNames[12] = "jump spin";
      _skillNames[13] = "super spin";
      _skillNames[14] = "bounce spin";
      _skillNames[15] = "jump";
      _skillNames[16] = "stand up";
      _skillNames[17] = "wave";
      _skillNames[18] = "jump off";
      _skillNames[19] = "go there";
      _skillNames[20] = "throw ball";
      _skillNames[21] = "stop juggling";
      
      public function PetSkillNames()
      {
         super();
      }
      
      public static function getName(param1:int) : String
      {
         return _skillNames[param1];
      }
      
      public static function getNumSkills() : int
      {
         return _skillNames.length;
      }
   }
}

