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

int k = 3;               // Centroides, de 3 a 4
int nPuntos = 300;        // Puntos distribuidos en todo el espacio
int nAgrupados = 100;     // Puntos agrupados por clase
int Densidad = 10;        // Concentración de los grupos
int Espera = 0;
boolean AvanzarConClick = false;

int Radio = 8;
color ColorFondo = 100;
color ColorPuntoNormal = 200;
color[] ColorClase = {#FF0000, #00FF00, #0000FF, #F0F0F0, #FF00FF};

ArrayList<Punto> Puntos = new ArrayList();
ArrayList<Clase> Clases = new ArrayList();

boolean Cambio;
int Iteraciones;
float DsvStPuntos, Varianza;

void setup()
{
    size(800,600);
    Cambio = true;
    Iteraciones=0;

    // Los k centroides se generan aleatoriamente
    for ( int i=0 ; i<k ; i++ ) {
        Clase C = new Clase(random(2*Radio, width-2*Radio),
                            random(2*Radio, height-2*Radio), 
                            ColorClase[i], i);
        Clases.add(C);
    }

    // nPuntos distribuidos en toda la ventana
    for ( int i=0 ; i<nPuntos ; i++ ) {
        Punto p = new Punto(random(Radio, width-Radio),
                            random(Radio, height-Radio));
        Puntos.add(p);
    }

    // Puntos adicionales agrupados
    float Hor = width/Densidad;
    float Ver = height/Densidad;
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
        //Punto p = new Punto(width/2+random(-Hor, Hor), 
        // Esta línea hace fallar el algoritmo en ocasiones
        Punto p = new Punto(2*width/3+random(-Hor, Hor), 
                            2*height/3+random(-Ver, Ver));
        Puntos.add(p);
    }
    //for ( int i=0 ; i<100 ; i++ ) {
    //    Punto p = new Punto(width/3+random(-Hor, Hor), 
    //                        2*height/3+random(-Ver, Ver));
    //    Puntos.add(p);
    //}
    Ayuda();
    for (Clase C : Clases )
        println(C.Centro.x,C.Centro.y);
}

void draw()
{
    background(ColorFondo);
    
    noStroke();
    for (Punto p : Puntos) 
        p.Dibujar(Radio);
    for (Clase C : Clases )
        C.Dibujar(2*Radio);

    if ( frameCount>1 ) {
        Iterar_k_means();
        Iteraciones++;
    }

    //saveFrame("line-##.png");
    if ( Cambio == false ) {
        println("\nCentroides estables en "+str(Iteraciones)+" iteraciones");
        println("Clase\tPuntos\tVarianza");
        for (Clase C : Clases ) {
            C.CalcularDispersion();
            C.MostrarDispersion();
            print(" "+str(C.k)+ "\t"+str(C.Card)+
                                  "\t"+str(int(C.Varianza)));
            println("\t("+str(int(C.Centro.x))+","+str(int(C.Centro.y))+")");
        }
        noLoop();
    }
    if ( AvanzarConClick == true )
        noLoop();
    delay(Espera);
}

void Iterar_k_means()
{
    // Asignar puntos al centroide más cercano
    for (Punto p : Puntos) {
        float D = 2*width;
        for (Clase C : Clases ) { 
            float d = dist(p.x, p.y, C.Centro.x, C.Centro.y);
            if ( d < D ) {
                D = d;
                p.Color = C.Color;
                p.k = C.k;
            }
        }
    }

    //  - Actualizar centroides por clase
    float SumaX, SumaY;
    int n;
    int ClasesEstables = 0;
    for (Clase C : Clases ) {
        int xAnt = int(C.Centro.x);
        int yAnt = int(C.Centro.y);
        int x,y;
        n = 0;
        SumaX = SumaY = 0;
        for (Punto p : Puntos)
            if ( p.Color == C.Color ) {
                SumaX += p.x;
                SumaY += p.y;
                n++;
            }
        C.Centro.x = int(SumaX/n);
        C.Centro.y = int(SumaY/n);
        C.Card = n;
        if ( xAnt == int(SumaX/n)  &&  yAnt == int(SumaY/n) ) //<>//
            ClasesEstables++;
    }
    if ( ClasesEstables == k )
        Cambio = false;
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
    for (Clase C : Clases ) {
        C.Centro.x = random(2*Radio, width-2*Radio);
        C.Centro.y = random(2*Radio, height-2*Radio);
        print("\n("+str(int(C.Centro.x))+","+str(int(C.Centro.y))+")");
        C.Color = ColorClase[i++];
        C.DesvStdX = C.DesvStdY = -1;
    }
    Cambio = true;
    frameCount=1;
    Iteraciones = 0;
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
 
