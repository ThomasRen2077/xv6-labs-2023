
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	add	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	add	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	2b6080e7          	jalr	694(ra) # 2be <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	2b0080e7          	jalr	688(ra) # 2c6 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	336080e7          	jalr	822(ra) # 356 <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  2a:	1141                	add	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	add	s0,sp,16
  extern int main();
  main();
  32:	00000097          	auipc	ra,0x0
  36:	fce080e7          	jalr	-50(ra) # 0 <main>
  exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	28a080e7          	jalr	650(ra) # 2c6 <exit>

0000000000000044 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  44:	1141                	add	sp,sp,-16
  46:	e422                	sd	s0,8(sp)
  48:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4a:	87aa                	mv	a5,a0
  4c:	0585                	add	a1,a1,1
  4e:	0785                	add	a5,a5,1
  50:	fff5c703          	lbu	a4,-1(a1)
  54:	fee78fa3          	sb	a4,-1(a5)
  58:	fb75                	bnez	a4,4c <strcpy+0x8>
    ;
  return os;
}
  5a:	6422                	ld	s0,8(sp)
  5c:	0141                	add	sp,sp,16
  5e:	8082                	ret

0000000000000060 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  60:	1141                	add	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  66:	00054783          	lbu	a5,0(a0)
  6a:	cb91                	beqz	a5,7e <strcmp+0x1e>
  6c:	0005c703          	lbu	a4,0(a1)
  70:	00f71763          	bne	a4,a5,7e <strcmp+0x1e>
    p++, q++;
  74:	0505                	add	a0,a0,1
  76:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  78:	00054783          	lbu	a5,0(a0)
  7c:	fbe5                	bnez	a5,6c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  7e:	0005c503          	lbu	a0,0(a1)
}
  82:	40a7853b          	subw	a0,a5,a0
  86:	6422                	ld	s0,8(sp)
  88:	0141                	add	sp,sp,16
  8a:	8082                	ret

000000000000008c <strlen>:

uint
strlen(const char *s)
{
  8c:	1141                	add	sp,sp,-16
  8e:	e422                	sd	s0,8(sp)
  90:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  92:	00054783          	lbu	a5,0(a0)
  96:	cf91                	beqz	a5,b2 <strlen+0x26>
  98:	0505                	add	a0,a0,1
  9a:	87aa                	mv	a5,a0
  9c:	86be                	mv	a3,a5
  9e:	0785                	add	a5,a5,1
  a0:	fff7c703          	lbu	a4,-1(a5)
  a4:	ff65                	bnez	a4,9c <strlen+0x10>
  a6:	40a6853b          	subw	a0,a3,a0
  aa:	2505                	addw	a0,a0,1
    ;
  return n;
}
  ac:	6422                	ld	s0,8(sp)
  ae:	0141                	add	sp,sp,16
  b0:	8082                	ret
  for(n = 0; s[n]; n++)
  b2:	4501                	li	a0,0
  b4:	bfe5                	j	ac <strlen+0x20>

00000000000000b6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b6:	1141                	add	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  bc:	ca19                	beqz	a2,d2 <memset+0x1c>
  be:	87aa                	mv	a5,a0
  c0:	1602                	sll	a2,a2,0x20
  c2:	9201                	srl	a2,a2,0x20
  c4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  cc:	0785                	add	a5,a5,1
  ce:	fee79de3          	bne	a5,a4,c8 <memset+0x12>
  }
  return dst;
}
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	add	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strchr>:

