package com.binweevils
{
   import fl.containers.ScrollPane;
   import flash.display.Sprite;
   
   public class UserList
   {
      
      private var _UI:UImain;
      
      public var listType:int;
      
      private var list_spr:Sprite;
      
      private var listItems:Array;
      
      private var scrollPane:ScrollPane;
      
      public var hiliR:*;
      
      public var hiliG:*;
      
      public var hiliB:int;
      
      public function UserList(param1:UImain, param2:ScrollPane, param3:int, param4:int = 0, param5:int = 0, param6:int = 0)
      {
         super();
         this._UI = param1;
         this.scrollPane = param2;
         this.listType = param3;
         this.listItems = new Array();
         this.list_spr = new Sprite();
         this.hiliR = param4;
         this.hiliG = param5;
         this.hiliB = param6;
      }
      
      public function populate(param1:Array) : void
      {
         var _loc2_:ListedUser = null;
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         this.cleanUpList();
         for(_loc4_ in param1)
         {
            _loc3_ = param1[_loc4_];
            if(_loc3_ != null && !this.onList(_loc3_.name))
            {
               _loc2_ = new ListedUser(this,_loc3_.name,_loc3_.isOnline);
               _loc2_.updateVars(_loc3_.variables);
               this.listItems.push(_loc2_);
               this.list_spr.addChild(_loc2_.spr);
            }
         }
         this.sortList();
      }
      
      public function populate2(param1:Array) : void
      {
         var _loc2_:ListedUser = null;
         var _loc3_:* = undefined;
         this.cleanUpList();
         for(_loc3_ in param1)
         {
            if(param1[_loc3_] != null && !this.onList(param1[_loc3_]))
            {
               _loc2_ = new ListedUser(this,param1[_loc3_],true);
               this.listItems.push(_loc2_);
               this.list_spr.addChild(_loc2_.spr);
            }
         }
         this.sortList();
      }
      
      public function cleanUpList() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.listItems)
         {
            this.listItems[_loc1_].remove();
            this.list_spr.removeChild(this.listItems[_loc1_].spr);
         }
         this.listItems = [];
      }
      
      public function set vis(param1:Boolean) : void
      {
         this.list_spr.visible = param1;
         this.scrollPane.visible = param1;
      }
      
      public function addUser(param1:String) : void
      {
         var _loc2_:ListedUser = null;
         if(this.getUserByName(param1) == null)
         {
            _loc2_ = new ListedUser(this,param1,true);
            this.listItems.push(_loc2_);
            this.list_spr.addChild(_loc2_.spr);
            this.sortList();
         }
      }
      
      public function removeUser(param1:String) : void
      {
         var _loc2_:int = int(this.listItems.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.listItems[_loc3_].userName == param1)
            {
               this.listItems[_loc3_].remove();
               this.list_spr.removeChild(this.listItems[_loc3_].spr);
               this.listItems.splice(_loc3_,1);
               this.sortList();
               break;
            }
            _loc3_++;
         }
      }
      
      private function sortList() : void
      {
         this.listItems.sortOn("userName");
         var _loc1_:int = int(this.listItems.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this.listItems[_loc2_].spr.y = 19 * _loc2_;
            _loc2_++;
         }
         this.scrollPane.source = this.list_spr;
      }
      
      public function updateUserStatus(param1:String, param2:Boolean, param3:Object = null) : void
      {
         var _loc4_:ListedUser = this.getUserByName(param1);
         if(_loc4_ != null)
         {
            _loc4_.setOnlineStatus(param2);
            if(param3 != null)
            {
               _loc4_.updateVars(param3);
            }
         }
      }
      
      public function highlightUser(param1:String, param2:Boolean) : void
      {
         var _loc3_:ListedUser = this.getUserByName(param1);
         if(_loc3_ != null)
         {
            _loc3_.highlight(param2);
         }
      }
      
      public function highlightAll() : void
      {
         var _loc1_:ListedUser = null;
         for each(_loc1_ in this.listItems)
         {
            _loc1_.highlight(true);
         }
      }
      
      public function getUserByName(param1:String) : ListedUser
      {
         var _loc2_:ListedUser = null;
         for each(_loc2_ in this.listItems)
         {
            if(_loc2_.userName == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function onList(param1:String) : Boolean
      {
         var _loc2_:ListedUser = null;
         for each(_loc2_ in this.listItems)
         {
            if(_loc2_.userName == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get numUsers() : int
      {
         return this.listItems.length;
      }
      
      public function getList() : Array
      {
         return this.listItems;
      }
      
      public function noneHiLighted() : Boolean
      {
         var _loc1_:ListedUser = null;
         for each(_loc1_ in this.listItems)
         {
            if(_loc1_.hiLi)
            {
               return false;
            }
         }
         return true;
      }
      
      public function numHiLighted() : int
      {
         var _loc2_:ListedUser = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.listItems)
         {
            if(_loc2_.hiLi)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public function userSelected(param1:String, param2:int, param3:int, param4:Boolean, param5:String, param6:Sprite = null) : void
      {
         switch(this.listType)
         {
            case 1:
               this._UI.showWeevilProfile(param6,param1,param2,param3,param4,param5);
               break;
            case 2:
               this._UI.showInviteHandler(param1);
         }
      }
      
      public function userInvalid(param1:String) : void
      {
         this._UI.listedUserInvalid(this,param1);
      }
   }
}

