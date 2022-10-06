// Implementation of the Mandelbrot orbits, as seen in
// https://youtu.be/FFftmWSzgmk and https://www.geogebra.org/m/BUVhcRSv

interface Axes<TIn, TOut> {
  TOut x(TIn val);
  TOut y(TIn val);
  TIn xval(TOut x);
  TIn yval(TOut y);
}

class IdentityAxes implements Axes<Integer, Integer> {
  Integer x(Integer val) {
    return val;
  }
  Integer y(Integer val) {
    return val;
  }
  Integer xval(Integer x) {
    return x;
  }
  Integer yval(Integer y) {
    return y;
  }
}

class VirtualAxes implements Axes<Integer, Integer> {
  int xmin = 0;
  int ymin = 0;
  Axes<Integer, Integer> innerAxes;
  
  VirtualAxes(Integer xmin, Integer ymin) {
    this.xmin = xmin;
    this.ymin = ymin;
    this.innerAxes = new IdentityAxes();
  }

  VirtualAxes(int xmin, int ymin, Axes<Integer, Integer> innerAxes) {
     this.xmin = xmin;
     this.ymin = ymin;
     this.innerAxes = innerAxes;
  }

  Integer x(Integer val) {
    return this.innerAxes.x(val - xmin);
  }
  
  Integer y(Integer val) {
    return this.innerAxes.y(val - ymin);
  }

  Integer xval(Integer x) {
    return this.innerAxes.xval(x) + xmin;
  }
  
  Integer yval(Integer y) {
    return this.innerAxes.yval(y) + ymin;
  }

  void updateXMin(int dx) {
    this.xmin += dx;
  }
  
  void updateYMin(int dy) {
    this.ymin += dy;
  }
}

class ScaledAxes implements Axes<Float, Integer> {
  Float scale;
  Axes<Integer, Integer> innerAxes;
  ScaledAxes(Float scale, Axes<Integer, Integer> innerAxes) {
    this.scale = scale;
    this.innerAxes = innerAxes;
  }
  
  Integer x(Float val) {
    return innerAxes.x(int(val/scale));
  }
  
  Integer y(Float val) {
    return innerAxes.y(int(val/scale));
  }
  
  Float xval(Integer x) {
    return innerAxes.xval(x) * scale;
  }
  
  Float yval(Integer y) {
    return innerAxes.yval(y) * scale;
  }

  void adjustScale(float factor) {
    this.scale *= factor;
  }
}

VirtualAxes viewport;
ScaledAxes ax;

// C = a + bi
float Ca = 0; // Real part of `C`
float Cb = 0; // Imaginary part of `C`

int POINT_RADIUS = 10;

void drawPoint(float x, float y) {
  ellipse(ax.x(x), ax.y(y), POINT_RADIUS, POINT_RADIUS);
}

void drawC() {
  fill(255);
  stroke(255);
  drawPoint(Ca, Cb);
}

boolean overC(int x, int y) {
  int cx = ax.y(Ca);
  int cy = ax.y(Cb);
  
  return (pow(x - cx, 2) + pow(y - cy, 2)) < pow(POINT_RADIUS, 2);
}

void drawOrbitPoints(int numPoints) {
  assert numPoints > 1;
  
  float[] zas = new float[numPoints];
  zas[0] = 0;
  float[] zbs = new float[numPoints];
  zbs[0] = 0;
  
  for (int i = 1; i < numPoints; i++) {
    float prevA = zas[i-1];
    float prevB = zbs[i-1];
    zas[i] = (pow(prevA, 2) - pow(prevB, 2)) + Ca;
    zbs[i] = 2 * prevA * prevB + Cb;
  }
  
  // draw line segments
  stroke(0);
  for (int i = 1; i < numPoints; i++) {
     line(
      ax.x(zas[i-1]), 
      ax.y(zbs[i-1]), 
      ax.x(zas[i]), 
      ax.y(zbs[i])
    );
  }
  
  fill(153);
  stroke(255);
  for (int i = 0; i < numPoints; i++) {
    drawPoint(zas[i], zbs[i]);
  }  
}

void setup() {
  size(1000, 1000, P2D);  
  
  // Create a virtual axes where (0,0) is in the center
  // of the screen.
  viewport = new VirtualAxes(
    -width/2, 
    -height/2
  );
  
  // Create a scaled axes on top of the viewport that 
  // allow zooming in/out to arbitrary scales.
  float initialScale = 0.001; // Each pixel corresponds to `ax_scale` value
  ax = new ScaledAxes(
    initialScale,
    viewport
  );
}

void draw() {
  background(192, 64, 0);
  
  // draw axes (x = 0 and y = 0 in the scaled axes)
  line(0, ax.y(0.0), width, ax.y(0.0));
  line(ax.x(0.0), 0, ax.x(0.0), height);

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
    Ca = ax.xval(mouseX);
    Cb = ax.yval(mouseY);
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      viewport.updateXMin(10);
    } else if (keyCode == RIGHT) {
      viewport.updateXMin(-10);
    } else if (keyCode == UP) {      
      viewport.updateYMin(10);      
    } else if (keyCode == DOWN) {
      viewport.updateYMin(-10);      
    }
  } else if (key == 'x' || key == 'X') {
    ax.adjustScale(0.5);
  } else if (key == 'z' || key == 'Z') {
    ax.adjustScale(2);
  }
}
