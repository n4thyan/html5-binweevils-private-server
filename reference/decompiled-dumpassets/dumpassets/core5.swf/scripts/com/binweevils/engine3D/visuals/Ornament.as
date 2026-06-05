package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.*;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.utils.Timer;
   
   public class Ornament extends Object3D implements NestItem
   {
      
      private var _cat:int;
      
      private var _id:int;
      
      private var _powerConsumption:int;
      
      private var _configName:String;
      
      private var _thumb:DisplayObject;
      
      private var _inLimbo:Boolean;
      
      private var _noSell:Boolean;
      
      private var _fID:int;
      
      private var _spotID:int;
      
      private var _furniture:Furniture;
      
      private var spot:Spot;
      
      private var flickerTimer:Timer;
      
      private var selectionHandler:Function;
      
      private var cam:Cam3D;
      
      private var viewPort:ViewPort;
      
      public function Ornament(param1:int, param2:int, param3:int, param4:Element, param5:Number, param6:Number, param7:Number, param8:Number = 1, param9:Number = 0)
      {
         super(param4,param5,param6,param7,param8,param9);
         this.id = param1;
         this.fID = param2;
         this.spotID = param3;
         this.flickerTimer = new Timer(250,1);
         this.flickerTimer.addEventListener("timer",this.resetAlpha);
      }
      
      public function setSelectionHandler(param1:Function) : void
      {
         this.selectionHandler = param1;
         d_o.addEventListener(MouseEvent.MOUSE_DOWN,this.selectMe);
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
         else if(int(param1) > 0)
         {
            _loc6_ = int(param1);
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
      
      public function set fID(param1:int) : void
      {
         this._fID = param1;
      }
      
      public function get fID() : int
      {
         return this._fID;
      }
      
      public function set spotID(param1:int) : void
      {
         this._spotID = param1;
      }
      
      public function get spotID() : int
      {
         return this._spotID;
      }
      
      public function set furniture(param1:Furniture) : void
      {
         this._furniture = param1;
      }
      
      public function get furniture() : Furniture
      {
         return this._furniture;
      }
      
      public function setSpot(param1:Spot) : void
      {
         p = param1;
         this.spotID = param1.id;
      }
      
      public function flicker() : void
      {
         d_o.alpha = 0.5;
         this.flickerTimer.start();
      }
      
      private function resetAlpha(param1:TimerEvent) : void
      {
         d_o.alpha = 1;
      }
      
      public function setClickHandler(param1:Function) : void
      {
         d_o.addEventListener(MouseEvent.CLICK,param1);
         Sprite(d_o).buttonMode = true;
      }
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
         super.render(param1,this.viewPort,param3);
         this.cam = param1;
         this.viewPort = param2;
      }
      
      public function forceRender() : void
      {
         this.render(this.cam,this.viewPort,1);
      }
   }
}

