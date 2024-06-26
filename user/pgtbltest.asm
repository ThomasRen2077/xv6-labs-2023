
user/_pgtbltest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:

char *testname = "???";

void
err(char *why)
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	add	s0,sp,32
   c:	84aa                	mv	s1,a0
  printf("pgtbltest: %s failed: %s, pid=%d\n", testname, why, getpid());
   e:	00001917          	auipc	s2,0x1
  12:	47293903          	ld	s2,1138(s2) # 1480 <testname>
  16:	00000097          	auipc	ra,0x0
  1a:	50a080e7          	jalr	1290(ra) # 520 <getpid>
  1e:	86aa                	mv	a3,a0
  20:	8626                	mv	a2,s1
  22:	85ca                	mv	a1,s2
  24:	00001517          	auipc	a0,0x1
  28:	9ac50513          	add	a0,a0,-1620 # 9d0 <malloc+0x100>
  2c:	00000097          	auipc	ra,0x0
  30:	7ec080e7          	jalr	2028(ra) # 818 <printf>
  exit(1);
  34:	4505                	li	a0,1
  36:	00000097          	auipc	ra,0x0
  3a:	46a080e7          	jalr	1130(ra) # 4a0 <exit>

000000000000003e <ugetpid_test>:
}

void
ugetpid_test()
{
  3e:	7179                	add	sp,sp,-48
  40:	f406                	sd	ra,40(sp)
  42:	f022                	sd	s0,32(sp)
  44:	ec26                	sd	s1,24(sp)
  46:	1800                	add	s0,sp,48
  int i;

  printf("ugetpid_test starting\n");
  48:	00001517          	auipc	a0,0x1
  4c:	9b050513          	add	a0,a0,-1616 # 9f8 <malloc+0x128>
  50:	00000097          	auipc	ra,0x0
  54:	7c8080e7          	jalr	1992(ra) # 818 <printf>
  testname = "ugetpid_test";
  58:	00001797          	auipc	a5,0x1
  5c:	9b878793          	add	a5,a5,-1608 # a10 <malloc+0x140>
  60:	00001717          	auipc	a4,0x1
  64:	42f73023          	sd	a5,1056(a4) # 1480 <testname>
  68:	04000493          	li	s1,64

  for (i = 0; i < 64; i++) {
    int ret = fork();
  6c:	00000097          	auipc	ra,0x0
  70:	42c080e7          	jalr	1068(ra) # 498 <fork>
  74:	fca42e23          	sw	a0,-36(s0)
    if (ret != 0) {
  78:	cd15                	beqz	a0,b4 <ugetpid_test+0x76>
      wait(&ret);
  7a:	fdc40513          	add	a0,s0,-36
  7e:	00000097          	auipc	ra,0x0
  82:	42a080e7          	jalr	1066(ra) # 4a8 <wait>
      if (ret != 0)
  86:	fdc42783          	lw	a5,-36(s0)
  8a:	e385                	bnez	a5,aa <ugetpid_test+0x6c>
  for (i = 0; i < 64; i++) {
  8c:	34fd                	addw	s1,s1,-1
  8e:	fcf9                	bnez	s1,6c <ugetpid_test+0x2e>
    }
    if (getpid() != ugetpid())
      err("missmatched PID");
    exit(0);
  }
  printf("ugetpid_test: OK\n");
  90:	00001517          	auipc	a0,0x1
  94:	9a050513          	add	a0,a0,-1632 # a30 <malloc+0x160>
  98:	00000097          	auipc	ra,0x0
  9c:	780080e7          	jalr	1920(ra) # 818 <printf>
}
  a0:	70a2                	ld	ra,40(sp)
  a2:	7402                	ld	s0,32(sp)
  a4:	64e2                	ld	s1,24(sp)
  a6:	6145                	add	sp,sp,48
  a8:	8082                	ret
        exit(1);
  aa:	4505                	li	a0,1
  ac:	00000097          	auipc	ra,0x0
  b0:	3f4080e7          	jalr	1012(ra) # 4a0 <exit>
    if (getpid() != ugetpid())
  b4:	00000097          	auipc	ra,0x0
  b8:	46c080e7          	jalr	1132(ra) # 520 <getpid>
  bc:	84aa                	mv	s1,a0
  be:	00000097          	auipc	ra,0x0
  c2:	3c4080e7          	jalr	964(ra) # 482 <ugetpid>
  c6:	00a48a63          	beq	s1,a0,da <ugetpid_test+0x9c>
      err("missmatched PID");
  ca:	00001517          	auipc	a0,0x1
  ce:	95650513          	add	a0,a0,-1706 # a20 <malloc+0x150>
  d2:	00000097          	auipc	ra,0x0
  d6:	f2e080e7          	jalr	-210(ra) # 0 <err>
    exit(0);
  da:	4501                	li	a0,0
  dc:	00000097          	auipc	ra,0x0
  e0:	3c4080e7          	jalr	964(ra) # 4a0 <exit>

00000000000000e4 <pgaccess_test>:

void
pgaccess_test()
{
  e4:	7179                	add	sp,sp,-48
  e6:	f406                	sd	ra,40(sp)
  e8:	f022                	sd	s0,32(sp)
  ea:	ec26                	sd	s1,24(sp)
  ec:	1800                	add	s0,sp,48
  char *buf;
  unsigned int abits;
  printf("pgaccess_test starting\n");
  ee:	00001517          	auipc	a0,0x1
  f2:	95a50513          	add	a0,a0,-1702 # a48 <malloc+0x178>
  f6:	00000097          	auipc	ra,0x0
  fa:	722080e7          	jalr	1826(ra) # 818 <printf>
  testname = "pgaccess_test";
  fe:	00001797          	auipc	a5,0x1
 102:	96278793          	add	a5,a5,-1694 # a60 <malloc+0x190>
 106:	00001717          	auipc	a4,0x1
 10a:	36f73d23          	sd	a5,890(a4) # 1480 <testname>
  buf = malloc(32 * PGSIZE);
 10e:	00020537          	lui	a0,0x20
 112:	00000097          	auipc	ra,0x0
 116:	7be080e7          	jalr	1982(ra) # 8d0 <malloc>
 11a:	84aa                	mv	s1,a0
  if (pgaccess(buf, 32, &abits) < 0)
 11c:	fdc40613          	add	a2,s0,-36
 120:	02000593          	li	a1,32
 124:	00000097          	auipc	ra,0x0
 128:	424080e7          	jalr	1060(ra) # 548 <pgaccess>
 12c:	06054b63          	bltz	a0,1a2 <pgaccess_test+0xbe>
    err("pgaccess failed");
  buf[PGSIZE * 1] += 1;
 130:	6785                	lui	a5,0x1
 132:	97a6                	add	a5,a5,s1
 134:	0007c703          	lbu	a4,0(a5) # 1000 <digits+0x4c0>
 138:	2705                	addw	a4,a4,1
 13a:	00e78023          	sb	a4,0(a5)
  buf[PGSIZE * 2] += 1;
 13e:	6789                	lui	a5,0x2
 140:	97a6                	add	a5,a5,s1
 142:	0007c703          	lbu	a4,0(a5) # 2000 <base+0xb60>
 146:	2705                	addw	a4,a4,1
 148:	00e78023          	sb	a4,0(a5)
  buf[PGSIZE * 30] += 1;
 14c:	67f9                	lui	a5,0x1e
 14e:	97a6                	add	a5,a5,s1
 150:	0007c703          	lbu	a4,0(a5) # 1e000 <base+0x1cb60>
 154:	2705                	addw	a4,a4,1
 156:	00e78023          	sb	a4,0(a5)
  if (pgaccess(buf, 32, &abits) < 0)
 15a:	fdc40613          	add	a2,s0,-36
 15e:	02000593          	li	a1,32
 162:	8526                	mv	a0,s1
 164:	00000097          	auipc	ra,0x0
 168:	3e4080e7          	jalr	996(ra) # 548 <pgaccess>
 16c:	04054363          	bltz	a0,1b2 <pgaccess_test+0xce>
    err("pgaccess failed");
  if (abits != ((1 << 1) | (1 << 2) | (1 << 30)))
 170:	fdc42703          	lw	a4,-36(s0)
 174:	400007b7          	lui	a5,0x40000
 178:	0799                	add	a5,a5,6 # 40000006 <base+0x3fffeb66>
 17a:	04f71463          	bne	a4,a5,1c2 <pgaccess_test+0xde>
    err("incorrect access bits set");
  free(buf);
 17e:	8526                	mv	a0,s1
 180:	00000097          	auipc	ra,0x0
 184:	6ce080e7          	jalr	1742(ra) # 84e <free>
  printf("pgaccess_test: OK\n");
 188:	00001517          	auipc	a0,0x1
 18c:	91850513          	add	a0,a0,-1768 # aa0 <malloc+0x1d0>
 190:	00000097          	auipc	ra,0x0
 194:	688080e7          	jalr	1672(ra) # 818 <printf>
}
 198:	70a2                	ld	ra,40(sp)
 19a:	7402                	ld	s0,32(sp)
 19c:	64e2                	ld	s1,24(sp)
 19e:	6145                	add	sp,sp,48
 1a0:	8082                	ret
    err("pgaccess failed");
 1a2:	00001517          	auipc	a0,0x1
 1a6:	8ce50513          	add	a0,a0,-1842 # a70 <malloc+0x1a0>
 1aa:	00000097          	auipc	ra,0x0
 1ae:	e56080e7          	jalr	-426(ra) # 0 <err>
    err("pgaccess failed");
 1b2:	00001517          	auipc	a0,0x1
 1b6:	8be50513          	add	a0,a0,-1858 # a70 <malloc+0x1a0>
 1ba:	00000097          	auipc	ra,0x0
 1be:	e46080e7          	jalr	-442(ra) # 0 <err>
    err("incorrect access bits set");
 1c2:	00001517          	auipc	a0,0x1
 1c6:	8be50513          	add	a0,a0,-1858 # a80 <malloc+0x1b0>
 1ca:	00000097          	auipc	ra,0x0
 1ce:	e36080e7          	jalr	-458(ra) # 0 <err>

00000000000001d2 <main>:
{
 1d2:	1141                	add	sp,sp,-16
 1d4:	e406                	sd	ra,8(sp)
 1d6:	e022                	sd	s0,0(sp)
 1d8:	0800                	add	s0,sp,16
  ugetpid_test();
 1da:	00000097          	auipc	ra,0x0
 1de:	e64080e7          	jalr	-412(ra) # 3e <ugetpid_test>
  pgaccess_test();
 1e2:	00000097          	auipc	ra,0x0
 1e6:	f02080e7          	jalr	-254(ra) # e4 <pgaccess_test>
  printf("pgtbltest: all tests succeeded\n");
 1ea:	00001517          	auipc	a0,0x1
 1ee:	8ce50513          	add	a0,a0,-1842 # ab8 <malloc+0x1e8>
 1f2:	00000097          	auipc	ra,0x0
 1f6:	626080e7          	jalr	1574(ra) # 818 <printf>
  exit(0);
 1fa:	4501                	li	a0,0
 1fc:	00000097          	auipc	ra,0x0
 200:	2a4080e7          	jalr	676(ra) # 4a0 <exit>

0000000000000204 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 204:	1141                	add	sp,sp,-16
 206:	e406                	sd	ra,8(sp)
 208:	e022                	sd	s0,0(sp)
 20a:	0800                	add	s0,sp,16
  extern int main();
  main();
 20c:	00000097          	auipc	ra,0x0
 210:	fc6080e7          	jalr	-58(ra) # 1d2 <main>
  exit(0);
 214:	4501                	li	a0,0
 216:	00000097          	auipc	ra,0x0
 21a:	28a080e7          	jalr	650(ra) # 4a0 <exit>

000000000000021e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 21e:	1141                	add	sp,sp,-16
 220:	e422                	sd	s0,8(sp)
 222:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 224:	87aa                	mv	a5,a0
 226:	0585                	add	a1,a1,1
 228:	0785                	add	a5,a5,1
 22a:	fff5c703          	lbu	a4,-1(a1)
 22e:	fee78fa3          	sb	a4,-1(a5)
 232:	fb75                	bnez	a4,226 <strcpy+0x8>
    ;
  return os;
}
 234:	6422                	ld	s0,8(sp)
 236:	0141                	add	sp,sp,16
 238:	8082                	ret

000000000000023a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 23a:	1141                	add	sp,sp,-16
 23c:	e422                	sd	s0,8(sp)
 23e:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 240:	00054783          	lbu	a5,0(a0)
 244:	cb91                	beqz	a5,258 <strcmp+0x1e>
 246:	0005c703          	lbu	a4,0(a1)
 24a:	00f71763          	bne	a4,a5,258 <strcmp+0x1e>
    p++, q++;
 24e:	0505                	add	a0,a0,1
 250:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 252:	00054783          	lbu	a5,0(a0)
 256:	fbe5                	bnez	a5,246 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 258:	0005c503          	lbu	a0,0(a1)
}
 25c:	40a7853b          	subw	a0,a5,a0
 260:	6422                	ld	s0,8(sp)
 262:	0141                	add	sp,sp,16
 264:	8082                	ret

