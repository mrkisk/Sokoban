Board board;

void settings() {
    size(960, 540);
}

void setup() {
    board = new Board("data4.txt");
}

void draw() {
    keyboardCheckOnDraw();
    board.update();
    board.display();
}
