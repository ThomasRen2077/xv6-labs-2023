
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	add	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	add	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	add	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	add	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	add	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	add	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	add	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	add	a1,a1,1
  ba:	00178513          	add	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	add	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	add	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	add	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	add	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	add	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	715d                	add	sp,sp,-80
 11c:	e486                	sd	ra,72(sp)
 11e:	e0a2                	sd	s0,64(sp)
 120:	fc26                	sd	s1,56(sp)
 122:	f84a                	sd	s2,48(sp)
 124:	f44e                	sd	s3,40(sp)
 126:	f052                	sd	s4,32(sp)
 128:	ec56                	sd	s5,24(sp)
 12a:	e85a                	sd	s6,16(sp)
 12c:	e45e                	sd	s7,8(sp)
 12e:	e062                	sd	s8,0(sp)
 130:	0880                	add	s0,sp,80
 132:	89aa                	mv	s3,a0
 134:	8b2e                	mv	s6,a1
  m = 0;
 136:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 138:	3ff00b93          	li	s7,1023
 13c:	00001a97          	auipc	s5,0x1
 140:	3b4a8a93          	add	s5,s5,948 # 14f0 <buf>
 144:	a0a1                	j	18c <grep+0x72>
      p = q+1;
 146:	00148913          	add	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 14a:	45a9                	li	a1,10
 14c:	854a                	mv	a0,s2
 14e:	00000097          	auipc	ra,0x0
 152:	20a080e7          	jalr	522(ra) # 358 <strchr>
 156:	84aa                	mv	s1,a0
 158:	c905                	beqz	a0,188 <grep+0x6e>
      *q = 0;
 15a:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 15e:	85ca                	mv	a1,s2
 160:	854e                	mv	a0,s3
 162:	00000097          	auipc	ra,0x0
 166:	f6a080e7          	jalr	-150(ra) # cc <match>
 16a:	dd71                	beqz	a0,146 <grep+0x2c>
        *q = '\n';
 16c:	47a9                	li	a5,10
 16e:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 172:	00148613          	add	a2,s1,1
 176:	4126063b          	subw	a2,a2,s2
 17a:	85ca                	mv	a1,s2
 17c:	4505                	li	a0,1
 17e:	00000097          	auipc	ra,0x0
 182:	3e8080e7          	jalr	1000(ra) # 566 <write>
 186:	b7c1                	j	146 <grep+0x2c>
    if(m > 0){
 188:	03404763          	bgtz	s4,1b6 <grep+0x9c>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 18c:	414b863b          	subw	a2,s7,s4
 190:	014a85b3          	add	a1,s5,s4
 194:	855a                	mv	a0,s6
 196:	00000097          	auipc	ra,0x0
 19a:	3c8080e7          	jalr	968(ra) # 55e <read>
 19e:	02a05b63          	blez	a0,1d4 <grep+0xba>
    m += n;
 1a2:	00aa0c3b          	addw	s8,s4,a0
 1a6:	000c0a1b          	sext.w	s4,s8
    buf[m] = '\0';
 1aa:	014a87b3          	add	a5,s5,s4
 1ae:	00078023          	sb	zero,0(a5)
    p = buf;
 1b2:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 1b4:	bf59                	j	14a <grep+0x30>
      m -= p - buf;
 1b6:	00001517          	auipc	a0,0x1
 1ba:	33a50513          	add	a0,a0,826 # 14f0 <buf>
 1be:	40a90a33          	sub	s4,s2,a0
 1c2:	414c0a3b          	subw	s4,s8,s4
      memmove(buf, p, m);
 1c6:	8652                	mv	a2,s4
 1c8:	85ca                	mv	a1,s2
 1ca:	00000097          	auipc	ra,0x0
 1ce:	2b4080e7          	jalr	692(ra) # 47e <memmove>
 1d2:	bf6d                	j	18c <grep+0x72>
}
 1d4:	60a6                	ld	ra,72(sp)
 1d6:	6406                	ld	s0,64(sp)
 1d8:	74e2                	ld	s1,56(sp)
 1da:	7942                	ld	s2,48(sp)
 1dc:	79a2                	ld	s3,40(sp)
 1de:	7a02                	ld	s4,32(sp)
 1e0:	6ae2                	ld	s5,24(sp)
 1e2:	6b42                	ld	s6,16(sp)
 1e4:	6ba2                	ld	s7,8(sp)
 1e6:	6c02                	ld	s8,0(sp)
 1e8:	6161                	add	sp,sp,80
 1ea:	8082                	ret

