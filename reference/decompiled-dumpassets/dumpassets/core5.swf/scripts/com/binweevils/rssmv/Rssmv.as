package com.binweevils.rssmv
{
   import flash.display.MovieClip;
   import flash.net.SharedObject;
   
   public class Rssmv
   {
      
      private static var so:SharedObject;
      
      private static var vars:Array;
      
      private static var salt:String = "P07aJK8soogA815CxjkTcA==";
      
      public function Rssmv()
      {
         super();
         clearVars();
      }
      
      public static function o_1(param1:MovieClip) : String
      {
         so = SharedObject.getLocal("bw-li=sasdasd9283412o3ni423li4jn12l3kn4");
         var _loc2_:String = so.data.ky == null ? "" : so.data.ky;
         var _loc3_:* = salt;
         _loc3_ += param1.weevilName_txt.text;
         _loc3_ += param1.password_txt.text;
         _loc3_ += _loc2_;
         return getHashString(_loc3_);
      }
      
      public static function o_2(param1:Array) : String
      {
         var _loc2_:* = arrayToString(param1);
         return getHashString(salt + _loc2_);
      }
      
      public static function clearVars() : void
      {
         vars = [];
      }
      
      public static function addVar(param1:String) : void
      {
         vars.push(param1);
      }
      
      public static function getHashString(param1:String) : String
      {
         if(param1 == "")
         {
            return param1;
         }
         var _loc2_:Ne6 = new Ne6();
         return _loc2_.calculate(param1);
      }
      
      private static function arrayToString(param1:Array) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ += param1[_loc3_];
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

