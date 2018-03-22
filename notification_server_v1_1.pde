//<import statements here>
import java.util.LinkedList;
//to use this, copy notification.pde, notification_listener.pde and notification_server.pde from this sketch to yours.
//Example usage below.

//name of a file to load from the data directory
String eventDataJSON1 = "ExampleData_1.json";
String eventDataJSON2 = "ExampleData_2.json";
String eventDataJSON3 = "ExampleData_3.json";

NotificationServer server;
ArrayList<Notification> notifications;
LinkedList<SamplePlayer> soundQueue = new LinkedList<SamplePlayer>();
LinkedList<String> ttsQueue = new LinkedList<String>();

Example example;
SamplePlayer currentSound;
String currentVoice;
String message;

//in your own custom class, you will implement the NotificationListener interface 
//(with the notificationReceived() method) to receive Notification events as they come in
class Example implements NotificationListener {
  ContextType context;
  boolean selectTweet;
  boolean selectEmail;
  boolean selectMissedCall;
  boolean selectTextMessage;
  boolean selectVoiceMail;
 
 private int getNumSelectedEvent() {
   int num = 0;
  if(selectTweet) {num++;}
  if(selectEmail) {num++;}
  if(selectMissedCall) {num++;}
  if(selectTextMessage) {num++;}
  if(selectVoiceMail) {num++;}
   return num;
 }
  
  
  public Example() {
  }
  
  public ContextType getContextType() {
    return context;
  }
  
 public void playNextNotification() {
   currentSound = soundQueue.remove();
     currentSound.start();

    
 }
  
  
  private void presentingContext(int typeInt, int level) {

    if (level == 4) {
      soundQueue.add(soundTable[typeInt][level-1]);
      playNextNotification();
    }
    
  }
  
  
 
  
  
  private void socializingContext(int typeInt, int level, int summary) {
    int numEvents = getNumSelectedEvent();
    soundQueue.add(soundTable[typeInt][level-1]);
    println("justaddednormalsound:" + soundQueue );
    playNextNotification();
      if (numEvents > 0 && numEvents < 4) {
        if (typeInt == 1 || typeInt == 3 || typeInt == 4) {
          //content summary notification
        soundQueue.add(soundTable[5][summary-1]);
        println("justaddedsummarysound: "  +soundQueue);
        playNextNotification();
          
        }
      }
  }
      
      
  public void playNextVoice() {
    print(ttsQueue);
    if(sp == null || sp.isPaused()) {
    currentVoice = ttsQueue.remove();
    print(currentVoice);
    ttsExamplePlayback(currentVoice);
    }
    else {
      ttsExamplePlayback(currentVoice);
    }
    
    
  }
  
  private void walkingContext(int typeInt, int level, String message) {
    int numSelected = getNumSelectedEvent();
    //only play tts if email or text
    if((typeInt == 1) || (typeInt == 3)) {
      ttsQueue.add(message);
      playNextVoice();
    }
    
    if (numSelected < 4) {
    soundQueue.add(soundTable[typeInt][level-1]);
    println("justaddednormalsound:" + soundQueue );
    playNextNotification();
    }
    else {
      if (level > 2) {
            soundQueue.add(soundTable[typeInt][level-1]);
            println("justaddednormalsound:" + soundQueue );
            playNextNotification();
       }
    }
    
  }
  
  private void gymContext(int typeInt, int level, String message, String sender) {
    if ((typeInt != 2)) {
      ttsQueue.add(sender);
      ttsQueue.add(message);
      playNextVoice();
      
    } else {
    soundQueue.add(soundTable[typeInt][level-1]);
    println("justaddednormalsound:" + soundQueue );
    playNextNotification();
      
    }
  }
  
  
  //this method must be implemented to receive notifications
  public void notificationReceived(Notification notification) { 
    
    
    int level = notification.getPriorityLevel();
    NotificationType type = notification.getType();
    int typeInt = -1;
    int summary = notification.getContentSummary();
    String message;
    String sender = notification.getSender();
    
    
    if (type == NotificationType.Tweet) {
      typeInt = 0;
    }
    else if (type == NotificationType.Email) {
      typeInt = 1;
    }
    else if (type == NotificationType.MissedCall) {
      typeInt = 2;
    }
    else if (type == NotificationType.TextMessage) {
      typeInt = 3;
    }
    else if (type == NotificationType.VoiceMail) {
      typeInt = 4;
    }
    
    if((typeInt == 0) ||( typeInt == 1) || (typeInt == 3) || (typeInt == 4)) {
      message = notification.getMessage();
    }
    else {message = null;}
    
    
    boolean selectedToHear = (typeInt == 0 && selectTweet) || (typeInt == 1 && selectEmail ) || 
                             (typeInt == 2 && selectMissedCall) || (typeInt == 3 && selectTextMessage) ||
                             (typeInt == 4 && selectVoiceMail);
    
    
    if (context == ContextType.presenting && selectedToHear) {
      presentingContext(typeInt, level);
    }
    
    if (context == ContextType.socializing && selectedToHear) {
      socializingContext(typeInt, level, summary);
    }
    
    if(context == ContextType.walking && selectedToHear) {
      walkingContext(typeInt, level, message);
    }
    
    if(context == ContextType.gym && selectedToHear) {
      gymContext(typeInt, level, message, sender);
    }
    
    
    
    //println("<Example> " + notification.getType().toString() + " notification received at " 
    //+ Integer.toString(notification.getTimestamp()) + "millis.");
    
    //String debugOutput = "";
    //switch (notification.getType()) {
    //  case Tweet:
    //    debugOutput += "New tweet from ";
    //    break;
    //  case Email:
    //    debugOutput += "New email from ";
    //    break;
    //  case VoiceMail:
    //    debugOutput += "New voicemail from ";
    //    break;
    //  case MissedCall:
    //    debugOutput += "Missed call from ";
    //    break;
    //  case TextMessage:
    //    debugOutput += "New message from ";
    //    break;
    //}
    //debugOutput += notification.getSender() + ", " + notification.getMessage();
    
    //println(debugOutput);
    
   //You can experiment with the timing by altering the timestamp values (in ms) in the exampleData.json file
    //(located in the data directory)
  }
}