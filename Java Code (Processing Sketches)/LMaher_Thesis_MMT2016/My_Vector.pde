/**************************************************************
Custom superclass for extending the Vector object in Processing
***************************************************************
*/

class myVector extends PVector
{
  myVector (float p_x, float p_y, float p_h) {
    super(p_x, p_y, p_h);
  }
  float longitude;
  float latitude;
}