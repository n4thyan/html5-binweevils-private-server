package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.ViewPort;
   import flash.display.DisplayObject;
   import flash.errors.IllegalOperationError;
   
   public class Visual
   {
      
      public var d_o:DisplayObject;
      
      public var visID:int;
      
      public var logicID:int;
      
      public var type:String;
      
      public var subType:String;
      
      public var doorID:int;
      
      protected var _extUIDataObj:Object;
      
      protected var _boundaryObj:Object;
      
      public var displayText:String;
      
      public var link:String;
      
      public var linkWindow:String;
      
      protected var _bg:Boolean;
      
      protected var _depthOffset:Number = 0;
      
      public var redraw:Boolean;
      
      public function Visual()
      {
         super();
      }
      
      public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
      }
      
      public function set vis(param1:*) : void
      {
         this.d_o.visible = param1;
      }
      
      public function set bg(param1:*) : void
      {
         this._bg = param1;
      }
      
      public function get bg() : Boolean
      {
         return this._bg;
      }
      
      public function set depthOffset(param1:Number) : void
      {
         this._depthOffset = param1;
      }
      
      public function set_link(param1:String, param2:String) : void
      {
         throw new IllegalOperationError("Abstract method: must be overridden in a subclass");
      }
      
      public function set extUIDataObj(param1:Object) : void
      {
         throw new IllegalOperationError("Abstract method: must be overridden in a subclass");
      }
      
      public function get extUIDataObj() : Object
      {
         return this._extUIDataObj;
      }
      
      public function set boundary(param1:Object) : void
      {
         throw new IllegalOperationError("Abstract method: must be overridden in a subclass");
      }
      
      public function get boundary() : Object
      {
         return this._boundaryObj;
      }
   }
}

