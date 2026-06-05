package com.binweevils.engine3D.visuals
{
   import flash.display.DisplayObject;
   
   public class LoadedAsset
   {
      
      public var path:String;
      
      public var asset:DisplayObject;
      
      public function LoadedAsset(param1:String, param2:DisplayObject)
      {
         super();
         this.path = param1;
         this.asset = param2;
      }
   }
}

