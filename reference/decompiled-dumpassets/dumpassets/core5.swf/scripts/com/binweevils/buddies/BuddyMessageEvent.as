package com.binweevils.buddies
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class BuddyMessageEvent extends Event
   {
      
      public static const ON_BUDDY_LIST_DATA_AVAILABLE:String = "onBuddyListDataAvailable";
      
      public static const ON_NUM_NEW_MESSAGES:String = "onNumNewBuddyMessages";
      
      public static const ON_NEW_MESSAGE_READ:String = "onNewBuddyMessageRead";
      
      public static const ON_MESSAGE_SELECTED:String = "onBuddyMessageSelected";
      
      public static const ON_MESSAGES_CLOSED:String = "onBuddyMessagesClosed";
      
      public static const ON_REPLY_SELECTED:String = "onBuddyMessageReplySelected";
      
      public static const ON_COMPOSER_CLOSED:String = "onBuddyMessageComposerClosed";
      
      public static const ON_MESSAGE_SENT:String = "onBuddyMessageSent";
      
      public static const SHOW_BUDDY_LIST:String = "buddyMessagesShowBuddyList";
      
      public static const SHOW_BUDDY_ALERTS:String = "buddyMessagesShowBuddyAlerts";
      
      public static const SHOW_CONVERSATION_LIST:String = "buddyMessagesShowBuddyInbox";
      
      public static const SHOW_CONVERSATION_BUDDY_LIST:String = "buddyMessagesShowConversationBuddyList";
      
      public static const HIDE_CONVERSATION_BUDDY_LIST:String = "buddyMessagesHideConversationBuddyList";
      
      public static const HIDE_BUDDY_LIST:String = "buddyMessagesHideBuddyList";
      
      public static const DELETE_MESSAGE:String = "buddyMessageDelete";
      
      public static const ON_BUDDY_SELECTED:String = "onBuddyMessagesBuddySelected";
      
      public static const ON_JIGGLE_MC_AVAILABLE:String = "onBuddyMessagesTabletJiggleAvailable";
      
      public var numNew:int;
      
      public var msgInfo:BuddyMessageInfoObject;
      
      public var teaser:BuddyMessageTeaser;
      
      public var jiggleMC:MovieClip;
      
      public var msgInfoArr:Array;
      
      public function BuddyMessageEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new BuddyMessageEvent(type,bubbles,cancelable);
      }
   }
}

