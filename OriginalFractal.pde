//SCROLL TO BOTTOM FOR RECURSIVE VERSIONS OF THE MANDELBROT AND BURNING SHIP FRACTAL
//LOOK INTO THE DrawFractal METHOD TO SWITCH TO RENDERING WITH THESE RECURSIVE FUNCTIONS
//UNCOMMENT THE FUNCTIONS SSTARTING WITH recursive IN ITS NAME AND COMMENT THE FUNCTIONS WITH loop IN ITS NAME

//User controlled data
public double accuracy; //Larger number -> less accurate 
public double offsetX;
public double offsetY;
public double offsetXamount;
public double offsetYamount;
public double zoom;
public int mode;

//Settings
public int maxIterations = 150;
public color backgroundColor = color(0, 0, 0);
public color fractalColor = color(255, 255, 255);
public int brightness = 5;
public float brightnessFactor = ((float)brightness*255)/maxIterations;

//Program
public int maxNum = 2;
public boolean toggleDraw;

public void getDefaultSettings(int modeInput){
  if (modeInput == 1){
    accuracy = 0.005;
    zoom = 250;
    mode = 1;
    offsetX = 0.7;
    offsetY = 0;
    offsetXamount = Math.min(Math.abs((width*0.02)/zoom), Math.abs((height*0.02)/zoom));
    offsetYamount = Math.min(Math.abs((width*0.02)/zoom), Math.abs((height*0.02)/zoom));
    toggleDraw = true;
  }
  
  if (modeInput == 2){
    accuracy = 0.001;
    zoom = 2500;
    mode = 2;
    offsetX = 1.46;
    offsetY = 0;
    offsetXamount = Math.min(Math.abs((width*0.02)/zoom), Math.abs((height*0.02)/zoom));
    offsetYamount = Math.min(Math.abs((width*0.02)/zoom), Math.abs((height*0.02)/zoom));
    toggleDraw = true;
  }
  
  if (modeInput == 3){
    accuracy = 0.0015;
    zoom = 2500;
    mode = 3;
    offsetX = 1.47;
    offsetY = 0;
    offsetXamount = Math.min(Math.abs((width*0.02)/zoom), Math.abs((height*0.02)/zoom));
    offsetYamount = Math.min(Math.abs((width*0.02)/zoom), Math.abs((height*0.02)/zoom));
    toggleDraw = true;
  }
  
  if (modeInput == 4){
    accuracy = 0.000115;
    zoom = 7500;
    mode = 4;
    offsetX = 1.76;
    offsetY = -0.0357;
    offsetXamount = Math.min(Math.abs((width*0.02)/zoom), Math.abs((height*0.02)/zoom));
    offsetYamount = Math.min(Math.abs((width*0.02)/zoom), Math.abs((height*0.02)/zoom));
    toggleDraw = true;
  }
}

public void setup(){
  size(800, 600, P2D);
  background(backgroundColor);
  noSmooth(); //Don't anti-alias for performance
  noStroke(); //Performance
  
  //Default fractal settings (1: mandelbrot, 2/3: mandelbrot broken, 4: burning ship)
  getDefaultSettings(1);
}

public void draw(){
  if (keyPressed){
    repeatKeys();
  }
  
  if (toggleDraw){
    fill(backgroundColor);
    rect(0, 0, width, height);
    
    drawFractal();
  }
  
  surface.setTitle("Point: (" + offsetX + ", " + offsetY + ")   Accuracy: " + accuracy);
  
  toggleDraw = false;
}

