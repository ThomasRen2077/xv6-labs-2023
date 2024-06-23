
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	add	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	add	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  12:	4785                	li	a5,1
  14:	06a7d863          	bge	a5,a0,84 <main+0x84>
  18:	00858493          	add	s1,a1,8
  1c:	3579                	addw	a0,a0,-2
  1e:	02051793          	sll	a5,a0,0x20
  22:	01d7d513          	srl	a0,a5,0x1d
  26:	00a48a33          	add	s4,s1,a0
  2a:	05c1                	add	a1,a1,16
  2c:	00a589b3          	add	s3,a1,a0
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  30:	00001a97          	auipc	s5,0x1
  34:	830a8a93          	add	s5,s5,-2000 # 860 <malloc+0x106>
  38:	a819                	j	4e <main+0x4e>
  3a:	4605                	li	a2,1
  3c:	85d6                	mv	a1,s5
  3e:	4505                	li	a0,1
  40:	00000097          	auipc	ra,0x0
  44:	30a080e7          	jalr	778(ra) # 34a <write>
  for(i = 1; i < argc; i++){
  48:	04a1                	add	s1,s1,8
  4a:	03348d63          	beq	s1,s3,84 <main+0x84>
    write(1, argv[i], strlen(argv[i]));
  4e:	0004b903          	ld	s2,0(s1)
  52:	854a                	mv	a0,s2
  54:	00000097          	auipc	ra,0x0
  58:	09c080e7          	jalr	156(ra) # f0 <strlen>
  5c:	0005061b          	sext.w	a2,a0
  60:	85ca                	mv	a1,s2
  62:	4505                	li	a0,1
  64:	00000097          	auipc	ra,0x0
  68:	2e6080e7          	jalr	742(ra) # 34a <write>
    if(i + 1 < argc){
  6c:	fd4497e3          	bne	s1,s4,3a <main+0x3a>
    } else {
      write(1, "\n", 1);
  70:	4605                	li	a2,1
  72:	00000597          	auipc	a1,0x0
  76:	7f658593          	add	a1,a1,2038 # 868 <malloc+0x10e>
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	2ce080e7          	jalr	718(ra) # 34a <write>
    }
  }
  exit(0);
  84:	4501                	li	a0,0
  86:	00000097          	auipc	ra,0x0
  8a:	2a4080e7          	jalr	676(ra) # 32a <exit>

000000000000008e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  8e:	1141                	add	sp,sp,-16
  90:	e406                	sd	ra,8(sp)
  92:	e022                	sd	s0,0(sp)
  94:	0800                	add	s0,sp,16
  extern int main();
  main();
  96:	00000097          	auipc	ra,0x0
  9a:	f6a080e7          	jalr	-150(ra) # 0 <main>
  exit(0);
  9e:	4501                	li	a0,0
  a0:	00000097          	auipc	ra,0x0
  a4:	28a080e7          	jalr	650(ra) # 32a <exit>

00000000000000a8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  a8:	1141                	add	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ae:	87aa                	mv	a5,a0
  b0:	0585                	add	a1,a1,1
  b2:	0785                	add	a5,a5,1
  b4:	fff5c703          	lbu	a4,-1(a1)
  b8:	fee78fa3          	sb	a4,-1(a5)
  bc:	fb75                	bnez	a4,b0 <strcpy+0x8>
    ;
  return os;
}
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	add	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c4:	1141                	add	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cb91                	beqz	a5,e2 <strcmp+0x1e>
  d0:	0005c703          	lbu	a4,0(a1)
  d4:	00f71763          	bne	a4,a5,e2 <strcmp+0x1e>
    p++, q++;
  d8:	0505                	add	a0,a0,1
  da:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  dc:	00054783          	lbu	a5,0(a0)
  e0:	fbe5                	bnez	a5,d0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  e2:	0005c503          	lbu	a0,0(a1)
}
  e6:	40a7853b          	subw	a0,a5,a0
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	add	sp,sp,16
  ee:	8082                	ret

00000000000000f0 <strlen>:

uint
strlen(const char *s)
{
  f0:	1141                	add	sp,sp,-16
  f2:	e422                	sd	s0,8(sp)
  f4:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  f6:	00054783          	lbu	a5,0(a0)
  fa:	cf91                	beqz	a5,116 <strlen+0x26>
  fc:	0505                	add	a0,a0,1
  fe:	87aa                	mv	a5,a0
 100:	86be                	mv	a3,a5
 102:	0785                	add	a5,a5,1
 104:	fff7c703          	lbu	a4,-1(a5)
 108:	ff65                	bnez	a4,100 <strlen+0x10>
 10a:	40a6853b          	subw	a0,a3,a0
 10e:	2505                	addw	a0,a0,1
    ;
  return n;
}
 110:	6422                	ld	s0,8(sp)
 112:	0141                	add	sp,sp,16
 114:	8082                	ret
  for(n = 0; s[n]; n++)
 116:	4501                	li	a0,0
 118:	bfe5                	j	110 <strlen+0x20>

