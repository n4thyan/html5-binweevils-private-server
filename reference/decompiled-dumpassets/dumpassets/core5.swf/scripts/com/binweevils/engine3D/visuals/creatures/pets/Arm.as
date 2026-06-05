package com.binweevils.engine3D.visuals.creatures.pets
{
   import com.binweevils.engine3D.*;
   import com.binweevils.engine3D.visuals.creatures.HashLimb;
   import com.binweevils.engine3D.visuals.creatures.Limb;
   import flash.display.*;
   
   public class Arm extends Limb
   {
      
      public function Arm(param1:int, param2:MovieClip, param3:MovieClip, param4:Vector3D, param5:Vector3D, param6:Vector3D, param7:Number = 0, param8:Boolean = false)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8);
         this.createHash();
         setPose(0);
      }
      
      override public function createHash(param1:Boolean = false) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Vector3D = null;
         h = new Array();
         h[0] = HashLimb.getHash(j1,j2,j3);
         var _loc4_:int = j2.x > j1.x ? 1 : -1;
         _loc2_ = new Vector3D(185 * _loc4_,40,0);
         _loc3_ = new Vector3D(190 * _loc4_,165,0);
         h[1] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(188 * _loc4_,50,0);
         _loc3_ = new Vector3D(120 * _loc4_,165,0);
         h[2] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(192 * _loc4_,37,0);
         _loc3_ = new Vector3D(240 * _loc4_,150,0);
         h[3] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(115 * _loc4_,100,0);
         _loc3_ = new Vector3D(60 * _loc4_,225,0);
         h[4] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(206 * _loc4_,0,0);
         _loc3_ = new Vector3D(333 * _loc4_,0,0);
         h[5] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(188 * _loc4_,20,0);
         _loc3_ = new Vector3D(120 * _loc4_,-105,0);
         h[6] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(188 * _loc4_,-20,0);
         _loc3_ = new Vector3D(115 * _loc4_,-145,0);
         h[7] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(115 * _loc4_,-95,0);
         _loc3_ = new Vector3D(110 * _loc4_,-220,0);
         h[8] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(112 * _loc4_,-95,0);
         _loc3_ = new Vector3D(5 * _loc4_,-195,0);
         h[9] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(160 * _loc4_,-25,60);
         _loc3_ = new Vector3D(90 * _loc4_,-105,120);
         h[10] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(160 * _loc4_,-25,-60);
         _loc3_ = new Vector3D(90 * _loc4_,-105,-120);
         h[11] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(115 * _loc4_,-90,25);
         _loc3_ = new Vector3D(100 * _loc4_,-210,50);
         h[12] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(115 * _loc4_,-90,-25);
         _loc3_ = new Vector3D(100 * _loc4_,-210,-50);
         h[13] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(130 * _loc4_,-60,100);
         _loc3_ = new Vector3D(90 * _loc4_,-105,200);
         h[14] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(200 * _loc4_,-30,15);
         _loc3_ = new Vector3D(260 * _loc4_,-10,120);
         h[15] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(205 * _loc4_,-20,15);
         _loc3_ = new Vector3D(210 * _loc4_,-90,120);
         h[16] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(190 * _loc4_,-40,15);
         _loc3_ = new Vector3D(150 * _loc4_,24,120);
         h[17] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(200 * _loc4_,-30,15);
         _loc3_ = new Vector3D(80 * _loc4_,0,120);
         h[18] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(219 * _loc4_,-16,60);
         _loc3_ = new Vector3D(338 * _loc4_,-6,120);
         h[19] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(185 * _loc4_,-25,90);
         _loc3_ = new Vector3D(20 * _loc4_,0,80);
         h[20] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(120 * _loc4_,-85,10);
         _loc3_ = new Vector3D(-20 * _loc4_,-105,85);
         h[21] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(180 * _loc4_,12,45);
         _loc3_ = new Vector3D(260 * _loc4_,50,120);
         h[22] = HashLimb.getHash(j1,_loc2_,_loc3_);
         _loc2_ = new Vector3D(180 * _loc4_,12,45);
         _loc3_ = new Vector3D(80 * _loc4_,50,120);
         h[23] = HashLimb.getHash(j1,_loc2_,_loc3_);
         useHash = true;
      }
      
      public function dynamicDraw(param1:Number, param2:Number) : void
      {
         var _loc3_:HashLimb = hash as HashLimb;
         var _loc4_:Number = param1 - _loc3_.x2;
         var _loc5_:Number = param2 - _loc3_.y2;
         var _loc6_:Number = -toDegr * atan2(_loc5_,_loc4_);
         L_mc.scaleX = _loc4_;
         L_mc.scaleY = _loc5_;
         L_mc.rotation = _loc6_;
      }
   }
}

