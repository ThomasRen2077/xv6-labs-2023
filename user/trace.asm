
user/_trace:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	712d                	add	sp,sp,-288
   2:	ee06                	sd	ra,280(sp)
   4:	ea22                	sd	s0,272(sp)
   6:	e626                	sd	s1,264(sp)
   8:	e24a                	sd	s2,256(sp)
   a:	1200                	add	s0,sp,288
   c:	892e                	mv	s2,a1
  int i;
  char *nargv[MAXARG];

  if(argc < 3 || (argv[1][0] < '0' || argv[1][0] > '9')){
   e:	4789                	li	a5,2
  10:	00a7dd63          	bge	a5,a0,2a <main+0x2a>
  14:	84aa                	mv	s1,a0
  16:	6588                	ld	a0,8(a1)
  18:	00054783          	lbu	a5,0(a0)
  1c:	fd07879b          	addw	a5,a5,-48
  20:	0ff7f793          	zext.b	a5,a5
  24:	4725                	li	a4,9
  26:	02f77263          	bgeu	a4,a5,4a <main+0x4a>
    fprintf(2, "Usage: %s mask command\n", argv[0]);
  2a:	00093603          	ld	a2,0(s2)
  2e:	00001597          	auipc	a1,0x1
  32:	85258593          	add	a1,a1,-1966 # 880 <malloc+0x10a>
  36:	4509                	li	a0,2
  38:	00000097          	auipc	ra,0x0
  3c:	658080e7          	jalr	1624(ra) # 690 <fprintf>
    exit(1);
  40:	4505                	li	a0,1
  42:	00000097          	auipc	ra,0x0
  46:	304080e7          	jalr	772(ra) # 346 <exit>
  }

  if (trace(atoi(argv[1])) < 0) {
  4a:	00000097          	auipc	ra,0x0
  4e:	202080e7          	jalr	514(ra) # 24c <atoi>
  52:	00000097          	auipc	ra,0x0
  56:	394080e7          	jalr	916(ra) # 3e6 <trace>
  5a:	04054363          	bltz	a0,a0 <main+0xa0>
  5e:	01090793          	add	a5,s2,16
  62:	ee040713          	add	a4,s0,-288
  66:	34f5                	addw	s1,s1,-3
  68:	02049693          	sll	a3,s1,0x20
  6c:	01d6d493          	srl	s1,a3,0x1d
  70:	94be                	add	s1,s1,a5
  72:	10090593          	add	a1,s2,256
    fprintf(2, "%s: trace failed\n", argv[0]);
    exit(1);
  }
  
  for(i = 2; i < argc && i < MAXARG; i++){
    nargv[i-2] = argv[i];
  76:	6394                	ld	a3,0(a5)
  78:	e314                	sd	a3,0(a4)
  for(i = 2; i < argc && i < MAXARG; i++){
  7a:	00978663          	beq	a5,s1,86 <main+0x86>
  7e:	07a1                	add	a5,a5,8
  80:	0721                	add	a4,a4,8
  82:	feb79ae3          	bne	a5,a1,76 <main+0x76>
  }
  exec(nargv[0], nargv);
  86:	ee040593          	add	a1,s0,-288
  8a:	ee043503          	ld	a0,-288(s0)
  8e:	00000097          	auipc	ra,0x0
  92:	2f0080e7          	jalr	752(ra) # 37e <exec>
  exit(0);
  96:	4501                	li	a0,0
  98:	00000097          	auipc	ra,0x0
  9c:	2ae080e7          	jalr	686(ra) # 346 <exit>
    fprintf(2, "%s: trace failed\n", argv[0]);
  a0:	00093603          	ld	a2,0(s2)
  a4:	00000597          	auipc	a1,0x0
  a8:	7f458593          	add	a1,a1,2036 # 898 <malloc+0x122>
  ac:	4509                	li	a0,2
  ae:	00000097          	auipc	ra,0x0
  b2:	5e2080e7          	jalr	1506(ra) # 690 <fprintf>
    exit(1);
  b6:	4505                	li	a0,1
  b8:	00000097          	auipc	ra,0x0
  bc:	28e080e7          	jalr	654(ra) # 346 <exit>

00000000000000c0 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  c0:	1141                	add	sp,sp,-16
  c2:	e406                	sd	ra,8(sp)
  c4:	e022                	sd	s0,0(sp)
  c6:	0800                	add	s0,sp,16
  extern int main();
  main();
  c8:	00000097          	auipc	ra,0x0
  cc:	f38080e7          	jalr	-200(ra) # 0 <main>
  exit(0);
  d0:	4501                	li	a0,0
  d2:	00000097          	auipc	ra,0x0
  d6:	274080e7          	jalr	628(ra) # 346 <exit>

00000000000000da <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  da:	1141                	add	sp,sp,-16
  dc:	e422                	sd	s0,8(sp)
  de:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e0:	87aa                	mv	a5,a0
  e2:	0585                	add	a1,a1,1
  e4:	0785                	add	a5,a5,1
  e6:	fff5c703          	lbu	a4,-1(a1)
  ea:	fee78fa3          	sb	a4,-1(a5)
  ee:	fb75                	bnez	a4,e2 <strcpy+0x8>
    ;
  return os;
}
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	add	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f6:	1141                	add	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  fc:	00054783          	lbu	a5,0(a0)
 100:	cb91                	beqz	a5,114 <strcmp+0x1e>
 102:	0005c703          	lbu	a4,0(a1)
 106:	00f71763          	bne	a4,a5,114 <strcmp+0x1e>
    p++, q++;
 10a:	0505                	add	a0,a0,1
 10c:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 10e:	00054783          	lbu	a5,0(a0)
 112:	fbe5                	bnez	a5,102 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 114:	0005c503          	lbu	a0,0(a1)
}
 118:	40a7853b          	subw	a0,a5,a0
 11c:	6422                	ld	s0,8(sp)
 11e:	0141                	add	sp,sp,16
 120:	8082                	ret

