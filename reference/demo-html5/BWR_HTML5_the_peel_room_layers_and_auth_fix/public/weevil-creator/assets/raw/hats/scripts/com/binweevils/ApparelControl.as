package com.binweevils
{
   import com.binweevils.utilities.URLhandler;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class ApparelControl
   {
      
      private var apparelContent_mc:MovieClip;
      
      private var apparel:Array;
      
      private var numItems:int;
      
      private var crntItem:int;
      
      private var numSets:int;
      
      private var crntSetNum:int;
      
      private var apparelHolders:Array;
      
      private var initialised:Boolean;
      
      public function ApparelControl(param1:MovieClip)
      {
         super();
         this.apparelContent_mc = param1;
         this.apparelHolders = new Array();
         this.apparelContent_mc.apparel_next_btn.addEventListener(MouseEvent.CLICK,this.incrSetNum);
         this.apparelContent_mc.apparel_back_btn.addEventListener(MouseEvent.CLICK,this.decrSetNum);
      }
      
      public function newItemsAdded() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.apparel)
         {
            this.apparel[_loc1_].cleanUp();
         }
         this.initialised = false;
      }
      
      public function getAllApparel() : void
      {
         var request:URLRequest = null;
         var loader:URLLoader = null;
         if(!this.initialised)
         {
            this.initialised = true;
            request = new URLRequest();
            request.url = URLhandler.servicesLocation + "weevil/get-my-apparel?rndVar=" + Math.random();
            loader = new URLLoader();
            loader.addEventListener(Event.COMPLETE,this.apparelDataReceived);
            try
            {
               loader.load(request);
            }
            catch(error:Error)
            {
            }
         }
         else
         {
            this.loadManager();
         }
      }
      
      private function apparelDataReceived(param1:Event) : void
      {
         var _loc4_:XML = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:* = false;
         var _loc2_:XML = new XML(param1.target.data);
         var _loc3_:XMLList = _loc2_.child("item");
         this.apparel = new Array();
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         this.apparelHolders[0] = this.apparelContent_mc.holders1;
         for each(_loc4_ in _loc3_)
         {
            if(_loc5_ >= 12)
            {
               _loc5_ = 0;
               _loc6_++;
               if(this.apparelHolders[_loc6_] == null)
               {
                  this.apparelHolders[_loc6_] = new apparelHolderSet();
                  this.apparelContent_mc.addChild(this.apparelHolders[_loc6_]);
               }
            }
            _loc7_ = int(_loc4_.attribute("id"));
            _loc8_ = int(_loc4_.attribute("cat"));
            _loc9_ = _loc4_.attribute("rgb");
            _loc10_ = _loc4_.attribute("worn") == "1";
            this.apparel[_loc6_ * 12 + _loc5_] = new ApparelSwitch(this,this.apparelHolders[_loc6_]["a" + _loc5_],_loc7_,_loc8_,_loc9_,_loc10_);
            _loc5_++;
         }
         this.numItems = _loc6_ * 12 + _loc5_;
         this.crntItem = 0;
         this.numSets = _loc6_ + 1;
         this.crntSetNum = 0;
         this.showCrntSet();
         this.loadManager();
      }
      
      private function showCrntSet() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.apparelHolders)
         {
            this.apparelHolders[_loc1_].visible = false;
         }
         if(this.numItems > 0)
         {
            this.apparelHolders[this.crntSetNum].visible = true;
            this.apparelContent_mc.noHats_txt.visible = false;
         }
         else
         {
            this.apparelContent_mc.noHats_txt.visible = true;
         }
      }
      
      private function incrSetNum(param1:MouseEvent) : void
      {
         if(this.crntSetNum < this.numSets - 1)
         {
            ++this.crntSetNum;
            this.showCrntSet();
         }
      }
      
      private function decrSetNum(param1:MouseEvent) : void
      {
         if(this.crntSetNum > 0)
         {
            --this.crntSetNum;
            this.showCrntSet();
         }
      }
      
      public function loadManager() : void
      {
         if(this.crntItem < this.numItems)
         {
            this.apparel[this.crntItem].loadThumb();
            ++this.crntItem;
         }
      }
      
      public function apparelClicked(param1:ApparelSwitch) : void
      {
         var _loc2_:ApparelSwitch = null;
         if(!param1.beingWorn)
         {
            Bin.get_instance().addApparel(param1.id,param1.rgb);
            for each(_loc2_ in this.apparel)
            {
               _loc2_.beingWorn = false;
            }
            param1.beingWorn = true;
         }
         else
         {
            Bin.get_instance().removeApparel(param1.cat);
            param1.beingWorn = false;
         }
      }
   }
}

