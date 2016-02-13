class Mappoint {

  int ID;
  int column, row;
  PVector position;
  
  public Mappoint( int ID, int column, int row ) {
    this.ID = ID;
    this.column = column;
    this.row = row;
    position = new PVector();
  }

}