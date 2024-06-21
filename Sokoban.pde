Board board;
String fileName;
int gameWidth, gameHeight;

void settings() {
    loadConfig("config.txt");
    size(gameWidth, gameHeight);
}

void setup() {
    board = new Board(fileName);
}

void draw() {
    keyboardCheckOnDraw();
    board.update();
    board.display();
}

void loadConfig(String filename) {
    String[] lines = loadStrings(filename);
    fileName = lines[0].split(": ")[1].trim();
    String[] size = lines[1].split(": ")[1].trim().split(" ");
    gameWidth = int(size[0]);
    gameHeight = int(size[1]);
}
