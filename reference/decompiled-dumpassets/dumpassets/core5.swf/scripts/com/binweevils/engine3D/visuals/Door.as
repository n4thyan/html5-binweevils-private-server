package com.binweevils.engine3D.visuals
{
   import com.binweevils.Bin;
   import com.binweevils.BinEvents;
   import com.binweevils.EventManager;
   import com.binweevils.engine3D.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Door
   {
      
      public var d_o:Sprite;
      
      public var id:int;
      
      private var clickArea_btn:SimpleButton;
      
      private var masks:Array;
      
      private var crntMask:int;
      
      private var hasMask:Boolean;
      
      private var loc:Loc;
      
      private var _x1:Number;
      
      private var _z1:Number;
      
      private var _x2:Number;
      
      private var _z2:Number;
      
      private var _y:Number;
      
      private var _y2:Number;
      
      private var _entryDir:Number;
      
      public var entryDirRads:Number;
      
      private var exitRect:Rectangle;
      
      private var _toLoc:int;
      
      private var _toDoor:int;
      
      private var _extUIDataObj:Object;
      
      private var _tycconOnly:Boolean;
      
      private var _nonTyconOverlay:String;
      
      private var bin:Object;
      
      public function Door(param1:Loc, param2:*, param3:Sprite, param4:int, param5:Object, param6:int, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number = 0, param13:Number = 0, param14:String = "fixedCam", param15:Boolean = false, param16:String = "")
      {
         var _loc17_:* = undefined;
         super();
         this.id = param2;
         this.d_o = param3;
         this._x1 = param7 + 3 - 6 * Math.random();
         this._z1 = param8 + 3 - 6 * Math.random();
         this._x2 = param9;
         this._z2 = param10;
         this._y = param12;
         this._y2 = param13;
         this._entryDir = param11;
         this.entryDirRads = param11 * Math.PI / 180;
         this.entryDirRads += Math.random() - 0.5;
         this.loc = param1;
         this.link(param4,param6,param5);
         this.exitRect = new Rectangle(this.x1 - 30,this.z1 - 30,60,60);
         if(this.d_o != null)
         {
            this.masks = new Array();
            this.masks.push(this.d_o.getChildByName("mask1_spr"));
            this.masks.push(this.d_o.getChildByName("mask2_spr"));
            this.masks.push(this.d_o.getChildByName("mask3_spr"));
            if(this.masks[0] != null)
            {
               this.hasMask = true;
               for(_loc17_ in this.masks)
               {
                  this.masks[_loc17_].visible = false;
               }
            }
            if(param14 == "fixedCam")
            {
               this.clickArea_btn = SimpleButton(this.d_o.getChildByName("clickArea_btn"));
               this.clickArea_btn.addEventListener(MouseEvent.MOUSE_UP,this.gotoDoor);
            }
            else
            {
               this.setClickHandler(this.d_o);
            }
            this._tycconOnly = param15;
            this._nonTyconOverlay = param16;
         }
      }
      
      public function replaceClickTarget(param1:Sprite) : void
      {
         this.removeClickHandler(this.d_o);
         this.setClickHandler(param1);
         this.d_o = param1;
      }
      
      private function setClickHandler(param1:Sprite) : void
      {
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.HiLiExit);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.LoLiExit);
         param1.addEventListener(MouseEvent.MOUSE_UP,this.gotoDoor);
         param1.buttonMode = true;
      }
      
      private function removeClickHandler(param1:Sprite) : void
      {
         param1.removeEventListener(MouseEvent.MOUSE_OVER,this.HiLiExit);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,this.LoLiExit);
         param1.removeEventListener(MouseEvent.MOUSE_UP,this.gotoDoor);
      }
      
      private function HiLiExit(param1:MouseEvent) : void
      {
         this.d_o.transform.colorTransform = new ColorTransform(1.5,1.5,1,1,0,0,0,0);
      }
      
      private function LoLiExit(param1:MouseEvent) : void
      {
         this.d_o.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
      }
      
      public function setVis(param1:Boolean) : void
      {
         this.d_o.visible = param1;
      }
      
      public function getVis() : Boolean
      {
         return this.d_o.visible;
      }
      
      public function link(param1:int, param2:int, param3:Object) : void
      {
         this._toLoc = param1;
         this._toDoor = param2;
         this._extUIDataObj = param3;
         if(this._extUIDataObj != null)
         {
            this._extUIDataObj.limbo = true;
         }
      }
      
      public function get x1() : Number
      {
         return this._x1;
      }
      
      public function get z1() : Number
      {
         return this._z1;
      }
      
      public function get x2() : Number
      {
         return this._x2;
      }
      
      public function get z2() : Number
      {
         return this._z2;
      }
      
      public function get y() : Number
      {
         return this._y;
      }
      
      public function get y2() : Number
      {
         return this._y2;
      }
      
      public function get entryDir() : Number
      {
         return this._entryDir;
      }
      
      public function get toLoc() : int
      {
         return this._toLoc;
      }
      
      public function get toDoor() : int
      {
         return this._toDoor;
      }
      
      public function get extUIDataObj() : Object
      {
         return this._extUIDataObj;
      }
      
      public function gotoDoor(param1:MouseEvent = null) : void
      {
         if(Bin.controlsEnabled)
         {
            this.bin = Bin.get_instance();
            if(this._tycconOnly == true && this.bin.tycoon == false)
            {
               this.bin.moveMyWeevil(this.x1,this.z1);
               EventManager.get_instance().addEventListener(BinEvents.WEEVIL_ARRIVED,this.gotToTheDoor);
            }
            else
            {
               this.loc.gotoDoor(this);
            }
         }
         else
         {
            EventManager.get_instance().dispatchEvent(new Event(BinEvents.DISABLED_UI_DOOR_CLICK));
         }
      }
      
      private function gotToTheDoor(param1:Event) : void
      {
         EventManager.get_instance().removeEventListener(BinEvents.WEEVIL_ARRIVED,this.gotToTheDoor);
         this.bin.loadOverlayUI(this._nonTyconOverlay);
      }
      
      public function applyMask(param1:DisplayObject) : void
      {
         if(this.hasMask)
         {
            ++this.crntMask;
            if(this.crntMask > 2)
            {
               this.crntMask = 0;
            }
            param1.mask = this.masks[this.crntMask];
         }
         else
         {
            param1.mask = null;
         }
      }
      
      public function isInExitArea(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Point = new Point();
         _loc3_.x = param1;
         _loc3_.y = param2;
         return this.exitRect.containsPoint(_loc3_);
      }
   }
}

