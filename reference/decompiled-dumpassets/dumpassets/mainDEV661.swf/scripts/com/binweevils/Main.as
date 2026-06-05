package com.binweevils
{
   import com.binweevils.DBaccess.PHP2call;
   import com.binweevils.utilities.GoogleAnalytics;
   import com.binweevils.utilities.URLhandler;
   import com.binweevils.utilities.XMLLoader;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import flash.net.LocalConnection;
   import flash.net.SharedObject;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class Main extends Sprite
   {
      
      public var binPetLoadingAnim_mc:MovieClip;
      
      public var clearCacheMsg_mc:MovieClip;
      
      public var contentHolderL_spr:MovieClip;
      
      public var contentHolderU_spr:MovieClip;
      
      public var loaderBinPet_mc:MovieClip;
      
      public var loader_spr:MovieClip;
      
      public var openInAnotherWinMsg:MovieClip;
      
      private var loadBar_spr:Sprite;
      
      private var loadBarBar_spr:Sprite;
      
      private var waitingBar_mc:MovieClip;
      
      private var loadMsg_txt:TextField;
      
      private var loaderMode:int;
      
      private var loaderContentPath:String;
      
      private var loginPath:String;
      
      private var defaultLocID:int;
      
      private var autoBin:Boolean;
      
      private var l_conn:LocalConnection;
      
      private var loadConfigTimer:Timer;
      
      private var allowMultipleLogins:Boolean;
      
      private var loaderTextAnim:MainTextLoaderAnim;
      
      private var newUser:Boolean = false;
      
      private var adLoader:Loader;
      
      public function Main()
      {
         var _loc2_:XMLLoader = null;
         super();
         var _loc1_:SharedObject = SharedObject.getLocal("BinWeevilsRegistration","/",false);
         if(_loc1_.data.firstLogin != null)
         {
            this.newUser = _loc1_.data.firstLogin;
            _loc1_.clear();
         }
         GalleryData.artists[0] = "0";
         this.clearCacheMsg_mc.visible = false;
         this.clearCacheMsg_mc.clearCacheFAQ_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.gotoClearCacheFAQ);
         this.openInAnotherWinMsg.visible = false;
         VersionHandler.cluster = root.loaderInfo.parameters.cluster;
         this.loginPath = root.loaderInfo.parameters.loginPath;
         URLhandler.autoBin = root.loaderInfo.parameters.autoBin == "true";
         URLhandler.autoZoneName = root.loaderInfo.parameters.zone;
         URLhandler.loginPageURL = "index.php";
         if(this.loginPath == "" || this.loginPath == null)
         {
            this.loginPath = null;
            URLhandler.loginPageURL = "index.php";
         }
         else
         {
            URLhandler.loginPageURL = "https://play.binweevils.com/";
         }
         STAGE = this.stage;
         this.loader_spr.visible = false;
         this.loaderTextAnim = new MainTextLoaderAnim(this.loader_spr.loader_mc);
         this.loadConfigTimer = new Timer(1000,1);
         this.loadConfigTimer.addEventListener("timer",this.loadConfig);
         this.loadConfigTimer.start();
      }
      
      private function createLocalConnectionIsUnique() : Boolean
      {
         this.l_conn = new LocalConnection();
         this.l_conn.client = this;
         try
         {
            this.l_conn.connect("randomConnectObjectThatNoOneElseIsEverGonnaHave13465928");
            return true;
         }
         catch(error:ArgumentError)
         {
         }
         return false;
      }
      
      private function loadConfig(param1:TimerEvent) : void
      {
         var _loc2_:URLRequest = new URLRequest("binConfig/config.xml");
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.addEventListener(Event.COMPLETE,this.configLoaded);
         _loc3_.load(_loc2_);
      }
      
      private function configLoaded(param1:Event) : void
      {
         var _loc2_:XML = new XML(param1.target.data);
         URLhandler.domain = _loc2_.child("domain");
         URLhandler.servicesLocation = _loc2_.child("servicesLocation");
         this.allowMultipleLogins = _loc2_.child("allowMultipleLogins") == "true";
         if(URLhandler.servicesLocation == "http://api.binweevils.com/" && VersionHandler.cluster == "uk")
         {
            URLhandler.servicesLocation = "https://play.bwrewritten.com/";
         }
         else if(URLhandler.servicesLocation == "http://api.binweevils.com/" && VersionHandler.cluster != "uk")
         {
            URLhandler.servicesLocation = "http://api." + VersionHandler.cluster + ".binweevils.com/";
         }
         URLhandler.basePathSmall = _loc2_.child("basePathSmall");
         URLhandler.basePathLarge = _loc2_.child("basePathLarge");
         URLhandler.pathItemConfigs = _loc2_.child("pathItemConfigs");
         URLhandler.pathAssetsNest = _loc2_.child("pathAssetsNest");
         URLhandler.pathAssetsTycoon = _loc2_.child("pathAssetsTycoon");
         this.checkVersion();
         if(_loc2_.child("useBubbleTester") != null)
         {
            if(_loc2_.child("useBubbleTester") == "true")
            {
               URLhandler.useBubbleTester = true;
            }
         }
      }
      
      private function checkVersion() : void
      {
         var request:URLRequest;
         var loader:URLLoader;
         var variables:URLVariables = new URLVariables();
         variables.version = VersionHandler.siteVersion;
         request = new URLRequest();
         request.url = URLhandler.domain + "binConfig/" + VersionHandler.cluster + "/checkVersion.php";
         request.method = URLRequestMethod.POST;
         request.data = variables;
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.VARIABLES;
         loader.addEventListener(Event.COMPLETE,this.onCheckVersionHandler);
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
         }
      }
      
      private function onCheckVersionHandler(param1:Event) : void
      {
         var _loc2_:String = param1.target.data.vOK;
         VersionHandler.coreVersion = param1.target.data.core;
         VersionHandler.VODplayerVersion = param1.target.data.VODplayer;
         VersionHandler.VODcontentVersion = param1.target.data.VODcontent;
         VersionHandler.locDefVersion = param1.target.data.locDef;
         VersionHandler.URLPathVersion = param1.target.data.URLDef;
         VersionHandler.nestDefVersion = param1.target.data.nestDef;
         VersionHandler.binBadgesDisplayVersion = param1.target.data.binBadgesDisplay;
         VersionHandler.achievementAlertsVersion = param1.target.data.achievementAlerts;
         VersionHandler.newsVersion = param1.target.data.news;
         if(_loc2_ == "1")
         {
            if(this.loginPath == null)
            {
               this.defaultLocID = 5;
               this.getLoaderAdPath();
            }
            else
            {
               this.getDefaultLocID();
            }
         }
         else
         {
            this.clearCacheMsg_mc.visible = true;
         }
         URLhandler.loadURLPaths();
      }
      
      private function gotoClearCacheFAQ(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = new URLRequest("http://blog.binweevils.com/tech-support/");
         navigateToURL(_loc2_,"_self");
      }
      
      private function getDefaultLocID() : void
      {
         var request:URLRequest;
         var loader:URLLoader;
         var variables:URLVariables = new URLVariables();
         variables.loginPath = this.loginPath;
         request = new URLRequest();
         request.url = URLhandler.domain + "php/getDefaultLocID.php";
         request.method = URLRequestMethod.POST;
         request.data = variables;
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.VARIABLES;
         loader.addEventListener(Event.COMPLETE,this.defaultLocIDReceived);
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
         }
      }
      
      private function defaultLocIDReceived(param1:Event) : void
      {
         this.defaultLocID = int(param1.target.data.locID);
         this.getLoaderAdPath();
      }
      
      private function getLoaderAdPath() : void
      {
         var _loc1_:Loader = null;
         var _loc2_:int = 0;
         if(this.newUser)
         {
            this.loaderContentPath = "loaderContent/Campaigns/BinWeevils/LoaderPage_newPlayer2.swf";
            _loc1_ = new Loader();
            this.adLoader = _loc1_;
            this.adLoader.addEventListener(IOErrorEvent.IO_ERROR,this.adLoaderErrorHandler);
            URLhandler.loadFromCDN(_loc1_,this.loaderContentPath,this.loaderContentLoaded,false);
         }
         else
         {
            _loc2_ = AdLocations.LOADER_PAGE;
            new PHP2call("ads/getAdPaths").sendAndAwaitResponse(["area"],[_loc2_],this.loaderAdPathReceived);
         }
      }
      
      private function loaderAdPathReceived(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1.responseCode == "1")
         {
            _loc2_ = param1.adPath;
            if(_loc2_ != "0")
            {
               this.loaderContentPath = "loaderContent/Campaigns/" + _loc2_;
               this.adLoader = new Loader();
               this.adLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.adLoaderErrorHandler);
               this.adLoader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR,this.adLoaderErrorHandler);
               URLhandler.loadFromCDN(this.adLoader,this.loaderContentPath,this.loaderContentLoaded,false);
            }
            else
            {
               this.loadCore();
            }
         }
         else
         {
            this.loadCore();
         }
      }
      
      private function adLoaderErrorHandler(param1:IOErrorEvent) : void
      {
         GoogleAnalytics.trackUser("/loader/loaderContent/LoaderPageFailed");
         this.adLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.adLoaderErrorHandler);
         this.adLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.adLoaderErrorHandler);
         this.loadCore();
      }
      
      private function loaderContentLoaded(param1:Event) : void
      {
         this.adLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.adLoaderErrorHandler);
         this.adLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.adLoaderErrorHandler);
         var _loc2_:MovieClip = param1.target.content;
         this.loader_spr.bg_spr.loaderContentHolder_spr.addChild(_loc2_);
         this.loadCore();
      }
      
      private function loadCore() : void
      {
         var _loc1_:String = "";
         if(VersionHandler.coreVersion > 0)
         {
            _loc1_ = String(VersionHandler.coreVersion);
         }
         var _loc2_:Loader = new Loader();
         URLhandler.loadFromCDN(_loc2_,"core" + _loc1_ + ".swf",this.coreLoaded,true);
      }
      
      private function coreLoaded(param1:Event) : void
      {
         var _loc2_:MovieClip = null;
         if(this.allowMultipleLogins || this.createLocalConnectionIsUnique())
         {
            _loc2_ = param1.target.content;
            _loc2_.init(this.contentHolderU_spr,this.contentHolderL_spr,this.showLoader,this.hideLoader,this.defaultLocID);
            this.binPetLoadingAnim_mc.visible = false;
            removeChild(this.binPetLoadingAnim_mc);
         }
         else
         {
            this.openInAnotherWinMsg.visible = true;
         }
      }
      
      public function showLoader(param1:Loader, param2:String, param3:Boolean = false, param4:Boolean = true, param5:DisplayObject = null) : void
      {
         this.loadBar_spr = this.loaderBinPet_mc.loadIndicators_mc.loadBar_spr;
         this.loadBarBar_spr = this.loaderBinPet_mc.loadIndicators_mc.loadBar_spr.loadBarBar_spr;
         this.waitingBar_mc = this.loaderBinPet_mc.loadIndicators_mc.waitingBar_mc;
         this.loadMsg_txt = this.loaderBinPet_mc.loadIndicators_mc.loadMsg_txt;
         if(param5 == null || param3)
         {
            this.closeBinPetLoaderIfOpen();
            if(param3)
            {
               this.loader_spr.bg_spr.visible = false;
            }
            else
            {
               this.loader_spr.bg_spr.visible = true;
               if(this.loaderMode != 1)
               {
                  GoogleAnalytics.trackUser("loader/" + this.loaderContentPath);
               }
            }
            this.loaderMode = 1;
            this.loader_spr.visible = true;
         }
         else
         {
            this.loader_spr.visible = false;
            this.loaderMode = 2;
            if(this.loaderBinPet_mc.currentFrame == 1 || this.loaderBinPet_mc.currentFrame > 10)
            {
               this.loaderBinPet_mc.snapshotHolder_spr.addChild(param5);
               if(param4)
               {
                  this.loaderBinPet_mc.gotoAndPlay(2);
               }
               else
               {
                  this.loaderBinPet_mc.gotoAndStop("waiting");
               }
            }
         }
         this.loadMsg_txt.text = param2;
         if(param4)
         {
            this.waitingBar_mc.visible = false;
            this.waitingBar_mc.stop();
            this.loadBarBar_spr.scaleX = 0.05;
            this.loadBar_spr.visible = true;
            param1.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.showLoadProgress);
         }
         else
         {
            this.loadBar_spr.visible = false;
            this.waitingBar_mc.visible = true;
            this.waitingBar_mc.play();
         }
      }
      
      private function showLoadProgress(param1:ProgressEvent) : void
      {
         var _loc2_:Number = param1.bytesLoaded / param1.bytesTotal;
         this.loadBarBar_spr.scaleX = _loc2_;
      }
      
      public function hideLoader(param1:int = 0) : void
      {
         if(param1 != 0)
         {
            this.loaderMode = param1;
         }
         switch(this.loaderMode)
         {
            case 1:
               this.loader_spr.visible = false;
               this.closeBinPetLoaderIfOpen();
               this.waitingBar_mc.stop();
               break;
            case 2:
               this.loaderBinPet_mc.gotoAndPlay("close");
               this.waitingBar_mc.stop();
         }
      }
      
      private function closeBinPetLoaderIfOpen() : void
      {
         if(this.loaderBinPet_mc.currentFrame > 1 && this.loaderBinPet_mc.currentFrame < 11)
         {
            this.loaderBinPet_mc.gotoAndPlay("close");
         }
      }
   }
}

