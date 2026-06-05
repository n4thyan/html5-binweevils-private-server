package com.binweevils.buddies
{
   import caurina.transitions.Tweener;
   import com.binweevils.Bin_extInterface;
   import com.binweevils.utilities.SimpleLoader;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getTimer;
   
   public class BuddyWallItem
   {
      
      private const HEIGHT_MIN:int = 50;
      
      private const MUGSHOT_WIDTH:int = 50;
      
      private const PADDING_ICON:int = 10;
      
      private const DELIMITER_TEXT_EVENT:String = "|";
      
      private const DELAY_LOAD_ICON:Number = 0.03;
      
      private var itemMC:MovieClip;
      
      private var msgTxt:TextField;
      
      private var agoTxt:TextField;
      
      private var bin:Object;
      
      private var wall:BuddyWall;
      
      private var info:Object;
      
      private var maskMC:MovieClip;
      
      public function BuddyWallItem(param1:BuddyWall, param2:MovieClip)
      {
         super();
         this.itemMC = param2;
         this.msgTxt = this.itemMC.msg_txt;
         this.msgTxt.styleSheet = this.getStyle();
         this.agoTxt = this.itemMC.ago_txt;
         this.bin = Bin_extInterface.bin;
         this.wall = param1;
         this.maskMC = this.itemMC.mask_mc;
         this.maskMC.visible = false;
         this.itemMC.mugshotHolder_mc.mask = this.maskMC;
         this.itemMC.addEventListener(TextEvent.LINK,this.textLinkHandler);
      }
      
      private function getStyle() : StyleSheet
      {
         var _loc1_:StyleSheet = new StyleSheet();
         _loc1_.parseCSS("a:link{color:#ff0000}a:hover{color:#0000ff}");
         return _loc1_;
      }
      
      public function getMC() : MovieClip
      {
         return this.itemMC;
      }
      
      public function setInfo(param1:Object, param2:int) : void
      {
         this.setAgo(param1.ago);
         this.setMsg(param1.message);
         this.itemMC.addEventListener(Event.ENTER_FRAME,this.removeAutoSize);
         this.info = param1;
         this.getIcons(param2);
      }
      
      private function setMsg(param1:String) : void
      {
         this.msgTxt.multiline = true;
         this.msgTxt.wordWrap = true;
         this.msgTxt.autoSize = TextFieldAutoSize.LEFT;
         this.msgTxt.htmlText = param1;
      }
      
      private function setAgo(param1:String) : void
      {
         this.agoTxt.htmlText = param1;
      }
      
      private function removeAutoSize(param1:Event) : void
      {
         this.itemMC.removeEventListener(Event.ENTER_FRAME,this.removeAutoSize);
         this.msgTxt.autoSize = TextFieldAutoSize.NONE;
      }
      
      public function getIcons(param1:int) : void
      {
         Tweener.addTween(this.itemMC,{
            "delay":0.05 + param1 * this.DELAY_LOAD_ICON,
            "onComplete":this.addMugshot,
            "onCompleteParams":[this.info.weevilDef]
         });
         Tweener.addTween(this.itemMC,{
            "delay":0.05 + param1 * this.DELAY_LOAD_ICON,
            "onComplete":this.addIcon,
            "onCompleteParams":[this.info.icon]
         });
      }
      
      private function addMugshot(param1:String) : void
      {
         var _loc3_:Bitmap = null;
         var _loc5_:Object = null;
         var _loc6_:uint = 0;
         var _loc2_:int = getTimer();
         var _loc4_:BitmapData = BuddyMugshots.getMugshotData(param1);
         if(_loc4_)
         {
            _loc3_ = new Bitmap(BuddyMugshots.getMugshotData(param1),"auto",true);
         }
         else
         {
            _loc5_ = {"weevilDef":param1};
            _loc6_ = 0;
            _loc3_ = this.bin.getWeevilMugshot(null,_loc5_,_loc6_);
            BuddyMugshots.setMugshotData(param1,_loc3_.bitmapData);
         }
         this.itemMC.mugshotHolder_mc.addChild(_loc3_);
         _loc3_.smoothing = true;
         _loc3_.width = this.MUGSHOT_WIDTH;
         _loc3_.scaleY = _loc3_.scaleX;
         this.itemMC.mugshotHolder_mc.mouseEnabled = false;
         this.itemMC.mugshot_spr.addEventListener(MouseEvent.CLICK,this.onMugshotClick);
         this.itemMC.mugshot_spr.buttonMode = true;
      }
      
      private function addIcon(param1:String) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:SimpleLoader = new SimpleLoader(param1,null,this.onIconLoadComplete,this.onIconLoadError);
      }
      
      private function onIconLoadComplete(param1:Event) : void
      {
         var _loc2_:Loader = Loader(param1.target.loader);
         var _loc3_:* = _loc2_.content;
         if(_loc3_ is MovieClip || _loc3_ is Bitmap)
         {
            _loc3_.smoothing = true;
         }
         _loc3_.height = 35;
         _loc3_.scaleX = _loc3_.scaleY;
         this.itemMC.addChild(_loc2_);
         _loc2_.x = 30;
         _loc2_.y = 60;
      }
      
      private function onIconLoadError(param1:IOErrorEvent) : void
      {
      }
      
      private function checkResizeBG() : void
      {
      }
      
      private function onMugshotClick(param1:MouseEvent) : void
      {
         this.showWeevilProfile();
      }
      
      private function showWeevilProfile(param1:String = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         if(param1 != null)
         {
            _loc2_ = BuddyData.getInfoForWeevil(param1);
         }
         else
         {
            for(_loc3_ in this.info)
            {
            }
            if(int(this.info.idx) == this.bin.myUserIDX)
            {
               this.wall.getUI().showMyProfile();
               return;
            }
            _loc2_ = BuddyData.getInfoForWeevil(this.info.userWeevilID);
         }
         this.wall.getUI().showWeevilProfile(this.getLargeMugshotSprite(),_loc2_.name,_loc2_.idx,_loc2_.level,_loc2_.tycoon,_loc2_.lastLog);
      }
      
      private function getLargeMugshotSprite() : Sprite
      {
         var _loc1_:Bitmap = this.bin.getWeevilMugshot(null,{"weevilDef":this.info.weevilDef},2);
         var _loc2_:Sprite = new Sprite();
         _loc2_.addChild(_loc1_);
         return _loc2_;
      }
      
      private function textLinkHandler(param1:TextEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc2_:String = param1.text;
         if(_loc2_.indexOf(this.DELIMITER_TEXT_EVENT) == -1)
         {
            _loc3_ = _loc2_;
         }
         else
         {
            _loc5_ = _loc2_.split(this.DELIMITER_TEXT_EVENT);
            _loc3_ = _loc5_[0];
            _loc4_ = _loc5_[1];
         }
         switch(_loc3_)
         {
            case "weevil":
               _loc6_ = BuddyData.getWeevilNameForIDX(int(_loc4_));
               if(_loc6_ == null)
               {
                  if(_loc4_ == this.bin.myUserIDX)
                  {
                     this.wall.getUI().showMyProfile();
                  }
               }
               else
               {
                  this.showWeevilProfile(_loc6_);
               }
               break;
            case "location":
               this.bin.loadLoc(_loc4_);
         }
      }
   }
}

