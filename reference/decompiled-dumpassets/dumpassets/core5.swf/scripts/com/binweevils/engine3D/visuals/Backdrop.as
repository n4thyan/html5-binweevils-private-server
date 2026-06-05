package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.ViewPort;
   import flash.display.Sprite;
   
   public class Backdrop extends Visual
   {
      
      public var p:Vector3D;
      
      public function Backdrop(param1:Sprite, param2:Number, param3:Number, param4:Number)
      {
         super();
         this.set_p(new Vector3D(param2,param3,param4));
         d_o = param1;
      }
      
      public function set_p(param1:Vector3D) : void
      {
         this.p = param1;
      }
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
         var _loc4_:Number = ViewPort.d;
         var _loc5_:Vector3D = param1.transform_vtx(this.p,_loc4_);
         var _loc6_:Number = _loc4_ / (_loc4_ + _loc5_.z);
         var _loc7_:Number = ViewPort.x0 + _loc5_.x * _loc6_;
         var _loc8_:Number = -_loc5_.z;
         if(_loc8_ > _loc4_ || _loc7_ < -300 || _loc7_ > 914)
         {
            d_o.visible = false;
         }
         else
         {
            d_o.x = _loc7_;
            d_o.y = ViewPort.y0 - _loc5_.y * _loc6_;
            d_o.visible = true;
            d_o.alpha = 1 + 0.0005 * _loc8_;
         }
      }
   }
}

