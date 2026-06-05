package com.binweevils.overlayUIs.itemControl
{
   public class ItemGroupData
   {
      
      private var _ids:Array;
      
      public var colour:String;
      
      public var deliveryTime:Number;
      
      public var category:Number;
      
      public var configName:String;
      
      public var powerConsumption:Number;
      
      public var groupable:int;
      
      public var tags:Array;
      
      public var count:int;
      
      public var crntPos:String;
      
      public var fID:String;
      
      public var spot:String;
      
      public var previousID:Number;
      
      public function ItemGroupData(param1:Object)
      {
         super();
         this._ids = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < param1.id.length)
         {
            this.addId(param1.id[_loc2_]);
            _loc2_++;
         }
         if(param1.clr == 0 || param1.clr == "0,0,0" || param1.clr == undefined)
         {
            param1.clr = -1;
         }
         this.colour = param1.clr;
         this.deliveryTime = param1.dt;
         if(isNaN(param1.dt) || param1.dt < 0)
         {
            this.deliveryTime = 0;
         }
         this.category = param1.cat;
         this.configName = param1.configName;
         this.groupable = param1.grp;
         if(param1.tags != null && param1.tags.length == 0)
         {
            param1.tags = ["other stuff"];
         }
         this.tags = param1.tags;
         this.count = param1.count;
         this.crntPos = param1.crntPos;
         this.fID = param1.fID;
         this.spot = param1.spot;
      }
      
      public function addId(param1:Number) : void
      {
         if(this._ids.indexOf(param1) == -1)
         {
            this._ids.unshift(param1);
         }
      }
      
      public function removeId(param1:Number) : void
      {
         var _loc2_:int = int(this._ids.indexOf(param1));
         if(_loc2_ != -1)
         {
            this._ids.splice(_loc2_,1);
            this.previousID = param1;
         }
      }
      
      public function get ids() : Array
      {
         return this._ids;
      }
      
      public function toString() : String
      {
         return "ItemGroupData configName " + this.configName + " ids: " + this.ids;
      }
   }
}

