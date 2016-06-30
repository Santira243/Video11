import processing.video.*;
import java.util.Date;
import processing.serial.*;
import javax.sound.sampled.*;
import java.io.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

Movie movie;
Serial myPort;                       // The serial port
String path;
Minim  minim;
MultiChannelBuffer sampleBuffer;

int[] serialInArray = new int[8];    // Where we'll put what we receive
int serialCount = 0;                 // A count of how many bytes we receive
boolean firstContact = false;        // Whether we've heard from the microcontroller

AudioOutput  output;
Sampler     sampler;

int[] [] yvals;
 
 PFont f;
 PFont f1;
 
 int box = 75;
 int esp = 10;
 boolean rectbot0=false;
 boolean rectbot1=false;
 boolean rectbot2=false;
 boolean rectbot3=false;
 boolean rectbot4=false;
 boolean rectbot5=false;
 boolean rectbot6=false;
 boolean rectbot7=false; 
 boolean edit_box=false;
 boolean edit_box_press=false;
 
 int salto;

 boolean boton0=false;
 boolean boton1=false;
 boolean boton2=false;
 boolean boton3=false;
 boolean boton4=false;
 boolean boton5=false;
 boolean boton6=false;
 boolean boton7=false; 


 String archivos[];
 String tiempo;
 String numbers; 
 int newFrame = 0;
 int movFrameRate = 30;
 Modulo[] mods;
 color inside = color(204, 102, 0);
 color grabando = color(240, 10, 0);
 int color_editbox;

 boolean grabando0= false;
 boolean grabando1= false; 
 boolean grabando2= false;
 boolean grabando3= false;
 boolean grabando4= false;
 boolean grabando5= false;
 boolean grabando6= false;
 boolean grabando7= false;

 int recordCount=0;
 int frameAct=0;
 int frameOld=0;
 
 int keyIndex = -1;
 String aux,aux2;

int a; 
//byte[] pcm_data = new byte[44100*largo];
//Valrel relees = new Valrel();
 byte[] pcm_data;
 Valrel[] relees;
 
 

void setup() {
  size(1024, 700, P2D);   
  background(0);
  // Load and play the video in a loop
  String path = sketchPath();  
  //audio
  minim  = new Minim(this);
  output = minim.getLineOut();
  sampleBuffer     = new MultiChannelBuffer( 1, 1024 );
  sampler = new Sampler( sampleBuffer, 44100, 1 );
 
  
  println("\nListing info about all files in a directory: ");
  File[] files = listFiles(path);
    for (int i = 0; i < files.length; i++) {
        File f = files[i];    
         if (f.isDirectory()) {
        String names[] = f.list();
        archivos = names;
        println (names);
      } 
   
   }

  //movie = new Movie(this, archivos[0]);
  movie = new Movie(this, "Bici.mp4");
  movie.pause();
  mods = new Modulo[getLength()];
  relees= new Valrel[getLength()];
  
  for (int index=0;index<getLength();index++)
   {
     mods[index] = new Modulo(index/30.0);
     relees[index] = new Valrel();
   }
 
   leer_archivo();  //      ------CoLOCAR un Funcion!! -
   //carga el vector visible incial
  
   pixel_inicial();  
   color_editbox = 255;
   f = createFont("SourceCodePro-Regular.ttf", 12);
   f1 =createFont("Georgia", 18);
   textFont(f);

  // Print a list of the serial ports, for debugging purposes:
  printArray(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  //String portName = Serial.list()[3];
  //myPort = new Serial(this, portName, 9600);

  aux = "00000000,";
  aux2= "00000000,";
 
 }

// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}

// This function returns all the files in a directory as an array of File objects
// This is useful if you want more info about the file
  File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }


}

void pixel_inicial(){
 yvals = new int [8] [335];
  for (int ia=0; ia< yvals.length; ia++){
    for(int ib=0; ib< yvals[ia].length; ib++) 
         {
          if(mods[ib].relee(ia))  
          yvals[ia][ib]=40+(63*ia);      
          else
          yvals[ia][ib]=80+(63*ia);      
          }
   }
 }

