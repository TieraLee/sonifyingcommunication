import beads.*;
import org.jaudiolibs.beads.*;

//to use text to speech functionality, copy text_to_speech.pde from this sketch to yours
//example usage below

//IMPORTANT (notice from text_to_speech.pde):
//to use this you must import 'ttslib' into Processing, as this code uses the included FreeTTS library
//e.g. from the Menu Bar select Sketch -> Import Library... -> ttslib

TextToSpeechMaker ttsMaker; 
SamplePlayer sp;


void ttsExamplePlayback(String inputSpeech) {
  //create TTS file and play it back immediately
  //the SamplePlayer will remove itself when it is finished in this case
  
  String ttsFilePath = ttsMaker.createTTSWavFile(inputSpeech);
  println("File created at " + ttsFilePath);
  
  //createTTSWavFile makes a new WAV file of name ttsX.wav, where X is a unique integer
  //it returns the path relative to the sketch's data directory to the wav file
  
  //see helper_functions.pde for actual loading of the WAV file into a SamplePlayer
  
  sp = getSamplePlayer(ttsFilePath, true); 
  sp.setEndListener(new Bead() {
    public void messageReceived(Bead mess) {
    sp.setToLoopStart();
    sp.pause(true);
    if(!ttsQueue.isEmpty()) {
      currentVoice = ttsQueue.remove();
    }
    } 
  });
  //true means it will delete itself when it is finished playing
  //you may or may not want this behavior!
  
  ac.out.addInput(sp);
  sp.setToLoopStart();
  //sp.start();
  println("TTS: " + inputSpeech);
}