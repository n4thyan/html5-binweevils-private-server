package com.binweevils.engine3D.visuals.creatures.pets
{
   import com.binweevils.Bin;
   import com.binweevils.DBaccess.PHP2call;
   import com.binweevils.SSclient;
   import com.binweevils.engine3D.toDegr;
   import com.binweevils.engine3D.visuals.Door;
   import com.binweevils.engine3D.visuals.LocNest;
   import com.binweevils.engine3D.visuals.Pos;
   import com.binweevils.engine3D.visuals.creatures.pets.behaviours.Ball;
   import com.binweevils.engine3D.visuals.creatures.pets.behaviours.PetBehaviours;
   import com.binweevils.engine3D.visuals.creatures.pets.behaviours.PetExpressions;
   import com.binweevils.engine3D.visuals.creatures.pets.behaviours.PetThoughts;
   import com.binweevils.engine3D.visuals.creatures.pets.behaviours.PetTypeBehaviours;
   import com.binweevils.engine3D.visuals.creatures.weevils.behaviours.WeevilBehaviours;
   import com.binweevils.petProfile.PetAddSkillAnim;
   import com.binweevils.utilities.Utils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.net.*;
   import flash.utils.Timer;
   
   public class Brain extends EventDispatcher
   {
      
      private var pet:Pet;
      
      private var updateTimer:Timer;
      
      private var ballID:int;
      
      private var foodLocID:int;
      
      private var foodLoc:LocNest;
      
      private var foodLoc_dx:*;
      
      private var foodLoc_dy:*;
      
      private var foodLoc_dz:int;
      
      private var food_x:*;
      
      private var food_z:int;
      
      public var foodDetected:Boolean;
      
      public var seekingFood:Boolean;
      
      public var goto_locID:int;
      
      private var goto_loc:LocNest;
      
      private var goto_x:*;
      
      private var goto_z:Number;
      
      private var gotoLoc_dx:*;
      
      private var gotoLoc_dy:*;
      
      private var gotoLoc_dz:int;
      
      private var summoned:Boolean;
      
      private var summonTimer:Timer;
      
      public var staying:Boolean;
      
      private var longStay:Boolean;
      
      private var stayTimer:Timer;
      
      private var mimicking:Boolean;
      
      private var mimicTimer:Timer;
      
      private var mimicPetTimer:Timer;
      
      private var mimicActionID:int;
      
      private var reactionTimer:Timer;
      
      private var waitTimer:Timer;
      
      private var waiting:Boolean;
      
      private var expressionTimer:Timer;
      
      public var juggling:Boolean;
      
      private var reinforcementTimer:Timer;
      
      private var listeningForReinforcement:Boolean;
      
      public var fuel:Number;
      
      public var energy:Number;
      
      public var mentalEnergy:Number;
      
      public var physEnergy:Number;
      
      public var health:Number;
      
      public var fitness:Number;
      
      public var experience:Number;
      
      private var rechargeRate:Number;
      
      private var foodThoughtCounter:int;
      
      private var wokenThisSession:Boolean;
      
      private var updateCounter:int;
      
      private var fuel_LU:int;
      
      private var mentalEnergy_LU:int;
      
      private var health_LU:int;
      
      private var fitness_LU:int;
      
      private var experience_LU:int;
      
      private var skillNames:Array;
      
      private var skills:Array;
      
      private var crntSkill:Skill;
      
      private var jugglingSkill:Skill;
      
      private var jugglingTricks:Array;
      
      private var crntJugglingTrick:JugglingTrick;
      
      private var bin:Bin;
      
      private var ssclient:SSclient;
      
      private var active:Boolean;
      
      public var activityFactor:Number = 1;
      
      public var greetOnArrival:Boolean;
      
      private var _dormant:Boolean;
      
      public function Brain(param1:Pet)
      {
         super();
         this.pet = param1;
         this.bin = Bin.get_instance();
         this.ssclient = this.bin.get_ssclient();
      }
      
      public function activate() : void
      {
         this.summonTimer = new Timer(15000,1);
         this.summonTimer.addEventListener("timer",this.cancelSummonListener);
         this.stayTimer = new Timer(15000,1);
         this.stayTimer.addEventListener("timer",this.cancelStayListener);
         this.mimicTimer = new Timer(500,1);
         this.mimicTimer.addEventListener("timer",this.mimicTimerListener);
         this.mimicPetTimer = new Timer(500,1);
         this.mimicPetTimer.addEventListener("timer",this.mimicPetTimerListener);
         this.reinforcementTimer = new Timer(10000,1);
         this.reinforcementTimer.addEventListener("timer",this.cancelReinforcementListener);
         this.reactionTimer = new Timer(150,1);
         this.reactionTimer.addEventListener("timer",this.reactToThrow);
         this.waitTimer = new Timer(8000,1);
         this.waitTimer.addEventListener("timer",this.stopWaiting);
         this.expressionTimer = new Timer(8000,1);
         this.expressionTimer.addEventListener("timer",this.expressionTimerListener);
         this.updateTimer = new Timer(1000,0);
         this.updateTimer.addEventListener("timer",this.update);
         this.updateTimer.start();
         this.active = true;
      }
      
      public function addFitness(param1:Number, param2:Boolean = false) : void
      {
         this.fitness += param1;
         if(this.fitness > 100)
         {
            this.fitness = 100;
         }
         if(this.fitness < 35)
         {
            this.fitness = 35;
         }
         if(param2)
         {
            this.sendUpdate();
         }
      }
      
      public function wakeUp() : void
      {
         this.wokenThisSession = true;
      }
      
      public function set dormant(param1:Boolean) : void
      {
         this._dormant = param1;
      }
      
      public function setStats(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         this.fuel = this.fuel_LU = param1;
         this.mentalEnergy = this.mentalEnergy_LU = param2;
         this.health = this.health_LU = param3;
         this.fitness = this.fitness_LU = param4;
         this.experience = this.experience_LU = param5;
         this.physEnergy = 100;
         this.energy = this.mentalEnergy;
      }
      
      public function getSkills() : void
      {
         var _loc1_:PHP2call = new PHP2call("pets/getPetSkills");
         _loc1_.sendAndAwaitResponse(["petID","idx"],[this.pet.id,this.bin.myUserIDX],this.skillsReceived,true,true);
      }
      
      private function skillsReceived(param1:Object, param2:Event) : void
      {
         switch(int(param1.responseCode))
         {
            case 1:
               this.setSkills(param1.skills);
               break;
            case 999:
               this.bin.showAlertBox("Error 999 loading pet skills",true);
         }
      }
      
      private function setSkills(param1:Array) : void
      {
         var _loc4_:Object = null;
         this.skills = new Array();
         this.skillNames = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < PetSkillNames.getNumSkills())
         {
            this.skillNames[_loc2_] = PetSkillNames.getName(_loc2_);
            _loc2_++;
         }
         this.addSkill(PetSkillNames.CALL,100,0);
         this.addSkill(PetSkillNames.GO_THERE,100,0);
         this.addSkill(PetSkillNames.WEEVIL_THROW_BALL,100,0);
         this.addSkill(PetSkillNames.STOP_JUGGLING,100,0);
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            this.addSkill(_loc4_.skillID,_loc4_.obedience,_loc4_.skillLevel);
            _loc3_++;
         }
         this.getJugglingSkills();
      }
      
      public function getJugglingSkills() : void
      {
         var _loc1_:String = "pets/getAcquiredJugglingTricks";
         var _loc2_:PHP2call = new PHP2call(_loc1_);
         _loc2_.sendAndAwaitResponse(["petID","idx"],[this.pet.id,this.bin.myUserIDX],this.jugglingSkillsReceived,true,true);
      }
      
      private function jugglingSkillsReceived(param1:Object, param2:Event) : void
      {
         switch(param1.responseCode)
         {
            case 1:
               this.setJugglingSkills2(param1.tricks);
               break;
            case 999:
               this.bin.showAlertBox("Error 999 loading pet J T",true);
               break;
            default:
               this.bin.showAlertBox("Error " + param1.responseCode + " loading pet J T");
         }
      }
      
      private function setJugglingSkills2(param1:Array) : void
      {
         var _loc4_:Object = null;
         this.jugglingTricks = new Array();
         var _loc2_:int = 1;
         while(_loc2_ <= 9)
         {
            this.jugglingTricks[_loc2_] = new Array();
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            this.addJugglingTrick(_loc4_.id,_loc4_.numBalls,_loc4_.pattern,_loc4_.difficulty,_loc4_.aptitude,_loc4_.name);
            _loc3_++;
         }
         this.jugglingSkill = this.skills[PetSkillNames.JUGGLE];
      }
      
      private function addSkill(param1:int, param2:int, param3:Number) : void
      {
         this.skills[param1] = new Skill(param1,this.skillNames[param1],param2,param3);
         if(param1 == PetSkillNames.JUMP_ON)
         {
            this.skills[PetSkillNames.JUMP_OFF] = new Skill(PetSkillNames.JUMP_OFF,this.skillNames[PetSkillNames.JUMP_OFF],param2,param3);
         }
      }
      
      private function addJugglingTrick(param1:int, param2:int, param3:String, param4:int, param5:Number = 0, param6:String = "") : void
      {
         var _loc7_:JugglingTrickRequirements = PetSkillsTricksProgression.getRequirementsForTrick(param1);
         this.jugglingTricks[param2].push(new JugglingTrick(param1,param2,param3,param4,param5,_loc7_,this,param6));
      }
      
      public function getJugglingTrick(param1:int, param2:int) : JugglingTrick
      {
         return this.jugglingTricks[param1][param2];
      }
      
      public function getJugglingTrickByID(param1:Number, param2:int = -1) : JugglingTrick
      {
         var _loc3_:int = 0;
         var _loc4_:JugglingTrick = null;
         if(param2 != -1)
         {
            return this.getJugglingTrickByIDNumBalls(param1,param2);
         }
         _loc3_ = 1;
         while(_loc3_ < 10)
         {
            _loc4_ = this.getJugglingTrickByIDNumBalls(param1,_loc3_);
            if(_loc4_ != null)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getJugglingTrickNameByID(param1:Number) : String
      {
         var _loc2_:JugglingTrick = this.getJugglingTrickByID(param1);
         return _loc2_.name;
      }
      
      private function getJugglingTrickByIDNumBalls(param1:Number, param2:int) : JugglingTrick
      {
         var _loc5_:JugglingTrick = null;
         var _loc3_:Array = this.jugglingTricks[param2];
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            if(_loc5_.id == param1)
            {
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function getJugglingTricks(param1:int) : Array
      {
         return this.jugglingTricks[param1];
      }
      
      public function juggle(param1:int, param2:int) : void
      {
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         if(this.pet.getExpression() != PetExpressions.NOT_SO_HAPPY && this.pet.getExpression() != PetExpressions.SAD)
         {
            this.juggling = true;
            this.crntJugglingTrick = this.getJugglingTrick(param1,param2);
            _loc3_ = this.crntJugglingTrick.patternStr;
            _loc4_ = 1 / this.jugglingSkill.level;
            _loc5_ = this.crntJugglingTrick.aptitude;
            _loc6_ = _loc3_ + "," + _loc4_ + "," + _loc5_;
            this.pet.act(PetBehaviours.JUGGLE,_loc6_);
         }
         else
         {
            this.pet.showThoughtBubble(PetThoughts.SAD);
         }
      }
      
      public function improveJugglingSkill(param1:int) : void
      {
         var _loc2_:Number = this.crntJugglingTrick.difficulty;
         var _loc3_:Number = this.jugglingSkill.level;
         var _loc4_:Number = this.crntJugglingTrick.aptitude;
         var _loc5_:Number = param1 / _loc4_;
         if(_loc5_ > 1)
         {
            this.pet.setExpression(PetExpressions.HAPPY,true);
         }
         else if(_loc5_ > 0.75)
         {
            this.pet.setExpression(PetExpressions.NEUTRAL,true);
         }
         else
         {
            this.pet.setExpression(PetExpressions.SAD,true);
            this.setExpressionTimer();
         }
         var _loc6_:Number = 1;
         var _loc7_:int = PetSkillsTricksProgression.convertLevelToTenScale(_loc3_);
         _loc6_ *= this.crntJugglingTrick.numBalls / _loc7_;
         this.jugglingSkill.incrSkillLevel(_loc6_);
         this.crntJugglingTrick.improve(2);
         var _loc8_:Number = this.crntJugglingTrick.aptitude;
         var _loc9_:PHP2call = new PHP2call("pets/updateJugglingTrick");
         var _loc10_:Array = ["petID","idx","trickID","aptitude","skillLevel"];
         var _loc11_:Array = [this.pet.id,this.bin.myUserIDX,this.crntJugglingTrick.id,this.roundTo2dp(_loc8_),this.roundTo2dp(this.jugglingSkill.level)];
         _loc9_.sendAndAwaitResponse(_loc10_,_loc11_,this.updateJugglingTrickHandler,true,true);
         var _loc12_:PetAddSkillAnim = new PetAddSkillAnim(this.pet.d_o,0,-50,"JUGGLE");
         dispatchEvent(new Event(Pet.SKILLS_UPDATED_EVENT));
         this.juggling = false;
      }
      
      private function updateJugglingTrickHandler(param1:Object, param2:Event) : void
      {
         switch(param1.responseCode)
         {
            case 1:
            case 999:
         }
      }
      
      private function getNewJugglingTrick(param1:int, param2:int) : *
      {
         this.ssclient.getNewJugglingTrick(this.pet.id,param1,param2);
      }
      
      public function newJugglingTrickReceived(param1:Array) : void
      {
         if(param1[0] != 0)
         {
            this.addJugglingTrick(param1[0],param1[1],param1[2],param1[3]);
            if(!this.pet.panting)
            {
               this.pet.act(PetBehaviours.CELEBRATE);
            }
         }
      }
      
      private function getSkillByName(param1:String) : Skill
      {
         var _loc2_:Skill = null;
         for each(_loc2_ in this.skills)
         {
            if(_loc2_.skillName == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getSkillByID(param1:int) : Skill
      {
         return this.skills[param1];
      }
      
      public function getSkillNameByID(param1:int) : String
      {
         return this.skills[param1].skillName;
      }
      
      public function getSkillLevel(param1:int) : Number
      {
         return this.skills[param1].level;
      }
      
      public function listenToMsg(param1:String) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Skill = null;
         var _loc4_:Boolean = false;
         var _loc5_:Number = NaN;
         param1 = param1.toLowerCase();
         if(param1.search(this.pet.name.toLowerCase()) >= 0)
         {
            param1 = param1.replace(this.pet.name.toLowerCase(),"");
            param1 = Utils.trimString(param1);
            for each(_loc2_ in this.skills)
            {
               if(_loc2_.skillName.toLowerCase() == param1)
               {
                  _loc3_ = _loc2_;
                  break;
               }
            }
            if(_loc3_ == null)
            {
               _loc3_ = this.skills[PetSkillNames.CALL];
               if(this.ownerInView() && this.pet.actions.length > 0)
               {
                  _loc4_ = true;
               }
               this.pet.showThoughtBubble(PetThoughts.CONFUSED);
            }
            _loc5_ = _loc3_.obedience;
            if(this.fuel < 40)
            {
               _loc5_ *= 0.5;
            }
            if(!this.juggling || _loc3_.id != 8 && !_loc4_)
            {
               if(100 * Math.random() < _loc5_)
               {
                  this.doIt(_loc3_,true);
               }
               else
               {
                  this.cancelReinforcementListener();
                  if(this.fuel < 40)
                  {
                     this.pet.showThoughtBubble(PetThoughts.FOOD);
                  }
                  else
                  {
                     this.pet.showThoughtBubble(PetThoughts.TONG_OUT);
                  }
               }
            }
            else
            {
               this.pet.showThoughtBubble(PetThoughts.TONG_OUT);
            }
         }
      }
      
      private function doIt(param1:Skill, param2:Boolean = false) : void
      {
         var _loc3_:* = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:String = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         var _loc12_:Ball = null;
         this.pet.abortActions();
         if(this.pet.actions.length == 0)
         {
            if(param2)
            {
               if(param1.id != PetSkillNames.STAY && param1.id != PetSkillNames.GO_TO_BED && param1.id != PetSkillNames.JUGGLE)
               {
                  this.crntSkill = param1;
                  this.listenForReinforcement();
               }
               else if(param1.id == PetSkillNames.STAY)
               {
                  this.crntSkill = this.skills[PetSkillNames.SIT];
                  this.listenForReinforcement();
               }
            }
            _loc7_ = this.getPerformanceFactor();
            _loc8_ = param1.skillName;
            _loc9_ = this.getSkillByName(_loc8_).level;
            _loc10_ = this.getSkillLevel(PetSkillNames.JUMP);
            switch(_loc8_)
            {
               case this.skillNames[PetSkillNames.COME_HERE]:
                  this.cancelStay();
                  this.summon(this.bin.crntLocID,this.bin.myWeevil.x,this.bin.myWeevil.z);
                  break;
               case this.skillNames[PetSkillNames.SIT]:
                  this.pet.sit();
                  break;
               case this.skillNames[PetSkillNames.STAY]:
                  this.stay(true);
                  break;
               case this.skillNames[PetSkillNames.GO_TO_BED]:
                  if(this.sleepy())
                  {
                     this.goToBed();
                  }
                  else
                  {
                     this.refuse();
                     if(this.mentalEnergy > 65)
                     {
                        if(this.pet.isBedInThisRoom())
                        {
                           this.pet.gotoDoor();
                        }
                     }
                  }
                  break;
               case this.skillNames[PetSkillNames.JUMP_ON]:
                  if(this.ownerInRange(true))
                  {
                     this.pet.act(PetBehaviours.JUMP_ON);
                  }
                  else
                  {
                     this.summon(this.bin.crntLocID,this.bin.myWeevil.x,this.bin.myWeevil.z);
                  }
                  break;
               case this.skillNames[PetSkillNames.JUMP_OFF]:
                  this.pet.act(PetBehaviours.JUMP_OFF);
                  break;
               case this.skillNames[PetSkillNames.FETCH]:
                  if(this.mentalEnergy > 40 && this.fuel > 40)
                  {
                     this.cancelStay();
                     if(this.pet.balls.length == 0)
                     {
                        this.pet.showThoughtBubble(PetThoughts.NO_BALLS);
                     }
                     else
                     {
                        _loc3_ = this.pet.owner.x + "," + this.pet.owner.z + "," + this.pet.lastBallThrownByOwnerID + ",0";
                        this.pet.act(PetBehaviours.FETCH,_loc3_);
                     }
                  }
                  else
                  {
                     this.refuseHungryOrTired();
                  }
                  break;
               case this.skillNames[PetSkillNames.THROW_TO_ME]:
                  if(this.mentalEnergy > 40 && this.fuel > 40)
                  {
                     _loc12_ = this.pet.getFurthestBallFromOwner();
                     if(_loc12_ == null)
                     {
                        this.pet.showThoughtBubble(PetThoughts.NO_BALLS);
                     }
                     else
                     {
                        this.pet.lastBallThrownByOwnerID = _loc12_.id;
                        _loc3_ = this.pet.owner.x + "," + this.pet.owner.z + "," + this.pet.lastBallThrownByOwnerID + ",1," + this.skills[PetSkillNames.THROW_TO_ME].level;
                        this.pet.act(PetBehaviours.FETCH,_loc3_);
                     }
                  }
                  else
                  {
                     this.refuseHungryOrTired();
                  }
                  break;
               case this.skillNames[PetSkillNames.JUGGLE]:
                  _loc11_ = this.pet.getBallCount();
                  if(_loc11_ > 0)
                  {
                     if(this.mentalEnergy > 40 && this.fuel > 40)
                     {
                        this.pet.abortActions();
                        this.stay();
                     }
                     else
                     {
                        this.pet.act(PetBehaviours.THROW_ALL);
                        this.setExpressionTimer();
                        this.refuseHungryOrTired();
                     }
                  }
                  break;
               case this.skillNames[PetSkillNames.STOP_JUGGLING]:
                  this.pet.abortActions();
                  this.stay();
                  this.juggling = false;
                  break;
               case this.skillNames[PetSkillNames.SPIN]:
                  if(this.mentalEnergy > 40 && this.fuel > 40)
                  {
                     _loc4_ = _loc9_ * 0.5 * _loc7_;
                     _loc5_ = 1 - 0.5 / _loc9_;
                     _loc3_ = _loc4_ + "," + _loc5_ + ",0";
                     this.pet.act(PetBehaviours.SPIN,_loc3_);
                     this.updateSkill(param1,1,-1);
                  }
                  else
                  {
                     this.refuseHungryOrTired();
                  }
                  break;
               case this.skillNames[PetSkillNames.FAST_SPIN]:
                  if(this.mentalEnergy > 40 && this.fuel > 40)
                  {
                     _loc4_ = _loc9_ * 0.5 * _loc7_;
                     _loc5_ = 1 - 0.5 / _loc9_;
                     _loc3_ = _loc4_ + "," + _loc5_ + ",1";
                     this.pet.act(PetBehaviours.SPIN,_loc3_);
                     this.updateSkill(param1,1,-1);
                  }
                  else
                  {
                     this.refuseHungryOrTired();
                  }
                  break;
               case this.skillNames[PetSkillNames.JUMP_SPIN]:
                  if(this.mentalEnergy > 40 && this.fuel > 40)
                  {
                     _loc4_ = _loc9_ * 0.5 * _loc7_;
                     _loc6_ = _loc10_ * 0.04 * _loc7_;
                     _loc3_ = _loc4_ + "," + _loc6_ + ",0,0";
                     this.pet.act(PetBehaviours.JUMP_SPIN,_loc3_);
                     this.updateSkill(param1,1,-1);
                  }
                  else
                  {
                     this.refuseHungryOrTired();
                  }
                  break;
               case this.skillNames[PetSkillNames.SUPER_SPIN]:
                  if(this.mentalEnergy > 40 && this.fuel > 40)
                  {
                     _loc4_ = _loc9_ * 0.5 * this.getPerformanceFactor();
                     _loc6_ = _loc10_ * 0.04 * _loc7_;
                     _loc3_ = _loc4_ + "," + _loc6_ + ",1,0";
                     this.pet.act(PetBehaviours.JUMP_SPIN,_loc3_);
                     this.updateSkill(param1,1,-1);
                  }
                  else
                  {
                     this.refuseHungryOrTired();
                  }
                  break;
               case this.skillNames[PetSkillNames.BOUNCE_SPIN]:
                  if(this.mentalEnergy > 40 && this.fuel > 40)
                  {
                     _loc4_ = _loc9_ * 0.7 * this.getPerformanceFactor();
                     _loc6_ = _loc10_ * 0.04 * _loc7_;
                     _loc3_ = _loc4_ + "," + _loc6_ + ",1,1";
                     this.pet.act(PetBehaviours.JUMP_SPIN,_loc3_);
                     this.updateSkill(param1,1,-1);
                  }
                  else
                  {
                     this.refuseHungryOrTired();
                  }
                  break;
               default:
                  if(this.pet.loc.id == this.pet.owner.crntLoc.id)
                  {
                     _loc3_ = this.pet.owner.x + "," + this.pet.owner.z;
                     this.pet.act(PetBehaviours.TURN_TO_FACE,_loc3_);
                  }
                  else
                  {
                     this.summon(this.bin.crntLocID,this.bin.myWeevil.x,this.bin.myWeevil.z);
                  }
            }
         }
      }
      
      public function updateSkillByID(param1:int, param2:Number = 1) : void
      {
         var _loc3_:Skill = this.skills[param1];
         this.updateSkill(_loc3_,param2);
      }
      
      private function updateSkill(param1:Skill, param2:Number = 0, param3:int = 0) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:PetAddSkillAnim = null;
         var _loc6_:PHP2call = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         if(this.checkInSkillIgnoreList(param1.id))
         {
            return;
         }
         if(param2 != 0)
         {
            if(param1.level != 100)
            {
               _loc4_ = true;
               this.experience += 0.05;
               _loc5_ = new PetAddSkillAnim(this.pet.d_o,0,-50,param1.skillName);
            }
            param1.incrSkillLevel(param2);
         }
         if(param3 != 0)
         {
            param1.reinforce(param3);
            if(param1 == this.skills[PetSkillNames.JUMP_ON])
            {
               this.skills[PetSkillNames.JUMP_OFF].reinforce(param3);
            }
            _loc4_ = true;
         }
         if(_loc4_)
         {
            _loc6_ = new PHP2call("pets/updatePetSkill");
            _loc7_ = ["petID","idx","skillID","skillLevel","obedience"];
            _loc8_ = [this.pet.id,this.bin.myUserIDX,param1.id,this.roundTo2dp(param1.level),param1.obedience];
            _loc6_.sendAndAwaitResponse(_loc7_,_loc8_,this.updatedSkillReceived,true,true);
         }
         dispatchEvent(new Event(Pet.SKILLS_UPDATED_EVENT));
      }
      
      private function checkInSkillIgnoreList(param1:Number) : Boolean
      {
         var _loc2_:Array = new Array(0,1,2,3,4,5,18,19,20,21);
         if(_loc2_.indexOf(param1) == -1)
         {
            return false;
         }
         return true;
      }
      
      private function updatedSkillReceived(param1:Object, param2:Event) : void
      {
         switch(param1.responseCode)
         {
            case 1:
            case 2:
            case 999:
         }
      }
      
      private function roundTo2dp(param1:Number) : Number
      {
         return 0.01 * Number(int(param1 * 100));
      }
      
      private function refuse() : void
      {
         var _loc1_:int = Math.random() < 0.5 ? PetExpressions.NOT_SO_HAPPY : PetExpressions.TONG_OUT_DISOBEDIENT;
         this.pet.setExpression(_loc1_,true);
         this.setExpressionTimer();
         this.pet.showThoughtBubble(PetThoughts.TONG_OUT);
      }
      
      private function refuseHungryOrTired() : void
      {
         if(this.mentalEnergy > this.fuel)
         {
            this.pet.showThoughtBubble(PetThoughts.FOOD);
         }
         else
         {
            this.pet.showThoughtBubble(PetThoughts.SLEEPY);
         }
      }
      
      private function setExpressionTimer() : void
      {
         this.expressionTimer.reset();
         this.expressionTimer.start();
      }
      
      private function expressionTimerListener(param1:TimerEvent) : void
      {
         if(this.pet.getExpression() == PetExpressions.NOT_SO_HAPPY || this.pet.getExpression() == PetExpressions.TONG_OUT_DISOBEDIENT || this.pet.getExpression() == PetExpressions.SAD)
         {
            this.pet.setExpression(PetExpressions.NEUTRAL,true);
         }
      }
      
      private function listenForReinforcement() : void
      {
         if(this.active)
         {
            this.cancelReinforcementListener();
            this.listeningForReinforcement = true;
            this.reinforcementTimer.reset();
            this.reinforcementTimer.start();
         }
      }
      
      private function cancelReinforcementListener(param1:TimerEvent = null) : void
      {
         this.listeningForReinforcement = false;
         if(this.active && this.reinforcementTimer.running)
         {
            this.reinforcementTimer.stop();
         }
      }
      
      public function receivePleasure(param1:Number) : void
      {
         if(this.listeningForReinforcement)
         {
            this.updateSkill(this.crntSkill,0,param1);
         }
         if(this.fuel > 40 && this.mentalEnergy > 40 && !this.pet.panting && !this.pet.sleeping)
         {
            this.pet.showThoughtBubble(PetThoughts.HAPPY);
            this.pet.setExpression(PetExpressions.HAPPY,true);
         }
         else if(this.pet.sleeping)
         {
            this.pet.showThoughtBubble(PetThoughts.SLEEPY);
         }
         else if(this.fuel <= 40)
         {
            this.pet.showThoughtBubble(PetThoughts.FOOD);
         }
         else if(this.mentalEnergy <= 40)
         {
            this.pet.showThoughtBubble(PetThoughts.SLEEPY);
         }
         else if(this.pet.panting)
         {
            this.pet.showThoughtBubble(PetThoughts.NO_ENERGY);
         }
      }
      
      private function doMove() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:* = undefined;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Object = null;
         if(!this._dormant && this.pet.loc != null)
         {
            if(this.goto_locID != 0)
            {
               _loc1_ = 0;
               this.gotoLoc(_loc1_);
            }
            else
            {
               _loc2_ = this.bin.seekPet(this.pet);
               if(this.pet.ridingOwner)
               {
                  if(800 * Math.random() < this.energy)
                  {
                     this.pet.act(PetBehaviours.JUMP_OFF);
                  }
               }
               else if(Math.random() < 0.5 && _loc2_ != null)
               {
                  this.goToPet(_loc2_);
               }
               else if(Math.random() < 0.2 && this.ownerInRange() && !this.pet.doingActionType(PetTypeBehaviours.MOVEMENT))
               {
                  this.pet.act(PetBehaviours.JUMP_ON);
               }
               else if(this.pet.loc.id < 100 && Math.random() < 0.1)
               {
                  if(this.pet.owner.crntLoc.id < 100)
                  {
                     this.summon(this.pet.owner.crntLoc.id,this.pet.owner.x,this.pet.owner.z);
                  }
               }
               else if(this.mentalEnergy > 65 && this.energy > 65 && Math.random() < 0.2)
               {
                  if(this.pet.owner.crntLoc.id == this.pet.loc.id)
                  {
                     if(this.pet.balls.length > 0)
                     {
                        _loc3_ = Math.random();
                        if(_loc3_ < 0.333)
                        {
                           this.pet.lastBallThrownByOwnerID = this.pet.getFurthestBallFromOwner().id;
                           this.reactToThrow();
                        }
                        else if(_loc3_ < 0.666)
                        {
                           _loc4_ = this.pet.getBallCount();
                           if(_loc4_ > 0 && this.skills[PetSkillNames.THROW_TO_ME].level > 25)
                           {
                              _loc5_ = this.getJugglingTricks(_loc4_);
                              _loc6_ = int(_loc5_.length * Math.random());
                              this.juggle(_loc4_,_loc6_);
                           }
                           else
                           {
                              this.doATrick();
                           }
                        }
                        else
                        {
                           this.summon(this.pet.owner.crntLoc.id,this.pet.owner.x,this.pet.owner.z);
                        }
                     }
                     else
                     {
                        this.doATrick();
                     }
                  }
               }
               else
               {
                  _loc7_ = this.pet.loc.getRandomFreeCoord();
                  _loc8_ = Number(_loc7_.x);
                  _loc9_ = Number(_loc7_.z);
                  _loc10_ = this.pet.loc.pathCollisionPoint(this.pet.x,this.pet.z,_loc8_,_loc9_);
                  if(_loc10_ != null)
                  {
                     _loc8_ = Number(_loc10_.x);
                     _loc9_ = Number(_loc10_.z);
                  }
                  if(this.pet.loc.id >= 100)
                  {
                     this.pet.ignoreCollisions = false;
                  }
                  this.travel(_loc8_,_loc9_);
               }
            }
         }
      }
      
      private function ownerInRange(param1:Boolean = false) : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(this.pet.loc == this.pet.owner.crntLoc)
         {
            _loc2_ = this.getSkillLevel(PetSkillNames.JUMP);
            if(_loc2_ > 15 || param1)
            {
               _loc3_ = this.pet.owner.x - this.pet.x;
               _loc4_ = this.pet.owner.z - this.pet.z;
               _loc5_ = Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
               if(_loc2_ > 30 || param1)
               {
                  _loc6_ = 120 + this.getPerformanceFactor() * 150;
               }
               else
               {
                  _loc6_ = 120;
               }
               _loc6_ *= this.pet.scale;
               return _loc6_ > _loc5_ ? true : false;
            }
            return false;
         }
         return false;
      }
      
      private function doATrick() : void
      {
         var _loc1_:Array = [this.skills[PetSkillNames.SPIN]];
         if(this.skills[PetSkillNames.FAST_SPIN].level > 25)
         {
            _loc1_.push(this.skills[PetSkillNames.FAST_SPIN]);
         }
         if(this.skills[PetSkillNames.JUMP_SPIN].level > 15)
         {
            _loc1_.push(this.skills[PetSkillNames.JUMP_SPIN]);
         }
         if(this.skills[PetSkillNames.SUPER_SPIN].level > 25)
         {
            _loc1_.push(this.skills[PetSkillNames.SUPER_SPIN]);
         }
         if(this.skills[PetSkillNames.BOUNCE_SPIN].level > 35)
         {
            _loc1_.push(this.skills[PetSkillNames.BOUNCE_SPIN]);
         }
         var _loc2_:int = _loc1_.length * Math.random();
         var _loc3_:Skill = _loc1_[_loc2_];
         this.doIt(_loc3_);
      }
      
      private function doStaticAction() : void
      {
         var _loc1_:Number = Math.random();
         if(_loc1_ < 0.25)
         {
            this.pet.act(PetBehaviours.BLINK);
         }
         else if(_loc1_ < 0.39)
         {
            this.pet.act(PetBehaviours.LOOK_LEFT_RIGHT);
         }
         else if(_loc1_ < 0.5)
         {
            this.pet.act(PetBehaviours.ROLL_EYES);
         }
      }
      
      public function getPerformanceFactor() : Number
      {
         return Math.sqrt(this.fitness * this.fitness + this.energy * this.energy) * 0.01;
      }
      
      public function travel(param1:Number, param2:Number, param3:Number = 0, param4:Number = 0) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:Boolean = false;
         if(isNaN(param1) || isNaN(param2))
         {
            return;
         }
         var _loc10_:Number = this.pet.scale;
         var _loc11_:Number = this.getPerformanceFactor();
         var _loc12_:Number = this.getSkillLevel(PetSkillNames.JUMP);
         var _loc13_:Number = this.getSkillLevel(PetSkillNames.STAND_UP);
         _loc7_ = PetSkillsTricksProgression.petCanHop(_loc12_);
         _loc8_ = PetSkillsTricksProgression.petCanWalk(_loc13_);
         _loc9_ = PetSkillsTricksProgression.petCanRun(_loc13_);
         var _loc14_:Number = this.energy + param3;
         if(_loc14_ > 75)
         {
            if(_loc9_)
            {
               _loc5_ = PetBehaviours.WALK;
               _loc6_ = 11 * _loc10_ * _loc11_;
            }
            else if(_loc8_)
            {
               _loc5_ = PetBehaviours.WALK;
               _loc6_ = 8 * _loc10_ * _loc11_;
            }
            else if(_loc7_)
            {
               _loc5_ = PetBehaviours.HOP;
               _loc6_ = _loc12_ * 0.13 * _loc10_ * Math.min(_loc11_,0.7);
            }
            else
            {
               _loc5_ = PetBehaviours.CRAWL;
               _loc6_ = 4 * _loc10_ * Math.max(_loc11_,0.5);
            }
         }
         else if(_loc14_ > 50)
         {
            if(_loc7_)
            {
               _loc5_ = PetBehaviours.HOP;
               _loc6_ = _loc12_ * 0.13 * _loc10_ * Math.min(_loc11_,0.7);
            }
            else if(_loc8_)
            {
               _loc5_ = PetBehaviours.WALK;
               _loc6_ = 8 * _loc10_ * _loc11_;
            }
            else
            {
               _loc5_ = PetBehaviours.CRAWL;
               _loc6_ = 4 * _loc10_ * _loc11_;
            }
         }
         else if(_loc14_ > 25)
         {
            if(_loc8_ && Math.random() > 0.5)
            {
               if(25 + 25 * Math.random() < this.energy)
               {
                  _loc5_ = PetBehaviours.WALK;
                  _loc6_ = 7 * _loc10_ * _loc11_;
               }
               else
               {
                  _loc5_ = PetBehaviours.CRAWL;
                  _loc6_ = 4 * _loc10_ * Math.min(_loc11_,0.5);
               }
            }
            else
            {
               _loc5_ = PetBehaviours.CRAWL;
               _loc6_ = 5 * _loc10_ * _loc11_;
            }
         }
         else
         {
            _loc5_ = PetBehaviours.CRAWL;
            _loc6_ = 4 * _loc10_ * Math.min(_loc11_,0.5);
         }
         var _loc15_:Number = this.pet.getDir(param1,param2);
         var _loc16_:String = param1 + "," + param2 + "," + _loc15_ + "," + _loc6_ + "," + param4;
         this.pet.act(_loc5_,_loc16_);
      }
      
      public function sleepy() : Boolean
      {
         if(this.mentalEnergy < 50)
         {
            return true;
         }
         return false;
      }
      
      public function lookForBed() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(this.pet.isBedInThisRoom())
         {
            _loc1_ = this.pet.getBedCoords();
            _loc2_ = Number(_loc1_.x);
            _loc3_ = Number(_loc1_.z);
            _loc4_ = _loc2_ - this.pet.x;
            _loc5_ = _loc3_ - this.pet.z;
            _loc6_ = Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_);
            _loc7_ = _loc2_ - _loc4_ * 13 / _loc6_;
            _loc8_ = _loc3_ - _loc5_ * 13 / _loc6_;
            this.travel(_loc7_,_loc8_);
            return true;
         }
         if(10 * Math.random() > 8.5)
         {
            this.pet.act(PetBehaviours.STRETCH);
         }
         return false;
      }
      
      public function goToBed() : void
      {
         var _loc2_:Object = null;
         var _loc1_:int = this.pet.getBedLocID();
         if(_loc1_ != 0)
         {
            this.goto_locID = _loc1_;
            _loc2_ = this.pet.getBedCoords();
            this.goto_x = _loc2_.x;
            this.goto_z = _loc2_.z;
            this.gotoLoc();
         }
      }
      
      public function summon(param1:*, param2:Number, param3:Number) : void
      {
         if(!this.pet.sleeping)
         {
            this.summonTimer.reset();
            this.summonTimer.start();
            this.summoned = true;
            this.comeHere(param1,param2,param3);
         }
      }
      
      private function cancelSummonListener(param1:TimerEvent) : void
      {
         this.cancelSummon();
      }
      
      public function cancelSummon() : void
      {
         if(this.summoned)
         {
            this.summonTimer.stop();
            this.summoned = false;
            if(this.foodDetected)
            {
               this.seekFood();
            }
            else
            {
               this.goto_locID = 0;
            }
         }
      }
      
      public function stay(param1:Boolean = false) : void
      {
         this.stayTimer.reset();
         this.stayTimer.start();
         this.staying = true;
         this.longStay = param1;
      }
      
      private function cancelStayListener(param1:TimerEvent) : void
      {
         this.cancelStay();
      }
      
      public function cancelStay() : void
      {
         if(this.staying)
         {
            if(!this.longStay)
            {
               this.staying = false;
               if(this.foodDetected)
               {
                  this.seekFood();
               }
            }
            else
            {
               this.stay();
            }
            this.longStay = false;
         }
      }
      
      public function wait() : void
      {
         this.waitTimer.reset();
         this.waitTimer.start();
         this.waiting = true;
      }
      
      private function stopWaiting(param1:TimerEvent) : void
      {
         this.waitTimer.stop();
         this.waiting = false;
      }
      
      public function ownerInView() : Boolean
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:Number = NaN;
         if(this.pet.loc == this.pet.owner.crntLoc)
         {
            _loc1_ = this.pet.owner.x;
            _loc2_ = this.pet.owner.z;
            _loc3_ = this.pet.x - _loc1_;
            _loc4_ = this.pet.z - _loc2_;
            _loc5_ = Math.atan2(_loc3_,_loc4_) * toDegr;
            _loc6_ = _loc5_ - this.pet.rotY;
            if(_loc6_ < 130 && _loc6_ > -130)
            {
               return true;
            }
         }
         return false;
      }
      
      public function petInView(param1:Pet) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:Number = NaN;
         _loc2_ = param1.x;
         _loc3_ = param1.z;
         _loc4_ = this.pet.x - _loc2_;
         _loc5_ = this.pet.z - _loc3_;
         var _loc8_:Number = 200 * this.pet.scale;
         if(_loc4_ < _loc8_ && _loc5_ < _loc8_)
         {
            _loc6_ = Math.atan2(_loc4_,_loc5_) * toDegr;
            _loc7_ = _loc6_ - this.pet.rotY;
            if(_loc7_ < 130 && _loc7_ > -130)
            {
               return true;
            }
         }
         return false;
      }
      
      public function mimicOwner(param1:int) : void
      {
         if(this.energy > 40 && !this.mimicking)
         {
            if(this.ownerInView() || this.pet.ridingOwner)
            {
               this.pet.act(PetBehaviours.TURN_TO_FACE,this.pet.owner.x + "," + this.pet.owner.z);
               this.mimicking = true;
               this.mimicTimer.reset();
               this.mimicTimer.start();
               this.mimicActionID = param1;
            }
         }
      }
      
      private function mimicTimerListener(param1:TimerEvent) : void
      {
         var _loc2_:Skill = null;
         var _loc3_:Number = NaN;
         this.mimicTimer.stop();
         switch(this.mimicActionID)
         {
            case WeevilBehaviours.JUMP:
               _loc2_ = this.getSkillByID(PetSkillNames.JUMP);
               if(100 * Math.random() < _loc2_.obedience)
               {
                  _loc3_ = 5 * this.getPerformanceFactor() * _loc2_.level * 0.02;
                  this.pet.act(PetBehaviours.JUMP,"" + _loc3_);
               }
               else
               {
                  this.pet.showThoughtBubble(PetThoughts.TONG_OUT);
               }
               break;
            case WeevilBehaviours.WAVE1:
               _loc2_ = this.getSkillByID(PetSkillNames.WAVE);
               if(100 * Math.random() < _loc2_.obedience)
               {
                  this.pet.act(PetBehaviours.WAVE_LEFT);
               }
               else
               {
                  this.pet.showThoughtBubble(PetThoughts.TONG_OUT);
               }
               break;
            case WeevilBehaviours.WAVE2:
               _loc2_ = this.getSkillByID(PetSkillNames.WAVE);
               if(100 * Math.random() < _loc2_.obedience)
               {
                  this.pet.act(PetBehaviours.WAVE_RIGHT);
               }
               else
               {
                  this.pet.showThoughtBubble(PetThoughts.TONG_OUT);
               }
               break;
            case WeevilBehaviours.SHAKE_HEAD:
            case WeevilBehaviours.NOD:
               break;
            case WeevilBehaviours.STAND_TALL:
               _loc2_ = this.getSkillByID(PetSkillNames.STAND_UP);
               if(100 * Math.random() < _loc2_.obedience)
               {
                  this.pet.act(PetBehaviours.STAND,String(this.getSkillLevel(PetSkillNames.STAND_UP)));
               }
               else
               {
                  this.pet.showThoughtBubble(PetThoughts.TONG_OUT);
               }
         }
         this.mimicking = false;
      }
      
      public function mimicPet(param1:Pet, param2:int) : void
      {
         if(this.energy > 40 && !this.mimicking)
         {
            if(this.petInView(param1))
            {
               this.pet.act(PetBehaviours.TURN_TO_FACE,param1.x + "," + param1.z);
               this.mimicking = true;
               this.mimicPetTimer.reset();
               this.mimicPetTimer.start();
               this.mimicActionID = param2;
            }
         }
      }
      
      private function mimicPetTimerListener(param1:TimerEvent) : void
      {
         var _loc2_:Skill = null;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         this.mimicTimer.stop();
         switch(this.mimicActionID)
         {
            case PetBehaviours.WAVE_RIGHT:
            case PetBehaviours.WAVE_LEFT:
               _loc2_ = this.getSkillByID(PetSkillNames.WAVE);
               if(100 * Math.random() < _loc2_.obedience)
               {
                  this.pet.act(this.mimicActionID);
               }
               break;
            case PetBehaviours.JUMP:
               _loc2_ = this.getSkillByID(PetSkillNames.JUMP);
               if(100 * Math.random() < _loc2_.obedience)
               {
                  _loc4_ = 5 * this.getPerformanceFactor() * _loc2_.level * 0.02;
                  this.pet.act(PetBehaviours.JUMP,"" + _loc4_);
               }
               break;
            case PetBehaviours.SPIN:
            case PetBehaviours.JUMP_SPIN:
               _loc3_ = Utils.getRndInt(10,14);
               _loc2_ = this.getSkillByID(_loc3_);
               this.doIt(_loc2_);
         }
         this.mimicking = false;
      }
      
      public function goToPet(param1:Pet) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:String = null;
         this.greetOnArrival = true;
         var _loc4_:Number = param1.x;
         var _loc5_:Number = param1.z;
         var _loc6_:Number = _loc4_ - this.pet.x;
         var _loc7_:Number = _loc5_ - this.pet.z;
         var _loc8_:Number = Math.sqrt(_loc6_ * _loc6_ + _loc7_ * _loc7_);
         var _loc9_:Number = this.pet.scale * 150;
         if(_loc8_ > _loc9_)
         {
            _loc10_ = (_loc8_ - _loc9_) / _loc8_;
            _loc6_ *= _loc10_;
            _loc7_ *= _loc10_;
            _loc2_ = this.pet.x + _loc6_;
            _loc3_ = this.pet.z + _loc7_;
            this.travel(_loc2_,_loc3_,15);
         }
         else
         {
            _loc11_ = _loc4_ + "," + _loc5_;
            this.pet.act(PetBehaviours.TURN_TO_FACE,_loc11_);
         }
      }
      
      public function greet() : void
      {
         var _loc2_:Skill = null;
         var _loc3_:Number = NaN;
         this.greetOnArrival = false;
         var _loc1_:int = Utils.getRndInt(0,2);
         switch(_loc1_)
         {
            case 0:
               this.pet.act(PetBehaviours.WAVE_RIGHT);
               break;
            case 1:
               _loc2_ = this.getSkillByID(PetSkillNames.JUMP);
               _loc3_ = 5 * this.getPerformanceFactor() * _loc2_.level * 0.02;
               this.pet.act(PetBehaviours.JUMP,"" + _loc3_);
               break;
            case 2:
               this.doATrick();
         }
      }
      
      public function updateOwnerPos(param1:int, param2:Number, param3:Number) : void
      {
         if(this.summoned)
         {
            this.comeHere(param1,param2,param3);
         }
      }
      
      public function comeHere(param1:*, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(!this.pet.sleeping)
         {
            this.goto_locID = param1;
            _loc4_ = param2 - this.pet.x;
            _loc5_ = param3 - this.pet.z;
            _loc6_ = Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_);
            _loc7_ = this.pet.scale * 120;
            this.goto_x = param2 - _loc4_ * _loc7_ / _loc6_;
            this.goto_z = param3 - _loc5_ * _loc7_ / _loc6_;
            this.gotoLoc();
         }
      }
      
      public function goThere(param1:*, param2:Number, param3:Number) : void
      {
         if(!this.pet.sleeping)
         {
            this.goto_locID = param1;
            this.goto_x = param2;
            this.goto_z = param3;
            this.gotoLoc();
         }
      }
      
      public function ownerThrownBall() : void
      {
         if(!this.staying && this.ownerInView())
         {
            if(this.energy > 50)
            {
               this.reactionTimer.reset();
               this.reactionTimer.start();
            }
         }
      }
      
      private function reactToThrow(param1:TimerEvent = null) : void
      {
         var _loc2_:* = null;
         var _loc3_:Skill = null;
         var _loc5_:String = null;
         this.pet.setExpression(PetExpressions.HAPPY,true);
         var _loc4_:Number = this.getSkillLevel(PetSkillNames.THROW_TO_ME);
         if(_loc4_ > 1)
         {
            if(this.waiting)
            {
               _loc5_ = ",1";
               _loc3_ = this.skills[PetSkillNames.THROW_TO_ME];
            }
            else
            {
               if(Math.random() < 0.5)
               {
                  _loc5_ = ",0";
                  _loc3_ = this.skills[PetSkillNames.FETCH];
               }
               else
               {
                  _loc5_ = ",1";
                  _loc3_ = this.skills[PetSkillNames.THROW_TO_ME];
               }
               _loc5_ = Math.random() < 0.5 ? ",0" : ",1";
            }
            _loc2_ = this.pet.owner.x + "," + this.pet.owner.z + "," + this.pet.lastBallThrownByOwnerID + _loc5_ + "," + _loc4_;
            this.pet.act(PetBehaviours.FETCH,_loc2_);
         }
         else
         {
            _loc2_ = this.pet.owner.x + "," + this.pet.owner.z + "," + this.pet.lastBallThrownByOwnerID + ",0";
            this.pet.act(PetBehaviours.FETCH,_loc2_);
            _loc3_ = this.skills[PetSkillNames.FETCH];
         }
      }
      
      public function seekFood() : void
      {
         var _loc2_:Pos = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc1_:MovieClip = this.bin.nest.getPetBowl(this.pet.bowlID);
         if(_loc1_ != null)
         {
            this.pet.foodBowl = _loc1_;
            this.goto_locID = _loc1_.getLocID();
            _loc2_ = _loc1_.getPos();
            if(!this.pet.foodBowl.hitCheck(this.pet.x,this.pet.z))
            {
               this.goto_x = _loc2_.x;
               this.goto_z = _loc2_.z;
               _loc3_ = this.goto_x - this.pet.x;
               _loc4_ = this.goto_z - this.pet.z;
               _loc5_ = Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
               this.goto_x -= _loc3_ * 12 / _loc5_;
               this.goto_z -= _loc4_ * 12 / _loc5_;
               this.seekingFood = true;
               if(!this.pet.sleeping && !this.pet.exiting())
               {
                  this.gotoLoc();
               }
            }
            else
            {
               _loc6_ = _loc2_.x + "," + _loc2_.z;
               this.pet.act(PetBehaviours.TURN_TO_FACE,_loc6_);
               _loc6_ = String(this.pet.foodBowl.getFID());
               this.pet.act(PetBehaviours.EAT,_loc6_);
            }
         }
      }
      
      public function smellFood() : void
      {
         this.cancelSummon();
         this.foodDetected = true;
         if(!this.pet.sleeping)
         {
            this.pet.act(PetBehaviours.EXTEND_EYES,"4");
         }
         this.seekFood();
      }
      
      public function foodEaten() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         this.goto_locID = 0;
         this.foodDetected = false;
         this.fuel += 30;
         if(this.fuel > 100)
         {
            if(this.fuel > 120)
            {
               _loc1_ = this.fuel - 120;
               _loc2_ = -1 * _loc1_ * this.fitness * 0.001;
               this.addFitness(_loc2_);
               this.physEnergy -= _loc1_;
            }
            this.fuel = 100;
         }
         this.foodThoughtCounter = 40;
         this.sendUpdate();
      }
      
      private function gotoLoc(param1:Number = 0) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:Door = null;
         var _loc5_:LocNest = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(this.pet.loc.id < 100)
         {
            this.pet.ignoreCollisions = true;
         }
         if(this.foodDetected)
         {
            this.pet.setExpression(PetExpressions.TONG_OUT_HUNGRY,true);
         }
         if(this.pet.loc.id == this.goto_locID)
         {
            if(this.foodDetected)
            {
               this.pet.act(PetBehaviours.EXTEND_EYES,"4");
            }
            this.travel(this.goto_x,this.goto_z,0,param1);
         }
         else if(this.pet.loc.id < 100)
         {
            this.goto_loc = LocNest(this.bin.getLocById(this.goto_locID));
            this.gotoLoc_dx = Math.abs(LocNest(this.pet.loc).x - this.goto_loc.x);
            this.gotoLoc_dy = Math.abs(LocNest(this.pet.loc).y - this.goto_loc.y);
            this.gotoLoc_dz = Math.abs(LocNest(this.pet.loc).z - this.goto_loc.z);
            for each(_loc3_ in this.pet.loc.doors)
            {
               _loc2_ = int(_loc3_.toLoc);
               if(_loc2_ == this.goto_locID)
               {
                  _loc4_ = _loc3_;
                  break;
               }
               _loc5_ = LocNest(this.bin.getLocById(_loc2_));
               if(_loc5_ != null && _loc5_.loaded)
               {
                  _loc6_ = Math.abs(_loc5_.x - this.goto_loc.x);
                  _loc7_ = Math.abs(_loc5_.z - this.goto_loc.z);
                  if(this.gotoLoc_dz == 0)
                  {
                     if(_loc6_ < this.gotoLoc_dx)
                     {
                        _loc4_ = _loc3_;
                     }
                  }
                  else if(LocNest(this.pet.loc).x == 2)
                  {
                     if(_loc7_ < this.gotoLoc_dz)
                     {
                        _loc4_ = _loc3_;
                     }
                     else if(LocNest(this.pet.loc).z == 2 && _loc6_ < this.gotoLoc_dx)
                     {
                        _loc4_ = _loc3_;
                     }
                  }
                  else if(_loc5_.x == 2)
                  {
                     _loc4_ = _loc3_;
                  }
               }
            }
            if(_loc4_ == null)
            {
               for each(_loc3_ in this.pet.loc.doors)
               {
                  _loc2_ = int(_loc3_.toLoc);
                  if(this.bin.getLocById(_loc2_).loaded)
                  {
                     _loc4_ = _loc3_;
                  }
               }
            }
            if(_loc4_ != null)
            {
               this.pet.gotoDoor(_loc4_);
            }
         }
      }
      
      public function exert(param1:Number) : void
      {
         this.physEnergy -= param1 / this.fitness;
         param1 -= 200;
         this.fuel -= 0.001 * param1;
         if(param1 > this.fitness)
         {
            if(this.fitness < 45)
            {
               this.addFitness(0.0008 * (param1 - this.fitness));
            }
            else
            {
               this.addFitness(0.0003 * (param1 - this.fitness));
            }
         }
      }
      
      public function showMentalEnergy() : void
      {
         if(this.mentalEnergy > 80)
         {
            this.pet.setEyeExt(4,true);
         }
         else if(this.mentalEnergy > 50)
         {
            this.pet.setEyeExt(3,true);
         }
         else if(this.mentalEnergy > 40)
         {
            this.pet.setEyeExt(2,true);
         }
         else
         {
            this.pet.setEyeExt(1,true);
         }
      }
      
      public function update(param1:TimerEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc7_:MovieClip = null;
         this.rechargeRate = 1 + this.fitness * 0.02;
         var _loc2_:Number = this.pet.activityLvl;
         if(this.fuel > 0)
         {
            this.fuel -= _loc2_ * 0.05;
         }
         else
         {
            this.fuel = 0;
         }
         var _loc3_:Number = this.rechargeRate - 180 * _loc2_ / this.fitness;
         this.physEnergy += _loc3_;
         if(this.physEnergy < 0)
         {
            this.physEnergy = 0;
         }
         else if(this.physEnergy > 100)
         {
            this.physEnergy = 100;
         }
         if(this.mentalEnergy > 40)
         {
            if(this.fuel < 40)
            {
               if(this.energy > this.fuel && this.energy > 5)
               {
                  this.energy -= 2;
               }
            }
            else
            {
               this.energy = this.physEnergy;
            }
         }
         else if(this.energy > this.mentalEnergy && this.energy > 5)
         {
            this.energy -= 2;
         }
         if(this.pet.sleeping)
         {
            this.energy = this.mentalEnergy;
            if(this.mentalEnergy < 100)
            {
               this.mentalEnergy += 0.4;
            }
            else
            {
               this.mentalEnergy = 100;
               if(this.wokenThisSession)
               {
                  this.pet.act(PetBehaviours.WAKE_UP);
               }
               else if(this.fitness > 40)
               {
                  this.addFitness(-0.0001);
               }
            }
         }
         else
         {
            if(this.mentalEnergy > 1)
            {
               this.mentalEnergy -= 0.015;
            }
            if(this.physEnergy < 35)
            {
               if(!this.pet.panting)
               {
                  this.sendAction(-2,"-1");
                  this.pet.pant.init();
                  this.pet.panting = true;
               }
               if(this.physEnergy < 8)
               {
                  this.pet.abortActions();
               }
            }
            else if(this.pet.panting)
            {
               this.sendAction(-3,"-1");
               this.pet.panting = false;
               this.pet.pant.halt();
            }
            _loc4_ = int(this.pet.actions.length);
            if(_loc4_ == 0 && !this.pet.panting)
            {
               this.showMentalEnergy();
               if(this.bin.inNest || Math.random() < this.activityFactor)
               {
                  if(this.fuel < 40)
                  {
                     this.foodThoughts();
                  }
                  if(Math.random() < 0.4)
                  {
                     this.doStaticAction();
                  }
                  else if(!this.staying && !this.waiting && !this.mimicking)
                  {
                     if(240 * Math.random() < Math.min(this.energy,this.mentalEnergy))
                     {
                        this.doMove();
                     }
                     else
                     {
                        if(this.mentalEnergy < 30 && this.fuel < 40)
                        {
                           if(this.mentalEnergy < this.fuel)
                           {
                              _loc6_ = "goToBed";
                           }
                           else
                           {
                              _loc6_ = "lookForFood";
                           }
                        }
                        else if(this.mentalEnergy < 30)
                        {
                           _loc6_ = "goToBed";
                        }
                        else if(this.fuel < 40)
                        {
                           _loc6_ = "lookForFood";
                        }
                        switch(_loc6_)
                        {
                           case "goToBed":
                              this.lookForBed();
                              break;
                           case "lookForFood":
                              if(42 * Math.random() > this.fuel)
                              {
                                 _loc7_ = this.bin.nest.getPetBowl(this.pet.bowlID);
                                 if(_loc7_ != null)
                                 {
                                    if(!_loc7_.hitCheck(this.pet.x,this.pet.z))
                                    {
                                       this.pet.setExpression(PetExpressions.SAD,true);
                                       this.seekFood();
                                    }
                                    else
                                    {
                                       this.seekingFood = false;
                                       this.goto_locID = 0;
                                       this.foodDetected = false;
                                    }
                                 }
                              }
                        }
                     }
                  }
               }
            }
            _loc5_ = this.fitness * 0.015;
            if(_loc3_ < 0)
            {
               if(this.fitness < 100)
               {
                  if(this.fitness < 45)
                  {
                     this.addFitness(-0.03 * _loc3_);
                  }
                  else
                  {
                     this.addFitness(-0.01 * _loc3_);
                  }
               }
            }
            else if(this.fitness > 35)
            {
               if(this.fitness > 50)
               {
                  this.addFitness(-0.0003 * _loc3_);
               }
               else
               {
                  this.addFitness(-0.0001 * _loc3_);
               }
            }
         }
         this.bin.UI.updatePetStats(this.pet);
         this.updateCheck();
      }
      
      private function sendAction(param1:int, param2:String, param3:String = "-1") : void
      {
         if(!this._dormant)
         {
            this.bin.sendPetAction(this.pet.id,this.pet.loc.name,param1,param2,param3);
         }
      }
      
      private function foodThoughts() : void
      {
         this.foodThoughtCounter += 2;
         if(this.foodThoughtCounter > this.fuel)
         {
            this.pet.showThoughtBubble(PetThoughts.FOOD);
            this.foodThoughtCounter = 0;
         }
      }
      
      private function updateCheck() : void
      {
         ++this.updateCounter;
         if(this.updateCounter > 60)
         {
            this.updateCounter = 0;
            this.sendUpdate();
         }
         else if(int(this.experience) > this.experience_LU)
         {
            this.sendUpdate();
         }
      }
      
      private function sendUpdate() : void
      {
         this.fuel_LU = int(this.fuel);
         this.mentalEnergy_LU = int(this.mentalEnergy);
         this.fitness_LU = int(this.fitness);
         this.experience_LU = int(this.experience);
         var _loc1_:PHP2call = new PHP2call("pets/updatePetStats");
         var _loc2_:Array = ["petID","idx","fuel","mentalEnergy","fitness","experience"];
         var _loc3_:Array = [this.pet.id,this.bin.myUserIDX,this.fuel_LU,this.mentalEnergy_LU,this.fitness_LU,this.experience_LU];
         _loc1_.sendAndAwaitResponse(_loc2_,_loc3_,this.updatedPetStatsReceived,false,true);
      }
      
      private function updatedPetStatsReceived(param1:Object, param2:Event) : void
      {
         switch(param1.responseCode)
         {
            case 1:
            case 2:
            case 999:
         }
      }
   }
}

