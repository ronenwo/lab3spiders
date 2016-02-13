/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/100339*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
PImage levels;

Mappoint[] mappoints;
Mapface[] mapfaces;
int mapwidth;
int mapheight;

MapTraveller[] mtrav;
int travnum = 40;
int travhisto = 500;
//int travhisto = 100;

// int vectorrange = 10;
float sampling = 16;
//float elevation = 10;
float elevation = 180;


boolean showimage = true;
//boolean showimage = false;
boolean drawedges = false;
boolean drawfaces = true;
//boolean drawfaces = false;

void setup() {

  size( 1024, 768, P3D );
  levels = loadImage( "levelmap.png" );
  mappoints = new Mappoint[ ceil( levels.width / sampling ) * ceil( levels.height / sampling ) ];
  levels.loadPixels();
  processMap( levels.pixels, levels.width, levels.height );

  mtrav = new MapTraveller[ travnum ];
  for ( int i=0; i < mtrav.length; i++ )
    mtrav[i] = new MapTraveller( random( 0.3f * levels.width, 0.7f * levels.height ), random( 0.3f * levels.width, 0.7f * levels.height ), 1.f, travhisto );
}

private void processMap( int[] pixels, int imgwidth, int imgheight ) {

  float[] pixels_brightness = new float[ pixels.length ];
  for ( int p=0; p < pixels.length; p++ )
    pixels_brightness[ p ] = brightness( pixels[ p ] ) / 255.f;

  // creating the map points
  mapwidth = (int) ceil( imgwidth / sampling );
  mapheight = (int) ceil( imgheight / sampling );
  int i = 0;
  int gc = 0;
  int gr = 0;
  for ( int r=0; r < imgheight; r += sampling ) {
    gc = 0;
    for ( int c=0; c < imgwidth; c += sampling ) {
      int pix = c + ( r * imgwidth );
      // if sampling si > 1, than we average the surrounding pixels
      int np = 0;
      float totalb = 0;
      int halfs = (int) floor( sampling * 0.5f );
      for ( int sy = r-halfs; sy <= r+halfs; sy++ ) {
        if ( sy < 0 )
          continue;
        if ( sy >= imgheight )
          break;
        for ( int sx = c-halfs; sx <= c+halfs; sx++ ) {
          if ( sx < 0 )
            continue;
          if ( sx >= imgwidth )
            break;
          totalb += pixels_brightness[ sx + ( sy * imgwidth ) ];
          np++;
        }
      }
      totalb /= np;
      mappoints[ i ] = new Mappoint( i, gc, gr );
      mappoints[ i ].position.set( ( c + 0.5f ), ( r + 0.5f ), totalb * elevation );
      i++;
      gc++;
    }
    gr++;
  }

  // creating map faces
  mapfaces = new Mapface[ ( ( mapwidth - 1 ) * ( mapheight - 1 ) ) * 2 ];
  int facescount = 0;
  i = 0;
  for ( int r=1; r < mapheight; r++ ) {
    for ( int c=0; c < mapwidth-1; c++ ) {
      i = c + r * mapwidth;
      Mappoint topleft = mappoints[ i - mapwidth ];
      Mappoint topright = mappoints[ i - mapwidth + 1 ];
      Mappoint bottomleft = mappoints[ i ];
      Mappoint bottomright = mappoints[ i +1 ];
      mapfaces[ facescount ] = new Mapface( topleft, topright, bottomright );
      facescount++;
      mapfaces[ facescount ] = new Mapface( topleft, bottomright, bottomleft );
      facescount++;
    }
  }
}

