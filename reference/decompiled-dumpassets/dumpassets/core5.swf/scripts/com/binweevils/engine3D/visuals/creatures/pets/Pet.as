package com.binweevils.engine3D.visuals.creatures.pets
{
   import assetsWeevil.*;
   import com.binweevils.Bin;
   import com.binweevils.BinEvents;
   import com.binweevils.CustomEvent;
   import com.binweevils.EventManager;
   import com.binweevils.engine3D.*;
   import com.binweevils.engine3D.visuals.*;
   import com.binweevils.engine3D.visuals.creatures.Mouth;
   import com.binweevils.engine3D.visuals.creatures.pets.behaviours.Ball;
   import com.binweevils.engine3D.visuals.creatures.pets.behaviours.Behaviour;
   import com.binweevils.engine3D.visuals.creatures.pets.behaviours.Pant;
   import com.binweevils.engine3D.visuals.creatures.pets.behaviours.PetBehaviours;
   import com.binweevils.engine3D.visuals.creatures.pets.behaviours.PetThoughts;
   import com.binweevils.engine3D.visuals.creatures.weevils.Weevil;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.utils.Timer;
   
   public class Pet extends Object3D implements IPet
   {
      
      public static var SKILLS_UPDATED_EVENT:String = "SKILLS_UPDATED_EVENT";
      
      private var _id:int;
      
      private var _name:String;
      
      private var _nameHash:String;
      
      public var owner:Weevil;
      
      private var _defObj:Object;
      
      public var mine:Boolean;
      
      public var bedID:int;
      
      public var bowlID:int;
      
      public var bin:Bin;
      
      private var brain:Brain;
      
      public var pet_cmp:Composite;
      
      public var creature:Composite;
      
      private var body_mc:MovieClip;
      
      public var arm1:*;
      
      public var arm2:Arm;
      
      public var eye1:*;
      
      public var eye2:Eye;
      
      private var eyeExt:int;
      
      private var mouth:Mouth;
      
      private var crntExpression:int;
      
      public var crntPose:int;
      
      private var shadow_mc:MovieClip;
      
      private var zz_mc:MovieClip;
      
      private var thoughtBubble_mc:MovieClip;
      
      private var thought_mc:MovieClip;
      
      private var hideThoughtBubbleTimer:Timer;
      
      public var foodBowl:MovieClip;
      
      private var ballsSwapped:Boolean;
      
      private var alternativeBallClass:Class;
      
      private var ballColours:Array;
      
      public var balls:Array;
      
      public var nearestBalls:Array;
      
      public var ballsCreated:int;
      
      public var lastBallThrownByOwnerID:int;
      
      public var g:Number;
      
      public var behaviours:Array;
      
      public var actions:Array;
      
      public var pant:Behaviour;
      
      public var panting:Boolean;
      
      public var pose:int;
      
      public var sleeping:Boolean;
      
      public var sitting:Boolean;
      
      private var thinking:Boolean;
      
      public var ridingOwner:Boolean;
      
      public var ignoreCollisions:Boolean;
      
      private var strokeTimer:Timer;
      
      private var strokeTimerCount:int;
      
      private var mouseOnPet:Boolean;
      
      public var activityLvl:Number;
      
      public var y0:Number;
      
      private var _loc:Loc;
      
      private var exitDoor:Door;
      
      private var destLoc:Loc;
      
      private var entryDoor:Door;
      
      private var doorForMasking:Door;
      
      private var masked:Boolean;
      
      private var _isRental:Boolean = false;
      
      public var events:EventDispatcher;
      
      public var juggleAppeal:Number;
      
      public function Pet(param1:int, param2:String, param3:Weevil, param4:Element, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Boolean)
      {
         super(param4,param5,param6,param7,param8,param9);
         this._id = param1;
         this._name = param2;
         this.owner = param3;
         this.bin = Bin.get_instance();
         this.events = new EventDispatcher();
         if(param10)
         {
            this.brain = new Brain(this);
            this.brain.addEventListener(Pet.SKILLS_UPDATED_EVENT,this.skillsUpdatedHandler);
            this.mine = true;
            this.activityLvl = 0;
            this.strokeTimer = new Timer(500,5);
            this.strokeTimer.addEventListener("timer",this.strokeTimerListener);
         }
         this.hideThoughtBubbleTimer = new Timer(3500,1);
         this.hideThoughtBubbleTimer.addEventListener("timer",this.hideThoughtBubble);
         this.behaviours = new Array();
         this.actions = new Array();
         this.ballColours = new Array();
         this.ballColours[0] = 4474111;
         this.ballColours[1] = 16776960;
         this.ballColours[2] = 16729156;
         this.ballColours[3] = 4521796;
         this.ballColours[4] = 16777215;
         this.ballColours[5] = 16711935;
         this.ballColours[6] = 16768256;
         this.ballColours[7] = 65535;
         this.ballColours[8] = 14548991;
         this.balls = new Array();
         this.ballsCreated = 0;
         this.nearestBalls = new Array();
         this.g = -0.25;
         redraw = true;
      }
      
      private function skillsUpdatedHandler(param1:Event) : void
      {
         this.events.dispatchEvent(param1);
      }
      
      public function activate() : void
      {
         if(this.mine)
         {
            this.brain.activate();
         }
      }
      
      public function setOwner(param1:Weevil) : void
      {
         this.owner = param1;
      }
      
      public function setStats(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : void
      {
         this.bedID = param1;
         this.bowlID = param2;
         this.brain.setStats(param3,param4,param5,param6,param7);
      }
      
      public function getSkills() : void
      {
         this.brain.getSkills();
      }
      
      public function newJugglingTrickReceived(param1:Array) : void
      {
         this.brain.newJugglingTrickReceived(param1);
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set nameHash(param1:String) : void
      {
         this._nameHash = param1;
      }
      
      public function get nameHash() : String
      {
         return this._nameHash;
      }
      
      public function set defObj(param1:Object) : void
      {
         this._defObj = param1;
      }
      
      public function get defObj() : Object
      {
         return this._defObj;
      }
      
      public function set loc(param1:*) : void
      {
         this._loc = param1;
         if(this.mine)
         {
            if(this._loc.name == "nest")
            {
               this.brain.activityFactor = 0.2;
            }
            else
            {
               this.brain.activityFactor = 0.6;
            }
            if(this._loc.id < 100)
            {
               this.ignoreCollisions = true;
            }
            else
            {
               this.ignoreCollisions = false;
            }
         }
      }
      
      public function get loc() : Loc
      {
         return this._loc;
      }
      
      override public function set scale(param1:Number) : void
      {
         _scale = param1;
         this.y0 = 32 * _scale;
         y = this.y0;
         this.g = -2.2 * param1;
      }
      
      public function get health() : Number
      {
         return this.brain.health;
      }
      
      public function get vitality() : Number
      {
         return this.brain.mentalEnergy;
      }
      
      public function get fuel() : Number
      {
         return this.brain.fuel;
      }
      
      public function get energy() : Number
      {
         return this.brain.energy;
      }
      
      public function get fitness() : Number
      {
         return this.brain.fitness;
      }
      
      public function get experience() : Number
      {
         return this.brain.experience;
      }
      
      public function getSkillNameByID(param1:int) : String
      {
         return this.brain.getSkillNameByID(param1);
      }
      
      public function getSkillLevel(param1:int) : Number
      {
         return this.brain.getSkillLevel(param1);
      }
      
      public function get isRental() : Boolean
      {
         return this._isRental;
      }
      
      public function set isRental(param1:Boolean) : void
      {
         this._isRental = param1;
      }
      
      public function get mugShot() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         this.creature.setViewAngle(20,-15);
         var _loc2_:BitmapData = new BitmapData(112,135,true,0);
         _loc2_.draw(this.creature.d_o,new Matrix(0.5,0,0,0.5,60,50));
         var _loc3_:Bitmap = new Bitmap();
         _loc3_.bitmapData = _loc2_;
         _loc1_.addChild(_loc3_);
         if(this.ridingOwner)
         {
            this.owner.redraw = true;
         }
         else
         {
            redraw = true;
         }
         return _loc1_;
      }
      
      public function addFitness(param1:Number) : void
      {
         this.brain.addFitness(param1,true);
      }
      
      public function setMouseHandlers() : void
      {
         if(this.mine)
         {
            this.creature.d_o.mouseChildren = false;
            this.creature.d_o.addEventListener(MouseEvent.MOUSE_DOWN,this.showPetProfile);
            this.creature.d_o.addEventListener(MouseEvent.MOUSE_OVER,this.startStrokeTimer);
            this.creature.d_o.addEventListener(MouseEvent.MOUSE_OUT,this.cancelStroke);
         }
         else
         {
            this.creature.d_o.addEventListener(MouseEvent.MOUSE_DOWN,this.showSomeoneElsePetProfile);
         }
      }
      
      public function removeMouseHandlers() : void
      {
         if(this.mine)
         {
            this.creature.d_o.removeEventListener(MouseEvent.MOUSE_DOWN,this.showPetProfile);
            this.creature.d_o.removeEventListener(MouseEvent.MOUSE_OVER,this.startStrokeTimer);
            this.creature.d_o.removeEventListener(MouseEvent.MOUSE_OUT,this.cancelStroke);
         }
         else
         {
            this.creature.d_o.removeEventListener(MouseEvent.MOUSE_DOWN,this.showSomeoneElsePetProfile);
         }
      }
      
      public function startStrokeTimer(param1:MouseEvent) : void
      {
         this.mouseOnPet = true;
         if(!this.bin.UI.crosshairs_on && !this.bin.UI.handShowing)
         {
            this.strokeTimerCount = 0;
            this.strokeTimer.reset();
            this.strokeTimer.start();
         }
      }
      
      public function strokeTimerListener(param1:TimerEvent) : void
      {
         ++this.strokeTimerCount;
         if(this.mouseOnPet)
         {
            switch(this.strokeTimerCount)
            {
               case 1:
                  this.bin.UI.activateHand(true);
                  break;
               case 2:
                  if(this.thoughtBubble_mc.visible == false)
                  {
                     this.brain.receivePleasure(14);
                  }
                  break;
               case 5:
                  this.bin.UI.activateHand(false);
            }
         }
         else
         {
            this.bin.UI.activateHand(false);
         }
      }
      
      public function cancelStroke(param1:MouseEvent) : void
      {
         this.mouseOnPet = false;
         if(this.strokeTimerCount == 0)
         {
            this.strokeTimer.stop();
         }
      }
      
      private function showPetProfile(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.bin.UI.crosshairs_on)
         {
            _loc2_ = x + 10 * (0.5 - Math.random());
            _loc3_ = z + 10 * (0.5 - Math.random());
            this.bin.myWeevilThrowBall(_loc2_,_loc3_);
         }
         else
         {
            this.cancelStroke(param1);
            this.bin.UI.activateHand(false);
            this.bin.showPetProfile(this);
         }
      }
      
      private function showSomeoneElsePetProfile(param1:MouseEvent) : void
      {
         this.bin.showPetProfile(this,true);
      }
      
      public function setLastBallThrownByOwner(param1:int) : void
      {
         this.lastBallThrownByOwnerID = param1;
         if(!this.sleeping && !this.exiting())
         {
            this.brain.ownerThrownBall();
         }
      }
      
      public function goThere(param1:*, param2:Number, param3:Number) : void
      {
         this.brain.goThere(param1,param2,param3);
      }
      
      public function addZz(param1:MovieClip) : void
      {
         this.zz_mc = param1;
         this.zz_mc.visible = false;
         Sprite(d_o).addChild(this.zz_mc);
      }
      
      public function showZz(param1:Boolean) : void
      {
         this.zz_mc.visible = param1;
      }
      
      public function addThoughtBubble(param1:MovieClip) : void
      {
         this.thoughtBubble_mc = param1;
         this.hideThoughtBubble();
         var _loc2_:Sprite = Sprite(this.thoughtBubble_mc.getChildAt(0));
         this.thought_mc = MovieClip(_loc2_.getChildAt(1));
         this.thought_mc.stop();
         Sprite(d_o).addChild(this.thoughtBubble_mc);
      }
      
      public function showThoughtBubble(param1:int = 1) : void
      {
         if(!this.thinking)
         {
            this.thinking = true;
            this.thought_mc.gotoAndStop(param1);
            this.thoughtBubble_mc.gotoAndPlay(2);
            this.thoughtBubble_mc.visible = true;
            this.hideThoughtBubbleTimer.reset();
            this.hideThoughtBubbleTimer.start();
         }
      }
      
      public function hideThoughtBubble(param1:TimerEvent = null) : void
      {
         this.thinking = false;
         this.thoughtBubble_mc.gotoAndStop(1);
         this.thoughtBubble_mc.visible = false;
      }
      
      public function set_creature(param1:Composite) : void
      {
         this.creature = param1;
         this.setMouseHandlers();
      }
      
      public function set_pet_cmp(param1:Composite) : void
      {
         this.pet_cmp = param1;
      }
      
      public function set_arms(param1:Arm, param2:Arm) : void
      {
         this.arm1 = param1;
         this.arm2 = param2;
         this.arm1.setHashMrrs(this.arm2.h);
         this.arm2.setHashMrrs(this.arm1.h);
      }
      
      public function set_eyes(param1:Eye, param2:Eye) : void
      {
         this.eye1 = param1;
         this.eye2 = param2;
         this.eye1.setHashMrrs(this.eye2.h,this.eye2.eyeBall.h);
         this.eye2.setHashMrrs(this.eye1.h,this.eye1.eyeBall.h);
      }
      
      public function set_mouth(param1:Mouth) : void
      {
         this.mouth = param1;
      }
      
      public function set_body(param1:MovieClip) : void
      {
         this.body_mc = param1;
      }
      
      public function setClr(param1:String, param2:int) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         switch(param1)
         {
            case "body":
               _loc3_ = param2 >> 16;
               _loc4_ = param2 >> 8 & 0xFF;
               _loc5_ = param2 & 0xFF;
               this.body_mc.transform.colorTransform = new ColorTransform(1,1,1,1,_loc3_ - 255,_loc4_ - 255,_loc5_ - 255,0);
               this.eye1.setStalkClr(param2);
               this.eye2.setStalkClr(param2);
               break;
            case "arm1":
               this.arm1.setClr(param2);
               break;
            case "arm2":
               this.arm2.setClr(param2);
               break;
            case "eye1":
               this.eye1.setLidClr(param2);
               break;
            case "eye2":
               this.eye2.setLidClr(param2);
         }
      }
      
      public function setExpression(param1:int, param2:Boolean = false) : void
      {
         redraw = true;
         this.crntExpression = param1;
         this.mouth.setExpression(param1);
         redraw = true;
         if(this.ridingOwner)
         {
            this.owner.redraw = true;
         }
         if(param2)
         {
            this.bin.sendPetExpression(this.id,this.loc.name,param1);
         }
      }
      
      public function getExpression() : int
      {
         return this.crntExpression;
      }
      
      public function set_shadow(param1:MovieClip) : void
      {
         this.shadow_mc = param1;
      }
      
      public function setBehaviours(param1:Array) : void
      {
         this.behaviours = param1;
         this.pant = new Pant(999,0,this);
      }
      
      public function listenToMsg(param1:String) : void
      {
         if(!this.sleeping && !this.exiting())
         {
            this.brain.listenToMsg(param1);
         }
         else if(this.sleeping)
         {
            if(this.loc.id == this.owner.crntLoc.id)
            {
               this.wakeUp();
            }
         }
      }
      
      public function updateOwnerPos(param1:int, param2:Number, param3:Number) : void
      {
         this.brain.updateOwnerPos(param1,param2,param3);
      }
      
      public function cancelSummon() : void
      {
         this.brain.cancelSummon();
      }
      
      public function inRange(param1:Number, param2:Number, param3:Number) : Boolean
      {
         var _loc4_:Number = param1 - x;
         var _loc5_:Number = param2 - z;
         if(_loc4_ * _loc4_ + _loc5_ * _loc5_ < param3)
         {
            return true;
         }
         return false;
      }
      
      public function smellFood() : void
      {
         this.brain.smellFood();
      }
      
      public function createBall() : Ball
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Ball = null;
         if(this.ballsSwapped)
         {
            _loc1_ = new Ball_exploding_mc();
            _loc1_.addFrameScript(471,this.jugglingBallExploded);
            _loc1_.addFrameScript(500,this.stopAllBalls);
            _loc1_.rotation = 360 * Math.random();
            _loc1_.gotoAndPlay(int(18 * Math.random()));
            _loc2_ = new Ball(this.ballsCreated,this.behaviours[PetBehaviours.JUGGLE],this.g,_loc1_,16777164,x,0,z + 4,scale * 0.45);
         }
         else
         {
            _loc1_ = new Ball_mc();
            _loc2_ = new Ball(this.ballsCreated,this.behaviours[PetBehaviours.JUGGLE],this.g,_loc1_,this.getNextAvailableColour(),x,0,z + 4,scale * 0.45);
         }
         this.balls.push(_loc2_);
         ++this.ballsCreated;
         this.loc.addDynamicObject(_loc2_);
         return _loc2_;
      }
      
      private function getNextAvailableColour() : int
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this.ballColours.length)
         {
            _loc2_ = int(this.ballColours[_loc1_]);
            if(this.ballColourIsAvailable(_loc2_))
            {
               return _loc2_;
            }
            _loc1_++;
         }
         return this.ballColours[0];
      }
      
      private function ballColourIsAvailable(param1:int) : Boolean
      {
         var _loc3_:Ball = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.balls.length)
         {
            _loc3_ = this.balls[_loc2_];
            if(_loc3_.colour == param1)
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      public function swapBalls() : void
      {
         this.ballsSwapped = true;
      }
      
      private function jugglingBallExploded() : void
      {
         this.behaviours[PetBehaviours.JUGGLE].dropAll();
         EventManager.get_instance().dispatchEvent(new Event("jugglingBallsExploded"));
      }
      
      private function stopAllBalls() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.balls)
         {
            this.balls[_loc1_].ball_mc.stop();
         }
      }
      
      public function destroyBalls() : void
      {
         this.balls = [];
         this.ballsCreated = 0;
      }
      
      public function destroyBall(param1:Ball) : void
      {
         var _loc2_:int = int(this.balls.indexOf(param1));
         if(_loc2_ != -1)
         {
            this.balls.splice(_loc2_,1);
            --this.ballsCreated;
         }
         this.loc.removePetBall(param1);
      }
      
      public function gatherBalls(param1:int) : void
      {
         var _loc2_:Ball = null;
         while(this.balls.length < param1)
         {
            this.createBall();
         }
         this.nearestBalls = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            _loc2_ = this.balls[_loc3_];
            _loc2_.x = x + 2 * Math.random();
            _loc2_.z = z + 2 * Math.random();
            this.nearestBalls.push(_loc2_);
            _loc3_++;
         }
      }
      
      public function getBallCount() : int
      {
         var _loc1_:Ball = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:Number = NaN;
         var _loc2_:Number = scale * 600;
         var _loc6_:int = 0;
         this.nearestBalls = [];
         for each(_loc1_ in this.balls)
         {
            _loc3_ = x - _loc1_.x;
            _loc4_ = z - _loc1_.z;
            _loc5_ = Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
            if(_loc5_ < _loc2_)
            {
               _loc6_++;
               this.nearestBalls.push(_loc1_);
            }
         }
         return _loc6_;
      }
      
      public function getNearestBalls(param1:int) : Array
      {
         var _loc2_:Ball = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:Number = NaN;
         if(param1 >= this.ballsCreated)
         {
            while(param1 > this.ballsCreated)
            {
               this.createBall();
            }
            return this.balls;
         }
         this.nearestBalls = [];
         for each(_loc2_ in this.balls)
         {
            _loc3_ = x - _loc2_.x;
            _loc4_ = z - _loc2_.z;
            _loc2_.dSq = _loc3_ * _loc3_ + _loc4_ * _loc4_;
            this.nearestBalls.push(_loc2_);
         }
         this.nearestBalls.sortOn("dSq",Array.NUMERIC);
         return this.nearestBalls.splice(0,param1);
      }
      
      public function getFurthestBallFromOwner() : Ball
      {
         var _loc1_:* = undefined;
         var _loc2_:Ball = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:Number = NaN;
         _loc3_ = this.owner.x;
         _loc4_ = this.owner.z;
         _loc8_ = 0;
         for each(_loc1_ in this.balls)
         {
            _loc5_ = _loc3_ - _loc1_.x;
            _loc6_ = _loc4_ - _loc1_.z;
            _loc7_ = _loc5_ * _loc5_ + _loc6_ * _loc6_;
            if(_loc7_ > _loc8_)
            {
               _loc8_ = _loc7_;
               _loc2_ = _loc1_;
            }
         }
         return _loc2_;
      }
      
      public function standSquare() : void
      {
         if(rotY < 90 && rotY > -90)
         {
            rotY = 0;
         }
         else
         {
            rotY = 180;
         }
         this.creature.rotY = 0;
      }
      
      public function getJugglingTricks(param1:int) : Array
      {
         if(this.mine)
         {
            return this.brain.getJugglingTricks(param1);
         }
         return null;
      }
      
      public function getJugglingTrickNameByID(param1:Number) : String
      {
         return this.brain.getJugglingTrickNameByID(param1);
      }
      
      public function juggle(param1:int, param2:int) : void
      {
         this.brain.juggle(param1,param2);
      }
      
      public function improveJugglingSkill(param1:int) : void
      {
         if(this.mine)
         {
            this.brain.improveJugglingSkill(param1);
         }
      }
      
      public function updateSkillByID(param1:int, param2:Number = 1) : void
      {
         if(this.brain != null)
         {
            this.brain.updateSkillByID(param1,param2);
         }
      }
      
      public function mimicOwner(param1:int) : void
      {
         if(!this.sleeping && !this.exiting())
         {
            this.brain.mimicOwner(param1);
         }
      }
      
      public function mimicPet(param1:Pet, param2:int) : void
      {
         if(!this.sleeping && !this.exiting())
         {
            this.brain.mimicPet(param1,param2);
         }
      }
      
      public function rideOwner() : void
      {
         if(!this.ridingOwner)
         {
            this.ridingOwner = true;
            this.creature.d_o.scaleX = this.creature.d_o.scaleY = 1.6;
            d_o.x = d_o.y = 0;
            this.loc.removePet(this);
            this.destroyBalls();
            this.owner.petMountWeevil(this,this.creature);
            this.owner.redraw = true;
         }
      }
      
      public function dismount() : void
      {
         if(this.ridingOwner)
         {
            this.ridingOwner = false;
            this.creature.d_o.scaleX = this.creature.d_o.scaleY = 1;
            x = this.owner.x;
            z = this.owner.z;
            y = this.y0;
            rotY = this.owner.rotY;
            this.owner.petDismount(this.creature);
            this.pet_cmp.container_spr.addChild(this.creature.d_o);
            this.owner.crntLoc.addPet(this);
            redraw = true;
         }
      }
      
      public function wakeUp() : void
      {
         var _loc1_:String = null;
         this.act(PetBehaviours.WAKE_UP);
         this.brain.wakeUp();
         if(this.mine)
         {
            _loc1_ = "locID:" + -this.loc.id + ",ps:" + this.crntPose + ",x:" + x + ",y:" + y + ",z:" + z + ",r:" + rotY;
            this.bin.setPetState(this.id,_loc1_);
         }
      }
      
      private function allowedWhileRiding(param1:int) : Boolean
      {
         if(param1 == PetBehaviours.JUMP_OFF || param1 == PetBehaviours.WAVE_RIGHT || param1 == PetBehaviours.WAVE_LEFT || param1 == PetBehaviours.STRETCH || param1 == PetBehaviours.LOOK || param1 == PetBehaviours.LOOK_LEFT_RIGHT || param1 == PetBehaviours.ROLL_EYES || param1 == PetBehaviours.EXTEND_EYES || param1 == PetBehaviours.BLINK)
         {
            return true;
         }
         return false;
      }
      
      public function set dormant(param1:Boolean) : void
      {
         if(this.mine)
         {
            this.brain.dormant = param1;
         }
      }
      
      public function act(param1:int, param2:String = "-1", param3:Boolean = true) : void
      {
         var _loc4_:* = null;
         var _loc5_:Behaviour = null;
         var _loc6_:* = undefined;
         var _loc7_:Array = null;
         var _loc8_:Behaviour = null;
         var _loc9_:Boolean = false;
         if(!this.ridingOwner || this.allowedWhileRiding(param1))
         {
            switch(param1)
            {
               case 0:
                  this.defaultPose();
                  break;
               case -1:
                  this.sit();
                  break;
               case -2:
                  this.pant.init();
                  this.panting = true;
                  break;
               case -3:
                  this.panting = false;
                  this.pant.halt();
                  break;
               case -4:
                  this.abortActions();
                  break;
               case -5:
                  this.setEyeExt(int(param2));
                  break;
               case PetBehaviours.JUMP_OFF:
                  this.crntPose = 0;
                  this.dismount();
                  _loc4_ = "locID:" + -this.loc.id + ",ps:0,x:" + x + ",y:" + this.y0 + ",z:" + z + ",r:" + rotY;
                  if(this.mine)
                  {
                     this.bin.sendPetAction(this.id,this.loc.name,PetBehaviours.JUMP_OFF,_loc4_);
                  }
                  break;
               default:
                  _loc5_ = this.behaviours[param1];
                  _loc6_ = _loc5_.type;
                  if(param2 != "-1" && param2 != null)
                  {
                     _loc7_ = param2.split(",");
                  }
                  for each(_loc8_ in this.actions)
                  {
                     if(_loc8_.type == _loc6_)
                     {
                        if(this.mine)
                        {
                           _loc8_.abort();
                        }
                        else
                        {
                           _loc8_.halt();
                        }
                     }
                  }
                  _loc9_ = true;
                  for each(_loc8_ in this.actions)
                  {
                     if(_loc8_.type == _loc6_)
                     {
                        _loc9_ = false;
                        if(param1 == PetBehaviours.JUGGLE)
                        {
                           this.brain.juggling = false;
                        }
                     }
                  }
                  if(_loc9_)
                  {
                     this.actions.push(_loc5_);
                     this.actions.sortOn("type",Array.NUMERIC);
                     _loc5_.init(_loc7_);
                     if(param1 == PetBehaviours.CRAWL || param1 == PetBehaviours.HOP || param1 == PetBehaviours.WALK || param1 == PetBehaviours.FETCH)
                     {
                        this.sitting = false;
                     }
                     if(this.mine)
                     {
                        switch(param1)
                        {
                           case PetBehaviours.SLEEP:
                              this.crntPose = 13;
                              break;
                           case PetBehaviours.JUMP_ON:
                              this.crntPose = 28;
                              break;
                           default:
                              this.crntPose = 0;
                        }
                        switch(param1)
                        {
                           case PetBehaviours.CRAWL:
                           case PetBehaviours.HOP:
                           case PetBehaviours.WALK:
                              _loc4_ = "locID:" + -this.loc.id + ",ps:0,x:" + _loc7_[0] + ",y:" + this.y0 + ",z:" + _loc7_[1] + ",r:" + _loc7_[2];
                              break;
                           case PetBehaviours.GET_IN_BED:
                              _loc4_ = "locID:" + -this.loc.id + ",ps:13,x:" + _loc7_[0] + ",y:" + this.y0 + ",z:" + _loc7_[1] + ",r:0";
                              break;
                           default:
                              _loc4_ = "-1";
                        }
                        if(param3)
                        {
                           this.bin.sendPetAction(this.id,this.loc.name,param1,_loc4_,param2);
                        }
                     }
                     if(param1 == PetBehaviours.SPIN || param1 == PetBehaviours.JUMP_SPIN || param1 == PetBehaviours.WAVE_RIGHT || param1 == PetBehaviours.WAVE_LEFT || param1 == PetBehaviours.JUMP)
                     {
                        this.bin.petsMimicPet(this,param1);
                     }
                  }
            }
         }
         else
         {
            this.showThoughtBubble(PetThoughts.CONFUSED);
         }
      }
      
      public function actionIsInProgress(param1:int) : Boolean
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
      
      public function gotBall() : void
      {
         this.behaviours[PetBehaviours.FETCH].gotBall = true;
      }
      
      public function travel(param1:Number, param2:Number, param3:Number = 0) : void
      {
         if(this.mine)
         {
            this.brain.travel(param1,param2,param3);
         }
      }
      
      public function sit() : void
      {
         this.sitting = true;
         this.stopActions();
         this.arm1.setPose(21);
         this.arm2.setPose(21);
         this.owner.redraw = true;
         y = this.y0;
         if(this.mine)
         {
            this.bin.sendPetAction(this.id,this.loc.name,-1,"-1");
            this.brain.cancelSummon();
            this.brain.stay();
         }
         redraw = true;
      }
      
      public function wait() : void
      {
         if(this.mine)
         {
            this.brain.wait();
         }
      }
      
      public function get staying() : Boolean
      {
         return this.brain.staying;
      }
      
      public function get juggling() : Boolean
      {
         return this.brain.juggling;
      }
      
      public function eatenFood() : void
      {
         if(this.mine)
         {
            this.brain.foodEaten();
         }
      }
      
      public function showMentalEnergy() : void
      {
         if(this.mine)
         {
            this.brain.showMentalEnergy();
         }
      }
      
      public function get sleepy() : Boolean
      {
         return this.brain.sleepy();
      }
      
      public function setEyeExt(param1:int, param2:Boolean = false) : void
      {
         if(param1 != this.eyeExt)
         {
            if(param2)
            {
               this.bin.sendPetAction(this.id,this.loc.name,-5,"-1",String(param1));
            }
            this.eyeExt = param1;
            this.eye1.setPose(param1);
            this.eye2.setPose(param1);
         }
      }
      
      public function look(param1:Number, param2:Number) : void
      {
         this.eye1.ebRotX = param1;
         this.eye1.ebRotY = param2;
         this.eye2.ebRotX = param1;
         this.eye2.ebRotY = param2;
      }
      
      public function defaultPose() : void
      {
         this.arm1.setPose(0);
         this.arm2.setPose(0);
         y = this.y0;
         redraw = true;
      }
      
      public function halt() : void
      {
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
      
      public function stopAction(param1:int) : void
      {
         var _loc2_:Behaviour = this.behaviours[param1];
         var _loc3_:int = int(this.actions.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.actions[_loc4_] == _loc2_)
            {
               this.actions.splice(_loc4_,1);
               break;
            }
            _loc4_++;
         }
      }
      
      public function abortAction(param1:int) : void
      {
         var _loc2_:Behaviour = this.behaviours[param1];
         if(_loc2_ != null)
         {
            _loc2_.halt();
         }
      }
      
      public function stopActions() : void
      {
         this.actions = [];
      }
      
      public function baseRate() : void
      {
         this.activityLvl = 0.06;
      }
      
      public function exert(param1:Number) : void
      {
         if(this.mine)
         {
            this.brain.exert(param1);
         }
      }
      
      public function abortActions() : void
      {
         var _loc1_:Behaviour = null;
         if(this.mine)
         {
            this.bin.sendPetAction(this.id,this.loc.name,-4,"-1");
         }
         var _loc2_:int = int(this.actions.length);
         var _loc3_:int = _loc2_ - 1;
         while(_loc3_ >= 0)
         {
            _loc1_ = this.actions[_loc3_];
            _loc1_.abort();
            _loc3_--;
         }
         redraw = true;
      }
      
      public function getDir(param1:Number, param2:Number) : int
      {
         var _loc3_:Number = param1 - x;
         var _loc4_:Number = param2 - z;
         var _loc5_:Number = Math.atan2(-_loc3_,-_loc4_) * toDegr;
         return int(_loc5_);
      }
      
      public function exiting() : Boolean
      {
         if(this.destLoc != null)
         {
            return true;
         }
         return false;
      }
      
      public function arrived() : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc1_:Object = {
            "petID":this.id,
            "x":x,
            "y":y,
            "z":z
         };
         var _loc2_:CustomEvent = new CustomEvent(BinEvents.PET_ARRIVED,_loc1_);
         EventManager.get_instance().dispatchEvent(_loc2_);
         if(this.mine)
         {
            if(this.exitDoor != null)
            {
               this.exitThroughDoor();
            }
            else if(this.destLoc != null)
            {
               this.bin.UI.petHasLeftRoom(this);
               this.loc.removePet(this);
               this.destroyBalls();
               this.mask = null;
               this.destLoc.addPet(this);
               this.enterThroughDoor();
            }
            else if(this.entryDoor != null)
            {
               this.entryDoor = null;
               this.mask = null;
            }
            else if(this.brain.foodDetected)
            {
               if(this.foodBowl != null)
               {
                  if(Boolean(this.foodBowl.hitCheck(x,z)) && Boolean(this.foodBowl.isFull))
                  {
                     if(this.foodBowl.isFull)
                     {
                        _loc3_ = String(this.foodBowl.getFID());
                        this.act(PetBehaviours.EAT,_loc3_);
                     }
                  }
               }
            }
            else if(this.brain.sleepy())
            {
               if(this.isBedInThisRoom())
               {
                  _loc4_ = this.getBedCoords();
                  _loc5_ = Number(_loc4_.x);
                  _loc6_ = Number(_loc4_.z);
                  if(this.inRange(_loc5_,_loc6_,1000))
                  {
                     _loc7_ = _loc5_ + "," + _loc6_;
                     this.brain.goto_locID = 0;
                     this.act(PetBehaviours.GET_IN_BED,_loc7_);
                  }
               }
            }
            else if(this.brain.greetOnArrival)
            {
               this.brain.greet();
            }
         }
      }
      
      public function isBedInThisRoom() : Boolean
      {
         if(this.loc.id == this.bin.nest.getPetBedLocID(this.bedID))
         {
            return true;
         }
         return false;
      }
      
      public function getBedLocID() : int
      {
         return this.bin.nest.getPetBedLocID(this.bedID);
      }
      
      public function getBedLoc() : Object
      {
         return this.bin.nest.getPetBedLoc(this.bedID);
      }
      
      public function getBedCoords() : Object
      {
         return this.bin.nest.getPetBedCoords(this.bedID);
      }
      
      public function gotoDoor(param1:Door = null) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         this.ignoreCollisions = true;
         if(param1 == null)
         {
            this.exitDoor = LocNest(this.loc).getRndDoor();
         }
         else
         {
            this.exitDoor = param1;
         }
         if(this.exitDoor != null)
         {
            _loc2_ = this.exitDoor.x1;
            _loc3_ = this.exitDoor.z1;
            this.travel(_loc2_,_loc3_);
         }
      }
      
      private function exitThroughDoor() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(this.exitDoor.isInExitArea(x,z))
         {
            this.bin.sendSetNestDoorPet(this.id,this.loc.name,this.exitDoor.id);
            this.setDoorMask(this.exitDoor);
            _loc1_ = this.exitDoor.x2;
            _loc2_ = this.exitDoor.z2;
            this.travel(_loc1_,_loc2_);
            this.destLoc = this.bin.getLocById(this.exitDoor.toLoc);
            this.entryDoor = this.destLoc.getDoorById(this.exitDoor.toDoor);
         }
         this.exitDoor = null;
      }
      
      public function enterThroughDoor(param1:Door = null) : void
      {
         if(this.mine)
         {
            this.bin.petJoinNestLoc(this.id,this.loc.id,this.entryDoor.id,this.entryDoor.x1,y,this.entryDoor.z1,rotY,this.loc.name);
         }
         if(param1 != null)
         {
            this.entryDoor = param1;
         }
         this.destLoc = null;
         this.setDoorMask(this.entryDoor);
         x = this.entryDoor.x2;
         z = this.entryDoor.z2;
         var _loc2_:Number = this.entryDoor.x1;
         var _loc3_:Number = this.entryDoor.z1;
         this.travel(_loc2_,_loc3_);
      }
      
      public function setDoorForMasking(param1:int) : void
      {
         this.doorForMasking = this.loc.getDoorByID(param1);
         this.mask = null;
      }
      
      public function maskIfNeeded() : void
      {
         if(!this.masked)
         {
            if(this.doorForMasking != null)
            {
               if(x < -187 || x > 187 || z > 387)
               {
                  this.setDoorMask(this.doorForMasking);
               }
            }
         }
         else if(x > -187 && x < 187 && z < 387)
         {
            this.mask = null;
         }
      }
      
      public function setDoorMask(param1:Door) : void
      {
         param1.applyMask(d_o);
         this.masked = true;
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
      
      public function update(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
         var _loc5_:Behaviour = null;
         var _loc4_:Boolean = this.bin.crntLoc == this.loc ? true : false;
         if(this.actions.length != 0)
         {
            if(_loc4_)
            {
               redraw = true;
               if(this.ridingOwner)
               {
                  this.owner.redraw = true;
               }
            }
            for each(_loc5_ in this.actions)
            {
               _loc5_.setPose(param3,param1,param2);
            }
         }
         if(this.panting)
         {
            if(_loc4_)
            {
               redraw = true;
               if(this.ridingOwner)
               {
                  this.owner.redraw = true;
               }
            }
            this.pant.setPose(param3,param1,param2);
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
            depth = -_loc5_.z;
            if(depth > _loc4_ || _loc7_ < -260 || _loc7_ > 874)
            {
               d_o.visible = false;
            }
            else
            {
               d_o.x = _loc7_;
               d_o.y = ViewPort.y0 - _loc5_.y * _loc6_;
               d_o.scaleX = d_o.scaleY = _loc6_ * _scale;
               d_o.visible = true;
               _loc8_ = p.x - param1.x;
               _loc9_ = p.y - param1.y;
               _loc10_ = p.z - param1.z;
               _loc11_ = Math.sqrt(_loc8_ * _loc8_ + _loc10_ * _loc10_);
               _loc12_ = -toDegr * atan2(_loc8_,_loc10_) + rotY;
               if(_loc12_ < 0)
               {
                  _loc12_ += 360;
               }
               else if(_loc12_ > 360)
               {
                  _loc12_ -= 360;
               }
               _loc12_ = 360 - _loc12_;
               _loc13_ = toDegr * atan2(-_loc9_,_loc11_) + rotX;
               visualElm.setViewAngle(_loc13_,_loc12_);
               this.shadow_mc.y = 1 / scale * y * (_loc11_ / (_loc4_ + _loc5_.z));
               this.shadow_mc.alpha = 1 - 0.01 * p.y;
               _loc14_ = toDegr * atan2(_loc5_.x,_loc5_.z + _loc4_ + 100);
               _loc14_ = sin(atan2(-_loc9_,_loc11_)) * _loc14_;
               d_o.rotation = _loc14_;
            }
         }
      }
   }
}

