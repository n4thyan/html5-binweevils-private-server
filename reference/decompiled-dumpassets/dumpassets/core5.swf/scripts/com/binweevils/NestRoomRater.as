package com.binweevils
{
   import com.binweevils.DBaccess.PHPcall;
   import com.binweevils.engine3D.visuals.LocGarden;
   import com.binweevils.engine3D.visuals.LocNest;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class NestRoomRater
   {
      
      private var nestRoomRater_spr:Sprite;
      
      private var roomRated_txt:TextField;
      
      private var rateThis_txt:TextField;
      
      private var starRatingUI_spr:Sprite;
      
      private var stars:Array;
      
      private var roomsRatedToday:Array;
      
      private var roomID:int;
      
      public function NestRoomRater(param1:Sprite)
      {
         super();
         this.nestRoomRater_spr = param1;
         this.starRatingUI_spr = Sprite(this.nestRoomRater_spr.getChildByName("starRatingUI_spr"));
         this.roomRated_txt = TextField(this.nestRoomRater_spr.getChildByName("roomRated_txt"));
         this.rateThis_txt = TextField(this.starRatingUI_spr.getChildByName("rateThis_txt"));
         this.stars = new Array();
         var _loc2_:int = 1;
         while(_loc2_ <= 5)
         {
            this.stars[_loc2_] = this.starRatingUI_spr.getChildByName("star" + _loc2_ + "_mc");
            this.stars[_loc2_].btn.addEventListener(MouseEvent.MOUSE_OVER,this.showStars);
            this.stars[_loc2_].btn.addEventListener(MouseEvent.MOUSE_UP,this.starClicked);
            _loc2_++;
         }
         this.starRatingUI_spr.addEventListener(MouseEvent.ROLL_OUT,this.turnOffAllStars);
      }
      
      private function turnOffAllStars(param1:MouseEvent = null) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.stars)
         {
            this.stars[_loc2_].gotoAndStop(1);
         }
      }
      
      private function showStars(param1:MouseEvent) : void
      {
         this.turnOffAllStars();
         switch(param1.target)
         {
            case this.stars[5].btn:
               this.stars[5].gotoAndStop(2);
            case this.stars[4].btn:
               this.stars[4].gotoAndStop(2);
            case this.stars[3].btn:
               this.stars[3].gotoAndStop(2);
            case this.stars[2].btn:
               this.stars[2].gotoAndStop(2);
            case this.stars[1].btn:
               this.stars[1].gotoAndStop(2);
         }
      }
      
      private function starClicked(param1:MouseEvent) : void
      {
         switch(param1.target)
         {
            case this.stars[5].btn:
               this.rateRoom(5);
               break;
            case this.stars[4].btn:
               this.rateRoom(4);
               break;
            case this.stars[3].btn:
               this.rateRoom(3);
               break;
            case this.stars[2].btn:
               this.rateRoom(2);
               break;
            case this.stars[1].btn:
               this.rateRoom(1);
         }
      }
      
      private function rateRoom(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:LocGarden = null;
         if(Bin.get_instance().crntLocID == -20)
         {
            _loc5_ = LocGarden(Bin.get_instance().crntLoc);
            _loc2_ = int(_loc5_.plants.length + _loc5_.gardenItems.length);
         }
         else
         {
            _loc2_ = int(LocNest(Bin.get_instance().crntLoc).itemsArray.length);
         }
         if(_loc2_ <= 2)
         {
            _loc3_ = 1;
         }
         else if(_loc2_ <= 5)
         {
            _loc3_ = 2;
         }
         else if(_loc2_ <= 10)
         {
            _loc3_ = 3;
         }
         else if(_loc2_ <= 15)
         {
            _loc3_ = 4;
         }
         else
         {
            _loc3_ = 5;
         }
         param1 = Math.min(param1,_loc3_);
         this.roomsRatedToday.push(this.roomID);
         this.set_mode(2);
         var _loc4_:PHPcall = new PHPcall("nest/rate-nest-room",true);
         _loc4_.fireAndForget(["rating","locID"],[param1,this.roomID]);
      }
      
      private function roomRated(param1:int) : Boolean
      {
         return this.roomsRatedToday.indexOf(param1) == -1 ? false : true;
      }
      
      private function getRoomsRated() : void
      {
         var _loc1_:PHPcall = new PHPcall("nest/get-rooms-rated-today",true);
         _loc1_.awaitResponse(this.roomsRatedReceived);
      }
      
      private function roomsRatedReceived(param1:Object) : void
      {
         var _loc2_:* = undefined;
         this.roomsRatedToday = param1.ratedToday.split(",");
         for(_loc2_ in this.roomsRatedToday)
         {
            this.roomsRatedToday[_loc2_] = int(this.roomsRatedToday[_loc2_]);
         }
         this.show();
      }
      
      public function show() : void
      {
         if(this.roomsRatedToday == null)
         {
            this.hide();
            this.getRoomsRated();
         }
         else if(this.roomsRatedToday.length < 50)
         {
            this.roomID = LocNest(Bin.get_instance().crntLoc).instanceID;
            if(Bin.get_instance().crntLocID == -20)
            {
               this.rateThis_txt.text = "RATE THIS GARDEN";
               this.roomRated_txt.text = "GARDEN RATED";
            }
            else
            {
               this.rateThis_txt.text = "RATE THIS ROOM";
               this.roomRated_txt.text = "ROOM RATED";
            }
            if(this.roomRated(this.roomID))
            {
               this.set_mode(2);
            }
            else
            {
               this.set_mode(1);
            }
            this.nestRoomRater_spr.visible = true;
         }
         else
         {
            this.hide();
         }
      }
      
      public function hide() : void
      {
         this.nestRoomRater_spr.visible = false;
      }
      
      private function set_mode(param1:int) : void
      {
         switch(param1)
         {
            case 1:
               this.roomRated_txt.visible = false;
               this.starRatingUI_spr.visible = true;
               break;
            case 2:
               this.starRatingUI_spr.visible = false;
               this.roomRated_txt.visible = true;
         }
      }
   }
}