000000000000011a <memset>:

void*
memset(void *dst, int c, uint n)
{
 11a:	1141                	add	sp,sp,-16
 11c:	e422                	sd	s0,8(sp)
 11e:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 120:	ca19                	beqz	a2,136 <memset+0x1c>
 122:	87aa                	mv	a5,a0
 124:	1602                	sll	a2,a2,0x20
 126:	9201                	srl	a2,a2,0x20
 128:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 12c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 130:	0785                	add	a5,a5,1
 132:	fee79de3          	bne	a5,a4,12c <memset+0x12>
  }
  return dst;
}
 136:	6422                	ld	s0,8(sp)
 138:	0141                	add	sp,sp,16
 13a:	8082                	ret

000000000000013c <strchr>:

char*
strchr(const char *s, char c)
{
 13c:	1141                	add	sp,sp,-16
 13e:	e422                	sd	s0,8(sp)
 140:	0800                	add	s0,sp,16
  for(; *s; s++)
 142:	00054783          	lbu	a5,0(a0)
 146:	cb99                	beqz	a5,15c <strchr+0x20>
    if(*s == c)
 148:	00f58763          	beq	a1,a5,156 <strchr+0x1a>
  for(; *s; s++)
 14c:	0505                	add	a0,a0,1
 14e:	00054783          	lbu	a5,0(a0)
 152:	fbfd                	bnez	a5,148 <strchr+0xc>
      return (char*)s;
  return 0;
 154:	4501                	li	a0,0
}
 156:	6422                	ld	s0,8(sp)
 158:	0141                	add	sp,sp,16
 15a:	8082                	ret
  return 0;
 15c:	4501                	li	a0,0
 15e:	bfe5                	j	156 <strchr+0x1a>

0000000000000160 <gets>:

char*
gets(char *buf, int max)
{
 160:	711d                	add	sp,sp,-96
 162:	ec86                	sd	ra,88(sp)
 164:	e8a2                	sd	s0,80(sp)
 166:	e4a6                	sd	s1,72(sp)
 168:	e0ca                	sd	s2,64(sp)
 16a:	fc4e                	sd	s3,56(sp)
 16c:	f852                	sd	s4,48(sp)
 16e:	f456                	sd	s5,40(sp)
 170:	f05a                	sd	s6,32(sp)
 172:	ec5e                	sd	s7,24(sp)
 174:	1080                	add	s0,sp,96
 176:	8baa                	mv	s7,a0
 178:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17a:	892a                	mv	s2,a0
 17c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 17e:	4aa9                	li	s5,10
 180:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 182:	89a6                	mv	s3,s1
 184:	2485                	addw	s1,s1,1
 186:	0344d863          	bge	s1,s4,1b6 <gets+0x56>
    cc = read(0, &c, 1);
 18a:	4605                	li	a2,1
 18c:	faf40593          	add	a1,s0,-81
 190:	4501                	li	a0,0
 192:	00000097          	auipc	ra,0x0
 196:	1b0080e7          	jalr	432(ra) # 342 <read>
    if(cc < 1)
 19a:	00a05e63          	blez	a0,1b6 <gets+0x56>
    buf[i++] = c;
 19e:	faf44783          	lbu	a5,-81(s0)
 1a2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1a6:	01578763          	beq	a5,s5,1b4 <gets+0x54>
 1aa:	0905                	add	s2,s2,1
 1ac:	fd679be3          	bne	a5,s6,182 <gets+0x22>
    buf[i++] = c;
 1b0:	89a6                	mv	s3,s1
 1b2:	a011                	j	1b6 <gets+0x56>
 1b4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1b6:	99de                	add	s3,s3,s7
 1b8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1bc:	855e                	mv	a0,s7
 1be:	60e6                	ld	ra,88(sp)
 1c0:	6446                	ld	s0,80(sp)
 1c2:	64a6                	ld	s1,72(sp)
 1c4:	6906                	ld	s2,64(sp)
 1c6:	79e2                	ld	s3,56(sp)
 1c8:	7a42                	ld	s4,48(sp)
 1ca:	7aa2                	ld	s5,40(sp)
 1cc:	7b02                	ld	s6,32(sp)
 1ce:	6be2                	ld	s7,24(sp)
 1d0:	6125                	add	sp,sp,96
 1d2:	8082                	ret

00000000000001d4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d4:	1101                	add	sp,sp,-32
 1d6:	ec06                	sd	ra,24(sp)
 1d8:	e822                	sd	s0,16(sp)
 1da:	e04a                	sd	s2,0(sp)
 1dc:	1000                	add	s0,sp,32
 1de:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e0:	4581                	li	a1,0
 1e2:	00000097          	auipc	ra,0x0
 1e6:	188080e7          	jalr	392(ra) # 36a <open>
  if(fd < 0)
 1ea:	02054663          	bltz	a0,216 <stat+0x42>
 1ee:	e426                	sd	s1,8(sp)
 1f0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f2:	85ca                	mv	a1,s2
 1f4:	00000097          	auipc	ra,0x0
 1f8:	18e080e7          	jalr	398(ra) # 382 <fstat>
 1fc:	892a                	mv	s2,a0
  close(fd);
 1fe:	8526                	mv	a0,s1
 200:	00000097          	auipc	ra,0x0
 204:	152080e7          	jalr	338(ra) # 352 <close>
  return r;
 208:	64a2                	ld	s1,8(sp)
}
 20a:	854a                	mv	a0,s2
 20c:	60e2                	ld	ra,24(sp)
 20e:	6442                	ld	s0,16(sp)
 210:	6902                	ld	s2,0(sp)
 212:	6105                	add	sp,sp,32
 214:	8082                	ret
    return -1;
 216:	597d                	li	s2,-1
 218:	bfcd                	j	20a <stat+0x36>

