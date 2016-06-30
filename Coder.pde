static int ancho_inith = 100;
static int ancho_initl = 100;
static int pulsol = 20;
static int pulsoh = 50;
static int pulso = pulsol+pulsoh;
static int total = pulso*8+ancho_initl+ancho_inith;
static byte alto = 124; 
static byte bajo = 0; 
public class  Valrel
{
       public boolean[] rel = new boolean[8];;
       byte[] tiempos_rel = new byte[total];

 void asignar() 
 {
   int a=0;
   int aux=0;
     while(a<ancho_inith)
      { 
        tiempos_rel[a]= alto;
        a++;
      }
    aux = a;
    
    while(a<ancho_initl+aux)
     {
      tiempos_rel[a]= bajo;
      a++;
     }
    aux = a; 
     
    for (int j=0; j<8; j++)
     {
      aux = a;
       if (rel[j]== true)
       {
          while(a<pulsoh+aux)
           {           
            tiempos_rel[a]= alto;
            a++;
           }
          aux = a;
          while(a<pulsol+aux)
           {
            tiempos_rel[a]= bajo;
            a++;
           }
        }
      else
      { 
        while(a<pulsol+aux)
         {
          tiempos_rel[a]= alto;
          a++;
         } 
        aux = a;
        while(a<pulsoh+aux)
         {
          tiempos_rel[a]= bajo;
          a++;
         }
       }
   }
  }
}
 