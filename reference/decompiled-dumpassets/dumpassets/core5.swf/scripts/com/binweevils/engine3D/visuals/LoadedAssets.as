package com.binweevils.engine3D.visuals
{
   import flash.display.DisplayObject;
   import flash.events.*;
   import flash.net.*;
   
   public class LoadedAssets
   {
      
      private static var assets:Array = [];
      
      public function LoadedAssets()
      {
         super();
      }
      
      public static function getAsset(param1:String) : DisplayObject
      {
         var _loc3_:* = undefined;
         var _loc4_:Class = null;
         var _loc5_:DisplayObject = null;
         var _loc2_:Boolean = false;
         for(_loc3_ in assets)
         {
            if(assets[_loc3_].path == param1)
            {
               _loc4_ = Object(assets[_loc3_].asset).constructor;
               return new _loc4_();
            }
         }
         return null;
      }
      
      public static function addAsset(param1:String, param2:DisplayObject) : void
      {
         var _loc4_:* = undefined;
         var _loc3_:Boolean = false;
         for(_loc4_ in assets)
         {
            if(assets[_loc4_].path == param1)
            {
               _loc3_ = true;
               break;
            }
         }
         if(!_loc3_)
         {
            assets.push(new LoadedAsset(param1,param2));
         }
      }
   }
}

