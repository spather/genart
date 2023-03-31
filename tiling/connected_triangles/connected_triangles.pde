
// tile height and width
final int TILEH = 20;
final int TILEW = 20;

int rows;
int cols;

int[][] rightYs;

void setup() {
  size(800, 800, P2D);
  rows = height / TILEH;
  cols = width / TILEW;

  rightYs = new int[rows][cols];

  // Initialize rightYs and bottomXs
  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      rightYs[row][col] = -1;
    }
  } 
}



void drawTile(int row, int col) {
  stroke(0, 0, 0);

  int x1 = 0;
  int y1;
  
  if (col == 0) {
    y1 = int(random(0, TILEH));
  } else {
    y1 = rightYs[row][col - 1];
  }

  int x2 = TILEW;
  int y2 = int(random(0, TILEH));
  rightYs[row][col] = y2;

  int x3 = int(random(0, TILEW));
  int y3 = TILEH;
  
  triangle(x1, y1, x2, y2, x3, y3);
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
