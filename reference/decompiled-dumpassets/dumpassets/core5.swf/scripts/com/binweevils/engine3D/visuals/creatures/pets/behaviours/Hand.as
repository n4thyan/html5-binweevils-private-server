package com.binweevils.engine3D.visuals.creatures.pets.behaviours
{
   import com.binweevils.engine3D.Vector3D;
   
   public class Hand
   {
      
      private var juggle:Juggle;
      
      private var ball:Ball;
      
      private var pet:Object;
      
      private var arm:Object;
      
      private var petX:*;
      
      private var petZ:Number;
      
      private var errorMargin:Number;
      
      private var errorIncr:Number;
      
      private var saveThreshold:Number;
      
      private var theta:Number;
      
      private var thetaIncr:Number;
      
      private var xIncr:Number;
      
      private var beats:int;
      
      private var p:Array;
      
      private var LHS:Boolean;
      
      private var reverse:Boolean;
      
      private var throwWidth:int;
      
      private var receiveWide:Boolean;
      
      private var saved:Boolean;
      
      private var concentrate:Boolean;
      
      private var c:int;
      
      public function Hand(param1:Juggle, param2:Object, param3:Object)
      {
         super();
         this.juggle = param1;
         this.pet = param2;
         this.arm = param3;
         this.p = new Array();
         this.p[0] = new Vector3D(0,4.5,0);
         this.p[1] = new Vector3D(0,1,0);
         this.p[2] = new Vector3D(0,0.7,0);
         this.p[3] = new Vector3D(0,4.5,0);
      }
      
      public function init(param1:Number, param2:Number, param3:Number, param4:Number, param5:Boolean, param6:Boolean, param7:int = 0) : void
      {
         var _loc9_:Number = NaN;
         var _loc10_:* = undefined;
         this.petX = param1;
         this.petZ = param2;
         this.LHS = param5;
         this.reverse = param6;
         this.throwWidth = param7;
         this.errorMargin = param3;
         this.errorIncr = 10 * this.errorMargin / param4;
         this.saveThreshold = 86 * this.pet.scale;
         var _loc8_:int = 1;
         if(this.LHS)
         {
            _loc8_ = -1;
         }
         this.p[0].x = _loc8_ * 0.5 * this.juggle.handSpacing;
         this.p[1].x = 0.81 * this.p[0].x;
         this.p[2].x = 0.52 * this.p[0].x;
         this.p[3].x = _loc8_ * (0.5 * this.juggle.handSpacing - this.juggle.carryDist);
         this.p[0].y = this.pet.scale * 41;
         this.p[1].y = this.pet.scale * 9.1;
         this.p[2].y = this.pet.scale * 6.4;
         this.p[3].y = this.pet.scale * 41;
         if(this.pet.rotY == 0)
         {
            _loc9_ = -this.pet.scale * 36.4;
         }
         else
         {
            _loc9_ = this.pet.scale * 36.4;
         }
         for(_loc10_ in this.p)
         {
            this.p[_loc10_].z = param2 + _loc9_;
         }
         this.concentrate = false;
      }
      
      public function setThrowCatchStyle(param1:Hand) : void
      {
         if(param1.throwWidth == 1)
         {
            this.receiveWide = true;
         }
         else if(param1.reverse)
         {
            this.receiveWide = false;
         }
         else if(param1.throwWidth == -1)
         {
            this.receiveWide = false;
         }
         else
         {
            this.receiveWide = true;
         }
      }
      
      public function throwBall(param1:Ball, param2:Number) : void
      {
         this.ball = param1;
         this.ball.z = this.p[0].z;
         this.beats = param2;
         this.c = 1;
      }
      
      public function update() : void
      {
         if(this.reverse)
         {
            if(this.receiveWide)
            {
               switch(this.c)
               {
                  case 0:
                     break;
                  case 1:
                     this.saved = this.saveBall();
                     if(this.saved)
                     {
                        this.arm.setPose(19);
                     }
                     else
                     {
                        this.arm.setPose(15);
                     }
                     break;
                  case 2:
                     if(this.saved)
                     {
                        if(this.pet.x != this.petX)
                        {
                           this.pet.x = 0.5 * (this.pet.x + this.petX);
                        }
                     }
                     else
                     {
                        this.arm.setPose(16);
                        this.ball.x = this.petX + this.p[1].x;
                        this.ball.y = this.p[1].y;
                        this.ball.z = this.p[1].z;
                     }
                     break;
                  case 4:
                     this.pet.x = this.petX;
                     this.arm.setPose(16);
                     this.ball.x = this.petX + this.p[1].x;
                     this.ball.y = this.p[1].y;
                     this.ball.z = this.p[1].z;
                     break;
                  case 6:
                     if(this.beats * this.juggle.beatLength > 45)
                     {
                        this.arm.setPose(22);
                     }
                     else
                     {
                        this.arm.setPose(15);
                     }
                     this.ball.x = this.petX + this.p[0].x;
                     this.ball.y = this.p[0].y;
                     break;
                  case 8:
                     if(this.beats * this.juggle.beatLength > 50)
                     {
                        this.pet.creature.d_o.scaleY = 1 + this.beats * 0.008;
                        this.pet.y = this.pet.y0 * this.pet.creature.d_o.scaleY;
                     }
                     if(this.pet.panting)
                     {
                        this.errorMargin *= 1.3;
                     }
                     this.errorMargin += this.errorIncr;
                     this.ball.launch(this.beats,this.LHS,true,this.throwWidth,this.errorMargin * this.juggle.dizzy);
                     break;
                  case 10:
                     if(this.beats >= 7)
                     {
                        this.pet.creature.d_o.scaleY = 1;
                        this.pet.y = this.pet.y0;
                     }
                     this.arm.setPose(17);
                     break;
                  case 13:
                     this.c = 0;
                     this.arm.setPose(15);
               }
            }
            else
            {
               switch(this.c)
               {
                  case 0:
                     break;
                  case 1:
                     this.saved = this.saveBall();
                     if(this.saved)
                     {
                        this.arm.setPose(19);
                     }
                     else
                     {
                        this.arm.setPose(18);
                     }
                     break;
                  case 2:
                     if(this.saved)
                     {
                        if(this.pet.x != this.petX)
                        {
                           this.pet.x = 0.5 * (this.pet.x + this.petX);
                        }
                     }
                     else
                     {
                        this.arm.setPose(0);
                        this.ball.x = this.petX + this.p[2].x;
                        this.ball.y = this.p[2].y;
                        this.ball.z = this.p[2].z;
                     }
                     break;
                  case 4:
                     this.pet.x = this.petX;
                     this.arm.setPose(16);
                     this.ball.x = this.petX + this.p[1].x;
                     this.ball.y = this.p[1].y;
                     this.ball.z = this.p[1].z;
                     break;
                  case 6:
                     if(this.beats * this.juggle.beatLength > 45)
                     {
                        this.arm.setPose(22);
                     }
                     else
                     {
                        this.arm.setPose(15);
                     }
                     this.ball.x = this.petX + this.p[0].x;
                     this.ball.y = this.p[0].y;
                     break;
                  case 8:
                     if(this.beats * this.juggle.beatLength > 50)
                     {
                        this.pet.creature.d_o.scaleY = 1 + this.beats * 0.008;
                        this.pet.y = this.pet.y0 * this.pet.creature.d_o.scaleY;
                     }
                     if(this.pet.panting)
                     {
                        this.errorMargin *= 1.3;
                     }
                     this.errorMargin += this.errorIncr;
                     this.ball.launch(this.beats,this.LHS,true,this.throwWidth,this.errorMargin * this.juggle.dizzy);
                     break;
                  case 10:
                     if(this.beats >= 7)
                     {
                        this.pet.creature.d_o.scaleY = 1;
                        this.pet.y = this.pet.y0;
                     }
                     this.arm.setPose(17);
                     break;
                  case 13:
                     this.c = 0;
                     this.arm.setPose(18);
               }
            }
         }
         else
         {
            switch(this.c)
            {
               case 0:
                  break;
               case 1:
                  this.saved = this.saveBall();
                  if(this.saved)
                  {
                     this.arm.setPose(19);
                  }
                  else
                  {
                     this.arm.setPose(15);
                  }
                  break;
               case 2:
                  if(this.saved)
                  {
                     if(this.pet.x != this.petX)
                     {
                        this.pet.x = 0.5 * (this.pet.x + this.petX);
                     }
                  }
                  else
                  {
                     this.arm.setPose(16);
                     this.ball.x = this.petX + this.p[1].x;
                     this.ball.y = this.p[1].y;
                     this.ball.z = this.p[1].z;
                  }
                  break;
               case 4:
                  this.pet.x = this.petX;
                  this.arm.setPose(0);
                  this.ball.x = this.petX + this.p[2].x;
                  this.ball.y = this.p[2].y;
                  this.ball.z = this.p[2].z;
                  break;
               case 6:
                  if(this.beats >= 7)
                  {
                     this.arm.setPose(23);
                  }
                  else
                  {
                     this.arm.setPose(18);
                  }
                  this.ball.x = this.petX + this.p[3].x;
                  this.ball.y = this.p[3].y;
                  break;
               case 8:
                  if(this.beats * this.juggle.beatLength > 45)
                  {
                     this.pet.creature.d_o.scaleY = 1 + this.beats * 0.008;
                     this.pet.y = this.pet.y0 * this.pet.creature.d_o.scaleY;
                  }
                  if(this.pet.panting)
                  {
                     this.errorMargin *= 1.3;
                  }
                  this.errorMargin += this.errorIncr;
                  this.ball.launch(this.beats,this.LHS,false,this.throwWidth,this.errorMargin * this.juggle.dizzy);
                  break;
               case 10:
                  if(this.beats * this.juggle.beatLength > 50)
                  {
                     this.pet.creature.d_o.scaleY = 1;
                     this.pet.y = this.pet.y0;
                  }
                  this.arm.setPose(17);
                  break;
               case 13:
                  this.c = 0;
                  this.arm.setPose(15);
            }
         }
         if(this.c > 0)
         {
            ++this.c;
         }
      }
      
      private function saveBall() : Boolean
      {
         var _loc1_:Number = this.ball.x - this.petX;
         if(this.LHS)
         {
            if(_loc1_ < -this.saveThreshold)
            {
               this.arm.setPose(19);
               this.concentrate = true;
               this.pet.setExpression(PetExpressions.MOUTH_WIDE_OPEN);
               return true;
            }
         }
         else if(_loc1_ > this.saveThreshold)
         {
            this.arm.setPose(19);
            this.pet.setExpression(PetExpressions.MOUTH_WIDE_OPEN);
            return true;
         }
         if(this.concentrate)
         {
            this.pet.setExpression(PetExpressions.MOUTH_OPEN);
         }
         return false;
      }
   }
}

