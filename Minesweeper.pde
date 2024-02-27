import de.bezier.guido.*;
public final static int NUM_ROWS = 8;
public final static int NUM_COLS = 8;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
public boolean gameLoss;
void setup ()
{
  size(800, 800);
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

  for (int i = 0; i < 2*NUM_ROWS; i++) {
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
  if(gameLoss){
    for(int i = 0; i < NUM_ROWS; i++){
      for(int g = 0; g < NUM_COLS; g++){
         if((mines.contains(buttons[i][g])))
          buttons[i][g].mousePressed();
       }     
    }
    displayLosingMessage(); 
    noLoop();
  }
  //System.out.println(isWon() + " " +gameLoss );
}
public boolean isWon()
{
  
  if(gameLoss){
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
  if (r > -1 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {
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
    width = 800/NUM_COLS;
    height = 800/NUM_ROWS;
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
      if (!flagged) {
        clicked = false;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
      gameLoss = true;
    } else if (countMines(myRow, myCol) > 0) {
      setLabel(countMines(myRow, myCol));
    } else {
      for (int i = myRow - 1; i < myRow + 2; i++) {
        for (int g = myCol - 1; g < myCol + 2; g++) {        
          if (isValid(i, g) && !buttons[i][g].isClicked()) {
            buttons[i][g].mousePressed();
          }
        }
      }  
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
     else if(gameLoss && mines.contains(this))
       fill(255, 0, 0);
    else if ( clicked && mines.contains(this) ) {
      fill(255, 0, 0);
      gameLoss = true;
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
  } 
}