boolean overBot(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+700) {
    return true;
  } else {
    return false;
  }
}


void update(int x, int y) {
  
          rectbot0 = false;
          rectbot1 = false;
          rectbot2 = false;
          rectbot3 = false;
          rectbot4 = false;
          rectbot5 = false;
          rectbot6 = false;
          rectbot7 = false;
          edit_box = false;
 
 
    if (overBot(700, 550, 190, 50))
    {
          edit_box = true;
    }
 
 for (int a=0; a<8;a++)
 {
    if ( overBot(1024/2-500+box*a, 700/2+200, box, box) ) 
        {
          
      switch (a) {
        
        case 0:
        rectbot0 = true;
        break;
 
        case 1:
        rectbot1 = true;
        break;
        
        case 2:
        rectbot2 = true;
        break;
        
        case 3:
        rectbot3 = true;
        break;
        
        case 4:
        rectbot4 = true;
        break;
        
        case 5:
        rectbot5 = true;
        break;
        
        case 6:
        rectbot6 = true;
        break;
        
        case 7:
        rectbot7 = true;
        break;
        
        default:
        break;
 
         }  
      } 
   }

}
  

void validar_estado(int r){ 
int frame_viejo = frameOld;  
   
   
   while(frame_viejo<=(frameAct))
   {  
    switch (r) {
     case 0:
     if (boton0){
        mods[frame_viejo].set_relee(0);
      }
      else{
       mods[frame_viejo].des_relee(0);
      }
      break;
      
      case 1:
      if (boton1){
        mods[frame_viejo].set_relee(1);
      }
      else{
       mods[frame_viejo].des_relee(1);
      }
      break;
      
      case 2:
      if (boton2){
        mods[frame_viejo].set_relee(2);
      }
      else{
       mods[frame_viejo].des_relee(2);
      }
      break;
      
      case 3:
      if (boton3){
        mods[frame_viejo].set_relee(3);
      }
      else{
       mods[frame_viejo].des_relee(3);
      }
     break;
     
     case 4:
      if (boton4){
        mods[frame_viejo].set_relee(4);
      }
      else{
       mods[frame_viejo].des_relee(4);
      }
     break;
     
     case 5:
      if (boton5){
        mods[frame_viejo].set_relee(5);
      }
      else{
       mods[frame_viejo].des_relee(5);
      }
     break;
     
     case 6:
      if (boton6){
        mods[frame_viejo].set_relee(6);
      }
      else{
       mods[frame_viejo].des_relee(6);
      }
     break;
     
     case 7:
      if (boton7){
        mods[frame_viejo].set_relee(7);
      }
      else{
       mods[frame_viejo].des_relee(7);
      }
     break;
     
      
      default:
          break;
     }//fin case
    
    frame_viejo++;
 }

 } 
 

void mousePressed() {
  if (rectbot0 || rectbot1 || rectbot2 || rectbot3 || rectbot4 || rectbot5 || rectbot6 || rectbot7 ) {
   edit_box = false;
   edit_box_press = false;
  }
  if (edit_box)
   {
   if (edit_box_press)
       {
        salto = int(numbers);
        if ((0<salto) && (salto<getLength()))
        setFrame(salto);
        numbers="0";
        edit_box_press = false;
       }
   else
     edit_box_press= true;
   }
  if (rectbot0) {
   if (boton0)
   boton0 = false;
   else
   boton0 = true;  
  }
  if (rectbot1) {
   if (boton1)
   boton1 = false;
   else
   boton1 = true;
   println("Relee 1");  
  }
  if (rectbot2) {
   if (boton2)
   boton2 = false;
   else
   boton2 = true;
   println("Relee 2");
  }
  if (rectbot3) {
    if (boton3)
   boton3 = false;
   else
   boton3 = true;
   println("Relee 3");
  }
   if (rectbot4) {
   if (boton4)
   boton4 = false;
   else
   boton4 = true;
   println("Relee 4");
  }
  if (rectbot5) {
    if (boton5)
   boton5 = false;
   else
   boton5 = true;
   println("Relee 5");
  }
  if (rectbot6) {
   if (boton6)
   boton6 = false;
   else
   boton6 = true;
   println("Relee 6");
  }
  if (rectbot7) {
   if (boton7)
   boton7 = false;
   else
   boton7 = true;
   println("Relee 7"); 
 }
}


