package com.binweevils
{
   import com.binweevils.DBaccess.PHP2call;
   import com.binweevils.utilities.GoogleAnalytics;
   import com.binweevils.utilities.URLhandler;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.StatusEvent;
   import flash.events.TimerEvent;
   import flash.net.LocalConnection;
   import flash.net.SharedObject;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.Timer;
   import it.gotoandplay.smartfoxserver.SFSEvent;
   import it.gotoandplay.smartfoxserver.SmartFoxClient;
   
   public class LoginToBin extends MovieClip implements IBinZoneListener
   {
      
      private static var SCROLL_OFFSET:* = -360;
      
      public var UI_mc:MovieClip;
      
      public var bigGameHolder_spr:MovieClip;
      
      public var draggableHolder_spr:MovieClip;
      
      public var externalUIHolder_spr:MovieClip;
      
      public var inventoryHolder_spr:MovieClip;
      
      public var loginToBin_mc:MovieClip;
      
      public var newUsersTutorialHolder_spr:MovieClip;
      
      public var overlayUIHolder_spr:MovieClip;
      
      public var questExtUiHelpHolder_spr:MovieClip;
      
      public var questHelpHolder_spr:MovieClip;
      
      private var defaultLocID:int;
      
      private var zones:Array;
      
      private var barredSo:SharedObject;
      
      private var origServerInfoYPos:Number;
      
      private var origServerInfoXPos:Number;
      
      private var origServersHolderY:Number;
      
      private var buddyListCount_arr:Array;
      
      private var serverListLoader:URLLoader;
      
      private var serverInfoTimer:Timer;
      
      private var bg_spr:Sprite;
      
      private var showLoader:Function;
      
      private var hideLoader:Function;
      
      private var bin:Bin;
      
      private var ss:SSclient;
      
      private var userName:String;
      
      private var userIDX:int;
      
      private var tycoon:Boolean;
      
      private var tycoonTV:Boolean;
      
      private var loginKey:String;
      
      private var zone:String;
      
      private var userNoWeevil:Boolean;
      
      private var i:int;
      
      private var msgSplat_mc:*;
      
      private var serverSelection_mc:MovieClip;
      
      private var engagementMeter:EngagementMeter;
      
      private var numbServersPerPage:int = 4;
      
      private var serversPage:int;
      
      private var retryLoginTimer:Timer;
      
      private var retryAttempts:int;
      
      public function LoginToBin()
      {
         super();
         this.retryLoginTimer = new Timer(2000,1);
         this.retryLoginTimer.addEventListener(TimerEvent.TIMER,this.retryLogin);
         this.retryAttempts = 0;
         this.msgSplat_mc = this.loginToBin_mc.msgSplat_mc;
         this.serverSelection_mc = this.loginToBin_mc.serverSelection_mc;
         this.serverSelection_mc.visible = false;
         this.serverInfoTimer = new Timer(60000);
         this.serverSelection_mc.content.addEventListener(Event.ADDED,this.onServerAdded,false,0,true);
         this.origServersHolderY = this.serverSelection_mc.content.y;
         this.serverSelection_mc.content.server_0.visible = false;
         this.origServerInfoYPos = this.serverSelection_mc.content.server_0.y;
         this.origServerInfoXPos = this.serverSelection_mc.content.server_0.x;
         this.barredSo = SharedObject.getLocal("bw-li=sasdasd9283412o3ni423li4jn12l3kn4");
      }
      
      internal function retryLogin(param1:TimerEvent) : *
      {
         if(this.retryAttempts < 2)
         {
            ++this.retryAttempts;
            this.getLoginDetails();
         }
         else
         {
            this.bin.showDialogueBox("Unable to connect to server (ERROR 1)\nPlease contact support and send the error number above.",this.tryAgain);
         }
      }
      
      public function init(param1:Sprite, param2:Sprite, param3:Function, param4:Function, param5:int) : void
      {
         this.defaultLocID = param5;
         this.showLoader = param3;
         this.hideLoader = param4;
         this.showMsg(0);
         this.ss = new SSclient();
         this.bin = new Bin(this,param1,param2,this.ss);
         this.ss.addEventListener(SFSEvent.onExtensionResponse,this.onExtensionResponse);
         this.ss.addEventListener(SFSEvent.onRoomListUpdate,this.onRoomListUpdate);
         this.ss.addEventListener(SFSEvent.onLogin,this.onSFSLogin);
         this.ss.addEventListener(SFSEvent.onConnectionLost,this.onSFSConnectionLost);
         param2.addChild(this);
         this.getLoginDetails();
         this.engagementMeter = new EngagementMeter(stage,this.ss);
      }
      
      private function onSFSLogin(param1:SFSEvent) : void
      {
         var _loc2_:* = param1.params.dataObj;
         if(_loc2_.logged != "true")
         {
            if(_loc2_.guest == "true")
            {
               this.bin.showDialogueBox("Unable to connect to server (ERROR 5)\nPlease contact support and send the error number above.",this.tryAgain);
            }
            else
            {
               this.bin.showDialogueBox("Unable to connect to server (ERROR 3)\nPlease contact support and send the error number above.",this.tryAgain);
            }
         }
      }
      
      private function onSFSConnectionLost(param1:SFSEvent) : void
      {
         this.bin.showDialogueBox("Unable to connect to server (ERROR 2)\nPlease contact support and send the error number above.",this.tryAgain);
      }
      
      private function getLoginDetails() : void
      {
         var _loc1_:PHP2call = new PHP2call("weevil/get-login-details");
         _loc1_.sendAndAwaitResponse([],[],this.onLoginDetailsReceived);
      }
      
      private function onLoginDetailsReceived(param1:Object) : void
      {
         var _loc2_:LocalConnection = null;
         this.userName = param1.userName;
         this.userIDX = param1.userIDX;
         this.tycoon = param1.tycoon == 1;
         this.tycoonTV = param1.tycoonTV == 1;
         this.loginKey = param1.loginKey;
         if(this.userName != "0" && this.loginKey != "0")
         {
            _loc2_ = new LocalConnection();
            _loc2_.addEventListener(StatusEvent.STATUS,this.statusHandler);
            _loc2_.send("userConn","setUserDetails",this.userName,VersionHandler.cluster);
            this.getZones();
         }
         else
         {
            this.retryLoginTimer.start();
         }
      }
      
      internal function statusHandler(param1:StatusEvent) : void
      {
         switch(param1.level)
         {
            case "status":
            case "error":
         }
      }
      
      public function onWeevilLoginServiceConnectionFailed(param1:Object) : *
      {
      }
      
      public function onGetLoginDetailsFailed(param1:Object) : *
      {
      }
      
      private function storeKeyToLocalObject(param1:String) : *
      {
         this.barredSo.data.ky = param1;
      }
      
      public function onGetUserBuddyCount(param1:Object) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 != null)
         {
            this.buddyListCount_arr = param1.split(",");
            _loc2_ = 0;
            while(_loc2_ < this.zones.length)
            {
               this.zones[_loc2_].asset.buddyCount_txt.text = this.buddyListCount_arr[_loc2_];
               _loc2_++;
            }
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < this.zones.length)
            {
               this.zones[_loc2_].asset.buddyCount_txt.text = "0";
               _loc2_++;
            }
         }
      }
      
      public function onGetUserBuddyCountFailed(param1:Object) : *
      {
      }
      
      private function getZones() : *
      {
         var _loc1_:PHP2call = new PHP2call("smartfox/getActiveZones");
         _loc1_.awaitResponse(this.onGotZones);
      }
      
      private function onGotZones(param1:Object) : void
      {
         var _loc7_:Zone = null;
         var _loc8_:Zone = null;
         var _loc11_:MovieClip = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Zone = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.serverSelection_mc.visible = true;
         this.zones = new Array();
         var _loc4_:Array = param1.names.split(",");
         var _loc5_:Array = param1.ips.split(",");
         var _loc6_:Array = param1.oo5.split(",");
         var _loc9_:int = -1;
         var _loc10_:int = 0;
         while(_loc10_ < _loc4_.length)
         {
            _loc11_ = new BinZone();
            _loc12_ = this.origServerInfoXPos + _loc2_ * 337;
            _loc13_ = this.origServerInfoYPos + _loc3_ * (_loc11_.height + 15);
            _loc14_ = new Zone(_loc4_[_loc10_],_loc4_[_loc10_],_loc5_[_loc10_],_loc6_[_loc10_],this,_loc11_,_loc12_,_loc13_);
            if(URLhandler.autoZoneName == _loc4_[_loc10_])
            {
               _loc8_ == _loc14_;
            }
            this.zones.push(_loc14_);
            if(_loc6_[_loc10_] != 6 && _loc6_[_loc10_] > _loc9_)
            {
               _loc7_ = _loc14_;
               _loc9_ = int(_loc6_[_loc10_]);
            }
            _loc2_++;
            if(_loc2_ >= 2)
            {
               _loc2_ = 0;
               _loc3_++;
            }
            if(_loc3_ >= 2)
            {
               _loc2_ = 0;
               _loc3_ = 0;
            }
            _loc10_++;
         }
         if(this.zones.length > 4)
         {
            this.serverSelection_mc.more_bt.visible = true;
            this.serverSelection_mc.more_bt.buttonMode = true;
            this.serverSelection_mc.more_bt.addEventListener(MouseEvent.CLICK,this.showMoreServers);
         }
         else
         {
            this.serverSelection_mc.more_bt.visible = false;
         }
         this.showServersInitialPage();
         if(URLhandler.autoBin)
         {
            if(_loc8_ == null)
            {
               _loc8_ = _loc7_;
            }
            if(_loc8_ != null)
            {
               this.onBinMouseClick(_loc8_);
            }
         }
      }
      
      private function showServersInitialPage() : void
      {
         var _loc3_:Zone = null;
         this.serversPage = 1;
         var _loc1_:Array = this.getZonesForPage(this.serversPage);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            this.serverSelection_mc.content.addChild(_loc3_.asset);
            _loc2_++;
         }
      }
      
      private function showMoreServers(param1:MouseEvent) : void
      {
         var _loc6_:Zone = null;
         var _loc7_:MovieClip = null;
         var _loc2_:Array = this.getZonesForPage(this.serversPage);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc6_ = _loc2_[_loc3_];
            _loc6_.fadeOut();
            _loc3_++;
         }
         ++this.serversPage;
         var _loc4_:int = int(this.zones.length / this.numbServersPerPage);
         if(this.zones.length % this.numbServersPerPage != 0)
         {
            _loc4_++;
         }
         if(this.serversPage > _loc4_)
         {
            this.serversPage = 1;
         }
         _loc2_ = this.getZonesForPage(this.serversPage);
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc6_ = _loc2_[_loc5_];
            _loc6_.animateIn();
            _loc7_ = _loc6_.asset;
            this.serverSelection_mc.content.addChild(_loc7_);
            _loc5_++;
         }
      }
      
      private function getZonesForPage(param1:int) : Array
      {
         var _loc6_:Zone = null;
         var _loc2_:int = (param1 - 1) * this.numbServersPerPage;
         var _loc3_:int = param1 * this.numbServersPerPage;
         if(_loc3_ > this.zones.length)
         {
            _loc3_ = int(this.zones.length);
         }
         var _loc4_:Array = new Array();
         var _loc5_:int = _loc2_;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = this.zones[_loc5_];
            _loc4_.push(_loc6_);
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function onServerAdded(param1:Event) : *
      {
      }
      
      public function onBinMouseClick(param1:Zone) : void
      {
         var _loc2_:SmartFoxClient = this.ss.get_sfs();
         _loc2_.ipAddress = param1.ip;
         _loc2_.port = 9339;
         _loc2_.blueBoxIpAddress = param1.ip;
         _loc2_.blueBoxPort = 80;
         _loc2_.smartConnect = true;
         this.zone = param1.name;
         this.loginToBin_mc.visible = false;
         this.showLoader(null,"loading...",false,false);
         this.connect(new Event("connect"));
      }
      
      private function tryAgain(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = new URLRequest("https://www.binweevils.com/logout/");
         navigateToURL(_loc2_,"_self");
      }
      
      private function showMsg(param1:int, param2:String = null) : void
      {
         this.msgSplat_mc.tooManyPlayersMsg_spr.visible = false;
         switch(param1)
         {
            case 10:
               this.msgSplat_mc.tooManyPlayersMsg_spr.visible = true;
               this.msgSplat_mc.visible = true;
               break;
            default:
               this.msgSplat_mc.visible = false;
         }
      }
      
      private function connect(param1:Event) : void
      {
         var onCompleteHandler:Function = null;
         var evt:Event = param1;
         onCompleteHandler = function(param1:Event):*
         {
            GoogleAnalytics.login();
            var _loc2_:MovieClip = MovieClip(param1.target.content);
            ss.setLoginDetails(userName,_loc2_.GetLoginKey(loginKey));
            if(ss.get_sfs().isConnected)
            {
               bin.showDialogueBox("Unable to connect to server (ERROR 4)\nPlease contact support and send the error number above.",tryAgain);
            }
            ss.connect(zone);
         };
         URLhandler.loadFromCDN(new Loader(),"MLP_loader_20_04_16.swf",onCompleteHandler);
      }
      
      private function onExtensionResponse(param1:SFSEvent) : void
      {
         var _loc3_:* = undefined;
         this.loginToBin_mc.visible = true;
         var _loc2_:Object = param1.params.dataObj;
         switch(_loc2_.commandType)
         {
            case "login":
               if(_loc2_.success == "true")
               {
                  this.removeChild(this.loginToBin_mc);
                  this.ss.removeEventListener(MouseEvent.MOUSE_DOWN,this.onExtensionResponse);
                  for(_loc3_ in _loc2_["user"])
                  {
                  }
                  this.bin.setUser(this.userName,this.userIDX,this.tycoon,this.tycoonTV,_loc2_["user"]);
                  this.ss.getRoomList();
               }
               else
               {
                  this.hideLoader();
                  switch(_loc2_.fr)
                  {
                     case "0":
                        this.showMsg(1);
                        break;
                     case "1":
                        this.showMsg(2);
                        break;
                     case "2":
                        this.showMsg(6);
                        break;
                     case "3":
                        this.showMsg(7,_loc2_.kd);
                        break;
                     case "4":
                        this.showMsg(2);
                        break;
                     case "5":
                        this.showMsg(9,_loc2_.kd);
                        break;
                     case "6":
                        this.showMsg(11);
                  }
                  this.serverSelection_mc.visible = false;
               }
         }
      }
      
      private function onRoomListUpdate(param1:SFSEvent) : void
      {
         this.bin.init(this.showLoader,this.hideLoader,this.defaultLocID);
         this.engagementMeter.init();
      }
   }
}

