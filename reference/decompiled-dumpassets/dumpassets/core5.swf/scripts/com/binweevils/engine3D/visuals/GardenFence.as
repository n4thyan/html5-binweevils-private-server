package com.binweevils.engine3D.visuals
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   public class GardenFence extends Visual implements NestItem
   {
      
      private var _cat:int;
      
      private var _id:Number;
      
      private var _powerConsumption:int;
      
      private var _configName:String;
      
      private var _thumb:DisplayObject;
      
      private var _inLimbo:Boolean;
      
      private var _noSell:Boolean;
      
      private var selectionHandler:Function;
      
      private var thumbCopy:Sprite;
      
      public var fenceFront_mc:MovieClip;
      
      public var fenceBack_mc:MovieClip;
      
      public function GardenFence(param1:int, param2:Sprite)
      {
         super();
         this.id = param1;
         d_o = param2;
         this.fenceFront_mc = MovieClip(param2.getChildByName("fenceFront_mc"));
         this.fenceBack_mc = MovieClip(param2.getChildByName("fenceBack_mc"));
      }
      
      public function setFenceSize(param1:int) : void
      {
         this.fenceFront_mc.gotoAndStop(param1);
         this.fenceBack_mc.gotoAndStop(param1);
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
      }
      
      public function get configName() : String
      {
         return null;
      }
      
      public function setThumb(param1:DisplayObject) : void
      {
         this._thumb = param1;
         this.thumbCopy = this.createThumbCopy(Sprite(this._thumb));
      }
      
      public function get thumb() : DisplayObject
      {
         return this._thumb;
      }
      
      private function createThumbCopy(param1:Sprite) : Sprite
      {
         var _loc2_:BitmapData = new BitmapData(100,100,true,0);
         _loc2_.draw(param1);
         var _loc3_:Bitmap = new Bitmap(_loc2_);
         var _loc4_:Sprite = new Sprite();
         _loc4_.addChild(_loc3_);
         return _loc4_;
      }
      
      public function getThumbDragable(param1:int) : Sprite
      {
         if(param1 > 1)
         {
            return this.thumbCopy;
         }
         return Sprite(this._thumb);
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
            this.fenceFront_mc.transform.colorTransform = new ColorTransform(1,1,1,1,_loc2_,_loc3_,_loc4_,0);
            this.fenceBack_mc.transform.colorTransform = new ColorTransform(1,1,1,1,_loc2_,_loc3_,_loc4_,0);
         }
         else if(int("0x" + param1) > 0)
         {
            _loc6_ = int("0x" + param1);
            _loc2_ = _loc6_ >> 16;
            _loc3_ = _loc6_ >> 8 & 0xFF;
            _loc4_ = _loc6_ & 0xFF;
            this._thumb.transform.colorTransform = new ColorTransform(1,1,1,1,-255 + _loc2_,-255 + _loc3_,-255 + _loc4_,0);
            this.fenceFront_mc.transform.colorTransform = new ColorTransform(1,1,1,1,-255 + _loc2_,-255 + _loc3_,-255 + _loc4_,0);
            this.fenceBack_mc.transform.colorTransform = new ColorTransform(1,1,1,1,-255 + _loc2_,-255 + _loc3_,-255 + _loc4_,0);
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
   }
}