void dibuja_botones(){
 
  for (int i=0; i<8;i++){
   if(mods[getFrame()].relee(i))
    {fill(inside);}
   else   
    {fill(255, 204);} 

   rect(1024/2-500+box*i+esp, 700/2+200,box , box);
 
 }
 
  if(grabando0)
    {fill(grabando);}
   else   
    {fill(240, 204);} 
   rect(1024/2-500+box*0+esp, 700/2+275,75 , 10);
   
   if(grabando1)
    {fill(grabando);}
   else   
    {fill(240, 204);} 
   rect(1024/2-500+box*1+esp, 700/2+275,75 , 10);
   
   if(grabando2)
    {fill(grabando);}
   else   
    {fill(240, 204);} 
   rect(1024/2-500+box*2+esp, 700/2+275,75 , 10);
   
   if(grabando3)
    {fill(grabando);}
   else   
    {fill(240, 204);} 
   rect(1024/2-500+box*3+esp, 700/2+275,75 , 10); 
 
   if(grabando4)
    {fill(grabando);}
   else   
    {fill(240, 204);} 
   rect(1024/2-500+box*4+esp, 700/2+275,75 , 10); 
 
   if(grabando5)
    {fill(grabando);}
   else   
    {fill(240, 204);} 
   rect(1024/2-500+box*5+esp, 700/2+275,75 , 10); 
 
   if(grabando6)
    {fill(grabando);}
   else   
    {fill(240, 204);} 
   rect(1024/2-500+box*6+esp, 700/2+275,75 , 10); 
 
   if(grabando7)
    {fill(grabando);}
   else   
    {fill(240, 204);} 
   rect(1024/2-500+box*7+esp, 700/2+275,75 , 10); 
 

 fill(0, 100); 
 textAlign(LEFT, CENTER);
 for (int i=0; i<8;i++){ 
  text("Relee "+(i+1), 1024/2-483+box*i+esp, 700/2+235);
 }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == DOWN) {
      movie.pause();
    } else if (keyCode == RIGHT) {
      movie.speed(1.0);
      movie.play();
    }
    else if (keyCode == LEFT) {
     //setFrame(getFrame()-2);
     movie.speed(-.5);
     dibuja_botones();
     movie.play();
  
    }
  } 
 
  if (key == 's') {
    println("Grabando...");
    grabar_archivo();
    println("Grabado");
  }

 if (key == 'r') {
   movie.pause();
   setFrame(1);
   movie.play(); 
   movie.pause();  
   println("Restart..");
  }

  if (key == 'b') {
    println("Borrando...");
    borrar_todo();
    println("Borrado");
  }
  
  if (key == 'q') {
    println("Chau..");
    movie.stop();
    exit();
  }
  if(edit_box_press){
         if (key >= '0' && key <= '9') {
            keyIndex = key;
            numbers = numbers + key;
            }
  }
  if(!edit_box_press){
           numbers = "0";
           if (key == '1') {
                  if(grabando0){
                        grabando0=false;
                        println("Deja Grabar 0");
                      }
                      else {
                        grabando0=true;
                        println("Comienza Grabar 0");
                      }
              }
                 if (key == '2') {
                     if(grabando1){
                        grabando1=false;
                        println("Deja Grabar 1");
                      }
                      else {
                        grabando1=true;
                        println("Comienza Grabar 1");
                      }
              }
              
                 if (key == '3') {
                      if(grabando2){
                            grabando2=false;
                            println("Deja Grabar 2");
                          }
                          else {
                            grabando2=true;
                            println("Comienza Grabar 2");
                  }
              }
                 if (key == '4') {
                      if(grabando3){
                            grabando3=false;
                            println("Deja Grabar 3");
                          }
                          else {
                            grabando3=true;
                            println("Comienza Grabar 3");
                          }
              }
                 if (key == '5') {
                      if(grabando4){
                            grabando4=false;
                            println("Deja Grabar 4");
                          }
                          else {
                            grabando4=true;
                            println("Comienza Grabar 4");
                          }
                }
                if (key == '6') {
                      if(grabando5){
                            grabando5=false;
                            println("Deja Grabar 5");
                          }
                          else {
                            grabando5=true;
                            println("Comienza Grabar 5");
                          }
                }
                if (key == '7') {
                      if(grabando6){
                            grabando6=false;
                            println("Deja Grabar 6");
                          }
                          else {
                            grabando6=true;
                            println("Comienza Grabar 6");
                          }
                }
           if (key == '8') {
                      if(grabando7){
                            grabando7=false;
                            println("Deja Grabar 7");
                          }
                          else {
                            grabando7=true;
                            println("Comienza Grabar 7");
                          }
                }
  }
}

