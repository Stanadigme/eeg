import controlP5.*; 
ControlP5 cp5;

float[] colorvalues = new float[3];
int offset = 0;

void setup() {
  fullScreen();
  colorMode(HSB, height, width, width,100);
  background(0);
  noStroke();
  
  cp5 = new ControlP5(this);
  
  cp5.addSlider("Offset")
    .setPosition(25, 25) //x and y upper left corner
    .setSize(25, height-50) //(width, height)50, 250
    .setRange(0, height) //slider range low,high
    .setValue(offset) //start val
    .setColorValue(color(30,100,100))
    .setBroadcast(true); 
  
  for (int i=0; i< colorvalues.length ; i++) {
    cp5.addSlider(str(i))
    .setPosition(125, (height-50)/(i+1)) //x and y upper left corner
    .setSize(200, 50) //(width, height)50, 250
    .setRange(0, 100) //slider range low,high
    .setValue(50) //start val
    .setColorValue(color(height/(i+1) , 100, 100))
    .setBroadcast(true); 
    //vall color r,g,b
    //.setColorActive(color(255, 0, 0)) //mouse over color
    //.setScrollSensitivity(1)
    //.setNumberOfTickMarks(20)
  }
}

void Offset(int val) {
  offset = val;
}

void draw() {
    loadPixels();
    for (int x = 0; x < height; x++) {
      for (int y = 0; y < width; y++) {
        if (x+offset < height) {
          pixels[x*width+y] = color(x+offset,y,y);
        }
        else {
          pixels[x*width+y] = color(x-offset,width-y,width-y);
        }
      }
    }
    updatePixels();
}