0000000000000266 <strlen>:

uint
strlen(const char *s)
{
 266:	1141                	add	sp,sp,-16
 268:	e422                	sd	s0,8(sp)
 26a:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 26c:	00054783          	lbu	a5,0(a0)
 270:	cf91                	beqz	a5,28c <strlen+0x26>
 272:	0505                	add	a0,a0,1
 274:	87aa                	mv	a5,a0
 276:	86be                	mv	a3,a5
 278:	0785                	add	a5,a5,1
 27a:	fff7c703          	lbu	a4,-1(a5)
 27e:	ff65                	bnez	a4,276 <strlen+0x10>
 280:	40a6853b          	subw	a0,a3,a0
 284:	2505                	addw	a0,a0,1
    ;
  return n;
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	add	sp,sp,16
 28a:	8082                	ret
  for(n = 0; s[n]; n++)
 28c:	4501                	li	a0,0
 28e:	bfe5                	j	286 <strlen+0x20>

0000000000000290 <memset>:

void*
memset(void *dst, int c, uint n)
{
 290:	1141                	add	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 296:	ca19                	beqz	a2,2ac <memset+0x1c>
 298:	87aa                	mv	a5,a0
 29a:	1602                	sll	a2,a2,0x20
 29c:	9201                	srl	a2,a2,0x20
 29e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2a6:	0785                	add	a5,a5,1
 2a8:	fee79de3          	bne	a5,a4,2a2 <memset+0x12>
  }
  return dst;
}
 2ac:	6422                	ld	s0,8(sp)
 2ae:	0141                	add	sp,sp,16
 2b0:	8082                	ret