000000000000021a <atoi>:

int
atoi(const char *s)
{
 21a:	1141                	add	sp,sp,-16
 21c:	e422                	sd	s0,8(sp)
 21e:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 220:	00054683          	lbu	a3,0(a0)
 224:	fd06879b          	addw	a5,a3,-48
 228:	0ff7f793          	zext.b	a5,a5
 22c:	4625                	li	a2,9
 22e:	02f66863          	bltu	a2,a5,25e <atoi+0x44>
 232:	872a                	mv	a4,a0
  n = 0;
 234:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 236:	0705                	add	a4,a4,1
 238:	0025179b          	sllw	a5,a0,0x2
 23c:	9fa9                	addw	a5,a5,a0
 23e:	0017979b          	sllw	a5,a5,0x1
 242:	9fb5                	addw	a5,a5,a3
 244:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 248:	00074683          	lbu	a3,0(a4)
 24c:	fd06879b          	addw	a5,a3,-48
 250:	0ff7f793          	zext.b	a5,a5
 254:	fef671e3          	bgeu	a2,a5,236 <atoi+0x1c>
  return n;
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	add	sp,sp,16
 25c:	8082                	ret
  n = 0;
 25e:	4501                	li	a0,0
 260:	bfe5                	j	258 <atoi+0x3e>

0000000000000262 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 262:	1141                	add	sp,sp,-16
 264:	e422                	sd	s0,8(sp)
 266:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 268:	02b57463          	bgeu	a0,a1,290 <memmove+0x2e>
    while(n-- > 0)
 26c:	00c05f63          	blez	a2,28a <memmove+0x28>
 270:	1602                	sll	a2,a2,0x20
 272:	9201                	srl	a2,a2,0x20
 274:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 278:	872a                	mv	a4,a0
      *dst++ = *src++;
 27a:	0585                	add	a1,a1,1
 27c:	0705                	add	a4,a4,1
 27e:	fff5c683          	lbu	a3,-1(a1)
 282:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 286:	fef71ae3          	bne	a4,a5,27a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	add	sp,sp,16
 28e:	8082                	ret
    dst += n;
 290:	00c50733          	add	a4,a0,a2
    src += n;
 294:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 296:	fec05ae3          	blez	a2,28a <memmove+0x28>
 29a:	fff6079b          	addw	a5,a2,-1
 29e:	1782                	sll	a5,a5,0x20
 2a0:	9381                	srl	a5,a5,0x20
 2a2:	fff7c793          	not	a5,a5
 2a6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2a8:	15fd                	add	a1,a1,-1
 2aa:	177d                	add	a4,a4,-1
 2ac:	0005c683          	lbu	a3,0(a1)
 2b0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2b4:	fee79ae3          	bne	a5,a4,2a8 <memmove+0x46>
 2b8:	bfc9                	j	28a <memmove+0x28>

00000000000002ba <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ba:	1141                	add	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c0:	ca05                	beqz	a2,2f0 <memcmp+0x36>
 2c2:	fff6069b          	addw	a3,a2,-1
 2c6:	1682                	sll	a3,a3,0x20
 2c8:	9281                	srl	a3,a3,0x20
 2ca:	0685                	add	a3,a3,1
 2cc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ce:	00054783          	lbu	a5,0(a0)
 2d2:	0005c703          	lbu	a4,0(a1)
 2d6:	00e79863          	bne	a5,a4,2e6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2da:	0505                	add	a0,a0,1
    p2++;
 2dc:	0585                	add	a1,a1,1
  while (n-- > 0) {
 2de:	fed518e3          	bne	a0,a3,2ce <memcmp+0x14>
  }
  return 0;
 2e2:	4501                	li	a0,0
 2e4:	a019                	j	2ea <memcmp+0x30>
      return *p1 - *p2;
 2e6:	40e7853b          	subw	a0,a5,a4
}
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	add	sp,sp,16
 2ee:	8082                	ret
  return 0;
 2f0:	4501                	li	a0,0
 2f2:	bfe5                	j	2ea <memcmp+0x30>

