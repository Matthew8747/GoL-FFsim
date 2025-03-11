
int[][] board, tempBoard;
int columnCount, rowCount;
int scale;
float growthProbability = 0.001;
float growthBoostNearWater = 0.01; 
float maturityProbability = 0.02; 
float fireProbabilityYoung = 0.002; 
float fireProbabilityMature = 0.00005; 
float fireSpreadChance = 0.8; 
float droughtMultiplier = 1.0; 
boolean isDrought = false; 

// Weather variables
int weatherState = 0; // 0 = Normal, 1 = Rain, 2 = Heatwave
float weatherChangeProbability = 0.002; // Chance to change weather each frame
int rainDuration = 0;
int heatwaveDuration = 0;


// Wind mechanics
float windStrength = 0.4; // Higher values push fire faster
int windDirection = 1; // 1 = East, -1 = West

void setup() {
  size(900, 1000);
  scale = 5;
  rowCount = height / scale;
  columnCount = width / scale;
  board = new int[rowCount][columnCount];
  tempBoard = new int[rowCount][columnCount];

  generateTerrain();
  noStroke();
}

void draw() {
  background(0);
  int totalTrees = 0, burningTrees = 0, emptyLand = 0, waterCells = 0;


  for (int r = 0; r < rowCount; r++) {
    for (int c = 0; c < columnCount; c++) {
      if (board[r][c] == 0) {
        fill(0);
        emptyLand++;
      } else if (board[r][c] == 1) {
        fill(173, 255, 47); 
        totalTrees++;
      } else if (board[r][c] == 2) {
        fill(0, 128, 0); 
        totalTrees++;
      } else if (board[r][c] == 3) {
        fill(255, 69, 0); 
        burningTrees++;
      } else if (board[r][c] == 4) {
        fill(255, 140, 0); 
      } else if (board[r][c] == 5) {
        fill(50, 50, 50); 
      } else if (board[r][c] == 6) {
        fill(0, 0, 255); 
        waterCells++;
      }
      rect(c * scale, r * scale, scale, scale);
    }
  }
  int totalLandCells = rowCount * columnCount - waterCells;
  float forestCoverage = (totalTrees / (float) totalLandCells) * 100;
  float firePercentage = (burningTrees / (float) totalTrees) * 100;
  String windDir = (windDirection == 1) ? "→ East" : "← West";
  
  fill(255);
  textSize(16);
  text("Fire Simulation Stats", 10, 20);
  text("Forest Coverage: " + nf(forestCoverage, 0, 1) + "%", 10, 40);
  text("Burning Trees: " + nf(firePercentage, 0, 1) + "%", 10, 60);
  text("Wind: " + windDir + " (" + nf(windStrength * 100, 0, 1) + "% spread boost)", 10, 80);
  text("Drought Mode: " + (isDrought ? "ON (fire*2.5)" : "OFF"), 10, 100);

  update();
}

void generateTerrain() {
  for (int r = 0; r < rowCount; r++) {
    for (int c = 0; c < columnCount; c++) {
      if (random(1) > 0.7) board[r][c] = 2; 
      else board[r][c] = 0;
    }
  }

  int numPools = int(random(3, 6)); 
  for (int i = 0; i < numPools; i++) {
    int startR = int(random(rowCount));
    int startC = int(random(columnCount));
    generateWaterPool(startR, startC, int(random(4, 8))); 
  }
}

void generateWaterPool(int r, int c, int size) {
  for (int dr = -size; dr <= size; dr++) {
    for (int dc = -size; dc <= size; dc++) {
      int nr = (r + dr + rowCount) % rowCount;
      int nc = (c + dc + columnCount) % columnCount;
      if (random(1) < 0.7) board[nr][nc] = 6; 
    }
  }
}

void update() {
  if(mousePressed){
    int c = mouseX / scale;
    int r = mouseY / scale;
    board[r][c] = 3; 
  }
  if (random(1) < 0.002) { 
    isDrought = !isDrought; 
    droughtMultiplier = isDrought ? 2.5 : 1.0; 
  }

  if (random(1) < 0.01) { 
    windDirection = (random(1) < 0.5) ? 1 : -1; 
  }

  for (int r = 0; r < rowCount; r++) {
    for (int c = 0; c < columnCount; c++) {
      if (board[r][c] == 6) tempBoard[r][c] = 6; 
      else if (board[r][c] == 3) tempBoard[r][c] = 4; 
      else if (board[r][c] == 4) tempBoard[r][c] = 5; 
      else if (board[r][c] == 5) {
        if (random(1) < 0.002) tempBoard[r][c] = 0; 
        else tempBoard[r][c] = 5;
      }
      else if (board[r][c] == 1) { 
        if ((hasBurningNeighbor(r, c) && random(1) < fireSpreadChance * droughtMultiplier) || random(1) < fireProbabilityYoung) 
          tempBoard[r][c] = 3; 
        else if (random(1) < maturityProbability) 
          tempBoard[r][c] = 2; 
        else 
          tempBoard[r][c] = 1; 
      } else if (board[r][c] == 2) { 
        if ((hasBurningNeighbor(r, c) && random(1) < fireSpreadChance * droughtMultiplier) || random(1) < fireProbabilityMature) 
          tempBoard[r][c] = 3; 
        else 
          tempBoard[r][c] = 2; 
      } else if (board[r][c] == 0) { 
        float localGrowthProb = isNearWater(r, c) ? (growthProbability + growthBoostNearWater) : growthProbability;
        if (random(1) < localGrowthProb) tempBoard[r][c] = 1; 
        else tempBoard[r][c] = 0; 
      }
    }
  }

  int[][] swap = board;
  board = tempBoard;
  tempBoard = swap;
}

boolean hasBurningNeighbor(int r, int c) {
  int burningCount = 0;

  for (int deltaR = -1; deltaR <= 1; deltaR++) {
    for (int deltaC = -1; deltaC <= 1; deltaC++) {
      if (deltaR == 0 && deltaC == 0) continue;
      int neighborR = (r + deltaR + rowCount) % rowCount;
      int neighborC = (c + deltaC + columnCount) % columnCount;
      if (board[neighborR][neighborC] == 3) {
        burningCount++;
        if (deltaC == windDirection) { 
          if (random(1) < windStrength) return true; 
        }
      }
    }
  }

  if (burningCount >= 2) return true; 
  return false;
}

boolean isNearWater(int r, int c) {
  for (int deltaR = -2; deltaR <= 2; deltaR++) {
    for (int deltaC = -2; deltaC <= 2; deltaC++) {
      int neighborR = (r + deltaR + rowCount) % rowCount;
      int neighborC = (c + deltaC + columnCount) % columnCount;
      if (board[neighborR][neighborC] == 6) return true;
    }
  }
  return false;
}

void mousePressed() {
  int c = mouseX / scale;
  int r = mouseY / scale;
  board[r][c] = 0; 
}
