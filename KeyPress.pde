boolean [ ] keyboard = new boolean [525];
boolean [ ] keyboardd = new boolean [525];
boolean [ ] keyboardTmp = new boolean [525];

void keyPressed() {
    if (int(keyCode) < keyboard.length)
        keyboard[int(keyCode)] = true;
}

void keyReleased() {
    if (int(keyCode) < keyboard.length)
        keyboard[int(keyCode)] = false;
}

void keyboardCheckOnDraw() {
    for (int i = 0; i < keyboard.length; i++) {
        keyboardd[i] = false;
        if (keyboardTmp[i] == true && keyboard[i] == true) {
            keyboardd[i] = true;
            keyboardTmp[i] = false;
        }
        if (keyboard[i] == false) {
            keyboardTmp[i] = true;
        }
    }
}
