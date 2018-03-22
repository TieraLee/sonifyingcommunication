import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;
import beads.SamplePlayer.LoopType;

enum ContextType {gym, walking, socializing, presenting}

//declare global variables at the top of your sketch
//AudioContext ac; is declared in helper_functions



ControlP5 p5;
CheckBox eventTypes;
ContextType context;
CheckBox heartBeat;

//background noises
SamplePlayer gymNoise;
SamplePlayer walkingNoise;
SamplePlayer socializingNoise;
SamplePlayer presentingNoise;
SamplePlayer heartbeatNoise;



//table to hold all alerts and priorties
SamplePlayer[][] soundTable = new SamplePlayer[6][4];

//Tweet noises
SamplePlayer tweet1;
SamplePlayer tweet2;
SamplePlayer tweet3;
SamplePlayer tweet4;



//Email noises
SamplePlayer email1;
SamplePlayer email2;
SamplePlayer email3;
SamplePlayer email4;

//Missed Call Noises
SamplePlayer call1;
SamplePlayer call2;
SamplePlayer call3;
SamplePlayer call4;

//Text Message Noises
SamplePlayer text1;
SamplePlayer text2;
SamplePlayer text3;
SamplePlayer text4;

//VoiceMail Noises
SamplePlayer voiceMail1;
SamplePlayer voiceMail2;
SamplePlayer voiceMail3;
SamplePlayer voiceMail4;

//contentSummaryNoises
SamplePlayer content1;
SamplePlayer content2;
SamplePlayer content3;





Gain gymNoiseGain;
Gain walkingNoiseGain;
Gain socializingNoiseGain;
Gain presentingNoiseGain;
Gain heartbeatNoiseGain;


Gain tweetGain;
Gain emailGain;
Gain missedCallGain;
Gain textGain;
Gain voiceMailGain;
Gain contentGain;
//Glide masterGlide;
//Gain masterGain;
//end global variables

