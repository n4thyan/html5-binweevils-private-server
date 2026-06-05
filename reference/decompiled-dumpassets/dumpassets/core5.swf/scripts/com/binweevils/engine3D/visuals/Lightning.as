package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.*;
   import flash.display.*;
   import flash.media.SoundTransform;
   
   public class Lightning extends Visual
   {
      
      private static var toDegr:Number = 180 / Math.PI;
      
      private var lightning_mc:MovieClip;
      
      private var lightning1_mc:MovieClip;
      
      private var lightning2_mc:MovieClip;
      
      public var flash_spr:Sprite;
      
      private var thunderSounds:Array;
      
      private var p:Vector3D;
      
      private var _scale:Number;
      
      public var depth:Number;
      
      public var mc:MovieClip;
      
      private var striking:Boolean;
      
      public function Lightning(param1:MovieClip, param2:MovieClip, param3:Sprite, param4:Array)
      {
         super();
         this.lightning1_mc = param1;
         this.lightning2_mc = param2;
         this.flash_spr = param3;
         this.flash_spr.visible = false;
         this.thunderSounds = param4;
         var _loc5_:Sprite = new Sprite();
         _loc5_.addChild(this.lightning1_mc);
         _loc5_.addChild(this.lightning2_mc);
         d_o = _loc5_;
         subType = "lightning";
         this.p = new Vector3D(0,0,0);
         this._scale = 1;
      }
      
      public function set_scale(param1:Number) : void
      {
         this._scale = param1;
      }
      
      public function strike() : void
      {
         if(Math.random() > 0.5)
         {
            this.lightning_mc = this.lightning1_mc;
            this.lightning1_mc.visible = true;
            this.lightning2_mc.visible = false;
         }
         else
         {
            this.lightning_mc = this.lightning2_mc;
            this.lightning1_mc.visible = false;
            this.lightning2_mc.visible = true;
         }
         this.p.x = 150 - 300 * Math.random();
         this.p.z = 450 - 300 * Math.random();
         this.striking = true;
      }
      
      public function playThunderSound(param1:Number) : void
      {
         this.thunderSounds[int(4 * Math.random())].play(0,0,new SoundTransform(param1));
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
         var _loc13_:int = 0;
         var _loc14_:Number = NaN;
         if(this.striking)
         {
            _loc4_ = ViewPort.d;
            _loc5_ = param1.transform_vtx(this.p,_loc4_);
            _loc6_ = _loc4_ / (_loc4_ + _loc5_.z);
            _loc7_ = ViewPort.x0 + _loc5_.x * _loc6_;
            this.depth = -_loc5_.z;
            if(this.depth > _loc4_ || -_loc5_.z > _loc4_)
            {
               d_o.visible = false;
            }
            else
            {
               d_o.x = _loc7_;
               d_o.y = ViewPort.y0 - _loc5_.y * _loc6_;
               d_o.scaleX = d_o.scaleY = _loc6_ * this._scale;
               if(Math.random() > 0.5)
               {
                  d_o.scaleX = -d_o.scaleX;
               }
               _loc8_ = this.p.x - param1.x;
               _loc9_ = this.p.y - param1.y;
               _loc10_ = this.p.z - param1.z;
               _loc11_ = Math.sqrt(_loc8_ * _loc8_ + _loc10_ * _loc10_);
               _loc12_ = toDegr * atan2(-_loc9_,_loc11_);
               _loc13_ = Math.round(5 * (_loc12_ - 10));
               if(_loc13_ < 1)
               {
                  _loc13_ = 1;
               }
               if(_loc13_ > 7)
               {
                  _loc13_ = 7;
               }
               this.lightning_mc.gotoAndStop(_loc13_);
               _loc14_ = toDegr * atan2(_loc5_.x,_loc5_.z + _loc4_ + 100);
               _loc14_ = sin(atan2(-_loc9_,_loc11_)) * _loc14_;
               d_o.rotation = _loc14_;
               d_o.visible = true;
            }
            this.striking = false;
         }
         else
         {
            d_o.visible = false;
         }
      }
   }
}

