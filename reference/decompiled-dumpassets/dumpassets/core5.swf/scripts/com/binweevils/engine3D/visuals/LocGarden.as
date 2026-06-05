package com.binweevils.engine3D.visuals
{
   import assetsNest.*;
   import com.binweevils.DBaccess.PHPcall;
   import com.binweevils.engine3D.*;
   import com.binweevils.newUserTutorial.NewUserProgressManager;
   import com.binweevils.overlayUIs.gardenItemControl.GardenItemGroupData;
   import com.binweevils.overlayUIs.gardenItemControl.SeedGroupData;
   import com.binweevils.utilities.URLhandler;
   import com.binweevils.utilities.Utils;
   import com.binweevils.utilities.XML2JSON;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.net.*;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class LocGarden extends LocNest
   {
      
      private var nest_spr:Sprite;
      
      private var lawn_mc:MovieClip;
      
      private var boundaryCircle_spr:Sprite;
      
      public var fenceFrontHolder_spr:Sprite;
      
      public var fenceBackHolder_spr:Sprite;
      
      private var buySeedsSign_mc:MovieClip;
      
      private var loader_mc:MovieClip;
      
      private var harvestRobot_mc:MovieClip;
      
      private var harvestRake:MovieClip;
      
      private var harvestShovel:MovieClip;
      
      private var openHarvestRobotButton_mc:MovieClip;
      
      private var harvestAllPerishableButton_mc:MovieClip;
      
      private var harvestAllPermanentButton:MovieClip;
      
      private var harvestPerishableCooldown:int;
      
      private var harvestPermanentCooldown:int;
      
      public var plants:Array;
      
      private var plantLoaders:Array;
      
      private var crntPlant:int;
      
      private var plantTimer:Timer;
      
      public var gardenItems:Array;
      
      public var fence:GardenFence;
      
      private var wateringCan:GardenItem;
      
      private var wateringCanResetX:*;
      
      private var wateringCanResetZ:Number;
      
      private var crntOwner:String;
      
      private var _ownerHappiness:Number;
      
      private var mine:Boolean;
      
      private var gardenItemControl:Object;
      
      private var circle_ctrlV:*;
      
      private var circle_anchrV:Array;
      
      private var segmentAngle:Number = 0.7853981633974483;
      
      private var circleClr:int;
      
      private var updateBoundCircle:Boolean;
      
      private var plantInfo_spr:Sprite;
      
      private var plantActions1_spr:Sprite;
      
      private var plantActions1a_spr:Sprite;
      
      private var plantActions2_spr:Sprite;
      
      private var plantWithered_spr:Sprite;
      
      private var harvesting_spr:Sprite;
      
      private var harvestingBar_mc:MovieClip;
      
      private var selectedPlant:Plant;
      
      private var harvestTimer:Timer;
      
      private var wateringCanTimer:Timer;
      
      private var harvestCallBackCount:int;
      
      private var busy:Boolean;
      
      private var _newItemsAcquired:Boolean;
      
      private var loadingStoredItems:Boolean;
      
      private var allItemsDataById:Array = new Array();
      
      public var clearSoldItems:Boolean;
      
      public function LocGarden(param1:Sprite, param2:int, param3:int, param4:String, param5:String, param6:Array, param7:Object, param8:Number, param9:Number, param10:Number, param11:Array, param12:int, param13:String)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,[],param12,param13);
         _myDefaultEntryX = param9;
         _myDefaultEntryZ = param10;
         if(id > 0)
         {
            this.mine = true;
         }
         else
         {
            this.mine = false;
         }
         this.plants = new Array();
         this.gardenItems = new Array();
         this.plantLoaders = new Array();
         this.plantTimer = new Timer(60000);
         this.plantTimer.addEventListener("timer",this.agePlants);
         this.harvestTimer = new Timer(2500,2);
         this.harvestTimer.addEventListener("timer",this.finishedHarvesting);
         this.wateringCanTimer = new Timer(2000,1);
         this.wateringCanTimer.addEventListener("timer",this.resetWateringCan);
      }
      
      public function newItemsAdded() : void
      {
         this._newItemsAcquired = true;
      }
      
      public function itemsSold() : void
      {
         this.clearSoldItems = true;
      }
      
      public function newItemsRequested() : void
      {
         this._newItemsAcquired = false;
      }
      
      public function get newItemsAcquired() : Boolean
      {
         return this._newItemsAcquired;
      }
      
      override public function cleanUp() : void
      {
         var _loc1_:GardenItem = null;
         var _loc2_:DisplayObject = null;
         var _loc3_:Plant = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(nest.ownerName != this.crntOwner)
         {
            for each(_loc1_ in this.gardenItems)
            {
               _loc2_ = Visual(_loc1_).d_o;
               _loc2_.parent.removeChild(_loc2_);
            }
            for each(_loc3_ in this.plants)
            {
               _loc2_ = Visual(_loc3_).d_o;
               _loc2_.parent.removeChild(_loc2_);
            }
            this.gardenItems = [];
            this.plants = [];
            _loc5_ = int(visuals.length);
            _loc4_ = _loc5_ - 1;
            while(_loc4_ >= 0)
            {
               if((visuals[_loc4_].type == "plant" || visuals[_loc4_].type == "item") && visuals[_loc4_].d_o.parent == null)
               {
                  visuals.splice(_loc4_,1);
               }
               _loc4_--;
            }
            _loc6_ = int(assetLoaders.length);
            _loc4_ = _loc6_ - 1;
            while(_loc4_ >= 0)
            {
               if(assetLoaders[_loc4_] is GardenItemLoader || assetLoaders[_loc4_] is PlantLoader)
               {
                  assetLoaders.splice(_loc4_,1);
               }
               _loc4_--;
            }
            this.plantLoaders = [];
            this.crntPlant = 0;
            this.removeFence();
            loaded = false;
            if(!initialised)
            {
               crntAsset = 0;
            }
            else
            {
               crntAsset = 1;
            }
         }
      }
      
      override public function getClickable() : InteractiveObject
      {
         return this.lawn_mc;
      }
      
      override public function addAssetInfo(param1:XML) : void
      {
         var _loc3_:GardenItemGroupData = null;
         var _loc2_:String = param1.name();
         switch(_loc2_)
         {
            case "roomBG":
               assetLoaders.push(new AssetLoader(param1,true));
               break;
            case "item":
               if(!this.itemAlreadyExists(param1.attribute("id")))
               {
                  if(param1.attribute("cat") == "5")
                  {
                     _loc3_ = new GardenItemGroupData(XML2JSON.parse(param1));
                     this.addItemDataById(_loc3_);
                     this.addGardenItemInfo(_loc3_);
                  }
                  else if(this.mine)
                  {
                     nest.send_removeItem(param1.attribute("id"));
                  }
               }
         }
      }
      
      public function addPlantInfo(param1:SeedGroupData) : void
      {
         this.plantLoaders.push(new PlantLoader(param1));
      }
      
      public function getPlantLoader(param1:SeedGroupData) : GardenLoader
      {
         return new PlantLoader(param1);
      }
      
      public function addGardenItemInfo(param1:GardenItemGroupData) : void
      {
         assetLoaders.push(new GardenItemLoader(param1));
      }
      
      public function getGardenItemLoader(param1:GardenItemGroupData) : GardenLoader
      {
         return new GardenItemLoader(param1,true);
      }
      
      public function getItemDataById(param1:String) : GardenItemGroupData
      {
         return this.allItemsDataById["id" + param1];
      }
      
      public function addItemDataById(param1:GardenItemGroupData) : void
      {
         this.allItemsDataById["id" + param1.id] = param1;
      }
      
      private function checkPlantDefLegal(param1:XML) : Boolean
      {
         var _loc2_:Number = int(param1.attribute("x"));
         var _loc3_:Number = int(param1.attribute("z"));
         var _loc4_:Number = int(param1.attribute("r"));
         if(!isWithinBounds(_loc2_,_loc3_,_loc4_))
         {
            return false;
         }
         return true;
      }
      
      private function itemAlreadyExists(param1:int) : Boolean
      {
         var _loc2_:* = undefined;
         for(_loc2_ in assetLoaders)
         {
            if(assetLoaders[_loc2_].id == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function plantAlreadyExists(param1:int) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:PlantLoader = null;
         for(_loc2_ in this.plantLoaders)
         {
            _loc3_ = this.plantLoaders[_loc2_];
            if(_loc3_.id == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      override protected function createDoors() : void
      {
         var _loc1_:XML = null;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Boolean = false;
         var _loc15_:String = null;
         if(!doorsCreated)
         {
            for each(_loc1_ in doorList)
            {
               _loc2_ = int(_loc1_.attribute("id"));
               _loc3_ = Sprite(bg_spr.getChildByName("door" + _loc2_ + "_mc"));
               _loc3_.addEventListener(MouseEvent.MOUSE_DOWN,this.hideAllPlantBoxes);
               _loc4_ = 0;
               if(_loc1_.attribute("toLoc") == undefined)
               {
                  _loc5_ = Utils.stringToObject(_loc1_.attribute("extUIData"));
               }
               else
               {
                  _loc4_ = int(_loc1_.attribute("toLoc"));
                  if(id < 0)
                  {
                     _loc4_ = -_loc4_;
                  }
               }
               _loc6_ = int(_loc1_.attribute("toDoor"));
               _loc7_ = Number(_loc1_.attribute("x1"));
               _loc8_ = Number(_loc1_.attribute("z1"));
               _loc9_ = Number(_loc1_.attribute("x2"));
               _loc10_ = Number(_loc1_.attribute("z2"));
               _loc11_ = Number(_loc1_.attribute("y"));
               _loc12_ = Number(_loc1_.attribute("y2"));
               _loc13_ = NaN;
               _loc14_ = false;
               if(_loc1_.attribute("tycoonOnly") == "true")
               {
                  _loc14_ = true;
               }
               _loc15_ = _loc1_.attribute("nonTyconOverlay");
               doors[_loc2_] = new Door(this,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc13_,_loc11_,_loc12_,"fixedCam",_loc14_,_loc15_);
            }
            doorsCreated = true;
         }
      }
      
      public function loadPlantFromSeed(param1:PlantLoader) : void
      {
         param1.addEventListener(GardenLoader.EVENT_PLANT_LOADED_FROM_SEED,this.plantLoadedFromSeedHandler);
         this.showLoader();
         param1.loadMainAsset();
      }
      
      private function plantLoadedFromSeedHandler(param1:Event) : void
      {
         var _loc2_:PlantLoader = param1.currentTarget as PlantLoader;
         _loc2_.removeEventListener(GardenLoader.EVENT_PLANT_LOADED,this.plantLoadedFromSeedHandler);
         this.itemFromStorageLoaded(_loc2_.visual);
         this.hideLoader();
      }
      
      public function itemFromStorageLoaded(param1:Visual) : void
      {
         this.gardenItemControl.addItemToGarden(param1);
      }
      
      public function manageSeed(param1:PlantLoader = null) : void
      {
         this.gardenItemControl.thumbLoaded(param1);
      }
      
      public function manageStoredThumb(param1:GardenItemLoader = null) : void
      {
         this.gardenItemControl.thumbLoaded(param1);
      }
      
      override public function manageAsset(param1:Visual, param2:IItemLoader = null) : void
      {
         var _loc3_:String = param1.type;
         var _loc4_:String = param1.subType;
         switch(_loc3_)
         {
            case "roomBG":
               if(bg_spr == null)
               {
                  bg_spr = Sprite(param1.d_o);
                  this.nest_spr = Sprite(bg_spr.getChildByName("nest"));
                  this.lawn_mc = MovieClip(bg_spr.getChildByName("lawn_mc"));
                  this.boundaryCircle_spr = Sprite(bg_spr.getChildByName("boundaryCircle_spr"));
                  this.fenceFrontHolder_spr = Sprite(bg_spr.getChildByName("fenceFrontHolder"));
                  this.fenceBackHolder_spr = Sprite(bg_spr.getChildByName("fenceBackHolder"));
                  this.plantInfo_spr = Sprite(bg_spr.getChildByName("plantInfo_spr"));
                  this.plantActions1a_spr = Sprite(bg_spr.getChildByName("plantActions1a_spr"));
                  this.plantActions1_spr = Sprite(bg_spr.getChildByName("plantActions1_spr"));
                  this.plantActions2_spr = Sprite(bg_spr.getChildByName("plantActions2_spr"));
                  this.plantWithered_spr = Sprite(bg_spr.getChildByName("plantWithered_spr"));
                  this.harvesting_spr = Sprite(bg_spr.getChildByName("harvesting_spr"));
                  this.harvestingBar_mc = MovieClip(this.harvesting_spr.getChildByName("waitingBar_mc"));
                  this.harvestingBar_mc.stop();
                  this.buySeedsSign_mc = MovieClip(bg_spr.getChildByName("buySeedsSign_mc"));
                  this.loader_mc = MovieClip(bg_spr.getChildByName("loader_mc"));
                  this.harvestRobot_mc = MovieClip(bg_spr.getChildByName("harvestRobot"));
                  this.openHarvestRobotButton_mc = this.harvestRobot_mc.openButton;
                  this.harvestAllPerishableButton_mc = this.harvestRobot_mc.perishable;
                  this.harvestAllPermanentButton = this.harvestRobot_mc.permanent;
                  this.harvestRake = this.harvestRobot_mc.rake;
                  this.harvestShovel = this.harvestRobot_mc.shovel;
                  SimpleButton(this.harvestRobot_mc.getChildByName("close_btn")).addEventListener(MouseEvent.CLICK,this.closeRobot);
                  SimpleButton(this.plantActions1_spr.getChildByName("water_btn")).addEventListener(MouseEvent.CLICK,this.waterPlant);
                  SimpleButton(this.plantActions1_spr.getChildByName("harvest_btn")).addEventListener(MouseEvent.CLICK,this.showHarvestDialogue1);
                  SimpleButton(this.plantActions1a_spr.getChildByName("harvest_btn")).addEventListener(MouseEvent.CLICK,this.showHarvestDialogue1);
                  SimpleButton(this.plantActions2_spr.getChildByName("harvest_btn")).addEventListener(MouseEvent.CLICK,this.showHarvestDialogue2);
                  SimpleButton(this.plantWithered_spr.getChildByName("remove_btn")).addEventListener(MouseEvent.CLICK,this.removeWitheredPlantClicked);
                  this.lawn_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.hideAllPlantBoxes);
                  bg_spr.addEventListener(MouseEvent.MOUSE_DOWN,this.hideAllPlantBoxes);
                  this.fenceFrontHolder_spr.addEventListener(MouseEvent.MOUSE_DOWN,this.hideAllPlantBoxes);
                  this.fenceBackHolder_spr.addEventListener(MouseEvent.MOUSE_DOWN,this.hideAllPlantBoxes);
                  this.plantInfo_spr.addEventListener(MouseEvent.MOUSE_DOWN,this.hideAllPlantBoxes);
                  bg_spr.addEventListener(Event.REMOVED_FROM_STAGE,this.hideAllPlantBoxes);
                  this.buySeedsSign_mc.btn.addEventListener(MouseEvent.CLICK,this.goBuySeeds);
                  this.openHarvestRobotButton_mc.mouseEnabled = true;
                  this.openHarvestRobotButton_mc.buttonMode = true;
                  this.openHarvestRobotButton_mc.addEventListener(MouseEvent.CLICK,this.showRobot);
                  this.harvestAllPerishableButton_mc.addEventListener(MouseEvent.ROLL_OVER,this.harvestPerishableOver);
                  this.harvestAllPerishableButton_mc.addEventListener(MouseEvent.ROLL_OUT,this.harvestPerishableOut);
                  this.harvestAllPerishableButton_mc.addEventListener(MouseEvent.CLICK,this.harvestPerishable);
                  this.harvestAllPermanentButton.addEventListener(MouseEvent.ROLL_OVER,this.harvestPermanentOver);
                  this.harvestAllPermanentButton.addEventListener(MouseEvent.ROLL_OUT,this.harvestPermanentOut);
                  this.harvestAllPermanentButton.addEventListener(MouseEvent.CLICK,this.harvestPermanent);
                  this.hideAllPlantBoxes();
                  bgHolder_spr.addChildAt(bg_spr,0);
                  if(this.mine)
                  {
                     this.harvestRobot_mc.visible = true;
                     this.harvestRobot_mc.mouseChildren = true;
                     this.harvestRobot_mc.mouseEnabled = true;
                  }
                  else
                  {
                     this.harvestRobot_mc.visible = false;
                     this.harvestRobot_mc.mouseChildren = false;
                     this.harvestRobot_mc.mouseEnabled = false;
                  }
               }
               break;
            case "plant":
               visuals.push(param1);
               content_spr.addChild(param1.d_o);
               Plant(param1).setGarden(this);
               if(this.mine)
               {
                  Plant(param1).setClickHandler();
               }
               this.plants.push(param1);
               forceRender = true;
               break;
            case "item":
               if(_loc4_ == "fence")
               {
                  this.addFence(param1);
               }
               else
               {
                  if(_loc4_ == "wateringCan")
                  {
                     this.wateringCan = GardenItem(param1);
                  }
                  visuals.push(param1);
                  this.gardenItems.push(param1);
                  content_spr.addChild(param1.d_o);
                  forceRender = true;
               }
               break;
            default:
               visuals.push(param1);
               content_spr.addChild(param1.d_o);
         }
      }
      
      public function showHelp(param1:MouseEvent) : void
      {
         if(this.harvestRobot_mc.currentFrame == 1)
         {
            bin.loadOverlayUI("overlayUIs/gardenInfo.swf");
         }
      }
      
      public function goBuySeeds(param1:MouseEvent) : void
      {
         var _loc2_:String = URLhandler.getPath("GardeningShop");
         bin.loadInterface({
            "path":_loc2_,
            "userName":bin.myUserName,
            "fromGarden":true,
            "limbo":false
         });
      }
      
      private function getHarvestCooldowns(param1:MouseEvent = null) : void
      {
         var _loc2_:PHPcall = new PHPcall("garden/get-harvest-cooldowns",true);
         _loc2_.sendAndAwaitResponse([],[],this.onHarvestCooldownsRecieved,false);
      }
      
      private function onHarvestCooldownsRecieved(param1:Object) : void
      {
         if(param1.responseCode == 1)
         {
            this.harvestPerishableCooldown = param1.peri;
            this.harvestPermanentCooldown = param1["non-peri"];
            this.setHarvestClocks();
         }
      }
      
      private function setHarvestClocks() : void
      {
         this.harvestRake.clock.visible = this.harvestPerishableCooldown > 0;
         this.harvestShovel.clock.visible = this.harvestPermanentCooldown > 0;
      }
      
      public function showRobot(param1:MouseEvent) : void
      {
         if(this.harvestRobot_mc.currentFrame == 1)
         {
            this.harvestRobot_mc.gotoAndPlay("Open");
            this.getHarvestCooldowns();
         }
      }
      
      public function closeRobot(param1:MouseEvent) : void
      {
         if(this.harvestRobot_mc.currentFrame < 58)
         {
            this.harvestRobot_mc.gotoAndPlay("Close");
         }
      }
      
      public function harvestPerishable(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = null;
         if(bin.tycoon)
         {
            if(this.harvestRobot_mc.currentFrameLabel == "ReadyToHarvestPerishable")
            {
               if(this.harvestPerishableCooldown > 0)
               {
                  this.closeRobot(null);
                  _loc2_ = {
                     "peri":true,
                     "time":this.harvestPerishableCooldown
                  };
                  _loc3_ = URLhandler.getPath("harvestCooldownOverlay");
                  bin.loadOverlayUI(_loc3_,_loc2_);
               }
               else
               {
                  _loc4_ = 0;
                  _loc5_ = 0;
                  _loc6_ = 0;
                  while(_loc6_ < this.plants.length)
                  {
                     if(this.plants[_loc6_] is Plant_perishable && this.plants[_loc6_].getProgress() == 100)
                     {
                        _loc4_ += this.plants[_loc6_].xpYield;
                        _loc5_ += this.plants[_loc6_].mulchYield;
                     }
                     _loc6_++;
                  }
                  if(_loc4_ > 0)
                  {
                     _loc7_ = "Do you want to harvest all perishable plants for " + _loc5_ + " Mulch and " + _loc4_ + " XP?\n(The plants will then disappear.)";
                     bin.showDialogueBox(_loc7_,this.harvestAllPerishable);
                  }
                  else
                  {
                     bin.showAlertBox("There are currently no plants ready to harvest.");
                  }
               }
            }
         }
         else
         {
            bin.showAlertBox("You need to have a Bin Tycoon membership to use this feature!");
         }
      }
      
      private function harvestAllPerishable(param1:MouseEvent = null) : void
      {
         bin.hideDialogueBox();
         var _loc2_:PHPcall = new PHPcall("garden/harvest-all-perishables",true);
         _loc2_.sendAndAwaitResponse([],[],this.perishablesHarvested);
      }
      
      private function perishablesHarvested(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.closeRobot(null);
         if(param1.responseCode == 1)
         {
            _loc2_ = 0;
            while(_loc2_ < this.plants.length)
            {
               if(this.plants[_loc2_] is Plant_perishable && this.plants[_loc2_].getProgress() == 100)
               {
                  this.plants[_loc2_].harvest();
                  _loc2_--;
               }
               _loc2_++;
            }
            _loc3_ = int(param1.xp);
            _loc3_ += bin.myXp;
            bin.updateMulch(param1.mulch);
            bin.updateXp(_loc3_);
            bin.completedNewUserTask(NewUserProgressManager.HARVEST_PLANT_TASK);
         }
      }
      
      public function harvestPerishableOver(param1:MouseEvent) : void
      {
         if(this.harvestRobot_mc.currentFrame > 24 && this.harvestRobot_mc.currentFrame < 58)
         {
            this.harvestRobot_mc.gotoAndPlay("HarvestPerishableOver");
         }
      }
      
      public function harvestPerishableOut(param1:MouseEvent) : void
      {
         if(this.harvestRobot_mc.currentFrameLabel == "ReadyToHarvestPerishable")
         {
            this.harvestRobot_mc.gotoAndPlay("HarvestPerishableOut");
         }
         else if(this.harvestRobot_mc.currentFrame > 24 && this.harvestRobot_mc.currentFrame < 58)
         {
            this.harvestRobot_mc.gotoAndStop("Idle");
         }
      }
      
      public function harvestPermanent(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = null;
         if(bin.tycoon)
         {
            if(this.harvestRobot_mc.currentFrameLabel == "ReadyToHarvestPermanent")
            {
               if(this.harvestPermanentCooldown > 0)
               {
                  _loc2_ = {
                     "peri":false,
                     "time":this.harvestPermanentCooldown
                  };
                  this.closeRobot(null);
                  _loc3_ = URLhandler.getPath("harvestCooldownOverlay");
                  bin.loadOverlayUI(_loc3_,_loc2_);
               }
               else
               {
                  _loc4_ = 0;
                  _loc5_ = 0;
                  _loc6_ = 0;
                  while(_loc6_ < this.plants.length)
                  {
                     if(this.plants[_loc6_] is Plant_nonperishable && this.plants[_loc6_].getFruitProgress() == 100)
                     {
                        _loc4_ += this.plants[_loc6_].xpYield;
                        _loc5_ += this.plants[_loc6_].mulchYield;
                     }
                     _loc6_++;
                  }
                  if(_loc4_ > 0)
                  {
                     _loc7_ = "Do you want to harvest these plants for " + _loc5_ + " Mulch and " + _loc4_ + " XP?\n(You can harvest them again soon.)";
                     bin.showDialogueBox(_loc7_,this.harvestAllPermanent);
                  }
                  else
                  {
                     bin.showAlertBox("There are currently no plants ready to harvest.");
                  }
               }
            }
         }
         else
         {
            bin.showAlertBox("You need to have a Bin Tycoon membership to use this feature!");
         }
      }
      
      private function harvestAllPermanent(param1:MouseEvent = null) : void
      {
         bin.hideDialogueBox();
         var _loc2_:PHPcall = new PHPcall("garden/harvest-all-non-perishables",true);
         _loc2_.sendAndAwaitResponse([],[],this.permanentHarvested);
      }
      
      private function permanentHarvested(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.closeRobot(null);
         if(param1.responseCode == 1)
         {
            _loc2_ = 0;
            while(_loc2_ < this.plants.length)
            {
               if(this.plants[_loc2_] is Plant_nonperishable && this.plants[_loc2_].getFruitProgress() == 100)
               {
                  this.plants[_loc2_].harvest();
                  _loc2_--;
               }
               _loc2_++;
            }
            _loc3_ = int(param1.xp);
            _loc3_ += bin.myXp;
            bin.updateMulch(param1.mulch);
            bin.updateXp(_loc3_);
            bin.completedNewUserTask(NewUserProgressManager.HARVEST_PLANT_TASK);
         }
      }
      
      public function harvestPermanentOver(param1:MouseEvent) : void
      {
         if(this.harvestRobot_mc.currentFrame > 24 && this.harvestRobot_mc.currentFrame < 58)
         {
            this.harvestRobot_mc.gotoAndPlay("HarvestPermanentOver");
         }
      }
      
      public function harvestPermanentOut(param1:MouseEvent) : void
      {
         if(this.harvestRobot_mc.currentFrameLabel == "ReadyToHarvestPermanent")
         {
            this.harvestRobot_mc.gotoAndPlay("HarvestPermanentOut");
         }
         else if(this.harvestRobot_mc.currentFrame > 24 && this.harvestRobot_mc.currentFrame < 58)
         {
            this.harvestRobot_mc.gotoAndStop("Idle");
         }
      }
      
      public function updatePowerConsumption(param1:int) : void
      {
         nest.updatePowerConsumption(param1);
      }
      
      public function removeGardenItem(param1:GardenItem) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         _loc3_ = int(visuals.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(visuals[_loc2_] == param1)
            {
               visuals.splice(_loc2_,1);
               content_spr.removeChild(param1.d_o);
               break;
            }
            _loc2_++;
         }
         _loc3_ = int(this.gardenItems.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.gardenItems[_loc2_] == param1)
            {
               this.gardenItems.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function removePlant(param1:Plant) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         _loc3_ = int(visuals.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(visuals[_loc2_] == param1)
            {
               visuals.splice(_loc2_,1);
               content_spr.removeChild(param1.d_o);
               break;
            }
            _loc2_++;
         }
         _loc3_ = int(this.plants.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.plants[_loc2_] == param1)
            {
               this.plants.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function addFence(param1:Visual) : GardenFence
      {
         var _loc2_:GardenFence = this.fence;
         this.removeFence();
         this.fence = GardenFence(param1);
         this.fence.setFenceSize(this.gardenSize);
         this.fenceFrontHolder_spr.addChild(this.fence.fenceFront_mc);
         this.fenceBackHolder_spr.addChild(this.fence.fenceBack_mc);
         return _loc2_;
      }
      
      public function removeFence() : void
      {
         var _loc1_:int = 0;
         if(this.fenceFrontHolder_spr != null)
         {
            _loc1_ = this.fenceFrontHolder_spr.numChildren;
            while(_loc1_ > 0)
            {
               this.fenceFrontHolder_spr.removeChildAt(0);
               _loc1_--;
            }
            _loc1_ = this.fenceBackHolder_spr.numChildren;
            while(_loc1_ > 0)
            {
               this.fenceBackHolder_spr.removeChildAt(0);
               _loc1_--;
            }
         }
         this.fence = null;
      }
      
      public function extendGarden() : void
      {
         if(this.fence != null)
         {
            this.fence.setFenceSize(this.gardenSize);
         }
      }
      
      override public function loadManager() : void
      {
         var _loc1_:* = null;
         var _loc2_:GardenItemLoader = null;
         if(crntAsset < assetLoaders.length)
         {
            _loc1_ = "loading garden...  (" + (crntAsset + 1) + " of " + assetLoaders.length + ")";
            if(assetLoaders[crntAsset] is GardenLoader)
            {
               _loc2_ = assetLoaders[crntAsset];
               _loc2_.addEventListener(GardenLoader.EVENT_THUMB_LOADED,this.itemLoadedHandler);
               this.showLoader();
               _loc2_.loadAsset();
            }
            else
            {
               assetLoaders[crntAsset].loadAsset(this,_loc1_);
            }
            ++crntAsset;
         }
         else
         {
            this.hideLoader();
            if(!this.loadingStoredItems)
            {
               if(!initialised)
               {
                  initialised = true;
                  this.createDoors();
                  createInteractives();
                  setupObjects();
                  createNoGoAreas();
               }
               this.setColour();
               this.loadComplete();
            }
         }
      }
      
      private function itemLoadedHandler(param1:Event) : void
      {
         var _loc2_:GardenItemLoader = param1.currentTarget as GardenItemLoader;
         _loc2_.removeEventListener(GardenLoader.EVENT_THUMB_LOADED,this.itemLoadedHandler);
         this.manageAsset(_loc2_.visual);
         this.loadManager();
      }
      
      override protected function loadComplete() : void
      {
         this.lawn_mc.gotoAndStop(this.gardenSize);
         switch(nest.gardenSize)
         {
            case 1:
               resetRadBoundary(-3,360,197);
               break;
            case 2:
               resetRadBoundary(36,360,236);
               break;
            case 3:
               resetRadBoundary(75,360,275);
               break;
            case 4:
               resetRadBoundary(115,360,315);
               break;
            case 5:
               resetRadBoundary(154,360,354);
         }
         if(this.mine)
         {
            this.buySeedsSign_mc.visible = true;
         }
         else
         {
            this.buySeedsSign_mc.visible = false;
         }
         super.loadComplete();
         if(this.crntOwner != nest.ownerName)
         {
            this.crntOwner = nest.ownerName;
            this.getPlantConfigs();
         }
         bin.dealWithRegMsgDisplay();
      }
      
      public function get gardenSize() : int
      {
         return nest.gardenSize;
      }
      
      private function getPlantConfigs() : void
      {
         var request:URLRequest;
         var loader:URLLoader;
         var variables:URLVariables = new URLVariables();
         variables.userID = nest.ownerName;
         request = new URLRequest();
         request.url = URLhandler.servicesLocation + "garden/get-plant-configs?rndVar=" + Math.random();
         request.method = URLRequestMethod.POST;
         request.data = variables;
         loader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,this.plantConfigsReceived);
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
         }
      }
      
      private function plantConfigsReceived(param1:Event) : void
      {
         var _loc4_:XML = null;
         var _loc5_:Object = null;
         var _loc6_:SeedGroupData = null;
         var _loc2_:XML = new XML(param1.target.data);
         this._ownerHappiness = _loc2_.attribute("weevilHappiness");
         var _loc3_:XMLList = _loc2_.child("plant");
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = XML2JSON.parse(_loc4_);
            _loc6_ = new SeedGroupData(_loc5_);
            this.addPlantInfo(_loc6_);
         }
         this.plantLoadManager();
      }
      
      public function get ownerHappiness() : Number
      {
         return 100;
      }
      
      public function loadStoredItems(param1:Object) : void
      {
         this.loadingStoredItems = true;
         this.gardenItemControl = param1;
         this.plantLoadManager();
      }
      
      public function plantLoadManager() : void
      {
         var _loc2_:* = null;
         var _loc3_:PlantLoader = null;
         var _loc1_:int = int(this.plantLoaders.length);
         if(this.crntPlant < _loc1_)
         {
            _loc2_ = "loading nest contents...  (" + (this.crntPlant + 1) + " of " + _loc1_ + ")";
            _loc3_ = this.plantLoaders[this.crntPlant];
            _loc3_.addEventListener(GardenLoader.EVENT_PLANT_LOADED,this.plantLoadedHandler);
            this.showLoader();
            _loc3_.loadAsset();
            ++this.crntPlant;
         }
         else
         {
            this.hideLoader();
            this.plantTimer.start();
            if(this.loadingStoredItems)
            {
               this.loadManager();
            }
         }
      }
      
      private function plantLoadedHandler(param1:Event) : void
      {
         var _loc2_:PlantLoader = param1.currentTarget as PlantLoader;
         _loc2_.removeEventListener(GardenLoader.EVENT_PLANT_LOADED,this.plantLoadedHandler);
         this.manageAsset(_loc2_.visual);
         this.plantLoadManager();
      }
      
      public function showLoader() : void
      {
         this.loader_mc.gotoAndStop("open");
      }
      
      public function hideLoader() : void
      {
         if(this.loader_mc.currentFrame == 2)
         {
            this.loader_mc.gotoAndPlay("close");
         }
      }
      
      private function agePlants(param1:TimerEvent) : void
      {
         var _loc2_:Plant = null;
         for each(_loc2_ in this.plants)
         {
            _loc2_.incrAge();
         }
      }
      
      public function showGrowthProgress(param1:Plant) : void
      {
         this.configurePlantBox(param1,this.plantInfo_spr);
         var _loc2_:int = param1.getProgress();
         TextField(this.plantInfo_spr.getChildByName("info_txt")).text = _loc2_ + "% grown";
         var _loc3_:MovieClip = MovieClip(this.plantInfo_spr.getChildByName("progress_mc"));
         _loc3_.bar_spr.scaleX = 0.01 * _loc2_;
      }
      
      public function showFruitProgress(param1:Plant_nonperishable) : void
      {
         this.configurePlantBox(param1,this.plantInfo_spr);
         var _loc2_:int = param1.getFruitProgress();
         TextField(this.plantInfo_spr.getChildByName("info_txt")).text = _loc2_ + "% ready";
         var _loc3_:MovieClip = MovieClip(this.plantInfo_spr.getChildByName("progress_mc"));
         _loc3_.bar_spr.scaleX = 0.01 * _loc2_;
      }
      
      public function showHarvestOptions_perishable(param1:Plant_perishable, param2:Boolean = false) : void
      {
         if(this.wateringCanInGarden())
         {
            this.configurePlantBox(param1,this.plantActions1_spr);
         }
         else
         {
            this.configurePlantBox(param1,this.plantActions1a_spr);
         }
      }
      
      public function showHarvestOptions_nonperishable(param1:Plant_nonperishable) : void
      {
         this.configurePlantBox(param1,this.plantActions2_spr);
      }
      
      public function showPerished(param1:Plant_perishable) : void
      {
         this.configurePlantBox(param1,this.plantWithered_spr);
      }
      
      private function removeWitheredPlantClicked(param1:MouseEvent) : void
      {
         bin.showDialogueBox("Do you want to throw this plant away?",this.removeWitheredPlant);
      }
      
      private function removeWitheredPlant(param1:MouseEvent) : void
      {
         bin.hideDialogueBox();
         this.removePlant(this.selectedPlant);
         var _loc2_:PHPcall = new PHPcall("garden/remove-plant",true);
         _loc2_.fireAndForget(["plantID"],[this.selectedPlant.id],true);
         this.hideAllPlantBoxes();
      }
      
      private function configurePlantBox(param1:Plant, param2:Sprite) : void
      {
         var _loc3_:Point = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(!this.busy)
         {
            this.hideAllPlantBoxes();
            this.selectedPlant = param1;
            _loc3_ = param1.getRenderCoords();
            _loc4_ = _loc3_.x - 82;
            _loc5_ = _loc3_.y - 105;
            if(_loc4_ < 8)
            {
               _loc4_ = 8;
            }
            if(_loc4_ > 656)
            {
               _loc4_ = 656;
            }
            if(_loc5_ < 17)
            {
               _loc5_ = 17;
            }
            param2.x = _loc4_;
            param2.y = _loc5_;
            TextField(param2.getChildByName("name_txt")).text = param1.name;
            param2.visible = true;
         }
      }
      
      public function hideAllPlantBoxes(param1:Event = null) : void
      {
         bin.hideDialogueBox();
         this.plantInfo_spr.visible = false;
         this.plantActions1a_spr.visible = false;
         this.plantActions1_spr.visible = false;
         this.plantActions2_spr.visible = false;
         this.plantWithered_spr.visible = false;
         this.harvesting_spr.visible = false;
         this.selectedPlant = null;
      }
      
      private function showHarvestDialogue1(param1:MouseEvent) : void
      {
         var _loc2_:int = this.selectedPlant.mulchYield;
         var _loc3_:int = this.selectedPlant.xpYield;
         var _loc4_:* = "Do you want to harvest this plant for\n" + _loc2_ + " Mulch and " + _loc3_ + " XP?\n(This plant will then disappear.)";
         bin.showDialogueBox(_loc4_,this.harvestPlant);
      }
      
      private function showHarvestDialogue2(param1:MouseEvent) : void
      {
         var _loc2_:int = this.selectedPlant.mulchYield;
         var _loc3_:int = this.selectedPlant.xpYield;
         var _loc4_:* = "Do you want to harvest this plant for " + _loc2_ + " Mulch and " + _loc3_ + " XP?\n(You can harvest it again soon.)";
         bin.showDialogueBox(_loc4_,this.harvestPlant);
      }
      
      private function harvestPlant(param1:MouseEvent = null) : void
      {
         this.configurePlantBox(this.selectedPlant,this.harvesting_spr);
         this.busy = true;
         this.selectedPlant.busy = true;
         this.harvestCallBackCount = 0;
         this.harvestingBar_mc.play();
         this.harvestTimer.reset();
         this.harvestTimer.start();
         var _loc2_:PHPcall = new PHPcall("garden/harvest-plant",true);
         _loc2_.sendAndAwaitResponse(["plantID"],[this.selectedPlant.id],this.plantHarvested);
      }
      
      private function finishedHarvesting(param1:TimerEvent = null) : void
      {
         ++this.harvestCallBackCount;
         if(this.harvestCallBackCount >= 2)
         {
            this.harvestTimer.stop();
            this.harvesting_spr.visible = false;
            this.harvestingBar_mc.stop();
            this.busy = false;
         }
      }
      
      private function plantHarvested(param1:Object) : void
      {
         this.finishedHarvesting();
         var _loc2_:int = int(param1.plantID);
         var _loc3_:Plant = this.getPlantByID(_loc2_);
         _loc3_.harvest();
         bin.updateMulch(param1.mulch);
         bin.updateXp(param1.xp);
         bin.completedNewUserTask(NewUserProgressManager.HARVEST_PLANT_TASK);
      }
      
      private function waterPlant(param1:MouseEvent) : void
      {
         var _loc2_:PHPcall = null;
         if(this.wateringCanInGarden())
         {
            this.busy = true;
            this.wateringCanResetX = this.wateringCan.x;
            this.wateringCanResetZ = this.wateringCan.z;
            this.wateringCan.x = this.selectedPlant.x - 1;
            this.wateringCan.z = this.selectedPlant.z - 1;
            MovieClip(this.wateringCan.d_o).y = -1000;
            MovieClip(this.wateringCan.d_o).gotoAndPlay(2);
            forceRender = true;
            this.wateringCanTimer.reset();
            this.wateringCanTimer.start();
            if(Plant_perishable(this.selectedPlant).water())
            {
               _loc2_ = new PHPcall("garden/water-plant",true);
               _loc2_.fireAndForget(["plantID"],[this.selectedPlant.id]);
            }
         }
         else
         {
            bin.showAlertBox("You can\'t water plants until you have a watering can in your garden!\n You can buy one from the garden shop in the shopping mall.\nWatering plants keeps them alive for longer.");
         }
         this.hideAllPlantBoxes();
      }
      
      private function wateringCanInGarden() : Boolean
      {
         var _loc1_:* = undefined;
         if(this.wateringCan != null)
         {
            for(_loc1_ in this.gardenItems)
            {
               if(this.gardenItems[_loc1_] == this.wateringCan)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function resetWateringCan(param1:TimerEvent) : void
      {
         this.wateringCan.x = this.wateringCanResetX;
         this.wateringCan.z = this.wateringCanResetZ;
         MovieClip(this.wateringCan.d_o).y = -1000;
         MovieClip(this.wateringCan.d_o).gotoAndStop(1);
         forceRender = true;
         this.busy = false;
      }
      
      private function getPlantByID(param1:int) : Plant
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.plants)
         {
            if(this.plants[_loc2_].id == param1)
            {
               return this.plants[_loc2_];
            }
         }
         return null;
      }
      
      public function updatePlant1Pos(param1:Number, param2:Number, param3:Plant_perishable) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         var _loc4_:Point = bin.getFloorClickCoords(param1,param2);
         if(_loc4_ == null)
         {
            _loc5_ = -800;
            _loc6_ = 2000;
         }
         else
         {
            _loc5_ = _loc4_.x;
            _loc6_ = _loc4_.y;
         }
         param3.x = _loc5_;
         param3.z = _loc6_;
         if(isWithinBounds(_loc5_,_loc6_))
         {
            param3.d_o.alpha = 0.4;
         }
         else
         {
            param3.d_o.alpha = 1;
         }
      }
      
      public function createBoundCircle(param1:Number, param2:Number, param3:Number, param4:GardenItem = null, param5:Plant_nonperishable = null) : Point
      {
         var _loc10_:Number = NaN;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:Number = NaN;
         var _loc6_:Point = bin.getFloorClickCoords(param1,param2);
         if(_loc6_ == null)
         {
            return null;
         }
         var _loc7_:int = _loc6_.x;
         var _loc8_:int = _loc6_.y;
         if(param4 != null)
         {
            param4.x = _loc7_;
            param4.z = _loc8_;
         }
         else if(param5 != null)
         {
            param5.x = _loc7_;
            param5.z = _loc8_;
         }
         if(this.positionAllowed(_loc7_,_loc8_,param3,param4,param5))
         {
            this.circleClr = 16777215;
            if(param4 != null)
            {
               param4.d_o.alpha = 1;
            }
            else if(param5 != null)
            {
               param5.d_o.alpha = 1;
            }
         }
         else
         {
            _loc6_ = null;
            this.circleClr = 16711680;
            if(param4 != null)
            {
               param4.d_o.alpha = 0.4;
            }
            else if(param5 != null)
            {
               param5.d_o.alpha = 0.4;
            }
         }
         var _loc9_:Number = param3 / cos(this.segmentAngle / 2);
         var _loc15_:* = 0;
         this.circle_ctrlV = [];
         this.circle_anchrV = [];
         this.circle_anchrV[0] = new Vector3D(_loc7_ + param3,0,_loc8_);
         var _loc16_:int = 1;
         while(_loc16_ <= 8)
         {
            _loc15_ += this.segmentAngle;
            _loc10_ = _loc15_ - this.segmentAngle / 2;
            _loc11_ = _loc7_ + cos(_loc10_) * _loc9_;
            _loc12_ = _loc8_ + sin(_loc10_) * _loc9_;
            this.circle_ctrlV[_loc16_] = new Vector3D(_loc11_,0,_loc12_);
            _loc13_ = _loc7_ + cos(_loc15_) * param3;
            _loc14_ = _loc8_ + sin(_loc15_) * param3;
            this.circle_anchrV[_loc16_] = new Vector3D(_loc13_,0,_loc14_);
            _loc16_++;
         }
         this.updateBoundCircle = true;
         return _loc6_;
      }
      
      public function clearBoundCircle() : void
      {
         var _loc1_:Graphics = null;
         this.updateBoundCircle = false;
         _loc1_ = this.boundaryCircle_spr.graphics;
         _loc1_.clear();
      }
      
      private function drawBoundCircle(param1:Cam3D) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Number = NaN;
         var _loc7_:Vector3D = null;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:Graphics = null;
         if(this.updateBoundCircle)
         {
            this.updateBoundCircle = false;
            _loc2_ = new Array();
            _loc3_ = new Array();
            _loc4_ = new Array();
            _loc5_ = new Array();
            _loc6_ = ViewPort.d;
            _loc7_ = param1.transform_vtx(this.circle_anchrV[0],_loc6_);
            _loc8_ = _loc6_ / (_loc6_ + _loc7_.z);
            _loc2_[0] = ViewPort.x0 + _loc7_.x * _loc8_;
            _loc3_[0] = ViewPort.y0 - _loc7_.y * _loc8_;
            _loc9_ = 1;
            while(_loc9_ <= 8)
            {
               _loc7_ = param1.transform_vtx(this.circle_anchrV[_loc9_],_loc6_);
               _loc8_ = _loc6_ / (_loc6_ + _loc7_.z);
               _loc2_[_loc9_] = ViewPort.x0 + _loc7_.x * _loc8_;
               _loc3_[_loc9_] = ViewPort.y0 - _loc7_.y * _loc8_;
               _loc7_ = param1.transform_vtx(this.circle_ctrlV[_loc9_],_loc6_);
               _loc8_ = _loc6_ / (_loc6_ + _loc7_.z);
               _loc4_[_loc9_] = ViewPort.x0 + _loc7_.x * _loc8_;
               _loc5_[_loc9_] = ViewPort.y0 - _loc7_.y * _loc8_;
               _loc9_++;
            }
            _loc10_ = this.boundaryCircle_spr.graphics;
            _loc10_.clear();
            _loc10_.moveTo(_loc2_[0],_loc3_[0]);
            _loc10_.beginFill(this.circleClr,0.3);
            _loc10_.lineStyle(1,this.circleClr);
            _loc9_ = 1;
            while(_loc9_ <= 8)
            {
               _loc10_.curveTo(_loc4_[_loc9_],_loc5_[_loc9_],_loc2_[_loc9_],_loc3_[_loc9_]);
               _loc9_++;
            }
         }
      }
      
      public function positionAllowed(param1:Number, param2:Number, param3:Number, param4:GardenItem = null, param5:Plant = null) : Boolean
      {
         var _loc11_:Plant = null;
         var _loc12_:PlantLoader = null;
         var _loc13_:GardenItem = null;
         if(!isWithinBounds(param1,param2,param3))
         {
            return false;
         }
         var _loc6_:Number = 5 - param1;
         var _loc7_:Number = 505 - param2;
         var _loc8_:Number = _loc6_ * _loc6_ + _loc7_ * _loc7_;
         var _loc9_:Number = 94 + param3;
         var _loc10_:Number = _loc9_ * _loc9_;
         if(_loc8_ < _loc10_)
         {
            return false;
         }
         for each(_loc11_ in this.plants)
         {
            if(_loc11_ != param5 && _loc11_.clashCheck(param1,param2,param3))
            {
               return false;
            }
         }
         for each(_loc12_ in this.plantLoaders)
         {
            if(_loc12_.loadStatus != 2 && _loc12_.clashCheck(param1,param2,param3))
            {
               return false;
            }
         }
         for each(_loc13_ in this.gardenItems)
         {
            if(_loc13_ != param4 && _loc13_.clashCheck(param1,param2,param3))
            {
               return false;
            }
         }
         return true;
      }
      
      public function validateItemPosition(param1:GardenItem) : Boolean
      {
         if(this.positionAllowed(param1.x,param1.z,param1.r,param1))
         {
            return true;
         }
         return false;
      }
      
      public function validatePlantPosition(param1:Plant_nonperishable) : Boolean
      {
         if(this.positionAllowed(param1.x,param1.z,param1.r,null,param1))
         {
            return true;
         }
         return false;
      }
      
      override public function isForbidden(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:NoGoArea = null;
         for each(_loc3_ in noGos)
         {
            if(_loc3_.isWithin(param1,param2))
            {
               return true;
            }
         }
         return false;
      }
      
      override protected function setColour() : void
      {
         var _loc1_:ColorTransform = new ColorTransform(1,1,1,1,r,g,b,0);
         this.nest_spr.transform.colorTransform = _loc1_;
         doors[1].d_o.transform.colorTransform = _loc1_;
      }
      
      override public function setDimness(param1:int) : void
      {
      }
      
      override public function render(param1:Cam3D, param2:Number = 1) : void
      {
         super.render(param1,param2);
         this.drawBoundCircle(param1);
      }
   }
}

