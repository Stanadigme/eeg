import processing.serial.*;
//import controlP5.*;

Serial serial;
int packetCount = 0;

float[] values = new float[11];
float[] colorvalues = new float[3];
float[] tempcolorvalues = new float[3];

float sleep = 0;
float relaxed = 0;
float alert = 0;

float hue_offset = height/4;

void setup() {
  fullScreen();
  colorMode(HSB, height, 100, 100,100);
  background(0);
  noStroke();
  fill(102);

    // Set up serial connection
  println("Find your Arduino in the list below, note its [index]:\n");
  
  for (int i = 0; i < Serial.list().length; i++) {
    println("[" + i + "] " + Serial.list()[i]);
  }

  serial = new Serial(this, Serial.list()[0], 9600);
  serial.bufferUntil(10);
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

    colorvalues[0] = colorvalues[0] / sleep;
    colorvalues[1] = colorvalues[1] / relaxed;
    colorvalues[2] = colorvalues[2] / alert;
    printArray(colorvalues);
}

void draw() {
    loadPixels();
    //printArray(colorvalues);
    //color from = color(colorvalues[0],colorvalues[1],colorvalues[2]);
    //color to = color(tempcolorvalues[0],tempcolorvalues[1],tempcolorvalues[2]);
    
    /*if (colorvalues != null) {
        for (int x = 0; x < width; x++) {
          for (int y = 0; y < height; y++) {
              pixels[x+y*width] = color(colorvalues[0],colorvalues[1],colorvalues[2]);
              //pixels[x+y*width] = lerpColor(from, to, (x+y)/(width+height));
          }
        }
    }*/
    /*
      _height = variable en fonction de height
      _state = array[3] des valeurs du casque
      hue = f(_height)
      saturation = f(_state, _height)
      brightness = similaire à saturation ?
    */
    if (colorvalues != null) {
      for (int x = 0; x < height; x++) {
        for (int y = 0; y < width; y++) {
          float sat = getSat(x);
          float bri = getBri(x,y);
          //println(sat);
          //print(bri);
          //pixels[x*width+y] = color(x,sat,bri);
          pixels[x*width+y] = color(x,sat,bri);
        }
      }
    }

    updatePixels();
}

float getSat(int x) {
  float sat = 0;
  if (x < height/3) {
    sat = colorvalues[2];
  }
  else if (x < 2 * height/3) {
    sat = colorvalues[1];
  }
  else {
    sat = colorvalues[0];
  }
  return 100 * sat;
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
        if ((Integer.parseInt(incomingvalues[0]) == 200) && (i > 2)) {
          newValue = 0;
        }
        values[i] = float(newValue);
        //print(newValue);
        //println(values[i]);

    }
      setColorvalues();
    }
  }
}
