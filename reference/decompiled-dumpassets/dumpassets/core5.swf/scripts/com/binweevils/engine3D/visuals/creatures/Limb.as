package com.binweevils.engine3D.visuals.creatures
{
   import com.binweevils.engine3D.*;
   import com.binweevils.engine3D.visuals.Element;
   import flash.display.*;
   import flash.geom.ColorTransform;
   
   public class Limb extends Element
   {
      
      public var U_mc:MovieClip;
      
      public var L_mc:MovieClip;
      
      protected var j1:Vector3D;
      
      protected var j2:Vector3D;
      
      protected var j3:Vector3D;
      
      protected var frontLeg:Boolean;
      
      public var h:Array;
      
      protected var pose:int;
      
      protected var hashDpth:Array;
      
      public function Limb(param1:int, param2:MovieClip, param3:MovieClip, param4:Vector3D, param5:Vector3D, param6:Vector3D, param7:Number = 0, param8:Boolean = false)
      {
         super(param4.x,param4.y,param4.z);
         d_o = new Sprite();
         this.U_mc = param2;
         this.L_mc = param3;
         this.setClr(param1);
         d_o.addChild(this.U_mc);
         d_o.addChild(this.L_mc);
         if(param4.x > 0)
         {
            param4.x += param7;
            param5.x += param7;
            param6.x += param7;
         }
         else
         {
            param4.x -= param7;
            param5.x -= param7;
            param6.x -= 0.4 * param7;
         }
         this.set_j1(param4);
         this.set_j2(param5);
         this.set_j3(param6);
      }
      
      public function set_j1(param1:Vector3D) : void
      {
         this.j1 = param1;
      }
      
      public function set_j2(param1:Vector3D) : void
      {
         this.j2 = param1;
      }
      
      public function set_j3(param1:Vector3D) : void
      {
         this.j3 = param1;
      }
      
      public function setPose(param1:int) : void
      {
         hash = this.h[param1];
         this.pose = param1;
      }
      
      public function setClr(param1:int) : void
      {
         var _loc2_:* = param1 >> 16;
         var _loc3_:* = param1 >> 8 & 0xFF;
         var _loc4_:* = param1 & 0xFF;
         this.U_mc.transform.colorTransform = new ColorTransform(1,1,1,1,_loc2_,_loc3_,_loc4_,0);
         this.L_mc.transform.colorTransform = new ColorTransform(1,1,1,1,_loc2_,_loc3_,_loc4_,0);
      }
      
      public function setHashMrrs(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:int = int(this.h.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(param2)
            {
               if(_loc4_ == 11)
               {
                  this.h[11].setMrr(param1[12]);
               }
               else if(_loc4_ == 12)
               {
                  this.h[12].setMrr(param1[11]);
               }
               else
               {
                  this.h[_loc4_].setMrr(param1[_loc4_]);
               }
            }
            else
            {
               this.h[_loc4_].setMrr(param1[_loc4_]);
            }
            _loc4_++;
         }
      }
   }
}

