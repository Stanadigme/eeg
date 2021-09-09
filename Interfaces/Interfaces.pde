import processing.serial.*;
//import controlP5.*;

Serial serial;
int packetCount = 0;
int serialPort = 0;

int[] values = new int[11];
float[] colorvalues = new float[3];
float[] frequency = new float[3];
float[] tempcolorvalues = new float[3];

float startColor = 0;
float endColor = height;

float sleep = 0;
float relaxed = 0;
float alert = 0;

float hue_offset = height/4;

void setColorFrequency() {
  frequency[0] = startColor;
  float deltaFreq = (endColor - startColor) / frequency.length;
  for (int i = 1; i < frequency.length; i++) {
    frequency[i] = frequency[0]+deltaFreq*i;
  }
  //printArray(frequency);
}

void init( int serialPort) {
  endColor = height;
  if (Serial.list().length > 0) {
    println("Find your Arduino in the list below, note its [index]:\n");
    for (int i = 0; i < Serial.list().length; i++) {
      println("[" + i + "] " + Serial.list()[i]);
    }
    serial = new Serial(this, Serial.list()[serialPort], 9600);
    serial.bufferUntil(10);
  }
  else {
    println("Aucun Arduino détecté ");
  }
  initParameters();
  println(Parameters);
}

void setup() {
  //fullScreen();
  size(640, 360);
  colorMode(HSB, height, width, width,100);
  background(0);
  noStroke();
  println(endColor);
  if(args != null){
    serialPort = arg[0]
  }
  init(serialPort);
  setColorFrequency();
  fill(102);

    // Set up serial connection
  
}

void setColorvalues() {
  tempcolorvalues = colorvalues;
    colorvalues[0] = values[3]+values[4];
    colorvalues[1] = values[5]+values[6];
    colorvalues[2] = values[7]+values[8];
    if (colorvalues[0] > sleep) {
      sleep = colorvalues[0];
    }
    if (colorvalues[1] > relaxed) {
      relaxed = colorvalues[1];
    }
    if (colorvalues[2] > alert) {
      alert = colorvalues[2];
    }

    printArray(colorvalues);
    for (int i = 0; i < Parameters.size(); ++i) {
      int value = values[i];
    Parameters.getJSONObject(i).setInt("value",value);
    }
}

void draw() {
    loadPixels();
    if (colorvalues != null) {
      int from_i = 0;
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            for (int i = 3; i < Parameters.size()-1; ++i) {
              if (y == Parameters.getJSONObject(i).getInt("y")){
                //int from_hue = Parameters.getJSONObject(i).getInt("hue");
                //int to_hue = Parameters.getJSONObject(i+1).getInt("hue");
                from_i = i;
                break;
              }
            }
            float e_y = float((y - Parameters.getJSONObject(from_i).getInt("y")))/float((Parameters.getJSONObject(from_i+1).getInt("y") - Parameters.getJSONObject(from_i).getInt("y")));
            float e_y_ = float((Parameters.getJSONObject(from_i+1).getInt("y") - Parameters.getJSONObject(from_i).getInt("y")))/float((y - Parameters.getJSONObject(from_i).getInt("y")));
            float e_x_bri = float(
                (Parameters.getJSONObject(from_i).getInt("value")*Parameters.getJSONObject(from_i).getInt("max"))
              )/float((
                Parameters.getJSONObject(from_i).getInt("max") * Parameters.getJSONObject(from_i).getInt("min")
              ));
            float e_x_sat = float(
                (Parameters.getJSONObject(from_i).getInt("value")*Parameters.getJSONObject(from_i).getInt("min"))
              )/float((
                Parameters.getJSONObject(from_i).getInt("min") * Parameters.getJSONObject(from_i).getInt("max")
              ));
            //println(e_y);
          pixels[x+width*y] = color(
            lerp(
              Parameters.getJSONObject(from_i).getInt("hue"),
              Parameters.getJSONObject(from_i+1).getInt("hue"),
              e_y),
            lerp(
              0,
              x,
              e_x_sat*e_y),
            lerp(
              0,
              x,
              e_x_bri*e_y));
        }
        
      }
    }
    updatePixels();
}

float getColor(int x, int y) {
  return x;
}



float getBri(int x,int y) {
  float bri = 0;
  if (x < height/3) {
    if (y < width/3) {
      bri = sleep/(sleep+relaxed+alert);
    }
    else if (y < 2 * width/3) {
      bri = relaxed/(sleep+relaxed+alert);
    }
    else {
      bri = alert/(sleep+relaxed+alert);
    }
  }
  else if (x < 2/3 * height) {
    if (y < width/3) {
      bri = sleep/(sleep+relaxed+alert);
    }
    else if (y < 2 * width/3) {
      bri = relaxed/(sleep+relaxed+alert);
    }
    else {
      bri = alert/(sleep+relaxed+alert);
    }
  }
  else {
    if (y < width/3) {
      bri = sleep/(sleep+relaxed+alert);
    }
    else if (y < 2 * width/3) {
      bri = relaxed/(sleep+relaxed+alert);
    }
    else {
      bri = alert/(sleep+relaxed+alert);
    }
  }
  return 100 * bri;
}



void serialEvent(Serial p) {
  // Split incoming packet on commas
  // See https://github.com/kitschpatrol/Arduino-Brain-Library/blob/master/README for information on the CSV packet format
  
  String incomingString = p.readString().trim();
  print("Received string over serial: ");
  println(incomingString);  
  
  String[] incomingvalues = split(incomingString, ',');

  // Verify that the packet looks legit
  if (incomingvalues.length > 1) {
    packetCount++;

    // Wait till the third packet or so to start recording to avoid initialization garbage.
    if (packetCount > 3) {
      
      for (int i = 0; i < incomingvalues.length; i++) {
        String stringValue = incomingvalues[i].trim();

      int newValue = Integer.parseInt(stringValue);

        // Zero the EEG power values if we don't have a signal.
        // Can be useful to leave them in for development.
        
        Parameters.getJSONObject(i).setInt("value",newValue);
        if (Parameters.getJSONObject(i).getInt("max")  < newValue) {
          Parameters.getJSONObject(i).setInt("max",newValue);
        }
        if (Parameters.getJSONObject(i).getInt("min")  > newValue) {
          Parameters.getJSONObject(i).setInt("min",newValue);
        }
        //values[i] = newValue;
        //print(newValue);
        //println(values[i]);
    }
    print(Parameters);
    //printArray(values);
      //setColorvalues();
    }
  }
}