char*
strchr(const char *s, char c)
{
  d8:	1141                	add	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	add	s0,sp,16
  for(; *s; s++)
  de:	00054783          	lbu	a5,0(a0)
  e2:	cb99                	beqz	a5,f8 <strchr+0x20>
    if(*s == c)
  e4:	00f58763          	beq	a1,a5,f2 <strchr+0x1a>
  for(; *s; s++)
  e8:	0505                	add	a0,a0,1
  ea:	00054783          	lbu	a5,0(a0)
  ee:	fbfd                	bnez	a5,e4 <strchr+0xc>
      return (char*)s;
  return 0;
  f0:	4501                	li	a0,0
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	add	sp,sp,16
  f6:	8082                	ret
  return 0;
  f8:	4501                	li	a0,0
  fa:	bfe5                	j	f2 <strchr+0x1a>

00000000000000fc <gets>:

char*
gets(char *buf, int max)
{
  fc:	711d                	add	sp,sp,-96
  fe:	ec86                	sd	ra,88(sp)
 100:	e8a2                	sd	s0,80(sp)
 102:	e4a6                	sd	s1,72(sp)
 104:	e0ca                	sd	s2,64(sp)
 106:	fc4e                	sd	s3,56(sp)
 108:	f852                	sd	s4,48(sp)
 10a:	f456                	sd	s5,40(sp)
 10c:	f05a                	sd	s6,32(sp)
 10e:	ec5e                	sd	s7,24(sp)
 110:	1080                	add	s0,sp,96
 112:	8baa                	mv	s7,a0
 114:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 116:	892a                	mv	s2,a0
 118:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 11a:	4aa9                	li	s5,10
 11c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 11e:	89a6                	mv	s3,s1
 120:	2485                	addw	s1,s1,1
 122:	0344d863          	bge	s1,s4,152 <gets+0x56>
    cc = read(0, &c, 1);
 126:	4605                	li	a2,1
 128:	faf40593          	add	a1,s0,-81
 12c:	4501                	li	a0,0
 12e:	00000097          	auipc	ra,0x0
 132:	1b0080e7          	jalr	432(ra) # 2de <read>
    if(cc < 1)
 136:	00a05e63          	blez	a0,152 <gets+0x56>
    buf[i++] = c;
 13a:	faf44783          	lbu	a5,-81(s0)
 13e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 142:	01578763          	beq	a5,s5,150 <gets+0x54>
 146:	0905                	add	s2,s2,1
 148:	fd679be3          	bne	a5,s6,11e <gets+0x22>
    buf[i++] = c;
 14c:	89a6                	mv	s3,s1
 14e:	a011                	j	152 <gets+0x56>
 150:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 152:	99de                	add	s3,s3,s7
 154:	00098023          	sb	zero,0(s3)
  return buf;
}
 158:	855e                	mv	a0,s7
 15a:	60e6                	ld	ra,88(sp)
 15c:	6446                	ld	s0,80(sp)
 15e:	64a6                	ld	s1,72(sp)
 160:	6906                	ld	s2,64(sp)
 162:	79e2                	ld	s3,56(sp)
 164:	7a42                	ld	s4,48(sp)
 166:	7aa2                	ld	s5,40(sp)
 168:	7b02                	ld	s6,32(sp)
 16a:	6be2                	ld	s7,24(sp)
 16c:	6125                	add	sp,sp,96
 16e:	8082                	ret

0000000000000170 <stat>:

int
stat(const char *n, struct stat *st)
{
 170:	1101                	add	sp,sp,-32
 172:	ec06                	sd	ra,24(sp)
 174:	e822                	sd	s0,16(sp)
 176:	e04a                	sd	s2,0(sp)
 178:	1000                	add	s0,sp,32
 17a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17c:	4581                	li	a1,0
 17e:	00000097          	auipc	ra,0x0
 182:	188080e7          	jalr	392(ra) # 306 <open>
  if(fd < 0)
 186:	02054663          	bltz	a0,1b2 <stat+0x42>
 18a:	e426                	sd	s1,8(sp)
 18c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18e:	85ca                	mv	a1,s2
 190:	00000097          	auipc	ra,0x0
 194:	18e080e7          	jalr	398(ra) # 31e <fstat>
 198:	892a                	mv	s2,a0
  close(fd);
 19a:	8526                	mv	a0,s1
 19c:	00000097          	auipc	ra,0x0
 1a0:	152080e7          	jalr	338(ra) # 2ee <close>
  return r;
 1a4:	64a2                	ld	s1,8(sp)
}
 1a6:	854a                	mv	a0,s2
 1a8:	60e2                	ld	ra,24(sp)
 1aa:	6442                	ld	s0,16(sp)
 1ac:	6902                	ld	s2,0(sp)
 1ae:	6105                	add	sp,sp,32
 1b0:	8082                	ret
    return -1;
 1b2:	597d                	li	s2,-1
 1b4:	bfcd                	j	1a6 <stat+0x36>

00000000000001b6 <atoi>:

int
atoi(const char *s)
{
 1b6:	1141                	add	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1bc:	00054683          	lbu	a3,0(a0)
 1c0:	fd06879b          	addw	a5,a3,-48
 1c4:	0ff7f793          	zext.b	a5,a5
 1c8:	4625                	li	a2,9
 1ca:	02f66863          	bltu	a2,a5,1fa <atoi+0x44>
 1ce:	872a                	mv	a4,a0
  n = 0;
 1d0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1d2:	0705                	add	a4,a4,1
 1d4:	0025179b          	sllw	a5,a0,0x2
 1d8:	9fa9                	addw	a5,a5,a0
 1da:	0017979b          	sllw	a5,a5,0x1
 1de:	9fb5                	addw	a5,a5,a3
 1e0:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1e4:	00074683          	lbu	a3,0(a4)
 1e8:	fd06879b          	addw	a5,a3,-48
 1ec:	0ff7f793          	zext.b	a5,a5
 1f0:	fef671e3          	bgeu	a2,a5,1d2 <atoi+0x1c>
  return n;
}
 1f4:	6422                	ld	s0,8(sp)
 1f6:	0141                	add	sp,sp,16
 1f8:	8082                	ret
  n = 0;
 1fa:	4501                	li	a0,0
 1fc:	bfe5                	j	1f4 <atoi+0x3e>

00000000000001fe <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1fe:	1141                	add	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 204:	02b57463          	bgeu	a0,a1,22c <memmove+0x2e>
    while(n-- > 0)
 208:	00c05f63          	blez	a2,226 <memmove+0x28>
 20c:	1602                	sll	a2,a2,0x20
 20e:	9201                	srl	a2,a2,0x20
 210:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 214:	872a                	mv	a4,a0
      *dst++ = *src++;
 216:	0585                	add	a1,a1,1
 218:	0705                	add	a4,a4,1
 21a:	fff5c683          	lbu	a3,-1(a1)
 21e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 222:	fef71ae3          	bne	a4,a5,216 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	add	sp,sp,16
 22a:	8082                	ret
    dst += n;
 22c:	00c50733          	add	a4,a0,a2
    src += n;
 230:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 232:	fec05ae3          	blez	a2,226 <memmove+0x28>
 236:	fff6079b          	addw	a5,a2,-1
 23a:	1782                	sll	a5,a5,0x20
 23c:	9381                	srl	a5,a5,0x20
 23e:	fff7c793          	not	a5,a5
 242:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 244:	15fd                	add	a1,a1,-1
 246:	177d                	add	a4,a4,-1
 248:	0005c683          	lbu	a3,0(a1)
 24c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 250:	fee79ae3          	bne	a5,a4,244 <memmove+0x46>
 254:	bfc9                	j	226 <memmove+0x28>

0000000000000256 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 256:	1141                	add	sp,sp,-16
 258:	e422                	sd	s0,8(sp)
 25a:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25c:	ca05                	beqz	a2,28c <memcmp+0x36>
 25e:	fff6069b          	addw	a3,a2,-1
 262:	1682                	sll	a3,a3,0x20
 264:	9281                	srl	a3,a3,0x20
 266:	0685                	add	a3,a3,1
 268:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 26a:	00054783          	lbu	a5,0(a0)
 26e:	0005c703          	lbu	a4,0(a1)
 272:	00e79863          	bne	a5,a4,282 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 276:	0505                	add	a0,a0,1
    p2++;
 278:	0585                	add	a1,a1,1
  while (n-- > 0) {
 27a:	fed518e3          	bne	a0,a3,26a <memcmp+0x14>
  }
  return 0;
 27e:	4501                	li	a0,0
 280:	a019                	j	286 <memcmp+0x30>
      return *p1 - *p2;
 282:	40e7853b          	subw	a0,a5,a4
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	add	sp,sp,16
 28a:	8082                	ret
  return 0;
 28c:	4501                	li	a0,0
 28e:	bfe5                	j	286 <memcmp+0x30>

0000000000000290 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 290:	1141                	add	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 298:	00000097          	auipc	ra,0x0
 29c:	f66080e7          	jalr	-154(ra) # 1fe <memmove>
}
 2a0:	60a2                	ld	ra,8(sp)
 2a2:	6402                	ld	s0,0(sp)
 2a4:	0141                	add	sp,sp,16
 2a6:	8082                	ret

