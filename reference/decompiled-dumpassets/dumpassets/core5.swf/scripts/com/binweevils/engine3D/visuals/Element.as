package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.round;
   import flash.display.Sprite;
   
   public class Element
   {
      
      public var d_o:Sprite;
      
      protected var p:Vector3D;
      
      protected var scale:Number;
      
      public var rotX:int;
      
      public var rotY:int;
      
      public var depth:Number;
      
      protected var hash:Hash;
      
      protected var useHash:Boolean;
      
      protected var clr:int;
      
      public function Element(param1:Number, param2:Number, param3:Number, param4:Number = 1, param5:Number = 0)
      {
         super();
         this.set_p(new Vector3D(param1,param2,param3));
         this.set_scale(param4);
         this.rotX = 0;
         this.rotY = param5;
         this.depth = -param3;
      }
      
      public function createHash(param1:Boolean = false) : void
      {
         this.hash = Hash1.getHash(this.p,param1);
         this.useHash = true;
      }
      
      public function set_p(param1:Vector3D) : void
      {
         this.p = param1;
      }
      
      public function set x(param1:Number) : void
      {
         this.p.x = param1;
      }
      
      public function set y(param1:Number) : void
      {
         this.p.y = param1;
      }
      
      public function set z(param1:Number) : void
      {
         this.p.z = param1;
      }
      
      public function get x() : Number
      {
         return this.p.x;
      }
      
      public function get y() : Number
      {
         return this.p.y;
      }
      
      public function get z() : Number
      {
         return this.p.z;
      }
      
      public function set vis(param1:*) : void
      {
         this.d_o.visible = param1;
      }
      
      public function set_coords(param1:Number, param2:Number, param3:Number) : void
      {
         this.p.x = param1;
         this.p.y = param2;
         this.p.z = param3;
      }
      
      public function set_scale(param1:Number) : void
      {
         this.scale = param1;
      }
      
      public function setViewAngle(param1:Number, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.useHash)
         {
            if(param2 < 0)
            {
               param2 += 360;
            }
            else if(param2 > 360)
            {
               param2 -= 360;
            }
            _loc3_ = round(0.2 * param1);
            _loc4_ = round(0.2 * param2);
            this.hash.setProps(this,_loc3_,_loc4_,false,this.clr);
         }
      }
   }
}

