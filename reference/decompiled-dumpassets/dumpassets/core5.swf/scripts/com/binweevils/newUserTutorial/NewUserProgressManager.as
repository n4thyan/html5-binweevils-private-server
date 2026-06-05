package com.binweevils.newUserTutorial
{
   import com.binweevils.QuestControl;
   import com.binweevils.utilities.URLhandler;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   
   public class NewUserProgressManager
   {
      
      public static var LOGIN_TASK:Number = 900;
      
      public static var WATCH_STORY_INTRO:Number = 946;
      
      public static var DECORATE_NEST_TASK:Number = 901;
      
      public static var PLAY_GAME_TASK:Number = 902;
      
      public static var BUY_NEST_ITEM_TASK:Number = 903;
      
      public static var PLANT_SEED_TASK:Number = 904;
      
      public static var FEED_WEEVIL_TASK:Number = 905;
      
      public static var STAMP_YOUR_BIN_CARD_TASK:Number = 906;
      
      public static var HARVEST_PLANT_TASK:Number = 907;
      
      public static var COMPLETED_ALL_TASKS:Number = 908;
      
      public static var COLECTED_MULCH_TASK:Number = 911;
      
      public static var EXIT_WEEVIL_CHANGER:Number = 947;
      
      public static var UNLOCKED_NEST:Number = 948;
      
      public static var DISMISS_LEVEL2:Number = 949;
      
      public static var COOLNESS_EXPLANATION:Number = 950;
      
      public static var NEST_ITEM_CHOICE:Number = 951;
      
      public static var DECORATE_ROOM:Number = 952;
      
      public static var DISMISS_LEVEL3:Number = 953;
      
      public static var ADD_ITEMS_TO_ROOM:Number = 954;
      
      public static var ITEM_OPTION1:Number = 955;
      
      public static var ITEM_OPTION2:Number = 956;
      
      public static var ITEM_OPTION3:Number = 957;
      
      public static var COMPLETED_TUTORIAL_TASK:Number = 999;
      
      public static var SHOW_PLAY_GAME_TASK_COMPLETE:Number = 38;
      
      public static var OPEN_CHEST_ROOM:Number = 3;
      
      public static var DRAG_SHELF_ROOM:Number = 4;
      
      public static var DRAG_EGG_TO_SHELF:Number = 5;
      
      public static var CLOSE_ROOM_CHEST:Number = 6;
      
      public static var PLACE_ITEM_IN_NEST_TASK:Number = 7;
      
      public static var OPEN_CHEST_GARDEN:Number = 34;
      
      public static var DRAG_SEED_GARDEN:Number = 37;
      
      public static var CLOSE_GARDEN_CHEST_TASK:Number = 32;
      
      public static var CONNECT_MULCH_CLICKED:Number = 958;
      
      public static var POOL_TABLE_CLICKED:Number = 959;
      
      public static var FLIP_MULCH_CLICKED:Number = 960;
      
      public static var SQUARES_CLICKED:Number = 961;
      
      public static var MAP_LOC:String = "map";
      
      public static var LABSLAB_LOC:String = "LabsLab";
      
      public static var NESTCO_LOC:String = "Nestco";
      
      public static var BINCARD_LOC:String = "loyaltyCard";
      
      public static var TUTORIAL_COMPLETED_EVENT:String = "TUTORIAL_COMPLETED_EVENT";
      
      private var contentsLoadedFunc:Function;
      
      private var container:MovieClip;
      
      private var _isActive:Boolean = true;
      
      private var _isNewUser:Boolean = true;
      
      private var _isFirstLogin:Boolean = true;
      
      private var tutorialMain:ITutorial;
      
      public function NewUserProgressManager(param1:MovieClip)
      {
         super();
         this.container = param1;
      }
      
      public function checkTasksCompleted() : void
      {
         if(QuestControl.isTaskComplete(COMPLETED_TUTORIAL_TASK))
         {
            this._isActive = false;
            this._isNewUser = false;
            this._isFirstLogin = false;
         }
         else if(QuestControl.isTaskComplete(LOGIN_TASK))
         {
            this._isFirstLogin = false;
         }
      }
      
      public function hideTutorialUI() : void
      {
         if(!this.isActive)
         {
            return;
         }
         this.tutorialMain.hideTutorialUI();
      }
      
      public function showTutorialUI() : void
      {
         this.tutorialMain.showTutorialUI();
      }
      
      public function init() : void
      {
         this.tutorialMain.init();
      }
      
      public function completeTask(param1:Number) : void
      {
         if(!this.isActive)
         {
            return;
         }
         this.tutorialMain.completeTask(param1);
      }
      
      public function loadContents(param1:Function) : void
      {
         this.contentsLoadedFunc = param1;
         var _loc2_:Loader = new Loader();
         _loc2_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onContentLoaderError);
         var _loc3_:String = "tutorial";
         var _loc4_:String = URLhandler.getPath(_loc3_);
         URLhandler.loadFromCDN(_loc2_,_loc4_,this.onContentLoaded);
      }
      
      public function enableTutorial() : void
      {
         this._isActive = true;
         this.showTutorialUI();
         this.newLocationLoaded(5,"Nest Hall");
         this.tutorialMain.showTaskClipBoard();
         this.tutorialMain.hideTaskClipBoard();
      }
      
      public function disableTutorial() : void
      {
         this._isActive = false;
         this.hideTutorialUI();
      }
      
      private function onContentLoaderError(param1:IOErrorEvent) : void
      {
         this.contentsLoadedFunc();
      }
      
      private function onContentLoaded(param1:Event) : void
      {
         var _loc2_:Loader = param1.target.loader;
         this.tutorialMain = ITutorial(_loc2_.content);
         this.tutorialMain.config(this.container);
         this.tutorialMain.checkTasksCompleted();
         this.contentsLoadedFunc();
         this.tutorialMain.addEventListener(TUTORIAL_COMPLETED_EVENT,this.tutorialCompleteHandler);
         if(!QuestControl.isTaskComplete(DISMISS_LEVEL3))
         {
            this._isActive = false;
         }
      }
      
      private function tutorialCompleteHandler(param1:Event) : void
      {
         this._isActive = false;
      }
      
      public function loadingNewLocation() : void
      {
         if(!this.isActive)
         {
            return;
         }
         this.tutorialMain.loadingNewLocation();
      }
      
      public function newLocationLoaded(param1:Number, param2:String) : void
      {
         if(!this.isActive)
         {
            return;
         }
         this.tutorialMain.newLocationLoaded(param1,param2);
      }
      
      public function newExtUIOpened(param1:String) : void
      {
         if(!this.isActive)
         {
            return;
         }
         this.tutorialMain.newExtUIOpened(param1);
      }
      
      public function closedExtUI() : void
      {
         if(!this.isActive)
         {
            return;
         }
         this.tutorialMain.closedExtUI();
      }
      
      public function get isNewUser() : Boolean
      {
         return this._isNewUser;
      }
      
      public function get isFirstLogin() : Boolean
      {
         return this._isFirstLogin;
      }
      
      public function get isActive() : Boolean
      {
         return this._isActive;
      }
   }
}

