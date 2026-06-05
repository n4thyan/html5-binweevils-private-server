package com.binweevils
{
   import com.binweevils.utilities.URLhandler;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   public class ApparelSwitch
   {
      
      private var apparelControl:ApparelControl;
      
      private var _id:int;
      
      private var _cat:int;
      
      private var _rgb:String;
      
      private var holder_spr:Sprite;
      
      private var bgSq_mc:MovieClip;
      
      private var _beingWorn:Boolean;
      
      private var thumb:DisplayObject;
      
      private var loaded:Boolean;
      
      public function ApparelSwitch(param1:ApparelControl, param2:Sprite, param3:int, param4:int, param5:String, param6:Boolean)
      {
         super();
         this.apparelControl = param1;
         this._id = param3;
         this._cat = param4;
         this._rgb = param5;
         this.holder_spr = param2;
         this.bgSq_mc = MovieClip(this.holder_spr.getChildByName("bg_mc"));
         this.beingWorn = param6;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get cat() : int
      {
         return this._cat;
      }
      
      public function get rgb() : String
      {
         return this._rgb;
      }
      
      public function get beingWorn() : Boolean
      {
         return this._beingWorn;
      }
      
      public function set beingWorn(param1:Boolean) : void
      {
         this._beingWorn = param1;
         if(this._beingWorn)
         {
            this.bgSq_mc.gotoAndStop(2);
         }
         else
         {
            this.bgSq_mc.gotoAndStop(1);
         }
      }
      
      public function loadThumb() : void
      {
         var _loc1_:* = null;
         var _loc2_:Loader = null;
         if(!this.loaded)
         {
            _loc1_ = "assets3D/apparel_" + this.id + "_thumb.swf";
            _loc2_ = new Loader();
            URLhandler.loadFromCDN(_loc2_,_loc1_,this.thumbLoaded,false);
         }
         else
         {
            this.apparelControl.loadManager();
         }
      }
      
      private function thumbLoaded(param1:Event) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(!this.loaded)
         {
            this.loaded = true;
            this.thumb = param1.target.content;
            this.holder_spr.addChild(this.thumb);
            if(this.rgb != "0")
            {
               _loc2_ = this.rgb.split(",");
               _loc3_ = int(_loc2_[0]);
               _loc4_ = int(_loc2_[1]);
               _loc5_ = int(_loc2_[2]);
               this.thumb.transform.colorTransform = new ColorTransform(1,1,1,1,_loc3_,_loc4_,_loc5_,0);
            }
            this.holder_spr.addEventListener(MouseEvent.CLICK,this.clicked);
            this.apparelControl.loadManager();
         }
      }
      
      private function clicked(param1:MouseEvent) : void
      {
         this.apparelControl.apparelClicked(this);
      }
      
      public function cleanUp() : void
      {
         if(this.loaded)
         {
            this.holder_spr.removeEventListener(MouseEvent.CLICK,this.clicked);
            this.holder_spr.removeChild(this.thumb);
            this.loaded = false;
         }
      }
   }
}

