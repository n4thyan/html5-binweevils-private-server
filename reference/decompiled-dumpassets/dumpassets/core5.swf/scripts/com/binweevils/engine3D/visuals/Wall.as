package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.ViewPort;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.SpreadMethod;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class Wall extends Visual
   {
      
      private var wall_spr:Sprite;
      
      private var xWall_shp:Shape;
      
      private var zWall_shp:Shape;
      
      private var c1:Vector3D;
      
      private var xWall:Boolean;
      
      private var zWall:Boolean;
      
      private var theta:Number;
      
      public function Wall(param1:int, param2:int)
      {
         super();
         this.xWall_shp = new Shape();
         this.zWall_shp = new Shape();
         this.wall_spr = new Sprite();
         this.wall_spr.addChild(this.xWall_shp);
         this.wall_spr.addChild(this.zWall_shp);
         d_o = this.wall_spr;
         var _loc3_:* = 510;
         var _loc4_:* = 1024;
         this.c1 = new Vector3D(_loc3_,0,_loc4_);
         this.xWall = Boolean(param1);
         this.zWall = Boolean(param2);
      }
      
      internal function init(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
      }
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
         var _loc7_:Graphics = null;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:Number = NaN;
         var _loc18_:Array = null;
         var _loc20_:Matrix = null;
         var _loc22_:Vector3D = null;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc4_:Number = param1.rx;
         var _loc5_:Number = -param1.ry;
         var _loc6_:Number = ViewPort.d;
         _loc7_ = this.xWall_shp.graphics;
         _loc7_.clear();
         var _loc16_:String = GradientType.LINEAR;
         var _loc17_:Array = [7438500,7438500];
         var _loc19_:Array = [0,255];
         var _loc21_:String = SpreadMethod.PAD;
         if(this.xWall && this.zWall)
         {
            _loc22_ = param1.transform_vtx(this.c1,_loc6_);
            _loc23_ = _loc6_ / (_loc6_ + _loc22_.z);
            _loc24_ = ViewPort.x0 + _loc22_.x * _loc23_;
         }
         if(this.xWall)
         {
            if(_loc5_ > 0 && _loc5_ < Math.PI)
            {
               _loc8_ = 510 - param1.x;
               _loc11_ = _loc8_ / Math.sin(_loc5_);
               _loc12_ = 1 - _loc11_ / 2000;
               _loc15_ = 0.5 * Math.PI - _loc5_;
               _loc15_ = _loc15_ * 0.5;
               _loc14_ = _loc12_ - _loc15_;
               _loc13_ = _loc12_ + _loc15_;
               _loc18_ = [_loc14_,_loc13_];
               if(this.zWall)
               {
                  _loc18_ = [_loc14_,_loc13_];
                  _loc20_ = new Matrix();
                  _loc20_.createGradientBox(ViewPort.w - _loc24_,ViewPort.h,0,_loc24_,0);
                  _loc7_.beginGradientFill(_loc16_,_loc17_,_loc18_,_loc19_,_loc20_,_loc21_);
                  _loc7_.drawRect(_loc24_,0,ViewPort.w - _loc24_,ViewPort.h);
               }
               else
               {
                  _loc20_ = new Matrix();
                  _loc20_.createGradientBox(ViewPort.w,ViewPort.h,0,0,0);
                  _loc7_.beginGradientFill(_loc16_,_loc17_,_loc18_,_loc19_,_loc20_,_loc21_);
                  _loc7_.drawRect(0,0,ViewPort.w,ViewPort.h);
               }
            }
         }
         _loc7_ = this.zWall_shp.graphics;
         _loc7_.clear();
         if(this.zWall)
         {
            if(_loc5_ > -0.5 * Math.PI && _loc5_ < 0.5 * Math.PI)
            {
               _loc9_ = 1024 - param1.z;
               _loc11_ = _loc9_ / Math.cos(_loc5_);
               _loc12_ = 1 - _loc11_ / 2000;
               _loc15_ = -_loc5_;
               _loc15_ = _loc15_ * 0.5;
               _loc14_ = _loc12_ - _loc15_;
               _loc13_ = _loc12_ + _loc15_;
               _loc18_ = [_loc14_,_loc13_];
               if(this.xWall)
               {
                  _loc18_ = [_loc14_,_loc13_];
                  _loc20_ = new Matrix();
                  _loc20_.createGradientBox(ViewPort.w - _loc24_,ViewPort.h,0,0,0);
                  _loc7_.beginGradientFill(_loc16_,_loc17_,_loc18_,_loc19_,_loc20_,_loc21_);
                  _loc7_.drawRect(0,0,_loc24_,ViewPort.h);
               }
               else
               {
                  _loc20_ = new Matrix();
                  _loc20_.createGradientBox(ViewPort.w,ViewPort.h,0,0,0);
                  _loc7_.beginGradientFill(_loc16_,_loc17_,_loc18_,_loc19_,_loc20_,_loc21_);
                  _loc7_.drawRect(0,0,ViewPort.w,ViewPort.h);
               }
            }
         }
      }
   }
}

