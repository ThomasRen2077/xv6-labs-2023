#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(void) {
    int pid;
    int p[2];
    pipe(p);
    // int pid = getpid();
    if(fork() == 0) {
        char * buf[2];
        pid = getpid();
        if(read(p[0], buf, 1) != 1) {
            fprintf(2, "read ping failed\n");           
            exit(1);
        }
        printf("%d: received ping\n", pid);
        close(p[0]);
        if(write(p[1], buf[0], 1) != 1){
            fprintf(2, "write ping failed\n");           
            exit(1);
        }
        close(p[1]);
    }
    else {
        pid = getpid();
        char *a = "a";
        if(write(p[1], a, 1) != 1){
            fprintf(2, "write ping failed\n");           
            exit(1);
        }
        close(p[1]);
        wait(0);
        char * buf[2];
        if(read(p[0], buf, 1) != 1) {
            fprintf(2, "read pong failed\n");           
            exit(1);
        }
        printf("%d: received pong\n", pid);
        close(p[0]);
    }
    exit(0);
}