00000000000002a8 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 2a8:	1141                	add	sp,sp,-16
 2aa:	e422                	sd	s0,8(sp)
 2ac:	0800                	add	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 2ae:	040007b7          	lui	a5,0x4000
 2b2:	17f5                	add	a5,a5,-3 # 3fffffd <base+0x3ffebed>
 2b4:	07b2                	sll	a5,a5,0xc
}
 2b6:	4388                	lw	a0,0(a5)
 2b8:	6422                	ld	s0,8(sp)
 2ba:	0141                	add	sp,sp,16
 2bc:	8082                	ret

00000000000002be <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2be:	4885                	li	a7,1
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c6:	4889                	li	a7,2
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ce:	488d                	li	a7,3
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2d6:	4891                	li	a7,4
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <read>:
.global read
read:
 li a7, SYS_read
 2de:	4895                	li	a7,5
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <write>:
.global write
write:
 li a7, SYS_write
 2e6:	48c1                	li	a7,16
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <close>:
.global close
close:
 li a7, SYS_close
 2ee:	48d5                	li	a7,21
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2f6:	4899                	li	a7,6
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <exec>:
.global exec
exec:
 li a7, SYS_exec
 2fe:	489d                	li	a7,7
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <open>:
.global open
open:
 li a7, SYS_open
 306:	48bd                	li	a7,15
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 30e:	48c5                	li	a7,17
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 316:	48c9                	li	a7,18
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 31e:	48a1                	li	a7,8
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <link>:
.global link
link:
 li a7, SYS_link
 326:	48cd                	li	a7,19
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 32e:	48d1                	li	a7,20
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 336:	48a5                	li	a7,9
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <dup>:
.global dup
dup:
 li a7, SYS_dup
 33e:	48a9                	li	a7,10
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 346:	48ad                	li	a7,11
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 34e:	48b1                	li	a7,12
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 356:	48b5                	li	a7,13
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 35e:	48b9                	li	a7,14
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <connect>:
.global connect
connect:
 li a7, SYS_connect
 366:	48f5                	li	a7,29
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 36e:	48f9                	li	a7,30
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 376:	1101                	add	sp,sp,-32
 378:	ec06                	sd	ra,24(sp)
 37a:	e822                	sd	s0,16(sp)
 37c:	1000                	add	s0,sp,32
 37e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 382:	4605                	li	a2,1
 384:	fef40593          	add	a1,s0,-17
 388:	00000097          	auipc	ra,0x0
 38c:	f5e080e7          	jalr	-162(ra) # 2e6 <write>
}
 390:	60e2                	ld	ra,24(sp)
 392:	6442                	ld	s0,16(sp)
 394:	6105                	add	sp,sp,32
 396:	8082                	ret

