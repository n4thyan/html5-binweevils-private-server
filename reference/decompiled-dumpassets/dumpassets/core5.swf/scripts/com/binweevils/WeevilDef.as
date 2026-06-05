package com.binweevils
{
   public class WeevilDef
   {
      
      private static var clrs1:Array = [10027008,43520,153,10057472,8913032,11198463,26367,16750848,13421568,61166,13369548,16777215,16766429,11206400,16763904,15658496,16745604,2631720,10066329,16777145,15597568,26112,1184274,12733185,16736768,16425579,16767167,7620096,16771473,6394113,8899328,14548127,62720,11993014,25670,110971,61093,7011535,25219,50886,10289151,2797311,3014772,5243334,8334079,14138879,16729855,16756735,11338573,15597672,15952037,16757203];
      
      private static var clrs2:Array = [52224,4474077,15610675,13421568,52428,13369548,8943360,2136473,11206400,16763904,15658496,16745604,10027008,15597568,16766429,12733185,16736768,16425579,16767167,7620096,16750848,16771473,10057472,16777145,6394113,8899328,11206400,14548127,26112,43520,62720,11993014,25670,110971,61093,7011535,25219,50886,61166,10289151,153,26367,2797311,11198463,3014772,5243334,8334079,14138879,8913032,16729855,16756735,11338573,15597672,15952037,16757203,10066329,16777215,2631720];
      
      public function WeevilDef()
      {
         super();
      }
      
      public static function getDefObj(param1:String) : Object
      {
         var _loc2_:Object = new Object();
         _loc2_.ht = param1.substr(0,1);
         _loc2_.hc = clrs1[int(param1.substr(1,2))];
         _loc2_.bt = param1.substr(3,1);
         _loc2_.bc = clrs1[int(param1.substr(4,2))];
         _loc2_.et = param1.substr(6,1);
         _loc2_.ec = clrs2[int(param1.substr(7,2))];
         _loc2_.lids = param1.substr(9,1);
         _loc2_.at = param1.substr(10,2);
         _loc2_.ac = clrs1[int(param1.substr(12,2))];
         _loc2_.lc = clrs1[int(param1.substr(14,2))];
         _loc2_.lt = param1.substr(16,2);
         return _loc2_;
      }
      
      public static function getDefStr(param1:Object) : String
      {
         var _loc2_:String = param1.ht;
         _loc2_ += getClrIndex(1,param1.hc);
         _loc2_ += param1.bt;
         _loc2_ += getClrIndex(1,param1.bc);
         _loc2_ += param1.et;
         _loc2_ += getClrIndex(2,param1.ec);
         _loc2_ += param1.lids;
         var _loc3_:String = "";
         if(int(param1.at) < 10)
         {
            _loc3_ = "0";
         }
         _loc2_ += _loc3_ + String(int(param1.at));
         _loc2_ += getClrIndex(1,param1.ac);
         _loc2_ += getClrIndex(1,param1.lc);
         _loc3_ = "";
         if(int(param1.lt) < 10)
         {
            _loc3_ = "0";
         }
         return _loc2_ + (_loc3_ + String(int(param1.lt)));
      }
      
      private static function getClrIndex(param1:int, param2:int) : String
      {
         var _loc3_:Array = null;
         switch(param1)
         {
            case 1:
               _loc3_ = clrs1;
               break;
            case 2:
               _loc3_ = clrs2;
         }
         var _loc4_:int = -1;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_[_loc5_] == param2)
            {
               _loc4_ = _loc5_;
               break;
            }
            _loc5_++;
         }
         if(_loc4_ >= 0 && _loc4_ < 10)
         {
            return "0" + String(_loc4_);
         }
         return String(_loc4_);
      }
   }
}

