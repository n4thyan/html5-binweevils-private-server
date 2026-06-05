package com.binweevils.engine3D.visuals.creatures.pets.behaviours
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.ViewPort;
   import flash.display.DisplayObject;
   
   public class Pant implements Behaviour
   {
      
      private var _id:int;
      
      private var _type:int;
      
      private var pet:Object;
      
      private var creature_d_o:DisplayObject;
      
      private var c:Number;
      
      public function Pant(param1:int, param2:int, param3:Object)
      {
         super();
         this._id = param1;
         this._type = param2;
         this.pet = param3;
         this.creature_d_o = this.pet.creature.d_o;
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
         this.c = 0;
      }
      
      public function setPose(param1:Number = 1, param2:Cam3D = null, param3:ViewPort = null) : void
      {
         var _loc4_:Number = Math.sin(this.c);
         this.creature_d_o.scaleX = 1 + 0.05 * _loc4_;
         this.c += 0.18;
         if(_loc4_ > 0)
         {
            this.pet.setExpression(PetExpressions.MOUTH_WIDE_OPEN);
            this.pet.setEyeExt(0);
         }
         else
         {
            this.pet.setExpression(PetExpressions.MOUTH_OPEN);
            this.pet.setEyeExt(1);
         }
      }
      
      public function abort() : void
      {
         this.halt();
      }
      
      public function halt() : void
      {
         this.creature_d_o.scaleX = 1;
         this.pet.setEyeExt(2);
         this.pet.setExpression(PetExpressions.NEUTRAL);
      }
   }
}