00000000000001ec <main>:
{
 1ec:	7179                	add	sp,sp,-48
 1ee:	f406                	sd	ra,40(sp)
 1f0:	f022                	sd	s0,32(sp)
 1f2:	ec26                	sd	s1,24(sp)
 1f4:	e84a                	sd	s2,16(sp)
 1f6:	e44e                	sd	s3,8(sp)
 1f8:	e052                	sd	s4,0(sp)
 1fa:	1800                	add	s0,sp,48
  if(argc <= 1){
 1fc:	4785                	li	a5,1
 1fe:	04a7de63          	bge	a5,a0,25a <main+0x6e>
  pattern = argv[1];
 202:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 206:	4789                	li	a5,2
 208:	06a7d763          	bge	a5,a0,276 <main+0x8a>
 20c:	01058913          	add	s2,a1,16
 210:	ffd5099b          	addw	s3,a0,-3
 214:	02099793          	sll	a5,s3,0x20
 218:	01d7d993          	srl	s3,a5,0x1d
 21c:	05e1                	add	a1,a1,24
 21e:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 220:	4581                	li	a1,0
 222:	00093503          	ld	a0,0(s2)
 226:	00000097          	auipc	ra,0x0
 22a:	360080e7          	jalr	864(ra) # 586 <open>
 22e:	84aa                	mv	s1,a0
 230:	04054e63          	bltz	a0,28c <main+0xa0>
    grep(pattern, fd);
 234:	85aa                	mv	a1,a0
 236:	8552                	mv	a0,s4
 238:	00000097          	auipc	ra,0x0
 23c:	ee2080e7          	jalr	-286(ra) # 11a <grep>
    close(fd);
 240:	8526                	mv	a0,s1
 242:	00000097          	auipc	ra,0x0
 246:	32c080e7          	jalr	812(ra) # 56e <close>
  for(i = 2; i < argc; i++){
 24a:	0921                	add	s2,s2,8
 24c:	fd391ae3          	bne	s2,s3,220 <main+0x34>
  exit(0);
 250:	4501                	li	a0,0
 252:	00000097          	auipc	ra,0x0
 256:	2f4080e7          	jalr	756(ra) # 546 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 25a:	00001597          	auipc	a1,0x1
 25e:	82658593          	add	a1,a1,-2010 # a80 <malloc+0x10a>
 262:	4509                	li	a0,2
 264:	00000097          	auipc	ra,0x0
 268:	62c080e7          	jalr	1580(ra) # 890 <fprintf>
    exit(1);
 26c:	4505                	li	a0,1
 26e:	00000097          	auipc	ra,0x0
 272:	2d8080e7          	jalr	728(ra) # 546 <exit>
    grep(pattern, 0);
 276:	4581                	li	a1,0
 278:	8552                	mv	a0,s4
 27a:	00000097          	auipc	ra,0x0
 27e:	ea0080e7          	jalr	-352(ra) # 11a <grep>
    exit(0);
 282:	4501                	li	a0,0
 284:	00000097          	auipc	ra,0x0
 288:	2c2080e7          	jalr	706(ra) # 546 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 28c:	00093583          	ld	a1,0(s2)
 290:	00001517          	auipc	a0,0x1
 294:	81050513          	add	a0,a0,-2032 # aa0 <malloc+0x12a>
 298:	00000097          	auipc	ra,0x0
 29c:	626080e7          	jalr	1574(ra) # 8be <printf>
      exit(1);
 2a0:	4505                	li	a0,1
 2a2:	00000097          	auipc	ra,0x0
 2a6:	2a4080e7          	jalr	676(ra) # 546 <exit>

00000000000002aa <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2aa:	1141                	add	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	add	s0,sp,16
  extern int main();
  main();
 2b2:	00000097          	auipc	ra,0x0
 2b6:	f3a080e7          	jalr	-198(ra) # 1ec <main>
  exit(0);
 2ba:	4501                	li	a0,0
 2bc:	00000097          	auipc	ra,0x0
 2c0:	28a080e7          	jalr	650(ra) # 546 <exit>

00000000000002c4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2c4:	1141                	add	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ca:	87aa                	mv	a5,a0
 2cc:	0585                	add	a1,a1,1
 2ce:	0785                	add	a5,a5,1
 2d0:	fff5c703          	lbu	a4,-1(a1)
 2d4:	fee78fa3          	sb	a4,-1(a5)
 2d8:	fb75                	bnez	a4,2cc <strcpy+0x8>
    ;
  return os;
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	add	sp,sp,16
 2de:	8082                	ret

00000000000002e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e0:	1141                	add	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 2e6:	00054783          	lbu	a5,0(a0)
 2ea:	cb91                	beqz	a5,2fe <strcmp+0x1e>
 2ec:	0005c703          	lbu	a4,0(a1)
 2f0:	00f71763          	bne	a4,a5,2fe <strcmp+0x1e>
    p++, q++;
 2f4:	0505                	add	a0,a0,1
 2f6:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 2f8:	00054783          	lbu	a5,0(a0)
 2fc:	fbe5                	bnez	a5,2ec <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2fe:	0005c503          	lbu	a0,0(a1)
}
 302:	40a7853b          	subw	a0,a5,a0
 306:	6422                	ld	s0,8(sp)
 308:	0141                	add	sp,sp,16
 30a:	8082                	ret

000000000000030c <strlen>:

uint
strlen(const char *s)
{
 30c:	1141                	add	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 312:	00054783          	lbu	a5,0(a0)
 316:	cf91                	beqz	a5,332 <strlen+0x26>
 318:	0505                	add	a0,a0,1
 31a:	87aa                	mv	a5,a0
 31c:	86be                	mv	a3,a5
 31e:	0785                	add	a5,a5,1
 320:	fff7c703          	lbu	a4,-1(a5)
 324:	ff65                	bnez	a4,31c <strlen+0x10>
 326:	40a6853b          	subw	a0,a3,a0
 32a:	2505                	addw	a0,a0,1
    ;
  return n;
}
 32c:	6422                	ld	s0,8(sp)
 32e:	0141                	add	sp,sp,16
 330:	8082                	ret
  for(n = 0; s[n]; n++)
 332:	4501                	li	a0,0
 334:	bfe5                	j	32c <strlen+0x20>

0000000000000336 <memset>:

void*
memset(void *dst, int c, uint n)
{
 336:	1141                	add	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 33c:	ca19                	beqz	a2,352 <memset+0x1c>
 33e:	87aa                	mv	a5,a0
 340:	1602                	sll	a2,a2,0x20
 342:	9201                	srl	a2,a2,0x20
 344:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 348:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 34c:	0785                	add	a5,a5,1
 34e:	fee79de3          	bne	a5,a4,348 <memset+0x12>
  }
  return dst;
}
 352:	6422                	ld	s0,8(sp)
 354:	0141                	add	sp,sp,16
 356:	8082                	ret

0000000000000358 <strchr>:

char*
strchr(const char *s, char c)
{
 358:	1141                	add	sp,sp,-16
 35a:	e422                	sd	s0,8(sp)
 35c:	0800                	add	s0,sp,16
  for(; *s; s++)
 35e:	00054783          	lbu	a5,0(a0)
 362:	cb99                	beqz	a5,378 <strchr+0x20>
    if(*s == c)
 364:	00f58763          	beq	a1,a5,372 <strchr+0x1a>
  for(; *s; s++)
 368:	0505                	add	a0,a0,1
 36a:	00054783          	lbu	a5,0(a0)
 36e:	fbfd                	bnez	a5,364 <strchr+0xc>
      return (char*)s;
  return 0;
 370:	4501                	li	a0,0
}
 372:	6422                	ld	s0,8(sp)
 374:	0141                	add	sp,sp,16
 376:	8082                	ret
  return 0;
 378:	4501                	li	a0,0
 37a:	bfe5                	j	372 <strchr+0x1a>

000000000000037c <gets>:

char*
gets(char *buf, int max)
{
 37c:	711d                	add	sp,sp,-96
 37e:	ec86                	sd	ra,88(sp)
 380:	e8a2                	sd	s0,80(sp)
 382:	e4a6                	sd	s1,72(sp)
 384:	e0ca                	sd	s2,64(sp)
 386:	fc4e                	sd	s3,56(sp)
 388:	f852                	sd	s4,48(sp)
 38a:	f456                	sd	s5,40(sp)
 38c:	f05a                	sd	s6,32(sp)
 38e:	ec5e                	sd	s7,24(sp)
 390:	1080                	add	s0,sp,96
 392:	8baa                	mv	s7,a0
 394:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 396:	892a                	mv	s2,a0
 398:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 39a:	4aa9                	li	s5,10
 39c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 39e:	89a6                	mv	s3,s1
 3a0:	2485                	addw	s1,s1,1
 3a2:	0344d863          	bge	s1,s4,3d2 <gets+0x56>
    cc = read(0, &c, 1);
 3a6:	4605                	li	a2,1
 3a8:	faf40593          	add	a1,s0,-81
 3ac:	4501                	li	a0,0
 3ae:	00000097          	auipc	ra,0x0
 3b2:	1b0080e7          	jalr	432(ra) # 55e <read>
    if(cc < 1)
 3b6:	00a05e63          	blez	a0,3d2 <gets+0x56>
    buf[i++] = c;
 3ba:	faf44783          	lbu	a5,-81(s0)
 3be:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3c2:	01578763          	beq	a5,s5,3d0 <gets+0x54>
 3c6:	0905                	add	s2,s2,1
 3c8:	fd679be3          	bne	a5,s6,39e <gets+0x22>
    buf[i++] = c;
 3cc:	89a6                	mv	s3,s1
 3ce:	a011                	j	3d2 <gets+0x56>
 3d0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3d2:	99de                	add	s3,s3,s7
 3d4:	00098023          	sb	zero,0(s3)
  return buf;
}
 3d8:	855e                	mv	a0,s7
 3da:	60e6                	ld	ra,88(sp)
 3dc:	6446                	ld	s0,80(sp)
 3de:	64a6                	ld	s1,72(sp)
 3e0:	6906                	ld	s2,64(sp)
 3e2:	79e2                	ld	s3,56(sp)
 3e4:	7a42                	ld	s4,48(sp)
 3e6:	7aa2                	ld	s5,40(sp)
 3e8:	7b02                	ld	s6,32(sp)
 3ea:	6be2                	ld	s7,24(sp)
 3ec:	6125                	add	sp,sp,96
 3ee:	8082                	ret

00000000000003f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3f0:	1101                	add	sp,sp,-32
 3f2:	ec06                	sd	ra,24(sp)
 3f4:	e822                	sd	s0,16(sp)
 3f6:	e04a                	sd	s2,0(sp)
 3f8:	1000                	add	s0,sp,32
 3fa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3fc:	4581                	li	a1,0
 3fe:	00000097          	auipc	ra,0x0
 402:	188080e7          	jalr	392(ra) # 586 <open>
  if(fd < 0)
 406:	02054663          	bltz	a0,432 <stat+0x42>
 40a:	e426                	sd	s1,8(sp)
 40c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 40e:	85ca                	mv	a1,s2
 410:	00000097          	auipc	ra,0x0
 414:	18e080e7          	jalr	398(ra) # 59e <fstat>
 418:	892a                	mv	s2,a0
  close(fd);
 41a:	8526                	mv	a0,s1
 41c:	00000097          	auipc	ra,0x0
 420:	152080e7          	jalr	338(ra) # 56e <close>
  return r;
 424:	64a2                	ld	s1,8(sp)
}
 426:	854a                	mv	a0,s2
 428:	60e2                	ld	ra,24(sp)
 42a:	6442                	ld	s0,16(sp)
 42c:	6902                	ld	s2,0(sp)
 42e:	6105                	add	sp,sp,32
 430:	8082                	ret
    return -1;
 432:	597d                	li	s2,-1
 434:	bfcd                	j	426 <stat+0x36>