0000000000000122 <strlen>:

uint
strlen(const char *s)
{
 122:	1141                	add	sp,sp,-16
 124:	e422                	sd	s0,8(sp)
 126:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 128:	00054783          	lbu	a5,0(a0)
 12c:	cf91                	beqz	a5,148 <strlen+0x26>
 12e:	0505                	add	a0,a0,1
 130:	87aa                	mv	a5,a0
 132:	86be                	mv	a3,a5
 134:	0785                	add	a5,a5,1
 136:	fff7c703          	lbu	a4,-1(a5)
 13a:	ff65                	bnez	a4,132 <strlen+0x10>
 13c:	40a6853b          	subw	a0,a3,a0
 140:	2505                	addw	a0,a0,1
    ;
  return n;
}
 142:	6422                	ld	s0,8(sp)
 144:	0141                	add	sp,sp,16
 146:	8082                	ret
  for(n = 0; s[n]; n++)
 148:	4501                	li	a0,0
 14a:	bfe5                	j	142 <strlen+0x20>

000000000000014c <memset>:

void*
memset(void *dst, int c, uint n)
{
 14c:	1141                	add	sp,sp,-16
 14e:	e422                	sd	s0,8(sp)
 150:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 152:	ca19                	beqz	a2,168 <memset+0x1c>
 154:	87aa                	mv	a5,a0
 156:	1602                	sll	a2,a2,0x20
 158:	9201                	srl	a2,a2,0x20
 15a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 15e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 162:	0785                	add	a5,a5,1
 164:	fee79de3          	bne	a5,a4,15e <memset+0x12>
  }
  return dst;
}
 168:	6422                	ld	s0,8(sp)
 16a:	0141                	add	sp,sp,16
 16c:	8082                	ret

000000000000016e <strchr>:

char*
strchr(const char *s, char c)
{
 16e:	1141                	add	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	add	s0,sp,16
  for(; *s; s++)
 174:	00054783          	lbu	a5,0(a0)
 178:	cb99                	beqz	a5,18e <strchr+0x20>
    if(*s == c)
 17a:	00f58763          	beq	a1,a5,188 <strchr+0x1a>
  for(; *s; s++)
 17e:	0505                	add	a0,a0,1
 180:	00054783          	lbu	a5,0(a0)
 184:	fbfd                	bnez	a5,17a <strchr+0xc>
      return (char*)s;
  return 0;
 186:	4501                	li	a0,0
}
 188:	6422                	ld	s0,8(sp)
 18a:	0141                	add	sp,sp,16
 18c:	8082                	ret
  return 0;
 18e:	4501                	li	a0,0
 190:	bfe5                	j	188 <strchr+0x1a>

0000000000000192 <gets>:

char*
gets(char *buf, int max)
{
 192:	711d                	add	sp,sp,-96
 194:	ec86                	sd	ra,88(sp)
 196:	e8a2                	sd	s0,80(sp)
 198:	e4a6                	sd	s1,72(sp)
 19a:	e0ca                	sd	s2,64(sp)
 19c:	fc4e                	sd	s3,56(sp)
 19e:	f852                	sd	s4,48(sp)
 1a0:	f456                	sd	s5,40(sp)
 1a2:	f05a                	sd	s6,32(sp)
 1a4:	ec5e                	sd	s7,24(sp)
 1a6:	1080                	add	s0,sp,96
 1a8:	8baa                	mv	s7,a0
 1aa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ac:	892a                	mv	s2,a0
 1ae:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1b0:	4aa9                	li	s5,10
 1b2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1b4:	89a6                	mv	s3,s1
 1b6:	2485                	addw	s1,s1,1
 1b8:	0344d863          	bge	s1,s4,1e8 <gets+0x56>
    cc = read(0, &c, 1);
 1bc:	4605                	li	a2,1
 1be:	faf40593          	add	a1,s0,-81
 1c2:	4501                	li	a0,0
 1c4:	00000097          	auipc	ra,0x0
 1c8:	19a080e7          	jalr	410(ra) # 35e <read>
    if(cc < 1)
 1cc:	00a05e63          	blez	a0,1e8 <gets+0x56>
    buf[i++] = c;
 1d0:	faf44783          	lbu	a5,-81(s0)
 1d4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1d8:	01578763          	beq	a5,s5,1e6 <gets+0x54>
 1dc:	0905                	add	s2,s2,1
 1de:	fd679be3          	bne	a5,s6,1b4 <gets+0x22>
    buf[i++] = c;
 1e2:	89a6                	mv	s3,s1
 1e4:	a011                	j	1e8 <gets+0x56>
 1e6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1e8:	99de                	add	s3,s3,s7
 1ea:	00098023          	sb	zero,0(s3)
  return buf;
}
 1ee:	855e                	mv	a0,s7
 1f0:	60e6                	ld	ra,88(sp)
 1f2:	6446                	ld	s0,80(sp)
 1f4:	64a6                	ld	s1,72(sp)
 1f6:	6906                	ld	s2,64(sp)
 1f8:	79e2                	ld	s3,56(sp)
 1fa:	7a42                	ld	s4,48(sp)
 1fc:	7aa2                	ld	s5,40(sp)
 1fe:	7b02                	ld	s6,32(sp)
 200:	6be2                	ld	s7,24(sp)
 202:	6125                	add	sp,sp,96
 204:	8082                	ret

