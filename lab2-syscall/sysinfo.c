#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "sysinfo.h"

// Add fmem function in kalloc.c
// uint64 fmem(void){
//     struct run *cur;
//     uint64 count = 0;

//     acquire(&kmem.lock);
//     cur = kmem.freelist;
//     while(cur) {
//       cur = cur->next;
//       count++;
//     }
//     release(&kmem.lock);

//     return (count << 12);
// }

// Add numofproc() in proc.c
// uint64 numofproc(void){
//   struct proc *p;
//   uint64 count = 0;

//   for(p = proc; p < &proc[NPROC]; p++) {
//     if(p->state != UNUSED)
//       count++;
//   }

//   return count;
// }

uint64
sys_sysinfo(void){
    struct proc *p = myproc();
    struct sysinfo info;

    uint64 addr;
    argaddr(0, &addr);

    info.freemem = fmem();
    info.nproc = numofproc();

    if(copyout(p->pagetable, addr, (char *)&info, sizeof(info)) < 0)
      return -1;
    return 0;

}
