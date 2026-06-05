package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.ViewPort;
   import flash.display.DisplayObject;
   
   public class FixedAsset extends Visual
   {
      
      public var p:Vector3D;
      
      public var depth:Number;
      
      public function FixedAsset(param1:DisplayObject, param2:Number, param3:Number, param4:Number)
      {
         super();
         d_o = param1;
         this.set_p(new Vector3D(param2,param3,param4));
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
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
         var _loc4_:Number = ViewPort.d;
         var _loc5_:Vector3D = param1.transform_vtx(this.p,_loc4_);
         var _loc6_:Number = _loc4_ / (_loc4_ + this.p.z);
         this.depth = -_loc5_.z;
      }
   }
}