0000000000000436 <atoi>:

int
atoi(const char *s)
{
 436:	1141                	add	sp,sp,-16
 438:	e422                	sd	s0,8(sp)
 43a:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 43c:	00054683          	lbu	a3,0(a0)
 440:	fd06879b          	addw	a5,a3,-48
 444:	0ff7f793          	zext.b	a5,a5
 448:	4625                	li	a2,9
 44a:	02f66863          	bltu	a2,a5,47a <atoi+0x44>
 44e:	872a                	mv	a4,a0
  n = 0;
 450:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 452:	0705                	add	a4,a4,1
 454:	0025179b          	sllw	a5,a0,0x2
 458:	9fa9                	addw	a5,a5,a0
 45a:	0017979b          	sllw	a5,a5,0x1
 45e:	9fb5                	addw	a5,a5,a3
 460:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 464:	00074683          	lbu	a3,0(a4)
 468:	fd06879b          	addw	a5,a3,-48
 46c:	0ff7f793          	zext.b	a5,a5
 470:	fef671e3          	bgeu	a2,a5,452 <atoi+0x1c>
  return n;
}
 474:	6422                	ld	s0,8(sp)
 476:	0141                	add	sp,sp,16
 478:	8082                	ret
  n = 0;
 47a:	4501                	li	a0,0
 47c:	bfe5                	j	474 <atoi+0x3e>