0000000000000398 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 398:	7139                	add	sp,sp,-64
 39a:	fc06                	sd	ra,56(sp)
 39c:	f822                	sd	s0,48(sp)
 39e:	f426                	sd	s1,40(sp)
 3a0:	0080                	add	s0,sp,64
 3a2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a4:	c299                	beqz	a3,3aa <printint+0x12>
 3a6:	0805cb63          	bltz	a1,43c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3aa:	2581                	sext.w	a1,a1
  neg = 0;
 3ac:	4881                	li	a7,0
 3ae:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 3b2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3b4:	2601                	sext.w	a2,a2
 3b6:	00000517          	auipc	a0,0x0
 3ba:	4aa50513          	add	a0,a0,1194 # 860 <digits>
 3be:	883a                	mv	a6,a4
 3c0:	2705                	addw	a4,a4,1
 3c2:	02c5f7bb          	remuw	a5,a1,a2
 3c6:	1782                	sll	a5,a5,0x20
 3c8:	9381                	srl	a5,a5,0x20
 3ca:	97aa                	add	a5,a5,a0
 3cc:	0007c783          	lbu	a5,0(a5)
 3d0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3d4:	0005879b          	sext.w	a5,a1
 3d8:	02c5d5bb          	divuw	a1,a1,a2
 3dc:	0685                	add	a3,a3,1
 3de:	fec7f0e3          	bgeu	a5,a2,3be <printint+0x26>
  if(neg)
 3e2:	00088c63          	beqz	a7,3fa <printint+0x62>
    buf[i++] = '-';
 3e6:	fd070793          	add	a5,a4,-48
 3ea:	00878733          	add	a4,a5,s0
 3ee:	02d00793          	li	a5,45
 3f2:	fef70823          	sb	a5,-16(a4)
 3f6:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 3fa:	02e05c63          	blez	a4,432 <printint+0x9a>
 3fe:	f04a                	sd	s2,32(sp)
 400:	ec4e                	sd	s3,24(sp)
 402:	fc040793          	add	a5,s0,-64
 406:	00e78933          	add	s2,a5,a4
 40a:	fff78993          	add	s3,a5,-1
 40e:	99ba                	add	s3,s3,a4
 410:	377d                	addw	a4,a4,-1
 412:	1702                	sll	a4,a4,0x20
 414:	9301                	srl	a4,a4,0x20
 416:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 41a:	fff94583          	lbu	a1,-1(s2)
 41e:	8526                	mv	a0,s1
 420:	00000097          	auipc	ra,0x0
 424:	f56080e7          	jalr	-170(ra) # 376 <putc>
  while(--i >= 0)
 428:	197d                	add	s2,s2,-1
 42a:	ff3918e3          	bne	s2,s3,41a <printint+0x82>
 42e:	7902                	ld	s2,32(sp)
 430:	69e2                	ld	s3,24(sp)
}
 432:	70e2                	ld	ra,56(sp)
 434:	7442                	ld	s0,48(sp)
 436:	74a2                	ld	s1,40(sp)
 438:	6121                	add	sp,sp,64
 43a:	8082                	ret
    x = -xx;
 43c:	40b005bb          	negw	a1,a1
    neg = 1;
 440:	4885                	li	a7,1
    x = -xx;
 442:	b7b5                	j	3ae <printint+0x16>

