package com.binweevils
{
   import com.adobe.crypto.MD5;
   import com.adobe.serialization.json.JSON;
   import com.binweevils.DBaccess.PHP2call;
   import com.binweevils.DBaccess.PHPcall;
   import com.binweevils.binBadges.BinBadgesManager;
   import com.binweevils.buddies.BuddyData;
   import com.binweevils.buddies.BuddyFeedContainer;
   import com.binweevils.buddies.BuddyMessageEvent;
   import com.binweevils.buddies.BuddyPanelContainer;
   import com.binweevils.buddies.IgnoreListData;
   import com.binweevils.buddies.NewMessagesIndicator;
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.visuals.creatures.pets.Pet;
   import com.binweevils.engine3D.visuals.creatures.pets.PetSkillNames;
   import com.binweevils.engine3D.visuals.creatures.pets.PetSkillsTricksProgression;
   import com.binweevils.engine3D.visuals.creatures.weevils.Weevil;
   import com.binweevils.newUserTutorial.NewUserProgressManager;
   import com.binweevils.news.NewsAndMessages;
   import com.binweevils.petProfile.PetCommandsUI;
   import com.binweevils.petProfile.PetStatsUI;
   import com.binweevils.rssmv.Rssmv;
   import com.binweevils.utilities.ColourFilters;
   import com.binweevils.utilities.DateTime;
   import com.binweevils.utilities.ToolTipEvent;
   import com.binweevils.utilities.TooltipsManager;
   import com.binweevils.utilities.URLhandler;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.net.*;
   import flash.system.LoaderContext;
   import flash.system.Security;
   import flash.text.*;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import it.gotoandplay.smartfoxserver.SFSEvent;
   
   public class UImain
   {
      
      private var UI_mc:MovieClip;
      
      private var bin:Bin;
      
      private var say_btn:SimpleButton;
      
      private var chatMsg_txt:TextField;
      
      private var mouthBtns:Array;
      
      private var actionBtns:Array;
      
      private var starActive:Boolean;
      
      private var clickSqnce:String;
      
      private var profileContent_spr:Sprite;
      
      private var weevilMugShotHolder_spr:Sprite;
      
      private var profileLevelIndicator_spr:Sprite;
      
      private var profileLevelNum_txt:TextField;
      
      private var profileLevelStar_spr:Sprite;
      
      private var weevilName_txt:TextField;
      
      private var crntUserProfile:String;
      
      private var crntUserIDX:int;
      
      private var crntUserName:String;
      
      private var crntUserPets:Array = new Array();
      
      private var deadUser:String;
      
      private var petName_txt:TextField;
      
      private var petMugShotHolder_spr:Sprite;
      
      private var petStats_spr:Sprite;
      
      private var defaultPic:Sprite;
      
      private var photoContainer_mc:Sprite;
      
      private var petHelp_btn:SimpleButton;
      
      private var foodBar_spr:*;
      
      private var energyBar_spr:*;
      
      private var healthBar_spr:*;
      
      private var fitnessBar_spr:*;
      
      private var vitality_spr:Sprite;
      
      private var energyStatLabel_txt:TextField;
      
      private var petXP_txt:TextField;
      
      private var _crosshairs_on:Boolean;
      
      public var keepCrosshairsCount:uint;
      
      private var _handShowing:Boolean;
      
      private var dialogueYesHandler:Function;
      
      private var queueMonitorInitialised:Boolean;
      
      private var showApparel_btn:SimpleButton;
      
      private var binBadges_btn:SimpleButton;
      
      private var binPet_btn:SimpleButton;
      
      private var buddyRequest_btn:SimpleButton;
      
      private var removeBuddy_btn:SimpleButton;
      
      private var findBuddy_btn:SimpleButton;
      
      private var sendInvite_btn:SimpleButton;
      
      private var removeGuest_btn:SimpleButton;
      
      private var ignore_btn:SimpleButton;
      
      private var removeIgnore_btn:SimpleButton;
      
      private var sendBuddyMsg_btn:SimpleButton;
      
      private var topHat_btn:SimpleButton;
      
      private var staff_btn:SimpleButton;
      
      private var reportUser_btn:SimpleButton;
      
      private var selectedReportReasonMC:MovieClip;
      
      private var reportReasons:Array;
      
      private var buddyRequests:Array;
      
      private var potentialBuddy:String;
      
      private var buddyToFind:Object;
      
      private var findBuddyMode:int;
      
      private var buddyLastLog:String;
      
      private var newInvites:Array;
      
      private var newInvite:Boolean;
      
      private var hostUserName:String;
      
      private var publicNestVisitor:Boolean;
      
      private var apparelControl:ApparelControl;
      
      private var weevilStatManager:WeevilStatManager;
      
      public var weevilActionsUI:WeevilActionsUI;
      
      public var weevilExpressionsUI:WeevilExpressionsUI;
      
      private var topRightDisplay:TopRightDisplay;
      
      private var chatLog:ChatLog;
      
      private var buddyList:*;
      
      private var guestList:*;
      
      private var invList:UserList;
      
      private var ignoreList:UserList;
      
      private var petCommandsUI:PetCommandsUI;
      
      private var lottoResults:LottoResults;
      
      private var camUI:CamUI;
      
      private var loadBar_spr:Sprite;
      
      private var crntWeevilMugShot:Sprite;
      
      private var crntPetMugShot:Sprite;
      
      private var chatEnabled:Boolean;
      
      private var _crntMode:int;
      
      private var guestMode:Boolean;
      
      public var chestOpen:Boolean;
      
      private var dialogueManagerLoadStatus:int;
      
      private var dialogueManager_mc:MovieClip;
      
      private var inventoryLoadStatus:int;
      
      private var inventoryControl:MovieClip;
      
      private var inventoryPath:String;
      
      private var inventoryHolder_spr:Sprite;
      
      private var helpQuestLoadStatus:int;
      
      private var questHelpControl:MovieClip;
      
      private var questHelpObj:Object;
      
      private var questHelpHolder_spr:*;
      
      private var questExtUiHelpHolder_spr:Sprite;
      
      private var ssclient:SSclient;
      
      private var key0Down:*;
      
      private var key1Down:*;
      
      private var key2Down:*;
      
      private var key3Down:*;
      
      private var key4Down:*;
      
      private var key5Down:*;
      
      private var key6Down:*;
      
      private var key7Down:*;
      
      private var key8Down:*;
      
      private var key9Down:Boolean;
      
      private var chatDisabled_mc:*;
      
      private var weevilProfile_mc:*;
      
      private var petProfile_mc:*;
      
      private var reportUser_mc:*;
      
      private var lists_mc:*;
      
      private var lottoResults_mc:*;
      
      private var doshPrompt_mc:*;
      
      private var warningBox_mc:*;
      
      private var alertBox_mc:*;
      
      private var dialogueBox_mc:*;
      
      private var invitation_mc:*;
      
      private var buddyRequestMsg_mc:*;
      
      private var hand_mc:*;
      
      private var tycoonPanel_mc:*;
      
      private var sendBuddyMsg_mc:*;
      
      private var myStuffShake_mc:*;
      
      private var mapBtnGlow_mc:MovieClip;
      
      private var publicPetProfile_mc:MovieClip;
      
      private var chat_spr:*;
      
      private var chatLog_spr:*;
      
      private var myProfileBtn_spr:*;
      
      private var modMsg_spr:*;
      
      private var petCommands_spr:*;
      
      private var buddyRequestIndicator_spr:*;
      
      private var inviteIndicator_spr:*;
      
      private var crosshairs_spr:*;
      
      private var camUILoader_spr:*;
      
      private var camUI_spr:Sprite;
      
      private var map_btn:*;
      
      private var nest_btn:*;
      
      private var myStuff_btn:*;
      
      private var chatLog_btn:*;
      
      private var tycoonTV_btn:*;
      
      private var cameraIcon_btn:*;
      
      private var shop_btn:SimpleButton;
      
      private var activation_btn:SimpleButton;
      
      private var silenceMinutes:int;
      
      private var silenceMinutes_ghost:int = 13;
      
      private var silenceMinutesTimer:Timer;
      
      private var tycoonBusinesses:Array;
      
      private var plazaOpen:Boolean;
      
      private var currentList:int;
      
      private var tooltipsManager:TooltipsManager;
      
      public var infoTxtColour:String = "#5677C2";
      
      private var buddyPanelContainer:BuddyPanelContainer;
      
      private var buddyFeedContainer:BuddyFeedContainer;
      
      private var newsAndMessages:NewsAndMessages;
      
      private var newsAndMessagesBtnMC:MovieClip;
      
      private var newsAndMessagesBtn:SimpleButton;
      
      private var newMessagesIndicator:NewMessagesIndicator;
      
      private var numNewsTxt:TextField;
      
      private var numMessagesTxt:TextField;
      
      private var tabletJiggleMC:MovieClip;
      
      private var binBadgesContainer:BinBadgesManager;
      
      private var XPAnimManager:UIMainXPMulchAnimManager;
      
      private var plazaListUi_btn:SimpleButton;
      
      private var businessPlazaIsOpen:Boolean;
      
      private var petStatsUI:PetStatsUI;
      
      private var crntPetID:Number;
      
      private var crntPetOwnerName:String;
      
      private var sa:Boolean;
      
      private var magStaff_btn:SimpleButton;
      
      private var msa:Boolean;
      
      public var businessPlazaList:TycoonBusinessesList;
      
      public var isLevelingUp:Boolean = false;
      
      public function UImain(param1:MovieClip, param2:Sprite, param3:Sprite, param4:Sprite, param5:Sprite, param6:Sprite)
      {
         super();
         this.UI_mc = param1;
         this.bin = Bin.get_instance();
         this.vis = false;
         EventManager.get_instance().addEventListener(ToolTipEvent.REGISTER_TOOLTIP,this.handleRegisterTooltip);
         this.buddyFeedContainer = new BuddyFeedContainer(this,param1.controls_mc.buddyFeed_mc);
         this.cameraIcon_btn = param1.cameraIcon_btn;
         this.showControls(false);
         this.businessPlazaList = new TycoonBusinessesList();
         this.weevilProfile_mc = param1.weevilProfile_mc;
         this.petProfile_mc = param1.petProfile_mc;
         this.reportUser_mc = param1.reportUser_mc;
         this.lists_mc = param1.controls_mc.lists_mc;
         this.chat_spr = param1.controls_mc.chat_spr;
         this.chatDisabled_mc = param1.controls_mc.chatDisabled_mc;
         this.myProfileBtn_spr = param1.myProfileBtn_spr;
         this.chatLog_spr = param1.controls_mc.chatLog_spr;
         this.chatLog_btn = param1.controls_mc.chatLog_btn;
         this.modMsg_spr = param1.modMsg_spr;
         this.lottoResults_mc = param1.lottoResults_mc;
         this.petCommands_spr = param1.petProfile_mc.petCommands_spr;
         this.doshPrompt_mc = param1.doshPrompt_mc;
         this.alertBox_mc = param1.alertBox_mc;
         this.warningBox_mc = param1.warningBox_mc;
         this.dialogueBox_mc = param1.dialogueBox_mc;
         this.invitation_mc = param1.invitation_mc;
         this.buddyRequestMsg_mc = param1.buddyRequestMsg_mc;
         this.buddyRequestIndicator_spr = param1.controls_mc.buddyRequestIndicator_spr;
         this.inviteIndicator_spr = param1.controls_mc.inviteIndicator_spr;
         this.crosshairs_spr = param1.crosshairs_spr;
         this.hand_mc = param1.hand_mc;
         this.camUILoader_spr = param1.controls_mc.camUILoader_spr;
         this.camUI_spr = param1.controls_mc.camUI_spr;
         this.tycoonTV_btn = param1.controls_mc.tycoonTV_btn;
         this.activation_btn = param1.controls_mc.activate_bt;
         this.activation_btn.visible = false;
         this.cameraIcon_btn.visible = false;
         this.tooltipsManager = new TooltipsManager(param1.hint_mc);
         this.map_btn = param1.controls_mc.map_btn;
         this.shop_btn = param1.controls_mc.shop_btn;
         this.mapBtnGlow_mc = param1.controls_mc.mapBtnGlow_mc;
         this.mapBtnGlow_mc.visible = false;
         this.mapBtnGlow_mc.gotoAndStop(1);
         this.mapBtnGlow_mc.mouseEnabled = false;
         this.mapBtnGlow_mc.mouseChildren = false;
         this.nest_btn = param1.controls_mc.nest_btn;
         this.myStuff_btn = param1.controls_mc.myStuff_btn;
         this.myStuffShake_mc = param1.controls_mc.myStuffShake_mc;
         this.myStuffShake_mc.mouseEnabled = false;
         param2.addChild(this.UI_mc);
         this.camUILoader_spr.visible = false;
         this.inventoryHolder_spr = param4;
         this.questHelpHolder_spr = param5;
         this.questExtUiHelpHolder_spr = param6;
         this.profileContent_spr = Sprite(this.weevilProfile_mc.getChildByName("profileContent_spr"));
         this.weevilMugShotHolder_spr = Sprite(this.weevilProfile_mc.getChildByName("mugShotHolder_spr"));
         this.profileLevelIndicator_spr = Sprite(this.profileContent_spr.getChildByName("levelIndicator_spr"));
         this.profileLevelStar_spr = Sprite(this.profileLevelIndicator_spr.getChildByName("levelStar_spr"));
         this.profileLevelNum_txt = TextField(this.profileLevelIndicator_spr.getChildByName("levelNum_txt"));
         this.weevilName_txt = TextField(this.weevilProfile_mc.getChildByName("weevilName_txt"));
         var _loc7_:SimpleButton = SimpleButton(this.weevilProfile_mc.getChildByName("close_btn"));
         _loc7_.addEventListener(MouseEvent.CLICK,this.hideWeevilProfile);
         this.showApparel_btn = SimpleButton(this.profileContent_spr.getChildByName("showApparel_btn"));
         this.binBadges_btn = SimpleButton(this.profileContent_spr.getChildByName("binBadges_btn"));
         this.binPet_btn = SimpleButton(this.profileContent_spr.getChildByName("binPet_btn"));
         this.buddyRequest_btn = SimpleButton(this.profileContent_spr.getChildByName("buddyRequest_btn"));
         this.removeBuddy_btn = SimpleButton(this.profileContent_spr.getChildByName("removeBuddy_btn"));
         this.findBuddy_btn = SimpleButton(this.profileContent_spr.getChildByName("findBuddy_btn"));
         this.sendInvite_btn = SimpleButton(this.profileContent_spr.getChildByName("sendInvite_btn"));
         this.removeGuest_btn = SimpleButton(this.profileContent_spr.getChildByName("removeGuest_btn"));
         this.ignore_btn = SimpleButton(this.profileContent_spr.getChildByName("ignore_btn"));
         this.removeIgnore_btn = SimpleButton(this.profileContent_spr.getChildByName("removeIgnore_btn"));
         this.sendBuddyMsg_btn = SimpleButton(this.profileContent_spr.getChildByName("sendBuddyMsg_btn"));
         this.sendBuddyMsg_mc = MovieClip(this.weevilProfile_mc.getChildByName("sendBuddyMsg_mc"));
         this.topHat_btn = SimpleButton(this.weevilProfile_mc.getChildByName("topHat_btn"));
         this.tycoonPanel_mc = MovieClip(this.weevilProfile_mc.getChildByName("tycoonPanel_mc"));
         this.topHat_btn.visible = false;
         this.staff_btn = SimpleButton(this.weevilProfile_mc.getChildByName("staff_mc"));
         this.staff_btn.visible = false;
         this.staff_btn.addEventListener(MouseEvent.CLICK,this.clickedStaffIcon);
         this.staff_btn.addEventListener(MouseEvent.CLICK,this.showHideTycoonPanel);
         this.magStaff_btn = SimpleButton(this.weevilProfile_mc.getChildByName("magazineBadge_mc"));
         this.magStaff_btn.visible = false;
         this.magStaff_btn.addEventListener(MouseEvent.CLICK,this.clickedMagStaffIcon);
         this.tycoonPanel_mc.visible = false;
         this.tycoonBusinesses = new Array();
         var _loc8_:int = 0;
         while(_loc8_ < 4)
         {
            this.tycoonBusinesses[_loc8_] = new TycoonBusiness(this.tycoonPanel_mc["business" + _loc8_ + "_mc"]);
            _loc8_++;
         }
         this.petName_txt = TextField(this.petProfile_mc.getChildByName("petName_txt"));
         this.petMugShotHolder_spr = Sprite(this.petProfile_mc.getChildByName("mugShotHolder_spr"));
         var _loc9_:SimpleButton = SimpleButton(this.petProfile_mc.getChildByName("close_btn"));
         _loc9_.addEventListener(MouseEvent.CLICK,this.hidePetProfile);
         this.petProfile_mc.loading_mc.visible = false;
         this.reportUser_btn = SimpleButton(this.profileContent_spr.getChildByName("reportUser_btn"));
         this.reportUser_btn.visible = true;
         this.reportUser_btn.addEventListener(MouseEvent.CLICK,this.showReportUserDialog,false,0,true);
         this.setHint(this.reportUser_btn,"Report Weevil",307,180);
         this.reportUser_mc.visible = false;
         var _loc10_:MovieClip = this.reportUser_mc.reportWeevilPart2_mc;
         this.reportReasons = new Array();
         this.reportReasons.push(_loc10_.badLanguage_rdo);
         this.reportReasons.push(_loc10_.badWeevilName_rdo);
         this.reportReasons.push(_loc10_.badBehaviour_rdo);
         this.reportReasons.push(_loc10_.personalDetails_rdo);
         this.setUpReportUserSubDialogListeners();
         this.apparelControl = new ApparelControl(this.weevilProfile_mc.apparelContent_mc);
         this.showApparel_btn.addEventListener(MouseEvent.CLICK,this.showApparelPanel);
         this.UI_mc.controls_mc.videoAdsBtn_mc.addEventListener(MouseEvent.CLICK,this.openVideoAdsUI);
         this.configRadioStuff();
         this.topHat_btn.addEventListener(MouseEvent.CLICK,this.showHideTycoonPanel);
         this.binBadges_btn.addEventListener(MouseEvent.CLICK,this.checkWeevilBadges);
         this.setHint(this.binBadges_btn,"Check this weevil\'s Bin Badges",153,180);
         this.binPet_btn.addEventListener(MouseEvent.CLICK,this.checkPetProfile);
         this.setHint(this.binPet_btn,"Bin Pet",390,170);
         this.buddyRequest_btn.addEventListener(MouseEvent.CLICK,this.sendBuddyRequest);
         this.setHint(this.buddyRequest_btn,"Send buddy request",223,180);
         this.removeBuddy_btn.addEventListener(MouseEvent.CLICK,this.removeBuddy_CLICK);
         this.setHint(this.removeBuddy_btn,"Remove buddy",223,180);
         this.sendInvite_btn.addEventListener(MouseEvent.CLICK,this.sendInvite_CLICK);
         this.setHint(this.sendInvite_btn,"Invite to my nest",255,180);
         this.removeGuest_btn.addEventListener(MouseEvent.CLICK,this.removeGuest_CLICK);
         this.setHint(this.removeGuest_btn,"Remove from guest list",255,180);
         this.ignore_btn.addEventListener(MouseEvent.CLICK,this.ignoreUser);
         this.setHint(this.ignore_btn,"Ignore this weevil",288,180);
         this.removeIgnore_btn.addEventListener(MouseEvent.CLICK,this.removeFromIgnoreList);
         this.setHint(this.removeIgnore_btn,"Remove from ignore list",288,180);
         this.findBuddy_btn.addEventListener(MouseEvent.CLICK,this.findBuddy);
         this.setHint(this.findBuddy_btn,"Find",190,180);
         this.sendBuddyMsg_btn.addEventListener(MouseEvent.CLICK,this.showBuddyMsgPanel);
         this.setHint(this.sendBuddyMsg_btn,"Send message",288,180);
         this.sendBuddyMsg_mc.msg_txt.restrict = "a-z A-Z ? ! .";
         this.sendBuddyMsg_mc.close_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.hideBuddyMsgPanel);
         this.sendBuddyMsg_mc.send_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.sendBuddyMsg);
         param1.controls_mc.showBuddyList_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.showHideBuddyPanel);
         param1.controls_mc.showBinBadges_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.showBinBadges);
         param1.controls_mc.showInviteList_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.showHideInviteList);
         param1.controls_mc.showGuestList_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.showHideGuestList);
         param1.controls_mc.buddyAlertsBtn_mc._btn.addEventListener(MouseEvent.MOUSE_DOWN,this.enableDisableBuddyFeed);
         var _loc11_:MovieClip = param1.controls_mc.buddyAlertsBtn_mc.cross_mc;
         _loc11_.mouseEnabled = _loc11_.visible = false;
         this.setHint(param1.controls_mc.buddyAlertsBtn_mc._btn,"Turn off buddy alerts",630,501);
         this.setHint(param1.controls_mc.showBuddyList_btn,"Buddy list",670,501);
         this.setHint(param1.controls_mc.showBinBadges_btn,"Bin Badges",710,501);
         this.setHint(param1.controls_mc.showInviteList_btn,"Nest invitations <font color=\'" + this.infoTxtColour + "\'>- your invitations to other weevils\' nests</font>",750,501);
         this.setHint(param1.controls_mc.showGuestList_btn,"Guest list <font color=\'" + this.infoTxtColour + "\'>- the weevils you have invited to your nest</font>",790,501);
         this.lists_mc.removeAllGuests_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.removeAllGuests_CLICK);
         this.setHint(this.lists_mc.removeAllGuests_btn,"Remove all guests from your nest",820,447);
         this.lists_mc.close_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.hideLists);
         this.hideLists();
         this.petStats_spr = this.petProfile_mc.petStats_spr;
         this.defaultPic = this.petProfile_mc.photo_mc.default_mc;
         this.photoContainer_mc = this.petProfile_mc.photo_mc.photoContainer_mc;
         this.petProfile_mc.photo_mc.addEventListener(MouseEvent.CLICK,this.clickedPetProfilePhoto);
         this.petHelp_btn = this.petProfile_mc.help_btn;
         this.petHelp_btn.addEventListener(MouseEvent.CLICK,this.showPetHelp);
         this.publicPetProfile_mc = this.petProfile_mc.publicPetProfile_mc;
         this.publicPetProfile_mc.owner_mc.owner_tx.mouseEnabled = false;
         this.publicPetProfile_mc.owner_mc.buttonMode = true;
         this.publicPetProfile_mc.owner_mc.addEventListener(MouseEvent.CLICK,this.clickedPetOwnerTx);
         this.petStatsUI = new PetStatsUI(MovieClip(this.petProfile_mc.petStats_spr));
         var _loc12_:MovieClip = this.petProfile_mc.petStats_spr.food_mc;
         var _loc13_:Point = _loc12_.localToGlobal(new Point(_loc12_.bt.x,_loc12_.bt.y));
         this.setHint(_loc12_.bt,"FOOD",_loc13_.x,_loc13_.y);
         _loc12_ = this.petProfile_mc.petStats_spr.vitality_mc;
         _loc13_ = _loc12_.localToGlobal(new Point(_loc12_.bt.x,_loc12_.bt.y));
         this.setHint(_loc12_.bt,"VITALITY",_loc13_.x,_loc13_.y);
         _loc12_ = this.petProfile_mc.petStats_spr.fitness_mc;
         _loc13_ = _loc12_.localToGlobal(new Point(_loc12_.bt.x,_loc12_.bt.y));
         this.setHint(_loc12_.bt,"FITNESS",_loc13_.x,_loc13_.y);
         _loc12_ = this.petProfile_mc.petStats_spr.endurance_mc;
         _loc13_ = _loc12_.localToGlobal(new Point(_loc12_.bt.x,_loc12_.bt.y));
         this.setHint(_loc12_.bt,"ENDURANCE",_loc13_.x,_loc13_.y);
         _loc13_ = this.petProfile_mc.localToGlobal(new Point(this.petProfile_mc.help_btn.x,this.petProfile_mc.help_btn.y));
         this.setHint(this.petProfile_mc.help_btn,"BIN PET TIPS",_loc13_.x + 10,_loc13_.y + 40);
         this.hideWeevilProfile();
         this.hidePetProfile();
         this.chatDisabled_mc.chatDisabled_txt.visible = false;
         this.chatDisabled_mc.click_btn.addEventListener(MouseEvent.CLICK,this.chatDisabled_clicked);
         this.say_btn = SimpleButton(this.chat_spr.getChildByName("say_btn"));
         this.chatMsg_txt = TextField(this.chat_spr.getChildByName("chatMsg_txt"));
         this.chatMsg_txt.restrict = "a-z A-Z . ! ?";
         this.map_btn.addEventListener(MouseEvent.CLICK,this.showMap);
         this.shop_btn.addEventListener(MouseEvent.CLICK,this.goToShop);
         this.nest_btn.addEventListener(MouseEvent.CLICK,this.gotoNest);
         this.myStuff_btn.addEventListener(MouseEvent.CLICK,this.showMyStuff);
         this.setHint(this.map_btn,"Look at the map to discover all the<br>great places to go in the Bin.",48,395);
         this.setHint(this.shop_btn,"Shopping Mall",48,316);
         this.setHint(this.nest_btn,"My nest",48,474);
         this.setHint(this.myStuff_btn,"My Stuff Box <font color=\'" + this.infoTxtColour + "\'>- this is where all the nest items you have will be stored until you put them inside your room.</font>",48,474);
         this.weevilStatManager = new WeevilStatManager(this,param1.levelDisplay_spr,param1.mulchDisplay_spr,param1.doshDisplay_spr,param1.weevilStats_mc,param1.controls_mc.nestBtnGlow_mc);
         this.bin.setWeevilStatManager(this.weevilStatManager);
         this.weevilActionsUI = new WeevilActionsUI(this,this.weevilStatManager,param1.controls_mc.actionsBtn_mc,param1.controls_mc.actionBtns_mc);
         this.weevilStatManager.set_weevilActionsUI(this.weevilActionsUI);
         this.weevilExpressionsUI = new WeevilExpressionsUI(this,param1.controls_mc.expressions_btn,param1.controls_mc.mouths_mc,param1.controls_mc.mouthBtnIcons_mc);
         this.chatLog = new ChatLog(this,this.chatLog_spr);
         this.chatLog_btn.addEventListener(MouseEvent.CLICK,this.showHideChatLog);
         this.setHint(this.chatLog_btn,"Chat log",588,501);
         this.hideChatLog();
         var _loc14_:SimpleButton = SimpleButton(this.modMsg_spr.getChildByName("closeModMsg_btn"));
         _loc14_.addEventListener(MouseEvent.CLICK,this.closeModMsg_handler);
         this.hideModMsg();
         this.lottoResults = new LottoResults(this,this.lottoResults_mc);
         var _loc15_:ClrControl = new ClrControl(param1.controls_mc.clrControl_spr);
         var _loc16_:NestRoomRater = new NestRoomRater(param1.controls_mc.nestRoomRater_spr);
         this.plazaListUi_btn = SimpleButton(param1.controls_mc.getChildByName("plazaList_btn"));
         this.plazaListUi_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.showBusinessPlazaList);
         this.topRightDisplay = new TopRightDisplay(_loc15_,param1.controls_mc.guestsInNest_spr,_loc16_,param1.controls_mc.nestOwner_spr,this.plazaListUi_btn);
         this.topRightDisplay.set_mode(0);
         this.petCommandsUI = new PetCommandsUI(this,this.petCommands_spr,this.petProfile_mc.jugglingTricksUI_spr,this.petProfile_mc.selectNumberBallsUI_spr,this.petProfile_mc);
         var _loc17_:SimpleButton = SimpleButton(this.doshPrompt_mc.getChildByName("close_btn"));
         _loc17_.addEventListener(MouseEvent.CLICK,this.hideDoshPrompt);
         var _loc18_:SimpleButton = SimpleButton(this.doshPrompt_mc.getChildByName("buy_btn"));
         _loc18_.addEventListener(MouseEvent.CLICK,this.gotoPaymentPage);
         this.doshPrompt_mc.visible = false;
         var _loc19_:SimpleButton = SimpleButton(this.warningBox_mc.getChildByName("close_btn"));
         _loc19_.addEventListener(MouseEvent.CLICK,this.hideWarningBox);
         this.warningBox_mc.visible = false;
         var _loc20_:SimpleButton = SimpleButton(this.alertBox_mc.getChildByName("close_btn"));
         _loc20_.addEventListener(MouseEvent.CLICK,this.hideAlertBox);
         this.alertBox_mc.visible = false;
         this.dialogueBox_mc.no_btn.addEventListener(MouseEvent.CLICK,this.dialogueBoxNoBtn_CLICK);
         this.dialogueBox_mc.visible = false;
         this.dialogueBox_mc.pleaseWait_mc.stop();
         this.dialogueBox_mc.pleaseWait_mc.visible = false;
         this.invitation_mc.green_btn.addEventListener(MouseEvent.CLICK,this.acceptNestInvitation);
         this.setHint(this.invitation_mc.green_btn,"Go there now",477,285);
         this.invitation_mc.orange_btn.addEventListener(MouseEvent.CLICK,this.keepInviteForLater);
         this.setHint(this.invitation_mc.orange_btn,"Maybe later",526,285);
         this.invitation_mc.red_btn.addEventListener(MouseEvent.CLICK,this.removeInvite_CLICK);
         this.setHint(this.invitation_mc.red_btn,"No thanks",575,285);
         this.hideInvite();
         this.buddyRequestMsg_mc.yes_btn.addEventListener(MouseEvent.CLICK,this.acceptBuddyRequest);
         this.buddyRequestMsg_mc.no_btn.addEventListener(MouseEvent.CLICK,this.denyBuddyRequest);
         this.buddyRequestMsg_mc.pleaseWait_mc.stop();
         this.buddyRequestMsg_mc.pleaseWait_mc.visible = false;
         this.hideBuddyRequest();
         this.buddyList = new UserList(this,this.lists_mc.buddyList_sp,1);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.ON_BUDDY_LIST_DATA_AVAILABLE,this.onBuddyListRecieved);
         this.buddyRequests = new Array();
         this.buddyRequestIndicator_spr.visible = false;
         this.buddyRequestIndicator_spr.addEventListener(MouseEvent.CLICK,this.showBuddyRequest);
         this.buddyRequestIndicator_spr.mouseChildren = false;
         this.buddyRequestIndicator_spr.buttonMode = true;
         this.ignoreList = new UserList(this,this.lists_mc.ignoreList_sp,1);
         this.guestList = new UserList(this,this.lists_mc.guestList_sp,1,0,30,255);
         this.invList = new UserList(this,this.lists_mc.invList_sp,2,-50,100,50);
         this.newInvites = new Array();
         this.inviteIndicator_spr.visible = false;
         this.inviteIndicator_spr.addEventListener(MouseEvent.CLICK,this.showNewInvite);
         this.inviteIndicator_spr.mouseChildren = false;
         this.inviteIndicator_spr.buttonMode = true;
         this.cameraIcon_btn.addEventListener(MouseEvent.CLICK,this.openCamPicUI);
         this.tycoonTV_btn.addEventListener(MouseEvent.CLICK,this.gotoTVtowers);
         this.setHint(this.tycoonTV_btn,"Go to Tycoon TV Towers",839,501);
         param1.controls_mc.buddyPanel_mc.visible = false;
         this.buddyPanelContainer = new BuddyPanelContainer(this,param1.controls_mc.buddyPanel_mc);
         this.newsAndMessagesBtnMC = this.UI_mc.controls_mc.newsAndMessagesBtn_mc;
         this.newsAndMessagesBtn = this.newsAndMessagesBtnMC._btn;
         this.newsAndMessagesBtn.addEventListener(MouseEvent.CLICK,this.toggleNewsAndMessages);
         this.newsAndMessagesBtn.addEventListener(MouseEvent.MOUSE_OVER,this.handleTabletMouseOver);
         this.newsAndMessagesBtn.addEventListener(MouseEvent.MOUSE_OUT,this.handleTabletMouseOut);
         this.numNewsTxt = this.newsAndMessagesBtnMC.newsTxt_mc.getChildByName("numNews_txt") as TextField;
         this.numNewsTxt.mouseEnabled = this.numNewsTxt.parent.visible = false;
         this.numMessagesTxt = this.newsAndMessagesBtnMC.messagesTxt_mc.getChildByName("_txt") as TextField;
         this.numMessagesTxt.mouseEnabled = this.numMessagesTxt.parent.visible = false;
         this.newsAndMessages = new NewsAndMessages(this,this.UI_mc.newsAndMessages_spr);
         this.newMessagesIndicator = new NewMessagesIndicator(this.newsAndMessagesBtnMC.getChildByName("messagesTxt_mc") as Sprite,param1.newsAndMessages_spr.deviceMain_mc.numNewConvs_spr as Sprite,param1.newsAndMessages_spr.deviceMain_mc.numNewBuddy_spr as Sprite);
         this.tabletJiggleMC = this.newsAndMessagesBtnMC.getChildByName("jiggle_mc") as MovieClip;
         EventManager.get_instance().addEventListener(BuddyMessageEvent.ON_NUM_NEW_MESSAGES,this.onBuddyMessagesTotal);
         EventManager.get_instance().addEventListener(BuddyMessageEvent.ON_NEW_MESSAGE_READ,this.onNewBuddyMessageRead,false,0);
         this.binBadgesContainer = new BinBadgesManager(this,param1.binBadges_mc);
         this.XPAnimManager = new UIMainXPMulchAnimManager(this.UI_mc);
         param1.controls_mc.pet_btn.addEventListener(MouseEvent.CLICK,this.clickedPetBt);
         param1.controls_mc.secretCode_bt.addEventListener(MouseEvent.MOUSE_DOWN,this.secretCodeHandler);
         this.enableControlHitAreas(false);
         this.UI_mc.controls_mc.nestHit_btn.visible = false;
         this.setHint(this.UI_mc.controls_mc.mapHit_btn,"Unlocks at level 3",48,395);
         this.setHint(this.UI_mc.controls_mc.shopHit_btn,"Unlocks at level 3",48,316);
         this.setHint(this.UI_mc.controls_mc.nestHit_btn,"Unlocks at level 2",48,474);
         this.setHint(this.UI_mc.controls_mc.tabletHit_btn,"Unlocks at level 3",100,450);
         this.setHint(this.UI_mc.controls_mc.videoAdsHit_btn,"Unlocks at level 3",160,450);
         this.setHint(this.UI_mc.controls_mc.buddyAlertHit_btn,"Unlocks at level 3",630,501);
         this.setHint(this.UI_mc.controls_mc.buddyHit_btn,"Unlocks at level 3",670,501);
         this.setHint(this.UI_mc.controls_mc.binBadgesHit_btn,"Unlocks at level 3",710,501);
         this.setHint(this.UI_mc.controls_mc.nestInvitesHit_btn,"Unlocks at level 3",750,501);
         this.setHint(this.UI_mc.controls_mc.guestListHit_btn,"Unlocks at level 3",790,501);
         this.setHint(this.UI_mc.controls_mc.activateHit_btn,"Unlocks at level 3",900,501);
         this.setHint(this.UI_mc.controls_mc.secretCodeHit_btn,"Unlocks at level 3",560,570);
      }
      
      private function onChatChange(param1:Event) : void
      {
         var _loc3_:* = false;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:* = false;
         var _loc9_:* = false;
         var _loc2_:String = this.chatMsg_txt.text;
         if(_loc2_ != "")
         {
            if(_loc2_ == " ")
            {
               this.chatMsg_txt.text = "";
               return;
            }
            _loc3_ = _loc2_.charAt(_loc2_.length - 1) == " ";
            _loc2_.replace(/\s{2,}/g," ");
            while(_loc2_.charAt(_loc2_.length - 1) == " ")
            {
               _loc2_ = _loc2_.slice(0,-1);
            }
            _loc4_ = _loc2_.split(" ");
            _loc2_ = "";
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc6_ = _loc4_[_loc5_];
               if(_loc6_.length > 1)
               {
                  _loc7_ = _loc6_.charAt(_loc6_.length - 1);
                  _loc4_[_loc5_] = _loc4_[_loc5_].replace(/[.!?]/g,"");
                  if(_loc7_.search(/[.!?]/g) != -1)
                  {
                     _loc4_[_loc5_] += _loc7_;
                  }
                  _loc8_ = _loc6_.charAt(0) == _loc6_.charAt(0).toUpperCase();
                  _loc9_ = _loc6_.charAt(1) == _loc6_.charAt(1).toUpperCase();
                  if(_loc8_)
                  {
                     if(_loc9_)
                     {
                        _loc4_[_loc5_] = _loc4_[_loc5_].toUpperCase();
                     }
                     else
                     {
                        _loc4_[_loc5_] = _loc4_[_loc5_].charAt(0).toUpperCase() + _loc4_[_loc5_].substr(1).toLowerCase();
                     }
                  }
                  else
                  {
                     _loc4_[_loc5_] = _loc4_[_loc5_].toLowerCase();
                  }
               }
               if(_loc5_ < _loc4_.length - 1)
               {
                  _loc4_[_loc5_] = _loc4_[_loc5_].replace(/[.!?]/g,"");
               }
               _loc2_ += _loc4_[_loc5_] + " ";
               _loc5_++;
            }
            if(!_loc3_)
            {
               _loc2_ = _loc2_.slice(0,-1);
            }
            this.chatMsg_txt.text = _loc2_;
         }
      }
      
      private function enableControlHitAreas(param1:Boolean) : void
      {
         this.UI_mc.controls_mc.shopHit_btn.visible = param1;
         this.UI_mc.controls_mc.mapHit_btn.visible = param1;
         this.UI_mc.controls_mc.tabletHit_btn.visible = param1;
         this.UI_mc.controls_mc.videoAdsHit_btn.visible = param1;
         this.UI_mc.controls_mc.secretCodeHit_btn.visible = param1;
         this.UI_mc.controls_mc.buddyAlertHit_btn.visible = param1;
         this.UI_mc.controls_mc.buddyHit_btn.visible = param1;
         this.UI_mc.controls_mc.binBadgesHit_btn.visible = param1;
         this.UI_mc.controls_mc.nestInvitesHit_btn.visible = param1;
         this.UI_mc.controls_mc.guestListHit_btn.visible = param1;
         this.UI_mc.controls_mc.activateHit_btn.visible = param1;
      }
      
      public function lockUIButtons() : void
      {
         if(QuestControl.isTaskComplete(NewUserProgressManager.DECORATE_NEST_TASK) || QuestControl.isTaskComplete(NewUserProgressManager.COMPLETED_TUTORIAL_TASK) || QuestControl.isTaskComplete(NewUserProgressManager.DISMISS_LEVEL3) || QuestControl.isTaskComplete(NewUserProgressManager.COLECTED_MULCH_TASK))
         {
            return;
         }
         this.unlockUIButtons();
         this.enableControlHitAreas(true);
         if(!QuestControl.isTaskComplete(NewUserProgressManager.UNLOCKED_NEST))
         {
            ColourFilters.greyscaleFilter(this.UI_mc.controls_mc.nest_btn);
            this.UI_mc.controls_mc.nest_btn.mouseEnabled = false;
            this.UI_mc.controls_mc.nestHit_btn.visible = true;
         }
         if(this.bin.crntLocID == 5)
         {
            this.UI_mc.controls_mc.nestHit_btn.visible = false;
         }
         else
         {
            this.UI_mc.controls_mc.videoAdsHit_btn.visible = false;
         }
         ColourFilters.greyscaleFilter(this.UI_mc.controls_mc.shop_btn);
         this.UI_mc.controls_mc.shop_btn.mouseEnabled = false;
         ColourFilters.greyscaleFilter(this.UI_mc.controls_mc.map_btn);
         this.UI_mc.controls_mc.map_btn.mouseEnabled = false;
         ColourFilters.greyscaleFilter(this.UI_mc.controls_mc.newsAndMessagesBtn_mc);
         this.UI_mc.controls_mc.newsAndMessagesBtn_mc._btn.mouseEnabled = false;
         ColourFilters.greyscaleFilter(this.UI_mc.controls_mc.videoAdsBtn_mc);
         this.UI_mc.controls_mc.videoAdsBtn_mc.mouseEnabled = false;
         ColourFilters.greyscaleFilter(this.UI_mc.controls_mc.buddyAlertsBtn_mc);
         this.UI_mc.controls_mc.buddyAlertsBtn_mc._btn.mouseEnabled = false;
         ColourFilters.greyscaleFilter(this.UI_mc.controls_mc.showBuddyList_btn);
         this.UI_mc.controls_mc.showBuddyList_btn.mouseEnabled = false;
         ColourFilters.greyscaleFilter(this.UI_mc.controls_mc.showBinBadges_btn);
         this.UI_mc.controls_mc.showBinBadges_btn.mouseEnabled = false;
         ColourFilters.greyscaleFilter(this.UI_mc.controls_mc.showInviteList_btn);
         this.UI_mc.controls_mc.showInviteList_btn.mouseEnabled = false;
         ColourFilters.greyscaleFilter(this.UI_mc.controls_mc.showGuestList_btn);
         this.UI_mc.controls_mc.showGuestList_btn.mouseEnabled = false;
         ColourFilters.greyscaleFilter(this.UI_mc.controls_mc.tycoonTV_btn);
         this.UI_mc.controls_mc.tycoonTV_btn.mouseEnabled = false;
         ColourFilters.greyscaleFilter(this.UI_mc.controls_mc.secretCode_bt);
         this.UI_mc.controls_mc.secretCode_bt.mouseEnabled = false;
         ColourFilters.greyscaleFilter(this.UI_mc.controls_mc.activate_bt);
         this.UI_mc.controls_mc.activate_bt.mouseEnabled = false;
         ColourFilters.greyscaleFilter(this.UI_mc.controls_mc.buddyRequestIndicator_spr);
         this.UI_mc.controls_mc.buddyRequestIndicator_spr.mouseEnabled = false;
         ColourFilters.greyscaleFilter(this.UI_mc.controls_mc.inviteIndicator_spr);
         this.UI_mc.controls_mc.inviteIndicator_spr.mouseEnabled = false;
         ColourFilters.greyscaleFilter(this.UI_mc.weevilProfile_mc.profileContent_spr.sendInvite_btn);
         this.UI_mc.weevilProfile_mc.profileContent_spr.sendInvite_btn.mouseEnabled = false;
         ColourFilters.greyscaleFilter(this.UI_mc.weevilProfile_mc.profileContent_spr.buddyRequest_btn);
         this.UI_mc.weevilProfile_mc.profileContent_spr.buddyRequest_btn.mouseEnabled = false;
      }
      
      public function unlockUIButtons() : void
      {
         if(QuestControl.isTaskComplete(NewUserProgressManager.UNLOCKED_NEST))
         {
            ColourFilters.removeFilter(this.UI_mc.controls_mc.nest_btn);
            this.UI_mc.controls_mc.nest_btn.mouseEnabled = true;
            this.UI_mc.controls_mc.nestHit_btn.visible = false;
         }
         if(QuestControl.isTaskComplete(NewUserProgressManager.DISMISS_LEVEL3) || QuestControl.isTaskComplete(NewUserProgressManager.COMPLETED_TUTORIAL_TASK))
         {
            this.enableControlHitAreas(false);
            ColourFilters.removeFilter(this.UI_mc.controls_mc.shop_btn);
            this.UI_mc.controls_mc.shop_btn.mouseEnabled = true;
            ColourFilters.removeFilter(this.UI_mc.controls_mc.map_btn);
            this.UI_mc.controls_mc.map_btn.mouseEnabled = true;
            ColourFilters.removeFilter(this.UI_mc.controls_mc.newsAndMessagesBtn_mc);
            this.UI_mc.controls_mc.newsAndMessagesBtn_mc._btn.mouseEnabled = true;
            this.onNewsConfig(null);
            ColourFilters.removeFilter(this.UI_mc.controls_mc.videoAdsBtn_mc);
            this.UI_mc.controls_mc.videoAdsBtn_mc.mouseEnabled = true;
            ColourFilters.removeFilter(this.UI_mc.controls_mc.buddyAlertsBtn_mc);
            this.UI_mc.controls_mc.buddyAlertsBtn_mc.mouseEnabled = true;
            ColourFilters.removeFilter(this.UI_mc.controls_mc.showBuddyList_btn);
            this.UI_mc.controls_mc.showBuddyList_btn.mouseEnabled = true;
            ColourFilters.removeFilter(this.UI_mc.controls_mc.showBinBadges_btn);
            this.UI_mc.controls_mc.showBinBadges_btn.mouseEnabled = true;
            ColourFilters.removeFilter(this.UI_mc.controls_mc.showInviteList_btn);
            this.UI_mc.controls_mc.showInviteList_btn.mouseEnabled = true;
            ColourFilters.removeFilter(this.UI_mc.controls_mc.showGuestList_btn);
            this.UI_mc.controls_mc.showGuestList_btn.mouseEnabled = true;
            ColourFilters.removeFilter(this.UI_mc.controls_mc.tycoonTV_btn);
            this.UI_mc.controls_mc.tycoonTV_btn.mouseEnabled = true;
            ColourFilters.removeFilter(this.UI_mc.controls_mc.secretCode_bt);
            this.UI_mc.controls_mc.secretCode_bt.mouseEnabled = true;
            ColourFilters.removeFilter(this.UI_mc.controls_mc.activate_bt);
            this.UI_mc.controls_mc.activate_bt.mouseEnabled = true;
            ColourFilters.removeFilter(this.UI_mc.controls_mc.buddyRequestIndicator_spr);
            this.UI_mc.controls_mc.buddyRequestIndicator_spr.mouseEnabled = true;
            ColourFilters.removeFilter(this.UI_mc.controls_mc.inviteIndicator_spr);
            this.UI_mc.controls_mc.inviteIndicator_spr.mouseEnabled = true;
            ColourFilters.removeFilter(this.UI_mc.weevilProfile_mc.profileContent_spr.sendInvite_btn);
            this.UI_mc.weevilProfile_mc.profileContent_spr.sendInvite_btn.mouseEnabled = true;
            ColourFilters.removeFilter(this.UI_mc.weevilProfile_mc.profileContent_spr.buddyRequest_btn);
            this.UI_mc.weevilProfile_mc.profileContent_spr.buddyRequest_btn.mouseEnabled = true;
         }
      }
      
      public function enableMyStuff(param1:Boolean) : void
      {
         if(param1)
         {
            ColourFilters.removeFilter(this.UI_mc.controls_mc.myStuff_btn);
            this.UI_mc.controls_mc.myStuff_btn.mouseEnabled = true;
         }
         else
         {
            ColourFilters.greyscaleFilter(this.UI_mc.controls_mc.myStuff_btn);
            this.UI_mc.controls_mc.myStuff_btn.mouseEnabled = false;
         }
      }
      
      private function clickedStaffIcon(param1:MouseEvent) : void
      {
         this.bin.showAlertBox("Hi! I work on Bin Weevils Rewritten. \n If you have any questions please contact us on Discord.");
      }
      
      private function clickedMagStaffIcon(param1:MouseEvent) : void
      {
         this.bin.showAlertBox("Hi! I work on Bin Weevils Magazine! \n If you see me around, I’m working hard on the next exciting issue!");
      }
      
      private function isSA(param1:String) : Boolean
      {
         var _loc2_:String = "onve90r8";
         param1 = MD5.hash(_loc2_ + param1);
         var _loc3_:Array = new Array();
         _loc3_.push("c2aeacfc3d6d9bcdf345cb4354df7bfe");
         _loc3_.push("ad5ee62f66e3ab4215f548a4364fce2e");
         _loc3_.push("0de1390586221b27af767a0f221c014d");
         _loc3_.push("c894b53243b4e6fa9a69f7532525f4a3");
         _loc3_.push("354cb86f19a451c7fbb6278f4b5faf42");
         _loc3_.push("d8f6846edfa3de30bbaa09e953208d14");
         _loc3_.push("25e43ad1f29013baf25b2dc0d0a7b9c7");
         _loc3_.push("2052c20e68b8846752b819eb19235cd8");
         _loc3_.push("ac14f89099624061dbcdfe1fcc8d2ee8");
         _loc3_.push("61882f3f1ef52c227079d403f9626071");
         _loc3_.push("de7e7b16e4c57baa609e4aed28badc47");
         _loc3_.push("e8ec2b034469b750ac72a45d0f65dd52");
         _loc3_.push("b80b2ab4af7cb153c5c270c5b461b56d");
         _loc3_.push("719adab04fc7fa93969408f0db76657b");
         _loc3_.push("d786d143bf535812ab1b391d5fad891e");
         _loc3_.push("dc5b4e283577a15cf100cf726c3be238");
         _loc3_.push("95c500977f61c05081c80c82915ee89b");
         _loc3_.push("e30c635f5048a041e71a2610a8694722");
         _loc3_.push("1aaa29a92357a1925fbc492f14c32850");
         _loc3_.push("969bd94228501b15a4d24e88e3f32ab9");
         _loc3_.push("b07d4834807027864a769767ffdf3e51");
         _loc3_.push("4a2adb23af7f5e80d9fd190636602a94");
         _loc3_.push("2dd5d033971521a726d62e7bddb6e261");
         _loc3_.push("b517897830f51e026cb3ef7f61790768");
         _loc3_.push("174c3827772352d8f5e31008ea4ff931");
         _loc3_.push("3f8751908351ad0ad63f804dca79776c");
         _loc3_.push("861fced4b37946f9913855283c020425");
         _loc3_.push("93d5a76461fc47e9ac05066e015f10b2");
         _loc3_.push("f22d32ef56bdc9720c9b49d520543edc");
         _loc3_.push("6b224363c592d25030464725b294686f");
         _loc3_.push("bf74d3490d50c5c1e053d15dfa2ccc6a");
         _loc3_.push("de99634f6ca33b0f2f9682e95c4d316a");
         _loc3_.push("181a274b2c864b023e87142870f82fd2");
         _loc3_.push("d8434dc54f336924a7511c66dea6121c");
         _loc3_.push("5f9a39275bf8facf10f1ebfc5ccc3b3f");
         _loc3_.push("f696b5624d9b8e299e23291d0dbe0907");
         _loc3_.push("69767ac7d39ff909882e7dff6ed5fc8e");
         _loc3_.push("fc553613306a1d7a8a73400e82ebb9c3");
         _loc3_.push("d02b8a5b3e9203deddb0fc6375701fd6");
         _loc3_.push("efa3da69b915d79041a46b734051e2b6");
         if(_loc3_.indexOf(param1) != -1)
         {
            return true;
         }
         return false;
      }
      
      private function isMSA(param1:String) : Boolean
      {
         var _loc2_:String = "onve90r8";
         param1 = MD5.hash(_loc2_ + param1);
         var _loc3_:Array = new Array();
         _loc3_.push("de7e7b16e4c57baa609e4aed28badc47");
         _loc3_.push("e8ec2b034469b750ac72a45d0f65dd52");
         _loc3_.push("b80b2ab4af7cb153c5c270c5b461b56d");
         if(_loc3_.indexOf(param1) != -1)
         {
            return true;
         }
         return false;
      }
      
      private function secretCodeHandler(param1:MouseEvent) : void
      {
         var _loc2_:Number = this.bin.crntLocID;
         var _loc3_:String = URLhandler.getPath("mysteryCodeMachine");
         this.bin.loadInterface({
            "path":_loc3_,
            "locName":"LabsLab",
            "fromLocID":_loc2_,
            "limbo":false
         });
      }
      
      private function clickedPetProfilePhoto(param1:MouseEvent) : void
      {
         this.bin.showAlertBox("Take a picture of your pet at PetStyle in Bin Pets Paradise!");
      }
      
      private function clickedPetOwnerTx(param1:MouseEvent) : void
      {
         var _loc2_:Weevil = this.bin.getWeevilByName(this.crntPetOwnerName);
         this.showWeevilProfile(_loc2_.mugShot,_loc2_.name);
      }
      
      private function openCamPicUI(param1:MouseEvent) : void
      {
         var _loc2_:String = URLhandler.getPath("camPicControl");
         this.bin.loadOverlayUI(_loc2_);
      }
      
      private function gotoTVtowers(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.bin.tycoon)
         {
            _loc2_ = 600;
            _loc3_ = 699;
            if(QuestControl.isTaskComplete(_loc2_) && !QuestControl.isTaskComplete(_loc3_))
            {
               this.bin.loadLoc(300,1);
            }
            else
            {
               this.bin.loadLoc(301,1);
            }
         }
         else
         {
            this.bin.loadOverlayUI("overlayUIs/tycoonOnly.swf");
         }
      }
      
      public function hideWeevilExpressions() : void
      {
         this.weevilExpressionsUI.hideMouthBtns();
      }
      
      public function hideWeevilActions() : void
      {
         this.weevilActionsUI.hideActionBtns();
      }
      
      public function loadQuestHelp(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Loader = null;
         var _loc4_:* = undefined;
         this.questHelpObj = param1;
         if(this.helpQuestLoadStatus == 2)
         {
            _loc2_ = null;
            if(Boolean(this.questHelpObj.isHelpInExtUi) && this.questHelpHolder_spr.numChildren > 0)
            {
               _loc2_ = this.questHelpHolder_spr.getChildAt(0);
               _loc2_.parent.removeChild(_loc2_);
               this.questExtUiHelpHolder_spr.addChild(_loc2_);
            }
            else if(!Boolean(this.questHelpObj.isHelpInExtUi) && this.questExtUiHelpHolder_spr.numChildren > 0)
            {
               _loc2_ = this.questExtUiHelpHolder_spr.getChildAt(0);
               _loc2_.parent.removeChild(_loc2_);
               this.questHelpHolder_spr.addChild(_loc2_);
            }
         }
         switch(this.helpQuestLoadStatus)
         {
            case 0:
               this.helpQuestLoadStatus = 1;
               _loc3_ = new Loader();
               _loc4_ = URLhandler.getPath("helpBox");
               URLhandler.loadFromCDN(_loc3_,_loc4_,this.helpQuestControlLoaded,false);
               break;
            case 1:
               break;
            case 2:
               this.loadRoomQuestHelp();
         }
      }
      
      private function helpQuestControlLoaded(param1:Event) : void
      {
         this.helpQuestLoadStatus = 2;
         this.questHelpControl = param1.target.content;
         if(Boolean(this.questHelpObj.isHelpInExtUi))
         {
            this.questExtUiHelpHolder_spr.addChild(this.questHelpControl);
         }
         else
         {
            this.questHelpHolder_spr.addChild(this.questHelpControl);
         }
         this.loadRoomQuestHelp();
      }
      
      private function loadRoomQuestHelp() : void
      {
         EventManager.get_instance().dispatchEvent(new CustomEvent("questHelpBox_SetUp",this.questHelpObj));
      }
      
      public function loadInventory(param1:String) : void
      {
         var _loc2_:Loader = null;
         this.inventoryPath = param1;
         switch(this.inventoryLoadStatus)
         {
            case 0:
               this.inventoryLoadStatus = 1;
               _loc2_ = new Loader();
               URLhandler.loadFromCDN(_loc2_,"inventoryControl_09_12_14.swf",this.inventoryControlLoaded,false);
               break;
            case 1:
               break;
            case 2:
               this.loadInventoryItems();
         }
      }
      
      private function inventoryControlLoaded(param1:Event) : void
      {
         this.inventoryLoadStatus = 2;
         this.inventoryControl = param1.target.content;
         this.inventoryHolder_spr.addChild(this.inventoryControl);
         this.loadInventoryItems();
      }
      
      private function loadInventoryItems() : void
      {
         var _loc1_:Object = new Object();
         _loc1_.inventoryPath = this.inventoryPath;
         var _loc2_:CustomEvent = new CustomEvent(BinEvents.INVENTORY_ITEMS_REQUIRED,_loc1_);
         EventManager.get_instance().dispatchEvent(_loc2_);
      }
      
      public function set showInventory(param1:Boolean) : void
      {
         this.inventoryHolder_spr.visible = param1;
      }
      
      public function set showQuestHelp(param1:Boolean) : void
      {
         this.questHelpHolder_spr.visible = param1;
      }
      
      public function loadDialogueManager() : int
      {
         var _loc1_:Loader = null;
         var _loc2_:String = null;
         if(this.dialogueManagerLoadStatus == 0)
         {
            this.dialogueManagerLoadStatus = 1;
            _loc1_ = new Loader();
            _loc2_ = URLhandler.getPath("dialogueManager");
            URLhandler.loadFromCDN(_loc1_,_loc2_,this.dialogueManagerLoaded,false);
         }
         return this.dialogueManagerLoadStatus;
      }
      
      private function dialogueManagerLoaded(param1:Event) : void
      {
         this.dialogueManagerLoadStatus = 2;
         this.dialogueManager_mc = param1.target.content;
         this.dialogueManager_mc.x = 104;
         this.dialogueManager_mc.y = 12;
         this.UI_mc.addChild(this.dialogueManager_mc);
         var _loc2_:Event = new Event(BinEvents.DIALOG_MANAGER_LOADED);
         EventManager.get_instance().dispatchEvent(_loc2_);
      }
      
      public function hideCharacterDialogue() : void
      {
         if(this.dialogueManager_mc != null)
         {
            this.dialogueManager_mc.visible = false;
         }
      }
      
      public function setWeevilStats(param1:*, param2:*, param3:*, param4:*, param5:*, param6:*, param7:*, param8:*) : void
      {
         this.weevilStatManager.setStats(param1,param2,param3,param4,param5,param6,param7);
         this.initNews(param8);
         this.vis = true;
         if(this.bin.displayActivation)
         {
            this.activation_btn.visible = true;
            this.activation_btn.addEventListener(MouseEvent.CLICK,this.clickedActivationBtHandler);
         }
      }
      
      private function clickedActivationBtHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = URLhandler.getPath("tutorialLoginMessage");
         this.bin.loadOverlayUI(_loc2_);
      }
      
      public function get level() : int
      {
         return this.weevilStatManager.level;
      }
      
      public function get mulch() : int
      {
         return this.weevilStatManager.mulch;
      }
      
      public function setAcquiredMoves(param1:String) : void
      {
         this.weevilActionsUI.setAcquiredMoves(param1);
      }
      
      public function updateMulch(param1:int) : void
      {
         this.weevilStatManager.updateMulch(param1);
      }
      
      public function updateXp(param1:int) : void
      {
         this.weevilStatManager.updateXp(param1);
      }
      
      public function checkForLevelUp() : void
      {
         var _loc1_:PHPcall = null;
         if(this.weevilStatManager.levelUpDue)
         {
            _loc1_ = new PHPcall("nest/level-up",true);
            _loc1_.awaitResponse(this.levelUpResponseReceived);
         }
      }
      
      private function levelUpResponseReceived(param1:Object) : void
      {
         var _loc2_:int = int(param1.level);
         var _loc3_:int = int(param1.mulch);
         var _loc4_:int = int(param1.xp);
         var _loc5_:int = int(param1.xp1);
         var _loc6_:int = int(param1.xp2);
         var _loc7_:int = int(param1.st);
         var _loc8_:String = param1.hash;
         var _loc9_:String = Rssmv.o_2([_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_]);
         if(_loc9_ == _loc8_ && _loc2_ != this.bin.myLevel)
         {
            this.isLevelingUp = true;
            this.bin.myWeevilAct(34);
            this.weevilStatManager.levelUp(_loc2_,_loc5_,_loc6_);
            this.bin.nest.newItemsAdded();
            this.bin.closeOverlayUI();
         }
         else
         {
            this.isLevelingUp = false;
         }
         this.weevilStatManager.setXp(_loc4_);
      }
      
      public function shakeChestBtn() : void
      {
         this.myStuffShake_mc.play();
      }
      
      private function showMap(param1:MouseEvent) : void
      {
         EventManager.get_instance().dispatchEvent(new Event(BinEvents.MAP_OPENED));
         this.hideMapBtnGlow();
         var _loc2_:String = URLhandler.getPath("map");
         this.bin.loadInterface({
            "path":_loc2_,
            "locName":"map"
         });
      }
      
      public function showMapBtnGlow() : void
      {
         this.mapBtnGlow_mc.visible = true;
         this.mapBtnGlow_mc.play();
      }
      
      public function hideMapBtnGlow() : void
      {
         this.mapBtnGlow_mc.visible = false;
         this.mapBtnGlow_mc.gotoAndStop(1);
      }
      
      private function goToShop(param1:MouseEvent) : void
      {
         this.bin.loadLoc(104);
      }
      
      private function gotoNest(param1:MouseEvent) : void
      {
         this.bin.gotoNest();
      }
      
      private function showMyStuff(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         this.myStuffShake_mc.gotoAndStop(1);
         if(this.bin.crntLocID == 20)
         {
            _loc2_ = URLhandler.getPath("gardenItemControl");
            this.bin.loadOverlayUI(_loc2_);
            this.bin.completedNewUserTask(NewUserProgressManager.OPEN_CHEST_GARDEN);
         }
         else
         {
            _loc3_ = URLhandler.getPath("itemControl");
            this.bin.loadOverlayUI(_loc3_);
            this.bin.completedNewUserTask(NewUserProgressManager.OPEN_CHEST_ROOM);
         }
      }
      
      public function newApparelAdded() : void
      {
         this.apparelControl.newItemsAdded();
      }
      
      private function showHideTycoonPanel(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         this.tycoonPanel_mc.visible = this.tycoonPanel_mc.visible == false;
         this.tycoonPanel_mc.panelLower_mc.gotoAndStop(1);
         if(this.tycoonPanel_mc.visible)
         {
            for(_loc2_ in this.tycoonBusinesses)
            {
               this.tycoonBusinesses[_loc2_].vis = false;
            }
            this.getTycoonRatings(this.crntUserIDX);
         }
      }
      
      private function getTycoonRatings(param1:int) : void
      {
         var _loc2_:PHPcall = new PHPcall("getTycoonRatings");
         _loc2_.sendAndAwaitResponse(["idx"],[param1],this.tycoonRatingsReceived);
      }
      
      private function tycoonRatingsReceived(param1:Object) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = param1.ratings;
         if(_loc3_.length > 0)
         {
            _loc4_ = _loc3_.split("|");
            for(_loc6_ in _loc4_)
            {
               _loc5_ = _loc4_[_loc6_].split(":");
               _loc7_ = int(_loc5_[0]);
               _loc8_ = int(_loc5_[1]);
               this.setUpBusinessIcon(_loc2_++,_loc7_,_loc8_);
            }
         }
         if(this.businessPlazaList.isBusinessOpen())
         {
            this.setUpBusinessIcon(_loc2_++,2,0,this.visitBusinessPlaza);
         }
         if(this.businessPlazaList.isPhotoStudioOpen())
         {
            this.setUpBusinessIcon(_loc2_++,3,0,this.visitBusinessPlaza);
         }
      }
      
      private function setUpBusinessIcon(param1:int, param2:int, param3:int = 0, param4:* = null) : void
      {
         this.tycoonBusinesses[param1].setDetails(this.crntUserIDX,param2,param3,param4);
         this.tycoonPanel_mc.panelLower_mc.nextFrame();
      }
      
      private function setUpReportUserSubDialogListeners() : *
      {
         this.reportUser_mc.close_btn.addEventListener(MouseEvent.MOUSE_UP,this.onDeclineReportUser,false,0,true);
         this.reportUser_mc.reportWeevilPart1_mc.yes_btn.addEventListener(MouseEvent.MOUSE_UP,this.onConfirmReportUserPart1,false,0,true);
         this.reportUser_mc.reportWeevilPart1_mc.no_btn.addEventListener(MouseEvent.MOUSE_UP,this.onDeclineReportUser,false,0,true);
         this.reportUser_mc.reportWeevilPart2_mc.report_btn.addEventListener(MouseEvent.MOUSE_UP,this.onConfirmReportUserPart2,false,0,true);
         this.reportUser_mc.reportWeevilPart2_mc.cancel_btn.addEventListener(MouseEvent.MOUSE_UP,this.onDeclineReportUser,false,0,true);
         this.reportUser_mc.reportWeevilPart3_mc.yes_btn.addEventListener(MouseEvent.MOUSE_UP,this.onConfirmReportUserPart3,false,0,true);
         this.reportUser_mc.reportWeevilPart3_mc.no_btn.addEventListener(MouseEvent.MOUSE_UP,this.onDeclineReportUser,false,0,true);
         this.reportUser_mc.error_mc.ok_btn.addEventListener(MouseEvent.MOUSE_UP,this.reportWeevilErrorMsgOkPressed,false,0,true);
         var _loc1_:int = 0;
         while(_loc1_ < this.reportReasons.length)
         {
            this.reportReasons[_loc1_].hit_mc.addEventListener(MouseEvent.MOUSE_UP,this.onReportReasonPressed,false,0,true);
            this.reportReasons[_loc1_].hit_mc.buttonMode = true;
            _loc1_++;
         }
      }
      
      private function onReportReasonPressed(param1:MouseEvent) : *
      {
         this.hideAllCboChecks();
         this.selectedReportReasonMC = MovieClip(param1.target.parent);
         this.selectedReportReasonMC.cbo_mc.check_mc.visible = true;
      }
      
      private function onDeclineReportUser(param1:MouseEvent) : *
      {
         this.reportUser_mc.visible = false;
      }
      
      private function onConfirmReportUserPart3(param1:MouseEvent) : *
      {
         this.ignoreUser(param1);
         this.reportUser_mc.visible = false;
      }
      
      private function showReportError(param1:String) : *
      {
         this.reportUser_mc.error_mc.visible = true;
         this.reportUser_mc.error_mc.message_txt.text = param1;
      }
      
      private function reportWeevilErrorMsgOkPressed(param1:MouseEvent) : *
      {
         this.reportUser_mc.error_mc.visible = false;
      }
      
      private function onConfirmReportUserPart2(param1:MouseEvent) : *
      {
         var _loc2_:String = null;
         var _loc3_:MovieClip = this.reportUser_mc.reportWeevilPart2_mc;
         if(this.selectedReportReasonMC != null)
         {
            switch(this.selectedReportReasonMC.name)
            {
               case _loc3_.badLanguage_rdo.name:
                  _loc2_ = "0";
                  break;
               case _loc3_.badWeevilName_rdo.name:
                  _loc2_ = "1";
                  break;
               case _loc3_.badBehaviour_rdo.name:
                  _loc2_ = "2";
                  break;
               case _loc3_.personalDetails_rdo.name:
                  _loc2_ = "3";
                  break;
               default:
                  this.showReportError("please select a reason for report.");
                  return;
            }
            var _loc4_:PHP2call = new PHP2call("crisp/reportWeevil");
            _loc4_.fireAndForget(["reportedUser","reportedUserIdx","reason","comment"],[this.crntUserProfile,this.crntUserIDX,_loc2_,_loc3_.comment_txt.text]);
            this.reportUser_mc.reportWeevilPart3_mc.visible = true;
            this.reportUser_mc.reportWeevilPart2_mc.visible = false;
            return;
         }
         this.showReportError("please select a reason for report.");
      }
      
      private function onConfirmReportUserPart1(param1:MouseEvent) : *
      {
         this.reportUser_mc.reportWeevilPart2_mc.visible = true;
         this.reportUser_mc.reportWeevilPart1_mc.visible = false;
      }
      
      private function hideAllCboChecks() : *
      {
         this.selectedReportReasonMC = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.reportReasons.length)
         {
            this.reportReasons[_loc1_].cbo_mc.check_mc.visible = false;
            _loc1_++;
         }
      }
      
      private function showReportUserDialog(param1:MouseEvent) : *
      {
         this.hideAllCboChecks();
         this.reportUser_mc.error_mc.visible = false;
         this.reportUser_mc.reportWeevilPart2_mc.comment_txt.text = "";
         this.reportUser_mc.visible = true;
         this.reportUser_mc.reportWeevilPart3_mc.visible = false;
         this.reportUser_mc.reportWeevilPart2_mc.visible = false;
         this.reportUser_mc.reportWeevilPart1_mc.visible = true;
         this.reportUser_mc.reportWeevilPart1_mc.message_txt.text = "You have chosen to report \"" + this.crntUserProfile + "\"." + " This will send a message to the moderator who will look into the report and take appropriate action which could lead to the weevil being banned. \n\n" + "Are you sure you wish to report \"" + this.crntUserProfile + "\"?";
      }
      
      public function setHint(param1:InteractiveObject, param2:String, param3:Number, param4:Number) : void
      {
         this.tooltipsManager.setTip(param1,param2,{
            "x":param3,
            "y":param4
         });
      }
      
      public function showHint(param1:String, param2:Number, param3:Number) : void
      {
         this.tooltipsManager.showTip(param1,{
            "x":param2,
            "y":param3
         });
      }
      
      public function handleRegisterTooltip(param1:ToolTipEvent) : void
      {
         this.tooltipsManager.setTip(param1.io,param1.tipText,{
            "x":param1.x,
            "y":param1.y
         });
      }
      
      public function hideHint() : void
      {
         this.tooltipsManager.hideTip();
      }
      
      public function showDoshPrompt() : void
      {
         if(this.bin.tycoon)
         {
            this.doshPrompt_mc.gotoAndStop("forTycoons");
         }
         else
         {
            this.doshPrompt_mc.gotoAndStop("forNonTycoons");
         }
         this.doshPrompt_mc.visible = true;
      }
      
      public function hideDoshPrompt(param1:MouseEvent = null) : void
      {
         this.doshPrompt_mc.visible = false;
         this.doshPrompt_mc.gotoAndStop(1);
      }
      
      private function gotoPaymentPage(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = null;
         if(!this.bin.tycoon)
         {
            _loc2_ = new URLRequest("https://www.binweevils.com/membership/payment/package");
         }
         else
         {
            _loc2_ = new URLRequest("https://www.binweevils.com/membership/payment/package/tt/dtu");
         }
         navigateToURL(_loc2_,"_blank");
         this.hideDoshPrompt();
      }
      
      public function showAlertBox(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:TextField = null;
         if(param2)
         {
            _loc3_ = TextField(this.warningBox_mc.getChildByName("msg_txt"));
            _loc3_.text = param1;
            this.warningBox_mc.gotoAndPlay(1);
            this.warningBox_mc.visible = true;
         }
         else
         {
            _loc3_ = TextField(this.alertBox_mc.getChildByName("msg_txt"));
            _loc3_.text = param1;
            this.alertBox_mc.gotoAndPlay(1);
            this.alertBox_mc.visible = true;
         }
      }
      
      public function hideWarningBox(param1:MouseEvent = null) : void
      {
         this.warningBox_mc.visible = false;
         this.hideDoshPrompt();
      }
      
      public function hideAlertBox(param1:MouseEvent = null) : void
      {
         this.alertBox_mc.visible = false;
         this.hideDoshPrompt();
      }
      
      public function showDialogueBox(param1:String, param2:Function) : void
      {
         this.dialogueYesHandler = param2;
         this.hideDialogueBox();
         this.hideAlertBox();
         this.dialogueBox_mc.msg_txt.htmlText = param1;
         this.dialogueBox_mc.msg_txt.visible = true;
         this.dialogueBox_mc.yes_btn.addEventListener(MouseEvent.CLICK,this.dialogueYesHandler);
         this.dialogueBox_mc.yes_btn.visible = true;
         this.dialogueBox_mc.no_btn.visible = true;
         this.dialogueBox_mc.gotoAndPlay(1);
         this.dialogueBox_mc.visible = true;
      }
      
      public function dialogueBoxBusy() : void
      {
         this.dialogueBox_mc.yes_btn.visible = false;
         this.dialogueBox_mc.no_btn.visible = false;
         this.dialogueBox_mc.msg_txt.visible = false;
         this.dialogueBox_mc.pleaseWait_mc.play();
         this.dialogueBox_mc.pleaseWait_mc.visible = true;
         this.dialogueBox_mc.visible = true;
      }
      
      public function hideDialogueBox() : void
      {
         if(this.dialogueBox_mc.visible)
         {
            this.dialogueBox_mc.pleaseWait_mc.stop();
            this.dialogueBox_mc.pleaseWait_mc.visible = false;
            this.dialogueBox_mc.yes_btn.removeEventListener(MouseEvent.CLICK,this.dialogueYesHandler);
            this.dialogueBox_mc.visible = false;
         }
      }
      
      public function dialogueBoxNoBtn_CLICK(param1:MouseEvent) : void
      {
         this.hideDialogueBox();
      }
      
      private function sendBuddyRequest(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         if(this.buddyList.numUsers != 0 && BuddyData.getInfoForWeevilIDX(this.crntUserIDX) != null)
         {
            this.showAlertBox("Weevil is already a buddy!");
         }
         else if(this.buddyList.numUsers < 100)
         {
            _loc2_ = new Object();
            _loc2_.buddy_idx = this.crntUserIDX;
            Bin_extInterface.bin.webSocket.send("friends/send-request",_loc2_);
            EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_BUDDYREQUESTSENT_RECIEVED,this.onRequestSent);
         }
         else
         {
            this.showAlertBox("Your Bin Buddy list is full.");
         }
      }
      
      private function onRequestSent(param1:CustomEvent) : *
      {
         var _loc2_:Object = param1.dataObj;
         if(_loc2_["responseCode"] == 1)
         {
            this.showAlertBox("You have sent a buddy request to " + this.crntUserProfile + ".");
         }
         else if(_loc2_["responseCode"] == 2)
         {
            this.showAlertBox("You have already sent this weevil a buddy request!");
         }
      }
      
      private function btnMouseOut(param1:MouseEvent) : void
      {
         this.hideHint();
      }
      
      public function listedUserInvalid(param1:*, param2:String) : void
      {
         this.deadUser = param2;
         switch(param1)
         {
            case this.buddyList:
            case "newBuddyList":
               this.hideWeevilProfile();
               this.showDialogueBox("This Bin Weevil no longer exists!\n Do you want to remove it from your buddy list?",this.removeDeadBuddy);
               break;
            case this.ignoreList:
               this.hideWeevilProfile();
               this.showDialogueBox("This Bin Weevil no longer exists!\n Do you want to remove it from your ignore list?",this.removeDeadIgnored);
         }
      }
      
      private function removeBuddy_CLICK(param1:MouseEvent) : void
      {
         this.showDialogueBox("Do you want to remove " + this.crntUserProfile + " from your buddy list? ",this.removeBuddy);
      }
      
      private function removeBuddy(param1:MouseEvent) : void
      {
         this.removeBuddy_btn.visible = false;
         this.findBuddy_btn.visible = false;
         this.ignore_btn.visible = true;
         this.sendBuddyMsg_btn.visible = false;
         this.hideDialogueBox();
         this.removeBuddyCall(this.crntUserIDX);
         this.showAlertBox(this.crntUserProfile + " has been removed from your buddy list.");
      }
      
      private function removeDeadBuddy(param1:MouseEvent) : void
      {
         this.hideDialogueBox();
         this.showAlertBox(this.deadUser + " has been removed from your buddy list.");
         this.deadUser = null;
      }
      
      private function removeBuddyCall(param1:int) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.buddy_idx = param1;
         Bin_extInterface.bin.webSocket.send("friends/delete",_loc2_);
         EventManager.get_instance().addEventListener(BinEvents.WEB_SOCKET_BUDDYDELETED_RECIEVED,this.onBuddyDeleted);
      }
      
      private function onBuddyDeleted(param1:CustomEvent) : *
      {
      }
      
      private function removeDeadIgnored(param1:MouseEvent) : void
      {
         this.hideDialogueBox();
         this.ignoreList.removeUser(this.deadUser);
         var _loc2_:PHPcall = new PHPcall("weevil/remove-ignore-list",true);
         _loc2_.fireAndForget(["username"],[this.deadUser]);
         this.showAlertBox(this.deadUser + " has been removed from your ignore list.");
         this.deadUser = null;
         IgnoreListData.updateUserListInfo(this.ignoreList.getList());
      }
      
      private function ignoreUser(param1:MouseEvent) : void
      {
         var _loc2_:PHPcall = null;
         if(this.ignoreList.numUsers < 50)
         {
            if(this.crntUserProfile != this.bin.myUserName && this.crntUserProfile != null && this.crntUserProfile != "")
            {
               this.ignoreList.addUser(this.crntUserProfile);
               this.removeIgnore_btn.visible = true;
               this.buddyRequest_btn.visible = false;
               this.removeBuddy_btn.visible = false;
               this.sendBuddyMsg_btn.visible = false;
               _loc2_ = new PHPcall("weevil/add-ignore-list",true);
               _loc2_.fireAndForget(["username"],[this.crntUserProfile]);
               this.showAlertBox(this.crntUserProfile + " has been added to your ignore list.");
               IgnoreListData.updateUserListInfo(this.ignoreList.getList());
            }
         }
         else
         {
            this.showAlertBox("Your ignore list is full.");
         }
      }
      
      private function removeFromIgnoreList(param1:MouseEvent) : void
      {
         this.ignoreList.removeUser(this.crntUserProfile);
         this.removeIgnore_btn.visible = false;
         this.buddyRequest_btn.visible = true;
         this.sendBuddyMsg_btn.visible = false;
         var _loc2_:PHPcall = new PHPcall("weevil/remove-ignore-list",true);
         _loc2_.fireAndForget(["username"],[this.crntUserProfile]);
         this.showAlertBox(this.crntUserProfile + " has been removed from your ignore list.");
         IgnoreListData.updateUserListInfo(this.ignoreList.getList());
      }
      
      public function isOnIgnoreList(param1:String) : Boolean
      {
         return this.ignoreList.onList(param1);
      }
      
      private function findBuddy(param1:MouseEvent) : void
      {
         var _loc3_:Date = null;
         var _loc4_:String = null;
         var _loc2_:Object = BuddyData.getInfoForWeevilIDX(this.crntUserIDX);
         if(this.findBuddyMode == 1)
         {
            this.buddyToFind = this.ssclient.getBuddyByName(this.crntUserProfile);
            if(this.buddyToFind != null)
            {
               this.ssclient.getBuddyRoom(this.buddyToFind);
            }
            else
            {
               this.bin.showAlertBox(this.crntUserProfile + " is logged into a different server!");
            }
         }
         else if(_loc2_.isOnline == 2)
         {
            this.bin.showAlertBox(this.crntUserProfile + " is logged in on Bin Weevils Connect!");
         }
         else
         {
            _loc3_ = new Date(Number(this.buddyLastLog) * 1000);
            _loc4_ = "" + _loc3_.getDate() + "/" + (_loc3_.getMonth() + 1) + "/" + _loc3_.getFullYear() + " " + (_loc3_.getHours() < 10 ? "0" + _loc3_.getHours() : _loc3_.getHours()) + ":" + (_loc3_.getMinutes() < 10 ? "0" + _loc3_.getMinutes() : _loc3_.getMinutes());
            this.bin.showAlertBox(this.crntUserProfile + " last logged in on " + _loc4_);
         }
      }
      
      private function showBuddyMsgPanel(param1:MouseEvent) : void
      {
         EventManager.get_instance().dispatchEvent(new BuddyMessageEvent(BuddyMessageEvent.SHOW_CONVERSATION_LIST));
      }
      
      private function hideBuddyMsgPanel(param1:MouseEvent = null) : void
      {
         this.sendBuddyMsg_mc.visible = false;
      }
      
      private function sendBuddyMsg(param1:MouseEvent) : void
      {
         var _loc2_:String = this.trimIt(this.sendBuddyMsg_mc.msg_txt.text);
         if(_loc2_ != "")
         {
            if(this.bin.sendBuddyMsg(_loc2_,this.crntUserName,this.crntUserIDX))
            {
               this.showAlertBox("Message sent.");
            }
            this.hideBuddyMsgPanel();
         }
      }
      
      private function onBuddyRoom(param1:SFSEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         for(_loc2_ in param1.params)
         {
         }
         _loc3_ = int(param1.params.idList[0]);
         _loc4_ = this.ssclient.getRoom(_loc3_);
         if(_loc4_ != null)
         {
            _loc5_ = _loc4_.getName();
            if(_loc5_ == "Main" || _loc5_.substr(0,5) == "nest_")
            {
               for(_loc6_ in this.buddyToFind.variables)
               {
               }
               _loc7_ = this.buddyToFind.variables["locName"];
               if(_loc7_ == "in " + this.bin.myUserName + "\'s nest")
               {
                  _loc7_ = "in your nest";
               }
               else if(_loc7_ == null)
               {
                  _loc7_ = "logging in";
               }
               this.showAlertBox(this.buddyToFind.name + " is " + _loc7_ + ".");
            }
            else
            {
               this.showAlertBox(this.buddyToFind.name + " is " + LocNames.getNiceLocName(_loc5_) + ".");
            }
         }
         else
         {
            this.showAlertBox(this.buddyToFind.name + " is " + this.buddyToFind.variables["locName"] + ".");
         }
      }
      
      public function getIgnoreList() : void
      {
         var request:URLRequest;
         var loader:URLLoader;
         var variables:URLVariables = new URLVariables();
         variables.userID = this.bin.myUserName;
         request = new URLRequest();
         request.url = URLhandler.servicesLocation + "php/getIgnoreList.php?rndVar=" + Math.random();
         request.method = URLRequestMethod.POST;
         request.data = variables;
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.VARIABLES;
         loader.addEventListener(Event.COMPLETE,this.ignoreListReceived);
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
         }
      }
      
      public function ignoreListReceived(param1:Event) : void
      {
         var _loc2_:String = param1.target.data.result;
         var _loc3_:Array = new Array();
         if(_loc2_.length > 0)
         {
            _loc3_ = _loc2_.split(",");
            this.ignoreList.populate2(_loc3_);
         }
         IgnoreListData.setBuddyListInfo(_loc3_);
      }
      
      private function onBuddyListRecieved(param1:BuddyMessageEvent) : void
      {
         this.buddyList.populate(BuddyData.getList());
      }
      
      private function onBuddyList(param1:SFSEvent) : void
      {
      }
      
      private function onBuddyListUpdate(param1:SFSEvent) : void
      {
      }
      
      private function onBuddyPermissionRequest(param1:SFSEvent) : void
      {
      }
      
      public function isOnBuddyList(param1:String) : Boolean
      {
         return this.buddyList.getUserByName(param1) == null ? false : true;
      }
      
      private function addBuddyRequest(param1:String) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:* = undefined;
         for(_loc3_ in this.buddyRequests)
         {
            if(this.buddyRequests[_loc3_] == param1)
            {
               _loc2_ = true;
               break;
            }
         }
         if(!_loc2_)
         {
            this.buddyRequests.push(param1);
         }
         TextField(this.buddyRequestIndicator_spr.getChildByName("numMsgs_txt")).text = String(this.buddyRequests.length);
         this.buddyRequestIndicator_spr.visible = true;
      }
      
      private function addInvite(param1:String) : void
      {
         var _loc2_:Boolean = false;
         if(this.invList.onList(param1))
         {
            _loc2_ = true;
         }
         if(!_loc2_)
         {
            this.newInvites.push(param1);
            this.invList.addUser(param1);
            this.invList.highlightUser(param1,true);
         }
         this.updateInviteIndicator();
      }
      
      private function showNewInvite(param1:MouseEvent) : void
      {
         this.hideAlertBox(param1);
         var _loc2_:String = this.newInvites[0];
         if(_loc2_ != null)
         {
            this.showInviteHandler(_loc2_);
         }
      }
      
      public function showInviteHandler(param1:String) : void
      {
         this.hostUserName = param1;
         this.showInvite();
      }
      
      private function onRoomListUpdate(param1:SFSEvent) : void
      {
         if(this.bin.roomListClient == "nestInvite")
         {
            this.bin.roomListClient = null;
            this.bin.visitOtherWeevilNest(this.hostUserName);
         }
      }
      
      private function showInvite() : void
      {
         var _loc1_:int = int(this.newInvites.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(this.newInvites[_loc2_] == this.hostUserName)
            {
               this.newInvites.splice(_loc2_,1);
               this.invList.highlightUser(this.hostUserName,false);
               this.updateInviteIndicator();
               break;
            }
            _loc2_++;
         }
         this.invitation_mc.pleaseWait_mc.stop();
         this.invitation_mc.pleaseWait_mc.visible = false;
         this.invitation_mc.msg_txt.text = "This is an invitation to " + this.hostUserName + "\'s nest.";
         this.invitation_mc.green_btn.visible = true;
         this.invitation_mc.orange_btn.visible = true;
         this.invitation_mc.red_btn.visible = true;
         this.invitation_mc.gotoAndPlay(1);
         this.invitation_mc.visible = true;
      }
      
      private function acceptNestInvitation(param1:MouseEvent) : void
      {
         this.publicNestVisitor = false;
         this.attemptNestVisit();
      }
      
      private function attemptNestVisit() : void
      {
         if(this.newInvite)
         {
            this.newInvite = false;
            this.bin.roomListClient = "nestInvite";
            this.ssclient.getRoomList();
            this.inviteBusy();
         }
         else
         {
            this.bin.visitOtherWeevilNest(this.hostUserName);
         }
      }
      
      private function inviteBusy() : void
      {
         this.invitation_mc.msg_txt.text = "";
         this.invitation_mc.pleaseWait_mc.play();
         this.invitation_mc.pleaseWait_mc.visible = true;
         this.invitation_mc.green_btn.visible = false;
         this.invitation_mc.orange_btn.visible = false;
         this.invitation_mc.red_btn.visible = false;
         this.invitation_mc.visible = true;
      }
      
      private function keepInviteForLater(param1:MouseEvent) : void
      {
         this.hideInvite();
      }
      
      private function removeInvite_CLICK(param1:MouseEvent) : void
      {
         this.removeInvite(this.hostUserName,true);
         this.hideInvite();
      }
      
      public function removeInvite(param1:String, param2:Boolean = false) : void
      {
         if(param2)
         {
            this.bin.exitHostNest(param1);
            this.ssclient.removeNestInvite(param1);
         }
         this.invList.removeUser(param1);
         var _loc3_:int = int(this.newInvites.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.newInvites[_loc4_] == param1)
            {
               this.newInvites.splice(_loc4_,1);
            }
            _loc4_++;
         }
         this.updateInviteIndicator();
      }
      
      private function updateInviteIndicator() : void
      {
         var _loc1_:TextField = TextField(this.inviteIndicator_spr.getChildByName("numMsgs_txt"));
         _loc1_.text = String(this.newInvites.length);
         if(this.newInvites.length > 0)
         {
            this.inviteIndicator_spr.visible = true;
         }
         else
         {
            this.inviteIndicator_spr.visible = false;
         }
      }
      
      public function hideInvite() : void
      {
         this.invitation_mc.visible = false;
         this.invitation_mc.pleaseWait_mc.stop();
         this.invitation_mc.pleaseWait_mc.visible = false;
      }
      
      public function invitationValid(param1:String) : Boolean
      {
         if(this.publicNestVisitor)
         {
            return true;
         }
         return this.invList.onList(param1);
      }
      
      private function updateMsgIndicator() : void
      {
         var _loc1_:int = int(this.buddyRequests.length);
         TextField(this.buddyRequestIndicator_spr.getChildByName("numMsgs_txt")).text = String(_loc1_);
         if(_loc1_ > 0)
         {
            this.buddyRequestIndicator_spr.visible = true;
         }
         else
         {
            this.buddyRequestIndicator_spr.visible = false;
         }
      }
      
      private function acceptBuddyRequest(param1:MouseEvent) : void
      {
         this.ssclient.sendBuddyPermissionResponse(true,this.potentialBuddy);
         this.hideBuddyRequest();
      }
      
      private function denyBuddyRequest(param1:MouseEvent) : void
      {
         this.ssclient.sendBuddyPermissionResponse(false,this.potentialBuddy);
         this.hideBuddyRequest();
      }
      
      private function showBuddyRequest(param1:MouseEvent) : void
      {
         this.hideAlertBox(param1);
         if(this.buddyRequests.length > 0)
         {
            this.potentialBuddy = this.buddyRequests.shift();
            if(this.buddyList.numUsers < 60)
            {
               this.buddyRequestMsg_mc.msg_txt.text = this.potentialBuddy + " has asked to be your buddy. Do you accept?";
               this.buddyRequestMsg_mc.gotoAndPlay(1);
               this.buddyRequestMsg_mc.visible = true;
            }
            else
            {
               this.showAlertBox(this.potentialBuddy + " has asked to be your buddy, but your buddy list is full.");
            }
            TextField(this.buddyRequestIndicator_spr.getChildByName("numMsgs_txt")).text = String(this.buddyRequests.length);
            if(this.buddyRequests.length == 0)
            {
               this.buddyRequestIndicator_spr.visible = false;
            }
         }
         else
         {
            this.buddyRequestIndicator_spr.visible = false;
         }
      }
      
      private function hideBuddyRequest() : void
      {
         this.buddyRequestMsg_mc.visible = false;
      }
      
      private function removeAllGuests(param1:MouseEvent = null) : void
      {
         this.hideDialogueBox();
         this.ssclient.removeGuestFromNest();
         this.guestList.cleanUpList();
         this.topRightDisplay.set_mode(1);
      }
      
      private function removeAllGuests_CLICK(param1:MouseEvent) : void
      {
         this.showDialogueBox("Do you want to remove everyone from your guest list? ",this.removeAllGuests);
      }
      
      private function showBusinessPlazaList(param1:MouseEvent) : void
      {
         var _loc2_:String = URLhandler.getPath("tycoonBusinessList");
         this.bin.loadInterface({"path":_loc2_});
      }
      
      private function showHideBuddyList(param1:MouseEvent) : void
      {
         if(this.currentList != 1)
         {
            this.showBuddyList();
         }
         else
         {
            this.hideLists();
         }
      }
      
      private function showHideIgnoreList(param1:MouseEvent) : void
      {
         if(this.currentList != 2)
         {
            this.showIgnoreList();
         }
         else
         {
            this.hideLists();
         }
      }
      
      private function showHideInviteList(param1:MouseEvent) : void
      {
         if(this.currentList != 3)
         {
            this.showInviteList();
         }
         else
         {
            this.hideLists();
         }
      }
      
      private function showHideGuestList(param1:MouseEvent) : void
      {
         if(this.currentList != 4)
         {
            this.showGuestList();
         }
         else
         {
            this.hideLists();
         }
      }
      
      public function showBuddyList(param1:MouseEvent = null) : void
      {
         this.currentList = 1;
         this.lists_mc.removeAllGuests_btn.visible = false;
         this.lists_mc.heading_txt.text = "Bin Buddies";
         this.ignoreList.vis = false;
         this.guestList.vis = false;
         this.invList.vis = false;
         this.buddyList.vis = true;
         this.lists_mc.visible = true;
      }
      
      private function showIgnoreList(param1:MouseEvent = null) : void
      {
         this.currentList = 2;
         this.lists_mc.removeAllGuests_btn.visible = false;
         this.lists_mc.heading_txt.text = "Ignore list";
         this.buddyList.vis = false;
         this.guestList.vis = false;
         this.invList.vis = false;
         this.ignoreList.vis = true;
         this.lists_mc.visible = true;
      }
      
      private function showInviteList(param1:MouseEvent = null) : void
      {
         this.currentList = 3;
         this.lists_mc.removeAllGuests_btn.visible = false;
         this.lists_mc.heading_txt.text = "Nest Invitations";
         this.buddyList.vis = false;
         this.ignoreList.vis = false;
         this.guestList.vis = false;
         this.invList.vis = true;
         this.lists_mc.visible = true;
      }
      
      private function showGuestList(param1:MouseEvent = null) : void
      {
         this.currentList = 4;
         this.lists_mc.removeAllGuests_btn.visible = true;
         this.lists_mc.heading_txt.text = "Guest list";
         this.buddyList.vis = false;
         this.ignoreList.vis = false;
         this.invList.vis = false;
         this.guestList.vis = true;
         this.lists_mc.visible = true;
      }
      
      public function hideLists(param1:MouseEvent = null) : void
      {
         this.lists_mc.visible = false;
         this.currentList = 0;
      }
      
      public function hideWeevilControls() : void
      {
      }
      
      public function showSilenceMsg(param1:int, param2:String = null) : void
      {
         if(param2 == null)
         {
            this.showModMsg("Your chat will be disabled\n for " + DateTime.formatTimeFromMinutes(param1) + " due to bad behaviour.");
         }
         else
         {
            this.showModMsg(param2);
         }
      }
      
      public function showModMsg(param1:String) : void
      {
         var _loc2_:TextField = TextField(this.modMsg_spr.getChildByName("modMsg_txt"));
         _loc2_.text = param1;
         this.modMsg_spr.visible = true;
      }
      
      private function hideModMsg() : void
      {
         this.modMsg_spr.visible = false;
      }
      
      private function closeModMsg_handler(param1:MouseEvent) : void
      {
         this.hideModMsg();
      }
      
      public function get crntMode() : int
      {
         return this._crntMode;
      }
      
      public function set vis(param1:Boolean) : void
      {
         this.UI_mc.visible = param1;
      }
      
      public function showControls(param1:Boolean) : void
      {
         this.UI_mc.controls_mc.visible = param1;
         this.showCameraBtn(param1);
         this.setBuddyFeedCanShow(param1);
      }
      
      public function showCameraBtn(param1:Boolean = true) : void
      {
         if(this.bin.tycoon && param1)
         {
            this.cameraIcon_btn.visible = param1;
         }
         else
         {
            this.cameraIcon_btn.visible = false;
         }
      }
      
      public function setMyProfileBtnPic(param1:Bitmap) : void
      {
         this.myProfileBtn_spr.addChild(param1);
         this.myProfileBtn_spr.buttonMode = true;
      }
      
      public function setupCamUI(param1:Cam3D) : void
      {
         this.camUI = new CamUI(param1,this.camUI_spr);
         this.loadBar_spr = Sprite(this.camUILoader_spr.getChildByName("loadBar_spr"));
      }
      
      public function set_ssclient(param1:*) : void
      {
         this.ssclient = param1;
         this.say_btn.addEventListener(MouseEvent.CLICK,this.sendChatMsg);
         this.setHint(this.say_btn,"Send",538,501);
         this.petCommandsUI.setUpCmdBtns();
         this.ssclient.addEventListener(SFSEvent.onBuddyList,this.onBuddyList);
         this.ssclient.addEventListener(SFSEvent.onBuddyListUpdate,this.onBuddyListUpdate);
         this.ssclient.addEventListener(SFSEvent.onBuddyPermissionRequest,this.onBuddyPermissionRequest);
         this.ssclient.addEventListener(SFSEvent.onBuddyRoom,this.onBuddyRoom);
         this.ssclient.addEventListener(SFSEvent.onRoomListUpdate,this.onRoomListUpdate);
         this.getIgnoreList();
         STAGE.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         if(URLhandler.useBubbleTester)
         {
            this.loadBubbleTester();
         }
      }
      
      public function getBuddyList() : void
      {
         this.ssclient.loadBuddyList();
      }
      
      public function set_tycoonMode(param1:Boolean) : void
      {
         this.topHat_btn.visible = param1;
         if(VersionHandler.cluster != "uk")
         {
            this.tycoonTV_btn.visible = false;
         }
      }
      
      public function silence(param1:int, param2:String = null) : void
      {
         if(param2 != null)
         {
            this.bin.storeSilencedKey(param2);
         }
         this.silenceMinutes = param1;
         this.silenceMinutes_ghost = this.silenceMinutes + 13;
         if(param1 != 9999)
         {
            this.silenceMinutesTimer = new Timer(60000,0);
            this.silenceMinutesTimer.addEventListener("timer",this.decrSilenceMinutes);
            this.silenceMinutesTimer.start();
         }
         if(this.silenceMinutes != 0)
         {
            this.chatDisabled_mc.chatDisabled_txt.visible = true;
            this.disableChat();
         }
      }
      
      private function decrSilenceMinutes(param1:TimerEvent) : void
      {
         if(this.silenceMinutes > 0)
         {
            --this.silenceMinutes;
            --this.silenceMinutes_ghost;
         }
         else if(this.silenceMinutes < 0)
         {
            ++this.silenceMinutes;
            ++this.silenceMinutes_ghost;
         }
         else
         {
            this.silenceMinutesTimer.stop();
         }
      }
      
      public function enableChat() : void
      {
         if(!this.chatEnabled)
         {
            this.chatDisabled_mc.visible = false;
            this.say_btn.addEventListener(MouseEvent.CLICK,this.sendChatMsg);
            this.chatEnabled = true;
            this.chat_spr.alpha = 1;
         }
      }
      
      public function disableChat() : void
      {
         this.chatDisabled_mc.visible = true;
         this.say_btn.removeEventListener(MouseEvent.CLICK,this.sendChatMsg);
         this.chatEnabled = false;
         this.chat_spr.alpha = 0.4;
      }
      
      private function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:int = int(param1.keyCode);
         if(_loc2_ == 13)
         {
            if(this.chatEnabled)
            {
               this.sendChatMsg(param1);
            }
         }
      }
      
      public function hideMySpeachBubble() : void
      {
         this.bin.myWeevil.hideSpeachBubble();
      }
      
      public function sendPetCmd(param1:String, param2:String, param3:int) : void
      {
         this.ssclient.sendPetCmd(param1,param2,param3);
      }
      
      public function areBuddyMessagesEnabled() : Boolean
      {
         if(this.silenceMinutes == 0 && this.silenceMinutes_ghost == 13)
         {
            return true;
         }
         if(this.silenceMinutes_ghost != this.silenceMinutes + 13)
         {
            this.showAlertBox("Sending buddy messages has been disabled on this computer.");
         }
         else if(this.silenceMinutes == 9999)
         {
            this.showAlertBox("Sending buddy messages has been disabled permanently due to bad behaviour.");
         }
         else if(this.silenceMinutes > 0)
         {
            this.showAlertBox("Sending buddy messages will be disabled for " + DateTime.formatTimeFromMinutes(this.silenceMinutes) + " due to bad behaviour.");
         }
         else if(this.silenceMinutes < 0)
         {
            this.showAlertBox("Sending buddy messages will be disabled on this computer for " + DateTime.formatTimeFromMinutes(this.silenceMinutes));
         }
         else
         {
            this.showAlertBox("Log in again to send buddy messsages.");
         }
         return false;
      }
      
      private function chatDisabled_clicked(param1:MouseEvent) : void
      {
         if(this.silenceMinutes_ghost != this.silenceMinutes + 13)
         {
            this.showAlertBox("Chat has been disabled on this computer.");
         }
         else if(this.silenceMinutes == 9999)
         {
            this.showAlertBox("Your chat has been disabled permanently due to bad behaviour.");
         }
         else if(this.silenceMinutes > 0)
         {
            this.showAlertBox("Your chat will be disabled\n for " + DateTime.formatTimeFromMinutes(this.silenceMinutes) + " due to bad behaviour.");
         }
         else if(this.silenceMinutes < 0)
         {
            this.showAlertBox("Chat will be disabled on this computer for " + DateTime.formatTimeFromMinutes(this.silenceMinutes));
         }
         else
         {
            this.showAlertBox("Log in again to enable your chat.");
         }
      }
      
      public function sendChatMsg(param1:Event) : void
      {
         var _loc2_:String = this.trimIt(this.chatMsg_txt.text);
         if(_loc2_ != "")
         {
            this.chatMsg_txt.text = "";
            if(this.bin.broadcastMoves)
            {
               this.bin.sendChatMsg(_loc2_);
            }
            else
            {
               this.bin.myWeevil.say(_loc2_);
            }
            this.bin.resetLogoutTimer();
         }
         this.chatMsg_txt.text = "";
      }
      
      private function trimIt(param1:String) : String
      {
         while(param1.charAt(0) == " ")
         {
            param1 = param1.substring(1,param1.length);
         }
         while(param1.charAt(param1.length - 1) == " ")
         {
            param1 = param1.substring(0,param1.length - 1);
         }
         return param1;
      }
      
      public function setMouth(param1:int) : void
      {
         this.bin.myWeevil.setMouth(param1);
         if(this.bin.broadcastMoves)
         {
            this.ssclient.sendExpression(param1);
         }
         this.bin.resetLogoutTimer();
      }
      
      public function getCrntMouthID() : int
      {
         return this.weevilExpressionsUI.crntMouthID;
      }
      
      private function act(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc4_:String = null;
         var _loc3_:int = -1;
         if(this.starActive)
         {
            switch(param1.target.name)
            {
               case "action1_btn":
                  _loc4_ = "A";
                  break;
               case "action2_btn":
                  _loc4_ = "B";
                  break;
               case "action3_btn":
                  _loc4_ = "C";
                  break;
               case "action4_btn":
                  _loc4_ = "D";
                  break;
               case "action5_btn":
                  _loc4_ = "E";
                  break;
               case "action6_btn":
                  _loc4_ = "F";
                  break;
               case "action7_btn":
                  _loc4_ = "G";
            }
            this.clickSqnce += _loc4_;
         }
         else
         {
            switch(param1.target.name)
            {
               case "action1_btn":
                  _loc2_ = 1;
                  _loc3_ = 0;
                  break;
               case "action2_btn":
                  _loc2_ = 2;
                  break;
               case "action3_btn":
                  _loc2_ = 3;
                  break;
               case "action4_btn":
                  _loc2_ = 4;
                  break;
               case "action5_btn":
                  _loc2_ = 5;
                  break;
               case "action6_btn":
                  _loc2_ = 6;
                  _loc3_ = 6;
                  break;
               case "action7_btn":
                  _loc2_ = 7;
                  _loc3_ = 7;
            }
            if(Bin.controlsEnabled)
            {
               this.bin.myWeevilAct(_loc2_,_loc3_);
            }
         }
      }
      
      public function get specialTransMove() : int
      {
         return this.weevilActionsUI.transMoveID;
      }
      
      public function set specialTransMove(param1:int) : void
      {
         this.weevilActionsUI.transMoveID = param1;
      }
      
      public function get crosshairs_on() : Boolean
      {
         return this._crosshairs_on;
      }
      
      public function set crosshairs_on(param1:Boolean) : void
      {
         this.hideJugglingTricks();
         this._crosshairs_on = param1;
      }
      
      public function activateCrosshairs(param1:Boolean) : void
      {
         if(param1)
         {
            if(!this.crosshairs_on)
            {
               this.activateHand(false);
               this.crosshairs_on = true;
               this.crosshairs_spr.x = STAGE.mouseX;
               this.crosshairs_spr.y = STAGE.mouseY;
               this.crosshairs_spr.alpha = 1;
               STAGE.addEventListener(MouseEvent.MOUSE_MOVE,this.updateCrosshairs);
               STAGE.addEventListener(MouseEvent.MOUSE_UP,this.switchOffCrosshairs);
            }
         }
         else if(this.keepCrosshairsCount == 0)
         {
            if(this.crosshairs_on)
            {
               this.crosshairs_on = false;
               STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,this.updateCrosshairs);
               STAGE.removeEventListener(MouseEvent.MOUSE_UP,this.switchOffCrosshairs);
               this.crosshairs_spr.y = -2000;
            }
         }
         else
         {
            --this.keepCrosshairsCount;
         }
      }
      
      public function get handShowing() : Boolean
      {
         return this._handShowing;
      }
      
      public function set handShowing(param1:Boolean) : void
      {
         this._handShowing = param1;
      }
      
      public function activateHand(param1:Boolean) : void
      {
         if(!this.crosshairs_on)
         {
            if(param1)
            {
               if(!this.handShowing)
               {
                  this.handShowing = true;
                  this.hand_mc.x = STAGE.mouseX;
                  this.hand_mc.y = STAGE.mouseY;
                  this.hand_mc.gotoAndPlay(2);
                  STAGE.addEventListener(MouseEvent.MOUSE_MOVE,this.updateHandPos);
               }
            }
            else if(this.handShowing)
            {
               this.handShowing = false;
               STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,this.updateHandPos);
               this.hand_mc.y = -2000;
               this.hand_mc.gotoAndStop(1);
            }
         }
      }
      
      public function getCrntPet() : Pet
      {
         return this.petCommandsUI.crntPet;
      }
      
      public function getBallToThrowID() : int
      {
         return this.petCommandsUI.ballToThrowID;
      }
      
      public function petHasLeftRoom(param1:Pet) : void
      {
         if(this.petCommandsUI.crntPet == param1)
         {
         }
      }
      
      private function switchOffCrosshairs(param1:MouseEvent) : void
      {
         this.activateCrosshairs(false);
      }
      
      private function updateCrosshairs(param1:MouseEvent) : void
      {
         this.crosshairs_spr.x = param1.stageX;
         this.crosshairs_spr.y = param1.stageY;
         if(this.specialTransMove != 0 && this.specialTransMove != 3)
         {
            if(this.bin.getRange(param1) < this.weevilActionsUI.maxSuperJumpRange)
            {
               this.crosshairs_spr.alpha = 1;
            }
            else
            {
               this.crosshairs_spr.alpha = 0.2;
            }
         }
      }
      
      public function get maxSuperJumpRange() : Number
      {
         return this.weevilActionsUI.maxSuperJumpRange;
      }
      
      public function get maxSuperSpeedLevel() : int
      {
         return this.weevilActionsUI.maxSuperSpeedLevel;
      }
      
      public function get selectedPowerLevel() : int
      {
         return this.weevilActionsUI.selectedPowerLevel;
      }
      
      public function incrSuperSpeedLevel() : int
      {
         return this.weevilActionsUI.incrSuperSpeedLevel();
      }
      
      public function resetSuperSpeedLevel() : void
      {
         this.weevilActionsUI.selectedPowerLevel = 0;
      }
      
      public function checkEnergySufficient(param1:*, param2:Number = 0) : Boolean
      {
         return this.weevilActionsUI.checkEnergySufficient(param1,param2);
      }
      
      public function get_weevilActionsUI() : WeevilActionsUI
      {
         return this.weevilActionsUI;
      }
      
      private function updateHandPos(param1:MouseEvent) : void
      {
         this.hand_mc.x = param1.stageX;
         this.hand_mc.y = param1.stageY;
      }
      
      public function showMyProfile(param1:MouseEvent = null) : void
      {
         this.bin.showWeevilProfile(this.bin.myUserID);
      }
      
      public function getWeevilProfile(param1:int) : void
      {
         this.bin.showWeevilProfile(param1);
      }
      
      public function showWeevilProfile(param1:Sprite, param2:String, param3:int = 0, param4:int = 0, param5:Boolean = false, param6:String = "") : void
      {
         var _loc9_:ListedUser = null;
         this.ssclient.loadBuddyList();
         this.staff_btn.visible = false;
         this.magStaff_btn.visible = false;
         this.sa = this.isSA(param2);
         this.msa = this.isMSA(param2);
         this.hideDialogueBox();
         this.hideAlertBox();
         this.businessPlazaIsOpen = false;
         this.businessPlazaList.loadList(this,param2,this.crntUserIDX);
         var _loc7_:Boolean = false;
         if(this.crntWeevilMugShot != null)
         {
            this.weevilMugShotHolder_spr.removeChild(this.crntWeevilMugShot);
         }
         this.hidePetProfile();
         this.crntUserName = param2;
         var _loc8_:Boolean = param2 == this.bin.myUserName ? true : false;
         if(_loc8_)
         {
            this.crntUserIDX = this.bin.myUserIDX;
            this.showApparel_btn.visible = true;
            this.crntUserPets = this.bin.getAllMyPets();
            if(this.crntUserPets.length > 0)
            {
               _loc7_ = true;
            }
         }
         else
         {
            this.showApparel_btn.visible = false;
            this.crntUserPets = new Array();
         }
         this.tycoonPanel_mc.visible = false;
         this.sendBuddyMsg_mc.visible = false;
         this.profileLevelIndicator_spr.visible = false;
         this.crntUserProfile = param2;
         if(_loc8_)
         {
            this.binBadges_btn.visible = false;
            this.sendInvite_btn.visible = false;
            this.removeGuest_btn.visible = false;
            this.buddyRequest_btn.visible = false;
            this.removeBuddy_btn.visible = false;
            this.findBuddy_btn.visible = false;
            this.ignore_btn.visible = false;
            this.removeIgnore_btn.visible = false;
            this.sendBuddyMsg_btn.visible = false;
            this.reportUser_btn.visible = false;
            param4 = this.weevilStatManager.level;
            this.profileLevelNum_txt.text = String(param4);
            this.weevilStatManager.setStarClr(this.profileLevelStar_spr,param4);
            this.profileLevelIndicator_spr.visible = true;
            this.topHat_btn.visible = this.bin.tycoon;
         }
         else
         {
            if(param4 == 0)
            {
               this.bin.getWeevilData2(param2,this.weevilDataReceived);
            }
            else
            {
               this.profileLevelNum_txt.text = String(param4);
               this.weevilStatManager.setStarClr(this.profileLevelStar_spr,param4);
               this.profileLevelIndicator_spr.visible = true;
               this.crntUserIDX = param3;
               this.topHat_btn.visible = param5;
            }
            if(this.buddyList.onList(param2))
            {
               this.buddyLastLog = param6;
               this.findBuddy_btn.visible = true;
               this.ignore_btn.visible = false;
               this.removeIgnore_btn.visible = false;
               this.removeBuddy_btn.visible = false;
               this.buddyRequest_btn.visible = false;
               this.sendBuddyMsg_btn.visible = true;
               _loc9_ = this.buddyList.getUserByName(param2);
               if(_loc9_.online)
               {
                  this.findBuddyMode = 1;
                  this.sendInvite_btn.visible = true;
                  if(this.guestList.onList(this.crntUserProfile))
                  {
                     this.removeGuest_btn.visible = true;
                  }
                  else
                  {
                     this.removeGuest_btn.visible = false;
                  }
               }
               else
               {
                  this.findBuddyMode = 0;
                  this.sendInvite_btn.visible = false;
                  this.removeGuest_btn.visible = false;
               }
            }
            else if(this.ignoreList.onList(param2))
            {
               this.buddyRequest_btn.visible = false;
               this.findBuddy_btn.visible = false;
               this.removeBuddy_btn.visible = false;
               this.removeIgnore_btn.visible = true;
               this.sendBuddyMsg_btn.visible = false;
               this.ignore_btn.visible = true;
            }
            else
            {
               this.findBuddy_btn.visible = false;
               this.removeBuddy_btn.visible = false;
               this.removeIgnore_btn.visible = false;
               this.buddyRequest_btn.visible = true;
               this.sendInvite_btn.visible = true;
               if(this.guestList.onList(this.crntUserProfile))
               {
                  this.removeGuest_btn.visible = true;
               }
               else
               {
                  this.removeGuest_btn.visible = false;
               }
               this.ignore_btn.visible = true;
               this.sendBuddyMsg_btn.visible = false;
            }
            this.reportUser_btn.visible = true;
            this.binBadges_btn.visible = true;
         }
         this.crntWeevilMugShot = param1;
         this.weevilMugShotHolder_spr.addChild(param1);
         this.weevilName_txt.text = param2;
         this.weevilProfile_mc.gotoAndPlay(1);
         this.weevilProfile_mc.weevilPicMask_mc.gotoAndPlay(1);
         this.weevilProfile_mc.weevilProfileMask_mc.gotoAndPlay(1);
         this.weevilProfile_mc.visible = true;
         if(_loc7_)
         {
            this.binPet_btn.visible = true;
         }
         else
         {
            this.binPet_btn.visible = false;
         }
         if(this.sa)
         {
            this.topHat_btn.visible = false;
            if(this.msa)
            {
               this.magStaff_btn.visible = true;
            }
            else
            {
               this.staff_btn.visible = true;
            }
         }
      }
      
      private function visitBusinessPlaza() : void
      {
         this.bin.attemptVisitTycoonPlaza(this.crntUserName,this.crntUserIDX);
      }
      
      private function showApparelPanel(param1:MouseEvent) : void
      {
         this.showApparel_btn.visible = false;
         this.weevilProfile_mc.gotoAndPlay(4);
         this.apparelControl.getAllApparel();
      }
      
      private function clickedPetBt(param1:MouseEvent) : void
      {
         var _loc2_:Array = this.bin.getAllMyPets();
         if(_loc2_.length == 0)
         {
            this.bin.showAlertBox("You dont have a pet. Get one at the shopping mall.");
         }
         else
         {
            this.showPetProfile(_loc2_[0].id,false,_loc2_[0]);
         }
      }
      
      public function showPetProfile(param1:Number, param2:Boolean, param3:Pet = null) : void
      {
         var _loc5_:String = null;
         this.petProfile_mc.photo_mc.mouseEnabled = false;
         this.petProfile_mc.photo_mc.mouseChildren = false;
         this.petProfile_mc.photo_mc.buttonMode = false;
         this.resetPetProfile();
         if(this.crntPetMugShot != null)
         {
            this.petMugShotHolder_spr.removeChild(this.crntPetMugShot);
         }
         this.clearLoadedImages();
         var _loc4_:Sprite = new Sprite();
         this.hideWeevilProfile();
         this.defaultPic.visible = true;
         this.petProfile_mc.visible = true;
         if(param2 == false)
         {
            this.petName_txt.text = param3.name;
            this.updatePetStats(param3);
            this.petCommandsUI.showAvailableCmds(param3);
            this.petStats_spr.visible = true;
            this.publicPetProfile_mc.visible = false;
            this.defaultPic.visible = false;
            _loc4_ = param3.mugShot;
         }
         else
         {
            if(param3 != null)
            {
               this.petName_txt.text = param3.name;
               this.petCommandsUI.showPublicProfile(param3);
               if(param3.owner == null)
               {
                  _loc5_ = "?";
               }
               else
               {
                  _loc5_ = param3.owner.name;
               }
               this.publicPetProfile_mc.owner_mc.owner_tx.text = _loc5_;
               this.crntPetOwnerName = _loc5_;
               if(param3.mine)
               {
                  this.petProfile_mc.photo_mc.mouseEnabled = true;
                  this.petProfile_mc.photo_mc.mouseChildren = true;
                  this.petProfile_mc.photo_mc.buttonMode = true;
               }
            }
            else
            {
               this.petCommandsUI.showPublicProfile();
               this.petName_txt.text = "";
               this.crntPetOwnerName = "";
            }
            this.petStats_spr.visible = false;
            this.publicPetProfile_mc.visible = true;
            this.publicPetProfile_mc.adoptionDate_tx.text = "";
            this.publicPetProfile_mc.juggle_tx.text = "";
            this.publicPetProfile_mc.status_tx.text = "";
            this.crntPetID = param1;
            this.getPetPublicProfileInfo(param1);
         }
         this.crntPetMugShot = _loc4_;
         this.petMugShotHolder_spr.addChild(_loc4_);
      }
      
      private function resetPetProfile() : void
      {
         this.petProfile_mc.gotoAndStop(1);
         this.publicPetProfile_mc.gotoAndStop(1);
         this.publicPetProfile_mc.adoptionDate_tx.visible = true;
         this.publicPetProfile_mc.juggle_tx.visible = true;
         this.publicPetProfile_mc.status_tx.visible = true;
         this.petName_txt.textColor = 3839991;
         this.publicPetProfile_mc.owner_mc.owner_tx.textColor = 3839991;
      }
      
      private function getPetPublicProfileInfo(param1:Number) : void
      {
         this.petProfile_mc.loading_mc.visible = true;
         var _loc2_:PHP2call = new PHP2call("pets/getPetProfile");
         var _loc3_:Array = ["petID"];
         var _loc4_:Array = [param1];
         _loc2_.sendAndAwaitResponse(_loc3_,_loc4_,this.petPublicProfileInfoReceived,true,true);
      }
      
      private function petPublicProfileInfoReceived(param1:Object, param2:Event) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:String = null;
         switch(param1.responseCode)
         {
            case 1:
               if(this.crntPetID == param1.profile.id)
               {
                  if(int(param1.profile.rented) == 1)
                  {
                     this.petProfile_mc.gotoAndStop(2);
                     this.publicPetProfile_mc.gotoAndStop(2);
                     this.publicPetProfile_mc.adoptionDate_tx.visible = false;
                     this.publicPetProfile_mc.juggle_tx.visible = false;
                     this.publicPetProfile_mc.status_tx.visible = false;
                     this.petName_txt.textColor = 32807;
                     this.publicPetProfile_mc.owner_mc.owner_tx.textColor = 32807;
                  }
                  else
                  {
                     this.resetPetProfile();
                  }
                  _loc3_ = param1.profile.name;
                  this.petName_txt.text = _loc3_;
                  _loc4_ = param1.profile.ownerId;
                  this.crntPetOwnerName = _loc4_;
                  this.publicPetProfile_mc.owner_mc.owner_tx.text = _loc4_;
                  _loc5_ = param1.profile.adoptedDate;
                  _loc6_ = this.extractSkillLevelFromArray(param1.profile.skills,PetSkillNames.JUGGLE);
                  _loc7_ = PetSkillsTricksProgression.getNumBallsUnlocked(_loc6_);
                  _loc8_ = this.extractSkillLevelFromArray(param1.profile.skills,PetSkillNames.JUMP);
                  _loc9_ = this.extractSkillLevelFromArray(param1.profile.skills,PetSkillNames.STAND_UP);
                  _loc10_ = PetSkillsTricksProgression.getWalkingStatus(_loc8_,_loc9_);
                  this.publicPetProfile_mc.adoptionDate_tx.text = DateTime.formatDate(_loc5_,3);
                  if(_loc7_ == 1)
                  {
                     this.publicPetProfile_mc.juggle_tx.text = _loc7_ + " ball";
                  }
                  else
                  {
                     this.publicPetProfile_mc.juggle_tx.text = _loc7_ + " balls";
                  }
                  this.publicPetProfile_mc.status_tx.text = _loc10_;
                  if(int(param1.profile.rented) == 1)
                  {
                     this.loadRentedPetImage(param1.profile.bc);
                  }
                  else if(param1.profile.pp != null)
                  {
                     this.loadImage(param1.profile.pp);
                  }
                  else
                  {
                     this.petProfile_mc.loading_mc.visible = false;
                  }
               }
               break;
            case 999:
               this.bin.showAlertBox("Error 999 loading pet profile",true);
         }
         this.publicPetProfile_mc.visible = true;
      }
      
      private function extractSkillLevelFromArray(param1:Array, param2:Number) : Number
      {
         var _loc4_:Object = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            if(_loc4_.skillID == param2)
            {
               return _loc4_.skillLevel;
            }
            _loc3_++;
         }
         return 0;
      }
      
      private function loadImage(param1:String) : void
      {
         var _loc2_:String = "http://66de562792cf613e1f12-992a8416bac56958371ba7e12c3e9554.r88.cf1.rackcdn.com/";
         var _loc3_:Loader = new Loader();
         var _loc4_:LoaderContext = new LoaderContext();
         _loc4_.checkPolicyFile = true;
         _loc3_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onImageLoaderError);
         _loc3_.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR,this.onImageLoaderError);
         _loc3_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.imageLoaded);
         var _loc5_:* = _loc2_ + param1 + "_thm.jpg";
         _loc3_.load(new URLRequest(_loc5_),_loc4_);
      }
      
      private function loadRentedPetImage(param1:String) : void
      {
         var _loc2_:String = "externalUIs/binPetsParadise/PetForADay/";
         var _loc3_:Loader = new Loader();
         _loc3_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onImageLoaderError);
         _loc3_.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR,this.onImageLoaderError);
         var _loc4_:* = _loc2_ + param1 + "_thm.jpg";
         URLhandler.loadFromCDN(_loc3_,_loc4_,this.imageLoaded);
      }
      
      private function imageLoaded(param1:Event) : void
      {
         var _loc2_:Loader = param1.target.loader;
         this.photoContainer_mc.addChild(_loc2_);
         this.petProfile_mc.loading_mc.visible = false;
      }
      
      private function onImageLoaderError(param1:IOErrorEvent) : void
      {
         this.petProfile_mc.loading_mc.visible = false;
      }
      
      private function clearLoadedImages() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.photoContainer_mc.numChildren)
         {
            this.photoContainer_mc.removeChild(this.photoContainer_mc.getChildAt(0));
            _loc1_++;
         }
      }
      
      private function sendInvite_CLICK(param1:MouseEvent) : void
      {
         this.showDialogueBox("Do you want to invite " + this.crntUserProfile + " to your nest? ",this.sendInvite);
      }
      
      private function sendInvite(param1:MouseEvent = null) : void
      {
         this.hideDialogueBox();
         this.showAlertBox("You have sent an invitation to " + this.crntUserProfile + ".");
         this.ssclient.inviteToNest(this.crntUserProfile);
         this.guestList.addUser(this.crntUserProfile);
         this.removeGuest_btn.visible = true;
      }
      
      private function removeGuest_CLICK(param1:MouseEvent) : void
      {
         this.showDialogueBox("Do you want to remove " + this.crntUserProfile + " from your guest list? ",this.removeGuestConfirmed);
      }
      
      private function removeGuestConfirmed(param1:MouseEvent = null) : void
      {
         this.hideDialogueBox();
         this.removeGuest(this.crntUserProfile);
      }
      
      private function removeGuest(param1:String) : void
      {
         this.ssclient.removeGuestFromNest(param1);
         this.guestList.removeUser(param1);
         this.removeGuest_btn.visible = false;
         if(this.guestFreeNest())
         {
            this.topRightDisplay.set_mode(1);
         }
      }
      
      public function guestRemoved(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         this.guestList.removeUser(_loc2_);
      }
      
      public function guestInNest(param1:String, param2:Boolean) : void
      {
         this.guestList.highlightUser(param1,param2);
         if(this.bin.inNest)
         {
            if(param2)
            {
               this.topRightDisplay.set_mode(2);
            }
            else if(this.guestList.noneHiLighted())
            {
               this.topRightDisplay.set_mode(1);
            }
         }
      }
      
      public function openTycoonPlaza(param1:Boolean) : void
      {
         if(param1)
         {
            this.plazaOpen = true;
            if(this.guestFreeNest())
            {
               this.topRightDisplay.set_mode(2);
            }
            else
            {
               this.topRightDisplay.set_mode(0);
            }
         }
         else
         {
            this.plazaOpen = false;
            this.topRightDisplay.set_mode(1);
         }
      }
      
      public function sendPlazaInvitation() : *
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = this.buddyList.getList();
         for(_loc2_ in _loc1_)
         {
            this.ssclient.inviteToNest(_loc1_[_loc2_].userName);
            this.guestList.addUser(_loc1_[_loc2_].userName);
         }
      }
      
      public function guestFreeNest() : Boolean
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Weevil = null;
         if(this.bin.inNest)
         {
            _loc1_ = this.bin.getWeevils();
            _loc2_ = int(_loc1_.length);
            if(_loc2_ == 0)
            {
               return true;
            }
            if(_loc2_ == 1)
            {
               _loc3_ = this.bin.getWeevilByID(this.bin.myUserID);
               if(_loc1_[0] == _loc3_)
               {
                  return true;
               }
               return false;
            }
            return false;
         }
         return this.guestList.noneHiLighted();
      }
      
      public function invitationReceived(param1:Array) : void
      {
         this.newInvite = true;
         var _loc2_:String = param1[2];
         this.addInvite(_loc2_);
      }
      
      private function showPetHelp(param1:MouseEvent = null) : void
      {
         this.bin.loadOverlayUI("overlayUIs/PetsTutorial.swf");
      }
      
      public function updatePetStats(param1:Pet) : void
      {
         var _loc2_:TextFormat = null;
         if(this.petCommandsUI.crntPet == param1)
         {
            this.petStatsUI.updateStats(param1.fuel,param1.vitality,param1.fitness,param1.energy);
         }
      }
      
      public function showJugglingTricks(param1:int) : void
      {
         this.petCommandsUI.showJugglingTricks(param1);
      }
      
      public function hideJugglingTricks() : void
      {
         this.petCommandsUI.hideJugglingTricks();
      }
      
      private function weevilDataReceived(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         switch(int(param1.responseCode))
         {
            case 1:
               _loc2_ = param1.weevil;
               _loc3_ = int(_loc2_.level);
               this.profileLevelNum_txt.text = String(_loc3_);
               this.weevilStatManager.setStarClr(this.profileLevelStar_spr,_loc3_);
               this.profileLevelIndicator_spr.visible = true;
               this.crntUserIDX = _loc2_.idx;
               this.buddyLastLog = _loc2_.lastLog;
               this.topHat_btn.visible = _loc2_.tycoon == "1" ? true : false;
               if(_loc2_.petIds == null)
               {
                  this.crntUserPets = new Array();
               }
               else
               {
                  this.crntUserPets = String(_loc2_.petIds).split(",");
               }
               if(this.crntUserPets.length > 0)
               {
                  this.binPet_btn.visible = true;
               }
               else
               {
                  this.binPet_btn.visible = false;
               }
               if(this.sa)
               {
                  this.topHat_btn.visible = false;
                  if(this.msa)
                  {
                     this.magStaff_btn.visible = true;
                  }
                  else
                  {
                     this.staff_btn.visible = true;
                  }
               }
               break;
            case 999:
               this.bin.showAlertBox("Error 999 weevil data",true);
         }
      }
      
      public function hideWeevilProfile(param1:MouseEvent = null) : void
      {
         this.weevilProfile_mc.visible = false;
      }
      
      public function hidePetProfile(param1:MouseEvent = null) : void
      {
         this.petProfile_mc.visible = false;
      }
      
      public function clearChatLog() : void
      {
         this.chatLog.clearLog();
      }
      
      private function showHideChatLog(param1:MouseEvent) : void
      {
         this.chatLog.vis = this.chatLog.vis == false;
         if(this.chatLog.vis)
         {
            this.hideBuddyPanel();
            this.hideNewsAndMessages();
         }
      }
      
      public function hideChatLog() : void
      {
         this.chatLog.vis = false;
      }
      
      public function addMsgToChatLog(param1:int, param2:String, param3:String) : void
      {
         this.chatLog.addMsg(param1,param2,param3);
      }
      
      public function lottoResultReceived(param1:Array) : void
      {
         this.lottoResults.liveResultReceived(param1[2],param1[3],param1[4],param1[5],param1[6]);
      }
      
      public function initClrSliders(param1:String) : void
      {
         this.topRightDisplay.initClrSliders(param1);
      }
      
      public function clearChatBox() : void
      {
         this.chatMsg_txt.text = "";
      }
      
      public function playSound(param1:String) : *
      {
         var _loc2_:Class = getDefinitionByName(param1) as Class;
         var _loc3_:Sound = Sound(new _loc2_());
         _loc3_.play();
      }
      
      public function set_mode(param1:int = 0) : void
      {
         this._crntMode = param1;
         this.camUILoader_spr.visible = false;
         if(param1 < 5)
         {
            if(!this.bin.browsingMap)
            {
               this.showControls(true);
            }
         }
         else
         {
            this.showControls(false);
         }
         this.hideCharacterDialogue();
         this.hideBuddyPanel();
         this.hideNewsAndMessages();
         switch(param1)
         {
            case -1:
               this.nest_btn.visible = true;
               this.myStuff_btn.visible = false;
               if(this.bin.crntLocID == -5 || this.bin.crntLocID == -50)
               {
                  this.topRightDisplay.set_mode(3);
               }
               else if(this.bin.crntLocID > -50)
               {
                  this.topRightDisplay.set_mode(4);
               }
               else
               {
                  this.topRightDisplay.set_mode(0);
               }
               this.camUI.disable();
               break;
            case 0:
               if(this.guestFreeNest())
               {
                  this.topRightDisplay.set_mode(1);
               }
               else
               {
                  this.topRightDisplay.set_mode(2);
               }
               this.camUI.disable();
               this.nest_btn.visible = false;
               if(this.bin.crntLocID == 5)
               {
                  this.myStuff_btn.visible = false;
               }
               else
               {
                  this.myStuff_btn.visible = true;
               }
               break;
            case 1:
               this.camUI.disable();
               this.camUI.resetCamModeBtns();
               this.nest_btn.visible = false;
               if(this.guestFreeNest() && (this.bin.crntLocID < 50 || !this.plazaOpen))
               {
                  this.topRightDisplay.set_mode(1);
                  this.myStuff_btn.visible = true;
               }
               else
               {
                  this.topRightDisplay.set_mode(0);
                  this.myStuff_btn.visible = false;
                  if(this.bin.crntLocID < 50 && !this.guestFreeNest())
                  {
                     this.topRightDisplay.set_mode(2);
                  }
               }
               break;
            case 2:
               this.topRightDisplay.set_mode(0);
               this.nest_btn.visible = true;
               this.myStuff_btn.visible = false;
               this.camUI.disable();
               this.camUI.resetCamModeBtns();
               break;
            case 3:
               this.topRightDisplay.set_mode(0);
               this.camUILoader_spr.visible = false;
               this.nest_btn.visible = true;
               this.myStuff_btn.visible = false;
               this.camUI.enable();
               this.camUI.setCamModeBtns();
               break;
            case 4:
               this.topRightDisplay.set_mode(0);
               this.nest_btn.visible = true;
               this.myStuff_btn.visible = false;
               this.camUI.disable();
               this.camUI.resetCamModeBtns();
               break;
            case 5:
               this.camUI.disable();
               this.topRightDisplay.set_mode(0);
               break;
            case 6:
               this.topRightDisplay.set_mode(0);
               this.warningBox_mc.visible = false;
               this.alertBox_mc.visible = false;
               this.nest_btn.visible = false;
               this.myStuff_btn.visible = false;
               this.camUI.disable();
               break;
            case 7:
               this.topRightDisplay.set_mode(0);
               this.myStuff_btn.visible = false;
         }
      }
      
      public function showLoader(param1:Object, param2:String) : void
      {
         var _loc3_:TextField = TextField(this.camUILoader_spr.getChildByName("loadMsg_txt"));
         _loc3_.text = param2;
         param1.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.showLoadProgress);
      }
      
      private function showLoadProgress(param1:ProgressEvent) : void
      {
         var _loc2_:Number = NaN;
         if(this._crntMode == 2)
         {
            this.camUILoader_spr.visible = true;
            _loc2_ = param1.bytesLoaded / param1.bytesTotal;
            this.loadBar_spr.scaleX = _loc2_;
         }
      }
      
      public function showBuddyPanel(param1:Event = null) : void
      {
         this.buddyPanelContainer.setVis(true);
         this.hideChatLog();
         this.hideNewsAndMessages();
      }
      
      public function hideBuddyPanel(param1:Event = null) : void
      {
         this.buddyPanelContainer.setVis(false);
      }
      
      public function showHideBuddyPanel(param1:Event = null) : void
      {
         if(this.buddyPanelContainer.getVis())
         {
            this.hideBuddyPanel();
         }
         else
         {
            this.showBuddyPanel();
         }
      }
      
      public function toggleNewsAndMessages(param1:MouseEvent = null) : void
      {
         this.newsAndMessages.toggleVisibility();
         this.numNewsTxt.text = "0";
         this.numNewsTxt.parent.visible = false;
         if(!this.numMessagesTxt.parent.visible)
         {
            this.tabletJiggleMC.gotoAndStop(1);
         }
      }
      
      private function handleTabletMouseOver(param1:MouseEvent) : void
      {
         this.tabletJiggleMC.visible = false;
      }
      
      private function handleTabletMouseOut(param1:MouseEvent) : void
      {
         this.tabletJiggleMC.visible = true;
      }
      
      public function hideNewsAndMessages() : void
      {
         this.newsAndMessages.hide();
      }
      
      private function initNews(param1:int) : void
      {
         var _loc2_:int = VersionHandler.newsVersion;
         this.newsAndMessages.setLastNewsRead(param1);
         this.newsAndMessages.loadNews(_loc2_);
         if(param1 < _loc2_)
         {
            this.UI_mc.addEventListener("newNewsAvailable",this.onNewsConfig);
         }
      }
      
      private function onNewsConfig(param1:Event) : void
      {
         var _loc2_:int = this.newsAndMessages.getNumNewNews();
         if(!QuestControl.isTaskComplete(NewUserProgressManager.DISMISS_LEVEL3) && !QuestControl.isTaskComplete(NewUserProgressManager.DECORATE_NEST_TASK))
         {
            _loc2_ = 0;
         }
         if(_loc2_ > 0)
         {
            this.numNewsTxt.text = String(_loc2_);
            this.numNewsTxt.parent.visible = true;
            this.tabletJiggleMC.play();
         }
         else
         {
            this.tabletJiggleMC.gotoAndStop(1);
         }
      }
      
      private function onBuddyMessagesTotal(param1:BuddyMessageEvent) : void
      {
         if(param1.numNew > 0)
         {
            this.tabletJiggleMC.play();
         }
         else if(parseInt(this.numNewsTxt.text) < 1)
         {
            this.tabletJiggleMC.gotoAndStop(1);
         }
      }
      
      private function onNewBuddyMessageRead(param1:BuddyMessageEvent) : void
      {
         if(!this.numMessagesTxt.parent.visible && parseInt(this.numNewsTxt.text) < 1)
         {
            this.tabletJiggleMC.gotoAndStop(1);
         }
      }
      
      public function enableBuddyFeed(param1:Event = null) : void
      {
         this.buddyFeedContainer.isOn = true;
         this.UI_mc.controls_mc.buddyAlertsBtn_mc.cross_mc.visible = false;
         if(this.tooltipsManager)
         {
            this.tooltipsManager.removeTip(this.UI_mc.controls_mc.buddyAlertsBtn_mc._btn);
            this.setHint(this.UI_mc.controls_mc.buddyAlertsBtn_mc._btn,"Turn off buddy alerts",630,501);
         }
      }
      
      public function disableBuddyFeed(param1:Event = null) : void
      {
         this.buddyFeedContainer.isOn = false;
         this.UI_mc.controls_mc.buddyAlertsBtn_mc.cross_mc.visible = true;
         if(this.tooltipsManager)
         {
            this.tooltipsManager.removeTip(this.UI_mc.controls_mc.buddyAlertsBtn_mc._btn);
            this.setHint(this.UI_mc.controls_mc.buddyAlertsBtn_mc._btn,"Turn on buddy alerts",630,501);
         }
      }
      
      public function enableDisableBuddyFeed(param1:Event = null) : void
      {
         this.buddyFeedContainer.clickInitiated = true;
         if(this.buddyFeedContainer.isOn)
         {
            this.disableBuddyFeed();
         }
         else
         {
            this.enableBuddyFeed();
         }
      }
      
      private function setBuddyFeedCanShow(param1:Boolean) : void
      {
         this.buddyFeedContainer.setCanShow(param1);
      }
      
      public function showBinBadges(param1:Event = null) : void
      {
         this.binBadgesContainer.showBadges(this.bin.myUserIDX,true);
         this.hideChatLog();
         this.hideBuddyPanel();
         this.hideNewsAndMessages();
      }
      
      public function startBinBadges() : void
      {
         this.binBadgesContainer.init();
      }
      
      private function checkWeevilBadges(param1:MouseEvent) : void
      {
         this.binBadgesContainer.showBadges(this.crntUserIDX);
      }
      
      private function checkPetProfile(param1:MouseEvent) : void
      {
         var _loc3_:Pet = null;
         var _loc2_:Boolean = this.crntUserIDX == this.bin.myUserIDX ? true : false;
         if(_loc2_)
         {
            _loc3_ = this.bin.getAllMyPets()[0];
            this.showPetProfile(_loc3_.id,true,_loc3_);
         }
         else
         {
            this.showPetProfile(this.crntUserPets[0],true);
         }
      }
      
      private function loadBubbleTester() : void
      {
         URLhandler.loadFromCDN(new Loader(),"Utils/bubbleTester.swf",this.onBubbleTesterLoaded);
      }
      
      private function onBubbleTesterLoaded(param1:Event) : void
      {
         var _loc2_:Loader = Loader(param1.target.loader);
         var _loc3_:MovieClip = MovieClip(_loc2_.content);
         this.UI_mc.addChild(_loc3_);
         _loc3_.init(this.ssclient,this.bin);
      }
      
      public function tryToShowVideoAds() : void
      {
         var urlLoader:URLLoader = null;
         var crossDomainURL:String = "https://ads.superawesome.tv/crossdomain.xml";
         var googleCrossDomain:String = "http://imasdk.googleapis.com/crossdomain.xml";
         Security.allowDomain("*");
         Security.loadPolicyFile(crossDomainURL);
         Security.loadPolicyFile(googleCrossDomain);
         this.hideVideoAds();
         urlLoader = new URLLoader();
         urlLoader.addEventListener(Event.COMPLETE,function(param1:Event):*
         {
            var _loc2_:Object = com.adobe.serialization.json.JSON.decode(urlLoader.data);
            if(_loc2_.creative != null)
            {
               if(_loc2_.creative.details.vast != null)
               {
                  UI_mc.controls_mc.videoAdsBtn_mc.visible = true;
               }
            }
         });
         urlLoader.addEventListener(IOErrorEvent.IO_ERROR,function(param1:Event):*
         {
            hideVideoAds();
         });
         urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function(param1:Event):*
         {
            hideVideoAds();
         });
         urlLoader.load(new URLRequest("https://ads.superawesome.tv/v2/ad/24720"));
      }
      
      private function doesAnyVideoAvailableHandler(param1:Object, param2:Event) : void
      {
         if(param1.responseCode == 1)
         {
            if(param1.errCode != null)
            {
               this.UI_mc.controls_mc.videoAdsBtn_mc.visible = false;
            }
            else if(param1.data.videos > 0)
            {
               this.UI_mc.controls_mc.videoAdsBtn_mc.visible = true;
            }
            else
            {
               this.UI_mc.controls_mc.videoAdsBtn_mc.visible = false;
            }
         }
         else
         {
            this.UI_mc.controls_mc.videoAdsBtn_mc.visible = false;
         }
      }
      
      public function hideVideoAds() : void
      {
         this.UI_mc.controls_mc.videoAdsBtn_mc.visible = false;
      }
      
      private function openVideoAdsUI(param1:MouseEvent) : void
      {
         var _loc2_:String = URLhandler.getPath("videoAdsUI");
         this.bin.loadInterface({
            "path":_loc2_,
            "locName":"videoAdsUI"
         });
      }
      
      private function configRadioStuff() : void
      {
      }
      
      private function openRadioUI(param1:MouseEvent) : void
      {
         this.bin.loadOverlayUI("overlayUIs/BWradio_shoppingMall.swf");
      }
   }
}

