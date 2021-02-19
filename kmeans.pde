/* 
    Agrupamiento k-means
    
    Programa de ejemplo del más básico algoritmo de agrupamiento.
     1 - Se ubican nPuntos en la ventana
     2 - Se seleccionan 3 puntos como los centroides iniciales
     3 - Se agregan puntos más agrupados. Estos serán los que
        deben ser localizados
     4 - Se aplica k means, dando a cada punto el color de su centroide
        más cercano
     5 - Se repite el paso 4 con cada click del mouse
     
    Con la tecla 'r' se reubican los centroides aleatoriamente.

    Prof. Miguel Angel Norzagaray Cosío
    UABCS/DSC, IA II
*/

int k = 3;                // Centroides, de 3 a 4
int nPuntos = 400;        // Puntos distribuidos en todo el espacio
int nAgrupados = 120;     // Puntos agrupados por clase
int Densidad = 10;        // Concentración de los grupos

int Radio = 10;
color ColorFondo = 100;
color ColorPuntoNormal = 200;
color[] ColorClase = {#FF0000, #00FF00, #0000FF, #F0F0F0, #FF00FF};

ArrayList<Punto> Puntos = new ArrayList();
ArrayList<Punto> Clases = new ArrayList();

void setup()
{
    size(800,600);
    
    // nPuntos distribuidos en toda la ventana
    for ( int i=0 ; i<nPuntos ; i++ ) {
        Punto p = new Punto(random(Radio, width-Radio),
                            random(Radio, height-Radio));
        Puntos.add(p);
    }
    
    // Las clases se forman con los puntos iniciales
    for ( int i=0 ; i<k ; i++ ) {
        int r = int(random(Puntos.size()));
        Punto p = Puntos.get(r);
        p.Color = ColorClase[i];
        Clases.add(p);  // Debiera revisarse que no se repitan
    }
    
    float Hor = width/Densidad;
    float Ver = height/Densidad;
    // Puntos adicionales agrupados
    for ( int i=0 ; i<nAgrupados ; i++ ) {
        Punto p = new Punto(width/3+random(-Hor, Hor), 
                            height/3+random(-Ver, Ver));
        Puntos.add(p);
    }
    for ( int i=0 ; i<nAgrupados ; i++ ) {
        Punto p = new Punto(2*width/3+random(-Hor, Hor), 
                            height/3+random(-Ver, Ver));
        Puntos.add(p);
    }
    for ( int i=0 ; i<nAgrupados ; i++ ) {
        Punto p = new Punto(width/2+random(-Hor, Hor), 
        // Esta línea hace fallar el algoritmo en ocasiones
        //Punto p = new Punto(2*width/3+random(-Hor, Hor), 
                            2*height/3+random(-Ver, Ver));
        Puntos.add(p);
    }
    //for ( int i=0 ; i<100 ; i++ ) {
    //    Punto p = new Punto(width/3+random(-Hor, Hor), 
    //                        2*height/3+random(-Ver, Ver));
    //    Puntos.add(p);
    //}
    Ayuda();
}

void draw()
{
    background(ColorFondo);
    
    noStroke();
    for (Punto p : Puntos) 
        p.Dibujar(Radio);
    for (Punto p : Clases ) 
        p.Dibujar(2*Radio);
    
    Iterar_k_means();

    //saveFrame("line-##.png");
    noLoop();
    //delay(500);
}

void Iterar_k_means()
{
    // Asignar puntos al centroide más cercano
    for (Punto p : Puntos) {
        float D = width;
        if ( Clases.contains(p) )
            continue;
        for (Punto q : Clases ) { 
            float d = dist(p.x, p.y, q.x, q.y);
            if ( d < D ) {
                D = d;
                p.Color = q.Color;
            }
        }
    }

    //  - Actualizar centroides por clase
    float SumaX, SumaY;
    int n;
    for (Punto q : Clases ) {
        n = 0; //<>//
        SumaX = SumaY = 0;
        for (Punto p : Puntos)
            if ( p.Color == q.Color ) {
                SumaX += p.x;
                SumaY += p.y;
                n++;
            }
        q.x = int(SumaX/n);
        q.y = int(SumaY/n);
    }
}

void mouseClicked()
{
    loop();
}

void keyPressed()
{
    if ( key != 'r'  &&  key != 'R' )
        return;
    for (Punto p : Puntos) 
        p.Color = ColorPuntoNormal;
    int i = 0;
    for (Punto C : Clases ) {
        C.x = random(width);
        C.y = random(height);
        C.Color = ColorClase[i++];
    }
    loop();
}

void Ayuda()
{
    println("UABCS/DASC, IA II: Animación del algoritmo k-means");
    println("Click izquierdo para iterar");
    println("Tecla 'r' para reiniciar centroides");
    println("¡Feliz agrupamiento!");
}

/* Fin de archivo */
 
