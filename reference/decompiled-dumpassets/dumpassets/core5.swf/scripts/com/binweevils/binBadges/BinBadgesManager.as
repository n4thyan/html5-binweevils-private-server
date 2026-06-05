package com.binweevils.binBadges
{
   import com.binweevils.BinEvents;
   import com.binweevils.Bin_extInterface;
   import com.binweevils.CustomEvent;
   import com.binweevils.DBaccess.PHP2call;
   import com.binweevils.EventManager;
   import com.binweevils.UImain;
   import com.binweevils.VersionHandler;
   import com.binweevils.utilities.URLhandler;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   
   public class BinBadgesManager
   {
      
      private var containerMC:MovieClip;
      
      private var UI:UImain;
      
      private const SWF_BIN_BADGES_DISPLAY:String = "binBadges/binBadgesDisplay";
      
      private const SWF_BIN_BADGES_ALERTS:String = "binBadges/AchievementAlertsManager";
      
      private var badgeDisplayMC:MovieClip;
      
      private var badgeAlertsMC:MovieClip;
      
      private var achivementsList:Array = new Array();
      
      private var badgesList:Array;
      
      public function BinBadgesManager(param1:UImain, param2:MovieClip)
      {
         super();
         this.containerMC = param2;
         this.UI = param1;
         EventManager.get_instance().addEventListener(BinEvents.NEW_BIN_BADGE_ALERT,this.newBinBadgesHandler);
      }
      
      private function newBinBadgesHandler(param1:CustomEvent) : void
      {
         var _loc2_:Array = param1.dataObj.newBadges.split(",");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            this.badgeAlertsMC.addBinBadgeAlert(_loc2_[_loc3_]);
            _loc3_++;
         }
      }
      
      public function init() : void
      {
         this.loadBadgesAlerts();
      }
      
      public function showBadges(param1:Number, param2:Boolean = false) : void
      {
         var _loc3_:Object = Bin_extInterface.bin;
         var _loc4_:Number = Number(_loc3_.crntLocID);
         var _loc5_:* = this.SWF_BIN_BADGES_DISPLAY;
         if(VersionHandler.binBadgesDisplayVersion > 0)
         {
            _loc5_ += String(VersionHandler.binBadgesDisplayVersion);
         }
         _loc5_ += ".swf";
         _loc3_.loadInterface({
            "path":_loc5_,
            "userIdx":param1,
            "mine":param2,
            "fromLocID":_loc4_,
            "binBadgesList":this.badgesList,
            "achivementsList":this.achivementsList,
            "limbo":false,
            "loadBadgesInfoFunc":this.loadAllBadgesInfo
         });
      }
      
      private function loadBadgesAlerts() : void
      {
         var _loc1_:Loader = new Loader();
         _loc1_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onAlertsLoaderError);
         var _loc2_:* = this.SWF_BIN_BADGES_ALERTS;
         if(VersionHandler.achievementAlertsVersion > 0)
         {
            _loc2_ += String(VersionHandler.achievementAlertsVersion);
         }
         _loc2_ += ".swf";
         URLhandler.loadFromCDN(_loc1_,_loc2_,this.onBadgeAlertsLoaded);
      }
      
      private function onBadgeAlertsLoaded(param1:Event) : void
      {
         var _loc2_:Loader = param1.target.loader;
         this.badgeAlertsMC = MovieClip(_loc2_.content);
         this.badgeAlertsMC.init(this.getAchievementData,this.containerMC);
         this.containerMC.addChild(this.badgeAlertsMC);
         this.loadNewAchievementsAlerts();
      }
      
      private function clickedAlertHandler(param1:MouseEvent) : void
      {
         var _loc2_:Object = Bin_extInterface.bin;
         this.showBadges(_loc2_.myUserIDX,true);
      }
      
      private function onAlertsLoaderError(param1:IOErrorEvent) : void
      {
      }
      
      private function loadNewAchievementsAlerts() : void
      {
         var _loc1_:Object = Bin_extInterface.bin;
         new PHP2call("achievements/getNewAchievements").sendAndAwaitResponse(["idx"],[_loc1_.myUserIDX],this.onNewAchivementsReceived,true);
      }
      
      private function onNewAchivementsReceived(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(param1.responseCode == 999)
         {
            return;
         }
         if(param1.newAchievements != "")
         {
            _loc2_ = param1.newAchievements.split(",");
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               this.badgeAlertsMC.addBinBadgeAlert(_loc2_[_loc3_]);
               _loc3_++;
            }
            this.loadAllBadgesInfo();
         }
      }
      
      public function loadAllBadgesInfo() : void
      {
         new PHP2call("achievements/getAllAchievements").awaitResponse(this.onBadgesInfoReceived,true);
      }
      
      private function onBadgesInfoReceived(param1:Object, param2:Event) : void
      {
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:CustomEvent = null;
         var _loc7_:BinBadgeData = null;
         var _loc8_:Object = null;
         var _loc9_:String = null;
         var _loc10_:Object = null;
         var _loc11_:Number = NaN;
         var _loc12_:AchievementData = null;
         var _loc13_:String = null;
         this.achivementsList = new Array();
         this.badgesList = new Array();
         var _loc3_:Object = param1.achievements;
         for(_loc4_ in _loc3_)
         {
            _loc7_ = new BinBadgeData(Number(_loc4_));
            _loc8_ = _loc3_[_loc4_];
            for(_loc9_ in _loc8_)
            {
               if(_loc9_ == "TAGS")
               {
                  _loc7_.tags = _loc8_[_loc9_].split(",");
               }
               else if(_loc9_ == "typeColour")
               {
                  _loc7_.colour = _loc8_[_loc9_];
               }
               else if(_loc9_ == "typeOrder")
               {
                  _loc7_.order = _loc8_[_loc9_];
               }
               else if(_loc9_ == "typeName")
               {
                  _loc7_.name = _loc8_[_loc9_];
               }
               else if(_loc9_ == "imageName")
               {
                  _loc7_.imageName = _loc8_[_loc9_];
               }
               else if(_loc9_ == "description")
               {
                  _loc7_.description = _loc8_[_loc9_];
               }
               else if(!isNaN(Number(_loc9_)))
               {
                  _loc10_ = _loc8_[_loc9_];
                  _loc11_ = Number(_loc9_);
                  _loc12_ = new AchievementData(_loc11_);
                  this.achivementsList[_loc11_] = _loc12_;
                  for(_loc13_ in _loc10_)
                  {
                     if(_loc13_ == "descriptionForMe")
                     {
                        _loc12_.descriptionForMe = _loc10_[_loc13_];
                     }
                     if(_loc13_ == "descriptionForVisitors")
                     {
                        _loc12_.descriptionForVisitors = _loc10_[_loc13_];
                     }
                     else if(_loc13_ == "name")
                     {
                        _loc12_.name = _loc10_[_loc13_];
                     }
                     else if(_loc13_ == "order")
                     {
                        _loc12_.order = _loc10_[_loc13_];
                     }
                  }
                  _loc12_.badgeObj = _loc7_;
                  _loc7_.achievementsAr.push(_loc12_);
               }
            }
            _loc7_.achievementsAr.sortOn("order",Array.NUMERIC);
            this.badgesList.push(_loc7_);
         }
         this.badgesList.sortOn("order",Array.NUMERIC);
         this.badgeAlertsMC.showAlerts();
         _loc5_ = {
            "badgesList":this.badgesList,
            "achivementsList":this.achivementsList
         };
         _loc6_ = new CustomEvent(BinEvents.BIN_BADGES_ALL_INFO_LOADED,_loc5_);
         EventManager.get_instance().dispatchEvent(_loc6_);
      }
      
      public function getBinBadgesList() : Array
      {
         return this.badgesList;
      }
      
      public function getAchievementsList() : Array
      {
         return this.achivementsList;
      }
      
      public function getAchievementData(param1:Number) : AchievementData
      {
         if(param1 > this.achivementsList.length || this.achivementsList[param1] == null)
         {
            this.loadAllBadgesInfo();
            return null;
         }
         return this.achivementsList[param1];
      }
      
      public function showUserBadges(param1:Number) : void
      {
      }
   }
}

