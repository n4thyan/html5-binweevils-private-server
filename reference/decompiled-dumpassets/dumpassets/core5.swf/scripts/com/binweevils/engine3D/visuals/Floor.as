package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.*;
   import flash.display.*;
   import flash.geom.Matrix;
   
   public class Floor extends Visual
   {
      
      private var floor_spr:Sprite;
      
      private var floor_bd:BitmapData;
      
      private var scans:Array;
      
      private var fade:Boolean;
      
      private var zCentreOffset:Number;
      
      public function Floor(param1:Bitmap)
      {
         super();
         this.floor_spr = new Sprite();
         d_o = this.floor_spr;
         this.floor_bd = Bitmap(param1).bitmapData;
         this.zCentreOffset = 0.5 * param1.width;
      }
      
      internal function init(param1:ViewPort, param2:Boolean = true) : void
      {
         var _loc4_:int = 0;
         this.fade = param2;
         this.floor_spr.x = ViewPort.x0;
         this.floor_spr.y = ViewPort.y0;
         this.scans = new Array();
         var _loc3_:Number = param1.numScansX;
         var _loc5_:int = 1;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            this.scans[_loc4_] = new Sprite();
            this.scans[_loc4_].x = 0;
            this.scans[_loc4_].y = _loc4_ - ViewPort.y0;
            this.floor_spr.addChild(this.scans[_loc4_]);
            _loc4_++;
         }
      }
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc19_:Matrix = null;
         var _loc31_:Sprite = null;
         var _loc4_:Number = param2.numScansX;
         var _loc17_:* = Math.sin;
         var _loc18_:* = Math.cos;
         var _loc20_:Number = -param1.rx;
         var _loc21_:Number = -param1.ry;
         var _loc22_:Number = param1.x;
         var _loc23_:Number = param1.y;
         var _loc24_:Number = param1.z;
         _loc19_ = new Matrix();
         _loc19_.identity();
         _loc19_.rotate(_loc21_);
         var _loc25_:* = _loc19_.a;
         var _loc26_:* = _loc19_.b;
         var _loc27_:* = _loc19_.c;
         var _loc28_:* = _loc19_.d;
         _loc5_ = ViewPort.x0 / 800;
         _loc12_ = 40 / _loc4_ * Math.PI / 180;
         _loc13_ = _loc20_ - _loc12_ * _loc4_ * 0.5;
         _loc9_ = _loc17_(_loc21_);
         _loc11_ = _loc18_(_loc21_);
         var _loc29_:Array = param2.thetaX;
         var _loc30_:int = -1;
         while(++_loc30_ < _loc4_)
         {
            _loc31_ = this.scans[_loc30_];
            _loc31_.graphics.clear();
            _loc13_ = _loc20_ + _loc29_[_loc30_];
            _loc10_ = _loc17_(_loc13_);
            if(_loc10_ >= 0)
            {
               _loc14_ = _loc23_ / _loc10_;
               _loc15_ = 1.3 - 0.00085 * _loc14_;
               if(_loc15_ >= 0.01)
               {
                  if(this.fade)
                  {
                     _loc31_.alpha = _loc15_;
                  }
                  _loc16_ = _loc18_(_loc13_) * _loc14_;
                  _loc7_ = -_loc22_ - _loc9_ * _loc16_ - this.zCentreOffset;
                  _loc8_ = -_loc24_ - _loc11_ * _loc16_;
                  _loc19_.tx = _loc7_ * _loc25_ + _loc8_ * _loc27_;
                  _loc19_.ty = _loc7_ * _loc26_ + _loc8_ * _loc28_;
                  _loc6_ = _loc5_ * _loc14_;
                  _loc31_.scaleX = 800 / _loc14_;
                  _loc31_.graphics.beginBitmapFill(this.floor_bd,_loc19_,false,true);
                  _loc31_.graphics.moveTo(-_loc6_,0);
                  _loc31_.graphics.lineTo(_loc6_,0);
                  _loc31_.graphics.lineTo(_loc6_,1);
                  _loc31_.graphics.lineTo(-_loc6_,1);
                  _loc31_.graphics.endFill();
               }
            }
         }
      }
   }
}