00000000000002b2 <strchr>:

char*
strchr(const char *s, char c)
{
 2b2:	1141                	add	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	add	s0,sp,16
  for(; *s; s++)
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	cb99                	beqz	a5,2d2 <strchr+0x20>
    if(*s == c)
 2be:	00f58763          	beq	a1,a5,2cc <strchr+0x1a>
  for(; *s; s++)
 2c2:	0505                	add	a0,a0,1
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	fbfd                	bnez	a5,2be <strchr+0xc>
      return (char*)s;
  return 0;
 2ca:	4501                	li	a0,0
}
 2cc:	6422                	ld	s0,8(sp)
 2ce:	0141                	add	sp,sp,16
 2d0:	8082                	ret
  return 0;
 2d2:	4501                	li	a0,0
 2d4:	bfe5                	j	2cc <strchr+0x1a>

00000000000002d6 <gets>:

char*
gets(char *buf, int max)
{
 2d6:	711d                	add	sp,sp,-96
 2d8:	ec86                	sd	ra,88(sp)
 2da:	e8a2                	sd	s0,80(sp)
 2dc:	e4a6                	sd	s1,72(sp)
 2de:	e0ca                	sd	s2,64(sp)
 2e0:	fc4e                	sd	s3,56(sp)
 2e2:	f852                	sd	s4,48(sp)
 2e4:	f456                	sd	s5,40(sp)
 2e6:	f05a                	sd	s6,32(sp)
 2e8:	ec5e                	sd	s7,24(sp)
 2ea:	1080                	add	s0,sp,96
 2ec:	8baa                	mv	s7,a0
 2ee:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f0:	892a                	mv	s2,a0
 2f2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2f4:	4aa9                	li	s5,10
 2f6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2f8:	89a6                	mv	s3,s1
 2fa:	2485                	addw	s1,s1,1
 2fc:	0344d863          	bge	s1,s4,32c <gets+0x56>
    cc = read(0, &c, 1);
 300:	4605                	li	a2,1
 302:	faf40593          	add	a1,s0,-81
 306:	4501                	li	a0,0
 308:	00000097          	auipc	ra,0x0
 30c:	1b0080e7          	jalr	432(ra) # 4b8 <read>
    if(cc < 1)
 310:	00a05e63          	blez	a0,32c <gets+0x56>
    buf[i++] = c;
 314:	faf44783          	lbu	a5,-81(s0)
 318:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 31c:	01578763          	beq	a5,s5,32a <gets+0x54>
 320:	0905                	add	s2,s2,1
 322:	fd679be3          	bne	a5,s6,2f8 <gets+0x22>
    buf[i++] = c;
 326:	89a6                	mv	s3,s1
 328:	a011                	j	32c <gets+0x56>
 32a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 32c:	99de                	add	s3,s3,s7
 32e:	00098023          	sb	zero,0(s3)
  return buf;
}
 332:	855e                	mv	a0,s7
 334:	60e6                	ld	ra,88(sp)
 336:	6446                	ld	s0,80(sp)
 338:	64a6                	ld	s1,72(sp)
 33a:	6906                	ld	s2,64(sp)
 33c:	79e2                	ld	s3,56(sp)
 33e:	7a42                	ld	s4,48(sp)
 340:	7aa2                	ld	s5,40(sp)
 342:	7b02                	ld	s6,32(sp)
 344:	6be2                	ld	s7,24(sp)
 346:	6125                	add	sp,sp,96
 348:	8082                	ret

