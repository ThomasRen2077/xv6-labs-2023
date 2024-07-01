#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"


void backtrace(void)
{
  printf("backtrace:\n");
  uint64 s0 = r_fp();
  uint64* fp = (uint64 *) s0;
  uint64 pageNum = PGROUNDDOWN((uint64)fp);
  while(pageNum == PGROUNDDOWN((uint64)fp)){
    printf("%p\n", *(fp - 1));
    fp = (uint64 *) *(fp - 2);
  }
  return;
}
