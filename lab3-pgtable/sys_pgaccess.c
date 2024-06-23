#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

// Add sys_pageaccess system call to detect which pages have been accessed
int
sys_pgaccess(void)
{
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
