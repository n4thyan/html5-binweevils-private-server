package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Vector3D;
   import de.polygonal.ds.Array2;
   import flash.display.DisplayObject;
   
   public class Hash1 extends Hash
   {
      
      private static var h:Array = new Array();
      
      private var p0:Vector3D;
      
      public var x:Array2;
      
      public var y:Array2;
      
      public var dpth:Array2;
      
      public var scl:Array2;
      
      public function Hash1(param1:Vector3D, param2:Boolean)
      {
         var _loc4_:int = 0;
         var _loc5_:Vector3D = null;
         var _loc6_:Number = NaN;
         super(param2);
         this.p0 = param1;
         this.x = new Array2(11,36);
         this.y = new Array2(11,36);
         this.dpth = new Array2(11,36);
         this.scl = new Array2(11,36);
         var _loc3_:int = 0;
         while(_loc3_ < 11)
         {
            _loc4_ = 0;
            while(_loc4_ <= 36)
            {
               positionCamera(_loc3_,_loc4_);
               _loc5_ = getTransform(param1);
               _loc6_ = get_p_ratio(_loc5_);
               this.x.set(_loc3_,_loc4_,_loc5_.x * _loc6_ * sf);
               this.y.set(_loc3_,_loc4_,-_loc5_.y * _loc6_ * sf);
               this.dpth.set(_loc3_,_loc4_,-_loc5_.z - d0);
               this.scl.set(_loc3_,_loc4_,_loc6_ * sf);
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      public static function getHash(param1:Vector3D, param2:Boolean) : Hash1
      {
         var _loc3_:Hash1 = null;
         for each(_loc3_ in h)
         {
            if(_loc3_.p0.isEqual(param1))
            {
               return _loc3_;
            }
         }
         _loc3_ = new Hash1(param1,param2);
         h.push(_loc3_);
         return _loc3_;
      }
      
      override public function setProps(param1:Element, param2:int, param3:int, param4:Boolean = false, param5:int = 0) : void
      {
         var _loc6_:Number = NaN;
         if(param2 > 10)
         {
            param2 = 10;
         }
         else if(param2 < 0)
         {
            param2 = 0;
         }
         if(param3 > 36)
         {
            param3 = 72 - param3;
            _loc6_ = -this.x.get(param2,param3);
         }
         else
         {
            _loc6_ = this.x.get(param2,param3);
         }
         var _loc7_:DisplayObject = param1.d_o;
         _loc7_.x = _loc6_;
         _loc7_.y = this.y.get(param2,param3);
         _loc7_.scaleX = _loc7_.scaleY = this.scl.get(param2,param3);
         param1.depth = this.dpth.get(param2,param3);
      }
   }
}