0000000000000206 <stat>:

int
stat(const char *n, struct stat *st)
{
 206:	1101                	add	sp,sp,-32
 208:	ec06                	sd	ra,24(sp)
 20a:	e822                	sd	s0,16(sp)
 20c:	e04a                	sd	s2,0(sp)
 20e:	1000                	add	s0,sp,32
 210:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 212:	4581                	li	a1,0
 214:	00000097          	auipc	ra,0x0
 218:	172080e7          	jalr	370(ra) # 386 <open>
  if(fd < 0)
 21c:	02054663          	bltz	a0,248 <stat+0x42>
 220:	e426                	sd	s1,8(sp)
 222:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 224:	85ca                	mv	a1,s2
 226:	00000097          	auipc	ra,0x0
 22a:	178080e7          	jalr	376(ra) # 39e <fstat>
 22e:	892a                	mv	s2,a0
  close(fd);
 230:	8526                	mv	a0,s1
 232:	00000097          	auipc	ra,0x0
 236:	13c080e7          	jalr	316(ra) # 36e <close>
  return r;
 23a:	64a2                	ld	s1,8(sp)
}
 23c:	854a                	mv	a0,s2
 23e:	60e2                	ld	ra,24(sp)
 240:	6442                	ld	s0,16(sp)
 242:	6902                	ld	s2,0(sp)
 244:	6105                	add	sp,sp,32
 246:	8082                	ret
    return -1;
 248:	597d                	li	s2,-1
 24a:	bfcd                	j	23c <stat+0x36>

000000000000024c <atoi>:

int
atoi(const char *s)
{
 24c:	1141                	add	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 252:	00054683          	lbu	a3,0(a0)
 256:	fd06879b          	addw	a5,a3,-48
 25a:	0ff7f793          	zext.b	a5,a5
 25e:	4625                	li	a2,9
 260:	02f66863          	bltu	a2,a5,290 <atoi+0x44>
 264:	872a                	mv	a4,a0
  n = 0;
 266:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 268:	0705                	add	a4,a4,1
 26a:	0025179b          	sllw	a5,a0,0x2
 26e:	9fa9                	addw	a5,a5,a0
 270:	0017979b          	sllw	a5,a5,0x1
 274:	9fb5                	addw	a5,a5,a3
 276:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 27a:	00074683          	lbu	a3,0(a4)
 27e:	fd06879b          	addw	a5,a3,-48
 282:	0ff7f793          	zext.b	a5,a5
 286:	fef671e3          	bgeu	a2,a5,268 <atoi+0x1c>
  return n;
}
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	add	sp,sp,16
 28e:	8082                	ret
  n = 0;
 290:	4501                	li	a0,0
 292:	bfe5                	j	28a <atoi+0x3e>

0000000000000294 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 294:	1141                	add	sp,sp,-16
 296:	e422                	sd	s0,8(sp)
 298:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 29a:	02b57463          	bgeu	a0,a1,2c2 <memmove+0x2e>
    while(n-- > 0)
 29e:	00c05f63          	blez	a2,2bc <memmove+0x28>
 2a2:	1602                	sll	a2,a2,0x20
 2a4:	9201                	srl	a2,a2,0x20
 2a6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2aa:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ac:	0585                	add	a1,a1,1
 2ae:	0705                	add	a4,a4,1
 2b0:	fff5c683          	lbu	a3,-1(a1)
 2b4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2b8:	fef71ae3          	bne	a4,a5,2ac <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	add	sp,sp,16
 2c0:	8082                	ret
    dst += n;
 2c2:	00c50733          	add	a4,a0,a2
    src += n;
 2c6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2c8:	fec05ae3          	blez	a2,2bc <memmove+0x28>
 2cc:	fff6079b          	addw	a5,a2,-1
 2d0:	1782                	sll	a5,a5,0x20
 2d2:	9381                	srl	a5,a5,0x20
 2d4:	fff7c793          	not	a5,a5
 2d8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2da:	15fd                	add	a1,a1,-1
 2dc:	177d                	add	a4,a4,-1
 2de:	0005c683          	lbu	a3,0(a1)
 2e2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2e6:	fee79ae3          	bne	a5,a4,2da <memmove+0x46>
 2ea:	bfc9                	j	2bc <memmove+0x28>

