package com.binweevils.engine3D.visuals.creatures.pets
{
   import fl.motion.AdjustColor;
   import flash.filters.ColorMatrixFilter;
   
   public class PetSkillsTricksProgression
   {
      
      public static var CRAWLER_STATUS:String = "Crawler";
      
      public static var HOPPER_STATUS:String = "Hopper";
      
      public static var WALKER_STATUS:String = "Walker";
      
      public static var RUNNER_STATUS:String = "Runner";
      
      public function PetSkillsTricksProgression()
      {
         super();
      }
      
      public static function skillRequirements(param1:int) : Array
      {
         var _loc2_:Array = null;
         switch(param1)
         {
            case PetSkillNames.FAST_SPIN:
               _loc2_ = [new SkillRequired(PetSkillNames.SPIN,2)];
               break;
            case PetSkillNames.JUMP_SPIN:
               _loc2_ = [new SkillRequired(PetSkillNames.FAST_SPIN,3),new SkillRequired(PetSkillNames.JUMP,2)];
               break;
            case PetSkillNames.SUPER_SPIN:
               _loc2_ = [new SkillRequired(PetSkillNames.JUMP_SPIN,2),new SkillRequired(PetSkillNames.JUMP,3)];
               break;
            case PetSkillNames.BOUNCE_SPIN:
               _loc2_ = [new SkillRequired(PetSkillNames.SUPER_SPIN,3),new SkillRequired(PetSkillNames.JUMP,4)];
               break;
            case PetSkillNames.THROW_TO_ME:
               _loc2_ = [new SkillRequired(PetSkillNames.FETCH,2)];
               break;
            case PetSkillNames.JUGGLE:
               _loc2_ = [new SkillRequired(PetSkillNames.FETCH,3),new SkillRequired(PetSkillNames.THROW_TO_ME,2)];
               break;
            default:
               _loc2_ = new Array();
         }
         return _loc2_;
      }
      
      public static function convertLevelToTenScale(param1:Number) : int
      {
         return int(param1 / 10) + 1;
      }
      
      public static function convertLevelToHundredScale(param1:Number) : Number
      {
         return (param1 - 1) * 10;
      }
      
      public static function getUnlockBallRequirements() : Array
      {
         var _loc1_:Array = new Array();
         _loc1_[1] = 0;
         _loc1_[2] = 10;
         _loc1_[3] = 20;
         _loc1_[4] = 30;
         _loc1_[5] = 40;
         _loc1_[6] = 50;
         _loc1_[7] = 60;
         _loc1_[8] = 70;
         _loc1_[9] = 80;
         return _loc1_;
      }
      
      public static function getNumBallsUnlocked(param1:Number) : int
      {
         var _loc2_:Array = getUnlockBallRequirements();
         var _loc3_:int = 1;
         var _loc4_:int = 1;
         while(_loc4_ < _loc2_.length)
         {
            if(param1 >= _loc2_[_loc4_])
            {
               _loc3_ = _loc4_;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function getWalkingStatus(param1:Number, param2:Number) : String
      {
         var _loc3_:String = CRAWLER_STATUS;
         if(petCanHop(param1))
         {
            _loc3_ = HOPPER_STATUS;
            if(petCanWalk(param2))
            {
               _loc3_ = WALKER_STATUS;
               if(petCanRun(param2))
               {
                  _loc3_ = RUNNER_STATUS;
               }
            }
         }
         return _loc3_;
      }
      
      public static function petCanHop(param1:Number) : Boolean
      {
         var _loc2_:int = 20;
         if(param1 >= _loc2_)
         {
            return true;
         }
         return false;
      }
      
      public static function petCanWalk(param1:Number) : Boolean
      {
         var _loc2_:int = 26;
         if(param1 >= _loc2_)
         {
            return true;
         }
         return false;
      }
      
      public static function petCanRun(param1:Number) : Boolean
      {
         var _loc2_:int = 50;
         if(param1 >= _loc2_)
         {
            return true;
         }
         return false;
      }
      
      public static function getObedienteSkills() : Array
      {
         return [PetSkillNames.CALL,PetSkillNames.COME_HERE,PetSkillNames.SIT,PetSkillNames.STAY,PetSkillNames.JUMP_ON,PetSkillNames.JUMP_OFF,PetSkillNames.GO_THERE,PetSkillNames.STOP_JUGGLING];
      }
      
      public static function getMimicSkills() : Array
      {
         return [PetSkillNames.JUMP,PetSkillNames.STAND_UP,PetSkillNames.WAVE];
      }
      
      public static function getGreyLockedFilter() : Array
      {
         var _loc2_:ColorMatrixFilter = null;
         var _loc3_:Array = null;
         var _loc1_:AdjustColor = new AdjustColor();
         _loc1_.brightness = 5;
         _loc1_.contrast = -10;
         _loc1_.saturation = -90;
         _loc1_.hue = 0;
         _loc3_ = _loc1_.CalculateFinalFlatArray();
         _loc2_ = new ColorMatrixFilter(_loc3_);
         return [_loc2_];
      }
      
      public static function trickRequirements() : Array
      {
         var _loc1_:JugglingTrickRequirements = null;
         var _loc2_:Array = new Array();
         _loc2_[1] = new JugglingTrickRequirements();
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(1,2);
         _loc2_[10] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(10,2);
         _loc1_.addSkillRequirement(PetSkillNames.SPIN,2);
         _loc2_[11] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(11,3);
         _loc1_.addSkillRequirement(PetSkillNames.FAST_SPIN,2);
         _loc2_[12] = _loc1_;
         _loc2_[2] = new JugglingTrickRequirements();
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(2,2);
         _loc2_[13] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(13,2);
         _loc1_.addSkillRequirement(PetSkillNames.SPIN,2);
         _loc2_[14] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(14,3);
         _loc1_.addSkillRequirement(PetSkillNames.FAST_SPIN,2);
         _loc2_[15] = _loc1_;
         _loc2_[3] = new JugglingTrickRequirements();
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(3,2);
         _loc2_[16] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(16,2);
         _loc2_[17] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(17,2);
         _loc2_[18] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(18,2);
         _loc2_[31] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(31,2);
         _loc2_[29] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(29,3);
         _loc2_[25] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(31,2);
         _loc2_[40] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(40,3);
         _loc2_[39] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(39,3);
         _loc2_[38] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(38,3);
         _loc2_[24] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(39,2);
         _loc1_.addTrickRequired(19,2);
         _loc2_[21] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(21,4);
         _loc2_[37] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(37,4);
         _loc2_[53] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(53,4);
         _loc2_[54] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(18,3);
         _loc2_[30] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(30,2);
         _loc2_[28] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(28,2);
         _loc2_[22] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(22,3);
         _loc2_[20] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(22,3);
         _loc2_[23] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(28,2);
         _loc2_[19] = _loc1_;
         _loc2_[55] = new JugglingTrickRequirements();
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(55,2);
         _loc2_[56] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(56,3);
         _loc2_[48] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(48,2);
         _loc2_[47] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(47,2);
         _loc2_[45] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(45,2);
         _loc2_[44] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(44,3);
         _loc1_.addSkillRequirement(PetSkillNames.SPIN,3);
         _loc2_[32] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(45,2);
         _loc2_[42] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(42,2);
         _loc2_[43] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(43,4);
         _loc2_[50] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(50,3);
         _loc1_.addSkillRequirement(PetSkillNames.SPIN,3);
         _loc2_[52] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(47,2);
         _loc2_[46] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(46,2);
         _loc2_[41] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(41,4);
         _loc2_[49] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(49,3);
         _loc1_.addSkillRequirement(PetSkillNames.FAST_SPIN,3);
         _loc2_[34] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(49,3);
         _loc1_.addSkillRequirement(PetSkillNames.SPIN,2);
         _loc2_[51] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(41,4);
         _loc2_[26] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(43,4);
         _loc1_.addTrickRequired(26,2);
         _loc2_[27] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(27,5);
         _loc2_[36] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(36,5);
         _loc2_[76] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(76,3);
         _loc1_.addSkillRequirement(PetSkillNames.SPIN,5);
         _loc2_[35] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc2_[4] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(4,2);
         _loc2_[61] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(61,2);
         _loc2_[67] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(67,3);
         _loc2_[60] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(60,3);
         _loc2_[69] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(69,3);
         _loc1_.addTrickRequired(65,3);
         _loc2_[68] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(4,2);
         _loc2_[57] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(57,2);
         _loc2_[58] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(58,3);
         _loc2_[59] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(59,3);
         _loc2_[65] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(68,3);
         _loc2_[70] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(70,3);
         _loc1_.addSkillRequirement(PetSkillNames.SPIN,3);
         _loc2_[71] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(71,4);
         _loc2_[77] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(68,4);
         _loc2_[64] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(64,4);
         _loc2_[62] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(68,3);
         _loc2_[66] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(66,4);
         _loc2_[63] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(68,3);
         _loc2_[78] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(78,4);
         _loc1_.addSkillRequirement(PetSkillNames.FAST_SPIN,3);
         _loc2_[72] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc2_[5] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(5,2);
         _loc2_[75] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(75,3);
         _loc2_[87] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(87,3);
         _loc2_[85] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(85,2);
         _loc2_[86] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(86,3);
         _loc2_[79] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(79,3);
         _loc2_[83] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(83,2);
         _loc2_[84] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(84,3);
         _loc2_[90] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(90,3);
         _loc2_[80] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(80,3);
         _loc2_[88] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(88,2);
         _loc2_[89] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(89,4);
         _loc1_.addTrickRequired(96,2);
         _loc2_[91] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(91,4);
         _loc2_[92] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(92,2);
         _loc2_[93] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(93,3);
         _loc2_[94] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(94,3);
         _loc1_.addTrickRequired(85,3);
         _loc2_[81] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(81,2);
         _loc2_[82] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(82,3);
         _loc2_[99] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(99,2);
         _loc1_.addTrickRequired(84,4);
         _loc2_[100] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(100,3);
         _loc1_.addSkillRequirement(PetSkillNames.SPIN,3);
         _loc2_[74] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(74,2);
         _loc1_.addSkillRequirement(PetSkillNames.SPIN,3);
         _loc2_[96] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(96,3);
         _loc1_.addSkillRequirement(PetSkillNames.FAST_SPIN,2);
         _loc2_[73] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(73,3);
         _loc1_.addSkillRequirement(PetSkillNames.FAST_SPIN,3);
         _loc2_[95] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(95,3);
         _loc1_.addSkillRequirement(PetSkillNames.FAST_SPIN,3);
         _loc2_[97] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(97,3);
         _loc1_.addSkillRequirement(PetSkillNames.FAST_SPIN,5);
         _loc2_[98] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc2_[6] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(6,3);
         _loc2_[102] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(102,3);
         _loc2_[110] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(110,3);
         _loc2_[104] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(104,3);
         _loc2_[108] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(102,4);
         _loc1_.addTrickRequired(110,2);
         _loc1_.addTrickRequired(105,3);
         _loc2_[103] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(103,2);
         _loc2_[106] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(108,3);
         _loc1_.addTrickRequired(106,4);
         _loc2_[111] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(6,2);
         _loc2_[101] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(101,2);
         _loc2_[116] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(116,3);
         _loc2_[109] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(109,3);
         _loc2_[105] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(105,4);
         _loc2_[107] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(111,2);
         _loc1_.addTrickRequired(107,4);
         _loc2_[112] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc2_[7] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(7,3);
         _loc2_[117] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(117,3);
         _loc2_[119] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(119,2);
         _loc2_[127] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(128,2);
         _loc2_[128] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(128,2);
         _loc2_[123] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(123,4);
         _loc1_.addTrickRequired(121,3);
         _loc2_[131] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(131,4);
         _loc1_.addSkillRequirement(PetSkillNames.SPIN,6);
         _loc2_[125] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(125,3);
         _loc1_.addTrickRequired(128,3);
         _loc2_[129] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(129,4);
         _loc1_.addSkillRequirement(PetSkillNames.SPIN,6);
         _loc2_[126] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(7,2);
         _loc2_[113] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(113,3);
         _loc2_[124] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(124,3);
         _loc2_[120] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(120,3);
         _loc2_[130] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(130,3);
         _loc2_[121] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(126,2);
         _loc1_.addTrickRequired(125,2);
         _loc1_.addTrickRequired(130,4);
         _loc2_[122] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc2_[8] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(8,3);
         _loc2_[134] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(134,3);
         _loc2_[137] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(135,4);
         _loc1_.addTrickRequired(137,3);
         _loc2_[139] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(139,2);
         _loc1_.addTrickRequired(138,3);
         _loc2_[140] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(134,2);
         _loc1_.addTrickRequired(133,3);
         _loc2_[135] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(8,2);
         _loc2_[133] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(133,3);
         _loc2_[136] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(136,3);
         _loc1_.addTrickRequired(135,3);
         _loc2_[138] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc2_[9] = _loc1_;
         _loc1_ = new JugglingTrickRequirements();
         _loc1_.addTrickRequired(9,3);
         _loc2_[114] = _loc1_;
         return _loc2_;
      }
      
      public static function getRequirementsForTrick(param1:int) : JugglingTrickRequirements
      {
         var _loc2_:Array = trickRequirements();
         if(_loc2_[param1] == null)
         {
            return new JugglingTrickRequirements();
         }
         return _loc2_[param1];
      }
   }
}

