package com.binweevils.engine3D.visuals.creatures.pets
{
   import com.binweevils.engine3D.*;
   import com.binweevils.engine3D.visuals.Element;
   import flash.display.*;
   import flash.geom.ColorTransform;
   
   public class Eye extends Element
   {
      
      internal var stalk:Shape;
      
      internal var eyeBall:EyeBall;
      
      internal var eyeBall_spr:Sprite;
      
      internal var white_spr:Sprite;
      
      internal var pupil_mc:MovieClip;
      
      internal var lid_mc:MovieClip;
      
      private var dir:Vector3D;
      
      private var pBase:Vector3D;
      
      public var h:Array;
      
      private var pose:int;
      
      public function Eye(param1:Sprite, param2:MovieClip, param3:MovieClip, param4:int, param5:Vector3D, param6:Vector3D, param7:Vector3D, param8:Number = 1)
      {
         super(param6.x,param6.y,param6.z,param8);
         this.setStalkClr(param4);
         d_o = new Sprite();
         this.stalk = new Shape();
         this.white_spr = param1;
         this.pupil_mc = param2;
         this.lid_mc = param3;
         d_o.addChild(this.stalk);
         this.eyeBall = new EyeBall(param1,param2,param3,param7);
         this.eyeBall_spr = this.eyeBall.d_o;
         d_o.addChild(this.eyeBall_spr);
         this.pBase = param5;
         this.createHash(false);
         this.setPose(2);
      }
      
      override public function createHash(param1:Boolean = false) : void
      {
         this.h = new Array();
         this.h[0] = HashEye.getHash(this.pBase,p,param1,scale);
         var _loc2_:Vector3D = p.clone();
         var _loc3_:int = 1;
         while(_loc3_ <= 4)
         {
            _loc2_ = _loc2_.clone();
            _loc2_.y += 20;
            if(p.x > 0)
            {
               _loc2_.x += 2;
            }
            else
            {
               _loc2_.x -= 2;
            }
            this.h[_loc3_] = HashEye.getHash(this.pBase,_loc2_,param1,scale);
            _loc3_++;
         }
         useHash = true;
      }
      
      public function setHashMrrs(param1:Array, param2:Array) : void
      {
         var _loc3_:int = int(this.h.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this.h[_loc4_].setMrr(param1[_loc4_]);
            _loc4_++;
         }
         this.eyeBall.setHashMrrs(param2);
      }
      
      public function setPose(param1:int) : void
      {
         hash = this.h[param1];
         this.pose = param1;
      }
      
      public function getPose() : int
      {
         return this.pose;
      }
      
      public function closeIt() : void
      {
         this.eyeBall.shut = true;
      }
      
      public function openIt() : void
      {
         this.eyeBall.shut = false;
      }
      
      public function get ebRotX() : Number
      {
         return this.eyeBall.rotX;
      }
      
      public function set ebRotX(param1:Number) : void
      {
         this.eyeBall.rotX = param1;
      }
      
      public function get ebRotY() : Number
      {
         return this.eyeBall.rotX;
      }
      
      public function set ebRotY(param1:Number) : void
      {
         this.eyeBall.rotY = param1;
      }
      
      public function setStalkClr(param1:int) : void
      {
         clr = param1;
      }
      
      public function setLidClr(param1:int) : void
      {
         var _loc2_:* = param1 >> 16;
         var _loc3_:* = param1 >> 8 & 0xFF;
         var _loc4_:* = param1 & 0xFF;
         this.lid_mc.transform.colorTransform = new ColorTransform(1,1,1,1,_loc2_ - 255,_loc3_ - 255,_loc4_ - 255,0);
      }
      
      override public function setViewAngle(param1:Number, param2:Number) : void
      {
         param2 += rotY;
         if(param2 < 0)
         {
            param2 += 360;
         }
         else if(param2 > 360)
         {
            param2 -= 360;
         }
         super.setViewAngle(param1,param2);
         this.eyeBall.setViewAngle(param1,param2);
      }
   }
}

