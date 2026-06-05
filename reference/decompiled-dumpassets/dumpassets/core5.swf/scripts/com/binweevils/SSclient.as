package com.binweevils
{
   import com.binweevils.conf.*;
   import flash.events.*;
   import it.gotoandplay.smartfoxserver.SFSEvent;
   import it.gotoandplay.smartfoxserver.SmartFoxClient;
   
   public class SSclient extends EventDispatcher
   {
      
      private var sfs:SmartFoxClient;
      
      private var defaultZone:String;
      
      private var myUserName:String;
      
      private var loginKey:String;
      
      private var nestXML:String;
      
      public var crntRoom:String;
      
      public function SSclient()
      {
         super();
         this.defaultZone = new String("BinWeevils");
         this.nestXML = new String("");
         this.sfs = new SmartFoxClient();
         this.sfs.debug = true;
         this.sfs.addEventListener(SFSEvent.onConnection,this.onConnection);
         this.sfs.addEventListener(SFSEvent.onConnectionLost,this.onConnectionLost);
         this.sfs.addEventListener(SFSEvent.onLogin,this.onLogin);
         this.sfs.addEventListener(SFSEvent.onRoomListUpdate,this.onRoomListUpdate);
         this.sfs.addEventListener(SFSEvent.onRoomVariablesUpdate,this.onRoomVariablesUpdate);
         this.sfs.addEventListener(SFSEvent.onJoinRoom,this.onJoinRoom);
         this.sfs.addEventListener(SFSEvent.onJoinRoomError,this.onJoinRoomError);
         this.sfs.addEventListener(SFSEvent.onUserEnterRoom,this.onUserEnterRoom);
         this.sfs.addEventListener(SFSEvent.onUserLeaveRoom,this.onUserLeaveRoom);
         this.sfs.addEventListener(SFSEvent.onPublicMessage,this.publicMsgReceived);
         this.sfs.addEventListener(SFSEvent.onExtensionResponse,this.onExtensionResponse);
         this.sfs.addEventListener(SFSEvent.onAdminMessage,this.onAdminMessage);
         this.sfs.addEventListener(SFSEvent.onModeratorMessage,this.onModeratorMessage);
         this.sfs.addEventListener(SFSEvent.onConfigLoadSuccess,this.onConfigLoadSuccess);
         this.sfs.addEventListener(SFSEvent.onConfigLoadFailure,this.onConfigLoadFailureHandler);
         this.sfs.addEventListener(SFSEvent.onBuddyList,this.onBuddyList);
         this.sfs.addEventListener(SFSEvent.onBuddyListUpdate,this.onBuddyListUpdate);
         this.sfs.addEventListener(SFSEvent.onBuddyPermissionRequest,this.onBuddyPermissionRequest);
         this.sfs.addEventListener(SFSEvent.onBuddyRoom,this.onBuddyRoom);
      }
      
      public function get_sfs() : SmartFoxClient
      {
         return this.sfs;
      }
      
      public function setUserVar(param1:String, param2:String) : void
      {
         var _loc3_:Object = new Object();
         _loc3_[param1] = param2;
         this.sfs.setUserVariables(_loc3_);
      }
      
      public function setUserVars(param1:Object) : void
      {
         this.sfs.setUserVariables(param1);
      }
      
      public function loadBuddyList() : void
      {
         this.sfs.loadBuddyList();
      }
      
      public function sendPetAction(param1:int, param2:int, param3:String, param4:uint, param5:String) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.PET_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.PET_MODULE_ACTION,[param1,param2,param3,param4,param5],"str");
      }
      
      public function sendPetExpression(param1:int, param2:int, param3:uint = 0) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.PET_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.PET_MODULE_PET_EXPRESSION,[param1,param2,param3],"str");
      }
      
      public function sendPetGotBall(param1:int) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.PET_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.PET_MODULE_GOT_BALL,[param1],"str");
      }
      
      public function petJoinNestLoc(param1:int, param2:int, param3:int, param4:Number = 0, param5:Number = 0, param6:Number = 0, param7:Number = 0, param8:uint = 0) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.PET_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.PET_MODULE_PET_JOIN_NEST_LOC,[param1,param2,param3,param4,param5,param6,param7,param8],"str");
      }
      
      public function petGoHome(param1:String, param2:int, param3:String) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.PET_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.PET_MODULE_PET_GO_NEST,[param1,param2,param3],"str");
      }
      
      public function setNestDoorPet(param1:int, param2:int, param3:uint = 0) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.PET_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.PET_MODULE_SET_NEST_DOOR_PET,[param1,param2,param3],"str");
      }
      
      public function sendPetCmd(param1:String, param2:String, param3:int) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.PET_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.PET_MODULE_SEND_PET_COMMAND,[param1,param2,param3],"str");
      }
      
      public function setPetIDs(param1:String, param2:int) : void
      {
         var _loc3_:Array = [{
            "name":"petIDs",
            "val":param1,
            "persistent":true
         }];
         this.sfs.setRoomVariables(_loc3_,param2);
      }
      
      public function setPetDef(param1:int, param2:String, param3:int, param4:Boolean = true) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         if(param4)
         {
            _loc5_ = [{
               "name":"petDef" + param1,
               "val":param2,
               "persistent":true
            }];
            this.sfs.setRoomVariables(_loc5_,param3);
         }
         else
         {
            _loc6_ = {"petDef":param2};
            this.sfs.setUserVariables(_loc6_);
         }
      }
      
      public function setPetState(param1:int, param2:String, param3:int, param4:Boolean) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         if(param4)
         {
            _loc5_ = [{
               "name":"petState" + param1,
               "val":param2,
               "persistent":true
            }];
            this.sfs.setRoomVariables(_loc5_,param3);
         }
         else
         {
            _loc6_ = {"petState":param2};
            this.sfs.setUserVariables(_loc6_);
         }
      }
      
      public function getChatState() : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.CHAT_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.CHAT_MODULE_CHANGE_CHAT_STATE,[],"str");
      }
      
      public function sendMove(param1:Number, param2:Number, param3:Number) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.INGAME_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.INGAME_MODULE_MOVE,[param1,param2,param3],"str");
      }
      
      public function sendExpression(param1:int) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.INGAME_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.INGAME_MODULE_EXPRESSION,[param1],"str");
      }
      
      public function sendAction(param1:int, param2:int = 0, param3:String = "-1") : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.INGAME_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.INGAME_MODULE_ACTION,[param1,param2,param3],"str");
      }
      
      public function joinRoom(param1:String, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:int = 0, param7:int = 0) : *
      {
         this.crntRoom = param1;
         this.sfs.sendXtMessage("login",MessageProtocol.INGAME_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.INGAME_MODULE_JOIN_ROOM,[param1,param2,param3,param4,param5,param6,param7],"str");
      }
      
      public function sendRoomEvent(param1:String, param2:String = "-1") : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.INGAME_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.INGAME_MODULE_ROOM_EVENT,[param1,param2],"str");
      }
      
      public function grabTray(param1:int) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.DINER_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.DINER_MODULE_GRAB_TRAY,[param1],"str");
      }
      
      public function dropTray(param1:int) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.DINER_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.DINER_MODULE_DROP_TRAY,[param1],"str");
      }
      
      public function chefStart() : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.DINER_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.DINER_MODULE_CHEF_START,[],"str");
      }
      
      public function chefQuit() : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.DINER_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.DINER_MODULE_CHEF_QUIT,[],"str");
      }
      
      public function updatePlayerScore(param1:int) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.DAILYRANKING_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.DAILYRANKING_MODULE_UPDATE_PLAYER_SCORE,[param1],"str");
      }
      
      public function getZoneTime() : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.INGAME_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.INGAME_MODULE_GET_ZONE_TIME,[],"str");
      }
      
      public function addApparel(param1:int, param2:String = "0") : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.INGAME_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.INGAME_MODULE_ADD_APPAREL,[param1,param2],"str");
      }
      
      public function removeApparel(param1:int) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.INGAME_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.INGAME_MODULE_REMOVE_APPAREL,[param1],"str");
      }
      
      public function checkMsg(param1:String, param2:String) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.INGAME_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.INGAME_MODULE_CHECK_MESSAGE,[param1,param2],"str");
      }
      
      public function changeWeevilDef(param1:String) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.INGAME_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.INGAME_MODULE_CHANGE_WEEVILDEF,[param1],"str");
      }
      
      public function setNestDoor(param1:int) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.NEST_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.NEST_MODULE_SET_NEST_DOOR,[param1],"str");
      }
      
      public function joinNestLoc(param1:int, param2:int, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.NEST_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.NEST_MODULE_JOIN_NEST_LOCATION,[param1,param2,param3,param4,param5,param6],"str");
      }
      
      public function inviteToNest(param1:String) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.NEST_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.NEST_MODULE_INVITE_TO_NEST,[param1],"str");
      }
      
      public function removeGuestFromNest(param1:String = "-1") : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.NEST_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.NEST_MODULE_REMOVE_GUESTS_FROM_NEST,[param1],"str");
      }
      
      public function guestJoinedNest(param1:String, param2:int) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.NEST_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.NEST_MODULE_GUEST_JOINED_NEST,[param1,param2],"str");
      }
      
      public function removeNestInvite(param1:String = "-1") : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.NEST_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.NEST_MODULE_REMOVE_NEST_INVITES,[param1],"str");
      }
      
      public function evictUsersFromMyNest(param1:String) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.NEST_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.NEST_MODULE_RETURN_TO_NEST,[param1],"str");
      }
      
      public function sendBusinesses(param1:String) : *
      {
         this.sfs.sendXtMessage("login",MessageProtocol.BUSINESS_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.BUSINESS_MODULE_SET_BUSINESS_STATE,[param1],"str");
      }
      
      public function sendGetBusinesses() : *
      {
         this.sfs.sendXtMessage("login",MessageProtocol.BUSINESS_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.BUSINESS_MODULE_GET_BUSINESS_LIST,[],"str");
      }
      
      public function sendGetPlazaAvailable(param1:String) : *
      {
         this.sfs.sendXtMessage("login",MessageProtocol.BUSINESS_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.BUSINESS_MODULE_GET_PLAZA_AVAILABILITY,[param1],"str");
      }
      
      public function createNPC(param1:int, param2:String, param3:String) : *
      {
         this.sfs.sendXtMessage("login",MessageProtocol.NPC_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.NPC_MODULE_CREATE_NPC,[param1,param2,param3],"str");
      }
      
      public function removeNPC(param1:int) : *
      {
         this.sfs.sendXtMessage("login",MessageProtocol.NPC_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.NPC_MODULE_REMOVE_NPC,[param1],"str");
      }
      
      public function sendNPCAction(param1:int, param2:int, param3:String, param4:String) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.NPC_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.NPC_MODULE_NPC_ACTION,[param1,param2,param3,param4],"str");
      }
      
      public function sendNPCExpression(param1:int, param2:int) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.NPC_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.NPC_MODULE_SET_NPC_EXPRESSION,[param1,param2],"str");
      }
      
      public function NPCJoinNestLoc(param1:int, param2:int, param3:int, param4:Number = 0, param5:Number = 0, param6:Number = 0, param7:Number = 0) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.NPC_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.NPC_MODULE_NPC_JOIN_NEST_LOC,[param1,param2,param3,param4,param5,param6,param7],"str");
      }
      
      public function setNestDoorNPC(param1:int, param2:int) : void
      {
         this.sfs.sendXtMessage("login",MessageProtocol.NPC_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.NPC_MODULE_SET_NPC_NEST_DOOR,[param1,param2],"str");
      }
      
      public function weevilReportUser(param1:String, param2:String, param3:String) : *
      {
         this.sfs.sendXtMessage("login",MessageProtocol.ADMIN_MODULE_NAME + MessageProtocol.SEPARATOR + MessageProtocol.ADMIN_MODULE_REPORT,[param1,param2,param3],"str");
      }
      
      public function dispatchLottoDrawEvent() : void
      {
         var _loc1_:* = new Event("lottoDraw");
         dispatchEvent(_loc1_);
      }
      
      public function getLastLog(param1:String) : void
      {
         var _loc2_:* = new Array("userName:" + param1 + ",");
         this.sfs.sendXtMessage("login","getLastLog",_loc2_,"str");
      }
      
      public function syncBuddy(param1:String) : void
      {
         this.sfs.syncBuddy(param1);
      }
      
      public function sendBuddyPermissionResponse(param1:Boolean, param2:String) : void
      {
         this.sfs.sendBuddyPermissionResponse(param1,param2);
      }
      
      public function setBuddyVariables(param1:Array) : void
      {
         this.sfs.setBuddyVariables(param1);
      }
      
      public function getBuddyByName(param1:String) : Object
      {
         return this.sfs.getBuddyByName(param1);
      }
      
      public function getBuddyRoom(param1:Object) : void
      {
         this.sfs.getBuddyRoom(param1);
      }
      
      private function onBuddyRoom(param1:SFSEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function onBuddyList(param1:SFSEvent) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in this.sfs.myBuddyVars)
         {
         }
         dispatchEvent(param1);
      }
      
      private function onBuddyListUpdate(param1:SFSEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function onBuddyPermissionRequest(param1:SFSEvent) : void
      {
         dispatchEvent(param1);
      }
      
      public function getIgnoreList() : void
      {
         var _loc1_:* = new Array("crap:crap,");
         this.sfs.sendXtMessage("login","getIgnoreList",_loc1_,"str");
      }
      
      public function addUserToIgnoreList(param1:String) : void
      {
         var _loc2_:* = new Array("userName:" + param1 + ",");
         this.sfs.sendXtMessage("login","addUserToIgnoreList",_loc2_,"str");
      }
      
      public function removeUserFromIgnoreList(param1:String) : void
      {
         var _loc2_:* = new Array("userName:" + param1 + ",");
         this.sfs.sendXtMessage("login","removeUserFromIgnoreList",_loc2_,"str");
      }
      
      private function onAdminMessage(param1:SFSEvent) : *
      {
      }
      
      private function onModeratorMessage(param1:SFSEvent) : *
      {
         dispatchEvent(param1);
      }
      
      public function setLoginDetails(param1:String, param2:String) : *
      {
         this.myUserName = param1;
         this.loginKey = param2;
      }
      
      public function login() : *
      {
         this.sfs.login(this.defaultZone,this.myUserName,this.loginKey);
      }
      
      public function testIsUserUnique(param1:String) : *
      {
         var _loc2_:Array = new Array("username:" + param1 + ",DEf:hooah");
         this.sfs.sendXtMessage("login","isUserUnique",_loc2_,"str");
      }
      
      public function weevilToString(param1:Object) : String
      {
         var _loc2_:String = new String("");
         var _loc3_:* = new Array("username","password","email","ht","hc","bt","bc","et","ec","at","ac","lc","lids");
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(param1[_loc3_[_loc4_]] != null)
            {
               _loc2_ += _loc3_[_loc4_] + ":" + param1[_loc3_[_loc4_]] + ",";
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function testIsWeevilUnique(param1:Object) : *
      {
         var _loc2_:Array = new Array(this.weevilToString(param1));
         this.sfs.sendXtMessage("login","isWeevilUnique",_loc2_,"str");
      }
      
      public function submitWeevilDetails(param1:Object) : *
      {
         var _loc2_:* = new Array();
         _loc2_.push(this.weevilToString(param1));
         this.sfs.sendXtMessage("login","submitUser",_loc2_,"str");
      }
      
      public function turnBasedGameMessageS(param1:String, param2:String, param3:Array) : *
      {
         this.sfs.sendXtMessage(param1,param2,param3,"str");
      }
      
      public function sendDrivenOff() : void
      {
         this.sfs.sendXtMessage("login","b",["drivenOff"],"str");
      }
      
      public function sendBuyTicket() : void
      {
         var _loc1_:* = new Array("crap:crap,");
         this.sfs.sendXtMessage("login","buyTicket",_loc1_,"str");
      }
      
      public function getMyPets() : void
      {
         this.sfs.sendXtMessage("login","p",["getMyPets"],"str");
      }
      
      public function getPetSkills(param1:int) : void
      {
         this.sfs.sendXtMessage("login","p",["gps",param1],"str");
      }
      
      public function getPetJugglingSkills(param1:int) : void
      {
         this.sfs.sendXtMessage("login","p",["gpjs",param1],"str");
      }
      
      public function updatePetStats(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : void
      {
         this.sfs.sendXtMessage("login","p",["st",param1,param2,param3,param4,param5,param6],"str");
      }
      
      public function updatePetSkill(param1:int, param2:int, param3:int, param4:Number) : void
      {
         this.sfs.sendXtMessage("login","p",["sk",param1,param2,param3,param4],"str");
      }
      
      public function updateJugglingTrick(param1:int, param2:int, param3:Number, param4:Number) : void
      {
         this.sfs.sendXtMessage("login","p",["jt",param1,param2,param3,param4],"str");
      }
      
      public function getNewJugglingTrick(param1:int, param2:int, param3:int) : void
      {
         this.sfs.sendXtMessage("login","p",["newJt",param1,param2,param3],"str");
      }
      
      public function addWeevilExp(param1:int) : void
      {
         this.sfs.sendXtMessage("login","addWeevilExp",["exp:" + param1],"str");
      }
      
      public function getSpecialMoves() : void
      {
         var _loc1_:* = new Array("crap:crap,");
         this.sfs.sendXtMessage("login","getSpecialMoves",_loc1_,"str");
      }
      
      public function updateSpecialMoves(param1:String) : void
      {
         this.sfs.sendXtMessage("login","updateSpecialMoves",["specialMoves:" + param1],"str");
      }
      
      private function onExtensionResponse(param1:SFSEvent) : void
      {
         var _loc2_:String = param1.params.dataObj.commandType;
         if(_loc2_ == null)
         {
            if(param1.params.dataObj[0] == "mv")
            {
               _loc2_ = "mv";
            }
         }
         dispatchEvent(param1);
      }
      
      public function sendPublicMessage(param1:String) : void
      {
         this.sfs.sendPublicMessage(param1);
      }
      
      private function publicMsgReceived(param1:SFSEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function onUserEnterRoom(param1:SFSEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function onUserLeaveRoom(param1:SFSEvent) : void
      {
         dispatchEvent(param1);
      }
      
      internal function onConfigLoadFailureHandler(param1:SFSEvent) : void
      {
      }
      
      public function onConfigLoadSuccess(param1:SFSEvent) : void
      {
         this.sfs.connect(this.sfs.ipAddress,this.sfs.port);
      }
      
      public function connect(param1:String) : void
      {
         this.defaultZone = param1;
         if(!this.sfs.isConnected)
         {
            this.sfs.connect(this.sfs.ipAddress,this.sfs.port);
         }
      }
      
      internal function onConnection(param1:SFSEvent) : void
      {
         var _loc2_:Boolean = Boolean(param1.params.success);
         if(_loc2_)
         {
            this.login();
         }
      }
      
      internal function onConnectionLost(param1:SFSEvent) : void
      {
         dispatchEvent(param1);
      }
      
      internal function onLogin(param1:SFSEvent) : void
      {
         dispatchEvent(param1);
         var _loc2_:* = param1.params.dataObj;
         if(_loc2_.logged != "true")
         {
            if(_loc2_.guest == "true")
            {
            }
         }
      }
      
      public function getMyUserID() : int
      {
         return this.sfs.myUserId;
      }
      
      public function getActiveRoom() : Object
      {
         return this.sfs.getActiveRoom();
      }
      
      public function getRoom(param1:int) : Object
      {
         return this.sfs.getRoom(param1);
      }
      
      public function getRoomByName(param1:String) : Object
      {
         return this.sfs.getRoomByName(param1);
      }
      
      public function getRoomList() : void
      {
         this.sfs.getRoomList();
      }
      
      internal function onRoomListUpdate(param1:SFSEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function onRoomVariablesUpdate(param1:SFSEvent) : void
      {
      }
      
      internal function onJoinRoom(param1:SFSEvent) : void
      {
         dispatchEvent(param1);
      }
      
      internal function onJoinRoomError(param1:SFSEvent) : void
      {
      }
      
      internal function onSecurityError(param1:SecurityErrorEvent) : void
      {
      }
      
      internal function onIOError(param1:IOErrorEvent) : void
      {
      }
   }
}

