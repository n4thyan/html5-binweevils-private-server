package com.binweevils.engine3D.visuals
{
   import com.binweevils.Bin_extInterface;
   import com.binweevils.engine3D.*;
   import com.binweevils.utilities.URLhandler;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class Object3D extends Visual
   {
      
      protected var container_spr:Sprite;
      
      public var p:Vector3D;
      
      protected var _scale:Number;
      
      public var rotX:Number;
      
      public var rotY:Number;
      
      public var visualElm:Element;
      
      public var _colour:Array;
      
      private var redOffset:*;
      
      private var greenOffset:*;
      
      private var blueOffset:Number;
      
      private var blueFade:Boolean;
      
      public var depth:Number;
      
      public function Object3D(param1:Element, param2:Number, param3:Number, param4:Number, param5:Number = 1, param6:Number = 0, param7:String = "", param8:Boolean = false)
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         super();
         this.visualElm = param1;
         this.container_spr = new Sprite();
         this.container_spr.addChild(this.visualElm.d_o);
         d_o = this.container_spr;
         this.set_p(new Vector3D(param2,param3,param4));
         this.scale = param5;
         this.rotX = 0;
         this.rotY = param6;
         this.blueFade = param8;
         if(param7 != "")
         {
            this._colour = param7.split(",");
            _loc9_ = int(this._colour[0]);
            _loc10_ = int(this._colour[1]);
            _loc11_ = int(this._colour[2]);
            this.redOffset = -255 + _loc9_;
            this.greenOffset = -255 + _loc10_;
            this.blueOffset = -255 + _loc11_;
            d_o.transform.colorTransform = new ColorTransform(1,1,1,1,this.redOffset,this.greenOffset,this.blueOffset,0);
         }
         else
         {
            this.redOffset = this.greenOffset = this.blueOffset = 0;
         }
      }
      
      override public function set_link(param1:String, param2:String) : void
      {
         link = param1;
         linkWindow = param2;
         this.container_spr.addEventListener(MouseEvent.CLICK,this.clickHandler);
         this.container_spr.buttonMode = true;
      }
      
      override public function set extUIDataObj(param1:Object) : void
      {
         _extUIDataObj = param1;
         this.container_spr.addEventListener(MouseEvent.CLICK,this.gotoIt);
         this.container_spr.buttonMode = true;
      }
      
      private function openExtUI(param1:MouseEvent) : void
      {
         if(Bin_extInterface.bin.ctrlsEnabled)
         {
            Bin_extInterface.bin.loadInterface(extUIDataObj);
         }
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         URLhandler.gotoURL(link,linkWindow);
      }
      
      private function gotoIt(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(Bin_extInterface.bin.ctrlsEnabled)
         {
            _loc2_ = Bin_extInterface.bin.crntLoc.legaliseClick(this.x - 6 + int(12 * Math.random()),this.z - 6 + int(12 * Math.random()));
            _loc3_ = _loc2_.x;
            _loc4_ = _loc2_.y;
            Bin_extInterface.bin.moveMyWeevil(_loc3_,_loc4_,false,null,0,0,extUIDataObj);
         }
      }
      
      override public function set boundary(param1:Object) : void
      {
         _boundaryObj = param1;
         _boundaryObj.x = this.x;
         _boundaryObj.z = this.z;
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
      
      public function set scale(param1:Number) : void
      {
         this._scale = param1;
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc4_:Number = ViewPort.d;
         var _loc5_:Vector3D = param1.transform_vtx(this.p,_loc4_);
         var _loc6_:Number = _loc4_ / (_loc4_ + _loc5_.z);
         var _loc7_:Number = ViewPort.x0 + _loc5_.x * _loc6_;
         this.depth = -_loc5_.z;
         if(this.depth > _loc4_ || _loc7_ < -300 || _loc7_ > 914)
         {
            d_o.visible = false;
         }
         else
         {
            d_o.x = _loc7_;
            d_o.y = ViewPort.y0 - _loc5_.y * _loc6_;
            d_o.scaleX = d_o.scaleY = _loc6_ * this._scale;
            d_o.visible = true;
            if(this.blueFade)
            {
               _loc15_ = (1650 - (_loc5_.z + 800)) / 1400;
               if(_loc15_ > 1)
               {
                  _loc15_ = 1;
               }
               _loc16_ = 1 - _loc15_;
               _loc17_ = _loc15_ * this.redOffset + _loc16_ * 30;
               _loc18_ = _loc15_ * this.greenOffset + _loc16_ * 30;
               _loc19_ = _loc15_ * this.blueOffset + _loc16_ * 149;
               d_o.transform.colorTransform = new ColorTransform(_loc15_,_loc15_,_loc15_,1,_loc17_,_loc18_,_loc19_);
            }
            _loc8_ = this.p.x - param1.x;
            _loc9_ = this.p.y - param1.y;
            _loc10_ = this.p.z - param1.z;
            _loc11_ = Math.sqrt(_loc8_ * _loc8_ + _loc10_ * _loc10_);
            _loc12_ = toDegr * atan2(_loc8_,_loc10_) + this.rotY;
            if(_loc12_ < 0)
            {
               _loc12_ += 360;
            }
            else if(_loc12_ > 360)
            {
               _loc12_ -= 360;
            }
            _loc13_ = toDegr * atan2(-_loc9_,_loc11_);
            this.visualElm.setViewAngle(_loc13_,_loc12_);
            _loc14_ = toDegr * atan2(_loc5_.x,_loc5_.z + _loc4_ + 100);
            _loc14_ = sin(atan2(-_loc9_,_loc11_)) * _loc14_;
            d_o.rotation = _loc14_;
            this.depth += _depthOffset;
         }
      }
   }
}

