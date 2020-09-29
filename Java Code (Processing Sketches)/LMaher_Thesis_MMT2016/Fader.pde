/*********************************************************************
Default Fader: based on Conan Moriarty's mtVJ
Defines an abstract class and methods for switching between sketches 
**********************************************************************
*/

abstract class DefaultFader implements Fader
{
  public abstract void Draw();                                             
  void Xout(){}
  void Yout(){}
  void Xin(){}
  void Yin(){}
  void reset(){}
  void deset(){}
}