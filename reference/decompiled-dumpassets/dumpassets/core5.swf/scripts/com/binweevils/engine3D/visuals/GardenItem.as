package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.ViewPort;
   import com.binweevils.engine3D.atan2;
   import com.binweevils.engine3D.sin;
   import com.binweevils.engine3D.toDegr;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class GardenItem extends Visual implements NestItem
   {
      
      public var p:Vector3D;
      
      public var r:Number;
      
      protected var _scale:Number;
      
      protected var mc:MovieClip;
      
      public var depth:Number;
      
      private var _cat:int;
      
      private var _id:int;
      
      private var _powerConsumption:int;
      
      private var _configName:String;
      
      private var _thumb:DisplayObject;
      
      private var _inLimbo:Boolean;
      
      private var _noSell:Boolean;
      
      private var selectionHandler:Function;
      
      public var name:String = "";
      
      public var clr:String = "";
      
      public var deliveryTime:Number = 0;
      
      public function GardenItem(param1:int, param2:MovieClip, param3:Number, param4:Number, param5:Number, param6:Number = 1)
      {
         super();
         this.id = param1;
         this.mc = param2;
         d_o = param2;
         this.set_p(new Vector3D(param3,0,param4));
         this.r = param5;
         this.scale = param6;
      }
      
      public function setSelectionHandler(param1:Function) : void
      {
         this.selectionHandler = param1;
         d_o.addEventListener(MouseEvent.MOUSE_DOWN,this.selectMe);
      }
      
      public function removeSelectionHandler() : void
      {
         if(this.selectionHandler != null)
         {
            d_o.removeEventListener(MouseEvent.MOUSE_DOWN,this.selectMe);
            this.selectionHandler = null;
         }
      }
      
      public function selectMe(param1:MouseEvent) : void
      {
         this.selectionHandler(this.id);
      }
      
      public function set cat(param1:int) : void
      {
         this._cat = param1;
      }
      
      public function get cat() : int
      {
         return this._cat;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set powerConsumption(param1:int) : void
      {
         this._powerConsumption = param1;
      }
      
      public function get powerConsumption() : int
      {
         return this._powerConsumption;
      }
      
      public function set configName(param1:String) : void
      {
         this._configName = param1;
      }
      
      public function get configName() : String
      {
         return this._configName;
      }
      
      public function setThumb(param1:DisplayObject) : void
      {
         this._thumb = param1;
      }
      
      public function get thumb() : DisplayObject
      {
         return this._thumb;
      }
      
      public function setClr(param1:String) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = 0;
         var _loc6_:int = 0;
         var _loc5_:Array = param1.split(",");
         if(_loc5_.length == 3)
         {
            _loc2_ = int(_loc5_[0]);
            _loc3_ = int(_loc5_[1]);
            _loc4_ = int(_loc5_[2]);
            this._thumb.transform.colorTransform = new ColorTransform(1,1,1,1,_loc2_,_loc3_,_loc4_,0);
            d_o.transform.colorTransform = new ColorTransform(1,1,1,1,_loc2_,_loc3_,_loc4_,0);
         }
         else if(int("0x" + param1) > 0)
         {
            _loc6_ = int("0x" + param1);
            _loc2_ = _loc6_ >> 16;
            _loc3_ = _loc6_ >> 8 & 0xFF;
            _loc4_ = _loc6_ & 0xFF;
            this._thumb.transform.colorTransform = new ColorTransform(1,1,1,1,-255 + _loc2_,-255 + _loc3_,-255 + _loc4_,0);
            d_o.transform.colorTransform = new ColorTransform(1,1,1,1,-255 + _loc2_,-255 + _loc3_,-255 + _loc4_,0);
         }
      }
      
      public function set inLimbo(param1:Boolean) : void
      {
         this._inLimbo = param1;
      }
      
      public function get inLimbo() : Boolean
      {
         return this._inLimbo;
      }
      
      public function set noSell(param1:Boolean) : void
      {
         this._noSell = param1;
      }
      
      public function get noSell() : Boolean
      {
         return this._noSell;
      }
      
      public function flicker() : void
      {
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
      
      public function clashCheck(param1:Number, param2:Number, param3:Number) : Boolean
      {
         var _loc4_:Number = this.x - param1;
         var _loc5_:Number = this.z - param2;
         var _loc6_:Number = _loc4_ * _loc4_ + _loc5_ * _loc5_;
         var _loc7_:Number = this.r + param3;
         var _loc8_:Number = _loc7_ * _loc7_;
         return _loc6_ < _loc8_;
      }
      
      public function getRenderCoords() : Point
      {
         return new Point(this.mc.x,this.mc.y);
      }
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
         var _loc4_:Number = ViewPort.d;
         var _loc5_:Vector3D = param1.transform_vtx(this.p,_loc4_);
         var _loc6_:Number = _loc4_ / (_loc4_ + _loc5_.z);
         var _loc7_:Number = ViewPort.x0 + _loc5_.x * _loc6_;
         this.depth = -_loc5_.z;
         d_o.x = _loc7_;
         d_o.y = ViewPort.y0 - _loc5_.y * _loc6_;
         d_o.scaleX = d_o.scaleY = _loc6_ * this._scale;
         var _loc8_:Number = this.p.x - param1.x;
         var _loc9_:Number = this.p.y - param1.y;
         var _loc10_:Number = this.p.z - param1.z;
         var _loc11_:Number = Math.sqrt(_loc8_ * _loc8_ + _loc10_ * _loc10_);
         var _loc12_:Number = toDegr * atan2(_loc5_.x,_loc5_.z + _loc4_ + 100);
         _loc12_ = sin(atan2(-_loc9_,_loc11_)) * _loc12_;
         d_o.rotation = _loc12_;
      }
   }
}