00000000000002ec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ec:	1141                	add	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2f2:	ca05                	beqz	a2,322 <memcmp+0x36>
 2f4:	fff6069b          	addw	a3,a2,-1
 2f8:	1682                	sll	a3,a3,0x20
 2fa:	9281                	srl	a3,a3,0x20
 2fc:	0685                	add	a3,a3,1
 2fe:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 300:	00054783          	lbu	a5,0(a0)
 304:	0005c703          	lbu	a4,0(a1)
 308:	00e79863          	bne	a5,a4,318 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 30c:	0505                	add	a0,a0,1
    p2++;
 30e:	0585                	add	a1,a1,1
  while (n-- > 0) {
 310:	fed518e3          	bne	a0,a3,300 <memcmp+0x14>
  }
  return 0;
 314:	4501                	li	a0,0
 316:	a019                	j	31c <memcmp+0x30>
      return *p1 - *p2;
 318:	40e7853b          	subw	a0,a5,a4
}
 31c:	6422                	ld	s0,8(sp)
 31e:	0141                	add	sp,sp,16
 320:	8082                	ret
  return 0;
 322:	4501                	li	a0,0
 324:	bfe5                	j	31c <memcmp+0x30>

0000000000000326 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 326:	1141                	add	sp,sp,-16
 328:	e406                	sd	ra,8(sp)
 32a:	e022                	sd	s0,0(sp)
 32c:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 32e:	00000097          	auipc	ra,0x0
 332:	f66080e7          	jalr	-154(ra) # 294 <memmove>
}
 336:	60a2                	ld	ra,8(sp)
 338:	6402                	ld	s0,0(sp)
 33a:	0141                	add	sp,sp,16
 33c:	8082                	ret

000000000000033e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 33e:	4885                	li	a7,1
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <exit>:
.global exit
exit:
 li a7, SYS_exit
 346:	4889                	li	a7,2
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <wait>:
.global wait
wait:
 li a7, SYS_wait
 34e:	488d                	li	a7,3
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 356:	4891                	li	a7,4
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <read>:
.global read
read:
 li a7, SYS_read
 35e:	4895                	li	a7,5
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <write>:
.global write
write:
 li a7, SYS_write
 366:	48c1                	li	a7,16
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <close>:
.global close
close:
 li a7, SYS_close
 36e:	48d5                	li	a7,21
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <kill>:
.global kill
kill:
 li a7, SYS_kill
 376:	4899                	li	a7,6
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <exec>:
.global exec
exec:
 li a7, SYS_exec
 37e:	489d                	li	a7,7
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <open>:
.global open
open:
 li a7, SYS_open
 386:	48bd                	li	a7,15
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 38e:	48c5                	li	a7,17
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 396:	48c9                	li	a7,18
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 39e:	48a1                	li	a7,8
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <link>:
.global link
link:
 li a7, SYS_link
 3a6:	48cd                	li	a7,19
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3ae:	48d1                	li	a7,20
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3b6:	48a5                	li	a7,9
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <dup>:
.global dup
dup:
 li a7, SYS_dup
 3be:	48a9                	li	a7,10
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3c6:	48ad                	li	a7,11
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3ce:	48b1                	li	a7,12
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3d6:	48b5                	li	a7,13
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3de:	48b9                	li	a7,14
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3e6:	48d9                	li	a7,22
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 3ee:	48dd                	li	a7,23
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3f6:	1101                	add	sp,sp,-32
 3f8:	ec06                	sd	ra,24(sp)
 3fa:	e822                	sd	s0,16(sp)
 3fc:	1000                	add	s0,sp,32
 3fe:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 402:	4605                	li	a2,1
 404:	fef40593          	add	a1,s0,-17
 408:	00000097          	auipc	ra,0x0
 40c:	f5e080e7          	jalr	-162(ra) # 366 <write>
}
 410:	60e2                	ld	ra,24(sp)
 412:	6442                	ld	s0,16(sp)
 414:	6105                	add	sp,sp,32
 416:	8082                	ret

