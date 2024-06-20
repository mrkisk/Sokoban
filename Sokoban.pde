Board board;

void settings() {
    size(900, 900);
}

void setup() {
    board = new Board("data4.txt");
}

void draw() {
    keyboardCheckOnDraw();
    board.update();
    board.display();
}
