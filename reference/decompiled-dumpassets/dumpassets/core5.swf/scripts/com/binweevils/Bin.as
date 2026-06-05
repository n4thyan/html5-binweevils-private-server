package com.binweevils
{
   import com.binweevils.DBaccess.PHP2call;
   import com.binweevils.DBaccess.PHPcall;
   import com.binweevils.conf.CampaignConfig;
   import com.binweevils.conf.MessageProtocol;
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.Matrix3x3;
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.ViewPort;
   import com.binweevils.engine3D.visuals.Door;
   import com.binweevils.engine3D.visuals.GameSlot;
   import com.binweevils.engine3D.visuals.Loc;
   import com.binweevils.engine3D.visuals.LocFactory;
   import com.binweevils.engine3D.visuals.LocNest;
   import com.binweevils.engine3D.visuals.Spinner;
   import com.binweevils.engine3D.visuals.Teleporter;
   import com.binweevils.engine3D.visuals.creatures.NPC;
   import com.binweevils.engine3D.visuals.creatures.pets.IPet;
   import com.binweevils.engine3D.visuals.creatures.pets.Pet;
   import com.binweevils.engine3D.visuals.creatures.pets.PetFactory;
   import com.binweevils.engine3D.visuals.creatures.pets.PetSkillNames;
   import com.binweevils.engine3D.visuals.creatures.pets.behaviours.PetBehaviours;
   import com.binweevils.engine3D.visuals.creatures.weevils.Weevil;
   import com.binweevils.engine3D.visuals.creatures.weevils.WeevilFactory;
   import com.binweevils.externalUIs.DraggableUI;
   import com.binweevils.externalUIs.ExtUI;
   import com.binweevils.externalUIs.adCampaigns.common.AdVars;
   import com.binweevils.multiplayerGames.BigGameSlot;
   import com.binweevils.newUserTutorial.NewUserProgressManager;
   import com.binweevils.overlayUIs.OverlayUI;
   import com.binweevils.overlayUIs.OverlayUIdynamic;
   import com.binweevils.rssmv.Rssmv;
   import com.binweevils.utilities.DateTime;
   import com.binweevils.utilities.GoogleAnalytics;
   import com.binweevils.utilities.ScaledWeevilsList;
   import com.binweevils.utilities.SessionStarter;
   import com.binweevils.utilities.URLhandler;
   import com.binweevils.utilities.Utils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.InteractiveObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.NetConnection;
   import flash.net.SharedObject;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import it.gotoandplay.smartfoxserver.SFSEvent;
   import it.gotoandplay.smartfoxserver.SmartFoxClient;
   
   public class Bin implements WeevilClient
   {
      
      public static var viewPort:ViewPort;
      
      private static var _controlsEnabled:Boolean;
      
      private static var _instance:Bin;
      
      private const usedClasses:Array = [CampaignConfig,AdVars];
      
      private var initialised:Boolean;
      
      private var fullyInitialised:Boolean;
      
      private var petVarsInitialised:Boolean;
      
      private var _showLoader:*;
      
      private var _hideLoader:Function;
      
      private var screenSnapshot:Bitmap;
      
      public var cam:Cam3D;
      
      private var camMode:uint;
      
      private var revertCamMode:uint;
      
      private var locDefs:Array;
      
      private var locs:Array;
      
      public var crntLocID:int;
      
      private var crntLocName:String;
      
      public var crntLoc:Loc;
      
      private var crntTimerID:int;
      
      private var nestLocDefs_XML:XML;
      
      private var locFactory:LocFactory;
      
      public var petFactory:PetFactory;
      
      private var pets:Array;
      
      private var myPets:Array;
      
      private var myPetIDs:String;
      
      public var weevilFactory:WeevilFactory;
      
      public var creatureAssets:MovieClip;
      
      private var weevils:Array;
      
      private var _myWeevil:Weevil;
      
      private var _myUserObj:Object;
      
      private var _myUserID:int;
      
      private var _myUserName:String;
      
      private var _myUserIDX:int;
      
      private var _tycoon:Boolean;
      
      private var _tycoonTV:Boolean;
      
      private var _myNestRoomID:int;
      
      private var weevilSpeed:Number;
      
      private var specialMoveParamStr:String;
      
      private var hostWeevilName:*;
      
      private var prevHostWeevilName:String;
      
      private var renderTimer:Timer;
      
      private var tPrev:int;
      
      private var dtPrev:Number;
      
      public var dtFixed:Boolean;
      
      private var vx:Number;
      
      private var vy:Number;
      
      private var vz:Number;
      
      private var wv:int;
      
      private var aimX:Number;
      
      private var aimY:Number;
      
      private var aimZ:Number;
      
      private var aimYincr:int;
      
      private var xDest:*;
      
      private var zDest:Number;
      
      private var _UI:UImain;
      
      private var extUI_mc:MovieClip;
      
      private var draggableHolder_spr:Sprite;
      
      private var dragMouseArea:Sprite;
      
      private var _dragEnabled:Boolean;
      
      private var overlayUIHolder_spr:Sprite;
      
      private var externalUIHolder_spr:Sprite;
      
      private var bigGameHolder_spr:Sprite;
      
      private var bigGameLoader_mc:MovieClip;
      
      private var ssclient:SSclient;
      
      private var _nest:Nest;
      
      private var myNestName:String;
      
      public var inNest:Boolean;
      
      private var _otherUserNest:Nest;
      
      private var _inOtherUserNest:Boolean;
      
      public var browsingMap:Boolean;
      
      public var broadcastMoves:Boolean;
      
      private var player:int;
      
      private var floorClickArea:InteractiveObject;
      
      private var interfaceLoader:Loader;
      
      private var loadedInterfaces:Array;
      
      private var extUIDataObj:Object;
      
      private var crntGameSlot:GameSlot;
      
      private var crntBigGameSlot:BigGameSlot;
      
      private var imOnStage:Boolean;
      
      public var _UIresetMode:int;
      
      public const WEEVILWHEELS_LOCID:int = 800;
      
      private var _hardestUnlockedTrack:int = 1;
      
      private var logoutTimer:Timer;
      
      private var partyTimer:Timer;
      
      private var petProfileTimer:Timer;
      
      private var userUpdateTimer:Timer;
      
      private var checkTycoonAccountTimer:Timer;
      
      private var displayMoneyInAccountMsg:Boolean;
      
      public var latestNews:String;
      
      private var defaultLocID:int;
      
      private var defaultDoorID:int;
      
      private var newUser:Boolean;
      
      private var filterClientCallbackFn:Function;
      
      private var filterTxt:String;
      
      private var filterTxtHash:String;
      
      private var buddyMsgRecipientIDX:int;
      
      public var roomListClient:String;
      
      private var hostTycoonToVisit:String;
      
      private var hostTycoonToVisitIDX:*;
      
      private var hostTycoonIDX:int;
      
      public var tycoonCustomerManager:TycoonCustomerManager;
      
      private var NPCmanager:NPC_manager;
      
      private var eventManager:EventManager;
      
      private var AMFPHPNetConnection:NetConnection;
      
      public var weevilStatManager:WeevilStatManager;
      
      private var seenStartUpTips:Boolean;
      
      private var _accountActivated:Boolean;
      
      private var _daysRemaining:int;
      
      public var showRegMsg:Boolean;
      
      private var barredSo:SharedObject;
      
      private var _displayActivation:Boolean = false;
      
      private var _hasEmail:Boolean = false;
      
      public var bigWeevilsList:ScaledWeevilsList;
      
      public var smallWeevilsList:ScaledWeevilsList;
      
      public var hasPetInHotel:Boolean = false;
      
      public var hasUsedPetForADay:Boolean = false;
      
      public var WWTrackTestingEnabled:Boolean;
      
      public var weevilWheelsGame:MovieClip;
      
      private var newUserProgressManager:NewUserProgressManager;
      
      public var onLoginServerUnixTime:Number;
      
      public var challengesManager:Object;
      
      public var funFairManager:Object;
      
      public var superAntennaHuntManager:Object;
      
      public var swrveManager:SwrveManager;
      
      private var _locale:String;
      
      private var getWeevilData2CallBackFunc:Function;
      
      private var weevilDataCache:Object = new Object();
      
      private var weevilDataCacheDate:Date = new Date();
      
      private var weevilDataCacheName:String = "";
      
      private var getWeevilDataCallBack:Function;
      
      public var webSocket:WebSocketConnection;
      
      private var itemsInRoom:Array = new Array();
      
      public function Bin(param1:MovieClip, param2:Sprite, param3:Sprite, param4:SSclient)
      {
         super();
         _instance = this;
         Bin_extInterface.bin = this;
         this.webSocket = new WebSocketConnection();
         this.eventManager = EventManager.get_instance();
         this.swrveManager = SwrveManager.get_instance();
         this.ssclient = param4;
         this.ssclient.addEventListener(SFSEvent.onPublicMessage,this.publicMsgReceived);
         this.ssclient.addEventListener(SFSEvent.onModeratorMessage,this.modMsgReceived);
         this.ssclient.addEventListener(SFSEvent.onRoomListUpdate,this.onRoomListUpdate);
         this.ssclient.addEventListener(SFSEvent.onJoinRoom,this.onJoinRoom);
         this.ssclient.addEventListener(SFSEvent.onUserEnterRoom,this.onUserEnterRoom);
         this.ssclient.addEventListener(SFSEvent.onUserLeaveRoom,this.onUserLeaveRoom);
         this.ssclient.addEventListener(SFSEvent.onExtensionResponse,this.onExtensionResponse);
         this.ssclient.addEventListener(SFSEvent.onConnectionLost,this.logout);
         this.cam = new Cam3D(-138,230,248);
         this.cam.aim_triplet(157,32,582);
         viewPort = new ViewPort();
         param3.addChildAt(viewPort.display_spr,0);
         this.draggableHolder_spr = param1.draggableHolder_spr;
         this.draggableHolder_spr.x = 130;
         this.draggableHolder_spr.y = 70;
         this.overlayUIHolder_spr = param1.overlayUIHolder_spr;
         this.externalUIHolder_spr = param1.externalUIHolder_spr;
         this.bigGameHolder_spr = param1.bigGameHolder_spr;
         this.locFactory = new LocFactory();
         this.weevilFactory = WeevilFactory.getInstance();
         this.petFactory = PetFactory.getInstance();
         this.weevils = new Array();
         this.pets = new Array();
         this.myPets = new Array();
         this.locs = new Array();
         this.loadedInterfaces = new Array();
         this.logoutTimer = new Timer(2100000,1);
         this.logoutTimer.addEventListener("timer",this.logout);
         this.userUpdateTimer = new Timer(180000 + int(360000 * Math.random()),1);
         this.userUpdateTimer.addEventListener("timer",this.triggerUserUpdate);
         this.partyTimer = new Timer(60000,0);
         this.partyTimer.addEventListener("timer",this.partyTimerListener);
         this.petProfileTimer = new Timer(750,1);
         this.dtPrev = 1;
         this.renderTimer = new Timer(20,0);
         this.renderTimer.addEventListener("timer",this.render);
         this._UI = new UImain(param1.UI_mc,param2,param3,param1.inventoryHolder_spr,param1.questHelpHolder_spr,param1.questExtUiHelpHolder_spr);
         this._UI.setupCamUI(this.cam);
         this._UI.disableChat();
         param2.addChild(param1.newUsersTutorialHolder_spr);
         param2.addChild(this.overlayUIHolder_spr);
         param2.addChild(param1.UI_mc.alertBox_mc);
         param2.addChild(param1.UI_mc.dialogueBox_mc);
         param2.addChild(param1.UI_mc.hint_mc);
         this.tycoonCustomerManager = new TycoonCustomerManager();
         this.newUserProgressManager = new NewUserProgressManager(param1.newUsersTutorialHolder_spr);
      }
      
      public static function get_instance() : Bin
      {
         return _instance;
      }
      
      public static function get controlsEnabled() : Boolean
      {
         return _controlsEnabled;
      }
      
      public function getViewPort() : ViewPort
      {
         return viewPort;
      }
      
      public function getAMFPHPNetConnection() : NetConnection
      {
         if(this.AMFPHPNetConnection == null)
         {
            this.AMFPHPNetConnection = new NetConnection();
            this.AMFPHPNetConnection.connect(URLhandler.servicesLocation + "php/amfphp/Gateway.php");
         }
         return this.AMFPHPNetConnection;
      }
      
      private function triggerUserUpdate(param1:TimerEvent) : void
      {
         var _loc2_:PHPcall = new PHPcall("weevil/update-user-info",true);
         _loc2_.fireAndForget(["idx"],[this.myUserIDX]);
      }
      
      public function get hardestUnlockedTrack() : int
      {
         return this._hardestUnlockedTrack;
      }
      
      public function set hardestUnlockedTrack(param1:int) : void
      {
         this._hardestUnlockedTrack = param1;
      }
      
      public function showLoader(param1:Loader, param2:String, param3:Boolean = false, param4:Boolean = true) : void
      {
         this._showLoader(param1,param2,param3,param4,this.screenSnapshot);
      }
      
      public function hideLoader(param1:int = 0) : void
      {
         this._hideLoader(param1);
      }
      
      public function showHint(param1:String, param2:Number, param3:Number) : void
      {
         this._UI.showHint(param1,param2,param3);
      }
      
      public function hideHint(param1:MouseEvent = null) : void
      {
         this._UI.hideHint();
      }
      
      public function showAlertBox(param1:String, param2:Boolean = false) : void
      {
         this.UI.showAlertBox(param1,param2);
      }
      
      public function hideAlertBox() : void
      {
         this.UI.hideAlertBox();
      }
      
      public function showDialogueBox(param1:String, param2:Function) : void
      {
         this.UI.showDialogueBox(param1,param2);
      }
      
      public function hideDialogueBox() : void
      {
         this.UI.hideDialogueBox();
      }
      
      public function dialogueBoxBusy() : void
      {
         this.UI.dialogueBoxBusy();
      }
      
      public function getWeevils() : Array
      {
         return this.weevils;
      }
      
      public function getPets() : Array
      {
         return this.pets;
      }
      
      public function showCamUILoader(param1:Loader, param2:String, param3:int) : void
      {
         if(param3 == this.crntLocID)
         {
            this.UI.showLoader(param1,param2);
         }
      }
      
      public function get UI() : UImain
      {
         return this._UI;
      }
      
      public function get nest() : Nest
      {
         return this._nest;
      }
      
      public function get otherUserNest() : Nest
      {
         return this._otherUserNest;
      }
      
      public function get accountActivated() : Boolean
      {
         return this._accountActivated;
      }
      
      public function get daysRemaining() : int
      {
         return this._daysRemaining;
      }
      
      public function get hasEmail() : Boolean
      {
         return this._hasEmail;
      }
      
      public function get displayActivation() : Boolean
      {
         return this._displayActivation;
      }
      
      public function get myWeevil() : Weevil
      {
         return this._myWeevil;
      }
      
      public function get myUserName() : String
      {
         return this._myUserName;
      }
      
      public function get myUserIDX() : int
      {
         return this._myUserIDX;
      }
      
      public function get tycoon() : Boolean
      {
         return this._tycoon;
      }
      
      public function get tycoonTV() : Boolean
      {
         return this._tycoonTV;
      }
      
      public function get myUserID() : int
      {
         return this._myUserID;
      }
      
      public function get myUserObj() : Object
      {
         return this._myUserObj;
      }
      
      public function get UIresetMode() : int
      {
         return this._UIresetMode;
      }
      
      public function get_sfs() : SmartFoxClient
      {
         return this.ssclient.get_sfs();
      }
      
      public function get_ssclient() : SSclient
      {
         return this.ssclient;
      }
      
      public function setWeevilStatManager(param1:WeevilStatManager) : void
      {
         this.weevilStatManager = param1;
      }
      
      public function get myLevel() : int
      {
         return this.weevilStatManager.level;
      }
      
      public function get myMulch() : int
      {
         return this.weevilStatManager.mulch;
      }
      
      public function get myDosh() : int
      {
         return this.weevilStatManager.dosh;
      }
      
      public function updateMulch(param1:int) : void
      {
         this.weevilStatManager.updateMulch(param1);
         this.swrveManager.api.user({"mulch":param1});
      }
      
      public function updateDosh(param1:int) : void
      {
         this.weevilStatManager.updateDosh(param1);
         this.swrveManager.api.user({"dosh":param1});
      }
      
      public function get myXp() : int
      {
         return this.weevilStatManager.getXp();
      }
      
      public function updateXp(param1:int) : void
      {
         this.weevilStatManager.updateXp(param1);
      }
      
      public function get myHappinessLevel() : Number
      {
         return 100;
      }
      
      public function get isNewUser() : Boolean
      {
         return this.newUserProgressManager.isNewUser;
      }
      
      public function completedNewUserTask(param1:Number) : void
      {
         this.newUserProgressManager.completeTask(param1);
         if(param1 == NewUserProgressManager.DRAG_SHELF_ROOM)
         {
            EventManager.get_instance().dispatchEvent(new Event(BinEvents.ITEM_DRAGGED_ROOM));
         }
         if(param1 == NewUserProgressManager.CLOSE_ROOM_CHEST)
         {
            EventManager.get_instance().dispatchEvent(new Event(BinEvents.CLOSED_CHEST));
         }
         if(param1 == NewUserProgressManager.OPEN_CHEST_ROOM)
         {
            EventManager.get_instance().dispatchEvent(new Event(BinEvents.OPENED_CHEST));
         }
      }
      
      public function hideTutorialUI() : void
      {
         this.newUserProgressManager.hideTutorialUI();
      }
      
      public function showTutorialUI() : void
      {
         this.newUserProgressManager.showTutorialUI();
      }
      
      public function setUser(param1:String, param2:int, param3:Boolean, param4:Boolean, param5:Object) : void
      {
         var _loc6_:* = undefined;
         this._myUserObj = param5;
         for(_loc6_ in this._myUserObj)
         {
         }
         this._locale = this._myUserObj["locale"];
         this._myUserName = param1;
         this._myUserIDX = param2;
         this._tycoon = param3;
         this._tycoonTV = param4;
         URLhandler.userName = this.myUserName;
         this._myUserID = this._myUserObj.userID;
         this.get_sfs().myUserId = this._myUserID;
         this.myNestName = "nest_" + this._myUserName;
         if(this._myUserObj.exp < 1)
         {
            this.newUser = true;
         }
         else
         {
            this.newUser = false;
         }
         this.checkTycoonAccountTimer = new Timer(180000 + int(360000 * Math.random()),1);
         this.checkTycoonAccountTimer.addEventListener("timer",this.checkTycoonAccount);
         this.checkTycoonAccountTimer.start();
      }
      
      private function checkTycoonAccount(param1:TimerEvent) : void
      {
         var _loc2_:PHPcall = new PHPcall("weevil/remaining-revenue",true);
         _loc2_.awaitResponse(this.tycoonAccountStatusReceived);
      }
      
      private function tycoonAccountStatusReceived(param1:Object) : void
      {
         if(param1.res == "1")
         {
            this.displayMoneyInAccountMsg = true;
         }
      }
      
      public function showMoneyInAccountMsg() : void
      {
         this.displayMoneyInAccountMsg = false;
         this.showDialogueBox("You have Dosh waiting for you at the cash machine. Do you want to collect it now?",this.gotoCashMachine);
      }
      
      private function gotoCashMachine(param1:MouseEvent) : void
      {
         this.hideDialogueBox();
         this.loadLoc(111);
      }
      
      public function get myNestRoomID() : int
      {
         var _loc1_:Object = null;
         if(this._myNestRoomID == 0)
         {
            _loc1_ = this.ssclient.getRoomByName(this.myNestName);
            if(_loc1_ != null)
            {
               this._myNestRoomID = _loc1_.getId();
            }
         }
         return this._myNestRoomID;
      }
      
      private function onExtensionResponse(param1:SFSEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc2_:String = param1.params.type;
         switch(_loc2_)
         {
            case SmartFoxClient.XTMSG_TYPE_STR:
               _loc4_ = param1.params.dataObj;
               _loc3_ = _loc4_[0];
               _loc5_ = MessageProtocol.getCommmandName(_loc4_[0]);
               _loc6_ = MessageProtocol.getCommmandRest(_loc4_[0]);
               switch(_loc5_)
               {
                  case MessageProtocol.PET_MODULE_NAME:
                     switch(_loc6_)
                     {
                        case MessageProtocol.PET_MODULE_PET_EXPRESSION:
                           this.petExpressionReceived(_loc4_);
                           break;
                        case MessageProtocol.PET_MODULE_PET_GO_NEST:
                           this.onPetEnterNest(_loc4_);
                           break;
                        case MessageProtocol.PET_MODULE_GOT_BALL:
                           this.petGotBall(_loc4_);
                           break;
                        case MessageProtocol.PET_MODULE_PET_JOIN_NEST_LOC:
                           this.petJoinedNestLoc(_loc4_);
                           break;
                        case MessageProtocol.PET_MODULE_ACTION:
                           this.petActionReceived(_loc4_);
                           break;
                        case MessageProtocol.PET_MODULE_SET_NEST_DOOR_PET:
                           this.setNestDoorPet(_loc4_);
                           break;
                        case MessageProtocol.PET_MODULE_SEND_PET_COMMAND:
                           this.petCmdReceived(_loc4_);
                     }
                     return;
                  case MessageProtocol.CHAT_MODULE_NAME:
                     switch(_loc6_)
                     {
                        case MessageProtocol.CHAT_MODULE_CHAT_YOURSELF:
                           this.myMsgReceived(_loc4_[2]);
                           break;
                        case MessageProtocol.CHAT_MODULE_CHANGE_CHAT_STATE:
                           this.switchChatState(_loc4_[2]);
                     }
                     return;
                  case MessageProtocol.INGAME_MODULE_NAME:
                     switch(_loc6_)
                     {
                        case MessageProtocol.INGAME_MODULE_MOVE:
                           this.onMoveReceived(_loc4_);
                           break;
                        case MessageProtocol.INGAME_MODULE_EXPRESSION:
                           this.onExpressionReceived(_loc4_);
                           break;
                        case MessageProtocol.INGAME_MODULE_ACTION:
                           this.onActionReceived(_loc4_);
                           break;
                        case MessageProtocol.INGAME_MODULE_ROOM_EVENT:
                           this.onRoomEventReceived(_loc4_);
                           break;
                        case MessageProtocol.INGAME_MODULE_GET_ZONE_TIME:
                           this.setZoneTime(_loc4_);
                           break;
                        case MessageProtocol.INGAME_MODULE_ADD_APPAREL:
                           this.onAddApparelReceived(_loc4_);
                           break;
                        case MessageProtocol.INGAME_MODULE_REMOVE_APPAREL:
                           this.onRemoveApparelReceived(_loc4_);
                           break;
                        case MessageProtocol.INGAME_MODULE_CHECK_MESSAGE:
                           this.txtChecked(_loc4_);
                     }
                     return;
                  case MessageProtocol.NEST_MODULE_NAME:
                     switch(_loc6_)
                     {
                        case MessageProtocol.NEST_MODULE_SET_NEST_DOOR:
                           this.setNestDoor(_loc4_);
                           break;
                        case MessageProtocol.NEST_MODULE_JOIN_NEST_LOCATION:
                           this.userJoinedNestLoc(_loc4_);
                           break;
                        case MessageProtocol.NEST_MODULE_INVITE_TO_NEST:
                           if(this.fullyInitialised)
                           {
                              this.UI.invitationReceived(_loc4_);
                           }
                           break;
                        case MessageProtocol.NEST_MODULE_REMOVE_GUESTS_FROM_NEST:
                           this.UI.guestRemoved(_loc4_);
                           break;
                        case MessageProtocol.NEST_MODULE_GUEST_JOINED_NEST:
                           this.guestInNest(_loc4_);
                           break;
                        case MessageProtocol.NEST_MODULE_REMOVE_NEST_INVITES:
                           this.removeNestInvite(_loc4_);
                           break;
                        case MessageProtocol.NEST_MODULE_RETURN_TO_NEST:
                           this.returnToNest_received(_loc4_);
                     }
                     return;
                  case MessageProtocol.LOTTERY_MODULE_NAME:
                     switch(_loc6_)
                     {
                        case MessageProtocol.LOTTERY_MODULE_BROADCAST_DRAW:
                           this.UI.lottoResultReceived(_loc4_);
                           this.ssclient.dispatchLottoDrawEvent();
                     }
                     return;
                  case MessageProtocol.ADMIN_MODULE_NAME:
                     switch(_loc6_)
                     {
                        case MessageProtocol.ADMIN_MODULE_WARN:
                           this.warningMsgReceived(_loc4_);
                           break;
                        case MessageProtocol.ADMIN_MODULE_SILENCE:
                           this.UI.silence(_loc4_[2],_loc4_[3]);
                           this.UI.showSilenceMsg(_loc4_[2],_loc4_[4]);
                     }
                     return;
                  default:
                     switch(_loc3_)
                     {
                        case "p":
                           _loc8_ = _loc4_[2];
                           switch(_loc8_)
                           {
                              case "newJt":
                                 this.newJugglingTrickReceived(_loc4_);
                           }
                           break;
                        case "updateQpos":
                     }
               }
               break;
            case SmartFoxClient.XTMSG_TYPE_XML:
               _loc7_ = param1.params.dataObj;
               _loc3_ = _loc7_.commandType;
               switch(_loc3_)
               {
                  case "driveOff":
                     this.driveOff(_loc7_.playerCount);
                     break;
                  case "resetGame":
                     this.resetGame(_loc7_.playerCount);
                     break;
                  case "login":
                     if(_loc7_.success == "false")
                     {
                        this.logout();
                     }
               }
         }
      }
      
      private function petActionReceived(param1:Array) : void
      {
         var _loc2_:int = int(param1[2]);
         var _loc3_:int = int(param1[3]);
         var _loc4_:String = param1[4];
         var _loc5_:Pet = this.getPetByID(_loc2_);
         if(_loc5_ != null)
         {
            _loc5_.act(_loc3_,_loc4_);
         }
      }
      
      private function petExpressionReceived(param1:Array) : void
      {
         var _loc2_:int = int(param1[2]);
         var _loc3_:int = int(param1[3]);
         var _loc4_:Pet = this.getPetByID(_loc2_);
         if(_loc4_ != null)
         {
            _loc4_.setExpression(_loc3_);
         }
      }
      
      private function petGotBall(param1:Array) : void
      {
         var _loc2_:int = int(param1[2]);
         var _loc3_:Pet = this.getPetByID(_loc2_);
         if(_loc3_ != null)
         {
            _loc3_.gotBall();
         }
      }
      
      private function onPetEnterNest(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         var _loc3_:String = param1[3];
         var _loc4_:Object = Utils.stringToObject(_loc2_);
         var _loc5_:Object = Utils.stringToObject(_loc3_);
         var _loc6_:Pet = this.addPet(_loc5_.locID,_loc4_.id,_loc4_.name,this.getWeevilByName(this.hostWeevilName),_loc5_.x,_loc5_.y,_loc5_.z,_loc5_.r,_loc4_);
      }
      
      private function petJoinedNestLoc(param1:Array) : void
      {
         var _loc11_:Loc = null;
         var _loc2_:int = int(param1[2]);
         var _loc3_:int = int(param1[3]);
         var _loc4_:int = int(param1[4]);
         var _loc5_:Number = Number(param1[5]);
         var _loc6_:Number = Number(param1[6]);
         var _loc7_:Number = Number(param1[7]);
         var _loc8_:Number = Number(param1[8]);
         var _loc9_:Pet = this.getPetByID(_loc2_);
         if(_loc9_ != null)
         {
            _loc11_ = _loc9_.loc;
            if(_loc11_ != null)
            {
               _loc11_.removePet(_loc9_);
            }
            _loc9_.stopActions();
            _loc9_.rotY = _loc8_;
         }
         if(this.inNest)
         {
            _loc3_ = -_loc3_;
         }
         var _loc10_:Loc = this.getLocById(_loc3_);
         _loc10_.addPet(_loc9_);
         if(_loc10_.loaded)
         {
            _loc9_.enterThroughDoor(_loc10_.getDoorByID(_loc4_));
         }
         else
         {
            _loc9_.x = _loc5_;
            _loc9_.y = _loc6_;
            _loc9_.z = _loc7_;
         }
      }
      
      private function setNestDoorPet(param1:Array) : void
      {
         var _loc2_:int = int(param1[2]);
         var _loc3_:int = int(param1[3]);
         var _loc4_:Pet = this.getPetByID(_loc2_);
         if(_loc4_ != null)
         {
            _loc4_.setDoorForMasking(_loc3_);
         }
      }
      
      private function petCmdReceived(param1:Array) : void
      {
         var _loc2_:int = int(param1[2]);
         var _loc3_:String = param1[3];
         var _loc4_:int = int(param1[4]);
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc5_++;
         }
         var _loc6_:Weevil = this.getWeevilByID(_loc2_);
         if(_loc6_ != null)
         {
            if(_loc4_ == PetSkillNames.CALL)
            {
               _loc6_.say(_loc3_ + PetSkillNames.getName(_loc4_));
            }
            else
            {
               _loc6_.say(_loc3_ + " " + PetSkillNames.getName(_loc4_));
            }
         }
      }
      
      private function switchChatState(param1:String) : *
      {
         if(param1 == "1")
         {
            this.UI.enableChat();
         }
         else
         {
            this.UI.disableChat();
         }
      }
      
      private function publicMsgReceived(param1:SFSEvent) : void
      {
         var _loc2_:String = param1.params.message;
         var _loc3_:int = int(param1.params.sender.getId());
         var _loc4_:Weevil = this.getWeevilByID(_loc3_);
         if(_loc4_ != null)
         {
            if(!this.UI.isOnIgnoreList(_loc4_.name))
            {
               _loc4_.say(_loc2_);
               this._UI.addMsgToChatLog(_loc3_,_loc4_.name,_loc2_);
            }
         }
      }
      
      private function myMsgReceived(param1:String) : void
      {
         this.myWeevil.say(param1);
         this._UI.addMsgToChatLog(this.myUserID,this.myWeevil.name,param1);
      }
      
      private function onMoveReceived(param1:Array) : void
      {
         var _loc2_:int = int(param1[2]);
         var _loc3_:Number = Number(param1[3]);
         var _loc4_:Number = Number(param1[4]);
         var _loc5_:Number = Number(param1[5]);
         var _loc6_:Weevil = this.getWeevilByID(_loc2_);
         if(_loc6_ != null)
         {
            _loc6_.walk(_loc3_,_loc4_,_loc5_,this.weevilSpeed);
         }
      }
      
      private function onExpressionReceived(param1:Array) : void
      {
         var _loc2_:int = int(param1[2]);
         var _loc3_:int = int(param1[3]);
         var _loc4_:Weevil = this.getWeevilByID(_loc2_);
         if(_loc4_ != null)
         {
            _loc4_.setMouth(_loc3_);
         }
      }
      
      private function onActionReceived(param1:Array) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = int(param1[2]);
         var _loc3_:int = int(param1[3]);
         var _loc4_:String = param1[4];
         var _loc5_:Weevil = this.getWeevilByID(_loc2_);
         if(_loc5_ != this.myWeevil)
         {
            if(_loc5_ != null)
            {
               _loc5_.act(_loc3_,_loc4_);
            }
         }
      }
      
      private function onAddApparelReceived(param1:Array) : void
      {
         var _loc2_:int = int(param1[2]);
         var _loc3_:int = int(param1[3]);
         var _loc4_:String = param1[4];
         var _loc5_:Weevil = this.getWeevilByID(_loc2_);
         if(_loc5_ != null)
         {
            _loc5_.loadApparel(_loc3_,_loc4_);
         }
      }
      
      private function onRemoveApparelReceived(param1:Array) : void
      {
         var _loc2_:int = int(param1[2]);
         var _loc3_:int = int(param1[3]);
         var _loc4_:Weevil = this.getWeevilByID(_loc2_);
         if(_loc4_ != null)
         {
            _loc4_.removeApparel(_loc3_);
         }
      }
      
      public function filterText(param1:Function, param2:String, param3:Array, param4:String = null) : void
      {
         if(param4 == null)
         {
            param4 = this.myUserName;
         }
         this.filterClientCallbackFn = param1;
         this.filterTxt = param2;
         this.filterTxtHash = Rssmv.o_2(param3);
         this.ssclient.checkMsg(param2,param4);
      }
      
      public function sendBuddyMsg(param1:String, param2:String, param3:int) : Boolean
      {
         var _loc4_:String = null;
         var _loc5_:PHPcall = null;
         if(this.UI.areBuddyMessagesEnabled())
         {
            this.buddyMsgRecipientIDX = param3;
            _loc4_ = Rssmv.o_2([param1,param3]);
            _loc5_ = new PHPcall("buddy-messages/send-buddy-message",true);
            _loc5_.fireAndForget(["msg","recipIDX","hash"],[param1,param3,_loc4_]);
            return true;
         }
         return false;
      }
      
      private function txtChecked(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         if(this.filterClientCallbackFn != null)
         {
            if(_loc2_ == "1")
            {
               this.filterClientCallbackFn(true,this.filterTxt,this.filterTxtHash);
            }
            else
            {
               this.filterClientCallbackFn(false);
            }
         }
      }
      
      public function isOnBuddyList(param1:String) : Boolean
      {
         return this.UI.isOnBuddyList(param1);
      }
      
      private function onRoomEventReceived(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         this.crntLoc.roomEventReceived(_loc2_);
      }
      
      private function setZoneTime(param1:Array) : void
      {
         DateTime.setZoneTime(param1[2],param1[3]);
      }
      
      private function onJoinRoom(param1:Object) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         var _loc11_:String = null;
         var _loc12_:Weevil = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:* = undefined;
         var _loc17_:Object = null;
         var _loc18_:Pet = null;
         var _loc19_:* = undefined;
         var _loc20_:Object = null;
         var _loc21_:* = undefined;
         var _loc22_:Array = null;
         var _loc23_:Array = null;
         var _loc24_:int = 0;
         var _loc25_:* = undefined;
         this._UI.clearChatLog();
         this.myWeevil.defaultPose();
         if(!this.imOnStage)
         {
            this.myWeevil.y = 0;
         }
         var _loc2_:Object = this.ssclient.getActiveRoom();
         var _loc3_:String = _loc2_.getName();
         if(_loc3_ != "cinemaScreen")
         {
            if(_loc3_ == "WeevilWheels")
            {
               if(this.crntBigGameSlot != null)
               {
                  if(this.crntBigGameSlot.numPlayers == 1)
                  {
                     this.bigGameLoader_mc.startTimeTrial();
                  }
                  else
                  {
                     this.ssclient.sendDrivenOff();
                  }
               }
            }
            else if(_loc3_ != "Main")
            {
               if(this.crntLoc.timerID != this.crntTimerID)
               {
                  this.crntTimerID = this.crntLoc.timerID;
                  if(this.crntTimerID != 0)
                  {
                     this.startPartyTimer();
                  }
                  else
                  {
                     this.partyTimer.stop();
                  }
               }
               _loc4_ = _loc2_.getUserList();
               this.myPetsDormant(false);
               for(_loc19_ in _loc4_)
               {
                  _loc10_ = _loc4_[_loc19_];
                  _loc11_ = _loc10_.getName();
                  if(_loc4_[_loc19_].getId() != this.myUserID)
                  {
                     _loc5_ = Number(_loc10_.getVariable("x"));
                     _loc6_ = Number(_loc10_.getVariable("y"));
                     if(isNaN(_loc6_))
                     {
                        _loc6_ = 0;
                     }
                     _loc7_ = Number(_loc10_.getVariable("z"));
                     _loc8_ = Number(_loc10_.getVariable("r"));
                     _loc9_ = int(_loc10_.getVariable("locID"));
                     if(this.inNest)
                     {
                        _loc9_ = -_loc9_;
                     }
                     _loc20_ = new Object();
                     _loc20_.weevilDef = _loc10_.getVariable("weevilDef");
                     _loc20_.ex = _loc10_.getVariable("ex");
                     _loc20_.ps = _loc10_.getVariable("ps");
                     _loc20_.vict = _loc10_.getVariable("vict");
                     _loc20_.king = _loc10_.getVariable("king");
                     _loc20_.apparel = _loc10_.getVariable("apparel");
                     for(_loc21_ in _loc20_)
                     {
                     }
                     _loc12_ = this.addWeevil(_loc9_,_loc10_.getId(),_loc11_,_loc5_,_loc6_,_loc7_,_loc8_,_loc20_);
                     _loc14_ = _loc10_.getVariable("petDef");
                     if(_loc14_ != null && _loc14_ != "")
                     {
                        _loc17_ = Utils.stringToObject(_loc14_);
                        _loc15_ = _loc10_.getVariable("petState");
                        _loc16_ = Utils.stringToObject(_loc15_);
                        _loc18_ = this.addPet(_loc9_,_loc17_.id,_loc17_.name,_loc12_,_loc16_.x,_loc16_.y,_loc16_.z,_loc16_.r,_loc17_);
                        _loc18_.setOwner(_loc12_);
                        if(_loc16_.ps == "28")
                        {
                           _loc18_.act(_loc16_.ps,"1");
                        }
                     }
                  }
               }
               if(this.crntLocID < 100)
               {
                  this.myWeevil.inNest = true;
               }
               else
               {
                  this.myWeevil.inNest = false;
               }
               this.crntLoc.enterLoc(this.myWeevil);
               this.weevils.push(this.myWeevil);
               this.startRendering();
               this.crntLoc.displayIt(viewPort.display_spr);
               if(this.myWeevil.teleporting)
               {
                  this.myWeevilAct(29);
               }
               if(this._inOtherUserNest)
               {
                  if(this.UI.invitationValid(this.hostWeevilName) || this.crntLocID == -50)
                  {
                     _loc22_ = _loc2_.getVariables();
                     _loc13_ = _loc2_.getVariable("petIDs");
                     if(_loc13_ != null)
                     {
                        _loc23_ = _loc13_.split(",");
                        for(_loc25_ in _loc23_)
                        {
                           _loc24_ = int(_loc23_[_loc25_]);
                           _loc14_ = _loc2_.getVariable("petDef" + _loc24_);
                           if(_loc14_ != null && _loc14_ != "")
                           {
                              _loc17_ = Utils.stringToObject(_loc14_);
                              _loc15_ = _loc2_.getVariable("petState" + _loc24_);
                              _loc16_ = Utils.stringToObject(_loc15_);
                              _loc18_ = this.addPet(_loc16_.locID,_loc24_,_loc17_.name,this.getWeevilByName(this.hostWeevilName),_loc16_.x,_loc16_.y,_loc16_.z,_loc16_.r,_loc17_);
                              _loc18_.act(_loc16_.ps);
                           }
                        }
                     }
                  }
                  else
                  {
                     this.gotoNest();
                  }
               }
               else if(_loc3_ == this.myNestName)
               {
                  if(!this.petVarsInitialised)
                  {
                     this.petVarsInitialised = true;
                     this.myPetIDs = "";
                     _loc14_ = "";
                     _loc15_ = "";
                     for each(_loc18_ in this.myPets)
                     {
                        if(this.myPetIDs.length > 0)
                        {
                           this.myPetIDs += ",";
                        }
                        this.myPetIDs += _loc18_.id;
                        _loc14_ = "name:" + _loc18_.name + "," + Utils.objectToString(_loc18_.defObj);
                        _loc15_ = "locID:" + -_loc18_.loc.id + ",ps:" + _loc18_.crntPose + ",x:" + _loc18_.x + ",y:" + _loc18_.y + ",z:" + _loc18_.z + ",r:" + _loc18_.rotY;
                        this.ssclient.setPetDef(_loc18_.id,_loc14_,this.myNestRoomID,true);
                        this.setPetState(_loc18_.id,_loc15_);
                     }
                     if(_loc14_.length > 0)
                     {
                        this.ssclient.setPetIDs(this.myPetIDs,this.myNestRoomID);
                     }
                  }
                  if(this.crntLocID == 5)
                  {
                     this.moveMyWeevil(-15,165);
                  }
                  else if(this.crntLocID == 20)
                  {
                  }
                  if(!this.seenStartUpTips && this.myLevel >= 4 && this.myLevel <= 8)
                  {
                     this.seenStartUpTips = true;
                  }
               }
               if(this.displayMoneyInAccountMsg)
               {
                  this.showMoneyInAccountMsg();
               }
               this.hideLoader(2);
            }
         }
      }
      
      public function getRoomObject() : Object
      {
         return this.ssclient.getActiveRoom();
      }
      
      private function userJoinedNestLoc(param1:Array) : void
      {
         var _loc10_:Loc = null;
         var _loc11_:Loc = null;
         var _loc2_:int = int(param1[2]);
         var _loc3_:int = int(param1[3]);
         var _loc4_:int = int(param1[4]);
         var _loc5_:Number = Number(param1[5]);
         var _loc6_:Number = Number(param1[6]);
         var _loc7_:Number = Number(param1[7]);
         var _loc8_:Number = Number(param1[8]);
         if(this.inNest)
         {
            _loc3_ = -_loc3_;
         }
         var _loc9_:Weevil = this.getWeevilByID(_loc2_);
         if(_loc9_ != null)
         {
            _loc10_ = _loc9_.crntLoc;
            if(_loc10_ != null)
            {
               _loc10_.removeWeevil(_loc9_);
            }
            _loc9_.setExitDoor(null);
            if(!_loc9_.doingAction(29))
            {
               _loc9_.stopActions();
            }
            _loc9_.arrived();
            _loc9_.rotY = _loc8_;
            _loc11_ = this.getLocById(_loc3_);
            _loc11_.addWeevil(_loc9_);
            if(_loc11_.loaded && _loc4_ > 0)
            {
               _loc11_.enterThroughDoor(_loc9_,_loc11_.getDoorByID(_loc4_));
            }
            else
            {
               _loc9_.x = _loc5_;
               _loc9_.y = _loc6_;
               _loc9_.z = _loc7_;
            }
         }
      }
      
      private function setNestDoor(param1:Array) : void
      {
         var _loc2_:int = int(param1[2]);
         var _loc3_:int = int(param1[3]);
         var _loc4_:Weevil = this.getWeevilByID(_loc2_);
         if(_loc4_ != null)
         {
            _loc4_.setDoorForMasking(_loc3_);
         }
      }
      
      public function sendPetAction(param1:int, param2:String, param3:int, param4:String, param5:String = "-1") : void
      {
         var _loc6_:uint = 0;
         if(!this.inNest || !this.UI.guestFreeNest())
         {
            if(param2 == "nest")
            {
               _loc6_ = 0;
            }
            else
            {
               _loc6_ = 1;
            }
            this.ssclient.sendPetAction(param1,param3,param4,_loc6_,param5);
         }
      }
      
      public function sendPetExpression(param1:int, param2:String, param3:int) : void
      {
         var _loc4_:uint = 0;
         if(!this.inNest || !this.UI.guestFreeNest())
         {
            if(param2 == "nest")
            {
               _loc4_ = 0;
            }
            else
            {
               _loc4_ = 1;
            }
            this.ssclient.sendPetExpression(param1,param3,_loc4_);
         }
      }
      
      public function sendPetGotBall(param1:int) : void
      {
         this.ssclient.sendPetGotBall(param1);
      }
      
      public function petJoinNestLoc(param1:int, param2:int, param3:int, param4:Number, param5:Number, param6:Number, param7:Number, param8:String) : void
      {
         var _loc9_:uint = 0;
         if(param8 == "nest")
         {
            _loc9_ = 0;
            param2 = -param2;
         }
         else
         {
            _loc9_ = 1;
         }
         this.ssclient.petJoinNestLoc(param1,param2,param3,param4,param5,param6,param7,_loc9_);
      }
      
      private function petGoHome(param1:Pet) : void
      {
         var _loc3_:int = 0;
         var _loc5_:Object = null;
         if(param1.loc != null)
         {
            param1.loc.removePet(param1);
         }
         var _loc2_:int = param1.getBedLocID();
         if(_loc2_ != 0)
         {
            _loc5_ = param1.getBedCoords();
            param1.x = _loc5_.x;
            param1.z = _loc5_.z;
            this.getLocById(_loc2_).addPet(param1);
            _loc3_ = -_loc2_;
         }
         else
         {
            param1.stopActions();
            param1.x = 50;
            param1.z = 160;
            this.getLocById(5).addPet(param1);
            _loc3_ = -5;
         }
         var _loc4_:String = "locID:" + _loc3_ + ",ps:0,x:" + param1.x + ",y:" + param1.y + ",z:" + param1.z + ",r:" + param1.rotY;
         this.setPetState(param1.id,_loc4_);
         this.ssclient.petGoHome(this.myPetIDs,param1.id,_loc4_);
      }
      
      public function sendMyPetsHome() : void
      {
         var _loc1_:Pet = null;
         for each(_loc1_ in this.myPets)
         {
            _loc1_.dismount();
            if(_loc1_.loc.name != "nest")
            {
               this.petGoHome(_loc1_);
            }
         }
      }
      
      public function sendSetNestDoorPet(param1:int, param2:String, param3:int) : void
      {
         var _loc4_:uint = 0;
         if(param2 == "nest")
         {
            _loc4_ = 0;
         }
         else
         {
            _loc4_ = 1;
         }
         this.ssclient.setNestDoorPet(param1,param3,_loc4_);
      }
      
      public function sendPetCommand(param1:String) : void
      {
         param1 = Utils.trimString(param1);
         if(param1 != "")
         {
            if(this.broadcastMoves)
            {
               this.ssclient.sendPublicMessage(param1);
            }
            else
            {
               this.myWeevil.say(param1);
            }
         }
      }
      
      public function moveMyWeevil2(param1:Number, param2:Number, param3:int = 999, param4:Boolean = false) : void
      {
         var _loc5_:Point = this.crntLoc.legaliseClick(param1,param2);
         if(_loc5_ != null)
         {
            param1 = _loc5_.x;
            param2 = _loc5_.y;
            this.moveMyWeevil(param1,param2,param4,null,0,0,null,null,null,null,null,param3);
         }
      }
      
      public function moveMyWeevil(param1:Number, param2:Number, param3:Boolean = false, param4:Door = null, param5:int = 0, param6:int = 0, param7:Object = null, param8:GameSlot = null, param9:BigGameSlot = null, param10:Teleporter = null, param11:Spinner = null, param12:int = 999) : void
      {
         var _loc13_:int = 0;
         if(!this.myWeevil.isWalkAllowed())
         {
            return;
         }
         if(param12 == 999)
         {
            _loc13_ = this.myWeevil.getDir(param1,param2);
         }
         else
         {
            _loc13_ = param12;
         }
         this.myWeevil.setExitDoor(param4);
         if(param4 != null && (this.inNest || this._inOtherUserNest))
         {
            this.ssclient.setNestDoor(param4.id);
         }
         this.myWeevil.setDestLoc(param5,param6);
         this.myWeevil.setDestExtUIData(param7);
         this.myWeevil.setGameSlot(param8);
         this.myWeevil.setBigGameSlot(param9);
         this.myWeevil.setTeleporter(param10);
         this.myWeevil.setSpinner(param11);
         this.myWeevil.walk(param1,param2,_loc13_,this.weevilSpeed,param3);
         if(this.broadcastMoves)
         {
            this.sendMove(param1,param2,_loc13_);
         }
         this.resetLogoutTimer();
      }
      
      public function myWeevilAct(param1:int, param2:int = 0, param3:String = "-1") : void
      {
         this.myWeevil.act(param1,param3);
         if(this.broadcastMoves)
         {
            this.ssclient.sendAction(param1,param2,param3);
         }
         this.resetLogoutTimer();
      }
      
      public function sendRoomEvent(param1:String, param2:String = "-1") : void
      {
         this.ssclient.sendRoomEvent(param1,param2);
      }
      
      public function sendGrabTray(param1:int) : void
      {
         this.ssclient.grabTray(param1);
      }
      
      public function sendDropTray(param1:int) : void
      {
         this.ssclient.dropTray(param1);
      }
      
      public function sendChefStart() : void
      {
         this.ssclient.chefStart();
      }
      
      public function sendChefQuit() : void
      {
         this.ssclient.chefQuit();
      }
      
      public function updatePlayerScore(param1:int) : void
      {
         this.ssclient.updatePlayerScore(param1);
      }
      
      private function driveOff(param1:int) : void
      {
         if(this.crntLoc != null)
         {
            if(this.crntBigGameSlot != null)
            {
               if(this.crntBigGameSlot.numPlayers == param1 && this.myWeevil.kart != null)
               {
                  this.closeDragableUI();
               }
            }
            this.crntLoc.driveOff(param1);
         }
      }
      
      private function resetGame(param1:int) : void
      {
         if(this.crntLoc != null)
         {
            this.crntLoc.resetKarts(param1);
         }
      }
      
      public function logout(param1:Event = null) : void
      {
         this.logoutTimer.removeEventListener("timer",this.logout);
         this.callLogoutPHP();
      }
      
      private function callLogoutPHP() : void
      {
         var _loc1_:PHP2call = new PHP2call("login/logoutClient");
         _loc1_.awaitResponse(this.logoutResponseReceived);
      }
      
      private function logoutResponseReceived(param1:Object) : void
      {
         var _loc2_:URLRequest = new URLRequest("/login/login.php");
         navigateToURL(_loc2_,"_self");
      }
      
      public function resetLogoutTimer() : void
      {
         this.logoutTimer.reset();
         this.logoutTimer.start();
      }
      
      private function modMsgReceived(param1:SFSEvent) : void
      {
         var _loc2_:String = param1.params.message;
         this._UI.showModMsg(_loc2_);
      }
      
      private function warningMsgReceived(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         this._UI.showModMsg(_loc2_);
      }
      
      public function getWeevilByID(param1:int) : Weevil
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.weevils)
         {
            if(this.weevils[_loc2_].id == param1)
            {
               return this.weevils[_loc2_];
            }
         }
         return null;
      }
      
      public function getWeevilByName(param1:String) : Weevil
      {
         var _loc2_:Weevil = null;
         for each(_loc2_ in this.weevils)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function hideAllSpeechBubbles() : void
      {
         var _loc1_:Weevil = null;
         for each(_loc1_ in this.weevils)
         {
            _loc1_.hideSpeachBubble();
         }
      }
      
      public function getPetByID(param1:int) : Pet
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.pets)
         {
            if(this.pets[_loc2_].id == param1)
            {
               return this.pets[_loc2_];
            }
         }
         return null;
      }
      
      public function getMyPetByID(param1:int) : Pet
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.myPets)
         {
            if(this.myPets[_loc2_].id == param1)
            {
               return this.myPets[_loc2_];
            }
         }
         return null;
      }
      
      public function getAllMyPets() : Array
      {
         return this.myPets;
      }
      
      public function getPetNameByBowlID(param1:int) : String
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.myPets)
         {
            if(this.myPets[_loc2_].bowlID == param1)
            {
               return this.myPets[_loc2_].name;
            }
         }
         return null;
      }
      
      private function startPartyTimer() : void
      {
         if(!this.partyTimer.running)
         {
            this.enterParty();
            this.partyTimer.start();
         }
      }
      
      private function enterParty() : void
      {
         var request:URLRequest;
         var loader:URLLoader;
         var variables:URLVariables = new URLVariables();
         variables.id = this.crntTimerID;
         request = new URLRequest();
         request.url = URLhandler.servicesLocation + "php/enterParty.php?rndVar=" + Math.random();
         request.method = URLRequestMethod.POST;
         request.data = variables;
         loader = new URLLoader();
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
         }
      }
      
      private function partyTimerListener(param1:TimerEvent) : void
      {
         var request:URLRequest;
         var loader:URLLoader;
         var evt:TimerEvent = param1;
         var variables:URLVariables = new URLVariables();
         variables.id = this.crntTimerID;
         request = new URLRequest();
         request.url = URLhandler.servicesLocation + "php/incrPartyTime.php?rndVar=" + Math.random();
         request.method = URLRequestMethod.POST;
         request.data = variables;
         loader = new URLLoader();
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
         }
      }
      
      public function setPetDef(param1:Pet, param2:Boolean = true) : void
      {
         var _loc5_:Pet = null;
         var _loc3_:String = "name:" + param1.name + "," + Utils.objectToString(param1.defObj);
         this.ssclient.setPetDef(param1.id,_loc3_,this.myNestRoomID,param2);
         var _loc4_:* = "";
         if(!param2)
         {
            for each(_loc5_ in this.myPets)
            {
               if(_loc5_ != param1)
               {
                  if(_loc4_.length > 0)
                  {
                     _loc4_ += ",";
                  }
                  _loc4_ += _loc5_.id;
               }
            }
            this.ssclient.setPetIDs(_loc4_,this.myNestRoomID);
         }
      }
      
      public function setPetDefInPetChanger(param1:Pet, param2:Boolean = true) : void
      {
         var _loc3_:String = "name:" + param1.name + "," + Utils.objectToString(param1.defObj);
         this.ssclient.setPetDef(param1.id,_loc3_,this.myNestRoomID,param2);
         var _loc4_:String = "";
      }
      
      public function petDismountInNest(param1:Pet, param2:int = 0) : void
      {
         this.ssclient.setPetIDs(this.myPetIDs,this.myNestRoomID);
         if(param2 == 0)
         {
            param2 = -this.crntLocID;
         }
         var _loc3_:String = "locID:" + param2 + ",ps:0,x:" + param1.x + ",y:" + param1.y + ",z:" + param1.z + ",r:" + param1.rotY;
         this.setPetState(param1.id,_loc3_);
         this.setUserVar("petDef","");
      }
      
      public function setPetState(param1:int, param2:String, param3:Boolean = true) : void
      {
         this.ssclient.setPetState(param1,param2,this.myNestRoomID,param3);
      }
      
      private function myPetsDormant(param1:Boolean) : void
      {
         var _loc2_:Pet = null;
         for each(_loc2_ in this.myPets)
         {
            _loc2_.dormant = param1;
         }
      }
      
      private function onUserEnterRoom(param1:SFSEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         var _loc11_:* = undefined;
         var _loc12_:Weevil = null;
         var _loc13_:String = null;
         var _loc14_:Pet = null;
         var _loc15_:Object = null;
         var _loc16_:String = null;
         var _loc17_:Object = null;
         if(this.crntLocID != 800)
         {
            _loc2_ = param1.params.user;
            _loc3_ = int(_loc2_.getId());
            _loc4_ = _loc2_.getName();
            _loc5_ = Number(_loc2_.getVariable("x"));
            _loc6_ = Number(_loc2_.getVariable("y"));
            if(isNaN(_loc6_))
            {
               _loc6_ = 0;
            }
            _loc7_ = Number(_loc2_.getVariable("z"));
            _loc8_ = Number(_loc2_.getVariable("r"));
            _loc9_ = int(_loc2_.getVariable("locID"));
            if(this.inNest)
            {
               _loc9_ = -_loc9_;
            }
            _loc10_ = new Object();
            _loc10_.weevilDef = _loc2_.getVariable("weevilDef");
            _loc10_.ex = _loc2_.getVariable("ex");
            _loc10_.ps = _loc2_.getVariable("ps");
            _loc10_.vict = _loc2_.getVariable("vict");
            _loc10_.king = _loc2_.getVariable("king");
            _loc10_.apparel = _loc2_.getVariable("apparel");
            for(_loc11_ in _loc10_)
            {
            }
            _loc12_ = this.addWeevil(_loc9_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc10_);
            if(this._inOtherUserNest)
            {
               if(_loc4_ == this.hostWeevilName)
               {
                  for each(_loc14_ in this.pets)
                  {
                     if(_loc14_.loc == this.crntLoc && _loc14_.owner == null)
                     {
                        _loc14_.setOwner(_loc12_);
                     }
                     else if(_loc14_.owner != null && _loc14_.owner.name == _loc12_.name)
                     {
                        _loc14_.setOwner(_loc12_);
                     }
                  }
               }
            }
            _loc13_ = _loc2_.getVariable("petDef");
            if(_loc13_ != null && _loc13_ != "")
            {
               _loc15_ = Utils.stringToObject(_loc13_);
               _loc16_ = _loc2_.getVariable("petState");
               _loc17_ = Utils.stringToObject(_loc16_);
               _loc14_ = this.addPet(_loc9_,_loc15_.id,_loc15_.name,_loc12_,_loc17_.x,_loc17_.y,_loc17_.z,_loc17_.r,_loc15_);
               _loc14_.setOwner(_loc12_);
               _loc14_.act(PetBehaviours.JUMP_ON,"1");
            }
         }
      }
      
      private function onUserLeaveRoom(param1:SFSEvent) : void
      {
         var _loc4_:Loc = null;
         var _loc5_:Pet = null;
         var _loc2_:int = int(param1.params.userId);
         var _loc3_:Weevil = this.getWeevilByID(_loc2_);
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.crntLoc;
            if(_loc4_ != null)
            {
               this.removeWeevil(_loc3_.crntLoc.id,_loc2_);
               for each(_loc5_ in this.pets)
               {
                  if(_loc5_.owner == _loc3_)
                  {
                     if(!(this._inOtherUserNest && this.hostWeevilName == _loc3_.name && !_loc5_.ridingOwner))
                     {
                        this.removePet(_loc5_);
                     }
                     break;
                  }
               }
            }
         }
      }
      
      public function getWeevilDef(param1:String, param2:Function) : void
      {
         var _loc3_:PHPcall = new PHPcall("getWeevilDefinition");
         _loc3_.sendAndAwaitResponse(["userID"],[param1],param2);
      }
      
      public function getWeevilData(param1:String, param2:Function, param3:Boolean = false) : void
      {
         var _loc5_:Date = null;
         var _loc6_:int = 0;
         if(param3)
         {
            _loc5_ = new Date();
            _loc6_ = _loc5_.getTime() - this.weevilDataCacheDate.getTime();
            if(_loc6_ > 60000)
            {
               this.weevilDataCache = new Object();
               this.weevilDataCacheDate = new Date();
            }
            else if(this.weevilDataCache[param1] != null)
            {
               param2(this.weevilDataCache[param1]);
               return;
            }
         }
         this.weevilDataCacheName = param1;
         this.getWeevilDataCallBack = param2;
         var _loc4_:PHPcall = new PHPcall("weevil/data",true);
         _loc4_.sendAndAwaitResponse(["id"],[param1],this.getWeevilDataReceived);
      }
      
      public function getWeevilDataReceived(param1:Object) : void
      {
         this.weevilDataCache[this.weevilDataCacheName] = param1;
         this.getWeevilDataCallBack(param1);
      }
      
      public function getWeevilData2(param1:String, param2:Function) : void
      {
         this.getWeevilData2CallBackFunc = param2;
         var _loc3_:PHP2call = new PHP2call("weevil/getData");
         _loc3_.sendAndAwaitResponse(["id"],[param1],this.getWeevilData2Received,true,true);
      }
      
      private function getWeevilData2Received(param1:Object, param2:Event) : void
      {
         this.getWeevilData2CallBackFunc(param1);
      }
      
      public function getWeevilMugshot(param1:String, param2:Object, param3:uint) : Bitmap
      {
         var _loc4_:Weevil = this.weevilFactory.createWeevil(0,param1,0,0,0,0,param2);
         return this.weevilFactory.createMugShot2(_loc4_,param3);
      }
      
      private function addWeevil(param1:int, param2:int, param3:String, param4:Number, param5:Number, param6:Number, param7:Number, param8:Object) : Weevil
      {
         var _loc10_:Weevil = null;
         var _loc9_:Loc = this.getLocById(param1);
         if(_loc9_ != null)
         {
            _loc10_ = this.weevilFactory.createWeevil(param2,param3,param4,param5,param6,param7,param8);
            if(param1 < 100)
            {
               _loc10_.inNest = true;
            }
            _loc10_.set_bin(this);
            this.weevils.push(_loc10_);
            _loc9_.addWeevil(_loc10_);
            _loc10_.setClickHandler();
            return _loc10_;
         }
         return null;
      }
      
      private function removeWeevil(param1:int, param2:int) : void
      {
         var _loc6_:Loc = null;
         var _loc3_:Weevil = this.getWeevilByID(param2);
         var _loc4_:int = int(this.weevils.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(this.weevils[_loc5_] == _loc3_)
            {
               this.weevils.splice(_loc5_,1);
               _loc6_ = this.getLocById(param1);
               if(_loc6_ != null)
               {
                  this.getLocById(param1).removeWeevil(_loc3_);
               }
               if(_loc3_ != null)
               {
                  _loc3_.removeClickHandler();
                  if(_loc3_.kart != null)
                  {
                     _loc3_.kart.enableMouseHandlers();
                  }
               }
               break;
            }
            _loc5_++;
         }
      }
      
      public function removeAllWeevils() : void
      {
         var _loc1_:Weevil = null;
         for each(_loc1_ in this.weevils)
         {
            _loc1_.crntLoc.removeWeevil(_loc1_);
            _loc1_.removeClickHandler();
            if(_loc1_.kart != null)
            {
               _loc1_.kart.enableMouseHandlers();
            }
         }
         this.weevils = [];
      }
      
      public function createNPCmanager() : void
      {
         if(this.NPCmanager == null)
         {
            this.NPCmanager = new NPC_manager(this.ssclient);
         }
      }
      
      public function addNPC(param1:int, param2:int, param3:Number, param4:Number, param5:Number, param6:Number, param7:Object, param8:Number = 1) : NPC
      {
         var _loc10_:NPC = null;
         var _loc9_:Loc = this.getLocById(param1);
         if(_loc9_ != null)
         {
            _loc10_ = NPC(this.weevilFactory.createWeevil(param2,null,param3,param4,param5,param6,param7,true,param8));
            if(param1 < 100)
            {
            }
            Weevil(_loc10_).set_bin(this);
            this.weevils.push(_loc10_);
            _loc9_.addWeevil(Weevil(_loc10_));
            return _loc10_;
         }
         return null;
      }
      
      public function removeNPC(param1:NPC) : void
      {
      }
      
      public function addPet(param1:int, param2:int, param3:String, param4:Weevil, param5:Number, param6:Number, param7:Number, param8:Number, param9:Object) : Pet
      {
         var _loc10_:Pet = this.petFactory.createPet(param2,param3,param4,param5,param6,param7,param8,param9);
         this.pets.push(_loc10_);
         this.getLocById(param1).addPet(_loc10_);
         return _loc10_;
      }
      
      private function removePet(param1:Pet) : void
      {
         var _loc2_:int = int(this.pets.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.pets[_loc3_] == param1)
            {
               this.pets.splice(_loc3_,1);
               param1.loc.removePet(param1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function petFoodInBowl() : void
      {
         var _loc1_:Pet = null;
         for each(_loc1_ in this.myPets)
         {
            _loc1_.smellFood();
         }
      }
      
      public function petsMimicOwner(param1:Loc, param2:int) : void
      {
         var _loc3_:Pet = null;
         for each(_loc3_ in this.myPets)
         {
            if(_loc3_.loc == param1)
            {
               _loc3_.mimicOwner(param2);
            }
         }
      }
      
      public function petsMimicPet(param1:Pet, param2:int) : void
      {
         var _loc3_:Pet = null;
         for each(_loc3_ in this.myPets)
         {
            if(_loc3_.loc == this.crntLoc && param1 != _loc3_)
            {
               _loc3_.mimicPet(param1,param2);
            }
         }
      }
      
      public function seekPet(param1:Pet) : Pet
      {
         var _loc2_:Pet = null;
         var _loc5_:Pet = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:Number = 0;
         for each(_loc2_ in this.pets)
         {
            if(_loc2_.loc == this.crntLoc && _loc2_ != param1)
            {
               _loc3_.push(_loc2_);
               if(_loc2_.juggleAppeal > _loc4_)
               {
                  _loc5_ = _loc2_;
               }
            }
         }
         if(_loc5_ == null)
         {
            _loc6_ = int(_loc3_.length);
            if(_loc6_ > 0)
            {
               _loc7_ = Utils.getRndInt(0,_loc6_ - 1);
               _loc5_ = _loc3_[_loc7_];
            }
         }
         return _loc5_;
      }
      
      public function showWeevilProfile(param1:int) : void
      {
         var _loc2_:Weevil = null;
         if(!this.petProfileTimer.running)
         {
            _loc2_ = this.getWeevilByID(param1);
            if(_loc2_ != null)
            {
               this._UI.showWeevilProfile(_loc2_.mugShot,_loc2_.name);
            }
         }
      }
      
      private function hideWeevilProfile() : void
      {
         this._UI.hideWeevilProfile();
      }
      
      private function hidePetProfile() : void
      {
         this._UI.hidePetProfile();
      }
      
      public function showPetProfile(param1:Pet, param2:Boolean = false) : void
      {
         this._UI.showPetProfile(param1.id,param2,param1);
         this.petProfileTimer.reset();
         this.petProfileTimer.start();
      }
      
      private function removeOtherPets() : void
      {
         var _loc1_:Pet = null;
         var _loc2_:* = undefined;
         for each(_loc1_ in this.pets)
         {
            if(!_loc1_.mine)
            {
               _loc1_.loc.removePet(_loc1_);
            }
         }
         this.pets = [];
         for(_loc2_ in this.myPets)
         {
            this.pets.push(this.myPets[_loc2_]);
         }
      }
      
      public function initLocs(param1:XML, param2:Boolean = false) : void
      {
         var _loc3_:XML = null;
         var _loc5_:* = undefined;
         var _loc6_:Loc = null;
         var _loc4_:XMLList = param1.children();
         for(_loc5_ in _loc4_)
         {
            if(_loc4_[_loc5_].name() == "location")
            {
               _loc3_ = _loc4_[_loc5_];
               if(param2)
               {
                  _loc6_ = this.locFactory.createLoc(_loc4_[_loc5_],true);
               }
               else
               {
                  _loc6_ = this.locFactory.createLoc(_loc4_[_loc5_]);
               }
               this.initLoc(_loc6_);
            }
         }
      }
      
      public function initLoc(param1:Loc) : void
      {
         param1.set_viewPort(viewPort);
         this.locs.push(param1);
      }
      
      public function init(param1:Function, param2:Function, param3:int = 5) : void
      {
         if(!this.initialised)
         {
            this.initialised = true;
            this.resetLogoutTimer();
            this._showLoader = param1;
            this._hideLoader = param2;
            this.defaultLocID = param3;
            this._UI.set_ssclient(this.ssclient);
            this._UI.set_tycoonMode(this._tycoon);
            this.ssclient.getChatState();
            this.ssclient.getZoneTime();
            this.loadWeevilFactory();
         }
      }
      
      private function loadWeevilFactory() : void
      {
         this.weevilFactory.init(this,this.showLoader,this.hideLoader);
      }
      
      public function weevilFactoryReady() : void
      {
         this.creatureAssets = this.weevilFactory.components_mc;
         this._myWeevil = this.weevilFactory.createWeevil(this.myUserID,this.myUserName,0,0,380,180,this._myUserObj);
         this.myWeevil.thisIsMine();
         this.myWeevil.set_bin(this);
         this.enableMyWeevilProfile();
         this.initNests();
         this.eventManager.dispatchEvent(new Event("bin_weevilFactoryReady"));
      }
      
      public function enableMyWeevilProfile(param1:Boolean = true) : void
      {
         InteractiveObject(this.myWeevil.getCreatureDO()).removeEventListener(MouseEvent.CLICK,this.UI.showMyProfile);
         if(param1)
         {
            InteractiveObject(this.myWeevil.getCreatureDO()).addEventListener(MouseEvent.CLICK,this.UI.showMyProfile);
         }
      }
      
      private function initNests() : void
      {
         this._nest = new Nest(this,this.ssclient,true);
         this._otherUserNest = new Nest(this,this.ssclient,false);
         this.loadLocDefs("/binConfig/getFile/" + VersionHandler.locDefVersion + "/" + VersionHandler.cluster + "/locationDefinitions.xml",this.locDefsLoaded);
      }
      
      private function loadLocDefs(param1:String, param2:Function) : void
      {
         var $urlRequest:URLRequest;
         var $urlLoader:URLLoader;
         var $defFilePath:String = param1;
         var $completionHandler:Function = param2;
         this.showLoader(null,"loading bin...",false,false);
         $urlRequest = new URLRequest();
         $urlLoader = new URLLoader();
         $urlRequest.url = $defFilePath;
         $urlLoader.addEventListener(Event.COMPLETE,$completionHandler);
         try
         {
            $urlLoader.load($urlRequest);
         }
         catch(error:Error)
         {
         }
      }
      
      private function locDefsLoaded(param1:Event) : void
      {
         var _loc2_:XML = new XML(param1.target.data);
         this.initLocs(_loc2_);
         this.loadLocDefs("/binConfig/getFile/" + VersionHandler.nestDefVersion + "/" + VersionHandler.cluster + "/nestLocDefs.xml",this.nestLocDefsLoaded);
      }
      
      private function nestLocDefsLoaded(param1:Event) : void
      {
         this.nestLocDefs_XML = new XML(param1.target.data);
         this.initLocs(this.nestLocDefs_XML);
         this.initLocs(this.nestLocDefs_XML,true);
         this.getScaledWeevilsList();
      }
      
      private function getScaledWeevilsList() : void
      {
         var _loc1_:PHP2call = new PHP2call("login/getScaledWeevils");
         _loc1_.sendAndAwaitResponse([],[],this.scaledWeevilsReceived,false,true);
      }
      
      private function scaledWeevilsReceived(param1:Object, param2:Event) : void
      {
         var _loc3_:int = int(param1.responseCode);
         switch(_loc3_)
         {
            case 1:
               this.bigWeevilsList = new ScaledWeevilsList(param1.big);
               this.smallWeevilsList = new ScaledWeevilsList(param1.small);
               break;
            case 999:
               this.showAlertBox("ERROR 999: Scaled Weevils",true);
               break;
            default:
               this.showAlertBox("ERROR:" + _loc3_ + " scaled weevils",true);
         }
         this.getWeevilStats();
      }
      
      private function getWeevilStats() : void
      {
         this.barredSo = SharedObject.getLocal("bw-li=sasdasd9283412o3ni423li4jn12l3kn4");
         var _loc1_:String = this.barredSo.data.ky;
         if(_loc1_ == null)
         {
            _loc1_ = "0";
         }
         if(_loc1_.length == 0)
         {
            _loc1_ = "0";
         }
         var _loc2_:PHPcall = new PHPcall("nest/get-weevil-stats",true);
         _loc2_.sendAndAwaitResponse(["idx","key"],[this.myUserIDX,_loc1_],this.myWeevilStatsReceived,true);
      }
      
      private function myWeevilStatsReceived(param1:Object) : void
      {
         var _loc12_:int = 0;
         var _loc2_:int = int(param1.level);
         var _loc3_:int = int(param1.xp);
         var _loc4_:int = int(param1.xp1);
         var _loc5_:int = int(param1.xp2);
         var _loc6_:int = int(param1.mulch);
         var _loc7_:int = int(param1.dosh);
         var _loc8_:int = int(param1.food);
         var _loc9_:int = int(param1.age);
         var _loc10_:String = param1.sex;
         var _loc11_:int = int(param1.newsVersion);
         if(!isNaN(param1.cs))
         {
            _loc12_ = int(param1.cs);
         }
         var _loc13_:String = param1.key;
         this._accountActivated = param1.activated == "1";
         this._daysRemaining = int(param1.daysRemaining);
         this._hasEmail = param1.email == "1";
         if(param1.displayActivation == "1")
         {
            this._displayActivation = true;
         }
         var _loc14_:int = int(param1.st);
         var _loc15_:String = param1.hash;
         var _loc16_:String = Rssmv.o_2([_loc2_,_loc6_,_loc7_,_loc3_,_loc4_,_loc5_,_loc8_,_loc9_,_loc10_,param1.activated,this._daysRemaining,_loc12_,_loc13_,param1.displayActivation,param1.email,_loc11_,_loc14_]);
         if(_loc16_ == _loc15_)
         {
            if(_loc13_ != null && _loc13_ != "")
            {
               this.storeSilencedKey(_loc13_);
            }
            this.UI.setWeevilStats(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc11_);
            if(_loc12_ != 0)
            {
               this.UI.silence(_loc12_);
            }
            this.getTreasureHunt();
         }
         if(_loc2_ >= 4)
         {
            if(this.accountActivated)
            {
               this.userUpdateTimer.start();
            }
         }
         this.UI.getBuddyList();
         this.swrveManager.start(this);
         var _loc17_:Object = {
            "location":this._locale,
            "xp":_loc3_,
            "level":_loc2_,
            "tycoon":(this._tycoon ? 1 : 0),
            "dosh":_loc7_,
            "mulch":_loc6_
         };
         if(_loc9_ > 0)
         {
            _loc17_.age = _loc9_;
         }
         if(_loc10_ != null && _loc10_.length > 0)
         {
            _loc17_.gender = _loc10_;
         }
         this.swrveManager.api.user(_loc17_);
      }
      
      public function storeSilencedKey(param1:String) : void
      {
         this.barredSo.data.ky = param1;
      }
      
      private function getTreasureHunt() : void
      {
         var loader:URLLoader;
         var request:URLRequest = new URLRequest();
         request.url = URLhandler.servicesLocation + "php/getTreasureHunt.php?rndVar=" + Math.random();
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.VARIABLES;
         loader.addEventListener(Event.COMPLETE,this.treasureHuntReceived);
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
         }
      }
      
      private function treasureHuntReceived(param1:Event) : void
      {
         var _loc4_:XML = null;
         var _loc5_:String = null;
         var _loc2_:Object = param1.target.data;
         var _loc3_:int = int(_loc2_.count);
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_)
         {
            _loc4_ = <preRend3D/>;
            _loc5_ = "_" + String(_loc6_);
            _loc4_.@path = _loc2_["path" + _loc5_];
            _loc4_.@extUIData = _loc2_["extUIData" + _loc5_];
            _loc4_.@boundary = _loc2_["boundary" + _loc5_];
            _loc4_.@x = _loc2_["x" + _loc5_];
            _loc4_.@y = _loc2_["y" + _loc5_];
            _loc4_.@z = _loc2_["z" + _loc5_];
            _loc4_.@scale = _loc2_["scale" + _loc5_];
            _loc4_.@ry = _loc2_["ry" + _loc5_];
            _loc4_.@rxMin = _loc2_["rxMin" + _loc5_];
            _loc4_.@rxMax = _loc2_["rxMax" + _loc5_];
            _loc4_.@ryMin = "0";
            _loc4_.@ryMax = "360";
            _loc4_.@framesY = _loc2_["framesY" + _loc5_];
            _loc4_.@symAxes = _loc2_["symAxes" + _loc5_];
            _loc4_.@rIncr = _loc2_["rIncr" + _loc5_];
            this.getLocById(_loc2_["locID" + _loc5_]).addAssetInfo(_loc4_);
            _loc6_++;
         }
         this.getQuestData();
      }
      
      private function getQuestData() : void
      {
         var _loc1_:PHPcall = new PHPcall("quests/get-quest-data",true);
         _loc1_.awaitResponse(this.questDataReceived);
      }
      
      private function questDataReceived(param1:Object) : void
      {
         var _loc4_:XMLList = null;
         var _loc5_:XML = null;
         var _loc2_:String = param1.tasks;
         QuestControl.setCompletedTasks(_loc2_);
         var _loc3_:String = param1.itemList;
         if(_loc3_.length > 0)
         {
            _loc4_ = XMLList(_loc3_);
            for each(_loc5_ in _loc4_)
            {
               this.addItemToLoc(_loc5_.@locID,_loc5_);
            }
         }
         this.getMyPets();
         this.newUserProgressManager.checkTasksCompleted();
      }
      
      public function getMyPets() : void
      {
         var _loc1_:PHP2call = new PHP2call("pets/getUserPets");
         _loc1_.sendAndAwaitResponse(["idx"],[this.myUserIDX],this.myPetDataReceived,true,true);
      }
      
      private function myPetDataReceived(param1:Object, param2:Event) : void
      {
         var _loc3_:int = 0;
         switch(param1.responseCode)
         {
            case 1:
               _loc3_ = 0;
               while(_loc3_ < param1.pets.length)
               {
                  this.addMyPet(param1.pets[_loc3_]);
                  _loc3_++;
               }
               break;
            case 2:
               this.hasPetInHotel = true;
               break;
            case 3:
               break;
            case 4:
               this.hasUsedPetForADay = true;
               break;
            case 999:
               this.showAlertBox("Error 999 getting pets.");
         }
         this.getSpecialMoves();
      }
      
      private function addMyPet(param1:Object) : void
      {
         var _loc2_:Pet = null;
         var _loc3_:Object = new Object();
         _loc3_.bc = param1.bc;
         _loc3_.ac1 = param1.ac1;
         _loc3_.ac2 = param1.ac2;
         _loc3_.ec1 = param1.ec1;
         _loc3_.ec2 = param1.ec2;
         var _loc4_:Number = -180 + 360 * Math.random();
         _loc2_ = this.petFactory.createPet(param1.id,param1.name,this.myWeevil,0,3.5,-200,_loc4_,_loc3_,true);
         _loc2_.setStats(param1.bedID,param1.bowlID,param1.fuel,param1.mentalEnergy,param1.health,param1.fitness,param1.experience);
         _loc2_.nameHash = param1.nameHash;
         if(int(param1.rented) == 1)
         {
            _loc2_.isRental = true;
         }
         this.myPets.push(_loc2_);
         _loc2_.getSkills();
      }
      
      public function getPetCount() : int
      {
         return this.myPets.length;
      }
      
      private function getSpecialMoves() : void
      {
         var request:URLRequest;
         var loader:URLLoader;
         var variables:URLVariables = new URLVariables();
         variables.userID = this.myUserName;
         request = new URLRequest();
         request.url = URLhandler.servicesLocation + "php/getSpecialMoves.php?rndVar=" + Math.random();
         request.method = URLRequestMethod.POST;
         request.data = variables;
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.VARIABLES;
         loader.addEventListener(Event.COMPLETE,this.specialMovesReceived);
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
         }
      }
      
      private function specialMovesReceived(param1:Event) : void
      {
         var _loc2_:String = param1.target.data.result;
         this.UI.setAcquiredMoves(_loc2_);
         this.getMyLottoTicketsAndNextDrawDate();
      }
      
      private function getMyLottoTicketsAndNextDrawDate() : void
      {
         var _loc1_:PHPcall = new PHPcall("getMyLottoTicketsAndDrawDate");
         _loc1_.awaitResponse(this.myTicketsAndDrawDateReceived);
      }
      
      private function myTicketsAndDrawDateReceived(param1:Object) : void
      {
         LottoData.alreadyGotTicket = param1.gotTicket == "1" ? true : false;
         LottoData.setTickets(param1.tickets);
         LottoData.nextDrawID = param1.drawID;
         LottoData.nextDrawDate = param1.nextDraw;
         this.loadOnLoginServerUnixTime();
      }
      
      private function loadOnLoginServerUnixTime() : void
      {
         var _loc1_:PHPcall = new PHPcall("site/server-time",true);
         _loc1_.awaitResponse(this.onLoginServerUnixTimeLoaded);
      }
      
      private function onLoginServerUnixTimeLoaded(param1:URLVariables) : void
      {
         this.onLoginServerUnixTime = Number(param1.t);
         this.getExtraFunctionalitySWF();
      }
      
      private function getExtraFunctionalitySWF() : void
      {
         this.challengesManager = new Object();
         this.funFairManager = new Object();
         var _loc1_:String = URLhandler.getPath("extraFunctionality");
         URLhandler.loadFromCDN(new Loader(),_loc1_,this.onExtraFunctionalitySWFLoaded);
      }
      
      private function onExtraFunctionalitySWFLoaded(param1:Event) : void
      {
         var _loc2_:Loader = Loader(param1.target.loader);
         var _loc3_:MovieClip = MovieClip(_loc2_.content);
         _loc3_.init();
         this.checkNewUsers();
      }
      
      private function checkNewUsers() : void
      {
         var _loc3_:Number = NaN;
         this.showControls(false);
         this.fullyInitialised = true;
         var _loc1_:Array = [NewUserProgressManager.DECORATE_NEST_TASK,NewUserProgressManager.PLAY_GAME_TASK,NewUserProgressManager.BUY_NEST_ITEM_TASK,NewUserProgressManager.PLANT_SEED_TASK,NewUserProgressManager.FEED_WEEVIL_TASK,NewUserProgressManager.STAMP_YOUR_BIN_CARD_TASK,NewUserProgressManager.HARVEST_PLANT_TASK,NewUserProgressManager.COMPLETED_TUTORIAL_TASK];
         if(QuestControl.areAnyTasksComplete(_loc1_))
         {
            QuestControl.taskCompleted2(NewUserProgressManager.DISMISS_LEVEL3);
            QuestControl.taskCompleted2(NewUserProgressManager.COLECTED_MULCH_TASK);
            this.unlockUIButtons();
         }
         var _loc2_:Boolean = this.newUserProgressManager.isActive;
         if(_loc2_)
         {
            this.loadNewUserAssets();
         }
         else
         {
            _loc3_ = NewUserProgressManager.WATCH_STORY_INTRO;
            if(QuestControl.isTaskComplete(_loc3_))
            {
               this.initComplete();
            }
            else
            {
               this.loadInterface({"path":URLhandler.getPath("gameIntroExistingPlayer")});
            }
         }
      }
      
      private function loadNewUserAssets() : void
      {
         this.newUserProgressManager.loadContents(this.newUserAssetsLoaded);
      }
      
      private function newUserAssetsLoaded() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:Boolean = this.newUserProgressManager.isFirstLogin;
         if(_loc1_)
         {
            this.loadInterface({"path":URLhandler.getPath("gameIntroNewPlayer")});
         }
         else
         {
            _loc2_ = NewUserProgressManager.WATCH_STORY_INTRO;
            if(!QuestControl.isTaskComplete(_loc2_))
            {
               this.loadInterface({"path":URLhandler.getPath("gameIntroExistingPlayer")});
            }
            else
            {
               this.initComplete();
            }
         }
      }
      
      public function initComplete() : void
      {
         this.showControls(false);
         this.fullyInitialised = true;
         if(QuestControl.isTaskComplete(NewUserProgressManager.DISMISS_LEVEL3) || QuestControl.isTaskComplete(NewUserProgressManager.UNLOCKED_NEST) || QuestControl.isTaskComplete(NewUserProgressManager.COMPLETED_TUTORIAL_TASK) || QuestControl.isTaskComplete(NewUserProgressManager.COLECTED_MULCH_TASK))
         {
            this.gotoNest();
         }
         else if(QuestControl.isTaskComplete(NewUserProgressManager.EXIT_WEEVIL_CHANGER) || Boolean(QuestControl.taskCompleted2(NewUserProgressManager.WATCH_STORY_INTRO)))
         {
            this.loadLoc(115);
         }
         else
         {
            this.loadInterface({"path":URLhandler.getPath("weevilChanger")});
         }
         QuestControl.taskCompleted2(NewUserProgressManager.WATCH_STORY_INTRO);
         this.initiateBinBadges();
      }
      
      public function unlockUIButtons() : void
      {
         this.UI.unlockUIButtons();
      }
      
      public function lockUIButtons() : void
      {
         this.UI.lockUIButtons();
      }
      
      public function initCompleteFirstLogin() : void
      {
         this.showControls(false);
         this.fullyInitialised = true;
         QuestControl.taskCompleted2(NewUserProgressManager.WATCH_STORY_INTRO);
         QuestControl.taskCompleted2(NewUserProgressManager.LOGIN_TASK);
         this.initiateBinBadges();
         this.loadInterface({"path":URLhandler.getPath("weevilChanger")});
      }
      
      public function initiateBinBadges() : void
      {
         this._UI.startBinBadges();
      }
      
      public function updateMyWeevil(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         this._myUserObj.weevilDef = param1;
         if(param2)
         {
            _loc3_ = int(this.weevils.indexOf(this._myWeevil));
            this.crntLoc.removeWeevil(this._myWeevil);
            this.weevils.splice(_loc3_,1);
            this._myWeevil = this.weevilFactory.createWeevil(this.myUserID,this.myUserName,this._myWeevil.x,this._myWeevil.y,this._myWeevil.z,0,this._myUserObj);
            this.crntLoc.addWeevil(this._myWeevil);
            this.weevils.push(this._myWeevil);
         }
         else
         {
            this._myWeevil = this.weevilFactory.createWeevil(this.myUserID,this.myUserName,0,0,380,180,this._myUserObj);
         }
         this.myWeevil.thisIsMine();
         this.myWeevil.set_bin(this);
         InteractiveObject(this.myWeevil.getCreatureDO()).addEventListener(MouseEvent.CLICK,this.UI.showMyProfile);
         this.ssclient.changeWeevilDef(param1);
      }
      
      public function dealWithRegMsgDisplay() : void
      {
      }
      
      public function gotoRegOffice(param1:MouseEvent = null) : void
      {
         this.hideDialogueBox();
         this.loadInterface({
            "path":"externalUIs/Register2.swf",
            "limbo":true
         });
      }
      
      public function showActivateAccountOverlay() : void
      {
         this.showAlertBox("ERROR looking for account activation.");
      }
      
      public function addItemToLoc(param1:int, param2:XML) : void
      {
         var _loc3_:Loc = this.getLocById(param1);
         _loc3_.addAssetInfo(param2);
      }
      
      public function removeItemFromLoc(param1:int = -1, param2:int = -1) : void
      {
         var _loc3_:Loc = null;
         if(param1 == -1)
         {
            _loc3_ = this.crntLoc;
         }
         else
         {
            _loc3_ = this.getLocById(param1);
         }
         _loc3_.removeVisual(param2);
      }
      
      private function newJugglingTrickReceived(param1:Array) : void
      {
         var _loc2_:int = int(param1[3]);
         var _loc3_:Array = param1[4].split(";");
         this.getMyPetByID(_loc2_).newJugglingTrickReceived(_loc3_);
      }
      
      public function showUI(param1:Boolean) : void
      {
         this.UI.vis = param1;
      }
      
      public function showControls(param1:Boolean) : void
      {
         this.UI.showControls(param1);
      }
      
      public function showMapBtn(param1:Boolean) : void
      {
      }
      
      public function levelOverlayClosed() : void
      {
         switch(this.myLevel)
         {
            case 2:
               QuestControl.taskCompleted2(NewUserProgressManager.DISMISS_LEVEL2);
               this.unlockUIButtons();
               EventManager.get_instance().dispatchEvent(new Event("showNestTutorial"));
               break;
            case 3:
               QuestControl.taskCompleted2(NewUserProgressManager.DISMISS_LEVEL3);
               this.unlockUIButtons();
               EventManager.get_instance().dispatchEvent(new Event("showNestTutorial"));
               this.newUserProgressManager.enableTutorial();
               this.newUserProgressManager.completeTask(NewUserProgressManager.DECORATE_NEST_TASK);
         }
      }
      
      public function disableTutorial() : void
      {
         this.newUserProgressManager.disableTutorial();
      }
      
      public function unlockNest() : void
      {
         QuestControl.taskCompleted2(NewUserProgressManager.UNLOCKED_NEST);
         this.unlockUIButtons();
      }
      
      public function gotoNest() : void
      {
         var _loc1_:Array = null;
         this.inOtherUserNest = false;
         if(!this.inNest)
         {
            this.showLoader(null,"loading nest...",false,false);
            this.closeGame();
            _loc1_ = new Array();
            _loc1_["locName"] = "at home";
            this.ssclient.setBuddyVariables(_loc1_);
            this._nest.getConfig(this.myUserName);
         }
         else
         {
            this.closeExternalInterface(0);
            if(this.crntLocID >= 50)
            {
               this.loadLoc(5);
            }
         }
      }
      
      public function checkForLevelUp() : void
      {
         this.UI.checkForLevelUp();
      }
      
      public function startUserSession() : void
      {
         SessionStarter.startUserSession(this._myUserIDX,this._myUserName,this._nest.id,this.tycoon);
      }
      
      public function visitOtherWeevilNest(param1:String) : void
      {
         var _loc2_:Array = null;
         if(param1 != this.hostWeevilName || this._inOtherUserNest == false)
         {
            this.disableControls();
            this.renderTimer.stop();
            this.inNest = false;
            if(this._inOtherUserNest)
            {
               this.ssclient.guestJoinedNest(this.hostWeevilName,0);
            }
            this._inOtherUserNest = true;
            this.prevHostWeevilName = this.hostWeevilName;
            this.hostWeevilName = param1;
            this.otherUserNest.getConfig(this.hostWeevilName);
            _loc2_ = new Array();
            _loc2_["locName"] = "in " + this.hostWeevilName + "\'s nest";
            this.ssclient.setBuddyVariables(_loc2_);
         }
         else if(param1 == this.hostWeevilName && this.crntLocID <= -50)
         {
            this.UI.hideInvite();
            this.loadLoc(-5);
         }
      }
      
      public function attemptVisitTycoonPlaza(param1:String, param2:int) : void
      {
         if(param1 == this.myUserName)
         {
            this.gotoNest();
         }
         else if(this.ssclient.getRoomByName("nest_" + param1) == null)
         {
            this.hostTycoonToVisit = param1;
            this.hostTycoonToVisitIDX = param2;
            this.roomListClient = "tycoonPlaza";
            this.ssclient.getRoomList();
         }
         else
         {
            this.gotoTycoonPlaza(param1,param2);
         }
      }
      
      private function onRoomListUpdate(param1:SFSEvent) : void
      {
         if(this.roomListClient == "tycoonPlaza")
         {
            this.roomListClient = null;
            this.gotoTycoonPlaza(this.hostTycoonToVisit,this.hostTycoonToVisitIDX);
         }
      }
      
      private function gotoTycoonPlaza(param1:String, param2:int) : void
      {
         var _loc3_:Array = null;
         if(param1 != this.hostWeevilName || this._inOtherUserNest == false)
         {
            this.disableControls();
            this.renderTimer.stop();
            this.inNest = false;
            if(this._inOtherUserNest)
            {
               this.ssclient.guestJoinedNest(this.hostWeevilName,0);
            }
            this._inOtherUserNest = true;
            this.prevHostWeevilName = this.hostWeevilName;
            this.hostWeevilName = param1;
            this.hostTycoonIDX = param2;
            this.otherUserNest.getConfig(param1,true);
            _loc3_ = new Array();
            _loc3_["locName"] = "at " + this.hostWeevilName + "\'s plaza";
         }
         else if(param1 == this.hostWeevilName && this.crntLocID > -50)
         {
            this.loadLoc(-50);
         }
      }
      
      public function sendBusinesses(param1:String) : void
      {
         this.ssclient.sendBusinesses(param1);
      }
      
      public function evictCustomers() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc1_:String = "";
         for(_loc2_ in this.weevils)
         {
            if(this.weevils[_loc2_] != this.myWeevil)
            {
               _loc3_ = int(this.weevils[_loc2_].crntLocID);
               if(_loc3_ >= 50 && _loc3_ < 100)
               {
                  if(_loc1_.length > 0)
                  {
                     _loc1_ += MessageProtocol.SEPARATOR_LEVEL_1;
                  }
                  _loc1_ += this.weevils[_loc2_].name;
               }
            }
         }
         if(_loc1_.length > 0)
         {
            this.ssclient.evictUsersFromMyNest(_loc1_);
         }
      }
      
      public function getHostWeevilName() : String
      {
         return this.hostWeevilName;
      }
      
      public function getHostTycoonIDX() : int
      {
         return this.hostTycoonIDX;
      }
      
      public function set inOtherUserNest(param1:Boolean) : void
      {
         if(this._inOtherUserNest != param1)
         {
            this._inOtherUserNest = param1;
            if(param1 == false)
            {
               this.ssclient.guestJoinedNest(this.hostWeevilName,0);
            }
         }
      }
      
      private function removeNestInvite(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         if(this.UI != null)
         {
            this.UI.removeInvite(_loc2_);
         }
      }
      
      private function returnToNest_received(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         this.exitHostNest(_loc2_);
      }
      
      public function exitHostNest(param1:String) : void
      {
         if(this.ssclient.crntRoom == "nest_" + param1)
         {
            this.gotoNest();
            this.showAlertBox("You have been returned to your nest.");
         }
      }
      
      private function guestInNest(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         var _loc3_:Boolean = param1[3] == "1" ? true : false;
         this.UI.guestInNest(_loc2_,_loc3_);
         if(this.inNest)
         {
            this.broadcastMoves = true;
         }
      }
      
      public function myNestReady(param1:Boolean = false) : void
      {
         var _loc2_:Pet = null;
         var _loc3_:Object = null;
         for each(_loc2_ in this.myPets)
         {
            if(_loc2_.loc == null)
            {
               _loc3_ = this.nest.getPetBedLoc(_loc2_.bedID);
               if(_loc3_ == null)
               {
                  _loc2_.x = 50;
                  _loc2_.z = 160;
                  this.getLocById(5).addPet(_loc2_);
               }
               else
               {
                  _loc2_.rotY = 0;
                  this.getLocById(_loc3_.locID).addPet(_loc2_);
                  _loc2_.x = _loc3_.x;
                  _loc2_.z = _loc3_.z;
                  _loc2_.act(PetBehaviours.SLEEP);
               }
               this.pets.push(_loc2_);
               _loc2_.activate();
            }
         }
         if(this.defaultLocID != 5)
         {
            this.loadLoc(this.defaultLocID,this.defaultDoorID);
         }
         else if(param1)
         {
            this.loadLoc(50);
         }
         else
         {
            this.loadLoc(5);
         }
         this.defaultLocID = 5;
      }
      
      public function joinWeevilWheels() : void
      {
         this.stopRendering();
         this.ssclient.joinRoom("WeevilWheels");
         this.UI.set_mode(6);
      }
      
      public function createScreenSnapshot() : void
      {
         var bmpData:BitmapData = new BitmapData(825,490);
         try
         {
            bmpData.draw(STAGE,new Matrix(1,0,0,1,-104,-12),null,null,new Rectangle(0,0,825,490));
            this.screenSnapshot = new Bitmap();
            this.screenSnapshot.bitmapData = bmpData;
         }
         catch(e:ArgumentError)
         {
         }
      }
      
      private function cleanUpLoc(param1:String) : void
      {
         EventManager.get_instance().dispatchEvent(new Event("questHelpBox_Hide"));
         if(this.crntLoc != null)
         {
            this.crntLoc.hideIt();
            if(this.crntLocName != param1)
            {
               this.removeAllWeevils();
               this.removeOtherPets();
            }
            else
            {
               this.removeWeevil(this.crntLocID,this.myWeevil.id);
            }
            this.myWeevil.stopActions();
         }
      }
      
      public function loadLoc(param1:int, param2:int = 0) : void
      {
         var _loc3_:Loc = null;
         var _loc4_:String = null;
         var _loc5_:Pet = null;
         this.eventManager.dispatchEvent(new CustomEvent(BinEvents.LOAD_LOCATION,{
            "locID":param1,
            "entryDoorID":param2
         }));
         this.UI.hideHint();
         this.newUserProgressManager.loadingNewLocation();
         if(param1 != this.crntLocID || this.hostWeevilName != this.prevHostWeevilName)
         {
            this.renderTimer.stop();
            this.createScreenSnapshot();
            this.UI.clearChatBox();
            this.UI.set_mode(7);
            this.closeExternalInterface();
            this.closeGame();
            if(param1 != this.WEEVILWHEELS_LOCID)
            {
               this.closeBigGameLoader();
               this.closeBigGame();
            }
            this.closeOverlayUI();
            this.hideWeevilProfile();
            this.hidePetProfile();
            this.UI.hideChatLog();
            this.UI.hideLists();
            this.disableControls();
            this.myWeevil.vis = false;
            this.myWeevil.mask = null;
            this.myWeevil.kart = null;
            _loc3_ = this.getLocById(param1);
            _loc4_ = "";
            if(_loc3_ != null)
            {
               _loc4_ = _loc3_.name;
               if(_loc3_.type == 1 || _loc3_.noZoom)
               {
                  viewPort.zoomOut();
               }
               else
               {
                  viewPort.zoomIn();
               }
            }
            this.cleanUpLoc(_loc4_);
            this.crntLocID = param1;
            this.myPetsDormant(true);
            if(param1 == this.WEEVILWHEELS_LOCID)
            {
               for each(_loc5_ in this.myPets)
               {
                  if(!_loc5_.ridingOwner && _loc5_.loc.name != "nest")
                  {
                     this.petGoHome(_loc5_);
                  }
               }
               this.joinWeevilWheels();
            }
            else
            {
               this.crntLoc = _loc3_;
               if(this.crntLoc.type == 1)
               {
                  ViewPort.d = 800;
               }
               else if(this.crntLoc.id == 20 || this.crntLoc.id == -20)
               {
                  ViewPort.d = 2000;
               }
               else
               {
                  ViewPort.d = 600;
               }
               this.crntLocName = this.crntLoc.name;
               this.myWeevil.setCrntLoc(this.crntLoc);
               for each(_loc5_ in this.myPets)
               {
                  if(_loc5_.loc.name != "nest" && _loc5_.loc.name != this.crntLoc.name)
                  {
                     _loc5_.rideOwner();
                  }
               }
               this.weevilSpeed = this.crntLoc.get_weevilSpeed();
               this.crntLoc.loadLoc(param2);
            }
         }
         else
         {
            this.closeExternalInterface(this.UI.crntMode);
         }
         if(param1 == 5)
         {
            this.UI.tryToShowVideoAds();
         }
         else
         {
            this.UI.hideVideoAds();
         }
         if(param1 == 5)
         {
            this.UI.tryToShowVideoAds();
         }
         else
         {
            this.UI.hideVideoAds();
         }
      }
      
      public function clearInterface(param1:*) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.loadedInterfaces.length)
         {
            if(this.loadedInterfaces[_loc2_].path == param1 && this.loadedInterfaces[_loc2_].loadedContent != null)
            {
               this.loadedInterfaces.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function clearLocById(param1:int) : Boolean
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.locs)
         {
            if(this.locs[_loc2_].id == param1)
            {
               this.locs[_loc2_].clearLoc();
               return true;
            }
         }
         return false;
      }
      
      public function getLocById(param1:int) : Loc
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.locs)
         {
            if(this.locs[_loc2_].id == param1)
            {
               return this.locs[_loc2_];
            }
         }
         return null;
      }
      
      public function getNestLocByInstanceID(param1:int) : LocNest
      {
         return this.nest.getLocByInstanceID(param1);
      }
      
      public function isNestItemInRoom(param1:*) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this.itemsInRoom.length)
         {
            if(this.itemsInRoom[_loc3_] == param1)
            {
               _loc2_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function locLoaded(param1:Loc) : void
      {
         var _loc2_:String = "";
         if(param1.id == 5 || param1.id == -5)
         {
            _loc2_ = "/lobby";
         }
         GoogleAnalytics.trackUser(param1.name + _loc2_);
         this.showControls(true);
         this.vx = this.vy = this.vz = this.wv = 0;
         this.aimY = 15;
         this.revertCamMode = this.camMode;
         this.resetBinCam();
         this.myWeevil.defaultPose();
         if(param1.name == "nest")
         {
            this.itemsInRoom = LocNest(param1).itemsInRoom;
            if(!this.inNest)
            {
               this.ssclient.joinRoom(this.myNestName,0,0,150,0,0,5);
            }
            else
            {
               this.crntLoc.enterLoc(this.myWeevil);
               this.weevils.push(this.myWeevil);
               this.startRendering();
               this.crntLoc.displayIt(viewPort.display_spr);
               if(this.myWeevil.teleporting)
               {
                  this.myWeevilAct(29);
               }
               this.hideLoader();
            }
            this.ssclient.joinNestLoc(-param1.id,param1.myEntryDoorID,this.crntLoc.getMyEntryX(true),this.crntLoc.myEntryY,this.crntLoc.getMyEntryZ(true),this.myWeevil.rotY);
            this.inNest = true;
            this.broadcastMoves = true;
         }
         else
         {
            this.broadcastMoves = true;
            this.inNest = false;
            switch(this.crntLoc.type)
            {
               case 1:
                  this.UI.set_mode(2);
                  param1.loadOtherAngles();
                  break;
               case 2:
                  this.UI.set_mode(4);
            }
            if(param1.name != this.ssclient.crntRoom)
            {
               this.ssclient.joinRoom(param1.name,this.crntLoc.getMyEntryX(),this.crntLoc.myEntryY,this.crntLoc.getMyEntryZ(),this.crntLoc.myEntryDir,this.crntLoc.myEntryDoorID,this.crntLoc.id);
               if(this._inOtherUserNest && this.crntLocID == -5)
               {
                  this.UI.hideInvite();
                  this.ssclient.guestJoinedNest(this.hostWeevilName,1);
               }
            }
            else if(!this.UI.invitationValid(this.hostWeevilName) && param1.id > -50)
            {
               this.gotoNest();
            }
            else
            {
               if(param1.myEntryDoorID == 0)
               {
                  this.ssclient.guestJoinedNest(this.hostWeevilName,1);
               }
               this.ssclient.joinNestLoc(param1.id,param1.myEntryDoorID,this.crntLoc.getMyEntryX(true),this.crntLoc.myEntryY,this.crntLoc.getMyEntryZ(true),this.myWeevil.rotY);
               this.crntLoc.enterLoc(this.myWeevil);
               this.weevils.push(this.myWeevil);
               this.crntLoc.displayIt(viewPort.display_spr);
               if(this.myWeevil.teleporting)
               {
                  this.myWeevilAct(29);
               }
               this.startRendering();
               this.hideLoader();
            }
         }
         this.newUserProgressManager.newLocationLoaded(param1.id,param1.name);
      }
      
      public function resetBinCam(param1:Boolean = false) : void
      {
         this.camMode = 0;
         if(param1)
         {
            this.revertCamMode = 0;
         }
         this.initCam(this.crntLoc.get_camInit());
         if(this.crntLoc.camMode == 2)
         {
            this.UI.set_mode(2);
            this.camMode = 2;
         }
         this.crntLoc.render(this.cam);
      }
      
      public function closeUpCam() : void
      {
         this.camMode = this.revertCamMode = 0;
         this.cam.aim_triplet(this.myWeevil.x,this.aimY,this.myWeevil.z);
         var _loc1_:Number = this.cam.x - this.myWeevil.x;
         var _loc2_:Number = this.cam.y - this.aimY;
         var _loc3_:Number = this.cam.z - this.myWeevil.z;
         var _loc4_:* = Math.sqrt(_loc1_ * _loc1_ + _loc2_ * _loc2_ + _loc3_ * _loc3_);
         this.cam.move_forward(_loc4_ - 140);
         this.crntLoc.render(this.cam);
      }
      
      public function userSetCamMode(param1:uint) : void
      {
         this.camMode = this.revertCamMode = param1;
      }
      
      public function getCamMode() : uint
      {
         return this.camMode;
      }
      
      public function turnOffWeevilCam() : void
      {
         if(this.camMode == 2)
         {
            this.revertCamMode = this.camMode = 0;
         }
      }
      
      public function locAnglesLoaded(param1:Loc) : void
      {
         if(this.crntLoc.camMode == 0)
         {
            this.camMode = this.revertCamMode;
            this._UIresetMode = 3;
            if(param1 == this.crntLoc && this.UI.crntMode != 5)
            {
               this.UI.set_mode(3);
            }
         }
      }
      
      public function get_crntLoc() : Loc
      {
         return this.crntLoc;
      }
      
      private function initCam(param1:Object) : void
      {
         this.cam.set_coords(param1.camX,param1.camY,param1.camZ);
         if(this.crntLoc.type == 1)
         {
            this.cam.set_bounds(param1.xMin,param1.yMin,param1.zMin,param1.xMax,param1.yMax,param1.zMax,param1.radBound,param1.x0,param1.z0,param1.rad);
         }
         this.cam.aim_triplet(param1.aimX,param1.aimY,param1.aimZ);
      }
      
      public function disableControls() : void
      {
         if(this.floorClickArea != null)
         {
            try
            {
               this.floorClickArea.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            }
            catch(e:ArgumentError)
            {
            }
         }
         try
         {
            STAGE.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         }
         catch(e:ArgumentError)
         {
         }
         this.myWeevil.shadow_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this.myPetsDormant(true);
         _controlsEnabled = false;
         this.UI.hideMapBtnGlow();
      }
      
      public function enableControls() : void
      {
         if(!_controlsEnabled && this.crntLoc != null)
         {
            this.floorClickArea = this.crntLoc.getClickable();
            if(!this.crntLoc.maintainY)
            {
               if(this.crntLoc.clickAnywhere)
               {
                  STAGE.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
               }
               else
               {
                  this.floorClickArea.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
               }
               this.myWeevil.shadow_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            }
            this.myPetsDormant(false);
            _controlsEnabled = true;
         }
      }
      
      public function get ctrlsEnabled() : Boolean
      {
         return _controlsEnabled;
      }
      
      public function getFloorClickCoords(param1:Number, param2:Number, param3:Number = 0) : Point
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Vector3D = null;
         var _loc8_:Vector3D = null;
         var _loc9_:Vector3D = null;
         var _loc10_:Matrix3x3 = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         if(viewPort.isWithin(param1,param2))
         {
            param1 = param1 - ViewPort.x0 * ViewPort.zoomFactor - ViewPort.xOffset;
            param2 = param2 - ViewPort.y0 * ViewPort.zoomFactor - ViewPort.yOffset;
            param1 /= ViewPort.zoomFactor;
            param2 /= ViewPort.zoomFactor;
            _loc4_ = ViewPort.d;
            _loc5_ = Math.atan2(param2,_loc4_);
            _loc6_ = Math.atan2(param1,_loc4_);
            _loc7_ = this.cam.side;
            _loc8_ = this.cam.up;
            _loc9_ = this.cam.out;
            _loc10_ = new Matrix3x3();
            _loc10_.load_rotation_axis(_loc8_,Math.sin(_loc6_),Math.cos(_loc6_));
            _loc7_ = _loc10_.vectorMult(_loc7_);
            _loc9_ = _loc10_.vectorMult(_loc9_);
            _loc10_.load_rotation_axis(_loc7_,Math.sin(_loc5_),Math.cos(_loc5_));
            _loc8_ = _loc10_.vectorMult(_loc8_);
            _loc9_ = _loc10_.vectorMult(_loc9_);
            if(_loc9_.y < 0)
            {
               _loc11_ = (this.cam.y - param3) / -_loc9_.y;
               _loc12_ = _loc11_ * _loc9_.x;
               _loc13_ = _loc11_ * _loc9_.z;
               _loc14_ = int(this.cam.x + _loc12_);
               _loc15_ = int(this.cam.z + _loc13_);
               return new Point(_loc14_,_loc15_);
            }
            return null;
         }
         return null;
      }
      
      public function getRange(param1:MouseEvent) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Point = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:* = undefined;
         var _loc2_:Point = this.getFloorClickCoords(param1.stageX,param1.stageY);
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.x;
            _loc4_ = _loc2_.y;
            _loc5_ = this.crntLoc.legaliseClick(_loc3_,_loc4_);
            if(_loc5_ != null)
            {
               _loc3_ = _loc5_.x;
               _loc4_ = _loc5_.y;
               _loc6_ = _loc3_ - this.myWeevil.x;
               _loc7_ = _loc4_ - this.myWeevil.z;
               _loc8_ = Math.sqrt(_loc6_ * _loc6_ + _loc7_ * _loc7_);
               return _loc8_ / this.myWeevil.scale;
            }
         }
         return -1;
      }
      
      public function mouseDownHandler(param1:MouseEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Point = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:String = null;
         var _loc11_:Number = NaN;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:Number = NaN;
         var _loc16_:Pet = null;
         var _loc17_:Boolean = false;
         var _loc2_:Point = this.getFloorClickCoords(param1.stageX,param1.stageY);
         if(this.crntLoc.upSideDown)
         {
            _loc3_ = 2 * 104 + 825 - param1.stageX;
            _loc4_ = 24 + 490 - param1.stageY;
            _loc2_ = this.getFloorClickCoords(_loc3_,_loc4_);
         }
         if(_loc2_ != null)
         {
            _loc5_ = _loc2_.x;
            _loc6_ = _loc2_.y;
            _loc7_ = this.crntLoc.legaliseClick(_loc5_,_loc6_);
            if(this.crntLoc.denyOutOfBoundsClicks)
            {
               if(_loc5_ != _loc7_.x || _loc6_ != _loc7_.y)
               {
                  _loc7_ = null;
               }
            }
            this.eventManager.dispatchEvent(new CustomEvent(BinEvents.FLOOR_CLICK,{
               "x":_loc5_,
               "z":_loc6_
            }));
            if(_loc7_ != null)
            {
               _loc8_ = _loc7_.x;
               _loc9_ = _loc7_.y;
               if(!this.crntLoc.isForbidden(_loc8_,_loc9_))
               {
                  if(this.UI.crosshairs_on)
                  {
                     if(this.UI.specialTransMove == 0)
                     {
                        this.myWeevilThrowBall(_loc8_,_loc9_);
                     }
                     else
                     {
                        _loc11_ = this.myWeevil.getDir(_loc8_,_loc9_);
                        switch(this.UI.specialTransMove)
                        {
                           case 1:
                              _loc12_ = _loc8_ - this.myWeevil.x;
                              _loc13_ = _loc9_ - this.myWeevil.z;
                              _loc14_ = Math.sqrt(_loc12_ * _loc12_ + _loc13_ * _loc13_) / this.myWeevil.scale;
                              if(_loc14_ < this.UI.maxSuperJumpRange)
                              {
                                 if(this.UI.checkEnergySufficient(1,_loc14_))
                                 {
                                    _loc10_ = int(_loc8_) + ",0," + int(_loc9_) + "," + _loc11_;
                                    this.myWeevilAct(10,0,_loc10_);
                                 }
                                 this.closeOverlayUI();
                              }
                              this.UI.specialTransMove = 0;
                              break;
                           case 2:
                              _loc12_ = _loc8_ - this.myWeevil.x;
                              _loc13_ = _loc9_ - this.myWeevil.z;
                              _loc14_ = Math.sqrt(_loc12_ * _loc12_ + _loc13_ * _loc13_) / this.myWeevil.scale;
                              if(_loc14_ < this.UI.maxSuperJumpRange)
                              {
                                 if(this.specialMoveParamStr == "" || this.specialMoveParamStr == null)
                                 {
                                    this.specialMoveParamStr = int(_loc8_) + ",0," + int(_loc9_) + "," + _loc11_;
                                 }
                                 else
                                 {
                                    this.specialMoveParamStr += "," + int(_loc8_) + "," + int(_loc9_);
                                 }
                                 if(this.UI.keepCrosshairsCount == 0)
                                 {
                                    if(this.UI.checkEnergySufficient(2))
                                    {
                                       this.myWeevilAct(22,0,this.specialMoveParamStr);
                                    }
                                    this.specialMoveParamStr = "";
                                    this.UI.specialTransMove = 0;
                                    this.closeOverlayUI();
                                 }
                              }
                              else
                              {
                                 this.specialMoveParamStr = "";
                                 this.UI.specialTransMove = 0;
                              }
                              break;
                           case 3:
                              if(this.UI.checkEnergySufficient(3))
                              {
                                 this.specialMoveParamStr = int(_loc8_) + ",0," + int(_loc9_);
                                 this.myWeevilAct(23,0,this.specialMoveParamStr);
                              }
                              this.specialMoveParamStr = "";
                              this.UI.specialTransMove = 0;
                              break;
                           case 4:
                              _loc15_ = this.weevilSpeed * Math.pow(1.75,this.UI.selectedPowerLevel);
                              this.specialMoveParamStr = int(_loc8_) + "," + int(_loc9_) + "," + _loc11_ + "," + _loc15_;
                              this.myWeevilAct(33,0,this.specialMoveParamStr);
                              this.specialMoveParamStr = "";
                              this.UI.specialTransMove = 0;
                              break;
                           case 5:
                              this.specialMoveParamStr = int(_loc8_) + "," + int(_loc9_) + "," + _loc11_ + "," + _loc15_;
                              _loc12_ = _loc8_ - this.myWeevil.x;
                              _loc13_ = _loc9_ - this.myWeevil.z;
                              this.xDest = this.myWeevil.x + _loc12_ * 0.001;
                              this.zDest = this.myWeevil.z + _loc13_ * 0.001;
                              this.moveMyWeevil(this.xDest,this.zDest,true);
                              this.UI.specialTransMove = 0;
                              break;
                           case 6:
                              _loc16_ = this.UI.getCrntPet();
                              _loc16_.goThere(this.crntLocID,_loc8_,_loc9_);
                              this.UI.specialTransMove = 0;
                        }
                     }
                  }
                  else
                  {
                     this.myWeevil.clearMoveList();
                     _loc17_ = false;
                     if(this.crntLocID < 50 && this.crntLocID != 20 && this.crntLocID != -20)
                     {
                        _loc17_ = true;
                     }
                     if(this.UI.maxSuperSpeedLevel > 0 && int(_loc8_ + 0.5) == this.xDest && int(_loc9_ + 0.5) == this.zDest)
                     {
                        _loc11_ = this.myWeevil.getDir(_loc8_,_loc9_);
                        _loc15_ = this.weevilSpeed * Math.pow(1.75,this.UI.incrSuperSpeedLevel());
                        this.specialMoveParamStr = int(_loc8_) + "," + int(_loc9_) + "," + _loc11_ + "," + _loc15_;
                        this.myWeevilAct(33,0,this.specialMoveParamStr);
                        this.specialMoveParamStr = "";
                     }
                     else
                     {
                        this.UI.resetSuperSpeedLevel();
                        this.xDest = int(_loc8_ + 0.5);
                        this.zDest = int(_loc9_ + 0.5);
                        this.moveMyWeevil(int(_loc8_ + 0.5),int(_loc9_ + 0.5),_loc17_);
                     }
                     this.closeOverlayUI();
                  }
               }
            }
         }
      }
      
      public function resetTransMoves() : void
      {
         this.specialMoveParamStr = "";
         this.xDest = this.zDest = 0;
         this.UI.resetSuperSpeedLevel();
      }
      
      public function myWeevilThrowBall(param1:Number, param2:Number) : void
      {
         this.UI.activateCrosshairs(false);
         var _loc3_:int = this.UI.getBallToThrowID();
         var _loc4_:Pet = this.UI.getCrntPet();
         var _loc5_:String = _loc4_.id + "," + _loc3_ + "," + param1 + "," + param2;
         this.myWeevil.act(11,_loc5_);
         if(this.broadcastMoves)
         {
            this.ssclient.sendAction(11,0,_loc5_);
         }
         _loc4_.setLastBallThrownByOwner(_loc3_);
      }
      
      public function setUserVar(param1:String, param2:String) : void
      {
         this.ssclient.setUserVar(param1,param2);
      }
      
      public function setUserVars(param1:Object) : void
      {
         this.ssclient.setUserVars(param1);
      }
      
      public function moveWeevil(param1:Weevil, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = param1.getDir(param2,param3);
         param1.walk(param2,param3,_loc4_,this.weevilSpeed);
      }
      
      public function weevilAct(param1:Weevil, param2:int, param3:int = 0, param4:String = "-1") : void
      {
         param1.act(param2,param4);
      }
      
      public function sendMove(param1:Number, param2:Number, param3:Number) : void
      {
         this.ssclient.sendMove(param1,param2,param3);
      }
      
      public function sendAction(param1:int, param2:int, param3:String = null) : void
      {
         this.ssclient.sendAction(param1,param2,param3);
      }
      
      public function addApparel(param1:uint, param2:String) : void
      {
         this.myWeevil.loadApparel(param1,param2);
         this.ssclient.addApparel(param1,param2);
      }
      
      public function removeApparel(param1:uint) : void
      {
         if(this.myWeevil.removeApparel(param1))
         {
            this.ssclient.removeApparel(param1);
         }
      }
      
      public function sendChatMsg(param1:String) : void
      {
         this.ssclient.sendPublicMessage(param1);
      }
      
      public function tellMyPets(param1:String) : void
      {
         var _loc2_:Pet = null;
         for each(_loc2_ in this.myPets)
         {
            if(this.inNest || _loc2_.loc.id == this.crntLocID)
            {
               _loc2_.listenToMsg(param1);
            }
         }
      }
      
      public function updateMyPets(param1:Number, param2:Number) : void
      {
         var _loc3_:Pet = null;
         for each(_loc3_ in this.myPets)
         {
            if(_loc3_.sleeping && _loc3_.loc == this.crntLoc)
            {
               if(_loc3_.inRange(param1,param2,6400))
               {
                  _loc3_.wakeUp();
               }
            }
            else
            {
               _loc3_.updateOwnerPos(this.crntLocID,param1,param2);
            }
         }
      }
      
      public function addSpecialMove(param1:int) : Boolean
      {
         return this.UI.weevilActionsUI.addAcquiredMove(param1);
      }
      
      public function loadOverlayUI(param1:String, param2:Object = null) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Loader = null;
         this.closeOverlayUI();
         GoogleAnalytics.trackUser(param1);
         for each(_loc4_ in this.loadedInterfaces)
         {
            if(_loc4_.path == param1 && _loc4_.loadedContent != null)
            {
               _loc3_ = _loc4_.loadedContent;
               _loc4_.data = param2;
               this.setOverlayUIdata(_loc3_,param2);
               break;
            }
         }
         if(_loc3_ != null)
         {
            this.openOverlayUI(_loc3_);
         }
         else
         {
            _loc5_ = {
               "path":param1,
               "loadedContent":null,
               "data":param2
            };
            this.loadedInterfaces.push(_loc5_);
            _loc6_ = new Loader();
            _loc6_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.overlayUIErrorLoading);
            _loc6_.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR,this.overlayUIErrorLoading);
            URLhandler.loadFromCDN(_loc6_,param1,this.overlayUILoaded,false);
            this.showLoader(_loc6_,"loading...",true);
         }
      }
      
      private function overlayUIErrorLoading(param1:IOErrorEvent) : void
      {
      }
      
      private function overlayUILoaded(param1:Event) : void
      {
         this.hideLoader();
         var _loc2_:MovieClip = param1.target.content;
         this.loadedInterfaces[this.loadedInterfaces.length - 1].loadedContent = _loc2_;
         this.setOverlayUIdata(_loc2_,this.loadedInterfaces[this.loadedInterfaces.length - 1].data);
         this.openOverlayUI(_loc2_);
      }
      
      private function setOverlayUIdata(param1:MovieClip, param2:Object) : void
      {
         if(param1 is OverlayUIdynamic)
         {
            if(param2 != null)
            {
               param1.setData(param2);
            }
         }
      }
      
      private function openOverlayUI(param1:MovieClip) : void
      {
         var _loc2_:String = null;
         if(this._inOtherUserNest)
         {
            _loc2_ = this.hostWeevilName;
         }
         else
         {
            _loc2_ = this.myUserName;
         }
         param1.init(_loc2_);
         this.overlayUIHolder_spr.addChild(param1);
      }
      
      public function closeOverlayUI() : void
      {
         var _loc1_:OverlayUI = null;
         var _loc2_:* = undefined;
         this.eventManager.dispatchEvent(new Event("closeOverlayUI"));
         if(this.overlayUIHolder_spr.numChildren > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.overlayUIHolder_spr.numChildren)
            {
               try
               {
                  _loc1_ = OverlayUI(this.overlayUIHolder_spr.getChildAt(0));
                  _loc1_.terminate();
               }
               catch(e:Error)
               {
               }
               this.overlayUIHolder_spr.removeChildAt(0);
               _loc2_++;
            }
         }
      }
      
      public function showAsOverlay(param1:MovieClip) : void
      {
         this.closeOverlayUI();
         this.overlayUIHolder_spr.addChild(param1);
      }
      
      public function loadGame(param1:GameSlot) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Loader = null;
         this.crntGameSlot = param1;
         var _loc2_:String = this.crntGameSlot.gamePath;
         GoogleAnalytics.trackUser(_loc2_);
         for each(_loc4_ in this.loadedInterfaces)
         {
            if(_loc4_.path == _loc2_ && _loc4_.loadedContent != null)
            {
               _loc3_ = _loc4_.loadedContent;
               break;
            }
         }
         if(_loc3_ != null)
         {
            this.openGame(_loc3_);
         }
         else
         {
            _loc5_ = {
               "path":_loc2_,
               "loadedContent":null
            };
            this.loadedInterfaces.push(_loc5_);
            _loc6_ = new Loader();
            URLhandler.loadFromCDN(_loc6_,_loc2_,this.gameLoaded,false);
            this.showLoader(_loc6_,"loading game...",true);
         }
      }
      
      private function gameLoaded(param1:Event) : void
      {
         this.hideLoader();
         var _loc2_:MovieClip = param1.target.content;
         this.loadedInterfaces[this.loadedInterfaces.length - 1].loadedContent = _loc2_;
         this.openGame(_loc2_);
      }
      
      private function openGame(param1:MovieClip) : void
      {
         var $game_mc:MovieClip = param1;
         $game_mc.init(this.ssclient,{"slot":this.crntGameSlot.slot});
         this.draggableHolder_spr.addChild($game_mc);
         this.draggableHolder_spr.x = 110;
         this.draggableHolder_spr.y = 30;
         this.dragMouseArea = this.draggableHolder_spr;
         try
         {
            if($game_mc.dragArea != null)
            {
               this.dragMouseArea = $game_mc.dragArea;
               this.dragMouseArea.buttonMode = true;
            }
         }
         catch(err:Error)
         {
            dragMouseArea = draggableHolder_spr;
         }
         this.enableDrag();
      }
      
      public function disableDrag() : void
      {
         if(this.dragMouseArea != null)
         {
            this.dragMouseArea.removeEventListener(MouseEvent.MOUSE_DOWN,this.dragUI);
            this.dragMouseArea.removeEventListener(MouseEvent.MOUSE_UP,this.stopDraggingUI);
            this._dragEnabled = false;
            this.draggableHolder_spr.stopDrag();
         }
      }
      
      public function enableDrag() : void
      {
         if(!this._dragEnabled && this.dragMouseArea != null)
         {
            this.dragMouseArea.addEventListener(MouseEvent.MOUSE_DOWN,this.dragUI);
            this.dragMouseArea.addEventListener(MouseEvent.MOUSE_UP,this.stopDraggingUI);
            this._dragEnabled = true;
         }
      }
      
      private function dragUI(param1:MouseEvent) : void
      {
         if(this._dragEnabled)
         {
            this.draggableHolder_spr.startDrag(false,new Rectangle(0,0,690,300));
         }
      }
      
      private function stopDraggingUI(param1:MouseEvent) : void
      {
         this.draggableHolder_spr.stopDrag();
      }
      
      public function assignGamePlayer(param1:int) : void
      {
         this.player = param1;
         this.disableControls();
         var _loc2_:Array = this.crntGameSlot.getPlayerPositionData(param1);
         this.myWeevil.queueMove(_loc2_[1].x,_loc2_[1].y);
         this.moveMyWeevil(_loc2_[0].x,_loc2_[0].y,true);
      }
      
      public function closeGame() : void
      {
         var _loc1_:Array = null;
         if(this.draggableHolder_spr.numChildren > 0)
         {
            this.enableControls();
            this.closeDragableUI();
            if(this.player != 0)
            {
               _loc1_ = this.crntGameSlot.getPlayerPositionData(this.player);
               this.moveMyWeevil(_loc1_[2].x,_loc1_[2].y);
               this.player = 0;
            }
            this.disableDrag();
         }
      }
      
      public function closeDragableUI() : void
      {
         var _loc1_:DraggableUI = null;
         var _loc2_:* = undefined;
         if(this.draggableHolder_spr.numChildren > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.draggableHolder_spr.numChildren)
            {
               _loc1_ = DraggableUI(this.draggableHolder_spr.getChildAt(0));
               _loc1_.terminate();
               this.draggableHolder_spr.removeChildAt(0);
               _loc2_++;
            }
         }
      }
      
      public function gameOver() : void
      {
         var _loc1_:Array = null;
         if(this.player != 0)
         {
            _loc1_ = this.crntGameSlot.getPlayerPositionData(this.player);
            this.moveMyWeevil(_loc1_[2].x,_loc1_[2].y);
            this.player = 0;
         }
      }
      
      public function isGameOpen() : Boolean
      {
         return this.draggableHolder_spr.numChildren > 0 ? true : false;
      }
      
      public function loadBigGameLoader(param1:BigGameSlot) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Loader = null;
         this.crntBigGameSlot = param1;
         var _loc2_:String = this.crntBigGameSlot.gamePath;
         for each(_loc4_ in this.loadedInterfaces)
         {
            if(_loc4_.path == _loc2_ && _loc4_.loadedContent != null)
            {
               _loc3_ = _loc4_.loadedContent;
               break;
            }
         }
         if(_loc3_ != null)
         {
            this.openBigGameLoader(_loc3_);
         }
         else
         {
            _loc5_ = {
               "path":_loc2_,
               "loadedContent":null
            };
            this.loadedInterfaces.push(_loc5_);
            _loc6_ = new Loader();
            URLhandler.loadFromCDN(_loc6_,_loc2_,this.bigGameLoaderLoaded,false);
            this.showLoader(_loc6_,"loading...",true);
         }
      }
      
      public function bigGameLoaderLoaded(param1:Event) : void
      {
         this.hideLoader();
         var _loc2_:MovieClip = param1.target.content;
         this.loadedInterfaces[this.loadedInterfaces.length - 1].loadedContent = _loc2_;
         this.openBigGameLoader(_loc2_);
      }
      
      private function openBigGameLoader(param1:MovieClip) : void
      {
         this.bigGameLoader_mc = param1;
         param1.init(this.crntBigGameSlot);
         this.draggableHolder_spr.addChild(param1);
         this.enableDrag();
      }
      
      private function closeBigGameLoader() : void
      {
         if(this.bigGameLoader_mc != null)
         {
            this.bigGameLoader_mc.closeIt();
            this.bigGameLoader_mc = null;
         }
      }
      
      public function setBigGameLoader(param1:MovieClip) : void
      {
         this.bigGameLoader_mc = param1;
      }
      
      public function bigGameReady(param1:MovieClip) : void
      {
         this.bigGameHolder_spr.addChild(param1);
      }
      
      public function closeBigGame() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:* = undefined;
         if(this.bigGameHolder_spr.numChildren > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.bigGameHolder_spr.numChildren)
            {
               _loc1_ = MovieClip(this.bigGameHolder_spr.getChildAt(0));
               _loc1_.terminate();
               this.bigGameHolder_spr.removeChildAt(0);
               _loc2_++;
            }
         }
      }
      
      public function showPopupGame(param1:String, param2:uint = 2) : void
      {
         var _loc4_:String = null;
         var _loc3_:String = URLhandler.servicesLocation;
         if(param2 == 2)
         {
            _loc4_ = "games/playGame.php";
         }
         else
         {
            _loc4_ = "games/playGame_as3.php";
         }
         var _loc5_:String = URLhandler.servicesLocation;
         var _loc6_:URLRequest = new URLRequest(_loc3_ + _loc4_ + "?" + "userID=" + this.myUserName + "&" + "gameID=" + param1 + "&" + "loc=" + _loc5_);
         navigateToURL(_loc6_,"_blank");
      }
      
      public function openPopup(param1:String, param2:int = 900, param3:int = 700) : void
      {
         var jscommand:String = null;
         var url:URLRequest = null;
         var $url:String = param1;
         var w:int = param2;
         var h:int = param3;
         var wname:String = "bw2";
         var t:String = "no";
         var s:String = "yes";
         var r:String = "yes";
         if(ExternalInterface.available)
         {
            ExternalInterface.call("window.open",$url,wname,"height=" + h + ",width=" + w + ",toolbar=" + t + ",scrollbars=" + s + ",resizable=" + r + "");
            ExternalInterface.call("NewWindow.focus");
            ExternalInterface.call("newWindow.focus");
            ExternalInterface.call("bw2.focus");
         }
         else
         {
            jscommand = "window.open(\'" + $url + "\',\'" + wname + "\',\'height=" + h + ",width=" + w + ",toolbar=" + t + ",scrollbars=" + s + ",resizable=" + r + "\');";
            url = new URLRequest("javascript:" + jscommand + ",  void(0);");
            try
            {
               navigateToURL(url,"_self");
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function loadInterface(param1:Object) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:Pet = null;
         var _loc7_:Object = null;
         this.eventManager.dispatchEvent(new CustomEvent(BinEvents.LOAD_INTERFACE,param1));
         this.newUserProgressManager.loadingNewLocation();
         this.createScreenSnapshot();
         this.closeOverlayUI();
         this.extUIDataObj = param1;
         if(this.extUIDataObj.limbo)
         {
            _loc5_ = new Array();
            _loc5_["locName"] = this.extUIDataObj.locName;
            this.ssclient.setBuddyVariables(_loc5_);
            this.ssclient.joinRoom("Main");
            for each(_loc6_ in this.myPets)
            {
               if(!_loc6_.ridingOwner && _loc6_.loc.name != "nest")
               {
                  _loc6_.rideOwner();
               }
            }
            this.myPetsDormant(true);
            this.cleanUpLoc("");
            this.crntLocID = 0;
         }
         viewPort.vis = false;
         this.setCrntLocVis(false);
         this.hideWeevilProfile();
         this.hidePetProfile();
         var _loc2_:String = this.extUIDataObj.path;
         if(_loc2_ == null && this.extUIDataObj.pathName != null)
         {
            _loc2_ = URLhandler.getPath(this.extUIDataObj.pathName);
         }
         GoogleAnalytics.trackUser(_loc2_);
         for each(_loc4_ in this.loadedInterfaces)
         {
            if(_loc4_.path == _loc2_ && _loc4_.loadedContent != null)
            {
               _loc3_ = _loc4_.loadedContent;
               break;
            }
         }
         if(_loc3_ != null)
         {
            this.openExtUI(_loc3_);
         }
         else
         {
            _loc7_ = {
               "path":_loc2_,
               "loadedContent":null
            };
            this.loadedInterfaces.push(_loc7_);
            this.interfaceLoader = new Loader();
            URLhandler.loadFromCDN(this.interfaceLoader,_loc2_,this.externalUILoaded,true);
            this.showLoader(this.interfaceLoader,"loading...");
         }
      }
      
      private function externalUILoaded(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target.content;
         this.loadedInterfaces[this.loadedInterfaces.length - 1].loadedContent = _loc2_;
         this.openExtUI(_loc2_);
         this.hideLoader();
      }
      
      private function openExtUI(param1:MovieClip) : void
      {
         this.extUI_mc = param1;
         this._UIresetMode = this.UI.crntMode;
         this.extUI_mc.init(this.UI.crntMode,this.extUIDataObj);
         this.UI.set_mode(5);
         this.externalUIHolder_spr.addChild(this.extUI_mc);
         this.myWeevil.setDestExtUIData(null);
         this.newUserProgressManager.newExtUIOpened(this.extUIDataObj.locName);
         var _loc2_:Event = new Event(BinEvents.OPEN_EXTERNAL_UI);
         EventManager.get_instance().dispatchEvent(_loc2_);
      }
      
      public function closeExternalInterface(param1:int = 0) : void
      {
         var _loc4_:ExtUI = null;
         var _loc5_:* = undefined;
         var _loc2_:int = this.externalUIHolder_spr.numChildren;
         if(_loc2_ > 0)
         {
            this.UI.set_mode(param1);
            _loc5_ = _loc2_;
            while(_loc5_ > 0)
            {
               _loc4_ = ExtUI(this.externalUIHolder_spr.getChildAt(0));
               _loc4_.terminate();
               this.externalUIHolder_spr.removeChildAt(0);
               _loc5_--;
            }
         }
         this.extUI_mc = null;
         viewPort.vis = true;
         this.setCrntLocVis(true);
         this.showMapBtn(true);
         this.newUserProgressManager.closedExtUI();
         var _loc3_:Event = new Event(BinEvents.CLOSE_EXTERNAL_UI);
         EventManager.get_instance().dispatchEvent(_loc3_);
      }
      
      public function getCrntExtUI() : MovieClip
      {
         return this.extUI_mc;
      }
      
      private function setCrntLocVis(param1:Boolean) : void
      {
         if(this.crntLoc != null)
         {
            this.crntLoc.vis = param1;
         }
      }
      
      public function startRendering() : void
      {
         if(this.crntLoc != null)
         {
            this.renderTimer.start();
            this.crntLoc.vis = true;
         }
      }
      
      public function stopRendering() : void
      {
         this.renderTimer.stop();
         if(this.crntLoc != null)
         {
            this.crntLoc.vis = false;
         }
      }
      
      private function render(param1:TimerEvent) : void
      {
         var _loc2_:Pet = null;
         var _loc3_:Weevil = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         this.eventManager.dispatchEvent(new Event(BinEvents.RENDER));
         this.cam.update(this.myWeevil.x,this.aimY + this.myWeevil.getTotalY(),this.myWeevil.z,this.camMode,this.myWeevil.rotY);
         if(this.dtFixed)
         {
            _loc6_ = 1;
         }
         else
         {
            _loc5_ = getTimer();
            if(this.tPrev != 0)
            {
               _loc4_ = _loc5_ - this.tPrev;
            }
            else
            {
               _loc4_ = 35;
            }
            this.tPrev = _loc5_;
            _loc6_ = _loc4_ * 0.04;
            if(_loc6_ > 2)
            {
               _loc6_ = 2;
            }
            this.dtPrev = _loc6_;
         }
         for each(_loc2_ in this.pets)
         {
            _loc2_.update(this.cam,viewPort,_loc6_);
         }
         for each(_loc3_ in this.weevils)
         {
            _loc3_.update(_loc6_);
         }
         this.crntLoc.render(this.cam,_loc6_);
         param1.updateAfterEvent();
      }
      
      public function getCurrentPet() : IPet
      {
         var _loc1_:Pet = null;
         for each(_loc1_ in this.myPets)
         {
            if(_loc1_.loc == this.crntLoc)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function getLocDefs() : Array
      {
         try
         {
            return this.locs.concat();
         }
         catch(e:Error)
         {
         }
         return [];
      }
      
      public function hideVideoAdsButton() : void
      {
         this.UI.hideVideoAds();
      }
      
      public function enableMyStuff(param1:Boolean) : void
      {
         this.UI.enableMyStuff(param1);
      }
   }
}