000000000000047e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 47e:	1141                	add	sp,sp,-16
 480:	e422                	sd	s0,8(sp)
 482:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 484:	02b57463          	bgeu	a0,a1,4ac <memmove+0x2e>
    while(n-- > 0)
 488:	00c05f63          	blez	a2,4a6 <memmove+0x28>
 48c:	1602                	sll	a2,a2,0x20
 48e:	9201                	srl	a2,a2,0x20
 490:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 494:	872a                	mv	a4,a0
      *dst++ = *src++;
 496:	0585                	add	a1,a1,1
 498:	0705                	add	a4,a4,1
 49a:	fff5c683          	lbu	a3,-1(a1)
 49e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4a2:	fef71ae3          	bne	a4,a5,496 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4a6:	6422                	ld	s0,8(sp)
 4a8:	0141                	add	sp,sp,16
 4aa:	8082                	ret
    dst += n;
 4ac:	00c50733          	add	a4,a0,a2
    src += n;
 4b0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4b2:	fec05ae3          	blez	a2,4a6 <memmove+0x28>
 4b6:	fff6079b          	addw	a5,a2,-1
 4ba:	1782                	sll	a5,a5,0x20
 4bc:	9381                	srl	a5,a5,0x20
 4be:	fff7c793          	not	a5,a5
 4c2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4c4:	15fd                	add	a1,a1,-1
 4c6:	177d                	add	a4,a4,-1
 4c8:	0005c683          	lbu	a3,0(a1)
 4cc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4d0:	fee79ae3          	bne	a5,a4,4c4 <memmove+0x46>
 4d4:	bfc9                	j	4a6 <memmove+0x28>

00000000000004d6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4d6:	1141                	add	sp,sp,-16
 4d8:	e422                	sd	s0,8(sp)
 4da:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4dc:	ca05                	beqz	a2,50c <memcmp+0x36>
 4de:	fff6069b          	addw	a3,a2,-1
 4e2:	1682                	sll	a3,a3,0x20
 4e4:	9281                	srl	a3,a3,0x20
 4e6:	0685                	add	a3,a3,1
 4e8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4ea:	00054783          	lbu	a5,0(a0)
 4ee:	0005c703          	lbu	a4,0(a1)
 4f2:	00e79863          	bne	a5,a4,502 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4f6:	0505                	add	a0,a0,1
    p2++;
 4f8:	0585                	add	a1,a1,1
  while (n-- > 0) {
 4fa:	fed518e3          	bne	a0,a3,4ea <memcmp+0x14>
  }
  return 0;
 4fe:	4501                	li	a0,0
 500:	a019                	j	506 <memcmp+0x30>
      return *p1 - *p2;
 502:	40e7853b          	subw	a0,a5,a4
}
 506:	6422                	ld	s0,8(sp)
 508:	0141                	add	sp,sp,16
 50a:	8082                	ret
  return 0;
 50c:	4501                	li	a0,0
 50e:	bfe5                	j	506 <memcmp+0x30>

0000000000000510 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 510:	1141                	add	sp,sp,-16
 512:	e406                	sd	ra,8(sp)
 514:	e022                	sd	s0,0(sp)
 516:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 518:	00000097          	auipc	ra,0x0
 51c:	f66080e7          	jalr	-154(ra) # 47e <memmove>
}
 520:	60a2                	ld	ra,8(sp)
 522:	6402                	ld	s0,0(sp)
 524:	0141                	add	sp,sp,16
 526:	8082                	ret

0000000000000528 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 528:	1141                	add	sp,sp,-16
 52a:	e422                	sd	s0,8(sp)
 52c:	0800                	add	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 52e:	040007b7          	lui	a5,0x4000
 532:	17f5                	add	a5,a5,-3 # 3fffffd <base+0x3ffe70d>
 534:	07b2                	sll	a5,a5,0xc
}
 536:	4388                	lw	a0,0(a5)
 538:	6422                	ld	s0,8(sp)
 53a:	0141                	add	sp,sp,16
 53c:	8082                	ret

