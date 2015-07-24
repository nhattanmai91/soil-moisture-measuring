import processing.serial.*;

final int WIDTH = 3000;
final int HEIGHT = 400;
final int TEXT_SIZE_VALUE = 10;
final int OFFSET_Y = 50;
final int OFFSET_X = 3;

Serial myPort;        // The serial port
int xPos = 1;         // horizontal position of the graph
int runs_flag = 0;
int latest_value_label = 0;

void setup () {
  // set the window size:
  size(WIDTH, HEIGHT);        

  // List all the available serial ports
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 9600);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
  // set inital background:

  background(0);
}
void draw () {
  // everything happens in the serialEvent()
}

void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');

  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString); 

    // convert to an int and map to the screen height:
    float inByte = float(inString); 
    inByte = map(inByte, 0, 500, 0, height);
    // draw the line:
    stroke(127, 34, 255);
    line(xPos, height, xPos, height - inByte);
    runs_flag+=1;
    if (runs_flag==2) {         
      draw_axis(inByte);
      latest_value_label=xPos;
    }

    if (xPos-latest_value_label > OFFSET_X*10) {
      text(int(inByte), xPos-5, height-inByte-10);
      latest_value_label = xPos;
    }    

    // at the edge of the screen, go back to the beginning:
    if (xPos >= width) {
      xPos = 0;
      latest_value_label=xPos;
      runs_flag=0;
      background(0);
    } else {
      // increment the horizontal position:
      xPos = xPos + OFFSET_X;
    }
  }
}

void draw_axis(float base) {  
  int y_base = int(height - base);  //at the sensor value

  textSize(TEXT_SIZE_VALUE+2);
  text("Soil Moisture Value", 0, 20);

  textSize(TEXT_SIZE_VALUE);  
  text(str(int(base)), 0, y_base); 
  text(str(int(base)-OFFSET_Y*2), 0, y_base+OFFSET_Y*2); 
  text(str(int(base)-OFFSET_Y), 0, y_base+OFFSET_Y); 
  text(str(int(base)+OFFSET_Y), 0, y_base-OFFSET_Y); 
  text(str(int(base)+OFFSET_Y*2), 0, y_base-OFFSET_Y*2); 



  strokeWeight(0.5);
  stroke(#A7A6A6);  

  line(0, y_base, width, y_base);
  line(0, y_base+OFFSET_Y, width, y_base+OFFSET_Y);
  line(0, y_base+OFFSET_Y*2, width, y_base+OFFSET_Y*2);
  line(0, y_base-OFFSET_Y, width, y_base-OFFSET_Y);
  line(0, y_base-OFFSET_Y*2, width, y_base-OFFSET_Y*2);
}

