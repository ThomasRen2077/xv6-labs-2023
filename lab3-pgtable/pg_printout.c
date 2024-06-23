#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"


// Print out page table;
void
vmprint(pagetable_t pagetable)
{
  printf("page table %p\n", (uint64)pagetable);
  // there are 2^9 = 512 PTEs in a page table.

  for(int i = 0; i < 512; i++){
    pte_t pte_l2 = pagetable[i];
    if(!(pte_l2 & PTE_V))   continue;
    printf(" ..%d: pte %p pa %p\n", i, (uint64)pte_l2, (uint64)PTE2PA(pte_l2));
    for(int j = 0; j < 512; j++) {
      pte_t pte_l1 = ((pagetable_t) PTE2PA(pte_l2))[j];
      if(!(pte_l1 & PTE_V))   continue;
      printf(" .. ..%d: pte %p pa %p\n", j, (uint64)pte_l1, (uint64)PTE2PA(pte_l1));
      for(int k = 0; k < 512; k++) {
        pte_t pte_l0 = ((pagetable_t) PTE2PA(pte_l1))[k];
        if(!(pte_l0 & PTE_V))   continue;
        printf(" .. .. ..%d: pte %p pa %p\n", k, (uint64)pte_l0, (uint64)PTE2PA(pte_l0));
      }
    }
  }
}
