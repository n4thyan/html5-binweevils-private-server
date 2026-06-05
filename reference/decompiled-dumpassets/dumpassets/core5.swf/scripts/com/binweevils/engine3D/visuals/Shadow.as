package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.ViewPort;
   import com.binweevils.engine3D.atan2;
   import com.binweevils.engine3D.sin;
   import flash.display.MovieClip;
   
   public class Shadow extends Visual
   {
      
      private var mc:MovieClip;
      
      private var p:Vector3D;
      
      public var depth:Number;
      
      public function Shadow(param1:MovieClip, param2:Number, param3:Number, param4:Number)
      {
         super();
         this.mc = param1;
         d_o = param1;
         this.p = new Vector3D(param2,param3,param4);
         redraw = true;
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
      
      public function update(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this.x = param1;
         this.y = param2;
         this.z = param3;
         this.mc.alpha = 1 - 0.003 * param4;
         redraw = true;
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
         if(redraw || param1.mvd)
         {
            redraw = false;
            _loc4_ = ViewPort.d;
            _loc5_ = param1.transform_vtx(this.p,_loc4_);
            _loc6_ = _loc4_ / (_loc4_ + _loc5_.z);
            _loc7_ = ViewPort.x0 + _loc5_.x * _loc6_;
            this.depth = -_loc5_.z;
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
            }
            _loc8_ = this.p.x - param1.x;
            _loc9_ = this.p.y - param1.y;
            _loc10_ = this.p.z - param1.z;
            _loc11_ = Math.sqrt(_loc8_ * _loc8_ + _loc10_ * _loc10_);
            _loc12_ = atan2(-_loc9_,_loc11_);
            this.mc.scaleY *= sin(_loc12_);
         }
      }
   }
}

