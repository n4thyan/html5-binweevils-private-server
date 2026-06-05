package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.ViewPort;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class ProjectileTargetUseChildren extends ProjectileTarget
   {
      
      private var _cam:Cam3D;
      
      private var childMCHit:MovieClip;
      
      private var _useTargetShape:Boolean;
      
      private var _centrePoint:Point;
      
      private var _radius:Number;
      
      private var _autoPlay:Boolean;
      
      private var _enabled:Boolean;
      
      public function ProjectileTargetUseChildren(param1:Loc, param2:MovieClip, param3:Number, param4:Number, param5:Number, param6:Number, param7:int = 0, param8:Boolean = false, param9:Boolean = false, param10:Boolean = false, param11:Boolean = true)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11);
         this._useTargetShape = param10;
         switch(param7)
         {
            case 0:
               this._centrePoint = new Point(param3,param4);
               break;
            case 1:
               this._centrePoint = new Point(param5,param4);
               break;
            case 2:
               this._centrePoint = new Point(param3,param5);
         }
         this._radius = param6;
         this._autoPlay = param11;
         this.enable();
         MovieClip(param2).projectileTarget = this;
      }
      
      override public function hitCheck(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Vector3D
      {
         if(!this._enabled)
         {
            return null;
         }
         if(this.getChildren().length == 0)
         {
            return null;
         }
         switch(target_orientation)
         {
            case 0:
               if(param3 > param6)
               {
                  if(param6 < z && z < param3)
                  {
                     return this.findTheHitPoint_Child_Orientation0(param1,param2,param3,param4,param5,param6);
                  }
               }
               else if(param6 > z && z > param3)
               {
                  return this.findTheHitPoint_Child_Orientation0(param1,param2,param3,param4,param5,param6);
               }
         }
         return null;
      }
      
      private function findTheHitPoint_Child_Orientation0(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Vector3D
      {
         var _loc9_:MovieClip = null;
         var _loc10_:Vector3D = null;
         var _loc7_:Array = this.getChildren();
         var _loc8_:uint = 0;
         while(_loc8_ < _loc7_.length)
         {
            if(_loc7_[_loc8_] is MovieClip)
            {
               _loc9_ = _loc7_[_loc8_];
               _loc10_ = this.findTheHitPoint0(_loc9_,param1,param2,param3,param4,param5,param6);
               if(_loc10_ != null)
               {
                  this.childMCHit = _loc9_;
                  return _loc10_;
               }
            }
            _loc8_++;
         }
         return null;
      }
      
      private function findTheHitPoint0(param1:MovieClip, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Vector3D
      {
         var _loc15_:Number = NaN;
         var _loc16_:Vector3D = null;
         var _loc17_:Number = NaN;
         var _loc8_:Number = param2 - param5;
         var _loc9_:Number = param3 - param6;
         var _loc10_:Number = param4 - param7;
         var _loc11_:Number = z - param7;
         var _loc12_:Number = _loc11_ / _loc10_;
         var _loc13_:Point = new Point(param5 + _loc12_ * _loc8_,param6 + _loc12_ * _loc9_);
         var _loc14_:Vector3D = new Vector3D(_loc13_.x,_loc13_.y,z);
         if(this._useTargetShape && this._cam != null)
         {
            _loc15_ = ViewPort.d;
            _loc16_ = this._cam.transform_vtx(_loc14_,_loc15_);
            _loc17_ = _loc15_ / (_loc15_ + _loc16_.z);
            param2 = ViewPort.x0 + _loc16_.x * _loc17_;
            param3 = ViewPort.y0 - _loc16_.y * _loc17_;
            if(param1.hitTestPoint(param2 + 104,param3 + 12,true))
            {
               return _loc14_;
            }
         }
         return null;
      }
      
      private function getChildren() : Array
      {
         var _loc1_:int = mc.numChildren;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_.push(mc.getChildAt(_loc3_));
            _loc3_++;
         }
         return _loc2_;
      }
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
         super.render(param1,param2,param3);
         if(this._cam == null)
         {
            this._cam = param1;
         }
      }
      
      override public function hit() : void
      {
         if(this._autoPlay && mc.currentFrame != 2)
         {
            mc.gotoAndPlay(2);
         }
      }
      
      public function getChildMCHit() : MovieClip
      {
         return this.childMCHit;
      }
      
      public function enable() : void
      {
         this._enabled = true;
      }
      
      public function disable() : void
      {
         this._enabled = false;
      }
   }
}

