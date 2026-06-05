package com.binweevils
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class Zone
   {
      
      private var _name:String;
      
      private var _displayName:String;
      
      private var _asset:MovieClip;
      
      private var _assetParent:MovieClip;
      
      private var _ip:String;
      
      private var login:IBinZoneListener;
      
      public var xPos:Number;
      
      public var yPos:Number;
      
      public function Zone(param1:String, param2:String, param3:String, param4:int, param5:IBinZoneListener, param6:MovieClip, param7:int, param8:int)
      {
         super();
         this._ip = param3;
         this._name = param1;
         this._displayName = param2;
         this.setUpAsset(param5,param6,param7,param8);
         this.setZoneUserCountState(param4);
         this._asset.label_txt.text = this._displayName;
         this.xPos = param7;
         this.yPos = param8;
         this.resetPosition();
      }
      
      public function setUpAsset(param1:IBinZoneListener, param2:MovieClip, param3:int, param4:int) : *
      {
         this.login = param1;
         this._asset = param2;
         this._asset.label_txt.text = this._displayName;
      }
      
      public function resetPosition() : void
      {
         this._asset.x = this.xPos;
         this._asset.y = this.yPos;
      }
      
      public function get displayName() : String
      {
         return this._displayName;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set assetParent(param1:MovieClip) : *
      {
         this._assetParent = param1;
      }
      
      public function get assetParent() : MovieClip
      {
         return this._assetParent;
      }
      
      public function get asset() : MovieClip
      {
         return this._asset;
      }
      
      public function set ip(param1:String) : *
      {
         this._ip = param1;
      }
      
      public function get ip() : String
      {
         return this._ip;
      }
      
      private function setZoneUserCountState(param1:int) : *
      {
         var _loc2_:int = 0;
         this._asset.mouseChildren = false;
         if(param1 >= 6)
         {
            this._asset.gotoAndStop(2);
            this._asset.mouseEnabled = false;
            this._asset.buttonMode = false;
         }
         else
         {
            this._asset.gotoAndStop(1);
            _loc2_ = 1;
            while(_loc2_ < 6)
            {
               if(_loc2_ <= param1)
               {
                  this._asset["load" + _loc2_ + "_mc"].visible = true;
               }
               else
               {
                  this._asset["load" + _loc2_ + "_mc"].visible = false;
               }
               _loc2_++;
            }
            this._asset.addEventListener(MouseEvent.CLICK,this.onBinMouseClick);
            this._asset.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
            this._asset.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
            this._asset.mouseEnabled = true;
            this._asset.buttonMode = true;
         }
      }
      
      public function onBinMouseClick(param1:MouseEvent) : void
      {
         this.login.onBinMouseClick(this);
      }
      
      private function mouseOver(param1:MouseEvent) : void
      {
         this._asset.scaleX = 1.05;
         this._asset.scaleY = 1.05;
      }
      
      private function mouseOut(param1:MouseEvent) : void
      {
         this._asset.scaleX = 1;
         this._asset.scaleY = 1;
      }
      
      public function fadeOut() : void
      {
         TweenLite.killTweensOf(this._asset);
         TweenLite.to(this._asset,1,{
            "alpha":0,
            "onComplete":this.fadeOutComplete
         });
      }
      
      public function animateIn() : void
      {
         TweenLite.killTweensOf(this._asset);
         this._asset.alpha = 1;
         this.resetPosition();
         this._asset.y += 500;
         TweenLite.to(this._asset,1,{"y":this.yPos});
      }
      
      private function fadeOutComplete() : void
      {
         this._asset.parent.removeChild(this._asset);
         this._asset.alpha = 1;
      }
   }
}