0000000000000418 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 418:	7139                	add	sp,sp,-64
 41a:	fc06                	sd	ra,56(sp)
 41c:	f822                	sd	s0,48(sp)
 41e:	f426                	sd	s1,40(sp)
 420:	0080                	add	s0,sp,64
 422:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 424:	c299                	beqz	a3,42a <printint+0x12>
 426:	0805cb63          	bltz	a1,4bc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 42a:	2581                	sext.w	a1,a1
  neg = 0;
 42c:	4881                	li	a7,0
 42e:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 432:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 434:	2601                	sext.w	a2,a2
 436:	00000517          	auipc	a0,0x0
 43a:	4da50513          	add	a0,a0,1242 # 910 <digits>
 43e:	883a                	mv	a6,a4
 440:	2705                	addw	a4,a4,1
 442:	02c5f7bb          	remuw	a5,a1,a2
 446:	1782                	sll	a5,a5,0x20
 448:	9381                	srl	a5,a5,0x20
 44a:	97aa                	add	a5,a5,a0
 44c:	0007c783          	lbu	a5,0(a5)
 450:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 454:	0005879b          	sext.w	a5,a1
 458:	02c5d5bb          	divuw	a1,a1,a2
 45c:	0685                	add	a3,a3,1
 45e:	fec7f0e3          	bgeu	a5,a2,43e <printint+0x26>
  if(neg)
 462:	00088c63          	beqz	a7,47a <printint+0x62>
    buf[i++] = '-';
 466:	fd070793          	add	a5,a4,-48
 46a:	00878733          	add	a4,a5,s0
 46e:	02d00793          	li	a5,45
 472:	fef70823          	sb	a5,-16(a4)
 476:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 47a:	02e05c63          	blez	a4,4b2 <printint+0x9a>
 47e:	f04a                	sd	s2,32(sp)
 480:	ec4e                	sd	s3,24(sp)
 482:	fc040793          	add	a5,s0,-64
 486:	00e78933          	add	s2,a5,a4
 48a:	fff78993          	add	s3,a5,-1
 48e:	99ba                	add	s3,s3,a4
 490:	377d                	addw	a4,a4,-1
 492:	1702                	sll	a4,a4,0x20
 494:	9301                	srl	a4,a4,0x20
 496:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 49a:	fff94583          	lbu	a1,-1(s2)
 49e:	8526                	mv	a0,s1
 4a0:	00000097          	auipc	ra,0x0
 4a4:	f56080e7          	jalr	-170(ra) # 3f6 <putc>
  while(--i >= 0)
 4a8:	197d                	add	s2,s2,-1
 4aa:	ff3918e3          	bne	s2,s3,49a <printint+0x82>
 4ae:	7902                	ld	s2,32(sp)
 4b0:	69e2                	ld	s3,24(sp)
}
 4b2:	70e2                	ld	ra,56(sp)
 4b4:	7442                	ld	s0,48(sp)
 4b6:	74a2                	ld	s1,40(sp)
 4b8:	6121                	add	sp,sp,64
 4ba:	8082                	ret
    x = -xx;
 4bc:	40b005bb          	negw	a1,a1
    neg = 1;
 4c0:	4885                	li	a7,1
    x = -xx;
 4c2:	b7b5                	j	42e <printint+0x16>

