package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.ViewPort;
   import com.binweevils.engine3D.atan2;
   import com.binweevils.engine3D.sin;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class ProjectileTarget extends Visual
   {
      
      public var mc:MovieClip;
      
      public var p:Vector3D;
      
      public var target_orientation:int;
      
      private var shadow:Shadow;
      
      private var centrePoint:Point;
      
      private var radius:Number;
      
      public var depth:Number;
      
      private var loc:Loc;
      
      public var dynam:Boolean;
      
      private var indestructible:Boolean;
      
      private var useTargetShape:Boolean;
      
      private var autoPlay:Boolean;
      
      private var cam:Cam3D;
      
      public function ProjectileTarget(param1:Loc, param2:MovieClip, param3:Number, param4:Number, param5:Number, param6:Number, param7:int = 0, param8:Boolean = false, param9:Boolean = false, param10:Boolean = false, param11:Boolean = true)
      {
         super();
         type = "target";
         this.mc = param2;
         d_o = param2;
         this.target_orientation = param7;
         this.dynam = param8;
         this.indestructible = param9;
         this.useTargetShape = param10;
         this.autoPlay = param11;
         switch(this.target_orientation)
         {
            case 0:
               this.centrePoint = new Point(param3,param4);
               break;
            case 1:
               this.centrePoint = new Point(param5,param4);
               break;
            case 2:
               this.centrePoint = new Point(param3,param5);
         }
         this.radius = param6;
         this.set_p(new Vector3D(param3,param4,param5));
         this.loc = param1;
         if(this.mc.shadow_mc != null)
         {
            if(this.target_orientation == 0)
            {
               this.shadow = new Shadow(this.mc.shadow_mc,param3,0,param5);
               this.loc.manageAsset(this.shadow);
            }
            else
            {
               this.mc.shadow_mc.visible = false;
            }
         }
      }
      
      public function set_p(param1:Vector3D) : void
      {
         this.p = param1;
      }
      
      public function set x(param1:Number) : void
      {
         this.p.x = param1;
      }
      
      public function set y(param1:Number) : void
      {
         this.p.y = param1;
      }
      
      public function set z(param1:Number) : void
      {
         this.p.z = param1;
      }
      
      public function get x() : Number
      {
         return this.p.x;
      }
      
      public function get y() : Number
      {
         return this.p.y;
      }
      
      public function get z() : Number
      {
         return this.p.z;
      }
      
      public function hitCheck(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Vector3D
      {
         switch(this.target_orientation)
         {
            case 0:
               if(param3 > param6)
               {
                  if(param6 < this.z && this.z < param3)
                  {
                     return this.findHitPoint0(param1,param2,param3,param4,param5,param6);
                  }
               }
               else if(param6 > this.z && this.z > param3)
               {
                  return this.findHitPoint0(param1,param2,param3,param4,param5,param6);
               }
               break;
            case 1:
               if(param1 > param4)
               {
                  if(param4 < this.x && this.x < param1)
                  {
                     return this.findHitPoint1(param1,param2,param3,param4,param5,param6);
                  }
               }
               else if(param4 > this.x && this.x > param1)
               {
                  return this.findHitPoint1(param1,param2,param3,param4,param5,param6);
               }
               break;
            case 2:
               if(param2 > param5)
               {
                  if(param5 < this.y && this.y < param2)
                  {
                     return this.findHitPoint2(param1,param2,param3,param4,param5,param6);
                  }
               }
               else if(param5 > this.y && this.y > param2)
               {
                  return this.findHitPoint2(param1,param2,param3,param4,param5,param6);
               }
         }
         return null;
      }
      
      private function findHitPoint0(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Vector3D
      {
         var _loc14_:Number = NaN;
         var _loc15_:Vector3D = null;
         var _loc16_:Number = NaN;
         var _loc7_:Number = param1 - param4;
         var _loc8_:Number = param2 - param5;
         var _loc9_:Number = param3 - param6;
         var _loc10_:Number = this.z - param6;
         var _loc11_:Number = _loc10_ / _loc9_;
         var _loc12_:Point = new Point(param4 + _loc11_ * _loc7_,param5 + _loc11_ * _loc8_);
         var _loc13_:Vector3D = new Vector3D(_loc12_.x,_loc12_.y,this.z);
         if(this.useTargetShape && this.cam != null)
         {
            _loc14_ = ViewPort.d;
            _loc15_ = this.cam.transform_vtx(_loc13_,_loc14_);
            _loc16_ = _loc14_ / (_loc14_ + _loc15_.z);
            param1 = ViewPort.x0 + _loc15_.x * _loc16_;
            param2 = ViewPort.y0 - _loc15_.y * _loc16_;
            if(this.mc.hitTestPoint(param1 + 104,param2 + 12,true))
            {
               return _loc13_;
            }
         }
         else if(Point.distance(_loc12_,this.centrePoint) < this.radius)
         {
            return _loc13_;
         }
         return null;
      }
      
      private function findHitPoint1(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Vector3D
      {
         var _loc14_:Number = NaN;
         var _loc15_:Vector3D = null;
         var _loc16_:Number = NaN;
         var _loc7_:Number = param1 - param4;
         var _loc8_:Number = param2 - param5;
         var _loc9_:Number = param3 - param6;
         var _loc10_:Number = this.x - param4;
         var _loc11_:Number = _loc10_ / _loc7_;
         var _loc12_:Point = new Point(param6 + _loc11_ * _loc9_,param5 + _loc11_ * _loc8_);
         var _loc13_:Vector3D = new Vector3D(this.x,_loc12_.y,_loc12_.x);
         if(this.useTargetShape)
         {
            _loc14_ = ViewPort.d;
            _loc15_ = this.cam.transform_vtx(_loc13_,_loc14_);
            _loc16_ = _loc14_ / (_loc14_ + _loc15_.z);
            param1 = ViewPort.x0 + _loc15_.x * _loc16_;
            param2 = ViewPort.y0 - _loc15_.y * _loc16_;
            if(this.mc.hitTestPoint(param1 + 104,param2 + 12,true))
            {
               return _loc13_;
            }
         }
         else if(Point.distance(_loc12_,this.centrePoint) < this.radius)
         {
            return _loc13_;
         }
         return null;
      }
      
      private function findHitPoint2(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Vector3D
      {
         var _loc14_:Number = NaN;
         var _loc15_:Vector3D = null;
         var _loc16_:Number = NaN;
         var _loc7_:Number = param1 - param4;
         var _loc8_:Number = param2 - param5;
         var _loc9_:Number = param3 - param6;
         var _loc10_:Number = this.y - param5;
         var _loc11_:Number = _loc10_ / _loc8_;
         var _loc12_:Point = new Point(param4 + _loc11_ * _loc7_,param6 + _loc11_ * _loc9_);
         var _loc13_:Vector3D = new Vector3D(_loc12_.x,this.y,_loc12_.y);
         if(this.useTargetShape)
         {
            _loc14_ = ViewPort.d;
            _loc15_ = this.cam.transform_vtx(_loc13_,_loc14_);
            _loc16_ = _loc14_ / (_loc14_ + _loc15_.z);
            param1 = ViewPort.x0 + _loc15_.x * _loc16_;
            param2 = ViewPort.y0 - _loc15_.y * _loc16_;
            if(this.mc.hitTestPoint(param1 + 104,param2 + 12,true))
            {
               return _loc13_;
            }
         }
         else if(Point.distance(_loc12_,this.centrePoint) < this.radius)
         {
            return _loc13_;
         }
         return null;
      }
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Vector3D = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         if(redraw || param1.mvd)
         {
            this.cam = param1;
            _loc4_ = ViewPort.d;
            _loc5_ = param1.transform_vtx(this.p,_loc4_);
            _loc6_ = _loc4_ / (_loc4_ + _loc5_.z);
            this.depth = -_loc5_.z;
            if(this.dynam)
            {
               _loc7_ = ViewPort.x0 + _loc5_.x * _loc6_;
               if(this.depth > _loc4_ || _loc7_ < -300 || _loc7_ > 914)
               {
                  this.mc.visible = false;
               }
               else
               {
                  this.mc.x = _loc7_;
                  this.mc.y = ViewPort.y0 - _loc5_.y * _loc6_;
                  this.mc.scaleX = this.mc.scaleY = _loc6_;
                  this.mc.visible = true;
                  _loc8_ = (2000 - (this.z - 300)) / 2000;
                  this.mc.transform.colorTransform = new ColorTransform(_loc8_,_loc8_,_loc8_);
                  if(this.target_orientation != 0)
                  {
                     _loc9_ = this.p.x - param1.x;
                     _loc10_ = this.p.y - param1.y;
                     _loc11_ = this.p.z - param1.z;
                     switch(this.target_orientation)
                     {
                        case 1:
                           _loc12_ = atan2(_loc9_,_loc11_);
                           this.mc.scaleX *= sin(_loc12_);
                           break;
                        case 2:
                           _loc13_ = Math.sqrt(_loc9_ * _loc9_ + _loc11_ * _loc11_);
                           _loc14_ = atan2(-_loc10_,_loc13_);
                           this.mc.scaleY *= sin(_loc14_);
                     }
                  }
               }
            }
         }
         if(!this.indestructible && this.mc.currentFrame == 50)
         {
            this.loc.removeTarget(this);
         }
      }
      
      private function removeShadow() : void
      {
         if(!this.indestructible && this.shadow != null)
         {
            this.loc.removeVisual(0,this.shadow);
         }
      }
      
      public function hit() : void
      {
         if(this.autoPlay && this.mc.currentFrame != 2)
         {
            this.mc.gotoAndPlay(2);
         }
         this.removeShadow();
      }
   }
}

