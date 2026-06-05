package com.binweevils
{
   import com.binweevils.engine3D.*;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.geom.Rectangle;
   
   public class Joystick
   {
      
      private var camUI:CamUI;
      
      private var type:int;
      
      private var joy_spr:Sprite;
      
      private var shaft:Array;
      
      private var head:Sprite;
      
      private var ballJoint:Sprite;
      
      private var n:int;
      
      private var dragRange:Rectangle;
      
      private var constrV:Boolean;
      
      private var constrH:Boolean;
      
      public function Joystick(param1:CamUI, param2:int, param3:Sprite, param4:Rectangle, param5:int)
      {
         super();
         this.camUI = param1;
         this.type = param2;
         this.joy_spr = param3;
         this.n = param5;
         this.shaft = new Array();
         var _loc6_:int = 0;
         while(_loc6_ < this.n)
         {
            this.shaft[_loc6_] = this.joy_spr.getChildByName("s" + _loc6_);
            _loc6_++;
         }
         this.head = this.shaft[0];
         this.dragRange = param4;
         if(this.dragRange.width == 0)
         {
            this.constrV = true;
         }
         if(this.dragRange.height == 0)
         {
            this.constrH = true;
         }
         this.ballJoint = Sprite(this.joy_spr.getChildByName("ballJoint_spr"));
         this.shaft[0].addEventListener(MouseEvent.MOUSE_DOWN,this.drag);
      }
      
      private function drag(param1:MouseEvent) : void
      {
         this.head.startDrag(true,this.dragRange);
         this.joy_spr.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.updateStick);
         if(!this.constrV)
         {
            this.head.x = this.joy_spr.mouseX;
         }
         if(!this.constrH)
         {
            this.head.y = this.joy_spr.mouseY;
         }
         this.updateStick(param1);
         this.joy_spr.stage.addEventListener(MouseEvent.MOUSE_UP,this.releaseStick);
      }
      
      private function releaseStick(param1:MouseEvent) : void
      {
         this.head.stopDrag();
         this.joy_spr.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.updateStick);
         this.joy_spr.stage.removeEventListener(MouseEvent.MOUSE_UP,this.releaseStick);
         this.head.x = this.head.y = 0;
         this.updateStick(param1);
      }
      
      private function updateStick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(!this.constrH)
         {
            _loc3_ = this.head.y;
            _loc4_ = 0.11 * _loc3_;
            _loc2_ = 1;
            while(_loc2_ < this.n)
            {
               this.shaft[_loc2_].y = _loc3_ - _loc2_ * _loc4_;
               _loc2_++;
            }
            if(this.ballJoint != null)
            {
               this.ballJoint.y = _loc3_ - (_loc2_ + 0.5) * _loc4_;
            }
         }
         if(!this.constrV)
         {
            _loc5_ = this.head.x;
            _loc6_ = 0.11 * _loc5_;
            _loc2_ = 1;
            while(_loc2_ < this.n)
            {
               this.shaft[_loc2_].x = _loc5_ - _loc2_ * _loc6_;
               _loc2_++;
            }
            if(this.ballJoint != null)
            {
               this.ballJoint.x = _loc5_ - (_loc2_ + 0.5) * _loc6_;
            }
         }
         switch(this.type)
         {
            case 1:
               _loc7_ = _loc5_ < 0 ? -_loc5_ : _loc5_;
               this.camUI.set_vx(_loc5_ * _loc7_ * 0.025);
               _loc7_ = _loc3_ < 0 ? -_loc3_ : _loc3_;
               this.camUI.set_vz(-(_loc3_ * _loc7_ * 0.025));
               break;
            case 2:
               this.camUI.set_vy(-_loc3_ * 0.5);
         }
      }
   }
}