//runs once when the Play button above is pressed
void setup() {
  size(500, 500); //size(width, height) must be the first line in setup()
  ac = new AudioContext(); //AudioContext ac; is declared in helper_functions
 
  
  gymNoise = getSamplePlayer("gymCombination.wav");
  gymNoise.pause(true);
  gymNoise.setLoopType(LoopType.LOOP_FORWARDS);

  walkingNoise = getSamplePlayer("walkingCombination.wav");
  walkingNoise.pause(true);
  walkingNoise.setLoopType(LoopType.LOOP_FORWARDS);
  

  context = ContextType.gym;  socializingNoise = getSamplePlayer("216011__brainwaves8__bistro.wav");
  socializingNoise.pause(true);
  socializingNoise.setLoopType(LoopType.LOOP_FORWARDS);
  
  presentingNoise = getSamplePlayer("presentingCombination.mp3");
  presentingNoise.pause(true);
  presentingNoise.setLoopType(LoopType.LOOP_FORWARDS);
  
  heartbeatNoise = getSamplePlayer("windchimes.wav");
  heartbeatNoise.pause(true);
  heartbeatNoise.setLoopType(LoopType.LOOP_FORWARDS);
  
  
  
  tweet1 = getSamplePlayer("tweet.wav");
  tweet1.pause(true);
  tweet1.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    tweet1.setToLoopStart();
    tweet1.pause(true);
    //soundQueue.remove();
    } 
  });
  
  tweet2 = getSamplePlayer("Tweet 2.wav");
  tweet2.pause(true);
  tweet2.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    tweet2.setToLoopStart();
    tweet2.pause(true);
    //soundQueue.remove();
    } 
  });
  
  tweet3 = getSamplePlayer("Tweet 3.wav");
  tweet3.pause(true);
  
  tweet3.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    tweet3.setToLoopStart();
    tweet3.pause(true);
    //soundQueue.remove();
    } 
  });
  
  tweet4 = getSamplePlayer("Tweet 4.wav");
  tweet4.pause(true);
  tweet4.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    tweet4.setToLoopStart();
    tweet4.pause(true);
    //soundQueue.remove();
    } 
  });
  
  soundTable[0][0] = tweet1;
  soundTable[0][1] = tweet2;
  soundTable[0][2] = tweet3;
  soundTable[0][3] = tweet4;
  
  
  email1 = getSamplePlayer("email1.wav");
  email1.pause(true);
  email1.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    email1.setToLoopStart();
    email1.pause(true);
    //soundQueue.remove();
    print(soundQueue);
    } 
  });
  
  email2 = getSamplePlayer("email2.wav");
  email2.pause(true);
  email2.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    email2.setToLoopStart();
    email2.pause(true);
    //soundQueue.remove();
    } 
  });
  
  email3 = getSamplePlayer("email3.wav");
  email3.pause(true);
  email3.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    email3.setToLoopStart();
    email3.pause(true);
    //soundQueue.remove();
    } 
  });
  
  email4 = getSamplePlayer("email4.wav");
  email4.pause(true);
  email4.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    email4.setToLoopStart();
    email4.pause(true);
    //soundQueue.remove();
    } 
  });
  
  soundTable[1][0] = email1;
  soundTable[1][1] = email2;
  soundTable[1][2] = email3;
  soundTable[1][3] = email4;
  
  
  call1 = getSamplePlayer("phone1.wav");
  call1.pause(true);
  call1.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    call1.setToLoopStart();
    call1.pause(true);
    //soundQueue.remove();
    } 
  });
  
  call2 = getSamplePlayer("phone2.wav");
  call2.pause(true);
  call2.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    call2.setToLoopStart();
    call2.pause(true);
    //soundQueue.remove();
    } 
  });
  
  call3 = getSamplePlayer("phone3.wav");
  call3.pause(true);
  call3.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    call3.setToLoopStart();
    call3.pause(true);
    //soundQueue.remove();
    } 
  });
  
  call4 = getSamplePlayer("phone4.wav");
  call4.pause(true);
  call4.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    call4.setToLoopStart();
    call4.pause(true);
    //soundQueue.remove();
    } 
  });
  
  soundTable[2][0] = call1;
  soundTable[2][1] = call2;
  soundTable[2][2] = call3;
  soundTable[2][3] = call4;
  
  text1 = getSamplePlayer("text1.mp3");
  text1.pause(true);
  text1.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    text1.setToLoopStart();
    text1.pause(true);
    //soundQueue.remove();
    } 
  });
  
  text2 = getSamplePlayer("text2.mp3");
  text2.pause(true);
  text2.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    text2.setToLoopStart();
    text2.pause(true);
    //soundQueue.remove();
    } 
  });
  
  text3 = getSamplePlayer("text3.mp3");
  text3.pause(true);
  text3.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    text3.setToLoopStart();
    text3.pause(true);
    //soundQueue.remove();
    } 
  });
  
  text4 = getSamplePlayer("text4.mp3");
  text4.pause(true);
  text4.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    text4.setToLoopStart();
    text4.pause(true);
    //soundQueue.remove();
    } 
  });
  
  soundTable[3][0] = text1;
  soundTable[3][1] = text2;
  soundTable[3][2] = text3;
  soundTable[3][3] = text4;


  voiceMail1 = getSamplePlayer("voicemail1.wav");
  voiceMail1.pause(true);
  voiceMail1.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    voiceMail1.setToLoopStart();
    voiceMail1.pause(true);
    //soundQueue.remove();
    } 
  });
  
  voiceMail2 = getSamplePlayer("voicemail2.wav");
  voiceMail2.pause(true);
  voiceMail2.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    voiceMail2.setToLoopStart();
    voiceMail2.pause(true);
    //soundQueue.remove();
    } 
  });
  
  voiceMail3 = getSamplePlayer("voicemail3.wav");
  voiceMail3.pause(true);
   voiceMail3.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    voiceMail3.setToLoopStart();
    voiceMail3.pause(true);
    //soundQueue.remove();
    } 
  });
  
  voiceMail4 = getSamplePlayer("voicemail4.wav");
  voiceMail4.pause(true);
  voiceMail4.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    voiceMail4.setToLoopStart();
    voiceMail4.pause(true);
    //soundQueue.remove();
    } 
  });
  
  soundTable[4][0] = voiceMail1;
  soundTable[4][1] = voiceMail2;
  soundTable[4][2] = voiceMail3;
  soundTable[4][3] = voiceMail4;
  
  
  content1 = getSamplePlayer("summaryNegative.mp3");
  content1.pause(true);
  content1.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    content1.setToLoopStart();
    content1.pause(true);
    //soundQueue.remove();
    print(soundQueue);
    } 
  });
  
  content2 = getSamplePlayer("summaryNeutral.mp3");
  content2.pause(true);
  //content2.setEndListener(new Bead() {
  //  public void messageReceived(Bead mess) {
  //  content2.setToLoopStart();
  //  content2.pause(true);
  //  soundQueue.remove();
  //  } 
  //});
  
  content3 = getSamplePlayer("summaryPositive.mp3");
  content3.pause(true);
  //content3.setEndListener(new Bead() {
  //  public void messageReceived(Bead mess) {
  //  content3.setToLoopStart();
  //  content3.pause(true);
  //  soundQueue.remove();
  //  } 
  //});

  
  soundTable[5][0] = content1;
  soundTable[5][1] = content2;
  soundTable[5][2] = content3;

  
  //masterGlide = new Glide(ac,0.0,1);

  gymNoiseGain = new Gain(ac,1);
  gymNoiseGain.addInput(gymNoise);
  
  walkingNoiseGain = new Gain(ac, 1);
  walkingNoiseGain.addInput(walkingNoise);
  
  socializingNoiseGain = new Gain(ac, 1);
  socializingNoiseGain.addInput(socializingNoise);
  
  presentingNoiseGain = new Gain(ac, 1);
  presentingNoiseGain.addInput(presentingNoise);
  
  heartbeatNoiseGain = new Gain(ac,1);
  heartbeatNoiseGain.addInput(heartbeatNoise);
  
  
  tweetGain = new Gain(ac,4);
  tweetGain.addInput(tweet1);
  tweetGain.addInput(tweet2);
  tweetGain.addInput(tweet3);
  tweetGain.addInput(tweet4);
  
  
  emailGain = new Gain(ac,4);
  emailGain.addInput(email1);
  emailGain.addInput(email2);
  emailGain.addInput(email3);
  emailGain.addInput(email4);
  
  missedCallGain = new Gain(ac,4);
  missedCallGain.addInput(call1);
  missedCallGain.addInput(call2);
  missedCallGain.addInput(call3);
  missedCallGain.addInput(call4);
  
  textGain = new Gain(ac,4);
  textGain.addInput(text1);
  textGain.addInput(text2);
  textGain.addInput(text3);
  textGain.addInput(text4);
  
  voiceMailGain = new Gain(ac,4);
  voiceMailGain.addInput(voiceMail1);
  voiceMailGain.addInput(voiceMail2);
  voiceMailGain.addInput(voiceMail3);
  voiceMailGain.addInput(voiceMail4);
  
  contentGain = new Gain(ac,3);
  contentGain.addInput(content1);
  contentGain.addInput(content2);
  contentGain.addInput(content3);
  
  ac.out.addInput(gymNoiseGain);
  ac.out.addInput(walkingNoiseGain);
  ac.out.addInput(socializingNoise);
  ac.out.addInput(presentingNoise);
  ac.out.addInput(heartbeatNoise);
  
  //this will create WAV files in your data directory from input speech 
  //which you will then need to hook up to SamplePlayer Beads
  ttsMaker = new TextToSpeechMaker();
  
  
  ac.out.addInput(tweetGain);
  ac.out.addInput(emailGain);
  ac.out.addInput(missedCallGain);
  ac.out.addInput(textGain);
  ac.out.addInput(voiceMailGain);
  ac.out.addInput(contentGain);
  ac.start();
  
  
  //control p5l
  p5 = new ControlP5(this);
  p5.addButton("treadmill")
  .setPosition(150,150)
  .setSize(50,50);
  
  p5.addButton("walking")
  .setPosition(225,150)
  .setSize(50,50);
  
    p5.addButton("socializing")
  .setPosition(300,150)
  .setSize(50,50);
  
   p5.addButton("presenting")
  .setPosition(375,150)
  .setSize(50,50);
  
  
  p5.addButton("stream1")
  .setPosition(150,225)
  .setSize(50,50);
  
  p5.addButton("stream2")
  .setPosition(225,225)
  .setSize(50,50);
  
   p5.addButton("stream3")
  .setPosition(300, 225)
  .setSize(50,50);
  
  eventTypes = p5.addCheckBox("events")
    .setPosition(100,300)
    .setSize(20,20)
    .setItemsPerRow(5)
    .setSpacingColumn(50)
    .addItem("Twitter",1)
    .addItem("Email", 2)
    .addItem("MissedCall", 3)
    .addItem("Text", 4)
    .addItem("VoiceMail", 5);
                  
    heartBeat = p5.addCheckBox("heart")
    .setPosition(150,350)
    .setSize(20,20)
    .addItem("heartbeat", 1);
   
      
  //START NotificationServer setup
  server = new NotificationServer();
  
  //instantiating a custom class (seen below) and registering it as a listener to the server
  example = new Example();
  server.addListener(example);
  
}



