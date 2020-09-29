/******************************************************************************************
Liam Maher - MMT Thesis Project
*******************************************************************************************
MAIN CLASS
*******************************************************************************************
  This sketch contains the main class
  Its purpose is to instantiante the library of visualisation sketches, 
  contains the main draw() loop, listen to OSC input, and set up the keyPressed() functions
*******************************************************************************************
*/


//Load in libraries which will be used throughout the sketch
import oscP5.*;
import netP5.*;

//Globals
OscP5 oscP5;
NetAddress myRemoteLocation;
Flock flock; 
int currentFaderIdx, nextFaderIdx;

//Arrays
ArrayList faders = new ArrayList(); 
Fader currentFader; 

//Booleans
boolean fadingIn, fadingOut, fading = false; 
boolean blinker;

//Fader variables
int alphaFade = 0; 

//Scene Zero Variables
final int NB_POINTS = 10000; 
final float FINAL_SPHERE_RAD = 800;
final float NOISE_SPHERE_RAD = 100;
final float MAX_SPEED_NOISE = 0.025;
final float MIN_FREQ_NOISE = 50;
final float MAX_FREQ_NOISE = 300; 
final float GOLDEN_RATIO = (sqrt(5)+1)/2-1;
final float GOLDEN_ANGLE = GOLDEN_RATIO*TWO_PI;
float s = 0.0;
float ang = 0.0;
float minSphereRadius = 10;
float zoom = .3;
float rotX = 0;
float rotY = 0;
float h;
float noiseX = 0;
float noiseY = 0;
float noiseZ = 0;
float noiseSpeedX = random(MAX_SPEED_NOISE);
float noiseSpeedY = random(MAX_SPEED_NOISE);
float noiseSpeedZ = random(MAX_SPEED_NOISE);
float noiseFreqX = random(MIN_FREQ_NOISE, MAX_FREQ_NOISE);
float noiseFreqY = random(MIN_FREQ_NOISE, MAX_FREQ_NOISE);
float noiseFreqZ = random(MIN_FREQ_NOISE, MAX_FREQ_NOISE);
myVector tabNoise[];
float xSpeed = random(15)-random(15); 
float ySpeed = random(15)-random(15);
float headWidth = 10; 
color mColor = color (22, 22, 22, 155); 

//Scene 2-6 Variables
float a = 0.0; 
float aVelocity = 0.0;
float aAcceleration;
float pitch3; 
float loudness3;
float brightness3;
float noisiness3;
float attack3; 
float random3;
float attack4; 
float random;
float pitch4; 
float loudness4;
float brightness4;
float noisiness4;
float random4; 

//Variables for Analog Rytm
float cutoff; 
float resonance;

//Scene Six Variables/Instantiation
float depth = 400; 
Box[] boxes = new Box[200];
int counter; 

//Function interface
interface Fader {
  public void Draw(); 
  public void Xin();
  public void Yin(); 
  public void Xout(); 
  public void Yout();

}

//Global setup routine
void setup() {
  size(800, 600, P3D);
  //fullScreen(P3D, 2); //This was used for final performance on external projector screen
  frameRate(30);
  background(0); 
  oscP5 = new OscP5 (this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
  noCursor();
  initialize();
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);

//Instantiate flock
  flock = new Flock();
  
  // Add an initial set of boids into the flocking system
  for (int i = 0; i < 25; i++) {
    Boid b = new Boid(random(1, 4), width/2, height/2);
    flock.addBoid(b);
  }

  //Setup boxes for scene six
  for (int i = 0; i < boxes.length; i++) {
    boxes[i] = new Box(width/2+random(-1, 1), height/2+random(-1, 1));
    boxes[i].setBoundary(5, 5, width-5, height-5);
  }

//Add all the scenes to be rendered to the fader routine
  faders.add(new sceneZero()); 
  faders.add(new sceneOne()); 
  faders.add(new sceneTwo()); 
  faders.add(new sceneThree());
  faders.add(new sceneFour());
  faders.add(new sceneFive());
  faders.add(new sceneSix()); 
  faders.add(new sceneSeven());
 }

//Draw routine for deciding the sketch to be rendered, based on Conan Moriarty's mtVJ project
void draw() { 
  //Cast the relevant fader to the global fader object
  currentFader = (Fader) faders.get(currentFaderIdx);  //Cast the appropriate drawer to global drawer object
  //Call the sub-class' render rouine (as specified in its Draw() function
  currentFader.Draw();
  //If a change in scene is initialised, fade the screen
  if (fading)  fade();                                                       
}

//Loads up the next sketch, toggles fading
void nextSketch()                                                          
{
  if (nextFaderIdx<faders.size()-1)
  {
    nextFaderIdx++;
  } else
    nextFaderIdx=0;
  fading=true;
}

//Routine for loading up previous sketches, toggles fader
void prevSketch()                                                           
{
  if (nextFaderIdx>0)
  {
    nextFaderIdx--;
  } else
    nextFaderIdx=faders.size()-1;
  fading=true;
}

void fade()                                                                 
{
  //Increase or decrease alpha fade
  if (nextFaderIdx!=currentFaderIdx)alphaFade+=8.5 ;
  if (nextFaderIdx==currentFaderIdx)alphaFade-=255; 
  //When screen is black, move onto subsequent scene
  if (alphaFade>=255)currentFaderIdx=nextFaderIdx;   
  fill(0, alphaFade);                                                     
  if (alphaFade>=0) 
  {
    noStroke();
    box(2000);
  } else
  {
    //Toggle fading boolean if we have faded in the desired sketch, toggle the fading boolean
    if (nextFaderIdx==currentFaderIdx && alphaFade<40) fading=false;     
  }
}

//Initialisation routine for scene one and scene eight
void initialize()
{
  int myX, myY, myZ;
  tabNoise = new myVector[NB_POINTS];
  
  //Render Particle Sphere
  for (int i = 1; i < NB_POINTS; ++i)
  {
    float longitude = GOLDEN_ANGLE*i;
    longitude /= TWO_PI;
    longitude -= floor(longitude);
    longitude *= TWO_PI;
    if (longitude > PI)
    {
      longitude -= TWO_PI;
    }
    float latitude = asin(-1 + 2*i/(float)NB_POINTS);

//Implementation of Perlin Noise
    myX = (int)(NOISE_SPHERE_RAD * cos(latitude) * cos(longitude));
    myY = (int)(NOISE_SPHERE_RAD * cos(latitude) * sin(longitude));
    myZ = (int)(NOISE_SPHERE_RAD * sin(latitude));

    tabNoise[i] = new myVector(myX, myY, myZ);
    tabNoise[i].latitude = latitude;
    tabNoise[i].longitude = longitude;
  }
}

//KeyPressed() routines for switching between sketches
void keyPressed()
{

  if (key=='1') {
    nextSketch();
  }
  if (key=='2') {
    prevSketch();
  }
}