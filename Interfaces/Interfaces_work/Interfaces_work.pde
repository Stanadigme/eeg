import controlP5.*; 
ControlP5 cp5;

int[] colorvalues = {0,30,180};
temp
int up = 0;
int down = 0;

void setup() {
  fullScreen();
  colorMode(HSB, 360, width, width,100);
  background(0);
  noStroke();
  
  cp5 = new ControlP5(this);
  
  cp5.addSlider("Up")
    .setPosition(15, 25) //x and y upper left corner
    .setSize(25, (height/2)-40) //(width, height)50, 250
    .setRange(0, height) //slider range low,high
    .setValue(up) //start val
    .setColorValue(color(30,100,100))
    .setBroadcast(true);
    
   cp5.addSlider("Down")
    .setPosition(15, height/2+20) //x and y upper left corner
    .setSize(25, (height/2) - 40) //(width, height)50, 250
    .setRange(0, height) //slider range low,high
    .setValue(down) //start val
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

void Up(int val) {
  up = val;
}

void Down(int val) {
  down = val;
}

void getColor(int y) {
  
}

void draw() {
    loadPixels();
    for (int x = 0; x < height; x++) {
      for (int y = 0; y < width; y++) {
        pixels[x *width+y] = color(x-up+down,width,width);
        
      }
    }
    updatePixels();
}