00000000000004c4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c4:	715d                	add	sp,sp,-80
 4c6:	e486                	sd	ra,72(sp)
 4c8:	e0a2                	sd	s0,64(sp)
 4ca:	f84a                	sd	s2,48(sp)
 4cc:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ce:	0005c903          	lbu	s2,0(a1)
 4d2:	1a090a63          	beqz	s2,686 <vprintf+0x1c2>
 4d6:	fc26                	sd	s1,56(sp)
 4d8:	f44e                	sd	s3,40(sp)
 4da:	f052                	sd	s4,32(sp)
 4dc:	ec56                	sd	s5,24(sp)
 4de:	e85a                	sd	s6,16(sp)
 4e0:	e45e                	sd	s7,8(sp)
 4e2:	8aaa                	mv	s5,a0
 4e4:	8bb2                	mv	s7,a2
 4e6:	00158493          	add	s1,a1,1
  state = 0;
 4ea:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ec:	02500a13          	li	s4,37
 4f0:	4b55                	li	s6,21
 4f2:	a839                	j	510 <vprintf+0x4c>
        putc(fd, c);
 4f4:	85ca                	mv	a1,s2
 4f6:	8556                	mv	a0,s5
 4f8:	00000097          	auipc	ra,0x0
 4fc:	efe080e7          	jalr	-258(ra) # 3f6 <putc>
 500:	a019                	j	506 <vprintf+0x42>
    } else if(state == '%'){
 502:	01498d63          	beq	s3,s4,51c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 506:	0485                	add	s1,s1,1
 508:	fff4c903          	lbu	s2,-1(s1)
 50c:	16090763          	beqz	s2,67a <vprintf+0x1b6>
    if(state == 0){
 510:	fe0999e3          	bnez	s3,502 <vprintf+0x3e>
      if(c == '%'){
 514:	ff4910e3          	bne	s2,s4,4f4 <vprintf+0x30>
        state = '%';
 518:	89d2                	mv	s3,s4
 51a:	b7f5                	j	506 <vprintf+0x42>
      if(c == 'd'){
 51c:	13490463          	beq	s2,s4,644 <vprintf+0x180>
 520:	f9d9079b          	addw	a5,s2,-99
 524:	0ff7f793          	zext.b	a5,a5
 528:	12fb6763          	bltu	s6,a5,656 <vprintf+0x192>
 52c:	f9d9079b          	addw	a5,s2,-99
 530:	0ff7f713          	zext.b	a4,a5
 534:	12eb6163          	bltu	s6,a4,656 <vprintf+0x192>
 538:	00271793          	sll	a5,a4,0x2
 53c:	00000717          	auipc	a4,0x0
 540:	37c70713          	add	a4,a4,892 # 8b8 <malloc+0x142>
 544:	97ba                	add	a5,a5,a4
 546:	439c                	lw	a5,0(a5)
 548:	97ba                	add	a5,a5,a4
 54a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 54c:	008b8913          	add	s2,s7,8
 550:	4685                	li	a3,1
 552:	4629                	li	a2,10
 554:	000ba583          	lw	a1,0(s7)
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	ebe080e7          	jalr	-322(ra) # 418 <printint>
 562:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 564:	4981                	li	s3,0
 566:	b745                	j	506 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 568:	008b8913          	add	s2,s7,8
 56c:	4681                	li	a3,0
 56e:	4629                	li	a2,10
 570:	000ba583          	lw	a1,0(s7)
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	ea2080e7          	jalr	-350(ra) # 418 <printint>
 57e:	8bca                	mv	s7,s2
      state = 0;
 580:	4981                	li	s3,0
 582:	b751                	j	506 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 584:	008b8913          	add	s2,s7,8
 588:	4681                	li	a3,0
 58a:	4641                	li	a2,16
 58c:	000ba583          	lw	a1,0(s7)
 590:	8556                	mv	a0,s5
 592:	00000097          	auipc	ra,0x0
 596:	e86080e7          	jalr	-378(ra) # 418 <printint>
 59a:	8bca                	mv	s7,s2
      state = 0;
 59c:	4981                	li	s3,0
 59e:	b7a5                	j	506 <vprintf+0x42>
 5a0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5a2:	008b8c13          	add	s8,s7,8
 5a6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5aa:	03000593          	li	a1,48
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	e46080e7          	jalr	-442(ra) # 3f6 <putc>
  putc(fd, 'x');
 5b8:	07800593          	li	a1,120
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	e38080e7          	jalr	-456(ra) # 3f6 <putc>
 5c6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5c8:	00000b97          	auipc	s7,0x0
 5cc:	348b8b93          	add	s7,s7,840 # 910 <digits>
 5d0:	03c9d793          	srl	a5,s3,0x3c
 5d4:	97de                	add	a5,a5,s7
 5d6:	0007c583          	lbu	a1,0(a5)
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	e1a080e7          	jalr	-486(ra) # 3f6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5e4:	0992                	sll	s3,s3,0x4
 5e6:	397d                	addw	s2,s2,-1
 5e8:	fe0914e3          	bnez	s2,5d0 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5ec:	8be2                	mv	s7,s8
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	6c02                	ld	s8,0(sp)
 5f2:	bf11                	j	506 <vprintf+0x42>
        s = va_arg(ap, char*);
 5f4:	008b8993          	add	s3,s7,8
 5f8:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5fc:	02090163          	beqz	s2,61e <vprintf+0x15a>
        while(*s != 0){
 600:	00094583          	lbu	a1,0(s2)
 604:	c9a5                	beqz	a1,674 <vprintf+0x1b0>
          putc(fd, *s);
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	dee080e7          	jalr	-530(ra) # 3f6 <putc>
          s++;
 610:	0905                	add	s2,s2,1
        while(*s != 0){
 612:	00094583          	lbu	a1,0(s2)
 616:	f9e5                	bnez	a1,606 <vprintf+0x142>
        s = va_arg(ap, char*);
 618:	8bce                	mv	s7,s3
      state = 0;
 61a:	4981                	li	s3,0
 61c:	b5ed                	j	506 <vprintf+0x42>
          s = "(null)";
 61e:	00000917          	auipc	s2,0x0
 622:	29290913          	add	s2,s2,658 # 8b0 <malloc+0x13a>
        while(*s != 0){
 626:	02800593          	li	a1,40
 62a:	bff1                	j	606 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 62c:	008b8913          	add	s2,s7,8
 630:	000bc583          	lbu	a1,0(s7)
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	dc0080e7          	jalr	-576(ra) # 3f6 <putc>
 63e:	8bca                	mv	s7,s2
      state = 0;
 640:	4981                	li	s3,0
 642:	b5d1                	j	506 <vprintf+0x42>
        putc(fd, c);
 644:	02500593          	li	a1,37
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	dac080e7          	jalr	-596(ra) # 3f6 <putc>
      state = 0;
 652:	4981                	li	s3,0
 654:	bd4d                	j	506 <vprintf+0x42>
        putc(fd, '%');
 656:	02500593          	li	a1,37
 65a:	8556                	mv	a0,s5
 65c:	00000097          	auipc	ra,0x0
 660:	d9a080e7          	jalr	-614(ra) # 3f6 <putc>
        putc(fd, c);
 664:	85ca                	mv	a1,s2
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	d8e080e7          	jalr	-626(ra) # 3f6 <putc>
      state = 0;
 670:	4981                	li	s3,0
 672:	bd51                	j	506 <vprintf+0x42>
        s = va_arg(ap, char*);
 674:	8bce                	mv	s7,s3
      state = 0;
 676:	4981                	li	s3,0
 678:	b579                	j	506 <vprintf+0x42>
 67a:	74e2                	ld	s1,56(sp)
 67c:	79a2                	ld	s3,40(sp)
 67e:	7a02                	ld	s4,32(sp)
 680:	6ae2                	ld	s5,24(sp)
 682:	6b42                	ld	s6,16(sp)
 684:	6ba2                	ld	s7,8(sp)
    }
  }
}
 686:	60a6                	ld	ra,72(sp)
 688:	6406                	ld	s0,64(sp)
 68a:	7942                	ld	s2,48(sp)
 68c:	6161                	add	sp,sp,80
 68e:	8082                	ret

0000000000000690 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 690:	715d                	add	sp,sp,-80
 692:	ec06                	sd	ra,24(sp)
 694:	e822                	sd	s0,16(sp)
 696:	1000                	add	s0,sp,32
 698:	e010                	sd	a2,0(s0)
 69a:	e414                	sd	a3,8(s0)
 69c:	e818                	sd	a4,16(s0)
 69e:	ec1c                	sd	a5,24(s0)
 6a0:	03043023          	sd	a6,32(s0)
 6a4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6a8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ac:	8622                	mv	a2,s0
 6ae:	00000097          	auipc	ra,0x0
 6b2:	e16080e7          	jalr	-490(ra) # 4c4 <vprintf>
}
 6b6:	60e2                	ld	ra,24(sp)
 6b8:	6442                	ld	s0,16(sp)
 6ba:	6161                	add	sp,sp,80
 6bc:	8082                	ret

00000000000006be <printf>:

void
printf(const char *fmt, ...)
{
 6be:	711d                	add	sp,sp,-96
 6c0:	ec06                	sd	ra,24(sp)
 6c2:	e822                	sd	s0,16(sp)
 6c4:	1000                	add	s0,sp,32
 6c6:	e40c                	sd	a1,8(s0)
 6c8:	e810                	sd	a2,16(s0)
 6ca:	ec14                	sd	a3,24(s0)
 6cc:	f018                	sd	a4,32(s0)
 6ce:	f41c                	sd	a5,40(s0)
 6d0:	03043823          	sd	a6,48(s0)
 6d4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6d8:	00840613          	add	a2,s0,8
 6dc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6e0:	85aa                	mv	a1,a0
 6e2:	4505                	li	a0,1
 6e4:	00000097          	auipc	ra,0x0
 6e8:	de0080e7          	jalr	-544(ra) # 4c4 <vprintf>
}
 6ec:	60e2                	ld	ra,24(sp)
 6ee:	6442                	ld	s0,16(sp)
 6f0:	6125                	add	sp,sp,96
 6f2:	8082                	ret

00000000000006f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f4:	1141                	add	sp,sp,-16
 6f6:	e422                	sd	s0,8(sp)
 6f8:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fa:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fe:	00001797          	auipc	a5,0x1
 702:	ce27b783          	ld	a5,-798(a5) # 13e0 <freep>
 706:	a02d                	j	730 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 708:	4618                	lw	a4,8(a2)
 70a:	9f2d                	addw	a4,a4,a1
 70c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 710:	6398                	ld	a4,0(a5)
 712:	6310                	ld	a2,0(a4)
 714:	a83d                	j	752 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 716:	ff852703          	lw	a4,-8(a0)
 71a:	9f31                	addw	a4,a4,a2
 71c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 71e:	ff053683          	ld	a3,-16(a0)
 722:	a091                	j	766 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 724:	6398                	ld	a4,0(a5)
 726:	00e7e463          	bltu	a5,a4,72e <free+0x3a>
 72a:	00e6ea63          	bltu	a3,a4,73e <free+0x4a>
{
 72e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 730:	fed7fae3          	bgeu	a5,a3,724 <free+0x30>
 734:	6398                	ld	a4,0(a5)
 736:	00e6e463          	bltu	a3,a4,73e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73a:	fee7eae3          	bltu	a5,a4,72e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 73e:	ff852583          	lw	a1,-8(a0)
 742:	6390                	ld	a2,0(a5)
 744:	02059813          	sll	a6,a1,0x20
 748:	01c85713          	srl	a4,a6,0x1c
 74c:	9736                	add	a4,a4,a3
 74e:	fae60de3          	beq	a2,a4,708 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 752:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 756:	4790                	lw	a2,8(a5)
 758:	02061593          	sll	a1,a2,0x20
 75c:	01c5d713          	srl	a4,a1,0x1c
 760:	973e                	add	a4,a4,a5
 762:	fae68ae3          	beq	a3,a4,716 <free+0x22>
    p->s.ptr = bp->s.ptr;
 766:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 768:	00001717          	auipc	a4,0x1
 76c:	c6f73c23          	sd	a5,-904(a4) # 13e0 <freep>
}
 770:	6422                	ld	s0,8(sp)
 772:	0141                	add	sp,sp,16
 774:	8082                	ret

0000000000000776 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 776:	7139                	add	sp,sp,-64
 778:	fc06                	sd	ra,56(sp)
 77a:	f822                	sd	s0,48(sp)
 77c:	f426                	sd	s1,40(sp)
 77e:	ec4e                	sd	s3,24(sp)
 780:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 782:	02051493          	sll	s1,a0,0x20
 786:	9081                	srl	s1,s1,0x20
 788:	04bd                	add	s1,s1,15
 78a:	8091                	srl	s1,s1,0x4
 78c:	0014899b          	addw	s3,s1,1
 790:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 792:	00001517          	auipc	a0,0x1
 796:	c4e53503          	ld	a0,-946(a0) # 13e0 <freep>
 79a:	c915                	beqz	a0,7ce <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 79e:	4798                	lw	a4,8(a5)
 7a0:	08977e63          	bgeu	a4,s1,83c <malloc+0xc6>
 7a4:	f04a                	sd	s2,32(sp)
 7a6:	e852                	sd	s4,16(sp)
 7a8:	e456                	sd	s5,8(sp)
 7aa:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7ac:	8a4e                	mv	s4,s3
 7ae:	0009871b          	sext.w	a4,s3
 7b2:	6685                	lui	a3,0x1
 7b4:	00d77363          	bgeu	a4,a3,7ba <malloc+0x44>
 7b8:	6a05                	lui	s4,0x1
 7ba:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7be:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c2:	00001917          	auipc	s2,0x1
 7c6:	c1e90913          	add	s2,s2,-994 # 13e0 <freep>
  if(p == (char*)-1)
 7ca:	5afd                	li	s5,-1
 7cc:	a091                	j	810 <malloc+0x9a>
 7ce:	f04a                	sd	s2,32(sp)
 7d0:	e852                	sd	s4,16(sp)
 7d2:	e456                	sd	s5,8(sp)
 7d4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7d6:	00001797          	auipc	a5,0x1
 7da:	c1a78793          	add	a5,a5,-998 # 13f0 <base>
 7de:	00001717          	auipc	a4,0x1
 7e2:	c0f73123          	sd	a5,-1022(a4) # 13e0 <freep>
 7e6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7e8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ec:	b7c1                	j	7ac <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7ee:	6398                	ld	a4,0(a5)
 7f0:	e118                	sd	a4,0(a0)
 7f2:	a08d                	j	854 <malloc+0xde>
  hp->s.size = nu;
 7f4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7f8:	0541                	add	a0,a0,16
 7fa:	00000097          	auipc	ra,0x0
 7fe:	efa080e7          	jalr	-262(ra) # 6f4 <free>
  return freep;
 802:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 806:	c13d                	beqz	a0,86c <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 808:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80a:	4798                	lw	a4,8(a5)
 80c:	02977463          	bgeu	a4,s1,834 <malloc+0xbe>
    if(p == freep)
 810:	00093703          	ld	a4,0(s2)
 814:	853e                	mv	a0,a5
 816:	fef719e3          	bne	a4,a5,808 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 81a:	8552                	mv	a0,s4
 81c:	00000097          	auipc	ra,0x0
 820:	bb2080e7          	jalr	-1102(ra) # 3ce <sbrk>
  if(p == (char*)-1)
 824:	fd5518e3          	bne	a0,s5,7f4 <malloc+0x7e>
        return 0;
 828:	4501                	li	a0,0
 82a:	7902                	ld	s2,32(sp)
 82c:	6a42                	ld	s4,16(sp)
 82e:	6aa2                	ld	s5,8(sp)
 830:	6b02                	ld	s6,0(sp)
 832:	a03d                	j	860 <malloc+0xea>
 834:	7902                	ld	s2,32(sp)
 836:	6a42                	ld	s4,16(sp)
 838:	6aa2                	ld	s5,8(sp)
 83a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 83c:	fae489e3          	beq	s1,a4,7ee <malloc+0x78>
        p->s.size -= nunits;
 840:	4137073b          	subw	a4,a4,s3
 844:	c798                	sw	a4,8(a5)
        p += p->s.size;
 846:	02071693          	sll	a3,a4,0x20
 84a:	01c6d713          	srl	a4,a3,0x1c
 84e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 850:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 854:	00001717          	auipc	a4,0x1
 858:	b8a73623          	sd	a0,-1140(a4) # 13e0 <freep>
      return (void*)(p + 1);
 85c:	01078513          	add	a0,a5,16
  }
}
 860:	70e2                	ld	ra,56(sp)
 862:	7442                	ld	s0,48(sp)
 864:	74a2                	ld	s1,40(sp)
 866:	69e2                	ld	s3,24(sp)
 868:	6121                	add	sp,sp,64
 86a:	8082                	ret
 86c:	7902                	ld	s2,32(sp)
 86e:	6a42                	ld	s4,16(sp)
 870:	6aa2                	ld	s5,8(sp)
 872:	6b02                	ld	s6,0(sp)
 874:	b7f5                	j	860 <malloc+0xea>
