package com.binweevils.engine3D.visuals.creatures.weevils
{
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.visuals.Element;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   
   public class Antenna extends Element
   {
      
      internal var ball:MovieClip;
      
      internal var stalk:Shape;
      
      private var p1:Vector3D;
      
      private var p2:Vector3D;
      
      private var crv:Vector3D;
      
      public function Antenna(param1:MovieClip, param2:int, param3:Vector3D, param4:Vector3D, param5:Vector3D)
      {
         var _loc6_:Sprite = null;
         super(param4.x,param4.y,param4.z);
         _loc6_ = new Sprite();
         d_o = _loc6_;
         this.ball = param1;
         clr = param2;
         var _loc7_:* = param2 >> 16;
         var _loc8_:* = param2 >> 8 & 0xFF;
         var _loc9_:* = param2 & 0xFF;
         this.ball.transform.colorTransform = new ColorTransform(1,1,1,1,_loc7_,_loc8_,_loc9_,0);
         this.stalk = new Shape();
         _loc6_.addChild(this.ball);
         _loc6_.addChild(this.stalk);
         this.p1 = param3;
         this.p2 = param4;
         this.crv = param5;
         this.createHash(true);
      }
      
      override public function createHash(param1:Boolean = false) : void
      {
         hash = HashAntenna.getHash(this.p1,this.p2,this.crv,param1);
         useHash = true;
      }
      
      public function setClr(param1:int) : void
      {
         clr = param1;
         var _loc2_:* = param1 >> 16;
         var _loc3_:* = param1 >> 8 & 0xFF;
         var _loc4_:* = param1 & 0xFF;
         this.ball.transform.colorTransform = new ColorTransform(1,1,1,1,_loc2_,_loc3_,_loc4_,0);
      }
   }
}

