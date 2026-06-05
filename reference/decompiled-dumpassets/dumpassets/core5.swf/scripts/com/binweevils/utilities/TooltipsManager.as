package com.binweevils.utilities
{
   import com.adobe.utils.ArrayUtil;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TooltipsManager
   {
      
      private var ttt:ToolTipText;
      
      private var ios:Array;
      
      private var tips:Array;
      
      public function TooltipsManager(param1:MovieClip)
      {
         super();
         this.ttt = new ToolTipText(param1);
         this.ios = [];
         this.tips = [];
      }
      
      public function showTip(param1:String = "", param2:Object = null) : void
      {
         this.ttt.setText(param1);
         this.ttt.setPosition(param2);
         this.ttt.show();
      }
      
      public function hideTip(param1:MouseEvent = null) : void
      {
         this.ttt.hide();
      }
      
      public function setTip(param1:InteractiveObject, param2:String = "", param3:Object = null) : void
      {
         if(!ArrayUtil.arrayContainsValue(this.ios,param1))
         {
            this.ios.push(param1);
            this.tips.push([param2,param3]);
            param1.addEventListener(MouseEvent.MOUSE_OVER,this.showRegisteredTip);
            param1.addEventListener(MouseEvent.MOUSE_OUT,this.hideTip);
            param1.addEventListener(MouseEvent.MOUSE_DOWN,this.hideTip);
         }
      }
      
      private function showRegisteredTip(param1:MouseEvent) : void
      {
         var _loc2_:int = int(this.ios.indexOf(param1.target));
         if(_loc2_ >= 0)
         {
            this.showTip(this.tips[_loc2_][0],this.tips[_loc2_][1]);
         }
      }
      
      public function removeTip(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         if(param1 is Array)
         {
            _loc3_ = [];
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               _loc2_ = this.getArrayIndex(param1[_loc4_]);
               if(_loc2_ != -1)
               {
                  _loc3_.push({
                     "io":param1[_loc4_],
                     "pos":_loc2_
                  });
               }
               _loc4_++;
            }
            _loc3_.sortOn("pos",Array.NUMERIC);
            _loc4_ = int(_loc3_.length - 1);
            while(_loc4_ >= 0)
            {
               this.removeListeners(_loc3_[_loc4_].io);
               this.ios.splice(_loc3_[_loc4_].pos,1);
               this.tips.splice(_loc3_[_loc4_].pos,1);
               _loc4_--;
            }
         }
         else if(param1 is InteractiveObject)
         {
            _loc2_ = this.getArrayIndex(param1);
            if(_loc2_ != -1)
            {
               this.removeListeners(param1);
               this.ios.splice(_loc2_,1);
               this.tips.splice(_loc2_,1);
            }
         }
      }
      
      private function removeListeners(param1:InteractiveObject) : void
      {
         param1.removeEventListener(MouseEvent.MOUSE_OVER,this.showRegisteredTip);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,this.hideTip);
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.hideTip);
      }
      
      private function getArrayIndex(param1:InteractiveObject) : int
      {
         return this.ios.indexOf(param1);
      }
   }
}

