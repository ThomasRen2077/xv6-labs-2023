#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

// Speed up pid get system call by memory mappings

// Add following code to pagetable initialization

// map one read-only page at USYSCALL for pid;
int wrapper(struct proc *p) {
  pagetable_t pagetable;
  struct usyscall *u = (struct usyscall *) kalloc();
  u->pid = p->pid;
  if(mappages(pagetable, USYSCALL, PGSIZE, (uint64)u, PTE_R | PTE_U) < 0) {
    kfree(u);
    uvmunmap(pagetable, USYSCALL, 1, 0);
    uvmfree(pagetable, 0);
    return 0;
  }
}