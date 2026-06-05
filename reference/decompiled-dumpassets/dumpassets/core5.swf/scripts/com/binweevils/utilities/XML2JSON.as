package com.binweevils.utilities
{
   public class XML2JSON
   {
      
      private static var _arrays:Array;
      
      public function XML2JSON()
      {
         super();
      }
      
      public static function parse(param1:*) : Object
      {
         var _loc5_:* = undefined;
         var _loc6_:String = null;
         var _loc7_:* = undefined;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc2_:Object = {};
         var _loc3_:int = int(param1.children().length());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.children()[_loc4_];
            _loc6_ = _loc5_.name();
            if(_loc5_.children().length() == 1 && _loc5_.children()[0].name() == null)
            {
               if(_loc5_.attributes().length() > 0)
               {
                  _loc7_ = {"_content":_loc5_.children()[0].toString()};
                  _loc8_ = int(_loc5_.attributes().length());
                  _loc9_ = 0;
                  while(_loc9_ < _loc8_)
                  {
                     _loc7_[_loc5_.attributes()[_loc9_].name().toString()] = _loc5_.attributes()[_loc9_];
                     _loc9_++;
                  }
               }
               else
               {
                  _loc7_ = _loc5_.children()[0].toString();
               }
            }
            else
            {
               _loc7_ = parse(_loc5_);
            }
            if(_loc2_[_loc6_])
            {
               if(getTypeof(_loc2_[_loc6_]) == "array")
               {
                  _loc2_[_loc6_].push(_loc7_);
               }
               else
               {
                  _loc2_[_loc6_] = [_loc2_[_loc6_],_loc7_];
               }
            }
            else if(isArray(_loc6_))
            {
               _loc2_[_loc6_] = [_loc7_];
            }
            else
            {
               _loc2_[_loc6_] = _loc7_;
            }
            _loc4_++;
         }
         _loc8_ = int(param1.attributes().length());
         _loc4_ = 0;
         while(_loc4_ < _loc8_)
         {
            _loc2_[param1.attributes()[_loc4_].name().toString()] = param1.attributes()[_loc4_];
            _loc4_++;
         }
         if(_loc3_ == 0)
         {
            if(_loc8_ == 0)
            {
               _loc2_ = "";
            }
            else
            {
               _loc2_._content = "";
            }
         }
         return _loc2_;
      }
      
      public static function get arrays() : Array
      {
         if(!_arrays)
         {
            _arrays = [];
         }
         return _arrays;
      }
      
      public static function set arrays(param1:Array) : void
      {
         _arrays = param1;
      }
      
      private static function isArray(param1:String) : Boolean
      {
         var _loc2_:int = _arrays ? int(_arrays.length) : 0;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == _arrays[_loc3_])
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private static function getTypeof(param1:*) : String
      {
         if(typeof param1 == "object")
         {
            if(param1.length == null)
            {
               return "object";
            }
            if(typeof param1.length == "number")
            {
               return "array";
            }
            return "object";
         }
         return typeof param1;
      }
   }
}

