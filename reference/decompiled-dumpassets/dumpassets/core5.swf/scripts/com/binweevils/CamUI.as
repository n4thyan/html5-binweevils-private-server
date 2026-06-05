package com.binweevils
{
   import com.binweevils.engine3D.*;
   import com.binweevils.utilities.URLhandler;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.geom.Rectangle;
   
   public class CamUI
   {
      
      private var bin:Bin;
      
      private var cam:Cam3D;
      
      private var camUI_spr:Sprite;
      
      private var zoomRotate_spr:Sprite;
      
      private var elevation_spr:Sprite;
      
      private var left_btn:SimpleButton;
      
      private var right_btn:SimpleButton;
      
      private var forward_btn:SimpleButton;
      
      private var backward_btn:SimpleButton;
      
      private var up_btn:SimpleButton;
      
      private var down_btn:SimpleButton;
      
      private var joy1:Joystick;
      
      private var joy2:Joystick;
      
      private var resetCamBtn_mc:MovieClip;
      
      private var closeUpCamBtn_mc:MovieClip;
      
      private var aimFollowCamBtn_mc:MovieClip;
      
      private var weevilCamBtn_mc:MovieClip;
      
      private var followMode:Boolean;
      
      private var enbld:Boolean;
      
      private var help_sign:SimpleButton;
      
      public function CamUI(param1:Cam3D, param2:Sprite)
      {
         super();
         this.bin = Bin.get_instance();
         this.cam = param1;
         this.camUI_spr = param2;
         this.camUI_spr.visible = false;
         this.zoomRotate_spr = Sprite(param2.getChildByName("zoomRotate_spr"));
         this.elevation_spr = Sprite(param2.getChildByName("elevation_spr"));
         this.resetCamBtn_mc = MovieClip(param2.getChildByName("resetCamBtn_mc"));
         this.closeUpCamBtn_mc = MovieClip(param2.getChildByName("closeUpCamBtn_mc"));
         this.aimFollowCamBtn_mc = MovieClip(param2.getChildByName("aimFollowCamBtn_mc"));
         this.weevilCamBtn_mc = MovieClip(param2.getChildByName("weevilCamBtn_mc"));
         var _loc3_:Sprite = Sprite(this.zoomRotate_spr.getChildByName("joy1_spr"));
         var _loc4_:Sprite = Sprite(this.elevation_spr.getChildByName("joy2_spr"));
         this.joy1 = new Joystick(this,1,_loc3_,new Rectangle(-36,-36,72,72),7);
         this.joy2 = new Joystick(this,2,_loc4_,new Rectangle(0,-36,0,72),7);
         this.left_btn = SimpleButton(this.zoomRotate_spr.getChildByName("left_btn"));
         this.right_btn = SimpleButton(this.zoomRotate_spr.getChildByName("right_btn"));
         this.forward_btn = SimpleButton(this.zoomRotate_spr.getChildByName("forward_btn"));
         this.backward_btn = SimpleButton(this.zoomRotate_spr.getChildByName("backward_btn"));
         this.up_btn = SimpleButton(this.elevation_spr.getChildByName("up_btn"));
         this.down_btn = SimpleButton(this.elevation_spr.getChildByName("down_btn"));
         this.left_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.onLeftPress);
         this.right_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.onRightPress);
         this.forward_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.onForwardPress);
         this.backward_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.onBackwardPress);
         this.up_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.onUpPress);
         this.down_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.onDownPress);
         this.left_btn.addEventListener(MouseEvent.MOUSE_UP,this.leftRightReleased);
         this.left_btn.addEventListener(MouseEvent.MOUSE_OUT,this.leftRightReleased);
         this.right_btn.addEventListener(MouseEvent.MOUSE_UP,this.leftRightReleased);
         this.right_btn.addEventListener(MouseEvent.MOUSE_OUT,this.leftRightReleased);
         this.forward_btn.addEventListener(MouseEvent.MOUSE_UP,this.forBackReleased);
         this.forward_btn.addEventListener(MouseEvent.MOUSE_OUT,this.forBackReleased);
         this.backward_btn.addEventListener(MouseEvent.MOUSE_UP,this.forBackReleased);
         this.backward_btn.addEventListener(MouseEvent.MOUSE_OUT,this.forBackReleased);
         this.up_btn.addEventListener(MouseEvent.MOUSE_UP,this.upDownReleased);
         this.up_btn.addEventListener(MouseEvent.MOUSE_OUT,this.upDownReleased);
         this.down_btn.addEventListener(MouseEvent.MOUSE_UP,this.upDownReleased);
         this.down_btn.addEventListener(MouseEvent.MOUSE_OUT,this.upDownReleased);
         this.resetCamBtn_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.resetCam);
         this.closeUpCamBtn_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.closeUpCam);
         this.aimFollowCamBtn_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.activateAimFollowCam);
         this.weevilCamBtn_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.activateWeevilCam);
         this.resetCamBtn_mc.buttonMode = true;
         this.closeUpCamBtn_mc.buttonMode = true;
         this.aimFollowCamBtn_mc.buttonMode = true;
         this.weevilCamBtn_mc.buttonMode = true;
         this.help_sign = SimpleButton(param2.getChildByName("help_sign"));
         this.help_sign.addEventListener(MouseEvent.CLICK,this.helpSignClicked);
      }
      
      private function helpSignClicked(param1:MouseEvent) : void
      {
         var _loc2_:String = URLhandler.getPath("overlayUIs_help_FlumsFountain");
         var _loc3_:Object = Bin_extInterface.bin;
         _loc3_.loadOverlayUI(_loc2_);
      }
      
      public function enable() : void
      {
         if(!this.enbld)
         {
            this.enbld = true;
            STAGE.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            STAGE.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
            this.camUI_spr.visible = true;
            if(this.bin.crntLocID == 190)
            {
               this.help_sign.visible = true;
            }
            else
            {
               this.help_sign.visible = false;
            }
         }
      }
      
      public function disable() : void
      {
         if(this.enbld)
         {
            STAGE.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            STAGE.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
            this.enbld = false;
            this.camUI_spr.visible = false;
            this.cam.vx = this.cam.vy = this.cam.vz = 0;
         }
      }
      
      private function resetCam_MOUSE_OVER(param1:MouseEvent = null) : void
      {
      }
      
      private function closeUpCam_MOUSE_OVER(param1:MouseEvent = null) : void
      {
      }
      
      private function aimFollowCam_MOUSE_OVER(param1:MouseEvent = null) : void
      {
      }
      
      private function weevilCam_MOUSE_OVER(param1:MouseEvent = null) : void
      {
      }
      
      public function resetCamModeBtns() : void
      {
         this.followMode = false;
         this.resetCamBtn_mc.bg_mc.gotoAndStop(2);
         this.closeUpCamBtn_mc.bg_mc.gotoAndStop(1);
         this.aimFollowCamBtn_mc.bg_mc.gotoAndStop(1);
         this.weevilCamBtn_mc.bg_mc.gotoAndStop(1);
      }
      
      public function setCamModeBtns() : void
      {
         this.resetCamBtn_mc.bg_mc.gotoAndStop(1);
         this.closeUpCamBtn_mc.bg_mc.gotoAndStop(1);
         this.aimFollowCamBtn_mc.bg_mc.gotoAndStop(1);
         this.weevilCamBtn_mc.bg_mc.gotoAndStop(1);
         switch(this.bin.getCamMode())
         {
            case 0:
               this.resetCamBtn_mc.bg_mc.gotoAndStop(2);
               break;
            case 1:
               this.followMode = true;
               this.aimFollowCamBtn_mc.bg_mc.gotoAndStop(2);
               break;
            case 2:
               this.weevilCamBtn_mc.bg_mc.gotoAndStop(2);
         }
      }
      
      private function resetCam(param1:MouseEvent = null) : void
      {
         this.followMode = false;
         this.resetCamBtn_mc.bg_mc.gotoAndStop(2);
         this.closeUpCamBtn_mc.bg_mc.gotoAndStop(1);
         this.aimFollowCamBtn_mc.bg_mc.gotoAndStop(1);
         this.weevilCamBtn_mc.bg_mc.gotoAndStop(1);
         this.bin.resetBinCam(true);
      }
      
      private function closeUpCam(param1:MouseEvent = null) : void
      {
         this.followMode = false;
         this.closeUpCamBtn_mc.bg_mc.gotoAndStop(2);
         this.resetCamBtn_mc.bg_mc.gotoAndStop(1);
         this.aimFollowCamBtn_mc.bg_mc.gotoAndStop(1);
         this.weevilCamBtn_mc.bg_mc.gotoAndStop(1);
         this.bin.closeUpCam();
      }
      
      private function activateAimFollowCam(param1:MouseEvent = null) : void
      {
         this.weevilCamBtn_mc.bg_mc.gotoAndStop(1);
         this.resetCamBtn_mc.bg_mc.gotoAndStop(1);
         this.closeUpCamBtn_mc.bg_mc.gotoAndStop(1);
         if(this.aimFollowCamBtn_mc.bg_mc.currentFrame == 1)
         {
            this.followMode = true;
            this.aimFollowCamBtn_mc.bg_mc.gotoAndStop(2);
            this.bin.userSetCamMode(1);
            if(!this.cam.checkBounds())
            {
               this.cam.move_forward(21);
            }
         }
         else
         {
            this.followMode = false;
            this.aimFollowCamBtn_mc.bg_mc.gotoAndStop(1);
            this.bin.userSetCamMode(0);
         }
      }
      
      private function activateWeevilCam(param1:MouseEvent = null) : void
      {
         this.followMode = false;
         this.resetCamBtn_mc.bg_mc.gotoAndStop(1);
         this.closeUpCamBtn_mc.bg_mc.gotoAndStop(1);
         this.aimFollowCamBtn_mc.bg_mc.gotoAndStop(1);
         if(this.weevilCamBtn_mc.bg_mc.currentFrame == 1)
         {
            this.weevilCamBtn_mc.bg_mc.gotoAndStop(2);
            this.bin.userSetCamMode(2);
         }
         else
         {
            this.weevilCamBtn_mc.bg_mc.gotoAndStop(1);
            this.bin.userSetCamMode(0);
         }
      }
      
      private function freeCam() : void
      {
         if(this.followMode)
         {
         }
         this.resetCamBtn_mc.bg_mc.gotoAndStop(1);
         this.closeUpCamBtn_mc.bg_mc.gotoAndStop(1);
         this.weevilCamBtn_mc.bg_mc.gotoAndStop(1);
         this.bin.turnOffWeevilCam();
      }
      
      private function keyDownHandler(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case 37:
               this.set_vx(-10);
               break;
            case 39:
               this.set_vx(10);
               break;
            case 38:
               this.set_vz(10);
               break;
            case 40:
               this.set_vz(-10);
         }
      }
      
      private function keyUpHandler(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case 37:
            case 39:
               this.set_vx(0);
               break;
            case 38:
            case 40:
               this.set_vz(0);
         }
      }
      
      private function onLeftPress(param1:Event) : void
      {
         this.set_vx(-10);
      }
      
      private function onRightPress(param1:Event) : void
      {
         this.set_vx(10);
      }
      
      private function onForwardPress(param1:Event) : void
      {
         this.set_vz(10);
      }
      
      private function onBackwardPress(param1:Event) : void
      {
         this.set_vz(-10);
      }
      
      private function onUpPress(param1:Event) : void
      {
         this.set_vy(5);
      }
      
      private function onDownPress(param1:Event) : void
      {
         this.set_vy(-5);
      }
      
      private function leftRightReleased(param1:Event) : void
      {
         this.set_vx(0);
      }
      
      private function forBackReleased(param1:Event) : void
      {
         this.set_vz(0);
      }
      
      private function upDownReleased(param1:Event) : void
      {
         this.set_vy(0);
      }
      
      public function set_vx(param1:Number) : void
      {
         if(this.enbld)
         {
            this.cam.vx = param1;
            this.freeCam();
         }
      }
      
      public function set_vz(param1:Number) : void
      {
         if(this.enbld)
         {
            this.cam.vz = param1;
            this.freeCam();
         }
      }
      
      public function set_vy(param1:Number) : void
      {
         if(this.enbld)
         {
            this.cam.vy = param1;
            this.freeCam();
         }
      }
   }
}