000000000000034a <stat>:

int
stat(const char *n, struct stat *st)
{
 34a:	1101                	add	sp,sp,-32
 34c:	ec06                	sd	ra,24(sp)
 34e:	e822                	sd	s0,16(sp)
 350:	e04a                	sd	s2,0(sp)
 352:	1000                	add	s0,sp,32
 354:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 356:	4581                	li	a1,0
 358:	00000097          	auipc	ra,0x0
 35c:	188080e7          	jalr	392(ra) # 4e0 <open>
  if(fd < 0)
 360:	02054663          	bltz	a0,38c <stat+0x42>
 364:	e426                	sd	s1,8(sp)
 366:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 368:	85ca                	mv	a1,s2
 36a:	00000097          	auipc	ra,0x0
 36e:	18e080e7          	jalr	398(ra) # 4f8 <fstat>
 372:	892a                	mv	s2,a0
  close(fd);
 374:	8526                	mv	a0,s1
 376:	00000097          	auipc	ra,0x0
 37a:	152080e7          	jalr	338(ra) # 4c8 <close>
  return r;
 37e:	64a2                	ld	s1,8(sp)
}
 380:	854a                	mv	a0,s2
 382:	60e2                	ld	ra,24(sp)
 384:	6442                	ld	s0,16(sp)
 386:	6902                	ld	s2,0(sp)
 388:	6105                	add	sp,sp,32
 38a:	8082                	ret
    return -1;
 38c:	597d                	li	s2,-1
 38e:	bfcd                	j	380 <stat+0x36>

0000000000000390 <atoi>:

int
atoi(const char *s)
{
 390:	1141                	add	sp,sp,-16
 392:	e422                	sd	s0,8(sp)
 394:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 396:	00054683          	lbu	a3,0(a0)
 39a:	fd06879b          	addw	a5,a3,-48
 39e:	0ff7f793          	zext.b	a5,a5
 3a2:	4625                	li	a2,9
 3a4:	02f66863          	bltu	a2,a5,3d4 <atoi+0x44>
 3a8:	872a                	mv	a4,a0
  n = 0;
 3aa:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3ac:	0705                	add	a4,a4,1
 3ae:	0025179b          	sllw	a5,a0,0x2
 3b2:	9fa9                	addw	a5,a5,a0
 3b4:	0017979b          	sllw	a5,a5,0x1
 3b8:	9fb5                	addw	a5,a5,a3
 3ba:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3be:	00074683          	lbu	a3,0(a4)
 3c2:	fd06879b          	addw	a5,a3,-48
 3c6:	0ff7f793          	zext.b	a5,a5
 3ca:	fef671e3          	bgeu	a2,a5,3ac <atoi+0x1c>
  return n;
}
 3ce:	6422                	ld	s0,8(sp)
 3d0:	0141                	add	sp,sp,16
 3d2:	8082                	ret
  n = 0;
 3d4:	4501                	li	a0,0
 3d6:	bfe5                	j	3ce <atoi+0x3e>

00000000000003d8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d8:	1141                	add	sp,sp,-16
 3da:	e422                	sd	s0,8(sp)
 3dc:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3de:	02b57463          	bgeu	a0,a1,406 <memmove+0x2e>
    while(n-- > 0)
 3e2:	00c05f63          	blez	a2,400 <memmove+0x28>
 3e6:	1602                	sll	a2,a2,0x20
 3e8:	9201                	srl	a2,a2,0x20
 3ea:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3ee:	872a                	mv	a4,a0
      *dst++ = *src++;
 3f0:	0585                	add	a1,a1,1
 3f2:	0705                	add	a4,a4,1
 3f4:	fff5c683          	lbu	a3,-1(a1)
 3f8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3fc:	fef71ae3          	bne	a4,a5,3f0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 400:	6422                	ld	s0,8(sp)
 402:	0141                	add	sp,sp,16
 404:	8082                	ret
    dst += n;
 406:	00c50733          	add	a4,a0,a2
    src += n;
 40a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 40c:	fec05ae3          	blez	a2,400 <memmove+0x28>
 410:	fff6079b          	addw	a5,a2,-1
 414:	1782                	sll	a5,a5,0x20
 416:	9381                	srl	a5,a5,0x20
 418:	fff7c793          	not	a5,a5
 41c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 41e:	15fd                	add	a1,a1,-1
 420:	177d                	add	a4,a4,-1
 422:	0005c683          	lbu	a3,0(a1)
 426:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 42a:	fee79ae3          	bne	a5,a4,41e <memmove+0x46>
 42e:	bfc9                	j	400 <memmove+0x28>

0000000000000430 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 430:	1141                	add	sp,sp,-16
 432:	e422                	sd	s0,8(sp)
 434:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 436:	ca05                	beqz	a2,466 <memcmp+0x36>
 438:	fff6069b          	addw	a3,a2,-1
 43c:	1682                	sll	a3,a3,0x20
 43e:	9281                	srl	a3,a3,0x20
 440:	0685                	add	a3,a3,1
 442:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 444:	00054783          	lbu	a5,0(a0)
 448:	0005c703          	lbu	a4,0(a1)
 44c:	00e79863          	bne	a5,a4,45c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 450:	0505                	add	a0,a0,1
    p2++;
 452:	0585                	add	a1,a1,1
  while (n-- > 0) {
 454:	fed518e3          	bne	a0,a3,444 <memcmp+0x14>
  }
  return 0;
 458:	4501                	li	a0,0
 45a:	a019                	j	460 <memcmp+0x30>
      return *p1 - *p2;
 45c:	40e7853b          	subw	a0,a5,a4
}
 460:	6422                	ld	s0,8(sp)
 462:	0141                	add	sp,sp,16
 464:	8082                	ret
  return 0;
 466:	4501                	li	a0,0
 468:	bfe5                	j	460 <memcmp+0x30>

