package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.ViewPort;
   import com.binweevils.engine3D.atan2;
   import com.binweevils.engine3D.sin;
   import com.binweevils.engine3D.toDegr;
   import flash.display.MovieClip;
   import flash.errors.IllegalOperationError;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class Plant extends Visual
   {
      
      public var id:int;
      
      public var cat:int;
      
      public var name:String;
      
      protected var _growTime:int;
      
      protected var _mulchYield:int;
      
      protected var _xpYield:int;
      
      protected var _age:int;
      
      protected var _state:int;
      
      protected var pctGrown:int;
      
      protected var garden:LocGarden;
      
      protected const GROWING:int = 1;
      
      protected const FRUITING:int = 2;
      
      protected const HARVESTABLE:int = 3;
      
      protected const NEARLY_PERISHED:int = 4;
      
      protected const PERISHED:int = 5;
      
      public var p:Vector3D;
      
      public var r:Number;
      
      protected var _scale:Number;
      
      protected var mc:MovieClip;
      
      public var _colour:Array;
      
      public var depth:Number;
      
      private var mirror:int;
      
      private var selectionHandler:Function;
      
      public var busy:Boolean;
      
      public function Plant(param1:int, param2:MovieClip, param3:String, param4:Number, param5:Number, param6:Number, param7:int, param8:int, param9:int, param10:int, param11:Number = 0.5, param12:String = "")
      {
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         super();
         this.id = param1;
         this.mc = param2.mc;
         d_o = param2;
         this.set_p(new Vector3D(param4,0,param5));
         this.r = param6;
         this.scale = param11;
         if(this.id % 2 == 0)
         {
            this.mirror = 1;
         }
         else
         {
            this.mirror = -1;
         }
         this.name = param3;
         this._age = param7;
         this._growTime = param8;
         this._mulchYield = param9;
         this._xpYield = param10;
         type = "plant";
         if(param12 != "")
         {
            this._colour = param12.split(",");
            _loc13_ = int(this._colour[0]);
            _loc14_ = int(this._colour[1]);
            _loc15_ = int(this._colour[2]);
            d_o.transform.colorTransform = new ColorTransform(1,1,1,1,-255 + _loc13_,-255 + _loc14_,-255 + _loc15_,0);
         }
      }
      
      public function set age(param1:int) : void
      {
         this._age = param1;
         this.setState();
      }
      
      public function incrAge() : void
      {
         this.age = this._age + 1;
      }
      
      public function get growTime() : int
      {
         return this._growTime;
      }
      
      public function get mulchYield() : int
      {
         return this._mulchYield;
      }
      
      public function get xpYield() : int
      {
         return this._xpYield;
      }
      
      public function getProgress() : int
      {
         return this.pctGrown;
      }
      
      protected function setState() : void
      {
         throw new IllegalOperationError("Abstract method: must be overridden in a subclass");
      }
      
      public function harvest() : void
      {
         throw new IllegalOperationError("Abstract method: must be overridden in a subclass");
      }
      
      public function setGarden(param1:LocGarden) : void
      {
         this.garden = param1;
         this.age = this._age;
      }
      
      public function setClickHandler() : void
      {
         this.mc.addEventListener(MouseEvent.CLICK,this.mcClicked);
      }
      
      protected function mcClicked(param1:MouseEvent) : void
      {
         throw new IllegalOperationError("Abstract method: must be overridden in a subclass");
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
         if(this.selectionHandler != null)
         {
            this.selectionHandler(this.id);
         }
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
         return new Point(d_o.x,d_o.y);
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
         var _loc8_:Number = _loc6_ * this._scale;
         d_o.scaleX = _loc8_ * this.mirror;
         d_o.scaleY = _loc8_;
         var _loc9_:Number = this.p.x - param1.x;
         var _loc10_:Number = this.p.y - param1.y;
         var _loc11_:Number = this.p.z - param1.z;
         var _loc12_:Number = Math.sqrt(_loc9_ * _loc9_ + _loc11_ * _loc11_);
         var _loc13_:Number = toDegr * atan2(_loc5_.x,_loc5_.z + _loc4_ + 100);
         _loc13_ = sin(atan2(-_loc10_,_loc12_)) * _loc13_;
         d_o.rotation = _loc13_;
      }
   }
}

