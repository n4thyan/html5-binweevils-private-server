package com.binweevils
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.net.*;
   import flash.text.TextField;
   
   public class ListedUser
   {
      
      private var list:UserList;
      
      public var spr:Sprite;
      
      public var userName:String;
      
      private var _online:Boolean;
      
      public var hiLi:Boolean;
      
      private var userIDX:int;
      
      private var userLevel:int;
      
      private var tycoon:Boolean;
      
      private var lastLog:String;
      
      private var weevilDef:Object;
      
      private var mugShot_spr:Sprite;
      
      private var mugShot_bmp:Bitmap;
      
      private var vars:Object;
      
      public function ListedUser(param1:UserList, param2:String, param3:Boolean)
      {
         super();
         this.list = param1;
         this.userName = param2;
         this.spr = new ListItem();
         TextField(this.spr.getChildByName("item_txt")).text = this.userName;
         this.spr.addEventListener(MouseEvent.CLICK,this.clickHandler);
         this.spr.buttonMode = true;
         this.setOnlineStatus(param3);
      }
      
      public function setOnlineStatus(param1:Boolean) : void
      {
         this._online = param1;
         if(param1)
         {
            this.spr.alpha = 1;
         }
         else
         {
            this.spr.alpha = 0.5;
         }
      }
      
      public function highlight(param1:Boolean) : void
      {
         this.hiLi = param1;
         if(param1)
         {
            this.spr.transform.colorTransform = new ColorTransform(1,1,1,1,this.list.hiliR,this.list.hiliG,this.list.hiliB,0);
         }
         else
         {
            this.spr.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
         }
      }
      
      public function updateVars(param1:Object) : void
      {
         var _loc2_:* = undefined;
         if(this.vars == null)
         {
            this.vars = param1;
         }
         else
         {
            for(_loc2_ in param1)
            {
               this.vars[_loc2_] = param1[_loc2_];
            }
         }
      }
      
      public function get_var(param1:String) : String
      {
         if(this.vars != null)
         {
            return this.vars[param1];
         }
         return null;
      }
      
      public function get online() : Boolean
      {
         return this._online;
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         if(this.list.listType == 1)
         {
            if(this.mugShot_bmp == null)
            {
               Bin.get_instance().getWeevilData(this.userName,this.weevilDataReceived);
            }
            else
            {
               this.userSelected();
            }
         }
         else
         {
            this.userSelected();
         }
      }
      
      private function weevilDataReceived(param1:Object) : void
      {
         var _loc2_:Object = null;
         if(param1.res == 1)
         {
            this.userIDX = param1.idx;
            this.userLevel = param1.level;
            this.tycoon = param1.tycoon == 1;
            this.lastLog = param1.lastLog;
            _loc2_ = {};
            _loc2_.weevilDef = param1.weevilDef;
            _loc2_.king = 0;
            this.mugShot_bmp = Bin.get_instance().getWeevilMugshot(null,_loc2_,2);
            this.mugShot_spr = new Sprite();
            this.mugShot_spr.addChild(this.mugShot_bmp);
            this.userSelected();
         }
         else if(param1.res == 2)
         {
            this.list.userInvalid(this.userName);
         }
      }
      
      private function userSelected() : void
      {
         this.list.userSelected(this.userName,this.userIDX,this.userLevel,this.tycoon,this.lastLog,this.mugShot_spr);
      }
      
      public function remove() : void
      {
         this.mugShot_spr = null;
         this.mugShot_bmp = null;
         this.weevilDef = null;
         TextField(this.spr.getChildByName("item_txt")).text = "";
         if(this.spr.hasEventListener(MouseEvent.CLICK))
         {
            this.spr.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         }
      }
   }
}

