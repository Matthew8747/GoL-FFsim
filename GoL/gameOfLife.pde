int[][] board;
int columnCount, rowCount;
final int SCALE = 5;

void setup() {
  size(900, 1000);
  rowCount = height / SCALE;
  columnCount = width / SCALE;
  board = new int[rowCount][columnCount];

  for (int r = 0; r < rowCount; r++) {
    for (int c = 0; c < columnCount; c++) {
      board[r][c] = int(random(2)); // Randomize board
    }
  }
  noStroke();
}

void draw() {
  background(0);
  for (int r = 0; r < rowCount; r++) {
    for (int c = 0; c < columnCount; c++) {
      fill(255 * board[r][c]);
      rect(c * SCALE, r * SCALE, SCALE, SCALE);
    }
  }
  update();
}

void update() {
  int[][] tempBoard = new int[rowCount][columnCount];

  for (int r = 0; r < rowCount; r++) {
    for (int c = 0; c < columnCount; c++) {
      int neighbours = countNeighbours(r, c);
      
      if (board[r][c] == 1) {
        tempBoard[r][c] = (neighbours == 2 || neighbours == 3) ? 1 : 0;
      } else {
        tempBoard[r][c] = (neighbours == 3) ? 1 : 0;
      }
    }
  }

  // Swap board references instead of copying values
  int[][] temp = board;
  board = tempBoard;
  tempBoard = temp;
}

int countNeighbours(int r, int c) {
  int count = 0;
  int[][] neighbors = {
    {-1, -1}, {-1, 0}, {-1, 1},
    { 0, -1},         { 0, 1},
    { 1, -1}, { 1, 0}, { 1, 1}
  };

  for (int i = 0; i < 8; i++) {
    int neighbourR = (r + neighbors[i][0] + rowCount) % rowCount;
    int neighbourC = (c + neighbors[i][1] + columnCount) % columnCount;
    count += board[neighbourR][neighbourC];
  }
  
  return count;
}

// Click or drag to create life
void mousePressed() {
  createLifeAt(mouseX, mouseY);
}

// Dragging also creates life
void mouseDragged() {
  createLifeAt(mouseX, mouseY);
}

// Convert mouse position to grid and create life
void createLifeAt(int x, int y) {
  int c = x / SCALE;
  int r = y / SCALE;

  if (r >= 0 && r < rowCount && c >= 0 && c < columnCount) {
    board[r][c] = 1; // Set cell to alive
  }
}
