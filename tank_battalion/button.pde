class Button {
    static final int WIDTH = 360;
    static final int HEIGHT = 56;
    static final color DEFAULT_COLOR = #37c5cc;
    static final color HOVER_COLOR = #2C9EA3;
    static final color PRESSED_COLOR = #22797D;
    static final color TEXT_COLOR = 250;
    static final color STROKE_COLOR = #1f666a;
    static final color STROKE_HOVER_COLOR = #80F9FF;
    
    private int x, y;
    private String text;
    private boolean is_pressed;
    private color current_color = DEFAULT_COLOR;
    private color stroke_color = STROKE_COLOR;
    
    Button(int x, int y, String text) {
        this.x = x;
        this.y = y;
        this.text = text;
    }

    void update() {
        if (mouseX > this.x - WIDTH / 2
            && mouseX < this.x + WIDTH / 2
            && mouseY > this.y - HEIGHT / 2
            && mouseY < this.y + HEIGHT / 2) {
            if (mousePressed) {
                current_color = PRESSED_COLOR;
                this.is_pressed = true;
            } else {
                current_color = HOVER_COLOR;
                this.is_pressed = false;
            }
            stroke_color = STROKE_HOVER_COLOR;
        } else {
            current_color = DEFAULT_COLOR;
            stroke_color = STROKE_COLOR;
            this.is_pressed = false;
        }
    }

    void draw() {
        stroke(stroke_color);
        strokeWeight(4);
        fill(current_color);
        rectMode(CENTER);
        rect(this.x, this.y, WIDTH, HEIGHT);
        textAlign(CENTER, CENTER);
        textSize(36);
        fill(TEXT_COLOR);
        text(this.text, this.x, this.y - 4);
    }

    boolean is_pressed() {
        return is_pressed;
    }
}
