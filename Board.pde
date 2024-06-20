class Board {
    final int[] dx = {-1, 0, 1, 0};
    final int[] dy = {0, -1, 0, 1};
    int h, w;
    int[][] board;
    int x, y;
    int dir;
    int moveFrame, moveFrameMax;
    int boxMoveX, boxMoveY;
    float cellGap, cellSize, playerSize, boxSize, goalSize;
    ArrayList<int[][]> history;
    Board(String name) {
        loadBoard(name);
        dir = -1;
        moveFrame = 0;
        moveFrameMax = 5;
        cellGap = min(float(width) / w, float(height) / h);
        cellSize = cellGap * 0.95;
        playerSize = cellSize * 0.8;
        boxSize = cellSize * 0.8;
        goalSize = cellSize * 0.7;
        history = new ArrayList<int[][]>();
    }
    void loadBoard(String name) {
        String[] line = loadStrings(name);
        String[] tokens = split(line[0], ' ');
        h = int(tokens[0]);
        w = int(tokens[1]);
        board = new int[h][w];
        for (int i = 0; i < h; i++) {
            for (int j = 0; j < w; j++) {
                board[i][j] = line[j + 1].charAt(i) - '0';
            }
        }
        x = getPlayerX();
        y = getPlayerY();
    }
    void update() {
        if (dir == -1) {
            for (int i = 37; i < 41; i++) {
                dir = keyboardd[i] ? (i - 37) : dir;
            }
            if (dir != -1 && isPlayerMovable(dir)) {
                movePlayer(dir);
                moveFrame = 0;
            } else {
                dir = -1;
            }
        }
        if (dir != -1) {
            moveFrame++;
            if (moveFrame == moveFrameMax) {
                dir = -1;
                boxMoveX = -1;
                boxMoveY = -1;
            }
        } else if (keyboardd[85]) {
            undo();
        }
    }
    void display() {
        background(0);
        noStroke();
        for (int i = 0; i < h; i++) {
            for (int j = 0; j < w; j++) {
                if (!isWall(i, j)) {
                    fill(255);
                    rect(getHorizontal(i) - cellSize / 2, getVertical(j) - cellSize / 2, cellSize, cellSize);
                }
                if (isGoal(i, j)) {
                    fill(0, 255, 0);
                    rect(getHorizontal(i) - goalSize / 2, getVertical(j) - goalSize / 2, goalSize, goalSize);
                }
            }
        }
        for (int i = 0; i < h; i++) {
            for (int j = 0; j < w; j++) {
                if (isPlayer(i, j)) {
                    float px = getHorizontal(i);
                    float py = getVertical(j);
                    if (dir != -1) {
                        px = getHorizontal(i - dx[dir]) + dx[dir] * cellGap * moveFrame / moveFrameMax;
                        py = getVertical(j - dy[dir]) + dy[dir] * cellGap * moveFrame / moveFrameMax;
                    }
                    fill(255, 0, 0);
                    ellipse(px, py, playerSize, playerSize);
                }
                if (isBox(i, j)) {
                    float px = getHorizontal(i);
                    float py = getVertical(j);
                    if (dir != -1 && (i == boxMoveX && j == boxMoveY)) {
                        px = getHorizontal(i - dx[dir]) + dx[dir] * cellGap * moveFrame / moveFrameMax;
                        py = getVertical(j - dy[dir]) + dy[dir] * cellGap * moveFrame / moveFrameMax;
                    }
                    fill(0, 0, 255);
                    ellipse(px, py, boxSize, boxSize);
                }
            }
        }
    }
    float getHorizontal(int x) { return height / 2 + (x * 2 - h + 1) * cellGap / 2; }
    float getVertical(int y) { return width / 2 + (y * 2 - w + 1) * cellGap / 2; }
    
    boolean inRange(int x, int y) { return x >= 0 && x < h && y >= 0 && y < w; }
    boolean isWall(int x, int y) {  return board[x][y] == 0; }
    boolean isBox(int x, int y) { return board[x][y] == 3 || board[x][y] == 5; }
    boolean isPlayer(int x, int y) { return board[x][y] == 2 || board[x][y] == 6; }
    boolean isEmpty(int x, int y) { return board[x][y] == 1 || board[x][y] == 4; }
    boolean isGoal(int x, int y) { return board[x][y] == 4 || board[x][y] == 5 || board[x][y] == 6; }
    int getPlayerX() {
        for (int i = 0; i < h; i++) {
            for (int j = 0; j < w; j++) {
                if (isPlayer(i, j)) {
                    return i;
                }
            }
        }
        return -1;
    }
    int getPlayerY() {
        for (int i = 0; i < h; i++) {
            for (int j = 0; j < w; j++) {
                if (isPlayer(i, j)) {
                    return j;
                }
            }
        }
        return -1;
    }
    void removeBox(int x, int y) {
        if (board[x][y] == 3) {
            board[x][y] = 1;
        } else if (board[x][y] == 5) {
            board[x][y] = 4;
        }
    }
    void addBox(int x, int y) {
        if (board[x][y] == 1) {
            board[x][y] = 3;
        } else if (board[x][y] == 4) {
            board[x][y] = 5;
        }
    }
    boolean isBoxMovable(int x, int y, int dir) {
        int nx = x + dx[dir];
        int ny = y + dy[dir];
        return inRange(nx, ny) && isEmpty(nx, ny);
    }
    void moveBox(int x, int y, int dir) {
        int nx = x + dx[dir];
        int ny = y + dy[dir];
        removeBox(x, y);
        addBox(nx, ny);
        boxMoveX = nx;
        boxMoveY = ny;
    }
    void removePlayer(int x, int y) {
        if (board[x][y] == 2) {
            board[x][y] = 1;
        } else if (board[x][y] == 6) {
            board[x][y] = 4;
        }
    }
    void addPlayer(int x, int y) {
        if (board[x][y] == 1) {
            board[x][y] = 2;
        } else if (board[x][y] == 4) {
            board[x][y] = 6;
        }
    }
    boolean isPlayerMovable(int dir) {
        int nx = x + dx[dir];
        int ny = y + dy[dir];
        return inRange(nx, ny) && (isEmpty(nx, ny) || (isBox(nx, ny) && isBoxMovable(nx, ny, dir)));
    }
    void movePlayer(int dir) {
        save();
        int nx = x + dx[dir];
        int ny = y + dy[dir];
        if (isBox(nx, ny)) {
            moveBox(nx, ny, dir);
        }
        removePlayer(x, y);
        addPlayer(nx, ny);
        x = nx;
        y = ny;
    }
    void undo() {
        if (history.size() > 0) {
            board = history.remove(history.size() - 1);
            x = getPlayerX();
            y = getPlayerY();
        }
    }
    void save() {
        int[][] copy = new int[h][w];
        for (int i = 0; i < h; i++) {
            for (int j = 0; j < w; j++) {
                copy[i][j] = board[i][j];
            }
        }
        history.add(copy);
    }
}