00000000000002f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2f4:	1141                	add	sp,sp,-16
 2f6:	e406                	sd	ra,8(sp)
 2f8:	e022                	sd	s0,0(sp)
 2fa:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2fc:	00000097          	auipc	ra,0x0
 300:	f66080e7          	jalr	-154(ra) # 262 <memmove>
}
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	add	sp,sp,16
 30a:	8082                	ret

000000000000030c <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 30c:	1141                	add	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	add	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 312:	040007b7          	lui	a5,0x4000
 316:	17f5                	add	a5,a5,-3 # 3fffffd <base+0x3ffebed>
 318:	07b2                	sll	a5,a5,0xc
}
 31a:	4388                	lw	a0,0(a5)
 31c:	6422                	ld	s0,8(sp)
 31e:	0141                	add	sp,sp,16
 320:	8082                	ret

0000000000000322 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 322:	4885                	li	a7,1
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <exit>:
.global exit
exit:
 li a7, SYS_exit
 32a:	4889                	li	a7,2
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <wait>:
.global wait
wait:
 li a7, SYS_wait
 332:	488d                	li	a7,3
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 33a:	4891                	li	a7,4
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <read>:
.global read
read:
 li a7, SYS_read
 342:	4895                	li	a7,5
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <write>:
.global write
write:
 li a7, SYS_write
 34a:	48c1                	li	a7,16
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <close>:
.global close
close:
 li a7, SYS_close
 352:	48d5                	li	a7,21
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <kill>:
.global kill
kill:
 li a7, SYS_kill
 35a:	4899                	li	a7,6
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <exec>:
.global exec
exec:
 li a7, SYS_exec
 362:	489d                	li	a7,7
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <open>:
.global open
open:
 li a7, SYS_open
 36a:	48bd                	li	a7,15
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 372:	48c5                	li	a7,17
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 37a:	48c9                	li	a7,18
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 382:	48a1                	li	a7,8
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <link>:
.global link
link:
 li a7, SYS_link
 38a:	48cd                	li	a7,19
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 392:	48d1                	li	a7,20
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 39a:	48a5                	li	a7,9
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3a2:	48a9                	li	a7,10
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3aa:	48ad                	li	a7,11
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3b2:	48b1                	li	a7,12
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ba:	48b5                	li	a7,13
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3c2:	48b9                	li	a7,14
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <connect>:
.global connect
connect:
 li a7, SYS_connect
 3ca:	48f5                	li	a7,29
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 3d2:	48f9                	li	a7,30
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3da:	1101                	add	sp,sp,-32
 3dc:	ec06                	sd	ra,24(sp)
 3de:	e822                	sd	s0,16(sp)
 3e0:	1000                	add	s0,sp,32
 3e2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3e6:	4605                	li	a2,1
 3e8:	fef40593          	add	a1,s0,-17
 3ec:	00000097          	auipc	ra,0x0
 3f0:	f5e080e7          	jalr	-162(ra) # 34a <write>
}
 3f4:	60e2                	ld	ra,24(sp)
 3f6:	6442                	ld	s0,16(sp)
 3f8:	6105                	add	sp,sp,32
 3fa:	8082                	ret