0000000000000444 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 444:	715d                	add	sp,sp,-80
 446:	e486                	sd	ra,72(sp)
 448:	e0a2                	sd	s0,64(sp)
 44a:	f84a                	sd	s2,48(sp)
 44c:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 44e:	0005c903          	lbu	s2,0(a1)
 452:	1a090a63          	beqz	s2,606 <vprintf+0x1c2>
 456:	fc26                	sd	s1,56(sp)
 458:	f44e                	sd	s3,40(sp)
 45a:	f052                	sd	s4,32(sp)
 45c:	ec56                	sd	s5,24(sp)
 45e:	e85a                	sd	s6,16(sp)
 460:	e45e                	sd	s7,8(sp)
 462:	8aaa                	mv	s5,a0
 464:	8bb2                	mv	s7,a2
 466:	00158493          	add	s1,a1,1
  state = 0;
 46a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 46c:	02500a13          	li	s4,37
 470:	4b55                	li	s6,21
 472:	a839                	j	490 <vprintf+0x4c>
        putc(fd, c);
 474:	85ca                	mv	a1,s2
 476:	8556                	mv	a0,s5
 478:	00000097          	auipc	ra,0x0
 47c:	efe080e7          	jalr	-258(ra) # 376 <putc>
 480:	a019                	j	486 <vprintf+0x42>
    } else if(state == '%'){
 482:	01498d63          	beq	s3,s4,49c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 486:	0485                	add	s1,s1,1
 488:	fff4c903          	lbu	s2,-1(s1)
 48c:	16090763          	beqz	s2,5fa <vprintf+0x1b6>
    if(state == 0){
 490:	fe0999e3          	bnez	s3,482 <vprintf+0x3e>
      if(c == '%'){
 494:	ff4910e3          	bne	s2,s4,474 <vprintf+0x30>
        state = '%';
 498:	89d2                	mv	s3,s4
 49a:	b7f5                	j	486 <vprintf+0x42>
      if(c == 'd'){
 49c:	13490463          	beq	s2,s4,5c4 <vprintf+0x180>
 4a0:	f9d9079b          	addw	a5,s2,-99
 4a4:	0ff7f793          	zext.b	a5,a5
 4a8:	12fb6763          	bltu	s6,a5,5d6 <vprintf+0x192>
 4ac:	f9d9079b          	addw	a5,s2,-99
 4b0:	0ff7f713          	zext.b	a4,a5
 4b4:	12eb6163          	bltu	s6,a4,5d6 <vprintf+0x192>
 4b8:	00271793          	sll	a5,a4,0x2
 4bc:	00000717          	auipc	a4,0x0
 4c0:	34c70713          	add	a4,a4,844 # 808 <malloc+0x112>
 4c4:	97ba                	add	a5,a5,a4
 4c6:	439c                	lw	a5,0(a5)
 4c8:	97ba                	add	a5,a5,a4
 4ca:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4cc:	008b8913          	add	s2,s7,8
 4d0:	4685                	li	a3,1
 4d2:	4629                	li	a2,10
 4d4:	000ba583          	lw	a1,0(s7)
 4d8:	8556                	mv	a0,s5
 4da:	00000097          	auipc	ra,0x0
 4de:	ebe080e7          	jalr	-322(ra) # 398 <printint>
 4e2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4e4:	4981                	li	s3,0
 4e6:	b745                	j	486 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4e8:	008b8913          	add	s2,s7,8
 4ec:	4681                	li	a3,0
 4ee:	4629                	li	a2,10
 4f0:	000ba583          	lw	a1,0(s7)
 4f4:	8556                	mv	a0,s5
 4f6:	00000097          	auipc	ra,0x0
 4fa:	ea2080e7          	jalr	-350(ra) # 398 <printint>
 4fe:	8bca                	mv	s7,s2
      state = 0;
 500:	4981                	li	s3,0
 502:	b751                	j	486 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 504:	008b8913          	add	s2,s7,8
 508:	4681                	li	a3,0
 50a:	4641                	li	a2,16
 50c:	000ba583          	lw	a1,0(s7)
 510:	8556                	mv	a0,s5
 512:	00000097          	auipc	ra,0x0
 516:	e86080e7          	jalr	-378(ra) # 398 <printint>
 51a:	8bca                	mv	s7,s2
      state = 0;
 51c:	4981                	li	s3,0
 51e:	b7a5                	j	486 <vprintf+0x42>
 520:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 522:	008b8c13          	add	s8,s7,8
 526:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 52a:	03000593          	li	a1,48
 52e:	8556                	mv	a0,s5
 530:	00000097          	auipc	ra,0x0
 534:	e46080e7          	jalr	-442(ra) # 376 <putc>
  putc(fd, 'x');
 538:	07800593          	li	a1,120
 53c:	8556                	mv	a0,s5
 53e:	00000097          	auipc	ra,0x0
 542:	e38080e7          	jalr	-456(ra) # 376 <putc>
 546:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 548:	00000b97          	auipc	s7,0x0
 54c:	318b8b93          	add	s7,s7,792 # 860 <digits>
 550:	03c9d793          	srl	a5,s3,0x3c
 554:	97de                	add	a5,a5,s7
 556:	0007c583          	lbu	a1,0(a5)
 55a:	8556                	mv	a0,s5
 55c:	00000097          	auipc	ra,0x0
 560:	e1a080e7          	jalr	-486(ra) # 376 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 564:	0992                	sll	s3,s3,0x4
 566:	397d                	addw	s2,s2,-1
 568:	fe0914e3          	bnez	s2,550 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 56c:	8be2                	mv	s7,s8
      state = 0;
 56e:	4981                	li	s3,0
 570:	6c02                	ld	s8,0(sp)
 572:	bf11                	j	486 <vprintf+0x42>
        s = va_arg(ap, char*);
 574:	008b8993          	add	s3,s7,8
 578:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 57c:	02090163          	beqz	s2,59e <vprintf+0x15a>
        while(*s != 0){
 580:	00094583          	lbu	a1,0(s2)
 584:	c9a5                	beqz	a1,5f4 <vprintf+0x1b0>
          putc(fd, *s);
 586:	8556                	mv	a0,s5
 588:	00000097          	auipc	ra,0x0
 58c:	dee080e7          	jalr	-530(ra) # 376 <putc>
          s++;
 590:	0905                	add	s2,s2,1
        while(*s != 0){
 592:	00094583          	lbu	a1,0(s2)
 596:	f9e5                	bnez	a1,586 <vprintf+0x142>
        s = va_arg(ap, char*);
 598:	8bce                	mv	s7,s3
      state = 0;
 59a:	4981                	li	s3,0
 59c:	b5ed                	j	486 <vprintf+0x42>
          s = "(null)";
 59e:	00000917          	auipc	s2,0x0
 5a2:	26290913          	add	s2,s2,610 # 800 <malloc+0x10a>
        while(*s != 0){
 5a6:	02800593          	li	a1,40
 5aa:	bff1                	j	586 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5ac:	008b8913          	add	s2,s7,8
 5b0:	000bc583          	lbu	a1,0(s7)
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	dc0080e7          	jalr	-576(ra) # 376 <putc>
 5be:	8bca                	mv	s7,s2
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	b5d1                	j	486 <vprintf+0x42>
        putc(fd, c);
 5c4:	02500593          	li	a1,37
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	dac080e7          	jalr	-596(ra) # 376 <putc>
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	bd4d                	j	486 <vprintf+0x42>
        putc(fd, '%');
 5d6:	02500593          	li	a1,37
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	d9a080e7          	jalr	-614(ra) # 376 <putc>
        putc(fd, c);
 5e4:	85ca                	mv	a1,s2
 5e6:	8556                	mv	a0,s5
 5e8:	00000097          	auipc	ra,0x0
 5ec:	d8e080e7          	jalr	-626(ra) # 376 <putc>
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	bd51                	j	486 <vprintf+0x42>
        s = va_arg(ap, char*);
 5f4:	8bce                	mv	s7,s3
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	b579                	j	486 <vprintf+0x42>
 5fa:	74e2                	ld	s1,56(sp)
 5fc:	79a2                	ld	s3,40(sp)
 5fe:	7a02                	ld	s4,32(sp)
 600:	6ae2                	ld	s5,24(sp)
 602:	6b42                	ld	s6,16(sp)
 604:	6ba2                	ld	s7,8(sp)
    }
  }
}
 606:	60a6                	ld	ra,72(sp)
 608:	6406                	ld	s0,64(sp)
 60a:	7942                	ld	s2,48(sp)
 60c:	6161                	add	sp,sp,80
 60e:	8082                	ret

0000000000000610 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 610:	715d                	add	sp,sp,-80
 612:	ec06                	sd	ra,24(sp)
 614:	e822                	sd	s0,16(sp)
 616:	1000                	add	s0,sp,32
 618:	e010                	sd	a2,0(s0)
 61a:	e414                	sd	a3,8(s0)
 61c:	e818                	sd	a4,16(s0)
 61e:	ec1c                	sd	a5,24(s0)
 620:	03043023          	sd	a6,32(s0)
 624:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 628:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 62c:	8622                	mv	a2,s0
 62e:	00000097          	auipc	ra,0x0
 632:	e16080e7          	jalr	-490(ra) # 444 <vprintf>
}
 636:	60e2                	ld	ra,24(sp)
 638:	6442                	ld	s0,16(sp)
 63a:	6161                	add	sp,sp,80
 63c:	8082                	ret

000000000000063e <printf>:

void
printf(const char *fmt, ...)
{
 63e:	711d                	add	sp,sp,-96
 640:	ec06                	sd	ra,24(sp)
 642:	e822                	sd	s0,16(sp)
 644:	1000                	add	s0,sp,32
 646:	e40c                	sd	a1,8(s0)
 648:	e810                	sd	a2,16(s0)
 64a:	ec14                	sd	a3,24(s0)
 64c:	f018                	sd	a4,32(s0)
 64e:	f41c                	sd	a5,40(s0)
 650:	03043823          	sd	a6,48(s0)
 654:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 658:	00840613          	add	a2,s0,8
 65c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 660:	85aa                	mv	a1,a0
 662:	4505                	li	a0,1
 664:	00000097          	auipc	ra,0x0
 668:	de0080e7          	jalr	-544(ra) # 444 <vprintf>
}
 66c:	60e2                	ld	ra,24(sp)
 66e:	6442                	ld	s0,16(sp)
 670:	6125                	add	sp,sp,96
 672:	8082                	ret

0000000000000674 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 674:	1141                	add	sp,sp,-16
 676:	e422                	sd	s0,8(sp)
 678:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 67a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67e:	00001797          	auipc	a5,0x1
 682:	d827b783          	ld	a5,-638(a5) # 1400 <freep>
 686:	a02d                	j	6b0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 688:	4618                	lw	a4,8(a2)
 68a:	9f2d                	addw	a4,a4,a1
 68c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 690:	6398                	ld	a4,0(a5)
 692:	6310                	ld	a2,0(a4)
 694:	a83d                	j	6d2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 696:	ff852703          	lw	a4,-8(a0)
 69a:	9f31                	addw	a4,a4,a2
 69c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 69e:	ff053683          	ld	a3,-16(a0)
 6a2:	a091                	j	6e6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a4:	6398                	ld	a4,0(a5)
 6a6:	00e7e463          	bltu	a5,a4,6ae <free+0x3a>
 6aa:	00e6ea63          	bltu	a3,a4,6be <free+0x4a>
{
 6ae:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b0:	fed7fae3          	bgeu	a5,a3,6a4 <free+0x30>
 6b4:	6398                	ld	a4,0(a5)
 6b6:	00e6e463          	bltu	a3,a4,6be <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ba:	fee7eae3          	bltu	a5,a4,6ae <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6be:	ff852583          	lw	a1,-8(a0)
 6c2:	6390                	ld	a2,0(a5)
 6c4:	02059813          	sll	a6,a1,0x20
 6c8:	01c85713          	srl	a4,a6,0x1c
 6cc:	9736                	add	a4,a4,a3
 6ce:	fae60de3          	beq	a2,a4,688 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6d2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6d6:	4790                	lw	a2,8(a5)
 6d8:	02061593          	sll	a1,a2,0x20
 6dc:	01c5d713          	srl	a4,a1,0x1c
 6e0:	973e                	add	a4,a4,a5
 6e2:	fae68ae3          	beq	a3,a4,696 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6e6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6e8:	00001717          	auipc	a4,0x1
 6ec:	d0f73c23          	sd	a5,-744(a4) # 1400 <freep>
}
 6f0:	6422                	ld	s0,8(sp)
 6f2:	0141                	add	sp,sp,16
 6f4:	8082                	ret

00000000000006f6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6f6:	7139                	add	sp,sp,-64
 6f8:	fc06                	sd	ra,56(sp)
 6fa:	f822                	sd	s0,48(sp)
 6fc:	f426                	sd	s1,40(sp)
 6fe:	ec4e                	sd	s3,24(sp)
 700:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 702:	02051493          	sll	s1,a0,0x20
 706:	9081                	srl	s1,s1,0x20
 708:	04bd                	add	s1,s1,15
 70a:	8091                	srl	s1,s1,0x4
 70c:	0014899b          	addw	s3,s1,1
 710:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 712:	00001517          	auipc	a0,0x1
 716:	cee53503          	ld	a0,-786(a0) # 1400 <freep>
 71a:	c915                	beqz	a0,74e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 71c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 71e:	4798                	lw	a4,8(a5)
 720:	08977e63          	bgeu	a4,s1,7bc <malloc+0xc6>
 724:	f04a                	sd	s2,32(sp)
 726:	e852                	sd	s4,16(sp)
 728:	e456                	sd	s5,8(sp)
 72a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 72c:	8a4e                	mv	s4,s3
 72e:	0009871b          	sext.w	a4,s3
 732:	6685                	lui	a3,0x1
 734:	00d77363          	bgeu	a4,a3,73a <malloc+0x44>
 738:	6a05                	lui	s4,0x1
 73a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 73e:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 742:	00001917          	auipc	s2,0x1
 746:	cbe90913          	add	s2,s2,-834 # 1400 <freep>
  if(p == (char*)-1)
 74a:	5afd                	li	s5,-1
 74c:	a091                	j	790 <malloc+0x9a>
 74e:	f04a                	sd	s2,32(sp)
 750:	e852                	sd	s4,16(sp)
 752:	e456                	sd	s5,8(sp)
 754:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 756:	00001797          	auipc	a5,0x1
 75a:	cba78793          	add	a5,a5,-838 # 1410 <base>
 75e:	00001717          	auipc	a4,0x1
 762:	caf73123          	sd	a5,-862(a4) # 1400 <freep>
 766:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 768:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 76c:	b7c1                	j	72c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 76e:	6398                	ld	a4,0(a5)
 770:	e118                	sd	a4,0(a0)
 772:	a08d                	j	7d4 <malloc+0xde>
  hp->s.size = nu;
 774:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 778:	0541                	add	a0,a0,16
 77a:	00000097          	auipc	ra,0x0
 77e:	efa080e7          	jalr	-262(ra) # 674 <free>
  return freep;
 782:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 786:	c13d                	beqz	a0,7ec <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 788:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 78a:	4798                	lw	a4,8(a5)
 78c:	02977463          	bgeu	a4,s1,7b4 <malloc+0xbe>
    if(p == freep)
 790:	00093703          	ld	a4,0(s2)
 794:	853e                	mv	a0,a5
 796:	fef719e3          	bne	a4,a5,788 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 79a:	8552                	mv	a0,s4
 79c:	00000097          	auipc	ra,0x0
 7a0:	bb2080e7          	jalr	-1102(ra) # 34e <sbrk>
  if(p == (char*)-1)
 7a4:	fd5518e3          	bne	a0,s5,774 <malloc+0x7e>
        return 0;
 7a8:	4501                	li	a0,0
 7aa:	7902                	ld	s2,32(sp)
 7ac:	6a42                	ld	s4,16(sp)
 7ae:	6aa2                	ld	s5,8(sp)
 7b0:	6b02                	ld	s6,0(sp)
 7b2:	a03d                	j	7e0 <malloc+0xea>
 7b4:	7902                	ld	s2,32(sp)
 7b6:	6a42                	ld	s4,16(sp)
 7b8:	6aa2                	ld	s5,8(sp)
 7ba:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7bc:	fae489e3          	beq	s1,a4,76e <malloc+0x78>
        p->s.size -= nunits;
 7c0:	4137073b          	subw	a4,a4,s3
 7c4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7c6:	02071693          	sll	a3,a4,0x20
 7ca:	01c6d713          	srl	a4,a3,0x1c
 7ce:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7d0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7d4:	00001717          	auipc	a4,0x1
 7d8:	c2a73623          	sd	a0,-980(a4) # 1400 <freep>
      return (void*)(p + 1);
 7dc:	01078513          	add	a0,a5,16
  }
}
 7e0:	70e2                	ld	ra,56(sp)
 7e2:	7442                	ld	s0,48(sp)
 7e4:	74a2                	ld	s1,40(sp)
 7e6:	69e2                	ld	s3,24(sp)
 7e8:	6121                	add	sp,sp,64
 7ea:	8082                	ret
 7ec:	7902                	ld	s2,32(sp)
 7ee:	6a42                	ld	s4,16(sp)
 7f0:	6aa2                	ld	s5,8(sp)
 7f2:	6b02                	ld	s6,0(sp)
 7f4:	b7f5                	j	7e0 <malloc+0xea>
