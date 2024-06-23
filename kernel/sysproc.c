#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;


  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
  // lab pgtbl: your code here.
  uint64 srt_va;
  int num;
  uint64 ubit_m;
  unsigned int kbit_m = 0;
  struct proc *p = myproc(); 

  argaddr(0, &srt_va);
  argint(1, &num);
  argaddr(2, &ubit_m);

  if(num >32) {
    printf("sys_pgaccess: Scan too much pages!");
    return -1;
  }

  uint64 va;
  pte_t *pte;
  int i;
  for(i = 0, va = srt_va; va < srt_va + num * PGSIZE; i++, va += PGSIZE) {
    if((pte = walk(p->pagetable, va, 0)) != 0) {
      if((*pte & PTE_V) && (*pte & PTE_A)) {
        kbit_m = (kbit_m | (1L << i));
        *pte = (*pte) & (~PTE_A);
      }
    }
  }

  if(copyout(p->pagetable, ubit_m, (char *) &kbit_m, sizeof(unsigned int)) < 0) {
    printf("sys_pgaccess: Failed to copy bit_mask to userspace!");
    return -1;
  }


  return 0;
}
#endif

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
