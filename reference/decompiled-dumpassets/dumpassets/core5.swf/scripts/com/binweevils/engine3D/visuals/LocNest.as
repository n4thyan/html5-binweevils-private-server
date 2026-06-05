package com.binweevils.engine3D.visuals
{
   import assetsNest.*;
   import com.binweevils.BinEvents;
   import com.binweevils.EventManager;
   import com.binweevils.Nest;
   import com.binweevils.QuestControl;
   import com.binweevils.engine3D.*;
   import com.binweevils.engine3D.visuals.creatures.weevils.Weevil;
   import com.binweevils.newUserTutorial.NewUserProgressManager;
   import com.binweevils.overlayUIs.itemControl.ItemGroupData;
   import com.binweevils.utilities.Utils;
   import com.binweevils.utilities.XML2JSON;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class LocNest extends Loc
   {
      
      public var nest:Nest;
      
      private var _instanceID:int;
      
      private var _cat:int;
      
      private var _businessName:String;
      
      private var _businessType:int;
      
      private var _businessSignClr:int;
      
      private var _businessSignTxtClr:int;
      
      private var _businessOpen:Boolean;
      
      private var v:Array;
      
      public var x:*;
      
      public var y:*;
      
      public var z:int;
      
      internal var xMin:*;
      
      internal var xMax:*;
      
      internal var yMin:*;
      
      internal var yMax:*;
      
      internal var zMin:*;
      
      internal var zMax:Number;
      
      protected var bg_spr:Sprite;
      
      protected var r:int;
      
      protected var g:int;
      
      protected var b:int;
      
      private var objectList:XMLList;
      
      private var wallpaper_spr:Sprite;
      
      private var ceiling_spr:Sprite;
      
      private var carpet_spr:Sprite;
      
      private var rug_spr:Sprite;
      
      private var doorsContainer_spr:Sprite;
      
      private var _itemsArray:Array;
      
      private var furnitureArray:Array;
      
      private var ornaments:Array;
      
      private var keepFreeSqs:Array;
      
      private var gridSqs:Array;
      
      protected var doorsCreated:Boolean;
      
      private var visibleDoors:Array;
      
      private var numCalls:int;
      
      private var guides:Sprite = new Sprite();
      
      private var rr:Number = 1;
      
      private var gg:Number = 1;
      
      private var bb:Number = 1;
      
      public var itemsInRoom:Array = new Array();
      
      public function LocNest(param1:Sprite, param2:int, param3:int, param4:String, param5:String, param6:Array, param7:Object, param8:Number, param9:Number, param10:Number, param11:Array, param12:int, param13:String)
      {
         super(param1,param2,3,param4,param5,param6,param7,param8,param9,param10);
         this.y = 0;
         switch(id)
         {
            case 1:
               this.x = 1;
               this.z = 3;
               break;
            case 2:
               this.x = 2;
               this.z = 3;
               break;
            case 3:
               this.x = 3;
               this.z = 3;
               break;
            case 4:
               this.x = 1;
               this.z = 2;
               break;
            case 5:
               this.x = 2;
               this.z = 2;
               break;
            case 6:
               this.x = 3;
               this.z = 2;
               break;
            case 7:
               this.x = 1;
               this.z = 1;
               break;
            case 8:
               this.x = 2;
               this.z = 1;
               break;
            case 9:
               this.x = 3;
               this.z = 1;
         }
         if(id < 0)
         {
            this.nest = bin.otherUserNest;
         }
         else
         {
            this.nest = bin.nest;
         }
         this._instanceID = param3;
         this._cat = param12;
         var _loc14_:Array = param13.split("|");
         this.r = _loc14_[0];
         this.g = _loc14_[1];
         this.b = _loc14_[2];
         this.keepFreeSqs = param11;
         this.wallpaper_spr = new Sprite();
         this.ceiling_spr = new Sprite();
         this.carpet_spr = new Sprite();
         this.rug_spr = new Sprite();
         this.doorsContainer_spr = new Sprite();
         bgHolder_spr.addChildAt(this.wallpaper_spr,0);
         bgHolder_spr.addChildAt(this.ceiling_spr,1);
         bgHolder_spr.addChildAt(this.carpet_spr,2);
         bgHolder_spr.addChildAt(this.doorsContainer_spr,3);
         bgHolder_spr.addChildAt(this.rug_spr,4);
         loc_spr.addChildAt(bgHolder_spr,0);
         this.furnitureArray = new Array();
         this.ornaments = new Array();
         this._itemsArray = new Array();
      }
      
      public function addToDoorsLayer(param1:DisplayObject) : void
      {
         if(param1.parent != this.doorsContainer_spr)
         {
            this.doorsContainer_spr.addChild(param1);
         }
      }
      
      public function reInitBG() : void
      {
         MovieClip(this.bg_spr).init();
      }
      
      public function cleanUp() : void
      {
         var _loc1_:NestItem = null;
         var _loc2_:DisplayObject = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         for each(_loc1_ in this._itemsArray)
         {
            _loc2_ = Visual(_loc1_).d_o;
            _loc2_.parent.removeChild(_loc2_);
         }
         this._itemsArray = [];
         this.furnitureArray = [];
         this.ornaments = [];
         _loc4_ = int(visuals.length);
         _loc3_ = _loc4_ - 1;
         while(_loc3_ >= 0)
         {
            if(visuals[_loc3_].d_o.parent == null)
            {
               visuals.splice(_loc3_,1);
            }
            _loc3_--;
         }
         _loc4_ = int(bgVisuals.length);
         _loc3_ = _loc4_ - 1;
         while(_loc3_ >= 0)
         {
            if(bgVisuals[_loc3_].d_o.parent == null)
            {
               bgVisuals.splice(_loc3_,1);
            }
            _loc3_--;
         }
         var _loc5_:int = int(assetLoaders.length);
         _loc3_ = _loc5_ - 1;
         while(_loc3_ >= 0)
         {
            if(assetLoaders[_loc3_] is ItemLoader)
            {
               assetLoaders.splice(_loc3_,1);
            }
            _loc3_--;
         }
         loaded = false;
         crntAsset = 0;
      }
      
      public function removeKeepFreeSq(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.keepFreeSqs.length)
         {
            if(this.keepFreeSqs[_loc2_] == param1)
            {
               this.keepFreeSqs.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      override public function getClickable() : InteractiveObject
      {
         return bgHolder_spr;
      }
      
      public function get cat() : int
      {
         return this._cat;
      }
      
      public function set instanceID(param1:int) : void
      {
         this._instanceID = param1;
      }
      
      public function get instanceID() : int
      {
         return this._instanceID;
      }
      
      public function set businessName(param1:String) : void
      {
         this._businessName = param1;
      }
      
      public function get businessName() : String
      {
         return this._businessName;
      }
      
      public function set businessType(param1:int) : void
      {
         this._businessType = param1;
      }
      
      public function get businessType() : int
      {
         return this._businessType;
      }
      
      public function set businessSignClr(param1:int) : void
      {
         this._businessSignClr = param1;
      }
      
      public function get businessSignClr() : int
      {
         return this._businessSignClr;
      }
      
      public function set businessSignTxtClr(param1:int) : void
      {
         this._businessSignTxtClr = param1;
      }
      
      public function get businessSignTxtClr() : int
      {
         return this._businessSignTxtClr;
      }
      
      public function set businessOpen(param1:Boolean) : void
      {
         this._businessOpen = param1;
      }
      
      public function get businessOpen() : Boolean
      {
         return this._businessOpen;
      }
      
      override public function enterLoc(param1:Weevil) : void
      {
         if(id <= -51)
         {
            bin.tycoonCustomerManager.enterBusiness(-id,this.businessType);
         }
         super.enterLoc(param1);
      }
      
      override public function isForbidden(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Furniture = null;
         for each(_loc3_ in this.furnitureArray)
         {
            if(_loc3_.hitCheck(param1,param2))
            {
               return true;
            }
         }
         return false;
      }
      
      override public function legaliseClick(param1:Number, param2:Number) : Point
      {
         var _loc3_:Point = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         _loc3_ = new Point(param1,param2);
         var _loc4_:Number = 40 * bin.myWeevil.scale;
         switch(boundType)
         {
            case "rect":
               if(param1 > boundRect.right + _loc4_ || param1 < boundRect.left - _loc4_ || param2 > boundRect.bottom + _loc4_ || param2 < boundRect.top - _loc4_)
               {
                  return null;
               }
               if(param1 > boundRect.right)
               {
                  param1 = boundRect.right;
               }
               else if(param1 < boundRect.left)
               {
                  param1 = boundRect.left;
               }
               if(param2 > boundRect.bottom)
               {
                  param2 = boundRect.bottom;
               }
               else if(param2 < boundRect.top)
               {
                  param2 = boundRect.top;
               }
               break;
            case "rad":
               _loc5_ = distance(_loc3_,centrePoint);
               if(_loc5_ > boundRadius)
               {
                  _loc6_ = param1 - centrePoint.x;
                  _loc7_ = param2 - centrePoint.y;
                  _loc8_ = boundRadius / _loc5_;
                  _loc6_ *= _loc8_;
                  _loc7_ *= _loc8_;
                  param1 = centrePoint.x + _loc6_;
                  param2 = centrePoint.y + _loc7_;
               }
         }
         _loc3_.x = param1;
         _loc3_.y = param2;
         return _loc3_;
      }
      
      override public function pathCollisionPoint(param1:Number, param2:Number, param3:Number, param4:Number) : Object
      {
         var _loc5_:Furniture = null;
         var _loc6_:Object = null;
         var _loc7_:Array = new Array();
         for each(_loc5_ in this.furnitureArray)
         {
            _loc6_ = _loc5_.pathIntersection(param1,param2,param3,param4);
            if(_loc6_ != null)
            {
               _loc7_.push(_loc6_);
            }
         }
         if(_loc7_.length == 0)
         {
            return null;
         }
         if(_loc7_.length == 1)
         {
            return _loc7_[0];
         }
         if(param1 < param3)
         {
            _loc7_.sortOn("x",Array.NUMERIC);
         }
         else if(param1 > param3)
         {
            _loc7_.sortOn("x",Array.DESCENDING);
         }
         else if(param2 < param4)
         {
            _loc7_.sortOn("z",Array.NUMERIC);
         }
         else
         {
            _loc7_.sortOn("z",Array.DESCENDING);
         }
         return _loc7_[0];
      }
      
      override public function getRandomFreeCoord() : Object
      {
         var _loc3_:Pos = null;
         var _loc4_:Furniture = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc11_:* = undefined;
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         for each(_loc4_ in this.furnitureArray)
         {
            _loc3_ = _loc4_.getPos();
            if(_loc3_.y < 10)
            {
               _loc1_ = _loc1_.concat(_loc3_.gridSqs);
            }
         }
         _loc6_ = 1;
         while(_loc6_ <= 40)
         {
            _loc5_ = false;
            for(_loc11_ in _loc1_)
            {
               if(_loc1_[_loc11_] == _loc6_)
               {
                  _loc5_ = true;
               }
            }
            if(!_loc5_)
            {
               _loc2_.push(_loc6_);
            }
            _loc6_++;
         }
         var _loc7_:int = int(_loc2_[int(_loc2_.length * Math.random())]);
         var _loc8_:int = _loc7_ % 10;
         if(_loc8_ == 0)
         {
            _loc8_ = 10;
         }
         var _loc9_:Number = _loc8_ * 40 - 220;
         var _loc10_:Number = int((_loc7_ - 1) / 10) * 80 + 120;
         _loc9_ += 20 - 40 * Math.random();
         _loc10_ += 40 - 80 * Math.random();
         if(_loc9_ < -186)
         {
            _loc9_ = -186;
         }
         else if(_loc9_ > 186)
         {
            _loc9_ = 186;
         }
         if(_loc10_ < 50)
         {
            _loc10_ = 50;
         }
         else if(_loc10_ > 386)
         {
            _loc10_ = 386;
         }
         if(id == 5 || id == -5)
         {
            if(_loc10_ > 190)
            {
               _loc10_ = 80 + 110 * Math.random();
            }
         }
         return {
            "x":_loc9_,
            "z":_loc10_
         };
      }
      
      override public function addAssetInfo(param1:XML) : void
      {
         var _loc3_:Object = null;
         var _loc4_:ItemGroupData = null;
         var _loc5_:Object = null;
         var _loc2_:String = param1.name();
         switch(_loc2_)
         {
            case "roomBG":
               assetLoaders.push(new AssetLoader(param1,true));
               break;
            case "item":
               if(param1 != null)
               {
                  if(param1.attribute("configName") == "f_petBasket2")
                  {
                     _loc5_ = this.nest.getPetBedCoordsByPosID(param1.attribute("crntPos"));
                     this.nest.storePetBedLoc(param1.attribute("id"),id,_loc5_.x,_loc5_.z);
                  }
               }
               _loc3_ = XML2JSON.parse(param1);
               _loc3_.id = [_loc3_.id];
               _loc3_.tags = [];
               _loc3_.count = 1;
               _loc3_.dt = 0;
               _loc4_ = new ItemGroupData(_loc3_);
               assetLoaders.push(new ItemLoader(_loc4_));
         }
      }
      
      public function setObjects(param1:XMLList) : void
      {
         this.objectList = param1;
      }
      
      protected function setupObjects() : void
      {
         var _loc1_:XML = null;
         var _loc2_:String = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:FixedAsset = null;
         for each(_loc1_ in this.objectList)
         {
            _loc2_ = _loc1_.attribute("name");
            _loc3_ = this.bg_spr.getChildByName(_loc2_);
            if(_loc3_ != null)
            {
               _loc4_ = Number(_loc1_.attribute("x"));
               _loc5_ = Number(_loc1_.attribute("y"));
               _loc6_ = Number(_loc1_.attribute("z"));
               _loc7_ = new FixedAsset(_loc3_,_loc4_,_loc5_,_loc6_);
               this.manageAsset(_loc7_);
            }
         }
      }
      
      override protected function createDoors() : void
      {
         var _loc1_:XML = null;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Boolean = false;
         var _loc15_:String = null;
         if(!this.doorsCreated)
         {
            for each(_loc1_ in doorList)
            {
               _loc2_ = int(_loc1_.attribute("id"));
               _loc3_ = Sprite(this.bg_spr.getChildByName("door" + _loc2_ + "_mc"));
               _loc4_ = 0;
               if(_loc1_.attribute("toLoc") == undefined)
               {
                  _loc5_ = Utils.stringToObject(_loc1_.attribute("extUIData"));
               }
               else
               {
                  _loc4_ = int(_loc1_.attribute("toLoc"));
                  if(id < 0)
                  {
                     _loc4_ = -_loc4_;
                  }
               }
               _loc6_ = int(_loc1_.attribute("toDoor"));
               _loc7_ = Number(_loc1_.attribute("x1"));
               _loc8_ = Number(_loc1_.attribute("z1"));
               _loc9_ = Number(_loc1_.attribute("x2"));
               _loc10_ = Number(_loc1_.attribute("z2"));
               _loc11_ = Number(_loc1_.attribute("y"));
               _loc12_ = Number(_loc1_.attribute("y2"));
               _loc13_ = NaN;
               _loc14_ = false;
               if(_loc1_.attribute("tycoonOnly") == "true")
               {
                  _loc14_ = true;
               }
               _loc15_ = _loc1_.attribute("nonTyconOverlay");
               doors[_loc2_] = new Door(this,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc13_,_loc11_,_loc12_,"fixedCam",_loc14_,_loc15_);
               this.doorsContainer_spr.addChild(_loc3_);
            }
            this.doorsCreated = true;
         }
      }
      
      protected function createInteractives() : void
      {
         var _loc1_:XML = null;
         var _loc2_:Array = null;
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Rectangle = null;
         var _loc7_:String = null;
         for each(_loc1_ in interactiveList)
         {
            _loc2_ = _loc1_.attribute("path").split(".");
            _loc3_ = MovieClip(this.bg_spr.getChildByName(_loc2_[0]));
            _loc4_ = 1;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = MovieClip(_loc3_.getChildByName(_loc2_[_loc4_]));
               _loc4_++;
            }
            _loc5_ = _loc1_.attribute("actRect").split(",");
            _loc6_ = new Rectangle(_loc5_[0],_loc5_[1],_loc5_[2],_loc5_[3]);
            _loc7_ = _loc1_.attribute("type");
            interactives.push(new Interactive(_loc3_,_loc6_,_loc7_));
         }
      }
      
      public function getRndDoor() : Door
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:Door = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in this.visibleDoors)
         {
            if(bin.getLocById(this.visibleDoors[_loc2_].toLoc).loaded)
            {
               _loc1_.push(this.visibleDoors[_loc2_]);
            }
         }
         _loc3_ = int(_loc1_.length);
         return _loc1_[int(_loc3_ * Math.random())];
      }
      
      override public function gotoDoor(param1:Door) : void
      {
         bin.moveMyWeevil(param1.x1,param1.z1,true,param1);
      }
      
      override public function manageAsset(param1:Visual, param2:IItemLoader = null) : void
      {
         var _loc5_:Furniture = null;
         var _loc3_:String = param1.type;
         var _loc4_:String = param1.subType;
         switch(_loc3_)
         {
            case "roomBG":
               if(this.bg_spr == null)
               {
                  this.bg_spr = Sprite(param1.d_o);
                  bgHolder_spr.addChildAt(this.bg_spr,0);
               }
               break;
            case "item":
               if(NestItem(param1).cat == this.cat)
               {
                  switch(_loc4_)
                  {
                     case "furniture":
                        _loc5_ = Furniture(param1);
                        _loc5_.setLoc(this);
                        this.furnitureArray.push(_loc5_);
                        this.itemsInRoom.push(_loc5_.configName);
                        if(_loc5_.bg)
                        {
                           bgVisuals.push(param1);
                           this.wallpaper_spr.addChildAt(param1.d_o,0);
                        }
                        else
                        {
                           visuals.push(param1);
                           content_spr.addChild(param1.d_o);
                           if(_loc5_.configName.substr(0,9) == "f_petBowl")
                           {
                              this.nest.setPetBowl(_loc5_.mc);
                           }
                           if(_loc5_.configName == "f_petBasket2")
                           {
                              this.nest.storePetBed(_loc5_);
                           }
                        }
                        break;
                     case "ornament":
                        this.ornaments.push(Ornament(param1));
                        this.itemsInRoom.push(Ornament(param1).configName);
                        break;
                     case "wallpaper":
                        this.wallpaper_spr.addChildAt(Sprite(param1.d_o),0);
                        break;
                     case "carpet":
                        this.carpet_spr.addChildAt(Sprite(param1.d_o),0);
                        break;
                     case "rug":
                        this.rug_spr.addChildAt(Sprite(param1.d_o),0);
                        break;
                     case "ceiling":
                        this.ceiling_spr.addChildAt(Sprite(param1.d_o),0);
                  }
                  this.add_item(NestItem(param1),_loc4_);
                  if(!QuestControl.isTaskComplete(NewUserProgressManager.DECORATE_NEST_TASK) && !QuestControl.isTaskComplete(NewUserProgressManager.COLECTED_MULCH_TASK) && !QuestControl.isTaskComplete(NewUserProgressManager.COMPLETED_TUTORIAL_TASK))
                  {
                     this.setTutorialBundlePositions(param1);
                  }
               }
               else
               {
                  this.nest.remove_item(NestItem(param1),this,param2);
               }
               break;
            default:
               visuals.push(param1);
               content_spr.addChild(param1.d_o);
         }
      }
      
      private function setTutorialBundlePositions(param1:Visual) : void
      {
         var _loc2_:Furniture = null;
         switch(param1.subType)
         {
            case "furniture":
               _loc2_ = Furniture(param1);
               switch(_loc2_.configName)
               {
                  case "f_table_icecream":
                     _loc2_.setPos(8);
                     EventManager.get_instance().dispatchEvent(new Event(BinEvents.SHELF_ADDED));
                     break;
                  case "f_easter_MarshmallowStool3":
                     _loc2_.setPos(9);
                     break;
                  case "f_bed_rocket_blueRed":
                     _loc2_.setPos(6);
                     break;
                  case "f_bedRoyal":
                  case "f_fairytale_PrincessBookcase":
                  case "f_fairytale_princessSofa2":
                  case "f_safari_rug2":
                     _loc2_.setPos(3);
                     break;
                  case "f_DiningRoomTable_kingSize":
                     _loc2_.setPos(3);
                     EventManager.get_instance().dispatchEvent(new Event(BinEvents.SHELF_ADDED));
                     break;
                  case "f_lollypop_rug_rainbowpastel":
                     _loc2_.setPos(10);
                     break;
                  case "f_HangingChairPod_Black":
                  case "f_star_light_short":
                  case "f_bed4":
                     _loc2_.setPos(1);
                     break;
                  case "f_easter_chocStool2":
                  case "f_LabsLab_scienceShelf":
                     _loc2_.setPos(12);
                     break;
                  case "f_under_sea_fish_rug_2":
                     _loc2_.setPos(15);
                     break;
                  case "f_somersaulting_dog":
                  case "f_spotLight":
                     _loc2_.setPos(8);
                     break;
                  case "f_logTable":
                     _loc2_.setPos(13);
                     EventManager.get_instance().dispatchEvent(new Event(BinEvents.SHELF_ADDED));
                     break;
                  case "f_NIbook_WallpictureClott_Anim":
                     _loc2_.setPos(2);
                     break;
                  case "f_star_light_long":
                     _loc2_.setPos(11);
               }
               break;
            case "ornament":
         }
      }
      
      public function add_item(param1:NestItem, param2:String) : void
      {
         param1.inLimbo = false;
         this._itemsArray.push(param1);
      }
      
      private function placeOrnaments() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Ornament = null;
         var _loc3_:int = 0;
         var _loc4_:Furniture = null;
         for(_loc1_ in this.ornaments)
         {
            _loc2_ = this.ornaments[_loc1_];
            _loc3_ = _loc2_.fID;
            _loc4_ = this.getFurnitureByID(_loc3_);
            if(_loc4_ != null)
            {
               _loc4_.addOrnament(_loc2_,_loc2_.spotID);
            }
            else
            {
               this.nest.remove_item(_loc2_);
            }
         }
      }
      
      public function userAddItem(param1:NestItem) : Boolean
      {
         var _loc2_:* = Visual(param1).subType;
         switch(_loc2_)
         {
            case "furniture":
               return this.addFurniture(Furniture(param1));
            case "ornament":
               return this.addOrnament(Ornament(param1));
            case "wallpaper":
               this.addWallpaper(BgItem(param1));
               return true;
            case "carpet":
               this.addCarpet(BgItem(param1));
               return true;
            case "rug":
               this.addRug(BgItem(param1));
               return true;
            case "ceiling":
               this.addCeiling(BgItem(param1));
               return true;
            default:
               return false;
         }
      }
      
      public function get itemsArray() : Array
      {
         return this._itemsArray;
      }
      
      public function remove_item(param1:NestItem) : Array
      {
         var _loc2_:int = int(this._itemsArray.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._itemsArray[_loc3_] == param1)
            {
               this._itemsArray.splice(_loc3_,1);
            }
            _loc3_++;
         }
         var _loc4_:* = Visual(param1).subType;
         switch(_loc4_)
         {
            case "furniture":
               return this.removeFurniture(Furniture(param1));
            case "ornament":
               this.removeOrnament(Ornament(param1));
               break;
            case "wallpaper":
               this.removeWallpaper();
               break;
            case "carpet":
               this.removeCarpet();
               break;
            case "rug":
               this.removeRug();
               break;
            case "ceiling":
               this.removeCeiling();
         }
         return null;
      }
      
      private function addFurniture(param1:Furniture) : Boolean
      {
         var _loc2_:int = param1.numPositions;
         var _loc3_:Array = param1.getPositions();
         var _loc4_:int = 1;
         while(_loc4_ <= _loc2_)
         {
            if(!this.clashCheck(param1,_loc3_[_loc4_]))
            {
               param1.setPos(_loc4_);
               this.manageAsset(param1);
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      private function removeFurniture(param1:Furniture) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         var _loc4_:int = int(this.furnitureArray.length);
         if(param1.bg)
         {
            _loc3_ = int(bgVisuals.length);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if(bgVisuals[_loc2_] == param1)
               {
                  bgVisuals.splice(_loc2_,1);
                  this.wallpaper_spr.removeChild(param1.d_o);
               }
               _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < _loc4_)
            {
               if(this.furnitureArray[_loc2_] == param1)
               {
                  this.furnitureArray.splice(_loc2_,1);
               }
               _loc2_++;
            }
            param1.loc = null;
            return [];
         }
         _loc3_ = int(visuals.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(visuals[_loc2_] == param1)
            {
               visuals.splice(_loc2_,1);
               content_spr.removeChild(param1.d_o);
            }
            _loc2_++;
         }
         _loc5_ = param1.ornaments.concat();
         for(_loc6_ in _loc5_)
         {
            this.remove_item(_loc5_[_loc6_]);
         }
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            if(this.furnitureArray[_loc2_] == param1)
            {
               this.furnitureArray.splice(_loc2_,1);
            }
            _loc2_++;
         }
         param1.loc = null;
         return _loc5_;
      }
      
      private function addOrnament(param1:Ornament, param2:int = 0, param3:Boolean = true) : Boolean
      {
         var _loc4_:* = undefined;
         for(_loc4_ in this.furnitureArray)
         {
            if(this.furnitureArray[_loc4_].addOrnament(param1))
            {
               this.manageAsset(param1);
               return true;
            }
         }
         return false;
      }
      
      private function removeOrnament(param1:Ornament) : void
      {
         var _loc2_:int = param1.fID;
         var _loc3_:Furniture = this.getFurnitureByID(_loc2_);
         if(_loc3_ != null)
         {
            if(_loc3_.removeOrnament(param1))
            {
            }
         }
      }
      
      public function getFurnitureByID(param1:int) : Furniture
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.furnitureArray)
         {
            if(this.furnitureArray[_loc2_].id == param1)
            {
               return this.furnitureArray[_loc2_];
            }
         }
         return null;
      }
      
      public function addWallpaper(param1:BgItem) : void
      {
         var _loc2_:NestItem = null;
         if(this.wallpaper_spr.numChildren > 0)
         {
            _loc2_ = this.getCrntWCRItem("wallpaper");
            if(_loc2_ != null)
            {
               this.nest.remove_item(_loc2_);
            }
         }
         this.manageAsset(param1);
      }
      
      public function removeWallpaper() : void
      {
         var _loc1_:DisplayObject = null;
         if(this.wallpaper_spr.numChildren > 0)
         {
            _loc1_ = this.wallpaper_spr.getChildAt(0);
            this.wallpaper_spr.removeChild(_loc1_);
         }
      }
      
      public function getCrntWCRItem(param1:String) : NestItem
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this._itemsArray)
         {
            if(Visual(this._itemsArray[_loc2_]).subType == param1)
            {
               return this._itemsArray[_loc2_];
            }
         }
         return null;
      }
      
      public function addCarpet(param1:BgItem) : void
      {
         var _loc2_:NestItem = null;
         if(this.carpet_spr.numChildren > 0)
         {
            _loc2_ = this.getCrntWCRItem("carpet");
            if(_loc2_ != null)
            {
               this.nest.remove_item(_loc2_);
            }
         }
         this.manageAsset(param1);
      }
      
      public function removeCarpet() : void
      {
         var _loc1_:DisplayObject = null;
         if(this.carpet_spr.numChildren > 0)
         {
            _loc1_ = this.carpet_spr.getChildAt(0);
            this.carpet_spr.removeChild(_loc1_);
         }
      }
      
      public function addRug(param1:BgItem) : void
      {
         var _loc2_:NestItem = null;
         if(this.rug_spr.numChildren > 0)
         {
            _loc2_ = this.getCrntWCRItem("rug");
            if(_loc2_ != null)
            {
               this.nest.remove_item(_loc2_);
            }
         }
         this.manageAsset(param1);
      }
      
      public function removeRug() : void
      {
         var _loc1_:DisplayObject = null;
         if(this.rug_spr.numChildren > 0)
         {
            _loc1_ = this.rug_spr.getChildAt(0);
            this.rug_spr.removeChild(_loc1_);
         }
      }
      
      public function addCeiling(param1:BgItem) : void
      {
         var _loc2_:NestItem = null;
         if(this.ceiling_spr.numChildren > 0)
         {
            _loc2_ = this.getCrntWCRItem("ceiling");
            if(_loc2_ != null)
            {
               this.nest.remove_item(_loc2_);
            }
         }
         this.manageAsset(param1);
      }
      
      public function removeCeiling() : void
      {
         var _loc1_:DisplayObject = null;
         if(this.ceiling_spr.numChildren > 0)
         {
            _loc1_ = this.ceiling_spr.getChildAt(0);
            this.ceiling_spr.removeChild(_loc1_);
         }
      }
      
      override public function loadManager() : void
      {
         var _loc2_:* = null;
         var _loc3_:Furniture = null;
         var _loc1_:int = int(assetLoaders.length);
         if(crntAsset < _loc1_)
         {
            _loc2_ = "loading nest contents...  (" + (crntAsset + 1) + " of " + _loc1_ + ")";
            ++crntAsset;
            assetLoaders[crntAsset - 1].loadAsset(this,_loc2_);
         }
         else
         {
            this.createDoors();
            this.setColour();
            for each(_loc3_ in this.furnitureArray)
            {
               if(!_loc3_.isPositionValid())
               {
                  this.nest.remove_item(_loc3_,this);
               }
            }
            this.placeOrnaments();
            if(!initialised)
            {
               initialised = true;
               this.createInteractives();
               this.setupObjects();
               createNoGoAreas();
            }
            this.loadComplete();
         }
      }
      
      override protected function loadComplete() : void
      {
         var _loc1_:* = undefined;
         this.visibleDoors = [];
         for(_loc1_ in doors)
         {
            if(this.nest.hasLoc(doors[_loc1_].toLoc) || doors[_loc1_].toLoc >= 100)
            {
               doors[_loc1_].setVis(true);
               this.visibleDoors.push(doors[_loc1_]);
            }
            else
            {
               doors[_loc1_].setVis(false);
            }
         }
         this.nest.locLoaded(this);
         super.loadComplete();
      }
      
      public function clashCheck(param1:Furniture, param2:Pos, param3:Boolean = false) : Boolean
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         for(_loc4_ in this.furnitureArray)
         {
            if(this.furnitureArray[_loc4_] != param1)
            {
               if(this.furnitureArray[_loc4_].clashCheck(param2))
               {
                  return true;
               }
            }
         }
         if(param2.y < 51 && !param3)
         {
            for(_loc4_ in param2.gridSqs)
            {
               for(_loc5_ in this.keepFreeSqs)
               {
                  if(param2.gridSqs[_loc4_] == this.keepFreeSqs[_loc5_])
                  {
                     return true;
                  }
               }
            }
            if(bin.myWeevil.y == 0)
            {
               if(param2.hitCheck(bin.myWeevil.x,bin.myWeevil.z))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function moveItem(param1:NestItem, param2:Boolean) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:String = Visual(param1).subType;
         switch(Visual(param1).subType)
         {
            case "furniture":
               _loc3_ = Furniture(param1).crntPosID;
               this.moveFurniture(Furniture(param1),param2);
               break;
            case "ornament":
               _loc4_ = Ornament(param1).fID;
               _loc5_ = Ornament(param1).spotID;
               this.moveOrnament(Ornament(param1),param2);
         }
         this.updateItemPosition(param1,_loc6_,_loc3_,_loc4_,_loc5_);
      }
      
      private function updateItemPosition(param1:NestItem, param2:String, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:int = 0;
         switch(param2)
         {
            case "furniture":
               _loc6_ = Furniture(param1).crntPosID;
               break;
            case "ornament":
               _loc7_ = Ornament(param1).fID;
               _loc8_ = Ornament(param1).spotID;
         }
         if(_loc6_ != param3 || _loc7_ != param4 || _loc8_ != param5)
         {
            this.nest.updateItemPosition(param1.id,param2,_loc6_,_loc7_,_loc8_);
         }
         forceRender = true;
      }
      
      private function moveFurniture(param1:Furniture, param2:Boolean) : void
      {
         param1.moveIt(param2);
      }
      
      public function moveOrnament(param1:Ornament, param2:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:Furniture = this.getFurnitureByID(param1.fID);
         if(!_loc3_.moveOrnament(param1,param2))
         {
            _loc4_ = int(this.furnitureArray.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if(_loc3_ == this.furnitureArray[_loc5_])
               {
                  break;
               }
               _loc5_++;
            }
            this.numCalls = 0;
            this.addOrnament2(param1,_loc5_,_loc4_,param2);
         }
      }
      
      private function addOrnament2(param1:Ornament, param2:int, param3:int, param4:Boolean) : void
      {
         if(param4)
         {
            param2++;
            if(param2 >= param3)
            {
               param2 = 0;
            }
         }
         else
         {
            param2--;
            if(param2 < 0)
            {
               param2 = param3 - 1;
            }
         }
         if(!this.furnitureArray[param2].addOrnament2(param1,param4))
         {
            this.addOrnament2(param1,param2,param3,param4);
         }
      }
      
      private function drawGrid(param1:Cam3D) : void
      {
         var _loc5_:Vector3D = null;
         var _loc6_:Number = NaN;
         var _loc8_:Graphics = null;
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:Number = ViewPort.d;
         var _loc7_:int = 0;
         while(_loc7_ < this.v.length)
         {
            _loc5_ = param1.transform_vtx(this.v[_loc7_],_loc4_);
            _loc6_ = _loc4_ / (_loc4_ + _loc5_.z);
            _loc2_[_loc7_] = ViewPort.x0 + _loc5_.x * _loc6_;
            _loc3_[_loc7_] = ViewPort.y0 - _loc5_.y * _loc6_;
            _loc7_++;
         }
         _loc8_ = this.guides.graphics;
         _loc8_.clear();
         _loc8_.lineStyle(1,30464);
         _loc7_ = 110;
         while(_loc7_ <= 115)
         {
            _loc8_.moveTo(_loc2_[_loc7_],_loc3_[_loc7_]);
            _loc8_.lineTo(_loc2_[_loc7_ + 12],_loc3_[_loc7_ + 12]);
            _loc7_++;
         }
         _loc7_ = 117;
         while(_loc7_ <= 120)
         {
            _loc8_.moveTo(_loc2_[_loc7_],_loc3_[_loc7_]);
            _loc8_.lineTo(_loc2_[_loc7_ + 11],_loc3_[_loc7_ + 11]);
            _loc7_++;
         }
         _loc8_.moveTo(_loc2_[110],_loc3_[110]);
         _loc8_.lineTo(_loc2_[116],_loc3_[116]);
         _loc8_.lineTo(_loc2_[121],_loc3_[121]);
         _loc8_.lineTo(_loc2_[122],_loc3_[122]);
         _loc8_.lineTo(_loc2_[110],_loc3_[110]);
         _loc8_.lineStyle(1,43520);
         _loc7_ = 88;
         while(_loc7_ <= 93)
         {
            _loc8_.moveTo(_loc2_[_loc7_],_loc3_[_loc7_]);
            _loc8_.lineTo(_loc2_[_loc7_ + 12],_loc3_[_loc7_ + 12]);
            _loc7_++;
         }
         _loc7_ = 95;
         while(_loc7_ <= 98)
         {
            _loc8_.moveTo(_loc2_[_loc7_],_loc3_[_loc7_]);
            _loc8_.lineTo(_loc2_[_loc7_ + 11],_loc3_[_loc7_ + 11]);
            _loc7_++;
         }
         _loc8_.moveTo(_loc2_[88],_loc3_[88]);
         _loc8_.lineTo(_loc2_[94],_loc3_[94]);
         _loc8_.lineTo(_loc2_[99],_loc3_[99]);
         _loc8_.lineTo(_loc2_[100],_loc3_[100]);
         _loc8_.lineTo(_loc2_[88],_loc3_[88]);
         _loc8_.lineStyle(1,56576);
         _loc7_ = 66;
         while(_loc7_ <= 71)
         {
            _loc8_.moveTo(_loc2_[_loc7_],_loc3_[_loc7_]);
            _loc8_.lineTo(_loc2_[_loc7_ + 12],_loc3_[_loc7_ + 12]);
            _loc7_++;
         }
         _loc7_ = 73;
         while(_loc7_ <= 76)
         {
            _loc8_.moveTo(_loc2_[_loc7_],_loc3_[_loc7_]);
            _loc8_.lineTo(_loc2_[_loc7_ + 11],_loc3_[_loc7_ + 11]);
            _loc7_++;
         }
         _loc8_.moveTo(_loc2_[66],_loc3_[66]);
         _loc8_.lineTo(_loc2_[72],_loc3_[72]);
         _loc8_.lineTo(_loc2_[77],_loc3_[77]);
         _loc8_.lineTo(_loc2_[78],_loc3_[78]);
         _loc8_.lineTo(_loc2_[66],_loc3_[66]);
         _loc8_.lineStyle(1,10092288);
         _loc7_ = 44;
         while(_loc7_ <= 49)
         {
            _loc8_.moveTo(_loc2_[_loc7_],_loc3_[_loc7_]);
            _loc8_.lineTo(_loc2_[_loc7_ + 12],_loc3_[_loc7_ + 12]);
            _loc7_++;
         }
         _loc7_ = 51;
         while(_loc7_ <= 54)
         {
            _loc8_.moveTo(_loc2_[_loc7_],_loc3_[_loc7_]);
            _loc8_.lineTo(_loc2_[_loc7_ + 11],_loc3_[_loc7_ + 11]);
            _loc7_++;
         }
         _loc8_.moveTo(_loc2_[44],_loc3_[44]);
         _loc8_.lineTo(_loc2_[50],_loc3_[50]);
         _loc8_.lineTo(_loc2_[55],_loc3_[55]);
         _loc8_.lineTo(_loc2_[56],_loc3_[56]);
         _loc8_.lineTo(_loc2_[44],_loc3_[44]);
         _loc8_.lineStyle(1,16776960);
         _loc7_ = 22;
         while(_loc7_ <= 27)
         {
            _loc8_.moveTo(_loc2_[_loc7_],_loc3_[_loc7_]);
            _loc8_.lineTo(_loc2_[_loc7_ + 12],_loc3_[_loc7_ + 12]);
            _loc7_++;
         }
         _loc7_ = 29;
         while(_loc7_ <= 32)
         {
            _loc8_.moveTo(_loc2_[_loc7_],_loc3_[_loc7_]);
            _loc8_.lineTo(_loc2_[_loc7_ + 11],_loc3_[_loc7_ + 11]);
            _loc7_++;
         }
         _loc8_.moveTo(_loc2_[22],_loc3_[22]);
         _loc8_.lineTo(_loc2_[28],_loc3_[28]);
         _loc8_.lineTo(_loc2_[33],_loc3_[33]);
         _loc8_.lineTo(_loc2_[34],_loc3_[34]);
         _loc8_.lineTo(_loc2_[22],_loc3_[22]);
         _loc8_.lineStyle(1,16777215);
         _loc7_ = 0;
         while(_loc7_ <= 23)
         {
            _loc8_.moveTo(_loc2_[_loc7_],_loc3_[_loc7_]);
            _loc8_.lineTo(_loc2_[_loc7_ + 110],_loc3_[_loc7_ + 110]);
            _loc7_++;
         }
      }
      
      public function setColour_rgb(param1:String) : void
      {
         var _loc2_:Array = param1.split("|");
         this.r = _loc2_[0];
         this.g = _loc2_[1];
         this.b = _loc2_[2];
      }
      
      public function setColour_r_g_b(param1:int, param2:int, param3:int) : void
      {
         this.r = param1;
         this.g = param2;
         this.b = param3;
         this.setColour();
      }
      
      protected function setColour() : void
      {
         var _loc2_:Door = null;
         var _loc1_:ColorTransform = new ColorTransform(1,1,1,1,this.r,this.g,this.b,0);
         if(id == 5 || id == -5 || id == 50 || id == -50 || id == 10 || id == -10)
         {
            this.bg_spr.getChildByName("roomBG_spr").transform.colorTransform = _loc1_;
         }
         else
         {
            this.bg_spr.transform.colorTransform = _loc1_;
         }
         if(id != 5 && id != -5 && id != 10 && id != -10)
         {
            for each(_loc2_ in doors)
            {
               _loc2_.d_o.transform.colorTransform = _loc1_;
            }
         }
      }
      
      public function getClrStr() : String
      {
         return this.r + "|" + this.g + "|" + this.b;
      }
      
      public function setDimness(param1:int) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:ColorTransform = null;
         if(param1 < 10000)
         {
            _loc2_ = 0.0001 * param1;
            if(id == 5 || id == -5 || id == 50 || id == -50)
            {
               if(_loc2_ < 0.5)
               {
                  _loc2_ = 0.5;
               }
            }
            _loc3_ = new ColorTransform(_loc2_,_loc2_,_loc2_,1,0,0,0,0);
            loc_spr.transform.colorTransform = _loc3_;
         }
         else
         {
            loc_spr.transform.colorTransform = new ColorTransform();
         }
      }
      
      override public function render(param1:Cam3D, param2:Number = 1) : void
      {
         var _loc3_:Visual = null;
         var _loc4_:int = 0;
         if(param1.mvd || forceRender)
         {
            for each(_loc3_ in visuals)
            {
               _loc3_.render(param1,viewPort,param2);
            }
            for each(_loc3_ in bgVisuals)
            {
               _loc3_.render(param1,viewPort,param2);
            }
            forceRender = false;
         }
         else
         {
            for each(_loc3_ in dynams)
            {
               _loc3_.render(param1,viewPort,param2);
            }
         }
         visuals.sortOn("depth",Array.NUMERIC);
         _loc4_ = int(visuals.length);
         while(_loc4_--)
         {
            if(content_spr.getChildAt(_loc4_) != visuals[_loc4_].d_o)
            {
               content_spr.setChildIndex(visuals[_loc4_].d_o,_loc4_);
            }
         }
         bgVisuals.sortOn("depth",Array.NUMERIC);
         _loc4_ = int(bgVisuals.length);
         while(_loc4_--)
         {
            if(this.wallpaper_spr.getChildAt(_loc4_) != bgVisuals[_loc4_].d_o)
            {
               this.wallpaper_spr.setChildIndex(bgVisuals[_loc4_].d_o,_loc4_);
            }
         }
      }
   }
}

