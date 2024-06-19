#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

// Modified syscall function
// const char* SysNumToName(int value) {
//     switch (value) {
//         case SYS_fork:
//             return "fork";
//         case SYS_exit:
//             return "exit";
//         case SYS_wait:
//             return "wait";
//         case SYS_pipe:
//             return "pipe";
//         case SYS_read:
//             return "read";
//         case SYS_kill:
//             return "kill";
//         case SYS_exec:
//             return "exec";
//         case SYS_fstat:
//             return "fstat";
//         case SYS_chdir:
//             return "chdir";
//         case SYS_dup:
//             return "dup";
//         case SYS_getpid:
//             return "getpid";
//         case SYS_sbrk:
//             return "sbrk";
//         case SYS_sleep:
//             return "sleep";
//         case SYS_uptime:
//             return "uptime";
//         case SYS_open:
//             return "open";
//         case SYS_write:
//             return "write";
//         case SYS_mknod:
//             return "mknod";
//         case SYS_unlink:
//             return "unlink";
//         case SYS_link:
//             return "link";
//         case SYS_mkdir:
//             return "mkdir";
//         case SYS_close:
//             return "close";
//         case SYS_trace:
//             return "trace";
//         default:
//             return "Unknown";
//     }
// }

// void
// syscall(void)
// {
//   int num;
//   struct proc *p = myproc();

//   num = p->trapframe->a7;
//   // num = * (int * ) 0;
//   if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
//     // Use num to lookup the system call function for num, call it,
//     // and store its return value in p->trapframe->a0
//     p->trapframe->a0 = syscalls[num]();

//     int t = (p->mask >> num) % 2;
//     if(t == 1) {
//       printf("%d: syscall %s -> %d\n", p->pid, SysNumToName(num), p->trapframe->a0);
//     }

//   } else {
//     printf("%d %s: unknown sys call %d\n",
//             p->pid, p->name, num);
//     p->trapframe->a0 = -1;
//   }
// }

uint64
sys_trace(void)
{
  int num;
  argint(0, &num);

  int t = num;
  struct proc *p = myproc();
  p->mask = t;

  if(p->mask == t) {
      return 0;
  }
  else {
      printf("trace mask set failed!");
      return -1;
  }
}