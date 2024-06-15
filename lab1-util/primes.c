#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void newproc(int *p){
    char buf[2];
    close(p[1]);
    int pid = getpid();
    
    if(read(p[0], buf, 2) != 2) {
        fprintf(2, "%d fails in reading primes\n", pid);
        exit(1);
    }

    int prime = atoi(buf);
    printf("prime %d\n", prime);
    
    int t = read(p[0], buf, 2);
    int next = atoi(buf);
    if(t == 2) {
        int np[2];
        pipe(np);

        if(fork() == 0) {
            newproc(np);
        }
        else {
            close(np[0]);
            while(t == 2) {
                if(next % prime != 0)  {
                    char nbuf[2];
                    int d0 = next % 10;
                    int d1 = next / 10;
                    nbuf[0] = d1 + '0';
                    nbuf[1] = d0 + '0';
                    write(np[1], nbuf, 2);
                }
                t = read(p[0], buf, 2);
                next = atoi(buf);
            }
            close(p[0]);
            close(np[1]);
            wait(0);
        }
    }
}

int main(){
    int p[2];
    pipe(p);

    if(fork() == 0){
        newproc(p);
    }
    else {
        int pid = getpid();
        char buf[2];
        close(p[0]);
        for(int i = 2; i <= 35; i++) {
            int d0 = i % 10;
            int d1 = i / 10;
            buf[0] = d1 + '0';
            buf[1] = d0 + '0';
            if(write(p[1], buf, 2) != 2) {
                fprintf(2, "%d fails in writing primes\n", pid);
                exit(1);
            }
        }
        close(p[1]);
        wait(0);
    }
    exit(0);
}
