#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"


// Add following variable to struct proc definition

//   int     interval;                               // interrupt intervals
//   uint64  handler;                                // interrupt handler
//   int     t_count;                                // tick_count
//   int     handler_return;                         // handler return status;
//   uint64  saved_epc;                              // saved pc
//   uint64  saved_ra;                               // saved ra
//   uint64  saved_sp;                               // saved sp
//   uint64  saved_a0;                               // saved a0
//   uint64  saved_a1;                               // saved a1
//   uint64  saved_a2;                               // saved a2
//   uint64  saved_a3;                               // saved a3
//   uint64  saved_a4;                               // saved a4
//   uint64  saved_a5;                               // saved a5
//   uint64  saved_a6;                               // saved a6
//   uint64  saved_a7;                               // saved a7
//   uint64  saved_s0;                               // saved s0                                
//   uint64  saved_s1;                               // saved s1
//   uint64  saved_s2;                               // saved s2
//   uint64  saved_s3;                               // saved s3
//   uint64  saved_s4;                               // saved s4
//   uint64  saved_s5;                               // saved s5
//   uint64  saved_s6;                               // saved s6
//   uint64  saved_s7;                               // saved s7
//   uint64  saved_s8;                               // saved s8
//   uint64  saved_s9;                               // saved s9
//   uint64  saved_s10;                              // saved s10
//   uint64  saved_s11;                              // saved s11

// call alarm in trap when which_dec == 2
void 
alarm(void) 
{
  struct proc *p = myproc();
  p->t_count += 1;
  if(p->interval != 0  && p->t_count == p->interval) {
    if(p->handler_return) {
        p->t_count = 0;
        p->handler_return = 0;
        p->saved_epc = p->trapframe->epc;
        p->saved_ra = p->trapframe->ra;
        p->saved_sp = p->trapframe->sp;
        p->saved_a0 = p->trapframe->a0;
        p->saved_a1 = p->trapframe->a1;
        p->saved_a2 = p->trapframe->a2;
        p->saved_a3 = p->trapframe->a3;
        p->saved_a4 = p->trapframe->a4;
        p->saved_a5 = p->trapframe->a5;
        p->saved_a6 = p->trapframe->a6;
        p->saved_a7 = p->trapframe->a7;
        p->saved_s0 = p->trapframe->s0;
        p->saved_s1 = p->trapframe->s1;
        p->saved_s2 = p->trapframe->s2;
        p->saved_s3 = p->trapframe->s3;
        p->saved_s4 = p->trapframe->s4;
        p->saved_s5 = p->trapframe->s5;
        p->saved_s6 = p->trapframe->s6;
        p->saved_s7 = p->trapframe->s7;
        p->saved_s8 = p->trapframe->s8;
        p->saved_s9 = p->trapframe->s9;
        p->saved_s10 = p->trapframe->s10;
        p->saved_s11 = p->trapframe->s11;
        p->trapframe->epc = p->handler;
    }
    else {
        p->t_count -= 1;
    }
  }
}


// Add two system call

uint64
sys_sigalarm(void)
{
  int i;
  uint64 handler_addr;
  argint(0, &i);
  argaddr(1, &handler_addr);

  struct proc *p = myproc();
  p->interval = i;
  p->handler = handler_addr;

  return 0;
}

uint64
sys_sigreturn(void)
{
  struct proc *p = myproc();
  // p->trapframe->kernel_satp = p->saved_kernel_satp;
  // p->trapframe->kernel_sp = p->saved_kernel_sp;
  // p->trapframe->kernel_trap = p->saved_kernel_trap;
  // p->trapframe->kernel_hartid = p->saved_kernel_hartid;
  p->trapframe->ra = p->saved_ra;
  p->trapframe->sp = p->saved_sp;
  // p->trapframe->gp = p->saved_gp;
  // p->trapframe->tp = p->saved_tp;
  // p->trapframe->t0 = p->saved_t0;
  // p->trapframe->t1 = p->saved_t1;
  // p->trapframe->t2 = p->saved_t2;
  // p->trapframe->t3 = p->saved_t3;
  // p->trapframe->t4 = p->saved_t4;
  // p->trapframe->t5 = p->saved_t5;
  // p->trapframe->t6 = p->saved_t6;
  // p->trapframe->a0 = p->saved_a0;
  p->trapframe->a1 = p->saved_a1;
  p->trapframe->a2 = p->saved_a2;
  p->trapframe->a3 = p->saved_a3;
  p->trapframe->a4 = p->saved_a4;
  p->trapframe->a5 = p->saved_a5;
  p->trapframe->a6 = p->saved_a6;
  p->trapframe->a7 = p->saved_a7;
  p->trapframe->s0 = p->saved_s0;
  p->trapframe->s1 = p->saved_s1;
  p->trapframe->s2 = p->saved_s2;
  p->trapframe->s3 = p->saved_s3;
  p->trapframe->s4 = p->saved_s4;
  p->trapframe->s5 = p->saved_s5;
  p->trapframe->s6 = p->saved_s6;
  p->trapframe->s7 = p->saved_s7;
  p->trapframe->s8 = p->saved_s8;
  p->trapframe->s9 = p->saved_s9;
  p->trapframe->s10 = p->saved_s10;
  p->trapframe->s11 = p->saved_s11;
  p->trapframe->epc = p->saved_epc;
  p->handler_return = 1;
  return 0;
}