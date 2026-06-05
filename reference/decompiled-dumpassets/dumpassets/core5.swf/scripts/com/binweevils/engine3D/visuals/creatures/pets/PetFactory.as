package com.binweevils.engine3D.visuals.creatures.pets
{
   import assetsWeevil.*;
   import com.binweevils.Bin;
   import com.binweevils.engine3D.*;
   import com.binweevils.engine3D.visuals.*;
   import com.binweevils.engine3D.visuals.creatures.Mouth;
   import com.binweevils.engine3D.visuals.creatures.Shdw;
   import com.binweevils.engine3D.visuals.creatures.pets.behaviours.PetExpressions;
   import com.binweevils.engine3D.visuals.creatures.weevils.Weevil;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.ColorTransform;
   
   public class PetFactory
   {
      
      private static var _instance:PetFactory;
      
      public function PetFactory()
      {
         super();
      }
      
      public static function getInstance() : PetFactory
      {
         if(_instance == null)
         {
            _instance = new PetFactory();
         }
         return _instance;
      }
      
      public function createPet(param1:int, param2:String, param3:Weevil, param4:Number, param5:Number, param6:Number, param7:Number, param8:Object, param9:Boolean = false) : Pet
      {
         var _loc16_:* = undefined;
         var _loc17_:* = undefined;
         var _loc18_:* = undefined;
         var _loc19_:* = undefined;
         var _loc20_:* = undefined;
         var _loc21_:* = undefined;
         var _loc22_:* = undefined;
         var _loc23_:MovieClip = null;
         var _loc24_:* = undefined;
         var _loc25_:* = undefined;
         var _loc26_:* = undefined;
         var _loc27_:* = undefined;
         var _loc28_:* = undefined;
         var _loc29_:* = undefined;
         var _loc30_:* = undefined;
         var _loc31_:* = undefined;
         var _loc32_:* = undefined;
         var _loc33_:* = undefined;
         var _loc34_:* = undefined;
         var _loc35_:* = undefined;
         var _loc36_:* = undefined;
         var _loc37_:* = undefined;
         var _loc38_:Number = NaN;
         var _loc39_:* = undefined;
         var _loc40_:* = undefined;
         var _loc41_:* = undefined;
         var _loc42_:* = undefined;
         var _loc43_:* = undefined;
         var _loc44_:Vector3D = null;
         var _loc45_:* = undefined;
         var _loc46_:* = undefined;
         var _loc47_:* = 0;
         param8.id = param1;
         var _loc10_:Number = 0.14;
         var _loc11_:int = int(param8.bc);
         var _loc12_:int = int(param8.ac1);
         var _loc13_:int = int(param8.ac2);
         var _loc14_:int = int(param8.ec1);
         var _loc15_:int = int(param8.ec2);
         _loc34_ = 74;
         _loc35_ = 44;
         _loc39_ = new Vector3D(37,104,0);
         _loc40_ = new Vector3D(38,112,0);
         _loc43_ = new Vector3D(0.1,0.2,1);
         _loc41_ = new Vector3D(-35,104,0);
         _loc42_ = new Vector3D(-38,112,0);
         _loc44_ = new Vector3D(-0.1,0.2,1);
         _loc25_ = 0;
         _loc16_ = new PetBody_mc();
         _loc17_ = new PetMask_mc();
         _loc18_ = new Eye_white2_mc();
         _loc19_ = new Pet_pupil_mc();
         _loc21_ = new Eye_white2_mc();
         _loc22_ = new Pet_pupil_mc();
         _loc20_ = new Eye_lid2_mc();
         _loc23_ = new Eye_lid2_mc();
         var _loc48_:Composite = new Composite(0,0,0,1,0);
         var _loc49_:Composite = new Composite(0,0,0,1,0);
         var _loc50_:MovieClip = new UpperLeg_mc();
         var _loc51_:MovieClip = new LowerLeg_mc();
         var _loc52_:Vector3D = new Vector3D(110,0,0);
         var _loc53_:Vector3D = new Vector3D(200,-30,15);
         var _loc54_:Vector3D = new Vector3D(120,-108,120);
         var _loc55_:Arm = new Arm(_loc12_,_loc50_,_loc51_,_loc52_,_loc53_,_loc54_,_loc25_,true);
         _loc50_ = new UpperLeg_mc();
         _loc51_ = new LowerLeg_mc();
         _loc52_ = new Vector3D(-110,0,0);
         _loc53_ = new Vector3D(-200,-30,15);
         _loc54_ = new Vector3D(-120,-108,120);
         var _loc56_:Arm = new Arm(_loc13_,_loc50_,_loc51_,_loc52_,_loc53_,_loc54_,_loc25_,true);
         _loc45_ = _loc11_ >> 16;
         _loc46_ = _loc11_ >> 8 & 0xFF;
         _loc47_ = _loc11_ & 0xFF;
         _loc16_.transform.colorTransform = new ColorTransform(1,1,1,1,-255 + _loc45_,-255 + _loc46_,-255 + _loc47_,0);
         var _loc57_:PreRend3D = new PreRend3D(_loc16_,0,0,0,1,0,0,0,50,0,360,37,1);
         _loc49_.d_o.addChild(_loc17_);
         var _loc58_:Array = [new Mouth2_mc(),new Mouth1_mc(),new Mouth3_mc(),new Mouth4_mc(),new Mouth5_mc(),new Mouth6_mc(),new Mouth7_mc(),new Mouth8_mc()];
         var _loc59_:Mouth = new Mouth(_loc58_,0,0,30,_loc17_,1,0.5);
         _loc45_ = _loc14_ >> 16;
         _loc46_ = _loc14_ >> 8 & 0xFF;
         _loc47_ = _loc14_ & 0xFF;
         _loc20_.transform.colorTransform = new ColorTransform(1,1,1,1,-255 + _loc45_,-255 + _loc46_,-255 + _loc47_,0);
         _loc45_ = _loc15_ >> 16;
         _loc46_ = _loc15_ >> 8 & 0xFF;
         _loc47_ = _loc15_ & 0xFF;
         _loc23_.transform.colorTransform = new ColorTransform(1,1,1,1,-255 + _loc45_,-255 + _loc46_,-255 + _loc47_,0);
         var _loc60_:Eye = new Eye(_loc18_,_loc19_,_loc20_,_loc11_,_loc39_,_loc40_,_loc43_,1.4);
         var _loc61_:Eye = new Eye(_loc21_,_loc22_,_loc23_,_loc11_,_loc41_,_loc42_,_loc44_,1.4);
         _loc49_.addElement(_loc57_);
         _loc49_.addElement(_loc59_);
         _loc49_.addElement(_loc60_);
         _loc49_.addElement(_loc61_);
         _loc49_.addElement(_loc55_);
         _loc49_.addElement(_loc56_);
         var _loc62_:MovieClip = new Shadow_mc();
         var _loc63_:Shdw = new Shdw(_loc62_);
         _loc48_.addElement(_loc63_);
         _loc48_.addElement(_loc49_);
         var _loc64_:Pet = new Pet(param1,param2,param3,_loc48_,param4,param5,param6,_loc10_,param7,param9);
         _loc64_.addZz(new Zz_mc());
         _loc64_.addThoughtBubble(new ThoughtBubble_mc());
         _loc64_.set_creature(_loc49_);
         _loc64_.set_pet_cmp(_loc48_);
         _loc64_.set_body(_loc16_);
         _loc64_.set_arms(_loc55_,_loc56_);
         _loc64_.set_eyes(_loc60_,_loc61_);
         _loc64_.set_mouth(_loc59_);
         _loc64_.set_shadow(_loc62_);
         _loc64_.defObj = param8;
         var _loc65_:Array = Bin.get_instance().creatureAssets.setPetBehaviours(_loc64_);
         _loc64_.setBehaviours(_loc65_);
         _loc64_.setExpression(PetExpressions.MOUTH_OPEN);
         return _loc64_;
      }
   }
}