void draw() 
{
  if(getFrame()<mods.length) //evita el desborde al final (en validar_estado)
  frameAct = getFrame();
  
  if(grabando0)
     validar_estado(0);
   if(grabando1)
     validar_estado(1);
   if(grabando2)
     validar_estado(2);
   if(grabando3)
     validar_estado(3);
   if(grabando4)
     validar_estado(4);
   if(grabando5)
     validar_estado(5);
   if(grabando6)
     validar_estado(6);
   if(grabando7)
     validar_estado(7);
   
  frameOld=frameAct;
    
  if (movie.available()) {
    if(!edit_box_press)
      { movie.read();}
    else 
      movie.pause();
    
    tiempo = str(movie.time());
  }
  
  background(0);
  
  dibuja_botones(); 
  dibuja_pixel();
  
  if (edit_box_press)
     color_editbox = 100;    
  else 
      color_editbox = 255; 
  
  fill(color_editbox);
  quad(700, 550, 890, 550, 890, 600, 700, 600);
  if (edit_box_press)
   {
     if(numbers.length()>0)
        {
          textFont(f1);
          fill(234, 216, 70); 
          text(numbers, 740,568);
          textFont(f);
      }
   }    
  fill(100);
  textAlign(CENTER, CENTER);
  text(".::Diseño::. ^Teembu Team^", 800,680); 
  textAlign(LEFT, CENTER);
  text("Transcurrido (frames) "+getFrame() + " / " + (getLength() - 1), 26,650);
  text("Tiempo total (s) "+movie.duration(), 26,660);
 
  image(movie, 12,350-290, 640, 480);
  update(mouseX, mouseY);
  
  fill(255);
  }
 
void dibuja_pixel()
{
  println(frameAct);
     if (frameAct>335)
      {
        for(int at=0; at<8; at++)
       {
           for(int au=0; au< (yvals[at].length); au++)
          { 
             if(mods[frameAct-au].relee(at))
              yvals[at][yvals[at].length-au-1]=40+(63*at);       
               else
              yvals[at][yvals[at].length-au-1]=80+(63*at);      
          } 
       }
      }
      
    if ((frameAct<334) && (frameAct>3))
    {
        
    for(int ar=0; ar<8; ar++)
      {
           for(int as=0; as< frameAct; as++)
          { 
             if(mods[frameAct-as].relee(ar))
             {
               yvals[ar][frameAct-as]=40+(63*ar);       
              // aux2[ar]= '1'; //ver en internet como acceder a un punto de string
             }
              else
               {
                 //aux2[ar]= '1'; //ver en internet como acceder a un punto de string 
                 yvals[ar][frameAct-as]=80+(63*ar);
               }
            }
        
       }
    }
     
    for(int a=0; a< yvals.length; a++) 
    {
      for(int i=1; i< yvals[0].length; i++) 
        {
             stroke(255);
             strokeWeight(2); 
             if((yvals[a][i-1]!=0))
              {
               line((i-1)+660,yvals[a][i-1] ,i+660, yvals[a][i] );
              }         
        
        }
   }
}

