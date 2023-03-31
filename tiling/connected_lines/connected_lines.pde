
// tile height and width
final int TILEH = 20;
final int TILEW = 20;

int rows;
int cols;

void setup() {
  size(800, 800, P2D);
  rows = height / TILEH;
  cols = width / TILEW;
}


boolean coinFlip() {
  return random(1) > 0.5;
}

void drawTile(int row, int col) {
  stroke(0, 0, 0);
  
  int x1 = 0; 
  int y1 = int(random(0, TILEH));
  
  final int nSegments = 10;
  for (int i = 0; i < nSegments; i++) {
    int x2;
    int y2;
    if (coinFlip()) {
        // Go horizontal;
        y2 = y1;
        x2 = int(random(0, TILEW));
    } else {
        // Go vertical;
        y2 = int(random(0, TILEH));
        x2 = x1;    
    }
  
    line(x1, y1, x2, y2);
    x1 = x2; 
    y1 = y2;
  }
  
}

void draw() {
  if (frameCount > 1) {
    return;
  }
  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      pushMatrix();
      pushStyle();
      translate(col*TILEW, row*TILEH);
      drawTile(row, col);
      popStyle();
      popMatrix();
    }
  }
}
