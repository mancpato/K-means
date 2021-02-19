/*
  Clase Punto
  
  Clase base para construir nodos con propósito diverso.
  
  Miguel Angel Norzagaray Cosío
  UABCS-DSC
*/

class Punto {
    float x, y;
    float error;
    color Color;
    Punto(float _x, float _y) {
        x = _x;
        y = _y;
        Color = ColorPuntoNormal;
    }
    boolean mouseIn() {
        if ( dist(x,y,mouseX,mouseY)<Radio/2 )
               return true;
        return false;
    }
    void Mover(int x, int y) {
        if ( x<Radio ) 
            x = Radio+1;
        this.x = x;
        if ( y<Radio ) 
            y = Radio+1;
        if ( y > height-Radio )
            y = height-Radio-1;
        this.y = y;
    }
    void Dibujar(float R) {
        fill(this.Color);
        ellipse(x, y, R, R);
        stroke(25);
    }
}

/* Fin de archivo */
