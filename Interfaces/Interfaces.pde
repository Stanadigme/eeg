import processing.serial.*;
//import controlP5.*;

Serial serial;
int packetCount = 0;

float[] values = new float[11];
float[] colorvalues = new float[3];

void setup() {
  fullScreen();
  background(0);
  noStroke();
  fill(102);

    // Set up serial connection
  println("Find your Arduino in the list below, note its [index]:\n");
  
  for (int i = 0; i < Serial.list().length; i++) {
    println("[" + i + "] " + Serial.list()[i]);
  }

  serial = new Serial(this, Serial.list()[2], 9600);
  serial.bufferUntil(10);
}

void setColorvalues() {
    colorvalues[0] = values[3]+values[4];
    colorvalues[1] = values[5]+values[6];
    colorvalues[2] = values[7]+values[8];
    float sleep = colorvalues[0];
    float relaxed = colorvalues[1];
    float alert = colorvalues[2];

    colorvalues[0] = colorvalues[0] / max(sleep, relaxed, alert) * 255;
    colorvalues[1] = colorvalues[1] / max(sleep, relaxed, alert) * 255;
    colorvalues[2] = colorvalues[2] / max(sleep, relaxed, alert) * 255;
    println("values : "+values[3]);
    println("colorvalues : "+colorvalues);
}

void draw() {
    loadPixels();
    printArray(colorvalues);
    
    if (colorvalues != null) {
        for (int x = 0; x < width; x++) {
          for (int y = 0; y < height; y++) {
              pixels[x+y*width] = color(colorvalues[0],colorvalues[1],colorvalues[2]);
          }
      }    
    }

    updatePixels();
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