000000000000046a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 46a:	1141                	add	sp,sp,-16
 46c:	e406                	sd	ra,8(sp)
 46e:	e022                	sd	s0,0(sp)
 470:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 472:	00000097          	auipc	ra,0x0
 476:	f66080e7          	jalr	-154(ra) # 3d8 <memmove>
}
 47a:	60a2                	ld	ra,8(sp)
 47c:	6402                	ld	s0,0(sp)
 47e:	0141                	add	sp,sp,16
 480:	8082                	ret

0000000000000482 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 482:	1141                	add	sp,sp,-16
 484:	e422                	sd	s0,8(sp)
 486:	0800                	add	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 488:	040007b7          	lui	a5,0x4000
 48c:	17f5                	add	a5,a5,-3 # 3fffffd <base+0x3ffeb5d>
 48e:	07b2                	sll	a5,a5,0xc
}
 490:	4388                	lw	a0,0(a5)
 492:	6422                	ld	s0,8(sp)
 494:	0141                	add	sp,sp,16
 496:	8082                	ret

0000000000000498 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 498:	4885                	li	a7,1
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4a0:	4889                	li	a7,2
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4a8:	488d                	li	a7,3
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4b0:	4891                	li	a7,4
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <read>:
.global read
read:
 li a7, SYS_read
 4b8:	4895                	li	a7,5
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <write>:
.global write
write:
 li a7, SYS_write
 4c0:	48c1                	li	a7,16
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <close>:
.global close
close:
 li a7, SYS_close
 4c8:	48d5                	li	a7,21
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4d0:	4899                	li	a7,6
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4d8:	489d                	li	a7,7
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <open>:
.global open
open:
 li a7, SYS_open
 4e0:	48bd                	li	a7,15
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4e8:	48c5                	li	a7,17
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4f0:	48c9                	li	a7,18
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4f8:	48a1                	li	a7,8
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <link>:
.global link
link:
 li a7, SYS_link
 500:	48cd                	li	a7,19
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 508:	48d1                	li	a7,20
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 510:	48a5                	li	a7,9
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <dup>:
.global dup
dup:
 li a7, SYS_dup
 518:	48a9                	li	a7,10
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 520:	48ad                	li	a7,11
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 528:	48b1                	li	a7,12
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 530:	48b5                	li	a7,13
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 538:	48b9                	li	a7,14
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <connect>:
.global connect
connect:
 li a7, SYS_connect
 540:	48f5                	li	a7,29
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 548:	48f9                	li	a7,30
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 550:	1101                	add	sp,sp,-32
 552:	ec06                	sd	ra,24(sp)
 554:	e822                	sd	s0,16(sp)
 556:	1000                	add	s0,sp,32
 558:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 55c:	4605                	li	a2,1
 55e:	fef40593          	add	a1,s0,-17
 562:	00000097          	auipc	ra,0x0
 566:	f5e080e7          	jalr	-162(ra) # 4c0 <write>
}
 56a:	60e2                	ld	ra,24(sp)
 56c:	6442                	ld	s0,16(sp)
 56e:	6105                	add	sp,sp,32
 570:	8082                	ret

0000000000000572 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 572:	7139                	add	sp,sp,-64
 574:	fc06                	sd	ra,56(sp)
 576:	f822                	sd	s0,48(sp)
 578:	f426                	sd	s1,40(sp)
 57a:	0080                	add	s0,sp,64
 57c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 57e:	c299                	beqz	a3,584 <printint+0x12>
 580:	0805cb63          	bltz	a1,616 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 584:	2581                	sext.w	a1,a1
  neg = 0;
 586:	4881                	li	a7,0
 588:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 58c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 58e:	2601                	sext.w	a2,a2
 590:	00000517          	auipc	a0,0x0
 594:	5b050513          	add	a0,a0,1456 # b40 <digits>
 598:	883a                	mv	a6,a4
 59a:	2705                	addw	a4,a4,1
 59c:	02c5f7bb          	remuw	a5,a1,a2
 5a0:	1782                	sll	a5,a5,0x20
 5a2:	9381                	srl	a5,a5,0x20
 5a4:	97aa                	add	a5,a5,a0
 5a6:	0007c783          	lbu	a5,0(a5)
 5aa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5ae:	0005879b          	sext.w	a5,a1
 5b2:	02c5d5bb          	divuw	a1,a1,a2
 5b6:	0685                	add	a3,a3,1
 5b8:	fec7f0e3          	bgeu	a5,a2,598 <printint+0x26>
  if(neg)
 5bc:	00088c63          	beqz	a7,5d4 <printint+0x62>
    buf[i++] = '-';
 5c0:	fd070793          	add	a5,a4,-48
 5c4:	00878733          	add	a4,a5,s0
 5c8:	02d00793          	li	a5,45
 5cc:	fef70823          	sb	a5,-16(a4)
 5d0:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 5d4:	02e05c63          	blez	a4,60c <printint+0x9a>
 5d8:	f04a                	sd	s2,32(sp)
 5da:	ec4e                	sd	s3,24(sp)
 5dc:	fc040793          	add	a5,s0,-64
 5e0:	00e78933          	add	s2,a5,a4
 5e4:	fff78993          	add	s3,a5,-1
 5e8:	99ba                	add	s3,s3,a4
 5ea:	377d                	addw	a4,a4,-1
 5ec:	1702                	sll	a4,a4,0x20
 5ee:	9301                	srl	a4,a4,0x20
 5f0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5f4:	fff94583          	lbu	a1,-1(s2)
 5f8:	8526                	mv	a0,s1
 5fa:	00000097          	auipc	ra,0x0
 5fe:	f56080e7          	jalr	-170(ra) # 550 <putc>
  while(--i >= 0)
 602:	197d                	add	s2,s2,-1
 604:	ff3918e3          	bne	s2,s3,5f4 <printint+0x82>
 608:	7902                	ld	s2,32(sp)
 60a:	69e2                	ld	s3,24(sp)
}
 60c:	70e2                	ld	ra,56(sp)
 60e:	7442                	ld	s0,48(sp)
 610:	74a2                	ld	s1,40(sp)
 612:	6121                	add	sp,sp,64
 614:	8082                	ret
    x = -xx;
 616:	40b005bb          	negw	a1,a1
    neg = 1;
 61a:	4885                	li	a7,1
    x = -xx;
 61c:	b7b5                	j	588 <printint+0x16>

