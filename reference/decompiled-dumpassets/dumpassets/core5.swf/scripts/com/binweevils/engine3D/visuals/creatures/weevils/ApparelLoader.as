package com.binweevils.engine3D.visuals.creatures.weevils
{
   import com.binweevils.utilities.URLhandler;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   
   public class ApparelLoader
   {
      
      private var weevil:Weevil;
      
      private var garmentID:uint;
      
      private var rgb:String;
      
      public function ApparelLoader(param1:Weevil, param2:uint, param3:String = null)
      {
         super();
         this.weevil = param1;
         this.garmentID = param2;
         this.rgb = param3;
         var _loc4_:* = "assets3D/apparel_" + param2 + ".swf";
         var _loc5_:Loader = new Loader();
         URLhandler.loadFromCDN(_loc5_,_loc4_,this.apparelLoaded,true);
      }
      
      private function apparelLoaded(param1:Event) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:MovieClip = MovieClip(param1.target.content);
         if(this.rgb != null)
         {
            _loc3_ = this.rgb.split(",");
            _loc4_ = int(_loc3_[0]);
            _loc5_ = int(_loc3_[1]);
            _loc6_ = int(_loc3_[2]);
            _loc2_.transform.colorTransform = new ColorTransform(1,1,1,1,_loc4_,_loc5_,_loc6_,0);
         }
         this.weevil.apparelLoaded(_loc2_,this.garmentID);
      }
   }
}

