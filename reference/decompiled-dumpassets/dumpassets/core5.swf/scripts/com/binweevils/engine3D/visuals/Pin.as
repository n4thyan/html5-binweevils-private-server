package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.ViewPort;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class Pin extends Visual
   {
      
      private static var toDegr:Number = 180 / Math.PI;
      
      private var mcH:MovieClip;
      
      private var mcS:MovieClip;
      
      private var pH:Vector3D;
      
      private var pP:Vector3D;
      
      private var scale:Number;
      
      public var depth:Number;
      
      public var mc:MovieClip;
      
      public function Pin(param1:MovieClip, param2:MovieClip, param3:Vector3D, param4:Vector3D, param5:Number)
      {
         super();
         this.mcH = param1;
         this.mcS = param2;
         var _loc6_:Sprite = new Sprite();
         _loc6_.addChildAt(this.mcS,0);
         _loc6_.addChildAt(this.mcH,1);
         d_o = _loc6_;
         this.pH = param3;
         this.pP = param4;
         this.scale = param5;
      }
      
      public function set_pos(param1:Vector3D, param2:Vector3D) : void
      {
         this.pH = param1;
         this.pP = param2;
      }
      
      public function set_scale(param1:Number) : void
      {
         this.scale = param1;
      }
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc4_:Number = ViewPort.d;
         var _loc5_:Vector3D = param1.transform_vtx(this.pH,_loc4_);
         var _loc6_:Vector3D = param1.transform_vtx(this.pP,_loc4_);
         this.depth = -_loc6_.z;
         if(this.depth > _loc4_ || -_loc5_.z > _loc4_)
         {
            d_o.visible = false;
         }
         else
         {
            d_o.visible = true;
            _loc7_ = _loc4_ / (_loc4_ + _loc5_.z);
            _loc8_ = _loc4_ / (_loc4_ + _loc6_.z);
            _loc9_ = ViewPort.x0 + _loc5_.x * _loc7_;
            _loc10_ = ViewPort.y0 - _loc5_.y * _loc7_;
            _loc11_ = ViewPort.x0 + _loc6_.x * _loc8_;
            _loc12_ = ViewPort.y0 - _loc6_.y * _loc8_;
            d_o.x = _loc9_;
            d_o.y = _loc10_;
            _loc13_ = _loc7_ * this.scale;
            d_o.scaleX = d_o.scaleY = _loc13_;
            _loc14_ = _loc11_ - _loc9_;
            _loc15_ = _loc12_ - _loc10_;
            d_o.rotation = toDegr * Math.atan2(_loc15_,_loc14_);
            this.mcS.scaleX = 0.01 * Math.sqrt(_loc14_ * _loc14_ + _loc15_ * _loc15_) / _loc13_;
         }
      }
   }
}

