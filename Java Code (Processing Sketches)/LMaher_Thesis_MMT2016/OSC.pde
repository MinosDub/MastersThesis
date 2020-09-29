/**********************************************************************************************
Routine for parsing the OSC messages being sent from Max for Live and the Elektron Analog Rytm
The lists of numbers are parsed and stored as variables for later mapping in Processing
***********************************************************************************************
*/  

void oscEvent (OscMessage theOscMessage) {

  //Check for OSC messages, parse them according to type tags
  //Store received OSC values as variables
  if (theOscMessage.checkAddrPattern("/number3")==true) {
    if (theOscMessage.checkTypetag("ffffff")) {
      pitch3 = theOscMessage.get(0).floatValue();
      loudness3 = theOscMessage.get(1).floatValue();
      brightness3 = theOscMessage.get(2).floatValue();
      noisiness3 = theOscMessage.get(3).floatValue();
      attack3 = theOscMessage.get(4).floatValue();
      random4 = theOscMessage.get(5).floatValue();
      return;
    }
  }

  if (theOscMessage.checkAddrPattern("/number4")==true) {
    if (theOscMessage.checkTypetag("ffffff")) {
      pitch4 = theOscMessage.get(0).floatValue();
      loudness4 = theOscMessage.get(1).floatValue();
      brightness4 = theOscMessage.get(2).floatValue();
      noisiness4 = theOscMessage.get(3).floatValue();
      attack4 = theOscMessage.get(4).floatValue(); 
      random4 = theOscMessage.get(5).floatValue();
      return;
    }
  }
//Parse OSC data from the filters of the Analog Rytm
  if (theOscMessage.checkAddrPattern("/filters")==true) {
    if (theOscMessage.checkTypetag("ff")) {
      cutoff = theOscMessage.get(0).floatValue(); 
      resonance = theOscMessage.get(1).floatValue();
      return;
    }
  }
}