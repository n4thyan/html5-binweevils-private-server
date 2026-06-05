package com.binweevils.conf
{
   public class CampaignConfig
   {
      
      public static const POLICY_FILE_URL:String = "http://cdn-video.binw.net/freetoair/crossdomain.xml";
      
      public static const VIDEO_SOURCE_URL:String = "http://cdn-video.binw.net/freetoair/";
      
      public static const BUDDY_ALERT_PATH:String = "social/addEventPost";
      
      public static const BUDDY_ALERT_TYPE:String = "eventPostType";
      
      public static const BUDDY_ALERT_USER:String = "idx1";
      
      public static const BUDDY_ALERT_VALUE:String = "value";
      
      public static const TASK_COMPLETE_PATH:String = "campaignTasks/taskCompleted";
      
      public static const TASK_COMPLETE_TYPE:String = "taskID";
      
      public static const TASK_COMPLETE_USER:String = "userIDX";
      
      public static const COMPLETED_TASKS_PATH:String = "campaignTasks/getCompletedTaskIds";
      
      public static const COMPLETED_TASKS_TYPE:String = "groupID";
      
      public function CampaignConfig()
      {
         super();
      }
   }
}