void draw() {
  background(255);  //fills the canvas with black (0) each frame
  fill(101, 244, 66);
  rect(50,100,400,300);
  
  fill(0);
  text("Context", 75,185);
  text("Event Stream", 70, 260);
  text("Events", 60, 315);
}

void treadmill() { //<>//
  walkingNoise.pause(true);
  socializingNoise.pause(true);
  presentingNoise.pause(true);
  gymNoise.start();
  example.context = ContextType.gym;
  
}

void walking() {
  gymNoise.pause(true);
  socializingNoise.pause(true);
  presentingNoise.pause(true);
  walkingNoise.start();
  example.context = ContextType.walking;
}

void socializing() {
  walkingNoise.pause(true);
  gymNoise.pause(true);
  presentingNoise.pause(true);
  socializingNoise.start();
  example.context = ContextType.socializing;
}

void presenting() {
  walkingNoise.pause(true);
  gymNoise.pause(true);
  socializingNoise.pause(true);
  presentingNoise.start();
  example.context = ContextType.presenting;
}

void stream1() {
  server.stopEventStream(); //always call this before loading a new stream
  server.loadEventStream(eventDataJSON1);
  println("**** New event stream loaded: " + eventDataJSON1 + " ****");
}

void stream2() {
  server.stopEventStream(); //always call this before loading a new stream
  server.loadEventStream(eventDataJSON2);
  println("**** New event stream loaded: " + eventDataJSON2 + " ****");
}

void stream3() {
  server.stopEventStream(); //always call this before loading a new stream
  server.loadEventStream(eventDataJSON3);
  println("**** New event stream loaded: " + eventDataJSON3 + " ****");
  
}

void controlEvent(ControlEvent event) {
  if(event.isFrom(heartBeat)) {
    if (heartBeat.getState("heartbeat")) {
      heartbeatNoise.start();
    }
    else {
      heartbeatNoise.pause(true);
    }
  }
  
  if(event.isFrom(eventTypes)) {
     example.selectTweet = eventTypes.getState("Twitter");
     example.selectTextMessage = eventTypes.getState("Text");
     example.selectEmail = eventTypes.getState("Email");
     example.selectMissedCall = eventTypes.getState("MissedCall");
     example.selectVoiceMail = eventTypes.getState("VoiceMail");

  }
  
}