package com.binweevils.engine3D.visuals
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   
   public class Sign extends Object3D
   {
      
      private var mc:MovieClip;
      
      private var signText_spr:Sprite;
      
      private var signText_txt:TextField;
      
      public function Sign(param1:String, param2:String, param3:String, param4:Element, param5:Number, param6:Number, param7:Number, param8:Number = 1, param9:Number = 0)
      {
         super(param4,param5,param6,param7,param8,param9);
         this.mc = MovieClip(d_o);
         this.signText_spr = Sprite(this.mc.getChildByName("signText_mc"));
         this.signText_txt = TextField(this.signText_spr.getChildByName("signText_txt"));
         this.setText(param1);
         link = param2;
         this.signText_spr.addEventListener(MouseEvent.MOUSE_OVER,this.HiLi);
         this.signText_spr.addEventListener(MouseEvent.MOUSE_OUT,this.LoLi);
         this.signText_spr.buttonMode = true;
         this.signText_spr.useHandCursor = true;
         switch(param3)
         {
            case "popup":
               this.signText_spr.addEventListener(MouseEvent.CLICK,this.showPopup);
               break;
            case "internal":
         }
      }
      
      private function setText(param1:String) : void
      {
         this.signText_txt.text = param1;
      }
      
      private function HiLi(param1:MouseEvent) : void
      {
         this.signText_txt.transform.colorTransform = new ColorTransform(2.5,4,1,1,0,0,0,0);
      }
      
      private function LoLi(param1:MouseEvent) : void
      {
         this.signText_txt.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
      }
      
      private function showPopup(param1:MouseEvent) : void
      {
         link = "http://www." + link;
         var _loc2_:String = link;
         var _loc3_:URLRequest = new URLRequest(_loc2_);
         navigateToURL(_loc3_,"_blank");
      }
   }
}

