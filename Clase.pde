/*
  Clase Clase
  
  Clase que concentra información sobre los agrupamientos
  
  Miguel Angel Norzagaray Cosío
  UABCS-DSC, IA II
*/

class Clase {
    color Color;
    int k;
    int Card;
    Punto Centro;
    Punto MasCercano;
    Punto MasLejano;
    float DistPromX, DistPromY;
    float DesvStdX, DesvStdY, Varianza;
    Clase(float Y, float X, color C, int K) {
        Centro = new Punto(X, Y);
        Color = C;
        k = K;
        DesvStdX = DesvStdY = -1;
        MasCercano = MasLejano = null;
    }
    void Dibujar(float R) {
        fill(Color);
        noStroke();
        ellipse(Centro.x, Centro.y, R, R);
    }
    
    // Se calculan:
    //  - los promedios de las cooredenadas por eje
    //  - la suma de diferencias y la suma de diferencias al cuadrado
    //  - el promedio de las diferencias y las desviaciones estándar
    //  - puntos más cercano y más lejano
    void CalcularDispersion() {
        // Promedios de las cooredenadas por eje
        float SumaX = 0;
        float SumaY = 0;
        int nk=0;
        for (Punto p : Puntos) {
            if ( p.k != k )
                continue;
            SumaX += p.x;
            SumaY += p.y;
            nk++;
        }
        DistPromX = SumaX/Card;
        DistPromY = SumaY/Card;
        
        // Suma de diferencias y la suma de diferencias al cuadrado
        float SumaDifX = 0;
        float SumaDifY = 0;
        float SumaDifX2 = 0;
        float SumaDifY2 = 0;
        for (Punto p : Puntos) {
            if ( p.k != k )
                continue;
            float DifX = abs(p.x - DistPromX);
            float DifY = abs(p.y - DistPromY);
            SumaDifX += DifX;
            SumaDifY += DifY;
            SumaDifX2 += DifX*DifX;
            SumaDifY2 += DifY*DifY;
        }
        
        // Promedio de las diferencias y desviaciones estándar
        DistPromX = SumaDifX/nk;
        DistPromY = SumaDifY/nk;
        DesvStdX = sqrt(SumaDifX2/Card);
        DesvStdY = sqrt(SumaDifY2/Card);
        
        Varianza = sqrt( pow(SumaDifX2/Card,2) + 
                         pow(SumaDifY2/Card,2) );
        
        
        float Dmax =0;
        float Dmin = 2*width;
        for (Punto p : Puntos) {
            if ( p.k != k )
                continue;
            float Dist;
            Dist = dist(Centro.x, Centro.y, p.x, p.y);
            if ( Dist > Dmax ) {
                MasCercano = p;
                Dmax = Dist;
            }
            if ( Dist < Dmin ) {
                MasLejano = p;
                Dmin = Dist;
            }
        }
    }
    void MostrarDispersion() {
        if ( DesvStdX<0  ||  DesvStdX != DesvStdX )
            return;
        stroke(200);
        line(Centro.x-DistPromX,Centro.y,
             Centro.x+DistPromX,Centro.y);
        line(Centro.x,Centro.y-DistPromY,
             Centro.x,Centro.y+DistPromY);

        line(Centro.x,Centro.y,MasCercano.x, MasCercano.y);
        line(Centro.x,Centro.y, MasLejano.x, MasLejano.y);
        fill(Color,128);
        noStroke();
        ellipse(Centro.x, Centro.y, 2*DesvStdX, 2*DesvStdY);
    }
};

/* Fin */
