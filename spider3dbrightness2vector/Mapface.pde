class Mapface {

  PVector center;
  PVector normale;
  float kc, ac, bc;
  
  Mappoint[] pts;
  
  public Mapface( Mappoint p1, Mappoint p2, Mappoint p3 ) {
  
    pts = new Mappoint[3];
    pts[ 0 ] = p1;
    pts[ 1 ] = p2;
    pts[ 2 ] = p3;
    
    renderFace();
  
  }
  
  // points may change => update of center and normale is required
  public void renderFace() {
    
    center = new PVector(
      ( pts[0].position.x + pts[1].position.x + pts[2].position.x ) / 3,
      ( pts[0].position.y + pts[1].position.y + pts[2].position.y ) / 3,
      ( pts[0].position.z + pts[1].position.z + pts[2].position.z ) / 3
    );
    // via thierry ravet
    PVector u = new PVector( 
      pts[1].position.x - pts[0].position.x,
      pts[1].position.y - pts[0].position.y,
      pts[1].position.z - pts[0].position.z );
    PVector v = new PVector( 
      pts[2].position.x - pts[0].position.x,
      pts[2].position.y - pts[0].position.y,
      pts[2].position.z - pts[0].position.z );
    u.normalize();
    v.normalize();
    // cross product
    normale = u.cross( v );
  
    // preparing plane values
    // based on equation k = a*x0 + b*y0 + c*z0
    float k = normale.x * center.x + normale.y * center.y + normale.z * center.z;
    kc = k / normale.z;
    ac = normale.x / normale.z;
    bc = normale.y / normale.z;
    
  }
  
  public float dist( float x, float y ) {
    return PApplet.dist( x, y, center.x, center.y );
  }
  
  public float getZprojection( float x, float y ) {
    return kc - ac * x - bc * y;
  }
}