/*
  Clase Punto
  
  Clase base para construir nodos con propósito diverso.
  
  Miguel Angel Norzagaray Cosío
  UABCS-DSC
*/

class Punto {
    float x, y;
    color Color;
    int k;
    Punto(float X, float Y) {
        x = X;
        y = Y;
        Color = ColorPuntoNormal;
    }
    void Dibujar(float R) {
        fill(Color);
        noStroke();
        ellipse(x, y, R, R);
    }
}

/* Fin de archivo */
