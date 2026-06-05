package com.binweevils.engine3D.visuals
{
   import com.binweevils.BinEvents;
   import com.binweevils.EventManager;
   import com.binweevils.utilities.URLhandler;
   import com.binweevils.utilities.Utils;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.net.*;
   import flash.utils.Timer;
   
   public class LocFixedCam extends Loc
   {
      
      private var v:Array;
      
      private var vf1:Array;
      
      private var vf2:Array;
      
      internal var xMin:*;
      
      internal var xMax:*;
      
      internal var yMin:*;
      
      internal var yMax:*;
      
      internal var zMin:*;
      
      internal var zMax:Number;
      
      private var bg_spr:Sprite;
      
      private var floorClickArea:InteractiveObject;
      
      private var objectList:XMLList;
      
      private var targetList:XMLList;
      
      private var characterList:XMLList;
      
      private var doorsContainer_spr:Sprite;
      
      protected var animTimer:Timer;
      
      private var karts:Array;
      
      private var dialogueManagerLoadRequired:Boolean;
      
      public function LocFixedCam(param1:Sprite, param2:int, param3:String, param4:String, param5:Array, param6:Object, param7:Number, param8:Number, param9:Number, param10:Number, param11:Boolean = false, param12:String = null)
      {
         super(param1,param2,2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         anims = new Array();
         this.karts = new Array();
      }
      
      override public function getClickable() : InteractiveObject
      {
         return this.floorClickArea;
      }
      
      override protected function createWalkMasks() : void
      {
         var $noGo:XML = null;
         try
         {
            for each($noGo in walkMaskList)
            {
               walkMasks.push(MovieClip(this.bg_spr)[$noGo.attribute("name")]);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      override protected function createDoors() : void
      {
         var _loc1_:XML = null;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
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
         for each(_loc1_ in doorList)
         {
            _loc2_ = int(_loc1_.attribute("id"));
            _loc3_ = MovieClip(this.bg_spr.getChildByName("door" + _loc2_ + "_mc"));
            _loc4_ = 0;
            if(_loc1_.attribute("toLoc") == undefined)
            {
               _loc5_ = Utils.stringToObject(_loc1_.attribute("extUIData"));
            }
            else
            {
               _loc4_ = int(_loc1_.attribute("toLoc"));
            }
            _loc6_ = int(_loc1_.attribute("toDoor"));
            _loc7_ = Number(_loc1_.attribute("x1"));
            _loc8_ = Number(_loc1_.attribute("z1"));
            _loc9_ = Number(_loc1_.attribute("x2"));
            _loc10_ = Number(_loc1_.attribute("z2"));
            _loc11_ = Number(_loc1_.attribute("y"));
            _loc12_ = Number(_loc1_.attribute("y2"));
            _loc13_ = Number(_loc1_.attribute("entryDir"));
            _loc14_ = false;
            if(_loc1_.attribute("tycoonOnly") == "true")
            {
               _loc14_ = true;
            }
            _loc15_ = _loc1_.attribute("nonTyconOverlay");
            doors[_loc2_] = new Door(this,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc13_,_loc11_,_loc12_,"fixedCam",_loc14_,_loc15_);
         }
      }
      
      protected function createCtas() : void
      {
         var _loc1_:XML = null;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:* = null;
         var _loc8_:InteractiveObject = null;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         for each(_loc1_ in ctaList)
         {
            _loc2_ = int(_loc1_.attribute("id"));
            _loc3_ = Number(_loc1_.attribute("x"));
            _loc4_ = Number(_loc1_.attribute("z"));
            if(String(_loc1_.attribute("x2")) != "")
            {
               _loc5_ = Number(_loc1_.attribute("x2"));
               _loc6_ = Number(_loc1_.attribute("z2"));
            }
            _loc7_ = _loc1_.attribute("clickTarget");
            if(_loc7_ == null || _loc7_ == "")
            {
               _loc7_ = "cta" + _loc2_ + "_btn";
            }
            _loc8_ = InteractiveObject(this.bg_spr.getChildByName(_loc7_));
            _loc9_ = null;
            _loc10_ = _loc1_.attribute("popupGameID");
            if(_loc10_.length == 0)
            {
               _loc9_ = Utils.stringToObject(_loc1_.attribute("extUIData"));
            }
            else
            {
               _loc11_ = _loc1_.attribute("asVersion");
            }
            ctas[_loc2_] = new Cta(this,_loc3_,_loc4_,_loc8_,_loc5_,_loc6_,_loc9_,_loc10_,_loc11_);
         }
      }
      
      protected function createInteractives() : void
      {
         var _loc1_:XML = null;
         var _loc2_:Array = null;
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Rectangle = null;
         var _loc7_:String = null;
         for each(_loc1_ in interactiveList)
         {
            _loc2_ = _loc1_.attribute("path").split(".");
            _loc3_ = MovieClip(this.bg_spr.getChildByName(_loc2_[0]));
            _loc4_ = 1;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = MovieClip(_loc3_.getChildByName(_loc2_[_loc4_]));
               _loc4_++;
            }
            _loc5_ = _loc1_.attribute("actRect").split(",");
            _loc6_ = new Rectangle(_loc5_[0],_loc5_[1],_loc5_[2],_loc5_[3]);
            _loc7_ = _loc1_.attribute("type");
            interactives.push(new Interactive(_loc3_,_loc6_,_loc7_));
         }
      }
      
      protected function createAnims() : void
      {
         var _loc1_:XML = null;
         var _loc2_:Array = null;
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         this._trace("**createAnims**");
         for each(_loc1_ in animList)
         {
            _loc2_ = _loc1_.attribute("path").split(".");
            _loc3_ = MovieClip(this.bg_spr.getChildByName(_loc2_[0]));
            _loc4_ = 1;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = MovieClip(_loc3_.getChildByName(_loc2_[_loc4_]));
               _loc4_++;
            }
            anims.push(_loc3_);
         }
         this.resetAnimTimer();
      }
      
      protected function setUpTimeTrialBtn() : void
      {
         var _loc1_:XML = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Door = null;
         var _loc6_:SimpleButton = null;
         for each(_loc1_ in timeTrialList)
         {
            this._trace("$timeTrial_xml=" + _loc1_);
            _loc2_ = _loc1_.attribute("gamePath");
            _loc3_ = _loc1_.attribute("track");
            _loc4_ = int(_loc1_.attribute("doorID"));
            _loc5_ = doors[_loc4_];
            _loc6_ = SimpleButton(this.bg_spr.getChildByName("timeTrials_btn"));
            this._trace("$clickable_btn=" + _loc6_);
            new TimeTrial(this,_loc2_,_loc3_,_loc5_,_loc6_);
         }
      }
      
      private function setupKartHatches() : void
      {
         var _loc1_:Kart = null;
         var _loc2_:Sprite = null;
         for each(_loc1_ in this.karts)
         {
            this._trace("HATCH = hatch" + _loc1_.slotID + "_spr");
            _loc2_ = Sprite(this.bg_spr.getChildByName("hatch" + _loc1_.slotID + "_spr"));
            _loc1_.setHatch(_loc2_);
         }
      }
      
      public function setObjects(param1:XMLList) : void
      {
         this.objectList = param1;
      }
      
      private function setupObjects() : void
      {
         var _loc1_:XML = null;
         var _loc2_:String = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:FixedAsset = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:GameSlotFixedCam = null;
         for each(_loc1_ in this.objectList)
         {
            _loc2_ = _loc1_.attribute("name");
            this._trace("$objectName=" + _loc2_);
            _loc3_ = this.bg_spr.getChildByName(_loc2_);
            _loc4_ = Number(_loc1_.attribute("x"));
            _loc5_ = Number(_loc1_.attribute("y"));
            _loc6_ = Number(_loc1_.attribute("z"));
            _loc7_ = new FixedAsset(_loc3_,_loc4_,_loc5_,_loc6_);
            this.manageAsset(_loc7_);
            if(_loc1_.attribute("type") == "gameSlot")
            {
               this._trace("This object is a gameSlot");
               _loc8_ = _loc1_.attribute("lbl");
               _loc9_ = _loc1_.attribute("gamePath");
               _loc10_ = _loc1_.attribute("slot");
               _loc11_ = _loc1_.attribute("arrivalPoints");
               _loc12_ = _loc1_.attribute("playerPositions");
               _loc13_ = new GameSlotFixedCam(_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,Sprite(_loc3_));
               _loc13_.setLoc(this);
            }
         }
      }
      
      private function _trace(param1:*) : *
      {
      }
      
      private function setupGUIs() : void
      {
         var GUI_xml:* = undefined;
         var myURL:String = null;
         var $ldr:Loader = null;
         var loaded_GUI:* = undefined;
         var GUIName:String = null;
         var $object_d_o:DisplayObject = null;
         this._trace("setupGUIs");
         for each(GUI_xml in GUI_list)
         {
            myURL = GUI_xml.attribute("url");
            this._trace("myURL==\'\': " + [myURL,myURL == ""]);
            if(myURL != "")
            {
               this._trace("attempting load");
               $ldr = new Loader();
               loaded_GUI = function(param1:Event):*
               {
                  _trace("loaded_GUI: " + GUI_xml.attribute("name"));
                  var _loc2_:* = param1.target.content;
                  setupGUI(_loc2_,GUI_xml);
               };
               URLhandler.loadFromCDN($ldr,myURL,loaded_GUI);
            }
            else
            {
               this._trace("converting existing GUI to correct layer");
               GUIName = GUI_xml.@name;
               $object_d_o = this.bg_spr.getChildByName(GUIName);
               this.setupGUI($object_d_o,GUI_xml);
            }
         }
      }
      
      private function setupGUI(param1:DisplayObject, param2:XML) : *
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param1 != null)
         {
            GUI_spr.addChild(param1);
            _loc3_ = param2.attribute("x");
            _loc4_ = param2.attribute("y");
            if(_loc3_ != "")
            {
               param1.x = Number(_loc3_);
            }
            if(_loc4_ != "")
            {
               param1.x = Number(_loc4_);
            }
         }
      }
      
      public function setTargets(param1:XMLList) : void
      {
         this.targetList = param1;
      }
      
      private function setupTargets() : void
      {
         var _loc1_:XML = null;
         var _loc2_:String = null;
         var _loc3_:MovieClip = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:* = undefined;
         this._trace("**setupTargets**");
         for each(_loc1_ in this.targetList)
         {
            _loc2_ = _loc1_.attribute("name");
            this._trace("$targetName=" + _loc2_);
            _loc3_ = MovieClip(this.bg_spr.getChildByName(_loc2_));
            _loc4_ = Number(_loc1_.attribute("x"));
            _loc5_ = Number(_loc1_.attribute("y"));
            _loc6_ = Number(_loc1_.attribute("z"));
            _loc7_ = int(_loc1_.attribute("rad"));
            _loc8_ = int(_loc1_.attribute("ori"));
            _loc9_ = _loc1_.attribute("dynam") == "yes" ? true : false;
            _loc10_ = _loc1_.attribute("indestructible") == "yes" ? true : false;
            _loc11_ = _loc1_.attribute("useShape") == "yes" ? true : false;
            _loc12_ = _loc1_.attribute("autoPlay") == "no" ? false : true;
            _loc13_ = _loc1_.attribute("useChildren") == "yes" ? true : false;
            if(!_loc13_)
            {
               _loc14_ = new ProjectileTarget(this,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_);
            }
            else
            {
               _loc14_ = new ProjectileTargetUseChildren(this,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_);
            }
            this.manageAsset(_loc14_);
         }
      }
      
      public function addTarget(param1:MovieClip, param2:Number, param3:Number, param4:Number, param5:int, param6:int, param7:Boolean, param8:Boolean, param9:Boolean, param10:Boolean) : void
      {
         var _loc11_:ProjectileTarget = new ProjectileTarget(this,param1,param2,param3,param4,param5,param6,param7,param8,param9,param10);
         this.manageAsset(_loc11_);
         _loc11_.redraw = true;
      }
      
      public function setCharacters(param1:XMLList) : void
      {
         this.characterList = param1;
         if(this.characterList.length() > 0)
         {
            this.dialogueManagerLoadRequired = true;
         }
      }
      
      private function loadDialogueManager() : void
      {
         if(bin.UI.loadDialogueManager() == 2)
         {
            this.dialogueManagerLoaded();
         }
         else
         {
            EventManager.get_instance().addEventListener(BinEvents.DIALOG_MANAGER_LOADED,this.dialogueManagerLoaded);
         }
      }
      
      private function dialogueManagerLoaded(param1:Event = null) : void
      {
         EventManager.get_instance().removeEventListener(BinEvents.DIALOG_MANAGER_LOADED,this.dialogueManagerLoaded);
         this.dialogueManagerLoadRequired = false;
         this.loadManager();
      }
      
      private function setupCharacters() : void
      {
         var _loc1_:XML = null;
         var _loc2_:String = null;
         var _loc3_:MovieClip = null;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:CharacterInteractive = null;
         this._trace("**setupCharacters**");
         for each(_loc1_ in this.characterList)
         {
            _loc2_ = _loc1_.attribute("name");
            this._trace("$characterName=" + _loc2_);
            _loc3_ = MovieClip(this.bg_spr.getChildByName(_loc2_));
            _loc4_ = _loc1_.attribute("dialoguePath");
            _loc5_ = Number(_loc1_.attribute("x"));
            _loc6_ = Number(_loc1_.attribute("y"));
            _loc7_ = Number(_loc1_.attribute("z"));
            _loc8_ = int(_loc1_.attribute("xDest"));
            _loc9_ = int(_loc1_.attribute("zDest"));
            _loc10_ = int(_loc1_.attribute("rDest"));
            _loc11_ = int(_loc1_.attribute("bubbleX"));
            _loc12_ = int(_loc1_.attribute("bubbleY"));
            _loc13_ = new CharacterInteractive(_loc3_,_loc2_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_);
            this.manageAsset(_loc13_);
         }
      }
      
      public function createVisual(param1:LoaderInfo, param2:XML) : Visual
      {
         var _loc3_:MovieClip = MovieClip(param1.content);
         var _loc4_:Number = Number(param2.attribute("x"));
         var _loc5_:Number = Number(param2.attribute("y"));
         var _loc6_:Number = Number(param2.attribute("z"));
         return new FixedAsset(_loc3_,_loc4_,_loc5_,_loc6_);
      }
      
      override public function manageAsset(param1:Visual, param2:IItemLoader = null) : void
      {
         var _loc4_:ProjectileTarget = null;
         var _loc5_:Kart = null;
         this._trace("manageAsset");
         var _loc3_:String = param1.type;
         switch(_loc3_)
         {
            case "roomBG":
               this.bg_spr = Sprite(param1.d_o);
               if(this.bg_spr.getChildByName("floorClickArea_btn") != null)
               {
                  SimpleButton(this.bg_spr.getChildByName("floorClickArea_btn")).useHandCursor = false;
                  this.floorClickArea = InteractiveObject(this.bg_spr.getChildByName("floorClickArea_btn"));
               }
               else
               {
                  this.floorClickArea = this.bg_spr;
               }
               loc_spr.addChildAt(this.bg_spr,0);
               if(roomEvents)
               {
                  roomEventHandlerFn = MovieClip(this.bg_spr).roomEventReceived;
               }
               break;
            case "teleporter":
               visuals.push(param1);
               content_spr.addChild(param1.d_o);
               Teleporter(param1).setLoc(this);
               break;
            case "target":
               visuals.push(param1);
               content_spr.addChild(param1.d_o);
               _loc4_ = ProjectileTarget(param1);
               if(_loc4_.dynam)
               {
                  dynams.push(_loc4_);
               }
               targets.push(_loc4_);
               break;
            default:
               visuals.push(param1);
               content_spr.addChild(param1.d_o);
               if(_loc3_ == "gameSlot")
               {
                  GameSlot(param1).setLoc(this);
               }
               if(_loc3_ == "kart")
               {
                  _loc5_ = Kart(param1);
                  this.karts.push(_loc5_);
                  dynams.push(_loc5_);
                  _loc5_.setLoc(this);
               }
         }
      }
      
      override public function driveOff(param1:int) : void
      {
         var _loc2_:Kart = null;
         for each(_loc2_ in this.karts)
         {
            if(_loc2_.numPlayers == param1)
            {
               _loc2_.driveOff();
            }
         }
      }
      
      override public function getKartByID(param1:int) : Kart
      {
         var _loc2_:Kart = null;
         for each(_loc2_ in this.karts)
         {
            if(_loc2_.slotID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      override public function getKartByCoords(param1:Number, param2:Number) : Kart
      {
         var _loc3_:Kart = null;
         for each(_loc3_ in this.karts)
         {
            if(_loc3_.inArrivalZone(param1,param2))
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      override public function resetKarts(param1:int) : void
      {
         var _loc2_:Kart = null;
         for each(_loc2_ in this.karts)
         {
            if(_loc2_.numPlayers == param1)
            {
               _loc2_.reset();
            }
         }
      }
      
      private function quickResetKarts() : void
      {
         var _loc1_:Kart = null;
         for each(_loc1_ in this.karts)
         {
            _loc1_.quickReset();
         }
      }
      
      protected function resetAnimTimer() : void
      {
         this._trace("anims.length=" + anims.length);
         if(anims.length > 0)
         {
            if(this.animTimer != null)
            {
               this.animTimer.stop();
               this.animTimer.removeEventListener("timer",this.playAnim);
            }
            this.animTimer = new Timer(8000 * Math.random() + 4000,1);
            this.animTimer.addEventListener("timer",this.playAnim);
            this.animTimer.start();
         }
      }
      
      public function playAnim(param1:TimerEvent) : void
      {
         var _loc3_:int = 0;
         this._trace("**playAnim**");
         var _loc2_:int = int(anims.length);
         if(anims.length > 0)
         {
            _loc3_ = Utils.getRndInt(0,anims.length - 1);
            this._trace("$n=" + _loc3_);
            this._trace("anims[$n]=" + anims[_loc3_]);
            anims[_loc3_].play();
            this.resetAnimTimer();
         }
      }
      
      override public function displayIt(param1:Sprite) : void
      {
         super.displayIt(param1);
         this.resetAnimTimer();
      }
      
      override public function hideIt() : void
      {
         super.hideIt();
         if(this.animTimer != null)
         {
            this.animTimer.stop();
            this.animTimer.removeEventListener("timer",this.playAnim);
         }
      }
      
      override public function loadManager() : void
      {
         if(crntAsset < assetLoaders.length)
         {
            ++crntAsset;
            assetLoaders[crntAsset - 1].loadAsset(this);
         }
         else if(this.dialogueManagerLoadRequired)
         {
            this.loadDialogueManager();
         }
         else if(inventoryLoadRequired)
         {
            loadInventory();
         }
         else
         {
            if(!initialised)
            {
               initialised = true;
               this.createInteractives();
               this.createDoors();
               this.createAnims();
               this.createCtas();
               this.setupObjects();
               this.setupGUIs();
               this.setupTargets();
               this.setupCharacters();
               createNoGoAreas();
               this.createWalkMasks();
               this.setupKartHatches();
               this.setUpTimeTrialBtn();
            }
            this.loadComplete();
         }
      }
      
      override protected function loadComplete() : void
      {
         super.loadComplete();
         this.quickResetKarts();
      }
   }
}