void draw() {

  for ( int i=0; i < mtrav.length; i++ )
   mtrav[i].update();

  background( 0 );
  translate( width * 0.5f, height * 0.5f, -300  );
  rotateX( -mouseY * 0.03f );
  rotateZ( mouseX * 0.03f );
  translate( -levels.width * 0.5f, -levels.height * 0.5f, 0  );
  if ( showimage )
    image( levels, 0, 0 );
  noFill();

  // drawing points
  /*
  for ( int i=0; i < mappoints.length; i++ ) {
   Mappoint mp = mappoints[ i ];
   stroke( 255 * mp.position.z, 0, 0 );
   strokeWeight( sampling * 0.25f );
   pushMatrix();
   translate( mp.position.x, mp.position.y, mp.position.z );
   point( 0,0,0 );
   stroke( 255,0,255 );
   strokeWeight( 1 );
   popMatrix();
   }
   */
  // drawing faces

  int p = 0;

  if ( drawfaces ) {
    for ( int i=0; i < mapfaces.length; i++ ) {
      Mapface face = mapfaces[ i ];
      noStroke();
      fill( 255 * face.center.z / elevation );
      beginShape();
      p = 0;
      vertex( face.pts[p].position.x, face.pts[p].position.y, face.pts[p].position.z );
      p++;
      vertex( face.pts[p].position.x, face.pts[p].position.y, face.pts[p].position.z );
      p++;
      vertex( face.pts[p].position.x, face.pts[p].position.y, face.pts[p].position.z );
      endShape( CLOSE );
      stroke( 255, 0, 0 );
      pushMatrix();
      translate( face.center.x, face.center.y, face.center.z );
      strokeWeight( 2 );
      point( 0, 0, 0 );
      strokeWeight( 1 );
      line( 0, 0, 0, face.normale.x * 20, face.normale.y * 20, face.normale.z * 20 );
      popMatrix();
    }
  } 
  if ( drawedges ) {
    
    stroke( 100 );
    strokeWeight( 1 );
    for ( int r=0; r < mapheight-1; r++ ) {
      for ( int c=0; c < mapwidth-1; c++ ) {
        p = c + r * mapwidth;
        line( 
          mappoints[ p ].position.x, mappoints[ p ].position.y, mappoints[ p ].position.z,
          mappoints[ p+1 ].position.x, mappoints[ p+1 ].position.y, mappoints[ p+1 ].position.z
        );
        line( 
          mappoints[ p ].position.x, mappoints[ p ].position.y, mappoints[ p ].position.z,
          mappoints[ p+mapwidth ].position.x, mappoints[ p+mapwidth ].position.y, mappoints[ p+mapwidth ].position.z
        );
        if( c == mapwidth-2 ) {
          line( 
            mappoints[ p+1 ].position.x, mappoints[ p+1 ].position.y, mappoints[ p+1 ].position.z,
            mappoints[ p+mapwidth+1 ].position.x, mappoints[ p+mapwidth+1 ].position.y, mappoints[ p+mapwidth+1 ].position.z
          );
        }
        if( r == mapheight-2 ) {
          line( 
            mappoints[ p+mapwidth ].position.x, mappoints[ p+mapwidth ].position.y, mappoints[ p+mapwidth ].position.z,
            mappoints[ p+mapwidth+1 ].position.x, mappoints[ p+mapwidth+1 ].position.y, mappoints[ p+mapwidth+1 ].position.z
          );
        }
      }
    }
    
  }

  // bundaries
  stroke( 100 );
  strokeWeight( 2 );
  noFill();
  pushMatrix();
  rect( 0, 0, levels.width, levels.height );
  translate( 0, 0, elevation );
  rect( 0, 0, levels.width, levels.height );
  popMatrix();
  // noLoop();

  strokeWeight( 3 );
  stroke( 0, 255, 249 );
  for ( int i=0; i < mtrav.length; i++ ) {
   for ( int j=1; j < mtrav[i].positions.length; j++ ) {
     line(
     mtrav[i].positions[ j-1 ][ 0 ], 
     mtrav[i].positions[ j-1 ][ 1 ], 
     mtrav[i].positions[ j-1 ][ 2 ], 
     mtrav[i].positions[ j ][ 0 ], 
     mtrav[i].positions[ j ][ 1 ], 
     mtrav[i].positions[ j ][ 2 ]
       );
   }
  }
}

void keyPressed( ) {
  if ( key == 'e' ) {
    drawedges = !drawedges;
  } 
  else if ( key == 'f' ) {
    drawfaces = !drawfaces;
  } 
  else if ( key == 'i' ) {
    showimage = !showimage;
  } 
  else
    println( keyCode );
}