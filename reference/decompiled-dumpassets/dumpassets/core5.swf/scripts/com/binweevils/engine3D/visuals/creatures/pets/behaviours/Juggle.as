package com.binweevils.engine3D.visuals.creatures.pets.behaviours
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.ViewPort;
   
   public class Juggle implements Behaviour
   {
      
      private var _id:int;
      
      private var _type:int;
      
      private var pet:Object;
      
      private var arm1:*;
      
      private var arm2:Object;
      
      private var hand1:*;
      
      private var hand2:Hand;
      
      private var nextHand:Hand;
      
      private var c:int;
      
      private var pattern:Array;
      
      private var patternPeriod:int;
      
      private var numBalls:int;
      
      private var nextBall:int;
      
      private var balls:Array;
      
      private var ballTracker:Array;
      
      private var currentThrow:int;
      
      public var throwCount:int;
      
      public var y0:Number;
      
      public var carryDist:Number;
      
      public var scoopDist:Number;
      
      public var handSpacing:Number;
      
      public var dwellTime:Number;
      
      public var beatLength:Number;
      
      private var pirouette:int;
      
      private var pirouetting:Boolean;
      
      public var errorThreshold:Number;
      
      public var dizzy:Number;
      
      private var juggle_orientation:Number;
      
      private var dropped:Boolean;
      
      private var loc:Object;
      
      public function Juggle(param1:int, param2:int, param3:Object, param4:Object, param5:Object)
      {
         super();
         this._id = param1;
         this._type = param2;
         this.pet = param3;
         this.arm1 = param4;
         this.arm2 = param5;
         this.hand1 = new Hand(this,this.pet,param4);
         this.hand2 = new Hand(this,this.pet,param5);
         this.beatLength = 9;
         this.dwellTime = 7;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function init(param1:Array = null) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:Ball = null;
         var _loc6_:Boolean = false;
         this.pet.y = this.pet.y0;
         this.pet.showMentalEnergy();
         this.loc = this.pet.loc;
         this.y0 = this.pet.scale * 41;
         this.pattern = param1[0].split("");
         this.patternPeriod = this.pattern.length;
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         for(_loc4_ in this.pattern)
         {
            switch(this.pattern[_loc4_])
            {
               case "a":
                  this.pattern[_loc4_] = 10;
                  break;
               case "b":
                  this.pattern[_loc4_] = 11;
            }
            _loc2_ += int(this.pattern[_loc4_]);
            if(this.pattern[_loc4_] > _loc3_)
            {
               _loc3_ = int(this.pattern[_loc4_]);
            }
         }
         this.numBalls = _loc2_ / this.patternPeriod;
         this.balls = this.pet.getNearestBalls(this.numBalls);
         for each(_loc5_ in this.balls)
         {
            _loc5_.gather(this.pet.x,this.pet.z);
            _loc5_.y = 0;
         }
         _loc6_ = param1[1] == 1 ? true : false;
         var _loc7_:Boolean = param1[2] == 1 ? true : false;
         var _loc8_:int = int(param1[3]);
         var _loc9_:int = int(param1[4]);
         this.beatLength = param1[5];
         this.c = this.beatLength - 1;
         this.pirouette = param1[6];
         var _loc10_:Number = param1[7] * this.pet.scale * 4.5;
         var _loc11_:Number = Number(param1[8]);
         this.pet.juggleAppeal = _loc11_ * (this.numBalls + _loc3_);
         this.dizzy = 1;
         if(_loc11_ > 20)
         {
            this.pet.setExpression(PetExpressions.NEUTRAL);
         }
         else
         {
            this.pet.setExpression(PetExpressions.MOUTH_OPEN);
         }
         this.ballTracker = [];
         this.currentThrow = 0;
         this.nextBall = 0;
         this.carryDist = this.pet.scale * 60;
         this.handSpacing = this.pet.scale * 160;
         this.errorThreshold = this.pet.scale * 32;
         this.pet.standSquare();
         this.juggle_orientation = this.pet.rotY;
         this.pet.activityLvl = this.numBalls * 0.25;
         if(this.pet.rotY == 0)
         {
            this.hand1.init(this.pet.x,this.pet.z,_loc10_,_loc11_,true,_loc6_,_loc8_);
            this.hand2.init(this.pet.x,this.pet.z,_loc10_,_loc11_,false,_loc7_,_loc9_);
         }
         else
         {
            this.hand1.init(this.pet.x,this.pet.z,_loc10_,_loc11_,false,_loc6_,_loc8_);
            this.hand2.init(this.pet.x,this.pet.z,_loc10_,_loc11_,true,_loc7_,_loc9_);
         }
         this.nextHand = this.hand1;
         this.dropped = false;
         this.throwCount = 0;
      }
      
      private function throwManager() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc1_:Ball = this.ballTracker.shift();
         var _loc2_:int = int(this.pattern[this.currentThrow]);
         if(_loc2_ != 0)
         {
            if(this.pet.rotY == this.juggle_orientation)
            {
               this.pirouetting = false;
               if(this.dizzy > 1)
               {
                  this.dizzy -= 0.1;
               }
               else
               {
                  this.dizzy = 1;
               }
               if(_loc1_ == null)
               {
                  _loc1_ = this.balls[this.nextBall];
                  ++this.nextBall;
               }
               this.ballTracker[_loc2_ - 1] = _loc1_;
               this.nextHand.throwBall(_loc1_,_loc2_);
               this.pet.look(-_loc2_ * 5,0);
            }
            else
            {
               this.dropAll();
            }
         }
         else if(this.pirouette > 0 && !this.pirouetting)
         {
            if(this.pattern[this.currentThrow + 1] == 0 && this.pattern[this.currentThrow + 2] == 0)
            {
               _loc3_ = 3;
               _loc4_ = this.currentThrow + 3;
               while(_loc4_ < this.pattern.length)
               {
                  if(this.pattern[_loc4_] != 0)
                  {
                     break;
                  }
                  _loc3_++;
                  _loc4_++;
               }
               this.pirouetting = true;
               _loc5_ = this.pirouette;
               if(_loc5_ == 720 && _loc3_ < 4)
               {
                  _loc5_ = 360;
               }
               _loc6_ = this.beatLength * _loc3_;
               if(_loc6_ > 39)
               {
                  _loc6_ = 39;
               }
               _loc7_ = _loc5_ * 2.45 / _loc6_;
               this.pet.act(PetBehaviours.PIROUETTE,_loc7_ + ",0.94," + _loc5_,false);
               this.dizzy = _loc5_ * 0.005;
            }
         }
         ++this.currentThrow;
         if(this.currentThrow == this.patternPeriod)
         {
            this.currentThrow = 0;
         }
         if(this.nextHand == this.hand1)
         {
            this.nextHand = this.hand2;
         }
         else
         {
            this.nextHand = this.hand1;
         }
      }
      
      public function setPose(param1:Number = 1, param2:Cam3D = null, param3:ViewPort = null) : void
      {
         var _loc4_:Ball = null;
         var _loc5_:Boolean = false;
         if(!this.dropped)
         {
            ++this.c;
            if(this.c == this.beatLength)
            {
               this.c = 0;
               this.throwManager();
            }
            this.hand1.update();
            this.hand2.update();
         }
         else
         {
            _loc5_ = false;
            for each(_loc4_ in this.balls)
            {
               _loc4_.drop();
               if(_loc4_.airBorn)
               {
                  _loc5_ = true;
               }
            }
            if(!_loc5_)
            {
               this.halt();
            }
         }
         for each(_loc4_ in this.balls)
         {
            _loc4_.update();
         }
      }
      
      public function dropAll() : void
      {
         this.dropped = true;
         this.arm1.setPose(0);
         this.arm2.setPose(0);
         this.pet.look(20,0);
         this.pet.act(PetBehaviours.LOOK_LEFT_RIGHT);
      }
      
      public function abort() : void
      {
         this.dropAll();
      }
      
      public function halt() : void
      {
         var _loc1_:Ball = null;
         this.pet.look(0,0);
         this.pet.baseRate();
         this.pet.juggleAppeal = 0;
         for each(_loc1_ in this.balls)
         {
            _loc1_.drop();
         }
         this.pet.stopAction(this.id);
         this.pet.improveJugglingSkill(this.throwCount);
      }
   }
}

