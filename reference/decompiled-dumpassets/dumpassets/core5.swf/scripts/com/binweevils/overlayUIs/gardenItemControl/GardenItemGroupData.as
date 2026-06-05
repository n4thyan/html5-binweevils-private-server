package com.binweevils.overlayUIs.gardenItemControl
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class GardenItemGroupData extends EventDispatcher implements IItemData
   {
      
      private var _colour:String;
      
      private var _count:Number;
      
      private var _deliveryTime:Number;
      
      private var _fName:String;
      
      private var _groupable:Boolean = false;
      
      private var _id:Number;
      
      private var _ids:Array;
      
      private var _powerConsumption:Number;
      
      private var _r:Number;
      
      private var _x:Number;
      
      private var _z:Number;
      
      private var _category:Number = 0;
      
      private var _cycleTime:Number = 0;
      
      private var _growTime:Number = 0;
      
      private var _mulch:Number = 0;
      
      private var _name:String = "";
      
      private var _xp:Number = 0;
      
      private var _age:Number = 0;
      
      private var _isSeed:Boolean = false;
      
      private var _type:String;
      
      private var _subType:String;
      
      public function GardenItemGroupData(param1:Object)
      {
         var _loc2_:int = 0;
         super();
         this._colour = param1.clr;
         if(param1.clr == null || param1.clr == 0 || param1.clr == "0,0,0")
         {
            this._colour = "-1";
         }
         this._count = param1.count;
         this._deliveryTime = param1.dt;
         if(param1.dt == null)
         {
            this._deliveryTime = 0;
         }
         this._fName = param1.fName;
         if(param1.grp == "1")
         {
            this._groupable = true;
         }
         if(param1.id is Array)
         {
            this._ids = param1.id;
            _loc2_ = 0;
            while(_loc2_ < this._ids.length)
            {
               this._ids[_loc2_] = Number(this._ids[_loc2_]);
               _loc2_++;
            }
         }
         else
         {
            this._ids = [Number(param1.id)];
         }
         this._id = this._ids[0];
         this._powerConsumption = param1.pc;
         this._r = param1.r;
         this._x = param1.x;
         this._z = param1.z;
         this.type = "item";
         if(this._fName.substr(0,5) == "fence")
         {
            this._subType = "fence";
         }
         else if(this._fName.substr(0,11) == "wateringCan")
         {
            this._subType = "wateringCan";
         }
         else
         {
            this._subType = "gardenItem";
         }
      }
      
      public function get category() : Number
      {
         return this._category;
      }
      
      public function set category(param1:Number) : void
      {
         this._category = param1;
      }
      
      public function get count() : Number
      {
         return this._count;
      }
      
      public function set count(param1:Number) : void
      {
         this._count = param1;
      }
      
      public function get cycleTime() : Number
      {
         return this._cycleTime;
      }
      
      public function set cycleTime(param1:Number) : void
      {
         this._cycleTime = param1;
      }
      
      public function get fName() : String
      {
         return this._fName;
      }
      
      public function set fName(param1:String) : void
      {
         this._fName = param1;
      }
      
      public function get growTime() : Number
      {
         return this._growTime;
      }
      
      public function set growTime(param1:Number) : void
      {
         this._growTime = param1;
      }
      
      public function get id() : Number
      {
         return this._id;
      }
      
      public function set id(param1:Number) : void
      {
         this._id = param1;
      }
      
      public function get ids() : Array
      {
         return this._ids;
      }
      
      public function set ids(param1:Array) : void
      {
         this._ids = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this._ids.length)
         {
            this._ids[_loc2_] = Number(this._ids[_loc2_]);
            _loc2_++;
         }
      }
      
      public function get mulch() : Number
      {
         return this._mulch;
      }
      
      public function set mulch(param1:Number) : void
      {
         this._mulch = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = this.name;
      }
      
      public function get r() : Number
      {
         return this._r;
      }
      
      public function set r(param1:Number) : void
      {
         this._r = param1;
      }
      
      public function get xp() : Number
      {
         return this._xp;
      }
      
      public function set xp(param1:Number) : void
      {
         this._xp = param1;
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function set x(param1:Number) : void
      {
         this._x = param1;
      }
      
      public function get z() : Number
      {
         return this._z;
      }
      
      public function set z(param1:Number) : void
      {
         this._z = param1;
      }
      
      public function get age() : Number
      {
         return this._age;
      }
      
      public function set age(param1:Number) : void
      {
         this._age = param1;
      }
      
      public function get isSeed() : Boolean
      {
         return this._isSeed;
      }
      
      public function set isSeed(param1:Boolean) : void
      {
         this._isSeed = param1;
      }
      
      public function get colour() : String
      {
         return this._colour;
      }
      
      public function set colour(param1:String) : void
      {
         this._colour = param1;
      }
      
      public function get deliveryTime() : Number
      {
         return this._deliveryTime;
      }
      
      public function set deliveryTime(param1:Number) : void
      {
         this._deliveryTime = param1;
      }
      
      public function get powerConsumption() : Number
      {
         return this._powerConsumption;
      }
      
      public function set powerConsumption(param1:Number) : void
      {
         this._powerConsumption = param1;
      }
      
      public function get groupable() : Boolean
      {
         return this._groupable;
      }
      
      public function set groupable(param1:Boolean) : void
      {
         this._groupable = param1;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
      }
      
      public function get subType() : String
      {
         return this._subType;
      }
      
      public function set subType(param1:String) : void
      {
         this._subType = param1;
      }
      
      public function addId(param1:Number) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._ids.length)
         {
            this._ids[_loc2_] = Number(this._ids[_loc2_]);
            if(param1 == this._ids[_loc2_])
            {
            }
            _loc2_++;
         }
         if(this._ids.indexOf(param1) == -1)
         {
            this._ids.unshift(param1);
         }
         dispatchEvent(new Event(ItemDataEvent.IDS_CHANGED));
      }
      
      public function removeId(param1:Number) : void
      {
         var _loc2_:int = int(this._ids.indexOf(param1));
         if(_loc2_ != -1)
         {
            this._ids.splice(_loc2_,1);
         }
         dispatchEvent(new Event(ItemDataEvent.IDS_CHANGED));
      }
   }
}