000000000000053e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 53e:	4885                	li	a7,1
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <exit>:
.global exit
exit:
 li a7, SYS_exit
 546:	4889                	li	a7,2
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <wait>:
.global wait
wait:
 li a7, SYS_wait
 54e:	488d                	li	a7,3
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 556:	4891                	li	a7,4
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <read>:
.global read
read:
 li a7, SYS_read
 55e:	4895                	li	a7,5
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <write>:
.global write
write:
 li a7, SYS_write
 566:	48c1                	li	a7,16
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <close>:
.global close
close:
 li a7, SYS_close
 56e:	48d5                	li	a7,21
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <kill>:
.global kill
kill:
 li a7, SYS_kill
 576:	4899                	li	a7,6
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <exec>:
.global exec
exec:
 li a7, SYS_exec
 57e:	489d                	li	a7,7
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <open>:
.global open
open:
 li a7, SYS_open
 586:	48bd                	li	a7,15
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 58e:	48c5                	li	a7,17
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 596:	48c9                	li	a7,18
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 59e:	48a1                	li	a7,8
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <link>:
.global link
link:
 li a7, SYS_link
 5a6:	48cd                	li	a7,19
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5ae:	48d1                	li	a7,20
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5b6:	48a5                	li	a7,9
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <dup>:
.global dup
dup:
 li a7, SYS_dup
 5be:	48a9                	li	a7,10
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5c6:	48ad                	li	a7,11
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5ce:	48b1                	li	a7,12
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5d6:	48b5                	li	a7,13
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5de:	48b9                	li	a7,14
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <connect>:
.global connect
connect:
 li a7, SYS_connect
 5e6:	48f5                	li	a7,29
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 5ee:	48f9                	li	a7,30
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5f6:	1101                	add	sp,sp,-32
 5f8:	ec06                	sd	ra,24(sp)
 5fa:	e822                	sd	s0,16(sp)
 5fc:	1000                	add	s0,sp,32
 5fe:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 602:	4605                	li	a2,1
 604:	fef40593          	add	a1,s0,-17
 608:	00000097          	auipc	ra,0x0
 60c:	f5e080e7          	jalr	-162(ra) # 566 <write>
}
 610:	60e2                	ld	ra,24(sp)
 612:	6442                	ld	s0,16(sp)
 614:	6105                	add	sp,sp,32
 616:	8082                	ret

0000000000000618 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 618:	7139                	add	sp,sp,-64
 61a:	fc06                	sd	ra,56(sp)
 61c:	f822                	sd	s0,48(sp)
 61e:	f426                	sd	s1,40(sp)
 620:	0080                	add	s0,sp,64
 622:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 624:	c299                	beqz	a3,62a <printint+0x12>
 626:	0805cb63          	bltz	a1,6bc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 62a:	2581                	sext.w	a1,a1
  neg = 0;
 62c:	4881                	li	a7,0
 62e:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 632:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 634:	2601                	sext.w	a2,a2
 636:	00000517          	auipc	a0,0x0
 63a:	4e250513          	add	a0,a0,1250 # b18 <digits>
 63e:	883a                	mv	a6,a4
 640:	2705                	addw	a4,a4,1
 642:	02c5f7bb          	remuw	a5,a1,a2
 646:	1782                	sll	a5,a5,0x20
 648:	9381                	srl	a5,a5,0x20
 64a:	97aa                	add	a5,a5,a0
 64c:	0007c783          	lbu	a5,0(a5)
 650:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 654:	0005879b          	sext.w	a5,a1
 658:	02c5d5bb          	divuw	a1,a1,a2
 65c:	0685                	add	a3,a3,1
 65e:	fec7f0e3          	bgeu	a5,a2,63e <printint+0x26>
  if(neg)
 662:	00088c63          	beqz	a7,67a <printint+0x62>
    buf[i++] = '-';
 666:	fd070793          	add	a5,a4,-48
 66a:	00878733          	add	a4,a5,s0
 66e:	02d00793          	li	a5,45
 672:	fef70823          	sb	a5,-16(a4)
 676:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 67a:	02e05c63          	blez	a4,6b2 <printint+0x9a>
 67e:	f04a                	sd	s2,32(sp)
 680:	ec4e                	sd	s3,24(sp)
 682:	fc040793          	add	a5,s0,-64
 686:	00e78933          	add	s2,a5,a4
 68a:	fff78993          	add	s3,a5,-1
 68e:	99ba                	add	s3,s3,a4
 690:	377d                	addw	a4,a4,-1
 692:	1702                	sll	a4,a4,0x20
 694:	9301                	srl	a4,a4,0x20
 696:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 69a:	fff94583          	lbu	a1,-1(s2)
 69e:	8526                	mv	a0,s1
 6a0:	00000097          	auipc	ra,0x0
 6a4:	f56080e7          	jalr	-170(ra) # 5f6 <putc>
  while(--i >= 0)
 6a8:	197d                	add	s2,s2,-1
 6aa:	ff3918e3          	bne	s2,s3,69a <printint+0x82>
 6ae:	7902                	ld	s2,32(sp)
 6b0:	69e2                	ld	s3,24(sp)
}
 6b2:	70e2                	ld	ra,56(sp)
 6b4:	7442                	ld	s0,48(sp)
 6b6:	74a2                	ld	s1,40(sp)
 6b8:	6121                	add	sp,sp,64
 6ba:	8082                	ret
    x = -xx;
 6bc:	40b005bb          	negw	a1,a1
    neg = 1;
 6c0:	4885                	li	a7,1
    x = -xx;
 6c2:	b7b5                	j	62e <printint+0x16>

