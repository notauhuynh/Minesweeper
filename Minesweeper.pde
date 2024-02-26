import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 7;
public final static int NUM_COLS = 7;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList<MSButton>mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
public boolean lose = false;
void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  //your code to initialize buttons goes here
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int g = 0; g < NUM_COLS; g++) {
      buttons[i][g] = new MSButton(i, g);
    }
  }


  setMines();
}
public void setMines()
{

  for (int i = 0; i < 1.5*(NUM_ROWS*NUM_COLS)/NUM_ROWS; i++) {
    int setRow = (int)(Math.random() * NUM_ROWS);
    int setCol = (int)(Math.random() * NUM_COLS);
    if (!mines.contains(buttons[setRow][setCol])) {
      mines.add(buttons[setRow][setCol]);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon()){
    displayWinningMessage();
    noLoop(); 
  }
  if(lose){
    for(int i = 0; i < NUM_ROWS; i++){
      for(int g = 0; g < NUM_COLS; g++){
         if((mines.contains(buttons[i][g])))
          buttons[i][g].fillSq(255, 0, 0);
       }     
    }
    displayLosingMessage(); 
    noLoop();
  }
  //System.out.println(isWon() + " " +lose );
}
public boolean isWon()
{
  
  if(lose){
   return false;
  }
  for(int i = 0; i < NUM_ROWS; i++){
    for(int g = 0; g < NUM_COLS; g++){
     if((mines.contains(buttons[i][g]) && !buttons[i][g].flagged || !buttons[i][g].isClicked())){
      return false;  
     }     
    }
  }
  return true;
}
public void displayLosingMessage()
{
  for(int i = 0; i < NUM_ROWS; i++){
    for(int g = 0; g < NUM_COLS; g++){
         buttons[i][g].setLabel("LOSE");
     }     
    }
}
public void displayWinningMessage()
{
  for(int i = 0; i < NUM_ROWS; i++){
    for(int g = 0; g < NUM_COLS; g++){
       buttons[i][g].setLabel("WIN");
     }     
    }
}
public boolean isValid(int r, int c)
{
  if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {
    return true;
  }
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int i = row - 1; i < row + 2; i++) {
    for (int g = col - 1; g < col + 2; g++) {
      if (isValid(i, g) && mines.contains(buttons[i][g])) {
        numMines++;
      }
    }
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    if (mouseButton == RIGHT) {
      flagged = !flagged; 
      if (flagged == false) {
        clicked = false;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
      lose = true;
    } else if (countMines(myRow, myCol) > 0) {
      myLabel = Integer.toString(countMines(myRow, myCol));
    } else {
      for (int i = myRow - 1; i < myRow + 2; i++) {
        for (int g = myCol - 1; g < myCol + 2; g++) {
          if (isValid(i, g) && !mines.contains(buttons[i][g])) {
            buttons[i][g].clicked = true; 
            buttons[i][g].myLabel = Integer.toString(countMines(i, g));
          }
        }
      }
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
     else if(lose && mines.contains(this))
       fill(255, 0, 0);
    else if ( clicked && mines.contains(this) ) {
      fill(255, 0, 0);
      lose = true;
    }
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
  public boolean isClicked()
  {
    return clicked;
  } public void fillSq(int a, int b, int c){
   fill(a, b, c); 
  }
}
