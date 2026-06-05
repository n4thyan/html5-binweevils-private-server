package com.binweevils
{
   import com.binweevils.conf.*;
   import com.binweevils.utilities.*;
   import flash.events.*;
   import it.gotoandplay.smartfoxserver.*;
   import it.gotoandplay.smartfoxserver.data.*;
   
   public class TycoonBusinessesList
   {
      
      private var bin:Object;
      
      private var _ssclient:Object;
      
      private var businessListArray:Array;
      
      private var host:UImain;
      
      private var weevilName:String;
      
      private var weevilIDX:int;
      
      public function TycoonBusinessesList()
      {
         super();
      }
      
      public function TycoonBusinesses() : *
      {
      }
      
      public function loadList(param1:UImain, param2:String, param3:int) : void
      {
         this.bin = Bin_extInterface.bin;
         this._ssclient = this.bin.get_ssclient();
         this.host = param1;
         this.weevilName = param2;
         this.weevilIDX = param3;
         this._ssclient.addEventListener(SFSEvent.onExtensionResponse,this.onListExtensionResponse,false,0,true);
         this.businessListArray = [];
         this._ssclient.sendGetBusinesses();
      }
      
      private function createList(param1:String) : *
      {
         var _loc4_:String = null;
         if(param1 == "-1")
         {
            return;
         }
         var _loc2_:Array = param1.split(MessageProtocol.SEPARATOR_LEVEL_2);
         var _loc3_:int = 0;
         for each(_loc4_ in _loc2_)
         {
            this.businessListArray[_loc3_] = _loc4_.split(MessageProtocol.SEPARATOR_LEVEL_1);
            _loc3_++;
         }
      }
      
      public function isBusinessOpen() : Boolean
      {
         var _loc3_:String = null;
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         while(_loc2_ < this.businessListArray.length)
         {
            _loc3_ = this.businessListArray[_loc2_][0];
            if(this.businessListArray[_loc2_][1] != "0" && _loc3_ == this.weevilName)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function isPhotoStudioOpen() : Boolean
      {
         var _loc3_:String = null;
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         while(_loc2_ < this.businessListArray.length)
         {
            _loc3_ = this.businessListArray[_loc2_][0];
            if(this.businessListArray[_loc2_][1].indexOf("7") != -1 && _loc3_ == this.weevilName)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function onListExtensionResponse(param1:SFSEvent) : void
      {
         var _loc2_:Array = param1.params.dataObj;
         var _loc3_:String = MessageProtocol.getCommmandName(_loc2_[0]);
         var _loc4_:String = MessageProtocol.getCommmandRest(_loc2_[0]);
         switch(_loc3_)
         {
            case MessageProtocol.BUSINESS_MODULE_NAME:
               switch(_loc4_)
               {
                  case MessageProtocol.BUSINESS_MODULE_GET_BUSINESS_LIST:
                     this.createList(_loc2_[2]);
                     break;
                  case MessageProtocol.BUSINESS_MODULE_GET_PLAZA_AVAILABILITY:
               }
         }
      }
   }
}