public void keyPressed(){
  //Mandelbrot
  if (key == '1'){
    getDefaultSettings(1);
  }
  
  if (key == '2'){
    getDefaultSettings(2);
  }
  
  if (key == '3'){
    getDefaultSettings(3);
  }
  
  if (key == '4'){
    getDefaultSettings(4);
  }
  
  if (key == '=' || key == '+'){
    zoom *= 1.5;
    offsetXamount = Math.min(Math.abs((width*0.02)/zoom), Math.abs((height*0.02)/zoom));
    offsetYamount = Math.min(Math.abs((width*0.02)/zoom), Math.abs((height*0.02)/zoom));
    toggleDraw = true;
  }
  
  if (key == '-'){
    zoom /= 1.5;
    offsetXamount = Math.min(Math.abs((width*0.02)/zoom), Math.abs((height*0.02)/zoom));
    offsetYamount = Math.min(Math.abs((width*0.02)/zoom), Math.abs((height*0.02)/zoom));
    toggleDraw = true;
  }
  
  if (key == CODED){
    if (keyCode == UP){
      accuracy /= 2;
      toggleDraw = true;
    }
      
    if (keyCode == DOWN){
      accuracy *= 2;
      toggleDraw = true;
    }
  }
}

//Keys that should repeat
public void repeatKeys(){
  if (key == 'w'){
    offsetY -= offsetYamount;
    toggleDraw = true;
  }
  
  if (key == 'a'){
    offsetX += offsetXamount;
    toggleDraw = true;
  }
  
  if (key == 's'){
    offsetY += offsetYamount;
    toggleDraw = true;
  }
  
  if (key == 'd'){
    offsetX -= offsetXamount;
    toggleDraw = true;
  }
}

public void drawFractal(){
  strokeWeight(1);
  loadPixels();
  
  double re, im, pixelScale;
  int pixelX, pixelY, pixelXTemp, pixelYTemp, pixelIndex;
  color pixelColor = color(255, 0, 0); //Any red on screen = bad
  for (double j = Math.max(-2, -height/zoom + offsetY); j < Math.min(2, height/zoom + offsetY); j += accuracy){
    for (double i = Math.max(-2, -width/zoom - offsetX); i < Math.min(2, width/zoom - offsetX); i += accuracy){
      re = i;
      im = j;
      
      if (mode == 1){
        pixelColor = loopMandelbrot(re, im);
        //pixelColor = recurseMandelbrot(re, im);
      } else if (mode == 2){
        pixelColor = loopMandelbrotBroken1(re, im);
      } else if (mode == 3){
        pixelColor = loopMandelbrotBroken2(re, im);
      } else if (mode == 4){
        pixelColor = loopBurningShip(re, im);
        //pixelColor = recurseBurningShip(re, im);
      }
      
      //Directly access and modify the screen's pixels for faster drawing
      pixelX = (int)Math.floor((re + offsetX)*zoom + width/2);
      pixelY = (int)Math.floor((im - offsetY)*zoom + height/2);
      pixelScale = zoom*accuracy;
      
      if ((pixelX + pixelScale > -1 && pixelX < width) && (pixelY + pixelScale > -1 && pixelY < height)){
        for (int heightScale = 0; heightScale < zoom*accuracy; heightScale++){
          pixelYTemp = pixelY + heightScale;
          for (int widthScale = 0; widthScale < zoom*accuracy; widthScale++){
            pixelXTemp = pixelX + widthScale;
            
            if ((pixelXTemp > -1 && pixelXTemp < width) && (pixelYTemp > -1 && pixelYTemp < height)){
              pixelIndex = pixelYTemp*width + pixelXTemp;
              pixels[pixelIndex] = pixelColor;
            }
          }
        }
      }
    }
  }
  
  updatePixels();
}

//LOOPING FUNCTIONS

private color loopMandelbrot(double re, double im){
  double prevResultRe = 0;
  double prevResultIm = 0;
  double resultRe, resultIm, prevReSquared, prevImSquared;
  for (int i = 0; i < maxIterations; i++){
    prevReSquared = prevResultRe*prevResultRe;
    prevImSquared = prevResultIm*prevResultIm;
    
    resultRe = prevReSquared - prevImSquared + re;
    resultIm = 2*prevResultRe*prevResultIm + im;
    
    if (Math.sqrt(prevReSquared + prevImSquared) >= maxNum){
      return color(0, 0, i*brightnessFactor);
    }
    
    prevResultRe = resultRe;
    prevResultIm = resultIm;
  }
  
  return fractalColor;
}

