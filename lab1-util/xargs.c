#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"
#include "kernel/param.h"
#include <stdarg.h>
#include <stddef.h>

int main(int argc, char * argv[]){
    char *newargv[MAXARG]; 
    int i;

    for(i = 1; i < argc; i++) {
		newargv[i - 1] = (char *)malloc(strlen(argv[i]) + 1);
		strcpy(newargv[i - 1], argv[i]);
    }
    i--;
    newargv[i] = (char *)malloc(1024 + 1);
    char cur;
    int j = 0;
    while(read(0, &cur, 1) == 1){
        if(cur == '\n' ) {
            i++;
            if(i >= MAXARG - 1) {
                fprintf(2, "Too many Arguments!");
                exit(1);
            }

            newargv[i] = (char *)malloc(1024 + 1);
            j = 0;
        }
        else {
            *(*(newargv + i) + j) = cur;
            *(*(newargv + i) + j + 1) = 0;
            j++;
            if(j >= 1024) {
                fprintf(2, "Line exceeds 1024 bytes long!");
                exit(1);
            }
        }
    }
    // for(int k = 0; k <= i; k++) {
    //     printf("%s\n", newargv[k]);
    // }

    if(fork() == 0) {
        exec(argv[1],  newargv);
    } else {
        wait(0);
        for(int k = 0; k <= i; k++) {
            free(newargv[k]);
        }
    }
    exit(0);
}