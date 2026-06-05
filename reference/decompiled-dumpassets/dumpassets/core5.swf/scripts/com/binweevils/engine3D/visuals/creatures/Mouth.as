package com.binweevils.engine3D.visuals.creatures
{
   import com.binweevils.engine3D.*;
   import com.binweevils.engine3D.visuals.Element;
   import flash.display.*;
   
   public class Mouth extends Element
   {
      
      public var mc:MovieClip;
      
      private var container_spr:Sprite;
      
      private var mouths:Array;
      
      public function Mouth(param1:Array, param2:Number, param3:Number, param4:Number, param5:MovieClip, param6:int = 0, param7:Number = 1)
      {
         super(param2,param3,param4,param7);
         this.mouths = param1;
         this.mc = this.mouths[param6];
         this.container_spr = new Sprite();
         this.container_spr.addChild(this.mc);
         this.container_spr.mask = param5;
         d_o = this.container_spr;
         this.createHash(true);
      }
      
      override public function createHash(param1:Boolean = false) : void
      {
         hash = HashMouth.getHash(p,param1,scale);
         useHash = true;
      }
      
      public function setExpression(param1:int) : void
      {
         this.mc = this.mouths[param1];
         this.container_spr.removeChildAt(0);
         this.container_spr.addChild(this.mc);
      }
   }
}

