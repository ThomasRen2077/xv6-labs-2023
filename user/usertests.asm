
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	add	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	add	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	sll	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	c72080e7          	jalr	-910(ra) # 5c82 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	c60080e7          	jalr	-928(ra) # 5c82 <open>
    if(fd >= 0){
      2a:	55fd                	li	a1,-1
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	add	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	sll	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	14250513          	add	a0,a0,322 # 6180 <malloc+0x10e>
      46:	00006097          	auipc	ra,0x6
      4a:	f74080e7          	jalr	-140(ra) # 5fba <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	bf2080e7          	jalr	-1038(ra) # 5c42 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000c797          	auipc	a5,0xc
      5c:	8d078793          	add	a5,a5,-1840 # b928 <uninit>
      60:	0000e697          	auipc	a3,0xe
      64:	fd868693          	add	a3,a3,-40 # e038 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	add	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	add	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	add	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	12050513          	add	a0,a0,288 # 61a0 <malloc+0x12e>
      88:	00006097          	auipc	ra,0x6
      8c:	f32080e7          	jalr	-206(ra) # 5fba <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	bb0080e7          	jalr	-1104(ra) # 5c42 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	add	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	add	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	11050513          	add	a0,a0,272 # 61b8 <malloc+0x146>
      b0:	00006097          	auipc	ra,0x6
      b4:	bd2080e7          	jalr	-1070(ra) # 5c82 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	bae080e7          	jalr	-1106(ra) # 5c6a <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	11250513          	add	a0,a0,274 # 61d8 <malloc+0x166>
      ce:	00006097          	auipc	ra,0x6
      d2:	bb4080e7          	jalr	-1100(ra) # 5c82 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	add	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	0da50513          	add	a0,a0,218 # 61c0 <malloc+0x14e>
      ee:	00006097          	auipc	ra,0x6
      f2:	ecc080e7          	jalr	-308(ra) # 5fba <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	b4a080e7          	jalr	-1206(ra) # 5c42 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	0e650513          	add	a0,a0,230 # 61e8 <malloc+0x176>
     10a:	00006097          	auipc	ra,0x6
     10e:	eb0080e7          	jalr	-336(ra) # 5fba <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	b2e080e7          	jalr	-1234(ra) # 5c42 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	add	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	add	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	0e450513          	add	a0,a0,228 # 6210 <malloc+0x19e>
     134:	00006097          	auipc	ra,0x6
     138:	b5e080e7          	jalr	-1186(ra) # 5c92 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	0d050513          	add	a0,a0,208 # 6210 <malloc+0x19e>
     148:	00006097          	auipc	ra,0x6
     14c:	b3a080e7          	jalr	-1222(ra) # 5c82 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	0cc58593          	add	a1,a1,204 # 6220 <malloc+0x1ae>
     15c:	00006097          	auipc	ra,0x6
     160:	b06080e7          	jalr	-1274(ra) # 5c62 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	0a850513          	add	a0,a0,168 # 6210 <malloc+0x19e>
     170:	00006097          	auipc	ra,0x6
     174:	b12080e7          	jalr	-1262(ra) # 5c82 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	0ac58593          	add	a1,a1,172 # 6228 <malloc+0x1b6>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	adc080e7          	jalr	-1316(ra) # 5c62 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	07c50513          	add	a0,a0,124 # 6210 <malloc+0x19e>
     19c:	00006097          	auipc	ra,0x6
     1a0:	af6080e7          	jalr	-1290(ra) # 5c92 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	ac4080e7          	jalr	-1340(ra) # 5c6a <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	aba080e7          	jalr	-1350(ra) # 5c6a <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	add	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	06650513          	add	a0,a0,102 # 6230 <malloc+0x1be>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	de8080e7          	jalr	-536(ra) # 5fba <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	a66080e7          	jalr	-1434(ra) # 5c42 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	add	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	add	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	add	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	a72080e7          	jalr	-1422(ra) # 5c82 <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	a52080e7          	jalr	-1454(ra) # 5c6a <close>
  for(i = 0; i < N; i++){
     220:	2485                	addw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	add	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	a4c080e7          	jalr	-1460(ra) # 5c92 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	add	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	add	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	add	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	fdc50513          	add	a0,a0,-36 # 6258 <malloc+0x1e6>
     284:	00006097          	auipc	ra,0x6
     288:	a0e080e7          	jalr	-1522(ra) # 5c92 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	fc8a8a93          	add	s5,s5,-56 # 6258 <malloc+0x1e6>
      int cc = write(fd, buf, sz);
     298:	0000ea17          	auipc	s4,0xe
     29c:	da0a0a13          	add	s4,s4,-608 # e038 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	add	s6,s6,457 # 31c9 <fourteen+0x155>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	9d6080e7          	jalr	-1578(ra) # 5c82 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	9a4080e7          	jalr	-1628(ra) # 5c62 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	990080e7          	jalr	-1648(ra) # 5c62 <write>
      if(cc != sz){
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	98a080e7          	jalr	-1654(ra) # 5c6a <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	9a8080e7          	jalr	-1624(ra) # 5c92 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	add	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	f5650513          	add	a0,a0,-170 # 6268 <malloc+0x1f6>
     31a:	00006097          	auipc	ra,0x6
     31e:	ca0080e7          	jalr	-864(ra) # 5fba <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	91e080e7          	jalr	-1762(ra) # 5c42 <exit>
      if(cc != sz){
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	f5450513          	add	a0,a0,-172 # 6288 <malloc+0x216>
     33c:	00006097          	auipc	ra,0x6
     340:	c7e080e7          	jalr	-898(ra) # 5fba <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00006097          	auipc	ra,0x6
     34a:	8fc080e7          	jalr	-1796(ra) # 5c42 <exit>

000000000000034e <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     34e:	7179                	add	sp,sp,-48
     350:	f406                	sd	ra,40(sp)
     352:	f022                	sd	s0,32(sp)
     354:	ec26                	sd	s1,24(sp)
     356:	e84a                	sd	s2,16(sp)
     358:	e44e                	sd	s3,8(sp)
     35a:	e052                	sd	s4,0(sp)
     35c:	1800                	add	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     35e:	00006517          	auipc	a0,0x6
     362:	f4250513          	add	a0,a0,-190 # 62a0 <malloc+0x22e>
     366:	00006097          	auipc	ra,0x6
     36a:	92c080e7          	jalr	-1748(ra) # 5c92 <unlink>
     36e:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     372:	00006997          	auipc	s3,0x6
     376:	f2e98993          	add	s3,s3,-210 # 62a0 <malloc+0x22e>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     37a:	5a7d                	li	s4,-1
     37c:	018a5a13          	srl	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     380:	20100593          	li	a1,513
     384:	854e                	mv	a0,s3
     386:	00006097          	auipc	ra,0x6
     38a:	8fc080e7          	jalr	-1796(ra) # 5c82 <open>
     38e:	84aa                	mv	s1,a0
    if(fd < 0){
     390:	06054b63          	bltz	a0,406 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     394:	4605                	li	a2,1
     396:	85d2                	mv	a1,s4
     398:	00006097          	auipc	ra,0x6
     39c:	8ca080e7          	jalr	-1846(ra) # 5c62 <write>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00006097          	auipc	ra,0x6
     3a6:	8c8080e7          	jalr	-1848(ra) # 5c6a <close>
    unlink("junk");
     3aa:	854e                	mv	a0,s3
     3ac:	00006097          	auipc	ra,0x6
     3b0:	8e6080e7          	jalr	-1818(ra) # 5c92 <unlink>
  for(int i = 0; i < assumed_free; i++){
     3b4:	397d                	addw	s2,s2,-1
     3b6:	fc0915e3          	bnez	s2,380 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3ba:	20100593          	li	a1,513
     3be:	00006517          	auipc	a0,0x6
     3c2:	ee250513          	add	a0,a0,-286 # 62a0 <malloc+0x22e>
     3c6:	00006097          	auipc	ra,0x6
     3ca:	8bc080e7          	jalr	-1860(ra) # 5c82 <open>
     3ce:	84aa                	mv	s1,a0
  if(fd < 0){
     3d0:	04054863          	bltz	a0,420 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3d4:	4605                	li	a2,1
     3d6:	00006597          	auipc	a1,0x6
     3da:	e5258593          	add	a1,a1,-430 # 6228 <malloc+0x1b6>
     3de:	00006097          	auipc	ra,0x6
     3e2:	884080e7          	jalr	-1916(ra) # 5c62 <write>
     3e6:	4785                	li	a5,1
     3e8:	04f50963          	beq	a0,a5,43a <badwrite+0xec>
    printf("write failed\n");
     3ec:	00006517          	auipc	a0,0x6
     3f0:	ed450513          	add	a0,a0,-300 # 62c0 <malloc+0x24e>
     3f4:	00006097          	auipc	ra,0x6
     3f8:	bc6080e7          	jalr	-1082(ra) # 5fba <printf>
    exit(1);
     3fc:	4505                	li	a0,1
     3fe:	00006097          	auipc	ra,0x6
     402:	844080e7          	jalr	-1980(ra) # 5c42 <exit>
      printf("open junk failed\n");
     406:	00006517          	auipc	a0,0x6
     40a:	ea250513          	add	a0,a0,-350 # 62a8 <malloc+0x236>
     40e:	00006097          	auipc	ra,0x6
     412:	bac080e7          	jalr	-1108(ra) # 5fba <printf>
      exit(1);
     416:	4505                	li	a0,1
     418:	00006097          	auipc	ra,0x6
     41c:	82a080e7          	jalr	-2006(ra) # 5c42 <exit>
    printf("open junk failed\n");
     420:	00006517          	auipc	a0,0x6
     424:	e8850513          	add	a0,a0,-376 # 62a8 <malloc+0x236>
     428:	00006097          	auipc	ra,0x6
     42c:	b92080e7          	jalr	-1134(ra) # 5fba <printf>
    exit(1);
     430:	4505                	li	a0,1
     432:	00006097          	auipc	ra,0x6
     436:	810080e7          	jalr	-2032(ra) # 5c42 <exit>
  }
  close(fd);
     43a:	8526                	mv	a0,s1
     43c:	00006097          	auipc	ra,0x6
     440:	82e080e7          	jalr	-2002(ra) # 5c6a <close>
  unlink("junk");
     444:	00006517          	auipc	a0,0x6
     448:	e5c50513          	add	a0,a0,-420 # 62a0 <malloc+0x22e>
     44c:	00006097          	auipc	ra,0x6
     450:	846080e7          	jalr	-1978(ra) # 5c92 <unlink>

  exit(0);
     454:	4501                	li	a0,0
     456:	00005097          	auipc	ra,0x5
     45a:	7ec080e7          	jalr	2028(ra) # 5c42 <exit>

000000000000045e <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     45e:	715d                	add	sp,sp,-80
     460:	e486                	sd	ra,72(sp)
     462:	e0a2                	sd	s0,64(sp)
     464:	fc26                	sd	s1,56(sp)
     466:	f84a                	sd	s2,48(sp)
     468:	f44e                	sd	s3,40(sp)
     46a:	0880                	add	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     46c:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     46e:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     472:	40000993          	li	s3,1024
    name[0] = 'z';
     476:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47a:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     47e:	41f4d71b          	sraw	a4,s1,0x1f
     482:	01b7571b          	srlw	a4,a4,0x1b
     486:	009707bb          	addw	a5,a4,s1
     48a:	4057d69b          	sraw	a3,a5,0x5
     48e:	0306869b          	addw	a3,a3,48
     492:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     496:	8bfd                	and	a5,a5,31
     498:	9f99                	subw	a5,a5,a4
     49a:	0307879b          	addw	a5,a5,48
     49e:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a2:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a6:	fb040513          	add	a0,s0,-80
     4aa:	00005097          	auipc	ra,0x5
     4ae:	7e8080e7          	jalr	2024(ra) # 5c92 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4b2:	60200593          	li	a1,1538
     4b6:	fb040513          	add	a0,s0,-80
     4ba:	00005097          	auipc	ra,0x5
     4be:	7c8080e7          	jalr	1992(ra) # 5c82 <open>
    if(fd < 0){
     4c2:	00054963          	bltz	a0,4d4 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c6:	00005097          	auipc	ra,0x5
     4ca:	7a4080e7          	jalr	1956(ra) # 5c6a <close>
  for(int i = 0; i < nzz; i++){
     4ce:	2485                	addw	s1,s1,1
     4d0:	fb3493e3          	bne	s1,s3,476 <outofinodes+0x18>
     4d4:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4d6:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4da:	40000993          	li	s3,1024
    name[0] = 'z';
     4de:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e2:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e6:	41f4d71b          	sraw	a4,s1,0x1f
     4ea:	01b7571b          	srlw	a4,a4,0x1b
     4ee:	009707bb          	addw	a5,a4,s1
     4f2:	4057d69b          	sraw	a3,a5,0x5
     4f6:	0306869b          	addw	a3,a3,48
     4fa:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4fe:	8bfd                	and	a5,a5,31
     500:	9f99                	subw	a5,a5,a4
     502:	0307879b          	addw	a5,a5,48
     506:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50a:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     50e:	fb040513          	add	a0,s0,-80
     512:	00005097          	auipc	ra,0x5
     516:	780080e7          	jalr	1920(ra) # 5c92 <unlink>
  for(int i = 0; i < nzz; i++){
     51a:	2485                	addw	s1,s1,1
     51c:	fd3491e3          	bne	s1,s3,4de <outofinodes+0x80>
  }
}
     520:	60a6                	ld	ra,72(sp)
     522:	6406                	ld	s0,64(sp)
     524:	74e2                	ld	s1,56(sp)
     526:	7942                	ld	s2,48(sp)
     528:	79a2                	ld	s3,40(sp)
     52a:	6161                	add	sp,sp,80
     52c:	8082                	ret

000000000000052e <copyin>:
{
     52e:	715d                	add	sp,sp,-80
     530:	e486                	sd	ra,72(sp)
     532:	e0a2                	sd	s0,64(sp)
     534:	fc26                	sd	s1,56(sp)
     536:	f84a                	sd	s2,48(sp)
     538:	f44e                	sd	s3,40(sp)
     53a:	f052                	sd	s4,32(sp)
     53c:	0880                	add	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     53e:	4785                	li	a5,1
     540:	07fe                	sll	a5,a5,0x1f
     542:	fcf43023          	sd	a5,-64(s0)
     546:	57fd                	li	a5,-1
     548:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     54c:	fc040913          	add	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     550:	00006a17          	auipc	s4,0x6
     554:	d80a0a13          	add	s4,s4,-640 # 62d0 <malloc+0x25e>
    uint64 addr = addrs[ai];
     558:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     55c:	20100593          	li	a1,513
     560:	8552                	mv	a0,s4
     562:	00005097          	auipc	ra,0x5
     566:	720080e7          	jalr	1824(ra) # 5c82 <open>
     56a:	84aa                	mv	s1,a0
    if(fd < 0){
     56c:	08054863          	bltz	a0,5fc <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     570:	6609                	lui	a2,0x2
     572:	85ce                	mv	a1,s3
     574:	00005097          	auipc	ra,0x5
     578:	6ee080e7          	jalr	1774(ra) # 5c62 <write>
    if(n >= 0){
     57c:	08055d63          	bgez	a0,616 <copyin+0xe8>
    close(fd);
     580:	8526                	mv	a0,s1
     582:	00005097          	auipc	ra,0x5
     586:	6e8080e7          	jalr	1768(ra) # 5c6a <close>
    unlink("copyin1");
     58a:	8552                	mv	a0,s4
     58c:	00005097          	auipc	ra,0x5
     590:	706080e7          	jalr	1798(ra) # 5c92 <unlink>
    n = write(1, (char*)addr, 8192);
     594:	6609                	lui	a2,0x2
     596:	85ce                	mv	a1,s3
     598:	4505                	li	a0,1
     59a:	00005097          	auipc	ra,0x5
     59e:	6c8080e7          	jalr	1736(ra) # 5c62 <write>
    if(n > 0){
     5a2:	08a04963          	bgtz	a0,634 <copyin+0x106>
    if(pipe(fds) < 0){
     5a6:	fb840513          	add	a0,s0,-72
     5aa:	00005097          	auipc	ra,0x5
     5ae:	6a8080e7          	jalr	1704(ra) # 5c52 <pipe>
     5b2:	0a054063          	bltz	a0,652 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     5b6:	6609                	lui	a2,0x2
     5b8:	85ce                	mv	a1,s3
     5ba:	fbc42503          	lw	a0,-68(s0)
     5be:	00005097          	auipc	ra,0x5
     5c2:	6a4080e7          	jalr	1700(ra) # 5c62 <write>
    if(n > 0){
     5c6:	0aa04363          	bgtz	a0,66c <copyin+0x13e>
    close(fds[0]);
     5ca:	fb842503          	lw	a0,-72(s0)
     5ce:	00005097          	auipc	ra,0x5
     5d2:	69c080e7          	jalr	1692(ra) # 5c6a <close>
    close(fds[1]);
     5d6:	fbc42503          	lw	a0,-68(s0)
     5da:	00005097          	auipc	ra,0x5
     5de:	690080e7          	jalr	1680(ra) # 5c6a <close>
  for(int ai = 0; ai < 2; ai++){
     5e2:	0921                	add	s2,s2,8
     5e4:	fd040793          	add	a5,s0,-48
     5e8:	f6f918e3          	bne	s2,a5,558 <copyin+0x2a>
}
     5ec:	60a6                	ld	ra,72(sp)
     5ee:	6406                	ld	s0,64(sp)
     5f0:	74e2                	ld	s1,56(sp)
     5f2:	7942                	ld	s2,48(sp)
     5f4:	79a2                	ld	s3,40(sp)
     5f6:	7a02                	ld	s4,32(sp)
     5f8:	6161                	add	sp,sp,80
     5fa:	8082                	ret
      printf("open(copyin1) failed\n");
     5fc:	00006517          	auipc	a0,0x6
     600:	cdc50513          	add	a0,a0,-804 # 62d8 <malloc+0x266>
     604:	00006097          	auipc	ra,0x6
     608:	9b6080e7          	jalr	-1610(ra) # 5fba <printf>
      exit(1);
     60c:	4505                	li	a0,1
     60e:	00005097          	auipc	ra,0x5
     612:	634080e7          	jalr	1588(ra) # 5c42 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     616:	862a                	mv	a2,a0
     618:	85ce                	mv	a1,s3
     61a:	00006517          	auipc	a0,0x6
     61e:	cd650513          	add	a0,a0,-810 # 62f0 <malloc+0x27e>
     622:	00006097          	auipc	ra,0x6
     626:	998080e7          	jalr	-1640(ra) # 5fba <printf>
      exit(1);
     62a:	4505                	li	a0,1
     62c:	00005097          	auipc	ra,0x5
     630:	616080e7          	jalr	1558(ra) # 5c42 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     634:	862a                	mv	a2,a0
     636:	85ce                	mv	a1,s3
     638:	00006517          	auipc	a0,0x6
     63c:	ce850513          	add	a0,a0,-792 # 6320 <malloc+0x2ae>
     640:	00006097          	auipc	ra,0x6
     644:	97a080e7          	jalr	-1670(ra) # 5fba <printf>
      exit(1);
     648:	4505                	li	a0,1
     64a:	00005097          	auipc	ra,0x5
     64e:	5f8080e7          	jalr	1528(ra) # 5c42 <exit>
      printf("pipe() failed\n");
     652:	00006517          	auipc	a0,0x6
     656:	cfe50513          	add	a0,a0,-770 # 6350 <malloc+0x2de>
     65a:	00006097          	auipc	ra,0x6
     65e:	960080e7          	jalr	-1696(ra) # 5fba <printf>
      exit(1);
     662:	4505                	li	a0,1
     664:	00005097          	auipc	ra,0x5
     668:	5de080e7          	jalr	1502(ra) # 5c42 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66c:	862a                	mv	a2,a0
     66e:	85ce                	mv	a1,s3
     670:	00006517          	auipc	a0,0x6
     674:	cf050513          	add	a0,a0,-784 # 6360 <malloc+0x2ee>
     678:	00006097          	auipc	ra,0x6
     67c:	942080e7          	jalr	-1726(ra) # 5fba <printf>
      exit(1);
     680:	4505                	li	a0,1
     682:	00005097          	auipc	ra,0x5
     686:	5c0080e7          	jalr	1472(ra) # 5c42 <exit>

000000000000068a <copyout>:
{
     68a:	711d                	add	sp,sp,-96
     68c:	ec86                	sd	ra,88(sp)
     68e:	e8a2                	sd	s0,80(sp)
     690:	e4a6                	sd	s1,72(sp)
     692:	e0ca                	sd	s2,64(sp)
     694:	fc4e                	sd	s3,56(sp)
     696:	f852                	sd	s4,48(sp)
     698:	f456                	sd	s5,40(sp)
     69a:	f05a                	sd	s6,32(sp)
     69c:	1080                	add	s0,sp,96
  uint64 addrs[] = { 0LL, 0x80000000LL, 0xffffffffffffffff };
     69e:	fa043423          	sd	zero,-88(s0)
     6a2:	4785                	li	a5,1
     6a4:	07fe                	sll	a5,a5,0x1f
     6a6:	faf43823          	sd	a5,-80(s0)
  for(int ai = 0; ai < 2; ai++){
     6aa:	fa840913          	add	s2,s0,-88
     6ae:	fb840b13          	add	s6,s0,-72
    int fd = open("README", 0);
     6b2:	00006a17          	auipc	s4,0x6
     6b6:	cdea0a13          	add	s4,s4,-802 # 6390 <malloc+0x31e>
    n = write(fds[1], "x", 1);
     6ba:	00006a97          	auipc	s5,0x6
     6be:	b6ea8a93          	add	s5,s5,-1170 # 6228 <malloc+0x1b6>
    uint64 addr = addrs[ai];
     6c2:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6c6:	4581                	li	a1,0
     6c8:	8552                	mv	a0,s4
     6ca:	00005097          	auipc	ra,0x5
     6ce:	5b8080e7          	jalr	1464(ra) # 5c82 <open>
     6d2:	84aa                	mv	s1,a0
    if(fd < 0){
     6d4:	08054563          	bltz	a0,75e <copyout+0xd4>
    int n = read(fd, (void*)addr, 8192);
     6d8:	6609                	lui	a2,0x2
     6da:	85ce                	mv	a1,s3
     6dc:	00005097          	auipc	ra,0x5
     6e0:	57e080e7          	jalr	1406(ra) # 5c5a <read>
    if(n > 0){
     6e4:	08a04a63          	bgtz	a0,778 <copyout+0xee>
    close(fd);
     6e8:	8526                	mv	a0,s1
     6ea:	00005097          	auipc	ra,0x5
     6ee:	580080e7          	jalr	1408(ra) # 5c6a <close>
    if(pipe(fds) < 0){
     6f2:	fa040513          	add	a0,s0,-96
     6f6:	00005097          	auipc	ra,0x5
     6fa:	55c080e7          	jalr	1372(ra) # 5c52 <pipe>
     6fe:	08054c63          	bltz	a0,796 <copyout+0x10c>
    n = write(fds[1], "x", 1);
     702:	4605                	li	a2,1
     704:	85d6                	mv	a1,s5
     706:	fa442503          	lw	a0,-92(s0)
     70a:	00005097          	auipc	ra,0x5
     70e:	558080e7          	jalr	1368(ra) # 5c62 <write>
    if(n != 1){
     712:	4785                	li	a5,1
     714:	08f51e63          	bne	a0,a5,7b0 <copyout+0x126>
    n = read(fds[0], (void*)addr, 8192);
     718:	6609                	lui	a2,0x2
     71a:	85ce                	mv	a1,s3
     71c:	fa042503          	lw	a0,-96(s0)
     720:	00005097          	auipc	ra,0x5
     724:	53a080e7          	jalr	1338(ra) # 5c5a <read>
    if(n > 0){
     728:	0aa04163          	bgtz	a0,7ca <copyout+0x140>
    close(fds[0]);
     72c:	fa042503          	lw	a0,-96(s0)
     730:	00005097          	auipc	ra,0x5
     734:	53a080e7          	jalr	1338(ra) # 5c6a <close>
    close(fds[1]);
     738:	fa442503          	lw	a0,-92(s0)
     73c:	00005097          	auipc	ra,0x5
     740:	52e080e7          	jalr	1326(ra) # 5c6a <close>
  for(int ai = 0; ai < 2; ai++){
     744:	0921                	add	s2,s2,8
     746:	f7691ee3          	bne	s2,s6,6c2 <copyout+0x38>
}
     74a:	60e6                	ld	ra,88(sp)
     74c:	6446                	ld	s0,80(sp)
     74e:	64a6                	ld	s1,72(sp)
     750:	6906                	ld	s2,64(sp)
     752:	79e2                	ld	s3,56(sp)
     754:	7a42                	ld	s4,48(sp)
     756:	7aa2                	ld	s5,40(sp)
     758:	7b02                	ld	s6,32(sp)
     75a:	6125                	add	sp,sp,96
     75c:	8082                	ret
      printf("open(README) failed\n");
     75e:	00006517          	auipc	a0,0x6
     762:	c3a50513          	add	a0,a0,-966 # 6398 <malloc+0x326>
     766:	00006097          	auipc	ra,0x6
     76a:	854080e7          	jalr	-1964(ra) # 5fba <printf>
      exit(1);
     76e:	4505                	li	a0,1
     770:	00005097          	auipc	ra,0x5
     774:	4d2080e7          	jalr	1234(ra) # 5c42 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     778:	862a                	mv	a2,a0
     77a:	85ce                	mv	a1,s3
     77c:	00006517          	auipc	a0,0x6
     780:	c3450513          	add	a0,a0,-972 # 63b0 <malloc+0x33e>
     784:	00006097          	auipc	ra,0x6
     788:	836080e7          	jalr	-1994(ra) # 5fba <printf>
      exit(1);
     78c:	4505                	li	a0,1
     78e:	00005097          	auipc	ra,0x5
     792:	4b4080e7          	jalr	1204(ra) # 5c42 <exit>
      printf("pipe() failed\n");
     796:	00006517          	auipc	a0,0x6
     79a:	bba50513          	add	a0,a0,-1094 # 6350 <malloc+0x2de>
     79e:	00006097          	auipc	ra,0x6
     7a2:	81c080e7          	jalr	-2020(ra) # 5fba <printf>
      exit(1);
     7a6:	4505                	li	a0,1
     7a8:	00005097          	auipc	ra,0x5
     7ac:	49a080e7          	jalr	1178(ra) # 5c42 <exit>
      printf("pipe write failed\n");
     7b0:	00006517          	auipc	a0,0x6
     7b4:	c3050513          	add	a0,a0,-976 # 63e0 <malloc+0x36e>
     7b8:	00006097          	auipc	ra,0x6
     7bc:	802080e7          	jalr	-2046(ra) # 5fba <printf>
      exit(1);
     7c0:	4505                	li	a0,1
     7c2:	00005097          	auipc	ra,0x5
     7c6:	480080e7          	jalr	1152(ra) # 5c42 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7ca:	862a                	mv	a2,a0
     7cc:	85ce                	mv	a1,s3
     7ce:	00006517          	auipc	a0,0x6
     7d2:	c2a50513          	add	a0,a0,-982 # 63f8 <malloc+0x386>
     7d6:	00005097          	auipc	ra,0x5
     7da:	7e4080e7          	jalr	2020(ra) # 5fba <printf>
      exit(1);
     7de:	4505                	li	a0,1
     7e0:	00005097          	auipc	ra,0x5
     7e4:	462080e7          	jalr	1122(ra) # 5c42 <exit>

00000000000007e8 <truncate1>:
{
     7e8:	711d                	add	sp,sp,-96
     7ea:	ec86                	sd	ra,88(sp)
     7ec:	e8a2                	sd	s0,80(sp)
     7ee:	e4a6                	sd	s1,72(sp)
     7f0:	e0ca                	sd	s2,64(sp)
     7f2:	fc4e                	sd	s3,56(sp)
     7f4:	f852                	sd	s4,48(sp)
     7f6:	f456                	sd	s5,40(sp)
     7f8:	1080                	add	s0,sp,96
     7fa:	8aaa                	mv	s5,a0
  unlink("truncfile");
     7fc:	00006517          	auipc	a0,0x6
     800:	a1450513          	add	a0,a0,-1516 # 6210 <malloc+0x19e>
     804:	00005097          	auipc	ra,0x5
     808:	48e080e7          	jalr	1166(ra) # 5c92 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     80c:	60100593          	li	a1,1537
     810:	00006517          	auipc	a0,0x6
     814:	a0050513          	add	a0,a0,-1536 # 6210 <malloc+0x19e>
     818:	00005097          	auipc	ra,0x5
     81c:	46a080e7          	jalr	1130(ra) # 5c82 <open>
     820:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     822:	4611                	li	a2,4
     824:	00006597          	auipc	a1,0x6
     828:	9fc58593          	add	a1,a1,-1540 # 6220 <malloc+0x1ae>
     82c:	00005097          	auipc	ra,0x5
     830:	436080e7          	jalr	1078(ra) # 5c62 <write>
  close(fd1);
     834:	8526                	mv	a0,s1
     836:	00005097          	auipc	ra,0x5
     83a:	434080e7          	jalr	1076(ra) # 5c6a <close>
  int fd2 = open("truncfile", O_RDONLY);
     83e:	4581                	li	a1,0
     840:	00006517          	auipc	a0,0x6
     844:	9d050513          	add	a0,a0,-1584 # 6210 <malloc+0x19e>
     848:	00005097          	auipc	ra,0x5
     84c:	43a080e7          	jalr	1082(ra) # 5c82 <open>
     850:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     852:	02000613          	li	a2,32
     856:	fa040593          	add	a1,s0,-96
     85a:	00005097          	auipc	ra,0x5
     85e:	400080e7          	jalr	1024(ra) # 5c5a <read>
  if(n != 4){
     862:	4791                	li	a5,4
     864:	0cf51e63          	bne	a0,a5,940 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     868:	40100593          	li	a1,1025
     86c:	00006517          	auipc	a0,0x6
     870:	9a450513          	add	a0,a0,-1628 # 6210 <malloc+0x19e>
     874:	00005097          	auipc	ra,0x5
     878:	40e080e7          	jalr	1038(ra) # 5c82 <open>
     87c:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     87e:	4581                	li	a1,0
     880:	00006517          	auipc	a0,0x6
     884:	99050513          	add	a0,a0,-1648 # 6210 <malloc+0x19e>
     888:	00005097          	auipc	ra,0x5
     88c:	3fa080e7          	jalr	1018(ra) # 5c82 <open>
     890:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     892:	02000613          	li	a2,32
     896:	fa040593          	add	a1,s0,-96
     89a:	00005097          	auipc	ra,0x5
     89e:	3c0080e7          	jalr	960(ra) # 5c5a <read>
     8a2:	8a2a                	mv	s4,a0
  if(n != 0){
     8a4:	ed4d                	bnez	a0,95e <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8a6:	02000613          	li	a2,32
     8aa:	fa040593          	add	a1,s0,-96
     8ae:	8526                	mv	a0,s1
     8b0:	00005097          	auipc	ra,0x5
     8b4:	3aa080e7          	jalr	938(ra) # 5c5a <read>
     8b8:	8a2a                	mv	s4,a0
  if(n != 0){
     8ba:	e971                	bnez	a0,98e <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8bc:	4619                	li	a2,6
     8be:	00006597          	auipc	a1,0x6
     8c2:	bca58593          	add	a1,a1,-1078 # 6488 <malloc+0x416>
     8c6:	854e                	mv	a0,s3
     8c8:	00005097          	auipc	ra,0x5
     8cc:	39a080e7          	jalr	922(ra) # 5c62 <write>
  n = read(fd3, buf, sizeof(buf));
     8d0:	02000613          	li	a2,32
     8d4:	fa040593          	add	a1,s0,-96
     8d8:	854a                	mv	a0,s2
     8da:	00005097          	auipc	ra,0x5
     8de:	380080e7          	jalr	896(ra) # 5c5a <read>
  if(n != 6){
     8e2:	4799                	li	a5,6
     8e4:	0cf51d63          	bne	a0,a5,9be <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8e8:	02000613          	li	a2,32
     8ec:	fa040593          	add	a1,s0,-96
     8f0:	8526                	mv	a0,s1
     8f2:	00005097          	auipc	ra,0x5
     8f6:	368080e7          	jalr	872(ra) # 5c5a <read>
  if(n != 2){
     8fa:	4789                	li	a5,2
     8fc:	0ef51063          	bne	a0,a5,9dc <truncate1+0x1f4>
  unlink("truncfile");
     900:	00006517          	auipc	a0,0x6
     904:	91050513          	add	a0,a0,-1776 # 6210 <malloc+0x19e>
     908:	00005097          	auipc	ra,0x5
     90c:	38a080e7          	jalr	906(ra) # 5c92 <unlink>
  close(fd1);
     910:	854e                	mv	a0,s3
     912:	00005097          	auipc	ra,0x5
     916:	358080e7          	jalr	856(ra) # 5c6a <close>
  close(fd2);
     91a:	8526                	mv	a0,s1
     91c:	00005097          	auipc	ra,0x5
     920:	34e080e7          	jalr	846(ra) # 5c6a <close>
  close(fd3);
     924:	854a                	mv	a0,s2
     926:	00005097          	auipc	ra,0x5
     92a:	344080e7          	jalr	836(ra) # 5c6a <close>
}
     92e:	60e6                	ld	ra,88(sp)
     930:	6446                	ld	s0,80(sp)
     932:	64a6                	ld	s1,72(sp)
     934:	6906                	ld	s2,64(sp)
     936:	79e2                	ld	s3,56(sp)
     938:	7a42                	ld	s4,48(sp)
     93a:	7aa2                	ld	s5,40(sp)
     93c:	6125                	add	sp,sp,96
     93e:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     940:	862a                	mv	a2,a0
     942:	85d6                	mv	a1,s5
     944:	00006517          	auipc	a0,0x6
     948:	ae450513          	add	a0,a0,-1308 # 6428 <malloc+0x3b6>
     94c:	00005097          	auipc	ra,0x5
     950:	66e080e7          	jalr	1646(ra) # 5fba <printf>
    exit(1);
     954:	4505                	li	a0,1
     956:	00005097          	auipc	ra,0x5
     95a:	2ec080e7          	jalr	748(ra) # 5c42 <exit>
    printf("aaa fd3=%d\n", fd3);
     95e:	85ca                	mv	a1,s2
     960:	00006517          	auipc	a0,0x6
     964:	ae850513          	add	a0,a0,-1304 # 6448 <malloc+0x3d6>
     968:	00005097          	auipc	ra,0x5
     96c:	652080e7          	jalr	1618(ra) # 5fba <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     970:	8652                	mv	a2,s4
     972:	85d6                	mv	a1,s5
     974:	00006517          	auipc	a0,0x6
     978:	ae450513          	add	a0,a0,-1308 # 6458 <malloc+0x3e6>
     97c:	00005097          	auipc	ra,0x5
     980:	63e080e7          	jalr	1598(ra) # 5fba <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00005097          	auipc	ra,0x5
     98a:	2bc080e7          	jalr	700(ra) # 5c42 <exit>
    printf("bbb fd2=%d\n", fd2);
     98e:	85a6                	mv	a1,s1
     990:	00006517          	auipc	a0,0x6
     994:	ae850513          	add	a0,a0,-1304 # 6478 <malloc+0x406>
     998:	00005097          	auipc	ra,0x5
     99c:	622080e7          	jalr	1570(ra) # 5fba <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     9a0:	8652                	mv	a2,s4
     9a2:	85d6                	mv	a1,s5
     9a4:	00006517          	auipc	a0,0x6
     9a8:	ab450513          	add	a0,a0,-1356 # 6458 <malloc+0x3e6>
     9ac:	00005097          	auipc	ra,0x5
     9b0:	60e080e7          	jalr	1550(ra) # 5fba <printf>
    exit(1);
     9b4:	4505                	li	a0,1
     9b6:	00005097          	auipc	ra,0x5
     9ba:	28c080e7          	jalr	652(ra) # 5c42 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9be:	862a                	mv	a2,a0
     9c0:	85d6                	mv	a1,s5
     9c2:	00006517          	auipc	a0,0x6
     9c6:	ace50513          	add	a0,a0,-1330 # 6490 <malloc+0x41e>
     9ca:	00005097          	auipc	ra,0x5
     9ce:	5f0080e7          	jalr	1520(ra) # 5fba <printf>
    exit(1);
     9d2:	4505                	li	a0,1
     9d4:	00005097          	auipc	ra,0x5
     9d8:	26e080e7          	jalr	622(ra) # 5c42 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9dc:	862a                	mv	a2,a0
     9de:	85d6                	mv	a1,s5
     9e0:	00006517          	auipc	a0,0x6
     9e4:	ad050513          	add	a0,a0,-1328 # 64b0 <malloc+0x43e>
     9e8:	00005097          	auipc	ra,0x5
     9ec:	5d2080e7          	jalr	1490(ra) # 5fba <printf>
    exit(1);
     9f0:	4505                	li	a0,1
     9f2:	00005097          	auipc	ra,0x5
     9f6:	250080e7          	jalr	592(ra) # 5c42 <exit>

00000000000009fa <writetest>:
{
     9fa:	7139                	add	sp,sp,-64
     9fc:	fc06                	sd	ra,56(sp)
     9fe:	f822                	sd	s0,48(sp)
     a00:	f426                	sd	s1,40(sp)
     a02:	f04a                	sd	s2,32(sp)
     a04:	ec4e                	sd	s3,24(sp)
     a06:	e852                	sd	s4,16(sp)
     a08:	e456                	sd	s5,8(sp)
     a0a:	e05a                	sd	s6,0(sp)
     a0c:	0080                	add	s0,sp,64
     a0e:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a10:	20200593          	li	a1,514
     a14:	00006517          	auipc	a0,0x6
     a18:	abc50513          	add	a0,a0,-1348 # 64d0 <malloc+0x45e>
     a1c:	00005097          	auipc	ra,0x5
     a20:	266080e7          	jalr	614(ra) # 5c82 <open>
  if(fd < 0){
     a24:	0a054d63          	bltz	a0,ade <writetest+0xe4>
     a28:	892a                	mv	s2,a0
     a2a:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a2c:	00006997          	auipc	s3,0x6
     a30:	acc98993          	add	s3,s3,-1332 # 64f8 <malloc+0x486>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a34:	00006a97          	auipc	s5,0x6
     a38:	afca8a93          	add	s5,s5,-1284 # 6530 <malloc+0x4be>
  for(i = 0; i < N; i++){
     a3c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a40:	4629                	li	a2,10
     a42:	85ce                	mv	a1,s3
     a44:	854a                	mv	a0,s2
     a46:	00005097          	auipc	ra,0x5
     a4a:	21c080e7          	jalr	540(ra) # 5c62 <write>
     a4e:	47a9                	li	a5,10
     a50:	0af51563          	bne	a0,a5,afa <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a54:	4629                	li	a2,10
     a56:	85d6                	mv	a1,s5
     a58:	854a                	mv	a0,s2
     a5a:	00005097          	auipc	ra,0x5
     a5e:	208080e7          	jalr	520(ra) # 5c62 <write>
     a62:	47a9                	li	a5,10
     a64:	0af51a63          	bne	a0,a5,b18 <writetest+0x11e>
  for(i = 0; i < N; i++){
     a68:	2485                	addw	s1,s1,1
     a6a:	fd449be3          	bne	s1,s4,a40 <writetest+0x46>
  close(fd);
     a6e:	854a                	mv	a0,s2
     a70:	00005097          	auipc	ra,0x5
     a74:	1fa080e7          	jalr	506(ra) # 5c6a <close>
  fd = open("small", O_RDONLY);
     a78:	4581                	li	a1,0
     a7a:	00006517          	auipc	a0,0x6
     a7e:	a5650513          	add	a0,a0,-1450 # 64d0 <malloc+0x45e>
     a82:	00005097          	auipc	ra,0x5
     a86:	200080e7          	jalr	512(ra) # 5c82 <open>
     a8a:	84aa                	mv	s1,a0
  if(fd < 0){
     a8c:	0a054563          	bltz	a0,b36 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     a90:	7d000613          	li	a2,2000
     a94:	0000d597          	auipc	a1,0xd
     a98:	5a458593          	add	a1,a1,1444 # e038 <buf>
     a9c:	00005097          	auipc	ra,0x5
     aa0:	1be080e7          	jalr	446(ra) # 5c5a <read>
  if(i != N*SZ*2){
     aa4:	7d000793          	li	a5,2000
     aa8:	0af51563          	bne	a0,a5,b52 <writetest+0x158>
  close(fd);
     aac:	8526                	mv	a0,s1
     aae:	00005097          	auipc	ra,0x5
     ab2:	1bc080e7          	jalr	444(ra) # 5c6a <close>
  if(unlink("small") < 0){
     ab6:	00006517          	auipc	a0,0x6
     aba:	a1a50513          	add	a0,a0,-1510 # 64d0 <malloc+0x45e>
     abe:	00005097          	auipc	ra,0x5
     ac2:	1d4080e7          	jalr	468(ra) # 5c92 <unlink>
     ac6:	0a054463          	bltz	a0,b6e <writetest+0x174>
}
     aca:	70e2                	ld	ra,56(sp)
     acc:	7442                	ld	s0,48(sp)
     ace:	74a2                	ld	s1,40(sp)
     ad0:	7902                	ld	s2,32(sp)
     ad2:	69e2                	ld	s3,24(sp)
     ad4:	6a42                	ld	s4,16(sp)
     ad6:	6aa2                	ld	s5,8(sp)
     ad8:	6b02                	ld	s6,0(sp)
     ada:	6121                	add	sp,sp,64
     adc:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     ade:	85da                	mv	a1,s6
     ae0:	00006517          	auipc	a0,0x6
     ae4:	9f850513          	add	a0,a0,-1544 # 64d8 <malloc+0x466>
     ae8:	00005097          	auipc	ra,0x5
     aec:	4d2080e7          	jalr	1234(ra) # 5fba <printf>
    exit(1);
     af0:	4505                	li	a0,1
     af2:	00005097          	auipc	ra,0x5
     af6:	150080e7          	jalr	336(ra) # 5c42 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     afa:	8626                	mv	a2,s1
     afc:	85da                	mv	a1,s6
     afe:	00006517          	auipc	a0,0x6
     b02:	a0a50513          	add	a0,a0,-1526 # 6508 <malloc+0x496>
     b06:	00005097          	auipc	ra,0x5
     b0a:	4b4080e7          	jalr	1204(ra) # 5fba <printf>
      exit(1);
     b0e:	4505                	li	a0,1
     b10:	00005097          	auipc	ra,0x5
     b14:	132080e7          	jalr	306(ra) # 5c42 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b18:	8626                	mv	a2,s1
     b1a:	85da                	mv	a1,s6
     b1c:	00006517          	auipc	a0,0x6
     b20:	a2450513          	add	a0,a0,-1500 # 6540 <malloc+0x4ce>
     b24:	00005097          	auipc	ra,0x5
     b28:	496080e7          	jalr	1174(ra) # 5fba <printf>
      exit(1);
     b2c:	4505                	li	a0,1
     b2e:	00005097          	auipc	ra,0x5
     b32:	114080e7          	jalr	276(ra) # 5c42 <exit>
    printf("%s: error: open small failed!\n", s);
     b36:	85da                	mv	a1,s6
     b38:	00006517          	auipc	a0,0x6
     b3c:	a3050513          	add	a0,a0,-1488 # 6568 <malloc+0x4f6>
     b40:	00005097          	auipc	ra,0x5
     b44:	47a080e7          	jalr	1146(ra) # 5fba <printf>
    exit(1);
     b48:	4505                	li	a0,1
     b4a:	00005097          	auipc	ra,0x5
     b4e:	0f8080e7          	jalr	248(ra) # 5c42 <exit>
    printf("%s: read failed\n", s);
     b52:	85da                	mv	a1,s6
     b54:	00006517          	auipc	a0,0x6
     b58:	a3450513          	add	a0,a0,-1484 # 6588 <malloc+0x516>
     b5c:	00005097          	auipc	ra,0x5
     b60:	45e080e7          	jalr	1118(ra) # 5fba <printf>
    exit(1);
     b64:	4505                	li	a0,1
     b66:	00005097          	auipc	ra,0x5
     b6a:	0dc080e7          	jalr	220(ra) # 5c42 <exit>
    printf("%s: unlink small failed\n", s);
     b6e:	85da                	mv	a1,s6
     b70:	00006517          	auipc	a0,0x6
     b74:	a3050513          	add	a0,a0,-1488 # 65a0 <malloc+0x52e>
     b78:	00005097          	auipc	ra,0x5
     b7c:	442080e7          	jalr	1090(ra) # 5fba <printf>
    exit(1);
     b80:	4505                	li	a0,1
     b82:	00005097          	auipc	ra,0x5
     b86:	0c0080e7          	jalr	192(ra) # 5c42 <exit>

0000000000000b8a <writebig>:
{
     b8a:	7139                	add	sp,sp,-64
     b8c:	fc06                	sd	ra,56(sp)
     b8e:	f822                	sd	s0,48(sp)
     b90:	f426                	sd	s1,40(sp)
     b92:	f04a                	sd	s2,32(sp)
     b94:	ec4e                	sd	s3,24(sp)
     b96:	e852                	sd	s4,16(sp)
     b98:	e456                	sd	s5,8(sp)
     b9a:	0080                	add	s0,sp,64
     b9c:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     b9e:	20200593          	li	a1,514
     ba2:	00006517          	auipc	a0,0x6
     ba6:	a1e50513          	add	a0,a0,-1506 # 65c0 <malloc+0x54e>
     baa:	00005097          	auipc	ra,0x5
     bae:	0d8080e7          	jalr	216(ra) # 5c82 <open>
     bb2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     bb4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     bb6:	0000d917          	auipc	s2,0xd
     bba:	48290913          	add	s2,s2,1154 # e038 <buf>
  for(i = 0; i < MAXFILE; i++){
     bbe:	10c00a13          	li	s4,268
  if(fd < 0){
     bc2:	06054c63          	bltz	a0,c3a <writebig+0xb0>
    ((int*)buf)[0] = i;
     bc6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     bca:	40000613          	li	a2,1024
     bce:	85ca                	mv	a1,s2
     bd0:	854e                	mv	a0,s3
     bd2:	00005097          	auipc	ra,0x5
     bd6:	090080e7          	jalr	144(ra) # 5c62 <write>
     bda:	40000793          	li	a5,1024
     bde:	06f51c63          	bne	a0,a5,c56 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     be2:	2485                	addw	s1,s1,1
     be4:	ff4491e3          	bne	s1,s4,bc6 <writebig+0x3c>
  close(fd);
     be8:	854e                	mv	a0,s3
     bea:	00005097          	auipc	ra,0x5
     bee:	080080e7          	jalr	128(ra) # 5c6a <close>
  fd = open("big", O_RDONLY);
     bf2:	4581                	li	a1,0
     bf4:	00006517          	auipc	a0,0x6
     bf8:	9cc50513          	add	a0,a0,-1588 # 65c0 <malloc+0x54e>
     bfc:	00005097          	auipc	ra,0x5
     c00:	086080e7          	jalr	134(ra) # 5c82 <open>
     c04:	89aa                	mv	s3,a0
  n = 0;
     c06:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c08:	0000d917          	auipc	s2,0xd
     c0c:	43090913          	add	s2,s2,1072 # e038 <buf>
  if(fd < 0){
     c10:	06054263          	bltz	a0,c74 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c14:	40000613          	li	a2,1024
     c18:	85ca                	mv	a1,s2
     c1a:	854e                	mv	a0,s3
     c1c:	00005097          	auipc	ra,0x5
     c20:	03e080e7          	jalr	62(ra) # 5c5a <read>
    if(i == 0){
     c24:	c535                	beqz	a0,c90 <writebig+0x106>
    } else if(i != BSIZE){
     c26:	40000793          	li	a5,1024
     c2a:	0af51f63          	bne	a0,a5,ce8 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     c2e:	00092683          	lw	a3,0(s2)
     c32:	0c969a63          	bne	a3,s1,d06 <writebig+0x17c>
    n++;
     c36:	2485                	addw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c38:	bff1                	j	c14 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c3a:	85d6                	mv	a1,s5
     c3c:	00006517          	auipc	a0,0x6
     c40:	98c50513          	add	a0,a0,-1652 # 65c8 <malloc+0x556>
     c44:	00005097          	auipc	ra,0x5
     c48:	376080e7          	jalr	886(ra) # 5fba <printf>
    exit(1);
     c4c:	4505                	li	a0,1
     c4e:	00005097          	auipc	ra,0x5
     c52:	ff4080e7          	jalr	-12(ra) # 5c42 <exit>
      printf("%s: error: write big file failed\n", s, i);
     c56:	8626                	mv	a2,s1
     c58:	85d6                	mv	a1,s5
     c5a:	00006517          	auipc	a0,0x6
     c5e:	98e50513          	add	a0,a0,-1650 # 65e8 <malloc+0x576>
     c62:	00005097          	auipc	ra,0x5
     c66:	358080e7          	jalr	856(ra) # 5fba <printf>
      exit(1);
     c6a:	4505                	li	a0,1
     c6c:	00005097          	auipc	ra,0x5
     c70:	fd6080e7          	jalr	-42(ra) # 5c42 <exit>
    printf("%s: error: open big failed!\n", s);
     c74:	85d6                	mv	a1,s5
     c76:	00006517          	auipc	a0,0x6
     c7a:	99a50513          	add	a0,a0,-1638 # 6610 <malloc+0x59e>
     c7e:	00005097          	auipc	ra,0x5
     c82:	33c080e7          	jalr	828(ra) # 5fba <printf>
    exit(1);
     c86:	4505                	li	a0,1
     c88:	00005097          	auipc	ra,0x5
     c8c:	fba080e7          	jalr	-70(ra) # 5c42 <exit>
      if(n == MAXFILE - 1){
     c90:	10b00793          	li	a5,267
     c94:	02f48a63          	beq	s1,a5,cc8 <writebig+0x13e>
  close(fd);
     c98:	854e                	mv	a0,s3
     c9a:	00005097          	auipc	ra,0x5
     c9e:	fd0080e7          	jalr	-48(ra) # 5c6a <close>
  if(unlink("big") < 0){
     ca2:	00006517          	auipc	a0,0x6
     ca6:	91e50513          	add	a0,a0,-1762 # 65c0 <malloc+0x54e>
     caa:	00005097          	auipc	ra,0x5
     cae:	fe8080e7          	jalr	-24(ra) # 5c92 <unlink>
     cb2:	06054963          	bltz	a0,d24 <writebig+0x19a>
}
     cb6:	70e2                	ld	ra,56(sp)
     cb8:	7442                	ld	s0,48(sp)
     cba:	74a2                	ld	s1,40(sp)
     cbc:	7902                	ld	s2,32(sp)
     cbe:	69e2                	ld	s3,24(sp)
     cc0:	6a42                	ld	s4,16(sp)
     cc2:	6aa2                	ld	s5,8(sp)
     cc4:	6121                	add	sp,sp,64
     cc6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cc8:	10b00613          	li	a2,267
     ccc:	85d6                	mv	a1,s5
     cce:	00006517          	auipc	a0,0x6
     cd2:	96250513          	add	a0,a0,-1694 # 6630 <malloc+0x5be>
     cd6:	00005097          	auipc	ra,0x5
     cda:	2e4080e7          	jalr	740(ra) # 5fba <printf>
        exit(1);
     cde:	4505                	li	a0,1
     ce0:	00005097          	auipc	ra,0x5
     ce4:	f62080e7          	jalr	-158(ra) # 5c42 <exit>
      printf("%s: read failed %d\n", s, i);
     ce8:	862a                	mv	a2,a0
     cea:	85d6                	mv	a1,s5
     cec:	00006517          	auipc	a0,0x6
     cf0:	96c50513          	add	a0,a0,-1684 # 6658 <malloc+0x5e6>
     cf4:	00005097          	auipc	ra,0x5
     cf8:	2c6080e7          	jalr	710(ra) # 5fba <printf>
      exit(1);
     cfc:	4505                	li	a0,1
     cfe:	00005097          	auipc	ra,0x5
     d02:	f44080e7          	jalr	-188(ra) # 5c42 <exit>
      printf("%s: read content of block %d is %d\n", s,
     d06:	8626                	mv	a2,s1
     d08:	85d6                	mv	a1,s5
     d0a:	00006517          	auipc	a0,0x6
     d0e:	96650513          	add	a0,a0,-1690 # 6670 <malloc+0x5fe>
     d12:	00005097          	auipc	ra,0x5
     d16:	2a8080e7          	jalr	680(ra) # 5fba <printf>
      exit(1);
     d1a:	4505                	li	a0,1
     d1c:	00005097          	auipc	ra,0x5
     d20:	f26080e7          	jalr	-218(ra) # 5c42 <exit>
    printf("%s: unlink big failed\n", s);
     d24:	85d6                	mv	a1,s5
     d26:	00006517          	auipc	a0,0x6
     d2a:	97250513          	add	a0,a0,-1678 # 6698 <malloc+0x626>
     d2e:	00005097          	auipc	ra,0x5
     d32:	28c080e7          	jalr	652(ra) # 5fba <printf>
    exit(1);
     d36:	4505                	li	a0,1
     d38:	00005097          	auipc	ra,0x5
     d3c:	f0a080e7          	jalr	-246(ra) # 5c42 <exit>

0000000000000d40 <unlinkread>:
{
     d40:	7179                	add	sp,sp,-48
     d42:	f406                	sd	ra,40(sp)
     d44:	f022                	sd	s0,32(sp)
     d46:	ec26                	sd	s1,24(sp)
     d48:	e84a                	sd	s2,16(sp)
     d4a:	e44e                	sd	s3,8(sp)
     d4c:	1800                	add	s0,sp,48
     d4e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d50:	20200593          	li	a1,514
     d54:	00006517          	auipc	a0,0x6
     d58:	95c50513          	add	a0,a0,-1700 # 66b0 <malloc+0x63e>
     d5c:	00005097          	auipc	ra,0x5
     d60:	f26080e7          	jalr	-218(ra) # 5c82 <open>
  if(fd < 0){
     d64:	0e054563          	bltz	a0,e4e <unlinkread+0x10e>
     d68:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d6a:	4615                	li	a2,5
     d6c:	00006597          	auipc	a1,0x6
     d70:	97458593          	add	a1,a1,-1676 # 66e0 <malloc+0x66e>
     d74:	00005097          	auipc	ra,0x5
     d78:	eee080e7          	jalr	-274(ra) # 5c62 <write>
  close(fd);
     d7c:	8526                	mv	a0,s1
     d7e:	00005097          	auipc	ra,0x5
     d82:	eec080e7          	jalr	-276(ra) # 5c6a <close>
  fd = open("unlinkread", O_RDWR);
     d86:	4589                	li	a1,2
     d88:	00006517          	auipc	a0,0x6
     d8c:	92850513          	add	a0,a0,-1752 # 66b0 <malloc+0x63e>
     d90:	00005097          	auipc	ra,0x5
     d94:	ef2080e7          	jalr	-270(ra) # 5c82 <open>
     d98:	84aa                	mv	s1,a0
  if(fd < 0){
     d9a:	0c054863          	bltz	a0,e6a <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     d9e:	00006517          	auipc	a0,0x6
     da2:	91250513          	add	a0,a0,-1774 # 66b0 <malloc+0x63e>
     da6:	00005097          	auipc	ra,0x5
     daa:	eec080e7          	jalr	-276(ra) # 5c92 <unlink>
     dae:	ed61                	bnez	a0,e86 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     db0:	20200593          	li	a1,514
     db4:	00006517          	auipc	a0,0x6
     db8:	8fc50513          	add	a0,a0,-1796 # 66b0 <malloc+0x63e>
     dbc:	00005097          	auipc	ra,0x5
     dc0:	ec6080e7          	jalr	-314(ra) # 5c82 <open>
     dc4:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dc6:	460d                	li	a2,3
     dc8:	00006597          	auipc	a1,0x6
     dcc:	96058593          	add	a1,a1,-1696 # 6728 <malloc+0x6b6>
     dd0:	00005097          	auipc	ra,0x5
     dd4:	e92080e7          	jalr	-366(ra) # 5c62 <write>
  close(fd1);
     dd8:	854a                	mv	a0,s2
     dda:	00005097          	auipc	ra,0x5
     dde:	e90080e7          	jalr	-368(ra) # 5c6a <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de2:	660d                	lui	a2,0x3
     de4:	0000d597          	auipc	a1,0xd
     de8:	25458593          	add	a1,a1,596 # e038 <buf>
     dec:	8526                	mv	a0,s1
     dee:	00005097          	auipc	ra,0x5
     df2:	e6c080e7          	jalr	-404(ra) # 5c5a <read>
     df6:	4795                	li	a5,5
     df8:	0af51563          	bne	a0,a5,ea2 <unlinkread+0x162>
  if(buf[0] != 'h'){
     dfc:	0000d717          	auipc	a4,0xd
     e00:	23c74703          	lbu	a4,572(a4) # e038 <buf>
     e04:	06800793          	li	a5,104
     e08:	0af71b63          	bne	a4,a5,ebe <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e0c:	4629                	li	a2,10
     e0e:	0000d597          	auipc	a1,0xd
     e12:	22a58593          	add	a1,a1,554 # e038 <buf>
     e16:	8526                	mv	a0,s1
     e18:	00005097          	auipc	ra,0x5
     e1c:	e4a080e7          	jalr	-438(ra) # 5c62 <write>
     e20:	47a9                	li	a5,10
     e22:	0af51c63          	bne	a0,a5,eda <unlinkread+0x19a>
  close(fd);
     e26:	8526                	mv	a0,s1
     e28:	00005097          	auipc	ra,0x5
     e2c:	e42080e7          	jalr	-446(ra) # 5c6a <close>
  unlink("unlinkread");
     e30:	00006517          	auipc	a0,0x6
     e34:	88050513          	add	a0,a0,-1920 # 66b0 <malloc+0x63e>
     e38:	00005097          	auipc	ra,0x5
     e3c:	e5a080e7          	jalr	-422(ra) # 5c92 <unlink>
}
     e40:	70a2                	ld	ra,40(sp)
     e42:	7402                	ld	s0,32(sp)
     e44:	64e2                	ld	s1,24(sp)
     e46:	6942                	ld	s2,16(sp)
     e48:	69a2                	ld	s3,8(sp)
     e4a:	6145                	add	sp,sp,48
     e4c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e4e:	85ce                	mv	a1,s3
     e50:	00006517          	auipc	a0,0x6
     e54:	87050513          	add	a0,a0,-1936 # 66c0 <malloc+0x64e>
     e58:	00005097          	auipc	ra,0x5
     e5c:	162080e7          	jalr	354(ra) # 5fba <printf>
    exit(1);
     e60:	4505                	li	a0,1
     e62:	00005097          	auipc	ra,0x5
     e66:	de0080e7          	jalr	-544(ra) # 5c42 <exit>
    printf("%s: open unlinkread failed\n", s);
     e6a:	85ce                	mv	a1,s3
     e6c:	00006517          	auipc	a0,0x6
     e70:	87c50513          	add	a0,a0,-1924 # 66e8 <malloc+0x676>
     e74:	00005097          	auipc	ra,0x5
     e78:	146080e7          	jalr	326(ra) # 5fba <printf>
    exit(1);
     e7c:	4505                	li	a0,1
     e7e:	00005097          	auipc	ra,0x5
     e82:	dc4080e7          	jalr	-572(ra) # 5c42 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e86:	85ce                	mv	a1,s3
     e88:	00006517          	auipc	a0,0x6
     e8c:	88050513          	add	a0,a0,-1920 # 6708 <malloc+0x696>
     e90:	00005097          	auipc	ra,0x5
     e94:	12a080e7          	jalr	298(ra) # 5fba <printf>
    exit(1);
     e98:	4505                	li	a0,1
     e9a:	00005097          	auipc	ra,0x5
     e9e:	da8080e7          	jalr	-600(ra) # 5c42 <exit>
    printf("%s: unlinkread read failed", s);
     ea2:	85ce                	mv	a1,s3
     ea4:	00006517          	auipc	a0,0x6
     ea8:	88c50513          	add	a0,a0,-1908 # 6730 <malloc+0x6be>
     eac:	00005097          	auipc	ra,0x5
     eb0:	10e080e7          	jalr	270(ra) # 5fba <printf>
    exit(1);
     eb4:	4505                	li	a0,1
     eb6:	00005097          	auipc	ra,0x5
     eba:	d8c080e7          	jalr	-628(ra) # 5c42 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ebe:	85ce                	mv	a1,s3
     ec0:	00006517          	auipc	a0,0x6
     ec4:	89050513          	add	a0,a0,-1904 # 6750 <malloc+0x6de>
     ec8:	00005097          	auipc	ra,0x5
     ecc:	0f2080e7          	jalr	242(ra) # 5fba <printf>
    exit(1);
     ed0:	4505                	li	a0,1
     ed2:	00005097          	auipc	ra,0x5
     ed6:	d70080e7          	jalr	-656(ra) # 5c42 <exit>
    printf("%s: unlinkread write failed\n", s);
     eda:	85ce                	mv	a1,s3
     edc:	00006517          	auipc	a0,0x6
     ee0:	89450513          	add	a0,a0,-1900 # 6770 <malloc+0x6fe>
     ee4:	00005097          	auipc	ra,0x5
     ee8:	0d6080e7          	jalr	214(ra) # 5fba <printf>
    exit(1);
     eec:	4505                	li	a0,1
     eee:	00005097          	auipc	ra,0x5
     ef2:	d54080e7          	jalr	-684(ra) # 5c42 <exit>

0000000000000ef6 <linktest>:
{
     ef6:	1101                	add	sp,sp,-32
     ef8:	ec06                	sd	ra,24(sp)
     efa:	e822                	sd	s0,16(sp)
     efc:	e426                	sd	s1,8(sp)
     efe:	e04a                	sd	s2,0(sp)
     f00:	1000                	add	s0,sp,32
     f02:	892a                	mv	s2,a0
  unlink("lf1");
     f04:	00006517          	auipc	a0,0x6
     f08:	88c50513          	add	a0,a0,-1908 # 6790 <malloc+0x71e>
     f0c:	00005097          	auipc	ra,0x5
     f10:	d86080e7          	jalr	-634(ra) # 5c92 <unlink>
  unlink("lf2");
     f14:	00006517          	auipc	a0,0x6
     f18:	88450513          	add	a0,a0,-1916 # 6798 <malloc+0x726>
     f1c:	00005097          	auipc	ra,0x5
     f20:	d76080e7          	jalr	-650(ra) # 5c92 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f24:	20200593          	li	a1,514
     f28:	00006517          	auipc	a0,0x6
     f2c:	86850513          	add	a0,a0,-1944 # 6790 <malloc+0x71e>
     f30:	00005097          	auipc	ra,0x5
     f34:	d52080e7          	jalr	-686(ra) # 5c82 <open>
  if(fd < 0){
     f38:	10054763          	bltz	a0,1046 <linktest+0x150>
     f3c:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f3e:	4615                	li	a2,5
     f40:	00005597          	auipc	a1,0x5
     f44:	7a058593          	add	a1,a1,1952 # 66e0 <malloc+0x66e>
     f48:	00005097          	auipc	ra,0x5
     f4c:	d1a080e7          	jalr	-742(ra) # 5c62 <write>
     f50:	4795                	li	a5,5
     f52:	10f51863          	bne	a0,a5,1062 <linktest+0x16c>
  close(fd);
     f56:	8526                	mv	a0,s1
     f58:	00005097          	auipc	ra,0x5
     f5c:	d12080e7          	jalr	-750(ra) # 5c6a <close>
  if(link("lf1", "lf2") < 0){
     f60:	00006597          	auipc	a1,0x6
     f64:	83858593          	add	a1,a1,-1992 # 6798 <malloc+0x726>
     f68:	00006517          	auipc	a0,0x6
     f6c:	82850513          	add	a0,a0,-2008 # 6790 <malloc+0x71e>
     f70:	00005097          	auipc	ra,0x5
     f74:	d32080e7          	jalr	-718(ra) # 5ca2 <link>
     f78:	10054363          	bltz	a0,107e <linktest+0x188>
  unlink("lf1");
     f7c:	00006517          	auipc	a0,0x6
     f80:	81450513          	add	a0,a0,-2028 # 6790 <malloc+0x71e>
     f84:	00005097          	auipc	ra,0x5
     f88:	d0e080e7          	jalr	-754(ra) # 5c92 <unlink>
  if(open("lf1", 0) >= 0){
     f8c:	4581                	li	a1,0
     f8e:	00006517          	auipc	a0,0x6
     f92:	80250513          	add	a0,a0,-2046 # 6790 <malloc+0x71e>
     f96:	00005097          	auipc	ra,0x5
     f9a:	cec080e7          	jalr	-788(ra) # 5c82 <open>
     f9e:	0e055e63          	bgez	a0,109a <linktest+0x1a4>
  fd = open("lf2", 0);
     fa2:	4581                	li	a1,0
     fa4:	00005517          	auipc	a0,0x5
     fa8:	7f450513          	add	a0,a0,2036 # 6798 <malloc+0x726>
     fac:	00005097          	auipc	ra,0x5
     fb0:	cd6080e7          	jalr	-810(ra) # 5c82 <open>
     fb4:	84aa                	mv	s1,a0
  if(fd < 0){
     fb6:	10054063          	bltz	a0,10b6 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     fba:	660d                	lui	a2,0x3
     fbc:	0000d597          	auipc	a1,0xd
     fc0:	07c58593          	add	a1,a1,124 # e038 <buf>
     fc4:	00005097          	auipc	ra,0x5
     fc8:	c96080e7          	jalr	-874(ra) # 5c5a <read>
     fcc:	4795                	li	a5,5
     fce:	10f51263          	bne	a0,a5,10d2 <linktest+0x1dc>
  close(fd);
     fd2:	8526                	mv	a0,s1
     fd4:	00005097          	auipc	ra,0x5
     fd8:	c96080e7          	jalr	-874(ra) # 5c6a <close>
  if(link("lf2", "lf2") >= 0){
     fdc:	00005597          	auipc	a1,0x5
     fe0:	7bc58593          	add	a1,a1,1980 # 6798 <malloc+0x726>
     fe4:	852e                	mv	a0,a1
     fe6:	00005097          	auipc	ra,0x5
     fea:	cbc080e7          	jalr	-836(ra) # 5ca2 <link>
     fee:	10055063          	bgez	a0,10ee <linktest+0x1f8>
  unlink("lf2");
     ff2:	00005517          	auipc	a0,0x5
     ff6:	7a650513          	add	a0,a0,1958 # 6798 <malloc+0x726>
     ffa:	00005097          	auipc	ra,0x5
     ffe:	c98080e7          	jalr	-872(ra) # 5c92 <unlink>
  if(link("lf2", "lf1") >= 0){
    1002:	00005597          	auipc	a1,0x5
    1006:	78e58593          	add	a1,a1,1934 # 6790 <malloc+0x71e>
    100a:	00005517          	auipc	a0,0x5
    100e:	78e50513          	add	a0,a0,1934 # 6798 <malloc+0x726>
    1012:	00005097          	auipc	ra,0x5
    1016:	c90080e7          	jalr	-880(ra) # 5ca2 <link>
    101a:	0e055863          	bgez	a0,110a <linktest+0x214>
  if(link(".", "lf1") >= 0){
    101e:	00005597          	auipc	a1,0x5
    1022:	77258593          	add	a1,a1,1906 # 6790 <malloc+0x71e>
    1026:	00006517          	auipc	a0,0x6
    102a:	87a50513          	add	a0,a0,-1926 # 68a0 <malloc+0x82e>
    102e:	00005097          	auipc	ra,0x5
    1032:	c74080e7          	jalr	-908(ra) # 5ca2 <link>
    1036:	0e055863          	bgez	a0,1126 <linktest+0x230>
}
    103a:	60e2                	ld	ra,24(sp)
    103c:	6442                	ld	s0,16(sp)
    103e:	64a2                	ld	s1,8(sp)
    1040:	6902                	ld	s2,0(sp)
    1042:	6105                	add	sp,sp,32
    1044:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1046:	85ca                	mv	a1,s2
    1048:	00005517          	auipc	a0,0x5
    104c:	75850513          	add	a0,a0,1880 # 67a0 <malloc+0x72e>
    1050:	00005097          	auipc	ra,0x5
    1054:	f6a080e7          	jalr	-150(ra) # 5fba <printf>
    exit(1);
    1058:	4505                	li	a0,1
    105a:	00005097          	auipc	ra,0x5
    105e:	be8080e7          	jalr	-1048(ra) # 5c42 <exit>
    printf("%s: write lf1 failed\n", s);
    1062:	85ca                	mv	a1,s2
    1064:	00005517          	auipc	a0,0x5
    1068:	75450513          	add	a0,a0,1876 # 67b8 <malloc+0x746>
    106c:	00005097          	auipc	ra,0x5
    1070:	f4e080e7          	jalr	-178(ra) # 5fba <printf>
    exit(1);
    1074:	4505                	li	a0,1
    1076:	00005097          	auipc	ra,0x5
    107a:	bcc080e7          	jalr	-1076(ra) # 5c42 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    107e:	85ca                	mv	a1,s2
    1080:	00005517          	auipc	a0,0x5
    1084:	75050513          	add	a0,a0,1872 # 67d0 <malloc+0x75e>
    1088:	00005097          	auipc	ra,0x5
    108c:	f32080e7          	jalr	-206(ra) # 5fba <printf>
    exit(1);
    1090:	4505                	li	a0,1
    1092:	00005097          	auipc	ra,0x5
    1096:	bb0080e7          	jalr	-1104(ra) # 5c42 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    109a:	85ca                	mv	a1,s2
    109c:	00005517          	auipc	a0,0x5
    10a0:	75450513          	add	a0,a0,1876 # 67f0 <malloc+0x77e>
    10a4:	00005097          	auipc	ra,0x5
    10a8:	f16080e7          	jalr	-234(ra) # 5fba <printf>
    exit(1);
    10ac:	4505                	li	a0,1
    10ae:	00005097          	auipc	ra,0x5
    10b2:	b94080e7          	jalr	-1132(ra) # 5c42 <exit>
    printf("%s: open lf2 failed\n", s);
    10b6:	85ca                	mv	a1,s2
    10b8:	00005517          	auipc	a0,0x5
    10bc:	76850513          	add	a0,a0,1896 # 6820 <malloc+0x7ae>
    10c0:	00005097          	auipc	ra,0x5
    10c4:	efa080e7          	jalr	-262(ra) # 5fba <printf>
    exit(1);
    10c8:	4505                	li	a0,1
    10ca:	00005097          	auipc	ra,0x5
    10ce:	b78080e7          	jalr	-1160(ra) # 5c42 <exit>
    printf("%s: read lf2 failed\n", s);
    10d2:	85ca                	mv	a1,s2
    10d4:	00005517          	auipc	a0,0x5
    10d8:	76450513          	add	a0,a0,1892 # 6838 <malloc+0x7c6>
    10dc:	00005097          	auipc	ra,0x5
    10e0:	ede080e7          	jalr	-290(ra) # 5fba <printf>
    exit(1);
    10e4:	4505                	li	a0,1
    10e6:	00005097          	auipc	ra,0x5
    10ea:	b5c080e7          	jalr	-1188(ra) # 5c42 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10ee:	85ca                	mv	a1,s2
    10f0:	00005517          	auipc	a0,0x5
    10f4:	76050513          	add	a0,a0,1888 # 6850 <malloc+0x7de>
    10f8:	00005097          	auipc	ra,0x5
    10fc:	ec2080e7          	jalr	-318(ra) # 5fba <printf>
    exit(1);
    1100:	4505                	li	a0,1
    1102:	00005097          	auipc	ra,0x5
    1106:	b40080e7          	jalr	-1216(ra) # 5c42 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    110a:	85ca                	mv	a1,s2
    110c:	00005517          	auipc	a0,0x5
    1110:	76c50513          	add	a0,a0,1900 # 6878 <malloc+0x806>
    1114:	00005097          	auipc	ra,0x5
    1118:	ea6080e7          	jalr	-346(ra) # 5fba <printf>
    exit(1);
    111c:	4505                	li	a0,1
    111e:	00005097          	auipc	ra,0x5
    1122:	b24080e7          	jalr	-1244(ra) # 5c42 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1126:	85ca                	mv	a1,s2
    1128:	00005517          	auipc	a0,0x5
    112c:	78050513          	add	a0,a0,1920 # 68a8 <malloc+0x836>
    1130:	00005097          	auipc	ra,0x5
    1134:	e8a080e7          	jalr	-374(ra) # 5fba <printf>
    exit(1);
    1138:	4505                	li	a0,1
    113a:	00005097          	auipc	ra,0x5
    113e:	b08080e7          	jalr	-1272(ra) # 5c42 <exit>

0000000000001142 <validatetest>:
{
    1142:	7139                	add	sp,sp,-64
    1144:	fc06                	sd	ra,56(sp)
    1146:	f822                	sd	s0,48(sp)
    1148:	f426                	sd	s1,40(sp)
    114a:	f04a                	sd	s2,32(sp)
    114c:	ec4e                	sd	s3,24(sp)
    114e:	e852                	sd	s4,16(sp)
    1150:	e456                	sd	s5,8(sp)
    1152:	e05a                	sd	s6,0(sp)
    1154:	0080                	add	s0,sp,64
    1156:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1158:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    115a:	00005997          	auipc	s3,0x5
    115e:	76e98993          	add	s3,s3,1902 # 68c8 <malloc+0x856>
    1162:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1164:	6a85                	lui	s5,0x1
    1166:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    116a:	85a6                	mv	a1,s1
    116c:	854e                	mv	a0,s3
    116e:	00005097          	auipc	ra,0x5
    1172:	b34080e7          	jalr	-1228(ra) # 5ca2 <link>
    1176:	01251f63          	bne	a0,s2,1194 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    117a:	94d6                	add	s1,s1,s5
    117c:	ff4497e3          	bne	s1,s4,116a <validatetest+0x28>
}
    1180:	70e2                	ld	ra,56(sp)
    1182:	7442                	ld	s0,48(sp)
    1184:	74a2                	ld	s1,40(sp)
    1186:	7902                	ld	s2,32(sp)
    1188:	69e2                	ld	s3,24(sp)
    118a:	6a42                	ld	s4,16(sp)
    118c:	6aa2                	ld	s5,8(sp)
    118e:	6b02                	ld	s6,0(sp)
    1190:	6121                	add	sp,sp,64
    1192:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1194:	85da                	mv	a1,s6
    1196:	00005517          	auipc	a0,0x5
    119a:	74250513          	add	a0,a0,1858 # 68d8 <malloc+0x866>
    119e:	00005097          	auipc	ra,0x5
    11a2:	e1c080e7          	jalr	-484(ra) # 5fba <printf>
      exit(1);
    11a6:	4505                	li	a0,1
    11a8:	00005097          	auipc	ra,0x5
    11ac:	a9a080e7          	jalr	-1382(ra) # 5c42 <exit>

00000000000011b0 <bigdir>:
{
    11b0:	715d                	add	sp,sp,-80
    11b2:	e486                	sd	ra,72(sp)
    11b4:	e0a2                	sd	s0,64(sp)
    11b6:	fc26                	sd	s1,56(sp)
    11b8:	f84a                	sd	s2,48(sp)
    11ba:	f44e                	sd	s3,40(sp)
    11bc:	f052                	sd	s4,32(sp)
    11be:	ec56                	sd	s5,24(sp)
    11c0:	e85a                	sd	s6,16(sp)
    11c2:	0880                	add	s0,sp,80
    11c4:	89aa                	mv	s3,a0
  unlink("bd");
    11c6:	00005517          	auipc	a0,0x5
    11ca:	73250513          	add	a0,a0,1842 # 68f8 <malloc+0x886>
    11ce:	00005097          	auipc	ra,0x5
    11d2:	ac4080e7          	jalr	-1340(ra) # 5c92 <unlink>
  fd = open("bd", O_CREATE);
    11d6:	20000593          	li	a1,512
    11da:	00005517          	auipc	a0,0x5
    11de:	71e50513          	add	a0,a0,1822 # 68f8 <malloc+0x886>
    11e2:	00005097          	auipc	ra,0x5
    11e6:	aa0080e7          	jalr	-1376(ra) # 5c82 <open>
  if(fd < 0){
    11ea:	0c054963          	bltz	a0,12bc <bigdir+0x10c>
  close(fd);
    11ee:	00005097          	auipc	ra,0x5
    11f2:	a7c080e7          	jalr	-1412(ra) # 5c6a <close>
  for(i = 0; i < N; i++){
    11f6:	4901                	li	s2,0
    name[0] = 'x';
    11f8:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    11fc:	00005a17          	auipc	s4,0x5
    1200:	6fca0a13          	add	s4,s4,1788 # 68f8 <malloc+0x886>
  for(i = 0; i < N; i++){
    1204:	1f400b13          	li	s6,500
    name[0] = 'x';
    1208:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    120c:	41f9571b          	sraw	a4,s2,0x1f
    1210:	01a7571b          	srlw	a4,a4,0x1a
    1214:	012707bb          	addw	a5,a4,s2
    1218:	4067d69b          	sraw	a3,a5,0x6
    121c:	0306869b          	addw	a3,a3,48
    1220:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1224:	03f7f793          	and	a5,a5,63
    1228:	9f99                	subw	a5,a5,a4
    122a:	0307879b          	addw	a5,a5,48
    122e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1232:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1236:	fb040593          	add	a1,s0,-80
    123a:	8552                	mv	a0,s4
    123c:	00005097          	auipc	ra,0x5
    1240:	a66080e7          	jalr	-1434(ra) # 5ca2 <link>
    1244:	84aa                	mv	s1,a0
    1246:	e949                	bnez	a0,12d8 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1248:	2905                	addw	s2,s2,1
    124a:	fb691fe3          	bne	s2,s6,1208 <bigdir+0x58>
  unlink("bd");
    124e:	00005517          	auipc	a0,0x5
    1252:	6aa50513          	add	a0,a0,1706 # 68f8 <malloc+0x886>
    1256:	00005097          	auipc	ra,0x5
    125a:	a3c080e7          	jalr	-1476(ra) # 5c92 <unlink>
    name[0] = 'x';
    125e:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1262:	1f400a13          	li	s4,500
    name[0] = 'x';
    1266:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    126a:	41f4d71b          	sraw	a4,s1,0x1f
    126e:	01a7571b          	srlw	a4,a4,0x1a
    1272:	009707bb          	addw	a5,a4,s1
    1276:	4067d69b          	sraw	a3,a5,0x6
    127a:	0306869b          	addw	a3,a3,48
    127e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1282:	03f7f793          	and	a5,a5,63
    1286:	9f99                	subw	a5,a5,a4
    1288:	0307879b          	addw	a5,a5,48
    128c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1290:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1294:	fb040513          	add	a0,s0,-80
    1298:	00005097          	auipc	ra,0x5
    129c:	9fa080e7          	jalr	-1542(ra) # 5c92 <unlink>
    12a0:	ed21                	bnez	a0,12f8 <bigdir+0x148>
  for(i = 0; i < N; i++){
    12a2:	2485                	addw	s1,s1,1
    12a4:	fd4491e3          	bne	s1,s4,1266 <bigdir+0xb6>
}
    12a8:	60a6                	ld	ra,72(sp)
    12aa:	6406                	ld	s0,64(sp)
    12ac:	74e2                	ld	s1,56(sp)
    12ae:	7942                	ld	s2,48(sp)
    12b0:	79a2                	ld	s3,40(sp)
    12b2:	7a02                	ld	s4,32(sp)
    12b4:	6ae2                	ld	s5,24(sp)
    12b6:	6b42                	ld	s6,16(sp)
    12b8:	6161                	add	sp,sp,80
    12ba:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12bc:	85ce                	mv	a1,s3
    12be:	00005517          	auipc	a0,0x5
    12c2:	64250513          	add	a0,a0,1602 # 6900 <malloc+0x88e>
    12c6:	00005097          	auipc	ra,0x5
    12ca:	cf4080e7          	jalr	-780(ra) # 5fba <printf>
    exit(1);
    12ce:	4505                	li	a0,1
    12d0:	00005097          	auipc	ra,0x5
    12d4:	972080e7          	jalr	-1678(ra) # 5c42 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12d8:	fb040613          	add	a2,s0,-80
    12dc:	85ce                	mv	a1,s3
    12de:	00005517          	auipc	a0,0x5
    12e2:	64250513          	add	a0,a0,1602 # 6920 <malloc+0x8ae>
    12e6:	00005097          	auipc	ra,0x5
    12ea:	cd4080e7          	jalr	-812(ra) # 5fba <printf>
      exit(1);
    12ee:	4505                	li	a0,1
    12f0:	00005097          	auipc	ra,0x5
    12f4:	952080e7          	jalr	-1710(ra) # 5c42 <exit>
      printf("%s: bigdir unlink failed", s);
    12f8:	85ce                	mv	a1,s3
    12fa:	00005517          	auipc	a0,0x5
    12fe:	64650513          	add	a0,a0,1606 # 6940 <malloc+0x8ce>
    1302:	00005097          	auipc	ra,0x5
    1306:	cb8080e7          	jalr	-840(ra) # 5fba <printf>
      exit(1);
    130a:	4505                	li	a0,1
    130c:	00005097          	auipc	ra,0x5
    1310:	936080e7          	jalr	-1738(ra) # 5c42 <exit>

0000000000001314 <pgbug>:
{
    1314:	7179                	add	sp,sp,-48
    1316:	f406                	sd	ra,40(sp)
    1318:	f022                	sd	s0,32(sp)
    131a:	ec26                	sd	s1,24(sp)
    131c:	1800                	add	s0,sp,48
  argv[0] = 0;
    131e:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1322:	00009497          	auipc	s1,0x9
    1326:	09e48493          	add	s1,s1,158 # a3c0 <big>
    132a:	fd840593          	add	a1,s0,-40
    132e:	6088                	ld	a0,0(s1)
    1330:	00005097          	auipc	ra,0x5
    1334:	94a080e7          	jalr	-1718(ra) # 5c7a <exec>
  pipe(big);
    1338:	6088                	ld	a0,0(s1)
    133a:	00005097          	auipc	ra,0x5
    133e:	918080e7          	jalr	-1768(ra) # 5c52 <pipe>
  exit(0);
    1342:	4501                	li	a0,0
    1344:	00005097          	auipc	ra,0x5
    1348:	8fe080e7          	jalr	-1794(ra) # 5c42 <exit>

000000000000134c <badarg>:
{
    134c:	7139                	add	sp,sp,-64
    134e:	fc06                	sd	ra,56(sp)
    1350:	f822                	sd	s0,48(sp)
    1352:	f426                	sd	s1,40(sp)
    1354:	f04a                	sd	s2,32(sp)
    1356:	ec4e                	sd	s3,24(sp)
    1358:	0080                	add	s0,sp,64
    135a:	64b1                	lui	s1,0xc
    135c:	35048493          	add	s1,s1,848 # c350 <uninit+0xa28>
    argv[0] = (char*)0xffffffff;
    1360:	597d                	li	s2,-1
    1362:	02095913          	srl	s2,s2,0x20
    exec("echo", argv);
    1366:	00005997          	auipc	s3,0x5
    136a:	e5298993          	add	s3,s3,-430 # 61b8 <malloc+0x146>
    argv[0] = (char*)0xffffffff;
    136e:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1372:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1376:	fc040593          	add	a1,s0,-64
    137a:	854e                	mv	a0,s3
    137c:	00005097          	auipc	ra,0x5
    1380:	8fe080e7          	jalr	-1794(ra) # 5c7a <exec>
  for(int i = 0; i < 50000; i++){
    1384:	34fd                	addw	s1,s1,-1
    1386:	f4e5                	bnez	s1,136e <badarg+0x22>
  exit(0);
    1388:	4501                	li	a0,0
    138a:	00005097          	auipc	ra,0x5
    138e:	8b8080e7          	jalr	-1864(ra) # 5c42 <exit>

0000000000001392 <copyinstr2>:
{
    1392:	7155                	add	sp,sp,-208
    1394:	e586                	sd	ra,200(sp)
    1396:	e1a2                	sd	s0,192(sp)
    1398:	0980                	add	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    139a:	f6840793          	add	a5,s0,-152
    139e:	fe840693          	add	a3,s0,-24
    b[i] = 'x';
    13a2:	07800713          	li	a4,120
    13a6:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    13aa:	0785                	add	a5,a5,1
    13ac:	fed79de3          	bne	a5,a3,13a6 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13b0:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13b4:	f6840513          	add	a0,s0,-152
    13b8:	00005097          	auipc	ra,0x5
    13bc:	8da080e7          	jalr	-1830(ra) # 5c92 <unlink>
  if(ret != -1){
    13c0:	57fd                	li	a5,-1
    13c2:	0ef51063          	bne	a0,a5,14a2 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13c6:	20100593          	li	a1,513
    13ca:	f6840513          	add	a0,s0,-152
    13ce:	00005097          	auipc	ra,0x5
    13d2:	8b4080e7          	jalr	-1868(ra) # 5c82 <open>
  if(fd != -1){
    13d6:	57fd                	li	a5,-1
    13d8:	0ef51563          	bne	a0,a5,14c2 <copyinstr2+0x130>
  ret = link(b, b);
    13dc:	f6840593          	add	a1,s0,-152
    13e0:	852e                	mv	a0,a1
    13e2:	00005097          	auipc	ra,0x5
    13e6:	8c0080e7          	jalr	-1856(ra) # 5ca2 <link>
  if(ret != -1){
    13ea:	57fd                	li	a5,-1
    13ec:	0ef51b63          	bne	a0,a5,14e2 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    13f0:	00006797          	auipc	a5,0x6
    13f4:	7a878793          	add	a5,a5,1960 # 7b98 <malloc+0x1b26>
    13f8:	f4f43c23          	sd	a5,-168(s0)
    13fc:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1400:	f5840593          	add	a1,s0,-168
    1404:	f6840513          	add	a0,s0,-152
    1408:	00005097          	auipc	ra,0x5
    140c:	872080e7          	jalr	-1934(ra) # 5c7a <exec>
  if(ret != -1){
    1410:	57fd                	li	a5,-1
    1412:	0ef51963          	bne	a0,a5,1504 <copyinstr2+0x172>
  int pid = fork();
    1416:	00005097          	auipc	ra,0x5
    141a:	824080e7          	jalr	-2012(ra) # 5c3a <fork>
  if(pid < 0){
    141e:	10054363          	bltz	a0,1524 <copyinstr2+0x192>
  if(pid == 0){
    1422:	12051463          	bnez	a0,154a <copyinstr2+0x1b8>
    1426:	00009797          	auipc	a5,0x9
    142a:	4fa78793          	add	a5,a5,1274 # a920 <big.0>
    142e:	0000a697          	auipc	a3,0xa
    1432:	4f268693          	add	a3,a3,1266 # b920 <big.0+0x1000>
      big[i] = 'x';
    1436:	07800713          	li	a4,120
    143a:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    143e:	0785                	add	a5,a5,1
    1440:	fed79de3          	bne	a5,a3,143a <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1444:	0000a797          	auipc	a5,0xa
    1448:	4c078e23          	sb	zero,1244(a5) # b920 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    144c:	00007797          	auipc	a5,0x7
    1450:	19478793          	add	a5,a5,404 # 85e0 <malloc+0x256e>
    1454:	6390                	ld	a2,0(a5)
    1456:	6794                	ld	a3,8(a5)
    1458:	6b98                	ld	a4,16(a5)
    145a:	6f9c                	ld	a5,24(a5)
    145c:	f2c43823          	sd	a2,-208(s0)
    1460:	f2d43c23          	sd	a3,-200(s0)
    1464:	f4e43023          	sd	a4,-192(s0)
    1468:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    146c:	f3040593          	add	a1,s0,-208
    1470:	00005517          	auipc	a0,0x5
    1474:	d4850513          	add	a0,a0,-696 # 61b8 <malloc+0x146>
    1478:	00005097          	auipc	ra,0x5
    147c:	802080e7          	jalr	-2046(ra) # 5c7a <exec>
    if(ret != -1){
    1480:	57fd                	li	a5,-1
    1482:	0af50e63          	beq	a0,a5,153e <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1486:	55fd                	li	a1,-1
    1488:	00005517          	auipc	a0,0x5
    148c:	56050513          	add	a0,a0,1376 # 69e8 <malloc+0x976>
    1490:	00005097          	auipc	ra,0x5
    1494:	b2a080e7          	jalr	-1238(ra) # 5fba <printf>
      exit(1);
    1498:	4505                	li	a0,1
    149a:	00004097          	auipc	ra,0x4
    149e:	7a8080e7          	jalr	1960(ra) # 5c42 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14a2:	862a                	mv	a2,a0
    14a4:	f6840593          	add	a1,s0,-152
    14a8:	00005517          	auipc	a0,0x5
    14ac:	4b850513          	add	a0,a0,1208 # 6960 <malloc+0x8ee>
    14b0:	00005097          	auipc	ra,0x5
    14b4:	b0a080e7          	jalr	-1270(ra) # 5fba <printf>
    exit(1);
    14b8:	4505                	li	a0,1
    14ba:	00004097          	auipc	ra,0x4
    14be:	788080e7          	jalr	1928(ra) # 5c42 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14c2:	862a                	mv	a2,a0
    14c4:	f6840593          	add	a1,s0,-152
    14c8:	00005517          	auipc	a0,0x5
    14cc:	4b850513          	add	a0,a0,1208 # 6980 <malloc+0x90e>
    14d0:	00005097          	auipc	ra,0x5
    14d4:	aea080e7          	jalr	-1302(ra) # 5fba <printf>
    exit(1);
    14d8:	4505                	li	a0,1
    14da:	00004097          	auipc	ra,0x4
    14de:	768080e7          	jalr	1896(ra) # 5c42 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14e2:	86aa                	mv	a3,a0
    14e4:	f6840613          	add	a2,s0,-152
    14e8:	85b2                	mv	a1,a2
    14ea:	00005517          	auipc	a0,0x5
    14ee:	4b650513          	add	a0,a0,1206 # 69a0 <malloc+0x92e>
    14f2:	00005097          	auipc	ra,0x5
    14f6:	ac8080e7          	jalr	-1336(ra) # 5fba <printf>
    exit(1);
    14fa:	4505                	li	a0,1
    14fc:	00004097          	auipc	ra,0x4
    1500:	746080e7          	jalr	1862(ra) # 5c42 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1504:	567d                	li	a2,-1
    1506:	f6840593          	add	a1,s0,-152
    150a:	00005517          	auipc	a0,0x5
    150e:	4be50513          	add	a0,a0,1214 # 69c8 <malloc+0x956>
    1512:	00005097          	auipc	ra,0x5
    1516:	aa8080e7          	jalr	-1368(ra) # 5fba <printf>
    exit(1);
    151a:	4505                	li	a0,1
    151c:	00004097          	auipc	ra,0x4
    1520:	726080e7          	jalr	1830(ra) # 5c42 <exit>
    printf("fork failed\n");
    1524:	00006517          	auipc	a0,0x6
    1528:	92450513          	add	a0,a0,-1756 # 6e48 <malloc+0xdd6>
    152c:	00005097          	auipc	ra,0x5
    1530:	a8e080e7          	jalr	-1394(ra) # 5fba <printf>
    exit(1);
    1534:	4505                	li	a0,1
    1536:	00004097          	auipc	ra,0x4
    153a:	70c080e7          	jalr	1804(ra) # 5c42 <exit>
    exit(747); // OK
    153e:	2eb00513          	li	a0,747
    1542:	00004097          	auipc	ra,0x4
    1546:	700080e7          	jalr	1792(ra) # 5c42 <exit>
  int st = 0;
    154a:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    154e:	f5440513          	add	a0,s0,-172
    1552:	00004097          	auipc	ra,0x4
    1556:	6f8080e7          	jalr	1784(ra) # 5c4a <wait>
  if(st != 747){
    155a:	f5442703          	lw	a4,-172(s0)
    155e:	2eb00793          	li	a5,747
    1562:	00f71663          	bne	a4,a5,156e <copyinstr2+0x1dc>
}
    1566:	60ae                	ld	ra,200(sp)
    1568:	640e                	ld	s0,192(sp)
    156a:	6169                	add	sp,sp,208
    156c:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    156e:	00005517          	auipc	a0,0x5
    1572:	4a250513          	add	a0,a0,1186 # 6a10 <malloc+0x99e>
    1576:	00005097          	auipc	ra,0x5
    157a:	a44080e7          	jalr	-1468(ra) # 5fba <printf>
    exit(1);
    157e:	4505                	li	a0,1
    1580:	00004097          	auipc	ra,0x4
    1584:	6c2080e7          	jalr	1730(ra) # 5c42 <exit>

0000000000001588 <truncate3>:
{
    1588:	7159                	add	sp,sp,-112
    158a:	f486                	sd	ra,104(sp)
    158c:	f0a2                	sd	s0,96(sp)
    158e:	e8ca                	sd	s2,80(sp)
    1590:	1880                	add	s0,sp,112
    1592:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    1594:	60100593          	li	a1,1537
    1598:	00005517          	auipc	a0,0x5
    159c:	c7850513          	add	a0,a0,-904 # 6210 <malloc+0x19e>
    15a0:	00004097          	auipc	ra,0x4
    15a4:	6e2080e7          	jalr	1762(ra) # 5c82 <open>
    15a8:	00004097          	auipc	ra,0x4
    15ac:	6c2080e7          	jalr	1730(ra) # 5c6a <close>
  pid = fork();
    15b0:	00004097          	auipc	ra,0x4
    15b4:	68a080e7          	jalr	1674(ra) # 5c3a <fork>
  if(pid < 0){
    15b8:	08054463          	bltz	a0,1640 <truncate3+0xb8>
  if(pid == 0){
    15bc:	e16d                	bnez	a0,169e <truncate3+0x116>
    15be:	eca6                	sd	s1,88(sp)
    15c0:	e4ce                	sd	s3,72(sp)
    15c2:	e0d2                	sd	s4,64(sp)
    15c4:	fc56                	sd	s5,56(sp)
    15c6:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15ca:	00005a17          	auipc	s4,0x5
    15ce:	c46a0a13          	add	s4,s4,-954 # 6210 <malloc+0x19e>
      int n = write(fd, "1234567890", 10);
    15d2:	00005a97          	auipc	s5,0x5
    15d6:	49ea8a93          	add	s5,s5,1182 # 6a70 <malloc+0x9fe>
      int fd = open("truncfile", O_WRONLY);
    15da:	4585                	li	a1,1
    15dc:	8552                	mv	a0,s4
    15de:	00004097          	auipc	ra,0x4
    15e2:	6a4080e7          	jalr	1700(ra) # 5c82 <open>
    15e6:	84aa                	mv	s1,a0
      if(fd < 0){
    15e8:	06054e63          	bltz	a0,1664 <truncate3+0xdc>
      int n = write(fd, "1234567890", 10);
    15ec:	4629                	li	a2,10
    15ee:	85d6                	mv	a1,s5
    15f0:	00004097          	auipc	ra,0x4
    15f4:	672080e7          	jalr	1650(ra) # 5c62 <write>
      if(n != 10){
    15f8:	47a9                	li	a5,10
    15fa:	08f51363          	bne	a0,a5,1680 <truncate3+0xf8>
      close(fd);
    15fe:	8526                	mv	a0,s1
    1600:	00004097          	auipc	ra,0x4
    1604:	66a080e7          	jalr	1642(ra) # 5c6a <close>
      fd = open("truncfile", O_RDONLY);
    1608:	4581                	li	a1,0
    160a:	8552                	mv	a0,s4
    160c:	00004097          	auipc	ra,0x4
    1610:	676080e7          	jalr	1654(ra) # 5c82 <open>
    1614:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1616:	02000613          	li	a2,32
    161a:	f9840593          	add	a1,s0,-104
    161e:	00004097          	auipc	ra,0x4
    1622:	63c080e7          	jalr	1596(ra) # 5c5a <read>
      close(fd);
    1626:	8526                	mv	a0,s1
    1628:	00004097          	auipc	ra,0x4
    162c:	642080e7          	jalr	1602(ra) # 5c6a <close>
    for(int i = 0; i < 100; i++){
    1630:	39fd                	addw	s3,s3,-1
    1632:	fa0994e3          	bnez	s3,15da <truncate3+0x52>
    exit(0);
    1636:	4501                	li	a0,0
    1638:	00004097          	auipc	ra,0x4
    163c:	60a080e7          	jalr	1546(ra) # 5c42 <exit>
    1640:	eca6                	sd	s1,88(sp)
    1642:	e4ce                	sd	s3,72(sp)
    1644:	e0d2                	sd	s4,64(sp)
    1646:	fc56                	sd	s5,56(sp)
    printf("%s: fork failed\n", s);
    1648:	85ca                	mv	a1,s2
    164a:	00005517          	auipc	a0,0x5
    164e:	3f650513          	add	a0,a0,1014 # 6a40 <malloc+0x9ce>
    1652:	00005097          	auipc	ra,0x5
    1656:	968080e7          	jalr	-1688(ra) # 5fba <printf>
    exit(1);
    165a:	4505                	li	a0,1
    165c:	00004097          	auipc	ra,0x4
    1660:	5e6080e7          	jalr	1510(ra) # 5c42 <exit>
        printf("%s: open failed\n", s);
    1664:	85ca                	mv	a1,s2
    1666:	00005517          	auipc	a0,0x5
    166a:	3f250513          	add	a0,a0,1010 # 6a58 <malloc+0x9e6>
    166e:	00005097          	auipc	ra,0x5
    1672:	94c080e7          	jalr	-1716(ra) # 5fba <printf>
        exit(1);
    1676:	4505                	li	a0,1
    1678:	00004097          	auipc	ra,0x4
    167c:	5ca080e7          	jalr	1482(ra) # 5c42 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1680:	862a                	mv	a2,a0
    1682:	85ca                	mv	a1,s2
    1684:	00005517          	auipc	a0,0x5
    1688:	3fc50513          	add	a0,a0,1020 # 6a80 <malloc+0xa0e>
    168c:	00005097          	auipc	ra,0x5
    1690:	92e080e7          	jalr	-1746(ra) # 5fba <printf>
        exit(1);
    1694:	4505                	li	a0,1
    1696:	00004097          	auipc	ra,0x4
    169a:	5ac080e7          	jalr	1452(ra) # 5c42 <exit>
    169e:	eca6                	sd	s1,88(sp)
    16a0:	e4ce                	sd	s3,72(sp)
    16a2:	e0d2                	sd	s4,64(sp)
    16a4:	fc56                	sd	s5,56(sp)
    16a6:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16aa:	00005a17          	auipc	s4,0x5
    16ae:	b66a0a13          	add	s4,s4,-1178 # 6210 <malloc+0x19e>
    int n = write(fd, "xxx", 3);
    16b2:	00005a97          	auipc	s5,0x5
    16b6:	3eea8a93          	add	s5,s5,1006 # 6aa0 <malloc+0xa2e>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16ba:	60100593          	li	a1,1537
    16be:	8552                	mv	a0,s4
    16c0:	00004097          	auipc	ra,0x4
    16c4:	5c2080e7          	jalr	1474(ra) # 5c82 <open>
    16c8:	84aa                	mv	s1,a0
    if(fd < 0){
    16ca:	04054763          	bltz	a0,1718 <truncate3+0x190>
    int n = write(fd, "xxx", 3);
    16ce:	460d                	li	a2,3
    16d0:	85d6                	mv	a1,s5
    16d2:	00004097          	auipc	ra,0x4
    16d6:	590080e7          	jalr	1424(ra) # 5c62 <write>
    if(n != 3){
    16da:	478d                	li	a5,3
    16dc:	04f51c63          	bne	a0,a5,1734 <truncate3+0x1ac>
    close(fd);
    16e0:	8526                	mv	a0,s1
    16e2:	00004097          	auipc	ra,0x4
    16e6:	588080e7          	jalr	1416(ra) # 5c6a <close>
  for(int i = 0; i < 150; i++){
    16ea:	39fd                	addw	s3,s3,-1
    16ec:	fc0997e3          	bnez	s3,16ba <truncate3+0x132>
  wait(&xstatus);
    16f0:	fbc40513          	add	a0,s0,-68
    16f4:	00004097          	auipc	ra,0x4
    16f8:	556080e7          	jalr	1366(ra) # 5c4a <wait>
  unlink("truncfile");
    16fc:	00005517          	auipc	a0,0x5
    1700:	b1450513          	add	a0,a0,-1260 # 6210 <malloc+0x19e>
    1704:	00004097          	auipc	ra,0x4
    1708:	58e080e7          	jalr	1422(ra) # 5c92 <unlink>
  exit(xstatus);
    170c:	fbc42503          	lw	a0,-68(s0)
    1710:	00004097          	auipc	ra,0x4
    1714:	532080e7          	jalr	1330(ra) # 5c42 <exit>
      printf("%s: open failed\n", s);
    1718:	85ca                	mv	a1,s2
    171a:	00005517          	auipc	a0,0x5
    171e:	33e50513          	add	a0,a0,830 # 6a58 <malloc+0x9e6>
    1722:	00005097          	auipc	ra,0x5
    1726:	898080e7          	jalr	-1896(ra) # 5fba <printf>
      exit(1);
    172a:	4505                	li	a0,1
    172c:	00004097          	auipc	ra,0x4
    1730:	516080e7          	jalr	1302(ra) # 5c42 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1734:	862a                	mv	a2,a0
    1736:	85ca                	mv	a1,s2
    1738:	00005517          	auipc	a0,0x5
    173c:	37050513          	add	a0,a0,880 # 6aa8 <malloc+0xa36>
    1740:	00005097          	auipc	ra,0x5
    1744:	87a080e7          	jalr	-1926(ra) # 5fba <printf>
      exit(1);
    1748:	4505                	li	a0,1
    174a:	00004097          	auipc	ra,0x4
    174e:	4f8080e7          	jalr	1272(ra) # 5c42 <exit>

0000000000001752 <exectest>:
{
    1752:	715d                	add	sp,sp,-80
    1754:	e486                	sd	ra,72(sp)
    1756:	e0a2                	sd	s0,64(sp)
    1758:	f84a                	sd	s2,48(sp)
    175a:	0880                	add	s0,sp,80
    175c:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    175e:	00005797          	auipc	a5,0x5
    1762:	a5a78793          	add	a5,a5,-1446 # 61b8 <malloc+0x146>
    1766:	fcf43023          	sd	a5,-64(s0)
    176a:	00005797          	auipc	a5,0x5
    176e:	35e78793          	add	a5,a5,862 # 6ac8 <malloc+0xa56>
    1772:	fcf43423          	sd	a5,-56(s0)
    1776:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    177a:	00005517          	auipc	a0,0x5
    177e:	35650513          	add	a0,a0,854 # 6ad0 <malloc+0xa5e>
    1782:	00004097          	auipc	ra,0x4
    1786:	510080e7          	jalr	1296(ra) # 5c92 <unlink>
  pid = fork();
    178a:	00004097          	auipc	ra,0x4
    178e:	4b0080e7          	jalr	1200(ra) # 5c3a <fork>
  if(pid < 0) {
    1792:	04054763          	bltz	a0,17e0 <exectest+0x8e>
    1796:	fc26                	sd	s1,56(sp)
    1798:	84aa                	mv	s1,a0
  if(pid == 0) {
    179a:	ed41                	bnez	a0,1832 <exectest+0xe0>
    close(1);
    179c:	4505                	li	a0,1
    179e:	00004097          	auipc	ra,0x4
    17a2:	4cc080e7          	jalr	1228(ra) # 5c6a <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    17a6:	20100593          	li	a1,513
    17aa:	00005517          	auipc	a0,0x5
    17ae:	32650513          	add	a0,a0,806 # 6ad0 <malloc+0xa5e>
    17b2:	00004097          	auipc	ra,0x4
    17b6:	4d0080e7          	jalr	1232(ra) # 5c82 <open>
    if(fd < 0) {
    17ba:	04054263          	bltz	a0,17fe <exectest+0xac>
    if(fd != 1) {
    17be:	4785                	li	a5,1
    17c0:	04f50d63          	beq	a0,a5,181a <exectest+0xc8>
      printf("%s: wrong fd\n", s);
    17c4:	85ca                	mv	a1,s2
    17c6:	00005517          	auipc	a0,0x5
    17ca:	32a50513          	add	a0,a0,810 # 6af0 <malloc+0xa7e>
    17ce:	00004097          	auipc	ra,0x4
    17d2:	7ec080e7          	jalr	2028(ra) # 5fba <printf>
      exit(1);
    17d6:	4505                	li	a0,1
    17d8:	00004097          	auipc	ra,0x4
    17dc:	46a080e7          	jalr	1130(ra) # 5c42 <exit>
    17e0:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    17e2:	85ca                	mv	a1,s2
    17e4:	00005517          	auipc	a0,0x5
    17e8:	25c50513          	add	a0,a0,604 # 6a40 <malloc+0x9ce>
    17ec:	00004097          	auipc	ra,0x4
    17f0:	7ce080e7          	jalr	1998(ra) # 5fba <printf>
     exit(1);
    17f4:	4505                	li	a0,1
    17f6:	00004097          	auipc	ra,0x4
    17fa:	44c080e7          	jalr	1100(ra) # 5c42 <exit>
      printf("%s: create failed\n", s);
    17fe:	85ca                	mv	a1,s2
    1800:	00005517          	auipc	a0,0x5
    1804:	2d850513          	add	a0,a0,728 # 6ad8 <malloc+0xa66>
    1808:	00004097          	auipc	ra,0x4
    180c:	7b2080e7          	jalr	1970(ra) # 5fba <printf>
      exit(1);
    1810:	4505                	li	a0,1
    1812:	00004097          	auipc	ra,0x4
    1816:	430080e7          	jalr	1072(ra) # 5c42 <exit>
    if(exec("echo", echoargv) < 0){
    181a:	fc040593          	add	a1,s0,-64
    181e:	00005517          	auipc	a0,0x5
    1822:	99a50513          	add	a0,a0,-1638 # 61b8 <malloc+0x146>
    1826:	00004097          	auipc	ra,0x4
    182a:	454080e7          	jalr	1108(ra) # 5c7a <exec>
    182e:	02054163          	bltz	a0,1850 <exectest+0xfe>
  if (wait(&xstatus) != pid) {
    1832:	fdc40513          	add	a0,s0,-36
    1836:	00004097          	auipc	ra,0x4
    183a:	414080e7          	jalr	1044(ra) # 5c4a <wait>
    183e:	02951763          	bne	a0,s1,186c <exectest+0x11a>
  if(xstatus != 0)
    1842:	fdc42503          	lw	a0,-36(s0)
    1846:	cd0d                	beqz	a0,1880 <exectest+0x12e>
    exit(xstatus);
    1848:	00004097          	auipc	ra,0x4
    184c:	3fa080e7          	jalr	1018(ra) # 5c42 <exit>
      printf("%s: exec echo failed\n", s);
    1850:	85ca                	mv	a1,s2
    1852:	00005517          	auipc	a0,0x5
    1856:	2ae50513          	add	a0,a0,686 # 6b00 <malloc+0xa8e>
    185a:	00004097          	auipc	ra,0x4
    185e:	760080e7          	jalr	1888(ra) # 5fba <printf>
      exit(1);
    1862:	4505                	li	a0,1
    1864:	00004097          	auipc	ra,0x4
    1868:	3de080e7          	jalr	990(ra) # 5c42 <exit>
    printf("%s: wait failed!\n", s);
    186c:	85ca                	mv	a1,s2
    186e:	00005517          	auipc	a0,0x5
    1872:	2aa50513          	add	a0,a0,682 # 6b18 <malloc+0xaa6>
    1876:	00004097          	auipc	ra,0x4
    187a:	744080e7          	jalr	1860(ra) # 5fba <printf>
    187e:	b7d1                	j	1842 <exectest+0xf0>
  fd = open("echo-ok", O_RDONLY);
    1880:	4581                	li	a1,0
    1882:	00005517          	auipc	a0,0x5
    1886:	24e50513          	add	a0,a0,590 # 6ad0 <malloc+0xa5e>
    188a:	00004097          	auipc	ra,0x4
    188e:	3f8080e7          	jalr	1016(ra) # 5c82 <open>
  if(fd < 0) {
    1892:	02054a63          	bltz	a0,18c6 <exectest+0x174>
  if (read(fd, buf, 2) != 2) {
    1896:	4609                	li	a2,2
    1898:	fb840593          	add	a1,s0,-72
    189c:	00004097          	auipc	ra,0x4
    18a0:	3be080e7          	jalr	958(ra) # 5c5a <read>
    18a4:	4789                	li	a5,2
    18a6:	02f50e63          	beq	a0,a5,18e2 <exectest+0x190>
    printf("%s: read failed\n", s);
    18aa:	85ca                	mv	a1,s2
    18ac:	00005517          	auipc	a0,0x5
    18b0:	cdc50513          	add	a0,a0,-804 # 6588 <malloc+0x516>
    18b4:	00004097          	auipc	ra,0x4
    18b8:	706080e7          	jalr	1798(ra) # 5fba <printf>
    exit(1);
    18bc:	4505                	li	a0,1
    18be:	00004097          	auipc	ra,0x4
    18c2:	384080e7          	jalr	900(ra) # 5c42 <exit>
    printf("%s: open failed\n", s);
    18c6:	85ca                	mv	a1,s2
    18c8:	00005517          	auipc	a0,0x5
    18cc:	19050513          	add	a0,a0,400 # 6a58 <malloc+0x9e6>
    18d0:	00004097          	auipc	ra,0x4
    18d4:	6ea080e7          	jalr	1770(ra) # 5fba <printf>
    exit(1);
    18d8:	4505                	li	a0,1
    18da:	00004097          	auipc	ra,0x4
    18de:	368080e7          	jalr	872(ra) # 5c42 <exit>
  unlink("echo-ok");
    18e2:	00005517          	auipc	a0,0x5
    18e6:	1ee50513          	add	a0,a0,494 # 6ad0 <malloc+0xa5e>
    18ea:	00004097          	auipc	ra,0x4
    18ee:	3a8080e7          	jalr	936(ra) # 5c92 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    18f2:	fb844703          	lbu	a4,-72(s0)
    18f6:	04f00793          	li	a5,79
    18fa:	00f71863          	bne	a4,a5,190a <exectest+0x1b8>
    18fe:	fb944703          	lbu	a4,-71(s0)
    1902:	04b00793          	li	a5,75
    1906:	02f70063          	beq	a4,a5,1926 <exectest+0x1d4>
    printf("%s: wrong output\n", s);
    190a:	85ca                	mv	a1,s2
    190c:	00005517          	auipc	a0,0x5
    1910:	22450513          	add	a0,a0,548 # 6b30 <malloc+0xabe>
    1914:	00004097          	auipc	ra,0x4
    1918:	6a6080e7          	jalr	1702(ra) # 5fba <printf>
    exit(1);
    191c:	4505                	li	a0,1
    191e:	00004097          	auipc	ra,0x4
    1922:	324080e7          	jalr	804(ra) # 5c42 <exit>
    exit(0);
    1926:	4501                	li	a0,0
    1928:	00004097          	auipc	ra,0x4
    192c:	31a080e7          	jalr	794(ra) # 5c42 <exit>

0000000000001930 <pipe1>:
{
    1930:	711d                	add	sp,sp,-96
    1932:	ec86                	sd	ra,88(sp)
    1934:	e8a2                	sd	s0,80(sp)
    1936:	fc4e                	sd	s3,56(sp)
    1938:	1080                	add	s0,sp,96
    193a:	89aa                	mv	s3,a0
  if(pipe(fds) != 0){
    193c:	fa840513          	add	a0,s0,-88
    1940:	00004097          	auipc	ra,0x4
    1944:	312080e7          	jalr	786(ra) # 5c52 <pipe>
    1948:	ed3d                	bnez	a0,19c6 <pipe1+0x96>
    194a:	e4a6                	sd	s1,72(sp)
    194c:	f852                	sd	s4,48(sp)
    194e:	84aa                	mv	s1,a0
  pid = fork();
    1950:	00004097          	auipc	ra,0x4
    1954:	2ea080e7          	jalr	746(ra) # 5c3a <fork>
    1958:	8a2a                	mv	s4,a0
  if(pid == 0){
    195a:	c951                	beqz	a0,19ee <pipe1+0xbe>
  } else if(pid > 0){
    195c:	18a05b63          	blez	a0,1af2 <pipe1+0x1c2>
    1960:	e0ca                	sd	s2,64(sp)
    1962:	f456                	sd	s5,40(sp)
    close(fds[1]);
    1964:	fac42503          	lw	a0,-84(s0)
    1968:	00004097          	auipc	ra,0x4
    196c:	302080e7          	jalr	770(ra) # 5c6a <close>
    total = 0;
    1970:	8a26                	mv	s4,s1
    cc = 1;
    1972:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    1974:	0000ca97          	auipc	s5,0xc
    1978:	6c4a8a93          	add	s5,s5,1732 # e038 <buf>
    197c:	864a                	mv	a2,s2
    197e:	85d6                	mv	a1,s5
    1980:	fa842503          	lw	a0,-88(s0)
    1984:	00004097          	auipc	ra,0x4
    1988:	2d6080e7          	jalr	726(ra) # 5c5a <read>
    198c:	10a05a63          	blez	a0,1aa0 <pipe1+0x170>
      for(i = 0; i < n; i++){
    1990:	0000c717          	auipc	a4,0xc
    1994:	6a870713          	add	a4,a4,1704 # e038 <buf>
    1998:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    199c:	00074683          	lbu	a3,0(a4)
    19a0:	0ff4f793          	zext.b	a5,s1
    19a4:	2485                	addw	s1,s1,1
    19a6:	0cf69b63          	bne	a3,a5,1a7c <pipe1+0x14c>
      for(i = 0; i < n; i++){
    19aa:	0705                	add	a4,a4,1
    19ac:	fec498e3          	bne	s1,a2,199c <pipe1+0x6c>
      total += n;
    19b0:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19b4:	0019179b          	sllw	a5,s2,0x1
    19b8:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
    19bc:	670d                	lui	a4,0x3
    19be:	fb277fe3          	bgeu	a4,s2,197c <pipe1+0x4c>
        cc = sizeof(buf);
    19c2:	690d                	lui	s2,0x3
    19c4:	bf65                	j	197c <pipe1+0x4c>
    19c6:	e4a6                	sd	s1,72(sp)
    19c8:	e0ca                	sd	s2,64(sp)
    19ca:	f852                	sd	s4,48(sp)
    19cc:	f456                	sd	s5,40(sp)
    19ce:	f05a                	sd	s6,32(sp)
    19d0:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    19d2:	85ce                	mv	a1,s3
    19d4:	00005517          	auipc	a0,0x5
    19d8:	17450513          	add	a0,a0,372 # 6b48 <malloc+0xad6>
    19dc:	00004097          	auipc	ra,0x4
    19e0:	5de080e7          	jalr	1502(ra) # 5fba <printf>
    exit(1);
    19e4:	4505                	li	a0,1
    19e6:	00004097          	auipc	ra,0x4
    19ea:	25c080e7          	jalr	604(ra) # 5c42 <exit>
    19ee:	e0ca                	sd	s2,64(sp)
    19f0:	f456                	sd	s5,40(sp)
    19f2:	f05a                	sd	s6,32(sp)
    19f4:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    19f6:	fa842503          	lw	a0,-88(s0)
    19fa:	00004097          	auipc	ra,0x4
    19fe:	270080e7          	jalr	624(ra) # 5c6a <close>
    for(n = 0; n < N; n++){
    1a02:	0000cb17          	auipc	s6,0xc
    1a06:	636b0b13          	add	s6,s6,1590 # e038 <buf>
    1a0a:	416004bb          	negw	s1,s6
    1a0e:	0ff4f493          	zext.b	s1,s1
    1a12:	409b0913          	add	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a16:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1a18:	6a85                	lui	s5,0x1
    1a1a:	42da8a93          	add	s5,s5,1069 # 142d <copyinstr2+0x9b>
{
    1a1e:	87da                	mv	a5,s6
        buf[i] = seq++;
    1a20:	0097873b          	addw	a4,a5,s1
    1a24:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a28:	0785                	add	a5,a5,1
    1a2a:	ff279be3          	bne	a5,s2,1a20 <pipe1+0xf0>
    1a2e:	409a0a1b          	addw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a32:	40900613          	li	a2,1033
    1a36:	85de                	mv	a1,s7
    1a38:	fac42503          	lw	a0,-84(s0)
    1a3c:	00004097          	auipc	ra,0x4
    1a40:	226080e7          	jalr	550(ra) # 5c62 <write>
    1a44:	40900793          	li	a5,1033
    1a48:	00f51c63          	bne	a0,a5,1a60 <pipe1+0x130>
    for(n = 0; n < N; n++){
    1a4c:	24a5                	addw	s1,s1,9
    1a4e:	0ff4f493          	zext.b	s1,s1
    1a52:	fd5a16e3          	bne	s4,s5,1a1e <pipe1+0xee>
    exit(0);
    1a56:	4501                	li	a0,0
    1a58:	00004097          	auipc	ra,0x4
    1a5c:	1ea080e7          	jalr	490(ra) # 5c42 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a60:	85ce                	mv	a1,s3
    1a62:	00005517          	auipc	a0,0x5
    1a66:	0fe50513          	add	a0,a0,254 # 6b60 <malloc+0xaee>
    1a6a:	00004097          	auipc	ra,0x4
    1a6e:	550080e7          	jalr	1360(ra) # 5fba <printf>
        exit(1);
    1a72:	4505                	li	a0,1
    1a74:	00004097          	auipc	ra,0x4
    1a78:	1ce080e7          	jalr	462(ra) # 5c42 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a7c:	85ce                	mv	a1,s3
    1a7e:	00005517          	auipc	a0,0x5
    1a82:	0fa50513          	add	a0,a0,250 # 6b78 <malloc+0xb06>
    1a86:	00004097          	auipc	ra,0x4
    1a8a:	534080e7          	jalr	1332(ra) # 5fba <printf>
          return;
    1a8e:	64a6                	ld	s1,72(sp)
    1a90:	6906                	ld	s2,64(sp)
    1a92:	7a42                	ld	s4,48(sp)
    1a94:	7aa2                	ld	s5,40(sp)
}
    1a96:	60e6                	ld	ra,88(sp)
    1a98:	6446                	ld	s0,80(sp)
    1a9a:	79e2                	ld	s3,56(sp)
    1a9c:	6125                	add	sp,sp,96
    1a9e:	8082                	ret
    if(total != N * SZ){
    1aa0:	6785                	lui	a5,0x1
    1aa2:	42d78793          	add	a5,a5,1069 # 142d <copyinstr2+0x9b>
    1aa6:	02fa0263          	beq	s4,a5,1aca <pipe1+0x19a>
    1aaa:	f05a                	sd	s6,32(sp)
    1aac:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", total);
    1aae:	85d2                	mv	a1,s4
    1ab0:	00005517          	auipc	a0,0x5
    1ab4:	0e050513          	add	a0,a0,224 # 6b90 <malloc+0xb1e>
    1ab8:	00004097          	auipc	ra,0x4
    1abc:	502080e7          	jalr	1282(ra) # 5fba <printf>
      exit(1);
    1ac0:	4505                	li	a0,1
    1ac2:	00004097          	auipc	ra,0x4
    1ac6:	180080e7          	jalr	384(ra) # 5c42 <exit>
    1aca:	f05a                	sd	s6,32(sp)
    1acc:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1ace:	fa842503          	lw	a0,-88(s0)
    1ad2:	00004097          	auipc	ra,0x4
    1ad6:	198080e7          	jalr	408(ra) # 5c6a <close>
    wait(&xstatus);
    1ada:	fa440513          	add	a0,s0,-92
    1ade:	00004097          	auipc	ra,0x4
    1ae2:	16c080e7          	jalr	364(ra) # 5c4a <wait>
    exit(xstatus);
    1ae6:	fa442503          	lw	a0,-92(s0)
    1aea:	00004097          	auipc	ra,0x4
    1aee:	158080e7          	jalr	344(ra) # 5c42 <exit>
    1af2:	e0ca                	sd	s2,64(sp)
    1af4:	f456                	sd	s5,40(sp)
    1af6:	f05a                	sd	s6,32(sp)
    1af8:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1afa:	85ce                	mv	a1,s3
    1afc:	00005517          	auipc	a0,0x5
    1b00:	0b450513          	add	a0,a0,180 # 6bb0 <malloc+0xb3e>
    1b04:	00004097          	auipc	ra,0x4
    1b08:	4b6080e7          	jalr	1206(ra) # 5fba <printf>
    exit(1);
    1b0c:	4505                	li	a0,1
    1b0e:	00004097          	auipc	ra,0x4
    1b12:	134080e7          	jalr	308(ra) # 5c42 <exit>

0000000000001b16 <exitwait>:
{
    1b16:	7139                	add	sp,sp,-64
    1b18:	fc06                	sd	ra,56(sp)
    1b1a:	f822                	sd	s0,48(sp)
    1b1c:	f426                	sd	s1,40(sp)
    1b1e:	f04a                	sd	s2,32(sp)
    1b20:	ec4e                	sd	s3,24(sp)
    1b22:	e852                	sd	s4,16(sp)
    1b24:	0080                	add	s0,sp,64
    1b26:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1b28:	4901                	li	s2,0
    1b2a:	06400993          	li	s3,100
    pid = fork();
    1b2e:	00004097          	auipc	ra,0x4
    1b32:	10c080e7          	jalr	268(ra) # 5c3a <fork>
    1b36:	84aa                	mv	s1,a0
    if(pid < 0){
    1b38:	02054a63          	bltz	a0,1b6c <exitwait+0x56>
    if(pid){
    1b3c:	c151                	beqz	a0,1bc0 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b3e:	fcc40513          	add	a0,s0,-52
    1b42:	00004097          	auipc	ra,0x4
    1b46:	108080e7          	jalr	264(ra) # 5c4a <wait>
    1b4a:	02951f63          	bne	a0,s1,1b88 <exitwait+0x72>
      if(i != xstate) {
    1b4e:	fcc42783          	lw	a5,-52(s0)
    1b52:	05279963          	bne	a5,s2,1ba4 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b56:	2905                	addw	s2,s2,1 # 3001 <execout+0x51>
    1b58:	fd391be3          	bne	s2,s3,1b2e <exitwait+0x18>
}
    1b5c:	70e2                	ld	ra,56(sp)
    1b5e:	7442                	ld	s0,48(sp)
    1b60:	74a2                	ld	s1,40(sp)
    1b62:	7902                	ld	s2,32(sp)
    1b64:	69e2                	ld	s3,24(sp)
    1b66:	6a42                	ld	s4,16(sp)
    1b68:	6121                	add	sp,sp,64
    1b6a:	8082                	ret
      printf("%s: fork failed\n", s);
    1b6c:	85d2                	mv	a1,s4
    1b6e:	00005517          	auipc	a0,0x5
    1b72:	ed250513          	add	a0,a0,-302 # 6a40 <malloc+0x9ce>
    1b76:	00004097          	auipc	ra,0x4
    1b7a:	444080e7          	jalr	1092(ra) # 5fba <printf>
      exit(1);
    1b7e:	4505                	li	a0,1
    1b80:	00004097          	auipc	ra,0x4
    1b84:	0c2080e7          	jalr	194(ra) # 5c42 <exit>
        printf("%s: wait wrong pid\n", s);
    1b88:	85d2                	mv	a1,s4
    1b8a:	00005517          	auipc	a0,0x5
    1b8e:	03e50513          	add	a0,a0,62 # 6bc8 <malloc+0xb56>
    1b92:	00004097          	auipc	ra,0x4
    1b96:	428080e7          	jalr	1064(ra) # 5fba <printf>
        exit(1);
    1b9a:	4505                	li	a0,1
    1b9c:	00004097          	auipc	ra,0x4
    1ba0:	0a6080e7          	jalr	166(ra) # 5c42 <exit>
        printf("%s: wait wrong exit status\n", s);
    1ba4:	85d2                	mv	a1,s4
    1ba6:	00005517          	auipc	a0,0x5
    1baa:	03a50513          	add	a0,a0,58 # 6be0 <malloc+0xb6e>
    1bae:	00004097          	auipc	ra,0x4
    1bb2:	40c080e7          	jalr	1036(ra) # 5fba <printf>
        exit(1);
    1bb6:	4505                	li	a0,1
    1bb8:	00004097          	auipc	ra,0x4
    1bbc:	08a080e7          	jalr	138(ra) # 5c42 <exit>
      exit(i);
    1bc0:	854a                	mv	a0,s2
    1bc2:	00004097          	auipc	ra,0x4
    1bc6:	080080e7          	jalr	128(ra) # 5c42 <exit>

0000000000001bca <twochildren>:
{
    1bca:	1101                	add	sp,sp,-32
    1bcc:	ec06                	sd	ra,24(sp)
    1bce:	e822                	sd	s0,16(sp)
    1bd0:	e426                	sd	s1,8(sp)
    1bd2:	e04a                	sd	s2,0(sp)
    1bd4:	1000                	add	s0,sp,32
    1bd6:	892a                	mv	s2,a0
    1bd8:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bdc:	00004097          	auipc	ra,0x4
    1be0:	05e080e7          	jalr	94(ra) # 5c3a <fork>
    if(pid1 < 0){
    1be4:	02054c63          	bltz	a0,1c1c <twochildren+0x52>
    if(pid1 == 0){
    1be8:	c921                	beqz	a0,1c38 <twochildren+0x6e>
      int pid2 = fork();
    1bea:	00004097          	auipc	ra,0x4
    1bee:	050080e7          	jalr	80(ra) # 5c3a <fork>
      if(pid2 < 0){
    1bf2:	04054763          	bltz	a0,1c40 <twochildren+0x76>
      if(pid2 == 0){
    1bf6:	c13d                	beqz	a0,1c5c <twochildren+0x92>
        wait(0);
    1bf8:	4501                	li	a0,0
    1bfa:	00004097          	auipc	ra,0x4
    1bfe:	050080e7          	jalr	80(ra) # 5c4a <wait>
        wait(0);
    1c02:	4501                	li	a0,0
    1c04:	00004097          	auipc	ra,0x4
    1c08:	046080e7          	jalr	70(ra) # 5c4a <wait>
  for(int i = 0; i < 1000; i++){
    1c0c:	34fd                	addw	s1,s1,-1
    1c0e:	f4f9                	bnez	s1,1bdc <twochildren+0x12>
}
    1c10:	60e2                	ld	ra,24(sp)
    1c12:	6442                	ld	s0,16(sp)
    1c14:	64a2                	ld	s1,8(sp)
    1c16:	6902                	ld	s2,0(sp)
    1c18:	6105                	add	sp,sp,32
    1c1a:	8082                	ret
      printf("%s: fork failed\n", s);
    1c1c:	85ca                	mv	a1,s2
    1c1e:	00005517          	auipc	a0,0x5
    1c22:	e2250513          	add	a0,a0,-478 # 6a40 <malloc+0x9ce>
    1c26:	00004097          	auipc	ra,0x4
    1c2a:	394080e7          	jalr	916(ra) # 5fba <printf>
      exit(1);
    1c2e:	4505                	li	a0,1
    1c30:	00004097          	auipc	ra,0x4
    1c34:	012080e7          	jalr	18(ra) # 5c42 <exit>
      exit(0);
    1c38:	00004097          	auipc	ra,0x4
    1c3c:	00a080e7          	jalr	10(ra) # 5c42 <exit>
        printf("%s: fork failed\n", s);
    1c40:	85ca                	mv	a1,s2
    1c42:	00005517          	auipc	a0,0x5
    1c46:	dfe50513          	add	a0,a0,-514 # 6a40 <malloc+0x9ce>
    1c4a:	00004097          	auipc	ra,0x4
    1c4e:	370080e7          	jalr	880(ra) # 5fba <printf>
        exit(1);
    1c52:	4505                	li	a0,1
    1c54:	00004097          	auipc	ra,0x4
    1c58:	fee080e7          	jalr	-18(ra) # 5c42 <exit>
        exit(0);
    1c5c:	00004097          	auipc	ra,0x4
    1c60:	fe6080e7          	jalr	-26(ra) # 5c42 <exit>

0000000000001c64 <forkfork>:
{
    1c64:	7179                	add	sp,sp,-48
    1c66:	f406                	sd	ra,40(sp)
    1c68:	f022                	sd	s0,32(sp)
    1c6a:	ec26                	sd	s1,24(sp)
    1c6c:	1800                	add	s0,sp,48
    1c6e:	84aa                	mv	s1,a0
    int pid = fork();
    1c70:	00004097          	auipc	ra,0x4
    1c74:	fca080e7          	jalr	-54(ra) # 5c3a <fork>
    if(pid < 0){
    1c78:	04054163          	bltz	a0,1cba <forkfork+0x56>
    if(pid == 0){
    1c7c:	cd29                	beqz	a0,1cd6 <forkfork+0x72>
    int pid = fork();
    1c7e:	00004097          	auipc	ra,0x4
    1c82:	fbc080e7          	jalr	-68(ra) # 5c3a <fork>
    if(pid < 0){
    1c86:	02054a63          	bltz	a0,1cba <forkfork+0x56>
    if(pid == 0){
    1c8a:	c531                	beqz	a0,1cd6 <forkfork+0x72>
    wait(&xstatus);
    1c8c:	fdc40513          	add	a0,s0,-36
    1c90:	00004097          	auipc	ra,0x4
    1c94:	fba080e7          	jalr	-70(ra) # 5c4a <wait>
    if(xstatus != 0) {
    1c98:	fdc42783          	lw	a5,-36(s0)
    1c9c:	ebbd                	bnez	a5,1d12 <forkfork+0xae>
    wait(&xstatus);
    1c9e:	fdc40513          	add	a0,s0,-36
    1ca2:	00004097          	auipc	ra,0x4
    1ca6:	fa8080e7          	jalr	-88(ra) # 5c4a <wait>
    if(xstatus != 0) {
    1caa:	fdc42783          	lw	a5,-36(s0)
    1cae:	e3b5                	bnez	a5,1d12 <forkfork+0xae>
}
    1cb0:	70a2                	ld	ra,40(sp)
    1cb2:	7402                	ld	s0,32(sp)
    1cb4:	64e2                	ld	s1,24(sp)
    1cb6:	6145                	add	sp,sp,48
    1cb8:	8082                	ret
      printf("%s: fork failed", s);
    1cba:	85a6                	mv	a1,s1
    1cbc:	00005517          	auipc	a0,0x5
    1cc0:	f4450513          	add	a0,a0,-188 # 6c00 <malloc+0xb8e>
    1cc4:	00004097          	auipc	ra,0x4
    1cc8:	2f6080e7          	jalr	758(ra) # 5fba <printf>
      exit(1);
    1ccc:	4505                	li	a0,1
    1cce:	00004097          	auipc	ra,0x4
    1cd2:	f74080e7          	jalr	-140(ra) # 5c42 <exit>
{
    1cd6:	0c800493          	li	s1,200
        int pid1 = fork();
    1cda:	00004097          	auipc	ra,0x4
    1cde:	f60080e7          	jalr	-160(ra) # 5c3a <fork>
        if(pid1 < 0){
    1ce2:	00054f63          	bltz	a0,1d00 <forkfork+0x9c>
        if(pid1 == 0){
    1ce6:	c115                	beqz	a0,1d0a <forkfork+0xa6>
        wait(0);
    1ce8:	4501                	li	a0,0
    1cea:	00004097          	auipc	ra,0x4
    1cee:	f60080e7          	jalr	-160(ra) # 5c4a <wait>
      for(int j = 0; j < 200; j++){
    1cf2:	34fd                	addw	s1,s1,-1
    1cf4:	f0fd                	bnez	s1,1cda <forkfork+0x76>
      exit(0);
    1cf6:	4501                	li	a0,0
    1cf8:	00004097          	auipc	ra,0x4
    1cfc:	f4a080e7          	jalr	-182(ra) # 5c42 <exit>
          exit(1);
    1d00:	4505                	li	a0,1
    1d02:	00004097          	auipc	ra,0x4
    1d06:	f40080e7          	jalr	-192(ra) # 5c42 <exit>
          exit(0);
    1d0a:	00004097          	auipc	ra,0x4
    1d0e:	f38080e7          	jalr	-200(ra) # 5c42 <exit>
      printf("%s: fork in child failed", s);
    1d12:	85a6                	mv	a1,s1
    1d14:	00005517          	auipc	a0,0x5
    1d18:	efc50513          	add	a0,a0,-260 # 6c10 <malloc+0xb9e>
    1d1c:	00004097          	auipc	ra,0x4
    1d20:	29e080e7          	jalr	670(ra) # 5fba <printf>
      exit(1);
    1d24:	4505                	li	a0,1
    1d26:	00004097          	auipc	ra,0x4
    1d2a:	f1c080e7          	jalr	-228(ra) # 5c42 <exit>

0000000000001d2e <reparent2>:
{
    1d2e:	1101                	add	sp,sp,-32
    1d30:	ec06                	sd	ra,24(sp)
    1d32:	e822                	sd	s0,16(sp)
    1d34:	e426                	sd	s1,8(sp)
    1d36:	1000                	add	s0,sp,32
    1d38:	32000493          	li	s1,800
    int pid1 = fork();
    1d3c:	00004097          	auipc	ra,0x4
    1d40:	efe080e7          	jalr	-258(ra) # 5c3a <fork>
    if(pid1 < 0){
    1d44:	00054f63          	bltz	a0,1d62 <reparent2+0x34>
    if(pid1 == 0){
    1d48:	c915                	beqz	a0,1d7c <reparent2+0x4e>
    wait(0);
    1d4a:	4501                	li	a0,0
    1d4c:	00004097          	auipc	ra,0x4
    1d50:	efe080e7          	jalr	-258(ra) # 5c4a <wait>
  for(int i = 0; i < 800; i++){
    1d54:	34fd                	addw	s1,s1,-1
    1d56:	f0fd                	bnez	s1,1d3c <reparent2+0xe>
  exit(0);
    1d58:	4501                	li	a0,0
    1d5a:	00004097          	auipc	ra,0x4
    1d5e:	ee8080e7          	jalr	-280(ra) # 5c42 <exit>
      printf("fork failed\n");
    1d62:	00005517          	auipc	a0,0x5
    1d66:	0e650513          	add	a0,a0,230 # 6e48 <malloc+0xdd6>
    1d6a:	00004097          	auipc	ra,0x4
    1d6e:	250080e7          	jalr	592(ra) # 5fba <printf>
      exit(1);
    1d72:	4505                	li	a0,1
    1d74:	00004097          	auipc	ra,0x4
    1d78:	ece080e7          	jalr	-306(ra) # 5c42 <exit>
      fork();
    1d7c:	00004097          	auipc	ra,0x4
    1d80:	ebe080e7          	jalr	-322(ra) # 5c3a <fork>
      fork();
    1d84:	00004097          	auipc	ra,0x4
    1d88:	eb6080e7          	jalr	-330(ra) # 5c3a <fork>
      exit(0);
    1d8c:	4501                	li	a0,0
    1d8e:	00004097          	auipc	ra,0x4
    1d92:	eb4080e7          	jalr	-332(ra) # 5c42 <exit>

0000000000001d96 <createdelete>:
{
    1d96:	7175                	add	sp,sp,-144
    1d98:	e506                	sd	ra,136(sp)
    1d9a:	e122                	sd	s0,128(sp)
    1d9c:	fca6                	sd	s1,120(sp)
    1d9e:	f8ca                	sd	s2,112(sp)
    1da0:	f4ce                	sd	s3,104(sp)
    1da2:	f0d2                	sd	s4,96(sp)
    1da4:	ecd6                	sd	s5,88(sp)
    1da6:	e8da                	sd	s6,80(sp)
    1da8:	e4de                	sd	s7,72(sp)
    1daa:	e0e2                	sd	s8,64(sp)
    1dac:	fc66                	sd	s9,56(sp)
    1dae:	0900                	add	s0,sp,144
    1db0:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1db2:	4901                	li	s2,0
    1db4:	4991                	li	s3,4
    pid = fork();
    1db6:	00004097          	auipc	ra,0x4
    1dba:	e84080e7          	jalr	-380(ra) # 5c3a <fork>
    1dbe:	84aa                	mv	s1,a0
    if(pid < 0){
    1dc0:	02054f63          	bltz	a0,1dfe <createdelete+0x68>
    if(pid == 0){
    1dc4:	c939                	beqz	a0,1e1a <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1dc6:	2905                	addw	s2,s2,1
    1dc8:	ff3917e3          	bne	s2,s3,1db6 <createdelete+0x20>
    1dcc:	4491                	li	s1,4
    wait(&xstatus);
    1dce:	f7c40513          	add	a0,s0,-132
    1dd2:	00004097          	auipc	ra,0x4
    1dd6:	e78080e7          	jalr	-392(ra) # 5c4a <wait>
    if(xstatus != 0)
    1dda:	f7c42903          	lw	s2,-132(s0)
    1dde:	0e091263          	bnez	s2,1ec2 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1de2:	34fd                	addw	s1,s1,-1
    1de4:	f4ed                	bnez	s1,1dce <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1de6:	f8040123          	sb	zero,-126(s0)
    1dea:	03000993          	li	s3,48
    1dee:	5a7d                	li	s4,-1
    1df0:	07000c13          	li	s8,112
      if((i == 0 || i >= N/2) && fd < 0){
    1df4:	4b25                	li	s6,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1df6:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    1df8:	07400a93          	li	s5,116
    1dfc:	a28d                	j	1f5e <createdelete+0x1c8>
      printf("fork failed\n", s);
    1dfe:	85e6                	mv	a1,s9
    1e00:	00005517          	auipc	a0,0x5
    1e04:	04850513          	add	a0,a0,72 # 6e48 <malloc+0xdd6>
    1e08:	00004097          	auipc	ra,0x4
    1e0c:	1b2080e7          	jalr	434(ra) # 5fba <printf>
      exit(1);
    1e10:	4505                	li	a0,1
    1e12:	00004097          	auipc	ra,0x4
    1e16:	e30080e7          	jalr	-464(ra) # 5c42 <exit>
      name[0] = 'p' + pi;
    1e1a:	0709091b          	addw	s2,s2,112
    1e1e:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1e22:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1e26:	4951                	li	s2,20
    1e28:	a015                	j	1e4c <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1e2a:	85e6                	mv	a1,s9
    1e2c:	00005517          	auipc	a0,0x5
    1e30:	cac50513          	add	a0,a0,-852 # 6ad8 <malloc+0xa66>
    1e34:	00004097          	auipc	ra,0x4
    1e38:	186080e7          	jalr	390(ra) # 5fba <printf>
          exit(1);
    1e3c:	4505                	li	a0,1
    1e3e:	00004097          	auipc	ra,0x4
    1e42:	e04080e7          	jalr	-508(ra) # 5c42 <exit>
      for(i = 0; i < N; i++){
    1e46:	2485                	addw	s1,s1,1
    1e48:	07248863          	beq	s1,s2,1eb8 <createdelete+0x122>
        name[1] = '0' + i;
    1e4c:	0304879b          	addw	a5,s1,48
    1e50:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e54:	20200593          	li	a1,514
    1e58:	f8040513          	add	a0,s0,-128
    1e5c:	00004097          	auipc	ra,0x4
    1e60:	e26080e7          	jalr	-474(ra) # 5c82 <open>
        if(fd < 0){
    1e64:	fc0543e3          	bltz	a0,1e2a <createdelete+0x94>
        close(fd);
    1e68:	00004097          	auipc	ra,0x4
    1e6c:	e02080e7          	jalr	-510(ra) # 5c6a <close>
        if(i > 0 && (i % 2 ) == 0){
    1e70:	12905763          	blez	s1,1f9e <createdelete+0x208>
    1e74:	0014f793          	and	a5,s1,1
    1e78:	f7f9                	bnez	a5,1e46 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e7a:	01f4d79b          	srlw	a5,s1,0x1f
    1e7e:	9fa5                	addw	a5,a5,s1
    1e80:	4017d79b          	sraw	a5,a5,0x1
    1e84:	0307879b          	addw	a5,a5,48
    1e88:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1e8c:	f8040513          	add	a0,s0,-128
    1e90:	00004097          	auipc	ra,0x4
    1e94:	e02080e7          	jalr	-510(ra) # 5c92 <unlink>
    1e98:	fa0557e3          	bgez	a0,1e46 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e9c:	85e6                	mv	a1,s9
    1e9e:	00005517          	auipc	a0,0x5
    1ea2:	d9250513          	add	a0,a0,-622 # 6c30 <malloc+0xbbe>
    1ea6:	00004097          	auipc	ra,0x4
    1eaa:	114080e7          	jalr	276(ra) # 5fba <printf>
            exit(1);
    1eae:	4505                	li	a0,1
    1eb0:	00004097          	auipc	ra,0x4
    1eb4:	d92080e7          	jalr	-622(ra) # 5c42 <exit>
      exit(0);
    1eb8:	4501                	li	a0,0
    1eba:	00004097          	auipc	ra,0x4
    1ebe:	d88080e7          	jalr	-632(ra) # 5c42 <exit>
      exit(1);
    1ec2:	4505                	li	a0,1
    1ec4:	00004097          	auipc	ra,0x4
    1ec8:	d7e080e7          	jalr	-642(ra) # 5c42 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1ecc:	f8040613          	add	a2,s0,-128
    1ed0:	85e6                	mv	a1,s9
    1ed2:	00005517          	auipc	a0,0x5
    1ed6:	d7650513          	add	a0,a0,-650 # 6c48 <malloc+0xbd6>
    1eda:	00004097          	auipc	ra,0x4
    1ede:	0e0080e7          	jalr	224(ra) # 5fba <printf>
        exit(1);
    1ee2:	4505                	li	a0,1
    1ee4:	00004097          	auipc	ra,0x4
    1ee8:	d5e080e7          	jalr	-674(ra) # 5c42 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1eec:	034bff63          	bgeu	s7,s4,1f2a <createdelete+0x194>
      if(fd >= 0)
    1ef0:	02055863          	bgez	a0,1f20 <createdelete+0x18a>
    for(pi = 0; pi < NCHILD; pi++){
    1ef4:	2485                	addw	s1,s1,1
    1ef6:	0ff4f493          	zext.b	s1,s1
    1efa:	05548a63          	beq	s1,s5,1f4e <createdelete+0x1b8>
      name[0] = 'p' + pi;
    1efe:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1f02:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1f06:	4581                	li	a1,0
    1f08:	f8040513          	add	a0,s0,-128
    1f0c:	00004097          	auipc	ra,0x4
    1f10:	d76080e7          	jalr	-650(ra) # 5c82 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1f14:	00090463          	beqz	s2,1f1c <createdelete+0x186>
    1f18:	fd2b5ae3          	bge	s6,s2,1eec <createdelete+0x156>
    1f1c:	fa0548e3          	bltz	a0,1ecc <createdelete+0x136>
        close(fd);
    1f20:	00004097          	auipc	ra,0x4
    1f24:	d4a080e7          	jalr	-694(ra) # 5c6a <close>
    1f28:	b7f1                	j	1ef4 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f2a:	fc0545e3          	bltz	a0,1ef4 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f2e:	f8040613          	add	a2,s0,-128
    1f32:	85e6                	mv	a1,s9
    1f34:	00005517          	auipc	a0,0x5
    1f38:	d3c50513          	add	a0,a0,-708 # 6c70 <malloc+0xbfe>
    1f3c:	00004097          	auipc	ra,0x4
    1f40:	07e080e7          	jalr	126(ra) # 5fba <printf>
        exit(1);
    1f44:	4505                	li	a0,1
    1f46:	00004097          	auipc	ra,0x4
    1f4a:	cfc080e7          	jalr	-772(ra) # 5c42 <exit>
  for(i = 0; i < N; i++){
    1f4e:	2905                	addw	s2,s2,1
    1f50:	2a05                	addw	s4,s4,1
    1f52:	2985                	addw	s3,s3,1
    1f54:	0ff9f993          	zext.b	s3,s3
    1f58:	47d1                	li	a5,20
    1f5a:	02f90a63          	beq	s2,a5,1f8e <createdelete+0x1f8>
    for(pi = 0; pi < NCHILD; pi++){
    1f5e:	84e2                	mv	s1,s8
    1f60:	bf79                	j	1efe <createdelete+0x168>
  for(i = 0; i < N; i++){
    1f62:	2905                	addw	s2,s2,1
    1f64:	0ff97913          	zext.b	s2,s2
    1f68:	2985                	addw	s3,s3,1
    1f6a:	0ff9f993          	zext.b	s3,s3
    1f6e:	03490a63          	beq	s2,s4,1fa2 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f72:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f74:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f78:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f7c:	f8040513          	add	a0,s0,-128
    1f80:	00004097          	auipc	ra,0x4
    1f84:	d12080e7          	jalr	-750(ra) # 5c92 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1f88:	34fd                	addw	s1,s1,-1
    1f8a:	f4ed                	bnez	s1,1f74 <createdelete+0x1de>
    1f8c:	bfd9                	j	1f62 <createdelete+0x1cc>
    1f8e:	03000993          	li	s3,48
    1f92:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f96:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1f98:	08400a13          	li	s4,132
    1f9c:	bfd9                	j	1f72 <createdelete+0x1dc>
      for(i = 0; i < N; i++){
    1f9e:	2485                	addw	s1,s1,1
    1fa0:	b575                	j	1e4c <createdelete+0xb6>
}
    1fa2:	60aa                	ld	ra,136(sp)
    1fa4:	640a                	ld	s0,128(sp)
    1fa6:	74e6                	ld	s1,120(sp)
    1fa8:	7946                	ld	s2,112(sp)
    1faa:	79a6                	ld	s3,104(sp)
    1fac:	7a06                	ld	s4,96(sp)
    1fae:	6ae6                	ld	s5,88(sp)
    1fb0:	6b46                	ld	s6,80(sp)
    1fb2:	6ba6                	ld	s7,72(sp)
    1fb4:	6c06                	ld	s8,64(sp)
    1fb6:	7ce2                	ld	s9,56(sp)
    1fb8:	6149                	add	sp,sp,144
    1fba:	8082                	ret

0000000000001fbc <linkunlink>:
{
    1fbc:	711d                	add	sp,sp,-96
    1fbe:	ec86                	sd	ra,88(sp)
    1fc0:	e8a2                	sd	s0,80(sp)
    1fc2:	e4a6                	sd	s1,72(sp)
    1fc4:	e0ca                	sd	s2,64(sp)
    1fc6:	fc4e                	sd	s3,56(sp)
    1fc8:	f852                	sd	s4,48(sp)
    1fca:	f456                	sd	s5,40(sp)
    1fcc:	f05a                	sd	s6,32(sp)
    1fce:	ec5e                	sd	s7,24(sp)
    1fd0:	e862                	sd	s8,16(sp)
    1fd2:	e466                	sd	s9,8(sp)
    1fd4:	1080                	add	s0,sp,96
    1fd6:	84aa                	mv	s1,a0
  unlink("x");
    1fd8:	00004517          	auipc	a0,0x4
    1fdc:	25050513          	add	a0,a0,592 # 6228 <malloc+0x1b6>
    1fe0:	00004097          	auipc	ra,0x4
    1fe4:	cb2080e7          	jalr	-846(ra) # 5c92 <unlink>
  pid = fork();
    1fe8:	00004097          	auipc	ra,0x4
    1fec:	c52080e7          	jalr	-942(ra) # 5c3a <fork>
  if(pid < 0){
    1ff0:	02054b63          	bltz	a0,2026 <linkunlink+0x6a>
    1ff4:	8caa                	mv	s9,a0
  unsigned int x = (pid ? 1 : 97);
    1ff6:	06100913          	li	s2,97
    1ffa:	c111                	beqz	a0,1ffe <linkunlink+0x42>
    1ffc:	4905                	li	s2,1
    1ffe:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    2002:	41c65a37          	lui	s4,0x41c65
    2006:	e6da0a1b          	addw	s4,s4,-403 # 41c64e6d <base+0x41c53e35>
    200a:	698d                	lui	s3,0x3
    200c:	0399899b          	addw	s3,s3,57 # 3039 <execout+0x89>
    if((x % 3) == 0){
    2010:	4a8d                	li	s5,3
    } else if((x % 3) == 1){
    2012:	4b85                	li	s7,1
      unlink("x");
    2014:	00004b17          	auipc	s6,0x4
    2018:	214b0b13          	add	s6,s6,532 # 6228 <malloc+0x1b6>
      link("cat", "x");
    201c:	00005c17          	auipc	s8,0x5
    2020:	c7cc0c13          	add	s8,s8,-900 # 6c98 <malloc+0xc26>
    2024:	a825                	j	205c <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    2026:	85a6                	mv	a1,s1
    2028:	00005517          	auipc	a0,0x5
    202c:	a1850513          	add	a0,a0,-1512 # 6a40 <malloc+0x9ce>
    2030:	00004097          	auipc	ra,0x4
    2034:	f8a080e7          	jalr	-118(ra) # 5fba <printf>
    exit(1);
    2038:	4505                	li	a0,1
    203a:	00004097          	auipc	ra,0x4
    203e:	c08080e7          	jalr	-1016(ra) # 5c42 <exit>
      close(open("x", O_RDWR | O_CREATE));
    2042:	20200593          	li	a1,514
    2046:	855a                	mv	a0,s6
    2048:	00004097          	auipc	ra,0x4
    204c:	c3a080e7          	jalr	-966(ra) # 5c82 <open>
    2050:	00004097          	auipc	ra,0x4
    2054:	c1a080e7          	jalr	-998(ra) # 5c6a <close>
  for(i = 0; i < 100; i++){
    2058:	34fd                	addw	s1,s1,-1
    205a:	c895                	beqz	s1,208e <linkunlink+0xd2>
    x = x * 1103515245 + 12345;
    205c:	034907bb          	mulw	a5,s2,s4
    2060:	013787bb          	addw	a5,a5,s3
    2064:	0007891b          	sext.w	s2,a5
    if((x % 3) == 0){
    2068:	0357f7bb          	remuw	a5,a5,s5
    206c:	2781                	sext.w	a5,a5
    206e:	dbf1                	beqz	a5,2042 <linkunlink+0x86>
    } else if((x % 3) == 1){
    2070:	01778863          	beq	a5,s7,2080 <linkunlink+0xc4>
      unlink("x");
    2074:	855a                	mv	a0,s6
    2076:	00004097          	auipc	ra,0x4
    207a:	c1c080e7          	jalr	-996(ra) # 5c92 <unlink>
    207e:	bfe9                	j	2058 <linkunlink+0x9c>
      link("cat", "x");
    2080:	85da                	mv	a1,s6
    2082:	8562                	mv	a0,s8
    2084:	00004097          	auipc	ra,0x4
    2088:	c1e080e7          	jalr	-994(ra) # 5ca2 <link>
    208c:	b7f1                	j	2058 <linkunlink+0x9c>
  if(pid)
    208e:	020c8463          	beqz	s9,20b6 <linkunlink+0xfa>
    wait(0);
    2092:	4501                	li	a0,0
    2094:	00004097          	auipc	ra,0x4
    2098:	bb6080e7          	jalr	-1098(ra) # 5c4a <wait>
}
    209c:	60e6                	ld	ra,88(sp)
    209e:	6446                	ld	s0,80(sp)
    20a0:	64a6                	ld	s1,72(sp)
    20a2:	6906                	ld	s2,64(sp)
    20a4:	79e2                	ld	s3,56(sp)
    20a6:	7a42                	ld	s4,48(sp)
    20a8:	7aa2                	ld	s5,40(sp)
    20aa:	7b02                	ld	s6,32(sp)
    20ac:	6be2                	ld	s7,24(sp)
    20ae:	6c42                	ld	s8,16(sp)
    20b0:	6ca2                	ld	s9,8(sp)
    20b2:	6125                	add	sp,sp,96
    20b4:	8082                	ret
    exit(0);
    20b6:	4501                	li	a0,0
    20b8:	00004097          	auipc	ra,0x4
    20bc:	b8a080e7          	jalr	-1142(ra) # 5c42 <exit>

00000000000020c0 <forktest>:
{
    20c0:	7179                	add	sp,sp,-48
    20c2:	f406                	sd	ra,40(sp)
    20c4:	f022                	sd	s0,32(sp)
    20c6:	ec26                	sd	s1,24(sp)
    20c8:	e84a                	sd	s2,16(sp)
    20ca:	e44e                	sd	s3,8(sp)
    20cc:	1800                	add	s0,sp,48
    20ce:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    20d0:	4481                	li	s1,0
    20d2:	3e800913          	li	s2,1000
    pid = fork();
    20d6:	00004097          	auipc	ra,0x4
    20da:	b64080e7          	jalr	-1180(ra) # 5c3a <fork>
    if(pid < 0)
    20de:	08054263          	bltz	a0,2162 <forktest+0xa2>
    if(pid == 0)
    20e2:	c115                	beqz	a0,2106 <forktest+0x46>
  for(n=0; n<N; n++){
    20e4:	2485                	addw	s1,s1,1
    20e6:	ff2498e3          	bne	s1,s2,20d6 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20ea:	85ce                	mv	a1,s3
    20ec:	00005517          	auipc	a0,0x5
    20f0:	bfc50513          	add	a0,a0,-1028 # 6ce8 <malloc+0xc76>
    20f4:	00004097          	auipc	ra,0x4
    20f8:	ec6080e7          	jalr	-314(ra) # 5fba <printf>
    exit(1);
    20fc:	4505                	li	a0,1
    20fe:	00004097          	auipc	ra,0x4
    2102:	b44080e7          	jalr	-1212(ra) # 5c42 <exit>
      exit(0);
    2106:	00004097          	auipc	ra,0x4
    210a:	b3c080e7          	jalr	-1220(ra) # 5c42 <exit>
    printf("%s: no fork at all!\n", s);
    210e:	85ce                	mv	a1,s3
    2110:	00005517          	auipc	a0,0x5
    2114:	b9050513          	add	a0,a0,-1136 # 6ca0 <malloc+0xc2e>
    2118:	00004097          	auipc	ra,0x4
    211c:	ea2080e7          	jalr	-350(ra) # 5fba <printf>
    exit(1);
    2120:	4505                	li	a0,1
    2122:	00004097          	auipc	ra,0x4
    2126:	b20080e7          	jalr	-1248(ra) # 5c42 <exit>
      printf("%s: wait stopped early\n", s);
    212a:	85ce                	mv	a1,s3
    212c:	00005517          	auipc	a0,0x5
    2130:	b8c50513          	add	a0,a0,-1140 # 6cb8 <malloc+0xc46>
    2134:	00004097          	auipc	ra,0x4
    2138:	e86080e7          	jalr	-378(ra) # 5fba <printf>
      exit(1);
    213c:	4505                	li	a0,1
    213e:	00004097          	auipc	ra,0x4
    2142:	b04080e7          	jalr	-1276(ra) # 5c42 <exit>
    printf("%s: wait got too many\n", s);
    2146:	85ce                	mv	a1,s3
    2148:	00005517          	auipc	a0,0x5
    214c:	b8850513          	add	a0,a0,-1144 # 6cd0 <malloc+0xc5e>
    2150:	00004097          	auipc	ra,0x4
    2154:	e6a080e7          	jalr	-406(ra) # 5fba <printf>
    exit(1);
    2158:	4505                	li	a0,1
    215a:	00004097          	auipc	ra,0x4
    215e:	ae8080e7          	jalr	-1304(ra) # 5c42 <exit>
  if (n == 0) {
    2162:	d4d5                	beqz	s1,210e <forktest+0x4e>
  for(; n > 0; n--){
    2164:	00905b63          	blez	s1,217a <forktest+0xba>
    if(wait(0) < 0){
    2168:	4501                	li	a0,0
    216a:	00004097          	auipc	ra,0x4
    216e:	ae0080e7          	jalr	-1312(ra) # 5c4a <wait>
    2172:	fa054ce3          	bltz	a0,212a <forktest+0x6a>
  for(; n > 0; n--){
    2176:	34fd                	addw	s1,s1,-1
    2178:	f8e5                	bnez	s1,2168 <forktest+0xa8>
  if(wait(0) != -1){
    217a:	4501                	li	a0,0
    217c:	00004097          	auipc	ra,0x4
    2180:	ace080e7          	jalr	-1330(ra) # 5c4a <wait>
    2184:	57fd                	li	a5,-1
    2186:	fcf510e3          	bne	a0,a5,2146 <forktest+0x86>
}
    218a:	70a2                	ld	ra,40(sp)
    218c:	7402                	ld	s0,32(sp)
    218e:	64e2                	ld	s1,24(sp)
    2190:	6942                	ld	s2,16(sp)
    2192:	69a2                	ld	s3,8(sp)
    2194:	6145                	add	sp,sp,48
    2196:	8082                	ret

0000000000002198 <kernmem>:
{
    2198:	715d                	add	sp,sp,-80
    219a:	e486                	sd	ra,72(sp)
    219c:	e0a2                	sd	s0,64(sp)
    219e:	fc26                	sd	s1,56(sp)
    21a0:	f84a                	sd	s2,48(sp)
    21a2:	f44e                	sd	s3,40(sp)
    21a4:	f052                	sd	s4,32(sp)
    21a6:	ec56                	sd	s5,24(sp)
    21a8:	0880                	add	s0,sp,80
    21aa:	8aaa                	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21ac:	4485                	li	s1,1
    21ae:	04fe                	sll	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    21b0:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21b2:	69b1                	lui	s3,0xc
    21b4:	35098993          	add	s3,s3,848 # c350 <uninit+0xa28>
    21b8:	1003d937          	lui	s2,0x1003d
    21bc:	090e                	sll	s2,s2,0x3
    21be:	48090913          	add	s2,s2,1152 # 1003d480 <base+0x1002c448>
    pid = fork();
    21c2:	00004097          	auipc	ra,0x4
    21c6:	a78080e7          	jalr	-1416(ra) # 5c3a <fork>
    if(pid < 0){
    21ca:	02054963          	bltz	a0,21fc <kernmem+0x64>
    if(pid == 0){
    21ce:	c529                	beqz	a0,2218 <kernmem+0x80>
    wait(&xstatus);
    21d0:	fbc40513          	add	a0,s0,-68
    21d4:	00004097          	auipc	ra,0x4
    21d8:	a76080e7          	jalr	-1418(ra) # 5c4a <wait>
    if(xstatus != -1)  // did kernel kill child?
    21dc:	fbc42783          	lw	a5,-68(s0)
    21e0:	05479d63          	bne	a5,s4,223a <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21e4:	94ce                	add	s1,s1,s3
    21e6:	fd249ee3          	bne	s1,s2,21c2 <kernmem+0x2a>
}
    21ea:	60a6                	ld	ra,72(sp)
    21ec:	6406                	ld	s0,64(sp)
    21ee:	74e2                	ld	s1,56(sp)
    21f0:	7942                	ld	s2,48(sp)
    21f2:	79a2                	ld	s3,40(sp)
    21f4:	7a02                	ld	s4,32(sp)
    21f6:	6ae2                	ld	s5,24(sp)
    21f8:	6161                	add	sp,sp,80
    21fa:	8082                	ret
      printf("%s: fork failed\n", s);
    21fc:	85d6                	mv	a1,s5
    21fe:	00005517          	auipc	a0,0x5
    2202:	84250513          	add	a0,a0,-1982 # 6a40 <malloc+0x9ce>
    2206:	00004097          	auipc	ra,0x4
    220a:	db4080e7          	jalr	-588(ra) # 5fba <printf>
      exit(1);
    220e:	4505                	li	a0,1
    2210:	00004097          	auipc	ra,0x4
    2214:	a32080e7          	jalr	-1486(ra) # 5c42 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2218:	0004c683          	lbu	a3,0(s1)
    221c:	8626                	mv	a2,s1
    221e:	85d6                	mv	a1,s5
    2220:	00005517          	auipc	a0,0x5
    2224:	af050513          	add	a0,a0,-1296 # 6d10 <malloc+0xc9e>
    2228:	00004097          	auipc	ra,0x4
    222c:	d92080e7          	jalr	-622(ra) # 5fba <printf>
      exit(1);
    2230:	4505                	li	a0,1
    2232:	00004097          	auipc	ra,0x4
    2236:	a10080e7          	jalr	-1520(ra) # 5c42 <exit>
      exit(1);
    223a:	4505                	li	a0,1
    223c:	00004097          	auipc	ra,0x4
    2240:	a06080e7          	jalr	-1530(ra) # 5c42 <exit>

0000000000002244 <MAXVAplus>:
{
    2244:	7179                	add	sp,sp,-48
    2246:	f406                	sd	ra,40(sp)
    2248:	f022                	sd	s0,32(sp)
    224a:	1800                	add	s0,sp,48
  volatile uint64 a = MAXVA;
    224c:	4785                	li	a5,1
    224e:	179a                	sll	a5,a5,0x26
    2250:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2254:	fd843783          	ld	a5,-40(s0)
    2258:	c3a1                	beqz	a5,2298 <MAXVAplus+0x54>
    225a:	ec26                	sd	s1,24(sp)
    225c:	e84a                	sd	s2,16(sp)
    225e:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    2260:	54fd                	li	s1,-1
    pid = fork();
    2262:	00004097          	auipc	ra,0x4
    2266:	9d8080e7          	jalr	-1576(ra) # 5c3a <fork>
    if(pid < 0){
    226a:	02054b63          	bltz	a0,22a0 <MAXVAplus+0x5c>
    if(pid == 0){
    226e:	c539                	beqz	a0,22bc <MAXVAplus+0x78>
    wait(&xstatus);
    2270:	fd440513          	add	a0,s0,-44
    2274:	00004097          	auipc	ra,0x4
    2278:	9d6080e7          	jalr	-1578(ra) # 5c4a <wait>
    if(xstatus != -1)  // did kernel kill child?
    227c:	fd442783          	lw	a5,-44(s0)
    2280:	06979463          	bne	a5,s1,22e8 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    2284:	fd843783          	ld	a5,-40(s0)
    2288:	0786                	sll	a5,a5,0x1
    228a:	fcf43c23          	sd	a5,-40(s0)
    228e:	fd843783          	ld	a5,-40(s0)
    2292:	fbe1                	bnez	a5,2262 <MAXVAplus+0x1e>
    2294:	64e2                	ld	s1,24(sp)
    2296:	6942                	ld	s2,16(sp)
}
    2298:	70a2                	ld	ra,40(sp)
    229a:	7402                	ld	s0,32(sp)
    229c:	6145                	add	sp,sp,48
    229e:	8082                	ret
      printf("%s: fork failed\n", s);
    22a0:	85ca                	mv	a1,s2
    22a2:	00004517          	auipc	a0,0x4
    22a6:	79e50513          	add	a0,a0,1950 # 6a40 <malloc+0x9ce>
    22aa:	00004097          	auipc	ra,0x4
    22ae:	d10080e7          	jalr	-752(ra) # 5fba <printf>
      exit(1);
    22b2:	4505                	li	a0,1
    22b4:	00004097          	auipc	ra,0x4
    22b8:	98e080e7          	jalr	-1650(ra) # 5c42 <exit>
      *(char*)a = 99;
    22bc:	fd843783          	ld	a5,-40(s0)
    22c0:	06300713          	li	a4,99
    22c4:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    22c8:	fd843603          	ld	a2,-40(s0)
    22cc:	85ca                	mv	a1,s2
    22ce:	00005517          	auipc	a0,0x5
    22d2:	a6250513          	add	a0,a0,-1438 # 6d30 <malloc+0xcbe>
    22d6:	00004097          	auipc	ra,0x4
    22da:	ce4080e7          	jalr	-796(ra) # 5fba <printf>
      exit(1);
    22de:	4505                	li	a0,1
    22e0:	00004097          	auipc	ra,0x4
    22e4:	962080e7          	jalr	-1694(ra) # 5c42 <exit>
      exit(1);
    22e8:	4505                	li	a0,1
    22ea:	00004097          	auipc	ra,0x4
    22ee:	958080e7          	jalr	-1704(ra) # 5c42 <exit>

00000000000022f2 <bigargtest>:
{
    22f2:	7179                	add	sp,sp,-48
    22f4:	f406                	sd	ra,40(sp)
    22f6:	f022                	sd	s0,32(sp)
    22f8:	ec26                	sd	s1,24(sp)
    22fa:	1800                	add	s0,sp,48
    22fc:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22fe:	00005517          	auipc	a0,0x5
    2302:	a4a50513          	add	a0,a0,-1462 # 6d48 <malloc+0xcd6>
    2306:	00004097          	auipc	ra,0x4
    230a:	98c080e7          	jalr	-1652(ra) # 5c92 <unlink>
  pid = fork();
    230e:	00004097          	auipc	ra,0x4
    2312:	92c080e7          	jalr	-1748(ra) # 5c3a <fork>
  if(pid == 0){
    2316:	c121                	beqz	a0,2356 <bigargtest+0x64>
  } else if(pid < 0){
    2318:	0a054063          	bltz	a0,23b8 <bigargtest+0xc6>
  wait(&xstatus);
    231c:	fdc40513          	add	a0,s0,-36
    2320:	00004097          	auipc	ra,0x4
    2324:	92a080e7          	jalr	-1750(ra) # 5c4a <wait>
  if(xstatus != 0)
    2328:	fdc42503          	lw	a0,-36(s0)
    232c:	e545                	bnez	a0,23d4 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    232e:	4581                	li	a1,0
    2330:	00005517          	auipc	a0,0x5
    2334:	a1850513          	add	a0,a0,-1512 # 6d48 <malloc+0xcd6>
    2338:	00004097          	auipc	ra,0x4
    233c:	94a080e7          	jalr	-1718(ra) # 5c82 <open>
  if(fd < 0){
    2340:	08054e63          	bltz	a0,23dc <bigargtest+0xea>
  close(fd);
    2344:	00004097          	auipc	ra,0x4
    2348:	926080e7          	jalr	-1754(ra) # 5c6a <close>
}
    234c:	70a2                	ld	ra,40(sp)
    234e:	7402                	ld	s0,32(sp)
    2350:	64e2                	ld	s1,24(sp)
    2352:	6145                	add	sp,sp,48
    2354:	8082                	ret
    2356:	00008797          	auipc	a5,0x8
    235a:	4ca78793          	add	a5,a5,1226 # a820 <args.1>
    235e:	00008697          	auipc	a3,0x8
    2362:	5ba68693          	add	a3,a3,1466 # a918 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2366:	00005717          	auipc	a4,0x5
    236a:	9f270713          	add	a4,a4,-1550 # 6d58 <malloc+0xce6>
    236e:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2370:	07a1                	add	a5,a5,8
    2372:	fed79ee3          	bne	a5,a3,236e <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2376:	00008597          	auipc	a1,0x8
    237a:	4aa58593          	add	a1,a1,1194 # a820 <args.1>
    237e:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2382:	00004517          	auipc	a0,0x4
    2386:	e3650513          	add	a0,a0,-458 # 61b8 <malloc+0x146>
    238a:	00004097          	auipc	ra,0x4
    238e:	8f0080e7          	jalr	-1808(ra) # 5c7a <exec>
    fd = open("bigarg-ok", O_CREATE);
    2392:	20000593          	li	a1,512
    2396:	00005517          	auipc	a0,0x5
    239a:	9b250513          	add	a0,a0,-1614 # 6d48 <malloc+0xcd6>
    239e:	00004097          	auipc	ra,0x4
    23a2:	8e4080e7          	jalr	-1820(ra) # 5c82 <open>
    close(fd);
    23a6:	00004097          	auipc	ra,0x4
    23aa:	8c4080e7          	jalr	-1852(ra) # 5c6a <close>
    exit(0);
    23ae:	4501                	li	a0,0
    23b0:	00004097          	auipc	ra,0x4
    23b4:	892080e7          	jalr	-1902(ra) # 5c42 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    23b8:	85a6                	mv	a1,s1
    23ba:	00005517          	auipc	a0,0x5
    23be:	a7e50513          	add	a0,a0,-1410 # 6e38 <malloc+0xdc6>
    23c2:	00004097          	auipc	ra,0x4
    23c6:	bf8080e7          	jalr	-1032(ra) # 5fba <printf>
    exit(1);
    23ca:	4505                	li	a0,1
    23cc:	00004097          	auipc	ra,0x4
    23d0:	876080e7          	jalr	-1930(ra) # 5c42 <exit>
    exit(xstatus);
    23d4:	00004097          	auipc	ra,0x4
    23d8:	86e080e7          	jalr	-1938(ra) # 5c42 <exit>
    printf("%s: bigarg test failed!\n", s);
    23dc:	85a6                	mv	a1,s1
    23de:	00005517          	auipc	a0,0x5
    23e2:	a7a50513          	add	a0,a0,-1414 # 6e58 <malloc+0xde6>
    23e6:	00004097          	auipc	ra,0x4
    23ea:	bd4080e7          	jalr	-1068(ra) # 5fba <printf>
    exit(1);
    23ee:	4505                	li	a0,1
    23f0:	00004097          	auipc	ra,0x4
    23f4:	852080e7          	jalr	-1966(ra) # 5c42 <exit>

00000000000023f8 <stacktest>:
{
    23f8:	7179                	add	sp,sp,-48
    23fa:	f406                	sd	ra,40(sp)
    23fc:	f022                	sd	s0,32(sp)
    23fe:	ec26                	sd	s1,24(sp)
    2400:	1800                	add	s0,sp,48
    2402:	84aa                	mv	s1,a0
  pid = fork();
    2404:	00004097          	auipc	ra,0x4
    2408:	836080e7          	jalr	-1994(ra) # 5c3a <fork>
  if(pid == 0) {
    240c:	c115                	beqz	a0,2430 <stacktest+0x38>
  } else if(pid < 0){
    240e:	04054463          	bltz	a0,2456 <stacktest+0x5e>
  wait(&xstatus);
    2412:	fdc40513          	add	a0,s0,-36
    2416:	00004097          	auipc	ra,0x4
    241a:	834080e7          	jalr	-1996(ra) # 5c4a <wait>
  if(xstatus == -1)  // kernel killed child?
    241e:	fdc42503          	lw	a0,-36(s0)
    2422:	57fd                	li	a5,-1
    2424:	04f50763          	beq	a0,a5,2472 <stacktest+0x7a>
    exit(xstatus);
    2428:	00004097          	auipc	ra,0x4
    242c:	81a080e7          	jalr	-2022(ra) # 5c42 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2430:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2432:	77fd                	lui	a5,0xfffff
    2434:	97ba                	add	a5,a5,a4
    2436:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffedfc8>
    243a:	85a6                	mv	a1,s1
    243c:	00005517          	auipc	a0,0x5
    2440:	a3c50513          	add	a0,a0,-1476 # 6e78 <malloc+0xe06>
    2444:	00004097          	auipc	ra,0x4
    2448:	b76080e7          	jalr	-1162(ra) # 5fba <printf>
    exit(1);
    244c:	4505                	li	a0,1
    244e:	00003097          	auipc	ra,0x3
    2452:	7f4080e7          	jalr	2036(ra) # 5c42 <exit>
    printf("%s: fork failed\n", s);
    2456:	85a6                	mv	a1,s1
    2458:	00004517          	auipc	a0,0x4
    245c:	5e850513          	add	a0,a0,1512 # 6a40 <malloc+0x9ce>
    2460:	00004097          	auipc	ra,0x4
    2464:	b5a080e7          	jalr	-1190(ra) # 5fba <printf>
    exit(1);
    2468:	4505                	li	a0,1
    246a:	00003097          	auipc	ra,0x3
    246e:	7d8080e7          	jalr	2008(ra) # 5c42 <exit>
    exit(0);
    2472:	4501                	li	a0,0
    2474:	00003097          	auipc	ra,0x3
    2478:	7ce080e7          	jalr	1998(ra) # 5c42 <exit>

000000000000247c <textwrite>:
{
    247c:	7179                	add	sp,sp,-48
    247e:	f406                	sd	ra,40(sp)
    2480:	f022                	sd	s0,32(sp)
    2482:	ec26                	sd	s1,24(sp)
    2484:	1800                	add	s0,sp,48
    2486:	84aa                	mv	s1,a0
  pid = fork();
    2488:	00003097          	auipc	ra,0x3
    248c:	7b2080e7          	jalr	1970(ra) # 5c3a <fork>
  if(pid == 0) {
    2490:	c115                	beqz	a0,24b4 <textwrite+0x38>
  } else if(pid < 0){
    2492:	02054963          	bltz	a0,24c4 <textwrite+0x48>
  wait(&xstatus);
    2496:	fdc40513          	add	a0,s0,-36
    249a:	00003097          	auipc	ra,0x3
    249e:	7b0080e7          	jalr	1968(ra) # 5c4a <wait>
  if(xstatus == -1)  // kernel killed child?
    24a2:	fdc42503          	lw	a0,-36(s0)
    24a6:	57fd                	li	a5,-1
    24a8:	02f50c63          	beq	a0,a5,24e0 <textwrite+0x64>
    exit(xstatus);
    24ac:	00003097          	auipc	ra,0x3
    24b0:	796080e7          	jalr	1942(ra) # 5c42 <exit>
    *addr = 10;
    24b4:	47a9                	li	a5,10
    24b6:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    24ba:	4505                	li	a0,1
    24bc:	00003097          	auipc	ra,0x3
    24c0:	786080e7          	jalr	1926(ra) # 5c42 <exit>
    printf("%s: fork failed\n", s);
    24c4:	85a6                	mv	a1,s1
    24c6:	00004517          	auipc	a0,0x4
    24ca:	57a50513          	add	a0,a0,1402 # 6a40 <malloc+0x9ce>
    24ce:	00004097          	auipc	ra,0x4
    24d2:	aec080e7          	jalr	-1300(ra) # 5fba <printf>
    exit(1);
    24d6:	4505                	li	a0,1
    24d8:	00003097          	auipc	ra,0x3
    24dc:	76a080e7          	jalr	1898(ra) # 5c42 <exit>
    exit(0);
    24e0:	4501                	li	a0,0
    24e2:	00003097          	auipc	ra,0x3
    24e6:	760080e7          	jalr	1888(ra) # 5c42 <exit>

00000000000024ea <manywrites>:
{
    24ea:	711d                	add	sp,sp,-96
    24ec:	ec86                	sd	ra,88(sp)
    24ee:	e8a2                	sd	s0,80(sp)
    24f0:	e4a6                	sd	s1,72(sp)
    24f2:	e0ca                	sd	s2,64(sp)
    24f4:	fc4e                	sd	s3,56(sp)
    24f6:	f456                	sd	s5,40(sp)
    24f8:	1080                	add	s0,sp,96
    24fa:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    24fc:	4981                	li	s3,0
    24fe:	4911                	li	s2,4
    int pid = fork();
    2500:	00003097          	auipc	ra,0x3
    2504:	73a080e7          	jalr	1850(ra) # 5c3a <fork>
    2508:	84aa                	mv	s1,a0
    if(pid < 0){
    250a:	02054d63          	bltz	a0,2544 <manywrites+0x5a>
    if(pid == 0){
    250e:	c939                	beqz	a0,2564 <manywrites+0x7a>
  for(int ci = 0; ci < nchildren; ci++){
    2510:	2985                	addw	s3,s3,1
    2512:	ff2997e3          	bne	s3,s2,2500 <manywrites+0x16>
    2516:	f852                	sd	s4,48(sp)
    2518:	f05a                	sd	s6,32(sp)
    251a:	ec5e                	sd	s7,24(sp)
    251c:	4491                	li	s1,4
    int st = 0;
    251e:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    2522:	fa840513          	add	a0,s0,-88
    2526:	00003097          	auipc	ra,0x3
    252a:	724080e7          	jalr	1828(ra) # 5c4a <wait>
    if(st != 0)
    252e:	fa842503          	lw	a0,-88(s0)
    2532:	10051463          	bnez	a0,263a <manywrites+0x150>
  for(int ci = 0; ci < nchildren; ci++){
    2536:	34fd                	addw	s1,s1,-1
    2538:	f0fd                	bnez	s1,251e <manywrites+0x34>
  exit(0);
    253a:	4501                	li	a0,0
    253c:	00003097          	auipc	ra,0x3
    2540:	706080e7          	jalr	1798(ra) # 5c42 <exit>
    2544:	f852                	sd	s4,48(sp)
    2546:	f05a                	sd	s6,32(sp)
    2548:	ec5e                	sd	s7,24(sp)
      printf("fork failed\n");
    254a:	00005517          	auipc	a0,0x5
    254e:	8fe50513          	add	a0,a0,-1794 # 6e48 <malloc+0xdd6>
    2552:	00004097          	auipc	ra,0x4
    2556:	a68080e7          	jalr	-1432(ra) # 5fba <printf>
      exit(1);
    255a:	4505                	li	a0,1
    255c:	00003097          	auipc	ra,0x3
    2560:	6e6080e7          	jalr	1766(ra) # 5c42 <exit>
    2564:	f852                	sd	s4,48(sp)
    2566:	f05a                	sd	s6,32(sp)
    2568:	ec5e                	sd	s7,24(sp)
      name[0] = 'b';
    256a:	06200793          	li	a5,98
    256e:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    2572:	0619879b          	addw	a5,s3,97
    2576:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    257a:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    257e:	fa840513          	add	a0,s0,-88
    2582:	00003097          	auipc	ra,0x3
    2586:	710080e7          	jalr	1808(ra) # 5c92 <unlink>
    258a:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    258c:	0000cb17          	auipc	s6,0xc
    2590:	aacb0b13          	add	s6,s6,-1364 # e038 <buf>
        for(int i = 0; i < ci+1; i++){
    2594:	8a26                	mv	s4,s1
    2596:	0209ce63          	bltz	s3,25d2 <manywrites+0xe8>
          int fd = open(name, O_CREATE | O_RDWR);
    259a:	20200593          	li	a1,514
    259e:	fa840513          	add	a0,s0,-88
    25a2:	00003097          	auipc	ra,0x3
    25a6:	6e0080e7          	jalr	1760(ra) # 5c82 <open>
    25aa:	892a                	mv	s2,a0
          if(fd < 0){
    25ac:	04054763          	bltz	a0,25fa <manywrites+0x110>
          int cc = write(fd, buf, sz);
    25b0:	660d                	lui	a2,0x3
    25b2:	85da                	mv	a1,s6
    25b4:	00003097          	auipc	ra,0x3
    25b8:	6ae080e7          	jalr	1710(ra) # 5c62 <write>
          if(cc != sz){
    25bc:	678d                	lui	a5,0x3
    25be:	04f51e63          	bne	a0,a5,261a <manywrites+0x130>
          close(fd);
    25c2:	854a                	mv	a0,s2
    25c4:	00003097          	auipc	ra,0x3
    25c8:	6a6080e7          	jalr	1702(ra) # 5c6a <close>
        for(int i = 0; i < ci+1; i++){
    25cc:	2a05                	addw	s4,s4,1
    25ce:	fd49d6e3          	bge	s3,s4,259a <manywrites+0xb0>
        unlink(name);
    25d2:	fa840513          	add	a0,s0,-88
    25d6:	00003097          	auipc	ra,0x3
    25da:	6bc080e7          	jalr	1724(ra) # 5c92 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    25de:	3bfd                	addw	s7,s7,-1
    25e0:	fa0b9ae3          	bnez	s7,2594 <manywrites+0xaa>
      unlink(name);
    25e4:	fa840513          	add	a0,s0,-88
    25e8:	00003097          	auipc	ra,0x3
    25ec:	6aa080e7          	jalr	1706(ra) # 5c92 <unlink>
      exit(0);
    25f0:	4501                	li	a0,0
    25f2:	00003097          	auipc	ra,0x3
    25f6:	650080e7          	jalr	1616(ra) # 5c42 <exit>
            printf("%s: cannot create %s\n", s, name);
    25fa:	fa840613          	add	a2,s0,-88
    25fe:	85d6                	mv	a1,s5
    2600:	00005517          	auipc	a0,0x5
    2604:	8a050513          	add	a0,a0,-1888 # 6ea0 <malloc+0xe2e>
    2608:	00004097          	auipc	ra,0x4
    260c:	9b2080e7          	jalr	-1614(ra) # 5fba <printf>
            exit(1);
    2610:	4505                	li	a0,1
    2612:	00003097          	auipc	ra,0x3
    2616:	630080e7          	jalr	1584(ra) # 5c42 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    261a:	86aa                	mv	a3,a0
    261c:	660d                	lui	a2,0x3
    261e:	85d6                	mv	a1,s5
    2620:	00004517          	auipc	a0,0x4
    2624:	c6850513          	add	a0,a0,-920 # 6288 <malloc+0x216>
    2628:	00004097          	auipc	ra,0x4
    262c:	992080e7          	jalr	-1646(ra) # 5fba <printf>
            exit(1);
    2630:	4505                	li	a0,1
    2632:	00003097          	auipc	ra,0x3
    2636:	610080e7          	jalr	1552(ra) # 5c42 <exit>
      exit(st);
    263a:	00003097          	auipc	ra,0x3
    263e:	608080e7          	jalr	1544(ra) # 5c42 <exit>

0000000000002642 <copyinstr3>:
{
    2642:	7179                	add	sp,sp,-48
    2644:	f406                	sd	ra,40(sp)
    2646:	f022                	sd	s0,32(sp)
    2648:	ec26                	sd	s1,24(sp)
    264a:	1800                	add	s0,sp,48
  sbrk(8192);
    264c:	6509                	lui	a0,0x2
    264e:	00003097          	auipc	ra,0x3
    2652:	67c080e7          	jalr	1660(ra) # 5cca <sbrk>
  uint64 top = (uint64) sbrk(0);
    2656:	4501                	li	a0,0
    2658:	00003097          	auipc	ra,0x3
    265c:	672080e7          	jalr	1650(ra) # 5cca <sbrk>
  if((top % PGSIZE) != 0){
    2660:	03451793          	sll	a5,a0,0x34
    2664:	e3c9                	bnez	a5,26e6 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2666:	4501                	li	a0,0
    2668:	00003097          	auipc	ra,0x3
    266c:	662080e7          	jalr	1634(ra) # 5cca <sbrk>
  if(top % PGSIZE){
    2670:	03451793          	sll	a5,a0,0x34
    2674:	e3d9                	bnez	a5,26fa <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2676:	fff50493          	add	s1,a0,-1 # 1fff <linkunlink+0x43>
  *b = 'x';
    267a:	07800793          	li	a5,120
    267e:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2682:	8526                	mv	a0,s1
    2684:	00003097          	auipc	ra,0x3
    2688:	60e080e7          	jalr	1550(ra) # 5c92 <unlink>
  if(ret != -1){
    268c:	57fd                	li	a5,-1
    268e:	08f51363          	bne	a0,a5,2714 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2692:	20100593          	li	a1,513
    2696:	8526                	mv	a0,s1
    2698:	00003097          	auipc	ra,0x3
    269c:	5ea080e7          	jalr	1514(ra) # 5c82 <open>
  if(fd != -1){
    26a0:	57fd                	li	a5,-1
    26a2:	08f51863          	bne	a0,a5,2732 <copyinstr3+0xf0>
  ret = link(b, b);
    26a6:	85a6                	mv	a1,s1
    26a8:	8526                	mv	a0,s1
    26aa:	00003097          	auipc	ra,0x3
    26ae:	5f8080e7          	jalr	1528(ra) # 5ca2 <link>
  if(ret != -1){
    26b2:	57fd                	li	a5,-1
    26b4:	08f51e63          	bne	a0,a5,2750 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    26b8:	00005797          	auipc	a5,0x5
    26bc:	4e078793          	add	a5,a5,1248 # 7b98 <malloc+0x1b26>
    26c0:	fcf43823          	sd	a5,-48(s0)
    26c4:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    26c8:	fd040593          	add	a1,s0,-48
    26cc:	8526                	mv	a0,s1
    26ce:	00003097          	auipc	ra,0x3
    26d2:	5ac080e7          	jalr	1452(ra) # 5c7a <exec>
  if(ret != -1){
    26d6:	57fd                	li	a5,-1
    26d8:	08f51c63          	bne	a0,a5,2770 <copyinstr3+0x12e>
}
    26dc:	70a2                	ld	ra,40(sp)
    26de:	7402                	ld	s0,32(sp)
    26e0:	64e2                	ld	s1,24(sp)
    26e2:	6145                	add	sp,sp,48
    26e4:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26e6:	0347d513          	srl	a0,a5,0x34
    26ea:	6785                	lui	a5,0x1
    26ec:	40a7853b          	subw	a0,a5,a0
    26f0:	00003097          	auipc	ra,0x3
    26f4:	5da080e7          	jalr	1498(ra) # 5cca <sbrk>
    26f8:	b7bd                	j	2666 <copyinstr3+0x24>
    printf("oops\n");
    26fa:	00004517          	auipc	a0,0x4
    26fe:	7be50513          	add	a0,a0,1982 # 6eb8 <malloc+0xe46>
    2702:	00004097          	auipc	ra,0x4
    2706:	8b8080e7          	jalr	-1864(ra) # 5fba <printf>
    exit(1);
    270a:	4505                	li	a0,1
    270c:	00003097          	auipc	ra,0x3
    2710:	536080e7          	jalr	1334(ra) # 5c42 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2714:	862a                	mv	a2,a0
    2716:	85a6                	mv	a1,s1
    2718:	00004517          	auipc	a0,0x4
    271c:	24850513          	add	a0,a0,584 # 6960 <malloc+0x8ee>
    2720:	00004097          	auipc	ra,0x4
    2724:	89a080e7          	jalr	-1894(ra) # 5fba <printf>
    exit(1);
    2728:	4505                	li	a0,1
    272a:	00003097          	auipc	ra,0x3
    272e:	518080e7          	jalr	1304(ra) # 5c42 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2732:	862a                	mv	a2,a0
    2734:	85a6                	mv	a1,s1
    2736:	00004517          	auipc	a0,0x4
    273a:	24a50513          	add	a0,a0,586 # 6980 <malloc+0x90e>
    273e:	00004097          	auipc	ra,0x4
    2742:	87c080e7          	jalr	-1924(ra) # 5fba <printf>
    exit(1);
    2746:	4505                	li	a0,1
    2748:	00003097          	auipc	ra,0x3
    274c:	4fa080e7          	jalr	1274(ra) # 5c42 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2750:	86aa                	mv	a3,a0
    2752:	8626                	mv	a2,s1
    2754:	85a6                	mv	a1,s1
    2756:	00004517          	auipc	a0,0x4
    275a:	24a50513          	add	a0,a0,586 # 69a0 <malloc+0x92e>
    275e:	00004097          	auipc	ra,0x4
    2762:	85c080e7          	jalr	-1956(ra) # 5fba <printf>
    exit(1);
    2766:	4505                	li	a0,1
    2768:	00003097          	auipc	ra,0x3
    276c:	4da080e7          	jalr	1242(ra) # 5c42 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2770:	567d                	li	a2,-1
    2772:	85a6                	mv	a1,s1
    2774:	00004517          	auipc	a0,0x4
    2778:	25450513          	add	a0,a0,596 # 69c8 <malloc+0x956>
    277c:	00004097          	auipc	ra,0x4
    2780:	83e080e7          	jalr	-1986(ra) # 5fba <printf>
    exit(1);
    2784:	4505                	li	a0,1
    2786:	00003097          	auipc	ra,0x3
    278a:	4bc080e7          	jalr	1212(ra) # 5c42 <exit>

000000000000278e <rwsbrk>:
{
    278e:	1101                	add	sp,sp,-32
    2790:	ec06                	sd	ra,24(sp)
    2792:	e822                	sd	s0,16(sp)
    2794:	1000                	add	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2796:	6509                	lui	a0,0x2
    2798:	00003097          	auipc	ra,0x3
    279c:	532080e7          	jalr	1330(ra) # 5cca <sbrk>
  if(a == 0xffffffffffffffffLL) {
    27a0:	57fd                	li	a5,-1
    27a2:	06f50463          	beq	a0,a5,280a <rwsbrk+0x7c>
    27a6:	e426                	sd	s1,8(sp)
    27a8:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    27aa:	7579                	lui	a0,0xffffe
    27ac:	00003097          	auipc	ra,0x3
    27b0:	51e080e7          	jalr	1310(ra) # 5cca <sbrk>
    27b4:	57fd                	li	a5,-1
    27b6:	06f50963          	beq	a0,a5,2828 <rwsbrk+0x9a>
    27ba:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    27bc:	20100593          	li	a1,513
    27c0:	00004517          	auipc	a0,0x4
    27c4:	73850513          	add	a0,a0,1848 # 6ef8 <malloc+0xe86>
    27c8:	00003097          	auipc	ra,0x3
    27cc:	4ba080e7          	jalr	1210(ra) # 5c82 <open>
    27d0:	892a                	mv	s2,a0
  if(fd < 0){
    27d2:	06054963          	bltz	a0,2844 <rwsbrk+0xb6>
  n = write(fd, (void*)(a+4096), 1024);
    27d6:	6785                	lui	a5,0x1
    27d8:	94be                	add	s1,s1,a5
    27da:	40000613          	li	a2,1024
    27de:	85a6                	mv	a1,s1
    27e0:	00003097          	auipc	ra,0x3
    27e4:	482080e7          	jalr	1154(ra) # 5c62 <write>
    27e8:	862a                	mv	a2,a0
  if(n >= 0){
    27ea:	06054a63          	bltz	a0,285e <rwsbrk+0xd0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    27ee:	85a6                	mv	a1,s1
    27f0:	00004517          	auipc	a0,0x4
    27f4:	72850513          	add	a0,a0,1832 # 6f18 <malloc+0xea6>
    27f8:	00003097          	auipc	ra,0x3
    27fc:	7c2080e7          	jalr	1986(ra) # 5fba <printf>
    exit(1);
    2800:	4505                	li	a0,1
    2802:	00003097          	auipc	ra,0x3
    2806:	440080e7          	jalr	1088(ra) # 5c42 <exit>
    280a:	e426                	sd	s1,8(sp)
    280c:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    280e:	00004517          	auipc	a0,0x4
    2812:	6b250513          	add	a0,a0,1714 # 6ec0 <malloc+0xe4e>
    2816:	00003097          	auipc	ra,0x3
    281a:	7a4080e7          	jalr	1956(ra) # 5fba <printf>
    exit(1);
    281e:	4505                	li	a0,1
    2820:	00003097          	auipc	ra,0x3
    2824:	422080e7          	jalr	1058(ra) # 5c42 <exit>
    2828:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    282a:	00004517          	auipc	a0,0x4
    282e:	6ae50513          	add	a0,a0,1710 # 6ed8 <malloc+0xe66>
    2832:	00003097          	auipc	ra,0x3
    2836:	788080e7          	jalr	1928(ra) # 5fba <printf>
    exit(1);
    283a:	4505                	li	a0,1
    283c:	00003097          	auipc	ra,0x3
    2840:	406080e7          	jalr	1030(ra) # 5c42 <exit>
    printf("open(rwsbrk) failed\n");
    2844:	00004517          	auipc	a0,0x4
    2848:	6bc50513          	add	a0,a0,1724 # 6f00 <malloc+0xe8e>
    284c:	00003097          	auipc	ra,0x3
    2850:	76e080e7          	jalr	1902(ra) # 5fba <printf>
    exit(1);
    2854:	4505                	li	a0,1
    2856:	00003097          	auipc	ra,0x3
    285a:	3ec080e7          	jalr	1004(ra) # 5c42 <exit>
  close(fd);
    285e:	854a                	mv	a0,s2
    2860:	00003097          	auipc	ra,0x3
    2864:	40a080e7          	jalr	1034(ra) # 5c6a <close>
  unlink("rwsbrk");
    2868:	00004517          	auipc	a0,0x4
    286c:	69050513          	add	a0,a0,1680 # 6ef8 <malloc+0xe86>
    2870:	00003097          	auipc	ra,0x3
    2874:	422080e7          	jalr	1058(ra) # 5c92 <unlink>
  fd = open("README", O_RDONLY);
    2878:	4581                	li	a1,0
    287a:	00004517          	auipc	a0,0x4
    287e:	b1650513          	add	a0,a0,-1258 # 6390 <malloc+0x31e>
    2882:	00003097          	auipc	ra,0x3
    2886:	400080e7          	jalr	1024(ra) # 5c82 <open>
    288a:	892a                	mv	s2,a0
  if(fd < 0){
    288c:	02054963          	bltz	a0,28be <rwsbrk+0x130>
  n = read(fd, (void*)(a+4096), 10);
    2890:	4629                	li	a2,10
    2892:	85a6                	mv	a1,s1
    2894:	00003097          	auipc	ra,0x3
    2898:	3c6080e7          	jalr	966(ra) # 5c5a <read>
    289c:	862a                	mv	a2,a0
  if(n >= 0){
    289e:	02054d63          	bltz	a0,28d8 <rwsbrk+0x14a>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    28a2:	85a6                	mv	a1,s1
    28a4:	00004517          	auipc	a0,0x4
    28a8:	6a450513          	add	a0,a0,1700 # 6f48 <malloc+0xed6>
    28ac:	00003097          	auipc	ra,0x3
    28b0:	70e080e7          	jalr	1806(ra) # 5fba <printf>
    exit(1);
    28b4:	4505                	li	a0,1
    28b6:	00003097          	auipc	ra,0x3
    28ba:	38c080e7          	jalr	908(ra) # 5c42 <exit>
    printf("open(rwsbrk) failed\n");
    28be:	00004517          	auipc	a0,0x4
    28c2:	64250513          	add	a0,a0,1602 # 6f00 <malloc+0xe8e>
    28c6:	00003097          	auipc	ra,0x3
    28ca:	6f4080e7          	jalr	1780(ra) # 5fba <printf>
    exit(1);
    28ce:	4505                	li	a0,1
    28d0:	00003097          	auipc	ra,0x3
    28d4:	372080e7          	jalr	882(ra) # 5c42 <exit>
  close(fd);
    28d8:	854a                	mv	a0,s2
    28da:	00003097          	auipc	ra,0x3
    28de:	390080e7          	jalr	912(ra) # 5c6a <close>
  exit(0);
    28e2:	4501                	li	a0,0
    28e4:	00003097          	auipc	ra,0x3
    28e8:	35e080e7          	jalr	862(ra) # 5c42 <exit>

00000000000028ec <sbrkbasic>:
{
    28ec:	7139                	add	sp,sp,-64
    28ee:	fc06                	sd	ra,56(sp)
    28f0:	f822                	sd	s0,48(sp)
    28f2:	ec4e                	sd	s3,24(sp)
    28f4:	0080                	add	s0,sp,64
    28f6:	89aa                	mv	s3,a0
  pid = fork();
    28f8:	00003097          	auipc	ra,0x3
    28fc:	342080e7          	jalr	834(ra) # 5c3a <fork>
  if(pid < 0){
    2900:	02054f63          	bltz	a0,293e <sbrkbasic+0x52>
  if(pid == 0){
    2904:	e52d                	bnez	a0,296e <sbrkbasic+0x82>
    a = sbrk(TOOMUCH);
    2906:	40000537          	lui	a0,0x40000
    290a:	00003097          	auipc	ra,0x3
    290e:	3c0080e7          	jalr	960(ra) # 5cca <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2912:	57fd                	li	a5,-1
    2914:	04f50563          	beq	a0,a5,295e <sbrkbasic+0x72>
    2918:	f426                	sd	s1,40(sp)
    291a:	f04a                	sd	s2,32(sp)
    291c:	e852                	sd	s4,16(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    291e:	400007b7          	lui	a5,0x40000
    2922:	97aa                	add	a5,a5,a0
      *b = 99;
    2924:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2928:	6705                	lui	a4,0x1
      *b = 99;
    292a:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3ffeefc8>
    for(b = a; b < a+TOOMUCH; b += 4096){
    292e:	953a                	add	a0,a0,a4
    2930:	fef51de3          	bne	a0,a5,292a <sbrkbasic+0x3e>
    exit(1);
    2934:	4505                	li	a0,1
    2936:	00003097          	auipc	ra,0x3
    293a:	30c080e7          	jalr	780(ra) # 5c42 <exit>
    293e:	f426                	sd	s1,40(sp)
    2940:	f04a                	sd	s2,32(sp)
    2942:	e852                	sd	s4,16(sp)
    printf("fork failed in sbrkbasic\n");
    2944:	00004517          	auipc	a0,0x4
    2948:	62c50513          	add	a0,a0,1580 # 6f70 <malloc+0xefe>
    294c:	00003097          	auipc	ra,0x3
    2950:	66e080e7          	jalr	1646(ra) # 5fba <printf>
    exit(1);
    2954:	4505                	li	a0,1
    2956:	00003097          	auipc	ra,0x3
    295a:	2ec080e7          	jalr	748(ra) # 5c42 <exit>
    295e:	f426                	sd	s1,40(sp)
    2960:	f04a                	sd	s2,32(sp)
    2962:	e852                	sd	s4,16(sp)
      exit(0);
    2964:	4501                	li	a0,0
    2966:	00003097          	auipc	ra,0x3
    296a:	2dc080e7          	jalr	732(ra) # 5c42 <exit>
  wait(&xstatus);
    296e:	fcc40513          	add	a0,s0,-52
    2972:	00003097          	auipc	ra,0x3
    2976:	2d8080e7          	jalr	728(ra) # 5c4a <wait>
  if(xstatus == 1){
    297a:	fcc42703          	lw	a4,-52(s0)
    297e:	4785                	li	a5,1
    2980:	02f70063          	beq	a4,a5,29a0 <sbrkbasic+0xb4>
    2984:	f426                	sd	s1,40(sp)
    2986:	f04a                	sd	s2,32(sp)
    2988:	e852                	sd	s4,16(sp)
  a = sbrk(0);
    298a:	4501                	li	a0,0
    298c:	00003097          	auipc	ra,0x3
    2990:	33e080e7          	jalr	830(ra) # 5cca <sbrk>
    2994:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2996:	4901                	li	s2,0
    2998:	6a05                	lui	s4,0x1
    299a:	388a0a13          	add	s4,s4,904 # 1388 <badarg+0x3c>
    299e:	a01d                	j	29c4 <sbrkbasic+0xd8>
    29a0:	f426                	sd	s1,40(sp)
    29a2:	f04a                	sd	s2,32(sp)
    29a4:	e852                	sd	s4,16(sp)
    printf("%s: too much memory allocated!\n", s);
    29a6:	85ce                	mv	a1,s3
    29a8:	00004517          	auipc	a0,0x4
    29ac:	5e850513          	add	a0,a0,1512 # 6f90 <malloc+0xf1e>
    29b0:	00003097          	auipc	ra,0x3
    29b4:	60a080e7          	jalr	1546(ra) # 5fba <printf>
    exit(1);
    29b8:	4505                	li	a0,1
    29ba:	00003097          	auipc	ra,0x3
    29be:	288080e7          	jalr	648(ra) # 5c42 <exit>
    29c2:	84be                	mv	s1,a5
    b = sbrk(1);
    29c4:	4505                	li	a0,1
    29c6:	00003097          	auipc	ra,0x3
    29ca:	304080e7          	jalr	772(ra) # 5cca <sbrk>
    if(b != a){
    29ce:	04951c63          	bne	a0,s1,2a26 <sbrkbasic+0x13a>
    *b = 1;
    29d2:	4785                	li	a5,1
    29d4:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    29d8:	00148793          	add	a5,s1,1
  for(i = 0; i < 5000; i++){
    29dc:	2905                	addw	s2,s2,1
    29de:	ff4912e3          	bne	s2,s4,29c2 <sbrkbasic+0xd6>
  pid = fork();
    29e2:	00003097          	auipc	ra,0x3
    29e6:	258080e7          	jalr	600(ra) # 5c3a <fork>
    29ea:	892a                	mv	s2,a0
  if(pid < 0){
    29ec:	04054e63          	bltz	a0,2a48 <sbrkbasic+0x15c>
  c = sbrk(1);
    29f0:	4505                	li	a0,1
    29f2:	00003097          	auipc	ra,0x3
    29f6:	2d8080e7          	jalr	728(ra) # 5cca <sbrk>
  c = sbrk(1);
    29fa:	4505                	li	a0,1
    29fc:	00003097          	auipc	ra,0x3
    2a00:	2ce080e7          	jalr	718(ra) # 5cca <sbrk>
  if(c != a + 1){
    2a04:	0489                	add	s1,s1,2
    2a06:	04a48f63          	beq	s1,a0,2a64 <sbrkbasic+0x178>
    printf("%s: sbrk test failed post-fork\n", s);
    2a0a:	85ce                	mv	a1,s3
    2a0c:	00004517          	auipc	a0,0x4
    2a10:	5e450513          	add	a0,a0,1508 # 6ff0 <malloc+0xf7e>
    2a14:	00003097          	auipc	ra,0x3
    2a18:	5a6080e7          	jalr	1446(ra) # 5fba <printf>
    exit(1);
    2a1c:	4505                	li	a0,1
    2a1e:	00003097          	auipc	ra,0x3
    2a22:	224080e7          	jalr	548(ra) # 5c42 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    2a26:	872a                	mv	a4,a0
    2a28:	86a6                	mv	a3,s1
    2a2a:	864a                	mv	a2,s2
    2a2c:	85ce                	mv	a1,s3
    2a2e:	00004517          	auipc	a0,0x4
    2a32:	58250513          	add	a0,a0,1410 # 6fb0 <malloc+0xf3e>
    2a36:	00003097          	auipc	ra,0x3
    2a3a:	584080e7          	jalr	1412(ra) # 5fba <printf>
      exit(1);
    2a3e:	4505                	li	a0,1
    2a40:	00003097          	auipc	ra,0x3
    2a44:	202080e7          	jalr	514(ra) # 5c42 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2a48:	85ce                	mv	a1,s3
    2a4a:	00004517          	auipc	a0,0x4
    2a4e:	58650513          	add	a0,a0,1414 # 6fd0 <malloc+0xf5e>
    2a52:	00003097          	auipc	ra,0x3
    2a56:	568080e7          	jalr	1384(ra) # 5fba <printf>
    exit(1);
    2a5a:	4505                	li	a0,1
    2a5c:	00003097          	auipc	ra,0x3
    2a60:	1e6080e7          	jalr	486(ra) # 5c42 <exit>
  if(pid == 0)
    2a64:	00091763          	bnez	s2,2a72 <sbrkbasic+0x186>
    exit(0);
    2a68:	4501                	li	a0,0
    2a6a:	00003097          	auipc	ra,0x3
    2a6e:	1d8080e7          	jalr	472(ra) # 5c42 <exit>
  wait(&xstatus);
    2a72:	fcc40513          	add	a0,s0,-52
    2a76:	00003097          	auipc	ra,0x3
    2a7a:	1d4080e7          	jalr	468(ra) # 5c4a <wait>
  exit(xstatus);
    2a7e:	fcc42503          	lw	a0,-52(s0)
    2a82:	00003097          	auipc	ra,0x3
    2a86:	1c0080e7          	jalr	448(ra) # 5c42 <exit>

0000000000002a8a <sbrkmuch>:
{
    2a8a:	7179                	add	sp,sp,-48
    2a8c:	f406                	sd	ra,40(sp)
    2a8e:	f022                	sd	s0,32(sp)
    2a90:	ec26                	sd	s1,24(sp)
    2a92:	e84a                	sd	s2,16(sp)
    2a94:	e44e                	sd	s3,8(sp)
    2a96:	e052                	sd	s4,0(sp)
    2a98:	1800                	add	s0,sp,48
    2a9a:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2a9c:	4501                	li	a0,0
    2a9e:	00003097          	auipc	ra,0x3
    2aa2:	22c080e7          	jalr	556(ra) # 5cca <sbrk>
    2aa6:	892a                	mv	s2,a0
  a = sbrk(0);
    2aa8:	4501                	li	a0,0
    2aaa:	00003097          	auipc	ra,0x3
    2aae:	220080e7          	jalr	544(ra) # 5cca <sbrk>
    2ab2:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2ab4:	06400537          	lui	a0,0x6400
    2ab8:	9d05                	subw	a0,a0,s1
    2aba:	00003097          	auipc	ra,0x3
    2abe:	210080e7          	jalr	528(ra) # 5cca <sbrk>
  if (p != a) {
    2ac2:	0ca49863          	bne	s1,a0,2b92 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2ac6:	4501                	li	a0,0
    2ac8:	00003097          	auipc	ra,0x3
    2acc:	202080e7          	jalr	514(ra) # 5cca <sbrk>
    2ad0:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2ad2:	00a4f963          	bgeu	s1,a0,2ae4 <sbrkmuch+0x5a>
    *pp = 1;
    2ad6:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2ad8:	6705                	lui	a4,0x1
    *pp = 1;
    2ada:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2ade:	94ba                	add	s1,s1,a4
    2ae0:	fef4ede3          	bltu	s1,a5,2ada <sbrkmuch+0x50>
  *lastaddr = 99;
    2ae4:	064007b7          	lui	a5,0x6400
    2ae8:	06300713          	li	a4,99
    2aec:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63eefc7>
  a = sbrk(0);
    2af0:	4501                	li	a0,0
    2af2:	00003097          	auipc	ra,0x3
    2af6:	1d8080e7          	jalr	472(ra) # 5cca <sbrk>
    2afa:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2afc:	757d                	lui	a0,0xfffff
    2afe:	00003097          	auipc	ra,0x3
    2b02:	1cc080e7          	jalr	460(ra) # 5cca <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2b06:	57fd                	li	a5,-1
    2b08:	0af50363          	beq	a0,a5,2bae <sbrkmuch+0x124>
  c = sbrk(0);
    2b0c:	4501                	li	a0,0
    2b0e:	00003097          	auipc	ra,0x3
    2b12:	1bc080e7          	jalr	444(ra) # 5cca <sbrk>
  if(c != a - PGSIZE){
    2b16:	77fd                	lui	a5,0xfffff
    2b18:	97a6                	add	a5,a5,s1
    2b1a:	0af51863          	bne	a0,a5,2bca <sbrkmuch+0x140>
  a = sbrk(0);
    2b1e:	4501                	li	a0,0
    2b20:	00003097          	auipc	ra,0x3
    2b24:	1aa080e7          	jalr	426(ra) # 5cca <sbrk>
    2b28:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2b2a:	6505                	lui	a0,0x1
    2b2c:	00003097          	auipc	ra,0x3
    2b30:	19e080e7          	jalr	414(ra) # 5cca <sbrk>
    2b34:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2b36:	0aa49a63          	bne	s1,a0,2bea <sbrkmuch+0x160>
    2b3a:	4501                	li	a0,0
    2b3c:	00003097          	auipc	ra,0x3
    2b40:	18e080e7          	jalr	398(ra) # 5cca <sbrk>
    2b44:	6785                	lui	a5,0x1
    2b46:	97a6                	add	a5,a5,s1
    2b48:	0af51163          	bne	a0,a5,2bea <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2b4c:	064007b7          	lui	a5,0x6400
    2b50:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63eefc7>
    2b54:	06300793          	li	a5,99
    2b58:	0af70963          	beq	a4,a5,2c0a <sbrkmuch+0x180>
  a = sbrk(0);
    2b5c:	4501                	li	a0,0
    2b5e:	00003097          	auipc	ra,0x3
    2b62:	16c080e7          	jalr	364(ra) # 5cca <sbrk>
    2b66:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2b68:	4501                	li	a0,0
    2b6a:	00003097          	auipc	ra,0x3
    2b6e:	160080e7          	jalr	352(ra) # 5cca <sbrk>
    2b72:	40a9053b          	subw	a0,s2,a0
    2b76:	00003097          	auipc	ra,0x3
    2b7a:	154080e7          	jalr	340(ra) # 5cca <sbrk>
  if(c != a){
    2b7e:	0aa49463          	bne	s1,a0,2c26 <sbrkmuch+0x19c>
}
    2b82:	70a2                	ld	ra,40(sp)
    2b84:	7402                	ld	s0,32(sp)
    2b86:	64e2                	ld	s1,24(sp)
    2b88:	6942                	ld	s2,16(sp)
    2b8a:	69a2                	ld	s3,8(sp)
    2b8c:	6a02                	ld	s4,0(sp)
    2b8e:	6145                	add	sp,sp,48
    2b90:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2b92:	85ce                	mv	a1,s3
    2b94:	00004517          	auipc	a0,0x4
    2b98:	47c50513          	add	a0,a0,1148 # 7010 <malloc+0xf9e>
    2b9c:	00003097          	auipc	ra,0x3
    2ba0:	41e080e7          	jalr	1054(ra) # 5fba <printf>
    exit(1);
    2ba4:	4505                	li	a0,1
    2ba6:	00003097          	auipc	ra,0x3
    2baa:	09c080e7          	jalr	156(ra) # 5c42 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2bae:	85ce                	mv	a1,s3
    2bb0:	00004517          	auipc	a0,0x4
    2bb4:	4a850513          	add	a0,a0,1192 # 7058 <malloc+0xfe6>
    2bb8:	00003097          	auipc	ra,0x3
    2bbc:	402080e7          	jalr	1026(ra) # 5fba <printf>
    exit(1);
    2bc0:	4505                	li	a0,1
    2bc2:	00003097          	auipc	ra,0x3
    2bc6:	080080e7          	jalr	128(ra) # 5c42 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2bca:	86aa                	mv	a3,a0
    2bcc:	8626                	mv	a2,s1
    2bce:	85ce                	mv	a1,s3
    2bd0:	00004517          	auipc	a0,0x4
    2bd4:	4a850513          	add	a0,a0,1192 # 7078 <malloc+0x1006>
    2bd8:	00003097          	auipc	ra,0x3
    2bdc:	3e2080e7          	jalr	994(ra) # 5fba <printf>
    exit(1);
    2be0:	4505                	li	a0,1
    2be2:	00003097          	auipc	ra,0x3
    2be6:	060080e7          	jalr	96(ra) # 5c42 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2bea:	86d2                	mv	a3,s4
    2bec:	8626                	mv	a2,s1
    2bee:	85ce                	mv	a1,s3
    2bf0:	00004517          	auipc	a0,0x4
    2bf4:	4c850513          	add	a0,a0,1224 # 70b8 <malloc+0x1046>
    2bf8:	00003097          	auipc	ra,0x3
    2bfc:	3c2080e7          	jalr	962(ra) # 5fba <printf>
    exit(1);
    2c00:	4505                	li	a0,1
    2c02:	00003097          	auipc	ra,0x3
    2c06:	040080e7          	jalr	64(ra) # 5c42 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2c0a:	85ce                	mv	a1,s3
    2c0c:	00004517          	auipc	a0,0x4
    2c10:	4dc50513          	add	a0,a0,1244 # 70e8 <malloc+0x1076>
    2c14:	00003097          	auipc	ra,0x3
    2c18:	3a6080e7          	jalr	934(ra) # 5fba <printf>
    exit(1);
    2c1c:	4505                	li	a0,1
    2c1e:	00003097          	auipc	ra,0x3
    2c22:	024080e7          	jalr	36(ra) # 5c42 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2c26:	86aa                	mv	a3,a0
    2c28:	8626                	mv	a2,s1
    2c2a:	85ce                	mv	a1,s3
    2c2c:	00004517          	auipc	a0,0x4
    2c30:	4f450513          	add	a0,a0,1268 # 7120 <malloc+0x10ae>
    2c34:	00003097          	auipc	ra,0x3
    2c38:	386080e7          	jalr	902(ra) # 5fba <printf>
    exit(1);
    2c3c:	4505                	li	a0,1
    2c3e:	00003097          	auipc	ra,0x3
    2c42:	004080e7          	jalr	4(ra) # 5c42 <exit>

0000000000002c46 <sbrkarg>:
{
    2c46:	7179                	add	sp,sp,-48
    2c48:	f406                	sd	ra,40(sp)
    2c4a:	f022                	sd	s0,32(sp)
    2c4c:	ec26                	sd	s1,24(sp)
    2c4e:	e84a                	sd	s2,16(sp)
    2c50:	e44e                	sd	s3,8(sp)
    2c52:	1800                	add	s0,sp,48
    2c54:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2c56:	6505                	lui	a0,0x1
    2c58:	00003097          	auipc	ra,0x3
    2c5c:	072080e7          	jalr	114(ra) # 5cca <sbrk>
    2c60:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2c62:	20100593          	li	a1,513
    2c66:	00004517          	auipc	a0,0x4
    2c6a:	4e250513          	add	a0,a0,1250 # 7148 <malloc+0x10d6>
    2c6e:	00003097          	auipc	ra,0x3
    2c72:	014080e7          	jalr	20(ra) # 5c82 <open>
    2c76:	84aa                	mv	s1,a0
  unlink("sbrk");
    2c78:	00004517          	auipc	a0,0x4
    2c7c:	4d050513          	add	a0,a0,1232 # 7148 <malloc+0x10d6>
    2c80:	00003097          	auipc	ra,0x3
    2c84:	012080e7          	jalr	18(ra) # 5c92 <unlink>
  if(fd < 0)  {
    2c88:	0404c163          	bltz	s1,2cca <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2c8c:	6605                	lui	a2,0x1
    2c8e:	85ca                	mv	a1,s2
    2c90:	8526                	mv	a0,s1
    2c92:	00003097          	auipc	ra,0x3
    2c96:	fd0080e7          	jalr	-48(ra) # 5c62 <write>
    2c9a:	04054663          	bltz	a0,2ce6 <sbrkarg+0xa0>
  close(fd);
    2c9e:	8526                	mv	a0,s1
    2ca0:	00003097          	auipc	ra,0x3
    2ca4:	fca080e7          	jalr	-54(ra) # 5c6a <close>
  a = sbrk(PGSIZE);
    2ca8:	6505                	lui	a0,0x1
    2caa:	00003097          	auipc	ra,0x3
    2cae:	020080e7          	jalr	32(ra) # 5cca <sbrk>
  if(pipe((int *) a) != 0){
    2cb2:	00003097          	auipc	ra,0x3
    2cb6:	fa0080e7          	jalr	-96(ra) # 5c52 <pipe>
    2cba:	e521                	bnez	a0,2d02 <sbrkarg+0xbc>
}
    2cbc:	70a2                	ld	ra,40(sp)
    2cbe:	7402                	ld	s0,32(sp)
    2cc0:	64e2                	ld	s1,24(sp)
    2cc2:	6942                	ld	s2,16(sp)
    2cc4:	69a2                	ld	s3,8(sp)
    2cc6:	6145                	add	sp,sp,48
    2cc8:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2cca:	85ce                	mv	a1,s3
    2ccc:	00004517          	auipc	a0,0x4
    2cd0:	48450513          	add	a0,a0,1156 # 7150 <malloc+0x10de>
    2cd4:	00003097          	auipc	ra,0x3
    2cd8:	2e6080e7          	jalr	742(ra) # 5fba <printf>
    exit(1);
    2cdc:	4505                	li	a0,1
    2cde:	00003097          	auipc	ra,0x3
    2ce2:	f64080e7          	jalr	-156(ra) # 5c42 <exit>
    printf("%s: write sbrk failed\n", s);
    2ce6:	85ce                	mv	a1,s3
    2ce8:	00004517          	auipc	a0,0x4
    2cec:	48050513          	add	a0,a0,1152 # 7168 <malloc+0x10f6>
    2cf0:	00003097          	auipc	ra,0x3
    2cf4:	2ca080e7          	jalr	714(ra) # 5fba <printf>
    exit(1);
    2cf8:	4505                	li	a0,1
    2cfa:	00003097          	auipc	ra,0x3
    2cfe:	f48080e7          	jalr	-184(ra) # 5c42 <exit>
    printf("%s: pipe() failed\n", s);
    2d02:	85ce                	mv	a1,s3
    2d04:	00004517          	auipc	a0,0x4
    2d08:	e4450513          	add	a0,a0,-444 # 6b48 <malloc+0xad6>
    2d0c:	00003097          	auipc	ra,0x3
    2d10:	2ae080e7          	jalr	686(ra) # 5fba <printf>
    exit(1);
    2d14:	4505                	li	a0,1
    2d16:	00003097          	auipc	ra,0x3
    2d1a:	f2c080e7          	jalr	-212(ra) # 5c42 <exit>

0000000000002d1e <argptest>:
{
    2d1e:	1101                	add	sp,sp,-32
    2d20:	ec06                	sd	ra,24(sp)
    2d22:	e822                	sd	s0,16(sp)
    2d24:	e426                	sd	s1,8(sp)
    2d26:	e04a                	sd	s2,0(sp)
    2d28:	1000                	add	s0,sp,32
    2d2a:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2d2c:	4581                	li	a1,0
    2d2e:	00004517          	auipc	a0,0x4
    2d32:	45250513          	add	a0,a0,1106 # 7180 <malloc+0x110e>
    2d36:	00003097          	auipc	ra,0x3
    2d3a:	f4c080e7          	jalr	-180(ra) # 5c82 <open>
  if (fd < 0) {
    2d3e:	02054b63          	bltz	a0,2d74 <argptest+0x56>
    2d42:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2d44:	4501                	li	a0,0
    2d46:	00003097          	auipc	ra,0x3
    2d4a:	f84080e7          	jalr	-124(ra) # 5cca <sbrk>
    2d4e:	567d                	li	a2,-1
    2d50:	fff50593          	add	a1,a0,-1
    2d54:	8526                	mv	a0,s1
    2d56:	00003097          	auipc	ra,0x3
    2d5a:	f04080e7          	jalr	-252(ra) # 5c5a <read>
  close(fd);
    2d5e:	8526                	mv	a0,s1
    2d60:	00003097          	auipc	ra,0x3
    2d64:	f0a080e7          	jalr	-246(ra) # 5c6a <close>
}
    2d68:	60e2                	ld	ra,24(sp)
    2d6a:	6442                	ld	s0,16(sp)
    2d6c:	64a2                	ld	s1,8(sp)
    2d6e:	6902                	ld	s2,0(sp)
    2d70:	6105                	add	sp,sp,32
    2d72:	8082                	ret
    printf("%s: open failed\n", s);
    2d74:	85ca                	mv	a1,s2
    2d76:	00004517          	auipc	a0,0x4
    2d7a:	ce250513          	add	a0,a0,-798 # 6a58 <malloc+0x9e6>
    2d7e:	00003097          	auipc	ra,0x3
    2d82:	23c080e7          	jalr	572(ra) # 5fba <printf>
    exit(1);
    2d86:	4505                	li	a0,1
    2d88:	00003097          	auipc	ra,0x3
    2d8c:	eba080e7          	jalr	-326(ra) # 5c42 <exit>

0000000000002d90 <sbrkbugs>:
{
    2d90:	1141                	add	sp,sp,-16
    2d92:	e406                	sd	ra,8(sp)
    2d94:	e022                	sd	s0,0(sp)
    2d96:	0800                	add	s0,sp,16
  int pid = fork();
    2d98:	00003097          	auipc	ra,0x3
    2d9c:	ea2080e7          	jalr	-350(ra) # 5c3a <fork>
  if(pid < 0){
    2da0:	02054263          	bltz	a0,2dc4 <sbrkbugs+0x34>
  if(pid == 0){
    2da4:	ed0d                	bnez	a0,2dde <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2da6:	00003097          	auipc	ra,0x3
    2daa:	f24080e7          	jalr	-220(ra) # 5cca <sbrk>
    sbrk(-sz);
    2dae:	40a0053b          	negw	a0,a0
    2db2:	00003097          	auipc	ra,0x3
    2db6:	f18080e7          	jalr	-232(ra) # 5cca <sbrk>
    exit(0);
    2dba:	4501                	li	a0,0
    2dbc:	00003097          	auipc	ra,0x3
    2dc0:	e86080e7          	jalr	-378(ra) # 5c42 <exit>
    printf("fork failed\n");
    2dc4:	00004517          	auipc	a0,0x4
    2dc8:	08450513          	add	a0,a0,132 # 6e48 <malloc+0xdd6>
    2dcc:	00003097          	auipc	ra,0x3
    2dd0:	1ee080e7          	jalr	494(ra) # 5fba <printf>
    exit(1);
    2dd4:	4505                	li	a0,1
    2dd6:	00003097          	auipc	ra,0x3
    2dda:	e6c080e7          	jalr	-404(ra) # 5c42 <exit>
  wait(0);
    2dde:	4501                	li	a0,0
    2de0:	00003097          	auipc	ra,0x3
    2de4:	e6a080e7          	jalr	-406(ra) # 5c4a <wait>
  pid = fork();
    2de8:	00003097          	auipc	ra,0x3
    2dec:	e52080e7          	jalr	-430(ra) # 5c3a <fork>
  if(pid < 0){
    2df0:	02054563          	bltz	a0,2e1a <sbrkbugs+0x8a>
  if(pid == 0){
    2df4:	e121                	bnez	a0,2e34 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2df6:	00003097          	auipc	ra,0x3
    2dfa:	ed4080e7          	jalr	-300(ra) # 5cca <sbrk>
    sbrk(-(sz - 3500));
    2dfe:	6785                	lui	a5,0x1
    2e00:	dac7879b          	addw	a5,a5,-596 # dac <unlinkread+0x6c>
    2e04:	40a7853b          	subw	a0,a5,a0
    2e08:	00003097          	auipc	ra,0x3
    2e0c:	ec2080e7          	jalr	-318(ra) # 5cca <sbrk>
    exit(0);
    2e10:	4501                	li	a0,0
    2e12:	00003097          	auipc	ra,0x3
    2e16:	e30080e7          	jalr	-464(ra) # 5c42 <exit>
    printf("fork failed\n");
    2e1a:	00004517          	auipc	a0,0x4
    2e1e:	02e50513          	add	a0,a0,46 # 6e48 <malloc+0xdd6>
    2e22:	00003097          	auipc	ra,0x3
    2e26:	198080e7          	jalr	408(ra) # 5fba <printf>
    exit(1);
    2e2a:	4505                	li	a0,1
    2e2c:	00003097          	auipc	ra,0x3
    2e30:	e16080e7          	jalr	-490(ra) # 5c42 <exit>
  wait(0);
    2e34:	4501                	li	a0,0
    2e36:	00003097          	auipc	ra,0x3
    2e3a:	e14080e7          	jalr	-492(ra) # 5c4a <wait>
  pid = fork();
    2e3e:	00003097          	auipc	ra,0x3
    2e42:	dfc080e7          	jalr	-516(ra) # 5c3a <fork>
  if(pid < 0){
    2e46:	02054a63          	bltz	a0,2e7a <sbrkbugs+0xea>
  if(pid == 0){
    2e4a:	e529                	bnez	a0,2e94 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2e4c:	00003097          	auipc	ra,0x3
    2e50:	e7e080e7          	jalr	-386(ra) # 5cca <sbrk>
    2e54:	67ad                	lui	a5,0xb
    2e56:	8007879b          	addw	a5,a5,-2048 # a800 <slowtests+0x60>
    2e5a:	40a7853b          	subw	a0,a5,a0
    2e5e:	00003097          	auipc	ra,0x3
    2e62:	e6c080e7          	jalr	-404(ra) # 5cca <sbrk>
    sbrk(-10);
    2e66:	5559                	li	a0,-10
    2e68:	00003097          	auipc	ra,0x3
    2e6c:	e62080e7          	jalr	-414(ra) # 5cca <sbrk>
    exit(0);
    2e70:	4501                	li	a0,0
    2e72:	00003097          	auipc	ra,0x3
    2e76:	dd0080e7          	jalr	-560(ra) # 5c42 <exit>
    printf("fork failed\n");
    2e7a:	00004517          	auipc	a0,0x4
    2e7e:	fce50513          	add	a0,a0,-50 # 6e48 <malloc+0xdd6>
    2e82:	00003097          	auipc	ra,0x3
    2e86:	138080e7          	jalr	312(ra) # 5fba <printf>
    exit(1);
    2e8a:	4505                	li	a0,1
    2e8c:	00003097          	auipc	ra,0x3
    2e90:	db6080e7          	jalr	-586(ra) # 5c42 <exit>
  wait(0);
    2e94:	4501                	li	a0,0
    2e96:	00003097          	auipc	ra,0x3
    2e9a:	db4080e7          	jalr	-588(ra) # 5c4a <wait>
  exit(0);
    2e9e:	4501                	li	a0,0
    2ea0:	00003097          	auipc	ra,0x3
    2ea4:	da2080e7          	jalr	-606(ra) # 5c42 <exit>

0000000000002ea8 <sbrklast>:
{
    2ea8:	7179                	add	sp,sp,-48
    2eaa:	f406                	sd	ra,40(sp)
    2eac:	f022                	sd	s0,32(sp)
    2eae:	ec26                	sd	s1,24(sp)
    2eb0:	e84a                	sd	s2,16(sp)
    2eb2:	e44e                	sd	s3,8(sp)
    2eb4:	e052                	sd	s4,0(sp)
    2eb6:	1800                	add	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2eb8:	4501                	li	a0,0
    2eba:	00003097          	auipc	ra,0x3
    2ebe:	e10080e7          	jalr	-496(ra) # 5cca <sbrk>
  if((top % 4096) != 0)
    2ec2:	03451793          	sll	a5,a0,0x34
    2ec6:	ebd9                	bnez	a5,2f5c <sbrklast+0xb4>
  sbrk(4096);
    2ec8:	6505                	lui	a0,0x1
    2eca:	00003097          	auipc	ra,0x3
    2ece:	e00080e7          	jalr	-512(ra) # 5cca <sbrk>
  sbrk(10);
    2ed2:	4529                	li	a0,10
    2ed4:	00003097          	auipc	ra,0x3
    2ed8:	df6080e7          	jalr	-522(ra) # 5cca <sbrk>
  sbrk(-20);
    2edc:	5531                	li	a0,-20
    2ede:	00003097          	auipc	ra,0x3
    2ee2:	dec080e7          	jalr	-532(ra) # 5cca <sbrk>
  top = (uint64) sbrk(0);
    2ee6:	4501                	li	a0,0
    2ee8:	00003097          	auipc	ra,0x3
    2eec:	de2080e7          	jalr	-542(ra) # 5cca <sbrk>
    2ef0:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2ef2:	fc050913          	add	s2,a0,-64 # fc0 <linktest+0xca>
  p[0] = 'x';
    2ef6:	07800a13          	li	s4,120
    2efa:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2efe:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2f02:	20200593          	li	a1,514
    2f06:	854a                	mv	a0,s2
    2f08:	00003097          	auipc	ra,0x3
    2f0c:	d7a080e7          	jalr	-646(ra) # 5c82 <open>
    2f10:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2f12:	4605                	li	a2,1
    2f14:	85ca                	mv	a1,s2
    2f16:	00003097          	auipc	ra,0x3
    2f1a:	d4c080e7          	jalr	-692(ra) # 5c62 <write>
  close(fd);
    2f1e:	854e                	mv	a0,s3
    2f20:	00003097          	auipc	ra,0x3
    2f24:	d4a080e7          	jalr	-694(ra) # 5c6a <close>
  fd = open(p, O_RDWR);
    2f28:	4589                	li	a1,2
    2f2a:	854a                	mv	a0,s2
    2f2c:	00003097          	auipc	ra,0x3
    2f30:	d56080e7          	jalr	-682(ra) # 5c82 <open>
  p[0] = '\0';
    2f34:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2f38:	4605                	li	a2,1
    2f3a:	85ca                	mv	a1,s2
    2f3c:	00003097          	auipc	ra,0x3
    2f40:	d1e080e7          	jalr	-738(ra) # 5c5a <read>
  if(p[0] != 'x')
    2f44:	fc04c783          	lbu	a5,-64(s1)
    2f48:	03479463          	bne	a5,s4,2f70 <sbrklast+0xc8>
}
    2f4c:	70a2                	ld	ra,40(sp)
    2f4e:	7402                	ld	s0,32(sp)
    2f50:	64e2                	ld	s1,24(sp)
    2f52:	6942                	ld	s2,16(sp)
    2f54:	69a2                	ld	s3,8(sp)
    2f56:	6a02                	ld	s4,0(sp)
    2f58:	6145                	add	sp,sp,48
    2f5a:	8082                	ret
    sbrk(4096 - (top % 4096));
    2f5c:	0347d513          	srl	a0,a5,0x34
    2f60:	6785                	lui	a5,0x1
    2f62:	40a7853b          	subw	a0,a5,a0
    2f66:	00003097          	auipc	ra,0x3
    2f6a:	d64080e7          	jalr	-668(ra) # 5cca <sbrk>
    2f6e:	bfa9                	j	2ec8 <sbrklast+0x20>
    exit(1);
    2f70:	4505                	li	a0,1
    2f72:	00003097          	auipc	ra,0x3
    2f76:	cd0080e7          	jalr	-816(ra) # 5c42 <exit>

0000000000002f7a <sbrk8000>:
{
    2f7a:	1141                	add	sp,sp,-16
    2f7c:	e406                	sd	ra,8(sp)
    2f7e:	e022                	sd	s0,0(sp)
    2f80:	0800                	add	s0,sp,16
  sbrk(0x80000004);
    2f82:	80000537          	lui	a0,0x80000
    2f86:	0511                	add	a0,a0,4 # ffffffff80000004 <base+0xffffffff7ffeefcc>
    2f88:	00003097          	auipc	ra,0x3
    2f8c:	d42080e7          	jalr	-702(ra) # 5cca <sbrk>
  volatile char *top = sbrk(0);
    2f90:	4501                	li	a0,0
    2f92:	00003097          	auipc	ra,0x3
    2f96:	d38080e7          	jalr	-712(ra) # 5cca <sbrk>
  *(top-1) = *(top-1) + 1;
    2f9a:	fff54783          	lbu	a5,-1(a0)
    2f9e:	2785                	addw	a5,a5,1 # 1001 <linktest+0x10b>
    2fa0:	0ff7f793          	zext.b	a5,a5
    2fa4:	fef50fa3          	sb	a5,-1(a0)
}
    2fa8:	60a2                	ld	ra,8(sp)
    2faa:	6402                	ld	s0,0(sp)
    2fac:	0141                	add	sp,sp,16
    2fae:	8082                	ret

0000000000002fb0 <execout>:
{
    2fb0:	715d                	add	sp,sp,-80
    2fb2:	e486                	sd	ra,72(sp)
    2fb4:	e0a2                	sd	s0,64(sp)
    2fb6:	fc26                	sd	s1,56(sp)
    2fb8:	f84a                	sd	s2,48(sp)
    2fba:	f44e                	sd	s3,40(sp)
    2fbc:	f052                	sd	s4,32(sp)
    2fbe:	0880                	add	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2fc0:	4901                	li	s2,0
    2fc2:	49bd                	li	s3,15
    int pid = fork();
    2fc4:	00003097          	auipc	ra,0x3
    2fc8:	c76080e7          	jalr	-906(ra) # 5c3a <fork>
    2fcc:	84aa                	mv	s1,a0
    if(pid < 0){
    2fce:	02054063          	bltz	a0,2fee <execout+0x3e>
    } else if(pid == 0){
    2fd2:	c91d                	beqz	a0,3008 <execout+0x58>
      wait((int*)0);
    2fd4:	4501                	li	a0,0
    2fd6:	00003097          	auipc	ra,0x3
    2fda:	c74080e7          	jalr	-908(ra) # 5c4a <wait>
  for(int avail = 0; avail < 15; avail++){
    2fde:	2905                	addw	s2,s2,1
    2fe0:	ff3912e3          	bne	s2,s3,2fc4 <execout+0x14>
  exit(0);
    2fe4:	4501                	li	a0,0
    2fe6:	00003097          	auipc	ra,0x3
    2fea:	c5c080e7          	jalr	-932(ra) # 5c42 <exit>
      printf("fork failed\n");
    2fee:	00004517          	auipc	a0,0x4
    2ff2:	e5a50513          	add	a0,a0,-422 # 6e48 <malloc+0xdd6>
    2ff6:	00003097          	auipc	ra,0x3
    2ffa:	fc4080e7          	jalr	-60(ra) # 5fba <printf>
      exit(1);
    2ffe:	4505                	li	a0,1
    3000:	00003097          	auipc	ra,0x3
    3004:	c42080e7          	jalr	-958(ra) # 5c42 <exit>
        if(a == 0xffffffffffffffffLL)
    3008:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    300a:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    300c:	6505                	lui	a0,0x1
    300e:	00003097          	auipc	ra,0x3
    3012:	cbc080e7          	jalr	-836(ra) # 5cca <sbrk>
        if(a == 0xffffffffffffffffLL)
    3016:	01350763          	beq	a0,s3,3024 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    301a:	6785                	lui	a5,0x1
    301c:	97aa                	add	a5,a5,a0
    301e:	ff478fa3          	sb	s4,-1(a5) # fff <linktest+0x109>
      while(1){
    3022:	b7ed                	j	300c <execout+0x5c>
      for(int i = 0; i < avail; i++)
    3024:	01205a63          	blez	s2,3038 <execout+0x88>
        sbrk(-4096);
    3028:	757d                	lui	a0,0xfffff
    302a:	00003097          	auipc	ra,0x3
    302e:	ca0080e7          	jalr	-864(ra) # 5cca <sbrk>
      for(int i = 0; i < avail; i++)
    3032:	2485                	addw	s1,s1,1
    3034:	ff249ae3          	bne	s1,s2,3028 <execout+0x78>
      close(1);
    3038:	4505                	li	a0,1
    303a:	00003097          	auipc	ra,0x3
    303e:	c30080e7          	jalr	-976(ra) # 5c6a <close>
      char *args[] = { "echo", "x", 0 };
    3042:	00003517          	auipc	a0,0x3
    3046:	17650513          	add	a0,a0,374 # 61b8 <malloc+0x146>
    304a:	faa43c23          	sd	a0,-72(s0)
    304e:	00003797          	auipc	a5,0x3
    3052:	1da78793          	add	a5,a5,474 # 6228 <malloc+0x1b6>
    3056:	fcf43023          	sd	a5,-64(s0)
    305a:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    305e:	fb840593          	add	a1,s0,-72
    3062:	00003097          	auipc	ra,0x3
    3066:	c18080e7          	jalr	-1000(ra) # 5c7a <exec>
      exit(0);
    306a:	4501                	li	a0,0
    306c:	00003097          	auipc	ra,0x3
    3070:	bd6080e7          	jalr	-1066(ra) # 5c42 <exit>

0000000000003074 <fourteen>:
{
    3074:	1101                	add	sp,sp,-32
    3076:	ec06                	sd	ra,24(sp)
    3078:	e822                	sd	s0,16(sp)
    307a:	e426                	sd	s1,8(sp)
    307c:	1000                	add	s0,sp,32
    307e:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    3080:	00004517          	auipc	a0,0x4
    3084:	2d850513          	add	a0,a0,728 # 7358 <malloc+0x12e6>
    3088:	00003097          	auipc	ra,0x3
    308c:	c22080e7          	jalr	-990(ra) # 5caa <mkdir>
    3090:	e165                	bnez	a0,3170 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    3092:	00004517          	auipc	a0,0x4
    3096:	11e50513          	add	a0,a0,286 # 71b0 <malloc+0x113e>
    309a:	00003097          	auipc	ra,0x3
    309e:	c10080e7          	jalr	-1008(ra) # 5caa <mkdir>
    30a2:	e56d                	bnez	a0,318c <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    30a4:	20000593          	li	a1,512
    30a8:	00004517          	auipc	a0,0x4
    30ac:	16050513          	add	a0,a0,352 # 7208 <malloc+0x1196>
    30b0:	00003097          	auipc	ra,0x3
    30b4:	bd2080e7          	jalr	-1070(ra) # 5c82 <open>
  if(fd < 0){
    30b8:	0e054863          	bltz	a0,31a8 <fourteen+0x134>
  close(fd);
    30bc:	00003097          	auipc	ra,0x3
    30c0:	bae080e7          	jalr	-1106(ra) # 5c6a <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    30c4:	4581                	li	a1,0
    30c6:	00004517          	auipc	a0,0x4
    30ca:	1ba50513          	add	a0,a0,442 # 7280 <malloc+0x120e>
    30ce:	00003097          	auipc	ra,0x3
    30d2:	bb4080e7          	jalr	-1100(ra) # 5c82 <open>
  if(fd < 0){
    30d6:	0e054763          	bltz	a0,31c4 <fourteen+0x150>
  close(fd);
    30da:	00003097          	auipc	ra,0x3
    30de:	b90080e7          	jalr	-1136(ra) # 5c6a <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    30e2:	00004517          	auipc	a0,0x4
    30e6:	20e50513          	add	a0,a0,526 # 72f0 <malloc+0x127e>
    30ea:	00003097          	auipc	ra,0x3
    30ee:	bc0080e7          	jalr	-1088(ra) # 5caa <mkdir>
    30f2:	c57d                	beqz	a0,31e0 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    30f4:	00004517          	auipc	a0,0x4
    30f8:	25450513          	add	a0,a0,596 # 7348 <malloc+0x12d6>
    30fc:	00003097          	auipc	ra,0x3
    3100:	bae080e7          	jalr	-1106(ra) # 5caa <mkdir>
    3104:	cd65                	beqz	a0,31fc <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    3106:	00004517          	auipc	a0,0x4
    310a:	24250513          	add	a0,a0,578 # 7348 <malloc+0x12d6>
    310e:	00003097          	auipc	ra,0x3
    3112:	b84080e7          	jalr	-1148(ra) # 5c92 <unlink>
  unlink("12345678901234/12345678901234");
    3116:	00004517          	auipc	a0,0x4
    311a:	1da50513          	add	a0,a0,474 # 72f0 <malloc+0x127e>
    311e:	00003097          	auipc	ra,0x3
    3122:	b74080e7          	jalr	-1164(ra) # 5c92 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    3126:	00004517          	auipc	a0,0x4
    312a:	15a50513          	add	a0,a0,346 # 7280 <malloc+0x120e>
    312e:	00003097          	auipc	ra,0x3
    3132:	b64080e7          	jalr	-1180(ra) # 5c92 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    3136:	00004517          	auipc	a0,0x4
    313a:	0d250513          	add	a0,a0,210 # 7208 <malloc+0x1196>
    313e:	00003097          	auipc	ra,0x3
    3142:	b54080e7          	jalr	-1196(ra) # 5c92 <unlink>
  unlink("12345678901234/123456789012345");
    3146:	00004517          	auipc	a0,0x4
    314a:	06a50513          	add	a0,a0,106 # 71b0 <malloc+0x113e>
    314e:	00003097          	auipc	ra,0x3
    3152:	b44080e7          	jalr	-1212(ra) # 5c92 <unlink>
  unlink("12345678901234");
    3156:	00004517          	auipc	a0,0x4
    315a:	20250513          	add	a0,a0,514 # 7358 <malloc+0x12e6>
    315e:	00003097          	auipc	ra,0x3
    3162:	b34080e7          	jalr	-1228(ra) # 5c92 <unlink>
}
    3166:	60e2                	ld	ra,24(sp)
    3168:	6442                	ld	s0,16(sp)
    316a:	64a2                	ld	s1,8(sp)
    316c:	6105                	add	sp,sp,32
    316e:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    3170:	85a6                	mv	a1,s1
    3172:	00004517          	auipc	a0,0x4
    3176:	01650513          	add	a0,a0,22 # 7188 <malloc+0x1116>
    317a:	00003097          	auipc	ra,0x3
    317e:	e40080e7          	jalr	-448(ra) # 5fba <printf>
    exit(1);
    3182:	4505                	li	a0,1
    3184:	00003097          	auipc	ra,0x3
    3188:	abe080e7          	jalr	-1346(ra) # 5c42 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    318c:	85a6                	mv	a1,s1
    318e:	00004517          	auipc	a0,0x4
    3192:	04250513          	add	a0,a0,66 # 71d0 <malloc+0x115e>
    3196:	00003097          	auipc	ra,0x3
    319a:	e24080e7          	jalr	-476(ra) # 5fba <printf>
    exit(1);
    319e:	4505                	li	a0,1
    31a0:	00003097          	auipc	ra,0x3
    31a4:	aa2080e7          	jalr	-1374(ra) # 5c42 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    31a8:	85a6                	mv	a1,s1
    31aa:	00004517          	auipc	a0,0x4
    31ae:	08e50513          	add	a0,a0,142 # 7238 <malloc+0x11c6>
    31b2:	00003097          	auipc	ra,0x3
    31b6:	e08080e7          	jalr	-504(ra) # 5fba <printf>
    exit(1);
    31ba:	4505                	li	a0,1
    31bc:	00003097          	auipc	ra,0x3
    31c0:	a86080e7          	jalr	-1402(ra) # 5c42 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    31c4:	85a6                	mv	a1,s1
    31c6:	00004517          	auipc	a0,0x4
    31ca:	0ea50513          	add	a0,a0,234 # 72b0 <malloc+0x123e>
    31ce:	00003097          	auipc	ra,0x3
    31d2:	dec080e7          	jalr	-532(ra) # 5fba <printf>
    exit(1);
    31d6:	4505                	li	a0,1
    31d8:	00003097          	auipc	ra,0x3
    31dc:	a6a080e7          	jalr	-1430(ra) # 5c42 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    31e0:	85a6                	mv	a1,s1
    31e2:	00004517          	auipc	a0,0x4
    31e6:	12e50513          	add	a0,a0,302 # 7310 <malloc+0x129e>
    31ea:	00003097          	auipc	ra,0x3
    31ee:	dd0080e7          	jalr	-560(ra) # 5fba <printf>
    exit(1);
    31f2:	4505                	li	a0,1
    31f4:	00003097          	auipc	ra,0x3
    31f8:	a4e080e7          	jalr	-1458(ra) # 5c42 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    31fc:	85a6                	mv	a1,s1
    31fe:	00004517          	auipc	a0,0x4
    3202:	16a50513          	add	a0,a0,362 # 7368 <malloc+0x12f6>
    3206:	00003097          	auipc	ra,0x3
    320a:	db4080e7          	jalr	-588(ra) # 5fba <printf>
    exit(1);
    320e:	4505                	li	a0,1
    3210:	00003097          	auipc	ra,0x3
    3214:	a32080e7          	jalr	-1486(ra) # 5c42 <exit>

0000000000003218 <diskfull>:
{
    3218:	b8010113          	add	sp,sp,-1152
    321c:	46113c23          	sd	ra,1144(sp)
    3220:	46813823          	sd	s0,1136(sp)
    3224:	46913423          	sd	s1,1128(sp)
    3228:	47213023          	sd	s2,1120(sp)
    322c:	45313c23          	sd	s3,1112(sp)
    3230:	45413823          	sd	s4,1104(sp)
    3234:	45513423          	sd	s5,1096(sp)
    3238:	45613023          	sd	s6,1088(sp)
    323c:	43713c23          	sd	s7,1080(sp)
    3240:	43813823          	sd	s8,1072(sp)
    3244:	43913423          	sd	s9,1064(sp)
    3248:	48010413          	add	s0,sp,1152
    324c:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    324e:	00004517          	auipc	a0,0x4
    3252:	15250513          	add	a0,a0,338 # 73a0 <malloc+0x132e>
    3256:	00003097          	auipc	ra,0x3
    325a:	a3c080e7          	jalr	-1476(ra) # 5c92 <unlink>
    325e:	03000993          	li	s3,48
    name[0] = 'b';
    3262:	06200b13          	li	s6,98
    name[1] = 'i';
    3266:	06900a93          	li	s5,105
    name[2] = 'g';
    326a:	06700a13          	li	s4,103
    326e:	10c00b93          	li	s7,268
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    3272:	07f00c13          	li	s8,127
    3276:	a269                	j	3400 <diskfull+0x1e8>
      printf("%s: could not create file %s\n", s, name);
    3278:	b8040613          	add	a2,s0,-1152
    327c:	85e6                	mv	a1,s9
    327e:	00004517          	auipc	a0,0x4
    3282:	13250513          	add	a0,a0,306 # 73b0 <malloc+0x133e>
    3286:	00003097          	auipc	ra,0x3
    328a:	d34080e7          	jalr	-716(ra) # 5fba <printf>
      break;
    328e:	a819                	j	32a4 <diskfull+0x8c>
        close(fd);
    3290:	854a                	mv	a0,s2
    3292:	00003097          	auipc	ra,0x3
    3296:	9d8080e7          	jalr	-1576(ra) # 5c6a <close>
    close(fd);
    329a:	854a                	mv	a0,s2
    329c:	00003097          	auipc	ra,0x3
    32a0:	9ce080e7          	jalr	-1586(ra) # 5c6a <close>
  for(int i = 0; i < nzz; i++){
    32a4:	4481                	li	s1,0
    name[0] = 'z';
    32a6:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    32aa:	08000993          	li	s3,128
    name[0] = 'z';
    32ae:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    32b2:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    32b6:	41f4d71b          	sraw	a4,s1,0x1f
    32ba:	01b7571b          	srlw	a4,a4,0x1b
    32be:	009707bb          	addw	a5,a4,s1
    32c2:	4057d69b          	sraw	a3,a5,0x5
    32c6:	0306869b          	addw	a3,a3,48
    32ca:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    32ce:	8bfd                	and	a5,a5,31
    32d0:	9f99                	subw	a5,a5,a4
    32d2:	0307879b          	addw	a5,a5,48
    32d6:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    32da:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    32de:	ba040513          	add	a0,s0,-1120
    32e2:	00003097          	auipc	ra,0x3
    32e6:	9b0080e7          	jalr	-1616(ra) # 5c92 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    32ea:	60200593          	li	a1,1538
    32ee:	ba040513          	add	a0,s0,-1120
    32f2:	00003097          	auipc	ra,0x3
    32f6:	990080e7          	jalr	-1648(ra) # 5c82 <open>
    if(fd < 0)
    32fa:	00054963          	bltz	a0,330c <diskfull+0xf4>
    close(fd);
    32fe:	00003097          	auipc	ra,0x3
    3302:	96c080e7          	jalr	-1684(ra) # 5c6a <close>
  for(int i = 0; i < nzz; i++){
    3306:	2485                	addw	s1,s1,1
    3308:	fb3493e3          	bne	s1,s3,32ae <diskfull+0x96>
  if(mkdir("diskfulldir") == 0)
    330c:	00004517          	auipc	a0,0x4
    3310:	09450513          	add	a0,a0,148 # 73a0 <malloc+0x132e>
    3314:	00003097          	auipc	ra,0x3
    3318:	996080e7          	jalr	-1642(ra) # 5caa <mkdir>
    331c:	12050e63          	beqz	a0,3458 <diskfull+0x240>
  unlink("diskfulldir");
    3320:	00004517          	auipc	a0,0x4
    3324:	08050513          	add	a0,a0,128 # 73a0 <malloc+0x132e>
    3328:	00003097          	auipc	ra,0x3
    332c:	96a080e7          	jalr	-1686(ra) # 5c92 <unlink>
  for(int i = 0; i < nzz; i++){
    3330:	4481                	li	s1,0
    name[0] = 'z';
    3332:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3336:	08000993          	li	s3,128
    name[0] = 'z';
    333a:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    333e:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    3342:	41f4d71b          	sraw	a4,s1,0x1f
    3346:	01b7571b          	srlw	a4,a4,0x1b
    334a:	009707bb          	addw	a5,a4,s1
    334e:	4057d69b          	sraw	a3,a5,0x5
    3352:	0306869b          	addw	a3,a3,48
    3356:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    335a:	8bfd                	and	a5,a5,31
    335c:	9f99                	subw	a5,a5,a4
    335e:	0307879b          	addw	a5,a5,48
    3362:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    3366:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    336a:	ba040513          	add	a0,s0,-1120
    336e:	00003097          	auipc	ra,0x3
    3372:	924080e7          	jalr	-1756(ra) # 5c92 <unlink>
  for(int i = 0; i < nzz; i++){
    3376:	2485                	addw	s1,s1,1
    3378:	fd3491e3          	bne	s1,s3,333a <diskfull+0x122>
    337c:	03000493          	li	s1,48
    name[0] = 'b';
    3380:	06200a93          	li	s5,98
    name[1] = 'i';
    3384:	06900a13          	li	s4,105
    name[2] = 'g';
    3388:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    338c:	07f00913          	li	s2,127
    name[0] = 'b';
    3390:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    3394:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    3398:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    339c:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    33a0:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    33a4:	ba040513          	add	a0,s0,-1120
    33a8:	00003097          	auipc	ra,0x3
    33ac:	8ea080e7          	jalr	-1814(ra) # 5c92 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    33b0:	2485                	addw	s1,s1,1
    33b2:	0ff4f493          	zext.b	s1,s1
    33b6:	fd249de3          	bne	s1,s2,3390 <diskfull+0x178>
}
    33ba:	47813083          	ld	ra,1144(sp)
    33be:	47013403          	ld	s0,1136(sp)
    33c2:	46813483          	ld	s1,1128(sp)
    33c6:	46013903          	ld	s2,1120(sp)
    33ca:	45813983          	ld	s3,1112(sp)
    33ce:	45013a03          	ld	s4,1104(sp)
    33d2:	44813a83          	ld	s5,1096(sp)
    33d6:	44013b03          	ld	s6,1088(sp)
    33da:	43813b83          	ld	s7,1080(sp)
    33de:	43013c03          	ld	s8,1072(sp)
    33e2:	42813c83          	ld	s9,1064(sp)
    33e6:	48010113          	add	sp,sp,1152
    33ea:	8082                	ret
    close(fd);
    33ec:	854a                	mv	a0,s2
    33ee:	00003097          	auipc	ra,0x3
    33f2:	87c080e7          	jalr	-1924(ra) # 5c6a <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    33f6:	2985                	addw	s3,s3,1
    33f8:	0ff9f993          	zext.b	s3,s3
    33fc:	eb8984e3          	beq	s3,s8,32a4 <diskfull+0x8c>
    name[0] = 'b';
    3400:	b9640023          	sb	s6,-1152(s0)
    name[1] = 'i';
    3404:	b95400a3          	sb	s5,-1151(s0)
    name[2] = 'g';
    3408:	b9440123          	sb	s4,-1150(s0)
    name[3] = '0' + fi;
    340c:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    3410:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    3414:	b8040513          	add	a0,s0,-1152
    3418:	00003097          	auipc	ra,0x3
    341c:	87a080e7          	jalr	-1926(ra) # 5c92 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3420:	60200593          	li	a1,1538
    3424:	b8040513          	add	a0,s0,-1152
    3428:	00003097          	auipc	ra,0x3
    342c:	85a080e7          	jalr	-1958(ra) # 5c82 <open>
    3430:	892a                	mv	s2,a0
    if(fd < 0){
    3432:	e40543e3          	bltz	a0,3278 <diskfull+0x60>
    3436:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    3438:	40000613          	li	a2,1024
    343c:	ba040593          	add	a1,s0,-1120
    3440:	854a                	mv	a0,s2
    3442:	00003097          	auipc	ra,0x3
    3446:	820080e7          	jalr	-2016(ra) # 5c62 <write>
    344a:	40000793          	li	a5,1024
    344e:	e4f511e3          	bne	a0,a5,3290 <diskfull+0x78>
    for(int i = 0; i < MAXFILE; i++){
    3452:	34fd                	addw	s1,s1,-1
    3454:	f0f5                	bnez	s1,3438 <diskfull+0x220>
    3456:	bf59                	j	33ec <diskfull+0x1d4>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    3458:	00004517          	auipc	a0,0x4
    345c:	f7850513          	add	a0,a0,-136 # 73d0 <malloc+0x135e>
    3460:	00003097          	auipc	ra,0x3
    3464:	b5a080e7          	jalr	-1190(ra) # 5fba <printf>
    3468:	bd65                	j	3320 <diskfull+0x108>

000000000000346a <iputtest>:
{
    346a:	1101                	add	sp,sp,-32
    346c:	ec06                	sd	ra,24(sp)
    346e:	e822                	sd	s0,16(sp)
    3470:	e426                	sd	s1,8(sp)
    3472:	1000                	add	s0,sp,32
    3474:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    3476:	00004517          	auipc	a0,0x4
    347a:	f8a50513          	add	a0,a0,-118 # 7400 <malloc+0x138e>
    347e:	00003097          	auipc	ra,0x3
    3482:	82c080e7          	jalr	-2004(ra) # 5caa <mkdir>
    3486:	04054563          	bltz	a0,34d0 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    348a:	00004517          	auipc	a0,0x4
    348e:	f7650513          	add	a0,a0,-138 # 7400 <malloc+0x138e>
    3492:	00003097          	auipc	ra,0x3
    3496:	820080e7          	jalr	-2016(ra) # 5cb2 <chdir>
    349a:	04054963          	bltz	a0,34ec <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    349e:	00004517          	auipc	a0,0x4
    34a2:	fa250513          	add	a0,a0,-94 # 7440 <malloc+0x13ce>
    34a6:	00002097          	auipc	ra,0x2
    34aa:	7ec080e7          	jalr	2028(ra) # 5c92 <unlink>
    34ae:	04054d63          	bltz	a0,3508 <iputtest+0x9e>
  if(chdir("/") < 0){
    34b2:	00004517          	auipc	a0,0x4
    34b6:	fbe50513          	add	a0,a0,-66 # 7470 <malloc+0x13fe>
    34ba:	00002097          	auipc	ra,0x2
    34be:	7f8080e7          	jalr	2040(ra) # 5cb2 <chdir>
    34c2:	06054163          	bltz	a0,3524 <iputtest+0xba>
}
    34c6:	60e2                	ld	ra,24(sp)
    34c8:	6442                	ld	s0,16(sp)
    34ca:	64a2                	ld	s1,8(sp)
    34cc:	6105                	add	sp,sp,32
    34ce:	8082                	ret
    printf("%s: mkdir failed\n", s);
    34d0:	85a6                	mv	a1,s1
    34d2:	00004517          	auipc	a0,0x4
    34d6:	f3650513          	add	a0,a0,-202 # 7408 <malloc+0x1396>
    34da:	00003097          	auipc	ra,0x3
    34de:	ae0080e7          	jalr	-1312(ra) # 5fba <printf>
    exit(1);
    34e2:	4505                	li	a0,1
    34e4:	00002097          	auipc	ra,0x2
    34e8:	75e080e7          	jalr	1886(ra) # 5c42 <exit>
    printf("%s: chdir iputdir failed\n", s);
    34ec:	85a6                	mv	a1,s1
    34ee:	00004517          	auipc	a0,0x4
    34f2:	f3250513          	add	a0,a0,-206 # 7420 <malloc+0x13ae>
    34f6:	00003097          	auipc	ra,0x3
    34fa:	ac4080e7          	jalr	-1340(ra) # 5fba <printf>
    exit(1);
    34fe:	4505                	li	a0,1
    3500:	00002097          	auipc	ra,0x2
    3504:	742080e7          	jalr	1858(ra) # 5c42 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3508:	85a6                	mv	a1,s1
    350a:	00004517          	auipc	a0,0x4
    350e:	f4650513          	add	a0,a0,-186 # 7450 <malloc+0x13de>
    3512:	00003097          	auipc	ra,0x3
    3516:	aa8080e7          	jalr	-1368(ra) # 5fba <printf>
    exit(1);
    351a:	4505                	li	a0,1
    351c:	00002097          	auipc	ra,0x2
    3520:	726080e7          	jalr	1830(ra) # 5c42 <exit>
    printf("%s: chdir / failed\n", s);
    3524:	85a6                	mv	a1,s1
    3526:	00004517          	auipc	a0,0x4
    352a:	f5250513          	add	a0,a0,-174 # 7478 <malloc+0x1406>
    352e:	00003097          	auipc	ra,0x3
    3532:	a8c080e7          	jalr	-1396(ra) # 5fba <printf>
    exit(1);
    3536:	4505                	li	a0,1
    3538:	00002097          	auipc	ra,0x2
    353c:	70a080e7          	jalr	1802(ra) # 5c42 <exit>

0000000000003540 <exitiputtest>:
{
    3540:	7179                	add	sp,sp,-48
    3542:	f406                	sd	ra,40(sp)
    3544:	f022                	sd	s0,32(sp)
    3546:	ec26                	sd	s1,24(sp)
    3548:	1800                	add	s0,sp,48
    354a:	84aa                	mv	s1,a0
  pid = fork();
    354c:	00002097          	auipc	ra,0x2
    3550:	6ee080e7          	jalr	1774(ra) # 5c3a <fork>
  if(pid < 0){
    3554:	04054663          	bltz	a0,35a0 <exitiputtest+0x60>
  if(pid == 0){
    3558:	ed45                	bnez	a0,3610 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    355a:	00004517          	auipc	a0,0x4
    355e:	ea650513          	add	a0,a0,-346 # 7400 <malloc+0x138e>
    3562:	00002097          	auipc	ra,0x2
    3566:	748080e7          	jalr	1864(ra) # 5caa <mkdir>
    356a:	04054963          	bltz	a0,35bc <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    356e:	00004517          	auipc	a0,0x4
    3572:	e9250513          	add	a0,a0,-366 # 7400 <malloc+0x138e>
    3576:	00002097          	auipc	ra,0x2
    357a:	73c080e7          	jalr	1852(ra) # 5cb2 <chdir>
    357e:	04054d63          	bltz	a0,35d8 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    3582:	00004517          	auipc	a0,0x4
    3586:	ebe50513          	add	a0,a0,-322 # 7440 <malloc+0x13ce>
    358a:	00002097          	auipc	ra,0x2
    358e:	708080e7          	jalr	1800(ra) # 5c92 <unlink>
    3592:	06054163          	bltz	a0,35f4 <exitiputtest+0xb4>
    exit(0);
    3596:	4501                	li	a0,0
    3598:	00002097          	auipc	ra,0x2
    359c:	6aa080e7          	jalr	1706(ra) # 5c42 <exit>
    printf("%s: fork failed\n", s);
    35a0:	85a6                	mv	a1,s1
    35a2:	00003517          	auipc	a0,0x3
    35a6:	49e50513          	add	a0,a0,1182 # 6a40 <malloc+0x9ce>
    35aa:	00003097          	auipc	ra,0x3
    35ae:	a10080e7          	jalr	-1520(ra) # 5fba <printf>
    exit(1);
    35b2:	4505                	li	a0,1
    35b4:	00002097          	auipc	ra,0x2
    35b8:	68e080e7          	jalr	1678(ra) # 5c42 <exit>
      printf("%s: mkdir failed\n", s);
    35bc:	85a6                	mv	a1,s1
    35be:	00004517          	auipc	a0,0x4
    35c2:	e4a50513          	add	a0,a0,-438 # 7408 <malloc+0x1396>
    35c6:	00003097          	auipc	ra,0x3
    35ca:	9f4080e7          	jalr	-1548(ra) # 5fba <printf>
      exit(1);
    35ce:	4505                	li	a0,1
    35d0:	00002097          	auipc	ra,0x2
    35d4:	672080e7          	jalr	1650(ra) # 5c42 <exit>
      printf("%s: child chdir failed\n", s);
    35d8:	85a6                	mv	a1,s1
    35da:	00004517          	auipc	a0,0x4
    35de:	eb650513          	add	a0,a0,-330 # 7490 <malloc+0x141e>
    35e2:	00003097          	auipc	ra,0x3
    35e6:	9d8080e7          	jalr	-1576(ra) # 5fba <printf>
      exit(1);
    35ea:	4505                	li	a0,1
    35ec:	00002097          	auipc	ra,0x2
    35f0:	656080e7          	jalr	1622(ra) # 5c42 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    35f4:	85a6                	mv	a1,s1
    35f6:	00004517          	auipc	a0,0x4
    35fa:	e5a50513          	add	a0,a0,-422 # 7450 <malloc+0x13de>
    35fe:	00003097          	auipc	ra,0x3
    3602:	9bc080e7          	jalr	-1604(ra) # 5fba <printf>
      exit(1);
    3606:	4505                	li	a0,1
    3608:	00002097          	auipc	ra,0x2
    360c:	63a080e7          	jalr	1594(ra) # 5c42 <exit>
  wait(&xstatus);
    3610:	fdc40513          	add	a0,s0,-36
    3614:	00002097          	auipc	ra,0x2
    3618:	636080e7          	jalr	1590(ra) # 5c4a <wait>
  exit(xstatus);
    361c:	fdc42503          	lw	a0,-36(s0)
    3620:	00002097          	auipc	ra,0x2
    3624:	622080e7          	jalr	1570(ra) # 5c42 <exit>

0000000000003628 <dirtest>:
{
    3628:	1101                	add	sp,sp,-32
    362a:	ec06                	sd	ra,24(sp)
    362c:	e822                	sd	s0,16(sp)
    362e:	e426                	sd	s1,8(sp)
    3630:	1000                	add	s0,sp,32
    3632:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    3634:	00004517          	auipc	a0,0x4
    3638:	e7450513          	add	a0,a0,-396 # 74a8 <malloc+0x1436>
    363c:	00002097          	auipc	ra,0x2
    3640:	66e080e7          	jalr	1646(ra) # 5caa <mkdir>
    3644:	04054563          	bltz	a0,368e <dirtest+0x66>
  if(chdir("dir0") < 0){
    3648:	00004517          	auipc	a0,0x4
    364c:	e6050513          	add	a0,a0,-416 # 74a8 <malloc+0x1436>
    3650:	00002097          	auipc	ra,0x2
    3654:	662080e7          	jalr	1634(ra) # 5cb2 <chdir>
    3658:	04054963          	bltz	a0,36aa <dirtest+0x82>
  if(chdir("..") < 0){
    365c:	00004517          	auipc	a0,0x4
    3660:	e6c50513          	add	a0,a0,-404 # 74c8 <malloc+0x1456>
    3664:	00002097          	auipc	ra,0x2
    3668:	64e080e7          	jalr	1614(ra) # 5cb2 <chdir>
    366c:	04054d63          	bltz	a0,36c6 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    3670:	00004517          	auipc	a0,0x4
    3674:	e3850513          	add	a0,a0,-456 # 74a8 <malloc+0x1436>
    3678:	00002097          	auipc	ra,0x2
    367c:	61a080e7          	jalr	1562(ra) # 5c92 <unlink>
    3680:	06054163          	bltz	a0,36e2 <dirtest+0xba>
}
    3684:	60e2                	ld	ra,24(sp)
    3686:	6442                	ld	s0,16(sp)
    3688:	64a2                	ld	s1,8(sp)
    368a:	6105                	add	sp,sp,32
    368c:	8082                	ret
    printf("%s: mkdir failed\n", s);
    368e:	85a6                	mv	a1,s1
    3690:	00004517          	auipc	a0,0x4
    3694:	d7850513          	add	a0,a0,-648 # 7408 <malloc+0x1396>
    3698:	00003097          	auipc	ra,0x3
    369c:	922080e7          	jalr	-1758(ra) # 5fba <printf>
    exit(1);
    36a0:	4505                	li	a0,1
    36a2:	00002097          	auipc	ra,0x2
    36a6:	5a0080e7          	jalr	1440(ra) # 5c42 <exit>
    printf("%s: chdir dir0 failed\n", s);
    36aa:	85a6                	mv	a1,s1
    36ac:	00004517          	auipc	a0,0x4
    36b0:	e0450513          	add	a0,a0,-508 # 74b0 <malloc+0x143e>
    36b4:	00003097          	auipc	ra,0x3
    36b8:	906080e7          	jalr	-1786(ra) # 5fba <printf>
    exit(1);
    36bc:	4505                	li	a0,1
    36be:	00002097          	auipc	ra,0x2
    36c2:	584080e7          	jalr	1412(ra) # 5c42 <exit>
    printf("%s: chdir .. failed\n", s);
    36c6:	85a6                	mv	a1,s1
    36c8:	00004517          	auipc	a0,0x4
    36cc:	e0850513          	add	a0,a0,-504 # 74d0 <malloc+0x145e>
    36d0:	00003097          	auipc	ra,0x3
    36d4:	8ea080e7          	jalr	-1814(ra) # 5fba <printf>
    exit(1);
    36d8:	4505                	li	a0,1
    36da:	00002097          	auipc	ra,0x2
    36de:	568080e7          	jalr	1384(ra) # 5c42 <exit>
    printf("%s: unlink dir0 failed\n", s);
    36e2:	85a6                	mv	a1,s1
    36e4:	00004517          	auipc	a0,0x4
    36e8:	e0450513          	add	a0,a0,-508 # 74e8 <malloc+0x1476>
    36ec:	00003097          	auipc	ra,0x3
    36f0:	8ce080e7          	jalr	-1842(ra) # 5fba <printf>
    exit(1);
    36f4:	4505                	li	a0,1
    36f6:	00002097          	auipc	ra,0x2
    36fa:	54c080e7          	jalr	1356(ra) # 5c42 <exit>

00000000000036fe <subdir>:
{
    36fe:	1101                	add	sp,sp,-32
    3700:	ec06                	sd	ra,24(sp)
    3702:	e822                	sd	s0,16(sp)
    3704:	e426                	sd	s1,8(sp)
    3706:	e04a                	sd	s2,0(sp)
    3708:	1000                	add	s0,sp,32
    370a:	892a                	mv	s2,a0
  unlink("ff");
    370c:	00004517          	auipc	a0,0x4
    3710:	f2450513          	add	a0,a0,-220 # 7630 <malloc+0x15be>
    3714:	00002097          	auipc	ra,0x2
    3718:	57e080e7          	jalr	1406(ra) # 5c92 <unlink>
  if(mkdir("dd") != 0){
    371c:	00004517          	auipc	a0,0x4
    3720:	de450513          	add	a0,a0,-540 # 7500 <malloc+0x148e>
    3724:	00002097          	auipc	ra,0x2
    3728:	586080e7          	jalr	1414(ra) # 5caa <mkdir>
    372c:	38051663          	bnez	a0,3ab8 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3730:	20200593          	li	a1,514
    3734:	00004517          	auipc	a0,0x4
    3738:	dec50513          	add	a0,a0,-532 # 7520 <malloc+0x14ae>
    373c:	00002097          	auipc	ra,0x2
    3740:	546080e7          	jalr	1350(ra) # 5c82 <open>
    3744:	84aa                	mv	s1,a0
  if(fd < 0){
    3746:	38054763          	bltz	a0,3ad4 <subdir+0x3d6>
  write(fd, "ff", 2);
    374a:	4609                	li	a2,2
    374c:	00004597          	auipc	a1,0x4
    3750:	ee458593          	add	a1,a1,-284 # 7630 <malloc+0x15be>
    3754:	00002097          	auipc	ra,0x2
    3758:	50e080e7          	jalr	1294(ra) # 5c62 <write>
  close(fd);
    375c:	8526                	mv	a0,s1
    375e:	00002097          	auipc	ra,0x2
    3762:	50c080e7          	jalr	1292(ra) # 5c6a <close>
  if(unlink("dd") >= 0){
    3766:	00004517          	auipc	a0,0x4
    376a:	d9a50513          	add	a0,a0,-614 # 7500 <malloc+0x148e>
    376e:	00002097          	auipc	ra,0x2
    3772:	524080e7          	jalr	1316(ra) # 5c92 <unlink>
    3776:	36055d63          	bgez	a0,3af0 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    377a:	00004517          	auipc	a0,0x4
    377e:	dfe50513          	add	a0,a0,-514 # 7578 <malloc+0x1506>
    3782:	00002097          	auipc	ra,0x2
    3786:	528080e7          	jalr	1320(ra) # 5caa <mkdir>
    378a:	38051163          	bnez	a0,3b0c <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    378e:	20200593          	li	a1,514
    3792:	00004517          	auipc	a0,0x4
    3796:	e0e50513          	add	a0,a0,-498 # 75a0 <malloc+0x152e>
    379a:	00002097          	auipc	ra,0x2
    379e:	4e8080e7          	jalr	1256(ra) # 5c82 <open>
    37a2:	84aa                	mv	s1,a0
  if(fd < 0){
    37a4:	38054263          	bltz	a0,3b28 <subdir+0x42a>
  write(fd, "FF", 2);
    37a8:	4609                	li	a2,2
    37aa:	00004597          	auipc	a1,0x4
    37ae:	e2658593          	add	a1,a1,-474 # 75d0 <malloc+0x155e>
    37b2:	00002097          	auipc	ra,0x2
    37b6:	4b0080e7          	jalr	1200(ra) # 5c62 <write>
  close(fd);
    37ba:	8526                	mv	a0,s1
    37bc:	00002097          	auipc	ra,0x2
    37c0:	4ae080e7          	jalr	1198(ra) # 5c6a <close>
  fd = open("dd/dd/../ff", 0);
    37c4:	4581                	li	a1,0
    37c6:	00004517          	auipc	a0,0x4
    37ca:	e1250513          	add	a0,a0,-494 # 75d8 <malloc+0x1566>
    37ce:	00002097          	auipc	ra,0x2
    37d2:	4b4080e7          	jalr	1204(ra) # 5c82 <open>
    37d6:	84aa                	mv	s1,a0
  if(fd < 0){
    37d8:	36054663          	bltz	a0,3b44 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    37dc:	660d                	lui	a2,0x3
    37de:	0000b597          	auipc	a1,0xb
    37e2:	85a58593          	add	a1,a1,-1958 # e038 <buf>
    37e6:	00002097          	auipc	ra,0x2
    37ea:	474080e7          	jalr	1140(ra) # 5c5a <read>
  if(cc != 2 || buf[0] != 'f'){
    37ee:	4789                	li	a5,2
    37f0:	36f51863          	bne	a0,a5,3b60 <subdir+0x462>
    37f4:	0000b717          	auipc	a4,0xb
    37f8:	84474703          	lbu	a4,-1980(a4) # e038 <buf>
    37fc:	06600793          	li	a5,102
    3800:	36f71063          	bne	a4,a5,3b60 <subdir+0x462>
  close(fd);
    3804:	8526                	mv	a0,s1
    3806:	00002097          	auipc	ra,0x2
    380a:	464080e7          	jalr	1124(ra) # 5c6a <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    380e:	00004597          	auipc	a1,0x4
    3812:	e1a58593          	add	a1,a1,-486 # 7628 <malloc+0x15b6>
    3816:	00004517          	auipc	a0,0x4
    381a:	d8a50513          	add	a0,a0,-630 # 75a0 <malloc+0x152e>
    381e:	00002097          	auipc	ra,0x2
    3822:	484080e7          	jalr	1156(ra) # 5ca2 <link>
    3826:	34051b63          	bnez	a0,3b7c <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    382a:	00004517          	auipc	a0,0x4
    382e:	d7650513          	add	a0,a0,-650 # 75a0 <malloc+0x152e>
    3832:	00002097          	auipc	ra,0x2
    3836:	460080e7          	jalr	1120(ra) # 5c92 <unlink>
    383a:	34051f63          	bnez	a0,3b98 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    383e:	4581                	li	a1,0
    3840:	00004517          	auipc	a0,0x4
    3844:	d6050513          	add	a0,a0,-672 # 75a0 <malloc+0x152e>
    3848:	00002097          	auipc	ra,0x2
    384c:	43a080e7          	jalr	1082(ra) # 5c82 <open>
    3850:	36055263          	bgez	a0,3bb4 <subdir+0x4b6>
  if(chdir("dd") != 0){
    3854:	00004517          	auipc	a0,0x4
    3858:	cac50513          	add	a0,a0,-852 # 7500 <malloc+0x148e>
    385c:	00002097          	auipc	ra,0x2
    3860:	456080e7          	jalr	1110(ra) # 5cb2 <chdir>
    3864:	36051663          	bnez	a0,3bd0 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3868:	00004517          	auipc	a0,0x4
    386c:	e5850513          	add	a0,a0,-424 # 76c0 <malloc+0x164e>
    3870:	00002097          	auipc	ra,0x2
    3874:	442080e7          	jalr	1090(ra) # 5cb2 <chdir>
    3878:	36051a63          	bnez	a0,3bec <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    387c:	00004517          	auipc	a0,0x4
    3880:	e7450513          	add	a0,a0,-396 # 76f0 <malloc+0x167e>
    3884:	00002097          	auipc	ra,0x2
    3888:	42e080e7          	jalr	1070(ra) # 5cb2 <chdir>
    388c:	36051e63          	bnez	a0,3c08 <subdir+0x50a>
  if(chdir("./..") != 0){
    3890:	00004517          	auipc	a0,0x4
    3894:	e9050513          	add	a0,a0,-368 # 7720 <malloc+0x16ae>
    3898:	00002097          	auipc	ra,0x2
    389c:	41a080e7          	jalr	1050(ra) # 5cb2 <chdir>
    38a0:	38051263          	bnez	a0,3c24 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    38a4:	4581                	li	a1,0
    38a6:	00004517          	auipc	a0,0x4
    38aa:	d8250513          	add	a0,a0,-638 # 7628 <malloc+0x15b6>
    38ae:	00002097          	auipc	ra,0x2
    38b2:	3d4080e7          	jalr	980(ra) # 5c82 <open>
    38b6:	84aa                	mv	s1,a0
  if(fd < 0){
    38b8:	38054463          	bltz	a0,3c40 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    38bc:	660d                	lui	a2,0x3
    38be:	0000a597          	auipc	a1,0xa
    38c2:	77a58593          	add	a1,a1,1914 # e038 <buf>
    38c6:	00002097          	auipc	ra,0x2
    38ca:	394080e7          	jalr	916(ra) # 5c5a <read>
    38ce:	4789                	li	a5,2
    38d0:	38f51663          	bne	a0,a5,3c5c <subdir+0x55e>
  close(fd);
    38d4:	8526                	mv	a0,s1
    38d6:	00002097          	auipc	ra,0x2
    38da:	394080e7          	jalr	916(ra) # 5c6a <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    38de:	4581                	li	a1,0
    38e0:	00004517          	auipc	a0,0x4
    38e4:	cc050513          	add	a0,a0,-832 # 75a0 <malloc+0x152e>
    38e8:	00002097          	auipc	ra,0x2
    38ec:	39a080e7          	jalr	922(ra) # 5c82 <open>
    38f0:	38055463          	bgez	a0,3c78 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    38f4:	20200593          	li	a1,514
    38f8:	00004517          	auipc	a0,0x4
    38fc:	eb850513          	add	a0,a0,-328 # 77b0 <malloc+0x173e>
    3900:	00002097          	auipc	ra,0x2
    3904:	382080e7          	jalr	898(ra) # 5c82 <open>
    3908:	38055663          	bgez	a0,3c94 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    390c:	20200593          	li	a1,514
    3910:	00004517          	auipc	a0,0x4
    3914:	ed050513          	add	a0,a0,-304 # 77e0 <malloc+0x176e>
    3918:	00002097          	auipc	ra,0x2
    391c:	36a080e7          	jalr	874(ra) # 5c82 <open>
    3920:	38055863          	bgez	a0,3cb0 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    3924:	20000593          	li	a1,512
    3928:	00004517          	auipc	a0,0x4
    392c:	bd850513          	add	a0,a0,-1064 # 7500 <malloc+0x148e>
    3930:	00002097          	auipc	ra,0x2
    3934:	352080e7          	jalr	850(ra) # 5c82 <open>
    3938:	38055a63          	bgez	a0,3ccc <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    393c:	4589                	li	a1,2
    393e:	00004517          	auipc	a0,0x4
    3942:	bc250513          	add	a0,a0,-1086 # 7500 <malloc+0x148e>
    3946:	00002097          	auipc	ra,0x2
    394a:	33c080e7          	jalr	828(ra) # 5c82 <open>
    394e:	38055d63          	bgez	a0,3ce8 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    3952:	4585                	li	a1,1
    3954:	00004517          	auipc	a0,0x4
    3958:	bac50513          	add	a0,a0,-1108 # 7500 <malloc+0x148e>
    395c:	00002097          	auipc	ra,0x2
    3960:	326080e7          	jalr	806(ra) # 5c82 <open>
    3964:	3a055063          	bgez	a0,3d04 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3968:	00004597          	auipc	a1,0x4
    396c:	f0858593          	add	a1,a1,-248 # 7870 <malloc+0x17fe>
    3970:	00004517          	auipc	a0,0x4
    3974:	e4050513          	add	a0,a0,-448 # 77b0 <malloc+0x173e>
    3978:	00002097          	auipc	ra,0x2
    397c:	32a080e7          	jalr	810(ra) # 5ca2 <link>
    3980:	3a050063          	beqz	a0,3d20 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3984:	00004597          	auipc	a1,0x4
    3988:	eec58593          	add	a1,a1,-276 # 7870 <malloc+0x17fe>
    398c:	00004517          	auipc	a0,0x4
    3990:	e5450513          	add	a0,a0,-428 # 77e0 <malloc+0x176e>
    3994:	00002097          	auipc	ra,0x2
    3998:	30e080e7          	jalr	782(ra) # 5ca2 <link>
    399c:	3a050063          	beqz	a0,3d3c <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    39a0:	00004597          	auipc	a1,0x4
    39a4:	c8858593          	add	a1,a1,-888 # 7628 <malloc+0x15b6>
    39a8:	00004517          	auipc	a0,0x4
    39ac:	b7850513          	add	a0,a0,-1160 # 7520 <malloc+0x14ae>
    39b0:	00002097          	auipc	ra,0x2
    39b4:	2f2080e7          	jalr	754(ra) # 5ca2 <link>
    39b8:	3a050063          	beqz	a0,3d58 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    39bc:	00004517          	auipc	a0,0x4
    39c0:	df450513          	add	a0,a0,-524 # 77b0 <malloc+0x173e>
    39c4:	00002097          	auipc	ra,0x2
    39c8:	2e6080e7          	jalr	742(ra) # 5caa <mkdir>
    39cc:	3a050463          	beqz	a0,3d74 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    39d0:	00004517          	auipc	a0,0x4
    39d4:	e1050513          	add	a0,a0,-496 # 77e0 <malloc+0x176e>
    39d8:	00002097          	auipc	ra,0x2
    39dc:	2d2080e7          	jalr	722(ra) # 5caa <mkdir>
    39e0:	3a050863          	beqz	a0,3d90 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    39e4:	00004517          	auipc	a0,0x4
    39e8:	c4450513          	add	a0,a0,-956 # 7628 <malloc+0x15b6>
    39ec:	00002097          	auipc	ra,0x2
    39f0:	2be080e7          	jalr	702(ra) # 5caa <mkdir>
    39f4:	3a050c63          	beqz	a0,3dac <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    39f8:	00004517          	auipc	a0,0x4
    39fc:	de850513          	add	a0,a0,-536 # 77e0 <malloc+0x176e>
    3a00:	00002097          	auipc	ra,0x2
    3a04:	292080e7          	jalr	658(ra) # 5c92 <unlink>
    3a08:	3c050063          	beqz	a0,3dc8 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3a0c:	00004517          	auipc	a0,0x4
    3a10:	da450513          	add	a0,a0,-604 # 77b0 <malloc+0x173e>
    3a14:	00002097          	auipc	ra,0x2
    3a18:	27e080e7          	jalr	638(ra) # 5c92 <unlink>
    3a1c:	3c050463          	beqz	a0,3de4 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3a20:	00004517          	auipc	a0,0x4
    3a24:	b0050513          	add	a0,a0,-1280 # 7520 <malloc+0x14ae>
    3a28:	00002097          	auipc	ra,0x2
    3a2c:	28a080e7          	jalr	650(ra) # 5cb2 <chdir>
    3a30:	3c050863          	beqz	a0,3e00 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3a34:	00004517          	auipc	a0,0x4
    3a38:	f8c50513          	add	a0,a0,-116 # 79c0 <malloc+0x194e>
    3a3c:	00002097          	auipc	ra,0x2
    3a40:	276080e7          	jalr	630(ra) # 5cb2 <chdir>
    3a44:	3c050c63          	beqz	a0,3e1c <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3a48:	00004517          	auipc	a0,0x4
    3a4c:	be050513          	add	a0,a0,-1056 # 7628 <malloc+0x15b6>
    3a50:	00002097          	auipc	ra,0x2
    3a54:	242080e7          	jalr	578(ra) # 5c92 <unlink>
    3a58:	3e051063          	bnez	a0,3e38 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3a5c:	00004517          	auipc	a0,0x4
    3a60:	ac450513          	add	a0,a0,-1340 # 7520 <malloc+0x14ae>
    3a64:	00002097          	auipc	ra,0x2
    3a68:	22e080e7          	jalr	558(ra) # 5c92 <unlink>
    3a6c:	3e051463          	bnez	a0,3e54 <subdir+0x756>
  if(unlink("dd") == 0){
    3a70:	00004517          	auipc	a0,0x4
    3a74:	a9050513          	add	a0,a0,-1392 # 7500 <malloc+0x148e>
    3a78:	00002097          	auipc	ra,0x2
    3a7c:	21a080e7          	jalr	538(ra) # 5c92 <unlink>
    3a80:	3e050863          	beqz	a0,3e70 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3a84:	00004517          	auipc	a0,0x4
    3a88:	fac50513          	add	a0,a0,-84 # 7a30 <malloc+0x19be>
    3a8c:	00002097          	auipc	ra,0x2
    3a90:	206080e7          	jalr	518(ra) # 5c92 <unlink>
    3a94:	3e054c63          	bltz	a0,3e8c <subdir+0x78e>
  if(unlink("dd") < 0){
    3a98:	00004517          	auipc	a0,0x4
    3a9c:	a6850513          	add	a0,a0,-1432 # 7500 <malloc+0x148e>
    3aa0:	00002097          	auipc	ra,0x2
    3aa4:	1f2080e7          	jalr	498(ra) # 5c92 <unlink>
    3aa8:	40054063          	bltz	a0,3ea8 <subdir+0x7aa>
}
    3aac:	60e2                	ld	ra,24(sp)
    3aae:	6442                	ld	s0,16(sp)
    3ab0:	64a2                	ld	s1,8(sp)
    3ab2:	6902                	ld	s2,0(sp)
    3ab4:	6105                	add	sp,sp,32
    3ab6:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3ab8:	85ca                	mv	a1,s2
    3aba:	00004517          	auipc	a0,0x4
    3abe:	a4e50513          	add	a0,a0,-1458 # 7508 <malloc+0x1496>
    3ac2:	00002097          	auipc	ra,0x2
    3ac6:	4f8080e7          	jalr	1272(ra) # 5fba <printf>
    exit(1);
    3aca:	4505                	li	a0,1
    3acc:	00002097          	auipc	ra,0x2
    3ad0:	176080e7          	jalr	374(ra) # 5c42 <exit>
    printf("%s: create dd/ff failed\n", s);
    3ad4:	85ca                	mv	a1,s2
    3ad6:	00004517          	auipc	a0,0x4
    3ada:	a5250513          	add	a0,a0,-1454 # 7528 <malloc+0x14b6>
    3ade:	00002097          	auipc	ra,0x2
    3ae2:	4dc080e7          	jalr	1244(ra) # 5fba <printf>
    exit(1);
    3ae6:	4505                	li	a0,1
    3ae8:	00002097          	auipc	ra,0x2
    3aec:	15a080e7          	jalr	346(ra) # 5c42 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3af0:	85ca                	mv	a1,s2
    3af2:	00004517          	auipc	a0,0x4
    3af6:	a5650513          	add	a0,a0,-1450 # 7548 <malloc+0x14d6>
    3afa:	00002097          	auipc	ra,0x2
    3afe:	4c0080e7          	jalr	1216(ra) # 5fba <printf>
    exit(1);
    3b02:	4505                	li	a0,1
    3b04:	00002097          	auipc	ra,0x2
    3b08:	13e080e7          	jalr	318(ra) # 5c42 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3b0c:	85ca                	mv	a1,s2
    3b0e:	00004517          	auipc	a0,0x4
    3b12:	a7250513          	add	a0,a0,-1422 # 7580 <malloc+0x150e>
    3b16:	00002097          	auipc	ra,0x2
    3b1a:	4a4080e7          	jalr	1188(ra) # 5fba <printf>
    exit(1);
    3b1e:	4505                	li	a0,1
    3b20:	00002097          	auipc	ra,0x2
    3b24:	122080e7          	jalr	290(ra) # 5c42 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3b28:	85ca                	mv	a1,s2
    3b2a:	00004517          	auipc	a0,0x4
    3b2e:	a8650513          	add	a0,a0,-1402 # 75b0 <malloc+0x153e>
    3b32:	00002097          	auipc	ra,0x2
    3b36:	488080e7          	jalr	1160(ra) # 5fba <printf>
    exit(1);
    3b3a:	4505                	li	a0,1
    3b3c:	00002097          	auipc	ra,0x2
    3b40:	106080e7          	jalr	262(ra) # 5c42 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3b44:	85ca                	mv	a1,s2
    3b46:	00004517          	auipc	a0,0x4
    3b4a:	aa250513          	add	a0,a0,-1374 # 75e8 <malloc+0x1576>
    3b4e:	00002097          	auipc	ra,0x2
    3b52:	46c080e7          	jalr	1132(ra) # 5fba <printf>
    exit(1);
    3b56:	4505                	li	a0,1
    3b58:	00002097          	auipc	ra,0x2
    3b5c:	0ea080e7          	jalr	234(ra) # 5c42 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3b60:	85ca                	mv	a1,s2
    3b62:	00004517          	auipc	a0,0x4
    3b66:	aa650513          	add	a0,a0,-1370 # 7608 <malloc+0x1596>
    3b6a:	00002097          	auipc	ra,0x2
    3b6e:	450080e7          	jalr	1104(ra) # 5fba <printf>
    exit(1);
    3b72:	4505                	li	a0,1
    3b74:	00002097          	auipc	ra,0x2
    3b78:	0ce080e7          	jalr	206(ra) # 5c42 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3b7c:	85ca                	mv	a1,s2
    3b7e:	00004517          	auipc	a0,0x4
    3b82:	aba50513          	add	a0,a0,-1350 # 7638 <malloc+0x15c6>
    3b86:	00002097          	auipc	ra,0x2
    3b8a:	434080e7          	jalr	1076(ra) # 5fba <printf>
    exit(1);
    3b8e:	4505                	li	a0,1
    3b90:	00002097          	auipc	ra,0x2
    3b94:	0b2080e7          	jalr	178(ra) # 5c42 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3b98:	85ca                	mv	a1,s2
    3b9a:	00004517          	auipc	a0,0x4
    3b9e:	ac650513          	add	a0,a0,-1338 # 7660 <malloc+0x15ee>
    3ba2:	00002097          	auipc	ra,0x2
    3ba6:	418080e7          	jalr	1048(ra) # 5fba <printf>
    exit(1);
    3baa:	4505                	li	a0,1
    3bac:	00002097          	auipc	ra,0x2
    3bb0:	096080e7          	jalr	150(ra) # 5c42 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3bb4:	85ca                	mv	a1,s2
    3bb6:	00004517          	auipc	a0,0x4
    3bba:	aca50513          	add	a0,a0,-1334 # 7680 <malloc+0x160e>
    3bbe:	00002097          	auipc	ra,0x2
    3bc2:	3fc080e7          	jalr	1020(ra) # 5fba <printf>
    exit(1);
    3bc6:	4505                	li	a0,1
    3bc8:	00002097          	auipc	ra,0x2
    3bcc:	07a080e7          	jalr	122(ra) # 5c42 <exit>
    printf("%s: chdir dd failed\n", s);
    3bd0:	85ca                	mv	a1,s2
    3bd2:	00004517          	auipc	a0,0x4
    3bd6:	ad650513          	add	a0,a0,-1322 # 76a8 <malloc+0x1636>
    3bda:	00002097          	auipc	ra,0x2
    3bde:	3e0080e7          	jalr	992(ra) # 5fba <printf>
    exit(1);
    3be2:	4505                	li	a0,1
    3be4:	00002097          	auipc	ra,0x2
    3be8:	05e080e7          	jalr	94(ra) # 5c42 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3bec:	85ca                	mv	a1,s2
    3bee:	00004517          	auipc	a0,0x4
    3bf2:	ae250513          	add	a0,a0,-1310 # 76d0 <malloc+0x165e>
    3bf6:	00002097          	auipc	ra,0x2
    3bfa:	3c4080e7          	jalr	964(ra) # 5fba <printf>
    exit(1);
    3bfe:	4505                	li	a0,1
    3c00:	00002097          	auipc	ra,0x2
    3c04:	042080e7          	jalr	66(ra) # 5c42 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3c08:	85ca                	mv	a1,s2
    3c0a:	00004517          	auipc	a0,0x4
    3c0e:	af650513          	add	a0,a0,-1290 # 7700 <malloc+0x168e>
    3c12:	00002097          	auipc	ra,0x2
    3c16:	3a8080e7          	jalr	936(ra) # 5fba <printf>
    exit(1);
    3c1a:	4505                	li	a0,1
    3c1c:	00002097          	auipc	ra,0x2
    3c20:	026080e7          	jalr	38(ra) # 5c42 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3c24:	85ca                	mv	a1,s2
    3c26:	00004517          	auipc	a0,0x4
    3c2a:	b0250513          	add	a0,a0,-1278 # 7728 <malloc+0x16b6>
    3c2e:	00002097          	auipc	ra,0x2
    3c32:	38c080e7          	jalr	908(ra) # 5fba <printf>
    exit(1);
    3c36:	4505                	li	a0,1
    3c38:	00002097          	auipc	ra,0x2
    3c3c:	00a080e7          	jalr	10(ra) # 5c42 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3c40:	85ca                	mv	a1,s2
    3c42:	00004517          	auipc	a0,0x4
    3c46:	afe50513          	add	a0,a0,-1282 # 7740 <malloc+0x16ce>
    3c4a:	00002097          	auipc	ra,0x2
    3c4e:	370080e7          	jalr	880(ra) # 5fba <printf>
    exit(1);
    3c52:	4505                	li	a0,1
    3c54:	00002097          	auipc	ra,0x2
    3c58:	fee080e7          	jalr	-18(ra) # 5c42 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3c5c:	85ca                	mv	a1,s2
    3c5e:	00004517          	auipc	a0,0x4
    3c62:	b0250513          	add	a0,a0,-1278 # 7760 <malloc+0x16ee>
    3c66:	00002097          	auipc	ra,0x2
    3c6a:	354080e7          	jalr	852(ra) # 5fba <printf>
    exit(1);
    3c6e:	4505                	li	a0,1
    3c70:	00002097          	auipc	ra,0x2
    3c74:	fd2080e7          	jalr	-46(ra) # 5c42 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3c78:	85ca                	mv	a1,s2
    3c7a:	00004517          	auipc	a0,0x4
    3c7e:	b0650513          	add	a0,a0,-1274 # 7780 <malloc+0x170e>
    3c82:	00002097          	auipc	ra,0x2
    3c86:	338080e7          	jalr	824(ra) # 5fba <printf>
    exit(1);
    3c8a:	4505                	li	a0,1
    3c8c:	00002097          	auipc	ra,0x2
    3c90:	fb6080e7          	jalr	-74(ra) # 5c42 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3c94:	85ca                	mv	a1,s2
    3c96:	00004517          	auipc	a0,0x4
    3c9a:	b2a50513          	add	a0,a0,-1238 # 77c0 <malloc+0x174e>
    3c9e:	00002097          	auipc	ra,0x2
    3ca2:	31c080e7          	jalr	796(ra) # 5fba <printf>
    exit(1);
    3ca6:	4505                	li	a0,1
    3ca8:	00002097          	auipc	ra,0x2
    3cac:	f9a080e7          	jalr	-102(ra) # 5c42 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3cb0:	85ca                	mv	a1,s2
    3cb2:	00004517          	auipc	a0,0x4
    3cb6:	b3e50513          	add	a0,a0,-1218 # 77f0 <malloc+0x177e>
    3cba:	00002097          	auipc	ra,0x2
    3cbe:	300080e7          	jalr	768(ra) # 5fba <printf>
    exit(1);
    3cc2:	4505                	li	a0,1
    3cc4:	00002097          	auipc	ra,0x2
    3cc8:	f7e080e7          	jalr	-130(ra) # 5c42 <exit>
    printf("%s: create dd succeeded!\n", s);
    3ccc:	85ca                	mv	a1,s2
    3cce:	00004517          	auipc	a0,0x4
    3cd2:	b4250513          	add	a0,a0,-1214 # 7810 <malloc+0x179e>
    3cd6:	00002097          	auipc	ra,0x2
    3cda:	2e4080e7          	jalr	740(ra) # 5fba <printf>
    exit(1);
    3cde:	4505                	li	a0,1
    3ce0:	00002097          	auipc	ra,0x2
    3ce4:	f62080e7          	jalr	-158(ra) # 5c42 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3ce8:	85ca                	mv	a1,s2
    3cea:	00004517          	auipc	a0,0x4
    3cee:	b4650513          	add	a0,a0,-1210 # 7830 <malloc+0x17be>
    3cf2:	00002097          	auipc	ra,0x2
    3cf6:	2c8080e7          	jalr	712(ra) # 5fba <printf>
    exit(1);
    3cfa:	4505                	li	a0,1
    3cfc:	00002097          	auipc	ra,0x2
    3d00:	f46080e7          	jalr	-186(ra) # 5c42 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3d04:	85ca                	mv	a1,s2
    3d06:	00004517          	auipc	a0,0x4
    3d0a:	b4a50513          	add	a0,a0,-1206 # 7850 <malloc+0x17de>
    3d0e:	00002097          	auipc	ra,0x2
    3d12:	2ac080e7          	jalr	684(ra) # 5fba <printf>
    exit(1);
    3d16:	4505                	li	a0,1
    3d18:	00002097          	auipc	ra,0x2
    3d1c:	f2a080e7          	jalr	-214(ra) # 5c42 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3d20:	85ca                	mv	a1,s2
    3d22:	00004517          	auipc	a0,0x4
    3d26:	b5e50513          	add	a0,a0,-1186 # 7880 <malloc+0x180e>
    3d2a:	00002097          	auipc	ra,0x2
    3d2e:	290080e7          	jalr	656(ra) # 5fba <printf>
    exit(1);
    3d32:	4505                	li	a0,1
    3d34:	00002097          	auipc	ra,0x2
    3d38:	f0e080e7          	jalr	-242(ra) # 5c42 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3d3c:	85ca                	mv	a1,s2
    3d3e:	00004517          	auipc	a0,0x4
    3d42:	b6a50513          	add	a0,a0,-1174 # 78a8 <malloc+0x1836>
    3d46:	00002097          	auipc	ra,0x2
    3d4a:	274080e7          	jalr	628(ra) # 5fba <printf>
    exit(1);
    3d4e:	4505                	li	a0,1
    3d50:	00002097          	auipc	ra,0x2
    3d54:	ef2080e7          	jalr	-270(ra) # 5c42 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3d58:	85ca                	mv	a1,s2
    3d5a:	00004517          	auipc	a0,0x4
    3d5e:	b7650513          	add	a0,a0,-1162 # 78d0 <malloc+0x185e>
    3d62:	00002097          	auipc	ra,0x2
    3d66:	258080e7          	jalr	600(ra) # 5fba <printf>
    exit(1);
    3d6a:	4505                	li	a0,1
    3d6c:	00002097          	auipc	ra,0x2
    3d70:	ed6080e7          	jalr	-298(ra) # 5c42 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3d74:	85ca                	mv	a1,s2
    3d76:	00004517          	auipc	a0,0x4
    3d7a:	b8250513          	add	a0,a0,-1150 # 78f8 <malloc+0x1886>
    3d7e:	00002097          	auipc	ra,0x2
    3d82:	23c080e7          	jalr	572(ra) # 5fba <printf>
    exit(1);
    3d86:	4505                	li	a0,1
    3d88:	00002097          	auipc	ra,0x2
    3d8c:	eba080e7          	jalr	-326(ra) # 5c42 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3d90:	85ca                	mv	a1,s2
    3d92:	00004517          	auipc	a0,0x4
    3d96:	b8650513          	add	a0,a0,-1146 # 7918 <malloc+0x18a6>
    3d9a:	00002097          	auipc	ra,0x2
    3d9e:	220080e7          	jalr	544(ra) # 5fba <printf>
    exit(1);
    3da2:	4505                	li	a0,1
    3da4:	00002097          	auipc	ra,0x2
    3da8:	e9e080e7          	jalr	-354(ra) # 5c42 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3dac:	85ca                	mv	a1,s2
    3dae:	00004517          	auipc	a0,0x4
    3db2:	b8a50513          	add	a0,a0,-1142 # 7938 <malloc+0x18c6>
    3db6:	00002097          	auipc	ra,0x2
    3dba:	204080e7          	jalr	516(ra) # 5fba <printf>
    exit(1);
    3dbe:	4505                	li	a0,1
    3dc0:	00002097          	auipc	ra,0x2
    3dc4:	e82080e7          	jalr	-382(ra) # 5c42 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3dc8:	85ca                	mv	a1,s2
    3dca:	00004517          	auipc	a0,0x4
    3dce:	b9650513          	add	a0,a0,-1130 # 7960 <malloc+0x18ee>
    3dd2:	00002097          	auipc	ra,0x2
    3dd6:	1e8080e7          	jalr	488(ra) # 5fba <printf>
    exit(1);
    3dda:	4505                	li	a0,1
    3ddc:	00002097          	auipc	ra,0x2
    3de0:	e66080e7          	jalr	-410(ra) # 5c42 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3de4:	85ca                	mv	a1,s2
    3de6:	00004517          	auipc	a0,0x4
    3dea:	b9a50513          	add	a0,a0,-1126 # 7980 <malloc+0x190e>
    3dee:	00002097          	auipc	ra,0x2
    3df2:	1cc080e7          	jalr	460(ra) # 5fba <printf>
    exit(1);
    3df6:	4505                	li	a0,1
    3df8:	00002097          	auipc	ra,0x2
    3dfc:	e4a080e7          	jalr	-438(ra) # 5c42 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3e00:	85ca                	mv	a1,s2
    3e02:	00004517          	auipc	a0,0x4
    3e06:	b9e50513          	add	a0,a0,-1122 # 79a0 <malloc+0x192e>
    3e0a:	00002097          	auipc	ra,0x2
    3e0e:	1b0080e7          	jalr	432(ra) # 5fba <printf>
    exit(1);
    3e12:	4505                	li	a0,1
    3e14:	00002097          	auipc	ra,0x2
    3e18:	e2e080e7          	jalr	-466(ra) # 5c42 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3e1c:	85ca                	mv	a1,s2
    3e1e:	00004517          	auipc	a0,0x4
    3e22:	baa50513          	add	a0,a0,-1110 # 79c8 <malloc+0x1956>
    3e26:	00002097          	auipc	ra,0x2
    3e2a:	194080e7          	jalr	404(ra) # 5fba <printf>
    exit(1);
    3e2e:	4505                	li	a0,1
    3e30:	00002097          	auipc	ra,0x2
    3e34:	e12080e7          	jalr	-494(ra) # 5c42 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3e38:	85ca                	mv	a1,s2
    3e3a:	00004517          	auipc	a0,0x4
    3e3e:	82650513          	add	a0,a0,-2010 # 7660 <malloc+0x15ee>
    3e42:	00002097          	auipc	ra,0x2
    3e46:	178080e7          	jalr	376(ra) # 5fba <printf>
    exit(1);
    3e4a:	4505                	li	a0,1
    3e4c:	00002097          	auipc	ra,0x2
    3e50:	df6080e7          	jalr	-522(ra) # 5c42 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3e54:	85ca                	mv	a1,s2
    3e56:	00004517          	auipc	a0,0x4
    3e5a:	b9250513          	add	a0,a0,-1134 # 79e8 <malloc+0x1976>
    3e5e:	00002097          	auipc	ra,0x2
    3e62:	15c080e7          	jalr	348(ra) # 5fba <printf>
    exit(1);
    3e66:	4505                	li	a0,1
    3e68:	00002097          	auipc	ra,0x2
    3e6c:	dda080e7          	jalr	-550(ra) # 5c42 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3e70:	85ca                	mv	a1,s2
    3e72:	00004517          	auipc	a0,0x4
    3e76:	b9650513          	add	a0,a0,-1130 # 7a08 <malloc+0x1996>
    3e7a:	00002097          	auipc	ra,0x2
    3e7e:	140080e7          	jalr	320(ra) # 5fba <printf>
    exit(1);
    3e82:	4505                	li	a0,1
    3e84:	00002097          	auipc	ra,0x2
    3e88:	dbe080e7          	jalr	-578(ra) # 5c42 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3e8c:	85ca                	mv	a1,s2
    3e8e:	00004517          	auipc	a0,0x4
    3e92:	baa50513          	add	a0,a0,-1110 # 7a38 <malloc+0x19c6>
    3e96:	00002097          	auipc	ra,0x2
    3e9a:	124080e7          	jalr	292(ra) # 5fba <printf>
    exit(1);
    3e9e:	4505                	li	a0,1
    3ea0:	00002097          	auipc	ra,0x2
    3ea4:	da2080e7          	jalr	-606(ra) # 5c42 <exit>
    printf("%s: unlink dd failed\n", s);
    3ea8:	85ca                	mv	a1,s2
    3eaa:	00004517          	auipc	a0,0x4
    3eae:	bae50513          	add	a0,a0,-1106 # 7a58 <malloc+0x19e6>
    3eb2:	00002097          	auipc	ra,0x2
    3eb6:	108080e7          	jalr	264(ra) # 5fba <printf>
    exit(1);
    3eba:	4505                	li	a0,1
    3ebc:	00002097          	auipc	ra,0x2
    3ec0:	d86080e7          	jalr	-634(ra) # 5c42 <exit>

0000000000003ec4 <rmdot>:
{
    3ec4:	1101                	add	sp,sp,-32
    3ec6:	ec06                	sd	ra,24(sp)
    3ec8:	e822                	sd	s0,16(sp)
    3eca:	e426                	sd	s1,8(sp)
    3ecc:	1000                	add	s0,sp,32
    3ece:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3ed0:	00004517          	auipc	a0,0x4
    3ed4:	ba050513          	add	a0,a0,-1120 # 7a70 <malloc+0x19fe>
    3ed8:	00002097          	auipc	ra,0x2
    3edc:	dd2080e7          	jalr	-558(ra) # 5caa <mkdir>
    3ee0:	e549                	bnez	a0,3f6a <rmdot+0xa6>
  if(chdir("dots") != 0){
    3ee2:	00004517          	auipc	a0,0x4
    3ee6:	b8e50513          	add	a0,a0,-1138 # 7a70 <malloc+0x19fe>
    3eea:	00002097          	auipc	ra,0x2
    3eee:	dc8080e7          	jalr	-568(ra) # 5cb2 <chdir>
    3ef2:	e951                	bnez	a0,3f86 <rmdot+0xc2>
  if(unlink(".") == 0){
    3ef4:	00003517          	auipc	a0,0x3
    3ef8:	9ac50513          	add	a0,a0,-1620 # 68a0 <malloc+0x82e>
    3efc:	00002097          	auipc	ra,0x2
    3f00:	d96080e7          	jalr	-618(ra) # 5c92 <unlink>
    3f04:	cd59                	beqz	a0,3fa2 <rmdot+0xde>
  if(unlink("..") == 0){
    3f06:	00003517          	auipc	a0,0x3
    3f0a:	5c250513          	add	a0,a0,1474 # 74c8 <malloc+0x1456>
    3f0e:	00002097          	auipc	ra,0x2
    3f12:	d84080e7          	jalr	-636(ra) # 5c92 <unlink>
    3f16:	c545                	beqz	a0,3fbe <rmdot+0xfa>
  if(chdir("/") != 0){
    3f18:	00003517          	auipc	a0,0x3
    3f1c:	55850513          	add	a0,a0,1368 # 7470 <malloc+0x13fe>
    3f20:	00002097          	auipc	ra,0x2
    3f24:	d92080e7          	jalr	-622(ra) # 5cb2 <chdir>
    3f28:	e94d                	bnez	a0,3fda <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3f2a:	00004517          	auipc	a0,0x4
    3f2e:	bae50513          	add	a0,a0,-1106 # 7ad8 <malloc+0x1a66>
    3f32:	00002097          	auipc	ra,0x2
    3f36:	d60080e7          	jalr	-672(ra) # 5c92 <unlink>
    3f3a:	cd55                	beqz	a0,3ff6 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3f3c:	00004517          	auipc	a0,0x4
    3f40:	bc450513          	add	a0,a0,-1084 # 7b00 <malloc+0x1a8e>
    3f44:	00002097          	auipc	ra,0x2
    3f48:	d4e080e7          	jalr	-690(ra) # 5c92 <unlink>
    3f4c:	c179                	beqz	a0,4012 <rmdot+0x14e>
  if(unlink("dots") != 0){
    3f4e:	00004517          	auipc	a0,0x4
    3f52:	b2250513          	add	a0,a0,-1246 # 7a70 <malloc+0x19fe>
    3f56:	00002097          	auipc	ra,0x2
    3f5a:	d3c080e7          	jalr	-708(ra) # 5c92 <unlink>
    3f5e:	e961                	bnez	a0,402e <rmdot+0x16a>
}
    3f60:	60e2                	ld	ra,24(sp)
    3f62:	6442                	ld	s0,16(sp)
    3f64:	64a2                	ld	s1,8(sp)
    3f66:	6105                	add	sp,sp,32
    3f68:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3f6a:	85a6                	mv	a1,s1
    3f6c:	00004517          	auipc	a0,0x4
    3f70:	b0c50513          	add	a0,a0,-1268 # 7a78 <malloc+0x1a06>
    3f74:	00002097          	auipc	ra,0x2
    3f78:	046080e7          	jalr	70(ra) # 5fba <printf>
    exit(1);
    3f7c:	4505                	li	a0,1
    3f7e:	00002097          	auipc	ra,0x2
    3f82:	cc4080e7          	jalr	-828(ra) # 5c42 <exit>
    printf("%s: chdir dots failed\n", s);
    3f86:	85a6                	mv	a1,s1
    3f88:	00004517          	auipc	a0,0x4
    3f8c:	b0850513          	add	a0,a0,-1272 # 7a90 <malloc+0x1a1e>
    3f90:	00002097          	auipc	ra,0x2
    3f94:	02a080e7          	jalr	42(ra) # 5fba <printf>
    exit(1);
    3f98:	4505                	li	a0,1
    3f9a:	00002097          	auipc	ra,0x2
    3f9e:	ca8080e7          	jalr	-856(ra) # 5c42 <exit>
    printf("%s: rm . worked!\n", s);
    3fa2:	85a6                	mv	a1,s1
    3fa4:	00004517          	auipc	a0,0x4
    3fa8:	b0450513          	add	a0,a0,-1276 # 7aa8 <malloc+0x1a36>
    3fac:	00002097          	auipc	ra,0x2
    3fb0:	00e080e7          	jalr	14(ra) # 5fba <printf>
    exit(1);
    3fb4:	4505                	li	a0,1
    3fb6:	00002097          	auipc	ra,0x2
    3fba:	c8c080e7          	jalr	-884(ra) # 5c42 <exit>
    printf("%s: rm .. worked!\n", s);
    3fbe:	85a6                	mv	a1,s1
    3fc0:	00004517          	auipc	a0,0x4
    3fc4:	b0050513          	add	a0,a0,-1280 # 7ac0 <malloc+0x1a4e>
    3fc8:	00002097          	auipc	ra,0x2
    3fcc:	ff2080e7          	jalr	-14(ra) # 5fba <printf>
    exit(1);
    3fd0:	4505                	li	a0,1
    3fd2:	00002097          	auipc	ra,0x2
    3fd6:	c70080e7          	jalr	-912(ra) # 5c42 <exit>
    printf("%s: chdir / failed\n", s);
    3fda:	85a6                	mv	a1,s1
    3fdc:	00003517          	auipc	a0,0x3
    3fe0:	49c50513          	add	a0,a0,1180 # 7478 <malloc+0x1406>
    3fe4:	00002097          	auipc	ra,0x2
    3fe8:	fd6080e7          	jalr	-42(ra) # 5fba <printf>
    exit(1);
    3fec:	4505                	li	a0,1
    3fee:	00002097          	auipc	ra,0x2
    3ff2:	c54080e7          	jalr	-940(ra) # 5c42 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3ff6:	85a6                	mv	a1,s1
    3ff8:	00004517          	auipc	a0,0x4
    3ffc:	ae850513          	add	a0,a0,-1304 # 7ae0 <malloc+0x1a6e>
    4000:	00002097          	auipc	ra,0x2
    4004:	fba080e7          	jalr	-70(ra) # 5fba <printf>
    exit(1);
    4008:	4505                	li	a0,1
    400a:	00002097          	auipc	ra,0x2
    400e:	c38080e7          	jalr	-968(ra) # 5c42 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    4012:	85a6                	mv	a1,s1
    4014:	00004517          	auipc	a0,0x4
    4018:	af450513          	add	a0,a0,-1292 # 7b08 <malloc+0x1a96>
    401c:	00002097          	auipc	ra,0x2
    4020:	f9e080e7          	jalr	-98(ra) # 5fba <printf>
    exit(1);
    4024:	4505                	li	a0,1
    4026:	00002097          	auipc	ra,0x2
    402a:	c1c080e7          	jalr	-996(ra) # 5c42 <exit>
    printf("%s: unlink dots failed!\n", s);
    402e:	85a6                	mv	a1,s1
    4030:	00004517          	auipc	a0,0x4
    4034:	af850513          	add	a0,a0,-1288 # 7b28 <malloc+0x1ab6>
    4038:	00002097          	auipc	ra,0x2
    403c:	f82080e7          	jalr	-126(ra) # 5fba <printf>
    exit(1);
    4040:	4505                	li	a0,1
    4042:	00002097          	auipc	ra,0x2
    4046:	c00080e7          	jalr	-1024(ra) # 5c42 <exit>

000000000000404a <dirfile>:
{
    404a:	1101                	add	sp,sp,-32
    404c:	ec06                	sd	ra,24(sp)
    404e:	e822                	sd	s0,16(sp)
    4050:	e426                	sd	s1,8(sp)
    4052:	e04a                	sd	s2,0(sp)
    4054:	1000                	add	s0,sp,32
    4056:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    4058:	20000593          	li	a1,512
    405c:	00004517          	auipc	a0,0x4
    4060:	aec50513          	add	a0,a0,-1300 # 7b48 <malloc+0x1ad6>
    4064:	00002097          	auipc	ra,0x2
    4068:	c1e080e7          	jalr	-994(ra) # 5c82 <open>
  if(fd < 0){
    406c:	0e054d63          	bltz	a0,4166 <dirfile+0x11c>
  close(fd);
    4070:	00002097          	auipc	ra,0x2
    4074:	bfa080e7          	jalr	-1030(ra) # 5c6a <close>
  if(chdir("dirfile") == 0){
    4078:	00004517          	auipc	a0,0x4
    407c:	ad050513          	add	a0,a0,-1328 # 7b48 <malloc+0x1ad6>
    4080:	00002097          	auipc	ra,0x2
    4084:	c32080e7          	jalr	-974(ra) # 5cb2 <chdir>
    4088:	cd6d                	beqz	a0,4182 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    408a:	4581                	li	a1,0
    408c:	00004517          	auipc	a0,0x4
    4090:	b0450513          	add	a0,a0,-1276 # 7b90 <malloc+0x1b1e>
    4094:	00002097          	auipc	ra,0x2
    4098:	bee080e7          	jalr	-1042(ra) # 5c82 <open>
  if(fd >= 0){
    409c:	10055163          	bgez	a0,419e <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    40a0:	20000593          	li	a1,512
    40a4:	00004517          	auipc	a0,0x4
    40a8:	aec50513          	add	a0,a0,-1300 # 7b90 <malloc+0x1b1e>
    40ac:	00002097          	auipc	ra,0x2
    40b0:	bd6080e7          	jalr	-1066(ra) # 5c82 <open>
  if(fd >= 0){
    40b4:	10055363          	bgez	a0,41ba <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    40b8:	00004517          	auipc	a0,0x4
    40bc:	ad850513          	add	a0,a0,-1320 # 7b90 <malloc+0x1b1e>
    40c0:	00002097          	auipc	ra,0x2
    40c4:	bea080e7          	jalr	-1046(ra) # 5caa <mkdir>
    40c8:	10050763          	beqz	a0,41d6 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    40cc:	00004517          	auipc	a0,0x4
    40d0:	ac450513          	add	a0,a0,-1340 # 7b90 <malloc+0x1b1e>
    40d4:	00002097          	auipc	ra,0x2
    40d8:	bbe080e7          	jalr	-1090(ra) # 5c92 <unlink>
    40dc:	10050b63          	beqz	a0,41f2 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    40e0:	00004597          	auipc	a1,0x4
    40e4:	ab058593          	add	a1,a1,-1360 # 7b90 <malloc+0x1b1e>
    40e8:	00002517          	auipc	a0,0x2
    40ec:	2a850513          	add	a0,a0,680 # 6390 <malloc+0x31e>
    40f0:	00002097          	auipc	ra,0x2
    40f4:	bb2080e7          	jalr	-1102(ra) # 5ca2 <link>
    40f8:	10050b63          	beqz	a0,420e <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    40fc:	00004517          	auipc	a0,0x4
    4100:	a4c50513          	add	a0,a0,-1460 # 7b48 <malloc+0x1ad6>
    4104:	00002097          	auipc	ra,0x2
    4108:	b8e080e7          	jalr	-1138(ra) # 5c92 <unlink>
    410c:	10051f63          	bnez	a0,422a <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    4110:	4589                	li	a1,2
    4112:	00002517          	auipc	a0,0x2
    4116:	78e50513          	add	a0,a0,1934 # 68a0 <malloc+0x82e>
    411a:	00002097          	auipc	ra,0x2
    411e:	b68080e7          	jalr	-1176(ra) # 5c82 <open>
  if(fd >= 0){
    4122:	12055263          	bgez	a0,4246 <dirfile+0x1fc>
  fd = open(".", 0);
    4126:	4581                	li	a1,0
    4128:	00002517          	auipc	a0,0x2
    412c:	77850513          	add	a0,a0,1912 # 68a0 <malloc+0x82e>
    4130:	00002097          	auipc	ra,0x2
    4134:	b52080e7          	jalr	-1198(ra) # 5c82 <open>
    4138:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    413a:	4605                	li	a2,1
    413c:	00002597          	auipc	a1,0x2
    4140:	0ec58593          	add	a1,a1,236 # 6228 <malloc+0x1b6>
    4144:	00002097          	auipc	ra,0x2
    4148:	b1e080e7          	jalr	-1250(ra) # 5c62 <write>
    414c:	10a04b63          	bgtz	a0,4262 <dirfile+0x218>
  close(fd);
    4150:	8526                	mv	a0,s1
    4152:	00002097          	auipc	ra,0x2
    4156:	b18080e7          	jalr	-1256(ra) # 5c6a <close>
}
    415a:	60e2                	ld	ra,24(sp)
    415c:	6442                	ld	s0,16(sp)
    415e:	64a2                	ld	s1,8(sp)
    4160:	6902                	ld	s2,0(sp)
    4162:	6105                	add	sp,sp,32
    4164:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    4166:	85ca                	mv	a1,s2
    4168:	00004517          	auipc	a0,0x4
    416c:	9e850513          	add	a0,a0,-1560 # 7b50 <malloc+0x1ade>
    4170:	00002097          	auipc	ra,0x2
    4174:	e4a080e7          	jalr	-438(ra) # 5fba <printf>
    exit(1);
    4178:	4505                	li	a0,1
    417a:	00002097          	auipc	ra,0x2
    417e:	ac8080e7          	jalr	-1336(ra) # 5c42 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    4182:	85ca                	mv	a1,s2
    4184:	00004517          	auipc	a0,0x4
    4188:	9ec50513          	add	a0,a0,-1556 # 7b70 <malloc+0x1afe>
    418c:	00002097          	auipc	ra,0x2
    4190:	e2e080e7          	jalr	-466(ra) # 5fba <printf>
    exit(1);
    4194:	4505                	li	a0,1
    4196:	00002097          	auipc	ra,0x2
    419a:	aac080e7          	jalr	-1364(ra) # 5c42 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    419e:	85ca                	mv	a1,s2
    41a0:	00004517          	auipc	a0,0x4
    41a4:	a0050513          	add	a0,a0,-1536 # 7ba0 <malloc+0x1b2e>
    41a8:	00002097          	auipc	ra,0x2
    41ac:	e12080e7          	jalr	-494(ra) # 5fba <printf>
    exit(1);
    41b0:	4505                	li	a0,1
    41b2:	00002097          	auipc	ra,0x2
    41b6:	a90080e7          	jalr	-1392(ra) # 5c42 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    41ba:	85ca                	mv	a1,s2
    41bc:	00004517          	auipc	a0,0x4
    41c0:	9e450513          	add	a0,a0,-1564 # 7ba0 <malloc+0x1b2e>
    41c4:	00002097          	auipc	ra,0x2
    41c8:	df6080e7          	jalr	-522(ra) # 5fba <printf>
    exit(1);
    41cc:	4505                	li	a0,1
    41ce:	00002097          	auipc	ra,0x2
    41d2:	a74080e7          	jalr	-1420(ra) # 5c42 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    41d6:	85ca                	mv	a1,s2
    41d8:	00004517          	auipc	a0,0x4
    41dc:	9f050513          	add	a0,a0,-1552 # 7bc8 <malloc+0x1b56>
    41e0:	00002097          	auipc	ra,0x2
    41e4:	dda080e7          	jalr	-550(ra) # 5fba <printf>
    exit(1);
    41e8:	4505                	li	a0,1
    41ea:	00002097          	auipc	ra,0x2
    41ee:	a58080e7          	jalr	-1448(ra) # 5c42 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    41f2:	85ca                	mv	a1,s2
    41f4:	00004517          	auipc	a0,0x4
    41f8:	9fc50513          	add	a0,a0,-1540 # 7bf0 <malloc+0x1b7e>
    41fc:	00002097          	auipc	ra,0x2
    4200:	dbe080e7          	jalr	-578(ra) # 5fba <printf>
    exit(1);
    4204:	4505                	li	a0,1
    4206:	00002097          	auipc	ra,0x2
    420a:	a3c080e7          	jalr	-1476(ra) # 5c42 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    420e:	85ca                	mv	a1,s2
    4210:	00004517          	auipc	a0,0x4
    4214:	a0850513          	add	a0,a0,-1528 # 7c18 <malloc+0x1ba6>
    4218:	00002097          	auipc	ra,0x2
    421c:	da2080e7          	jalr	-606(ra) # 5fba <printf>
    exit(1);
    4220:	4505                	li	a0,1
    4222:	00002097          	auipc	ra,0x2
    4226:	a20080e7          	jalr	-1504(ra) # 5c42 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    422a:	85ca                	mv	a1,s2
    422c:	00004517          	auipc	a0,0x4
    4230:	a1450513          	add	a0,a0,-1516 # 7c40 <malloc+0x1bce>
    4234:	00002097          	auipc	ra,0x2
    4238:	d86080e7          	jalr	-634(ra) # 5fba <printf>
    exit(1);
    423c:	4505                	li	a0,1
    423e:	00002097          	auipc	ra,0x2
    4242:	a04080e7          	jalr	-1532(ra) # 5c42 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    4246:	85ca                	mv	a1,s2
    4248:	00004517          	auipc	a0,0x4
    424c:	a1850513          	add	a0,a0,-1512 # 7c60 <malloc+0x1bee>
    4250:	00002097          	auipc	ra,0x2
    4254:	d6a080e7          	jalr	-662(ra) # 5fba <printf>
    exit(1);
    4258:	4505                	li	a0,1
    425a:	00002097          	auipc	ra,0x2
    425e:	9e8080e7          	jalr	-1560(ra) # 5c42 <exit>
    printf("%s: write . succeeded!\n", s);
    4262:	85ca                	mv	a1,s2
    4264:	00004517          	auipc	a0,0x4
    4268:	a2450513          	add	a0,a0,-1500 # 7c88 <malloc+0x1c16>
    426c:	00002097          	auipc	ra,0x2
    4270:	d4e080e7          	jalr	-690(ra) # 5fba <printf>
    exit(1);
    4274:	4505                	li	a0,1
    4276:	00002097          	auipc	ra,0x2
    427a:	9cc080e7          	jalr	-1588(ra) # 5c42 <exit>

000000000000427e <iref>:
{
    427e:	7139                	add	sp,sp,-64
    4280:	fc06                	sd	ra,56(sp)
    4282:	f822                	sd	s0,48(sp)
    4284:	f426                	sd	s1,40(sp)
    4286:	f04a                	sd	s2,32(sp)
    4288:	ec4e                	sd	s3,24(sp)
    428a:	e852                	sd	s4,16(sp)
    428c:	e456                	sd	s5,8(sp)
    428e:	e05a                	sd	s6,0(sp)
    4290:	0080                	add	s0,sp,64
    4292:	8b2a                	mv	s6,a0
    4294:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4298:	00004a17          	auipc	s4,0x4
    429c:	a08a0a13          	add	s4,s4,-1528 # 7ca0 <malloc+0x1c2e>
    mkdir("");
    42a0:	00003497          	auipc	s1,0x3
    42a4:	50848493          	add	s1,s1,1288 # 77a8 <malloc+0x1736>
    link("README", "");
    42a8:	00002a97          	auipc	s5,0x2
    42ac:	0e8a8a93          	add	s5,s5,232 # 6390 <malloc+0x31e>
    fd = open("xx", O_CREATE);
    42b0:	00004997          	auipc	s3,0x4
    42b4:	8e898993          	add	s3,s3,-1816 # 7b98 <malloc+0x1b26>
    42b8:	a891                	j	430c <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    42ba:	85da                	mv	a1,s6
    42bc:	00004517          	auipc	a0,0x4
    42c0:	9ec50513          	add	a0,a0,-1556 # 7ca8 <malloc+0x1c36>
    42c4:	00002097          	auipc	ra,0x2
    42c8:	cf6080e7          	jalr	-778(ra) # 5fba <printf>
      exit(1);
    42cc:	4505                	li	a0,1
    42ce:	00002097          	auipc	ra,0x2
    42d2:	974080e7          	jalr	-1676(ra) # 5c42 <exit>
      printf("%s: chdir irefd failed\n", s);
    42d6:	85da                	mv	a1,s6
    42d8:	00004517          	auipc	a0,0x4
    42dc:	9e850513          	add	a0,a0,-1560 # 7cc0 <malloc+0x1c4e>
    42e0:	00002097          	auipc	ra,0x2
    42e4:	cda080e7          	jalr	-806(ra) # 5fba <printf>
      exit(1);
    42e8:	4505                	li	a0,1
    42ea:	00002097          	auipc	ra,0x2
    42ee:	958080e7          	jalr	-1704(ra) # 5c42 <exit>
      close(fd);
    42f2:	00002097          	auipc	ra,0x2
    42f6:	978080e7          	jalr	-1672(ra) # 5c6a <close>
    42fa:	a889                	j	434c <iref+0xce>
    unlink("xx");
    42fc:	854e                	mv	a0,s3
    42fe:	00002097          	auipc	ra,0x2
    4302:	994080e7          	jalr	-1644(ra) # 5c92 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4306:	397d                	addw	s2,s2,-1
    4308:	06090063          	beqz	s2,4368 <iref+0xea>
    if(mkdir("irefd") != 0){
    430c:	8552                	mv	a0,s4
    430e:	00002097          	auipc	ra,0x2
    4312:	99c080e7          	jalr	-1636(ra) # 5caa <mkdir>
    4316:	f155                	bnez	a0,42ba <iref+0x3c>
    if(chdir("irefd") != 0){
    4318:	8552                	mv	a0,s4
    431a:	00002097          	auipc	ra,0x2
    431e:	998080e7          	jalr	-1640(ra) # 5cb2 <chdir>
    4322:	f955                	bnez	a0,42d6 <iref+0x58>
    mkdir("");
    4324:	8526                	mv	a0,s1
    4326:	00002097          	auipc	ra,0x2
    432a:	984080e7          	jalr	-1660(ra) # 5caa <mkdir>
    link("README", "");
    432e:	85a6                	mv	a1,s1
    4330:	8556                	mv	a0,s5
    4332:	00002097          	auipc	ra,0x2
    4336:	970080e7          	jalr	-1680(ra) # 5ca2 <link>
    fd = open("", O_CREATE);
    433a:	20000593          	li	a1,512
    433e:	8526                	mv	a0,s1
    4340:	00002097          	auipc	ra,0x2
    4344:	942080e7          	jalr	-1726(ra) # 5c82 <open>
    if(fd >= 0)
    4348:	fa0555e3          	bgez	a0,42f2 <iref+0x74>
    fd = open("xx", O_CREATE);
    434c:	20000593          	li	a1,512
    4350:	854e                	mv	a0,s3
    4352:	00002097          	auipc	ra,0x2
    4356:	930080e7          	jalr	-1744(ra) # 5c82 <open>
    if(fd >= 0)
    435a:	fa0541e3          	bltz	a0,42fc <iref+0x7e>
      close(fd);
    435e:	00002097          	auipc	ra,0x2
    4362:	90c080e7          	jalr	-1780(ra) # 5c6a <close>
    4366:	bf59                	j	42fc <iref+0x7e>
    4368:	03300493          	li	s1,51
    chdir("..");
    436c:	00003997          	auipc	s3,0x3
    4370:	15c98993          	add	s3,s3,348 # 74c8 <malloc+0x1456>
    unlink("irefd");
    4374:	00004917          	auipc	s2,0x4
    4378:	92c90913          	add	s2,s2,-1748 # 7ca0 <malloc+0x1c2e>
    chdir("..");
    437c:	854e                	mv	a0,s3
    437e:	00002097          	auipc	ra,0x2
    4382:	934080e7          	jalr	-1740(ra) # 5cb2 <chdir>
    unlink("irefd");
    4386:	854a                	mv	a0,s2
    4388:	00002097          	auipc	ra,0x2
    438c:	90a080e7          	jalr	-1782(ra) # 5c92 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4390:	34fd                	addw	s1,s1,-1
    4392:	f4ed                	bnez	s1,437c <iref+0xfe>
  chdir("/");
    4394:	00003517          	auipc	a0,0x3
    4398:	0dc50513          	add	a0,a0,220 # 7470 <malloc+0x13fe>
    439c:	00002097          	auipc	ra,0x2
    43a0:	916080e7          	jalr	-1770(ra) # 5cb2 <chdir>
}
    43a4:	70e2                	ld	ra,56(sp)
    43a6:	7442                	ld	s0,48(sp)
    43a8:	74a2                	ld	s1,40(sp)
    43aa:	7902                	ld	s2,32(sp)
    43ac:	69e2                	ld	s3,24(sp)
    43ae:	6a42                	ld	s4,16(sp)
    43b0:	6aa2                	ld	s5,8(sp)
    43b2:	6b02                	ld	s6,0(sp)
    43b4:	6121                	add	sp,sp,64
    43b6:	8082                	ret

00000000000043b8 <openiputtest>:
{
    43b8:	7179                	add	sp,sp,-48
    43ba:	f406                	sd	ra,40(sp)
    43bc:	f022                	sd	s0,32(sp)
    43be:	ec26                	sd	s1,24(sp)
    43c0:	1800                	add	s0,sp,48
    43c2:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    43c4:	00004517          	auipc	a0,0x4
    43c8:	91450513          	add	a0,a0,-1772 # 7cd8 <malloc+0x1c66>
    43cc:	00002097          	auipc	ra,0x2
    43d0:	8de080e7          	jalr	-1826(ra) # 5caa <mkdir>
    43d4:	04054263          	bltz	a0,4418 <openiputtest+0x60>
  pid = fork();
    43d8:	00002097          	auipc	ra,0x2
    43dc:	862080e7          	jalr	-1950(ra) # 5c3a <fork>
  if(pid < 0){
    43e0:	04054a63          	bltz	a0,4434 <openiputtest+0x7c>
  if(pid == 0){
    43e4:	e93d                	bnez	a0,445a <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    43e6:	4589                	li	a1,2
    43e8:	00004517          	auipc	a0,0x4
    43ec:	8f050513          	add	a0,a0,-1808 # 7cd8 <malloc+0x1c66>
    43f0:	00002097          	auipc	ra,0x2
    43f4:	892080e7          	jalr	-1902(ra) # 5c82 <open>
    if(fd >= 0){
    43f8:	04054c63          	bltz	a0,4450 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    43fc:	85a6                	mv	a1,s1
    43fe:	00004517          	auipc	a0,0x4
    4402:	8fa50513          	add	a0,a0,-1798 # 7cf8 <malloc+0x1c86>
    4406:	00002097          	auipc	ra,0x2
    440a:	bb4080e7          	jalr	-1100(ra) # 5fba <printf>
      exit(1);
    440e:	4505                	li	a0,1
    4410:	00002097          	auipc	ra,0x2
    4414:	832080e7          	jalr	-1998(ra) # 5c42 <exit>
    printf("%s: mkdir oidir failed\n", s);
    4418:	85a6                	mv	a1,s1
    441a:	00004517          	auipc	a0,0x4
    441e:	8c650513          	add	a0,a0,-1850 # 7ce0 <malloc+0x1c6e>
    4422:	00002097          	auipc	ra,0x2
    4426:	b98080e7          	jalr	-1128(ra) # 5fba <printf>
    exit(1);
    442a:	4505                	li	a0,1
    442c:	00002097          	auipc	ra,0x2
    4430:	816080e7          	jalr	-2026(ra) # 5c42 <exit>
    printf("%s: fork failed\n", s);
    4434:	85a6                	mv	a1,s1
    4436:	00002517          	auipc	a0,0x2
    443a:	60a50513          	add	a0,a0,1546 # 6a40 <malloc+0x9ce>
    443e:	00002097          	auipc	ra,0x2
    4442:	b7c080e7          	jalr	-1156(ra) # 5fba <printf>
    exit(1);
    4446:	4505                	li	a0,1
    4448:	00001097          	auipc	ra,0x1
    444c:	7fa080e7          	jalr	2042(ra) # 5c42 <exit>
    exit(0);
    4450:	4501                	li	a0,0
    4452:	00001097          	auipc	ra,0x1
    4456:	7f0080e7          	jalr	2032(ra) # 5c42 <exit>
  sleep(1);
    445a:	4505                	li	a0,1
    445c:	00002097          	auipc	ra,0x2
    4460:	876080e7          	jalr	-1930(ra) # 5cd2 <sleep>
  if(unlink("oidir") != 0){
    4464:	00004517          	auipc	a0,0x4
    4468:	87450513          	add	a0,a0,-1932 # 7cd8 <malloc+0x1c66>
    446c:	00002097          	auipc	ra,0x2
    4470:	826080e7          	jalr	-2010(ra) # 5c92 <unlink>
    4474:	cd19                	beqz	a0,4492 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    4476:	85a6                	mv	a1,s1
    4478:	00002517          	auipc	a0,0x2
    447c:	7b850513          	add	a0,a0,1976 # 6c30 <malloc+0xbbe>
    4480:	00002097          	auipc	ra,0x2
    4484:	b3a080e7          	jalr	-1222(ra) # 5fba <printf>
    exit(1);
    4488:	4505                	li	a0,1
    448a:	00001097          	auipc	ra,0x1
    448e:	7b8080e7          	jalr	1976(ra) # 5c42 <exit>
  wait(&xstatus);
    4492:	fdc40513          	add	a0,s0,-36
    4496:	00001097          	auipc	ra,0x1
    449a:	7b4080e7          	jalr	1972(ra) # 5c4a <wait>
  exit(xstatus);
    449e:	fdc42503          	lw	a0,-36(s0)
    44a2:	00001097          	auipc	ra,0x1
    44a6:	7a0080e7          	jalr	1952(ra) # 5c42 <exit>

00000000000044aa <forkforkfork>:
{
    44aa:	1101                	add	sp,sp,-32
    44ac:	ec06                	sd	ra,24(sp)
    44ae:	e822                	sd	s0,16(sp)
    44b0:	e426                	sd	s1,8(sp)
    44b2:	1000                	add	s0,sp,32
    44b4:	84aa                	mv	s1,a0
  unlink("stopforking");
    44b6:	00004517          	auipc	a0,0x4
    44ba:	86a50513          	add	a0,a0,-1942 # 7d20 <malloc+0x1cae>
    44be:	00001097          	auipc	ra,0x1
    44c2:	7d4080e7          	jalr	2004(ra) # 5c92 <unlink>
  int pid = fork();
    44c6:	00001097          	auipc	ra,0x1
    44ca:	774080e7          	jalr	1908(ra) # 5c3a <fork>
  if(pid < 0){
    44ce:	04054563          	bltz	a0,4518 <forkforkfork+0x6e>
  if(pid == 0){
    44d2:	c12d                	beqz	a0,4534 <forkforkfork+0x8a>
  sleep(20); // two seconds
    44d4:	4551                	li	a0,20
    44d6:	00001097          	auipc	ra,0x1
    44da:	7fc080e7          	jalr	2044(ra) # 5cd2 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    44de:	20200593          	li	a1,514
    44e2:	00004517          	auipc	a0,0x4
    44e6:	83e50513          	add	a0,a0,-1986 # 7d20 <malloc+0x1cae>
    44ea:	00001097          	auipc	ra,0x1
    44ee:	798080e7          	jalr	1944(ra) # 5c82 <open>
    44f2:	00001097          	auipc	ra,0x1
    44f6:	778080e7          	jalr	1912(ra) # 5c6a <close>
  wait(0);
    44fa:	4501                	li	a0,0
    44fc:	00001097          	auipc	ra,0x1
    4500:	74e080e7          	jalr	1870(ra) # 5c4a <wait>
  sleep(10); // one second
    4504:	4529                	li	a0,10
    4506:	00001097          	auipc	ra,0x1
    450a:	7cc080e7          	jalr	1996(ra) # 5cd2 <sleep>
}
    450e:	60e2                	ld	ra,24(sp)
    4510:	6442                	ld	s0,16(sp)
    4512:	64a2                	ld	s1,8(sp)
    4514:	6105                	add	sp,sp,32
    4516:	8082                	ret
    printf("%s: fork failed", s);
    4518:	85a6                	mv	a1,s1
    451a:	00002517          	auipc	a0,0x2
    451e:	6e650513          	add	a0,a0,1766 # 6c00 <malloc+0xb8e>
    4522:	00002097          	auipc	ra,0x2
    4526:	a98080e7          	jalr	-1384(ra) # 5fba <printf>
    exit(1);
    452a:	4505                	li	a0,1
    452c:	00001097          	auipc	ra,0x1
    4530:	716080e7          	jalr	1814(ra) # 5c42 <exit>
      int fd = open("stopforking", 0);
    4534:	00003497          	auipc	s1,0x3
    4538:	7ec48493          	add	s1,s1,2028 # 7d20 <malloc+0x1cae>
    453c:	4581                	li	a1,0
    453e:	8526                	mv	a0,s1
    4540:	00001097          	auipc	ra,0x1
    4544:	742080e7          	jalr	1858(ra) # 5c82 <open>
      if(fd >= 0){
    4548:	02055763          	bgez	a0,4576 <forkforkfork+0xcc>
      if(fork() < 0){
    454c:	00001097          	auipc	ra,0x1
    4550:	6ee080e7          	jalr	1774(ra) # 5c3a <fork>
    4554:	fe0554e3          	bgez	a0,453c <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    4558:	20200593          	li	a1,514
    455c:	00003517          	auipc	a0,0x3
    4560:	7c450513          	add	a0,a0,1988 # 7d20 <malloc+0x1cae>
    4564:	00001097          	auipc	ra,0x1
    4568:	71e080e7          	jalr	1822(ra) # 5c82 <open>
    456c:	00001097          	auipc	ra,0x1
    4570:	6fe080e7          	jalr	1790(ra) # 5c6a <close>
    4574:	b7e1                	j	453c <forkforkfork+0x92>
        exit(0);
    4576:	4501                	li	a0,0
    4578:	00001097          	auipc	ra,0x1
    457c:	6ca080e7          	jalr	1738(ra) # 5c42 <exit>

0000000000004580 <killstatus>:
{
    4580:	7139                	add	sp,sp,-64
    4582:	fc06                	sd	ra,56(sp)
    4584:	f822                	sd	s0,48(sp)
    4586:	f426                	sd	s1,40(sp)
    4588:	f04a                	sd	s2,32(sp)
    458a:	ec4e                	sd	s3,24(sp)
    458c:	e852                	sd	s4,16(sp)
    458e:	0080                	add	s0,sp,64
    4590:	8a2a                	mv	s4,a0
    4592:	06400913          	li	s2,100
    if(xst != -1) {
    4596:	59fd                	li	s3,-1
    int pid1 = fork();
    4598:	00001097          	auipc	ra,0x1
    459c:	6a2080e7          	jalr	1698(ra) # 5c3a <fork>
    45a0:	84aa                	mv	s1,a0
    if(pid1 < 0){
    45a2:	02054f63          	bltz	a0,45e0 <killstatus+0x60>
    if(pid1 == 0){
    45a6:	c939                	beqz	a0,45fc <killstatus+0x7c>
    sleep(1);
    45a8:	4505                	li	a0,1
    45aa:	00001097          	auipc	ra,0x1
    45ae:	728080e7          	jalr	1832(ra) # 5cd2 <sleep>
    kill(pid1);
    45b2:	8526                	mv	a0,s1
    45b4:	00001097          	auipc	ra,0x1
    45b8:	6be080e7          	jalr	1726(ra) # 5c72 <kill>
    wait(&xst);
    45bc:	fcc40513          	add	a0,s0,-52
    45c0:	00001097          	auipc	ra,0x1
    45c4:	68a080e7          	jalr	1674(ra) # 5c4a <wait>
    if(xst != -1) {
    45c8:	fcc42783          	lw	a5,-52(s0)
    45cc:	03379d63          	bne	a5,s3,4606 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    45d0:	397d                	addw	s2,s2,-1
    45d2:	fc0913e3          	bnez	s2,4598 <killstatus+0x18>
  exit(0);
    45d6:	4501                	li	a0,0
    45d8:	00001097          	auipc	ra,0x1
    45dc:	66a080e7          	jalr	1642(ra) # 5c42 <exit>
      printf("%s: fork failed\n", s);
    45e0:	85d2                	mv	a1,s4
    45e2:	00002517          	auipc	a0,0x2
    45e6:	45e50513          	add	a0,a0,1118 # 6a40 <malloc+0x9ce>
    45ea:	00002097          	auipc	ra,0x2
    45ee:	9d0080e7          	jalr	-1584(ra) # 5fba <printf>
      exit(1);
    45f2:	4505                	li	a0,1
    45f4:	00001097          	auipc	ra,0x1
    45f8:	64e080e7          	jalr	1614(ra) # 5c42 <exit>
        getpid();
    45fc:	00001097          	auipc	ra,0x1
    4600:	6c6080e7          	jalr	1734(ra) # 5cc2 <getpid>
      while(1) {
    4604:	bfe5                	j	45fc <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    4606:	85d2                	mv	a1,s4
    4608:	00003517          	auipc	a0,0x3
    460c:	72850513          	add	a0,a0,1832 # 7d30 <malloc+0x1cbe>
    4610:	00002097          	auipc	ra,0x2
    4614:	9aa080e7          	jalr	-1622(ra) # 5fba <printf>
       exit(1);
    4618:	4505                	li	a0,1
    461a:	00001097          	auipc	ra,0x1
    461e:	628080e7          	jalr	1576(ra) # 5c42 <exit>

0000000000004622 <preempt>:
{
    4622:	7139                	add	sp,sp,-64
    4624:	fc06                	sd	ra,56(sp)
    4626:	f822                	sd	s0,48(sp)
    4628:	f426                	sd	s1,40(sp)
    462a:	f04a                	sd	s2,32(sp)
    462c:	ec4e                	sd	s3,24(sp)
    462e:	e852                	sd	s4,16(sp)
    4630:	0080                	add	s0,sp,64
    4632:	892a                	mv	s2,a0
  pid1 = fork();
    4634:	00001097          	auipc	ra,0x1
    4638:	606080e7          	jalr	1542(ra) # 5c3a <fork>
  if(pid1 < 0) {
    463c:	00054563          	bltz	a0,4646 <preempt+0x24>
    4640:	84aa                	mv	s1,a0
  if(pid1 == 0)
    4642:	e105                	bnez	a0,4662 <preempt+0x40>
    for(;;)
    4644:	a001                	j	4644 <preempt+0x22>
    printf("%s: fork failed", s);
    4646:	85ca                	mv	a1,s2
    4648:	00002517          	auipc	a0,0x2
    464c:	5b850513          	add	a0,a0,1464 # 6c00 <malloc+0xb8e>
    4650:	00002097          	auipc	ra,0x2
    4654:	96a080e7          	jalr	-1686(ra) # 5fba <printf>
    exit(1);
    4658:	4505                	li	a0,1
    465a:	00001097          	auipc	ra,0x1
    465e:	5e8080e7          	jalr	1512(ra) # 5c42 <exit>
  pid2 = fork();
    4662:	00001097          	auipc	ra,0x1
    4666:	5d8080e7          	jalr	1496(ra) # 5c3a <fork>
    466a:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    466c:	00054463          	bltz	a0,4674 <preempt+0x52>
  if(pid2 == 0)
    4670:	e105                	bnez	a0,4690 <preempt+0x6e>
    for(;;)
    4672:	a001                	j	4672 <preempt+0x50>
    printf("%s: fork failed\n", s);
    4674:	85ca                	mv	a1,s2
    4676:	00002517          	auipc	a0,0x2
    467a:	3ca50513          	add	a0,a0,970 # 6a40 <malloc+0x9ce>
    467e:	00002097          	auipc	ra,0x2
    4682:	93c080e7          	jalr	-1732(ra) # 5fba <printf>
    exit(1);
    4686:	4505                	li	a0,1
    4688:	00001097          	auipc	ra,0x1
    468c:	5ba080e7          	jalr	1466(ra) # 5c42 <exit>
  pipe(pfds);
    4690:	fc840513          	add	a0,s0,-56
    4694:	00001097          	auipc	ra,0x1
    4698:	5be080e7          	jalr	1470(ra) # 5c52 <pipe>
  pid3 = fork();
    469c:	00001097          	auipc	ra,0x1
    46a0:	59e080e7          	jalr	1438(ra) # 5c3a <fork>
    46a4:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    46a6:	02054e63          	bltz	a0,46e2 <preempt+0xc0>
  if(pid3 == 0){
    46aa:	e525                	bnez	a0,4712 <preempt+0xf0>
    close(pfds[0]);
    46ac:	fc842503          	lw	a0,-56(s0)
    46b0:	00001097          	auipc	ra,0x1
    46b4:	5ba080e7          	jalr	1466(ra) # 5c6a <close>
    if(write(pfds[1], "x", 1) != 1)
    46b8:	4605                	li	a2,1
    46ba:	00002597          	auipc	a1,0x2
    46be:	b6e58593          	add	a1,a1,-1170 # 6228 <malloc+0x1b6>
    46c2:	fcc42503          	lw	a0,-52(s0)
    46c6:	00001097          	auipc	ra,0x1
    46ca:	59c080e7          	jalr	1436(ra) # 5c62 <write>
    46ce:	4785                	li	a5,1
    46d0:	02f51763          	bne	a0,a5,46fe <preempt+0xdc>
    close(pfds[1]);
    46d4:	fcc42503          	lw	a0,-52(s0)
    46d8:	00001097          	auipc	ra,0x1
    46dc:	592080e7          	jalr	1426(ra) # 5c6a <close>
    for(;;)
    46e0:	a001                	j	46e0 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    46e2:	85ca                	mv	a1,s2
    46e4:	00002517          	auipc	a0,0x2
    46e8:	35c50513          	add	a0,a0,860 # 6a40 <malloc+0x9ce>
    46ec:	00002097          	auipc	ra,0x2
    46f0:	8ce080e7          	jalr	-1842(ra) # 5fba <printf>
     exit(1);
    46f4:	4505                	li	a0,1
    46f6:	00001097          	auipc	ra,0x1
    46fa:	54c080e7          	jalr	1356(ra) # 5c42 <exit>
      printf("%s: preempt write error", s);
    46fe:	85ca                	mv	a1,s2
    4700:	00003517          	auipc	a0,0x3
    4704:	65050513          	add	a0,a0,1616 # 7d50 <malloc+0x1cde>
    4708:	00002097          	auipc	ra,0x2
    470c:	8b2080e7          	jalr	-1870(ra) # 5fba <printf>
    4710:	b7d1                	j	46d4 <preempt+0xb2>
  close(pfds[1]);
    4712:	fcc42503          	lw	a0,-52(s0)
    4716:	00001097          	auipc	ra,0x1
    471a:	554080e7          	jalr	1364(ra) # 5c6a <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    471e:	660d                	lui	a2,0x3
    4720:	0000a597          	auipc	a1,0xa
    4724:	91858593          	add	a1,a1,-1768 # e038 <buf>
    4728:	fc842503          	lw	a0,-56(s0)
    472c:	00001097          	auipc	ra,0x1
    4730:	52e080e7          	jalr	1326(ra) # 5c5a <read>
    4734:	4785                	li	a5,1
    4736:	02f50363          	beq	a0,a5,475c <preempt+0x13a>
    printf("%s: preempt read error", s);
    473a:	85ca                	mv	a1,s2
    473c:	00003517          	auipc	a0,0x3
    4740:	62c50513          	add	a0,a0,1580 # 7d68 <malloc+0x1cf6>
    4744:	00002097          	auipc	ra,0x2
    4748:	876080e7          	jalr	-1930(ra) # 5fba <printf>
}
    474c:	70e2                	ld	ra,56(sp)
    474e:	7442                	ld	s0,48(sp)
    4750:	74a2                	ld	s1,40(sp)
    4752:	7902                	ld	s2,32(sp)
    4754:	69e2                	ld	s3,24(sp)
    4756:	6a42                	ld	s4,16(sp)
    4758:	6121                	add	sp,sp,64
    475a:	8082                	ret
  close(pfds[0]);
    475c:	fc842503          	lw	a0,-56(s0)
    4760:	00001097          	auipc	ra,0x1
    4764:	50a080e7          	jalr	1290(ra) # 5c6a <close>
  printf("kill... ");
    4768:	00003517          	auipc	a0,0x3
    476c:	61850513          	add	a0,a0,1560 # 7d80 <malloc+0x1d0e>
    4770:	00002097          	auipc	ra,0x2
    4774:	84a080e7          	jalr	-1974(ra) # 5fba <printf>
  kill(pid1);
    4778:	8526                	mv	a0,s1
    477a:	00001097          	auipc	ra,0x1
    477e:	4f8080e7          	jalr	1272(ra) # 5c72 <kill>
  kill(pid2);
    4782:	854e                	mv	a0,s3
    4784:	00001097          	auipc	ra,0x1
    4788:	4ee080e7          	jalr	1262(ra) # 5c72 <kill>
  kill(pid3);
    478c:	8552                	mv	a0,s4
    478e:	00001097          	auipc	ra,0x1
    4792:	4e4080e7          	jalr	1252(ra) # 5c72 <kill>
  printf("wait... ");
    4796:	00003517          	auipc	a0,0x3
    479a:	5fa50513          	add	a0,a0,1530 # 7d90 <malloc+0x1d1e>
    479e:	00002097          	auipc	ra,0x2
    47a2:	81c080e7          	jalr	-2020(ra) # 5fba <printf>
  wait(0);
    47a6:	4501                	li	a0,0
    47a8:	00001097          	auipc	ra,0x1
    47ac:	4a2080e7          	jalr	1186(ra) # 5c4a <wait>
  wait(0);
    47b0:	4501                	li	a0,0
    47b2:	00001097          	auipc	ra,0x1
    47b6:	498080e7          	jalr	1176(ra) # 5c4a <wait>
  wait(0);
    47ba:	4501                	li	a0,0
    47bc:	00001097          	auipc	ra,0x1
    47c0:	48e080e7          	jalr	1166(ra) # 5c4a <wait>
    47c4:	b761                	j	474c <preempt+0x12a>

00000000000047c6 <reparent>:
{
    47c6:	7179                	add	sp,sp,-48
    47c8:	f406                	sd	ra,40(sp)
    47ca:	f022                	sd	s0,32(sp)
    47cc:	ec26                	sd	s1,24(sp)
    47ce:	e84a                	sd	s2,16(sp)
    47d0:	e44e                	sd	s3,8(sp)
    47d2:	e052                	sd	s4,0(sp)
    47d4:	1800                	add	s0,sp,48
    47d6:	89aa                	mv	s3,a0
  int master_pid = getpid();
    47d8:	00001097          	auipc	ra,0x1
    47dc:	4ea080e7          	jalr	1258(ra) # 5cc2 <getpid>
    47e0:	8a2a                	mv	s4,a0
    47e2:	0c800913          	li	s2,200
    int pid = fork();
    47e6:	00001097          	auipc	ra,0x1
    47ea:	454080e7          	jalr	1108(ra) # 5c3a <fork>
    47ee:	84aa                	mv	s1,a0
    if(pid < 0){
    47f0:	02054263          	bltz	a0,4814 <reparent+0x4e>
    if(pid){
    47f4:	cd21                	beqz	a0,484c <reparent+0x86>
      if(wait(0) != pid){
    47f6:	4501                	li	a0,0
    47f8:	00001097          	auipc	ra,0x1
    47fc:	452080e7          	jalr	1106(ra) # 5c4a <wait>
    4800:	02951863          	bne	a0,s1,4830 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4804:	397d                	addw	s2,s2,-1
    4806:	fe0910e3          	bnez	s2,47e6 <reparent+0x20>
  exit(0);
    480a:	4501                	li	a0,0
    480c:	00001097          	auipc	ra,0x1
    4810:	436080e7          	jalr	1078(ra) # 5c42 <exit>
      printf("%s: fork failed\n", s);
    4814:	85ce                	mv	a1,s3
    4816:	00002517          	auipc	a0,0x2
    481a:	22a50513          	add	a0,a0,554 # 6a40 <malloc+0x9ce>
    481e:	00001097          	auipc	ra,0x1
    4822:	79c080e7          	jalr	1948(ra) # 5fba <printf>
      exit(1);
    4826:	4505                	li	a0,1
    4828:	00001097          	auipc	ra,0x1
    482c:	41a080e7          	jalr	1050(ra) # 5c42 <exit>
        printf("%s: wait wrong pid\n", s);
    4830:	85ce                	mv	a1,s3
    4832:	00002517          	auipc	a0,0x2
    4836:	39650513          	add	a0,a0,918 # 6bc8 <malloc+0xb56>
    483a:	00001097          	auipc	ra,0x1
    483e:	780080e7          	jalr	1920(ra) # 5fba <printf>
        exit(1);
    4842:	4505                	li	a0,1
    4844:	00001097          	auipc	ra,0x1
    4848:	3fe080e7          	jalr	1022(ra) # 5c42 <exit>
      int pid2 = fork();
    484c:	00001097          	auipc	ra,0x1
    4850:	3ee080e7          	jalr	1006(ra) # 5c3a <fork>
      if(pid2 < 0){
    4854:	00054763          	bltz	a0,4862 <reparent+0x9c>
      exit(0);
    4858:	4501                	li	a0,0
    485a:	00001097          	auipc	ra,0x1
    485e:	3e8080e7          	jalr	1000(ra) # 5c42 <exit>
        kill(master_pid);
    4862:	8552                	mv	a0,s4
    4864:	00001097          	auipc	ra,0x1
    4868:	40e080e7          	jalr	1038(ra) # 5c72 <kill>
        exit(1);
    486c:	4505                	li	a0,1
    486e:	00001097          	auipc	ra,0x1
    4872:	3d4080e7          	jalr	980(ra) # 5c42 <exit>

0000000000004876 <sbrkfail>:
{
    4876:	7119                	add	sp,sp,-128
    4878:	fc86                	sd	ra,120(sp)
    487a:	f8a2                	sd	s0,112(sp)
    487c:	f4a6                	sd	s1,104(sp)
    487e:	f0ca                	sd	s2,96(sp)
    4880:	ecce                	sd	s3,88(sp)
    4882:	e8d2                	sd	s4,80(sp)
    4884:	e4d6                	sd	s5,72(sp)
    4886:	0100                	add	s0,sp,128
    4888:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    488a:	fb040513          	add	a0,s0,-80
    488e:	00001097          	auipc	ra,0x1
    4892:	3c4080e7          	jalr	964(ra) # 5c52 <pipe>
    4896:	e901                	bnez	a0,48a6 <sbrkfail+0x30>
    4898:	f8040493          	add	s1,s0,-128
    489c:	fa840993          	add	s3,s0,-88
    48a0:	8926                	mv	s2,s1
    if(pids[i] != -1)
    48a2:	5a7d                	li	s4,-1
    48a4:	a085                	j	4904 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    48a6:	85d6                	mv	a1,s5
    48a8:	00002517          	auipc	a0,0x2
    48ac:	2a050513          	add	a0,a0,672 # 6b48 <malloc+0xad6>
    48b0:	00001097          	auipc	ra,0x1
    48b4:	70a080e7          	jalr	1802(ra) # 5fba <printf>
    exit(1);
    48b8:	4505                	li	a0,1
    48ba:	00001097          	auipc	ra,0x1
    48be:	388080e7          	jalr	904(ra) # 5c42 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    48c2:	00001097          	auipc	ra,0x1
    48c6:	408080e7          	jalr	1032(ra) # 5cca <sbrk>
    48ca:	064007b7          	lui	a5,0x6400
    48ce:	40a7853b          	subw	a0,a5,a0
    48d2:	00001097          	auipc	ra,0x1
    48d6:	3f8080e7          	jalr	1016(ra) # 5cca <sbrk>
      write(fds[1], "x", 1);
    48da:	4605                	li	a2,1
    48dc:	00002597          	auipc	a1,0x2
    48e0:	94c58593          	add	a1,a1,-1716 # 6228 <malloc+0x1b6>
    48e4:	fb442503          	lw	a0,-76(s0)
    48e8:	00001097          	auipc	ra,0x1
    48ec:	37a080e7          	jalr	890(ra) # 5c62 <write>
      for(;;) sleep(1000);
    48f0:	3e800513          	li	a0,1000
    48f4:	00001097          	auipc	ra,0x1
    48f8:	3de080e7          	jalr	990(ra) # 5cd2 <sleep>
    48fc:	bfd5                	j	48f0 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48fe:	0911                	add	s2,s2,4
    4900:	03390563          	beq	s2,s3,492a <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    4904:	00001097          	auipc	ra,0x1
    4908:	336080e7          	jalr	822(ra) # 5c3a <fork>
    490c:	00a92023          	sw	a0,0(s2)
    4910:	d94d                	beqz	a0,48c2 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4912:	ff4506e3          	beq	a0,s4,48fe <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4916:	4605                	li	a2,1
    4918:	faf40593          	add	a1,s0,-81
    491c:	fb042503          	lw	a0,-80(s0)
    4920:	00001097          	auipc	ra,0x1
    4924:	33a080e7          	jalr	826(ra) # 5c5a <read>
    4928:	bfd9                	j	48fe <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    492a:	6505                	lui	a0,0x1
    492c:	00001097          	auipc	ra,0x1
    4930:	39e080e7          	jalr	926(ra) # 5cca <sbrk>
    4934:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4936:	597d                	li	s2,-1
    4938:	a021                	j	4940 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    493a:	0491                	add	s1,s1,4
    493c:	01348f63          	beq	s1,s3,495a <sbrkfail+0xe4>
    if(pids[i] == -1)
    4940:	4088                	lw	a0,0(s1)
    4942:	ff250ce3          	beq	a0,s2,493a <sbrkfail+0xc4>
    kill(pids[i]);
    4946:	00001097          	auipc	ra,0x1
    494a:	32c080e7          	jalr	812(ra) # 5c72 <kill>
    wait(0);
    494e:	4501                	li	a0,0
    4950:	00001097          	auipc	ra,0x1
    4954:	2fa080e7          	jalr	762(ra) # 5c4a <wait>
    4958:	b7cd                	j	493a <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    495a:	57fd                	li	a5,-1
    495c:	04fa0163          	beq	s4,a5,499e <sbrkfail+0x128>
  pid = fork();
    4960:	00001097          	auipc	ra,0x1
    4964:	2da080e7          	jalr	730(ra) # 5c3a <fork>
    4968:	84aa                	mv	s1,a0
  if(pid < 0){
    496a:	04054863          	bltz	a0,49ba <sbrkfail+0x144>
  if(pid == 0){
    496e:	c525                	beqz	a0,49d6 <sbrkfail+0x160>
  wait(&xstatus);
    4970:	fbc40513          	add	a0,s0,-68
    4974:	00001097          	auipc	ra,0x1
    4978:	2d6080e7          	jalr	726(ra) # 5c4a <wait>
  if(xstatus != -1 && xstatus != 2)
    497c:	fbc42783          	lw	a5,-68(s0)
    4980:	577d                	li	a4,-1
    4982:	00e78563          	beq	a5,a4,498c <sbrkfail+0x116>
    4986:	4709                	li	a4,2
    4988:	08e79d63          	bne	a5,a4,4a22 <sbrkfail+0x1ac>
}
    498c:	70e6                	ld	ra,120(sp)
    498e:	7446                	ld	s0,112(sp)
    4990:	74a6                	ld	s1,104(sp)
    4992:	7906                	ld	s2,96(sp)
    4994:	69e6                	ld	s3,88(sp)
    4996:	6a46                	ld	s4,80(sp)
    4998:	6aa6                	ld	s5,72(sp)
    499a:	6109                	add	sp,sp,128
    499c:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    499e:	85d6                	mv	a1,s5
    49a0:	00003517          	auipc	a0,0x3
    49a4:	40050513          	add	a0,a0,1024 # 7da0 <malloc+0x1d2e>
    49a8:	00001097          	auipc	ra,0x1
    49ac:	612080e7          	jalr	1554(ra) # 5fba <printf>
    exit(1);
    49b0:	4505                	li	a0,1
    49b2:	00001097          	auipc	ra,0x1
    49b6:	290080e7          	jalr	656(ra) # 5c42 <exit>
    printf("%s: fork failed\n", s);
    49ba:	85d6                	mv	a1,s5
    49bc:	00002517          	auipc	a0,0x2
    49c0:	08450513          	add	a0,a0,132 # 6a40 <malloc+0x9ce>
    49c4:	00001097          	auipc	ra,0x1
    49c8:	5f6080e7          	jalr	1526(ra) # 5fba <printf>
    exit(1);
    49cc:	4505                	li	a0,1
    49ce:	00001097          	auipc	ra,0x1
    49d2:	274080e7          	jalr	628(ra) # 5c42 <exit>
    a = sbrk(0);
    49d6:	4501                	li	a0,0
    49d8:	00001097          	auipc	ra,0x1
    49dc:	2f2080e7          	jalr	754(ra) # 5cca <sbrk>
    49e0:	892a                	mv	s2,a0
    sbrk(10*BIG);
    49e2:	3e800537          	lui	a0,0x3e800
    49e6:	00001097          	auipc	ra,0x1
    49ea:	2e4080e7          	jalr	740(ra) # 5cca <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    49ee:	87ca                	mv	a5,s2
    49f0:	3e800737          	lui	a4,0x3e800
    49f4:	993a                	add	s2,s2,a4
    49f6:	6705                	lui	a4,0x1
      n += *(a+i);
    49f8:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63eefc8>
    49fc:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    49fe:	97ba                	add	a5,a5,a4
    4a00:	fef91ce3          	bne	s2,a5,49f8 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4a04:	8626                	mv	a2,s1
    4a06:	85d6                	mv	a1,s5
    4a08:	00003517          	auipc	a0,0x3
    4a0c:	3b850513          	add	a0,a0,952 # 7dc0 <malloc+0x1d4e>
    4a10:	00001097          	auipc	ra,0x1
    4a14:	5aa080e7          	jalr	1450(ra) # 5fba <printf>
    exit(1);
    4a18:	4505                	li	a0,1
    4a1a:	00001097          	auipc	ra,0x1
    4a1e:	228080e7          	jalr	552(ra) # 5c42 <exit>
    exit(1);
    4a22:	4505                	li	a0,1
    4a24:	00001097          	auipc	ra,0x1
    4a28:	21e080e7          	jalr	542(ra) # 5c42 <exit>

0000000000004a2c <mem>:
{
    4a2c:	7139                	add	sp,sp,-64
    4a2e:	fc06                	sd	ra,56(sp)
    4a30:	f822                	sd	s0,48(sp)
    4a32:	f426                	sd	s1,40(sp)
    4a34:	f04a                	sd	s2,32(sp)
    4a36:	ec4e                	sd	s3,24(sp)
    4a38:	0080                	add	s0,sp,64
    4a3a:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4a3c:	00001097          	auipc	ra,0x1
    4a40:	1fe080e7          	jalr	510(ra) # 5c3a <fork>
    m1 = 0;
    4a44:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    4a46:	6909                	lui	s2,0x2
    4a48:	71190913          	add	s2,s2,1809 # 2711 <copyinstr3+0xcf>
  if((pid = fork()) == 0){
    4a4c:	c115                	beqz	a0,4a70 <mem+0x44>
    wait(&xstatus);
    4a4e:	fcc40513          	add	a0,s0,-52
    4a52:	00001097          	auipc	ra,0x1
    4a56:	1f8080e7          	jalr	504(ra) # 5c4a <wait>
    if(xstatus == -1){
    4a5a:	fcc42503          	lw	a0,-52(s0)
    4a5e:	57fd                	li	a5,-1
    4a60:	06f50363          	beq	a0,a5,4ac6 <mem+0x9a>
    exit(xstatus);
    4a64:	00001097          	auipc	ra,0x1
    4a68:	1de080e7          	jalr	478(ra) # 5c42 <exit>
      *(char**)m2 = m1;
    4a6c:	e104                	sd	s1,0(a0)
      m1 = m2;
    4a6e:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4a70:	854a                	mv	a0,s2
    4a72:	00001097          	auipc	ra,0x1
    4a76:	600080e7          	jalr	1536(ra) # 6072 <malloc>
    4a7a:	f96d                	bnez	a0,4a6c <mem+0x40>
    while(m1){
    4a7c:	c881                	beqz	s1,4a8c <mem+0x60>
      m2 = *(char**)m1;
    4a7e:	8526                	mv	a0,s1
    4a80:	6084                	ld	s1,0(s1)
      free(m1);
    4a82:	00001097          	auipc	ra,0x1
    4a86:	56e080e7          	jalr	1390(ra) # 5ff0 <free>
    while(m1){
    4a8a:	f8f5                	bnez	s1,4a7e <mem+0x52>
    m1 = malloc(1024*20);
    4a8c:	6515                	lui	a0,0x5
    4a8e:	00001097          	auipc	ra,0x1
    4a92:	5e4080e7          	jalr	1508(ra) # 6072 <malloc>
    if(m1 == 0){
    4a96:	c911                	beqz	a0,4aaa <mem+0x7e>
    free(m1);
    4a98:	00001097          	auipc	ra,0x1
    4a9c:	558080e7          	jalr	1368(ra) # 5ff0 <free>
    exit(0);
    4aa0:	4501                	li	a0,0
    4aa2:	00001097          	auipc	ra,0x1
    4aa6:	1a0080e7          	jalr	416(ra) # 5c42 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4aaa:	85ce                	mv	a1,s3
    4aac:	00003517          	auipc	a0,0x3
    4ab0:	34450513          	add	a0,a0,836 # 7df0 <malloc+0x1d7e>
    4ab4:	00001097          	auipc	ra,0x1
    4ab8:	506080e7          	jalr	1286(ra) # 5fba <printf>
      exit(1);
    4abc:	4505                	li	a0,1
    4abe:	00001097          	auipc	ra,0x1
    4ac2:	184080e7          	jalr	388(ra) # 5c42 <exit>
      exit(0);
    4ac6:	4501                	li	a0,0
    4ac8:	00001097          	auipc	ra,0x1
    4acc:	17a080e7          	jalr	378(ra) # 5c42 <exit>

0000000000004ad0 <sharedfd>:
{
    4ad0:	7159                	add	sp,sp,-112
    4ad2:	f486                	sd	ra,104(sp)
    4ad4:	f0a2                	sd	s0,96(sp)
    4ad6:	e0d2                	sd	s4,64(sp)
    4ad8:	1880                	add	s0,sp,112
    4ada:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4adc:	00003517          	auipc	a0,0x3
    4ae0:	33450513          	add	a0,a0,820 # 7e10 <malloc+0x1d9e>
    4ae4:	00001097          	auipc	ra,0x1
    4ae8:	1ae080e7          	jalr	430(ra) # 5c92 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4aec:	20200593          	li	a1,514
    4af0:	00003517          	auipc	a0,0x3
    4af4:	32050513          	add	a0,a0,800 # 7e10 <malloc+0x1d9e>
    4af8:	00001097          	auipc	ra,0x1
    4afc:	18a080e7          	jalr	394(ra) # 5c82 <open>
  if(fd < 0){
    4b00:	06054063          	bltz	a0,4b60 <sharedfd+0x90>
    4b04:	eca6                	sd	s1,88(sp)
    4b06:	e8ca                	sd	s2,80(sp)
    4b08:	e4ce                	sd	s3,72(sp)
    4b0a:	fc56                	sd	s5,56(sp)
    4b0c:	f85a                	sd	s6,48(sp)
    4b0e:	f45e                	sd	s7,40(sp)
    4b10:	892a                	mv	s2,a0
  pid = fork();
    4b12:	00001097          	auipc	ra,0x1
    4b16:	128080e7          	jalr	296(ra) # 5c3a <fork>
    4b1a:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4b1c:	07000593          	li	a1,112
    4b20:	e119                	bnez	a0,4b26 <sharedfd+0x56>
    4b22:	06300593          	li	a1,99
    4b26:	4629                	li	a2,10
    4b28:	fa040513          	add	a0,s0,-96
    4b2c:	00001097          	auipc	ra,0x1
    4b30:	f06080e7          	jalr	-250(ra) # 5a32 <memset>
    4b34:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4b38:	4629                	li	a2,10
    4b3a:	fa040593          	add	a1,s0,-96
    4b3e:	854a                	mv	a0,s2
    4b40:	00001097          	auipc	ra,0x1
    4b44:	122080e7          	jalr	290(ra) # 5c62 <write>
    4b48:	47a9                	li	a5,10
    4b4a:	02f51f63          	bne	a0,a5,4b88 <sharedfd+0xb8>
  for(i = 0; i < N; i++){
    4b4e:	34fd                	addw	s1,s1,-1
    4b50:	f4e5                	bnez	s1,4b38 <sharedfd+0x68>
  if(pid == 0) {
    4b52:	04099963          	bnez	s3,4ba4 <sharedfd+0xd4>
    exit(0);
    4b56:	4501                	li	a0,0
    4b58:	00001097          	auipc	ra,0x1
    4b5c:	0ea080e7          	jalr	234(ra) # 5c42 <exit>
    4b60:	eca6                	sd	s1,88(sp)
    4b62:	e8ca                	sd	s2,80(sp)
    4b64:	e4ce                	sd	s3,72(sp)
    4b66:	fc56                	sd	s5,56(sp)
    4b68:	f85a                	sd	s6,48(sp)
    4b6a:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    4b6c:	85d2                	mv	a1,s4
    4b6e:	00003517          	auipc	a0,0x3
    4b72:	2b250513          	add	a0,a0,690 # 7e20 <malloc+0x1dae>
    4b76:	00001097          	auipc	ra,0x1
    4b7a:	444080e7          	jalr	1092(ra) # 5fba <printf>
    exit(1);
    4b7e:	4505                	li	a0,1
    4b80:	00001097          	auipc	ra,0x1
    4b84:	0c2080e7          	jalr	194(ra) # 5c42 <exit>
      printf("%s: write sharedfd failed\n", s);
    4b88:	85d2                	mv	a1,s4
    4b8a:	00003517          	auipc	a0,0x3
    4b8e:	2be50513          	add	a0,a0,702 # 7e48 <malloc+0x1dd6>
    4b92:	00001097          	auipc	ra,0x1
    4b96:	428080e7          	jalr	1064(ra) # 5fba <printf>
      exit(1);
    4b9a:	4505                	li	a0,1
    4b9c:	00001097          	auipc	ra,0x1
    4ba0:	0a6080e7          	jalr	166(ra) # 5c42 <exit>
    wait(&xstatus);
    4ba4:	f9c40513          	add	a0,s0,-100
    4ba8:	00001097          	auipc	ra,0x1
    4bac:	0a2080e7          	jalr	162(ra) # 5c4a <wait>
    if(xstatus != 0)
    4bb0:	f9c42983          	lw	s3,-100(s0)
    4bb4:	00098763          	beqz	s3,4bc2 <sharedfd+0xf2>
      exit(xstatus);
    4bb8:	854e                	mv	a0,s3
    4bba:	00001097          	auipc	ra,0x1
    4bbe:	088080e7          	jalr	136(ra) # 5c42 <exit>
  close(fd);
    4bc2:	854a                	mv	a0,s2
    4bc4:	00001097          	auipc	ra,0x1
    4bc8:	0a6080e7          	jalr	166(ra) # 5c6a <close>
  fd = open("sharedfd", 0);
    4bcc:	4581                	li	a1,0
    4bce:	00003517          	auipc	a0,0x3
    4bd2:	24250513          	add	a0,a0,578 # 7e10 <malloc+0x1d9e>
    4bd6:	00001097          	auipc	ra,0x1
    4bda:	0ac080e7          	jalr	172(ra) # 5c82 <open>
    4bde:	8baa                	mv	s7,a0
  nc = np = 0;
    4be0:	8ace                	mv	s5,s3
  if(fd < 0){
    4be2:	02054563          	bltz	a0,4c0c <sharedfd+0x13c>
    4be6:	faa40913          	add	s2,s0,-86
      if(buf[i] == 'c')
    4bea:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4bee:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4bf2:	4629                	li	a2,10
    4bf4:	fa040593          	add	a1,s0,-96
    4bf8:	855e                	mv	a0,s7
    4bfa:	00001097          	auipc	ra,0x1
    4bfe:	060080e7          	jalr	96(ra) # 5c5a <read>
    4c02:	02a05f63          	blez	a0,4c40 <sharedfd+0x170>
    4c06:	fa040793          	add	a5,s0,-96
    4c0a:	a01d                	j	4c30 <sharedfd+0x160>
    printf("%s: cannot open sharedfd for reading\n", s);
    4c0c:	85d2                	mv	a1,s4
    4c0e:	00003517          	auipc	a0,0x3
    4c12:	25a50513          	add	a0,a0,602 # 7e68 <malloc+0x1df6>
    4c16:	00001097          	auipc	ra,0x1
    4c1a:	3a4080e7          	jalr	932(ra) # 5fba <printf>
    exit(1);
    4c1e:	4505                	li	a0,1
    4c20:	00001097          	auipc	ra,0x1
    4c24:	022080e7          	jalr	34(ra) # 5c42 <exit>
        nc++;
    4c28:	2985                	addw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4c2a:	0785                	add	a5,a5,1
    4c2c:	fd2783e3          	beq	a5,s2,4bf2 <sharedfd+0x122>
      if(buf[i] == 'c')
    4c30:	0007c703          	lbu	a4,0(a5)
    4c34:	fe970ae3          	beq	a4,s1,4c28 <sharedfd+0x158>
      if(buf[i] == 'p')
    4c38:	ff6719e3          	bne	a4,s6,4c2a <sharedfd+0x15a>
        np++;
    4c3c:	2a85                	addw	s5,s5,1
    4c3e:	b7f5                	j	4c2a <sharedfd+0x15a>
  close(fd);
    4c40:	855e                	mv	a0,s7
    4c42:	00001097          	auipc	ra,0x1
    4c46:	028080e7          	jalr	40(ra) # 5c6a <close>
  unlink("sharedfd");
    4c4a:	00003517          	auipc	a0,0x3
    4c4e:	1c650513          	add	a0,a0,454 # 7e10 <malloc+0x1d9e>
    4c52:	00001097          	auipc	ra,0x1
    4c56:	040080e7          	jalr	64(ra) # 5c92 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4c5a:	6789                	lui	a5,0x2
    4c5c:	71078793          	add	a5,a5,1808 # 2710 <copyinstr3+0xce>
    4c60:	00f99763          	bne	s3,a5,4c6e <sharedfd+0x19e>
    4c64:	6789                	lui	a5,0x2
    4c66:	71078793          	add	a5,a5,1808 # 2710 <copyinstr3+0xce>
    4c6a:	02fa8063          	beq	s5,a5,4c8a <sharedfd+0x1ba>
    printf("%s: nc/np test fails\n", s);
    4c6e:	85d2                	mv	a1,s4
    4c70:	00003517          	auipc	a0,0x3
    4c74:	22050513          	add	a0,a0,544 # 7e90 <malloc+0x1e1e>
    4c78:	00001097          	auipc	ra,0x1
    4c7c:	342080e7          	jalr	834(ra) # 5fba <printf>
    exit(1);
    4c80:	4505                	li	a0,1
    4c82:	00001097          	auipc	ra,0x1
    4c86:	fc0080e7          	jalr	-64(ra) # 5c42 <exit>
    exit(0);
    4c8a:	4501                	li	a0,0
    4c8c:	00001097          	auipc	ra,0x1
    4c90:	fb6080e7          	jalr	-74(ra) # 5c42 <exit>

0000000000004c94 <fourfiles>:
{
    4c94:	7135                	add	sp,sp,-160
    4c96:	ed06                	sd	ra,152(sp)
    4c98:	e922                	sd	s0,144(sp)
    4c9a:	e526                	sd	s1,136(sp)
    4c9c:	e14a                	sd	s2,128(sp)
    4c9e:	fcce                	sd	s3,120(sp)
    4ca0:	f8d2                	sd	s4,112(sp)
    4ca2:	f4d6                	sd	s5,104(sp)
    4ca4:	f0da                	sd	s6,96(sp)
    4ca6:	ecde                	sd	s7,88(sp)
    4ca8:	e8e2                	sd	s8,80(sp)
    4caa:	e4e6                	sd	s9,72(sp)
    4cac:	e0ea                	sd	s10,64(sp)
    4cae:	fc6e                	sd	s11,56(sp)
    4cb0:	1100                	add	s0,sp,160
    4cb2:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4cb4:	00003797          	auipc	a5,0x3
    4cb8:	1f478793          	add	a5,a5,500 # 7ea8 <malloc+0x1e36>
    4cbc:	f6f43823          	sd	a5,-144(s0)
    4cc0:	00003797          	auipc	a5,0x3
    4cc4:	1f078793          	add	a5,a5,496 # 7eb0 <malloc+0x1e3e>
    4cc8:	f6f43c23          	sd	a5,-136(s0)
    4ccc:	00003797          	auipc	a5,0x3
    4cd0:	1ec78793          	add	a5,a5,492 # 7eb8 <malloc+0x1e46>
    4cd4:	f8f43023          	sd	a5,-128(s0)
    4cd8:	00003797          	auipc	a5,0x3
    4cdc:	1e878793          	add	a5,a5,488 # 7ec0 <malloc+0x1e4e>
    4ce0:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4ce4:	f7040b93          	add	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4ce8:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4cea:	4481                	li	s1,0
    4cec:	4a11                	li	s4,4
    fname = names[pi];
    4cee:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4cf2:	854e                	mv	a0,s3
    4cf4:	00001097          	auipc	ra,0x1
    4cf8:	f9e080e7          	jalr	-98(ra) # 5c92 <unlink>
    pid = fork();
    4cfc:	00001097          	auipc	ra,0x1
    4d00:	f3e080e7          	jalr	-194(ra) # 5c3a <fork>
    if(pid < 0){
    4d04:	04054063          	bltz	a0,4d44 <fourfiles+0xb0>
    if(pid == 0){
    4d08:	cd21                	beqz	a0,4d60 <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    4d0a:	2485                	addw	s1,s1,1
    4d0c:	0921                	add	s2,s2,8
    4d0e:	ff4490e3          	bne	s1,s4,4cee <fourfiles+0x5a>
    4d12:	4491                	li	s1,4
    wait(&xstatus);
    4d14:	f6c40513          	add	a0,s0,-148
    4d18:	00001097          	auipc	ra,0x1
    4d1c:	f32080e7          	jalr	-206(ra) # 5c4a <wait>
    if(xstatus != 0)
    4d20:	f6c42a83          	lw	s5,-148(s0)
    4d24:	0c0a9863          	bnez	s5,4df4 <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    4d28:	34fd                	addw	s1,s1,-1
    4d2a:	f4ed                	bnez	s1,4d14 <fourfiles+0x80>
    4d2c:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4d30:	00009a17          	auipc	s4,0x9
    4d34:	308a0a13          	add	s4,s4,776 # e038 <buf>
    if(total != N*SZ){
    4d38:	6d05                	lui	s10,0x1
    4d3a:	770d0d13          	add	s10,s10,1904 # 1770 <exectest+0x1e>
  for(i = 0; i < NCHILD; i++){
    4d3e:	03400d93          	li	s11,52
    4d42:	a22d                	j	4e6c <fourfiles+0x1d8>
      printf("fork failed\n", s);
    4d44:	85e6                	mv	a1,s9
    4d46:	00002517          	auipc	a0,0x2
    4d4a:	10250513          	add	a0,a0,258 # 6e48 <malloc+0xdd6>
    4d4e:	00001097          	auipc	ra,0x1
    4d52:	26c080e7          	jalr	620(ra) # 5fba <printf>
      exit(1);
    4d56:	4505                	li	a0,1
    4d58:	00001097          	auipc	ra,0x1
    4d5c:	eea080e7          	jalr	-278(ra) # 5c42 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4d60:	20200593          	li	a1,514
    4d64:	854e                	mv	a0,s3
    4d66:	00001097          	auipc	ra,0x1
    4d6a:	f1c080e7          	jalr	-228(ra) # 5c82 <open>
    4d6e:	892a                	mv	s2,a0
      if(fd < 0){
    4d70:	04054763          	bltz	a0,4dbe <fourfiles+0x12a>
      memset(buf, '0'+pi, SZ);
    4d74:	1f400613          	li	a2,500
    4d78:	0304859b          	addw	a1,s1,48
    4d7c:	00009517          	auipc	a0,0x9
    4d80:	2bc50513          	add	a0,a0,700 # e038 <buf>
    4d84:	00001097          	auipc	ra,0x1
    4d88:	cae080e7          	jalr	-850(ra) # 5a32 <memset>
    4d8c:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4d8e:	00009997          	auipc	s3,0x9
    4d92:	2aa98993          	add	s3,s3,682 # e038 <buf>
    4d96:	1f400613          	li	a2,500
    4d9a:	85ce                	mv	a1,s3
    4d9c:	854a                	mv	a0,s2
    4d9e:	00001097          	auipc	ra,0x1
    4da2:	ec4080e7          	jalr	-316(ra) # 5c62 <write>
    4da6:	85aa                	mv	a1,a0
    4da8:	1f400793          	li	a5,500
    4dac:	02f51763          	bne	a0,a5,4dda <fourfiles+0x146>
      for(i = 0; i < N; i++){
    4db0:	34fd                	addw	s1,s1,-1
    4db2:	f0f5                	bnez	s1,4d96 <fourfiles+0x102>
      exit(0);
    4db4:	4501                	li	a0,0
    4db6:	00001097          	auipc	ra,0x1
    4dba:	e8c080e7          	jalr	-372(ra) # 5c42 <exit>
        printf("create failed\n", s);
    4dbe:	85e6                	mv	a1,s9
    4dc0:	00003517          	auipc	a0,0x3
    4dc4:	10850513          	add	a0,a0,264 # 7ec8 <malloc+0x1e56>
    4dc8:	00001097          	auipc	ra,0x1
    4dcc:	1f2080e7          	jalr	498(ra) # 5fba <printf>
        exit(1);
    4dd0:	4505                	li	a0,1
    4dd2:	00001097          	auipc	ra,0x1
    4dd6:	e70080e7          	jalr	-400(ra) # 5c42 <exit>
          printf("write failed %d\n", n);
    4dda:	00003517          	auipc	a0,0x3
    4dde:	0fe50513          	add	a0,a0,254 # 7ed8 <malloc+0x1e66>
    4de2:	00001097          	auipc	ra,0x1
    4de6:	1d8080e7          	jalr	472(ra) # 5fba <printf>
          exit(1);
    4dea:	4505                	li	a0,1
    4dec:	00001097          	auipc	ra,0x1
    4df0:	e56080e7          	jalr	-426(ra) # 5c42 <exit>
      exit(xstatus);
    4df4:	8556                	mv	a0,s5
    4df6:	00001097          	auipc	ra,0x1
    4dfa:	e4c080e7          	jalr	-436(ra) # 5c42 <exit>
          printf("wrong char\n", s);
    4dfe:	85e6                	mv	a1,s9
    4e00:	00003517          	auipc	a0,0x3
    4e04:	0f050513          	add	a0,a0,240 # 7ef0 <malloc+0x1e7e>
    4e08:	00001097          	auipc	ra,0x1
    4e0c:	1b2080e7          	jalr	434(ra) # 5fba <printf>
          exit(1);
    4e10:	4505                	li	a0,1
    4e12:	00001097          	auipc	ra,0x1
    4e16:	e30080e7          	jalr	-464(ra) # 5c42 <exit>
      total += n;
    4e1a:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e1e:	660d                	lui	a2,0x3
    4e20:	85d2                	mv	a1,s4
    4e22:	854e                	mv	a0,s3
    4e24:	00001097          	auipc	ra,0x1
    4e28:	e36080e7          	jalr	-458(ra) # 5c5a <read>
    4e2c:	02a05063          	blez	a0,4e4c <fourfiles+0x1b8>
    4e30:	00009797          	auipc	a5,0x9
    4e34:	20878793          	add	a5,a5,520 # e038 <buf>
    4e38:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    4e3c:	0007c703          	lbu	a4,0(a5)
    4e40:	fa971fe3          	bne	a4,s1,4dfe <fourfiles+0x16a>
      for(j = 0; j < n; j++){
    4e44:	0785                	add	a5,a5,1
    4e46:	fed79be3          	bne	a5,a3,4e3c <fourfiles+0x1a8>
    4e4a:	bfc1                	j	4e1a <fourfiles+0x186>
    close(fd);
    4e4c:	854e                	mv	a0,s3
    4e4e:	00001097          	auipc	ra,0x1
    4e52:	e1c080e7          	jalr	-484(ra) # 5c6a <close>
    if(total != N*SZ){
    4e56:	03a91863          	bne	s2,s10,4e86 <fourfiles+0x1f2>
    unlink(fname);
    4e5a:	8562                	mv	a0,s8
    4e5c:	00001097          	auipc	ra,0x1
    4e60:	e36080e7          	jalr	-458(ra) # 5c92 <unlink>
  for(i = 0; i < NCHILD; i++){
    4e64:	0ba1                	add	s7,s7,8
    4e66:	2b05                	addw	s6,s6,1
    4e68:	03bb0d63          	beq	s6,s11,4ea2 <fourfiles+0x20e>
    fname = names[i];
    4e6c:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4e70:	4581                	li	a1,0
    4e72:	8562                	mv	a0,s8
    4e74:	00001097          	auipc	ra,0x1
    4e78:	e0e080e7          	jalr	-498(ra) # 5c82 <open>
    4e7c:	89aa                	mv	s3,a0
    total = 0;
    4e7e:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    4e80:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e84:	bf69                	j	4e1e <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    4e86:	85ca                	mv	a1,s2
    4e88:	00003517          	auipc	a0,0x3
    4e8c:	07850513          	add	a0,a0,120 # 7f00 <malloc+0x1e8e>
    4e90:	00001097          	auipc	ra,0x1
    4e94:	12a080e7          	jalr	298(ra) # 5fba <printf>
      exit(1);
    4e98:	4505                	li	a0,1
    4e9a:	00001097          	auipc	ra,0x1
    4e9e:	da8080e7          	jalr	-600(ra) # 5c42 <exit>
}
    4ea2:	60ea                	ld	ra,152(sp)
    4ea4:	644a                	ld	s0,144(sp)
    4ea6:	64aa                	ld	s1,136(sp)
    4ea8:	690a                	ld	s2,128(sp)
    4eaa:	79e6                	ld	s3,120(sp)
    4eac:	7a46                	ld	s4,112(sp)
    4eae:	7aa6                	ld	s5,104(sp)
    4eb0:	7b06                	ld	s6,96(sp)
    4eb2:	6be6                	ld	s7,88(sp)
    4eb4:	6c46                	ld	s8,80(sp)
    4eb6:	6ca6                	ld	s9,72(sp)
    4eb8:	6d06                	ld	s10,64(sp)
    4eba:	7de2                	ld	s11,56(sp)
    4ebc:	610d                	add	sp,sp,160
    4ebe:	8082                	ret

0000000000004ec0 <concreate>:
{
    4ec0:	7135                	add	sp,sp,-160
    4ec2:	ed06                	sd	ra,152(sp)
    4ec4:	e922                	sd	s0,144(sp)
    4ec6:	e526                	sd	s1,136(sp)
    4ec8:	e14a                	sd	s2,128(sp)
    4eca:	fcce                	sd	s3,120(sp)
    4ecc:	f8d2                	sd	s4,112(sp)
    4ece:	f4d6                	sd	s5,104(sp)
    4ed0:	f0da                	sd	s6,96(sp)
    4ed2:	ecde                	sd	s7,88(sp)
    4ed4:	1100                	add	s0,sp,160
    4ed6:	89aa                	mv	s3,a0
  file[0] = 'C';
    4ed8:	04300793          	li	a5,67
    4edc:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4ee0:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4ee4:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4ee6:	4b0d                	li	s6,3
    4ee8:	4a85                	li	s5,1
      link("C0", file);
    4eea:	00003b97          	auipc	s7,0x3
    4eee:	02eb8b93          	add	s7,s7,46 # 7f18 <malloc+0x1ea6>
  for(i = 0; i < N; i++){
    4ef2:	02800a13          	li	s4,40
    4ef6:	acc9                	j	51c8 <concreate+0x308>
      link("C0", file);
    4ef8:	fa840593          	add	a1,s0,-88
    4efc:	855e                	mv	a0,s7
    4efe:	00001097          	auipc	ra,0x1
    4f02:	da4080e7          	jalr	-604(ra) # 5ca2 <link>
    if(pid == 0) {
    4f06:	a465                	j	51ae <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4f08:	4795                	li	a5,5
    4f0a:	02f9693b          	remw	s2,s2,a5
    4f0e:	4785                	li	a5,1
    4f10:	02f90b63          	beq	s2,a5,4f46 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4f14:	20200593          	li	a1,514
    4f18:	fa840513          	add	a0,s0,-88
    4f1c:	00001097          	auipc	ra,0x1
    4f20:	d66080e7          	jalr	-666(ra) # 5c82 <open>
      if(fd < 0){
    4f24:	26055c63          	bgez	a0,519c <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4f28:	fa840593          	add	a1,s0,-88
    4f2c:	00003517          	auipc	a0,0x3
    4f30:	ff450513          	add	a0,a0,-12 # 7f20 <malloc+0x1eae>
    4f34:	00001097          	auipc	ra,0x1
    4f38:	086080e7          	jalr	134(ra) # 5fba <printf>
        exit(1);
    4f3c:	4505                	li	a0,1
    4f3e:	00001097          	auipc	ra,0x1
    4f42:	d04080e7          	jalr	-764(ra) # 5c42 <exit>
      link("C0", file);
    4f46:	fa840593          	add	a1,s0,-88
    4f4a:	00003517          	auipc	a0,0x3
    4f4e:	fce50513          	add	a0,a0,-50 # 7f18 <malloc+0x1ea6>
    4f52:	00001097          	auipc	ra,0x1
    4f56:	d50080e7          	jalr	-688(ra) # 5ca2 <link>
      exit(0);
    4f5a:	4501                	li	a0,0
    4f5c:	00001097          	auipc	ra,0x1
    4f60:	ce6080e7          	jalr	-794(ra) # 5c42 <exit>
        exit(1);
    4f64:	4505                	li	a0,1
    4f66:	00001097          	auipc	ra,0x1
    4f6a:	cdc080e7          	jalr	-804(ra) # 5c42 <exit>
  memset(fa, 0, sizeof(fa));
    4f6e:	02800613          	li	a2,40
    4f72:	4581                	li	a1,0
    4f74:	f8040513          	add	a0,s0,-128
    4f78:	00001097          	auipc	ra,0x1
    4f7c:	aba080e7          	jalr	-1350(ra) # 5a32 <memset>
  fd = open(".", 0);
    4f80:	4581                	li	a1,0
    4f82:	00002517          	auipc	a0,0x2
    4f86:	91e50513          	add	a0,a0,-1762 # 68a0 <malloc+0x82e>
    4f8a:	00001097          	auipc	ra,0x1
    4f8e:	cf8080e7          	jalr	-776(ra) # 5c82 <open>
    4f92:	892a                	mv	s2,a0
  n = 0;
    4f94:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f96:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4f9a:	02700b13          	li	s6,39
      fa[i] = 1;
    4f9e:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4fa0:	4641                	li	a2,16
    4fa2:	f7040593          	add	a1,s0,-144
    4fa6:	854a                	mv	a0,s2
    4fa8:	00001097          	auipc	ra,0x1
    4fac:	cb2080e7          	jalr	-846(ra) # 5c5a <read>
    4fb0:	08a05263          	blez	a0,5034 <concreate+0x174>
    if(de.inum == 0)
    4fb4:	f7045783          	lhu	a5,-144(s0)
    4fb8:	d7e5                	beqz	a5,4fa0 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4fba:	f7244783          	lbu	a5,-142(s0)
    4fbe:	ff4791e3          	bne	a5,s4,4fa0 <concreate+0xe0>
    4fc2:	f7444783          	lbu	a5,-140(s0)
    4fc6:	ffe9                	bnez	a5,4fa0 <concreate+0xe0>
      i = de.name[1] - '0';
    4fc8:	f7344783          	lbu	a5,-141(s0)
    4fcc:	fd07879b          	addw	a5,a5,-48
    4fd0:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4fd4:	02eb6063          	bltu	s6,a4,4ff4 <concreate+0x134>
      if(fa[i]){
    4fd8:	fb070793          	add	a5,a4,-80 # fb0 <linktest+0xba>
    4fdc:	97a2                	add	a5,a5,s0
    4fde:	fd07c783          	lbu	a5,-48(a5)
    4fe2:	eb8d                	bnez	a5,5014 <concreate+0x154>
      fa[i] = 1;
    4fe4:	fb070793          	add	a5,a4,-80
    4fe8:	00878733          	add	a4,a5,s0
    4fec:	fd770823          	sb	s7,-48(a4)
      n++;
    4ff0:	2a85                	addw	s5,s5,1
    4ff2:	b77d                	j	4fa0 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4ff4:	f7240613          	add	a2,s0,-142
    4ff8:	85ce                	mv	a1,s3
    4ffa:	00003517          	auipc	a0,0x3
    4ffe:	f4650513          	add	a0,a0,-186 # 7f40 <malloc+0x1ece>
    5002:	00001097          	auipc	ra,0x1
    5006:	fb8080e7          	jalr	-72(ra) # 5fba <printf>
        exit(1);
    500a:	4505                	li	a0,1
    500c:	00001097          	auipc	ra,0x1
    5010:	c36080e7          	jalr	-970(ra) # 5c42 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    5014:	f7240613          	add	a2,s0,-142
    5018:	85ce                	mv	a1,s3
    501a:	00003517          	auipc	a0,0x3
    501e:	f4650513          	add	a0,a0,-186 # 7f60 <malloc+0x1eee>
    5022:	00001097          	auipc	ra,0x1
    5026:	f98080e7          	jalr	-104(ra) # 5fba <printf>
        exit(1);
    502a:	4505                	li	a0,1
    502c:	00001097          	auipc	ra,0x1
    5030:	c16080e7          	jalr	-1002(ra) # 5c42 <exit>
  close(fd);
    5034:	854a                	mv	a0,s2
    5036:	00001097          	auipc	ra,0x1
    503a:	c34080e7          	jalr	-972(ra) # 5c6a <close>
  if(n != N){
    503e:	02800793          	li	a5,40
    5042:	00fa9763          	bne	s5,a5,5050 <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    5046:	4a8d                	li	s5,3
    5048:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    504a:	02800a13          	li	s4,40
    504e:	a8c9                	j	5120 <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    5050:	85ce                	mv	a1,s3
    5052:	00003517          	auipc	a0,0x3
    5056:	f3650513          	add	a0,a0,-202 # 7f88 <malloc+0x1f16>
    505a:	00001097          	auipc	ra,0x1
    505e:	f60080e7          	jalr	-160(ra) # 5fba <printf>
    exit(1);
    5062:	4505                	li	a0,1
    5064:	00001097          	auipc	ra,0x1
    5068:	bde080e7          	jalr	-1058(ra) # 5c42 <exit>
      printf("%s: fork failed\n", s);
    506c:	85ce                	mv	a1,s3
    506e:	00002517          	auipc	a0,0x2
    5072:	9d250513          	add	a0,a0,-1582 # 6a40 <malloc+0x9ce>
    5076:	00001097          	auipc	ra,0x1
    507a:	f44080e7          	jalr	-188(ra) # 5fba <printf>
      exit(1);
    507e:	4505                	li	a0,1
    5080:	00001097          	auipc	ra,0x1
    5084:	bc2080e7          	jalr	-1086(ra) # 5c42 <exit>
      close(open(file, 0));
    5088:	4581                	li	a1,0
    508a:	fa840513          	add	a0,s0,-88
    508e:	00001097          	auipc	ra,0x1
    5092:	bf4080e7          	jalr	-1036(ra) # 5c82 <open>
    5096:	00001097          	auipc	ra,0x1
    509a:	bd4080e7          	jalr	-1068(ra) # 5c6a <close>
      close(open(file, 0));
    509e:	4581                	li	a1,0
    50a0:	fa840513          	add	a0,s0,-88
    50a4:	00001097          	auipc	ra,0x1
    50a8:	bde080e7          	jalr	-1058(ra) # 5c82 <open>
    50ac:	00001097          	auipc	ra,0x1
    50b0:	bbe080e7          	jalr	-1090(ra) # 5c6a <close>
      close(open(file, 0));
    50b4:	4581                	li	a1,0
    50b6:	fa840513          	add	a0,s0,-88
    50ba:	00001097          	auipc	ra,0x1
    50be:	bc8080e7          	jalr	-1080(ra) # 5c82 <open>
    50c2:	00001097          	auipc	ra,0x1
    50c6:	ba8080e7          	jalr	-1112(ra) # 5c6a <close>
      close(open(file, 0));
    50ca:	4581                	li	a1,0
    50cc:	fa840513          	add	a0,s0,-88
    50d0:	00001097          	auipc	ra,0x1
    50d4:	bb2080e7          	jalr	-1102(ra) # 5c82 <open>
    50d8:	00001097          	auipc	ra,0x1
    50dc:	b92080e7          	jalr	-1134(ra) # 5c6a <close>
      close(open(file, 0));
    50e0:	4581                	li	a1,0
    50e2:	fa840513          	add	a0,s0,-88
    50e6:	00001097          	auipc	ra,0x1
    50ea:	b9c080e7          	jalr	-1124(ra) # 5c82 <open>
    50ee:	00001097          	auipc	ra,0x1
    50f2:	b7c080e7          	jalr	-1156(ra) # 5c6a <close>
      close(open(file, 0));
    50f6:	4581                	li	a1,0
    50f8:	fa840513          	add	a0,s0,-88
    50fc:	00001097          	auipc	ra,0x1
    5100:	b86080e7          	jalr	-1146(ra) # 5c82 <open>
    5104:	00001097          	auipc	ra,0x1
    5108:	b66080e7          	jalr	-1178(ra) # 5c6a <close>
    if(pid == 0)
    510c:	08090363          	beqz	s2,5192 <concreate+0x2d2>
      wait(0);
    5110:	4501                	li	a0,0
    5112:	00001097          	auipc	ra,0x1
    5116:	b38080e7          	jalr	-1224(ra) # 5c4a <wait>
  for(i = 0; i < N; i++){
    511a:	2485                	addw	s1,s1,1
    511c:	0f448563          	beq	s1,s4,5206 <concreate+0x346>
    file[1] = '0' + i;
    5120:	0304879b          	addw	a5,s1,48
    5124:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    5128:	00001097          	auipc	ra,0x1
    512c:	b12080e7          	jalr	-1262(ra) # 5c3a <fork>
    5130:	892a                	mv	s2,a0
    if(pid < 0){
    5132:	f2054de3          	bltz	a0,506c <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    5136:	0354e73b          	remw	a4,s1,s5
    513a:	00a767b3          	or	a5,a4,a0
    513e:	2781                	sext.w	a5,a5
    5140:	d7a1                	beqz	a5,5088 <concreate+0x1c8>
    5142:	01671363          	bne	a4,s6,5148 <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    5146:	f129                	bnez	a0,5088 <concreate+0x1c8>
      unlink(file);
    5148:	fa840513          	add	a0,s0,-88
    514c:	00001097          	auipc	ra,0x1
    5150:	b46080e7          	jalr	-1210(ra) # 5c92 <unlink>
      unlink(file);
    5154:	fa840513          	add	a0,s0,-88
    5158:	00001097          	auipc	ra,0x1
    515c:	b3a080e7          	jalr	-1222(ra) # 5c92 <unlink>
      unlink(file);
    5160:	fa840513          	add	a0,s0,-88
    5164:	00001097          	auipc	ra,0x1
    5168:	b2e080e7          	jalr	-1234(ra) # 5c92 <unlink>
      unlink(file);
    516c:	fa840513          	add	a0,s0,-88
    5170:	00001097          	auipc	ra,0x1
    5174:	b22080e7          	jalr	-1246(ra) # 5c92 <unlink>
      unlink(file);
    5178:	fa840513          	add	a0,s0,-88
    517c:	00001097          	auipc	ra,0x1
    5180:	b16080e7          	jalr	-1258(ra) # 5c92 <unlink>
      unlink(file);
    5184:	fa840513          	add	a0,s0,-88
    5188:	00001097          	auipc	ra,0x1
    518c:	b0a080e7          	jalr	-1270(ra) # 5c92 <unlink>
    5190:	bfb5                	j	510c <concreate+0x24c>
      exit(0);
    5192:	4501                	li	a0,0
    5194:	00001097          	auipc	ra,0x1
    5198:	aae080e7          	jalr	-1362(ra) # 5c42 <exit>
      close(fd);
    519c:	00001097          	auipc	ra,0x1
    51a0:	ace080e7          	jalr	-1330(ra) # 5c6a <close>
    if(pid == 0) {
    51a4:	bb5d                	j	4f5a <concreate+0x9a>
      close(fd);
    51a6:	00001097          	auipc	ra,0x1
    51aa:	ac4080e7          	jalr	-1340(ra) # 5c6a <close>
      wait(&xstatus);
    51ae:	f6c40513          	add	a0,s0,-148
    51b2:	00001097          	auipc	ra,0x1
    51b6:	a98080e7          	jalr	-1384(ra) # 5c4a <wait>
      if(xstatus != 0)
    51ba:	f6c42483          	lw	s1,-148(s0)
    51be:	da0493e3          	bnez	s1,4f64 <concreate+0xa4>
  for(i = 0; i < N; i++){
    51c2:	2905                	addw	s2,s2,1
    51c4:	db4905e3          	beq	s2,s4,4f6e <concreate+0xae>
    file[1] = '0' + i;
    51c8:	0309079b          	addw	a5,s2,48
    51cc:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    51d0:	fa840513          	add	a0,s0,-88
    51d4:	00001097          	auipc	ra,0x1
    51d8:	abe080e7          	jalr	-1346(ra) # 5c92 <unlink>
    pid = fork();
    51dc:	00001097          	auipc	ra,0x1
    51e0:	a5e080e7          	jalr	-1442(ra) # 5c3a <fork>
    if(pid && (i % 3) == 1){
    51e4:	d20502e3          	beqz	a0,4f08 <concreate+0x48>
    51e8:	036967bb          	remw	a5,s2,s6
    51ec:	d15786e3          	beq	a5,s5,4ef8 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    51f0:	20200593          	li	a1,514
    51f4:	fa840513          	add	a0,s0,-88
    51f8:	00001097          	auipc	ra,0x1
    51fc:	a8a080e7          	jalr	-1398(ra) # 5c82 <open>
      if(fd < 0){
    5200:	fa0553e3          	bgez	a0,51a6 <concreate+0x2e6>
    5204:	b315                	j	4f28 <concreate+0x68>
}
    5206:	60ea                	ld	ra,152(sp)
    5208:	644a                	ld	s0,144(sp)
    520a:	64aa                	ld	s1,136(sp)
    520c:	690a                	ld	s2,128(sp)
    520e:	79e6                	ld	s3,120(sp)
    5210:	7a46                	ld	s4,112(sp)
    5212:	7aa6                	ld	s5,104(sp)
    5214:	7b06                	ld	s6,96(sp)
    5216:	6be6                	ld	s7,88(sp)
    5218:	610d                	add	sp,sp,160
    521a:	8082                	ret

000000000000521c <bigfile>:
{
    521c:	7139                	add	sp,sp,-64
    521e:	fc06                	sd	ra,56(sp)
    5220:	f822                	sd	s0,48(sp)
    5222:	f426                	sd	s1,40(sp)
    5224:	f04a                	sd	s2,32(sp)
    5226:	ec4e                	sd	s3,24(sp)
    5228:	e852                	sd	s4,16(sp)
    522a:	e456                	sd	s5,8(sp)
    522c:	0080                	add	s0,sp,64
    522e:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    5230:	00003517          	auipc	a0,0x3
    5234:	d9050513          	add	a0,a0,-624 # 7fc0 <malloc+0x1f4e>
    5238:	00001097          	auipc	ra,0x1
    523c:	a5a080e7          	jalr	-1446(ra) # 5c92 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    5240:	20200593          	li	a1,514
    5244:	00003517          	auipc	a0,0x3
    5248:	d7c50513          	add	a0,a0,-644 # 7fc0 <malloc+0x1f4e>
    524c:	00001097          	auipc	ra,0x1
    5250:	a36080e7          	jalr	-1482(ra) # 5c82 <open>
    5254:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    5256:	4481                	li	s1,0
    memset(buf, i, SZ);
    5258:	00009917          	auipc	s2,0x9
    525c:	de090913          	add	s2,s2,-544 # e038 <buf>
  for(i = 0; i < N; i++){
    5260:	4a51                	li	s4,20
  if(fd < 0){
    5262:	0a054063          	bltz	a0,5302 <bigfile+0xe6>
    memset(buf, i, SZ);
    5266:	25800613          	li	a2,600
    526a:	85a6                	mv	a1,s1
    526c:	854a                	mv	a0,s2
    526e:	00000097          	auipc	ra,0x0
    5272:	7c4080e7          	jalr	1988(ra) # 5a32 <memset>
    if(write(fd, buf, SZ) != SZ){
    5276:	25800613          	li	a2,600
    527a:	85ca                	mv	a1,s2
    527c:	854e                	mv	a0,s3
    527e:	00001097          	auipc	ra,0x1
    5282:	9e4080e7          	jalr	-1564(ra) # 5c62 <write>
    5286:	25800793          	li	a5,600
    528a:	08f51a63          	bne	a0,a5,531e <bigfile+0x102>
  for(i = 0; i < N; i++){
    528e:	2485                	addw	s1,s1,1
    5290:	fd449be3          	bne	s1,s4,5266 <bigfile+0x4a>
  close(fd);
    5294:	854e                	mv	a0,s3
    5296:	00001097          	auipc	ra,0x1
    529a:	9d4080e7          	jalr	-1580(ra) # 5c6a <close>
  fd = open("bigfile.dat", 0);
    529e:	4581                	li	a1,0
    52a0:	00003517          	auipc	a0,0x3
    52a4:	d2050513          	add	a0,a0,-736 # 7fc0 <malloc+0x1f4e>
    52a8:	00001097          	auipc	ra,0x1
    52ac:	9da080e7          	jalr	-1574(ra) # 5c82 <open>
    52b0:	8a2a                	mv	s4,a0
  total = 0;
    52b2:	4981                	li	s3,0
  for(i = 0; ; i++){
    52b4:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    52b6:	00009917          	auipc	s2,0x9
    52ba:	d8290913          	add	s2,s2,-638 # e038 <buf>
  if(fd < 0){
    52be:	06054e63          	bltz	a0,533a <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    52c2:	12c00613          	li	a2,300
    52c6:	85ca                	mv	a1,s2
    52c8:	8552                	mv	a0,s4
    52ca:	00001097          	auipc	ra,0x1
    52ce:	990080e7          	jalr	-1648(ra) # 5c5a <read>
    if(cc < 0){
    52d2:	08054263          	bltz	a0,5356 <bigfile+0x13a>
    if(cc == 0)
    52d6:	c971                	beqz	a0,53aa <bigfile+0x18e>
    if(cc != SZ/2){
    52d8:	12c00793          	li	a5,300
    52dc:	08f51b63          	bne	a0,a5,5372 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    52e0:	01f4d79b          	srlw	a5,s1,0x1f
    52e4:	9fa5                	addw	a5,a5,s1
    52e6:	4017d79b          	sraw	a5,a5,0x1
    52ea:	00094703          	lbu	a4,0(s2)
    52ee:	0af71063          	bne	a4,a5,538e <bigfile+0x172>
    52f2:	12b94703          	lbu	a4,299(s2)
    52f6:	08f71c63          	bne	a4,a5,538e <bigfile+0x172>
    total += cc;
    52fa:	12c9899b          	addw	s3,s3,300
  for(i = 0; ; i++){
    52fe:	2485                	addw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    5300:	b7c9                	j	52c2 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    5302:	85d6                	mv	a1,s5
    5304:	00003517          	auipc	a0,0x3
    5308:	ccc50513          	add	a0,a0,-820 # 7fd0 <malloc+0x1f5e>
    530c:	00001097          	auipc	ra,0x1
    5310:	cae080e7          	jalr	-850(ra) # 5fba <printf>
    exit(1);
    5314:	4505                	li	a0,1
    5316:	00001097          	auipc	ra,0x1
    531a:	92c080e7          	jalr	-1748(ra) # 5c42 <exit>
      printf("%s: write bigfile failed\n", s);
    531e:	85d6                	mv	a1,s5
    5320:	00003517          	auipc	a0,0x3
    5324:	cd050513          	add	a0,a0,-816 # 7ff0 <malloc+0x1f7e>
    5328:	00001097          	auipc	ra,0x1
    532c:	c92080e7          	jalr	-878(ra) # 5fba <printf>
      exit(1);
    5330:	4505                	li	a0,1
    5332:	00001097          	auipc	ra,0x1
    5336:	910080e7          	jalr	-1776(ra) # 5c42 <exit>
    printf("%s: cannot open bigfile\n", s);
    533a:	85d6                	mv	a1,s5
    533c:	00003517          	auipc	a0,0x3
    5340:	cd450513          	add	a0,a0,-812 # 8010 <malloc+0x1f9e>
    5344:	00001097          	auipc	ra,0x1
    5348:	c76080e7          	jalr	-906(ra) # 5fba <printf>
    exit(1);
    534c:	4505                	li	a0,1
    534e:	00001097          	auipc	ra,0x1
    5352:	8f4080e7          	jalr	-1804(ra) # 5c42 <exit>
      printf("%s: read bigfile failed\n", s);
    5356:	85d6                	mv	a1,s5
    5358:	00003517          	auipc	a0,0x3
    535c:	cd850513          	add	a0,a0,-808 # 8030 <malloc+0x1fbe>
    5360:	00001097          	auipc	ra,0x1
    5364:	c5a080e7          	jalr	-934(ra) # 5fba <printf>
      exit(1);
    5368:	4505                	li	a0,1
    536a:	00001097          	auipc	ra,0x1
    536e:	8d8080e7          	jalr	-1832(ra) # 5c42 <exit>
      printf("%s: short read bigfile\n", s);
    5372:	85d6                	mv	a1,s5
    5374:	00003517          	auipc	a0,0x3
    5378:	cdc50513          	add	a0,a0,-804 # 8050 <malloc+0x1fde>
    537c:	00001097          	auipc	ra,0x1
    5380:	c3e080e7          	jalr	-962(ra) # 5fba <printf>
      exit(1);
    5384:	4505                	li	a0,1
    5386:	00001097          	auipc	ra,0x1
    538a:	8bc080e7          	jalr	-1860(ra) # 5c42 <exit>
      printf("%s: read bigfile wrong data\n", s);
    538e:	85d6                	mv	a1,s5
    5390:	00003517          	auipc	a0,0x3
    5394:	cd850513          	add	a0,a0,-808 # 8068 <malloc+0x1ff6>
    5398:	00001097          	auipc	ra,0x1
    539c:	c22080e7          	jalr	-990(ra) # 5fba <printf>
      exit(1);
    53a0:	4505                	li	a0,1
    53a2:	00001097          	auipc	ra,0x1
    53a6:	8a0080e7          	jalr	-1888(ra) # 5c42 <exit>
  close(fd);
    53aa:	8552                	mv	a0,s4
    53ac:	00001097          	auipc	ra,0x1
    53b0:	8be080e7          	jalr	-1858(ra) # 5c6a <close>
  if(total != N*SZ){
    53b4:	678d                	lui	a5,0x3
    53b6:	ee078793          	add	a5,a5,-288 # 2ee0 <sbrklast+0x38>
    53ba:	02f99363          	bne	s3,a5,53e0 <bigfile+0x1c4>
  unlink("bigfile.dat");
    53be:	00003517          	auipc	a0,0x3
    53c2:	c0250513          	add	a0,a0,-1022 # 7fc0 <malloc+0x1f4e>
    53c6:	00001097          	auipc	ra,0x1
    53ca:	8cc080e7          	jalr	-1844(ra) # 5c92 <unlink>
}
    53ce:	70e2                	ld	ra,56(sp)
    53d0:	7442                	ld	s0,48(sp)
    53d2:	74a2                	ld	s1,40(sp)
    53d4:	7902                	ld	s2,32(sp)
    53d6:	69e2                	ld	s3,24(sp)
    53d8:	6a42                	ld	s4,16(sp)
    53da:	6aa2                	ld	s5,8(sp)
    53dc:	6121                	add	sp,sp,64
    53de:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    53e0:	85d6                	mv	a1,s5
    53e2:	00003517          	auipc	a0,0x3
    53e6:	ca650513          	add	a0,a0,-858 # 8088 <malloc+0x2016>
    53ea:	00001097          	auipc	ra,0x1
    53ee:	bd0080e7          	jalr	-1072(ra) # 5fba <printf>
    exit(1);
    53f2:	4505                	li	a0,1
    53f4:	00001097          	auipc	ra,0x1
    53f8:	84e080e7          	jalr	-1970(ra) # 5c42 <exit>

00000000000053fc <fsfull>:
{
    53fc:	7135                	add	sp,sp,-160
    53fe:	ed06                	sd	ra,152(sp)
    5400:	e922                	sd	s0,144(sp)
    5402:	e526                	sd	s1,136(sp)
    5404:	e14a                	sd	s2,128(sp)
    5406:	fcce                	sd	s3,120(sp)
    5408:	f8d2                	sd	s4,112(sp)
    540a:	f4d6                	sd	s5,104(sp)
    540c:	f0da                	sd	s6,96(sp)
    540e:	ecde                	sd	s7,88(sp)
    5410:	e8e2                	sd	s8,80(sp)
    5412:	e4e6                	sd	s9,72(sp)
    5414:	e0ea                	sd	s10,64(sp)
    5416:	1100                	add	s0,sp,160
  printf("fsfull test\n");
    5418:	00003517          	auipc	a0,0x3
    541c:	c9050513          	add	a0,a0,-880 # 80a8 <malloc+0x2036>
    5420:	00001097          	auipc	ra,0x1
    5424:	b9a080e7          	jalr	-1126(ra) # 5fba <printf>
  for(nfiles = 0; ; nfiles++){
    5428:	4481                	li	s1,0
    name[0] = 'f';
    542a:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    542e:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5432:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    5436:	4b29                	li	s6,10
    printf("writing %s\n", name);
    5438:	00003c97          	auipc	s9,0x3
    543c:	c80c8c93          	add	s9,s9,-896 # 80b8 <malloc+0x2046>
    name[0] = 'f';
    5440:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    5444:	0384c7bb          	divw	a5,s1,s8
    5448:	0307879b          	addw	a5,a5,48
    544c:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5450:	0384e7bb          	remw	a5,s1,s8
    5454:	0377c7bb          	divw	a5,a5,s7
    5458:	0307879b          	addw	a5,a5,48
    545c:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5460:	0374e7bb          	remw	a5,s1,s7
    5464:	0367c7bb          	divw	a5,a5,s6
    5468:	0307879b          	addw	a5,a5,48
    546c:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    5470:	0364e7bb          	remw	a5,s1,s6
    5474:	0307879b          	addw	a5,a5,48
    5478:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    547c:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    5480:	f6040593          	add	a1,s0,-160
    5484:	8566                	mv	a0,s9
    5486:	00001097          	auipc	ra,0x1
    548a:	b34080e7          	jalr	-1228(ra) # 5fba <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    548e:	20200593          	li	a1,514
    5492:	f6040513          	add	a0,s0,-160
    5496:	00000097          	auipc	ra,0x0
    549a:	7ec080e7          	jalr	2028(ra) # 5c82 <open>
    549e:	892a                	mv	s2,a0
    if(fd < 0){
    54a0:	0a055563          	bgez	a0,554a <fsfull+0x14e>
      printf("open %s failed\n", name);
    54a4:	f6040593          	add	a1,s0,-160
    54a8:	00003517          	auipc	a0,0x3
    54ac:	c2050513          	add	a0,a0,-992 # 80c8 <malloc+0x2056>
    54b0:	00001097          	auipc	ra,0x1
    54b4:	b0a080e7          	jalr	-1270(ra) # 5fba <printf>
  while(nfiles >= 0){
    54b8:	0604c363          	bltz	s1,551e <fsfull+0x122>
    name[0] = 'f';
    54bc:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    54c0:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    54c4:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    54c8:	4929                	li	s2,10
  while(nfiles >= 0){
    54ca:	5afd                	li	s5,-1
    name[0] = 'f';
    54cc:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    54d0:	0344c7bb          	divw	a5,s1,s4
    54d4:	0307879b          	addw	a5,a5,48
    54d8:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    54dc:	0344e7bb          	remw	a5,s1,s4
    54e0:	0337c7bb          	divw	a5,a5,s3
    54e4:	0307879b          	addw	a5,a5,48
    54e8:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    54ec:	0334e7bb          	remw	a5,s1,s3
    54f0:	0327c7bb          	divw	a5,a5,s2
    54f4:	0307879b          	addw	a5,a5,48
    54f8:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    54fc:	0324e7bb          	remw	a5,s1,s2
    5500:	0307879b          	addw	a5,a5,48
    5504:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    5508:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    550c:	f6040513          	add	a0,s0,-160
    5510:	00000097          	auipc	ra,0x0
    5514:	782080e7          	jalr	1922(ra) # 5c92 <unlink>
    nfiles--;
    5518:	34fd                	addw	s1,s1,-1
  while(nfiles >= 0){
    551a:	fb5499e3          	bne	s1,s5,54cc <fsfull+0xd0>
  printf("fsfull test finished\n");
    551e:	00003517          	auipc	a0,0x3
    5522:	bca50513          	add	a0,a0,-1078 # 80e8 <malloc+0x2076>
    5526:	00001097          	auipc	ra,0x1
    552a:	a94080e7          	jalr	-1388(ra) # 5fba <printf>
}
    552e:	60ea                	ld	ra,152(sp)
    5530:	644a                	ld	s0,144(sp)
    5532:	64aa                	ld	s1,136(sp)
    5534:	690a                	ld	s2,128(sp)
    5536:	79e6                	ld	s3,120(sp)
    5538:	7a46                	ld	s4,112(sp)
    553a:	7aa6                	ld	s5,104(sp)
    553c:	7b06                	ld	s6,96(sp)
    553e:	6be6                	ld	s7,88(sp)
    5540:	6c46                	ld	s8,80(sp)
    5542:	6ca6                	ld	s9,72(sp)
    5544:	6d06                	ld	s10,64(sp)
    5546:	610d                	add	sp,sp,160
    5548:	8082                	ret
    int total = 0;
    554a:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    554c:	00009a97          	auipc	s5,0x9
    5550:	aeca8a93          	add	s5,s5,-1300 # e038 <buf>
      if(cc < BSIZE)
    5554:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    5558:	40000613          	li	a2,1024
    555c:	85d6                	mv	a1,s5
    555e:	854a                	mv	a0,s2
    5560:	00000097          	auipc	ra,0x0
    5564:	702080e7          	jalr	1794(ra) # 5c62 <write>
      if(cc < BSIZE)
    5568:	00aa5563          	bge	s4,a0,5572 <fsfull+0x176>
      total += cc;
    556c:	00a989bb          	addw	s3,s3,a0
    while(1){
    5570:	b7e5                	j	5558 <fsfull+0x15c>
    printf("wrote %d bytes\n", total);
    5572:	85ce                	mv	a1,s3
    5574:	00003517          	auipc	a0,0x3
    5578:	b6450513          	add	a0,a0,-1180 # 80d8 <malloc+0x2066>
    557c:	00001097          	auipc	ra,0x1
    5580:	a3e080e7          	jalr	-1474(ra) # 5fba <printf>
    close(fd);
    5584:	854a                	mv	a0,s2
    5586:	00000097          	auipc	ra,0x0
    558a:	6e4080e7          	jalr	1764(ra) # 5c6a <close>
    if(total == 0)
    558e:	f20985e3          	beqz	s3,54b8 <fsfull+0xbc>
  for(nfiles = 0; ; nfiles++){
    5592:	2485                	addw	s1,s1,1
    5594:	b575                	j	5440 <fsfull+0x44>

0000000000005596 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5596:	7179                	add	sp,sp,-48
    5598:	f406                	sd	ra,40(sp)
    559a:	f022                	sd	s0,32(sp)
    559c:	ec26                	sd	s1,24(sp)
    559e:	e84a                	sd	s2,16(sp)
    55a0:	1800                	add	s0,sp,48
    55a2:	84aa                	mv	s1,a0
    55a4:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    55a6:	00003517          	auipc	a0,0x3
    55aa:	b5a50513          	add	a0,a0,-1190 # 8100 <malloc+0x208e>
    55ae:	00001097          	auipc	ra,0x1
    55b2:	a0c080e7          	jalr	-1524(ra) # 5fba <printf>
  if((pid = fork()) < 0) {
    55b6:	00000097          	auipc	ra,0x0
    55ba:	684080e7          	jalr	1668(ra) # 5c3a <fork>
    55be:	02054e63          	bltz	a0,55fa <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    55c2:	c929                	beqz	a0,5614 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    55c4:	fdc40513          	add	a0,s0,-36
    55c8:	00000097          	auipc	ra,0x0
    55cc:	682080e7          	jalr	1666(ra) # 5c4a <wait>
    if(xstatus != 0) 
    55d0:	fdc42783          	lw	a5,-36(s0)
    55d4:	c7b9                	beqz	a5,5622 <run+0x8c>
      printf("FAILED\n");
    55d6:	00003517          	auipc	a0,0x3
    55da:	b5250513          	add	a0,a0,-1198 # 8128 <malloc+0x20b6>
    55de:	00001097          	auipc	ra,0x1
    55e2:	9dc080e7          	jalr	-1572(ra) # 5fba <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    55e6:	fdc42503          	lw	a0,-36(s0)
  }
}
    55ea:	00153513          	seqz	a0,a0
    55ee:	70a2                	ld	ra,40(sp)
    55f0:	7402                	ld	s0,32(sp)
    55f2:	64e2                	ld	s1,24(sp)
    55f4:	6942                	ld	s2,16(sp)
    55f6:	6145                	add	sp,sp,48
    55f8:	8082                	ret
    printf("runtest: fork error\n");
    55fa:	00003517          	auipc	a0,0x3
    55fe:	b1650513          	add	a0,a0,-1258 # 8110 <malloc+0x209e>
    5602:	00001097          	auipc	ra,0x1
    5606:	9b8080e7          	jalr	-1608(ra) # 5fba <printf>
    exit(1);
    560a:	4505                	li	a0,1
    560c:	00000097          	auipc	ra,0x0
    5610:	636080e7          	jalr	1590(ra) # 5c42 <exit>
    f(s);
    5614:	854a                	mv	a0,s2
    5616:	9482                	jalr	s1
    exit(0);
    5618:	4501                	li	a0,0
    561a:	00000097          	auipc	ra,0x0
    561e:	628080e7          	jalr	1576(ra) # 5c42 <exit>
      printf("OK\n");
    5622:	00003517          	auipc	a0,0x3
    5626:	b0e50513          	add	a0,a0,-1266 # 8130 <malloc+0x20be>
    562a:	00001097          	auipc	ra,0x1
    562e:	990080e7          	jalr	-1648(ra) # 5fba <printf>
    5632:	bf55                	j	55e6 <run+0x50>

0000000000005634 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    5634:	7179                	add	sp,sp,-48
    5636:	f406                	sd	ra,40(sp)
    5638:	f022                	sd	s0,32(sp)
    563a:	ec26                	sd	s1,24(sp)
    563c:	1800                	add	s0,sp,48
    563e:	84aa                	mv	s1,a0
  for (struct test *t = tests; t->s != 0; t++) {
    5640:	6508                	ld	a0,8(a0)
    5642:	c12d                	beqz	a0,56a4 <runtests+0x70>
    5644:	e84a                	sd	s2,16(sp)
    5646:	e44e                	sd	s3,8(sp)
    5648:	e052                	sd	s4,0(sp)
    564a:	892e                	mv	s2,a1
    564c:	89b2                	mv	s3,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
    564e:	4a09                	li	s4,2
    5650:	a021                	j	5658 <runtests+0x24>
  for (struct test *t = tests; t->s != 0; t++) {
    5652:	04c1                	add	s1,s1,16
    5654:	6488                	ld	a0,8(s1)
    5656:	cd1d                	beqz	a0,5694 <runtests+0x60>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5658:	00090863          	beqz	s2,5668 <runtests+0x34>
    565c:	85ca                	mv	a1,s2
    565e:	00000097          	auipc	ra,0x0
    5662:	37e080e7          	jalr	894(ra) # 59dc <strcmp>
    5666:	f575                	bnez	a0,5652 <runtests+0x1e>
      if(!run(t->f, t->s)){
    5668:	648c                	ld	a1,8(s1)
    566a:	6088                	ld	a0,0(s1)
    566c:	00000097          	auipc	ra,0x0
    5670:	f2a080e7          	jalr	-214(ra) # 5596 <run>
    5674:	fd79                	bnez	a0,5652 <runtests+0x1e>
        if(continuous != 2){
    5676:	fd498ee3          	beq	s3,s4,5652 <runtests+0x1e>
          printf("SOME TESTS FAILED\n");
    567a:	00003517          	auipc	a0,0x3
    567e:	abe50513          	add	a0,a0,-1346 # 8138 <malloc+0x20c6>
    5682:	00001097          	auipc	ra,0x1
    5686:	938080e7          	jalr	-1736(ra) # 5fba <printf>
          return 1;
    568a:	4505                	li	a0,1
    568c:	6942                	ld	s2,16(sp)
    568e:	69a2                	ld	s3,8(sp)
    5690:	6a02                	ld	s4,0(sp)
    5692:	a021                	j	569a <runtests+0x66>
    5694:	6942                	ld	s2,16(sp)
    5696:	69a2                	ld	s3,8(sp)
    5698:	6a02                	ld	s4,0(sp)
        }
      }
    }
  }
  return 0;
}
    569a:	70a2                	ld	ra,40(sp)
    569c:	7402                	ld	s0,32(sp)
    569e:	64e2                	ld	s1,24(sp)
    56a0:	6145                	add	sp,sp,48
    56a2:	8082                	ret
  return 0;
    56a4:	4501                	li	a0,0
    56a6:	bfd5                	j	569a <runtests+0x66>

00000000000056a8 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    56a8:	7139                	add	sp,sp,-64
    56aa:	fc06                	sd	ra,56(sp)
    56ac:	f822                	sd	s0,48(sp)
    56ae:	0080                	add	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    56b0:	fc840513          	add	a0,s0,-56
    56b4:	00000097          	auipc	ra,0x0
    56b8:	59e080e7          	jalr	1438(ra) # 5c52 <pipe>
    56bc:	06054a63          	bltz	a0,5730 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    56c0:	00000097          	auipc	ra,0x0
    56c4:	57a080e7          	jalr	1402(ra) # 5c3a <fork>

  if(pid < 0){
    56c8:	08054463          	bltz	a0,5750 <countfree+0xa8>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    56cc:	e55d                	bnez	a0,577a <countfree+0xd2>
    56ce:	f426                	sd	s1,40(sp)
    56d0:	f04a                	sd	s2,32(sp)
    56d2:	ec4e                	sd	s3,24(sp)
    close(fds[0]);
    56d4:	fc842503          	lw	a0,-56(s0)
    56d8:	00000097          	auipc	ra,0x0
    56dc:	592080e7          	jalr	1426(ra) # 5c6a <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    56e0:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    56e2:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    56e4:	00001997          	auipc	s3,0x1
    56e8:	b4498993          	add	s3,s3,-1212 # 6228 <malloc+0x1b6>
      uint64 a = (uint64) sbrk(4096);
    56ec:	6505                	lui	a0,0x1
    56ee:	00000097          	auipc	ra,0x0
    56f2:	5dc080e7          	jalr	1500(ra) # 5cca <sbrk>
      if(a == 0xffffffffffffffff){
    56f6:	07250d63          	beq	a0,s2,5770 <countfree+0xc8>
      *(char *)(a + 4096 - 1) = 1;
    56fa:	6785                	lui	a5,0x1
    56fc:	97aa                	add	a5,a5,a0
    56fe:	fe978fa3          	sb	s1,-1(a5) # fff <linktest+0x109>
      if(write(fds[1], "x", 1) != 1){
    5702:	8626                	mv	a2,s1
    5704:	85ce                	mv	a1,s3
    5706:	fcc42503          	lw	a0,-52(s0)
    570a:	00000097          	auipc	ra,0x0
    570e:	558080e7          	jalr	1368(ra) # 5c62 <write>
    5712:	fc950de3          	beq	a0,s1,56ec <countfree+0x44>
        printf("write() failed in countfree()\n");
    5716:	00003517          	auipc	a0,0x3
    571a:	a7a50513          	add	a0,a0,-1414 # 8190 <malloc+0x211e>
    571e:	00001097          	auipc	ra,0x1
    5722:	89c080e7          	jalr	-1892(ra) # 5fba <printf>
        exit(1);
    5726:	4505                	li	a0,1
    5728:	00000097          	auipc	ra,0x0
    572c:	51a080e7          	jalr	1306(ra) # 5c42 <exit>
    5730:	f426                	sd	s1,40(sp)
    5732:	f04a                	sd	s2,32(sp)
    5734:	ec4e                	sd	s3,24(sp)
    printf("pipe() failed in countfree()\n");
    5736:	00003517          	auipc	a0,0x3
    573a:	a1a50513          	add	a0,a0,-1510 # 8150 <malloc+0x20de>
    573e:	00001097          	auipc	ra,0x1
    5742:	87c080e7          	jalr	-1924(ra) # 5fba <printf>
    exit(1);
    5746:	4505                	li	a0,1
    5748:	00000097          	auipc	ra,0x0
    574c:	4fa080e7          	jalr	1274(ra) # 5c42 <exit>
    5750:	f426                	sd	s1,40(sp)
    5752:	f04a                	sd	s2,32(sp)
    5754:	ec4e                	sd	s3,24(sp)
    printf("fork failed in countfree()\n");
    5756:	00003517          	auipc	a0,0x3
    575a:	a1a50513          	add	a0,a0,-1510 # 8170 <malloc+0x20fe>
    575e:	00001097          	auipc	ra,0x1
    5762:	85c080e7          	jalr	-1956(ra) # 5fba <printf>
    exit(1);
    5766:	4505                	li	a0,1
    5768:	00000097          	auipc	ra,0x0
    576c:	4da080e7          	jalr	1242(ra) # 5c42 <exit>
      }
    }

    exit(0);
    5770:	4501                	li	a0,0
    5772:	00000097          	auipc	ra,0x0
    5776:	4d0080e7          	jalr	1232(ra) # 5c42 <exit>
    577a:	f426                	sd	s1,40(sp)
  }

  close(fds[1]);
    577c:	fcc42503          	lw	a0,-52(s0)
    5780:	00000097          	auipc	ra,0x0
    5784:	4ea080e7          	jalr	1258(ra) # 5c6a <close>

  int n = 0;
    5788:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    578a:	4605                	li	a2,1
    578c:	fc740593          	add	a1,s0,-57
    5790:	fc842503          	lw	a0,-56(s0)
    5794:	00000097          	auipc	ra,0x0
    5798:	4c6080e7          	jalr	1222(ra) # 5c5a <read>
    if(cc < 0){
    579c:	00054563          	bltz	a0,57a6 <countfree+0xfe>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    57a0:	c115                	beqz	a0,57c4 <countfree+0x11c>
      break;
    n += 1;
    57a2:	2485                	addw	s1,s1,1
  while(1){
    57a4:	b7dd                	j	578a <countfree+0xe2>
    57a6:	f04a                	sd	s2,32(sp)
    57a8:	ec4e                	sd	s3,24(sp)
      printf("read() failed in countfree()\n");
    57aa:	00003517          	auipc	a0,0x3
    57ae:	a0650513          	add	a0,a0,-1530 # 81b0 <malloc+0x213e>
    57b2:	00001097          	auipc	ra,0x1
    57b6:	808080e7          	jalr	-2040(ra) # 5fba <printf>
      exit(1);
    57ba:	4505                	li	a0,1
    57bc:	00000097          	auipc	ra,0x0
    57c0:	486080e7          	jalr	1158(ra) # 5c42 <exit>
  }

  close(fds[0]);
    57c4:	fc842503          	lw	a0,-56(s0)
    57c8:	00000097          	auipc	ra,0x0
    57cc:	4a2080e7          	jalr	1186(ra) # 5c6a <close>
  wait((int*)0);
    57d0:	4501                	li	a0,0
    57d2:	00000097          	auipc	ra,0x0
    57d6:	478080e7          	jalr	1144(ra) # 5c4a <wait>
  
  return n;
}
    57da:	8526                	mv	a0,s1
    57dc:	74a2                	ld	s1,40(sp)
    57de:	70e2                	ld	ra,56(sp)
    57e0:	7442                	ld	s0,48(sp)
    57e2:	6121                	add	sp,sp,64
    57e4:	8082                	ret

00000000000057e6 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    57e6:	711d                	add	sp,sp,-96
    57e8:	ec86                	sd	ra,88(sp)
    57ea:	e8a2                	sd	s0,80(sp)
    57ec:	e4a6                	sd	s1,72(sp)
    57ee:	e0ca                	sd	s2,64(sp)
    57f0:	fc4e                	sd	s3,56(sp)
    57f2:	f852                	sd	s4,48(sp)
    57f4:	f456                	sd	s5,40(sp)
    57f6:	f05a                	sd	s6,32(sp)
    57f8:	ec5e                	sd	s7,24(sp)
    57fa:	e862                	sd	s8,16(sp)
    57fc:	e466                	sd	s9,8(sp)
    57fe:	e06a                	sd	s10,0(sp)
    5800:	1080                	add	s0,sp,96
    5802:	8aaa                	mv	s5,a0
    5804:	892e                	mv	s2,a1
    5806:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
    5808:	00003b97          	auipc	s7,0x3
    580c:	9c8b8b93          	add	s7,s7,-1592 # 81d0 <malloc+0x215e>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
    5810:	00005b17          	auipc	s6,0x5
    5814:	bc0b0b13          	add	s6,s6,-1088 # a3d0 <quicktests>
      if(continuous != 2) {
    5818:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone, continuous)) {
    581a:	00005c17          	auipc	s8,0x5
    581e:	f86c0c13          	add	s8,s8,-122 # a7a0 <slowtests>
        printf("usertests slow tests starting\n");
    5822:	00003d17          	auipc	s10,0x3
    5826:	9c6d0d13          	add	s10,s10,-1594 # 81e8 <malloc+0x2176>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    582a:	00003c97          	auipc	s9,0x3
    582e:	9dec8c93          	add	s9,s9,-1570 # 8208 <malloc+0x2196>
    5832:	a839                	j	5850 <drivetests+0x6a>
        printf("usertests slow tests starting\n");
    5834:	856a                	mv	a0,s10
    5836:	00000097          	auipc	ra,0x0
    583a:	784080e7          	jalr	1924(ra) # 5fba <printf>
    583e:	a089                	j	5880 <drivetests+0x9a>
    if((free1 = countfree()) < free0) {
    5840:	00000097          	auipc	ra,0x0
    5844:	e68080e7          	jalr	-408(ra) # 56a8 <countfree>
    5848:	04954863          	blt	a0,s1,5898 <drivetests+0xb2>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    584c:	06090363          	beqz	s2,58b2 <drivetests+0xcc>
    printf("usertests starting\n");
    5850:	855e                	mv	a0,s7
    5852:	00000097          	auipc	ra,0x0
    5856:	768080e7          	jalr	1896(ra) # 5fba <printf>
    int free0 = countfree();
    585a:	00000097          	auipc	ra,0x0
    585e:	e4e080e7          	jalr	-434(ra) # 56a8 <countfree>
    5862:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
    5864:	864a                	mv	a2,s2
    5866:	85ce                	mv	a1,s3
    5868:	855a                	mv	a0,s6
    586a:	00000097          	auipc	ra,0x0
    586e:	dca080e7          	jalr	-566(ra) # 5634 <runtests>
    5872:	c119                	beqz	a0,5878 <drivetests+0x92>
      if(continuous != 2) {
    5874:	03491d63          	bne	s2,s4,58ae <drivetests+0xc8>
    if(!quick) {
    5878:	fc0a94e3          	bnez	s5,5840 <drivetests+0x5a>
      if (justone == 0)
    587c:	fa098ce3          	beqz	s3,5834 <drivetests+0x4e>
      if (runtests(slowtests, justone, continuous)) {
    5880:	864a                	mv	a2,s2
    5882:	85ce                	mv	a1,s3
    5884:	8562                	mv	a0,s8
    5886:	00000097          	auipc	ra,0x0
    588a:	dae080e7          	jalr	-594(ra) # 5634 <runtests>
    588e:	d94d                	beqz	a0,5840 <drivetests+0x5a>
        if(continuous != 2) {
    5890:	fb4908e3          	beq	s2,s4,5840 <drivetests+0x5a>
          return 1;
    5894:	4505                	li	a0,1
    5896:	a839                	j	58b4 <drivetests+0xce>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5898:	8626                	mv	a2,s1
    589a:	85aa                	mv	a1,a0
    589c:	8566                	mv	a0,s9
    589e:	00000097          	auipc	ra,0x0
    58a2:	71c080e7          	jalr	1820(ra) # 5fba <printf>
      if(continuous != 2) {
    58a6:	fb4905e3          	beq	s2,s4,5850 <drivetests+0x6a>
        return 1;
    58aa:	4505                	li	a0,1
    58ac:	a021                	j	58b4 <drivetests+0xce>
        return 1;
    58ae:	4505                	li	a0,1
    58b0:	a011                	j	58b4 <drivetests+0xce>
  return 0;
    58b2:	854a                	mv	a0,s2
}
    58b4:	60e6                	ld	ra,88(sp)
    58b6:	6446                	ld	s0,80(sp)
    58b8:	64a6                	ld	s1,72(sp)
    58ba:	6906                	ld	s2,64(sp)
    58bc:	79e2                	ld	s3,56(sp)
    58be:	7a42                	ld	s4,48(sp)
    58c0:	7aa2                	ld	s5,40(sp)
    58c2:	7b02                	ld	s6,32(sp)
    58c4:	6be2                	ld	s7,24(sp)
    58c6:	6c42                	ld	s8,16(sp)
    58c8:	6ca2                	ld	s9,8(sp)
    58ca:	6d02                	ld	s10,0(sp)
    58cc:	6125                	add	sp,sp,96
    58ce:	8082                	ret

00000000000058d0 <main>:

int
main(int argc, char *argv[])
{
    58d0:	1101                	add	sp,sp,-32
    58d2:	ec06                	sd	ra,24(sp)
    58d4:	e822                	sd	s0,16(sp)
    58d6:	e426                	sd	s1,8(sp)
    58d8:	e04a                	sd	s2,0(sp)
    58da:	1000                	add	s0,sp,32
    58dc:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    58de:	4789                	li	a5,2
    58e0:	02f50263          	beq	a0,a5,5904 <main+0x34>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    58e4:	4785                	li	a5,1
    58e6:	08a7c063          	blt	a5,a0,5966 <main+0x96>
  char *justone = 0;
    58ea:	4601                	li	a2,0
  int quick = 0;
    58ec:	4501                	li	a0,0
  int continuous = 0;
    58ee:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    58f0:	00000097          	auipc	ra,0x0
    58f4:	ef6080e7          	jalr	-266(ra) # 57e6 <drivetests>
    58f8:	c951                	beqz	a0,598c <main+0xbc>
    exit(1);
    58fa:	4505                	li	a0,1
    58fc:	00000097          	auipc	ra,0x0
    5900:	346080e7          	jalr	838(ra) # 5c42 <exit>
    5904:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5906:	00003597          	auipc	a1,0x3
    590a:	93258593          	add	a1,a1,-1742 # 8238 <malloc+0x21c6>
    590e:	00893503          	ld	a0,8(s2)
    5912:	00000097          	auipc	ra,0x0
    5916:	0ca080e7          	jalr	202(ra) # 59dc <strcmp>
    591a:	85aa                	mv	a1,a0
    591c:	e501                	bnez	a0,5924 <main+0x54>
  char *justone = 0;
    591e:	4601                	li	a2,0
    quick = 1;
    5920:	4505                	li	a0,1
    5922:	b7f9                	j	58f0 <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5924:	00003597          	auipc	a1,0x3
    5928:	91c58593          	add	a1,a1,-1764 # 8240 <malloc+0x21ce>
    592c:	00893503          	ld	a0,8(s2)
    5930:	00000097          	auipc	ra,0x0
    5934:	0ac080e7          	jalr	172(ra) # 59dc <strcmp>
    5938:	c521                	beqz	a0,5980 <main+0xb0>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    593a:	00003597          	auipc	a1,0x3
    593e:	95658593          	add	a1,a1,-1706 # 8290 <malloc+0x221e>
    5942:	00893503          	ld	a0,8(s2)
    5946:	00000097          	auipc	ra,0x0
    594a:	096080e7          	jalr	150(ra) # 59dc <strcmp>
    594e:	cd05                	beqz	a0,5986 <main+0xb6>
  } else if(argc == 2 && argv[1][0] != '-'){
    5950:	00893603          	ld	a2,8(s2)
    5954:	00064703          	lbu	a4,0(a2) # 3000 <execout+0x50>
    5958:	02d00793          	li	a5,45
    595c:	00f70563          	beq	a4,a5,5966 <main+0x96>
  int quick = 0;
    5960:	4501                	li	a0,0
  int continuous = 0;
    5962:	4581                	li	a1,0
    5964:	b771                	j	58f0 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    5966:	00003517          	auipc	a0,0x3
    596a:	8e250513          	add	a0,a0,-1822 # 8248 <malloc+0x21d6>
    596e:	00000097          	auipc	ra,0x0
    5972:	64c080e7          	jalr	1612(ra) # 5fba <printf>
    exit(1);
    5976:	4505                	li	a0,1
    5978:	00000097          	auipc	ra,0x0
    597c:	2ca080e7          	jalr	714(ra) # 5c42 <exit>
  char *justone = 0;
    5980:	4601                	li	a2,0
    continuous = 1;
    5982:	4585                	li	a1,1
    5984:	b7b5                	j	58f0 <main+0x20>
    continuous = 2;
    5986:	85a6                	mv	a1,s1
  char *justone = 0;
    5988:	4601                	li	a2,0
    598a:	b79d                	j	58f0 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    598c:	00003517          	auipc	a0,0x3
    5990:	8ec50513          	add	a0,a0,-1812 # 8278 <malloc+0x2206>
    5994:	00000097          	auipc	ra,0x0
    5998:	626080e7          	jalr	1574(ra) # 5fba <printf>
  exit(0);
    599c:	4501                	li	a0,0
    599e:	00000097          	auipc	ra,0x0
    59a2:	2a4080e7          	jalr	676(ra) # 5c42 <exit>

00000000000059a6 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    59a6:	1141                	add	sp,sp,-16
    59a8:	e406                	sd	ra,8(sp)
    59aa:	e022                	sd	s0,0(sp)
    59ac:	0800                	add	s0,sp,16
  extern int main();
  main();
    59ae:	00000097          	auipc	ra,0x0
    59b2:	f22080e7          	jalr	-222(ra) # 58d0 <main>
  exit(0);
    59b6:	4501                	li	a0,0
    59b8:	00000097          	auipc	ra,0x0
    59bc:	28a080e7          	jalr	650(ra) # 5c42 <exit>

00000000000059c0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    59c0:	1141                	add	sp,sp,-16
    59c2:	e422                	sd	s0,8(sp)
    59c4:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    59c6:	87aa                	mv	a5,a0
    59c8:	0585                	add	a1,a1,1
    59ca:	0785                	add	a5,a5,1
    59cc:	fff5c703          	lbu	a4,-1(a1)
    59d0:	fee78fa3          	sb	a4,-1(a5)
    59d4:	fb75                	bnez	a4,59c8 <strcpy+0x8>
    ;
  return os;
}
    59d6:	6422                	ld	s0,8(sp)
    59d8:	0141                	add	sp,sp,16
    59da:	8082                	ret

00000000000059dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
    59dc:	1141                	add	sp,sp,-16
    59de:	e422                	sd	s0,8(sp)
    59e0:	0800                	add	s0,sp,16
  while(*p && *p == *q)
    59e2:	00054783          	lbu	a5,0(a0)
    59e6:	cb91                	beqz	a5,59fa <strcmp+0x1e>
    59e8:	0005c703          	lbu	a4,0(a1)
    59ec:	00f71763          	bne	a4,a5,59fa <strcmp+0x1e>
    p++, q++;
    59f0:	0505                	add	a0,a0,1
    59f2:	0585                	add	a1,a1,1
  while(*p && *p == *q)
    59f4:	00054783          	lbu	a5,0(a0)
    59f8:	fbe5                	bnez	a5,59e8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    59fa:	0005c503          	lbu	a0,0(a1)
}
    59fe:	40a7853b          	subw	a0,a5,a0
    5a02:	6422                	ld	s0,8(sp)
    5a04:	0141                	add	sp,sp,16
    5a06:	8082                	ret

0000000000005a08 <strlen>:

uint
strlen(const char *s)
{
    5a08:	1141                	add	sp,sp,-16
    5a0a:	e422                	sd	s0,8(sp)
    5a0c:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5a0e:	00054783          	lbu	a5,0(a0)
    5a12:	cf91                	beqz	a5,5a2e <strlen+0x26>
    5a14:	0505                	add	a0,a0,1
    5a16:	87aa                	mv	a5,a0
    5a18:	86be                	mv	a3,a5
    5a1a:	0785                	add	a5,a5,1
    5a1c:	fff7c703          	lbu	a4,-1(a5)
    5a20:	ff65                	bnez	a4,5a18 <strlen+0x10>
    5a22:	40a6853b          	subw	a0,a3,a0
    5a26:	2505                	addw	a0,a0,1
    ;
  return n;
}
    5a28:	6422                	ld	s0,8(sp)
    5a2a:	0141                	add	sp,sp,16
    5a2c:	8082                	ret
  for(n = 0; s[n]; n++)
    5a2e:	4501                	li	a0,0
    5a30:	bfe5                	j	5a28 <strlen+0x20>

0000000000005a32 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5a32:	1141                	add	sp,sp,-16
    5a34:	e422                	sd	s0,8(sp)
    5a36:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5a38:	ca19                	beqz	a2,5a4e <memset+0x1c>
    5a3a:	87aa                	mv	a5,a0
    5a3c:	1602                	sll	a2,a2,0x20
    5a3e:	9201                	srl	a2,a2,0x20
    5a40:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5a44:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5a48:	0785                	add	a5,a5,1
    5a4a:	fee79de3          	bne	a5,a4,5a44 <memset+0x12>
  }
  return dst;
}
    5a4e:	6422                	ld	s0,8(sp)
    5a50:	0141                	add	sp,sp,16
    5a52:	8082                	ret

0000000000005a54 <strchr>:

char*
strchr(const char *s, char c)
{
    5a54:	1141                	add	sp,sp,-16
    5a56:	e422                	sd	s0,8(sp)
    5a58:	0800                	add	s0,sp,16
  for(; *s; s++)
    5a5a:	00054783          	lbu	a5,0(a0)
    5a5e:	cb99                	beqz	a5,5a74 <strchr+0x20>
    if(*s == c)
    5a60:	00f58763          	beq	a1,a5,5a6e <strchr+0x1a>
  for(; *s; s++)
    5a64:	0505                	add	a0,a0,1
    5a66:	00054783          	lbu	a5,0(a0)
    5a6a:	fbfd                	bnez	a5,5a60 <strchr+0xc>
      return (char*)s;
  return 0;
    5a6c:	4501                	li	a0,0
}
    5a6e:	6422                	ld	s0,8(sp)
    5a70:	0141                	add	sp,sp,16
    5a72:	8082                	ret
  return 0;
    5a74:	4501                	li	a0,0
    5a76:	bfe5                	j	5a6e <strchr+0x1a>

0000000000005a78 <gets>:

char*
gets(char *buf, int max)
{
    5a78:	711d                	add	sp,sp,-96
    5a7a:	ec86                	sd	ra,88(sp)
    5a7c:	e8a2                	sd	s0,80(sp)
    5a7e:	e4a6                	sd	s1,72(sp)
    5a80:	e0ca                	sd	s2,64(sp)
    5a82:	fc4e                	sd	s3,56(sp)
    5a84:	f852                	sd	s4,48(sp)
    5a86:	f456                	sd	s5,40(sp)
    5a88:	f05a                	sd	s6,32(sp)
    5a8a:	ec5e                	sd	s7,24(sp)
    5a8c:	1080                	add	s0,sp,96
    5a8e:	8baa                	mv	s7,a0
    5a90:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5a92:	892a                	mv	s2,a0
    5a94:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5a96:	4aa9                	li	s5,10
    5a98:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5a9a:	89a6                	mv	s3,s1
    5a9c:	2485                	addw	s1,s1,1
    5a9e:	0344d863          	bge	s1,s4,5ace <gets+0x56>
    cc = read(0, &c, 1);
    5aa2:	4605                	li	a2,1
    5aa4:	faf40593          	add	a1,s0,-81
    5aa8:	4501                	li	a0,0
    5aaa:	00000097          	auipc	ra,0x0
    5aae:	1b0080e7          	jalr	432(ra) # 5c5a <read>
    if(cc < 1)
    5ab2:	00a05e63          	blez	a0,5ace <gets+0x56>
    buf[i++] = c;
    5ab6:	faf44783          	lbu	a5,-81(s0)
    5aba:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5abe:	01578763          	beq	a5,s5,5acc <gets+0x54>
    5ac2:	0905                	add	s2,s2,1
    5ac4:	fd679be3          	bne	a5,s6,5a9a <gets+0x22>
    buf[i++] = c;
    5ac8:	89a6                	mv	s3,s1
    5aca:	a011                	j	5ace <gets+0x56>
    5acc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5ace:	99de                	add	s3,s3,s7
    5ad0:	00098023          	sb	zero,0(s3)
  return buf;
}
    5ad4:	855e                	mv	a0,s7
    5ad6:	60e6                	ld	ra,88(sp)
    5ad8:	6446                	ld	s0,80(sp)
    5ada:	64a6                	ld	s1,72(sp)
    5adc:	6906                	ld	s2,64(sp)
    5ade:	79e2                	ld	s3,56(sp)
    5ae0:	7a42                	ld	s4,48(sp)
    5ae2:	7aa2                	ld	s5,40(sp)
    5ae4:	7b02                	ld	s6,32(sp)
    5ae6:	6be2                	ld	s7,24(sp)
    5ae8:	6125                	add	sp,sp,96
    5aea:	8082                	ret

0000000000005aec <stat>:

int
stat(const char *n, struct stat *st)
{
    5aec:	1101                	add	sp,sp,-32
    5aee:	ec06                	sd	ra,24(sp)
    5af0:	e822                	sd	s0,16(sp)
    5af2:	e04a                	sd	s2,0(sp)
    5af4:	1000                	add	s0,sp,32
    5af6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5af8:	4581                	li	a1,0
    5afa:	00000097          	auipc	ra,0x0
    5afe:	188080e7          	jalr	392(ra) # 5c82 <open>
  if(fd < 0)
    5b02:	02054663          	bltz	a0,5b2e <stat+0x42>
    5b06:	e426                	sd	s1,8(sp)
    5b08:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5b0a:	85ca                	mv	a1,s2
    5b0c:	00000097          	auipc	ra,0x0
    5b10:	18e080e7          	jalr	398(ra) # 5c9a <fstat>
    5b14:	892a                	mv	s2,a0
  close(fd);
    5b16:	8526                	mv	a0,s1
    5b18:	00000097          	auipc	ra,0x0
    5b1c:	152080e7          	jalr	338(ra) # 5c6a <close>
  return r;
    5b20:	64a2                	ld	s1,8(sp)
}
    5b22:	854a                	mv	a0,s2
    5b24:	60e2                	ld	ra,24(sp)
    5b26:	6442                	ld	s0,16(sp)
    5b28:	6902                	ld	s2,0(sp)
    5b2a:	6105                	add	sp,sp,32
    5b2c:	8082                	ret
    return -1;
    5b2e:	597d                	li	s2,-1
    5b30:	bfcd                	j	5b22 <stat+0x36>

0000000000005b32 <atoi>:

int
atoi(const char *s)
{
    5b32:	1141                	add	sp,sp,-16
    5b34:	e422                	sd	s0,8(sp)
    5b36:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5b38:	00054683          	lbu	a3,0(a0)
    5b3c:	fd06879b          	addw	a5,a3,-48
    5b40:	0ff7f793          	zext.b	a5,a5
    5b44:	4625                	li	a2,9
    5b46:	02f66863          	bltu	a2,a5,5b76 <atoi+0x44>
    5b4a:	872a                	mv	a4,a0
  n = 0;
    5b4c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5b4e:	0705                	add	a4,a4,1
    5b50:	0025179b          	sllw	a5,a0,0x2
    5b54:	9fa9                	addw	a5,a5,a0
    5b56:	0017979b          	sllw	a5,a5,0x1
    5b5a:	9fb5                	addw	a5,a5,a3
    5b5c:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5b60:	00074683          	lbu	a3,0(a4)
    5b64:	fd06879b          	addw	a5,a3,-48
    5b68:	0ff7f793          	zext.b	a5,a5
    5b6c:	fef671e3          	bgeu	a2,a5,5b4e <atoi+0x1c>
  return n;
}
    5b70:	6422                	ld	s0,8(sp)
    5b72:	0141                	add	sp,sp,16
    5b74:	8082                	ret
  n = 0;
    5b76:	4501                	li	a0,0
    5b78:	bfe5                	j	5b70 <atoi+0x3e>

0000000000005b7a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5b7a:	1141                	add	sp,sp,-16
    5b7c:	e422                	sd	s0,8(sp)
    5b7e:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5b80:	02b57463          	bgeu	a0,a1,5ba8 <memmove+0x2e>
    while(n-- > 0)
    5b84:	00c05f63          	blez	a2,5ba2 <memmove+0x28>
    5b88:	1602                	sll	a2,a2,0x20
    5b8a:	9201                	srl	a2,a2,0x20
    5b8c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5b90:	872a                	mv	a4,a0
      *dst++ = *src++;
    5b92:	0585                	add	a1,a1,1
    5b94:	0705                	add	a4,a4,1
    5b96:	fff5c683          	lbu	a3,-1(a1)
    5b9a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b9e:	fef71ae3          	bne	a4,a5,5b92 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5ba2:	6422                	ld	s0,8(sp)
    5ba4:	0141                	add	sp,sp,16
    5ba6:	8082                	ret
    dst += n;
    5ba8:	00c50733          	add	a4,a0,a2
    src += n;
    5bac:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5bae:	fec05ae3          	blez	a2,5ba2 <memmove+0x28>
    5bb2:	fff6079b          	addw	a5,a2,-1
    5bb6:	1782                	sll	a5,a5,0x20
    5bb8:	9381                	srl	a5,a5,0x20
    5bba:	fff7c793          	not	a5,a5
    5bbe:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5bc0:	15fd                	add	a1,a1,-1
    5bc2:	177d                	add	a4,a4,-1
    5bc4:	0005c683          	lbu	a3,0(a1)
    5bc8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5bcc:	fee79ae3          	bne	a5,a4,5bc0 <memmove+0x46>
    5bd0:	bfc9                	j	5ba2 <memmove+0x28>

0000000000005bd2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5bd2:	1141                	add	sp,sp,-16
    5bd4:	e422                	sd	s0,8(sp)
    5bd6:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5bd8:	ca05                	beqz	a2,5c08 <memcmp+0x36>
    5bda:	fff6069b          	addw	a3,a2,-1
    5bde:	1682                	sll	a3,a3,0x20
    5be0:	9281                	srl	a3,a3,0x20
    5be2:	0685                	add	a3,a3,1
    5be4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5be6:	00054783          	lbu	a5,0(a0)
    5bea:	0005c703          	lbu	a4,0(a1)
    5bee:	00e79863          	bne	a5,a4,5bfe <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5bf2:	0505                	add	a0,a0,1
    p2++;
    5bf4:	0585                	add	a1,a1,1
  while (n-- > 0) {
    5bf6:	fed518e3          	bne	a0,a3,5be6 <memcmp+0x14>
  }
  return 0;
    5bfa:	4501                	li	a0,0
    5bfc:	a019                	j	5c02 <memcmp+0x30>
      return *p1 - *p2;
    5bfe:	40e7853b          	subw	a0,a5,a4
}
    5c02:	6422                	ld	s0,8(sp)
    5c04:	0141                	add	sp,sp,16
    5c06:	8082                	ret
  return 0;
    5c08:	4501                	li	a0,0
    5c0a:	bfe5                	j	5c02 <memcmp+0x30>

0000000000005c0c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5c0c:	1141                	add	sp,sp,-16
    5c0e:	e406                	sd	ra,8(sp)
    5c10:	e022                	sd	s0,0(sp)
    5c12:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    5c14:	00000097          	auipc	ra,0x0
    5c18:	f66080e7          	jalr	-154(ra) # 5b7a <memmove>
}
    5c1c:	60a2                	ld	ra,8(sp)
    5c1e:	6402                	ld	s0,0(sp)
    5c20:	0141                	add	sp,sp,16
    5c22:	8082                	ret

0000000000005c24 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
    5c24:	1141                	add	sp,sp,-16
    5c26:	e422                	sd	s0,8(sp)
    5c28:	0800                	add	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
    5c2a:	040007b7          	lui	a5,0x4000
    5c2e:	17f5                	add	a5,a5,-3 # 3fffffd <base+0x3feefc5>
    5c30:	07b2                	sll	a5,a5,0xc
}
    5c32:	4388                	lw	a0,0(a5)
    5c34:	6422                	ld	s0,8(sp)
    5c36:	0141                	add	sp,sp,16
    5c38:	8082                	ret

0000000000005c3a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5c3a:	4885                	li	a7,1
 ecall
    5c3c:	00000073          	ecall
 ret
    5c40:	8082                	ret

0000000000005c42 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5c42:	4889                	li	a7,2
 ecall
    5c44:	00000073          	ecall
 ret
    5c48:	8082                	ret

0000000000005c4a <wait>:
.global wait
wait:
 li a7, SYS_wait
    5c4a:	488d                	li	a7,3
 ecall
    5c4c:	00000073          	ecall
 ret
    5c50:	8082                	ret

0000000000005c52 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5c52:	4891                	li	a7,4
 ecall
    5c54:	00000073          	ecall
 ret
    5c58:	8082                	ret

0000000000005c5a <read>:
.global read
read:
 li a7, SYS_read
    5c5a:	4895                	li	a7,5
 ecall
    5c5c:	00000073          	ecall
 ret
    5c60:	8082                	ret

0000000000005c62 <write>:
.global write
write:
 li a7, SYS_write
    5c62:	48c1                	li	a7,16
 ecall
    5c64:	00000073          	ecall
 ret
    5c68:	8082                	ret

0000000000005c6a <close>:
.global close
close:
 li a7, SYS_close
    5c6a:	48d5                	li	a7,21
 ecall
    5c6c:	00000073          	ecall
 ret
    5c70:	8082                	ret

0000000000005c72 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5c72:	4899                	li	a7,6
 ecall
    5c74:	00000073          	ecall
 ret
    5c78:	8082                	ret

0000000000005c7a <exec>:
.global exec
exec:
 li a7, SYS_exec
    5c7a:	489d                	li	a7,7
 ecall
    5c7c:	00000073          	ecall
 ret
    5c80:	8082                	ret

0000000000005c82 <open>:
.global open
open:
 li a7, SYS_open
    5c82:	48bd                	li	a7,15
 ecall
    5c84:	00000073          	ecall
 ret
    5c88:	8082                	ret

0000000000005c8a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5c8a:	48c5                	li	a7,17
 ecall
    5c8c:	00000073          	ecall
 ret
    5c90:	8082                	ret

0000000000005c92 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5c92:	48c9                	li	a7,18
 ecall
    5c94:	00000073          	ecall
 ret
    5c98:	8082                	ret

0000000000005c9a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5c9a:	48a1                	li	a7,8
 ecall
    5c9c:	00000073          	ecall
 ret
    5ca0:	8082                	ret

0000000000005ca2 <link>:
.global link
link:
 li a7, SYS_link
    5ca2:	48cd                	li	a7,19
 ecall
    5ca4:	00000073          	ecall
 ret
    5ca8:	8082                	ret

0000000000005caa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5caa:	48d1                	li	a7,20
 ecall
    5cac:	00000073          	ecall
 ret
    5cb0:	8082                	ret

0000000000005cb2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5cb2:	48a5                	li	a7,9
 ecall
    5cb4:	00000073          	ecall
 ret
    5cb8:	8082                	ret

0000000000005cba <dup>:
.global dup
dup:
 li a7, SYS_dup
    5cba:	48a9                	li	a7,10
 ecall
    5cbc:	00000073          	ecall
 ret
    5cc0:	8082                	ret

0000000000005cc2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5cc2:	48ad                	li	a7,11
 ecall
    5cc4:	00000073          	ecall
 ret
    5cc8:	8082                	ret

0000000000005cca <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5cca:	48b1                	li	a7,12
 ecall
    5ccc:	00000073          	ecall
 ret
    5cd0:	8082                	ret

0000000000005cd2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5cd2:	48b5                	li	a7,13
 ecall
    5cd4:	00000073          	ecall
 ret
    5cd8:	8082                	ret

0000000000005cda <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5cda:	48b9                	li	a7,14
 ecall
    5cdc:	00000073          	ecall
 ret
    5ce0:	8082                	ret

0000000000005ce2 <connect>:
.global connect
connect:
 li a7, SYS_connect
    5ce2:	48f5                	li	a7,29
 ecall
    5ce4:	00000073          	ecall
 ret
    5ce8:	8082                	ret

0000000000005cea <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
    5cea:	48f9                	li	a7,30
 ecall
    5cec:	00000073          	ecall
 ret
    5cf0:	8082                	ret

0000000000005cf2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5cf2:	1101                	add	sp,sp,-32
    5cf4:	ec06                	sd	ra,24(sp)
    5cf6:	e822                	sd	s0,16(sp)
    5cf8:	1000                	add	s0,sp,32
    5cfa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5cfe:	4605                	li	a2,1
    5d00:	fef40593          	add	a1,s0,-17
    5d04:	00000097          	auipc	ra,0x0
    5d08:	f5e080e7          	jalr	-162(ra) # 5c62 <write>
}
    5d0c:	60e2                	ld	ra,24(sp)
    5d0e:	6442                	ld	s0,16(sp)
    5d10:	6105                	add	sp,sp,32
    5d12:	8082                	ret

0000000000005d14 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5d14:	7139                	add	sp,sp,-64
    5d16:	fc06                	sd	ra,56(sp)
    5d18:	f822                	sd	s0,48(sp)
    5d1a:	f426                	sd	s1,40(sp)
    5d1c:	0080                	add	s0,sp,64
    5d1e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5d20:	c299                	beqz	a3,5d26 <printint+0x12>
    5d22:	0805cb63          	bltz	a1,5db8 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5d26:	2581                	sext.w	a1,a1
  neg = 0;
    5d28:	4881                	li	a7,0
    5d2a:	fc040693          	add	a3,s0,-64
  }

  i = 0;
    5d2e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5d30:	2601                	sext.w	a2,a2
    5d32:	00003517          	auipc	a0,0x3
    5d36:	92650513          	add	a0,a0,-1754 # 8658 <digits>
    5d3a:	883a                	mv	a6,a4
    5d3c:	2705                	addw	a4,a4,1
    5d3e:	02c5f7bb          	remuw	a5,a1,a2
    5d42:	1782                	sll	a5,a5,0x20
    5d44:	9381                	srl	a5,a5,0x20
    5d46:	97aa                	add	a5,a5,a0
    5d48:	0007c783          	lbu	a5,0(a5)
    5d4c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5d50:	0005879b          	sext.w	a5,a1
    5d54:	02c5d5bb          	divuw	a1,a1,a2
    5d58:	0685                	add	a3,a3,1
    5d5a:	fec7f0e3          	bgeu	a5,a2,5d3a <printint+0x26>
  if(neg)
    5d5e:	00088c63          	beqz	a7,5d76 <printint+0x62>
    buf[i++] = '-';
    5d62:	fd070793          	add	a5,a4,-48
    5d66:	00878733          	add	a4,a5,s0
    5d6a:	02d00793          	li	a5,45
    5d6e:	fef70823          	sb	a5,-16(a4)
    5d72:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    5d76:	02e05c63          	blez	a4,5dae <printint+0x9a>
    5d7a:	f04a                	sd	s2,32(sp)
    5d7c:	ec4e                	sd	s3,24(sp)
    5d7e:	fc040793          	add	a5,s0,-64
    5d82:	00e78933          	add	s2,a5,a4
    5d86:	fff78993          	add	s3,a5,-1
    5d8a:	99ba                	add	s3,s3,a4
    5d8c:	377d                	addw	a4,a4,-1
    5d8e:	1702                	sll	a4,a4,0x20
    5d90:	9301                	srl	a4,a4,0x20
    5d92:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5d96:	fff94583          	lbu	a1,-1(s2)
    5d9a:	8526                	mv	a0,s1
    5d9c:	00000097          	auipc	ra,0x0
    5da0:	f56080e7          	jalr	-170(ra) # 5cf2 <putc>
  while(--i >= 0)
    5da4:	197d                	add	s2,s2,-1
    5da6:	ff3918e3          	bne	s2,s3,5d96 <printint+0x82>
    5daa:	7902                	ld	s2,32(sp)
    5dac:	69e2                	ld	s3,24(sp)
}
    5dae:	70e2                	ld	ra,56(sp)
    5db0:	7442                	ld	s0,48(sp)
    5db2:	74a2                	ld	s1,40(sp)
    5db4:	6121                	add	sp,sp,64
    5db6:	8082                	ret
    x = -xx;
    5db8:	40b005bb          	negw	a1,a1
    neg = 1;
    5dbc:	4885                	li	a7,1
    x = -xx;
    5dbe:	b7b5                	j	5d2a <printint+0x16>

0000000000005dc0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5dc0:	715d                	add	sp,sp,-80
    5dc2:	e486                	sd	ra,72(sp)
    5dc4:	e0a2                	sd	s0,64(sp)
    5dc6:	f84a                	sd	s2,48(sp)
    5dc8:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5dca:	0005c903          	lbu	s2,0(a1)
    5dce:	1a090a63          	beqz	s2,5f82 <vprintf+0x1c2>
    5dd2:	fc26                	sd	s1,56(sp)
    5dd4:	f44e                	sd	s3,40(sp)
    5dd6:	f052                	sd	s4,32(sp)
    5dd8:	ec56                	sd	s5,24(sp)
    5dda:	e85a                	sd	s6,16(sp)
    5ddc:	e45e                	sd	s7,8(sp)
    5dde:	8aaa                	mv	s5,a0
    5de0:	8bb2                	mv	s7,a2
    5de2:	00158493          	add	s1,a1,1
  state = 0;
    5de6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5de8:	02500a13          	li	s4,37
    5dec:	4b55                	li	s6,21
    5dee:	a839                	j	5e0c <vprintf+0x4c>
        putc(fd, c);
    5df0:	85ca                	mv	a1,s2
    5df2:	8556                	mv	a0,s5
    5df4:	00000097          	auipc	ra,0x0
    5df8:	efe080e7          	jalr	-258(ra) # 5cf2 <putc>
    5dfc:	a019                	j	5e02 <vprintf+0x42>
    } else if(state == '%'){
    5dfe:	01498d63          	beq	s3,s4,5e18 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    5e02:	0485                	add	s1,s1,1
    5e04:	fff4c903          	lbu	s2,-1(s1)
    5e08:	16090763          	beqz	s2,5f76 <vprintf+0x1b6>
    if(state == 0){
    5e0c:	fe0999e3          	bnez	s3,5dfe <vprintf+0x3e>
      if(c == '%'){
    5e10:	ff4910e3          	bne	s2,s4,5df0 <vprintf+0x30>
        state = '%';
    5e14:	89d2                	mv	s3,s4
    5e16:	b7f5                	j	5e02 <vprintf+0x42>
      if(c == 'd'){
    5e18:	13490463          	beq	s2,s4,5f40 <vprintf+0x180>
    5e1c:	f9d9079b          	addw	a5,s2,-99
    5e20:	0ff7f793          	zext.b	a5,a5
    5e24:	12fb6763          	bltu	s6,a5,5f52 <vprintf+0x192>
    5e28:	f9d9079b          	addw	a5,s2,-99
    5e2c:	0ff7f713          	zext.b	a4,a5
    5e30:	12eb6163          	bltu	s6,a4,5f52 <vprintf+0x192>
    5e34:	00271793          	sll	a5,a4,0x2
    5e38:	00002717          	auipc	a4,0x2
    5e3c:	7c870713          	add	a4,a4,1992 # 8600 <malloc+0x258e>
    5e40:	97ba                	add	a5,a5,a4
    5e42:	439c                	lw	a5,0(a5)
    5e44:	97ba                	add	a5,a5,a4
    5e46:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5e48:	008b8913          	add	s2,s7,8
    5e4c:	4685                	li	a3,1
    5e4e:	4629                	li	a2,10
    5e50:	000ba583          	lw	a1,0(s7)
    5e54:	8556                	mv	a0,s5
    5e56:	00000097          	auipc	ra,0x0
    5e5a:	ebe080e7          	jalr	-322(ra) # 5d14 <printint>
    5e5e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5e60:	4981                	li	s3,0
    5e62:	b745                	j	5e02 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5e64:	008b8913          	add	s2,s7,8
    5e68:	4681                	li	a3,0
    5e6a:	4629                	li	a2,10
    5e6c:	000ba583          	lw	a1,0(s7)
    5e70:	8556                	mv	a0,s5
    5e72:	00000097          	auipc	ra,0x0
    5e76:	ea2080e7          	jalr	-350(ra) # 5d14 <printint>
    5e7a:	8bca                	mv	s7,s2
      state = 0;
    5e7c:	4981                	li	s3,0
    5e7e:	b751                	j	5e02 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    5e80:	008b8913          	add	s2,s7,8
    5e84:	4681                	li	a3,0
    5e86:	4641                	li	a2,16
    5e88:	000ba583          	lw	a1,0(s7)
    5e8c:	8556                	mv	a0,s5
    5e8e:	00000097          	auipc	ra,0x0
    5e92:	e86080e7          	jalr	-378(ra) # 5d14 <printint>
    5e96:	8bca                	mv	s7,s2
      state = 0;
    5e98:	4981                	li	s3,0
    5e9a:	b7a5                	j	5e02 <vprintf+0x42>
    5e9c:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    5e9e:	008b8c13          	add	s8,s7,8
    5ea2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5ea6:	03000593          	li	a1,48
    5eaa:	8556                	mv	a0,s5
    5eac:	00000097          	auipc	ra,0x0
    5eb0:	e46080e7          	jalr	-442(ra) # 5cf2 <putc>
  putc(fd, 'x');
    5eb4:	07800593          	li	a1,120
    5eb8:	8556                	mv	a0,s5
    5eba:	00000097          	auipc	ra,0x0
    5ebe:	e38080e7          	jalr	-456(ra) # 5cf2 <putc>
    5ec2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5ec4:	00002b97          	auipc	s7,0x2
    5ec8:	794b8b93          	add	s7,s7,1940 # 8658 <digits>
    5ecc:	03c9d793          	srl	a5,s3,0x3c
    5ed0:	97de                	add	a5,a5,s7
    5ed2:	0007c583          	lbu	a1,0(a5)
    5ed6:	8556                	mv	a0,s5
    5ed8:	00000097          	auipc	ra,0x0
    5edc:	e1a080e7          	jalr	-486(ra) # 5cf2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5ee0:	0992                	sll	s3,s3,0x4
    5ee2:	397d                	addw	s2,s2,-1
    5ee4:	fe0914e3          	bnez	s2,5ecc <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    5ee8:	8be2                	mv	s7,s8
      state = 0;
    5eea:	4981                	li	s3,0
    5eec:	6c02                	ld	s8,0(sp)
    5eee:	bf11                	j	5e02 <vprintf+0x42>
        s = va_arg(ap, char*);
    5ef0:	008b8993          	add	s3,s7,8
    5ef4:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    5ef8:	02090163          	beqz	s2,5f1a <vprintf+0x15a>
        while(*s != 0){
    5efc:	00094583          	lbu	a1,0(s2)
    5f00:	c9a5                	beqz	a1,5f70 <vprintf+0x1b0>
          putc(fd, *s);
    5f02:	8556                	mv	a0,s5
    5f04:	00000097          	auipc	ra,0x0
    5f08:	dee080e7          	jalr	-530(ra) # 5cf2 <putc>
          s++;
    5f0c:	0905                	add	s2,s2,1
        while(*s != 0){
    5f0e:	00094583          	lbu	a1,0(s2)
    5f12:	f9e5                	bnez	a1,5f02 <vprintf+0x142>
        s = va_arg(ap, char*);
    5f14:	8bce                	mv	s7,s3
      state = 0;
    5f16:	4981                	li	s3,0
    5f18:	b5ed                	j	5e02 <vprintf+0x42>
          s = "(null)";
    5f1a:	00002917          	auipc	s2,0x2
    5f1e:	6be90913          	add	s2,s2,1726 # 85d8 <malloc+0x2566>
        while(*s != 0){
    5f22:	02800593          	li	a1,40
    5f26:	bff1                	j	5f02 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    5f28:	008b8913          	add	s2,s7,8
    5f2c:	000bc583          	lbu	a1,0(s7)
    5f30:	8556                	mv	a0,s5
    5f32:	00000097          	auipc	ra,0x0
    5f36:	dc0080e7          	jalr	-576(ra) # 5cf2 <putc>
    5f3a:	8bca                	mv	s7,s2
      state = 0;
    5f3c:	4981                	li	s3,0
    5f3e:	b5d1                	j	5e02 <vprintf+0x42>
        putc(fd, c);
    5f40:	02500593          	li	a1,37
    5f44:	8556                	mv	a0,s5
    5f46:	00000097          	auipc	ra,0x0
    5f4a:	dac080e7          	jalr	-596(ra) # 5cf2 <putc>
      state = 0;
    5f4e:	4981                	li	s3,0
    5f50:	bd4d                	j	5e02 <vprintf+0x42>
        putc(fd, '%');
    5f52:	02500593          	li	a1,37
    5f56:	8556                	mv	a0,s5
    5f58:	00000097          	auipc	ra,0x0
    5f5c:	d9a080e7          	jalr	-614(ra) # 5cf2 <putc>
        putc(fd, c);
    5f60:	85ca                	mv	a1,s2
    5f62:	8556                	mv	a0,s5
    5f64:	00000097          	auipc	ra,0x0
    5f68:	d8e080e7          	jalr	-626(ra) # 5cf2 <putc>
      state = 0;
    5f6c:	4981                	li	s3,0
    5f6e:	bd51                	j	5e02 <vprintf+0x42>
        s = va_arg(ap, char*);
    5f70:	8bce                	mv	s7,s3
      state = 0;
    5f72:	4981                	li	s3,0
    5f74:	b579                	j	5e02 <vprintf+0x42>
    5f76:	74e2                	ld	s1,56(sp)
    5f78:	79a2                	ld	s3,40(sp)
    5f7a:	7a02                	ld	s4,32(sp)
    5f7c:	6ae2                	ld	s5,24(sp)
    5f7e:	6b42                	ld	s6,16(sp)
    5f80:	6ba2                	ld	s7,8(sp)
    }
  }
}
    5f82:	60a6                	ld	ra,72(sp)
    5f84:	6406                	ld	s0,64(sp)
    5f86:	7942                	ld	s2,48(sp)
    5f88:	6161                	add	sp,sp,80
    5f8a:	8082                	ret

0000000000005f8c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5f8c:	715d                	add	sp,sp,-80
    5f8e:	ec06                	sd	ra,24(sp)
    5f90:	e822                	sd	s0,16(sp)
    5f92:	1000                	add	s0,sp,32
    5f94:	e010                	sd	a2,0(s0)
    5f96:	e414                	sd	a3,8(s0)
    5f98:	e818                	sd	a4,16(s0)
    5f9a:	ec1c                	sd	a5,24(s0)
    5f9c:	03043023          	sd	a6,32(s0)
    5fa0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5fa4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5fa8:	8622                	mv	a2,s0
    5faa:	00000097          	auipc	ra,0x0
    5fae:	e16080e7          	jalr	-490(ra) # 5dc0 <vprintf>
}
    5fb2:	60e2                	ld	ra,24(sp)
    5fb4:	6442                	ld	s0,16(sp)
    5fb6:	6161                	add	sp,sp,80
    5fb8:	8082                	ret

0000000000005fba <printf>:

void
printf(const char *fmt, ...)
{
    5fba:	711d                	add	sp,sp,-96
    5fbc:	ec06                	sd	ra,24(sp)
    5fbe:	e822                	sd	s0,16(sp)
    5fc0:	1000                	add	s0,sp,32
    5fc2:	e40c                	sd	a1,8(s0)
    5fc4:	e810                	sd	a2,16(s0)
    5fc6:	ec14                	sd	a3,24(s0)
    5fc8:	f018                	sd	a4,32(s0)
    5fca:	f41c                	sd	a5,40(s0)
    5fcc:	03043823          	sd	a6,48(s0)
    5fd0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5fd4:	00840613          	add	a2,s0,8
    5fd8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5fdc:	85aa                	mv	a1,a0
    5fde:	4505                	li	a0,1
    5fe0:	00000097          	auipc	ra,0x0
    5fe4:	de0080e7          	jalr	-544(ra) # 5dc0 <vprintf>
}
    5fe8:	60e2                	ld	ra,24(sp)
    5fea:	6442                	ld	s0,16(sp)
    5fec:	6125                	add	sp,sp,96
    5fee:	8082                	ret

0000000000005ff0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5ff0:	1141                	add	sp,sp,-16
    5ff2:	e422                	sd	s0,8(sp)
    5ff4:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5ff6:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5ffa:	00005797          	auipc	a5,0x5
    5ffe:	8167b783          	ld	a5,-2026(a5) # a810 <freep>
    6002:	a02d                	j	602c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    6004:	4618                	lw	a4,8(a2)
    6006:	9f2d                	addw	a4,a4,a1
    6008:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    600c:	6398                	ld	a4,0(a5)
    600e:	6310                	ld	a2,0(a4)
    6010:	a83d                	j	604e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    6012:	ff852703          	lw	a4,-8(a0)
    6016:	9f31                	addw	a4,a4,a2
    6018:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    601a:	ff053683          	ld	a3,-16(a0)
    601e:	a091                	j	6062 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6020:	6398                	ld	a4,0(a5)
    6022:	00e7e463          	bltu	a5,a4,602a <free+0x3a>
    6026:	00e6ea63          	bltu	a3,a4,603a <free+0x4a>
{
    602a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    602c:	fed7fae3          	bgeu	a5,a3,6020 <free+0x30>
    6030:	6398                	ld	a4,0(a5)
    6032:	00e6e463          	bltu	a3,a4,603a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6036:	fee7eae3          	bltu	a5,a4,602a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    603a:	ff852583          	lw	a1,-8(a0)
    603e:	6390                	ld	a2,0(a5)
    6040:	02059813          	sll	a6,a1,0x20
    6044:	01c85713          	srl	a4,a6,0x1c
    6048:	9736                	add	a4,a4,a3
    604a:	fae60de3          	beq	a2,a4,6004 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    604e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    6052:	4790                	lw	a2,8(a5)
    6054:	02061593          	sll	a1,a2,0x20
    6058:	01c5d713          	srl	a4,a1,0x1c
    605c:	973e                	add	a4,a4,a5
    605e:	fae68ae3          	beq	a3,a4,6012 <free+0x22>
    p->s.ptr = bp->s.ptr;
    6062:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    6064:	00004717          	auipc	a4,0x4
    6068:	7af73623          	sd	a5,1964(a4) # a810 <freep>
}
    606c:	6422                	ld	s0,8(sp)
    606e:	0141                	add	sp,sp,16
    6070:	8082                	ret

0000000000006072 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    6072:	7139                	add	sp,sp,-64
    6074:	fc06                	sd	ra,56(sp)
    6076:	f822                	sd	s0,48(sp)
    6078:	f426                	sd	s1,40(sp)
    607a:	ec4e                	sd	s3,24(sp)
    607c:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    607e:	02051493          	sll	s1,a0,0x20
    6082:	9081                	srl	s1,s1,0x20
    6084:	04bd                	add	s1,s1,15
    6086:	8091                	srl	s1,s1,0x4
    6088:	0014899b          	addw	s3,s1,1
    608c:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    608e:	00004517          	auipc	a0,0x4
    6092:	78253503          	ld	a0,1922(a0) # a810 <freep>
    6096:	c915                	beqz	a0,60ca <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6098:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    609a:	4798                	lw	a4,8(a5)
    609c:	08977e63          	bgeu	a4,s1,6138 <malloc+0xc6>
    60a0:	f04a                	sd	s2,32(sp)
    60a2:	e852                	sd	s4,16(sp)
    60a4:	e456                	sd	s5,8(sp)
    60a6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    60a8:	8a4e                	mv	s4,s3
    60aa:	0009871b          	sext.w	a4,s3
    60ae:	6685                	lui	a3,0x1
    60b0:	00d77363          	bgeu	a4,a3,60b6 <malloc+0x44>
    60b4:	6a05                	lui	s4,0x1
    60b6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    60ba:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    60be:	00004917          	auipc	s2,0x4
    60c2:	75290913          	add	s2,s2,1874 # a810 <freep>
  if(p == (char*)-1)
    60c6:	5afd                	li	s5,-1
    60c8:	a091                	j	610c <malloc+0x9a>
    60ca:	f04a                	sd	s2,32(sp)
    60cc:	e852                	sd	s4,16(sp)
    60ce:	e456                	sd	s5,8(sp)
    60d0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    60d2:	0000b797          	auipc	a5,0xb
    60d6:	f6678793          	add	a5,a5,-154 # 11038 <base>
    60da:	00004717          	auipc	a4,0x4
    60de:	72f73b23          	sd	a5,1846(a4) # a810 <freep>
    60e2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    60e4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    60e8:	b7c1                	j	60a8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    60ea:	6398                	ld	a4,0(a5)
    60ec:	e118                	sd	a4,0(a0)
    60ee:	a08d                	j	6150 <malloc+0xde>
  hp->s.size = nu;
    60f0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    60f4:	0541                	add	a0,a0,16
    60f6:	00000097          	auipc	ra,0x0
    60fa:	efa080e7          	jalr	-262(ra) # 5ff0 <free>
  return freep;
    60fe:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    6102:	c13d                	beqz	a0,6168 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6104:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6106:	4798                	lw	a4,8(a5)
    6108:	02977463          	bgeu	a4,s1,6130 <malloc+0xbe>
    if(p == freep)
    610c:	00093703          	ld	a4,0(s2)
    6110:	853e                	mv	a0,a5
    6112:	fef719e3          	bne	a4,a5,6104 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    6116:	8552                	mv	a0,s4
    6118:	00000097          	auipc	ra,0x0
    611c:	bb2080e7          	jalr	-1102(ra) # 5cca <sbrk>
  if(p == (char*)-1)
    6120:	fd5518e3          	bne	a0,s5,60f0 <malloc+0x7e>
        return 0;
    6124:	4501                	li	a0,0
    6126:	7902                	ld	s2,32(sp)
    6128:	6a42                	ld	s4,16(sp)
    612a:	6aa2                	ld	s5,8(sp)
    612c:	6b02                	ld	s6,0(sp)
    612e:	a03d                	j	615c <malloc+0xea>
    6130:	7902                	ld	s2,32(sp)
    6132:	6a42                	ld	s4,16(sp)
    6134:	6aa2                	ld	s5,8(sp)
    6136:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    6138:	fae489e3          	beq	s1,a4,60ea <malloc+0x78>
        p->s.size -= nunits;
    613c:	4137073b          	subw	a4,a4,s3
    6140:	c798                	sw	a4,8(a5)
        p += p->s.size;
    6142:	02071693          	sll	a3,a4,0x20
    6146:	01c6d713          	srl	a4,a3,0x1c
    614a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    614c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    6150:	00004717          	auipc	a4,0x4
    6154:	6ca73023          	sd	a0,1728(a4) # a810 <freep>
      return (void*)(p + 1);
    6158:	01078513          	add	a0,a5,16
  }
}
    615c:	70e2                	ld	ra,56(sp)
    615e:	7442                	ld	s0,48(sp)
    6160:	74a2                	ld	s1,40(sp)
    6162:	69e2                	ld	s3,24(sp)
    6164:	6121                	add	sp,sp,64
    6166:	8082                	ret
    6168:	7902                	ld	s2,32(sp)
    616a:	6a42                	ld	s4,16(sp)
    616c:	6aa2                	ld	s5,8(sp)
    616e:	6b02                	ld	s6,0(sp)
    6170:	b7f5                	j	615c <malloc+0xea>
