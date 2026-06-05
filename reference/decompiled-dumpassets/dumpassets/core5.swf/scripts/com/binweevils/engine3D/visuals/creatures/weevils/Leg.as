package com.binweevils.engine3D.visuals.creatures.weevils
{
   import com.binweevils.engine3D.*;
   import com.binweevils.engine3D.visuals.creatures.HashLimb;
   import com.binweevils.engine3D.visuals.creatures.Limb;
   import flash.display.*;
   
   public class Leg extends Limb
   {
      
      private var legID:int;
      
      public function Leg(param1:int, param2:MovieClip, param3:MovieClip, param4:Vector3D, param5:Vector3D, param6:Vector3D, param7:int, param8:Number = 0, param9:Boolean = false)
      {
         super(param1,param2,param3,param4,param5,param6,param8,param9);
         this.legID = param7;
         frontLeg = param9;
         this.createHash();
         setPose(4);
      }
      
      override public function createHash(param1:Boolean = false) : void
      {
         var _loc4_:Vector3D = null;
         var _loc5_:Vector3D = null;
         var _loc8_:Number = NaN;
         var _loc10_:Vector3D = null;
         h = new Array();
         h[4] = HashLimb.getHash(j1,j2,j3);
         var _loc2_:Vector3D = j2.subtraction(j1);
         var _loc3_:Vector3D = j3.subtraction(j1);
         var _loc6_:Number = Math.PI / 180;
         var _loc7_:Matrix3x3 = new Matrix3x3();
         var _loc9_:Boolean = j2.x > j1.x ? true : false;
         if(_loc9_)
         {
            _loc8_ = 12 * _loc6_;
         }
         else
         {
            _loc8_ = -12 * _loc6_;
         }
         _loc7_.load_rotation_z(sin(_loc8_),cos(_loc8_));
         _loc4_ = _loc7_.vectorMult(_loc2_);
         _loc5_ = _loc7_.vectorMult(_loc3_);
         _loc4_.addit(j1);
         _loc5_.addit(j1);
         h[0] = HashLimb.getHash(j1,_loc4_,_loc5_);
         if(_loc9_)
         {
            _loc8_ = 10 * _loc6_;
         }
         else
         {
            _loc8_ = -10 * _loc6_;
         }
         _loc7_.load_rotation_z(sin(_loc8_),cos(_loc8_));
         _loc4_ = _loc7_.vectorMult(_loc2_);
         _loc5_ = _loc7_.vectorMult(_loc3_);
         if(_loc9_)
         {
            _loc8_ = -7 * _loc6_;
         }
         else
         {
            _loc8_ = 7 * _loc6_;
         }
         _loc7_.load_rotation_y(sin(_loc8_),cos(_loc8_));
         _loc4_ = _loc7_.vectorMult(_loc4_);
         _loc5_ = _loc7_.vectorMult(_loc5_);
         _loc4_.addit(j1);
         _loc5_.addit(j1);
         h[1] = HashLimb.getHash(j1,_loc4_,_loc5_);
         if(_loc9_)
         {
            _loc8_ = 10 * _loc6_;
         }
         else
         {
            _loc8_ = -10 * _loc6_;
         }
         _loc7_.load_rotation_z(sin(_loc8_),cos(_loc8_));
         _loc4_ = _loc7_.vectorMult(_loc2_);
         _loc5_ = _loc7_.vectorMult(_loc3_);
         if(_loc9_)
         {
            _loc8_ = 7 * _loc6_;
         }
         else
         {
            _loc8_ = -7 * _loc6_;
         }
         _loc7_.load_rotation_y(sin(_loc8_),cos(_loc8_));
         _loc4_ = _loc7_.vectorMult(_loc4_);
         _loc5_ = _loc7_.vectorMult(_loc5_);
         _loc4_.addit(j1);
         _loc5_.addit(j1);
         h[7] = HashLimb.getHash(j1,_loc4_,_loc5_);
         if(_loc9_)
         {
            _loc8_ = -12 * _loc6_;
         }
         else
         {
            _loc8_ = 12 * _loc6_;
         }
         _loc7_.load_rotation_y(sin(_loc8_),cos(_loc8_));
         _loc4_ = _loc7_.vectorMult(_loc2_);
         _loc5_ = _loc7_.vectorMult(_loc3_);
         _loc8_ = -5 * _loc6_;
         _loc7_.load_rotation_x(sin(_loc8_),cos(_loc8_));
         _loc4_ = _loc7_.vectorMult(_loc4_);
         _loc5_ = _loc7_.vectorMult(_loc5_);
         _loc4_.addit(j1);
         _loc5_.addit(j1);
         h[2] = HashLimb.getHash(j1,_loc4_,_loc5_);
         if(_loc9_)
         {
            _loc8_ = -7 * _loc6_;
         }
         else
         {
            _loc8_ = 7 * _loc6_;
         }
         _loc7_.load_rotation_y(sin(_loc8_),cos(_loc8_));
         _loc4_ = _loc7_.vectorMult(_loc2_);
         _loc5_ = _loc7_.vectorMult(_loc3_);
         _loc8_ = -2.5 * _loc6_;
         _loc7_.load_rotation_x(sin(_loc8_),cos(_loc8_));
         _loc4_ = _loc7_.vectorMult(_loc4_);
         _loc5_ = _loc7_.vectorMult(_loc5_);
         _loc4_.addit(j1);
         _loc5_.addit(j1);
         h[3] = HashLimb.getHash(j1,_loc4_,_loc5_);
         if(_loc9_)
         {
            _loc8_ = 7 * _loc6_;
         }
         else
         {
            _loc8_ = -7 * _loc6_;
         }
         _loc7_.load_rotation_y(sin(_loc8_),cos(_loc8_));
         _loc4_ = _loc7_.vectorMult(_loc2_);
         _loc5_ = _loc7_.vectorMult(_loc3_);
         _loc8_ = 2.5 * _loc6_;
         _loc7_.load_rotation_x(sin(_loc8_),cos(_loc8_));
         _loc4_ = _loc7_.vectorMult(_loc4_);
         _loc5_ = _loc7_.vectorMult(_loc5_);
         _loc4_.addit(j1);
         _loc5_.addit(j1);
         h[5] = HashLimb.getHash(j1,_loc4_,_loc5_);
         if(_loc9_)
         {
            _loc8_ = 12 * _loc6_;
         }
         else
         {
            _loc8_ = -12 * _loc6_;
         }
         _loc7_.load_rotation_y(sin(_loc8_),cos(_loc8_));
         _loc4_ = _loc7_.vectorMult(_loc2_);
         _loc5_ = _loc7_.vectorMult(_loc3_);
         _loc8_ = 5 * _loc6_;
         _loc7_.load_rotation_x(sin(_loc8_),cos(_loc8_));
         _loc4_ = _loc7_.vectorMult(_loc4_);
         _loc5_ = _loc7_.vectorMult(_loc5_);
         _loc4_.addit(j1);
         _loc5_.addit(j1);
         h[6] = HashLimb.getHash(j1,_loc4_,_loc5_);
         _loc10_ = j1.clone();
         _loc4_ = j2.clone();
         _loc5_ = j3.clone();
         _loc10_.y += 12;
         _loc4_.y += 60;
         if(_loc9_)
         {
            _loc4_.x -= 25;
         }
         else
         {
            _loc4_.x += 25;
         }
         _loc5_.y += 60;
         h[8] = HashLimb.getHash(_loc10_,_loc4_,_loc5_);
         _loc10_ = j1.clone();
         _loc4_ = j2.clone();
         _loc5_ = j3.clone();
         _loc10_.y -= 12;
         _loc4_.y -= 60;
         if(_loc9_)
         {
            _loc4_.x -= 25;
         }
         else
         {
            _loc4_.x += 25;
         }
         _loc5_.y -= 60;
         h[9] = HashLimb.getHash(_loc10_,_loc4_,_loc5_);
         if(_loc9_)
         {
            switch(this.legID)
            {
               case 0:
                  _loc10_ = new Vector3D(65,170,55);
                  _loc4_ = new Vector3D(125,190,75);
                  _loc5_ = new Vector3D(304,170,125);
                  break;
               case 1:
                  _loc10_ = new Vector3D(75,170,10);
                  _loc4_ = new Vector3D(138,190,10);
                  _loc5_ = new Vector3D(324,170,10);
                  break;
               case 2:
                  _loc10_ = new Vector3D(69,170,-35);
                  _loc4_ = new Vector3D(129,190,-60);
                  _loc5_ = new Vector3D(296,170,-130);
            }
         }
         else
         {
            switch(this.legID)
            {
               case 3:
                  _loc10_ = new Vector3D(-65,170,55);
                  _loc4_ = new Vector3D(-125,190,75);
                  _loc5_ = new Vector3D(-304,170,125);
                  break;
               case 4:
                  _loc10_ = new Vector3D(-75,170,10);
                  _loc4_ = new Vector3D(-138,190,10);
                  _loc5_ = new Vector3D(-324,170,10);
                  break;
               case 5:
                  _loc10_ = new Vector3D(-69,170,-35);
                  _loc4_ = new Vector3D(-129,190,-60);
                  _loc5_ = new Vector3D(-296,170,-130);
            }
         }
         h[10] = HashLimb.getHash(_loc10_,_loc4_,_loc5_);
         if(_loc9_)
         {
            switch(this.legID)
            {
               case 0:
                  _loc10_ = new Vector3D(65,170,55);
                  _loc4_ = new Vector3D(115,185,87);
                  _loc5_ = new Vector3D(78,0,100);
                  break;
               case 1:
                  _loc10_ = new Vector3D(75,170,10);
                  _loc4_ = new Vector3D(136,185,29);
                  _loc5_ = new Vector3D(110,0,50);
                  break;
               case 2:
                  _loc10_ = new Vector3D(69,170,-35);
                  _loc4_ = new Vector3D(141,190,-41);
                  _loc5_ = new Vector3D(129,0,-16);
            }
         }
         else
         {
            switch(this.legID)
            {
               case 3:
                  _loc10_ = new Vector3D(-65,170,55);
                  _loc4_ = new Vector3D(-133,185,52);
                  _loc5_ = new Vector3D(-121,0,28);
                  break;
               case 4:
                  _loc10_ = new Vector3D(-75,170,10);
                  _loc4_ = new Vector3D(-137,185,-9);
                  _loc5_ = new Vector3D(-114,0,-31);
                  break;
               case 5:
                  _loc10_ = new Vector3D(-69,170,-35);
                  _loc4_ = new Vector3D(-123,185,-78);
                  _loc5_ = new Vector3D(-86,0,-94);
            }
         }
         h[11] = HashLimb.getHash(_loc10_,_loc4_,_loc5_);
         if(_loc9_)
         {
            switch(this.legID)
            {
               case 0:
                  _loc10_ = new Vector3D(65,170,55);
                  _loc4_ = new Vector3D(133,185,52);
                  _loc5_ = new Vector3D(121,0,28);
                  break;
               case 1:
                  _loc10_ = new Vector3D(75,170,10);
                  _loc4_ = new Vector3D(137,185,-9);
                  _loc5_ = new Vector3D(114,0,-31);
                  break;
               case 2:
                  _loc10_ = new Vector3D(69,170,-35);
                  _loc4_ = new Vector3D(123,185,-78);
                  _loc5_ = new Vector3D(86,0,-94);
            }
         }
         else
         {
            switch(this.legID)
            {
               case 3:
                  _loc10_ = new Vector3D(-65,170,55);
                  _loc4_ = new Vector3D(-115,185,87);
                  _loc5_ = new Vector3D(-78,0,100);
                  break;
               case 4:
                  _loc10_ = new Vector3D(-75,170,10);
                  _loc4_ = new Vector3D(-136,185,29);
                  _loc5_ = new Vector3D(-110,0,50);
                  break;
               case 5:
                  _loc10_ = new Vector3D(-69,170,-35);
                  _loc4_ = new Vector3D(-141,190,-41);
                  _loc5_ = new Vector3D(-129,0,-16);
            }
         }
         h[12] = HashLimb.getHash(_loc10_,_loc4_,_loc5_);
         if(frontLeg)
         {
            if(_loc9_)
            {
               _loc10_ = new Vector3D(63,170,55);
               _loc4_ = new Vector3D(95,95,45);
               _loc5_ = new Vector3D(4,0,3);
               h[13] = HashLimb.getHash(_loc10_,_loc4_,_loc5_);
               _loc10_ = new Vector3D(65,170,55);
               _loc4_ = new Vector3D(125,200,75);
               _loc5_ = new Vector3D(155,160,225);
               h[14] = HashLimb.getHash(_loc10_,_loc4_,_loc5_);
               _loc10_ = new Vector3D(65,185,55);
               _loc4_ = new Vector3D(124,225,75);
               _loc5_ = new Vector3D(225,380,80);
               h[15] = HashLimb.getHash(_loc10_,_loc4_,_loc5_);
               _loc10_ = new Vector3D(65,185,55);
               _loc4_ = new Vector3D(124,232,75);
               _loc5_ = new Vector3D(180,405,80);
               h[16] = HashLimb.getHash(_loc10_,_loc4_,_loc5_);
               _loc10_ = new Vector3D(65,185,55);
               _loc4_ = new Vector3D(124,232,75);
               _loc5_ = new Vector3D(120,423,80);
               h[17] = HashLimb.getHash(_loc10_,_loc4_,_loc5_);
            }
            else
            {
               _loc10_ = new Vector3D(-63,170,55);
               _loc4_ = new Vector3D(-95,95,45);
               _loc5_ = new Vector3D(-4,0,3);
               h[13] = HashLimb.getHash(_loc10_,_loc4_,_loc5_);
               _loc10_ = new Vector3D(-60,170,55);
               _loc4_ = new Vector3D(-120,200,75);
               _loc5_ = new Vector3D(-155,160,225);
               h[14] = HashLimb.getHash(_loc10_,_loc4_,_loc5_);
               _loc10_ = new Vector3D(-65,185,55);
               _loc4_ = new Vector3D(-124,225,75);
               _loc5_ = new Vector3D(-225,380,80);
               h[15] = HashLimb.getHash(_loc10_,_loc4_,_loc5_);
               _loc10_ = new Vector3D(-65,185,55);
               _loc4_ = new Vector3D(-124,232,75);
               _loc5_ = new Vector3D(-180,405,80);
               h[16] = HashLimb.getHash(_loc10_,_loc4_,_loc5_);
               _loc10_ = new Vector3D(-65,185,55);
               _loc4_ = new Vector3D(-124,232,75);
               _loc5_ = new Vector3D(-120,423,80);
               h[17] = HashLimb.getHash(_loc10_,_loc4_,_loc5_);
            }
         }
         useHash = true;
      }
   }
}

