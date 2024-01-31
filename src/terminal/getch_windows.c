#include "getch_windows.h"

int getch() {
    int d =-1, e=-1;
    d = _getch();
    // Arrow keys and num keys produce 2 key scan codes 
    if (d == 224 || d == 0) {
      e = _getch();
      // Remapping arrow keys up:17 down:18 left:19 right:20
      if (e == 72) 
        e = 17;
      else if (e == 80)
        e = 18; 
      else if (e == 75)
        e = 19; 
      else if (e == 77)
        e = 20; 
      return e;   
    }
    return d;
}