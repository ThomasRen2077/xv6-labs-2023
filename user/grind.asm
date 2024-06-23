
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	add	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	add	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xor	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	add	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	add	a3,a3,797 # 1f31d <base+0x1ca65>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	add	a2,a2,423 # 41a7 <base+0x18ef>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	add	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffcc34>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	add	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	add	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	add	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	add	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	45050513          	add	a0,a0,1104 # 24b0 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	add	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7159                	add	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	fc56                	sd	s5,56(sp)
      82:	1880                	add	s0,sp,112
      84:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      86:	4501                	li	a0,0
      88:	00001097          	auipc	ra,0x1
      8c:	e56080e7          	jalr	-426(ra) # ede <sbrk>
      90:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      92:	00001517          	auipc	a0,0x1
      96:	2fe50513          	add	a0,a0,766 # 1390 <malloc+0x10a>
      9a:	00001097          	auipc	ra,0x1
      9e:	e24080e7          	jalr	-476(ra) # ebe <mkdir>
  if(chdir("grindir") != 0){
      a2:	00001517          	auipc	a0,0x1
      a6:	2ee50513          	add	a0,a0,750 # 1390 <malloc+0x10a>
      aa:	00001097          	auipc	ra,0x1
      ae:	e1c080e7          	jalr	-484(ra) # ec6 <chdir>
      b2:	c115                	beqz	a0,d6 <go+0x5e>
      b4:	e8ca                	sd	s2,80(sp)
      b6:	e4ce                	sd	s3,72(sp)
      b8:	e0d2                	sd	s4,64(sp)
      ba:	f85a                	sd	s6,48(sp)
    printf("grind: chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	2dc50513          	add	a0,a0,732 # 1398 <malloc+0x112>
      c4:	00001097          	auipc	ra,0x1
      c8:	10a080e7          	jalr	266(ra) # 11ce <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	d88080e7          	jalr	-632(ra) # e56 <exit>
      d6:	e8ca                	sd	s2,80(sp)
      d8:	e4ce                	sd	s3,72(sp)
      da:	e0d2                	sd	s4,64(sp)
      dc:	f85a                	sd	s6,48(sp)
  }
  chdir("/");
      de:	00001517          	auipc	a0,0x1
      e2:	2e250513          	add	a0,a0,738 # 13c0 <malloc+0x13a>
      e6:	00001097          	auipc	ra,0x1
      ea:	de0080e7          	jalr	-544(ra) # ec6 <chdir>
      ee:	00001997          	auipc	s3,0x1
      f2:	2e298993          	add	s3,s3,738 # 13d0 <malloc+0x14a>
      f6:	c489                	beqz	s1,100 <go+0x88>
      f8:	00001997          	auipc	s3,0x1
      fc:	2d098993          	add	s3,s3,720 # 13c8 <malloc+0x142>
  uint64 iters = 0;
     100:	4481                	li	s1,0
  int fd = -1;
     102:	5a7d                	li	s4,-1
     104:	00001917          	auipc	s2,0x1
     108:	59c90913          	add	s2,s2,1436 # 16a0 <malloc+0x41a>
     10c:	a839                	j	12a <go+0xb2>
    iters++;
    if((iters % 500) == 0)
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
     10e:	20200593          	li	a1,514
     112:	00001517          	auipc	a0,0x1
     116:	2c650513          	add	a0,a0,710 # 13d8 <malloc+0x152>
     11a:	00001097          	auipc	ra,0x1
     11e:	d7c080e7          	jalr	-644(ra) # e96 <open>
     122:	00001097          	auipc	ra,0x1
     126:	d5c080e7          	jalr	-676(ra) # e7e <close>
    iters++;
     12a:	0485                	add	s1,s1,1
    if((iters % 500) == 0)
     12c:	1f400793          	li	a5,500
     130:	02f4f7b3          	remu	a5,s1,a5
     134:	eb81                	bnez	a5,144 <go+0xcc>
      write(1, which_child?"B":"A", 1);
     136:	4605                	li	a2,1
     138:	85ce                	mv	a1,s3
     13a:	4505                	li	a0,1
     13c:	00001097          	auipc	ra,0x1
     140:	d3a080e7          	jalr	-710(ra) # e76 <write>
    int what = rand() % 23;
     144:	00000097          	auipc	ra,0x0
     148:	f14080e7          	jalr	-236(ra) # 58 <rand>
     14c:	47dd                	li	a5,23
     14e:	02f5653b          	remw	a0,a0,a5
     152:	0005071b          	sext.w	a4,a0
     156:	47d9                	li	a5,22
     158:	fce7e9e3          	bltu	a5,a4,12a <go+0xb2>
     15c:	02051793          	sll	a5,a0,0x20
     160:	01e7d513          	srl	a0,a5,0x1e
     164:	954a                	add	a0,a0,s2
     166:	411c                	lw	a5,0(a0)
     168:	97ca                	add	a5,a5,s2
     16a:	8782                	jr	a5
    } else if(what == 2){
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     16c:	20200593          	li	a1,514
     170:	00001517          	auipc	a0,0x1
     174:	27850513          	add	a0,a0,632 # 13e8 <malloc+0x162>
     178:	00001097          	auipc	ra,0x1
     17c:	d1e080e7          	jalr	-738(ra) # e96 <open>
     180:	00001097          	auipc	ra,0x1
     184:	cfe080e7          	jalr	-770(ra) # e7e <close>
     188:	b74d                	j	12a <go+0xb2>
    } else if(what == 3){
      unlink("grindir/../a");
     18a:	00001517          	auipc	a0,0x1
     18e:	24e50513          	add	a0,a0,590 # 13d8 <malloc+0x152>
     192:	00001097          	auipc	ra,0x1
     196:	d14080e7          	jalr	-748(ra) # ea6 <unlink>
     19a:	bf41                	j	12a <go+0xb2>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     19c:	00001517          	auipc	a0,0x1
     1a0:	1f450513          	add	a0,a0,500 # 1390 <malloc+0x10a>
     1a4:	00001097          	auipc	ra,0x1
     1a8:	d22080e7          	jalr	-734(ra) # ec6 <chdir>
     1ac:	e115                	bnez	a0,1d0 <go+0x158>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     1ae:	00001517          	auipc	a0,0x1
     1b2:	25250513          	add	a0,a0,594 # 1400 <malloc+0x17a>
     1b6:	00001097          	auipc	ra,0x1
     1ba:	cf0080e7          	jalr	-784(ra) # ea6 <unlink>
      chdir("/");
     1be:	00001517          	auipc	a0,0x1
     1c2:	20250513          	add	a0,a0,514 # 13c0 <malloc+0x13a>
     1c6:	00001097          	auipc	ra,0x1
     1ca:	d00080e7          	jalr	-768(ra) # ec6 <chdir>
     1ce:	bfb1                	j	12a <go+0xb2>
        printf("grind: chdir grindir failed\n");
     1d0:	00001517          	auipc	a0,0x1
     1d4:	1c850513          	add	a0,a0,456 # 1398 <malloc+0x112>
     1d8:	00001097          	auipc	ra,0x1
     1dc:	ff6080e7          	jalr	-10(ra) # 11ce <printf>
        exit(1);
     1e0:	4505                	li	a0,1
     1e2:	00001097          	auipc	ra,0x1
     1e6:	c74080e7          	jalr	-908(ra) # e56 <exit>
    } else if(what == 5){
      close(fd);
     1ea:	8552                	mv	a0,s4
     1ec:	00001097          	auipc	ra,0x1
     1f0:	c92080e7          	jalr	-878(ra) # e7e <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1f4:	20200593          	li	a1,514
     1f8:	00001517          	auipc	a0,0x1
     1fc:	21050513          	add	a0,a0,528 # 1408 <malloc+0x182>
     200:	00001097          	auipc	ra,0x1
     204:	c96080e7          	jalr	-874(ra) # e96 <open>
     208:	8a2a                	mv	s4,a0
     20a:	b705                	j	12a <go+0xb2>
    } else if(what == 6){
      close(fd);
     20c:	8552                	mv	a0,s4
     20e:	00001097          	auipc	ra,0x1
     212:	c70080e7          	jalr	-912(ra) # e7e <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     216:	20200593          	li	a1,514
     21a:	00001517          	auipc	a0,0x1
     21e:	1fe50513          	add	a0,a0,510 # 1418 <malloc+0x192>
     222:	00001097          	auipc	ra,0x1
     226:	c74080e7          	jalr	-908(ra) # e96 <open>
     22a:	8a2a                	mv	s4,a0
     22c:	bdfd                	j	12a <go+0xb2>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     22e:	3e700613          	li	a2,999
     232:	00002597          	auipc	a1,0x2
     236:	29e58593          	add	a1,a1,670 # 24d0 <buf.0>
     23a:	8552                	mv	a0,s4
     23c:	00001097          	auipc	ra,0x1
     240:	c3a080e7          	jalr	-966(ra) # e76 <write>
     244:	b5dd                	j	12a <go+0xb2>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     246:	3e700613          	li	a2,999
     24a:	00002597          	auipc	a1,0x2
     24e:	28658593          	add	a1,a1,646 # 24d0 <buf.0>
     252:	8552                	mv	a0,s4
     254:	00001097          	auipc	ra,0x1
     258:	c1a080e7          	jalr	-998(ra) # e6e <read>
     25c:	b5f9                	j	12a <go+0xb2>
    } else if(what == 9){
      mkdir("grindir/../a");
     25e:	00001517          	auipc	a0,0x1
     262:	17a50513          	add	a0,a0,378 # 13d8 <malloc+0x152>
     266:	00001097          	auipc	ra,0x1
     26a:	c58080e7          	jalr	-936(ra) # ebe <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     26e:	20200593          	li	a1,514
     272:	00001517          	auipc	a0,0x1
     276:	1be50513          	add	a0,a0,446 # 1430 <malloc+0x1aa>
     27a:	00001097          	auipc	ra,0x1
     27e:	c1c080e7          	jalr	-996(ra) # e96 <open>
     282:	00001097          	auipc	ra,0x1
     286:	bfc080e7          	jalr	-1028(ra) # e7e <close>
      unlink("a/a");
     28a:	00001517          	auipc	a0,0x1
     28e:	1b650513          	add	a0,a0,438 # 1440 <malloc+0x1ba>
     292:	00001097          	auipc	ra,0x1
     296:	c14080e7          	jalr	-1004(ra) # ea6 <unlink>
     29a:	bd41                	j	12a <go+0xb2>
    } else if(what == 10){
      mkdir("/../b");
     29c:	00001517          	auipc	a0,0x1
     2a0:	1ac50513          	add	a0,a0,428 # 1448 <malloc+0x1c2>
     2a4:	00001097          	auipc	ra,0x1
     2a8:	c1a080e7          	jalr	-998(ra) # ebe <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     2ac:	20200593          	li	a1,514
     2b0:	00001517          	auipc	a0,0x1
     2b4:	1a050513          	add	a0,a0,416 # 1450 <malloc+0x1ca>
     2b8:	00001097          	auipc	ra,0x1
     2bc:	bde080e7          	jalr	-1058(ra) # e96 <open>
     2c0:	00001097          	auipc	ra,0x1
     2c4:	bbe080e7          	jalr	-1090(ra) # e7e <close>
      unlink("b/b");
     2c8:	00001517          	auipc	a0,0x1
     2cc:	19850513          	add	a0,a0,408 # 1460 <malloc+0x1da>
     2d0:	00001097          	auipc	ra,0x1
     2d4:	bd6080e7          	jalr	-1066(ra) # ea6 <unlink>
     2d8:	bd89                	j	12a <go+0xb2>
    } else if(what == 11){
      unlink("b");
     2da:	00001517          	auipc	a0,0x1
     2de:	18e50513          	add	a0,a0,398 # 1468 <malloc+0x1e2>
     2e2:	00001097          	auipc	ra,0x1
     2e6:	bc4080e7          	jalr	-1084(ra) # ea6 <unlink>
      link("../grindir/./../a", "../b");
     2ea:	00001597          	auipc	a1,0x1
     2ee:	11658593          	add	a1,a1,278 # 1400 <malloc+0x17a>
     2f2:	00001517          	auipc	a0,0x1
     2f6:	17e50513          	add	a0,a0,382 # 1470 <malloc+0x1ea>
     2fa:	00001097          	auipc	ra,0x1
     2fe:	bbc080e7          	jalr	-1092(ra) # eb6 <link>
     302:	b525                	j	12a <go+0xb2>
    } else if(what == 12){
      unlink("../grindir/../a");
     304:	00001517          	auipc	a0,0x1
     308:	18450513          	add	a0,a0,388 # 1488 <malloc+0x202>
     30c:	00001097          	auipc	ra,0x1
     310:	b9a080e7          	jalr	-1126(ra) # ea6 <unlink>
      link(".././b", "/grindir/../a");
     314:	00001597          	auipc	a1,0x1
     318:	0f458593          	add	a1,a1,244 # 1408 <malloc+0x182>
     31c:	00001517          	auipc	a0,0x1
     320:	17c50513          	add	a0,a0,380 # 1498 <malloc+0x212>
     324:	00001097          	auipc	ra,0x1
     328:	b92080e7          	jalr	-1134(ra) # eb6 <link>
     32c:	bbfd                	j	12a <go+0xb2>
    } else if(what == 13){
      int pid = fork();
     32e:	00001097          	auipc	ra,0x1
     332:	b20080e7          	jalr	-1248(ra) # e4e <fork>
      if(pid == 0){
     336:	c909                	beqz	a0,348 <go+0x2d0>
        exit(0);
      } else if(pid < 0){
     338:	00054c63          	bltz	a0,350 <go+0x2d8>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     33c:	4501                	li	a0,0
     33e:	00001097          	auipc	ra,0x1
     342:	b20080e7          	jalr	-1248(ra) # e5e <wait>
     346:	b3d5                	j	12a <go+0xb2>
        exit(0);
     348:	00001097          	auipc	ra,0x1
     34c:	b0e080e7          	jalr	-1266(ra) # e56 <exit>
        printf("grind: fork failed\n");
     350:	00001517          	auipc	a0,0x1
     354:	15050513          	add	a0,a0,336 # 14a0 <malloc+0x21a>
     358:	00001097          	auipc	ra,0x1
     35c:	e76080e7          	jalr	-394(ra) # 11ce <printf>
        exit(1);
     360:	4505                	li	a0,1
     362:	00001097          	auipc	ra,0x1
     366:	af4080e7          	jalr	-1292(ra) # e56 <exit>
    } else if(what == 14){
      int pid = fork();
     36a:	00001097          	auipc	ra,0x1
     36e:	ae4080e7          	jalr	-1308(ra) # e4e <fork>
      if(pid == 0){
     372:	c909                	beqz	a0,384 <go+0x30c>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     374:	02054563          	bltz	a0,39e <go+0x326>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     378:	4501                	li	a0,0
     37a:	00001097          	auipc	ra,0x1
     37e:	ae4080e7          	jalr	-1308(ra) # e5e <wait>
     382:	b365                	j	12a <go+0xb2>
        fork();
     384:	00001097          	auipc	ra,0x1
     388:	aca080e7          	jalr	-1334(ra) # e4e <fork>
        fork();
     38c:	00001097          	auipc	ra,0x1
     390:	ac2080e7          	jalr	-1342(ra) # e4e <fork>
        exit(0);
     394:	4501                	li	a0,0
     396:	00001097          	auipc	ra,0x1
     39a:	ac0080e7          	jalr	-1344(ra) # e56 <exit>
        printf("grind: fork failed\n");
     39e:	00001517          	auipc	a0,0x1
     3a2:	10250513          	add	a0,a0,258 # 14a0 <malloc+0x21a>
     3a6:	00001097          	auipc	ra,0x1
     3aa:	e28080e7          	jalr	-472(ra) # 11ce <printf>
        exit(1);
     3ae:	4505                	li	a0,1
     3b0:	00001097          	auipc	ra,0x1
     3b4:	aa6080e7          	jalr	-1370(ra) # e56 <exit>
    } else if(what == 15){
      sbrk(6011);
     3b8:	6505                	lui	a0,0x1
     3ba:	77b50513          	add	a0,a0,1915 # 177b <digits+0x23>
     3be:	00001097          	auipc	ra,0x1
     3c2:	b20080e7          	jalr	-1248(ra) # ede <sbrk>
     3c6:	b395                	j	12a <go+0xb2>
    } else if(what == 16){
      if(sbrk(0) > break0)
     3c8:	4501                	li	a0,0
     3ca:	00001097          	auipc	ra,0x1
     3ce:	b14080e7          	jalr	-1260(ra) # ede <sbrk>
     3d2:	d4aafce3          	bgeu	s5,a0,12a <go+0xb2>
        sbrk(-(sbrk(0) - break0));
     3d6:	4501                	li	a0,0
     3d8:	00001097          	auipc	ra,0x1
     3dc:	b06080e7          	jalr	-1274(ra) # ede <sbrk>
     3e0:	40aa853b          	subw	a0,s5,a0
     3e4:	00001097          	auipc	ra,0x1
     3e8:	afa080e7          	jalr	-1286(ra) # ede <sbrk>
     3ec:	bb3d                	j	12a <go+0xb2>
    } else if(what == 17){
      int pid = fork();
     3ee:	00001097          	auipc	ra,0x1
     3f2:	a60080e7          	jalr	-1440(ra) # e4e <fork>
     3f6:	8b2a                	mv	s6,a0
      if(pid == 0){
     3f8:	c51d                	beqz	a0,426 <go+0x3ae>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     3fa:	04054963          	bltz	a0,44c <go+0x3d4>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     3fe:	00001517          	auipc	a0,0x1
     402:	0c250513          	add	a0,a0,194 # 14c0 <malloc+0x23a>
     406:	00001097          	auipc	ra,0x1
     40a:	ac0080e7          	jalr	-1344(ra) # ec6 <chdir>
     40e:	ed21                	bnez	a0,466 <go+0x3ee>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     410:	855a                	mv	a0,s6
     412:	00001097          	auipc	ra,0x1
     416:	a74080e7          	jalr	-1420(ra) # e86 <kill>
      wait(0);
     41a:	4501                	li	a0,0
     41c:	00001097          	auipc	ra,0x1
     420:	a42080e7          	jalr	-1470(ra) # e5e <wait>
     424:	b319                	j	12a <go+0xb2>
        close(open("a", O_CREATE|O_RDWR));
     426:	20200593          	li	a1,514
     42a:	00001517          	auipc	a0,0x1
     42e:	08e50513          	add	a0,a0,142 # 14b8 <malloc+0x232>
     432:	00001097          	auipc	ra,0x1
     436:	a64080e7          	jalr	-1436(ra) # e96 <open>
     43a:	00001097          	auipc	ra,0x1
     43e:	a44080e7          	jalr	-1468(ra) # e7e <close>
        exit(0);
     442:	4501                	li	a0,0
     444:	00001097          	auipc	ra,0x1
     448:	a12080e7          	jalr	-1518(ra) # e56 <exit>
        printf("grind: fork failed\n");
     44c:	00001517          	auipc	a0,0x1
     450:	05450513          	add	a0,a0,84 # 14a0 <malloc+0x21a>
     454:	00001097          	auipc	ra,0x1
     458:	d7a080e7          	jalr	-646(ra) # 11ce <printf>
        exit(1);
     45c:	4505                	li	a0,1
     45e:	00001097          	auipc	ra,0x1
     462:	9f8080e7          	jalr	-1544(ra) # e56 <exit>
        printf("grind: chdir failed\n");
     466:	00001517          	auipc	a0,0x1
     46a:	06a50513          	add	a0,a0,106 # 14d0 <malloc+0x24a>
     46e:	00001097          	auipc	ra,0x1
     472:	d60080e7          	jalr	-672(ra) # 11ce <printf>
        exit(1);
     476:	4505                	li	a0,1
     478:	00001097          	auipc	ra,0x1
     47c:	9de080e7          	jalr	-1570(ra) # e56 <exit>
    } else if(what == 18){
      int pid = fork();
     480:	00001097          	auipc	ra,0x1
     484:	9ce080e7          	jalr	-1586(ra) # e4e <fork>
      if(pid == 0){
     488:	c909                	beqz	a0,49a <go+0x422>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     48a:	02054563          	bltz	a0,4b4 <go+0x43c>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     48e:	4501                	li	a0,0
     490:	00001097          	auipc	ra,0x1
     494:	9ce080e7          	jalr	-1586(ra) # e5e <wait>
     498:	b949                	j	12a <go+0xb2>
        kill(getpid());
     49a:	00001097          	auipc	ra,0x1
     49e:	a3c080e7          	jalr	-1476(ra) # ed6 <getpid>
     4a2:	00001097          	auipc	ra,0x1
     4a6:	9e4080e7          	jalr	-1564(ra) # e86 <kill>
        exit(0);
     4aa:	4501                	li	a0,0
     4ac:	00001097          	auipc	ra,0x1
     4b0:	9aa080e7          	jalr	-1622(ra) # e56 <exit>
        printf("grind: fork failed\n");
     4b4:	00001517          	auipc	a0,0x1
     4b8:	fec50513          	add	a0,a0,-20 # 14a0 <malloc+0x21a>
     4bc:	00001097          	auipc	ra,0x1
     4c0:	d12080e7          	jalr	-750(ra) # 11ce <printf>
        exit(1);
     4c4:	4505                	li	a0,1
     4c6:	00001097          	auipc	ra,0x1
     4ca:	990080e7          	jalr	-1648(ra) # e56 <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     4ce:	fa840513          	add	a0,s0,-88
     4d2:	00001097          	auipc	ra,0x1
     4d6:	994080e7          	jalr	-1644(ra) # e66 <pipe>
     4da:	02054b63          	bltz	a0,510 <go+0x498>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     4de:	00001097          	auipc	ra,0x1
     4e2:	970080e7          	jalr	-1680(ra) # e4e <fork>
      if(pid == 0){
     4e6:	c131                	beqz	a0,52a <go+0x4b2>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     4e8:	0a054a63          	bltz	a0,59c <go+0x524>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     4ec:	fa842503          	lw	a0,-88(s0)
     4f0:	00001097          	auipc	ra,0x1
     4f4:	98e080e7          	jalr	-1650(ra) # e7e <close>
      close(fds[1]);
     4f8:	fac42503          	lw	a0,-84(s0)
     4fc:	00001097          	auipc	ra,0x1
     500:	982080e7          	jalr	-1662(ra) # e7e <close>
      wait(0);
     504:	4501                	li	a0,0
     506:	00001097          	auipc	ra,0x1
     50a:	958080e7          	jalr	-1704(ra) # e5e <wait>
     50e:	b931                	j	12a <go+0xb2>
        printf("grind: pipe failed\n");
     510:	00001517          	auipc	a0,0x1
     514:	fd850513          	add	a0,a0,-40 # 14e8 <malloc+0x262>
     518:	00001097          	auipc	ra,0x1
     51c:	cb6080e7          	jalr	-842(ra) # 11ce <printf>
        exit(1);
     520:	4505                	li	a0,1
     522:	00001097          	auipc	ra,0x1
     526:	934080e7          	jalr	-1740(ra) # e56 <exit>
        fork();
     52a:	00001097          	auipc	ra,0x1
     52e:	924080e7          	jalr	-1756(ra) # e4e <fork>
        fork();
     532:	00001097          	auipc	ra,0x1
     536:	91c080e7          	jalr	-1764(ra) # e4e <fork>
        if(write(fds[1], "x", 1) != 1)
     53a:	4605                	li	a2,1
     53c:	00001597          	auipc	a1,0x1
     540:	fc458593          	add	a1,a1,-60 # 1500 <malloc+0x27a>
     544:	fac42503          	lw	a0,-84(s0)
     548:	00001097          	auipc	ra,0x1
     54c:	92e080e7          	jalr	-1746(ra) # e76 <write>
     550:	4785                	li	a5,1
     552:	02f51363          	bne	a0,a5,578 <go+0x500>
        if(read(fds[0], &c, 1) != 1)
     556:	4605                	li	a2,1
     558:	fa040593          	add	a1,s0,-96
     55c:	fa842503          	lw	a0,-88(s0)
     560:	00001097          	auipc	ra,0x1
     564:	90e080e7          	jalr	-1778(ra) # e6e <read>
     568:	4785                	li	a5,1
     56a:	02f51063          	bne	a0,a5,58a <go+0x512>
        exit(0);
     56e:	4501                	li	a0,0
     570:	00001097          	auipc	ra,0x1
     574:	8e6080e7          	jalr	-1818(ra) # e56 <exit>
          printf("grind: pipe write failed\n");
     578:	00001517          	auipc	a0,0x1
     57c:	f9050513          	add	a0,a0,-112 # 1508 <malloc+0x282>
     580:	00001097          	auipc	ra,0x1
     584:	c4e080e7          	jalr	-946(ra) # 11ce <printf>
     588:	b7f9                	j	556 <go+0x4de>
          printf("grind: pipe read failed\n");
     58a:	00001517          	auipc	a0,0x1
     58e:	f9e50513          	add	a0,a0,-98 # 1528 <malloc+0x2a2>
     592:	00001097          	auipc	ra,0x1
     596:	c3c080e7          	jalr	-964(ra) # 11ce <printf>
     59a:	bfd1                	j	56e <go+0x4f6>
        printf("grind: fork failed\n");
     59c:	00001517          	auipc	a0,0x1
     5a0:	f0450513          	add	a0,a0,-252 # 14a0 <malloc+0x21a>
     5a4:	00001097          	auipc	ra,0x1
     5a8:	c2a080e7          	jalr	-982(ra) # 11ce <printf>
        exit(1);
     5ac:	4505                	li	a0,1
     5ae:	00001097          	auipc	ra,0x1
     5b2:	8a8080e7          	jalr	-1880(ra) # e56 <exit>
    } else if(what == 20){
      int pid = fork();
     5b6:	00001097          	auipc	ra,0x1
     5ba:	898080e7          	jalr	-1896(ra) # e4e <fork>
      if(pid == 0){
     5be:	c909                	beqz	a0,5d0 <go+0x558>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     5c0:	06054f63          	bltz	a0,63e <go+0x5c6>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     5c4:	4501                	li	a0,0
     5c6:	00001097          	auipc	ra,0x1
     5ca:	898080e7          	jalr	-1896(ra) # e5e <wait>
     5ce:	beb1                	j	12a <go+0xb2>
        unlink("a");
     5d0:	00001517          	auipc	a0,0x1
     5d4:	ee850513          	add	a0,a0,-280 # 14b8 <malloc+0x232>
     5d8:	00001097          	auipc	ra,0x1
     5dc:	8ce080e7          	jalr	-1842(ra) # ea6 <unlink>
        mkdir("a");
     5e0:	00001517          	auipc	a0,0x1
     5e4:	ed850513          	add	a0,a0,-296 # 14b8 <malloc+0x232>
     5e8:	00001097          	auipc	ra,0x1
     5ec:	8d6080e7          	jalr	-1834(ra) # ebe <mkdir>
        chdir("a");
     5f0:	00001517          	auipc	a0,0x1
     5f4:	ec850513          	add	a0,a0,-312 # 14b8 <malloc+0x232>
     5f8:	00001097          	auipc	ra,0x1
     5fc:	8ce080e7          	jalr	-1842(ra) # ec6 <chdir>
        unlink("../a");
     600:	00001517          	auipc	a0,0x1
     604:	f4850513          	add	a0,a0,-184 # 1548 <malloc+0x2c2>
     608:	00001097          	auipc	ra,0x1
     60c:	89e080e7          	jalr	-1890(ra) # ea6 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     610:	20200593          	li	a1,514
     614:	00001517          	auipc	a0,0x1
     618:	eec50513          	add	a0,a0,-276 # 1500 <malloc+0x27a>
     61c:	00001097          	auipc	ra,0x1
     620:	87a080e7          	jalr	-1926(ra) # e96 <open>
        unlink("x");
     624:	00001517          	auipc	a0,0x1
     628:	edc50513          	add	a0,a0,-292 # 1500 <malloc+0x27a>
     62c:	00001097          	auipc	ra,0x1
     630:	87a080e7          	jalr	-1926(ra) # ea6 <unlink>
        exit(0);
     634:	4501                	li	a0,0
     636:	00001097          	auipc	ra,0x1
     63a:	820080e7          	jalr	-2016(ra) # e56 <exit>
        printf("grind: fork failed\n");
     63e:	00001517          	auipc	a0,0x1
     642:	e6250513          	add	a0,a0,-414 # 14a0 <malloc+0x21a>
     646:	00001097          	auipc	ra,0x1
     64a:	b88080e7          	jalr	-1144(ra) # 11ce <printf>
        exit(1);
     64e:	4505                	li	a0,1
     650:	00001097          	auipc	ra,0x1
     654:	806080e7          	jalr	-2042(ra) # e56 <exit>
    } else if(what == 21){
      unlink("c");
     658:	00001517          	auipc	a0,0x1
     65c:	ef850513          	add	a0,a0,-264 # 1550 <malloc+0x2ca>
     660:	00001097          	auipc	ra,0x1
     664:	846080e7          	jalr	-1978(ra) # ea6 <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     668:	20200593          	li	a1,514
     66c:	00001517          	auipc	a0,0x1
     670:	ee450513          	add	a0,a0,-284 # 1550 <malloc+0x2ca>
     674:	00001097          	auipc	ra,0x1
     678:	822080e7          	jalr	-2014(ra) # e96 <open>
     67c:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     67e:	04054f63          	bltz	a0,6dc <go+0x664>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     682:	4605                	li	a2,1
     684:	00001597          	auipc	a1,0x1
     688:	e7c58593          	add	a1,a1,-388 # 1500 <malloc+0x27a>
     68c:	00000097          	auipc	ra,0x0
     690:	7ea080e7          	jalr	2026(ra) # e76 <write>
     694:	4785                	li	a5,1
     696:	06f51063          	bne	a0,a5,6f6 <go+0x67e>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     69a:	fa840593          	add	a1,s0,-88
     69e:	855a                	mv	a0,s6
     6a0:	00001097          	auipc	ra,0x1
     6a4:	80e080e7          	jalr	-2034(ra) # eae <fstat>
     6a8:	e525                	bnez	a0,710 <go+0x698>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     6aa:	fb843583          	ld	a1,-72(s0)
     6ae:	4785                	li	a5,1
     6b0:	06f59d63          	bne	a1,a5,72a <go+0x6b2>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     6b4:	fac42583          	lw	a1,-84(s0)
     6b8:	0c800793          	li	a5,200
     6bc:	08b7e563          	bltu	a5,a1,746 <go+0x6ce>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     6c0:	855a                	mv	a0,s6
     6c2:	00000097          	auipc	ra,0x0
     6c6:	7bc080e7          	jalr	1980(ra) # e7e <close>
      unlink("c");
     6ca:	00001517          	auipc	a0,0x1
     6ce:	e8650513          	add	a0,a0,-378 # 1550 <malloc+0x2ca>
     6d2:	00000097          	auipc	ra,0x0
     6d6:	7d4080e7          	jalr	2004(ra) # ea6 <unlink>
     6da:	bc81                	j	12a <go+0xb2>
        printf("grind: create c failed\n");
     6dc:	00001517          	auipc	a0,0x1
     6e0:	e7c50513          	add	a0,a0,-388 # 1558 <malloc+0x2d2>
     6e4:	00001097          	auipc	ra,0x1
     6e8:	aea080e7          	jalr	-1302(ra) # 11ce <printf>
        exit(1);
     6ec:	4505                	li	a0,1
     6ee:	00000097          	auipc	ra,0x0
     6f2:	768080e7          	jalr	1896(ra) # e56 <exit>
        printf("grind: write c failed\n");
     6f6:	00001517          	auipc	a0,0x1
     6fa:	e7a50513          	add	a0,a0,-390 # 1570 <malloc+0x2ea>
     6fe:	00001097          	auipc	ra,0x1
     702:	ad0080e7          	jalr	-1328(ra) # 11ce <printf>
        exit(1);
     706:	4505                	li	a0,1
     708:	00000097          	auipc	ra,0x0
     70c:	74e080e7          	jalr	1870(ra) # e56 <exit>
        printf("grind: fstat failed\n");
     710:	00001517          	auipc	a0,0x1
     714:	e7850513          	add	a0,a0,-392 # 1588 <malloc+0x302>
     718:	00001097          	auipc	ra,0x1
     71c:	ab6080e7          	jalr	-1354(ra) # 11ce <printf>
        exit(1);
     720:	4505                	li	a0,1
     722:	00000097          	auipc	ra,0x0
     726:	734080e7          	jalr	1844(ra) # e56 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     72a:	2581                	sext.w	a1,a1
     72c:	00001517          	auipc	a0,0x1
     730:	e7450513          	add	a0,a0,-396 # 15a0 <malloc+0x31a>
     734:	00001097          	auipc	ra,0x1
     738:	a9a080e7          	jalr	-1382(ra) # 11ce <printf>
        exit(1);
     73c:	4505                	li	a0,1
     73e:	00000097          	auipc	ra,0x0
     742:	718080e7          	jalr	1816(ra) # e56 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     746:	00001517          	auipc	a0,0x1
     74a:	e8250513          	add	a0,a0,-382 # 15c8 <malloc+0x342>
     74e:	00001097          	auipc	ra,0x1
     752:	a80080e7          	jalr	-1408(ra) # 11ce <printf>
        exit(1);
     756:	4505                	li	a0,1
     758:	00000097          	auipc	ra,0x0
     75c:	6fe080e7          	jalr	1790(ra) # e56 <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     760:	f9840513          	add	a0,s0,-104
     764:	00000097          	auipc	ra,0x0
     768:	702080e7          	jalr	1794(ra) # e66 <pipe>
     76c:	10054063          	bltz	a0,86c <go+0x7f4>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     770:	fa040513          	add	a0,s0,-96
     774:	00000097          	auipc	ra,0x0
     778:	6f2080e7          	jalr	1778(ra) # e66 <pipe>
     77c:	10054663          	bltz	a0,888 <go+0x810>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     780:	00000097          	auipc	ra,0x0
     784:	6ce080e7          	jalr	1742(ra) # e4e <fork>
      if(pid1 == 0){
     788:	10050e63          	beqz	a0,8a4 <go+0x82c>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     78c:	1c054663          	bltz	a0,958 <go+0x8e0>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     790:	00000097          	auipc	ra,0x0
     794:	6be080e7          	jalr	1726(ra) # e4e <fork>
      if(pid2 == 0){
     798:	1c050e63          	beqz	a0,974 <go+0x8fc>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     79c:	2a054a63          	bltz	a0,a50 <go+0x9d8>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     7a0:	f9842503          	lw	a0,-104(s0)
     7a4:	00000097          	auipc	ra,0x0
     7a8:	6da080e7          	jalr	1754(ra) # e7e <close>
      close(aa[1]);
     7ac:	f9c42503          	lw	a0,-100(s0)
     7b0:	00000097          	auipc	ra,0x0
     7b4:	6ce080e7          	jalr	1742(ra) # e7e <close>
      close(bb[1]);
     7b8:	fa442503          	lw	a0,-92(s0)
     7bc:	00000097          	auipc	ra,0x0
     7c0:	6c2080e7          	jalr	1730(ra) # e7e <close>
      char buf[4] = { 0, 0, 0, 0 };
     7c4:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     7c8:	4605                	li	a2,1
     7ca:	f9040593          	add	a1,s0,-112
     7ce:	fa042503          	lw	a0,-96(s0)
     7d2:	00000097          	auipc	ra,0x0
     7d6:	69c080e7          	jalr	1692(ra) # e6e <read>
      read(bb[0], buf+1, 1);
     7da:	4605                	li	a2,1
     7dc:	f9140593          	add	a1,s0,-111
     7e0:	fa042503          	lw	a0,-96(s0)
     7e4:	00000097          	auipc	ra,0x0
     7e8:	68a080e7          	jalr	1674(ra) # e6e <read>
      read(bb[0], buf+2, 1);
     7ec:	4605                	li	a2,1
     7ee:	f9240593          	add	a1,s0,-110
     7f2:	fa042503          	lw	a0,-96(s0)
     7f6:	00000097          	auipc	ra,0x0
     7fa:	678080e7          	jalr	1656(ra) # e6e <read>
      close(bb[0]);
     7fe:	fa042503          	lw	a0,-96(s0)
     802:	00000097          	auipc	ra,0x0
     806:	67c080e7          	jalr	1660(ra) # e7e <close>
      int st1, st2;
      wait(&st1);
     80a:	f9440513          	add	a0,s0,-108
     80e:	00000097          	auipc	ra,0x0
     812:	650080e7          	jalr	1616(ra) # e5e <wait>
      wait(&st2);
     816:	fa840513          	add	a0,s0,-88
     81a:	00000097          	auipc	ra,0x0
     81e:	644080e7          	jalr	1604(ra) # e5e <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     822:	f9442783          	lw	a5,-108(s0)
     826:	fa842703          	lw	a4,-88(s0)
     82a:	8fd9                	or	a5,a5,a4
     82c:	ef89                	bnez	a5,846 <go+0x7ce>
     82e:	00001597          	auipc	a1,0x1
     832:	e3a58593          	add	a1,a1,-454 # 1668 <malloc+0x3e2>
     836:	f9040513          	add	a0,s0,-112
     83a:	00000097          	auipc	ra,0x0
     83e:	3b6080e7          	jalr	950(ra) # bf0 <strcmp>
     842:	8e0504e3          	beqz	a0,12a <go+0xb2>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     846:	f9040693          	add	a3,s0,-112
     84a:	fa842603          	lw	a2,-88(s0)
     84e:	f9442583          	lw	a1,-108(s0)
     852:	00001517          	auipc	a0,0x1
     856:	e1e50513          	add	a0,a0,-482 # 1670 <malloc+0x3ea>
     85a:	00001097          	auipc	ra,0x1
     85e:	974080e7          	jalr	-1676(ra) # 11ce <printf>
        exit(1);
     862:	4505                	li	a0,1
     864:	00000097          	auipc	ra,0x0
     868:	5f2080e7          	jalr	1522(ra) # e56 <exit>
        fprintf(2, "grind: pipe failed\n");
     86c:	00001597          	auipc	a1,0x1
     870:	c7c58593          	add	a1,a1,-900 # 14e8 <malloc+0x262>
     874:	4509                	li	a0,2
     876:	00001097          	auipc	ra,0x1
     87a:	92a080e7          	jalr	-1750(ra) # 11a0 <fprintf>
        exit(1);
     87e:	4505                	li	a0,1
     880:	00000097          	auipc	ra,0x0
     884:	5d6080e7          	jalr	1494(ra) # e56 <exit>
        fprintf(2, "grind: pipe failed\n");
     888:	00001597          	auipc	a1,0x1
     88c:	c6058593          	add	a1,a1,-928 # 14e8 <malloc+0x262>
     890:	4509                	li	a0,2
     892:	00001097          	auipc	ra,0x1
     896:	90e080e7          	jalr	-1778(ra) # 11a0 <fprintf>
        exit(1);
     89a:	4505                	li	a0,1
     89c:	00000097          	auipc	ra,0x0
     8a0:	5ba080e7          	jalr	1466(ra) # e56 <exit>
        close(bb[0]);
     8a4:	fa042503          	lw	a0,-96(s0)
     8a8:	00000097          	auipc	ra,0x0
     8ac:	5d6080e7          	jalr	1494(ra) # e7e <close>
        close(bb[1]);
     8b0:	fa442503          	lw	a0,-92(s0)
     8b4:	00000097          	auipc	ra,0x0
     8b8:	5ca080e7          	jalr	1482(ra) # e7e <close>
        close(aa[0]);
     8bc:	f9842503          	lw	a0,-104(s0)
     8c0:	00000097          	auipc	ra,0x0
     8c4:	5be080e7          	jalr	1470(ra) # e7e <close>
        close(1);
     8c8:	4505                	li	a0,1
     8ca:	00000097          	auipc	ra,0x0
     8ce:	5b4080e7          	jalr	1460(ra) # e7e <close>
        if(dup(aa[1]) != 1){
     8d2:	f9c42503          	lw	a0,-100(s0)
     8d6:	00000097          	auipc	ra,0x0
     8da:	5f8080e7          	jalr	1528(ra) # ece <dup>
     8de:	4785                	li	a5,1
     8e0:	02f50063          	beq	a0,a5,900 <go+0x888>
          fprintf(2, "grind: dup failed\n");
     8e4:	00001597          	auipc	a1,0x1
     8e8:	d0c58593          	add	a1,a1,-756 # 15f0 <malloc+0x36a>
     8ec:	4509                	li	a0,2
     8ee:	00001097          	auipc	ra,0x1
     8f2:	8b2080e7          	jalr	-1870(ra) # 11a0 <fprintf>
          exit(1);
     8f6:	4505                	li	a0,1
     8f8:	00000097          	auipc	ra,0x0
     8fc:	55e080e7          	jalr	1374(ra) # e56 <exit>
        close(aa[1]);
     900:	f9c42503          	lw	a0,-100(s0)
     904:	00000097          	auipc	ra,0x0
     908:	57a080e7          	jalr	1402(ra) # e7e <close>
        char *args[3] = { "echo", "hi", 0 };
     90c:	00001797          	auipc	a5,0x1
     910:	cfc78793          	add	a5,a5,-772 # 1608 <malloc+0x382>
     914:	faf43423          	sd	a5,-88(s0)
     918:	00001797          	auipc	a5,0x1
     91c:	cf878793          	add	a5,a5,-776 # 1610 <malloc+0x38a>
     920:	faf43823          	sd	a5,-80(s0)
     924:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     928:	fa840593          	add	a1,s0,-88
     92c:	00001517          	auipc	a0,0x1
     930:	cec50513          	add	a0,a0,-788 # 1618 <malloc+0x392>
     934:	00000097          	auipc	ra,0x0
     938:	55a080e7          	jalr	1370(ra) # e8e <exec>
        fprintf(2, "grind: echo: not found\n");
     93c:	00001597          	auipc	a1,0x1
     940:	cec58593          	add	a1,a1,-788 # 1628 <malloc+0x3a2>
     944:	4509                	li	a0,2
     946:	00001097          	auipc	ra,0x1
     94a:	85a080e7          	jalr	-1958(ra) # 11a0 <fprintf>
        exit(2);
     94e:	4509                	li	a0,2
     950:	00000097          	auipc	ra,0x0
     954:	506080e7          	jalr	1286(ra) # e56 <exit>
        fprintf(2, "grind: fork failed\n");
     958:	00001597          	auipc	a1,0x1
     95c:	b4858593          	add	a1,a1,-1208 # 14a0 <malloc+0x21a>
     960:	4509                	li	a0,2
     962:	00001097          	auipc	ra,0x1
     966:	83e080e7          	jalr	-1986(ra) # 11a0 <fprintf>
        exit(3);
     96a:	450d                	li	a0,3
     96c:	00000097          	auipc	ra,0x0
     970:	4ea080e7          	jalr	1258(ra) # e56 <exit>
        close(aa[1]);
     974:	f9c42503          	lw	a0,-100(s0)
     978:	00000097          	auipc	ra,0x0
     97c:	506080e7          	jalr	1286(ra) # e7e <close>
        close(bb[0]);
     980:	fa042503          	lw	a0,-96(s0)
     984:	00000097          	auipc	ra,0x0
     988:	4fa080e7          	jalr	1274(ra) # e7e <close>
        close(0);
     98c:	4501                	li	a0,0
     98e:	00000097          	auipc	ra,0x0
     992:	4f0080e7          	jalr	1264(ra) # e7e <close>
        if(dup(aa[0]) != 0){
     996:	f9842503          	lw	a0,-104(s0)
     99a:	00000097          	auipc	ra,0x0
     99e:	534080e7          	jalr	1332(ra) # ece <dup>
     9a2:	cd19                	beqz	a0,9c0 <go+0x948>
          fprintf(2, "grind: dup failed\n");
     9a4:	00001597          	auipc	a1,0x1
     9a8:	c4c58593          	add	a1,a1,-948 # 15f0 <malloc+0x36a>
     9ac:	4509                	li	a0,2
     9ae:	00000097          	auipc	ra,0x0
     9b2:	7f2080e7          	jalr	2034(ra) # 11a0 <fprintf>
          exit(4);
     9b6:	4511                	li	a0,4
     9b8:	00000097          	auipc	ra,0x0
     9bc:	49e080e7          	jalr	1182(ra) # e56 <exit>
        close(aa[0]);
     9c0:	f9842503          	lw	a0,-104(s0)
     9c4:	00000097          	auipc	ra,0x0
     9c8:	4ba080e7          	jalr	1210(ra) # e7e <close>
        close(1);
     9cc:	4505                	li	a0,1
     9ce:	00000097          	auipc	ra,0x0
     9d2:	4b0080e7          	jalr	1200(ra) # e7e <close>
        if(dup(bb[1]) != 1){
     9d6:	fa442503          	lw	a0,-92(s0)
     9da:	00000097          	auipc	ra,0x0
     9de:	4f4080e7          	jalr	1268(ra) # ece <dup>
     9e2:	4785                	li	a5,1
     9e4:	02f50063          	beq	a0,a5,a04 <go+0x98c>
          fprintf(2, "grind: dup failed\n");
     9e8:	00001597          	auipc	a1,0x1
     9ec:	c0858593          	add	a1,a1,-1016 # 15f0 <malloc+0x36a>
     9f0:	4509                	li	a0,2
     9f2:	00000097          	auipc	ra,0x0
     9f6:	7ae080e7          	jalr	1966(ra) # 11a0 <fprintf>
          exit(5);
     9fa:	4515                	li	a0,5
     9fc:	00000097          	auipc	ra,0x0
     a00:	45a080e7          	jalr	1114(ra) # e56 <exit>
        close(bb[1]);
     a04:	fa442503          	lw	a0,-92(s0)
     a08:	00000097          	auipc	ra,0x0
     a0c:	476080e7          	jalr	1142(ra) # e7e <close>
        char *args[2] = { "cat", 0 };
     a10:	00001797          	auipc	a5,0x1
     a14:	c3078793          	add	a5,a5,-976 # 1640 <malloc+0x3ba>
     a18:	faf43423          	sd	a5,-88(s0)
     a1c:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a20:	fa840593          	add	a1,s0,-88
     a24:	00001517          	auipc	a0,0x1
     a28:	c2450513          	add	a0,a0,-988 # 1648 <malloc+0x3c2>
     a2c:	00000097          	auipc	ra,0x0
     a30:	462080e7          	jalr	1122(ra) # e8e <exec>
        fprintf(2, "grind: cat: not found\n");
     a34:	00001597          	auipc	a1,0x1
     a38:	c1c58593          	add	a1,a1,-996 # 1650 <malloc+0x3ca>
     a3c:	4509                	li	a0,2
     a3e:	00000097          	auipc	ra,0x0
     a42:	762080e7          	jalr	1890(ra) # 11a0 <fprintf>
        exit(6);
     a46:	4519                	li	a0,6
     a48:	00000097          	auipc	ra,0x0
     a4c:	40e080e7          	jalr	1038(ra) # e56 <exit>
        fprintf(2, "grind: fork failed\n");
     a50:	00001597          	auipc	a1,0x1
     a54:	a5058593          	add	a1,a1,-1456 # 14a0 <malloc+0x21a>
     a58:	4509                	li	a0,2
     a5a:	00000097          	auipc	ra,0x0
     a5e:	746080e7          	jalr	1862(ra) # 11a0 <fprintf>
        exit(7);
     a62:	451d                	li	a0,7
     a64:	00000097          	auipc	ra,0x0
     a68:	3f2080e7          	jalr	1010(ra) # e56 <exit>

0000000000000a6c <iter>:
  }
}

void
iter()
{
     a6c:	7179                	add	sp,sp,-48
     a6e:	f406                	sd	ra,40(sp)
     a70:	f022                	sd	s0,32(sp)
     a72:	1800                	add	s0,sp,48
  unlink("a");
     a74:	00001517          	auipc	a0,0x1
     a78:	a4450513          	add	a0,a0,-1468 # 14b8 <malloc+0x232>
     a7c:	00000097          	auipc	ra,0x0
     a80:	42a080e7          	jalr	1066(ra) # ea6 <unlink>
  unlink("b");
     a84:	00001517          	auipc	a0,0x1
     a88:	9e450513          	add	a0,a0,-1564 # 1468 <malloc+0x1e2>
     a8c:	00000097          	auipc	ra,0x0
     a90:	41a080e7          	jalr	1050(ra) # ea6 <unlink>
  
  int pid1 = fork();
     a94:	00000097          	auipc	ra,0x0
     a98:	3ba080e7          	jalr	954(ra) # e4e <fork>
  if(pid1 < 0){
     a9c:	02054363          	bltz	a0,ac2 <iter+0x56>
     aa0:	ec26                	sd	s1,24(sp)
     aa2:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     aa4:	ed15                	bnez	a0,ae0 <iter+0x74>
     aa6:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     aa8:	00002717          	auipc	a4,0x2
     aac:	a0870713          	add	a4,a4,-1528 # 24b0 <rand_next>
     ab0:	631c                	ld	a5,0(a4)
     ab2:	01f7c793          	xor	a5,a5,31
     ab6:	e31c                	sd	a5,0(a4)
    go(0);
     ab8:	4501                	li	a0,0
     aba:	fffff097          	auipc	ra,0xfffff
     abe:	5be080e7          	jalr	1470(ra) # 78 <go>
     ac2:	ec26                	sd	s1,24(sp)
     ac4:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     ac6:	00001517          	auipc	a0,0x1
     aca:	9da50513          	add	a0,a0,-1574 # 14a0 <malloc+0x21a>
     ace:	00000097          	auipc	ra,0x0
     ad2:	700080e7          	jalr	1792(ra) # 11ce <printf>
    exit(1);
     ad6:	4505                	li	a0,1
     ad8:	00000097          	auipc	ra,0x0
     adc:	37e080e7          	jalr	894(ra) # e56 <exit>
     ae0:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     ae2:	00000097          	auipc	ra,0x0
     ae6:	36c080e7          	jalr	876(ra) # e4e <fork>
     aea:	892a                	mv	s2,a0
  if(pid2 < 0){
     aec:	02054263          	bltz	a0,b10 <iter+0xa4>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     af0:	ed0d                	bnez	a0,b2a <iter+0xbe>
    rand_next ^= 7177;
     af2:	00002697          	auipc	a3,0x2
     af6:	9be68693          	add	a3,a3,-1602 # 24b0 <rand_next>
     afa:	629c                	ld	a5,0(a3)
     afc:	6709                	lui	a4,0x2
     afe:	c0970713          	add	a4,a4,-1015 # 1c09 <digits+0x4b1>
     b02:	8fb9                	xor	a5,a5,a4
     b04:	e29c                	sd	a5,0(a3)
    go(1);
     b06:	4505                	li	a0,1
     b08:	fffff097          	auipc	ra,0xfffff
     b0c:	570080e7          	jalr	1392(ra) # 78 <go>
    printf("grind: fork failed\n");
     b10:	00001517          	auipc	a0,0x1
     b14:	99050513          	add	a0,a0,-1648 # 14a0 <malloc+0x21a>
     b18:	00000097          	auipc	ra,0x0
     b1c:	6b6080e7          	jalr	1718(ra) # 11ce <printf>
    exit(1);
     b20:	4505                	li	a0,1
     b22:	00000097          	auipc	ra,0x0
     b26:	334080e7          	jalr	820(ra) # e56 <exit>
    exit(0);
  }

  int st1 = -1;
     b2a:	57fd                	li	a5,-1
     b2c:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b30:	fdc40513          	add	a0,s0,-36
     b34:	00000097          	auipc	ra,0x0
     b38:	32a080e7          	jalr	810(ra) # e5e <wait>
  if(st1 != 0){
     b3c:	fdc42783          	lw	a5,-36(s0)
     b40:	ef99                	bnez	a5,b5e <iter+0xf2>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b42:	57fd                	li	a5,-1
     b44:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b48:	fd840513          	add	a0,s0,-40
     b4c:	00000097          	auipc	ra,0x0
     b50:	312080e7          	jalr	786(ra) # e5e <wait>

  exit(0);
     b54:	4501                	li	a0,0
     b56:	00000097          	auipc	ra,0x0
     b5a:	300080e7          	jalr	768(ra) # e56 <exit>
    kill(pid1);
     b5e:	8526                	mv	a0,s1
     b60:	00000097          	auipc	ra,0x0
     b64:	326080e7          	jalr	806(ra) # e86 <kill>
    kill(pid2);
     b68:	854a                	mv	a0,s2
     b6a:	00000097          	auipc	ra,0x0
     b6e:	31c080e7          	jalr	796(ra) # e86 <kill>
     b72:	bfc1                	j	b42 <iter+0xd6>

0000000000000b74 <main>:
}

int
main()
{
     b74:	1101                	add	sp,sp,-32
     b76:	ec06                	sd	ra,24(sp)
     b78:	e822                	sd	s0,16(sp)
     b7a:	e426                	sd	s1,8(sp)
     b7c:	1000                	add	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
    rand_next += 1;
     b7e:	00002497          	auipc	s1,0x2
     b82:	93248493          	add	s1,s1,-1742 # 24b0 <rand_next>
     b86:	a829                	j	ba0 <main+0x2c>
      iter();
     b88:	00000097          	auipc	ra,0x0
     b8c:	ee4080e7          	jalr	-284(ra) # a6c <iter>
    sleep(20);
     b90:	4551                	li	a0,20
     b92:	00000097          	auipc	ra,0x0
     b96:	354080e7          	jalr	852(ra) # ee6 <sleep>
    rand_next += 1;
     b9a:	609c                	ld	a5,0(s1)
     b9c:	0785                	add	a5,a5,1
     b9e:	e09c                	sd	a5,0(s1)
    int pid = fork();
     ba0:	00000097          	auipc	ra,0x0
     ba4:	2ae080e7          	jalr	686(ra) # e4e <fork>
    if(pid == 0){
     ba8:	d165                	beqz	a0,b88 <main+0x14>
    if(pid > 0){
     baa:	fea053e3          	blez	a0,b90 <main+0x1c>
      wait(0);
     bae:	4501                	li	a0,0
     bb0:	00000097          	auipc	ra,0x0
     bb4:	2ae080e7          	jalr	686(ra) # e5e <wait>
     bb8:	bfe1                	j	b90 <main+0x1c>

0000000000000bba <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     bba:	1141                	add	sp,sp,-16
     bbc:	e406                	sd	ra,8(sp)
     bbe:	e022                	sd	s0,0(sp)
     bc0:	0800                	add	s0,sp,16
  extern int main();
  main();
     bc2:	00000097          	auipc	ra,0x0
     bc6:	fb2080e7          	jalr	-78(ra) # b74 <main>
  exit(0);
     bca:	4501                	li	a0,0
     bcc:	00000097          	auipc	ra,0x0
     bd0:	28a080e7          	jalr	650(ra) # e56 <exit>

0000000000000bd4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     bd4:	1141                	add	sp,sp,-16
     bd6:	e422                	sd	s0,8(sp)
     bd8:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     bda:	87aa                	mv	a5,a0
     bdc:	0585                	add	a1,a1,1
     bde:	0785                	add	a5,a5,1
     be0:	fff5c703          	lbu	a4,-1(a1)
     be4:	fee78fa3          	sb	a4,-1(a5)
     be8:	fb75                	bnez	a4,bdc <strcpy+0x8>
    ;
  return os;
}
     bea:	6422                	ld	s0,8(sp)
     bec:	0141                	add	sp,sp,16
     bee:	8082                	ret

0000000000000bf0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     bf0:	1141                	add	sp,sp,-16
     bf2:	e422                	sd	s0,8(sp)
     bf4:	0800                	add	s0,sp,16
  while(*p && *p == *q)
     bf6:	00054783          	lbu	a5,0(a0)
     bfa:	cb91                	beqz	a5,c0e <strcmp+0x1e>
     bfc:	0005c703          	lbu	a4,0(a1)
     c00:	00f71763          	bne	a4,a5,c0e <strcmp+0x1e>
    p++, q++;
     c04:	0505                	add	a0,a0,1
     c06:	0585                	add	a1,a1,1
  while(*p && *p == *q)
     c08:	00054783          	lbu	a5,0(a0)
     c0c:	fbe5                	bnez	a5,bfc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     c0e:	0005c503          	lbu	a0,0(a1)
}
     c12:	40a7853b          	subw	a0,a5,a0
     c16:	6422                	ld	s0,8(sp)
     c18:	0141                	add	sp,sp,16
     c1a:	8082                	ret

0000000000000c1c <strlen>:

uint
strlen(const char *s)
{
     c1c:	1141                	add	sp,sp,-16
     c1e:	e422                	sd	s0,8(sp)
     c20:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c22:	00054783          	lbu	a5,0(a0)
     c26:	cf91                	beqz	a5,c42 <strlen+0x26>
     c28:	0505                	add	a0,a0,1
     c2a:	87aa                	mv	a5,a0
     c2c:	86be                	mv	a3,a5
     c2e:	0785                	add	a5,a5,1
     c30:	fff7c703          	lbu	a4,-1(a5)
     c34:	ff65                	bnez	a4,c2c <strlen+0x10>
     c36:	40a6853b          	subw	a0,a3,a0
     c3a:	2505                	addw	a0,a0,1
    ;
  return n;
}
     c3c:	6422                	ld	s0,8(sp)
     c3e:	0141                	add	sp,sp,16
     c40:	8082                	ret
  for(n = 0; s[n]; n++)
     c42:	4501                	li	a0,0
     c44:	bfe5                	j	c3c <strlen+0x20>

0000000000000c46 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c46:	1141                	add	sp,sp,-16
     c48:	e422                	sd	s0,8(sp)
     c4a:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c4c:	ca19                	beqz	a2,c62 <memset+0x1c>
     c4e:	87aa                	mv	a5,a0
     c50:	1602                	sll	a2,a2,0x20
     c52:	9201                	srl	a2,a2,0x20
     c54:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c58:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c5c:	0785                	add	a5,a5,1
     c5e:	fee79de3          	bne	a5,a4,c58 <memset+0x12>
  }
  return dst;
}
     c62:	6422                	ld	s0,8(sp)
     c64:	0141                	add	sp,sp,16
     c66:	8082                	ret

0000000000000c68 <strchr>:

char*
strchr(const char *s, char c)
{
     c68:	1141                	add	sp,sp,-16
     c6a:	e422                	sd	s0,8(sp)
     c6c:	0800                	add	s0,sp,16
  for(; *s; s++)
     c6e:	00054783          	lbu	a5,0(a0)
     c72:	cb99                	beqz	a5,c88 <strchr+0x20>
    if(*s == c)
     c74:	00f58763          	beq	a1,a5,c82 <strchr+0x1a>
  for(; *s; s++)
     c78:	0505                	add	a0,a0,1
     c7a:	00054783          	lbu	a5,0(a0)
     c7e:	fbfd                	bnez	a5,c74 <strchr+0xc>
      return (char*)s;
  return 0;
     c80:	4501                	li	a0,0
}
     c82:	6422                	ld	s0,8(sp)
     c84:	0141                	add	sp,sp,16
     c86:	8082                	ret
  return 0;
     c88:	4501                	li	a0,0
     c8a:	bfe5                	j	c82 <strchr+0x1a>

0000000000000c8c <gets>:

char*
gets(char *buf, int max)
{
     c8c:	711d                	add	sp,sp,-96
     c8e:	ec86                	sd	ra,88(sp)
     c90:	e8a2                	sd	s0,80(sp)
     c92:	e4a6                	sd	s1,72(sp)
     c94:	e0ca                	sd	s2,64(sp)
     c96:	fc4e                	sd	s3,56(sp)
     c98:	f852                	sd	s4,48(sp)
     c9a:	f456                	sd	s5,40(sp)
     c9c:	f05a                	sd	s6,32(sp)
     c9e:	ec5e                	sd	s7,24(sp)
     ca0:	1080                	add	s0,sp,96
     ca2:	8baa                	mv	s7,a0
     ca4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ca6:	892a                	mv	s2,a0
     ca8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     caa:	4aa9                	li	s5,10
     cac:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     cae:	89a6                	mv	s3,s1
     cb0:	2485                	addw	s1,s1,1
     cb2:	0344d863          	bge	s1,s4,ce2 <gets+0x56>
    cc = read(0, &c, 1);
     cb6:	4605                	li	a2,1
     cb8:	faf40593          	add	a1,s0,-81
     cbc:	4501                	li	a0,0
     cbe:	00000097          	auipc	ra,0x0
     cc2:	1b0080e7          	jalr	432(ra) # e6e <read>
    if(cc < 1)
     cc6:	00a05e63          	blez	a0,ce2 <gets+0x56>
    buf[i++] = c;
     cca:	faf44783          	lbu	a5,-81(s0)
     cce:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     cd2:	01578763          	beq	a5,s5,ce0 <gets+0x54>
     cd6:	0905                	add	s2,s2,1
     cd8:	fd679be3          	bne	a5,s6,cae <gets+0x22>
    buf[i++] = c;
     cdc:	89a6                	mv	s3,s1
     cde:	a011                	j	ce2 <gets+0x56>
     ce0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     ce2:	99de                	add	s3,s3,s7
     ce4:	00098023          	sb	zero,0(s3)
  return buf;
}
     ce8:	855e                	mv	a0,s7
     cea:	60e6                	ld	ra,88(sp)
     cec:	6446                	ld	s0,80(sp)
     cee:	64a6                	ld	s1,72(sp)
     cf0:	6906                	ld	s2,64(sp)
     cf2:	79e2                	ld	s3,56(sp)
     cf4:	7a42                	ld	s4,48(sp)
     cf6:	7aa2                	ld	s5,40(sp)
     cf8:	7b02                	ld	s6,32(sp)
     cfa:	6be2                	ld	s7,24(sp)
     cfc:	6125                	add	sp,sp,96
     cfe:	8082                	ret

0000000000000d00 <stat>:

int
stat(const char *n, struct stat *st)
{
     d00:	1101                	add	sp,sp,-32
     d02:	ec06                	sd	ra,24(sp)
     d04:	e822                	sd	s0,16(sp)
     d06:	e04a                	sd	s2,0(sp)
     d08:	1000                	add	s0,sp,32
     d0a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d0c:	4581                	li	a1,0
     d0e:	00000097          	auipc	ra,0x0
     d12:	188080e7          	jalr	392(ra) # e96 <open>
  if(fd < 0)
     d16:	02054663          	bltz	a0,d42 <stat+0x42>
     d1a:	e426                	sd	s1,8(sp)
     d1c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d1e:	85ca                	mv	a1,s2
     d20:	00000097          	auipc	ra,0x0
     d24:	18e080e7          	jalr	398(ra) # eae <fstat>
     d28:	892a                	mv	s2,a0
  close(fd);
     d2a:	8526                	mv	a0,s1
     d2c:	00000097          	auipc	ra,0x0
     d30:	152080e7          	jalr	338(ra) # e7e <close>
  return r;
     d34:	64a2                	ld	s1,8(sp)
}
     d36:	854a                	mv	a0,s2
     d38:	60e2                	ld	ra,24(sp)
     d3a:	6442                	ld	s0,16(sp)
     d3c:	6902                	ld	s2,0(sp)
     d3e:	6105                	add	sp,sp,32
     d40:	8082                	ret
    return -1;
     d42:	597d                	li	s2,-1
     d44:	bfcd                	j	d36 <stat+0x36>

0000000000000d46 <atoi>:

int
atoi(const char *s)
{
     d46:	1141                	add	sp,sp,-16
     d48:	e422                	sd	s0,8(sp)
     d4a:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d4c:	00054683          	lbu	a3,0(a0)
     d50:	fd06879b          	addw	a5,a3,-48
     d54:	0ff7f793          	zext.b	a5,a5
     d58:	4625                	li	a2,9
     d5a:	02f66863          	bltu	a2,a5,d8a <atoi+0x44>
     d5e:	872a                	mv	a4,a0
  n = 0;
     d60:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d62:	0705                	add	a4,a4,1
     d64:	0025179b          	sllw	a5,a0,0x2
     d68:	9fa9                	addw	a5,a5,a0
     d6a:	0017979b          	sllw	a5,a5,0x1
     d6e:	9fb5                	addw	a5,a5,a3
     d70:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d74:	00074683          	lbu	a3,0(a4)
     d78:	fd06879b          	addw	a5,a3,-48
     d7c:	0ff7f793          	zext.b	a5,a5
     d80:	fef671e3          	bgeu	a2,a5,d62 <atoi+0x1c>
  return n;
}
     d84:	6422                	ld	s0,8(sp)
     d86:	0141                	add	sp,sp,16
     d88:	8082                	ret
  n = 0;
     d8a:	4501                	li	a0,0
     d8c:	bfe5                	j	d84 <atoi+0x3e>

0000000000000d8e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d8e:	1141                	add	sp,sp,-16
     d90:	e422                	sd	s0,8(sp)
     d92:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d94:	02b57463          	bgeu	a0,a1,dbc <memmove+0x2e>
    while(n-- > 0)
     d98:	00c05f63          	blez	a2,db6 <memmove+0x28>
     d9c:	1602                	sll	a2,a2,0x20
     d9e:	9201                	srl	a2,a2,0x20
     da0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     da4:	872a                	mv	a4,a0
      *dst++ = *src++;
     da6:	0585                	add	a1,a1,1
     da8:	0705                	add	a4,a4,1
     daa:	fff5c683          	lbu	a3,-1(a1)
     dae:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     db2:	fef71ae3          	bne	a4,a5,da6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     db6:	6422                	ld	s0,8(sp)
     db8:	0141                	add	sp,sp,16
     dba:	8082                	ret
    dst += n;
     dbc:	00c50733          	add	a4,a0,a2
    src += n;
     dc0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     dc2:	fec05ae3          	blez	a2,db6 <memmove+0x28>
     dc6:	fff6079b          	addw	a5,a2,-1
     dca:	1782                	sll	a5,a5,0x20
     dcc:	9381                	srl	a5,a5,0x20
     dce:	fff7c793          	not	a5,a5
     dd2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     dd4:	15fd                	add	a1,a1,-1
     dd6:	177d                	add	a4,a4,-1
     dd8:	0005c683          	lbu	a3,0(a1)
     ddc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     de0:	fee79ae3          	bne	a5,a4,dd4 <memmove+0x46>
     de4:	bfc9                	j	db6 <memmove+0x28>

0000000000000de6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     de6:	1141                	add	sp,sp,-16
     de8:	e422                	sd	s0,8(sp)
     dea:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     dec:	ca05                	beqz	a2,e1c <memcmp+0x36>
     dee:	fff6069b          	addw	a3,a2,-1
     df2:	1682                	sll	a3,a3,0x20
     df4:	9281                	srl	a3,a3,0x20
     df6:	0685                	add	a3,a3,1
     df8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     dfa:	00054783          	lbu	a5,0(a0)
     dfe:	0005c703          	lbu	a4,0(a1)
     e02:	00e79863          	bne	a5,a4,e12 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     e06:	0505                	add	a0,a0,1
    p2++;
     e08:	0585                	add	a1,a1,1
  while (n-- > 0) {
     e0a:	fed518e3          	bne	a0,a3,dfa <memcmp+0x14>
  }
  return 0;
     e0e:	4501                	li	a0,0
     e10:	a019                	j	e16 <memcmp+0x30>
      return *p1 - *p2;
     e12:	40e7853b          	subw	a0,a5,a4
}
     e16:	6422                	ld	s0,8(sp)
     e18:	0141                	add	sp,sp,16
     e1a:	8082                	ret
  return 0;
     e1c:	4501                	li	a0,0
     e1e:	bfe5                	j	e16 <memcmp+0x30>

0000000000000e20 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e20:	1141                	add	sp,sp,-16
     e22:	e406                	sd	ra,8(sp)
     e24:	e022                	sd	s0,0(sp)
     e26:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
     e28:	00000097          	auipc	ra,0x0
     e2c:	f66080e7          	jalr	-154(ra) # d8e <memmove>
}
     e30:	60a2                	ld	ra,8(sp)
     e32:	6402                	ld	s0,0(sp)
     e34:	0141                	add	sp,sp,16
     e36:	8082                	ret

0000000000000e38 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
     e38:	1141                	add	sp,sp,-16
     e3a:	e422                	sd	s0,8(sp)
     e3c:	0800                	add	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
     e3e:	040007b7          	lui	a5,0x4000
     e42:	17f5                	add	a5,a5,-3 # 3fffffd <base+0x3ffd745>
     e44:	07b2                	sll	a5,a5,0xc
}
     e46:	4388                	lw	a0,0(a5)
     e48:	6422                	ld	s0,8(sp)
     e4a:	0141                	add	sp,sp,16
     e4c:	8082                	ret

0000000000000e4e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e4e:	4885                	li	a7,1
 ecall
     e50:	00000073          	ecall
 ret
     e54:	8082                	ret

0000000000000e56 <exit>:
.global exit
exit:
 li a7, SYS_exit
     e56:	4889                	li	a7,2
 ecall
     e58:	00000073          	ecall
 ret
     e5c:	8082                	ret

0000000000000e5e <wait>:
.global wait
wait:
 li a7, SYS_wait
     e5e:	488d                	li	a7,3
 ecall
     e60:	00000073          	ecall
 ret
     e64:	8082                	ret

0000000000000e66 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e66:	4891                	li	a7,4
 ecall
     e68:	00000073          	ecall
 ret
     e6c:	8082                	ret

0000000000000e6e <read>:
.global read
read:
 li a7, SYS_read
     e6e:	4895                	li	a7,5
 ecall
     e70:	00000073          	ecall
 ret
     e74:	8082                	ret

0000000000000e76 <write>:
.global write
write:
 li a7, SYS_write
     e76:	48c1                	li	a7,16
 ecall
     e78:	00000073          	ecall
 ret
     e7c:	8082                	ret

0000000000000e7e <close>:
.global close
close:
 li a7, SYS_close
     e7e:	48d5                	li	a7,21
 ecall
     e80:	00000073          	ecall
 ret
     e84:	8082                	ret

0000000000000e86 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e86:	4899                	li	a7,6
 ecall
     e88:	00000073          	ecall
 ret
     e8c:	8082                	ret

0000000000000e8e <exec>:
.global exec
exec:
 li a7, SYS_exec
     e8e:	489d                	li	a7,7
 ecall
     e90:	00000073          	ecall
 ret
     e94:	8082                	ret

0000000000000e96 <open>:
.global open
open:
 li a7, SYS_open
     e96:	48bd                	li	a7,15
 ecall
     e98:	00000073          	ecall
 ret
     e9c:	8082                	ret

0000000000000e9e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e9e:	48c5                	li	a7,17
 ecall
     ea0:	00000073          	ecall
 ret
     ea4:	8082                	ret

0000000000000ea6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     ea6:	48c9                	li	a7,18
 ecall
     ea8:	00000073          	ecall
 ret
     eac:	8082                	ret

0000000000000eae <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     eae:	48a1                	li	a7,8
 ecall
     eb0:	00000073          	ecall
 ret
     eb4:	8082                	ret

0000000000000eb6 <link>:
.global link
link:
 li a7, SYS_link
     eb6:	48cd                	li	a7,19
 ecall
     eb8:	00000073          	ecall
 ret
     ebc:	8082                	ret

0000000000000ebe <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     ebe:	48d1                	li	a7,20
 ecall
     ec0:	00000073          	ecall
 ret
     ec4:	8082                	ret

0000000000000ec6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     ec6:	48a5                	li	a7,9
 ecall
     ec8:	00000073          	ecall
 ret
     ecc:	8082                	ret

0000000000000ece <dup>:
.global dup
dup:
 li a7, SYS_dup
     ece:	48a9                	li	a7,10
 ecall
     ed0:	00000073          	ecall
 ret
     ed4:	8082                	ret

0000000000000ed6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     ed6:	48ad                	li	a7,11
 ecall
     ed8:	00000073          	ecall
 ret
     edc:	8082                	ret

0000000000000ede <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     ede:	48b1                	li	a7,12
 ecall
     ee0:	00000073          	ecall
 ret
     ee4:	8082                	ret

0000000000000ee6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     ee6:	48b5                	li	a7,13
 ecall
     ee8:	00000073          	ecall
 ret
     eec:	8082                	ret

0000000000000eee <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     eee:	48b9                	li	a7,14
 ecall
     ef0:	00000073          	ecall
 ret
     ef4:	8082                	ret

0000000000000ef6 <connect>:
.global connect
connect:
 li a7, SYS_connect
     ef6:	48f5                	li	a7,29
 ecall
     ef8:	00000073          	ecall
 ret
     efc:	8082                	ret

0000000000000efe <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     efe:	48f9                	li	a7,30
 ecall
     f00:	00000073          	ecall
 ret
     f04:	8082                	ret

0000000000000f06 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     f06:	1101                	add	sp,sp,-32
     f08:	ec06                	sd	ra,24(sp)
     f0a:	e822                	sd	s0,16(sp)
     f0c:	1000                	add	s0,sp,32
     f0e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     f12:	4605                	li	a2,1
     f14:	fef40593          	add	a1,s0,-17
     f18:	00000097          	auipc	ra,0x0
     f1c:	f5e080e7          	jalr	-162(ra) # e76 <write>
}
     f20:	60e2                	ld	ra,24(sp)
     f22:	6442                	ld	s0,16(sp)
     f24:	6105                	add	sp,sp,32
     f26:	8082                	ret

0000000000000f28 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f28:	7139                	add	sp,sp,-64
     f2a:	fc06                	sd	ra,56(sp)
     f2c:	f822                	sd	s0,48(sp)
     f2e:	f426                	sd	s1,40(sp)
     f30:	0080                	add	s0,sp,64
     f32:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f34:	c299                	beqz	a3,f3a <printint+0x12>
     f36:	0805cb63          	bltz	a1,fcc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f3a:	2581                	sext.w	a1,a1
  neg = 0;
     f3c:	4881                	li	a7,0
     f3e:	fc040693          	add	a3,s0,-64
  }

  i = 0;
     f42:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f44:	2601                	sext.w	a2,a2
     f46:	00001517          	auipc	a0,0x1
     f4a:	81250513          	add	a0,a0,-2030 # 1758 <digits>
     f4e:	883a                	mv	a6,a4
     f50:	2705                	addw	a4,a4,1
     f52:	02c5f7bb          	remuw	a5,a1,a2
     f56:	1782                	sll	a5,a5,0x20
     f58:	9381                	srl	a5,a5,0x20
     f5a:	97aa                	add	a5,a5,a0
     f5c:	0007c783          	lbu	a5,0(a5)
     f60:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f64:	0005879b          	sext.w	a5,a1
     f68:	02c5d5bb          	divuw	a1,a1,a2
     f6c:	0685                	add	a3,a3,1
     f6e:	fec7f0e3          	bgeu	a5,a2,f4e <printint+0x26>
  if(neg)
     f72:	00088c63          	beqz	a7,f8a <printint+0x62>
    buf[i++] = '-';
     f76:	fd070793          	add	a5,a4,-48
     f7a:	00878733          	add	a4,a5,s0
     f7e:	02d00793          	li	a5,45
     f82:	fef70823          	sb	a5,-16(a4)
     f86:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
     f8a:	02e05c63          	blez	a4,fc2 <printint+0x9a>
     f8e:	f04a                	sd	s2,32(sp)
     f90:	ec4e                	sd	s3,24(sp)
     f92:	fc040793          	add	a5,s0,-64
     f96:	00e78933          	add	s2,a5,a4
     f9a:	fff78993          	add	s3,a5,-1
     f9e:	99ba                	add	s3,s3,a4
     fa0:	377d                	addw	a4,a4,-1
     fa2:	1702                	sll	a4,a4,0x20
     fa4:	9301                	srl	a4,a4,0x20
     fa6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     faa:	fff94583          	lbu	a1,-1(s2)
     fae:	8526                	mv	a0,s1
     fb0:	00000097          	auipc	ra,0x0
     fb4:	f56080e7          	jalr	-170(ra) # f06 <putc>
  while(--i >= 0)
     fb8:	197d                	add	s2,s2,-1
     fba:	ff3918e3          	bne	s2,s3,faa <printint+0x82>
     fbe:	7902                	ld	s2,32(sp)
     fc0:	69e2                	ld	s3,24(sp)
}
     fc2:	70e2                	ld	ra,56(sp)
     fc4:	7442                	ld	s0,48(sp)
     fc6:	74a2                	ld	s1,40(sp)
     fc8:	6121                	add	sp,sp,64
     fca:	8082                	ret
    x = -xx;
     fcc:	40b005bb          	negw	a1,a1
    neg = 1;
     fd0:	4885                	li	a7,1
    x = -xx;
     fd2:	b7b5                	j	f3e <printint+0x16>

0000000000000fd4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     fd4:	715d                	add	sp,sp,-80
     fd6:	e486                	sd	ra,72(sp)
     fd8:	e0a2                	sd	s0,64(sp)
     fda:	f84a                	sd	s2,48(sp)
     fdc:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     fde:	0005c903          	lbu	s2,0(a1)
     fe2:	1a090a63          	beqz	s2,1196 <vprintf+0x1c2>
     fe6:	fc26                	sd	s1,56(sp)
     fe8:	f44e                	sd	s3,40(sp)
     fea:	f052                	sd	s4,32(sp)
     fec:	ec56                	sd	s5,24(sp)
     fee:	e85a                	sd	s6,16(sp)
     ff0:	e45e                	sd	s7,8(sp)
     ff2:	8aaa                	mv	s5,a0
     ff4:	8bb2                	mv	s7,a2
     ff6:	00158493          	add	s1,a1,1
  state = 0;
     ffa:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     ffc:	02500a13          	li	s4,37
    1000:	4b55                	li	s6,21
    1002:	a839                	j	1020 <vprintf+0x4c>
        putc(fd, c);
    1004:	85ca                	mv	a1,s2
    1006:	8556                	mv	a0,s5
    1008:	00000097          	auipc	ra,0x0
    100c:	efe080e7          	jalr	-258(ra) # f06 <putc>
    1010:	a019                	j	1016 <vprintf+0x42>
    } else if(state == '%'){
    1012:	01498d63          	beq	s3,s4,102c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    1016:	0485                	add	s1,s1,1
    1018:	fff4c903          	lbu	s2,-1(s1)
    101c:	16090763          	beqz	s2,118a <vprintf+0x1b6>
    if(state == 0){
    1020:	fe0999e3          	bnez	s3,1012 <vprintf+0x3e>
      if(c == '%'){
    1024:	ff4910e3          	bne	s2,s4,1004 <vprintf+0x30>
        state = '%';
    1028:	89d2                	mv	s3,s4
    102a:	b7f5                	j	1016 <vprintf+0x42>
      if(c == 'd'){
    102c:	13490463          	beq	s2,s4,1154 <vprintf+0x180>
    1030:	f9d9079b          	addw	a5,s2,-99
    1034:	0ff7f793          	zext.b	a5,a5
    1038:	12fb6763          	bltu	s6,a5,1166 <vprintf+0x192>
    103c:	f9d9079b          	addw	a5,s2,-99
    1040:	0ff7f713          	zext.b	a4,a5
    1044:	12eb6163          	bltu	s6,a4,1166 <vprintf+0x192>
    1048:	00271793          	sll	a5,a4,0x2
    104c:	00000717          	auipc	a4,0x0
    1050:	6b470713          	add	a4,a4,1716 # 1700 <malloc+0x47a>
    1054:	97ba                	add	a5,a5,a4
    1056:	439c                	lw	a5,0(a5)
    1058:	97ba                	add	a5,a5,a4
    105a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    105c:	008b8913          	add	s2,s7,8
    1060:	4685                	li	a3,1
    1062:	4629                	li	a2,10
    1064:	000ba583          	lw	a1,0(s7)
    1068:	8556                	mv	a0,s5
    106a:	00000097          	auipc	ra,0x0
    106e:	ebe080e7          	jalr	-322(ra) # f28 <printint>
    1072:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1074:	4981                	li	s3,0
    1076:	b745                	j	1016 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1078:	008b8913          	add	s2,s7,8
    107c:	4681                	li	a3,0
    107e:	4629                	li	a2,10
    1080:	000ba583          	lw	a1,0(s7)
    1084:	8556                	mv	a0,s5
    1086:	00000097          	auipc	ra,0x0
    108a:	ea2080e7          	jalr	-350(ra) # f28 <printint>
    108e:	8bca                	mv	s7,s2
      state = 0;
    1090:	4981                	li	s3,0
    1092:	b751                	j	1016 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    1094:	008b8913          	add	s2,s7,8
    1098:	4681                	li	a3,0
    109a:	4641                	li	a2,16
    109c:	000ba583          	lw	a1,0(s7)
    10a0:	8556                	mv	a0,s5
    10a2:	00000097          	auipc	ra,0x0
    10a6:	e86080e7          	jalr	-378(ra) # f28 <printint>
    10aa:	8bca                	mv	s7,s2
      state = 0;
    10ac:	4981                	li	s3,0
    10ae:	b7a5                	j	1016 <vprintf+0x42>
    10b0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    10b2:	008b8c13          	add	s8,s7,8
    10b6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    10ba:	03000593          	li	a1,48
    10be:	8556                	mv	a0,s5
    10c0:	00000097          	auipc	ra,0x0
    10c4:	e46080e7          	jalr	-442(ra) # f06 <putc>
  putc(fd, 'x');
    10c8:	07800593          	li	a1,120
    10cc:	8556                	mv	a0,s5
    10ce:	00000097          	auipc	ra,0x0
    10d2:	e38080e7          	jalr	-456(ra) # f06 <putc>
    10d6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    10d8:	00000b97          	auipc	s7,0x0
    10dc:	680b8b93          	add	s7,s7,1664 # 1758 <digits>
    10e0:	03c9d793          	srl	a5,s3,0x3c
    10e4:	97de                	add	a5,a5,s7
    10e6:	0007c583          	lbu	a1,0(a5)
    10ea:	8556                	mv	a0,s5
    10ec:	00000097          	auipc	ra,0x0
    10f0:	e1a080e7          	jalr	-486(ra) # f06 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    10f4:	0992                	sll	s3,s3,0x4
    10f6:	397d                	addw	s2,s2,-1
    10f8:	fe0914e3          	bnez	s2,10e0 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    10fc:	8be2                	mv	s7,s8
      state = 0;
    10fe:	4981                	li	s3,0
    1100:	6c02                	ld	s8,0(sp)
    1102:	bf11                	j	1016 <vprintf+0x42>
        s = va_arg(ap, char*);
    1104:	008b8993          	add	s3,s7,8
    1108:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    110c:	02090163          	beqz	s2,112e <vprintf+0x15a>
        while(*s != 0){
    1110:	00094583          	lbu	a1,0(s2)
    1114:	c9a5                	beqz	a1,1184 <vprintf+0x1b0>
          putc(fd, *s);
    1116:	8556                	mv	a0,s5
    1118:	00000097          	auipc	ra,0x0
    111c:	dee080e7          	jalr	-530(ra) # f06 <putc>
          s++;
    1120:	0905                	add	s2,s2,1
        while(*s != 0){
    1122:	00094583          	lbu	a1,0(s2)
    1126:	f9e5                	bnez	a1,1116 <vprintf+0x142>
        s = va_arg(ap, char*);
    1128:	8bce                	mv	s7,s3
      state = 0;
    112a:	4981                	li	s3,0
    112c:	b5ed                	j	1016 <vprintf+0x42>
          s = "(null)";
    112e:	00000917          	auipc	s2,0x0
    1132:	56a90913          	add	s2,s2,1386 # 1698 <malloc+0x412>
        while(*s != 0){
    1136:	02800593          	li	a1,40
    113a:	bff1                	j	1116 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    113c:	008b8913          	add	s2,s7,8
    1140:	000bc583          	lbu	a1,0(s7)
    1144:	8556                	mv	a0,s5
    1146:	00000097          	auipc	ra,0x0
    114a:	dc0080e7          	jalr	-576(ra) # f06 <putc>
    114e:	8bca                	mv	s7,s2
      state = 0;
    1150:	4981                	li	s3,0
    1152:	b5d1                	j	1016 <vprintf+0x42>
        putc(fd, c);
    1154:	02500593          	li	a1,37
    1158:	8556                	mv	a0,s5
    115a:	00000097          	auipc	ra,0x0
    115e:	dac080e7          	jalr	-596(ra) # f06 <putc>
      state = 0;
    1162:	4981                	li	s3,0
    1164:	bd4d                	j	1016 <vprintf+0x42>
        putc(fd, '%');
    1166:	02500593          	li	a1,37
    116a:	8556                	mv	a0,s5
    116c:	00000097          	auipc	ra,0x0
    1170:	d9a080e7          	jalr	-614(ra) # f06 <putc>
        putc(fd, c);
    1174:	85ca                	mv	a1,s2
    1176:	8556                	mv	a0,s5
    1178:	00000097          	auipc	ra,0x0
    117c:	d8e080e7          	jalr	-626(ra) # f06 <putc>
      state = 0;
    1180:	4981                	li	s3,0
    1182:	bd51                	j	1016 <vprintf+0x42>
        s = va_arg(ap, char*);
    1184:	8bce                	mv	s7,s3
      state = 0;
    1186:	4981                	li	s3,0
    1188:	b579                	j	1016 <vprintf+0x42>
    118a:	74e2                	ld	s1,56(sp)
    118c:	79a2                	ld	s3,40(sp)
    118e:	7a02                	ld	s4,32(sp)
    1190:	6ae2                	ld	s5,24(sp)
    1192:	6b42                	ld	s6,16(sp)
    1194:	6ba2                	ld	s7,8(sp)
    }
  }
}
    1196:	60a6                	ld	ra,72(sp)
    1198:	6406                	ld	s0,64(sp)
    119a:	7942                	ld	s2,48(sp)
    119c:	6161                	add	sp,sp,80
    119e:	8082                	ret

00000000000011a0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    11a0:	715d                	add	sp,sp,-80
    11a2:	ec06                	sd	ra,24(sp)
    11a4:	e822                	sd	s0,16(sp)
    11a6:	1000                	add	s0,sp,32
    11a8:	e010                	sd	a2,0(s0)
    11aa:	e414                	sd	a3,8(s0)
    11ac:	e818                	sd	a4,16(s0)
    11ae:	ec1c                	sd	a5,24(s0)
    11b0:	03043023          	sd	a6,32(s0)
    11b4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    11b8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    11bc:	8622                	mv	a2,s0
    11be:	00000097          	auipc	ra,0x0
    11c2:	e16080e7          	jalr	-490(ra) # fd4 <vprintf>
}
    11c6:	60e2                	ld	ra,24(sp)
    11c8:	6442                	ld	s0,16(sp)
    11ca:	6161                	add	sp,sp,80
    11cc:	8082                	ret

00000000000011ce <printf>:

void
printf(const char *fmt, ...)
{
    11ce:	711d                	add	sp,sp,-96
    11d0:	ec06                	sd	ra,24(sp)
    11d2:	e822                	sd	s0,16(sp)
    11d4:	1000                	add	s0,sp,32
    11d6:	e40c                	sd	a1,8(s0)
    11d8:	e810                	sd	a2,16(s0)
    11da:	ec14                	sd	a3,24(s0)
    11dc:	f018                	sd	a4,32(s0)
    11de:	f41c                	sd	a5,40(s0)
    11e0:	03043823          	sd	a6,48(s0)
    11e4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    11e8:	00840613          	add	a2,s0,8
    11ec:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    11f0:	85aa                	mv	a1,a0
    11f2:	4505                	li	a0,1
    11f4:	00000097          	auipc	ra,0x0
    11f8:	de0080e7          	jalr	-544(ra) # fd4 <vprintf>
}
    11fc:	60e2                	ld	ra,24(sp)
    11fe:	6442                	ld	s0,16(sp)
    1200:	6125                	add	sp,sp,96
    1202:	8082                	ret

0000000000001204 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1204:	1141                	add	sp,sp,-16
    1206:	e422                	sd	s0,8(sp)
    1208:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    120a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    120e:	00001797          	auipc	a5,0x1
    1212:	2b27b783          	ld	a5,690(a5) # 24c0 <freep>
    1216:	a02d                	j	1240 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1218:	4618                	lw	a4,8(a2)
    121a:	9f2d                	addw	a4,a4,a1
    121c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1220:	6398                	ld	a4,0(a5)
    1222:	6310                	ld	a2,0(a4)
    1224:	a83d                	j	1262 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1226:	ff852703          	lw	a4,-8(a0)
    122a:	9f31                	addw	a4,a4,a2
    122c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    122e:	ff053683          	ld	a3,-16(a0)
    1232:	a091                	j	1276 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1234:	6398                	ld	a4,0(a5)
    1236:	00e7e463          	bltu	a5,a4,123e <free+0x3a>
    123a:	00e6ea63          	bltu	a3,a4,124e <free+0x4a>
{
    123e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1240:	fed7fae3          	bgeu	a5,a3,1234 <free+0x30>
    1244:	6398                	ld	a4,0(a5)
    1246:	00e6e463          	bltu	a3,a4,124e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    124a:	fee7eae3          	bltu	a5,a4,123e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    124e:	ff852583          	lw	a1,-8(a0)
    1252:	6390                	ld	a2,0(a5)
    1254:	02059813          	sll	a6,a1,0x20
    1258:	01c85713          	srl	a4,a6,0x1c
    125c:	9736                	add	a4,a4,a3
    125e:	fae60de3          	beq	a2,a4,1218 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1262:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1266:	4790                	lw	a2,8(a5)
    1268:	02061593          	sll	a1,a2,0x20
    126c:	01c5d713          	srl	a4,a1,0x1c
    1270:	973e                	add	a4,a4,a5
    1272:	fae68ae3          	beq	a3,a4,1226 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1276:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1278:	00001717          	auipc	a4,0x1
    127c:	24f73423          	sd	a5,584(a4) # 24c0 <freep>
}
    1280:	6422                	ld	s0,8(sp)
    1282:	0141                	add	sp,sp,16
    1284:	8082                	ret

0000000000001286 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1286:	7139                	add	sp,sp,-64
    1288:	fc06                	sd	ra,56(sp)
    128a:	f822                	sd	s0,48(sp)
    128c:	f426                	sd	s1,40(sp)
    128e:	ec4e                	sd	s3,24(sp)
    1290:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1292:	02051493          	sll	s1,a0,0x20
    1296:	9081                	srl	s1,s1,0x20
    1298:	04bd                	add	s1,s1,15
    129a:	8091                	srl	s1,s1,0x4
    129c:	0014899b          	addw	s3,s1,1
    12a0:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    12a2:	00001517          	auipc	a0,0x1
    12a6:	21e53503          	ld	a0,542(a0) # 24c0 <freep>
    12aa:	c915                	beqz	a0,12de <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12ae:	4798                	lw	a4,8(a5)
    12b0:	08977e63          	bgeu	a4,s1,134c <malloc+0xc6>
    12b4:	f04a                	sd	s2,32(sp)
    12b6:	e852                	sd	s4,16(sp)
    12b8:	e456                	sd	s5,8(sp)
    12ba:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    12bc:	8a4e                	mv	s4,s3
    12be:	0009871b          	sext.w	a4,s3
    12c2:	6685                	lui	a3,0x1
    12c4:	00d77363          	bgeu	a4,a3,12ca <malloc+0x44>
    12c8:	6a05                	lui	s4,0x1
    12ca:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    12ce:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    12d2:	00001917          	auipc	s2,0x1
    12d6:	1ee90913          	add	s2,s2,494 # 24c0 <freep>
  if(p == (char*)-1)
    12da:	5afd                	li	s5,-1
    12dc:	a091                	j	1320 <malloc+0x9a>
    12de:	f04a                	sd	s2,32(sp)
    12e0:	e852                	sd	s4,16(sp)
    12e2:	e456                	sd	s5,8(sp)
    12e4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    12e6:	00001797          	auipc	a5,0x1
    12ea:	5d278793          	add	a5,a5,1490 # 28b8 <base>
    12ee:	00001717          	auipc	a4,0x1
    12f2:	1cf73923          	sd	a5,466(a4) # 24c0 <freep>
    12f6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    12f8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    12fc:	b7c1                	j	12bc <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    12fe:	6398                	ld	a4,0(a5)
    1300:	e118                	sd	a4,0(a0)
    1302:	a08d                	j	1364 <malloc+0xde>
  hp->s.size = nu;
    1304:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1308:	0541                	add	a0,a0,16
    130a:	00000097          	auipc	ra,0x0
    130e:	efa080e7          	jalr	-262(ra) # 1204 <free>
  return freep;
    1312:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1316:	c13d                	beqz	a0,137c <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1318:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    131a:	4798                	lw	a4,8(a5)
    131c:	02977463          	bgeu	a4,s1,1344 <malloc+0xbe>
    if(p == freep)
    1320:	00093703          	ld	a4,0(s2)
    1324:	853e                	mv	a0,a5
    1326:	fef719e3          	bne	a4,a5,1318 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    132a:	8552                	mv	a0,s4
    132c:	00000097          	auipc	ra,0x0
    1330:	bb2080e7          	jalr	-1102(ra) # ede <sbrk>
  if(p == (char*)-1)
    1334:	fd5518e3          	bne	a0,s5,1304 <malloc+0x7e>
        return 0;
    1338:	4501                	li	a0,0
    133a:	7902                	ld	s2,32(sp)
    133c:	6a42                	ld	s4,16(sp)
    133e:	6aa2                	ld	s5,8(sp)
    1340:	6b02                	ld	s6,0(sp)
    1342:	a03d                	j	1370 <malloc+0xea>
    1344:	7902                	ld	s2,32(sp)
    1346:	6a42                	ld	s4,16(sp)
    1348:	6aa2                	ld	s5,8(sp)
    134a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    134c:	fae489e3          	beq	s1,a4,12fe <malloc+0x78>
        p->s.size -= nunits;
    1350:	4137073b          	subw	a4,a4,s3
    1354:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1356:	02071693          	sll	a3,a4,0x20
    135a:	01c6d713          	srl	a4,a3,0x1c
    135e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1360:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1364:	00001717          	auipc	a4,0x1
    1368:	14a73e23          	sd	a0,348(a4) # 24c0 <freep>
      return (void*)(p + 1);
    136c:	01078513          	add	a0,a5,16
  }
}
    1370:	70e2                	ld	ra,56(sp)
    1372:	7442                	ld	s0,48(sp)
    1374:	74a2                	ld	s1,40(sp)
    1376:	69e2                	ld	s3,24(sp)
    1378:	6121                	add	sp,sp,64
    137a:	8082                	ret
    137c:	7902                	ld	s2,32(sp)
    137e:	6a42                	ld	s4,16(sp)
    1380:	6aa2                	ld	s5,8(sp)
    1382:	6b02                	ld	s6,0(sp)
    1384:	b7f5                	j	1370 <malloc+0xea>
