package com.binweevils
{
   import com.adobe.serialization.json.JSON;
   import flash.external.ExternalInterface;
   
   public class WebSocketConnection
   {
      
      public function WebSocketConnection()
      {
         super();
         ExternalInterface.addCallback("receiveFromWS",this.receiveFromWS);
      }
      
      public function send(param1:String, param2:Object = null) : *
      {
         var _loc3_:* = param1;
         if(param2 != null)
         {
            _loc3_ += com.adobe.serialization.json.JSON.encode(param2);
         }
         else
         {
            _loc3_ += "{}";
         }
         ExternalInterface.call("sendToWS",_loc3_);
      }
      
      public function receiveFromWS(param1:String) : *
      {
         var _loc2_:Object = com.adobe.serialization.json.JSON.decode(param1);
         switch(_loc2_["cn"])
         {
            case "nest-news":
               EventManager.get_instance().dispatchEvent(new CustomEvent(BinEvents.WEB_SOCKET_NEWS_RECIEVED,_loc2_));
               break;
            case "friends.get-list":
               EventManager.get_instance().dispatchEvent(new CustomEvent(BinEvents.WEB_SOCKET_BUDDYLIST_RECIEVED,_loc2_));
               break;
            case "friends.get-weevil":
               EventManager.get_instance().dispatchEvent(new CustomEvent(BinEvents.WEB_SOCKET_BUDDYSEARCH_RECIEVED,_loc2_));
               break;
            case "friends.send-request":
               EventManager.get_instance().dispatchEvent(new CustomEvent(BinEvents.WEB_SOCKET_BUDDYREQUESTSENT_RECIEVED,_loc2_));
               break;
            case "friends.handle-request":
               EventManager.get_instance().dispatchEvent(new CustomEvent(BinEvents.WEB_SOCKET_BUDDYREQUESTREPLIED_RECIEVED,_loc2_));
               break;
            case "friends.delete":
               EventManager.get_instance().dispatchEvent(new CustomEvent(BinEvents.WEB_SOCKET_BUDDYDELETED_RECIEVED,_loc2_));
               break;
            case "conversation.new":
               EventManager.get_instance().dispatchEvent(new CustomEvent(BinEvents.WEB_SOCKET_CREATECONVERSATION_RECIEVED,_loc2_));
               break;
            case "conversation.list":
               EventManager.get_instance().dispatchEvent(new CustomEvent(BinEvents.WEB_SOCKET_CONVERSATIONLIST_RECIEVED,_loc2_));
               break;
            case "conversation.load":
               EventManager.get_instance().dispatchEvent(new CustomEvent(BinEvents.WEB_SOCKET_CONVERSATION_RECIEVED,_loc2_));
               break;
            case "weevil.get-notifications":
               EventManager.get_instance().dispatchEvent(new CustomEvent(BinEvents.WEB_SOCKET_NOTIFICATIONS_RECIEVED,_loc2_));
               break;
            case "notify.new-friendship-request":
               EventManager.get_instance().dispatchEvent(new CustomEvent(BinEvents.WEB_SOCKET_NOTIFY_NEWINVITE,_loc2_));
               break;
            case "notify.handle-friendship-request":
               EventManager.get_instance().dispatchEvent(new CustomEvent(BinEvents.WEB_SOCKET_BUDDYREQUEST_HANDLED,_loc2_));
               break;
            case "notify.new-conversation-message":
               EventManager.get_instance().dispatchEvent(new CustomEvent(BinEvents.WEB_SOCKET_NOTIFY_NEWMESSAGE,_loc2_));
               break;
            case "notify.login":
               EventManager.get_instance().dispatchEvent(new CustomEvent(BinEvents.WEB_SOCKET_NOTIFY_BUDDYLOGIN,_loc2_));
               break;
            case "notify.logout":
               EventManager.get_instance().dispatchEvent(new CustomEvent(BinEvents.WEB_SOCKET_NOTIFY_BUDDYLOGOUT,_loc2_));
               break;
            case "notify.delete-friendship":
               EventManager.get_instance().dispatchEvent(new CustomEvent(BinEvents.WEB_SOCKET_NOTIFY_DELETED,_loc2_));
         }
      }
   }
}

