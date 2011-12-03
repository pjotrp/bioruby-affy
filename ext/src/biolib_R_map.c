
// #include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <biolib_error.h>
#include <biolib_R_map.h>

int R_running = false;

/* 
 * Initialize the R environment so we can use Rlib.so. 
 * FIXME: R_HOME is hard coded here.
 */

void BioLib_R_Init() {
  char *argv[] = {"BiolibEmbeddedR", "--gui=none", "--silent", "--no-environ" };
  int argc = sizeof(argv)/sizeof(argv[0]);

  if (!R_running) {
    biolib_log(LOG_INFO,"Initialize embedded R (library)");
    setenv("R_HOME","/usr/lib/R",1);
    Rf_initEmbeddedR(argc, argv);
    R_running = true;
  }
}

/*
 * Close down R environment
 */

void BioLib_R_Close() {
  if (R_running) {
    Rf_endEmbeddedR(0);
    R_running = false;
  }
}

