package com.binweevils.engine3D.visuals.creatures.weevils
{
   import assetsWeevil.*;
   import com.binweevils.Bin;
   import com.binweevils.BinEvents;
   import com.binweevils.CustomEvent;
   import com.binweevils.EventManager;
   import com.binweevils.engine3D.*;
   import com.binweevils.engine3D.visuals.*;
   import com.binweevils.engine3D.visuals.creatures.Mouth;
   import com.binweevils.engine3D.visuals.creatures.pets.Pet;
   import com.binweevils.engine3D.visuals.creatures.weevils.behaviours.Behaviour;
   import com.binweevils.engine3D.visuals.creatures.weevils.behaviours.WeevilBehaviours;
   import com.binweevils.multiplayerGames.BigGameSlot;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class Weevil extends Object3D
   {
      
      private var _id:int;
      
      private var _name:String;
      
      public var mine:Boolean;
      
      private var _defObj:Object;
      
      private var _celeb:Boolean;
      
      private var assets_spr:Sprite;
      
      public var apparentScale:Number;
      
      public var baseScale:Number = 1;
      
      private var viewAngleY:Number;
      
      private var body_mc:MovieClip;
      
      private var headShape_mc:MovieClip;
      
      private var prob_mc:MovieClip;
      
      private var lid1_mc:MovieClip;
      
      private var lid2_mc:MovieClip;
      
      private var iris1_mc:MovieClip;
      
      private var iris2_mc:MovieClip;
      
      public var backHeight:Number;
      
      public var y0:Number;
      
      private var hatY:*;
      
      private var hatZ:Number;
      
      public var apparel:Array;
      
      private var mugShot_spr:Sprite;
      
      public var creature:Composite;
      
      public var tumble:Number;
      
      public var shadow_mc:MovieClip;
      
      public var winnerCup_mc:MovieClip;
      
      private var pet_holder:Composite;
      
      public var pet:Pet;
      
      public var body:PreRend3D;
      
      public var head:Head;
      
      public var mouth:Mouth;
      
      public var legs:Array;
      
      public var antennae:Array;
      
      private var crntHat:PreRend3D;
      
      private var speechBubble:SpeechBubble;
      
      private var speaking:Boolean;
      
      private var thoughtBubble:ThoughtBubble;
      
      private var thinking:Boolean;
      
      private var behaviours:Array;
      
      private var actions:Array;
      
      private var specialMoves:Array;
      
      public var nonStandardPose:Boolean;
      
      public var pose:int;
      
      public var walking:Boolean;
      
      private var exitDoor:Door;
      
      private var exitedDoorID:int;
      
      private var destLocID:int;
      
      private var destDoorID:int;
      
      private var doorForMasking:Door;
      
      public var masked:Boolean;
      
      private var _unmaskOnArrival:Boolean;
      
      private var _enteringLoc:Boolean;
      
      private var _justWonRace:Boolean;
      
      private var _gamePointsEarned:int;
      
      private var furnClickedOn_mc:MovieClip;
      
      private var gameSlot:GameSlot;
      
      private var bigGameSlot:BigGameSlot;
      
      private var teleporter:Teleporter;
      
      private var spinner:Spinner;
      
      private var destExtUIDataObj:Object;
      
      private var moveList:Array;
      
      public var kart:Kart;
      
      public var bin:Bin;
      
      public var crntLoc:Loc;
      
      public var crntLocID:int;
      
      public var inNest:Boolean;
      
      public var sex:String;
      
      public var crntBoyGirlCompID:int;
      
      public function Weevil(param1:int, param2:String, param3:Element, param4:SpeechBubble, param5:MovieClip, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number = 0)
      {
         super(param3,param6,param7,param8,param9,param10);
         this.baseScale = param9;
         this.speechBubble = param4;
         this.winnerCup_mc = param5;
         this._id = param1;
         this._name = param2;
         this.assets_spr = Sprite(Sprite(d_o).getChildAt(0));
         this.speechBubble.d_o.mouseEnabled = false;
         this.speechBubble.d_o.mouseChildren = false;
         this.speechBubble.d_o.visible = false;
         container_spr.addChild(this.speechBubble.d_o);
         this.behaviours = new Array();
         this.actions = new Array();
         this.specialMoves = new Array();
         this.moveList = new Array();
         this.apparel = new Array();
         this.tumble = 0;
         d_o = container_spr;
         redraw = true;
      }
      
      private function addThoughtBubble() : void
      {
         var _loc1_:MovieClip = new WeevilThoughtBubble_mc();
         this.thoughtBubble = new ThoughtBubble(_loc1_,0,450,130,this.baseScale);
         container_spr.addChild(this.thoughtBubble.d_o);
         _loc1_.addEventListener("thoughtFinished",this.hideThoughtBubble);
      }
      
      public function loadApparel(param1:uint, param2:String = null) : void
      {
         if(param1 > 0)
         {
            new ApparelLoader(this,param1,param2);
         }
      }
      
      public function apparelLoaded(param1:MovieClip, param2:int) : void
      {
         var _loc3_:PreRend3D = null;
         var _loc7_:* = undefined;
         if(this.crntHat != null)
         {
            this.head.removeElement(this.crntHat);
         }
         var _loc4_:int = param1.totalFrames;
         var _loc5_:int = _loc4_ / 11;
         var _loc6_:int = 36 / (_loc5_ - 1);
         _loc3_ = new Hat(param2,param1,0,this.hatY + 6,this.hatZ,1,0,0,0,50,0,360,_loc5_,_loc6_);
         _loc3_.rotX = -20;
         _loc3_.createHash(true);
         this.head.addElement(_loc3_);
         this.crntHat = _loc3_;
         for(_loc7_ in this.antennae)
         {
            this.head.removeElement(this.antennae[_loc7_]);
         }
         this.apparel[Apparel(_loc3_).category] = _loc3_;
         redraw = true;
      }
      
      public function removeApparel(param1:int) : Boolean
      {
         var _loc2_:* = undefined;
         if(this.apparel[param1] != null)
         {
            switch(param1)
            {
               case 1:
                  this.head.removeElement(this.apparel[param1]);
                  for(_loc2_ in this.antennae)
                  {
                     this.head.addElement(this.antennae[_loc2_]);
                  }
                  this.crntHat = null;
            }
            this.apparel[param1] = null;
            return true;
         }
         return false;
      }
      
      public function thisIsMine() : void
      {
         this.mine = true;
         this.addThoughtBubble();
         EventManager.get_instance().addEventListener(BinEvents.OPEN_CHARACTER_DIALOGUE,this.openCharacterDialogueEventReceived);
      }
      
      private function openCharacterDialogueEventReceived(param1:CustomEvent) : void
      {
         if(this.bin.ctrlsEnabled)
         {
            if(!isNaN(param1.dataObj.xDest))
            {
               this.bin.moveMyWeevil2(param1.dataObj.xDest,param1.dataObj.zDest,param1.dataObj.rDest);
            }
         }
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set defObj(param1:Object) : void
      {
         this._defObj = param1;
      }
      
      public function get defObj() : Object
      {
         return this._defObj;
      }
      
      public function set celeb(param1:Boolean) : void
      {
         this._celeb = param1;
      }
      
      public function get celeb() : Boolean
      {
         return this._celeb;
      }
      
      public function get teleporting() : Boolean
      {
         return this.creature.d_o.alpha < 1;
      }
      
      public function get isGhost() : Boolean
      {
         return this.creature.d_o.alpha < 1;
      }
      
      public function getCreatureDO() : DisplayObject
      {
         return this.creature.d_o;
      }
      
      public function getCreatureY() : Number
      {
         return this.creature.y * _scale;
      }
      
      public function getTargetY() : Number
      {
         return y + (this.creature.y + 75) * _scale;
      }
      
      public function getTotalY() : Number
      {
         var _loc1_:Number = y + this.creature.y * _scale;
         if(_loc1_ < 0)
         {
            _loc1_ = 0;
         }
         return _loc1_;
      }
      
      public function inAir() : Boolean
      {
         var _loc1_:Number = this.creature.y;
         return _loc1_ == 0 || _loc1_ == -20 || _loc1_ == 20 ? false : true;
      }
      
      public function setCrntLoc(param1:Loc) : void
      {
         this.crntLoc = param1;
         if(param1 != null)
         {
            this.crntLocID = this.crntLoc.id;
            if(this.pet != null)
            {
               this.pet.loc = this.crntLoc;
            }
         }
         else
         {
            this.crntLocID = 0;
         }
      }
      
      public function getCrntLoc() : Loc
      {
         return Bin.get_instance().get_crntLoc();
      }
      
      public function setClickHandler() : void
      {
         this.creature.d_o.addEventListener(MouseEvent.MOUSE_DOWN,this.showWeevilInfo);
      }
      
      public function removeClickHandler() : void
      {
         this.creature.d_o.removeEventListener(MouseEvent.MOUSE_DOWN,this.showWeevilInfo);
      }
      
      private function showWeevilInfo(param1:MouseEvent) : void
      {
         this.bin.showWeevilProfile(this.id);
      }
      
      public function set_bin(param1:Bin) : void
      {
         this.bin = param1;
      }
      
      public function set_creature(param1:Composite) : void
      {
         this.creature = param1;
      }
      
      public function set_shadow(param1:MovieClip) : void
      {
         this.shadow_mc = param1;
      }
      
      public function set_petHolder(param1:Composite, param2:Number) : void
      {
         this.pet_holder = param1;
         this.backHeight = param2;
      }
      
      public function petMountWeevil(param1:Pet, param2:Composite) : void
      {
         var _loc3_:String = null;
         this.pet = param1;
         this.pet_holder.addElement(param2);
         if(this.mine)
         {
            this.bin.setPetDef(this.pet,false);
            _loc3_ = "ps:28,x:" + param1.x + ",y:" + param1.y + ",z:" + param1.z + ",r:" + param1.rotY;
            this.bin.setPetState(param1.id,_loc3_,false);
         }
      }
      
      public function petDismount(param1:Composite) : void
      {
         var _loc2_:String = null;
         this.pet_holder.removeElement(param1);
         if(this.mine)
         {
            if(this.bin.inNest)
            {
               this.bin.petDismountInNest(this.pet);
            }
            else
            {
               _loc2_ = "ps:0,x:" + this.pet.x + ",y:" + this.pet.y + ",z:" + this.pet.z + ",r:" + this.pet.rotY;
               this.bin.setPetState(this.pet.id,_loc2_,false);
            }
         }
         this.pet = null;
      }
      
      public function getPetOnBack() : Pet
      {
         return this.pet;
      }
      
      public function set_body(param1:PreRend3D) : void
      {
         this.body = param1;
      }
      
      public function set_y0(param1:int) : void
      {
         switch(param1)
         {
            case 1:
               this.y0 = -22;
               break;
            case 2:
               this.y0 = -31;
               break;
            case 3:
               this.y0 = -22;
               break;
            case 4:
               this.y0 = -30;
         }
      }
      
      public function set_head(param1:Head, param2:Number, param3:Number) : void
      {
         this.head = param1;
         this.hatY = param2;
         this.hatZ = param3;
      }
      
      public function set_mouth(param1:Mouth) : void
      {
         this.mouth = param1;
      }
      
      public function set_legs(param1:Array) : void
      {
         this.legs = param1;
         this.legs[0].setHashMrrs(this.legs[3].h,true);
         this.legs[1].setHashMrrs(this.legs[4].h,true);
         this.legs[2].setHashMrrs(this.legs[5].h,true);
         this.legs[3].setHashMrrs(this.legs[0].h,true);
         this.legs[4].setHashMrrs(this.legs[1].h,true);
         this.legs[5].setHashMrrs(this.legs[2].h,true);
      }
      
      public function getElbowRendrCoords(param1:int) : Point
      {
         var _loc2_:Leg = this.legs[param1];
         var _loc3_:Number = 1;
         if(this.viewAngleY + this.creature.rotY >= 182.5)
         {
            _loc3_ = -1;
         }
         var _loc4_:Point = this.creature.d_o.localToGlobal(new Point(_loc3_ * _loc2_.L_mc.x,_loc2_.L_mc.y));
         _loc4_.x -= 104;
         _loc4_.y -= 12;
         return _loc4_;
      }
      
      public function showLowerLeg(param1:int, param2:Boolean = true) : void
      {
         this.legs[param1].L_mc.visible = param2;
      }
      
      public function set_antennae(param1:Array) : void
      {
         this.antennae = param1;
      }
      
      public function set_clrPointers(param1:MovieClip, param2:MovieClip, param3:MovieClip, param4:MovieClip, param5:MovieClip, param6:MovieClip, param7:MovieClip) : void
      {
         this.body_mc = param1;
         this.headShape_mc = param2;
         this.prob_mc = param3;
         this.lid1_mc = param4;
         this.lid2_mc = param5;
         this.iris1_mc = param6;
         this.iris2_mc = param7;
      }
      
      public function setClr(param1:String, param2:int) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc3_:* = param2 >> 16;
         var _loc4_:* = param2 >> 8 & 0xFF;
         var _loc5_:* = param2 & 0xFF;
         switch(param1)
         {
            case "head":
               _loc3_ -= 255;
               _loc4_ -= 255;
               _loc5_ -= 255;
               this.headShape_mc.transform.colorTransform = new ColorTransform(1,1,1,1,_loc3_,_loc4_,_loc5_,0);
               this.prob_mc.transform.colorTransform = new ColorTransform(1,1,1,1,_loc3_,_loc4_,_loc5_,0);
               this.lid1_mc.transform.colorTransform = new ColorTransform(1,1,1,1,_loc3_,_loc4_,_loc5_,0);
               this.lid2_mc.transform.colorTransform = new ColorTransform(1,1,1,1,_loc3_,_loc4_,_loc5_,0);
               break;
            case "body":
               _loc3_ -= 255;
               _loc4_ -= 255;
               _loc5_ -= 255;
               this.body_mc.transform.colorTransform = new ColorTransform(1,1,1,1,_loc3_,_loc4_,_loc5_,0);
               break;
            case "eyes":
               _loc3_ -= 255;
               _loc4_ -= 255;
               _loc5_ -= 255;
               this.iris1_mc.transform.colorTransform = new ColorTransform(1,1,1,1,_loc3_,_loc4_,_loc5_,0);
               this.iris2_mc.transform.colorTransform = new ColorTransform(1,1,1,1,_loc3_,_loc4_,_loc5_,0);
               break;
            case "antennae":
               for(_loc6_ in this.antennae)
               {
                  this.antennae[_loc6_].setClr(param2);
               }
               break;
            case "legs":
               for(_loc7_ in this.legs)
               {
                  this.legs[_loc7_].setClr(param2);
               }
         }
      }
      
      public function setLids(param1:Boolean) : void
      {
         this.lid1_mc.visible = this.lid2_mc.visible = param1;
      }
      
      public function showBodyAndLegs(param1:Boolean) : void
      {
         var _loc2_:Leg = null;
         this.body.vis = param1;
         for each(_loc2_ in this.legs)
         {
            _loc2_.vis = param1;
         }
      }
      
      public function say(param1:String) : void
      {
         this.speechBubble.setText(param1);
         this.speaking = true;
         if(this.mine)
         {
            this.bin.tellMyPets(param1);
         }
      }
      
      public function hideSpeachBubble() : void
      {
         this.speechBubble.hideIt();
      }
      
      public function showThoughtBubble(param1:String) : void
      {
         this.thinking = true;
         redraw = true;
         this.thoughtBubble.setText(param1);
      }
      
      public function hideThoughtBubble(param1:Event = null) : void
      {
         this.thinking = false;
         this.thoughtBubble.hideIt();
      }
      
      public function setMouth(param1:int) : void
      {
         redraw = true;
         this.mouth.setExpression(param1);
      }
      
      public function setBehaviours(param1:Array) : void
      {
         this.behaviours = param1;
      }
      
      public function dropTray(param1:Boolean = false) : void
      {
         if(this.doingAction(24))
         {
            this.behaviours[24].halt();
            if(this.mine && param1)
            {
               this.bin.sendDropTray(this.behaviours[24].trayID);
            }
         }
      }
      
      public function dropItem() : void
      {
         this.behaviours[25].halt();
      }
      
      public function isWalkAllowed() : Boolean
      {
         var _loc1_:Behaviour = null;
         for each(_loc1_ in this.actions)
         {
            if(_loc1_.id == 10)
            {
               return false;
            }
         }
         return true;
      }
      
      public function resetYuserVar() : void
      {
         this.bin.setUserVar("y","0");
      }
      
      public function twist(param1:Boolean) : void
      {
         var _loc2_:Leg = null;
         if(param1)
         {
            for each(_loc2_ in this.legs)
            {
               _loc2_.setPose(12);
            }
            this.creature.rotY = 20;
         }
         else
         {
            for each(_loc2_ in this.legs)
            {
               _loc2_.setPose(11);
            }
            this.creature.rotY = -20;
         }
         this.creature.y = 0;
         redraw = true;
      }
      
      public function resetArm(param1:String) : void
      {
         if(param1 == "R")
         {
            this.behaviours[18].halt();
         }
         else
         {
            this.behaviours[19].halt();
         }
         redraw = true;
      }
      
      public function walk(param1:Number, param2:Number, param3:Number, param4:Number = 0, param5:Boolean = false, param6:Boolean = false) : void
      {
         this.showBodyAndLegs(true);
         var _loc7_:Loc = this.bin.get_crntLoc();
         if(param4 == 0)
         {
            param4 = _loc7_.get_weevilSpeed();
         }
         _loc7_.interact(x,z);
         if(_loc7_.slippery)
         {
            this.act(21,param1 + "," + param2 + "," + param3 + "," + 1.4 * param4 + "," + param5);
         }
         else
         {
            this.walking = true;
            this.behaviours[0].init([param1,param2,param3,param4,param5,param6]);
         }
      }
      
      public function halt() : void
      {
         if(this.walking)
         {
            this.behaviours[0].halt();
            this.head.rotY = 0;
         }
      }
      
      public function cancelWalk() : void
      {
         if(this.walking)
         {
            this.stopAction(this.behaviours[0]);
            this.walking = false;
         }
      }
      
      public function cancelAllMoves() : void
      {
         this.walking = false;
         this.stopActions();
      }
      
      public function act(param1:int, param2:String = "-1", param3:Boolean = false) : void
      {
         var _loc4_:Behaviour = null;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Behaviour = null;
         var _loc9_:Array = null;
         var _loc10_:Object = null;
         var _loc11_:CustomEvent = null;
         if(WeevilBehaviours.SPECIAL_MOVES.indexOf(param1) != -1)
         {
            this.stopAllSpecialMoves();
         }
         if(param1 > 80)
         {
            switch(param1)
            {
               case 81:
                  this.twist(false);
                  break;
               case 82:
                  this.twist(true);
                  break;
               case 83:
                  this.resetArm("R");
                  break;
               case 84:
                  this.resetArm("L");
            }
         }
         else
         {
            if(param1 != 8)
            {
               this.showBodyAndLegs(true);
            }
            if(param1 == 0)
            {
               this.defaultPose();
            }
            else
            {
               _loc4_ = this.behaviours[param1];
               _loc5_ = _loc4_.type;
               if(_loc5_ == 2 && this.doingActionType(1))
               {
                  _loc6_ = true;
               }
               if(!_loc6_)
               {
                  switch(_loc5_)
                  {
                     case 2:
                        if(this.pose != 6 && this.pose != 7)
                        {
                           if(this.pose != _loc4_.id || param3)
                           {
                              this.pose = _loc4_.id;
                           }
                        }
                        else
                        {
                           _loc4_ = null;
                        }
                        break;
                     case 1:
                        this.pose = 0;
                  }
                  if(_loc4_ != null)
                  {
                     for each(_loc8_ in this.actions)
                     {
                        if(_loc8_ == _loc4_)
                        {
                           _loc7_ = true;
                           break;
                        }
                     }
                     if(!_loc7_ || _loc5_ != 1)
                     {
                        if(param2 != "-1")
                        {
                           _loc9_ = param2.split(",");
                        }
                        _loc4_.init(_loc9_);
                        if(!_loc7_)
                        {
                           this.actions.push(_loc4_);
                           this.actions.sortOn("type",Array.NUMERIC);
                           if(this.mine)
                           {
                              _loc10_ = {
                                 "actionID":param1,
                                 "extraParams":param2
                              };
                              _loc11_ = new CustomEvent(BinEvents.MY_WEEVIL_ACTION,_loc10_);
                              EventManager.get_instance().dispatchEvent(_loc11_);
                           }
                        }
                        if(this.mine)
                        {
                           if(param1 >= 1 && param1 <= 5 || param1 == 7)
                           {
                              this.bin.petsMimicOwner(this.crntLoc,param1);
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function defaultPose() : void
      {
         var _loc1_:Leg = null;
         redraw = true;
         this.walking = false;
         for each(_loc1_ in this.legs)
         {
            _loc1_.setPose(4);
         }
         this.creature.y = 0;
         this.creature.d_o.rotation = 0;
         this.shadow_mc.alpha = 1;
         this.shadow_mc.visible = true;
         this.creature.d_o.visible = this.shadow_mc.visible = true;
         this.creature.d_o.filters = [];
         this.body.d_o.filters = [];
         this.creature.rotY = 0;
         this.tumble = 0;
         this.pose = 0;
         this.kart = null;
         this.showBodyAndLegs(true);
         this.behaviours[24].halt();
         this.behaviours[25].halt();
      }
      
      public function haltVictoryDisplay() : void
      {
         this.behaviours[20].halt();
      }
      
      public function endVictoryDisplay() : void
      {
         if(this.mine)
         {
            this._justWonRace = false;
            this.bin.setUserVar("vict","0");
         }
      }
      
      public function doingAction(param1:int) : Boolean
      {
         var _loc2_:Behaviour = null;
         for each(_loc2_ in this.actions)
         {
            if(_loc2_.id == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function doingActionType(param1:int) : Boolean
      {
         var _loc2_:Behaviour = null;
         for each(_loc2_ in this.actions)
         {
            if(_loc2_.type == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getAction(param1:int) : Behaviour
      {
         if(this.doingAction(param1))
         {
            return this.behaviours[param1];
         }
         return null;
      }
      
      public function stopAction(param1:Behaviour) : void
      {
         var _loc2_:int = int(this.actions.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.actions[_loc3_] == param1)
            {
               this.actions.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function stopActionByID(param1:int) : void
      {
         if(WeevilBehaviours.SPECIAL_MOVES.indexOf(this.id) != -1)
         {
            this.stopSpecialMove(param1);
         }
         var _loc2_:Behaviour = this.behaviours[param1];
         this.stopAction(_loc2_);
      }
      
      public function stopActions() : void
      {
         if(this.mine)
         {
            if(this.doingAction(20))
            {
               this.behaviours[20].halt();
            }
         }
         this.stopAllSpecialMoves();
         this.creature.d_o.filters = [];
         this.actions = [];
      }
      
      private function stopAllSpecialMoves() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Array = WeevilBehaviours.SPECIAL_MOVES;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = int(_loc1_[_loc2_]);
            this.stopSpecialMove(_loc3_);
            _loc2_++;
         }
      }
      
      private function stopSpecialMove(param1:Number) : void
      {
         if(this.doingAction(param1))
         {
            this.behaviours[param1].halt();
         }
      }
      
      public function getDir(param1:Number, param2:Number) : int
      {
         var _loc3_:Number = param1 - x;
         var _loc4_:Number = param2 - z;
         if(_loc3_ == 0 && _loc4_ == 0)
         {
            return int(rotY);
         }
         return int(Math.atan2(-_loc3_,-_loc4_) * toDegr);
      }
      
      public function getDist(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = param1 - x;
         var _loc4_:Number = param2 - z;
         return Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
      }
      
      public function setExitDoor(param1:Door) : void
      {
         this.exitDoor = param1;
      }
      
      public function setDestLoc(param1:int, param2:int) : void
      {
         this.destLocID = param1;
         this.destDoorID = param2;
      }
      
      public function setDestExtUIData(param1:Object) : void
      {
         this.destExtUIDataObj = param1;
      }
      
      public function setGameSlot(param1:GameSlot) : void
      {
         this.gameSlot = param1;
      }
      
      public function setBigGameSlot(param1:BigGameSlot) : void
      {
         this.bigGameSlot = param1;
      }
      
      public function setTeleporter(param1:Teleporter) : void
      {
         this.teleporter = param1;
      }
      
      public function setSpinner(param1:Spinner) : void
      {
         this.spinner = param1;
      }
      
      public function setFurnClickedOn(param1:MovieClip) : void
      {
         this.furnClickedOn_mc = param1;
      }
      
      public function sendMove(param1:Number, param2:Number) : void
      {
         this.bin.moveMyWeevil(param1,param2);
      }
      
      public function queueMove(param1:Number, param2:Number) : void
      {
         this.moveList.push(new Point(param1,param2));
      }
      
      public function clearMoveList() : void
      {
         this.moveList = [];
      }
      
      public function set justWonRace(param1:Boolean) : void
      {
         this._justWonRace = param1;
      }
      
      public function get justWonRace() : Boolean
      {
         return this._justWonRace;
      }
      
      public function set gamePointsEarned(param1:*) : void
      {
         this._gamePointsEarned = param1;
      }
      
      public function get gamePointsEarned() : int
      {
         return this._gamePointsEarned;
      }
      
      public function arrived() : void
      {
         var _loc1_:Event = null;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Point = null;
         this.walking = false;
         this.bin.get_crntLoc().interact(x,z);
         if(this.mine)
         {
            if(this.furnClickedOn_mc != null)
            {
               this.furnClickedOn_mc.rangeCheck(x,z);
               this.furnClickedOn_mc = null;
            }
            this.bin.updateMyPets(x,z);
            if(this.exitDoor != null)
            {
               this.exitedDoorID = this.exitDoor.id;
               this.bin.get_crntLoc().exit(this,this.exitDoor);
               this.setExitDoor(null);
            }
            else if(this.destLocID != 0)
            {
               this.bin.loadLoc(this.destLocID,this.destDoorID);
               this.destLocID = 0;
            }
            else if(this._enteringLoc)
            {
               this.enteringLoc = false;
               if(this._unmaskOnArrival)
               {
                  this.unmaskOnArrival = false;
                  this.mask = null;
               }
               this.bin.enableControls();
            }
            else if(this.destExtUIDataObj != null)
            {
               this.destExtUIDataObj.fromDoorID = this.exitedDoorID;
               this.destExtUIDataObj.fromLocID = this.crntLoc.id;
               this.bin.loadInterface(this.destExtUIDataObj);
            }
            else if(this.gameSlot != null)
            {
               this.bin.loadGame(this.gameSlot);
            }
            else if(this.bigGameSlot != null)
            {
               if(this.bigGameSlot.active)
               {
                  this.bin.loadBigGameLoader(this.bigGameSlot);
               }
               else
               {
                  this.bigGameSlot = null;
               }
            }
            else if(this.teleporter != null)
            {
               if(this.teleporter.inRange(x,z))
               {
                  if(this.teleporter.destLocID == 0)
                  {
                     _loc2_ = this.teleporter.destX + "," + this.teleporter.destY + "," + this.teleporter.destZ;
                     this.bin.myWeevilAct(23,0,_loc2_);
                  }
                  else
                  {
                     _loc2_ = String(this.teleporter.destLocID);
                     this.bin.myWeevilAct(28,0,_loc2_);
                  }
               }
            }
            else if(this.spinner != null)
            {
               _loc3_ = int((1 + Math.random()) * 15);
               this.bin.myWeevilAct(30,0,String(_loc3_));
            }
            if(this.moveList.length > 0)
            {
               _loc4_ = this.moveList.shift();
               this.sendMove(_loc4_.x,_loc4_.y);
            }
            _loc1_ = new Event(BinEvents.WEEVIL_ARRIVED);
            EventManager.get_instance().dispatchEvent(_loc1_);
         }
         else if(this._enteringLoc)
         {
            this.enteringLoc = false;
            if(this._unmaskOnArrival)
            {
               this.unmaskOnArrival = false;
               d_o.mask = null;
               this.mask = null;
            }
         }
      }
      
      public function setDoorForMasking(param1:int) : void
      {
         this.doorForMasking = this.crntLoc.getDoorByID(param1);
         this.mask = null;
      }
      
      public function maskIfNeeded() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Number = NaN;
         if(!this.masked)
         {
            if(this.doorForMasking != null)
            {
               switch(this.crntLocID)
               {
                  case 10:
                  case -10:
                     if(this.inAir() && z < 180 && x > 150)
                     {
                        this.setDoorMask(this.doorForMasking);
                     }
                     break;
                  case 55:
                  case -55:
                     if(z < 85 && x > 115)
                     {
                        this.setDoorMask(this.doorForMasking);
                     }
                     break;
                  case 50:
                  case -50:
                     if(x > 100 || z > 300 || x < -175)
                     {
                        this.setDoorMask(this.doorForMasking);
                     }
                     break;
                  case 5:
                  case -5:
                     if(z > 390)
                     {
                        this.setDoorMask(this.doorForMasking);
                        break;
                     }
                  default:
                     if(x < -171 || x > 171 || z > 371)
                     {
                        this.setDoorMask(this.doorForMasking);
                     }
               }
            }
         }
         else
         {
            switch(this.crntLocID)
            {
               case 55:
               case -55:
                  if(z > 85 || x < 115)
                  {
                     this.mask = null;
                  }
                  break;
               case 50:
               case -50:
                  if(x < 100 && z < 300 && x > -175)
                  {
                     this.mask = null;
                  }
                  break;
               case 5:
               case -5:
                  if(x > -171 && x < 171 && z < 194)
                  {
                     this.mask = null;
                  }
                  break;
               default:
                  if(x > -171 && x < 171 && z < 371)
                  {
                     this.mask = null;
                  }
            }
         }
      }
      
      public function setDoorMask(param1:Door) : void
      {
         if(param1 != null)
         {
            param1.applyMask(d_o);
            this.masked = true;
         }
      }
      
      public function set mask(param1:Sprite) : void
      {
         d_o.mask = param1;
         if(param1 == null)
         {
            this.masked = false;
         }
         else
         {
            this.masked = true;
         }
      }
      
      public function set enteringLoc(param1:Boolean) : void
      {
         this._enteringLoc = param1;
      }
      
      public function set unmaskOnArrival(param1:Boolean) : void
      {
         this._unmaskOnArrival = param1;
      }
      
      public function update(param1:Number = 1) : void
      {
         var _loc2_:Behaviour = null;
         if(this.walking == true)
         {
            redraw = true;
            this.behaviours[0].setPose(param1);
         }
         if(this.actions.length != 0)
         {
            redraw = true;
            for each(_loc2_ in this.actions)
            {
               _loc2_.setPose(param1);
            }
         }
      }
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Vector3D = null;
         var _loc6_:* = undefined;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         if(redraw || param1.mvd)
         {
            redraw = false;
            _loc4_ = ViewPort.d;
            _loc5_ = param1.transform_vtx(p,_loc4_);
            _loc6_ = _loc4_ / (_loc4_ + _loc5_.z);
            _loc7_ = ViewPort.x0 + _loc5_.x * _loc6_;
            if(this.inNest)
            {
               depth = -_loc5_.z + y;
            }
            else
            {
               depth = -_loc5_.z;
            }
            if(depth > _loc4_ || _loc7_ < -260 || _loc7_ > 874)
            {
               d_o.visible = false;
            }
            else
            {
               d_o.x = _loc7_;
               d_o.y = ViewPort.y0 - _loc5_.y * _loc6_;
               this.assets_spr.scaleX = this.assets_spr.scaleY = this.apparentScale = _loc6_ * _scale;
               d_o.visible = true;
               _loc8_ = p.x - param1.x;
               _loc9_ = p.y - param1.y;
               _loc10_ = p.z - param1.z;
               _loc11_ = Math.sqrt(_loc8_ * _loc8_ + _loc10_ * _loc10_);
               this.viewAngleY = -toDegr * atan2(_loc8_,_loc10_) + rotY;
               if(this.viewAngleY < 0)
               {
                  this.viewAngleY += 360;
               }
               else if(this.viewAngleY > 360)
               {
                  this.viewAngleY -= 360;
               }
               this.viewAngleY = 360 - this.viewAngleY;
               _loc12_ = toDegr * atan2(-_loc9_,_loc11_);
               visualElm.setViewAngle(_loc12_,this.viewAngleY);
               this.speechBubble.set_p_ratio(_loc6_ * _scale);
               this.speechBubble.setViewAngle(_loc12_,this.viewAngleY);
               if(this.thinking)
               {
                  this.thoughtBubble.set_p_ratio(_loc6_ * _scale);
                  this.thoughtBubble.setViewAngle(_loc12_,this.viewAngleY);
               }
               if(this.creature.y != 0)
               {
                  _loc14_ = -this.creature.y * (_loc11_ / (_loc4_ + _loc5_.z));
                  this.creature.d_o.y = _loc14_;
                  this.speechBubble.d_o.y += _loc14_ * _loc6_ * _scale;
                  this.shadow_mc.alpha = 1 + 0.002 * _loc14_;
               }
               else
               {
                  this.creature.d_o.y = 0;
               }
               if(this.tumble != 0)
               {
                  this.creature.d_o.rotation = this.tumble;
               }
               _loc13_ = toDegr * atan2(_loc5_.x,_loc5_.z + _loc4_ + 100);
               _loc13_ = sin(atan2(-_loc9_,_loc11_)) * _loc13_;
               this.assets_spr.rotation = _loc13_;
            }
         }
      }
      
      public function set mugShot(param1:Sprite) : void
      {
         this.mugShot_spr = param1;
      }
      
      public function get mugShot() : Sprite
      {
         return this.mugShot_spr;
      }
   }
}