00000000000006c4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6c4:	715d                	add	sp,sp,-80
 6c6:	e486                	sd	ra,72(sp)
 6c8:	e0a2                	sd	s0,64(sp)
 6ca:	f84a                	sd	s2,48(sp)
 6cc:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6ce:	0005c903          	lbu	s2,0(a1)
 6d2:	1a090a63          	beqz	s2,886 <vprintf+0x1c2>
 6d6:	fc26                	sd	s1,56(sp)
 6d8:	f44e                	sd	s3,40(sp)
 6da:	f052                	sd	s4,32(sp)
 6dc:	ec56                	sd	s5,24(sp)
 6de:	e85a                	sd	s6,16(sp)
 6e0:	e45e                	sd	s7,8(sp)
 6e2:	8aaa                	mv	s5,a0
 6e4:	8bb2                	mv	s7,a2
 6e6:	00158493          	add	s1,a1,1
  state = 0;
 6ea:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6ec:	02500a13          	li	s4,37
 6f0:	4b55                	li	s6,21
 6f2:	a839                	j	710 <vprintf+0x4c>
        putc(fd, c);
 6f4:	85ca                	mv	a1,s2
 6f6:	8556                	mv	a0,s5
 6f8:	00000097          	auipc	ra,0x0
 6fc:	efe080e7          	jalr	-258(ra) # 5f6 <putc>
 700:	a019                	j	706 <vprintf+0x42>
    } else if(state == '%'){
 702:	01498d63          	beq	s3,s4,71c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 706:	0485                	add	s1,s1,1
 708:	fff4c903          	lbu	s2,-1(s1)
 70c:	16090763          	beqz	s2,87a <vprintf+0x1b6>
    if(state == 0){
 710:	fe0999e3          	bnez	s3,702 <vprintf+0x3e>
      if(c == '%'){
 714:	ff4910e3          	bne	s2,s4,6f4 <vprintf+0x30>
        state = '%';
 718:	89d2                	mv	s3,s4
 71a:	b7f5                	j	706 <vprintf+0x42>
      if(c == 'd'){
 71c:	13490463          	beq	s2,s4,844 <vprintf+0x180>
 720:	f9d9079b          	addw	a5,s2,-99
 724:	0ff7f793          	zext.b	a5,a5
 728:	12fb6763          	bltu	s6,a5,856 <vprintf+0x192>
 72c:	f9d9079b          	addw	a5,s2,-99
 730:	0ff7f713          	zext.b	a4,a5
 734:	12eb6163          	bltu	s6,a4,856 <vprintf+0x192>
 738:	00271793          	sll	a5,a4,0x2
 73c:	00000717          	auipc	a4,0x0
 740:	38470713          	add	a4,a4,900 # ac0 <malloc+0x14a>
 744:	97ba                	add	a5,a5,a4
 746:	439c                	lw	a5,0(a5)
 748:	97ba                	add	a5,a5,a4
 74a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 74c:	008b8913          	add	s2,s7,8
 750:	4685                	li	a3,1
 752:	4629                	li	a2,10
 754:	000ba583          	lw	a1,0(s7)
 758:	8556                	mv	a0,s5
 75a:	00000097          	auipc	ra,0x0
 75e:	ebe080e7          	jalr	-322(ra) # 618 <printint>
 762:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 764:	4981                	li	s3,0
 766:	b745                	j	706 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 768:	008b8913          	add	s2,s7,8
 76c:	4681                	li	a3,0
 76e:	4629                	li	a2,10
 770:	000ba583          	lw	a1,0(s7)
 774:	8556                	mv	a0,s5
 776:	00000097          	auipc	ra,0x0
 77a:	ea2080e7          	jalr	-350(ra) # 618 <printint>
 77e:	8bca                	mv	s7,s2
      state = 0;
 780:	4981                	li	s3,0
 782:	b751                	j	706 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 784:	008b8913          	add	s2,s7,8
 788:	4681                	li	a3,0
 78a:	4641                	li	a2,16
 78c:	000ba583          	lw	a1,0(s7)
 790:	8556                	mv	a0,s5
 792:	00000097          	auipc	ra,0x0
 796:	e86080e7          	jalr	-378(ra) # 618 <printint>
 79a:	8bca                	mv	s7,s2
      state = 0;
 79c:	4981                	li	s3,0
 79e:	b7a5                	j	706 <vprintf+0x42>
 7a0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7a2:	008b8c13          	add	s8,s7,8
 7a6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7aa:	03000593          	li	a1,48
 7ae:	8556                	mv	a0,s5
 7b0:	00000097          	auipc	ra,0x0
 7b4:	e46080e7          	jalr	-442(ra) # 5f6 <putc>
  putc(fd, 'x');
 7b8:	07800593          	li	a1,120
 7bc:	8556                	mv	a0,s5
 7be:	00000097          	auipc	ra,0x0
 7c2:	e38080e7          	jalr	-456(ra) # 5f6 <putc>
 7c6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7c8:	00000b97          	auipc	s7,0x0
 7cc:	350b8b93          	add	s7,s7,848 # b18 <digits>
 7d0:	03c9d793          	srl	a5,s3,0x3c
 7d4:	97de                	add	a5,a5,s7
 7d6:	0007c583          	lbu	a1,0(a5)
 7da:	8556                	mv	a0,s5
 7dc:	00000097          	auipc	ra,0x0
 7e0:	e1a080e7          	jalr	-486(ra) # 5f6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7e4:	0992                	sll	s3,s3,0x4
 7e6:	397d                	addw	s2,s2,-1
 7e8:	fe0914e3          	bnez	s2,7d0 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 7ec:	8be2                	mv	s7,s8
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	6c02                	ld	s8,0(sp)
 7f2:	bf11                	j	706 <vprintf+0x42>
        s = va_arg(ap, char*);
 7f4:	008b8993          	add	s3,s7,8
 7f8:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 7fc:	02090163          	beqz	s2,81e <vprintf+0x15a>
        while(*s != 0){
 800:	00094583          	lbu	a1,0(s2)
 804:	c9a5                	beqz	a1,874 <vprintf+0x1b0>
          putc(fd, *s);
 806:	8556                	mv	a0,s5
 808:	00000097          	auipc	ra,0x0
 80c:	dee080e7          	jalr	-530(ra) # 5f6 <putc>
          s++;
 810:	0905                	add	s2,s2,1
        while(*s != 0){
 812:	00094583          	lbu	a1,0(s2)
 816:	f9e5                	bnez	a1,806 <vprintf+0x142>
        s = va_arg(ap, char*);
 818:	8bce                	mv	s7,s3
      state = 0;
 81a:	4981                	li	s3,0
 81c:	b5ed                	j	706 <vprintf+0x42>
          s = "(null)";
 81e:	00000917          	auipc	s2,0x0
 822:	29a90913          	add	s2,s2,666 # ab8 <malloc+0x142>
        while(*s != 0){
 826:	02800593          	li	a1,40
 82a:	bff1                	j	806 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 82c:	008b8913          	add	s2,s7,8
 830:	000bc583          	lbu	a1,0(s7)
 834:	8556                	mv	a0,s5
 836:	00000097          	auipc	ra,0x0
 83a:	dc0080e7          	jalr	-576(ra) # 5f6 <putc>
 83e:	8bca                	mv	s7,s2
      state = 0;
 840:	4981                	li	s3,0
 842:	b5d1                	j	706 <vprintf+0x42>
        putc(fd, c);
 844:	02500593          	li	a1,37
 848:	8556                	mv	a0,s5
 84a:	00000097          	auipc	ra,0x0
 84e:	dac080e7          	jalr	-596(ra) # 5f6 <putc>
      state = 0;
 852:	4981                	li	s3,0
 854:	bd4d                	j	706 <vprintf+0x42>
        putc(fd, '%');
 856:	02500593          	li	a1,37
 85a:	8556                	mv	a0,s5
 85c:	00000097          	auipc	ra,0x0
 860:	d9a080e7          	jalr	-614(ra) # 5f6 <putc>
        putc(fd, c);
 864:	85ca                	mv	a1,s2
 866:	8556                	mv	a0,s5
 868:	00000097          	auipc	ra,0x0
 86c:	d8e080e7          	jalr	-626(ra) # 5f6 <putc>
      state = 0;
 870:	4981                	li	s3,0
 872:	bd51                	j	706 <vprintf+0x42>
        s = va_arg(ap, char*);
 874:	8bce                	mv	s7,s3
      state = 0;
 876:	4981                	li	s3,0
 878:	b579                	j	706 <vprintf+0x42>
 87a:	74e2                	ld	s1,56(sp)
 87c:	79a2                	ld	s3,40(sp)
 87e:	7a02                	ld	s4,32(sp)
 880:	6ae2                	ld	s5,24(sp)
 882:	6b42                	ld	s6,16(sp)
 884:	6ba2                	ld	s7,8(sp)
    }
  }
}
 886:	60a6                	ld	ra,72(sp)
 888:	6406                	ld	s0,64(sp)
 88a:	7942                	ld	s2,48(sp)
 88c:	6161                	add	sp,sp,80
 88e:	8082                	ret

0000000000000890 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 890:	715d                	add	sp,sp,-80
 892:	ec06                	sd	ra,24(sp)
 894:	e822                	sd	s0,16(sp)
 896:	1000                	add	s0,sp,32
 898:	e010                	sd	a2,0(s0)
 89a:	e414                	sd	a3,8(s0)
 89c:	e818                	sd	a4,16(s0)
 89e:	ec1c                	sd	a5,24(s0)
 8a0:	03043023          	sd	a6,32(s0)
 8a4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8a8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8ac:	8622                	mv	a2,s0
 8ae:	00000097          	auipc	ra,0x0
 8b2:	e16080e7          	jalr	-490(ra) # 6c4 <vprintf>
}
 8b6:	60e2                	ld	ra,24(sp)
 8b8:	6442                	ld	s0,16(sp)
 8ba:	6161                	add	sp,sp,80
 8bc:	8082                	ret

00000000000008be <printf>:

void
printf(const char *fmt, ...)
{
 8be:	711d                	add	sp,sp,-96
 8c0:	ec06                	sd	ra,24(sp)
 8c2:	e822                	sd	s0,16(sp)
 8c4:	1000                	add	s0,sp,32
 8c6:	e40c                	sd	a1,8(s0)
 8c8:	e810                	sd	a2,16(s0)
 8ca:	ec14                	sd	a3,24(s0)
 8cc:	f018                	sd	a4,32(s0)
 8ce:	f41c                	sd	a5,40(s0)
 8d0:	03043823          	sd	a6,48(s0)
 8d4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8d8:	00840613          	add	a2,s0,8
 8dc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8e0:	85aa                	mv	a1,a0
 8e2:	4505                	li	a0,1
 8e4:	00000097          	auipc	ra,0x0
 8e8:	de0080e7          	jalr	-544(ra) # 6c4 <vprintf>
}
 8ec:	60e2                	ld	ra,24(sp)
 8ee:	6442                	ld	s0,16(sp)
 8f0:	6125                	add	sp,sp,96
 8f2:	8082                	ret

00000000000008f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8f4:	1141                	add	sp,sp,-16
 8f6:	e422                	sd	s0,8(sp)
 8f8:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8fa:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8fe:	00001797          	auipc	a5,0x1
 902:	be27b783          	ld	a5,-1054(a5) # 14e0 <freep>
 906:	a02d                	j	930 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 908:	4618                	lw	a4,8(a2)
 90a:	9f2d                	addw	a4,a4,a1
 90c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 910:	6398                	ld	a4,0(a5)
 912:	6310                	ld	a2,0(a4)
 914:	a83d                	j	952 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 916:	ff852703          	lw	a4,-8(a0)
 91a:	9f31                	addw	a4,a4,a2
 91c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 91e:	ff053683          	ld	a3,-16(a0)
 922:	a091                	j	966 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 924:	6398                	ld	a4,0(a5)
 926:	00e7e463          	bltu	a5,a4,92e <free+0x3a>
 92a:	00e6ea63          	bltu	a3,a4,93e <free+0x4a>
{
 92e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 930:	fed7fae3          	bgeu	a5,a3,924 <free+0x30>
 934:	6398                	ld	a4,0(a5)
 936:	00e6e463          	bltu	a3,a4,93e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 93a:	fee7eae3          	bltu	a5,a4,92e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 93e:	ff852583          	lw	a1,-8(a0)
 942:	6390                	ld	a2,0(a5)
 944:	02059813          	sll	a6,a1,0x20
 948:	01c85713          	srl	a4,a6,0x1c
 94c:	9736                	add	a4,a4,a3
 94e:	fae60de3          	beq	a2,a4,908 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 952:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 956:	4790                	lw	a2,8(a5)
 958:	02061593          	sll	a1,a2,0x20
 95c:	01c5d713          	srl	a4,a1,0x1c
 960:	973e                	add	a4,a4,a5
 962:	fae68ae3          	beq	a3,a4,916 <free+0x22>
    p->s.ptr = bp->s.ptr;
 966:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 968:	00001717          	auipc	a4,0x1
 96c:	b6f73c23          	sd	a5,-1160(a4) # 14e0 <freep>
}
 970:	6422                	ld	s0,8(sp)
 972:	0141                	add	sp,sp,16
 974:	8082                	ret

0000000000000976 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 976:	7139                	add	sp,sp,-64
 978:	fc06                	sd	ra,56(sp)
 97a:	f822                	sd	s0,48(sp)
 97c:	f426                	sd	s1,40(sp)
 97e:	ec4e                	sd	s3,24(sp)
 980:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 982:	02051493          	sll	s1,a0,0x20
 986:	9081                	srl	s1,s1,0x20
 988:	04bd                	add	s1,s1,15
 98a:	8091                	srl	s1,s1,0x4
 98c:	0014899b          	addw	s3,s1,1
 990:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 992:	00001517          	auipc	a0,0x1
 996:	b4e53503          	ld	a0,-1202(a0) # 14e0 <freep>
 99a:	c915                	beqz	a0,9ce <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 99c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 99e:	4798                	lw	a4,8(a5)
 9a0:	08977e63          	bgeu	a4,s1,a3c <malloc+0xc6>
 9a4:	f04a                	sd	s2,32(sp)
 9a6:	e852                	sd	s4,16(sp)
 9a8:	e456                	sd	s5,8(sp)
 9aa:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9ac:	8a4e                	mv	s4,s3
 9ae:	0009871b          	sext.w	a4,s3
 9b2:	6685                	lui	a3,0x1
 9b4:	00d77363          	bgeu	a4,a3,9ba <malloc+0x44>
 9b8:	6a05                	lui	s4,0x1
 9ba:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9be:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9c2:	00001917          	auipc	s2,0x1
 9c6:	b1e90913          	add	s2,s2,-1250 # 14e0 <freep>
  if(p == (char*)-1)
 9ca:	5afd                	li	s5,-1
 9cc:	a091                	j	a10 <malloc+0x9a>
 9ce:	f04a                	sd	s2,32(sp)
 9d0:	e852                	sd	s4,16(sp)
 9d2:	e456                	sd	s5,8(sp)
 9d4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9d6:	00001797          	auipc	a5,0x1
 9da:	f1a78793          	add	a5,a5,-230 # 18f0 <base>
 9de:	00001717          	auipc	a4,0x1
 9e2:	b0f73123          	sd	a5,-1278(a4) # 14e0 <freep>
 9e6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9e8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ec:	b7c1                	j	9ac <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9ee:	6398                	ld	a4,0(a5)
 9f0:	e118                	sd	a4,0(a0)
 9f2:	a08d                	j	a54 <malloc+0xde>
  hp->s.size = nu;
 9f4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9f8:	0541                	add	a0,a0,16
 9fa:	00000097          	auipc	ra,0x0
 9fe:	efa080e7          	jalr	-262(ra) # 8f4 <free>
  return freep;
 a02:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a06:	c13d                	beqz	a0,a6c <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a08:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a0a:	4798                	lw	a4,8(a5)
 a0c:	02977463          	bgeu	a4,s1,a34 <malloc+0xbe>
    if(p == freep)
 a10:	00093703          	ld	a4,0(s2)
 a14:	853e                	mv	a0,a5
 a16:	fef719e3          	bne	a4,a5,a08 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 a1a:	8552                	mv	a0,s4
 a1c:	00000097          	auipc	ra,0x0
 a20:	bb2080e7          	jalr	-1102(ra) # 5ce <sbrk>
  if(p == (char*)-1)
 a24:	fd5518e3          	bne	a0,s5,9f4 <malloc+0x7e>
        return 0;
 a28:	4501                	li	a0,0
 a2a:	7902                	ld	s2,32(sp)
 a2c:	6a42                	ld	s4,16(sp)
 a2e:	6aa2                	ld	s5,8(sp)
 a30:	6b02                	ld	s6,0(sp)
 a32:	a03d                	j	a60 <malloc+0xea>
 a34:	7902                	ld	s2,32(sp)
 a36:	6a42                	ld	s4,16(sp)
 a38:	6aa2                	ld	s5,8(sp)
 a3a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a3c:	fae489e3          	beq	s1,a4,9ee <malloc+0x78>
        p->s.size -= nunits;
 a40:	4137073b          	subw	a4,a4,s3
 a44:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a46:	02071693          	sll	a3,a4,0x20
 a4a:	01c6d713          	srl	a4,a3,0x1c
 a4e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a50:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a54:	00001717          	auipc	a4,0x1
 a58:	a8a73623          	sd	a0,-1396(a4) # 14e0 <freep>
      return (void*)(p + 1);
 a5c:	01078513          	add	a0,a5,16
  }
}
 a60:	70e2                	ld	ra,56(sp)
 a62:	7442                	ld	s0,48(sp)
 a64:	74a2                	ld	s1,40(sp)
 a66:	69e2                	ld	s3,24(sp)
 a68:	6121                	add	sp,sp,64
 a6a:	8082                	ret
 a6c:	7902                	ld	s2,32(sp)
 a6e:	6a42                	ld	s4,16(sp)
 a70:	6aa2                	ld	s5,8(sp)
 a72:	6b02                	ld	s6,0(sp)
 a74:	b7f5                	j	a60 <malloc+0xea>