void setFrame(int n) {
  float valor = (n)/30.00;
  
  println("Valor de jump"+(valor));

  float diff = movie.duration() - valor;
  if (diff < 0) {
    println("Aqui "+diff);
    valor += diff - (0.25/30.00);
  }

  movie.jump(valor);
  movie.pause();  
 
}  
void grabar_audio(int time_t)
{
 byte[] pcm_data = new byte[44100*time_t];
  int proxpos=0;
  int indxx=0;
  int ba=0;
  int posx=0;
  
  while(indxx<pcm_data.length) 
  
    {
        pcm_data[indxx]=relees[posx].tiempos_rel[ba];
          
          if (ba<relees[posx].tiempos_rel.length-1)
          {
            ba++;
          }
          else 
          {
            ba=0;
            if(posx < (relees.length-1))
              {
              posx++;
              } 
          }

        indxx++;
    }
 
  AudioFormat frmt = new AudioFormat(44100, 8, 1, true, true);
  AudioInputStream ais = new AudioInputStream(new ByteArrayInputStream(pcm_data), frmt, pcm_data.length / frmt.getFrameSize());
  path = sketchPath();
  try {
     AudioSystem.write(ais, AudioFileFormat.Type.WAVE, new File(path + "/test.wav"));
     println("Audio -> done");
  } 
  catch(Exception e) {
    e.printStackTrace();
  }
 
  
}

void grabar_archivo(){
 String[] lines = new String[mods.length];
  
 for (int c = 0; c< mods.length; c++) {
    lines[c] = mods[c].time() + "\t"+ mods[c].relee(0)+ "\t"+mods[c].relee(1)+ "\t"+mods[c].relee(2)+ "\t"+mods[c].relee(3)+ "\t"+mods[c].relee(4)+ "\t"+mods[c].relee(5)+ "\t"+mods[c].relee(6)+ "\t"+mods[c].relee(7);
   for (int b = 0; b< 8; b++) 
    {
      relees[c].rel[b] = mods[c].relee(b);
    }
    relees[c].asignar();
}
  saveStrings("lines.txt", lines);
  int tiempo_total = 1 + floor(mods[mods.length-1].time()); //sumo 1 segundo por las dudas
  grabar_audio(tiempo_total);
  
  //exit(); // Stop the program
}
 
void leer_archivo(){
 String[] linesread ;
  linesread = loadStrings("lines.txt");
  for (int c = 0; c< linesread.length; c++) {
     String[] pieces = split(linesread[c], TAB); // Load data into array
      if (pieces.length == 9) {
      mods[recordCount].leer(pieces);
      recordCount++;
      }
    }
    println(recordCount);
} 
 
 
int getLength() {
  return int(movie.duration() * movFrameRate);
}  

int getFrame() {  
  return round(movie.time() * 30);
}

void borrar_todo()
{
 for (int c = 0; c< mods.length; c++) {
    mods[c].borrar();
    }
}

void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  int inByte = myPort.read();
  // if this is the first byte received, and it's an A,
  // clear the serial buffer and note that you've
  // had first contact from the microcontroller. 
  // Otherwise, add the incoming byte to the array:
  if (firstContact == false) {
    if (inByte == 'A') { 
      myPort.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
      myPort.write(aux);       // ask for more
      println(aux);
    } 
  } 
  else {
    myPort.write(aux2);       // ask for more
    println(aux2);
   // println(inByte);
    myPort.clear();          // clear the serial port buffer
   
  }
 
}