000000000000061e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 61e:	715d                	add	sp,sp,-80
 620:	e486                	sd	ra,72(sp)
 622:	e0a2                	sd	s0,64(sp)
 624:	f84a                	sd	s2,48(sp)
 626:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 628:	0005c903          	lbu	s2,0(a1)
 62c:	1a090a63          	beqz	s2,7e0 <vprintf+0x1c2>
 630:	fc26                	sd	s1,56(sp)
 632:	f44e                	sd	s3,40(sp)
 634:	f052                	sd	s4,32(sp)
 636:	ec56                	sd	s5,24(sp)
 638:	e85a                	sd	s6,16(sp)
 63a:	e45e                	sd	s7,8(sp)
 63c:	8aaa                	mv	s5,a0
 63e:	8bb2                	mv	s7,a2
 640:	00158493          	add	s1,a1,1
  state = 0;
 644:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 646:	02500a13          	li	s4,37
 64a:	4b55                	li	s6,21
 64c:	a839                	j	66a <vprintf+0x4c>
        putc(fd, c);
 64e:	85ca                	mv	a1,s2
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	efe080e7          	jalr	-258(ra) # 550 <putc>
 65a:	a019                	j	660 <vprintf+0x42>
    } else if(state == '%'){
 65c:	01498d63          	beq	s3,s4,676 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 660:	0485                	add	s1,s1,1
 662:	fff4c903          	lbu	s2,-1(s1)
 666:	16090763          	beqz	s2,7d4 <vprintf+0x1b6>
    if(state == 0){
 66a:	fe0999e3          	bnez	s3,65c <vprintf+0x3e>
      if(c == '%'){
 66e:	ff4910e3          	bne	s2,s4,64e <vprintf+0x30>
        state = '%';
 672:	89d2                	mv	s3,s4
 674:	b7f5                	j	660 <vprintf+0x42>
      if(c == 'd'){
 676:	13490463          	beq	s2,s4,79e <vprintf+0x180>
 67a:	f9d9079b          	addw	a5,s2,-99
 67e:	0ff7f793          	zext.b	a5,a5
 682:	12fb6763          	bltu	s6,a5,7b0 <vprintf+0x192>
 686:	f9d9079b          	addw	a5,s2,-99
 68a:	0ff7f713          	zext.b	a4,a5
 68e:	12eb6163          	bltu	s6,a4,7b0 <vprintf+0x192>
 692:	00271793          	sll	a5,a4,0x2
 696:	00000717          	auipc	a4,0x0
 69a:	45270713          	add	a4,a4,1106 # ae8 <malloc+0x218>
 69e:	97ba                	add	a5,a5,a4
 6a0:	439c                	lw	a5,0(a5)
 6a2:	97ba                	add	a5,a5,a4
 6a4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6a6:	008b8913          	add	s2,s7,8
 6aa:	4685                	li	a3,1
 6ac:	4629                	li	a2,10
 6ae:	000ba583          	lw	a1,0(s7)
 6b2:	8556                	mv	a0,s5
 6b4:	00000097          	auipc	ra,0x0
 6b8:	ebe080e7          	jalr	-322(ra) # 572 <printint>
 6bc:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	b745                	j	660 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c2:	008b8913          	add	s2,s7,8
 6c6:	4681                	li	a3,0
 6c8:	4629                	li	a2,10
 6ca:	000ba583          	lw	a1,0(s7)
 6ce:	8556                	mv	a0,s5
 6d0:	00000097          	auipc	ra,0x0
 6d4:	ea2080e7          	jalr	-350(ra) # 572 <printint>
 6d8:	8bca                	mv	s7,s2
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	b751                	j	660 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 6de:	008b8913          	add	s2,s7,8
 6e2:	4681                	li	a3,0
 6e4:	4641                	li	a2,16
 6e6:	000ba583          	lw	a1,0(s7)
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	e86080e7          	jalr	-378(ra) # 572 <printint>
 6f4:	8bca                	mv	s7,s2
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	b7a5                	j	660 <vprintf+0x42>
 6fa:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6fc:	008b8c13          	add	s8,s7,8
 700:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 704:	03000593          	li	a1,48
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	e46080e7          	jalr	-442(ra) # 550 <putc>
  putc(fd, 'x');
 712:	07800593          	li	a1,120
 716:	8556                	mv	a0,s5
 718:	00000097          	auipc	ra,0x0
 71c:	e38080e7          	jalr	-456(ra) # 550 <putc>
 720:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 722:	00000b97          	auipc	s7,0x0
 726:	41eb8b93          	add	s7,s7,1054 # b40 <digits>
 72a:	03c9d793          	srl	a5,s3,0x3c
 72e:	97de                	add	a5,a5,s7
 730:	0007c583          	lbu	a1,0(a5)
 734:	8556                	mv	a0,s5
 736:	00000097          	auipc	ra,0x0
 73a:	e1a080e7          	jalr	-486(ra) # 550 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 73e:	0992                	sll	s3,s3,0x4
 740:	397d                	addw	s2,s2,-1
 742:	fe0914e3          	bnez	s2,72a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 746:	8be2                	mv	s7,s8
      state = 0;
 748:	4981                	li	s3,0
 74a:	6c02                	ld	s8,0(sp)
 74c:	bf11                	j	660 <vprintf+0x42>
        s = va_arg(ap, char*);
 74e:	008b8993          	add	s3,s7,8
 752:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 756:	02090163          	beqz	s2,778 <vprintf+0x15a>
        while(*s != 0){
 75a:	00094583          	lbu	a1,0(s2)
 75e:	c9a5                	beqz	a1,7ce <vprintf+0x1b0>
          putc(fd, *s);
 760:	8556                	mv	a0,s5
 762:	00000097          	auipc	ra,0x0
 766:	dee080e7          	jalr	-530(ra) # 550 <putc>
          s++;
 76a:	0905                	add	s2,s2,1
        while(*s != 0){
 76c:	00094583          	lbu	a1,0(s2)
 770:	f9e5                	bnez	a1,760 <vprintf+0x142>
        s = va_arg(ap, char*);
 772:	8bce                	mv	s7,s3
      state = 0;
 774:	4981                	li	s3,0
 776:	b5ed                	j	660 <vprintf+0x42>
          s = "(null)";
 778:	00000917          	auipc	s2,0x0
 77c:	36890913          	add	s2,s2,872 # ae0 <malloc+0x210>
        while(*s != 0){
 780:	02800593          	li	a1,40
 784:	bff1                	j	760 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 786:	008b8913          	add	s2,s7,8
 78a:	000bc583          	lbu	a1,0(s7)
 78e:	8556                	mv	a0,s5
 790:	00000097          	auipc	ra,0x0
 794:	dc0080e7          	jalr	-576(ra) # 550 <putc>
 798:	8bca                	mv	s7,s2
      state = 0;
 79a:	4981                	li	s3,0
 79c:	b5d1                	j	660 <vprintf+0x42>
        putc(fd, c);
 79e:	02500593          	li	a1,37
 7a2:	8556                	mv	a0,s5
 7a4:	00000097          	auipc	ra,0x0
 7a8:	dac080e7          	jalr	-596(ra) # 550 <putc>
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	bd4d                	j	660 <vprintf+0x42>
        putc(fd, '%');
 7b0:	02500593          	li	a1,37
 7b4:	8556                	mv	a0,s5
 7b6:	00000097          	auipc	ra,0x0
 7ba:	d9a080e7          	jalr	-614(ra) # 550 <putc>
        putc(fd, c);
 7be:	85ca                	mv	a1,s2
 7c0:	8556                	mv	a0,s5
 7c2:	00000097          	auipc	ra,0x0
 7c6:	d8e080e7          	jalr	-626(ra) # 550 <putc>
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	bd51                	j	660 <vprintf+0x42>
        s = va_arg(ap, char*);
 7ce:	8bce                	mv	s7,s3
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	b579                	j	660 <vprintf+0x42>
 7d4:	74e2                	ld	s1,56(sp)
 7d6:	79a2                	ld	s3,40(sp)
 7d8:	7a02                	ld	s4,32(sp)
 7da:	6ae2                	ld	s5,24(sp)
 7dc:	6b42                	ld	s6,16(sp)
 7de:	6ba2                	ld	s7,8(sp)
    }
  }
}
 7e0:	60a6                	ld	ra,72(sp)
 7e2:	6406                	ld	s0,64(sp)
 7e4:	7942                	ld	s2,48(sp)
 7e6:	6161                	add	sp,sp,80
 7e8:	8082                	ret

00000000000007ea <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ea:	715d                	add	sp,sp,-80
 7ec:	ec06                	sd	ra,24(sp)
 7ee:	e822                	sd	s0,16(sp)
 7f0:	1000                	add	s0,sp,32
 7f2:	e010                	sd	a2,0(s0)
 7f4:	e414                	sd	a3,8(s0)
 7f6:	e818                	sd	a4,16(s0)
 7f8:	ec1c                	sd	a5,24(s0)
 7fa:	03043023          	sd	a6,32(s0)
 7fe:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 802:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 806:	8622                	mv	a2,s0
 808:	00000097          	auipc	ra,0x0
 80c:	e16080e7          	jalr	-490(ra) # 61e <vprintf>
}
 810:	60e2                	ld	ra,24(sp)
 812:	6442                	ld	s0,16(sp)
 814:	6161                	add	sp,sp,80
 816:	8082                	ret

0000000000000818 <printf>:

void
printf(const char *fmt, ...)
{
 818:	711d                	add	sp,sp,-96
 81a:	ec06                	sd	ra,24(sp)
 81c:	e822                	sd	s0,16(sp)
 81e:	1000                	add	s0,sp,32
 820:	e40c                	sd	a1,8(s0)
 822:	e810                	sd	a2,16(s0)
 824:	ec14                	sd	a3,24(s0)
 826:	f018                	sd	a4,32(s0)
 828:	f41c                	sd	a5,40(s0)
 82a:	03043823          	sd	a6,48(s0)
 82e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 832:	00840613          	add	a2,s0,8
 836:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 83a:	85aa                	mv	a1,a0
 83c:	4505                	li	a0,1
 83e:	00000097          	auipc	ra,0x0
 842:	de0080e7          	jalr	-544(ra) # 61e <vprintf>
}
 846:	60e2                	ld	ra,24(sp)
 848:	6442                	ld	s0,16(sp)
 84a:	6125                	add	sp,sp,96
 84c:	8082                	ret

000000000000084e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 84e:	1141                	add	sp,sp,-16
 850:	e422                	sd	s0,8(sp)
 852:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 854:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 858:	00001797          	auipc	a5,0x1
 85c:	c387b783          	ld	a5,-968(a5) # 1490 <freep>
 860:	a02d                	j	88a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 862:	4618                	lw	a4,8(a2)
 864:	9f2d                	addw	a4,a4,a1
 866:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 86a:	6398                	ld	a4,0(a5)
 86c:	6310                	ld	a2,0(a4)
 86e:	a83d                	j	8ac <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 870:	ff852703          	lw	a4,-8(a0)
 874:	9f31                	addw	a4,a4,a2
 876:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 878:	ff053683          	ld	a3,-16(a0)
 87c:	a091                	j	8c0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87e:	6398                	ld	a4,0(a5)
 880:	00e7e463          	bltu	a5,a4,888 <free+0x3a>
 884:	00e6ea63          	bltu	a3,a4,898 <free+0x4a>
{
 888:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88a:	fed7fae3          	bgeu	a5,a3,87e <free+0x30>
 88e:	6398                	ld	a4,0(a5)
 890:	00e6e463          	bltu	a3,a4,898 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 894:	fee7eae3          	bltu	a5,a4,888 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 898:	ff852583          	lw	a1,-8(a0)
 89c:	6390                	ld	a2,0(a5)
 89e:	02059813          	sll	a6,a1,0x20
 8a2:	01c85713          	srl	a4,a6,0x1c
 8a6:	9736                	add	a4,a4,a3
 8a8:	fae60de3          	beq	a2,a4,862 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8ac:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8b0:	4790                	lw	a2,8(a5)
 8b2:	02061593          	sll	a1,a2,0x20
 8b6:	01c5d713          	srl	a4,a1,0x1c
 8ba:	973e                	add	a4,a4,a5
 8bc:	fae68ae3          	beq	a3,a4,870 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8c0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8c2:	00001717          	auipc	a4,0x1
 8c6:	bcf73723          	sd	a5,-1074(a4) # 1490 <freep>
}
 8ca:	6422                	ld	s0,8(sp)
 8cc:	0141                	add	sp,sp,16
 8ce:	8082                	ret

00000000000008d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8d0:	7139                	add	sp,sp,-64
 8d2:	fc06                	sd	ra,56(sp)
 8d4:	f822                	sd	s0,48(sp)
 8d6:	f426                	sd	s1,40(sp)
 8d8:	ec4e                	sd	s3,24(sp)
 8da:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8dc:	02051493          	sll	s1,a0,0x20
 8e0:	9081                	srl	s1,s1,0x20
 8e2:	04bd                	add	s1,s1,15
 8e4:	8091                	srl	s1,s1,0x4
 8e6:	0014899b          	addw	s3,s1,1
 8ea:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 8ec:	00001517          	auipc	a0,0x1
 8f0:	ba453503          	ld	a0,-1116(a0) # 1490 <freep>
 8f4:	c915                	beqz	a0,928 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f8:	4798                	lw	a4,8(a5)
 8fa:	08977e63          	bgeu	a4,s1,996 <malloc+0xc6>
 8fe:	f04a                	sd	s2,32(sp)
 900:	e852                	sd	s4,16(sp)
 902:	e456                	sd	s5,8(sp)
 904:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 906:	8a4e                	mv	s4,s3
 908:	0009871b          	sext.w	a4,s3
 90c:	6685                	lui	a3,0x1
 90e:	00d77363          	bgeu	a4,a3,914 <malloc+0x44>
 912:	6a05                	lui	s4,0x1
 914:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 918:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 91c:	00001917          	auipc	s2,0x1
 920:	b7490913          	add	s2,s2,-1164 # 1490 <freep>
  if(p == (char*)-1)
 924:	5afd                	li	s5,-1
 926:	a091                	j	96a <malloc+0x9a>
 928:	f04a                	sd	s2,32(sp)
 92a:	e852                	sd	s4,16(sp)
 92c:	e456                	sd	s5,8(sp)
 92e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 930:	00001797          	auipc	a5,0x1
 934:	b7078793          	add	a5,a5,-1168 # 14a0 <base>
 938:	00001717          	auipc	a4,0x1
 93c:	b4f73c23          	sd	a5,-1192(a4) # 1490 <freep>
 940:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 942:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 946:	b7c1                	j	906 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 948:	6398                	ld	a4,0(a5)
 94a:	e118                	sd	a4,0(a0)
 94c:	a08d                	j	9ae <malloc+0xde>
  hp->s.size = nu;
 94e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 952:	0541                	add	a0,a0,16
 954:	00000097          	auipc	ra,0x0
 958:	efa080e7          	jalr	-262(ra) # 84e <free>
  return freep;
 95c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 960:	c13d                	beqz	a0,9c6 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 962:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 964:	4798                	lw	a4,8(a5)
 966:	02977463          	bgeu	a4,s1,98e <malloc+0xbe>
    if(p == freep)
 96a:	00093703          	ld	a4,0(s2)
 96e:	853e                	mv	a0,a5
 970:	fef719e3          	bne	a4,a5,962 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 974:	8552                	mv	a0,s4
 976:	00000097          	auipc	ra,0x0
 97a:	bb2080e7          	jalr	-1102(ra) # 528 <sbrk>
  if(p == (char*)-1)
 97e:	fd5518e3          	bne	a0,s5,94e <malloc+0x7e>
        return 0;
 982:	4501                	li	a0,0
 984:	7902                	ld	s2,32(sp)
 986:	6a42                	ld	s4,16(sp)
 988:	6aa2                	ld	s5,8(sp)
 98a:	6b02                	ld	s6,0(sp)
 98c:	a03d                	j	9ba <malloc+0xea>
 98e:	7902                	ld	s2,32(sp)
 990:	6a42                	ld	s4,16(sp)
 992:	6aa2                	ld	s5,8(sp)
 994:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 996:	fae489e3          	beq	s1,a4,948 <malloc+0x78>
        p->s.size -= nunits;
 99a:	4137073b          	subw	a4,a4,s3
 99e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9a0:	02071693          	sll	a3,a4,0x20
 9a4:	01c6d713          	srl	a4,a3,0x1c
 9a8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9aa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ae:	00001717          	auipc	a4,0x1
 9b2:	aea73123          	sd	a0,-1310(a4) # 1490 <freep>
      return (void*)(p + 1);
 9b6:	01078513          	add	a0,a5,16
  }
}
 9ba:	70e2                	ld	ra,56(sp)
 9bc:	7442                	ld	s0,48(sp)
 9be:	74a2                	ld	s1,40(sp)
 9c0:	69e2                	ld	s3,24(sp)
 9c2:	6121                	add	sp,sp,64
 9c4:	8082                	ret
 9c6:	7902                	ld	s2,32(sp)
 9c8:	6a42                	ld	s4,16(sp)
 9ca:	6aa2                	ld	s5,8(sp)
 9cc:	6b02                	ld	s6,0(sp)
 9ce:	b7f5                	j	9ba <malloc+0xea>
