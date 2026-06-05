package com.binweevils.engine3D.visuals.creatures.pets
{
   import com.binweevils.engine3D.*;
   import com.binweevils.engine3D.visuals.Element;
   import flash.display.*;
   
   public class EyeBall extends Element
   {
      
      internal var white_spr:Sprite;
      
      internal var pupil_mc:MovieClip;
      
      internal var lid_mc:MovieClip;
      
      private var dir:Vector3D;
      
      public var h:Array;
      
      private var pose:int;
      
      internal var shut:Boolean;
      
      public function EyeBall(param1:Sprite, param2:MovieClip, param3:MovieClip, param4:Vector3D, param5:Number = 1)
      {
         super(0,0,0,param5);
         d_o = new Sprite();
         this.white_spr = param1;
         this.pupil_mc = param2;
         this.lid_mc = param3;
         d_o.addChild(param1);
         d_o.addChild(param2);
         d_o.addChild(param3);
         this.dir = param4;
         this.createHash(false);
         this.setPose(0);
      }
      
      override public function createHash(param1:Boolean = false) : void
      {
         this.h = new Array();
         this.h[0] = HashEyeBall.getHash(this.dir,param1,scale);
         useHash = true;
      }
      
      public function setHashMrrs(param1:Array) : void
      {
         var _loc2_:int = int(this.h.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.h[_loc3_].setMrr(param1[_loc3_]);
            _loc3_++;
         }
      }
      
      public function setPose(param1:int) : void
      {
         hash = this.h[param1];
         this.pose = param1;
      }
      
      override public function setViewAngle(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(!this.shut)
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
            if(rotX != 0)
            {
               _loc3_ = param1 + rotX;
               if(_loc3_ > 50)
               {
                  rotX = 50 - param1;
               }
               else if(_loc3_ < 0)
               {
                  rotX = -param1;
               }
               _loc4_ = param2 * 0.01745;
               param1 += rotX * cos(_loc4_);
               d_o.rotation = rotX * sin(_loc4_);
            }
            else
            {
               d_o.rotation = 0;
            }
            super.setViewAngle(param1,param2);
         }
         else
         {
            this.lid_mc.gotoAndStop(37);
         }
      }
   }
}