00000000000003fc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3fc:	7139                	add	sp,sp,-64
 3fe:	fc06                	sd	ra,56(sp)
 400:	f822                	sd	s0,48(sp)
 402:	f426                	sd	s1,40(sp)
 404:	0080                	add	s0,sp,64
 406:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 408:	c299                	beqz	a3,40e <printint+0x12>
 40a:	0805cb63          	bltz	a1,4a0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 40e:	2581                	sext.w	a1,a1
  neg = 0;
 410:	4881                	li	a7,0
 412:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 416:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 418:	2601                	sext.w	a2,a2
 41a:	00000517          	auipc	a0,0x0
 41e:	4b650513          	add	a0,a0,1206 # 8d0 <digits>
 422:	883a                	mv	a6,a4
 424:	2705                	addw	a4,a4,1
 426:	02c5f7bb          	remuw	a5,a1,a2
 42a:	1782                	sll	a5,a5,0x20
 42c:	9381                	srl	a5,a5,0x20
 42e:	97aa                	add	a5,a5,a0
 430:	0007c783          	lbu	a5,0(a5)
 434:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 438:	0005879b          	sext.w	a5,a1
 43c:	02c5d5bb          	divuw	a1,a1,a2
 440:	0685                	add	a3,a3,1
 442:	fec7f0e3          	bgeu	a5,a2,422 <printint+0x26>
  if(neg)
 446:	00088c63          	beqz	a7,45e <printint+0x62>
    buf[i++] = '-';
 44a:	fd070793          	add	a5,a4,-48
 44e:	00878733          	add	a4,a5,s0
 452:	02d00793          	li	a5,45
 456:	fef70823          	sb	a5,-16(a4)
 45a:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 45e:	02e05c63          	blez	a4,496 <printint+0x9a>
 462:	f04a                	sd	s2,32(sp)
 464:	ec4e                	sd	s3,24(sp)
 466:	fc040793          	add	a5,s0,-64
 46a:	00e78933          	add	s2,a5,a4
 46e:	fff78993          	add	s3,a5,-1
 472:	99ba                	add	s3,s3,a4
 474:	377d                	addw	a4,a4,-1
 476:	1702                	sll	a4,a4,0x20
 478:	9301                	srl	a4,a4,0x20
 47a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 47e:	fff94583          	lbu	a1,-1(s2)
 482:	8526                	mv	a0,s1
 484:	00000097          	auipc	ra,0x0
 488:	f56080e7          	jalr	-170(ra) # 3da <putc>
  while(--i >= 0)
 48c:	197d                	add	s2,s2,-1
 48e:	ff3918e3          	bne	s2,s3,47e <printint+0x82>
 492:	7902                	ld	s2,32(sp)
 494:	69e2                	ld	s3,24(sp)
}
 496:	70e2                	ld	ra,56(sp)
 498:	7442                	ld	s0,48(sp)
 49a:	74a2                	ld	s1,40(sp)
 49c:	6121                	add	sp,sp,64
 49e:	8082                	ret
    x = -xx;
 4a0:	40b005bb          	negw	a1,a1
    neg = 1;
 4a4:	4885                	li	a7,1
    x = -xx;
 4a6:	b7b5                	j	412 <printint+0x16>

