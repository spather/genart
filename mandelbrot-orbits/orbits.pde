// Implementation of the Mandelbrot orbits, as seen in
// https://youtu.be/FFftmWSzgmk and https://www.geogebra.org/m/BUVhcRSv

// Axis class that maps a range of pixels to a range of floating point values
class Axis {
  float axisMin, axisMax;
  int pixelsMin, pixelsMax;
  Axis(float axisMin, float axisMax, int pixelsMin, int pixelsMax) {
    this.axisMin = axisMin;
    this.axisMax = axisMax;
    this.pixelsMin = pixelsMin;
    this.pixelsMax = pixelsMax;
  }
  
  float fromPixel(int pixelVal) {
    return map(pixelVal, this.pixelsMin, this.pixelsMax, this.axisMin, this.axisMax);
  }
  
  int toPixel(float axisVal) {
    return int(map(axisVal, this.axisMin, this.axisMax, this.pixelsMin, this.pixelsMax));    
  }
}

void adjustAxisScale(Axis axis, float scaleFactor) {
  // Scale is the ratio of the range of axis values to range of pixel values.
  int pixelsRange = axis.pixelsMax - axis.pixelsMin;
  float scale = (axis.axisMax - axis.axisMin) / pixelsRange;
  scale *= scaleFactor;
  axis.axisMin = scale * (-pixelsRange/2);
  axis.axisMax = scale * (pixelsRange/2);
}

// C = a + bi
float Ca = 0; // Real part of `C`
float Cb = 0; // Imaginary part of `C`

int POINT_RADIUS = 10;

void drawPoint(float x, float y) {
  ellipse(xaxis.toPixel(x), yaxis.toPixel(y), POINT_RADIUS, POINT_RADIUS);
}

void drawC() {
  fill(255);
  stroke(255);
  drawPoint(Ca, Cb);
}

boolean overC(int x, int y) {
  int cx = xaxis.toPixel(Ca);
  int cy = yaxis.toPixel(Cb);
  
  return (pow(x - cx, 2) + pow(y - cy, 2)) < pow(POINT_RADIUS, 2);
}

// Set an arbitrary upper bound for either component of a complex number.
// I believe that anything where the magnitude of the complex number goes
// above 2 can be rejected but just doing something simple now and checking
// each component against an arbitrary max.
float MAX_COMPONENT_VALUE = 10;
boolean isOutOfRange(float a, float b) {
  return abs(a) > MAX_COMPONENT_VALUE || abs(b) > MAX_COMPONENT_VALUE;
}

void drawOrbitPoints(int maxPoints) {
  assert maxPoints > 1;
  
  float[] zas = new float[maxPoints];
  zas[0] = 0;
  float[] zbs = new float[maxPoints];
  zbs[0] = 0;
  
  int numPoints = 1;
  for (int i = 1; i < maxPoints; i++) {
    float prevA = zas[i-1];
    float prevB = zbs[i-1];
    
    zas[i] = (pow(prevA, 2) - pow(prevB, 2)) + Ca;
    zbs[i] = 2 * prevA * prevB + Cb;
    
    // If anything we computed is either Infinity or NaN, 
    // stop computing more points.
    if (
      Float.isNaN(zas[i]) || 
      Float.isInfinite(zas[i]) || 
      Float.isNaN(zbs[i]) || 
      Float.isInfinite(zbs[i]) || 
      isOutOfRange(zas[i], zbs[i])
    ) {
      break; 
    }
    numPoints++;
  }
  
  // draw line segments
  stroke(0);
  for (int i = 1; i < numPoints; i++) {
    line(
      xaxis.toPixel(zas[i-1]), 
      yaxis.toPixel(zbs[i-1]), 
      xaxis.toPixel(zas[i]), 
      yaxis.toPixel(zbs[i])
    );
  }
  
  fill(153);
  stroke(255);
  for (int i = 0; i < numPoints; i++) {
    drawPoint(zas[i], zbs[i]);
  }  
}

Axis xaxis;
Axis yaxis;

void setup() {
  size(1000, 1000, P2D);  
    
  // Create a scaled axes on top of the screen pixels that allow
  // moving the viewport and allow zooming in/out to arbitrary scales.
  float initialScale = 0.001; // Each pixel corresponds to `ax_scale` value
  xaxis = new Axis(initialScale*(-width/2), initialScale*(width/2), 0, width);
  yaxis = new Axis(initialScale*(-height/2), initialScale*(height/2), 0, height);
}

int panSpeedX = 0;
int panSpeedY = 0;
float scalingFactor = 0;

void draw() {
  background(192, 64, 0);
  
  // Adjust the axes based on current panning speed and scaling factor
  if (panSpeedX != 0) {
    float dx = xaxis.fromPixel(panSpeedX) - xaxis.axisMin;
    xaxis.axisMin += dx;
    xaxis.axisMax += dx;
  }

  if (panSpeedY != 0) {
    float dy = yaxis.fromPixel(panSpeedY) - yaxis.axisMin;
    yaxis.axisMin += dy;
    yaxis.axisMax += dy;
  }
  
  if (scalingFactor != 0) {
    adjustAxisScale(xaxis, scalingFactor);
    adjustAxisScale(yaxis, scalingFactor);    
  }

  // draw axes (x = 0 and y = 0 in the scaled axes)
  line(0, yaxis.toPixel(0.0), width, yaxis.toPixel(0.0));
  line(xaxis.toPixel(0.0), 0, xaxis.toPixel(0.0), height);

  drawOrbitPoints(25);
  drawC();
}

boolean moving = false; 
void mousePressed() {
  moving = overC(mouseX, mouseY);
}

void mouseReleased() {
  moving = false;
}

void mouseDragged() {
  if (moving) {
    Ca = xaxis.fromPixel(mouseX);
    Cb = yaxis.fromPixel(mouseY);
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      panSpeedX = 10;
    } else if (keyCode == RIGHT) {
      panSpeedX = -10;
    } else if (keyCode == UP) {
      panSpeedY = 10;      
    } else if (keyCode == DOWN) {
      panSpeedY = -10;      
    }
  } else if (key == 'x' || key == 'X') {
    scalingFactor = 0.96;
  } else if (key == 'z' || key == 'Z') {
    scalingFactor = 1.04;
  }
}


void keyReleased() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      panSpeedX = 0;
    } else if (keyCode == RIGHT) {
      panSpeedX = 0;
    } else if (keyCode == UP) {
      panSpeedY = 0;      
    } else if (keyCode == DOWN) {
      panSpeedY = 0;      
    }
  } else if (key == 'x' || key == 'X') {
    scalingFactor = 0;
  } else if (key == 'z' || key == 'Z') {
    scalingFactor = 0;
  }
}
