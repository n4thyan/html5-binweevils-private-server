package com.binweevils.engine3D.visuals.creatures.weevils
{
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.visuals.Element;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class Eye extends Element
   {
      
      public static var toDegr:Number = 180 / Math.PI;
      
      public static var toRads:Number = Math.PI / 180;
      
      internal var white_mc:MovieClip;
      
      internal var iris_mc:MovieClip;
      
      internal var lid_mc:MovieClip;
      
      private var dir:Vector3D;
      
      private var hashX:Array;
      
      private var hashY:Array;
      
      private var hashDpth:Array;
      
      private var hashScl:Array;
      
      private var hashR:Array;
      
      private var hashF:Array;
      
      private var hashF2:Array;
      
      private var hashR2:Array;
      
      private var hashXscl:Array;
      
      public function Eye(param1:MovieClip, param2:MovieClip, param3:MovieClip, param4:Vector3D, param5:Vector3D, param6:Number = 1)
      {
         super(param4.x,param4.y,param4.z,param6);
         d_o = new Sprite();
         this.white_mc = param1;
         this.iris_mc = param2;
         this.lid_mc = param3;
         d_o.addChild(param1);
         d_o.addChild(param2);
         if(this.lid_mc != null)
         {
            d_o.addChild(param3);
         }
         p = param4;
         this.dir = param5;
         this.createHash(true);
      }
      
      override public function createHash(param1:Boolean = false) : void
      {
         hash = HashEye.getHash(p,this.dir,param1,scale);
         useHash = true;
      }
   }
}