00000000000004a8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4a8:	715d                	add	sp,sp,-80
 4aa:	e486                	sd	ra,72(sp)
 4ac:	e0a2                	sd	s0,64(sp)
 4ae:	f84a                	sd	s2,48(sp)
 4b0:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4b2:	0005c903          	lbu	s2,0(a1)
 4b6:	1a090a63          	beqz	s2,66a <vprintf+0x1c2>
 4ba:	fc26                	sd	s1,56(sp)
 4bc:	f44e                	sd	s3,40(sp)
 4be:	f052                	sd	s4,32(sp)
 4c0:	ec56                	sd	s5,24(sp)
 4c2:	e85a                	sd	s6,16(sp)
 4c4:	e45e                	sd	s7,8(sp)
 4c6:	8aaa                	mv	s5,a0
 4c8:	8bb2                	mv	s7,a2
 4ca:	00158493          	add	s1,a1,1
  state = 0;
 4ce:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4d0:	02500a13          	li	s4,37
 4d4:	4b55                	li	s6,21
 4d6:	a839                	j	4f4 <vprintf+0x4c>
        putc(fd, c);
 4d8:	85ca                	mv	a1,s2
 4da:	8556                	mv	a0,s5
 4dc:	00000097          	auipc	ra,0x0
 4e0:	efe080e7          	jalr	-258(ra) # 3da <putc>
 4e4:	a019                	j	4ea <vprintf+0x42>
    } else if(state == '%'){
 4e6:	01498d63          	beq	s3,s4,500 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4ea:	0485                	add	s1,s1,1
 4ec:	fff4c903          	lbu	s2,-1(s1)
 4f0:	16090763          	beqz	s2,65e <vprintf+0x1b6>
    if(state == 0){
 4f4:	fe0999e3          	bnez	s3,4e6 <vprintf+0x3e>
      if(c == '%'){
 4f8:	ff4910e3          	bne	s2,s4,4d8 <vprintf+0x30>
        state = '%';
 4fc:	89d2                	mv	s3,s4
 4fe:	b7f5                	j	4ea <vprintf+0x42>
      if(c == 'd'){
 500:	13490463          	beq	s2,s4,628 <vprintf+0x180>
 504:	f9d9079b          	addw	a5,s2,-99
 508:	0ff7f793          	zext.b	a5,a5
 50c:	12fb6763          	bltu	s6,a5,63a <vprintf+0x192>
 510:	f9d9079b          	addw	a5,s2,-99
 514:	0ff7f713          	zext.b	a4,a5
 518:	12eb6163          	bltu	s6,a4,63a <vprintf+0x192>
 51c:	00271793          	sll	a5,a4,0x2
 520:	00000717          	auipc	a4,0x0
 524:	35870713          	add	a4,a4,856 # 878 <malloc+0x11e>
 528:	97ba                	add	a5,a5,a4
 52a:	439c                	lw	a5,0(a5)
 52c:	97ba                	add	a5,a5,a4
 52e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 530:	008b8913          	add	s2,s7,8
 534:	4685                	li	a3,1
 536:	4629                	li	a2,10
 538:	000ba583          	lw	a1,0(s7)
 53c:	8556                	mv	a0,s5
 53e:	00000097          	auipc	ra,0x0
 542:	ebe080e7          	jalr	-322(ra) # 3fc <printint>
 546:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 548:	4981                	li	s3,0
 54a:	b745                	j	4ea <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 54c:	008b8913          	add	s2,s7,8
 550:	4681                	li	a3,0
 552:	4629                	li	a2,10
 554:	000ba583          	lw	a1,0(s7)
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	ea2080e7          	jalr	-350(ra) # 3fc <printint>
 562:	8bca                	mv	s7,s2
      state = 0;
 564:	4981                	li	s3,0
 566:	b751                	j	4ea <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 568:	008b8913          	add	s2,s7,8
 56c:	4681                	li	a3,0
 56e:	4641                	li	a2,16
 570:	000ba583          	lw	a1,0(s7)
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	e86080e7          	jalr	-378(ra) # 3fc <printint>
 57e:	8bca                	mv	s7,s2
      state = 0;
 580:	4981                	li	s3,0
 582:	b7a5                	j	4ea <vprintf+0x42>
 584:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 586:	008b8c13          	add	s8,s7,8
 58a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 58e:	03000593          	li	a1,48
 592:	8556                	mv	a0,s5
 594:	00000097          	auipc	ra,0x0
 598:	e46080e7          	jalr	-442(ra) # 3da <putc>
  putc(fd, 'x');
 59c:	07800593          	li	a1,120
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	e38080e7          	jalr	-456(ra) # 3da <putc>
 5aa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ac:	00000b97          	auipc	s7,0x0
 5b0:	324b8b93          	add	s7,s7,804 # 8d0 <digits>
 5b4:	03c9d793          	srl	a5,s3,0x3c
 5b8:	97de                	add	a5,a5,s7
 5ba:	0007c583          	lbu	a1,0(a5)
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	e1a080e7          	jalr	-486(ra) # 3da <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5c8:	0992                	sll	s3,s3,0x4
 5ca:	397d                	addw	s2,s2,-1
 5cc:	fe0914e3          	bnez	s2,5b4 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5d0:	8be2                	mv	s7,s8
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	6c02                	ld	s8,0(sp)
 5d6:	bf11                	j	4ea <vprintf+0x42>
        s = va_arg(ap, char*);
 5d8:	008b8993          	add	s3,s7,8
 5dc:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5e0:	02090163          	beqz	s2,602 <vprintf+0x15a>
        while(*s != 0){
 5e4:	00094583          	lbu	a1,0(s2)
 5e8:	c9a5                	beqz	a1,658 <vprintf+0x1b0>
          putc(fd, *s);
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	dee080e7          	jalr	-530(ra) # 3da <putc>
          s++;
 5f4:	0905                	add	s2,s2,1
        while(*s != 0){
 5f6:	00094583          	lbu	a1,0(s2)
 5fa:	f9e5                	bnez	a1,5ea <vprintf+0x142>
        s = va_arg(ap, char*);
 5fc:	8bce                	mv	s7,s3
      state = 0;
 5fe:	4981                	li	s3,0
 600:	b5ed                	j	4ea <vprintf+0x42>
          s = "(null)";
 602:	00000917          	auipc	s2,0x0
 606:	26e90913          	add	s2,s2,622 # 870 <malloc+0x116>
        while(*s != 0){
 60a:	02800593          	li	a1,40
 60e:	bff1                	j	5ea <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 610:	008b8913          	add	s2,s7,8
 614:	000bc583          	lbu	a1,0(s7)
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	dc0080e7          	jalr	-576(ra) # 3da <putc>
 622:	8bca                	mv	s7,s2
      state = 0;
 624:	4981                	li	s3,0
 626:	b5d1                	j	4ea <vprintf+0x42>
        putc(fd, c);
 628:	02500593          	li	a1,37
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	dac080e7          	jalr	-596(ra) # 3da <putc>
      state = 0;
 636:	4981                	li	s3,0
 638:	bd4d                	j	4ea <vprintf+0x42>
        putc(fd, '%');
 63a:	02500593          	li	a1,37
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	d9a080e7          	jalr	-614(ra) # 3da <putc>
        putc(fd, c);
 648:	85ca                	mv	a1,s2
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	d8e080e7          	jalr	-626(ra) # 3da <putc>
      state = 0;
 654:	4981                	li	s3,0
 656:	bd51                	j	4ea <vprintf+0x42>
        s = va_arg(ap, char*);
 658:	8bce                	mv	s7,s3
      state = 0;
 65a:	4981                	li	s3,0
 65c:	b579                	j	4ea <vprintf+0x42>
 65e:	74e2                	ld	s1,56(sp)
 660:	79a2                	ld	s3,40(sp)
 662:	7a02                	ld	s4,32(sp)
 664:	6ae2                	ld	s5,24(sp)
 666:	6b42                	ld	s6,16(sp)
 668:	6ba2                	ld	s7,8(sp)
    }
  }
}
 66a:	60a6                	ld	ra,72(sp)
 66c:	6406                	ld	s0,64(sp)
 66e:	7942                	ld	s2,48(sp)
 670:	6161                	add	sp,sp,80
 672:	8082                	ret

0000000000000674 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 674:	715d                	add	sp,sp,-80
 676:	ec06                	sd	ra,24(sp)
 678:	e822                	sd	s0,16(sp)
 67a:	1000                	add	s0,sp,32
 67c:	e010                	sd	a2,0(s0)
 67e:	e414                	sd	a3,8(s0)
 680:	e818                	sd	a4,16(s0)
 682:	ec1c                	sd	a5,24(s0)
 684:	03043023          	sd	a6,32(s0)
 688:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 68c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 690:	8622                	mv	a2,s0
 692:	00000097          	auipc	ra,0x0
 696:	e16080e7          	jalr	-490(ra) # 4a8 <vprintf>
}
 69a:	60e2                	ld	ra,24(sp)
 69c:	6442                	ld	s0,16(sp)
 69e:	6161                	add	sp,sp,80
 6a0:	8082                	ret

00000000000006a2 <printf>:

void
printf(const char *fmt, ...)
{
 6a2:	711d                	add	sp,sp,-96
 6a4:	ec06                	sd	ra,24(sp)
 6a6:	e822                	sd	s0,16(sp)
 6a8:	1000                	add	s0,sp,32
 6aa:	e40c                	sd	a1,8(s0)
 6ac:	e810                	sd	a2,16(s0)
 6ae:	ec14                	sd	a3,24(s0)
 6b0:	f018                	sd	a4,32(s0)
 6b2:	f41c                	sd	a5,40(s0)
 6b4:	03043823          	sd	a6,48(s0)
 6b8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6bc:	00840613          	add	a2,s0,8
 6c0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6c4:	85aa                	mv	a1,a0
 6c6:	4505                	li	a0,1
 6c8:	00000097          	auipc	ra,0x0
 6cc:	de0080e7          	jalr	-544(ra) # 4a8 <vprintf>
}
 6d0:	60e2                	ld	ra,24(sp)
 6d2:	6442                	ld	s0,16(sp)
 6d4:	6125                	add	sp,sp,96
 6d6:	8082                	ret

00000000000006d8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d8:	1141                	add	sp,sp,-16
 6da:	e422                	sd	s0,8(sp)
 6dc:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6de:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e2:	00001797          	auipc	a5,0x1
 6e6:	d1e7b783          	ld	a5,-738(a5) # 1400 <freep>
 6ea:	a02d                	j	714 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6ec:	4618                	lw	a4,8(a2)
 6ee:	9f2d                	addw	a4,a4,a1
 6f0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f4:	6398                	ld	a4,0(a5)
 6f6:	6310                	ld	a2,0(a4)
 6f8:	a83d                	j	736 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6fa:	ff852703          	lw	a4,-8(a0)
 6fe:	9f31                	addw	a4,a4,a2
 700:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 702:	ff053683          	ld	a3,-16(a0)
 706:	a091                	j	74a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 708:	6398                	ld	a4,0(a5)
 70a:	00e7e463          	bltu	a5,a4,712 <free+0x3a>
 70e:	00e6ea63          	bltu	a3,a4,722 <free+0x4a>
{
 712:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 714:	fed7fae3          	bgeu	a5,a3,708 <free+0x30>
 718:	6398                	ld	a4,0(a5)
 71a:	00e6e463          	bltu	a3,a4,722 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71e:	fee7eae3          	bltu	a5,a4,712 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 722:	ff852583          	lw	a1,-8(a0)
 726:	6390                	ld	a2,0(a5)
 728:	02059813          	sll	a6,a1,0x20
 72c:	01c85713          	srl	a4,a6,0x1c
 730:	9736                	add	a4,a4,a3
 732:	fae60de3          	beq	a2,a4,6ec <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 736:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 73a:	4790                	lw	a2,8(a5)
 73c:	02061593          	sll	a1,a2,0x20
 740:	01c5d713          	srl	a4,a1,0x1c
 744:	973e                	add	a4,a4,a5
 746:	fae68ae3          	beq	a3,a4,6fa <free+0x22>
    p->s.ptr = bp->s.ptr;
 74a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 74c:	00001717          	auipc	a4,0x1
 750:	caf73a23          	sd	a5,-844(a4) # 1400 <freep>
}
 754:	6422                	ld	s0,8(sp)
 756:	0141                	add	sp,sp,16
 758:	8082                	ret

000000000000075a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 75a:	7139                	add	sp,sp,-64
 75c:	fc06                	sd	ra,56(sp)
 75e:	f822                	sd	s0,48(sp)
 760:	f426                	sd	s1,40(sp)
 762:	ec4e                	sd	s3,24(sp)
 764:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 766:	02051493          	sll	s1,a0,0x20
 76a:	9081                	srl	s1,s1,0x20
 76c:	04bd                	add	s1,s1,15
 76e:	8091                	srl	s1,s1,0x4
 770:	0014899b          	addw	s3,s1,1
 774:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 776:	00001517          	auipc	a0,0x1
 77a:	c8a53503          	ld	a0,-886(a0) # 1400 <freep>
 77e:	c915                	beqz	a0,7b2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 780:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 782:	4798                	lw	a4,8(a5)
 784:	08977e63          	bgeu	a4,s1,820 <malloc+0xc6>
 788:	f04a                	sd	s2,32(sp)
 78a:	e852                	sd	s4,16(sp)
 78c:	e456                	sd	s5,8(sp)
 78e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 790:	8a4e                	mv	s4,s3
 792:	0009871b          	sext.w	a4,s3
 796:	6685                	lui	a3,0x1
 798:	00d77363          	bgeu	a4,a3,79e <malloc+0x44>
 79c:	6a05                	lui	s4,0x1
 79e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7a2:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a6:	00001917          	auipc	s2,0x1
 7aa:	c5a90913          	add	s2,s2,-934 # 1400 <freep>
  if(p == (char*)-1)
 7ae:	5afd                	li	s5,-1
 7b0:	a091                	j	7f4 <malloc+0x9a>
 7b2:	f04a                	sd	s2,32(sp)
 7b4:	e852                	sd	s4,16(sp)
 7b6:	e456                	sd	s5,8(sp)
 7b8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7ba:	00001797          	auipc	a5,0x1
 7be:	c5678793          	add	a5,a5,-938 # 1410 <base>
 7c2:	00001717          	auipc	a4,0x1
 7c6:	c2f73f23          	sd	a5,-962(a4) # 1400 <freep>
 7ca:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7cc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7d0:	b7c1                	j	790 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7d2:	6398                	ld	a4,0(a5)
 7d4:	e118                	sd	a4,0(a0)
 7d6:	a08d                	j	838 <malloc+0xde>
  hp->s.size = nu;
 7d8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7dc:	0541                	add	a0,a0,16
 7de:	00000097          	auipc	ra,0x0
 7e2:	efa080e7          	jalr	-262(ra) # 6d8 <free>
  return freep;
 7e6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7ea:	c13d                	beqz	a0,850 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ec:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ee:	4798                	lw	a4,8(a5)
 7f0:	02977463          	bgeu	a4,s1,818 <malloc+0xbe>
    if(p == freep)
 7f4:	00093703          	ld	a4,0(s2)
 7f8:	853e                	mv	a0,a5
 7fa:	fef719e3          	bne	a4,a5,7ec <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 7fe:	8552                	mv	a0,s4
 800:	00000097          	auipc	ra,0x0
 804:	bb2080e7          	jalr	-1102(ra) # 3b2 <sbrk>
  if(p == (char*)-1)
 808:	fd5518e3          	bne	a0,s5,7d8 <malloc+0x7e>
        return 0;
 80c:	4501                	li	a0,0
 80e:	7902                	ld	s2,32(sp)
 810:	6a42                	ld	s4,16(sp)
 812:	6aa2                	ld	s5,8(sp)
 814:	6b02                	ld	s6,0(sp)
 816:	a03d                	j	844 <malloc+0xea>
 818:	7902                	ld	s2,32(sp)
 81a:	6a42                	ld	s4,16(sp)
 81c:	6aa2                	ld	s5,8(sp)
 81e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 820:	fae489e3          	beq	s1,a4,7d2 <malloc+0x78>
        p->s.size -= nunits;
 824:	4137073b          	subw	a4,a4,s3
 828:	c798                	sw	a4,8(a5)
        p += p->s.size;
 82a:	02071693          	sll	a3,a4,0x20
 82e:	01c6d713          	srl	a4,a3,0x1c
 832:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 834:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 838:	00001717          	auipc	a4,0x1
 83c:	bca73423          	sd	a0,-1080(a4) # 1400 <freep>
      return (void*)(p + 1);
 840:	01078513          	add	a0,a5,16
  }
}
 844:	70e2                	ld	ra,56(sp)
 846:	7442                	ld	s0,48(sp)
 848:	74a2                	ld	s1,40(sp)
 84a:	69e2                	ld	s3,24(sp)
 84c:	6121                	add	sp,sp,64
 84e:	8082                	ret
 850:	7902                	ld	s2,32(sp)
 852:	6a42                	ld	s4,16(sp)
 854:	6aa2                	ld	s5,8(sp)
 856:	6b02                	ld	s6,0(sp)
 858:	b7f5                	j	844 <malloc+0xea>