private color loopMandelbrotBroken1(double re, double im){
  double resultRe = 0;
  double resultIm = 0;
  for (int i = 0; i < maxIterations; i++){
    resultRe = resultRe*resultRe - resultIm*resultIm + re;
    resultIm = 2*resultRe*resultIm + im;
    
    if (Math.sqrt(resultRe*resultRe + resultIm*resultIm) >= maxNum){
      return color(0, 0, i*brightnessFactor);
    }
  }
  
  return fractalColor;
}

private color loopMandelbrotBroken2(double re, double im){
  double resultRe = 0;
  double resultIm = 0;
  for (int i = 0; i < maxIterations; i++){
    resultIm = 2*resultRe*resultIm + im;
    resultRe = resultRe*resultRe - resultIm*resultIm + re;
    
    if (Math.sqrt(resultRe*resultRe + resultIm*resultIm) >= maxNum){
      return color(0, 0, i*brightnessFactor);
    }
  }
  
  return fractalColor;
}

private color loopBurningShip(double re, double im){
  double prevResultRe = 0;
  double prevResultIm = 0;
  double resultRe, resultIm, prevReSquared, prevImSquared;
  for (int i = 0; i < maxIterations; i++){
    prevReSquared = prevResultRe*prevResultRe;
    prevImSquared = prevResultIm*prevResultIm;
    
    resultRe = Math.abs(prevReSquared - prevImSquared + re);
    resultIm = Math.abs(2*prevResultRe*prevResultIm + im);
    
    if (Math.sqrt(prevReSquared + prevImSquared) >= maxNum){
      return color(0, 0, i*brightnessFactor);
    }
    
    prevResultRe = resultRe;
    prevResultIm = resultIm;
  }
  
  return fractalColor;
}

//RECURSIVE FUNCTIONS

private color recurseMandelbrot(double re, double im){
  double reFinal = recurseMandelbrotRe(re, im, maxIterations);
  double imFinal = recurseMandelbrotIm(re, im, maxIterations);
  
  if (Math.sqrt(reFinal*reFinal + imFinal*imFinal) >= maxNum){
    return color(0, 0, 0);
  }
  
  return fractalColor;
}

//Real part of the mandelbrot set
private double recurseMandelbrotRe(double re, double im, double i){
  if (i == 0){
    return 0;
  }
  
  return Math.pow(recurseMandelbrotRe(re, im, i - 1), 2) - Math.pow(recurseMandelbrotIm(re, im, i - 1), 2) + re;
}

//Imaginary part of the mandelbrot set
private double recurseMandelbrotIm(double re, double im, double i){
  if (i == 0){
    return 0;
  }
  
  return 2*recurseMandelbrotRe(re, im, i - 1)*recurseMandelbrotIm(re, im, i - 1) + im;
}

private color recurseBurningShip(double re, double im){
  double reFinal = recurseBurningShipRe(re, im, maxIterations);
  double imFinal = recurseBurningShipIm(re, im, maxIterations);
  
  if (Math.sqrt(reFinal*reFinal + imFinal*imFinal) >= maxNum){
    return color(0, 0, 0);
  }
  
  return fractalColor;
}

//Real part of the burning ship fractal
private double recurseBurningShipRe(double re, double im, double i){
  if (i == 0){
    return 0;
  }
  
  return Math.abs(Math.pow(recurseBurningShipRe(re, im, i - 1), 2) - Math.pow(recurseBurningShipIm(re, im, i - 1), 2) + re);
}

//Imaginary part of the burning ship fractal
private double recurseBurningShipIm(double re, double im, double i){
  if (i == 0){
    return 0;
  }
  
  return Math.abs(2*recurseBurningShipRe(re, im, i - 1)*recurseBurningShipIm(re, im, i - 1) + im);
}
