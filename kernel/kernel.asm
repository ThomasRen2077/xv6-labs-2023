
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	38013103          	ld	sp,896(sp) # 8000b380 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	add	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	339050ef          	jal	80005b4e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	add	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	add	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	sll	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00025797          	auipc	a5,0x25
    80000034:	81078793          	add	a5,a5,-2032 # 80024840 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	sll	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	0000b917          	auipc	s2,0xb
    80000054:	38090913          	add	s2,s2,896 # 8000b3d0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	542080e7          	jalr	1346(ra) # 8000659c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	5e2080e7          	jalr	1506(ra) # 80006650 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	add	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f7e50513          	add	a0,a0,-130 # 80008000 <etext>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	f98080e7          	jalr	-104(ra) # 80006022 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	add	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	1800                	add	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000009c:	6785                	lui	a5,0x1
    8000009e:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a2:	00e504b3          	add	s1,a0,a4
    800000a6:	777d                	lui	a4,0xfffff
    800000a8:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	94be                	add	s1,s1,a5
    800000ac:	0295e463          	bltu	a1,s1,800000d4 <freerange+0x42>
    800000b0:	e84a                	sd	s2,16(sp)
    800000b2:	e44e                	sd	s3,8(sp)
    800000b4:	e052                	sd	s4,0(sp)
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
    800000ce:	6942                	ld	s2,16(sp)
    800000d0:	69a2                	ld	s3,8(sp)
    800000d2:	6a02                	ld	s4,0(sp)
}
    800000d4:	70a2                	ld	ra,40(sp)
    800000d6:	7402                	ld	s0,32(sp)
    800000d8:	64e2                	ld	s1,24(sp)
    800000da:	6145                	add	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	add	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f2a58593          	add	a1,a1,-214 # 80008010 <etext+0x10>
    800000ee:	0000b517          	auipc	a0,0xb
    800000f2:	2e250513          	add	a0,a0,738 # 8000b3d0 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	416080e7          	jalr	1046(ra) # 8000650c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	sll	a1,a1,0x1b
    80000102:	00024517          	auipc	a0,0x24
    80000106:	73e50513          	add	a0,a0,1854 # 80024840 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	add	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	add	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	0000b497          	auipc	s1,0xb
    80000128:	2ac48493          	add	s1,s1,684 # 8000b3d0 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	46e080e7          	jalr	1134(ra) # 8000659c <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	0000b517          	auipc	a0,0xb
    80000140:	29450513          	add	a0,a0,660 # 8000b3d0 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	50a080e7          	jalr	1290(ra) # 80006650 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	add	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	0000b517          	auipc	a0,0xb
    8000016c:	26850513          	add	a0,a0,616 # 8000b3d0 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	4e0080e7          	jalr	1248(ra) # 80006650 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	add	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	sll	a2,a2,0x20
    80000186:	9201                	srl	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	add	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	add	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	add	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	sll	a3,a3,0x20
    800001aa:	9281                	srl	a3,a3,0x20
    800001ac:	0685                	add	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	add	a0,a0,1
    800001be:	0585                	add	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	add	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	add	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	sll	a2,a2,0x20
    800001e4:	9201                	srl	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	add	a1,a1,1
    800001ee:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffda7c1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	feb79ae3          	bne	a5,a1,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	add	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	sll	a3,a2,0x20
    80000206:	9281                	srl	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addw	a5,a2,-1
    80000216:	1782                	sll	a5,a5,0x20
    80000218:	9381                	srl	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	add	a4,a4,-1
    80000222:	16fd                	add	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fef71ae3          	bne	a4,a5,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	add	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	add	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	add	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addw	a2,a2,-1
    80000262:	0505                	add	a0,a0,1
    80000264:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a801                	j	8000027a <strncmp+0x30>
    8000026c:	4501                	li	a0,0
    8000026e:	a031                	j	8000027a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	add	sp,sp,16
    8000027e:	8082                	ret

0000000080000280 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000280:	1141                	add	sp,sp,-16
    80000282:	e422                	sd	s0,8(sp)
    80000284:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000286:	87aa                	mv	a5,a0
    80000288:	86b2                	mv	a3,a2
    8000028a:	367d                	addw	a2,a2,-1
    8000028c:	02d05563          	blez	a3,800002b6 <strncpy+0x36>
    80000290:	0785                	add	a5,a5,1
    80000292:	0005c703          	lbu	a4,0(a1)
    80000296:	fee78fa3          	sb	a4,-1(a5)
    8000029a:	0585                	add	a1,a1,1
    8000029c:	f775                	bnez	a4,80000288 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000029e:	873e                	mv	a4,a5
    800002a0:	9fb5                	addw	a5,a5,a3
    800002a2:	37fd                	addw	a5,a5,-1
    800002a4:	00c05963          	blez	a2,800002b6 <strncpy+0x36>
    *s++ = 0;
    800002a8:	0705                	add	a4,a4,1
    800002aa:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002ae:	40e786bb          	subw	a3,a5,a4
    800002b2:	fed04be3          	bgtz	a3,800002a8 <strncpy+0x28>
  return os;
}
    800002b6:	6422                	ld	s0,8(sp)
    800002b8:	0141                	add	sp,sp,16
    800002ba:	8082                	ret

00000000800002bc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002bc:	1141                	add	sp,sp,-16
    800002be:	e422                	sd	s0,8(sp)
    800002c0:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c2:	02c05363          	blez	a2,800002e8 <safestrcpy+0x2c>
    800002c6:	fff6069b          	addw	a3,a2,-1
    800002ca:	1682                	sll	a3,a3,0x20
    800002cc:	9281                	srl	a3,a3,0x20
    800002ce:	96ae                	add	a3,a3,a1
    800002d0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d2:	00d58963          	beq	a1,a3,800002e4 <safestrcpy+0x28>
    800002d6:	0585                	add	a1,a1,1
    800002d8:	0785                	add	a5,a5,1
    800002da:	fff5c703          	lbu	a4,-1(a1)
    800002de:	fee78fa3          	sb	a4,-1(a5)
    800002e2:	fb65                	bnez	a4,800002d2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002e4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002e8:	6422                	ld	s0,8(sp)
    800002ea:	0141                	add	sp,sp,16
    800002ec:	8082                	ret

00000000800002ee <strlen>:

int
strlen(const char *s)
{
    800002ee:	1141                	add	sp,sp,-16
    800002f0:	e422                	sd	s0,8(sp)
    800002f2:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002f4:	00054783          	lbu	a5,0(a0)
    800002f8:	cf91                	beqz	a5,80000314 <strlen+0x26>
    800002fa:	0505                	add	a0,a0,1
    800002fc:	87aa                	mv	a5,a0
    800002fe:	86be                	mv	a3,a5
    80000300:	0785                	add	a5,a5,1
    80000302:	fff7c703          	lbu	a4,-1(a5)
    80000306:	ff65                	bnez	a4,800002fe <strlen+0x10>
    80000308:	40a6853b          	subw	a0,a3,a0
    8000030c:	2505                	addw	a0,a0,1
    ;
  return n;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	add	sp,sp,16
    80000312:	8082                	ret
  for(n = 0; s[n]; n++)
    80000314:	4501                	li	a0,0
    80000316:	bfe5                	j	8000030e <strlen+0x20>

0000000080000318 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000318:	1141                	add	sp,sp,-16
    8000031a:	e406                	sd	ra,8(sp)
    8000031c:	e022                	sd	s0,0(sp)
    8000031e:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80000320:	00001097          	auipc	ra,0x1
    80000324:	ca2080e7          	jalr	-862(ra) # 80000fc2 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000328:	0000b717          	auipc	a4,0xb
    8000032c:	07870713          	add	a4,a4,120 # 8000b3a0 <started>
  if(cpuid() == 0){
    80000330:	c139                	beqz	a0,80000376 <main+0x5e>
    while(started == 0)
    80000332:	431c                	lw	a5,0(a4)
    80000334:	2781                	sext.w	a5,a5
    80000336:	dff5                	beqz	a5,80000332 <main+0x1a>
      ;
    __sync_synchronize();
    80000338:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000033c:	00001097          	auipc	ra,0x1
    80000340:	c86080e7          	jalr	-890(ra) # 80000fc2 <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	add	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	d1e080e7          	jalr	-738(ra) # 8000606c <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00002097          	auipc	ra,0x2
    80000362:	9b8080e7          	jalr	-1608(ra) # 80001d16 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	15e080e7          	jalr	350(ra) # 800054c4 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	200080e7          	jalr	512(ra) # 8000156e <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	bbc080e7          	jalr	-1092(ra) # 80005f32 <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	ef6080e7          	jalr	-266(ra) # 80006274 <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	add	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	cde080e7          	jalr	-802(ra) # 8000606c <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	add	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	cce080e7          	jalr	-818(ra) # 8000606c <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	add	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	cbe080e7          	jalr	-834(ra) # 8000606c <printf>
    kinit();         // physical page allocator
    800003b6:	00000097          	auipc	ra,0x0
    800003ba:	d28080e7          	jalr	-728(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	34a080e7          	jalr	842(ra) # 80000708 <kvminit>
    kvminithart();   // turn on paging
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	068080e7          	jalr	104(ra) # 8000042e <kvminithart>
    procinit();      // process table
    800003ce:	00001097          	auipc	ra,0x1
    800003d2:	b34080e7          	jalr	-1228(ra) # 80000f02 <procinit>
    trapinit();      // trap vectors
    800003d6:	00002097          	auipc	ra,0x2
    800003da:	918080e7          	jalr	-1768(ra) # 80001cee <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	938080e7          	jalr	-1736(ra) # 80001d16 <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	0c4080e7          	jalr	196(ra) # 800054aa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	0d6080e7          	jalr	214(ra) # 800054c4 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	17e080e7          	jalr	382(ra) # 80002574 <binit>
    iinit();         // inode table
    800003fe:	00003097          	auipc	ra,0x3
    80000402:	834080e7          	jalr	-1996(ra) # 80002c32 <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	7e4080e7          	jalr	2020(ra) # 80003bea <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	1be080e7          	jalr	446(ra) # 800055cc <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	f38080e7          	jalr	-200(ra) # 8000134e <userinit>
    __sync_synchronize();
    8000041e:	0330000f          	fence	rw,rw
    started = 1;
    80000422:	4785                	li	a5,1
    80000424:	0000b717          	auipc	a4,0xb
    80000428:	f6f72e23          	sw	a5,-132(a4) # 8000b3a0 <started>
    8000042c:	b789                	j	8000036e <main+0x56>

000000008000042e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000042e:	1141                	add	sp,sp,-16
    80000430:	e422                	sd	s0,8(sp)
    80000432:	0800                	add	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000434:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000438:	0000b797          	auipc	a5,0xb
    8000043c:	f707b783          	ld	a5,-144(a5) # 8000b3a8 <kernel_pagetable>
    80000440:	83b1                	srl	a5,a5,0xc
    80000442:	577d                	li	a4,-1
    80000444:	177e                	sll	a4,a4,0x3f
    80000446:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000448:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000044c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000450:	6422                	ld	s0,8(sp)
    80000452:	0141                	add	sp,sp,16
    80000454:	8082                	ret

0000000080000456 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000456:	7139                	add	sp,sp,-64
    80000458:	fc06                	sd	ra,56(sp)
    8000045a:	f822                	sd	s0,48(sp)
    8000045c:	f426                	sd	s1,40(sp)
    8000045e:	f04a                	sd	s2,32(sp)
    80000460:	ec4e                	sd	s3,24(sp)
    80000462:	e852                	sd	s4,16(sp)
    80000464:	e456                	sd	s5,8(sp)
    80000466:	e05a                	sd	s6,0(sp)
    80000468:	0080                	add	s0,sp,64
    8000046a:	84aa                	mv	s1,a0
    8000046c:	89ae                	mv	s3,a1
    8000046e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000470:	57fd                	li	a5,-1
    80000472:	83e9                	srl	a5,a5,0x1a
    80000474:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000476:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000478:	04b7f263          	bgeu	a5,a1,800004bc <walk+0x66>
    panic("walk");
    8000047c:	00008517          	auipc	a0,0x8
    80000480:	bd450513          	add	a0,a0,-1068 # 80008050 <etext+0x50>
    80000484:	00006097          	auipc	ra,0x6
    80000488:	b9e080e7          	jalr	-1122(ra) # 80006022 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000048c:	060a8663          	beqz	s5,800004f8 <walk+0xa2>
    80000490:	00000097          	auipc	ra,0x0
    80000494:	c8a080e7          	jalr	-886(ra) # 8000011a <kalloc>
    80000498:	84aa                	mv	s1,a0
    8000049a:	c529                	beqz	a0,800004e4 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000049c:	6605                	lui	a2,0x1
    8000049e:	4581                	li	a1,0
    800004a0:	00000097          	auipc	ra,0x0
    800004a4:	cda080e7          	jalr	-806(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004a8:	00c4d793          	srl	a5,s1,0xc
    800004ac:	07aa                	sll	a5,a5,0xa
    800004ae:	0017e793          	or	a5,a5,1
    800004b2:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004b6:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffda7b7>
    800004b8:	036a0063          	beq	s4,s6,800004d8 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004bc:	0149d933          	srl	s2,s3,s4
    800004c0:	1ff97913          	and	s2,s2,511
    800004c4:	090e                	sll	s2,s2,0x3
    800004c6:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004c8:	00093483          	ld	s1,0(s2)
    800004cc:	0014f793          	and	a5,s1,1
    800004d0:	dfd5                	beqz	a5,8000048c <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d2:	80a9                	srl	s1,s1,0xa
    800004d4:	04b2                	sll	s1,s1,0xc
    800004d6:	b7c5                	j	800004b6 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004d8:	00c9d513          	srl	a0,s3,0xc
    800004dc:	1ff57513          	and	a0,a0,511
    800004e0:	050e                	sll	a0,a0,0x3
    800004e2:	9526                	add	a0,a0,s1
}
    800004e4:	70e2                	ld	ra,56(sp)
    800004e6:	7442                	ld	s0,48(sp)
    800004e8:	74a2                	ld	s1,40(sp)
    800004ea:	7902                	ld	s2,32(sp)
    800004ec:	69e2                	ld	s3,24(sp)
    800004ee:	6a42                	ld	s4,16(sp)
    800004f0:	6aa2                	ld	s5,8(sp)
    800004f2:	6b02                	ld	s6,0(sp)
    800004f4:	6121                	add	sp,sp,64
    800004f6:	8082                	ret
        return 0;
    800004f8:	4501                	li	a0,0
    800004fa:	b7ed                	j	800004e4 <walk+0x8e>

00000000800004fc <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800004fc:	57fd                	li	a5,-1
    800004fe:	83e9                	srl	a5,a5,0x1a
    80000500:	00b7f463          	bgeu	a5,a1,80000508 <walkaddr+0xc>
    return 0;
    80000504:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000506:	8082                	ret
{
    80000508:	1141                	add	sp,sp,-16
    8000050a:	e406                	sd	ra,8(sp)
    8000050c:	e022                	sd	s0,0(sp)
    8000050e:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000510:	4601                	li	a2,0
    80000512:	00000097          	auipc	ra,0x0
    80000516:	f44080e7          	jalr	-188(ra) # 80000456 <walk>
  if(pte == 0)
    8000051a:	c105                	beqz	a0,8000053a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000051c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000051e:	0117f693          	and	a3,a5,17
    80000522:	4745                	li	a4,17
    return 0;
    80000524:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000526:	00e68663          	beq	a3,a4,80000532 <walkaddr+0x36>
}
    8000052a:	60a2                	ld	ra,8(sp)
    8000052c:	6402                	ld	s0,0(sp)
    8000052e:	0141                	add	sp,sp,16
    80000530:	8082                	ret
  pa = PTE2PA(*pte);
    80000532:	83a9                	srl	a5,a5,0xa
    80000534:	00c79513          	sll	a0,a5,0xc
  return pa;
    80000538:	bfcd                	j	8000052a <walkaddr+0x2e>
    return 0;
    8000053a:	4501                	li	a0,0
    8000053c:	b7fd                	j	8000052a <walkaddr+0x2e>

000000008000053e <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000053e:	715d                	add	sp,sp,-80
    80000540:	e486                	sd	ra,72(sp)
    80000542:	e0a2                	sd	s0,64(sp)
    80000544:	fc26                	sd	s1,56(sp)
    80000546:	f84a                	sd	s2,48(sp)
    80000548:	f44e                	sd	s3,40(sp)
    8000054a:	f052                	sd	s4,32(sp)
    8000054c:	ec56                	sd	s5,24(sp)
    8000054e:	e85a                	sd	s6,16(sp)
    80000550:	e45e                	sd	s7,8(sp)
    80000552:	0880                	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000554:	03459793          	sll	a5,a1,0x34
    80000558:	e7b9                	bnez	a5,800005a6 <mappages+0x68>
    8000055a:	8aaa                	mv	s5,a0
    8000055c:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000055e:	03461793          	sll	a5,a2,0x34
    80000562:	ebb1                	bnez	a5,800005b6 <mappages+0x78>
    panic("mappages: size not aligned");

  if(size == 0)
    80000564:	c22d                	beqz	a2,800005c6 <mappages+0x88>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000566:	77fd                	lui	a5,0xfffff
    80000568:	963e                	add	a2,a2,a5
    8000056a:	00b609b3          	add	s3,a2,a1
  a = va;
    8000056e:	892e                	mv	s2,a1
    80000570:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000574:	6b85                	lui	s7,0x1
    80000576:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057a:	4605                	li	a2,1
    8000057c:	85ca                	mv	a1,s2
    8000057e:	8556                	mv	a0,s5
    80000580:	00000097          	auipc	ra,0x0
    80000584:	ed6080e7          	jalr	-298(ra) # 80000456 <walk>
    80000588:	cd39                	beqz	a0,800005e6 <mappages+0xa8>
    if(*pte & PTE_V)
    8000058a:	611c                	ld	a5,0(a0)
    8000058c:	8b85                	and	a5,a5,1
    8000058e:	e7a1                	bnez	a5,800005d6 <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000590:	80b1                	srl	s1,s1,0xc
    80000592:	04aa                	sll	s1,s1,0xa
    80000594:	0164e4b3          	or	s1,s1,s6
    80000598:	0014e493          	or	s1,s1,1
    8000059c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000059e:	07390063          	beq	s2,s3,800005fe <mappages+0xc0>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	bfc9                	j	80000576 <mappages+0x38>
    panic("mappages: va not aligned");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ab250513          	add	a0,a0,-1358 # 80008058 <etext+0x58>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	a74080e7          	jalr	-1420(ra) # 80006022 <panic>
    panic("mappages: size not aligned");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ac250513          	add	a0,a0,-1342 # 80008078 <etext+0x78>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	a64080e7          	jalr	-1436(ra) # 80006022 <panic>
    panic("mappages: size");
    800005c6:	00008517          	auipc	a0,0x8
    800005ca:	ad250513          	add	a0,a0,-1326 # 80008098 <etext+0x98>
    800005ce:	00006097          	auipc	ra,0x6
    800005d2:	a54080e7          	jalr	-1452(ra) # 80006022 <panic>
      panic("mappages: remap");
    800005d6:	00008517          	auipc	a0,0x8
    800005da:	ad250513          	add	a0,a0,-1326 # 800080a8 <etext+0xa8>
    800005de:	00006097          	auipc	ra,0x6
    800005e2:	a44080e7          	jalr	-1468(ra) # 80006022 <panic>
      return -1;
    800005e6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005e8:	60a6                	ld	ra,72(sp)
    800005ea:	6406                	ld	s0,64(sp)
    800005ec:	74e2                	ld	s1,56(sp)
    800005ee:	7942                	ld	s2,48(sp)
    800005f0:	79a2                	ld	s3,40(sp)
    800005f2:	7a02                	ld	s4,32(sp)
    800005f4:	6ae2                	ld	s5,24(sp)
    800005f6:	6b42                	ld	s6,16(sp)
    800005f8:	6ba2                	ld	s7,8(sp)
    800005fa:	6161                	add	sp,sp,80
    800005fc:	8082                	ret
  return 0;
    800005fe:	4501                	li	a0,0
    80000600:	b7e5                	j	800005e8 <mappages+0xaa>

0000000080000602 <kvmmap>:
{
    80000602:	1141                	add	sp,sp,-16
    80000604:	e406                	sd	ra,8(sp)
    80000606:	e022                	sd	s0,0(sp)
    80000608:	0800                	add	s0,sp,16
    8000060a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000060c:	86b2                	mv	a3,a2
    8000060e:	863e                	mv	a2,a5
    80000610:	00000097          	auipc	ra,0x0
    80000614:	f2e080e7          	jalr	-210(ra) # 8000053e <mappages>
    80000618:	e509                	bnez	a0,80000622 <kvmmap+0x20>
}
    8000061a:	60a2                	ld	ra,8(sp)
    8000061c:	6402                	ld	s0,0(sp)
    8000061e:	0141                	add	sp,sp,16
    80000620:	8082                	ret
    panic("kvmmap");
    80000622:	00008517          	auipc	a0,0x8
    80000626:	a9650513          	add	a0,a0,-1386 # 800080b8 <etext+0xb8>
    8000062a:	00006097          	auipc	ra,0x6
    8000062e:	9f8080e7          	jalr	-1544(ra) # 80006022 <panic>

0000000080000632 <kvmmake>:
{
    80000632:	1101                	add	sp,sp,-32
    80000634:	ec06                	sd	ra,24(sp)
    80000636:	e822                	sd	s0,16(sp)
    80000638:	e426                	sd	s1,8(sp)
    8000063a:	e04a                	sd	s2,0(sp)
    8000063c:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000063e:	00000097          	auipc	ra,0x0
    80000642:	adc080e7          	jalr	-1316(ra) # 8000011a <kalloc>
    80000646:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000648:	6605                	lui	a2,0x1
    8000064a:	4581                	li	a1,0
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	b2e080e7          	jalr	-1234(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000654:	4719                	li	a4,6
    80000656:	6685                	lui	a3,0x1
    80000658:	10000637          	lui	a2,0x10000
    8000065c:	100005b7          	lui	a1,0x10000
    80000660:	8526                	mv	a0,s1
    80000662:	00000097          	auipc	ra,0x0
    80000666:	fa0080e7          	jalr	-96(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000066a:	4719                	li	a4,6
    8000066c:	6685                	lui	a3,0x1
    8000066e:	10001637          	lui	a2,0x10001
    80000672:	100015b7          	lui	a1,0x10001
    80000676:	8526                	mv	a0,s1
    80000678:	00000097          	auipc	ra,0x0
    8000067c:	f8a080e7          	jalr	-118(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000680:	4719                	li	a4,6
    80000682:	004006b7          	lui	a3,0x400
    80000686:	0c000637          	lui	a2,0xc000
    8000068a:	0c0005b7          	lui	a1,0xc000
    8000068e:	8526                	mv	a0,s1
    80000690:	00000097          	auipc	ra,0x0
    80000694:	f72080e7          	jalr	-142(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000698:	00008917          	auipc	s2,0x8
    8000069c:	96890913          	add	s2,s2,-1688 # 80008000 <etext>
    800006a0:	4729                	li	a4,10
    800006a2:	80008697          	auipc	a3,0x80008
    800006a6:	95e68693          	add	a3,a3,-1698 # 8000 <_entry-0x7fff8000>
    800006aa:	4605                	li	a2,1
    800006ac:	067e                	sll	a2,a2,0x1f
    800006ae:	85b2                	mv	a1,a2
    800006b0:	8526                	mv	a0,s1
    800006b2:	00000097          	auipc	ra,0x0
    800006b6:	f50080e7          	jalr	-176(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006ba:	46c5                	li	a3,17
    800006bc:	06ee                	sll	a3,a3,0x1b
    800006be:	4719                	li	a4,6
    800006c0:	412686b3          	sub	a3,a3,s2
    800006c4:	864a                	mv	a2,s2
    800006c6:	85ca                	mv	a1,s2
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	f38080e7          	jalr	-200(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006d2:	4729                	li	a4,10
    800006d4:	6685                	lui	a3,0x1
    800006d6:	00007617          	auipc	a2,0x7
    800006da:	92a60613          	add	a2,a2,-1750 # 80007000 <_trampoline>
    800006de:	040005b7          	lui	a1,0x4000
    800006e2:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006e4:	05b2                	sll	a1,a1,0xc
    800006e6:	8526                	mv	a0,s1
    800006e8:	00000097          	auipc	ra,0x0
    800006ec:	f1a080e7          	jalr	-230(ra) # 80000602 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006f0:	8526                	mv	a0,s1
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	76e080e7          	jalr	1902(ra) # 80000e60 <proc_mapstacks>
}
    800006fa:	8526                	mv	a0,s1
    800006fc:	60e2                	ld	ra,24(sp)
    800006fe:	6442                	ld	s0,16(sp)
    80000700:	64a2                	ld	s1,8(sp)
    80000702:	6902                	ld	s2,0(sp)
    80000704:	6105                	add	sp,sp,32
    80000706:	8082                	ret

0000000080000708 <kvminit>:
{
    80000708:	1141                	add	sp,sp,-16
    8000070a:	e406                	sd	ra,8(sp)
    8000070c:	e022                	sd	s0,0(sp)
    8000070e:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    80000710:	00000097          	auipc	ra,0x0
    80000714:	f22080e7          	jalr	-222(ra) # 80000632 <kvmmake>
    80000718:	0000b797          	auipc	a5,0xb
    8000071c:	c8a7b823          	sd	a0,-880(a5) # 8000b3a8 <kernel_pagetable>
}
    80000720:	60a2                	ld	ra,8(sp)
    80000722:	6402                	ld	s0,0(sp)
    80000724:	0141                	add	sp,sp,16
    80000726:	8082                	ret

0000000080000728 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000728:	715d                	add	sp,sp,-80
    8000072a:	e486                	sd	ra,72(sp)
    8000072c:	e0a2                	sd	s0,64(sp)
    8000072e:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000730:	03459793          	sll	a5,a1,0x34
    80000734:	e39d                	bnez	a5,8000075a <uvmunmap+0x32>
    80000736:	f84a                	sd	s2,48(sp)
    80000738:	f44e                	sd	s3,40(sp)
    8000073a:	f052                	sd	s4,32(sp)
    8000073c:	ec56                	sd	s5,24(sp)
    8000073e:	e85a                	sd	s6,16(sp)
    80000740:	e45e                	sd	s7,8(sp)
    80000742:	8a2a                	mv	s4,a0
    80000744:	892e                	mv	s2,a1
    80000746:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000748:	0632                	sll	a2,a2,0xc
    8000074a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000074e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000750:	6b05                	lui	s6,0x1
    80000752:	0935fb63          	bgeu	a1,s3,800007e8 <uvmunmap+0xc0>
    80000756:	fc26                	sd	s1,56(sp)
    80000758:	a8a9                	j	800007b2 <uvmunmap+0x8a>
    8000075a:	fc26                	sd	s1,56(sp)
    8000075c:	f84a                	sd	s2,48(sp)
    8000075e:	f44e                	sd	s3,40(sp)
    80000760:	f052                	sd	s4,32(sp)
    80000762:	ec56                	sd	s5,24(sp)
    80000764:	e85a                	sd	s6,16(sp)
    80000766:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	95850513          	add	a0,a0,-1704 # 800080c0 <etext+0xc0>
    80000770:	00006097          	auipc	ra,0x6
    80000774:	8b2080e7          	jalr	-1870(ra) # 80006022 <panic>
      panic("uvmunmap: walk");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	96050513          	add	a0,a0,-1696 # 800080d8 <etext+0xd8>
    80000780:	00006097          	auipc	ra,0x6
    80000784:	8a2080e7          	jalr	-1886(ra) # 80006022 <panic>
      panic("uvmunmap: not mapped");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	96050513          	add	a0,a0,-1696 # 800080e8 <etext+0xe8>
    80000790:	00006097          	auipc	ra,0x6
    80000794:	892080e7          	jalr	-1902(ra) # 80006022 <panic>
      panic("uvmunmap: not a leaf");
    80000798:	00008517          	auipc	a0,0x8
    8000079c:	96850513          	add	a0,a0,-1688 # 80008100 <etext+0x100>
    800007a0:	00006097          	auipc	ra,0x6
    800007a4:	882080e7          	jalr	-1918(ra) # 80006022 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800007a8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ac:	995a                	add	s2,s2,s6
    800007ae:	03397c63          	bgeu	s2,s3,800007e6 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007b2:	4601                	li	a2,0
    800007b4:	85ca                	mv	a1,s2
    800007b6:	8552                	mv	a0,s4
    800007b8:	00000097          	auipc	ra,0x0
    800007bc:	c9e080e7          	jalr	-866(ra) # 80000456 <walk>
    800007c0:	84aa                	mv	s1,a0
    800007c2:	d95d                	beqz	a0,80000778 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    800007c4:	6108                	ld	a0,0(a0)
    800007c6:	00157793          	and	a5,a0,1
    800007ca:	dfdd                	beqz	a5,80000788 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007cc:	3ff57793          	and	a5,a0,1023
    800007d0:	fd7784e3          	beq	a5,s7,80000798 <uvmunmap+0x70>
    if(do_free){
    800007d4:	fc0a8ae3          	beqz	s5,800007a8 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800007d8:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    800007da:	0532                	sll	a0,a0,0xc
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	840080e7          	jalr	-1984(ra) # 8000001c <kfree>
    800007e4:	b7d1                	j	800007a8 <uvmunmap+0x80>
    800007e6:	74e2                	ld	s1,56(sp)
    800007e8:	7942                	ld	s2,48(sp)
    800007ea:	79a2                	ld	s3,40(sp)
    800007ec:	7a02                	ld	s4,32(sp)
    800007ee:	6ae2                	ld	s5,24(sp)
    800007f0:	6b42                	ld	s6,16(sp)
    800007f2:	6ba2                	ld	s7,8(sp)
  }
}
    800007f4:	60a6                	ld	ra,72(sp)
    800007f6:	6406                	ld	s0,64(sp)
    800007f8:	6161                	add	sp,sp,80
    800007fa:	8082                	ret

00000000800007fc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007fc:	1101                	add	sp,sp,-32
    800007fe:	ec06                	sd	ra,24(sp)
    80000800:	e822                	sd	s0,16(sp)
    80000802:	e426                	sd	s1,8(sp)
    80000804:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000806:	00000097          	auipc	ra,0x0
    8000080a:	914080e7          	jalr	-1772(ra) # 8000011a <kalloc>
    8000080e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000810:	c519                	beqz	a0,8000081e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000812:	6605                	lui	a2,0x1
    80000814:	4581                	li	a1,0
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	964080e7          	jalr	-1692(ra) # 8000017a <memset>
  return pagetable;
}
    8000081e:	8526                	mv	a0,s1
    80000820:	60e2                	ld	ra,24(sp)
    80000822:	6442                	ld	s0,16(sp)
    80000824:	64a2                	ld	s1,8(sp)
    80000826:	6105                	add	sp,sp,32
    80000828:	8082                	ret

000000008000082a <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000082a:	7179                	add	sp,sp,-48
    8000082c:	f406                	sd	ra,40(sp)
    8000082e:	f022                	sd	s0,32(sp)
    80000830:	ec26                	sd	s1,24(sp)
    80000832:	e84a                	sd	s2,16(sp)
    80000834:	e44e                	sd	s3,8(sp)
    80000836:	e052                	sd	s4,0(sp)
    80000838:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000083a:	6785                	lui	a5,0x1
    8000083c:	04f67863          	bgeu	a2,a5,8000088c <uvmfirst+0x62>
    80000840:	8a2a                	mv	s4,a0
    80000842:	89ae                	mv	s3,a1
    80000844:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	8d4080e7          	jalr	-1836(ra) # 8000011a <kalloc>
    8000084e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000850:	6605                	lui	a2,0x1
    80000852:	4581                	li	a1,0
    80000854:	00000097          	auipc	ra,0x0
    80000858:	926080e7          	jalr	-1754(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000085c:	4779                	li	a4,30
    8000085e:	86ca                	mv	a3,s2
    80000860:	6605                	lui	a2,0x1
    80000862:	4581                	li	a1,0
    80000864:	8552                	mv	a0,s4
    80000866:	00000097          	auipc	ra,0x0
    8000086a:	cd8080e7          	jalr	-808(ra) # 8000053e <mappages>
  memmove(mem, src, sz);
    8000086e:	8626                	mv	a2,s1
    80000870:	85ce                	mv	a1,s3
    80000872:	854a                	mv	a0,s2
    80000874:	00000097          	auipc	ra,0x0
    80000878:	962080e7          	jalr	-1694(ra) # 800001d6 <memmove>
}
    8000087c:	70a2                	ld	ra,40(sp)
    8000087e:	7402                	ld	s0,32(sp)
    80000880:	64e2                	ld	s1,24(sp)
    80000882:	6942                	ld	s2,16(sp)
    80000884:	69a2                	ld	s3,8(sp)
    80000886:	6a02                	ld	s4,0(sp)
    80000888:	6145                	add	sp,sp,48
    8000088a:	8082                	ret
    panic("uvmfirst: more than a page");
    8000088c:	00008517          	auipc	a0,0x8
    80000890:	88c50513          	add	a0,a0,-1908 # 80008118 <etext+0x118>
    80000894:	00005097          	auipc	ra,0x5
    80000898:	78e080e7          	jalr	1934(ra) # 80006022 <panic>

000000008000089c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000089c:	1101                	add	sp,sp,-32
    8000089e:	ec06                	sd	ra,24(sp)
    800008a0:	e822                	sd	s0,16(sp)
    800008a2:	e426                	sd	s1,8(sp)
    800008a4:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008a6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008a8:	00b67d63          	bgeu	a2,a1,800008c2 <uvmdealloc+0x26>
    800008ac:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ae:	6785                	lui	a5,0x1
    800008b0:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008b2:	00f60733          	add	a4,a2,a5
    800008b6:	76fd                	lui	a3,0xfffff
    800008b8:	8f75                	and	a4,a4,a3
    800008ba:	97ae                	add	a5,a5,a1
    800008bc:	8ff5                	and	a5,a5,a3
    800008be:	00f76863          	bltu	a4,a5,800008ce <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008c2:	8526                	mv	a0,s1
    800008c4:	60e2                	ld	ra,24(sp)
    800008c6:	6442                	ld	s0,16(sp)
    800008c8:	64a2                	ld	s1,8(sp)
    800008ca:	6105                	add	sp,sp,32
    800008cc:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ce:	8f99                	sub	a5,a5,a4
    800008d0:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008d2:	4685                	li	a3,1
    800008d4:	0007861b          	sext.w	a2,a5
    800008d8:	85ba                	mv	a1,a4
    800008da:	00000097          	auipc	ra,0x0
    800008de:	e4e080e7          	jalr	-434(ra) # 80000728 <uvmunmap>
    800008e2:	b7c5                	j	800008c2 <uvmdealloc+0x26>

00000000800008e4 <uvmalloc>:
  if(newsz < oldsz)
    800008e4:	0ab66b63          	bltu	a2,a1,8000099a <uvmalloc+0xb6>
{
    800008e8:	7139                	add	sp,sp,-64
    800008ea:	fc06                	sd	ra,56(sp)
    800008ec:	f822                	sd	s0,48(sp)
    800008ee:	ec4e                	sd	s3,24(sp)
    800008f0:	e852                	sd	s4,16(sp)
    800008f2:	e456                	sd	s5,8(sp)
    800008f4:	0080                	add	s0,sp,64
    800008f6:	8aaa                	mv	s5,a0
    800008f8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008fa:	6785                	lui	a5,0x1
    800008fc:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008fe:	95be                	add	a1,a1,a5
    80000900:	77fd                	lui	a5,0xfffff
    80000902:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000906:	08c9fc63          	bgeu	s3,a2,8000099e <uvmalloc+0xba>
    8000090a:	f426                	sd	s1,40(sp)
    8000090c:	f04a                	sd	s2,32(sp)
    8000090e:	e05a                	sd	s6,0(sp)
    80000910:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000912:	0126eb13          	or	s6,a3,18
    mem = kalloc();
    80000916:	00000097          	auipc	ra,0x0
    8000091a:	804080e7          	jalr	-2044(ra) # 8000011a <kalloc>
    8000091e:	84aa                	mv	s1,a0
    if(mem == 0){
    80000920:	c915                	beqz	a0,80000954 <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    80000922:	6605                	lui	a2,0x1
    80000924:	4581                	li	a1,0
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	854080e7          	jalr	-1964(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000092e:	875a                	mv	a4,s6
    80000930:	86a6                	mv	a3,s1
    80000932:	6605                	lui	a2,0x1
    80000934:	85ca                	mv	a1,s2
    80000936:	8556                	mv	a0,s5
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	c06080e7          	jalr	-1018(ra) # 8000053e <mappages>
    80000940:	ed05                	bnez	a0,80000978 <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000942:	6785                	lui	a5,0x1
    80000944:	993e                	add	s2,s2,a5
    80000946:	fd4968e3          	bltu	s2,s4,80000916 <uvmalloc+0x32>
  return newsz;
    8000094a:	8552                	mv	a0,s4
    8000094c:	74a2                	ld	s1,40(sp)
    8000094e:	7902                	ld	s2,32(sp)
    80000950:	6b02                	ld	s6,0(sp)
    80000952:	a821                	j	8000096a <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    80000954:	864e                	mv	a2,s3
    80000956:	85ca                	mv	a1,s2
    80000958:	8556                	mv	a0,s5
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	f42080e7          	jalr	-190(ra) # 8000089c <uvmdealloc>
      return 0;
    80000962:	4501                	li	a0,0
    80000964:	74a2                	ld	s1,40(sp)
    80000966:	7902                	ld	s2,32(sp)
    80000968:	6b02                	ld	s6,0(sp)
}
    8000096a:	70e2                	ld	ra,56(sp)
    8000096c:	7442                	ld	s0,48(sp)
    8000096e:	69e2                	ld	s3,24(sp)
    80000970:	6a42                	ld	s4,16(sp)
    80000972:	6aa2                	ld	s5,8(sp)
    80000974:	6121                	add	sp,sp,64
    80000976:	8082                	ret
      kfree(mem);
    80000978:	8526                	mv	a0,s1
    8000097a:	fffff097          	auipc	ra,0xfffff
    8000097e:	6a2080e7          	jalr	1698(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000982:	864e                	mv	a2,s3
    80000984:	85ca                	mv	a1,s2
    80000986:	8556                	mv	a0,s5
    80000988:	00000097          	auipc	ra,0x0
    8000098c:	f14080e7          	jalr	-236(ra) # 8000089c <uvmdealloc>
      return 0;
    80000990:	4501                	li	a0,0
    80000992:	74a2                	ld	s1,40(sp)
    80000994:	7902                	ld	s2,32(sp)
    80000996:	6b02                	ld	s6,0(sp)
    80000998:	bfc9                	j	8000096a <uvmalloc+0x86>
    return oldsz;
    8000099a:	852e                	mv	a0,a1
}
    8000099c:	8082                	ret
  return newsz;
    8000099e:	8532                	mv	a0,a2
    800009a0:	b7e9                	j	8000096a <uvmalloc+0x86>

00000000800009a2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009a2:	7179                	add	sp,sp,-48
    800009a4:	f406                	sd	ra,40(sp)
    800009a6:	f022                	sd	s0,32(sp)
    800009a8:	ec26                	sd	s1,24(sp)
    800009aa:	e84a                	sd	s2,16(sp)
    800009ac:	e44e                	sd	s3,8(sp)
    800009ae:	e052                	sd	s4,0(sp)
    800009b0:	1800                	add	s0,sp,48
    800009b2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009b4:	84aa                	mv	s1,a0
    800009b6:	6905                	lui	s2,0x1
    800009b8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ba:	4985                	li	s3,1
    800009bc:	a829                	j	800009d6 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009be:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009c0:	00c79513          	sll	a0,a5,0xc
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	fde080e7          	jalr	-34(ra) # 800009a2 <freewalk>
      pagetable[i] = 0;
    800009cc:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009d0:	04a1                	add	s1,s1,8
    800009d2:	03248163          	beq	s1,s2,800009f4 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009d6:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009d8:	00f7f713          	and	a4,a5,15
    800009dc:	ff3701e3          	beq	a4,s3,800009be <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009e0:	8b85                	and	a5,a5,1
    800009e2:	d7fd                	beqz	a5,800009d0 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009e4:	00007517          	auipc	a0,0x7
    800009e8:	75450513          	add	a0,a0,1876 # 80008138 <etext+0x138>
    800009ec:	00005097          	auipc	ra,0x5
    800009f0:	636080e7          	jalr	1590(ra) # 80006022 <panic>
    }
  }
  kfree((void*)pagetable);
    800009f4:	8552                	mv	a0,s4
    800009f6:	fffff097          	auipc	ra,0xfffff
    800009fa:	626080e7          	jalr	1574(ra) # 8000001c <kfree>
}
    800009fe:	70a2                	ld	ra,40(sp)
    80000a00:	7402                	ld	s0,32(sp)
    80000a02:	64e2                	ld	s1,24(sp)
    80000a04:	6942                	ld	s2,16(sp)
    80000a06:	69a2                	ld	s3,8(sp)
    80000a08:	6a02                	ld	s4,0(sp)
    80000a0a:	6145                	add	sp,sp,48
    80000a0c:	8082                	ret

0000000080000a0e <vmprint>:

void
vmprint(pagetable_t pagetable)
{
    80000a0e:	7159                	add	sp,sp,-112
    80000a10:	f486                	sd	ra,104(sp)
    80000a12:	f0a2                	sd	s0,96(sp)
    80000a14:	eca6                	sd	s1,88(sp)
    80000a16:	e8ca                	sd	s2,80(sp)
    80000a18:	e4ce                	sd	s3,72(sp)
    80000a1a:	e0d2                	sd	s4,64(sp)
    80000a1c:	fc56                	sd	s5,56(sp)
    80000a1e:	f85a                	sd	s6,48(sp)
    80000a20:	f45e                	sd	s7,40(sp)
    80000a22:	f062                	sd	s8,32(sp)
    80000a24:	ec66                	sd	s9,24(sp)
    80000a26:	e86a                	sd	s10,16(sp)
    80000a28:	e46e                	sd	s11,8(sp)
    80000a2a:	1880                	add	s0,sp,112
    80000a2c:	8caa                	mv	s9,a0
  printf("page table %p\n", (uint64)pagetable);
    80000a2e:	85aa                	mv	a1,a0
    80000a30:	00007517          	auipc	a0,0x7
    80000a34:	71850513          	add	a0,a0,1816 # 80008148 <etext+0x148>
    80000a38:	00005097          	auipc	ra,0x5
    80000a3c:	634080e7          	jalr	1588(ra) # 8000606c <printf>
  // there are 2^9 = 512 PTEs in a page table.

  for(int i = 0; i < 512; i++){
    80000a40:	4d01                	li	s10,0
    pte_t pte_l2 = pagetable[i];
    if(!(pte_l2 & PTE_V))   continue;
    printf(" ..%d: pte %p pa %p\n", i, (uint64)pte_l2, (uint64)PTE2PA(pte_l2));
    80000a42:	00007d97          	auipc	s11,0x7
    80000a46:	716d8d93          	add	s11,s11,1814 # 80008158 <etext+0x158>
    for(int j = 0; j < 512; j++) {
    80000a4a:	4b81                	li	s7,0
      pte_t pte_l1 = ((pagetable_t) PTE2PA(pte_l2))[j];
      if(!(pte_l1 & PTE_V))   continue;
      printf(" .. ..%d: pte %p pa %p\n", j, (uint64)pte_l1, (uint64)PTE2PA(pte_l1));
    80000a4c:	00007c17          	auipc	s8,0x7
    80000a50:	724c0c13          	add	s8,s8,1828 # 80008170 <etext+0x170>
      for(int k = 0; k < 512; k++) {
        pte_t pte_l0 = ((pagetable_t) PTE2PA(pte_l1))[k];
        if(!(pte_l0 & PTE_V))   continue;
        printf(" .. .. ..%d: pte %p pa %p\n", k, (uint64)pte_l0, (uint64)PTE2PA(pte_l0));
    80000a54:	00007a17          	auipc	s4,0x7
    80000a58:	734a0a13          	add	s4,s4,1844 # 80008188 <etext+0x188>
      for(int k = 0; k < 512; k++) {
    80000a5c:	20000993          	li	s3,512
    80000a60:	a8a9                	j	80000aba <vmprint+0xac>
    80000a62:	2485                	addw	s1,s1,1
    80000a64:	0921                	add	s2,s2,8 # 1008 <_entry-0x7fffeff8>
    80000a66:	03348163          	beq	s1,s3,80000a88 <vmprint+0x7a>
        pte_t pte_l0 = ((pagetable_t) PTE2PA(pte_l1))[k];
    80000a6a:	00093603          	ld	a2,0(s2)
        if(!(pte_l0 & PTE_V))   continue;
    80000a6e:	00167793          	and	a5,a2,1
    80000a72:	dbe5                	beqz	a5,80000a62 <vmprint+0x54>
        printf(" .. .. ..%d: pte %p pa %p\n", k, (uint64)pte_l0, (uint64)PTE2PA(pte_l0));
    80000a74:	00a65693          	srl	a3,a2,0xa
    80000a78:	06b2                	sll	a3,a3,0xc
    80000a7a:	85a6                	mv	a1,s1
    80000a7c:	8552                	mv	a0,s4
    80000a7e:	00005097          	auipc	ra,0x5
    80000a82:	5ee080e7          	jalr	1518(ra) # 8000606c <printf>
    80000a86:	bff1                	j	80000a62 <vmprint+0x54>
    for(int j = 0; j < 512; j++) {
    80000a88:	2a85                	addw	s5,s5,1
    80000a8a:	0b21                	add	s6,s6,8 # 1008 <_entry-0x7fffeff8>
    80000a8c:	033a8363          	beq	s5,s3,80000ab2 <vmprint+0xa4>
      pte_t pte_l1 = ((pagetable_t) PTE2PA(pte_l2))[j];
    80000a90:	000b3603          	ld	a2,0(s6)
      if(!(pte_l1 & PTE_V))   continue;
    80000a94:	00167793          	and	a5,a2,1
    80000a98:	dbe5                	beqz	a5,80000a88 <vmprint+0x7a>
      printf(" .. ..%d: pte %p pa %p\n", j, (uint64)pte_l1, (uint64)PTE2PA(pte_l1));
    80000a9a:	00a65913          	srl	s2,a2,0xa
    80000a9e:	0932                	sll	s2,s2,0xc
    80000aa0:	86ca                	mv	a3,s2
    80000aa2:	85d6                	mv	a1,s5
    80000aa4:	8562                	mv	a0,s8
    80000aa6:	00005097          	auipc	ra,0x5
    80000aaa:	5c6080e7          	jalr	1478(ra) # 8000606c <printf>
      for(int k = 0; k < 512; k++) {
    80000aae:	84de                	mv	s1,s7
    80000ab0:	bf6d                	j	80000a6a <vmprint+0x5c>
  for(int i = 0; i < 512; i++){
    80000ab2:	2d05                	addw	s10,s10,1
    80000ab4:	0ca1                	add	s9,s9,8
    80000ab6:	033d0363          	beq	s10,s3,80000adc <vmprint+0xce>
    pte_t pte_l2 = pagetable[i];
    80000aba:	000cb603          	ld	a2,0(s9)
    if(!(pte_l2 & PTE_V))   continue;
    80000abe:	00167793          	and	a5,a2,1
    80000ac2:	dbe5                	beqz	a5,80000ab2 <vmprint+0xa4>
    printf(" ..%d: pte %p pa %p\n", i, (uint64)pte_l2, (uint64)PTE2PA(pte_l2));
    80000ac4:	00a65b13          	srl	s6,a2,0xa
    80000ac8:	0b32                	sll	s6,s6,0xc
    80000aca:	86da                	mv	a3,s6
    80000acc:	85ea                	mv	a1,s10
    80000ace:	856e                	mv	a0,s11
    80000ad0:	00005097          	auipc	ra,0x5
    80000ad4:	59c080e7          	jalr	1436(ra) # 8000606c <printf>
    for(int j = 0; j < 512; j++) {
    80000ad8:	8ade                	mv	s5,s7
    80000ada:	bf5d                	j	80000a90 <vmprint+0x82>
    }
  }



}
    80000adc:	70a6                	ld	ra,104(sp)
    80000ade:	7406                	ld	s0,96(sp)
    80000ae0:	64e6                	ld	s1,88(sp)
    80000ae2:	6946                	ld	s2,80(sp)
    80000ae4:	69a6                	ld	s3,72(sp)
    80000ae6:	6a06                	ld	s4,64(sp)
    80000ae8:	7ae2                	ld	s5,56(sp)
    80000aea:	7b42                	ld	s6,48(sp)
    80000aec:	7ba2                	ld	s7,40(sp)
    80000aee:	7c02                	ld	s8,32(sp)
    80000af0:	6ce2                	ld	s9,24(sp)
    80000af2:	6d42                	ld	s10,16(sp)
    80000af4:	6da2                	ld	s11,8(sp)
    80000af6:	6165                	add	sp,sp,112
    80000af8:	8082                	ret

0000000080000afa <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000afa:	1101                	add	sp,sp,-32
    80000afc:	ec06                	sd	ra,24(sp)
    80000afe:	e822                	sd	s0,16(sp)
    80000b00:	e426                	sd	s1,8(sp)
    80000b02:	1000                	add	s0,sp,32
    80000b04:	84aa                	mv	s1,a0
  if(sz > 0)
    80000b06:	e999                	bnez	a1,80000b1c <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000b08:	8526                	mv	a0,s1
    80000b0a:	00000097          	auipc	ra,0x0
    80000b0e:	e98080e7          	jalr	-360(ra) # 800009a2 <freewalk>
}
    80000b12:	60e2                	ld	ra,24(sp)
    80000b14:	6442                	ld	s0,16(sp)
    80000b16:	64a2                	ld	s1,8(sp)
    80000b18:	6105                	add	sp,sp,32
    80000b1a:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b1c:	6785                	lui	a5,0x1
    80000b1e:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b20:	95be                	add	a1,a1,a5
    80000b22:	4685                	li	a3,1
    80000b24:	00c5d613          	srl	a2,a1,0xc
    80000b28:	4581                	li	a1,0
    80000b2a:	00000097          	auipc	ra,0x0
    80000b2e:	bfe080e7          	jalr	-1026(ra) # 80000728 <uvmunmap>
    80000b32:	bfd9                	j	80000b08 <uvmfree+0xe>

0000000080000b34 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000b34:	c679                	beqz	a2,80000c02 <uvmcopy+0xce>
{
    80000b36:	715d                	add	sp,sp,-80
    80000b38:	e486                	sd	ra,72(sp)
    80000b3a:	e0a2                	sd	s0,64(sp)
    80000b3c:	fc26                	sd	s1,56(sp)
    80000b3e:	f84a                	sd	s2,48(sp)
    80000b40:	f44e                	sd	s3,40(sp)
    80000b42:	f052                	sd	s4,32(sp)
    80000b44:	ec56                	sd	s5,24(sp)
    80000b46:	e85a                	sd	s6,16(sp)
    80000b48:	e45e                	sd	s7,8(sp)
    80000b4a:	0880                	add	s0,sp,80
    80000b4c:	8b2a                	mv	s6,a0
    80000b4e:	8aae                	mv	s5,a1
    80000b50:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000b52:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000b54:	4601                	li	a2,0
    80000b56:	85ce                	mv	a1,s3
    80000b58:	855a                	mv	a0,s6
    80000b5a:	00000097          	auipc	ra,0x0
    80000b5e:	8fc080e7          	jalr	-1796(ra) # 80000456 <walk>
    80000b62:	c531                	beqz	a0,80000bae <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000b64:	6118                	ld	a4,0(a0)
    80000b66:	00177793          	and	a5,a4,1
    80000b6a:	cbb1                	beqz	a5,80000bbe <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000b6c:	00a75593          	srl	a1,a4,0xa
    80000b70:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000b74:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000b78:	fffff097          	auipc	ra,0xfffff
    80000b7c:	5a2080e7          	jalr	1442(ra) # 8000011a <kalloc>
    80000b80:	892a                	mv	s2,a0
    80000b82:	c939                	beqz	a0,80000bd8 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000b84:	6605                	lui	a2,0x1
    80000b86:	85de                	mv	a1,s7
    80000b88:	fffff097          	auipc	ra,0xfffff
    80000b8c:	64e080e7          	jalr	1614(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000b90:	8726                	mv	a4,s1
    80000b92:	86ca                	mv	a3,s2
    80000b94:	6605                	lui	a2,0x1
    80000b96:	85ce                	mv	a1,s3
    80000b98:	8556                	mv	a0,s5
    80000b9a:	00000097          	auipc	ra,0x0
    80000b9e:	9a4080e7          	jalr	-1628(ra) # 8000053e <mappages>
    80000ba2:	e515                	bnez	a0,80000bce <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ba4:	6785                	lui	a5,0x1
    80000ba6:	99be                	add	s3,s3,a5
    80000ba8:	fb49e6e3          	bltu	s3,s4,80000b54 <uvmcopy+0x20>
    80000bac:	a081                	j	80000bec <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000bae:	00007517          	auipc	a0,0x7
    80000bb2:	5fa50513          	add	a0,a0,1530 # 800081a8 <etext+0x1a8>
    80000bb6:	00005097          	auipc	ra,0x5
    80000bba:	46c080e7          	jalr	1132(ra) # 80006022 <panic>
      panic("uvmcopy: page not present");
    80000bbe:	00007517          	auipc	a0,0x7
    80000bc2:	60a50513          	add	a0,a0,1546 # 800081c8 <etext+0x1c8>
    80000bc6:	00005097          	auipc	ra,0x5
    80000bca:	45c080e7          	jalr	1116(ra) # 80006022 <panic>
      kfree(mem);
    80000bce:	854a                	mv	a0,s2
    80000bd0:	fffff097          	auipc	ra,0xfffff
    80000bd4:	44c080e7          	jalr	1100(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000bd8:	4685                	li	a3,1
    80000bda:	00c9d613          	srl	a2,s3,0xc
    80000bde:	4581                	li	a1,0
    80000be0:	8556                	mv	a0,s5
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	b46080e7          	jalr	-1210(ra) # 80000728 <uvmunmap>
  return -1;
    80000bea:	557d                	li	a0,-1
}
    80000bec:	60a6                	ld	ra,72(sp)
    80000bee:	6406                	ld	s0,64(sp)
    80000bf0:	74e2                	ld	s1,56(sp)
    80000bf2:	7942                	ld	s2,48(sp)
    80000bf4:	79a2                	ld	s3,40(sp)
    80000bf6:	7a02                	ld	s4,32(sp)
    80000bf8:	6ae2                	ld	s5,24(sp)
    80000bfa:	6b42                	ld	s6,16(sp)
    80000bfc:	6ba2                	ld	s7,8(sp)
    80000bfe:	6161                	add	sp,sp,80
    80000c00:	8082                	ret
  return 0;
    80000c02:	4501                	li	a0,0
}
    80000c04:	8082                	ret

0000000080000c06 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c06:	1141                	add	sp,sp,-16
    80000c08:	e406                	sd	ra,8(sp)
    80000c0a:	e022                	sd	s0,0(sp)
    80000c0c:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000c0e:	4601                	li	a2,0
    80000c10:	00000097          	auipc	ra,0x0
    80000c14:	846080e7          	jalr	-1978(ra) # 80000456 <walk>
  if(pte == 0)
    80000c18:	c901                	beqz	a0,80000c28 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c1a:	611c                	ld	a5,0(a0)
    80000c1c:	9bbd                	and	a5,a5,-17
    80000c1e:	e11c                	sd	a5,0(a0)
}
    80000c20:	60a2                	ld	ra,8(sp)
    80000c22:	6402                	ld	s0,0(sp)
    80000c24:	0141                	add	sp,sp,16
    80000c26:	8082                	ret
    panic("uvmclear");
    80000c28:	00007517          	auipc	a0,0x7
    80000c2c:	5c050513          	add	a0,a0,1472 # 800081e8 <etext+0x1e8>
    80000c30:	00005097          	auipc	ra,0x5
    80000c34:	3f2080e7          	jalr	1010(ra) # 80006022 <panic>

0000000080000c38 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000c38:	ced1                	beqz	a3,80000cd4 <copyout+0x9c>
{
    80000c3a:	711d                	add	sp,sp,-96
    80000c3c:	ec86                	sd	ra,88(sp)
    80000c3e:	e8a2                	sd	s0,80(sp)
    80000c40:	e4a6                	sd	s1,72(sp)
    80000c42:	fc4e                	sd	s3,56(sp)
    80000c44:	f456                	sd	s5,40(sp)
    80000c46:	f05a                	sd	s6,32(sp)
    80000c48:	ec5e                	sd	s7,24(sp)
    80000c4a:	1080                	add	s0,sp,96
    80000c4c:	8baa                	mv	s7,a0
    80000c4e:	8aae                	mv	s5,a1
    80000c50:	8b32                	mv	s6,a2
    80000c52:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000c54:	74fd                	lui	s1,0xfffff
    80000c56:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000c58:	57fd                	li	a5,-1
    80000c5a:	83e9                	srl	a5,a5,0x1a
    80000c5c:	0697ee63          	bltu	a5,s1,80000cd8 <copyout+0xa0>
    80000c60:	e0ca                	sd	s2,64(sp)
    80000c62:	f852                	sd	s4,48(sp)
    80000c64:	e862                	sd	s8,16(sp)
    80000c66:	e466                	sd	s9,8(sp)
    80000c68:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000c6a:	4cd5                	li	s9,21
    80000c6c:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000c6e:	8c3e                	mv	s8,a5
    80000c70:	a035                	j	80000c9c <copyout+0x64>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000c72:	83a9                	srl	a5,a5,0xa
    80000c74:	07b2                	sll	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c76:	409a8533          	sub	a0,s5,s1
    80000c7a:	0009061b          	sext.w	a2,s2
    80000c7e:	85da                	mv	a1,s6
    80000c80:	953e                	add	a0,a0,a5
    80000c82:	fffff097          	auipc	ra,0xfffff
    80000c86:	554080e7          	jalr	1364(ra) # 800001d6 <memmove>

    len -= n;
    80000c8a:	412989b3          	sub	s3,s3,s2
    src += n;
    80000c8e:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000c90:	02098b63          	beqz	s3,80000cc6 <copyout+0x8e>
    if(va0 >= MAXVA)
    80000c94:	054c6463          	bltu	s8,s4,80000cdc <copyout+0xa4>
    80000c98:	84d2                	mv	s1,s4
    80000c9a:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000c9c:	4601                	li	a2,0
    80000c9e:	85a6                	mv	a1,s1
    80000ca0:	855e                	mv	a0,s7
    80000ca2:	fffff097          	auipc	ra,0xfffff
    80000ca6:	7b4080e7          	jalr	1972(ra) # 80000456 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000caa:	c121                	beqz	a0,80000cea <copyout+0xb2>
    80000cac:	611c                	ld	a5,0(a0)
    80000cae:	0157f713          	and	a4,a5,21
    80000cb2:	05971b63          	bne	a4,s9,80000d08 <copyout+0xd0>
    n = PGSIZE - (dstva - va0);
    80000cb6:	01a48a33          	add	s4,s1,s10
    80000cba:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000cbe:	fb29fae3          	bgeu	s3,s2,80000c72 <copyout+0x3a>
    80000cc2:	894e                	mv	s2,s3
    80000cc4:	b77d                	j	80000c72 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000cc6:	4501                	li	a0,0
    80000cc8:	6906                	ld	s2,64(sp)
    80000cca:	7a42                	ld	s4,48(sp)
    80000ccc:	6c42                	ld	s8,16(sp)
    80000cce:	6ca2                	ld	s9,8(sp)
    80000cd0:	6d02                	ld	s10,0(sp)
    80000cd2:	a015                	j	80000cf6 <copyout+0xbe>
    80000cd4:	4501                	li	a0,0
}
    80000cd6:	8082                	ret
      return -1;
    80000cd8:	557d                	li	a0,-1
    80000cda:	a831                	j	80000cf6 <copyout+0xbe>
    80000cdc:	557d                	li	a0,-1
    80000cde:	6906                	ld	s2,64(sp)
    80000ce0:	7a42                	ld	s4,48(sp)
    80000ce2:	6c42                	ld	s8,16(sp)
    80000ce4:	6ca2                	ld	s9,8(sp)
    80000ce6:	6d02                	ld	s10,0(sp)
    80000ce8:	a039                	j	80000cf6 <copyout+0xbe>
      return -1;
    80000cea:	557d                	li	a0,-1
    80000cec:	6906                	ld	s2,64(sp)
    80000cee:	7a42                	ld	s4,48(sp)
    80000cf0:	6c42                	ld	s8,16(sp)
    80000cf2:	6ca2                	ld	s9,8(sp)
    80000cf4:	6d02                	ld	s10,0(sp)
}
    80000cf6:	60e6                	ld	ra,88(sp)
    80000cf8:	6446                	ld	s0,80(sp)
    80000cfa:	64a6                	ld	s1,72(sp)
    80000cfc:	79e2                	ld	s3,56(sp)
    80000cfe:	7aa2                	ld	s5,40(sp)
    80000d00:	7b02                	ld	s6,32(sp)
    80000d02:	6be2                	ld	s7,24(sp)
    80000d04:	6125                	add	sp,sp,96
    80000d06:	8082                	ret
      return -1;
    80000d08:	557d                	li	a0,-1
    80000d0a:	6906                	ld	s2,64(sp)
    80000d0c:	7a42                	ld	s4,48(sp)
    80000d0e:	6c42                	ld	s8,16(sp)
    80000d10:	6ca2                	ld	s9,8(sp)
    80000d12:	6d02                	ld	s10,0(sp)
    80000d14:	b7cd                	j	80000cf6 <copyout+0xbe>

0000000080000d16 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000d16:	caa5                	beqz	a3,80000d86 <copyin+0x70>
{
    80000d18:	715d                	add	sp,sp,-80
    80000d1a:	e486                	sd	ra,72(sp)
    80000d1c:	e0a2                	sd	s0,64(sp)
    80000d1e:	fc26                	sd	s1,56(sp)
    80000d20:	f84a                	sd	s2,48(sp)
    80000d22:	f44e                	sd	s3,40(sp)
    80000d24:	f052                	sd	s4,32(sp)
    80000d26:	ec56                	sd	s5,24(sp)
    80000d28:	e85a                	sd	s6,16(sp)
    80000d2a:	e45e                	sd	s7,8(sp)
    80000d2c:	e062                	sd	s8,0(sp)
    80000d2e:	0880                	add	s0,sp,80
    80000d30:	8b2a                	mv	s6,a0
    80000d32:	8a2e                	mv	s4,a1
    80000d34:	8c32                	mv	s8,a2
    80000d36:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000d38:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d3a:	6a85                	lui	s5,0x1
    80000d3c:	a01d                	j	80000d62 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d3e:	018505b3          	add	a1,a0,s8
    80000d42:	0004861b          	sext.w	a2,s1
    80000d46:	412585b3          	sub	a1,a1,s2
    80000d4a:	8552                	mv	a0,s4
    80000d4c:	fffff097          	auipc	ra,0xfffff
    80000d50:	48a080e7          	jalr	1162(ra) # 800001d6 <memmove>

    len -= n;
    80000d54:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d58:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d5a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000d5e:	02098263          	beqz	s3,80000d82 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000d62:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d66:	85ca                	mv	a1,s2
    80000d68:	855a                	mv	a0,s6
    80000d6a:	fffff097          	auipc	ra,0xfffff
    80000d6e:	792080e7          	jalr	1938(ra) # 800004fc <walkaddr>
    if(pa0 == 0)
    80000d72:	cd01                	beqz	a0,80000d8a <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000d74:	418904b3          	sub	s1,s2,s8
    80000d78:	94d6                	add	s1,s1,s5
    if(n > len)
    80000d7a:	fc99f2e3          	bgeu	s3,s1,80000d3e <copyin+0x28>
    80000d7e:	84ce                	mv	s1,s3
    80000d80:	bf7d                	j	80000d3e <copyin+0x28>
  }
  return 0;
    80000d82:	4501                	li	a0,0
    80000d84:	a021                	j	80000d8c <copyin+0x76>
    80000d86:	4501                	li	a0,0
}
    80000d88:	8082                	ret
      return -1;
    80000d8a:	557d                	li	a0,-1
}
    80000d8c:	60a6                	ld	ra,72(sp)
    80000d8e:	6406                	ld	s0,64(sp)
    80000d90:	74e2                	ld	s1,56(sp)
    80000d92:	7942                	ld	s2,48(sp)
    80000d94:	79a2                	ld	s3,40(sp)
    80000d96:	7a02                	ld	s4,32(sp)
    80000d98:	6ae2                	ld	s5,24(sp)
    80000d9a:	6b42                	ld	s6,16(sp)
    80000d9c:	6ba2                	ld	s7,8(sp)
    80000d9e:	6c02                	ld	s8,0(sp)
    80000da0:	6161                	add	sp,sp,80
    80000da2:	8082                	ret

0000000080000da4 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000da4:	cacd                	beqz	a3,80000e56 <copyinstr+0xb2>
{
    80000da6:	715d                	add	sp,sp,-80
    80000da8:	e486                	sd	ra,72(sp)
    80000daa:	e0a2                	sd	s0,64(sp)
    80000dac:	fc26                	sd	s1,56(sp)
    80000dae:	f84a                	sd	s2,48(sp)
    80000db0:	f44e                	sd	s3,40(sp)
    80000db2:	f052                	sd	s4,32(sp)
    80000db4:	ec56                	sd	s5,24(sp)
    80000db6:	e85a                	sd	s6,16(sp)
    80000db8:	e45e                	sd	s7,8(sp)
    80000dba:	0880                	add	s0,sp,80
    80000dbc:	8a2a                	mv	s4,a0
    80000dbe:	8b2e                	mv	s6,a1
    80000dc0:	8bb2                	mv	s7,a2
    80000dc2:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000dc4:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000dc6:	6985                	lui	s3,0x1
    80000dc8:	a825                	j	80000e00 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000dca:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000dce:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000dd0:	37fd                	addw	a5,a5,-1
    80000dd2:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000dd6:	60a6                	ld	ra,72(sp)
    80000dd8:	6406                	ld	s0,64(sp)
    80000dda:	74e2                	ld	s1,56(sp)
    80000ddc:	7942                	ld	s2,48(sp)
    80000dde:	79a2                	ld	s3,40(sp)
    80000de0:	7a02                	ld	s4,32(sp)
    80000de2:	6ae2                	ld	s5,24(sp)
    80000de4:	6b42                	ld	s6,16(sp)
    80000de6:	6ba2                	ld	s7,8(sp)
    80000de8:	6161                	add	sp,sp,80
    80000dea:	8082                	ret
    80000dec:	fff90713          	add	a4,s2,-1
    80000df0:	9742                	add	a4,a4,a6
      --max;
    80000df2:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000df6:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000dfa:	04e58663          	beq	a1,a4,80000e46 <copyinstr+0xa2>
{
    80000dfe:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000e00:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000e04:	85a6                	mv	a1,s1
    80000e06:	8552                	mv	a0,s4
    80000e08:	fffff097          	auipc	ra,0xfffff
    80000e0c:	6f4080e7          	jalr	1780(ra) # 800004fc <walkaddr>
    if(pa0 == 0)
    80000e10:	cd0d                	beqz	a0,80000e4a <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000e12:	417486b3          	sub	a3,s1,s7
    80000e16:	96ce                	add	a3,a3,s3
    if(n > max)
    80000e18:	00d97363          	bgeu	s2,a3,80000e1e <copyinstr+0x7a>
    80000e1c:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000e1e:	955e                	add	a0,a0,s7
    80000e20:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000e22:	c695                	beqz	a3,80000e4e <copyinstr+0xaa>
    80000e24:	87da                	mv	a5,s6
    80000e26:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000e28:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000e2c:	96da                	add	a3,a3,s6
    80000e2e:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000e30:	00f60733          	add	a4,a2,a5
    80000e34:	00074703          	lbu	a4,0(a4)
    80000e38:	db49                	beqz	a4,80000dca <copyinstr+0x26>
        *dst = *p;
    80000e3a:	00e78023          	sb	a4,0(a5)
      dst++;
    80000e3e:	0785                	add	a5,a5,1
    while(n > 0){
    80000e40:	fed797e3          	bne	a5,a3,80000e2e <copyinstr+0x8a>
    80000e44:	b765                	j	80000dec <copyinstr+0x48>
    80000e46:	4781                	li	a5,0
    80000e48:	b761                	j	80000dd0 <copyinstr+0x2c>
      return -1;
    80000e4a:	557d                	li	a0,-1
    80000e4c:	b769                	j	80000dd6 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000e4e:	6b85                	lui	s7,0x1
    80000e50:	9ba6                	add	s7,s7,s1
    80000e52:	87da                	mv	a5,s6
    80000e54:	b76d                	j	80000dfe <copyinstr+0x5a>
  int got_null = 0;
    80000e56:	4781                	li	a5,0
  if(got_null){
    80000e58:	37fd                	addw	a5,a5,-1
    80000e5a:	0007851b          	sext.w	a0,a5
}
    80000e5e:	8082                	ret

0000000080000e60 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000e60:	7139                	add	sp,sp,-64
    80000e62:	fc06                	sd	ra,56(sp)
    80000e64:	f822                	sd	s0,48(sp)
    80000e66:	f426                	sd	s1,40(sp)
    80000e68:	f04a                	sd	s2,32(sp)
    80000e6a:	ec4e                	sd	s3,24(sp)
    80000e6c:	e852                	sd	s4,16(sp)
    80000e6e:	e456                	sd	s5,8(sp)
    80000e70:	e05a                	sd	s6,0(sp)
    80000e72:	0080                	add	s0,sp,64
    80000e74:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e76:	0000b497          	auipc	s1,0xb
    80000e7a:	9aa48493          	add	s1,s1,-1622 # 8000b820 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e7e:	8b26                	mv	s6,s1
    80000e80:	04fa5937          	lui	s2,0x4fa5
    80000e84:	fa590913          	add	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000e88:	0932                	sll	s2,s2,0xc
    80000e8a:	fa590913          	add	s2,s2,-91
    80000e8e:	0932                	sll	s2,s2,0xc
    80000e90:	fa590913          	add	s2,s2,-91
    80000e94:	0932                	sll	s2,s2,0xc
    80000e96:	fa590913          	add	s2,s2,-91
    80000e9a:	010009b7          	lui	s3,0x1000
    80000e9e:	19fd                	add	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000ea0:	09ba                	sll	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ea2:	00010a97          	auipc	s5,0x10
    80000ea6:	37ea8a93          	add	s5,s5,894 # 80011220 <tickslock>
    char *pa = kalloc();
    80000eaa:	fffff097          	auipc	ra,0xfffff
    80000eae:	270080e7          	jalr	624(ra) # 8000011a <kalloc>
    80000eb2:	862a                	mv	a2,a0
    if(pa == 0)
    80000eb4:	cd1d                	beqz	a0,80000ef2 <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80000eb6:	416485b3          	sub	a1,s1,s6
    80000eba:	858d                	sra	a1,a1,0x3
    80000ebc:	032585b3          	mul	a1,a1,s2
    80000ec0:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000ec4:	4719                	li	a4,6
    80000ec6:	6685                	lui	a3,0x1
    80000ec8:	40b985b3          	sub	a1,s3,a1
    80000ecc:	8552                	mv	a0,s4
    80000ece:	fffff097          	auipc	ra,0xfffff
    80000ed2:	734080e7          	jalr	1844(ra) # 80000602 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ed6:	16848493          	add	s1,s1,360
    80000eda:	fd5498e3          	bne	s1,s5,80000eaa <proc_mapstacks+0x4a>
  }
}
    80000ede:	70e2                	ld	ra,56(sp)
    80000ee0:	7442                	ld	s0,48(sp)
    80000ee2:	74a2                	ld	s1,40(sp)
    80000ee4:	7902                	ld	s2,32(sp)
    80000ee6:	69e2                	ld	s3,24(sp)
    80000ee8:	6a42                	ld	s4,16(sp)
    80000eea:	6aa2                	ld	s5,8(sp)
    80000eec:	6b02                	ld	s6,0(sp)
    80000eee:	6121                	add	sp,sp,64
    80000ef0:	8082                	ret
      panic("kalloc");
    80000ef2:	00007517          	auipc	a0,0x7
    80000ef6:	30650513          	add	a0,a0,774 # 800081f8 <etext+0x1f8>
    80000efa:	00005097          	auipc	ra,0x5
    80000efe:	128080e7          	jalr	296(ra) # 80006022 <panic>

0000000080000f02 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000f02:	7139                	add	sp,sp,-64
    80000f04:	fc06                	sd	ra,56(sp)
    80000f06:	f822                	sd	s0,48(sp)
    80000f08:	f426                	sd	s1,40(sp)
    80000f0a:	f04a                	sd	s2,32(sp)
    80000f0c:	ec4e                	sd	s3,24(sp)
    80000f0e:	e852                	sd	s4,16(sp)
    80000f10:	e456                	sd	s5,8(sp)
    80000f12:	e05a                	sd	s6,0(sp)
    80000f14:	0080                	add	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f16:	00007597          	auipc	a1,0x7
    80000f1a:	2ea58593          	add	a1,a1,746 # 80008200 <etext+0x200>
    80000f1e:	0000a517          	auipc	a0,0xa
    80000f22:	4d250513          	add	a0,a0,1234 # 8000b3f0 <pid_lock>
    80000f26:	00005097          	auipc	ra,0x5
    80000f2a:	5e6080e7          	jalr	1510(ra) # 8000650c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f2e:	00007597          	auipc	a1,0x7
    80000f32:	2da58593          	add	a1,a1,730 # 80008208 <etext+0x208>
    80000f36:	0000a517          	auipc	a0,0xa
    80000f3a:	4d250513          	add	a0,a0,1234 # 8000b408 <wait_lock>
    80000f3e:	00005097          	auipc	ra,0x5
    80000f42:	5ce080e7          	jalr	1486(ra) # 8000650c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f46:	0000b497          	auipc	s1,0xb
    80000f4a:	8da48493          	add	s1,s1,-1830 # 8000b820 <proc>
      initlock(&p->lock, "proc");
    80000f4e:	00007b17          	auipc	s6,0x7
    80000f52:	2cab0b13          	add	s6,s6,714 # 80008218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000f56:	8aa6                	mv	s5,s1
    80000f58:	04fa5937          	lui	s2,0x4fa5
    80000f5c:	fa590913          	add	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000f60:	0932                	sll	s2,s2,0xc
    80000f62:	fa590913          	add	s2,s2,-91
    80000f66:	0932                	sll	s2,s2,0xc
    80000f68:	fa590913          	add	s2,s2,-91
    80000f6c:	0932                	sll	s2,s2,0xc
    80000f6e:	fa590913          	add	s2,s2,-91
    80000f72:	010009b7          	lui	s3,0x1000
    80000f76:	19fd                	add	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000f78:	09ba                	sll	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f7a:	00010a17          	auipc	s4,0x10
    80000f7e:	2a6a0a13          	add	s4,s4,678 # 80011220 <tickslock>
      initlock(&p->lock, "proc");
    80000f82:	85da                	mv	a1,s6
    80000f84:	8526                	mv	a0,s1
    80000f86:	00005097          	auipc	ra,0x5
    80000f8a:	586080e7          	jalr	1414(ra) # 8000650c <initlock>
      p->state = UNUSED;
    80000f8e:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000f92:	415487b3          	sub	a5,s1,s5
    80000f96:	878d                	sra	a5,a5,0x3
    80000f98:	032787b3          	mul	a5,a5,s2
    80000f9c:	00d7979b          	sllw	a5,a5,0xd
    80000fa0:	40f987b3          	sub	a5,s3,a5
    80000fa4:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fa6:	16848493          	add	s1,s1,360
    80000faa:	fd449ce3          	bne	s1,s4,80000f82 <procinit+0x80>
  }
}
    80000fae:	70e2                	ld	ra,56(sp)
    80000fb0:	7442                	ld	s0,48(sp)
    80000fb2:	74a2                	ld	s1,40(sp)
    80000fb4:	7902                	ld	s2,32(sp)
    80000fb6:	69e2                	ld	s3,24(sp)
    80000fb8:	6a42                	ld	s4,16(sp)
    80000fba:	6aa2                	ld	s5,8(sp)
    80000fbc:	6b02                	ld	s6,0(sp)
    80000fbe:	6121                	add	sp,sp,64
    80000fc0:	8082                	ret

0000000080000fc2 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000fc2:	1141                	add	sp,sp,-16
    80000fc4:	e422                	sd	s0,8(sp)
    80000fc6:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000fc8:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000fca:	2501                	sext.w	a0,a0
    80000fcc:	6422                	ld	s0,8(sp)
    80000fce:	0141                	add	sp,sp,16
    80000fd0:	8082                	ret

0000000080000fd2 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000fd2:	1141                	add	sp,sp,-16
    80000fd4:	e422                	sd	s0,8(sp)
    80000fd6:	0800                	add	s0,sp,16
    80000fd8:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000fda:	2781                	sext.w	a5,a5
    80000fdc:	079e                	sll	a5,a5,0x7
  return c;
}
    80000fde:	0000a517          	auipc	a0,0xa
    80000fe2:	44250513          	add	a0,a0,1090 # 8000b420 <cpus>
    80000fe6:	953e                	add	a0,a0,a5
    80000fe8:	6422                	ld	s0,8(sp)
    80000fea:	0141                	add	sp,sp,16
    80000fec:	8082                	ret

0000000080000fee <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000fee:	1101                	add	sp,sp,-32
    80000ff0:	ec06                	sd	ra,24(sp)
    80000ff2:	e822                	sd	s0,16(sp)
    80000ff4:	e426                	sd	s1,8(sp)
    80000ff6:	1000                	add	s0,sp,32
  push_off();
    80000ff8:	00005097          	auipc	ra,0x5
    80000ffc:	558080e7          	jalr	1368(ra) # 80006550 <push_off>
    80001000:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001002:	2781                	sext.w	a5,a5
    80001004:	079e                	sll	a5,a5,0x7
    80001006:	0000a717          	auipc	a4,0xa
    8000100a:	3ea70713          	add	a4,a4,1002 # 8000b3f0 <pid_lock>
    8000100e:	97ba                	add	a5,a5,a4
    80001010:	7b84                	ld	s1,48(a5)
  pop_off();
    80001012:	00005097          	auipc	ra,0x5
    80001016:	5de080e7          	jalr	1502(ra) # 800065f0 <pop_off>
  return p;
}
    8000101a:	8526                	mv	a0,s1
    8000101c:	60e2                	ld	ra,24(sp)
    8000101e:	6442                	ld	s0,16(sp)
    80001020:	64a2                	ld	s1,8(sp)
    80001022:	6105                	add	sp,sp,32
    80001024:	8082                	ret

0000000080001026 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001026:	1141                	add	sp,sp,-16
    80001028:	e406                	sd	ra,8(sp)
    8000102a:	e022                	sd	s0,0(sp)
    8000102c:	0800                	add	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000102e:	00000097          	auipc	ra,0x0
    80001032:	fc0080e7          	jalr	-64(ra) # 80000fee <myproc>
    80001036:	00005097          	auipc	ra,0x5
    8000103a:	61a080e7          	jalr	1562(ra) # 80006650 <release>

  if (first) {
    8000103e:	0000a797          	auipc	a5,0xa
    80001042:	2f27a783          	lw	a5,754(a5) # 8000b330 <first.1>
    80001046:	eb89                	bnez	a5,80001058 <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001048:	00001097          	auipc	ra,0x1
    8000104c:	ce6080e7          	jalr	-794(ra) # 80001d2e <usertrapret>
}
    80001050:	60a2                	ld	ra,8(sp)
    80001052:	6402                	ld	s0,0(sp)
    80001054:	0141                	add	sp,sp,16
    80001056:	8082                	ret
    fsinit(ROOTDEV);
    80001058:	4505                	li	a0,1
    8000105a:	00002097          	auipc	ra,0x2
    8000105e:	b58080e7          	jalr	-1192(ra) # 80002bb2 <fsinit>
    first = 0;
    80001062:	0000a797          	auipc	a5,0xa
    80001066:	2c07a723          	sw	zero,718(a5) # 8000b330 <first.1>
    __sync_synchronize();
    8000106a:	0330000f          	fence	rw,rw
    8000106e:	bfe9                	j	80001048 <forkret+0x22>

0000000080001070 <allocpid>:
{
    80001070:	1101                	add	sp,sp,-32
    80001072:	ec06                	sd	ra,24(sp)
    80001074:	e822                	sd	s0,16(sp)
    80001076:	e426                	sd	s1,8(sp)
    80001078:	e04a                	sd	s2,0(sp)
    8000107a:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    8000107c:	0000a917          	auipc	s2,0xa
    80001080:	37490913          	add	s2,s2,884 # 8000b3f0 <pid_lock>
    80001084:	854a                	mv	a0,s2
    80001086:	00005097          	auipc	ra,0x5
    8000108a:	516080e7          	jalr	1302(ra) # 8000659c <acquire>
  pid = nextpid;
    8000108e:	0000a797          	auipc	a5,0xa
    80001092:	2a678793          	add	a5,a5,678 # 8000b334 <nextpid>
    80001096:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001098:	0014871b          	addw	a4,s1,1
    8000109c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000109e:	854a                	mv	a0,s2
    800010a0:	00005097          	auipc	ra,0x5
    800010a4:	5b0080e7          	jalr	1456(ra) # 80006650 <release>
}
    800010a8:	8526                	mv	a0,s1
    800010aa:	60e2                	ld	ra,24(sp)
    800010ac:	6442                	ld	s0,16(sp)
    800010ae:	64a2                	ld	s1,8(sp)
    800010b0:	6902                	ld	s2,0(sp)
    800010b2:	6105                	add	sp,sp,32
    800010b4:	8082                	ret

00000000800010b6 <proc_pagetable>:
{
    800010b6:	7179                	add	sp,sp,-48
    800010b8:	f406                	sd	ra,40(sp)
    800010ba:	f022                	sd	s0,32(sp)
    800010bc:	ec26                	sd	s1,24(sp)
    800010be:	e84a                	sd	s2,16(sp)
    800010c0:	1800                	add	s0,sp,48
    800010c2:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800010c4:	fffff097          	auipc	ra,0xfffff
    800010c8:	738080e7          	jalr	1848(ra) # 800007fc <uvmcreate>
    800010cc:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800010ce:	c925                	beqz	a0,8000113e <proc_pagetable+0x88>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800010d0:	4729                	li	a4,10
    800010d2:	00006697          	auipc	a3,0x6
    800010d6:	f2e68693          	add	a3,a3,-210 # 80007000 <_trampoline>
    800010da:	6605                	lui	a2,0x1
    800010dc:	040005b7          	lui	a1,0x4000
    800010e0:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010e2:	05b2                	sll	a1,a1,0xc
    800010e4:	fffff097          	auipc	ra,0xfffff
    800010e8:	45a080e7          	jalr	1114(ra) # 8000053e <mappages>
    800010ec:	06054063          	bltz	a0,8000114c <proc_pagetable+0x96>
    800010f0:	e44e                	sd	s3,8(sp)
  struct usyscall *u = (struct usyscall *) kalloc();
    800010f2:	fffff097          	auipc	ra,0xfffff
    800010f6:	028080e7          	jalr	40(ra) # 8000011a <kalloc>
    800010fa:	89aa                	mv	s3,a0
  u->pid = p->pid;
    800010fc:	03092783          	lw	a5,48(s2)
    80001100:	c11c                	sw	a5,0(a0)
  if(mappages(pagetable, USYSCALL, PGSIZE, (uint64)u, PTE_R | PTE_U) < 0) {
    80001102:	4749                	li	a4,18
    80001104:	86aa                	mv	a3,a0
    80001106:	6605                	lui	a2,0x1
    80001108:	040005b7          	lui	a1,0x4000
    8000110c:	15f5                	add	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    8000110e:	05b2                	sll	a1,a1,0xc
    80001110:	8526                	mv	a0,s1
    80001112:	fffff097          	auipc	ra,0xfffff
    80001116:	42c080e7          	jalr	1068(ra) # 8000053e <mappages>
    8000111a:	04054163          	bltz	a0,8000115c <proc_pagetable+0xa6>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000111e:	4719                	li	a4,6
    80001120:	05893683          	ld	a3,88(s2)
    80001124:	6605                	lui	a2,0x1
    80001126:	020005b7          	lui	a1,0x2000
    8000112a:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000112c:	05b6                	sll	a1,a1,0xd
    8000112e:	8526                	mv	a0,s1
    80001130:	fffff097          	auipc	ra,0xfffff
    80001134:	40e080e7          	jalr	1038(ra) # 8000053e <mappages>
    80001138:	04054b63          	bltz	a0,8000118e <proc_pagetable+0xd8>
    8000113c:	69a2                	ld	s3,8(sp)
}
    8000113e:	8526                	mv	a0,s1
    80001140:	70a2                	ld	ra,40(sp)
    80001142:	7402                	ld	s0,32(sp)
    80001144:	64e2                	ld	s1,24(sp)
    80001146:	6942                	ld	s2,16(sp)
    80001148:	6145                	add	sp,sp,48
    8000114a:	8082                	ret
    uvmfree(pagetable, 0);
    8000114c:	4581                	li	a1,0
    8000114e:	8526                	mv	a0,s1
    80001150:	00000097          	auipc	ra,0x0
    80001154:	9aa080e7          	jalr	-1622(ra) # 80000afa <uvmfree>
    return 0;
    80001158:	4481                	li	s1,0
    8000115a:	b7d5                	j	8000113e <proc_pagetable+0x88>
    kfree(u);
    8000115c:	854e                	mv	a0,s3
    8000115e:	fffff097          	auipc	ra,0xfffff
    80001162:	ebe080e7          	jalr	-322(ra) # 8000001c <kfree>
    uvmunmap(pagetable, USYSCALL, 1, 0);
    80001166:	4681                	li	a3,0
    80001168:	4605                	li	a2,1
    8000116a:	040005b7          	lui	a1,0x4000
    8000116e:	15f5                	add	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80001170:	05b2                	sll	a1,a1,0xc
    80001172:	8526                	mv	a0,s1
    80001174:	fffff097          	auipc	ra,0xfffff
    80001178:	5b4080e7          	jalr	1460(ra) # 80000728 <uvmunmap>
    uvmfree(pagetable, 0);
    8000117c:	4581                	li	a1,0
    8000117e:	8526                	mv	a0,s1
    80001180:	00000097          	auipc	ra,0x0
    80001184:	97a080e7          	jalr	-1670(ra) # 80000afa <uvmfree>
    return 0;
    80001188:	4481                	li	s1,0
    8000118a:	69a2                	ld	s3,8(sp)
    8000118c:	bf4d                	j	8000113e <proc_pagetable+0x88>
    kfree(u);
    8000118e:	854e                	mv	a0,s3
    80001190:	fffff097          	auipc	ra,0xfffff
    80001194:	e8c080e7          	jalr	-372(ra) # 8000001c <kfree>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001198:	4681                	li	a3,0
    8000119a:	4605                	li	a2,1
    8000119c:	040005b7          	lui	a1,0x4000
    800011a0:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011a2:	05b2                	sll	a1,a1,0xc
    800011a4:	8526                	mv	a0,s1
    800011a6:	fffff097          	auipc	ra,0xfffff
    800011aa:	582080e7          	jalr	1410(ra) # 80000728 <uvmunmap>
    uvmfree(pagetable, 0);
    800011ae:	4581                	li	a1,0
    800011b0:	8526                	mv	a0,s1
    800011b2:	00000097          	auipc	ra,0x0
    800011b6:	948080e7          	jalr	-1720(ra) # 80000afa <uvmfree>
    return 0;
    800011ba:	4481                	li	s1,0
    800011bc:	69a2                	ld	s3,8(sp)
    800011be:	b741                	j	8000113e <proc_pagetable+0x88>

00000000800011c0 <proc_freepagetable>:
{
    800011c0:	1101                	add	sp,sp,-32
    800011c2:	ec06                	sd	ra,24(sp)
    800011c4:	e822                	sd	s0,16(sp)
    800011c6:	e426                	sd	s1,8(sp)
    800011c8:	e04a                	sd	s2,0(sp)
    800011ca:	1000                	add	s0,sp,32
    800011cc:	84aa                	mv	s1,a0
    800011ce:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011d0:	4681                	li	a3,0
    800011d2:	4605                	li	a2,1
    800011d4:	040005b7          	lui	a1,0x4000
    800011d8:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011da:	05b2                	sll	a1,a1,0xc
    800011dc:	fffff097          	auipc	ra,0xfffff
    800011e0:	54c080e7          	jalr	1356(ra) # 80000728 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800011e4:	4681                	li	a3,0
    800011e6:	4605                	li	a2,1
    800011e8:	020005b7          	lui	a1,0x2000
    800011ec:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800011ee:	05b6                	sll	a1,a1,0xd
    800011f0:	8526                	mv	a0,s1
    800011f2:	fffff097          	auipc	ra,0xfffff
    800011f6:	536080e7          	jalr	1334(ra) # 80000728 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    800011fa:	4681                	li	a3,0
    800011fc:	4605                	li	a2,1
    800011fe:	040005b7          	lui	a1,0x4000
    80001202:	15f5                	add	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80001204:	05b2                	sll	a1,a1,0xc
    80001206:	8526                	mv	a0,s1
    80001208:	fffff097          	auipc	ra,0xfffff
    8000120c:	520080e7          	jalr	1312(ra) # 80000728 <uvmunmap>
  uvmfree(pagetable, sz);
    80001210:	85ca                	mv	a1,s2
    80001212:	8526                	mv	a0,s1
    80001214:	00000097          	auipc	ra,0x0
    80001218:	8e6080e7          	jalr	-1818(ra) # 80000afa <uvmfree>
}
    8000121c:	60e2                	ld	ra,24(sp)
    8000121e:	6442                	ld	s0,16(sp)
    80001220:	64a2                	ld	s1,8(sp)
    80001222:	6902                	ld	s2,0(sp)
    80001224:	6105                	add	sp,sp,32
    80001226:	8082                	ret

0000000080001228 <freeproc>:
{
    80001228:	1101                	add	sp,sp,-32
    8000122a:	ec06                	sd	ra,24(sp)
    8000122c:	e822                	sd	s0,16(sp)
    8000122e:	e426                	sd	s1,8(sp)
    80001230:	1000                	add	s0,sp,32
    80001232:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001234:	6d28                	ld	a0,88(a0)
    80001236:	c509                	beqz	a0,80001240 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001238:	fffff097          	auipc	ra,0xfffff
    8000123c:	de4080e7          	jalr	-540(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001240:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001244:	68a8                	ld	a0,80(s1)
    80001246:	c511                	beqz	a0,80001252 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001248:	64ac                	ld	a1,72(s1)
    8000124a:	00000097          	auipc	ra,0x0
    8000124e:	f76080e7          	jalr	-138(ra) # 800011c0 <proc_freepagetable>
  p->pagetable = 0;
    80001252:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001256:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000125a:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000125e:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001262:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001266:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000126a:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000126e:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001272:	0004ac23          	sw	zero,24(s1)
}
    80001276:	60e2                	ld	ra,24(sp)
    80001278:	6442                	ld	s0,16(sp)
    8000127a:	64a2                	ld	s1,8(sp)
    8000127c:	6105                	add	sp,sp,32
    8000127e:	8082                	ret

0000000080001280 <allocproc>:
{
    80001280:	1101                	add	sp,sp,-32
    80001282:	ec06                	sd	ra,24(sp)
    80001284:	e822                	sd	s0,16(sp)
    80001286:	e426                	sd	s1,8(sp)
    80001288:	e04a                	sd	s2,0(sp)
    8000128a:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000128c:	0000a497          	auipc	s1,0xa
    80001290:	59448493          	add	s1,s1,1428 # 8000b820 <proc>
    80001294:	00010917          	auipc	s2,0x10
    80001298:	f8c90913          	add	s2,s2,-116 # 80011220 <tickslock>
    acquire(&p->lock);
    8000129c:	8526                	mv	a0,s1
    8000129e:	00005097          	auipc	ra,0x5
    800012a2:	2fe080e7          	jalr	766(ra) # 8000659c <acquire>
    if(p->state == UNUSED) {
    800012a6:	4c9c                	lw	a5,24(s1)
    800012a8:	cf81                	beqz	a5,800012c0 <allocproc+0x40>
      release(&p->lock);
    800012aa:	8526                	mv	a0,s1
    800012ac:	00005097          	auipc	ra,0x5
    800012b0:	3a4080e7          	jalr	932(ra) # 80006650 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800012b4:	16848493          	add	s1,s1,360
    800012b8:	ff2492e3          	bne	s1,s2,8000129c <allocproc+0x1c>
  return 0;
    800012bc:	4481                	li	s1,0
    800012be:	a889                	j	80001310 <allocproc+0x90>
  p->pid = allocpid();
    800012c0:	00000097          	auipc	ra,0x0
    800012c4:	db0080e7          	jalr	-592(ra) # 80001070 <allocpid>
    800012c8:	d888                	sw	a0,48(s1)
  p->state = USED;
    800012ca:	4785                	li	a5,1
    800012cc:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800012ce:	fffff097          	auipc	ra,0xfffff
    800012d2:	e4c080e7          	jalr	-436(ra) # 8000011a <kalloc>
    800012d6:	892a                	mv	s2,a0
    800012d8:	eca8                	sd	a0,88(s1)
    800012da:	c131                	beqz	a0,8000131e <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800012dc:	8526                	mv	a0,s1
    800012de:	00000097          	auipc	ra,0x0
    800012e2:	dd8080e7          	jalr	-552(ra) # 800010b6 <proc_pagetable>
    800012e6:	892a                	mv	s2,a0
    800012e8:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800012ea:	c531                	beqz	a0,80001336 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800012ec:	07000613          	li	a2,112
    800012f0:	4581                	li	a1,0
    800012f2:	06048513          	add	a0,s1,96
    800012f6:	fffff097          	auipc	ra,0xfffff
    800012fa:	e84080e7          	jalr	-380(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800012fe:	00000797          	auipc	a5,0x0
    80001302:	d2878793          	add	a5,a5,-728 # 80001026 <forkret>
    80001306:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001308:	60bc                	ld	a5,64(s1)
    8000130a:	6705                	lui	a4,0x1
    8000130c:	97ba                	add	a5,a5,a4
    8000130e:	f4bc                	sd	a5,104(s1)
}
    80001310:	8526                	mv	a0,s1
    80001312:	60e2                	ld	ra,24(sp)
    80001314:	6442                	ld	s0,16(sp)
    80001316:	64a2                	ld	s1,8(sp)
    80001318:	6902                	ld	s2,0(sp)
    8000131a:	6105                	add	sp,sp,32
    8000131c:	8082                	ret
    freeproc(p);
    8000131e:	8526                	mv	a0,s1
    80001320:	00000097          	auipc	ra,0x0
    80001324:	f08080e7          	jalr	-248(ra) # 80001228 <freeproc>
    release(&p->lock);
    80001328:	8526                	mv	a0,s1
    8000132a:	00005097          	auipc	ra,0x5
    8000132e:	326080e7          	jalr	806(ra) # 80006650 <release>
    return 0;
    80001332:	84ca                	mv	s1,s2
    80001334:	bff1                	j	80001310 <allocproc+0x90>
    freeproc(p);
    80001336:	8526                	mv	a0,s1
    80001338:	00000097          	auipc	ra,0x0
    8000133c:	ef0080e7          	jalr	-272(ra) # 80001228 <freeproc>
    release(&p->lock);
    80001340:	8526                	mv	a0,s1
    80001342:	00005097          	auipc	ra,0x5
    80001346:	30e080e7          	jalr	782(ra) # 80006650 <release>
    return 0;
    8000134a:	84ca                	mv	s1,s2
    8000134c:	b7d1                	j	80001310 <allocproc+0x90>

000000008000134e <userinit>:
{
    8000134e:	1101                	add	sp,sp,-32
    80001350:	ec06                	sd	ra,24(sp)
    80001352:	e822                	sd	s0,16(sp)
    80001354:	e426                	sd	s1,8(sp)
    80001356:	1000                	add	s0,sp,32
  p = allocproc();
    80001358:	00000097          	auipc	ra,0x0
    8000135c:	f28080e7          	jalr	-216(ra) # 80001280 <allocproc>
    80001360:	84aa                	mv	s1,a0
  initproc = p;
    80001362:	0000a797          	auipc	a5,0xa
    80001366:	04a7b723          	sd	a0,78(a5) # 8000b3b0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000136a:	03400613          	li	a2,52
    8000136e:	0000a597          	auipc	a1,0xa
    80001372:	fd258593          	add	a1,a1,-46 # 8000b340 <initcode>
    80001376:	6928                	ld	a0,80(a0)
    80001378:	fffff097          	auipc	ra,0xfffff
    8000137c:	4b2080e7          	jalr	1202(ra) # 8000082a <uvmfirst>
  p->sz = PGSIZE;
    80001380:	6785                	lui	a5,0x1
    80001382:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001384:	6cb8                	ld	a4,88(s1)
    80001386:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000138a:	6cb8                	ld	a4,88(s1)
    8000138c:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000138e:	4641                	li	a2,16
    80001390:	00007597          	auipc	a1,0x7
    80001394:	e9058593          	add	a1,a1,-368 # 80008220 <etext+0x220>
    80001398:	15848513          	add	a0,s1,344
    8000139c:	fffff097          	auipc	ra,0xfffff
    800013a0:	f20080e7          	jalr	-224(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    800013a4:	00007517          	auipc	a0,0x7
    800013a8:	e8c50513          	add	a0,a0,-372 # 80008230 <etext+0x230>
    800013ac:	00002097          	auipc	ra,0x2
    800013b0:	258080e7          	jalr	600(ra) # 80003604 <namei>
    800013b4:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800013b8:	478d                	li	a5,3
    800013ba:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013bc:	8526                	mv	a0,s1
    800013be:	00005097          	auipc	ra,0x5
    800013c2:	292080e7          	jalr	658(ra) # 80006650 <release>
}
    800013c6:	60e2                	ld	ra,24(sp)
    800013c8:	6442                	ld	s0,16(sp)
    800013ca:	64a2                	ld	s1,8(sp)
    800013cc:	6105                	add	sp,sp,32
    800013ce:	8082                	ret

00000000800013d0 <growproc>:
{
    800013d0:	1101                	add	sp,sp,-32
    800013d2:	ec06                	sd	ra,24(sp)
    800013d4:	e822                	sd	s0,16(sp)
    800013d6:	e426                	sd	s1,8(sp)
    800013d8:	e04a                	sd	s2,0(sp)
    800013da:	1000                	add	s0,sp,32
    800013dc:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800013de:	00000097          	auipc	ra,0x0
    800013e2:	c10080e7          	jalr	-1008(ra) # 80000fee <myproc>
    800013e6:	84aa                	mv	s1,a0
  sz = p->sz;
    800013e8:	652c                	ld	a1,72(a0)
  if(n > 0){
    800013ea:	01204c63          	bgtz	s2,80001402 <growproc+0x32>
  } else if(n < 0){
    800013ee:	02094663          	bltz	s2,8000141a <growproc+0x4a>
  p->sz = sz;
    800013f2:	e4ac                	sd	a1,72(s1)
  return 0;
    800013f4:	4501                	li	a0,0
}
    800013f6:	60e2                	ld	ra,24(sp)
    800013f8:	6442                	ld	s0,16(sp)
    800013fa:	64a2                	ld	s1,8(sp)
    800013fc:	6902                	ld	s2,0(sp)
    800013fe:	6105                	add	sp,sp,32
    80001400:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001402:	4691                	li	a3,4
    80001404:	00b90633          	add	a2,s2,a1
    80001408:	6928                	ld	a0,80(a0)
    8000140a:	fffff097          	auipc	ra,0xfffff
    8000140e:	4da080e7          	jalr	1242(ra) # 800008e4 <uvmalloc>
    80001412:	85aa                	mv	a1,a0
    80001414:	fd79                	bnez	a0,800013f2 <growproc+0x22>
      return -1;
    80001416:	557d                	li	a0,-1
    80001418:	bff9                	j	800013f6 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000141a:	00b90633          	add	a2,s2,a1
    8000141e:	6928                	ld	a0,80(a0)
    80001420:	fffff097          	auipc	ra,0xfffff
    80001424:	47c080e7          	jalr	1148(ra) # 8000089c <uvmdealloc>
    80001428:	85aa                	mv	a1,a0
    8000142a:	b7e1                	j	800013f2 <growproc+0x22>

000000008000142c <fork>:
{
    8000142c:	7139                	add	sp,sp,-64
    8000142e:	fc06                	sd	ra,56(sp)
    80001430:	f822                	sd	s0,48(sp)
    80001432:	f04a                	sd	s2,32(sp)
    80001434:	e456                	sd	s5,8(sp)
    80001436:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001438:	00000097          	auipc	ra,0x0
    8000143c:	bb6080e7          	jalr	-1098(ra) # 80000fee <myproc>
    80001440:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001442:	00000097          	auipc	ra,0x0
    80001446:	e3e080e7          	jalr	-450(ra) # 80001280 <allocproc>
    8000144a:	12050063          	beqz	a0,8000156a <fork+0x13e>
    8000144e:	e852                	sd	s4,16(sp)
    80001450:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001452:	048ab603          	ld	a2,72(s5)
    80001456:	692c                	ld	a1,80(a0)
    80001458:	050ab503          	ld	a0,80(s5)
    8000145c:	fffff097          	auipc	ra,0xfffff
    80001460:	6d8080e7          	jalr	1752(ra) # 80000b34 <uvmcopy>
    80001464:	04054a63          	bltz	a0,800014b8 <fork+0x8c>
    80001468:	f426                	sd	s1,40(sp)
    8000146a:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000146c:	048ab783          	ld	a5,72(s5)
    80001470:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001474:	058ab683          	ld	a3,88(s5)
    80001478:	87b6                	mv	a5,a3
    8000147a:	058a3703          	ld	a4,88(s4)
    8000147e:	12068693          	add	a3,a3,288
    80001482:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001486:	6788                	ld	a0,8(a5)
    80001488:	6b8c                	ld	a1,16(a5)
    8000148a:	6f90                	ld	a2,24(a5)
    8000148c:	01073023          	sd	a6,0(a4)
    80001490:	e708                	sd	a0,8(a4)
    80001492:	eb0c                	sd	a1,16(a4)
    80001494:	ef10                	sd	a2,24(a4)
    80001496:	02078793          	add	a5,a5,32
    8000149a:	02070713          	add	a4,a4,32
    8000149e:	fed792e3          	bne	a5,a3,80001482 <fork+0x56>
  np->trapframe->a0 = 0;
    800014a2:	058a3783          	ld	a5,88(s4)
    800014a6:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800014aa:	0d0a8493          	add	s1,s5,208
    800014ae:	0d0a0913          	add	s2,s4,208
    800014b2:	150a8993          	add	s3,s5,336
    800014b6:	a015                	j	800014da <fork+0xae>
    freeproc(np);
    800014b8:	8552                	mv	a0,s4
    800014ba:	00000097          	auipc	ra,0x0
    800014be:	d6e080e7          	jalr	-658(ra) # 80001228 <freeproc>
    release(&np->lock);
    800014c2:	8552                	mv	a0,s4
    800014c4:	00005097          	auipc	ra,0x5
    800014c8:	18c080e7          	jalr	396(ra) # 80006650 <release>
    return -1;
    800014cc:	597d                	li	s2,-1
    800014ce:	6a42                	ld	s4,16(sp)
    800014d0:	a071                	j	8000155c <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800014d2:	04a1                	add	s1,s1,8
    800014d4:	0921                	add	s2,s2,8
    800014d6:	01348b63          	beq	s1,s3,800014ec <fork+0xc0>
    if(p->ofile[i])
    800014da:	6088                	ld	a0,0(s1)
    800014dc:	d97d                	beqz	a0,800014d2 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800014de:	00002097          	auipc	ra,0x2
    800014e2:	79e080e7          	jalr	1950(ra) # 80003c7c <filedup>
    800014e6:	00a93023          	sd	a0,0(s2)
    800014ea:	b7e5                	j	800014d2 <fork+0xa6>
  np->cwd = idup(p->cwd);
    800014ec:	150ab503          	ld	a0,336(s5)
    800014f0:	00002097          	auipc	ra,0x2
    800014f4:	908080e7          	jalr	-1784(ra) # 80002df8 <idup>
    800014f8:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800014fc:	4641                	li	a2,16
    800014fe:	158a8593          	add	a1,s5,344
    80001502:	158a0513          	add	a0,s4,344
    80001506:	fffff097          	auipc	ra,0xfffff
    8000150a:	db6080e7          	jalr	-586(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    8000150e:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001512:	8552                	mv	a0,s4
    80001514:	00005097          	auipc	ra,0x5
    80001518:	13c080e7          	jalr	316(ra) # 80006650 <release>
  acquire(&wait_lock);
    8000151c:	0000a497          	auipc	s1,0xa
    80001520:	eec48493          	add	s1,s1,-276 # 8000b408 <wait_lock>
    80001524:	8526                	mv	a0,s1
    80001526:	00005097          	auipc	ra,0x5
    8000152a:	076080e7          	jalr	118(ra) # 8000659c <acquire>
  np->parent = p;
    8000152e:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001532:	8526                	mv	a0,s1
    80001534:	00005097          	auipc	ra,0x5
    80001538:	11c080e7          	jalr	284(ra) # 80006650 <release>
  acquire(&np->lock);
    8000153c:	8552                	mv	a0,s4
    8000153e:	00005097          	auipc	ra,0x5
    80001542:	05e080e7          	jalr	94(ra) # 8000659c <acquire>
  np->state = RUNNABLE;
    80001546:	478d                	li	a5,3
    80001548:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000154c:	8552                	mv	a0,s4
    8000154e:	00005097          	auipc	ra,0x5
    80001552:	102080e7          	jalr	258(ra) # 80006650 <release>
  return pid;
    80001556:	74a2                	ld	s1,40(sp)
    80001558:	69e2                	ld	s3,24(sp)
    8000155a:	6a42                	ld	s4,16(sp)
}
    8000155c:	854a                	mv	a0,s2
    8000155e:	70e2                	ld	ra,56(sp)
    80001560:	7442                	ld	s0,48(sp)
    80001562:	7902                	ld	s2,32(sp)
    80001564:	6aa2                	ld	s5,8(sp)
    80001566:	6121                	add	sp,sp,64
    80001568:	8082                	ret
    return -1;
    8000156a:	597d                	li	s2,-1
    8000156c:	bfc5                	j	8000155c <fork+0x130>

000000008000156e <scheduler>:
{
    8000156e:	7139                	add	sp,sp,-64
    80001570:	fc06                	sd	ra,56(sp)
    80001572:	f822                	sd	s0,48(sp)
    80001574:	f426                	sd	s1,40(sp)
    80001576:	f04a                	sd	s2,32(sp)
    80001578:	ec4e                	sd	s3,24(sp)
    8000157a:	e852                	sd	s4,16(sp)
    8000157c:	e456                	sd	s5,8(sp)
    8000157e:	e05a                	sd	s6,0(sp)
    80001580:	0080                	add	s0,sp,64
    80001582:	8792                	mv	a5,tp
  int id = r_tp();
    80001584:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001586:	00779a93          	sll	s5,a5,0x7
    8000158a:	0000a717          	auipc	a4,0xa
    8000158e:	e6670713          	add	a4,a4,-410 # 8000b3f0 <pid_lock>
    80001592:	9756                	add	a4,a4,s5
    80001594:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001598:	0000a717          	auipc	a4,0xa
    8000159c:	e9070713          	add	a4,a4,-368 # 8000b428 <cpus+0x8>
    800015a0:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800015a2:	498d                	li	s3,3
        p->state = RUNNING;
    800015a4:	4b11                	li	s6,4
        c->proc = p;
    800015a6:	079e                	sll	a5,a5,0x7
    800015a8:	0000aa17          	auipc	s4,0xa
    800015ac:	e48a0a13          	add	s4,s4,-440 # 8000b3f0 <pid_lock>
    800015b0:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800015b2:	00010917          	auipc	s2,0x10
    800015b6:	c6e90913          	add	s2,s2,-914 # 80011220 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015ba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800015be:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800015c2:	10079073          	csrw	sstatus,a5
    800015c6:	0000a497          	auipc	s1,0xa
    800015ca:	25a48493          	add	s1,s1,602 # 8000b820 <proc>
    800015ce:	a811                	j	800015e2 <scheduler+0x74>
      release(&p->lock);
    800015d0:	8526                	mv	a0,s1
    800015d2:	00005097          	auipc	ra,0x5
    800015d6:	07e080e7          	jalr	126(ra) # 80006650 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015da:	16848493          	add	s1,s1,360
    800015de:	fd248ee3          	beq	s1,s2,800015ba <scheduler+0x4c>
      acquire(&p->lock);
    800015e2:	8526                	mv	a0,s1
    800015e4:	00005097          	auipc	ra,0x5
    800015e8:	fb8080e7          	jalr	-72(ra) # 8000659c <acquire>
      if(p->state == RUNNABLE) {
    800015ec:	4c9c                	lw	a5,24(s1)
    800015ee:	ff3791e3          	bne	a5,s3,800015d0 <scheduler+0x62>
        p->state = RUNNING;
    800015f2:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800015f6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800015fa:	06048593          	add	a1,s1,96
    800015fe:	8556                	mv	a0,s5
    80001600:	00000097          	auipc	ra,0x0
    80001604:	684080e7          	jalr	1668(ra) # 80001c84 <swtch>
        c->proc = 0;
    80001608:	020a3823          	sd	zero,48(s4)
    8000160c:	b7d1                	j	800015d0 <scheduler+0x62>

000000008000160e <sched>:
{
    8000160e:	7179                	add	sp,sp,-48
    80001610:	f406                	sd	ra,40(sp)
    80001612:	f022                	sd	s0,32(sp)
    80001614:	ec26                	sd	s1,24(sp)
    80001616:	e84a                	sd	s2,16(sp)
    80001618:	e44e                	sd	s3,8(sp)
    8000161a:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    8000161c:	00000097          	auipc	ra,0x0
    80001620:	9d2080e7          	jalr	-1582(ra) # 80000fee <myproc>
    80001624:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001626:	00005097          	auipc	ra,0x5
    8000162a:	efc080e7          	jalr	-260(ra) # 80006522 <holding>
    8000162e:	c93d                	beqz	a0,800016a4 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001630:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001632:	2781                	sext.w	a5,a5
    80001634:	079e                	sll	a5,a5,0x7
    80001636:	0000a717          	auipc	a4,0xa
    8000163a:	dba70713          	add	a4,a4,-582 # 8000b3f0 <pid_lock>
    8000163e:	97ba                	add	a5,a5,a4
    80001640:	0a87a703          	lw	a4,168(a5)
    80001644:	4785                	li	a5,1
    80001646:	06f71763          	bne	a4,a5,800016b4 <sched+0xa6>
  if(p->state == RUNNING)
    8000164a:	4c98                	lw	a4,24(s1)
    8000164c:	4791                	li	a5,4
    8000164e:	06f70b63          	beq	a4,a5,800016c4 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001652:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001656:	8b89                	and	a5,a5,2
  if(intr_get())
    80001658:	efb5                	bnez	a5,800016d4 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000165a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000165c:	0000a917          	auipc	s2,0xa
    80001660:	d9490913          	add	s2,s2,-620 # 8000b3f0 <pid_lock>
    80001664:	2781                	sext.w	a5,a5
    80001666:	079e                	sll	a5,a5,0x7
    80001668:	97ca                	add	a5,a5,s2
    8000166a:	0ac7a983          	lw	s3,172(a5)
    8000166e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001670:	2781                	sext.w	a5,a5
    80001672:	079e                	sll	a5,a5,0x7
    80001674:	0000a597          	auipc	a1,0xa
    80001678:	db458593          	add	a1,a1,-588 # 8000b428 <cpus+0x8>
    8000167c:	95be                	add	a1,a1,a5
    8000167e:	06048513          	add	a0,s1,96
    80001682:	00000097          	auipc	ra,0x0
    80001686:	602080e7          	jalr	1538(ra) # 80001c84 <swtch>
    8000168a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000168c:	2781                	sext.w	a5,a5
    8000168e:	079e                	sll	a5,a5,0x7
    80001690:	993e                	add	s2,s2,a5
    80001692:	0b392623          	sw	s3,172(s2)
}
    80001696:	70a2                	ld	ra,40(sp)
    80001698:	7402                	ld	s0,32(sp)
    8000169a:	64e2                	ld	s1,24(sp)
    8000169c:	6942                	ld	s2,16(sp)
    8000169e:	69a2                	ld	s3,8(sp)
    800016a0:	6145                	add	sp,sp,48
    800016a2:	8082                	ret
    panic("sched p->lock");
    800016a4:	00007517          	auipc	a0,0x7
    800016a8:	b9450513          	add	a0,a0,-1132 # 80008238 <etext+0x238>
    800016ac:	00005097          	auipc	ra,0x5
    800016b0:	976080e7          	jalr	-1674(ra) # 80006022 <panic>
    panic("sched locks");
    800016b4:	00007517          	auipc	a0,0x7
    800016b8:	b9450513          	add	a0,a0,-1132 # 80008248 <etext+0x248>
    800016bc:	00005097          	auipc	ra,0x5
    800016c0:	966080e7          	jalr	-1690(ra) # 80006022 <panic>
    panic("sched running");
    800016c4:	00007517          	auipc	a0,0x7
    800016c8:	b9450513          	add	a0,a0,-1132 # 80008258 <etext+0x258>
    800016cc:	00005097          	auipc	ra,0x5
    800016d0:	956080e7          	jalr	-1706(ra) # 80006022 <panic>
    panic("sched interruptible");
    800016d4:	00007517          	auipc	a0,0x7
    800016d8:	b9450513          	add	a0,a0,-1132 # 80008268 <etext+0x268>
    800016dc:	00005097          	auipc	ra,0x5
    800016e0:	946080e7          	jalr	-1722(ra) # 80006022 <panic>

00000000800016e4 <yield>:
{
    800016e4:	1101                	add	sp,sp,-32
    800016e6:	ec06                	sd	ra,24(sp)
    800016e8:	e822                	sd	s0,16(sp)
    800016ea:	e426                	sd	s1,8(sp)
    800016ec:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    800016ee:	00000097          	auipc	ra,0x0
    800016f2:	900080e7          	jalr	-1792(ra) # 80000fee <myproc>
    800016f6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016f8:	00005097          	auipc	ra,0x5
    800016fc:	ea4080e7          	jalr	-348(ra) # 8000659c <acquire>
  p->state = RUNNABLE;
    80001700:	478d                	li	a5,3
    80001702:	cc9c                	sw	a5,24(s1)
  sched();
    80001704:	00000097          	auipc	ra,0x0
    80001708:	f0a080e7          	jalr	-246(ra) # 8000160e <sched>
  release(&p->lock);
    8000170c:	8526                	mv	a0,s1
    8000170e:	00005097          	auipc	ra,0x5
    80001712:	f42080e7          	jalr	-190(ra) # 80006650 <release>
}
    80001716:	60e2                	ld	ra,24(sp)
    80001718:	6442                	ld	s0,16(sp)
    8000171a:	64a2                	ld	s1,8(sp)
    8000171c:	6105                	add	sp,sp,32
    8000171e:	8082                	ret

0000000080001720 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001720:	7179                	add	sp,sp,-48
    80001722:	f406                	sd	ra,40(sp)
    80001724:	f022                	sd	s0,32(sp)
    80001726:	ec26                	sd	s1,24(sp)
    80001728:	e84a                	sd	s2,16(sp)
    8000172a:	e44e                	sd	s3,8(sp)
    8000172c:	1800                	add	s0,sp,48
    8000172e:	89aa                	mv	s3,a0
    80001730:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001732:	00000097          	auipc	ra,0x0
    80001736:	8bc080e7          	jalr	-1860(ra) # 80000fee <myproc>
    8000173a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000173c:	00005097          	auipc	ra,0x5
    80001740:	e60080e7          	jalr	-416(ra) # 8000659c <acquire>
  release(lk);
    80001744:	854a                	mv	a0,s2
    80001746:	00005097          	auipc	ra,0x5
    8000174a:	f0a080e7          	jalr	-246(ra) # 80006650 <release>

  // Go to sleep.
  p->chan = chan;
    8000174e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001752:	4789                	li	a5,2
    80001754:	cc9c                	sw	a5,24(s1)

  sched();
    80001756:	00000097          	auipc	ra,0x0
    8000175a:	eb8080e7          	jalr	-328(ra) # 8000160e <sched>

  // Tidy up.
  p->chan = 0;
    8000175e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001762:	8526                	mv	a0,s1
    80001764:	00005097          	auipc	ra,0x5
    80001768:	eec080e7          	jalr	-276(ra) # 80006650 <release>
  acquire(lk);
    8000176c:	854a                	mv	a0,s2
    8000176e:	00005097          	auipc	ra,0x5
    80001772:	e2e080e7          	jalr	-466(ra) # 8000659c <acquire>
}
    80001776:	70a2                	ld	ra,40(sp)
    80001778:	7402                	ld	s0,32(sp)
    8000177a:	64e2                	ld	s1,24(sp)
    8000177c:	6942                	ld	s2,16(sp)
    8000177e:	69a2                	ld	s3,8(sp)
    80001780:	6145                	add	sp,sp,48
    80001782:	8082                	ret

0000000080001784 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001784:	7139                	add	sp,sp,-64
    80001786:	fc06                	sd	ra,56(sp)
    80001788:	f822                	sd	s0,48(sp)
    8000178a:	f426                	sd	s1,40(sp)
    8000178c:	f04a                	sd	s2,32(sp)
    8000178e:	ec4e                	sd	s3,24(sp)
    80001790:	e852                	sd	s4,16(sp)
    80001792:	e456                	sd	s5,8(sp)
    80001794:	0080                	add	s0,sp,64
    80001796:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001798:	0000a497          	auipc	s1,0xa
    8000179c:	08848493          	add	s1,s1,136 # 8000b820 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800017a0:	4989                	li	s3,2
        p->state = RUNNABLE;
    800017a2:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800017a4:	00010917          	auipc	s2,0x10
    800017a8:	a7c90913          	add	s2,s2,-1412 # 80011220 <tickslock>
    800017ac:	a811                	j	800017c0 <wakeup+0x3c>
      }
      release(&p->lock);
    800017ae:	8526                	mv	a0,s1
    800017b0:	00005097          	auipc	ra,0x5
    800017b4:	ea0080e7          	jalr	-352(ra) # 80006650 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017b8:	16848493          	add	s1,s1,360
    800017bc:	03248663          	beq	s1,s2,800017e8 <wakeup+0x64>
    if(p != myproc()){
    800017c0:	00000097          	auipc	ra,0x0
    800017c4:	82e080e7          	jalr	-2002(ra) # 80000fee <myproc>
    800017c8:	fea488e3          	beq	s1,a0,800017b8 <wakeup+0x34>
      acquire(&p->lock);
    800017cc:	8526                	mv	a0,s1
    800017ce:	00005097          	auipc	ra,0x5
    800017d2:	dce080e7          	jalr	-562(ra) # 8000659c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800017d6:	4c9c                	lw	a5,24(s1)
    800017d8:	fd379be3          	bne	a5,s3,800017ae <wakeup+0x2a>
    800017dc:	709c                	ld	a5,32(s1)
    800017de:	fd4798e3          	bne	a5,s4,800017ae <wakeup+0x2a>
        p->state = RUNNABLE;
    800017e2:	0154ac23          	sw	s5,24(s1)
    800017e6:	b7e1                	j	800017ae <wakeup+0x2a>
    }
  }
}
    800017e8:	70e2                	ld	ra,56(sp)
    800017ea:	7442                	ld	s0,48(sp)
    800017ec:	74a2                	ld	s1,40(sp)
    800017ee:	7902                	ld	s2,32(sp)
    800017f0:	69e2                	ld	s3,24(sp)
    800017f2:	6a42                	ld	s4,16(sp)
    800017f4:	6aa2                	ld	s5,8(sp)
    800017f6:	6121                	add	sp,sp,64
    800017f8:	8082                	ret

00000000800017fa <reparent>:
{
    800017fa:	7179                	add	sp,sp,-48
    800017fc:	f406                	sd	ra,40(sp)
    800017fe:	f022                	sd	s0,32(sp)
    80001800:	ec26                	sd	s1,24(sp)
    80001802:	e84a                	sd	s2,16(sp)
    80001804:	e44e                	sd	s3,8(sp)
    80001806:	e052                	sd	s4,0(sp)
    80001808:	1800                	add	s0,sp,48
    8000180a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000180c:	0000a497          	auipc	s1,0xa
    80001810:	01448493          	add	s1,s1,20 # 8000b820 <proc>
      pp->parent = initproc;
    80001814:	0000aa17          	auipc	s4,0xa
    80001818:	b9ca0a13          	add	s4,s4,-1124 # 8000b3b0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000181c:	00010997          	auipc	s3,0x10
    80001820:	a0498993          	add	s3,s3,-1532 # 80011220 <tickslock>
    80001824:	a029                	j	8000182e <reparent+0x34>
    80001826:	16848493          	add	s1,s1,360
    8000182a:	01348d63          	beq	s1,s3,80001844 <reparent+0x4a>
    if(pp->parent == p){
    8000182e:	7c9c                	ld	a5,56(s1)
    80001830:	ff279be3          	bne	a5,s2,80001826 <reparent+0x2c>
      pp->parent = initproc;
    80001834:	000a3503          	ld	a0,0(s4)
    80001838:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000183a:	00000097          	auipc	ra,0x0
    8000183e:	f4a080e7          	jalr	-182(ra) # 80001784 <wakeup>
    80001842:	b7d5                	j	80001826 <reparent+0x2c>
}
    80001844:	70a2                	ld	ra,40(sp)
    80001846:	7402                	ld	s0,32(sp)
    80001848:	64e2                	ld	s1,24(sp)
    8000184a:	6942                	ld	s2,16(sp)
    8000184c:	69a2                	ld	s3,8(sp)
    8000184e:	6a02                	ld	s4,0(sp)
    80001850:	6145                	add	sp,sp,48
    80001852:	8082                	ret

0000000080001854 <exit>:
{
    80001854:	7179                	add	sp,sp,-48
    80001856:	f406                	sd	ra,40(sp)
    80001858:	f022                	sd	s0,32(sp)
    8000185a:	ec26                	sd	s1,24(sp)
    8000185c:	e84a                	sd	s2,16(sp)
    8000185e:	e44e                	sd	s3,8(sp)
    80001860:	e052                	sd	s4,0(sp)
    80001862:	1800                	add	s0,sp,48
    80001864:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001866:	fffff097          	auipc	ra,0xfffff
    8000186a:	788080e7          	jalr	1928(ra) # 80000fee <myproc>
    8000186e:	89aa                	mv	s3,a0
  if(p == initproc)
    80001870:	0000a797          	auipc	a5,0xa
    80001874:	b407b783          	ld	a5,-1216(a5) # 8000b3b0 <initproc>
    80001878:	0d050493          	add	s1,a0,208
    8000187c:	15050913          	add	s2,a0,336
    80001880:	02a79363          	bne	a5,a0,800018a6 <exit+0x52>
    panic("init exiting");
    80001884:	00007517          	auipc	a0,0x7
    80001888:	9fc50513          	add	a0,a0,-1540 # 80008280 <etext+0x280>
    8000188c:	00004097          	auipc	ra,0x4
    80001890:	796080e7          	jalr	1942(ra) # 80006022 <panic>
      fileclose(f);
    80001894:	00002097          	auipc	ra,0x2
    80001898:	43a080e7          	jalr	1082(ra) # 80003cce <fileclose>
      p->ofile[fd] = 0;
    8000189c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800018a0:	04a1                	add	s1,s1,8
    800018a2:	01248563          	beq	s1,s2,800018ac <exit+0x58>
    if(p->ofile[fd]){
    800018a6:	6088                	ld	a0,0(s1)
    800018a8:	f575                	bnez	a0,80001894 <exit+0x40>
    800018aa:	bfdd                	j	800018a0 <exit+0x4c>
  begin_op();
    800018ac:	00002097          	auipc	ra,0x2
    800018b0:	f58080e7          	jalr	-168(ra) # 80003804 <begin_op>
  iput(p->cwd);
    800018b4:	1509b503          	ld	a0,336(s3)
    800018b8:	00001097          	auipc	ra,0x1
    800018bc:	73c080e7          	jalr	1852(ra) # 80002ff4 <iput>
  end_op();
    800018c0:	00002097          	auipc	ra,0x2
    800018c4:	fbe080e7          	jalr	-66(ra) # 8000387e <end_op>
  p->cwd = 0;
    800018c8:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800018cc:	0000a497          	auipc	s1,0xa
    800018d0:	b3c48493          	add	s1,s1,-1220 # 8000b408 <wait_lock>
    800018d4:	8526                	mv	a0,s1
    800018d6:	00005097          	auipc	ra,0x5
    800018da:	cc6080e7          	jalr	-826(ra) # 8000659c <acquire>
  reparent(p);
    800018de:	854e                	mv	a0,s3
    800018e0:	00000097          	auipc	ra,0x0
    800018e4:	f1a080e7          	jalr	-230(ra) # 800017fa <reparent>
  wakeup(p->parent);
    800018e8:	0389b503          	ld	a0,56(s3)
    800018ec:	00000097          	auipc	ra,0x0
    800018f0:	e98080e7          	jalr	-360(ra) # 80001784 <wakeup>
  acquire(&p->lock);
    800018f4:	854e                	mv	a0,s3
    800018f6:	00005097          	auipc	ra,0x5
    800018fa:	ca6080e7          	jalr	-858(ra) # 8000659c <acquire>
  p->xstate = status;
    800018fe:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001902:	4795                	li	a5,5
    80001904:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001908:	8526                	mv	a0,s1
    8000190a:	00005097          	auipc	ra,0x5
    8000190e:	d46080e7          	jalr	-698(ra) # 80006650 <release>
  sched();
    80001912:	00000097          	auipc	ra,0x0
    80001916:	cfc080e7          	jalr	-772(ra) # 8000160e <sched>
  panic("zombie exit");
    8000191a:	00007517          	auipc	a0,0x7
    8000191e:	97650513          	add	a0,a0,-1674 # 80008290 <etext+0x290>
    80001922:	00004097          	auipc	ra,0x4
    80001926:	700080e7          	jalr	1792(ra) # 80006022 <panic>

000000008000192a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000192a:	7179                	add	sp,sp,-48
    8000192c:	f406                	sd	ra,40(sp)
    8000192e:	f022                	sd	s0,32(sp)
    80001930:	ec26                	sd	s1,24(sp)
    80001932:	e84a                	sd	s2,16(sp)
    80001934:	e44e                	sd	s3,8(sp)
    80001936:	1800                	add	s0,sp,48
    80001938:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000193a:	0000a497          	auipc	s1,0xa
    8000193e:	ee648493          	add	s1,s1,-282 # 8000b820 <proc>
    80001942:	00010997          	auipc	s3,0x10
    80001946:	8de98993          	add	s3,s3,-1826 # 80011220 <tickslock>
    acquire(&p->lock);
    8000194a:	8526                	mv	a0,s1
    8000194c:	00005097          	auipc	ra,0x5
    80001950:	c50080e7          	jalr	-944(ra) # 8000659c <acquire>
    if(p->pid == pid){
    80001954:	589c                	lw	a5,48(s1)
    80001956:	01278d63          	beq	a5,s2,80001970 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000195a:	8526                	mv	a0,s1
    8000195c:	00005097          	auipc	ra,0x5
    80001960:	cf4080e7          	jalr	-780(ra) # 80006650 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001964:	16848493          	add	s1,s1,360
    80001968:	ff3491e3          	bne	s1,s3,8000194a <kill+0x20>
  }
  return -1;
    8000196c:	557d                	li	a0,-1
    8000196e:	a829                	j	80001988 <kill+0x5e>
      p->killed = 1;
    80001970:	4785                	li	a5,1
    80001972:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001974:	4c98                	lw	a4,24(s1)
    80001976:	4789                	li	a5,2
    80001978:	00f70f63          	beq	a4,a5,80001996 <kill+0x6c>
      release(&p->lock);
    8000197c:	8526                	mv	a0,s1
    8000197e:	00005097          	auipc	ra,0x5
    80001982:	cd2080e7          	jalr	-814(ra) # 80006650 <release>
      return 0;
    80001986:	4501                	li	a0,0
}
    80001988:	70a2                	ld	ra,40(sp)
    8000198a:	7402                	ld	s0,32(sp)
    8000198c:	64e2                	ld	s1,24(sp)
    8000198e:	6942                	ld	s2,16(sp)
    80001990:	69a2                	ld	s3,8(sp)
    80001992:	6145                	add	sp,sp,48
    80001994:	8082                	ret
        p->state = RUNNABLE;
    80001996:	478d                	li	a5,3
    80001998:	cc9c                	sw	a5,24(s1)
    8000199a:	b7cd                	j	8000197c <kill+0x52>

000000008000199c <setkilled>:

void
setkilled(struct proc *p)
{
    8000199c:	1101                	add	sp,sp,-32
    8000199e:	ec06                	sd	ra,24(sp)
    800019a0:	e822                	sd	s0,16(sp)
    800019a2:	e426                	sd	s1,8(sp)
    800019a4:	1000                	add	s0,sp,32
    800019a6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800019a8:	00005097          	auipc	ra,0x5
    800019ac:	bf4080e7          	jalr	-1036(ra) # 8000659c <acquire>
  p->killed = 1;
    800019b0:	4785                	li	a5,1
    800019b2:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800019b4:	8526                	mv	a0,s1
    800019b6:	00005097          	auipc	ra,0x5
    800019ba:	c9a080e7          	jalr	-870(ra) # 80006650 <release>
}
    800019be:	60e2                	ld	ra,24(sp)
    800019c0:	6442                	ld	s0,16(sp)
    800019c2:	64a2                	ld	s1,8(sp)
    800019c4:	6105                	add	sp,sp,32
    800019c6:	8082                	ret

00000000800019c8 <killed>:

int
killed(struct proc *p)
{
    800019c8:	1101                	add	sp,sp,-32
    800019ca:	ec06                	sd	ra,24(sp)
    800019cc:	e822                	sd	s0,16(sp)
    800019ce:	e426                	sd	s1,8(sp)
    800019d0:	e04a                	sd	s2,0(sp)
    800019d2:	1000                	add	s0,sp,32
    800019d4:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800019d6:	00005097          	auipc	ra,0x5
    800019da:	bc6080e7          	jalr	-1082(ra) # 8000659c <acquire>
  k = p->killed;
    800019de:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800019e2:	8526                	mv	a0,s1
    800019e4:	00005097          	auipc	ra,0x5
    800019e8:	c6c080e7          	jalr	-916(ra) # 80006650 <release>
  return k;
}
    800019ec:	854a                	mv	a0,s2
    800019ee:	60e2                	ld	ra,24(sp)
    800019f0:	6442                	ld	s0,16(sp)
    800019f2:	64a2                	ld	s1,8(sp)
    800019f4:	6902                	ld	s2,0(sp)
    800019f6:	6105                	add	sp,sp,32
    800019f8:	8082                	ret

00000000800019fa <wait>:
{
    800019fa:	715d                	add	sp,sp,-80
    800019fc:	e486                	sd	ra,72(sp)
    800019fe:	e0a2                	sd	s0,64(sp)
    80001a00:	fc26                	sd	s1,56(sp)
    80001a02:	f84a                	sd	s2,48(sp)
    80001a04:	f44e                	sd	s3,40(sp)
    80001a06:	f052                	sd	s4,32(sp)
    80001a08:	ec56                	sd	s5,24(sp)
    80001a0a:	e85a                	sd	s6,16(sp)
    80001a0c:	e45e                	sd	s7,8(sp)
    80001a0e:	e062                	sd	s8,0(sp)
    80001a10:	0880                	add	s0,sp,80
    80001a12:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001a14:	fffff097          	auipc	ra,0xfffff
    80001a18:	5da080e7          	jalr	1498(ra) # 80000fee <myproc>
    80001a1c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001a1e:	0000a517          	auipc	a0,0xa
    80001a22:	9ea50513          	add	a0,a0,-1558 # 8000b408 <wait_lock>
    80001a26:	00005097          	auipc	ra,0x5
    80001a2a:	b76080e7          	jalr	-1162(ra) # 8000659c <acquire>
    havekids = 0;
    80001a2e:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001a30:	4a15                	li	s4,5
        havekids = 1;
    80001a32:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a34:	0000f997          	auipc	s3,0xf
    80001a38:	7ec98993          	add	s3,s3,2028 # 80011220 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a3c:	0000ac17          	auipc	s8,0xa
    80001a40:	9ccc0c13          	add	s8,s8,-1588 # 8000b408 <wait_lock>
    80001a44:	a0d1                	j	80001b08 <wait+0x10e>
          pid = pp->pid;
    80001a46:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001a4a:	000b0e63          	beqz	s6,80001a66 <wait+0x6c>
    80001a4e:	4691                	li	a3,4
    80001a50:	02c48613          	add	a2,s1,44
    80001a54:	85da                	mv	a1,s6
    80001a56:	05093503          	ld	a0,80(s2)
    80001a5a:	fffff097          	auipc	ra,0xfffff
    80001a5e:	1de080e7          	jalr	478(ra) # 80000c38 <copyout>
    80001a62:	04054163          	bltz	a0,80001aa4 <wait+0xaa>
          freeproc(pp);
    80001a66:	8526                	mv	a0,s1
    80001a68:	fffff097          	auipc	ra,0xfffff
    80001a6c:	7c0080e7          	jalr	1984(ra) # 80001228 <freeproc>
          release(&pp->lock);
    80001a70:	8526                	mv	a0,s1
    80001a72:	00005097          	auipc	ra,0x5
    80001a76:	bde080e7          	jalr	-1058(ra) # 80006650 <release>
          release(&wait_lock);
    80001a7a:	0000a517          	auipc	a0,0xa
    80001a7e:	98e50513          	add	a0,a0,-1650 # 8000b408 <wait_lock>
    80001a82:	00005097          	auipc	ra,0x5
    80001a86:	bce080e7          	jalr	-1074(ra) # 80006650 <release>
}
    80001a8a:	854e                	mv	a0,s3
    80001a8c:	60a6                	ld	ra,72(sp)
    80001a8e:	6406                	ld	s0,64(sp)
    80001a90:	74e2                	ld	s1,56(sp)
    80001a92:	7942                	ld	s2,48(sp)
    80001a94:	79a2                	ld	s3,40(sp)
    80001a96:	7a02                	ld	s4,32(sp)
    80001a98:	6ae2                	ld	s5,24(sp)
    80001a9a:	6b42                	ld	s6,16(sp)
    80001a9c:	6ba2                	ld	s7,8(sp)
    80001a9e:	6c02                	ld	s8,0(sp)
    80001aa0:	6161                	add	sp,sp,80
    80001aa2:	8082                	ret
            release(&pp->lock);
    80001aa4:	8526                	mv	a0,s1
    80001aa6:	00005097          	auipc	ra,0x5
    80001aaa:	baa080e7          	jalr	-1110(ra) # 80006650 <release>
            release(&wait_lock);
    80001aae:	0000a517          	auipc	a0,0xa
    80001ab2:	95a50513          	add	a0,a0,-1702 # 8000b408 <wait_lock>
    80001ab6:	00005097          	auipc	ra,0x5
    80001aba:	b9a080e7          	jalr	-1126(ra) # 80006650 <release>
            return -1;
    80001abe:	59fd                	li	s3,-1
    80001ac0:	b7e9                	j	80001a8a <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ac2:	16848493          	add	s1,s1,360
    80001ac6:	03348463          	beq	s1,s3,80001aee <wait+0xf4>
      if(pp->parent == p){
    80001aca:	7c9c                	ld	a5,56(s1)
    80001acc:	ff279be3          	bne	a5,s2,80001ac2 <wait+0xc8>
        acquire(&pp->lock);
    80001ad0:	8526                	mv	a0,s1
    80001ad2:	00005097          	auipc	ra,0x5
    80001ad6:	aca080e7          	jalr	-1334(ra) # 8000659c <acquire>
        if(pp->state == ZOMBIE){
    80001ada:	4c9c                	lw	a5,24(s1)
    80001adc:	f74785e3          	beq	a5,s4,80001a46 <wait+0x4c>
        release(&pp->lock);
    80001ae0:	8526                	mv	a0,s1
    80001ae2:	00005097          	auipc	ra,0x5
    80001ae6:	b6e080e7          	jalr	-1170(ra) # 80006650 <release>
        havekids = 1;
    80001aea:	8756                	mv	a4,s5
    80001aec:	bfd9                	j	80001ac2 <wait+0xc8>
    if(!havekids || killed(p)){
    80001aee:	c31d                	beqz	a4,80001b14 <wait+0x11a>
    80001af0:	854a                	mv	a0,s2
    80001af2:	00000097          	auipc	ra,0x0
    80001af6:	ed6080e7          	jalr	-298(ra) # 800019c8 <killed>
    80001afa:	ed09                	bnez	a0,80001b14 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001afc:	85e2                	mv	a1,s8
    80001afe:	854a                	mv	a0,s2
    80001b00:	00000097          	auipc	ra,0x0
    80001b04:	c20080e7          	jalr	-992(ra) # 80001720 <sleep>
    havekids = 0;
    80001b08:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001b0a:	0000a497          	auipc	s1,0xa
    80001b0e:	d1648493          	add	s1,s1,-746 # 8000b820 <proc>
    80001b12:	bf65                	j	80001aca <wait+0xd0>
      release(&wait_lock);
    80001b14:	0000a517          	auipc	a0,0xa
    80001b18:	8f450513          	add	a0,a0,-1804 # 8000b408 <wait_lock>
    80001b1c:	00005097          	auipc	ra,0x5
    80001b20:	b34080e7          	jalr	-1228(ra) # 80006650 <release>
      return -1;
    80001b24:	59fd                	li	s3,-1
    80001b26:	b795                	j	80001a8a <wait+0x90>

0000000080001b28 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001b28:	7179                	add	sp,sp,-48
    80001b2a:	f406                	sd	ra,40(sp)
    80001b2c:	f022                	sd	s0,32(sp)
    80001b2e:	ec26                	sd	s1,24(sp)
    80001b30:	e84a                	sd	s2,16(sp)
    80001b32:	e44e                	sd	s3,8(sp)
    80001b34:	e052                	sd	s4,0(sp)
    80001b36:	1800                	add	s0,sp,48
    80001b38:	84aa                	mv	s1,a0
    80001b3a:	892e                	mv	s2,a1
    80001b3c:	89b2                	mv	s3,a2
    80001b3e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b40:	fffff097          	auipc	ra,0xfffff
    80001b44:	4ae080e7          	jalr	1198(ra) # 80000fee <myproc>
  if(user_dst){
    80001b48:	c08d                	beqz	s1,80001b6a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001b4a:	86d2                	mv	a3,s4
    80001b4c:	864e                	mv	a2,s3
    80001b4e:	85ca                	mv	a1,s2
    80001b50:	6928                	ld	a0,80(a0)
    80001b52:	fffff097          	auipc	ra,0xfffff
    80001b56:	0e6080e7          	jalr	230(ra) # 80000c38 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b5a:	70a2                	ld	ra,40(sp)
    80001b5c:	7402                	ld	s0,32(sp)
    80001b5e:	64e2                	ld	s1,24(sp)
    80001b60:	6942                	ld	s2,16(sp)
    80001b62:	69a2                	ld	s3,8(sp)
    80001b64:	6a02                	ld	s4,0(sp)
    80001b66:	6145                	add	sp,sp,48
    80001b68:	8082                	ret
    memmove((char *)dst, src, len);
    80001b6a:	000a061b          	sext.w	a2,s4
    80001b6e:	85ce                	mv	a1,s3
    80001b70:	854a                	mv	a0,s2
    80001b72:	ffffe097          	auipc	ra,0xffffe
    80001b76:	664080e7          	jalr	1636(ra) # 800001d6 <memmove>
    return 0;
    80001b7a:	8526                	mv	a0,s1
    80001b7c:	bff9                	j	80001b5a <either_copyout+0x32>

0000000080001b7e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b7e:	7179                	add	sp,sp,-48
    80001b80:	f406                	sd	ra,40(sp)
    80001b82:	f022                	sd	s0,32(sp)
    80001b84:	ec26                	sd	s1,24(sp)
    80001b86:	e84a                	sd	s2,16(sp)
    80001b88:	e44e                	sd	s3,8(sp)
    80001b8a:	e052                	sd	s4,0(sp)
    80001b8c:	1800                	add	s0,sp,48
    80001b8e:	892a                	mv	s2,a0
    80001b90:	84ae                	mv	s1,a1
    80001b92:	89b2                	mv	s3,a2
    80001b94:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b96:	fffff097          	auipc	ra,0xfffff
    80001b9a:	458080e7          	jalr	1112(ra) # 80000fee <myproc>
  if(user_src){
    80001b9e:	c08d                	beqz	s1,80001bc0 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001ba0:	86d2                	mv	a3,s4
    80001ba2:	864e                	mv	a2,s3
    80001ba4:	85ca                	mv	a1,s2
    80001ba6:	6928                	ld	a0,80(a0)
    80001ba8:	fffff097          	auipc	ra,0xfffff
    80001bac:	16e080e7          	jalr	366(ra) # 80000d16 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001bb0:	70a2                	ld	ra,40(sp)
    80001bb2:	7402                	ld	s0,32(sp)
    80001bb4:	64e2                	ld	s1,24(sp)
    80001bb6:	6942                	ld	s2,16(sp)
    80001bb8:	69a2                	ld	s3,8(sp)
    80001bba:	6a02                	ld	s4,0(sp)
    80001bbc:	6145                	add	sp,sp,48
    80001bbe:	8082                	ret
    memmove(dst, (char*)src, len);
    80001bc0:	000a061b          	sext.w	a2,s4
    80001bc4:	85ce                	mv	a1,s3
    80001bc6:	854a                	mv	a0,s2
    80001bc8:	ffffe097          	auipc	ra,0xffffe
    80001bcc:	60e080e7          	jalr	1550(ra) # 800001d6 <memmove>
    return 0;
    80001bd0:	8526                	mv	a0,s1
    80001bd2:	bff9                	j	80001bb0 <either_copyin+0x32>

0000000080001bd4 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001bd4:	715d                	add	sp,sp,-80
    80001bd6:	e486                	sd	ra,72(sp)
    80001bd8:	e0a2                	sd	s0,64(sp)
    80001bda:	fc26                	sd	s1,56(sp)
    80001bdc:	f84a                	sd	s2,48(sp)
    80001bde:	f44e                	sd	s3,40(sp)
    80001be0:	f052                	sd	s4,32(sp)
    80001be2:	ec56                	sd	s5,24(sp)
    80001be4:	e85a                	sd	s6,16(sp)
    80001be6:	e45e                	sd	s7,8(sp)
    80001be8:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001bea:	00006517          	auipc	a0,0x6
    80001bee:	42e50513          	add	a0,a0,1070 # 80008018 <etext+0x18>
    80001bf2:	00004097          	auipc	ra,0x4
    80001bf6:	47a080e7          	jalr	1146(ra) # 8000606c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bfa:	0000a497          	auipc	s1,0xa
    80001bfe:	d7e48493          	add	s1,s1,-642 # 8000b978 <proc+0x158>
    80001c02:	0000f917          	auipc	s2,0xf
    80001c06:	77690913          	add	s2,s2,1910 # 80011378 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c0a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001c0c:	00006997          	auipc	s3,0x6
    80001c10:	69498993          	add	s3,s3,1684 # 800082a0 <etext+0x2a0>
    printf("%d %s %s", p->pid, state, p->name);
    80001c14:	00006a97          	auipc	s5,0x6
    80001c18:	694a8a93          	add	s5,s5,1684 # 800082a8 <etext+0x2a8>
    printf("\n");
    80001c1c:	00006a17          	auipc	s4,0x6
    80001c20:	3fca0a13          	add	s4,s4,1020 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c24:	00007b97          	auipc	s7,0x7
    80001c28:	c0cb8b93          	add	s7,s7,-1012 # 80008830 <states.0>
    80001c2c:	a00d                	j	80001c4e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001c2e:	ed86a583          	lw	a1,-296(a3)
    80001c32:	8556                	mv	a0,s5
    80001c34:	00004097          	auipc	ra,0x4
    80001c38:	438080e7          	jalr	1080(ra) # 8000606c <printf>
    printf("\n");
    80001c3c:	8552                	mv	a0,s4
    80001c3e:	00004097          	auipc	ra,0x4
    80001c42:	42e080e7          	jalr	1070(ra) # 8000606c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c46:	16848493          	add	s1,s1,360
    80001c4a:	03248263          	beq	s1,s2,80001c6e <procdump+0x9a>
    if(p->state == UNUSED)
    80001c4e:	86a6                	mv	a3,s1
    80001c50:	ec04a783          	lw	a5,-320(s1)
    80001c54:	dbed                	beqz	a5,80001c46 <procdump+0x72>
      state = "???";
    80001c56:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c58:	fcfb6be3          	bltu	s6,a5,80001c2e <procdump+0x5a>
    80001c5c:	02079713          	sll	a4,a5,0x20
    80001c60:	01d75793          	srl	a5,a4,0x1d
    80001c64:	97de                	add	a5,a5,s7
    80001c66:	6390                	ld	a2,0(a5)
    80001c68:	f279                	bnez	a2,80001c2e <procdump+0x5a>
      state = "???";
    80001c6a:	864e                	mv	a2,s3
    80001c6c:	b7c9                	j	80001c2e <procdump+0x5a>
  }
}
    80001c6e:	60a6                	ld	ra,72(sp)
    80001c70:	6406                	ld	s0,64(sp)
    80001c72:	74e2                	ld	s1,56(sp)
    80001c74:	7942                	ld	s2,48(sp)
    80001c76:	79a2                	ld	s3,40(sp)
    80001c78:	7a02                	ld	s4,32(sp)
    80001c7a:	6ae2                	ld	s5,24(sp)
    80001c7c:	6b42                	ld	s6,16(sp)
    80001c7e:	6ba2                	ld	s7,8(sp)
    80001c80:	6161                	add	sp,sp,80
    80001c82:	8082                	ret

0000000080001c84 <swtch>:
    80001c84:	00153023          	sd	ra,0(a0)
    80001c88:	00253423          	sd	sp,8(a0)
    80001c8c:	e900                	sd	s0,16(a0)
    80001c8e:	ed04                	sd	s1,24(a0)
    80001c90:	03253023          	sd	s2,32(a0)
    80001c94:	03353423          	sd	s3,40(a0)
    80001c98:	03453823          	sd	s4,48(a0)
    80001c9c:	03553c23          	sd	s5,56(a0)
    80001ca0:	05653023          	sd	s6,64(a0)
    80001ca4:	05753423          	sd	s7,72(a0)
    80001ca8:	05853823          	sd	s8,80(a0)
    80001cac:	05953c23          	sd	s9,88(a0)
    80001cb0:	07a53023          	sd	s10,96(a0)
    80001cb4:	07b53423          	sd	s11,104(a0)
    80001cb8:	0005b083          	ld	ra,0(a1)
    80001cbc:	0085b103          	ld	sp,8(a1)
    80001cc0:	6980                	ld	s0,16(a1)
    80001cc2:	6d84                	ld	s1,24(a1)
    80001cc4:	0205b903          	ld	s2,32(a1)
    80001cc8:	0285b983          	ld	s3,40(a1)
    80001ccc:	0305ba03          	ld	s4,48(a1)
    80001cd0:	0385ba83          	ld	s5,56(a1)
    80001cd4:	0405bb03          	ld	s6,64(a1)
    80001cd8:	0485bb83          	ld	s7,72(a1)
    80001cdc:	0505bc03          	ld	s8,80(a1)
    80001ce0:	0585bc83          	ld	s9,88(a1)
    80001ce4:	0605bd03          	ld	s10,96(a1)
    80001ce8:	0685bd83          	ld	s11,104(a1)
    80001cec:	8082                	ret

0000000080001cee <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001cee:	1141                	add	sp,sp,-16
    80001cf0:	e406                	sd	ra,8(sp)
    80001cf2:	e022                	sd	s0,0(sp)
    80001cf4:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80001cf6:	00006597          	auipc	a1,0x6
    80001cfa:	5f258593          	add	a1,a1,1522 # 800082e8 <etext+0x2e8>
    80001cfe:	0000f517          	auipc	a0,0xf
    80001d02:	52250513          	add	a0,a0,1314 # 80011220 <tickslock>
    80001d06:	00005097          	auipc	ra,0x5
    80001d0a:	806080e7          	jalr	-2042(ra) # 8000650c <initlock>
}
    80001d0e:	60a2                	ld	ra,8(sp)
    80001d10:	6402                	ld	s0,0(sp)
    80001d12:	0141                	add	sp,sp,16
    80001d14:	8082                	ret

0000000080001d16 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001d16:	1141                	add	sp,sp,-16
    80001d18:	e422                	sd	s0,8(sp)
    80001d1a:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d1c:	00003797          	auipc	a5,0x3
    80001d20:	6d478793          	add	a5,a5,1748 # 800053f0 <kernelvec>
    80001d24:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001d28:	6422                	ld	s0,8(sp)
    80001d2a:	0141                	add	sp,sp,16
    80001d2c:	8082                	ret

0000000080001d2e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001d2e:	1141                	add	sp,sp,-16
    80001d30:	e406                	sd	ra,8(sp)
    80001d32:	e022                	sd	s0,0(sp)
    80001d34:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80001d36:	fffff097          	auipc	ra,0xfffff
    80001d3a:	2b8080e7          	jalr	696(ra) # 80000fee <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d3e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d42:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d44:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001d48:	00005697          	auipc	a3,0x5
    80001d4c:	2b868693          	add	a3,a3,696 # 80007000 <_trampoline>
    80001d50:	00005717          	auipc	a4,0x5
    80001d54:	2b070713          	add	a4,a4,688 # 80007000 <_trampoline>
    80001d58:	8f15                	sub	a4,a4,a3
    80001d5a:	040007b7          	lui	a5,0x4000
    80001d5e:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001d60:	07b2                	sll	a5,a5,0xc
    80001d62:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d64:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d68:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d6a:	18002673          	csrr	a2,satp
    80001d6e:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d70:	6d30                	ld	a2,88(a0)
    80001d72:	6138                	ld	a4,64(a0)
    80001d74:	6585                	lui	a1,0x1
    80001d76:	972e                	add	a4,a4,a1
    80001d78:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d7a:	6d38                	ld	a4,88(a0)
    80001d7c:	00000617          	auipc	a2,0x0
    80001d80:	13860613          	add	a2,a2,312 # 80001eb4 <usertrap>
    80001d84:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d86:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d88:	8612                	mv	a2,tp
    80001d8a:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d8c:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d90:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d94:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d98:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d9c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d9e:	6f18                	ld	a4,24(a4)
    80001da0:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001da4:	6928                	ld	a0,80(a0)
    80001da6:	8131                	srl	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001da8:	00005717          	auipc	a4,0x5
    80001dac:	2f470713          	add	a4,a4,756 # 8000709c <userret>
    80001db0:	8f15                	sub	a4,a4,a3
    80001db2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001db4:	577d                	li	a4,-1
    80001db6:	177e                	sll	a4,a4,0x3f
    80001db8:	8d59                	or	a0,a0,a4
    80001dba:	9782                	jalr	a5
}
    80001dbc:	60a2                	ld	ra,8(sp)
    80001dbe:	6402                	ld	s0,0(sp)
    80001dc0:	0141                	add	sp,sp,16
    80001dc2:	8082                	ret

0000000080001dc4 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001dc4:	1101                	add	sp,sp,-32
    80001dc6:	ec06                	sd	ra,24(sp)
    80001dc8:	e822                	sd	s0,16(sp)
    80001dca:	e426                	sd	s1,8(sp)
    80001dcc:	1000                	add	s0,sp,32
  acquire(&tickslock);
    80001dce:	0000f497          	auipc	s1,0xf
    80001dd2:	45248493          	add	s1,s1,1106 # 80011220 <tickslock>
    80001dd6:	8526                	mv	a0,s1
    80001dd8:	00004097          	auipc	ra,0x4
    80001ddc:	7c4080e7          	jalr	1988(ra) # 8000659c <acquire>
  ticks++;
    80001de0:	00009517          	auipc	a0,0x9
    80001de4:	5d850513          	add	a0,a0,1496 # 8000b3b8 <ticks>
    80001de8:	411c                	lw	a5,0(a0)
    80001dea:	2785                	addw	a5,a5,1
    80001dec:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001dee:	00000097          	auipc	ra,0x0
    80001df2:	996080e7          	jalr	-1642(ra) # 80001784 <wakeup>
  release(&tickslock);
    80001df6:	8526                	mv	a0,s1
    80001df8:	00005097          	auipc	ra,0x5
    80001dfc:	858080e7          	jalr	-1960(ra) # 80006650 <release>
}
    80001e00:	60e2                	ld	ra,24(sp)
    80001e02:	6442                	ld	s0,16(sp)
    80001e04:	64a2                	ld	s1,8(sp)
    80001e06:	6105                	add	sp,sp,32
    80001e08:	8082                	ret

0000000080001e0a <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e0a:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001e0e:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001e10:	0a07d163          	bgez	a5,80001eb2 <devintr+0xa8>
{
    80001e14:	1101                	add	sp,sp,-32
    80001e16:	ec06                	sd	ra,24(sp)
    80001e18:	e822                	sd	s0,16(sp)
    80001e1a:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    80001e1c:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001e20:	46a5                	li	a3,9
    80001e22:	00d70c63          	beq	a4,a3,80001e3a <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001e26:	577d                	li	a4,-1
    80001e28:	177e                	sll	a4,a4,0x3f
    80001e2a:	0705                	add	a4,a4,1
    return 0;
    80001e2c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001e2e:	06e78163          	beq	a5,a4,80001e90 <devintr+0x86>
  }
}
    80001e32:	60e2                	ld	ra,24(sp)
    80001e34:	6442                	ld	s0,16(sp)
    80001e36:	6105                	add	sp,sp,32
    80001e38:	8082                	ret
    80001e3a:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001e3c:	00003097          	auipc	ra,0x3
    80001e40:	6c0080e7          	jalr	1728(ra) # 800054fc <plic_claim>
    80001e44:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e46:	47a9                	li	a5,10
    80001e48:	00f50963          	beq	a0,a5,80001e5a <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001e4c:	4785                	li	a5,1
    80001e4e:	00f50b63          	beq	a0,a5,80001e64 <devintr+0x5a>
    return 1;
    80001e52:	4505                	li	a0,1
    } else if(irq){
    80001e54:	ec89                	bnez	s1,80001e6e <devintr+0x64>
    80001e56:	64a2                	ld	s1,8(sp)
    80001e58:	bfe9                	j	80001e32 <devintr+0x28>
      uartintr();
    80001e5a:	00004097          	auipc	ra,0x4
    80001e5e:	662080e7          	jalr	1634(ra) # 800064bc <uartintr>
    if(irq)
    80001e62:	a839                	j	80001e80 <devintr+0x76>
      virtio_disk_intr();
    80001e64:	00004097          	auipc	ra,0x4
    80001e68:	bc2080e7          	jalr	-1086(ra) # 80005a26 <virtio_disk_intr>
    if(irq)
    80001e6c:	a811                	j	80001e80 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e6e:	85a6                	mv	a1,s1
    80001e70:	00006517          	auipc	a0,0x6
    80001e74:	48050513          	add	a0,a0,1152 # 800082f0 <etext+0x2f0>
    80001e78:	00004097          	auipc	ra,0x4
    80001e7c:	1f4080e7          	jalr	500(ra) # 8000606c <printf>
      plic_complete(irq);
    80001e80:	8526                	mv	a0,s1
    80001e82:	00003097          	auipc	ra,0x3
    80001e86:	69e080e7          	jalr	1694(ra) # 80005520 <plic_complete>
    return 1;
    80001e8a:	4505                	li	a0,1
    80001e8c:	64a2                	ld	s1,8(sp)
    80001e8e:	b755                	j	80001e32 <devintr+0x28>
    if(cpuid() == 0){
    80001e90:	fffff097          	auipc	ra,0xfffff
    80001e94:	132080e7          	jalr	306(ra) # 80000fc2 <cpuid>
    80001e98:	c901                	beqz	a0,80001ea8 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e9a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e9e:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ea0:	14479073          	csrw	sip,a5
    return 2;
    80001ea4:	4509                	li	a0,2
    80001ea6:	b771                	j	80001e32 <devintr+0x28>
      clockintr();
    80001ea8:	00000097          	auipc	ra,0x0
    80001eac:	f1c080e7          	jalr	-228(ra) # 80001dc4 <clockintr>
    80001eb0:	b7ed                	j	80001e9a <devintr+0x90>
}
    80001eb2:	8082                	ret

0000000080001eb4 <usertrap>:
{
    80001eb4:	1101                	add	sp,sp,-32
    80001eb6:	ec06                	sd	ra,24(sp)
    80001eb8:	e822                	sd	s0,16(sp)
    80001eba:	e426                	sd	s1,8(sp)
    80001ebc:	e04a                	sd	s2,0(sp)
    80001ebe:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ec0:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ec4:	1007f793          	and	a5,a5,256
    80001ec8:	e3b1                	bnez	a5,80001f0c <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001eca:	00003797          	auipc	a5,0x3
    80001ece:	52678793          	add	a5,a5,1318 # 800053f0 <kernelvec>
    80001ed2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ed6:	fffff097          	auipc	ra,0xfffff
    80001eda:	118080e7          	jalr	280(ra) # 80000fee <myproc>
    80001ede:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ee0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ee2:	14102773          	csrr	a4,sepc
    80001ee6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ee8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001eec:	47a1                	li	a5,8
    80001eee:	02f70763          	beq	a4,a5,80001f1c <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001ef2:	00000097          	auipc	ra,0x0
    80001ef6:	f18080e7          	jalr	-232(ra) # 80001e0a <devintr>
    80001efa:	892a                	mv	s2,a0
    80001efc:	c151                	beqz	a0,80001f80 <usertrap+0xcc>
  if(killed(p))
    80001efe:	8526                	mv	a0,s1
    80001f00:	00000097          	auipc	ra,0x0
    80001f04:	ac8080e7          	jalr	-1336(ra) # 800019c8 <killed>
    80001f08:	c929                	beqz	a0,80001f5a <usertrap+0xa6>
    80001f0a:	a099                	j	80001f50 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001f0c:	00006517          	auipc	a0,0x6
    80001f10:	40450513          	add	a0,a0,1028 # 80008310 <etext+0x310>
    80001f14:	00004097          	auipc	ra,0x4
    80001f18:	10e080e7          	jalr	270(ra) # 80006022 <panic>
    if(killed(p))
    80001f1c:	00000097          	auipc	ra,0x0
    80001f20:	aac080e7          	jalr	-1364(ra) # 800019c8 <killed>
    80001f24:	e921                	bnez	a0,80001f74 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001f26:	6cb8                	ld	a4,88(s1)
    80001f28:	6f1c                	ld	a5,24(a4)
    80001f2a:	0791                	add	a5,a5,4
    80001f2c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f2e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f32:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f36:	10079073          	csrw	sstatus,a5
    syscall();
    80001f3a:	00000097          	auipc	ra,0x0
    80001f3e:	2d4080e7          	jalr	724(ra) # 8000220e <syscall>
  if(killed(p))
    80001f42:	8526                	mv	a0,s1
    80001f44:	00000097          	auipc	ra,0x0
    80001f48:	a84080e7          	jalr	-1404(ra) # 800019c8 <killed>
    80001f4c:	c911                	beqz	a0,80001f60 <usertrap+0xac>
    80001f4e:	4901                	li	s2,0
    exit(-1);
    80001f50:	557d                	li	a0,-1
    80001f52:	00000097          	auipc	ra,0x0
    80001f56:	902080e7          	jalr	-1790(ra) # 80001854 <exit>
  if(which_dev == 2)
    80001f5a:	4789                	li	a5,2
    80001f5c:	04f90f63          	beq	s2,a5,80001fba <usertrap+0x106>
  usertrapret();
    80001f60:	00000097          	auipc	ra,0x0
    80001f64:	dce080e7          	jalr	-562(ra) # 80001d2e <usertrapret>
}
    80001f68:	60e2                	ld	ra,24(sp)
    80001f6a:	6442                	ld	s0,16(sp)
    80001f6c:	64a2                	ld	s1,8(sp)
    80001f6e:	6902                	ld	s2,0(sp)
    80001f70:	6105                	add	sp,sp,32
    80001f72:	8082                	ret
      exit(-1);
    80001f74:	557d                	li	a0,-1
    80001f76:	00000097          	auipc	ra,0x0
    80001f7a:	8de080e7          	jalr	-1826(ra) # 80001854 <exit>
    80001f7e:	b765                	j	80001f26 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f80:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f84:	5890                	lw	a2,48(s1)
    80001f86:	00006517          	auipc	a0,0x6
    80001f8a:	3aa50513          	add	a0,a0,938 # 80008330 <etext+0x330>
    80001f8e:	00004097          	auipc	ra,0x4
    80001f92:	0de080e7          	jalr	222(ra) # 8000606c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f96:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f9a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f9e:	00006517          	auipc	a0,0x6
    80001fa2:	3c250513          	add	a0,a0,962 # 80008360 <etext+0x360>
    80001fa6:	00004097          	auipc	ra,0x4
    80001faa:	0c6080e7          	jalr	198(ra) # 8000606c <printf>
    setkilled(p);
    80001fae:	8526                	mv	a0,s1
    80001fb0:	00000097          	auipc	ra,0x0
    80001fb4:	9ec080e7          	jalr	-1556(ra) # 8000199c <setkilled>
    80001fb8:	b769                	j	80001f42 <usertrap+0x8e>
    yield();
    80001fba:	fffff097          	auipc	ra,0xfffff
    80001fbe:	72a080e7          	jalr	1834(ra) # 800016e4 <yield>
    80001fc2:	bf79                	j	80001f60 <usertrap+0xac>

0000000080001fc4 <kerneltrap>:
{
    80001fc4:	7179                	add	sp,sp,-48
    80001fc6:	f406                	sd	ra,40(sp)
    80001fc8:	f022                	sd	s0,32(sp)
    80001fca:	ec26                	sd	s1,24(sp)
    80001fcc:	e84a                	sd	s2,16(sp)
    80001fce:	e44e                	sd	s3,8(sp)
    80001fd0:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fd2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fd6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fda:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001fde:	1004f793          	and	a5,s1,256
    80001fe2:	cb85                	beqz	a5,80002012 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fe4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001fe8:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80001fea:	ef85                	bnez	a5,80002022 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001fec:	00000097          	auipc	ra,0x0
    80001ff0:	e1e080e7          	jalr	-482(ra) # 80001e0a <devintr>
    80001ff4:	cd1d                	beqz	a0,80002032 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ff6:	4789                	li	a5,2
    80001ff8:	06f50a63          	beq	a0,a5,8000206c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ffc:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002000:	10049073          	csrw	sstatus,s1
}
    80002004:	70a2                	ld	ra,40(sp)
    80002006:	7402                	ld	s0,32(sp)
    80002008:	64e2                	ld	s1,24(sp)
    8000200a:	6942                	ld	s2,16(sp)
    8000200c:	69a2                	ld	s3,8(sp)
    8000200e:	6145                	add	sp,sp,48
    80002010:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002012:	00006517          	auipc	a0,0x6
    80002016:	36e50513          	add	a0,a0,878 # 80008380 <etext+0x380>
    8000201a:	00004097          	auipc	ra,0x4
    8000201e:	008080e7          	jalr	8(ra) # 80006022 <panic>
    panic("kerneltrap: interrupts enabled");
    80002022:	00006517          	auipc	a0,0x6
    80002026:	38650513          	add	a0,a0,902 # 800083a8 <etext+0x3a8>
    8000202a:	00004097          	auipc	ra,0x4
    8000202e:	ff8080e7          	jalr	-8(ra) # 80006022 <panic>
    printf("scause %p\n", scause);
    80002032:	85ce                	mv	a1,s3
    80002034:	00006517          	auipc	a0,0x6
    80002038:	39450513          	add	a0,a0,916 # 800083c8 <etext+0x3c8>
    8000203c:	00004097          	auipc	ra,0x4
    80002040:	030080e7          	jalr	48(ra) # 8000606c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002044:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002048:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000204c:	00006517          	auipc	a0,0x6
    80002050:	38c50513          	add	a0,a0,908 # 800083d8 <etext+0x3d8>
    80002054:	00004097          	auipc	ra,0x4
    80002058:	018080e7          	jalr	24(ra) # 8000606c <printf>
    panic("kerneltrap");
    8000205c:	00006517          	auipc	a0,0x6
    80002060:	39450513          	add	a0,a0,916 # 800083f0 <etext+0x3f0>
    80002064:	00004097          	auipc	ra,0x4
    80002068:	fbe080e7          	jalr	-66(ra) # 80006022 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000206c:	fffff097          	auipc	ra,0xfffff
    80002070:	f82080e7          	jalr	-126(ra) # 80000fee <myproc>
    80002074:	d541                	beqz	a0,80001ffc <kerneltrap+0x38>
    80002076:	fffff097          	auipc	ra,0xfffff
    8000207a:	f78080e7          	jalr	-136(ra) # 80000fee <myproc>
    8000207e:	4d18                	lw	a4,24(a0)
    80002080:	4791                	li	a5,4
    80002082:	f6f71de3          	bne	a4,a5,80001ffc <kerneltrap+0x38>
    yield();
    80002086:	fffff097          	auipc	ra,0xfffff
    8000208a:	65e080e7          	jalr	1630(ra) # 800016e4 <yield>
    8000208e:	b7bd                	j	80001ffc <kerneltrap+0x38>

0000000080002090 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002090:	1101                	add	sp,sp,-32
    80002092:	ec06                	sd	ra,24(sp)
    80002094:	e822                	sd	s0,16(sp)
    80002096:	e426                	sd	s1,8(sp)
    80002098:	1000                	add	s0,sp,32
    8000209a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000209c:	fffff097          	auipc	ra,0xfffff
    800020a0:	f52080e7          	jalr	-174(ra) # 80000fee <myproc>
  switch (n) {
    800020a4:	4795                	li	a5,5
    800020a6:	0497e163          	bltu	a5,s1,800020e8 <argraw+0x58>
    800020aa:	048a                	sll	s1,s1,0x2
    800020ac:	00006717          	auipc	a4,0x6
    800020b0:	7b470713          	add	a4,a4,1972 # 80008860 <states.0+0x30>
    800020b4:	94ba                	add	s1,s1,a4
    800020b6:	409c                	lw	a5,0(s1)
    800020b8:	97ba                	add	a5,a5,a4
    800020ba:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800020bc:	6d3c                	ld	a5,88(a0)
    800020be:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800020c0:	60e2                	ld	ra,24(sp)
    800020c2:	6442                	ld	s0,16(sp)
    800020c4:	64a2                	ld	s1,8(sp)
    800020c6:	6105                	add	sp,sp,32
    800020c8:	8082                	ret
    return p->trapframe->a1;
    800020ca:	6d3c                	ld	a5,88(a0)
    800020cc:	7fa8                	ld	a0,120(a5)
    800020ce:	bfcd                	j	800020c0 <argraw+0x30>
    return p->trapframe->a2;
    800020d0:	6d3c                	ld	a5,88(a0)
    800020d2:	63c8                	ld	a0,128(a5)
    800020d4:	b7f5                	j	800020c0 <argraw+0x30>
    return p->trapframe->a3;
    800020d6:	6d3c                	ld	a5,88(a0)
    800020d8:	67c8                	ld	a0,136(a5)
    800020da:	b7dd                	j	800020c0 <argraw+0x30>
    return p->trapframe->a4;
    800020dc:	6d3c                	ld	a5,88(a0)
    800020de:	6bc8                	ld	a0,144(a5)
    800020e0:	b7c5                	j	800020c0 <argraw+0x30>
    return p->trapframe->a5;
    800020e2:	6d3c                	ld	a5,88(a0)
    800020e4:	6fc8                	ld	a0,152(a5)
    800020e6:	bfe9                	j	800020c0 <argraw+0x30>
  panic("argraw");
    800020e8:	00006517          	auipc	a0,0x6
    800020ec:	31850513          	add	a0,a0,792 # 80008400 <etext+0x400>
    800020f0:	00004097          	auipc	ra,0x4
    800020f4:	f32080e7          	jalr	-206(ra) # 80006022 <panic>

00000000800020f8 <fetchaddr>:
{
    800020f8:	1101                	add	sp,sp,-32
    800020fa:	ec06                	sd	ra,24(sp)
    800020fc:	e822                	sd	s0,16(sp)
    800020fe:	e426                	sd	s1,8(sp)
    80002100:	e04a                	sd	s2,0(sp)
    80002102:	1000                	add	s0,sp,32
    80002104:	84aa                	mv	s1,a0
    80002106:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002108:	fffff097          	auipc	ra,0xfffff
    8000210c:	ee6080e7          	jalr	-282(ra) # 80000fee <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002110:	653c                	ld	a5,72(a0)
    80002112:	02f4f863          	bgeu	s1,a5,80002142 <fetchaddr+0x4a>
    80002116:	00848713          	add	a4,s1,8
    8000211a:	02e7e663          	bltu	a5,a4,80002146 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000211e:	46a1                	li	a3,8
    80002120:	8626                	mv	a2,s1
    80002122:	85ca                	mv	a1,s2
    80002124:	6928                	ld	a0,80(a0)
    80002126:	fffff097          	auipc	ra,0xfffff
    8000212a:	bf0080e7          	jalr	-1040(ra) # 80000d16 <copyin>
    8000212e:	00a03533          	snez	a0,a0
    80002132:	40a00533          	neg	a0,a0
}
    80002136:	60e2                	ld	ra,24(sp)
    80002138:	6442                	ld	s0,16(sp)
    8000213a:	64a2                	ld	s1,8(sp)
    8000213c:	6902                	ld	s2,0(sp)
    8000213e:	6105                	add	sp,sp,32
    80002140:	8082                	ret
    return -1;
    80002142:	557d                	li	a0,-1
    80002144:	bfcd                	j	80002136 <fetchaddr+0x3e>
    80002146:	557d                	li	a0,-1
    80002148:	b7fd                	j	80002136 <fetchaddr+0x3e>

000000008000214a <fetchstr>:
{
    8000214a:	7179                	add	sp,sp,-48
    8000214c:	f406                	sd	ra,40(sp)
    8000214e:	f022                	sd	s0,32(sp)
    80002150:	ec26                	sd	s1,24(sp)
    80002152:	e84a                	sd	s2,16(sp)
    80002154:	e44e                	sd	s3,8(sp)
    80002156:	1800                	add	s0,sp,48
    80002158:	892a                	mv	s2,a0
    8000215a:	84ae                	mv	s1,a1
    8000215c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000215e:	fffff097          	auipc	ra,0xfffff
    80002162:	e90080e7          	jalr	-368(ra) # 80000fee <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002166:	86ce                	mv	a3,s3
    80002168:	864a                	mv	a2,s2
    8000216a:	85a6                	mv	a1,s1
    8000216c:	6928                	ld	a0,80(a0)
    8000216e:	fffff097          	auipc	ra,0xfffff
    80002172:	c36080e7          	jalr	-970(ra) # 80000da4 <copyinstr>
    80002176:	00054e63          	bltz	a0,80002192 <fetchstr+0x48>
  return strlen(buf);
    8000217a:	8526                	mv	a0,s1
    8000217c:	ffffe097          	auipc	ra,0xffffe
    80002180:	172080e7          	jalr	370(ra) # 800002ee <strlen>
}
    80002184:	70a2                	ld	ra,40(sp)
    80002186:	7402                	ld	s0,32(sp)
    80002188:	64e2                	ld	s1,24(sp)
    8000218a:	6942                	ld	s2,16(sp)
    8000218c:	69a2                	ld	s3,8(sp)
    8000218e:	6145                	add	sp,sp,48
    80002190:	8082                	ret
    return -1;
    80002192:	557d                	li	a0,-1
    80002194:	bfc5                	j	80002184 <fetchstr+0x3a>

0000000080002196 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002196:	1101                	add	sp,sp,-32
    80002198:	ec06                	sd	ra,24(sp)
    8000219a:	e822                	sd	s0,16(sp)
    8000219c:	e426                	sd	s1,8(sp)
    8000219e:	1000                	add	s0,sp,32
    800021a0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021a2:	00000097          	auipc	ra,0x0
    800021a6:	eee080e7          	jalr	-274(ra) # 80002090 <argraw>
    800021aa:	c088                	sw	a0,0(s1)
}
    800021ac:	60e2                	ld	ra,24(sp)
    800021ae:	6442                	ld	s0,16(sp)
    800021b0:	64a2                	ld	s1,8(sp)
    800021b2:	6105                	add	sp,sp,32
    800021b4:	8082                	ret

00000000800021b6 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800021b6:	1101                	add	sp,sp,-32
    800021b8:	ec06                	sd	ra,24(sp)
    800021ba:	e822                	sd	s0,16(sp)
    800021bc:	e426                	sd	s1,8(sp)
    800021be:	1000                	add	s0,sp,32
    800021c0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021c2:	00000097          	auipc	ra,0x0
    800021c6:	ece080e7          	jalr	-306(ra) # 80002090 <argraw>
    800021ca:	e088                	sd	a0,0(s1)
}
    800021cc:	60e2                	ld	ra,24(sp)
    800021ce:	6442                	ld	s0,16(sp)
    800021d0:	64a2                	ld	s1,8(sp)
    800021d2:	6105                	add	sp,sp,32
    800021d4:	8082                	ret

00000000800021d6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800021d6:	7179                	add	sp,sp,-48
    800021d8:	f406                	sd	ra,40(sp)
    800021da:	f022                	sd	s0,32(sp)
    800021dc:	ec26                	sd	s1,24(sp)
    800021de:	e84a                	sd	s2,16(sp)
    800021e0:	1800                	add	s0,sp,48
    800021e2:	84ae                	mv	s1,a1
    800021e4:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800021e6:	fd840593          	add	a1,s0,-40
    800021ea:	00000097          	auipc	ra,0x0
    800021ee:	fcc080e7          	jalr	-52(ra) # 800021b6 <argaddr>
  return fetchstr(addr, buf, max);
    800021f2:	864a                	mv	a2,s2
    800021f4:	85a6                	mv	a1,s1
    800021f6:	fd843503          	ld	a0,-40(s0)
    800021fa:	00000097          	auipc	ra,0x0
    800021fe:	f50080e7          	jalr	-176(ra) # 8000214a <fetchstr>
}
    80002202:	70a2                	ld	ra,40(sp)
    80002204:	7402                	ld	s0,32(sp)
    80002206:	64e2                	ld	s1,24(sp)
    80002208:	6942                	ld	s2,16(sp)
    8000220a:	6145                	add	sp,sp,48
    8000220c:	8082                	ret

000000008000220e <syscall>:



void
syscall(void)
{
    8000220e:	1101                	add	sp,sp,-32
    80002210:	ec06                	sd	ra,24(sp)
    80002212:	e822                	sd	s0,16(sp)
    80002214:	e426                	sd	s1,8(sp)
    80002216:	e04a                	sd	s2,0(sp)
    80002218:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000221a:	fffff097          	auipc	ra,0xfffff
    8000221e:	dd4080e7          	jalr	-556(ra) # 80000fee <myproc>
    80002222:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002224:	05853903          	ld	s2,88(a0)
    80002228:	0a893783          	ld	a5,168(s2)
    8000222c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002230:	37fd                	addw	a5,a5,-1
    80002232:	4775                	li	a4,29
    80002234:	00f76f63          	bltu	a4,a5,80002252 <syscall+0x44>
    80002238:	00369713          	sll	a4,a3,0x3
    8000223c:	00006797          	auipc	a5,0x6
    80002240:	63c78793          	add	a5,a5,1596 # 80008878 <syscalls>
    80002244:	97ba                	add	a5,a5,a4
    80002246:	639c                	ld	a5,0(a5)
    80002248:	c789                	beqz	a5,80002252 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000224a:	9782                	jalr	a5
    8000224c:	06a93823          	sd	a0,112(s2)
    80002250:	a839                	j	8000226e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002252:	15848613          	add	a2,s1,344
    80002256:	588c                	lw	a1,48(s1)
    80002258:	00006517          	auipc	a0,0x6
    8000225c:	1b050513          	add	a0,a0,432 # 80008408 <etext+0x408>
    80002260:	00004097          	auipc	ra,0x4
    80002264:	e0c080e7          	jalr	-500(ra) # 8000606c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002268:	6cbc                	ld	a5,88(s1)
    8000226a:	577d                	li	a4,-1
    8000226c:	fbb8                	sd	a4,112(a5)
  }
}
    8000226e:	60e2                	ld	ra,24(sp)
    80002270:	6442                	ld	s0,16(sp)
    80002272:	64a2                	ld	s1,8(sp)
    80002274:	6902                	ld	s2,0(sp)
    80002276:	6105                	add	sp,sp,32
    80002278:	8082                	ret

000000008000227a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000227a:	1101                	add	sp,sp,-32
    8000227c:	ec06                	sd	ra,24(sp)
    8000227e:	e822                	sd	s0,16(sp)
    80002280:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    80002282:	fec40593          	add	a1,s0,-20
    80002286:	4501                	li	a0,0
    80002288:	00000097          	auipc	ra,0x0
    8000228c:	f0e080e7          	jalr	-242(ra) # 80002196 <argint>
  exit(n);
    80002290:	fec42503          	lw	a0,-20(s0)
    80002294:	fffff097          	auipc	ra,0xfffff
    80002298:	5c0080e7          	jalr	1472(ra) # 80001854 <exit>
  return 0;  // not reached
}
    8000229c:	4501                	li	a0,0
    8000229e:	60e2                	ld	ra,24(sp)
    800022a0:	6442                	ld	s0,16(sp)
    800022a2:	6105                	add	sp,sp,32
    800022a4:	8082                	ret

00000000800022a6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800022a6:	1141                	add	sp,sp,-16
    800022a8:	e406                	sd	ra,8(sp)
    800022aa:	e022                	sd	s0,0(sp)
    800022ac:	0800                	add	s0,sp,16
  return myproc()->pid;
    800022ae:	fffff097          	auipc	ra,0xfffff
    800022b2:	d40080e7          	jalr	-704(ra) # 80000fee <myproc>
}
    800022b6:	5908                	lw	a0,48(a0)
    800022b8:	60a2                	ld	ra,8(sp)
    800022ba:	6402                	ld	s0,0(sp)
    800022bc:	0141                	add	sp,sp,16
    800022be:	8082                	ret

00000000800022c0 <sys_fork>:

uint64
sys_fork(void)
{
    800022c0:	1141                	add	sp,sp,-16
    800022c2:	e406                	sd	ra,8(sp)
    800022c4:	e022                	sd	s0,0(sp)
    800022c6:	0800                	add	s0,sp,16
  return fork();
    800022c8:	fffff097          	auipc	ra,0xfffff
    800022cc:	164080e7          	jalr	356(ra) # 8000142c <fork>
}
    800022d0:	60a2                	ld	ra,8(sp)
    800022d2:	6402                	ld	s0,0(sp)
    800022d4:	0141                	add	sp,sp,16
    800022d6:	8082                	ret

00000000800022d8 <sys_wait>:

uint64
sys_wait(void)
{
    800022d8:	1101                	add	sp,sp,-32
    800022da:	ec06                	sd	ra,24(sp)
    800022dc:	e822                	sd	s0,16(sp)
    800022de:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800022e0:	fe840593          	add	a1,s0,-24
    800022e4:	4501                	li	a0,0
    800022e6:	00000097          	auipc	ra,0x0
    800022ea:	ed0080e7          	jalr	-304(ra) # 800021b6 <argaddr>
  return wait(p);
    800022ee:	fe843503          	ld	a0,-24(s0)
    800022f2:	fffff097          	auipc	ra,0xfffff
    800022f6:	708080e7          	jalr	1800(ra) # 800019fa <wait>
}
    800022fa:	60e2                	ld	ra,24(sp)
    800022fc:	6442                	ld	s0,16(sp)
    800022fe:	6105                	add	sp,sp,32
    80002300:	8082                	ret

0000000080002302 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002302:	7179                	add	sp,sp,-48
    80002304:	f406                	sd	ra,40(sp)
    80002306:	f022                	sd	s0,32(sp)
    80002308:	ec26                	sd	s1,24(sp)
    8000230a:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000230c:	fdc40593          	add	a1,s0,-36
    80002310:	4501                	li	a0,0
    80002312:	00000097          	auipc	ra,0x0
    80002316:	e84080e7          	jalr	-380(ra) # 80002196 <argint>
  addr = myproc()->sz;
    8000231a:	fffff097          	auipc	ra,0xfffff
    8000231e:	cd4080e7          	jalr	-812(ra) # 80000fee <myproc>
    80002322:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002324:	fdc42503          	lw	a0,-36(s0)
    80002328:	fffff097          	auipc	ra,0xfffff
    8000232c:	0a8080e7          	jalr	168(ra) # 800013d0 <growproc>
    80002330:	00054863          	bltz	a0,80002340 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002334:	8526                	mv	a0,s1
    80002336:	70a2                	ld	ra,40(sp)
    80002338:	7402                	ld	s0,32(sp)
    8000233a:	64e2                	ld	s1,24(sp)
    8000233c:	6145                	add	sp,sp,48
    8000233e:	8082                	ret
    return -1;
    80002340:	54fd                	li	s1,-1
    80002342:	bfcd                	j	80002334 <sys_sbrk+0x32>

0000000080002344 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002344:	7139                	add	sp,sp,-64
    80002346:	fc06                	sd	ra,56(sp)
    80002348:	f822                	sd	s0,48(sp)
    8000234a:	f04a                	sd	s2,32(sp)
    8000234c:	0080                	add	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    8000234e:	fcc40593          	add	a1,s0,-52
    80002352:	4501                	li	a0,0
    80002354:	00000097          	auipc	ra,0x0
    80002358:	e42080e7          	jalr	-446(ra) # 80002196 <argint>
  acquire(&tickslock);
    8000235c:	0000f517          	auipc	a0,0xf
    80002360:	ec450513          	add	a0,a0,-316 # 80011220 <tickslock>
    80002364:	00004097          	auipc	ra,0x4
    80002368:	238080e7          	jalr	568(ra) # 8000659c <acquire>
  ticks0 = ticks;
    8000236c:	00009917          	auipc	s2,0x9
    80002370:	04c92903          	lw	s2,76(s2) # 8000b3b8 <ticks>
  while(ticks - ticks0 < n){
    80002374:	fcc42783          	lw	a5,-52(s0)
    80002378:	c3b9                	beqz	a5,800023be <sys_sleep+0x7a>
    8000237a:	f426                	sd	s1,40(sp)
    8000237c:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000237e:	0000f997          	auipc	s3,0xf
    80002382:	ea298993          	add	s3,s3,-350 # 80011220 <tickslock>
    80002386:	00009497          	auipc	s1,0x9
    8000238a:	03248493          	add	s1,s1,50 # 8000b3b8 <ticks>
    if(killed(myproc())){
    8000238e:	fffff097          	auipc	ra,0xfffff
    80002392:	c60080e7          	jalr	-928(ra) # 80000fee <myproc>
    80002396:	fffff097          	auipc	ra,0xfffff
    8000239a:	632080e7          	jalr	1586(ra) # 800019c8 <killed>
    8000239e:	ed15                	bnez	a0,800023da <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    800023a0:	85ce                	mv	a1,s3
    800023a2:	8526                	mv	a0,s1
    800023a4:	fffff097          	auipc	ra,0xfffff
    800023a8:	37c080e7          	jalr	892(ra) # 80001720 <sleep>
  while(ticks - ticks0 < n){
    800023ac:	409c                	lw	a5,0(s1)
    800023ae:	412787bb          	subw	a5,a5,s2
    800023b2:	fcc42703          	lw	a4,-52(s0)
    800023b6:	fce7ece3          	bltu	a5,a4,8000238e <sys_sleep+0x4a>
    800023ba:	74a2                	ld	s1,40(sp)
    800023bc:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800023be:	0000f517          	auipc	a0,0xf
    800023c2:	e6250513          	add	a0,a0,-414 # 80011220 <tickslock>
    800023c6:	00004097          	auipc	ra,0x4
    800023ca:	28a080e7          	jalr	650(ra) # 80006650 <release>
  return 0;
    800023ce:	4501                	li	a0,0
}
    800023d0:	70e2                	ld	ra,56(sp)
    800023d2:	7442                	ld	s0,48(sp)
    800023d4:	7902                	ld	s2,32(sp)
    800023d6:	6121                	add	sp,sp,64
    800023d8:	8082                	ret
      release(&tickslock);
    800023da:	0000f517          	auipc	a0,0xf
    800023de:	e4650513          	add	a0,a0,-442 # 80011220 <tickslock>
    800023e2:	00004097          	auipc	ra,0x4
    800023e6:	26e080e7          	jalr	622(ra) # 80006650 <release>
      return -1;
    800023ea:	557d                	li	a0,-1
    800023ec:	74a2                	ld	s1,40(sp)
    800023ee:	69e2                	ld	s3,24(sp)
    800023f0:	b7c5                	j	800023d0 <sys_sleep+0x8c>

00000000800023f2 <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    800023f2:	711d                	add	sp,sp,-96
    800023f4:	ec86                	sd	ra,88(sp)
    800023f6:	e8a2                	sd	s0,80(sp)
    800023f8:	fc4e                	sd	s3,56(sp)
    800023fa:	1080                	add	s0,sp,96
  // lab pgtbl: your code here.
  uint64 srt_va;
  int num;
  uint64 ubit_m;
  unsigned int kbit_m = 0;
    800023fc:	fa042223          	sw	zero,-92(s0)
  struct proc *p = myproc(); 
    80002400:	fffff097          	auipc	ra,0xfffff
    80002404:	bee080e7          	jalr	-1042(ra) # 80000fee <myproc>
    80002408:	89aa                	mv	s3,a0

  argaddr(0, &srt_va);
    8000240a:	fb840593          	add	a1,s0,-72
    8000240e:	4501                	li	a0,0
    80002410:	00000097          	auipc	ra,0x0
    80002414:	da6080e7          	jalr	-602(ra) # 800021b6 <argaddr>
  argint(1, &num);
    80002418:	fb440593          	add	a1,s0,-76
    8000241c:	4505                	li	a0,1
    8000241e:	00000097          	auipc	ra,0x0
    80002422:	d78080e7          	jalr	-648(ra) # 80002196 <argint>
  argaddr(2, &ubit_m);
    80002426:	fa840593          	add	a1,s0,-88
    8000242a:	4509                	li	a0,2
    8000242c:	00000097          	auipc	ra,0x0
    80002430:	d8a080e7          	jalr	-630(ra) # 800021b6 <argaddr>

  if(num >32) {
    80002434:	fb442783          	lw	a5,-76(s0)
    80002438:	02000713          	li	a4,32
    8000243c:	02f74463          	blt	a4,a5,80002464 <sys_pgaccess+0x72>
    80002440:	e4a6                	sd	s1,72(sp)
  }

  uint64 va;
  pte_t *pte;
  int i;
  for(i = 0, va = srt_va; va < srt_va + num * PGSIZE; i++, va += PGSIZE) {
    80002442:	fb843483          	ld	s1,-72(s0)
    80002446:	00c7979b          	sllw	a5,a5,0xc
    8000244a:	97a6                	add	a5,a5,s1
    8000244c:	06f4fe63          	bgeu	s1,a5,800024c8 <sys_pgaccess+0xd6>
    80002450:	e0ca                	sd	s2,64(sp)
    80002452:	f852                	sd	s4,48(sp)
    80002454:	f456                	sd	s5,40(sp)
    80002456:	f05a                	sd	s6,32(sp)
    80002458:	4901                	li	s2,0
    if((pte = walk(p->pagetable, va, 0)) != 0) {
      if((*pte & PTE_V) && (*pte & PTE_A)) {
    8000245a:	04100a93          	li	s5,65
        kbit_m = (kbit_m | (1L << i));
    8000245e:	4b05                	li	s6,1
  for(i = 0, va = srt_va; va < srt_va + num * PGSIZE; i++, va += PGSIZE) {
    80002460:	6a05                	lui	s4,0x1
    80002462:	a035                	j	8000248e <sys_pgaccess+0x9c>
    printf("sys_pgaccess: Scan too much pages!");
    80002464:	00006517          	auipc	a0,0x6
    80002468:	fc450513          	add	a0,a0,-60 # 80008428 <etext+0x428>
    8000246c:	00004097          	auipc	ra,0x4
    80002470:	c00080e7          	jalr	-1024(ra) # 8000606c <printf>
    return -1;
    80002474:	57fd                	li	a5,-1
    80002476:	a885                	j	800024e6 <sys_pgaccess+0xf4>
  for(i = 0, va = srt_va; va < srt_va + num * PGSIZE; i++, va += PGSIZE) {
    80002478:	2905                	addw	s2,s2,1
    8000247a:	94d2                	add	s1,s1,s4
    8000247c:	fb442783          	lw	a5,-76(s0)
    80002480:	00c7979b          	sllw	a5,a5,0xc
    80002484:	fb843703          	ld	a4,-72(s0)
    80002488:	97ba                	add	a5,a5,a4
    8000248a:	02f4fb63          	bgeu	s1,a5,800024c0 <sys_pgaccess+0xce>
    if((pte = walk(p->pagetable, va, 0)) != 0) {
    8000248e:	4601                	li	a2,0
    80002490:	85a6                	mv	a1,s1
    80002492:	0509b503          	ld	a0,80(s3)
    80002496:	ffffe097          	auipc	ra,0xffffe
    8000249a:	fc0080e7          	jalr	-64(ra) # 80000456 <walk>
    8000249e:	dd69                	beqz	a0,80002478 <sys_pgaccess+0x86>
      if((*pte & PTE_V) && (*pte & PTE_A)) {
    800024a0:	611c                	ld	a5,0(a0)
    800024a2:	0417f713          	and	a4,a5,65
    800024a6:	fd5719e3          	bne	a4,s5,80002478 <sys_pgaccess+0x86>
        kbit_m = (kbit_m | (1L << i));
    800024aa:	012b16b3          	sll	a3,s6,s2
    800024ae:	fa442703          	lw	a4,-92(s0)
    800024b2:	8f55                	or	a4,a4,a3
    800024b4:	fae42223          	sw	a4,-92(s0)
        *pte = (*pte) & (~PTE_A);
    800024b8:	fbf7f793          	and	a5,a5,-65
    800024bc:	e11c                	sd	a5,0(a0)
    800024be:	bf6d                	j	80002478 <sys_pgaccess+0x86>
    800024c0:	6906                	ld	s2,64(sp)
    800024c2:	7a42                	ld	s4,48(sp)
    800024c4:	7aa2                	ld	s5,40(sp)
    800024c6:	7b02                	ld	s6,32(sp)
      }
    }
  }

  if(copyout(p->pagetable, ubit_m, (char *) &kbit_m, sizeof(unsigned int)) < 0) {
    800024c8:	4691                	li	a3,4
    800024ca:	fa440613          	add	a2,s0,-92
    800024ce:	fa843583          	ld	a1,-88(s0)
    800024d2:	0509b503          	ld	a0,80(s3)
    800024d6:	ffffe097          	auipc	ra,0xffffe
    800024da:	762080e7          	jalr	1890(ra) # 80000c38 <copyout>
    printf("sys_pgaccess: Failed to copy bit_mask to userspace!");
    return -1;
  }


  return 0;
    800024de:	4781                	li	a5,0
  if(copyout(p->pagetable, ubit_m, (char *) &kbit_m, sizeof(unsigned int)) < 0) {
    800024e0:	00054963          	bltz	a0,800024f2 <sys_pgaccess+0x100>
    800024e4:	64a6                	ld	s1,72(sp)
}
    800024e6:	853e                	mv	a0,a5
    800024e8:	60e6                	ld	ra,88(sp)
    800024ea:	6446                	ld	s0,80(sp)
    800024ec:	79e2                	ld	s3,56(sp)
    800024ee:	6125                	add	sp,sp,96
    800024f0:	8082                	ret
    printf("sys_pgaccess: Failed to copy bit_mask to userspace!");
    800024f2:	00006517          	auipc	a0,0x6
    800024f6:	f5e50513          	add	a0,a0,-162 # 80008450 <etext+0x450>
    800024fa:	00004097          	auipc	ra,0x4
    800024fe:	b72080e7          	jalr	-1166(ra) # 8000606c <printf>
    return -1;
    80002502:	57fd                	li	a5,-1
    80002504:	64a6                	ld	s1,72(sp)
    80002506:	b7c5                	j	800024e6 <sys_pgaccess+0xf4>

0000000080002508 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    80002508:	1101                	add	sp,sp,-32
    8000250a:	ec06                	sd	ra,24(sp)
    8000250c:	e822                	sd	s0,16(sp)
    8000250e:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    80002510:	fec40593          	add	a1,s0,-20
    80002514:	4501                	li	a0,0
    80002516:	00000097          	auipc	ra,0x0
    8000251a:	c80080e7          	jalr	-896(ra) # 80002196 <argint>
  return kill(pid);
    8000251e:	fec42503          	lw	a0,-20(s0)
    80002522:	fffff097          	auipc	ra,0xfffff
    80002526:	408080e7          	jalr	1032(ra) # 8000192a <kill>
}
    8000252a:	60e2                	ld	ra,24(sp)
    8000252c:	6442                	ld	s0,16(sp)
    8000252e:	6105                	add	sp,sp,32
    80002530:	8082                	ret

0000000080002532 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002532:	1101                	add	sp,sp,-32
    80002534:	ec06                	sd	ra,24(sp)
    80002536:	e822                	sd	s0,16(sp)
    80002538:	e426                	sd	s1,8(sp)
    8000253a:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000253c:	0000f517          	auipc	a0,0xf
    80002540:	ce450513          	add	a0,a0,-796 # 80011220 <tickslock>
    80002544:	00004097          	auipc	ra,0x4
    80002548:	058080e7          	jalr	88(ra) # 8000659c <acquire>
  xticks = ticks;
    8000254c:	00009497          	auipc	s1,0x9
    80002550:	e6c4a483          	lw	s1,-404(s1) # 8000b3b8 <ticks>
  release(&tickslock);
    80002554:	0000f517          	auipc	a0,0xf
    80002558:	ccc50513          	add	a0,a0,-820 # 80011220 <tickslock>
    8000255c:	00004097          	auipc	ra,0x4
    80002560:	0f4080e7          	jalr	244(ra) # 80006650 <release>
  return xticks;
}
    80002564:	02049513          	sll	a0,s1,0x20
    80002568:	9101                	srl	a0,a0,0x20
    8000256a:	60e2                	ld	ra,24(sp)
    8000256c:	6442                	ld	s0,16(sp)
    8000256e:	64a2                	ld	s1,8(sp)
    80002570:	6105                	add	sp,sp,32
    80002572:	8082                	ret

0000000080002574 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002574:	7179                	add	sp,sp,-48
    80002576:	f406                	sd	ra,40(sp)
    80002578:	f022                	sd	s0,32(sp)
    8000257a:	ec26                	sd	s1,24(sp)
    8000257c:	e84a                	sd	s2,16(sp)
    8000257e:	e44e                	sd	s3,8(sp)
    80002580:	e052                	sd	s4,0(sp)
    80002582:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002584:	00006597          	auipc	a1,0x6
    80002588:	f0458593          	add	a1,a1,-252 # 80008488 <etext+0x488>
    8000258c:	0000f517          	auipc	a0,0xf
    80002590:	cac50513          	add	a0,a0,-852 # 80011238 <bcache>
    80002594:	00004097          	auipc	ra,0x4
    80002598:	f78080e7          	jalr	-136(ra) # 8000650c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000259c:	00017797          	auipc	a5,0x17
    800025a0:	c9c78793          	add	a5,a5,-868 # 80019238 <bcache+0x8000>
    800025a4:	00017717          	auipc	a4,0x17
    800025a8:	efc70713          	add	a4,a4,-260 # 800194a0 <bcache+0x8268>
    800025ac:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800025b0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800025b4:	0000f497          	auipc	s1,0xf
    800025b8:	c9c48493          	add	s1,s1,-868 # 80011250 <bcache+0x18>
    b->next = bcache.head.next;
    800025bc:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800025be:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800025c0:	00006a17          	auipc	s4,0x6
    800025c4:	ed0a0a13          	add	s4,s4,-304 # 80008490 <etext+0x490>
    b->next = bcache.head.next;
    800025c8:	2b893783          	ld	a5,696(s2)
    800025cc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800025ce:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800025d2:	85d2                	mv	a1,s4
    800025d4:	01048513          	add	a0,s1,16
    800025d8:	00001097          	auipc	ra,0x1
    800025dc:	4e8080e7          	jalr	1256(ra) # 80003ac0 <initsleeplock>
    bcache.head.next->prev = b;
    800025e0:	2b893783          	ld	a5,696(s2)
    800025e4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800025e6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800025ea:	45848493          	add	s1,s1,1112
    800025ee:	fd349de3          	bne	s1,s3,800025c8 <binit+0x54>
  }
}
    800025f2:	70a2                	ld	ra,40(sp)
    800025f4:	7402                	ld	s0,32(sp)
    800025f6:	64e2                	ld	s1,24(sp)
    800025f8:	6942                	ld	s2,16(sp)
    800025fa:	69a2                	ld	s3,8(sp)
    800025fc:	6a02                	ld	s4,0(sp)
    800025fe:	6145                	add	sp,sp,48
    80002600:	8082                	ret

0000000080002602 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002602:	7179                	add	sp,sp,-48
    80002604:	f406                	sd	ra,40(sp)
    80002606:	f022                	sd	s0,32(sp)
    80002608:	ec26                	sd	s1,24(sp)
    8000260a:	e84a                	sd	s2,16(sp)
    8000260c:	e44e                	sd	s3,8(sp)
    8000260e:	1800                	add	s0,sp,48
    80002610:	892a                	mv	s2,a0
    80002612:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002614:	0000f517          	auipc	a0,0xf
    80002618:	c2450513          	add	a0,a0,-988 # 80011238 <bcache>
    8000261c:	00004097          	auipc	ra,0x4
    80002620:	f80080e7          	jalr	-128(ra) # 8000659c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002624:	00017497          	auipc	s1,0x17
    80002628:	ecc4b483          	ld	s1,-308(s1) # 800194f0 <bcache+0x82b8>
    8000262c:	00017797          	auipc	a5,0x17
    80002630:	e7478793          	add	a5,a5,-396 # 800194a0 <bcache+0x8268>
    80002634:	02f48f63          	beq	s1,a5,80002672 <bread+0x70>
    80002638:	873e                	mv	a4,a5
    8000263a:	a021                	j	80002642 <bread+0x40>
    8000263c:	68a4                	ld	s1,80(s1)
    8000263e:	02e48a63          	beq	s1,a4,80002672 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002642:	449c                	lw	a5,8(s1)
    80002644:	ff279ce3          	bne	a5,s2,8000263c <bread+0x3a>
    80002648:	44dc                	lw	a5,12(s1)
    8000264a:	ff3799e3          	bne	a5,s3,8000263c <bread+0x3a>
      b->refcnt++;
    8000264e:	40bc                	lw	a5,64(s1)
    80002650:	2785                	addw	a5,a5,1
    80002652:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002654:	0000f517          	auipc	a0,0xf
    80002658:	be450513          	add	a0,a0,-1052 # 80011238 <bcache>
    8000265c:	00004097          	auipc	ra,0x4
    80002660:	ff4080e7          	jalr	-12(ra) # 80006650 <release>
      acquiresleep(&b->lock);
    80002664:	01048513          	add	a0,s1,16
    80002668:	00001097          	auipc	ra,0x1
    8000266c:	492080e7          	jalr	1170(ra) # 80003afa <acquiresleep>
      return b;
    80002670:	a8b9                	j	800026ce <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002672:	00017497          	auipc	s1,0x17
    80002676:	e764b483          	ld	s1,-394(s1) # 800194e8 <bcache+0x82b0>
    8000267a:	00017797          	auipc	a5,0x17
    8000267e:	e2678793          	add	a5,a5,-474 # 800194a0 <bcache+0x8268>
    80002682:	00f48863          	beq	s1,a5,80002692 <bread+0x90>
    80002686:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002688:	40bc                	lw	a5,64(s1)
    8000268a:	cf81                	beqz	a5,800026a2 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000268c:	64a4                	ld	s1,72(s1)
    8000268e:	fee49de3          	bne	s1,a4,80002688 <bread+0x86>
  panic("bget: no buffers");
    80002692:	00006517          	auipc	a0,0x6
    80002696:	e0650513          	add	a0,a0,-506 # 80008498 <etext+0x498>
    8000269a:	00004097          	auipc	ra,0x4
    8000269e:	988080e7          	jalr	-1656(ra) # 80006022 <panic>
      b->dev = dev;
    800026a2:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800026a6:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800026aa:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800026ae:	4785                	li	a5,1
    800026b0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800026b2:	0000f517          	auipc	a0,0xf
    800026b6:	b8650513          	add	a0,a0,-1146 # 80011238 <bcache>
    800026ba:	00004097          	auipc	ra,0x4
    800026be:	f96080e7          	jalr	-106(ra) # 80006650 <release>
      acquiresleep(&b->lock);
    800026c2:	01048513          	add	a0,s1,16
    800026c6:	00001097          	auipc	ra,0x1
    800026ca:	434080e7          	jalr	1076(ra) # 80003afa <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800026ce:	409c                	lw	a5,0(s1)
    800026d0:	cb89                	beqz	a5,800026e2 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800026d2:	8526                	mv	a0,s1
    800026d4:	70a2                	ld	ra,40(sp)
    800026d6:	7402                	ld	s0,32(sp)
    800026d8:	64e2                	ld	s1,24(sp)
    800026da:	6942                	ld	s2,16(sp)
    800026dc:	69a2                	ld	s3,8(sp)
    800026de:	6145                	add	sp,sp,48
    800026e0:	8082                	ret
    virtio_disk_rw(b, 0);
    800026e2:	4581                	li	a1,0
    800026e4:	8526                	mv	a0,s1
    800026e6:	00003097          	auipc	ra,0x3
    800026ea:	112080e7          	jalr	274(ra) # 800057f8 <virtio_disk_rw>
    b->valid = 1;
    800026ee:	4785                	li	a5,1
    800026f0:	c09c                	sw	a5,0(s1)
  return b;
    800026f2:	b7c5                	j	800026d2 <bread+0xd0>

00000000800026f4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800026f4:	1101                	add	sp,sp,-32
    800026f6:	ec06                	sd	ra,24(sp)
    800026f8:	e822                	sd	s0,16(sp)
    800026fa:	e426                	sd	s1,8(sp)
    800026fc:	1000                	add	s0,sp,32
    800026fe:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002700:	0541                	add	a0,a0,16
    80002702:	00001097          	auipc	ra,0x1
    80002706:	492080e7          	jalr	1170(ra) # 80003b94 <holdingsleep>
    8000270a:	cd01                	beqz	a0,80002722 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000270c:	4585                	li	a1,1
    8000270e:	8526                	mv	a0,s1
    80002710:	00003097          	auipc	ra,0x3
    80002714:	0e8080e7          	jalr	232(ra) # 800057f8 <virtio_disk_rw>
}
    80002718:	60e2                	ld	ra,24(sp)
    8000271a:	6442                	ld	s0,16(sp)
    8000271c:	64a2                	ld	s1,8(sp)
    8000271e:	6105                	add	sp,sp,32
    80002720:	8082                	ret
    panic("bwrite");
    80002722:	00006517          	auipc	a0,0x6
    80002726:	d8e50513          	add	a0,a0,-626 # 800084b0 <etext+0x4b0>
    8000272a:	00004097          	auipc	ra,0x4
    8000272e:	8f8080e7          	jalr	-1800(ra) # 80006022 <panic>

0000000080002732 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002732:	1101                	add	sp,sp,-32
    80002734:	ec06                	sd	ra,24(sp)
    80002736:	e822                	sd	s0,16(sp)
    80002738:	e426                	sd	s1,8(sp)
    8000273a:	e04a                	sd	s2,0(sp)
    8000273c:	1000                	add	s0,sp,32
    8000273e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002740:	01050913          	add	s2,a0,16
    80002744:	854a                	mv	a0,s2
    80002746:	00001097          	auipc	ra,0x1
    8000274a:	44e080e7          	jalr	1102(ra) # 80003b94 <holdingsleep>
    8000274e:	c925                	beqz	a0,800027be <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002750:	854a                	mv	a0,s2
    80002752:	00001097          	auipc	ra,0x1
    80002756:	3fe080e7          	jalr	1022(ra) # 80003b50 <releasesleep>

  acquire(&bcache.lock);
    8000275a:	0000f517          	auipc	a0,0xf
    8000275e:	ade50513          	add	a0,a0,-1314 # 80011238 <bcache>
    80002762:	00004097          	auipc	ra,0x4
    80002766:	e3a080e7          	jalr	-454(ra) # 8000659c <acquire>
  b->refcnt--;
    8000276a:	40bc                	lw	a5,64(s1)
    8000276c:	37fd                	addw	a5,a5,-1
    8000276e:	0007871b          	sext.w	a4,a5
    80002772:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002774:	e71d                	bnez	a4,800027a2 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002776:	68b8                	ld	a4,80(s1)
    80002778:	64bc                	ld	a5,72(s1)
    8000277a:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000277c:	68b8                	ld	a4,80(s1)
    8000277e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002780:	00017797          	auipc	a5,0x17
    80002784:	ab878793          	add	a5,a5,-1352 # 80019238 <bcache+0x8000>
    80002788:	2b87b703          	ld	a4,696(a5)
    8000278c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000278e:	00017717          	auipc	a4,0x17
    80002792:	d1270713          	add	a4,a4,-750 # 800194a0 <bcache+0x8268>
    80002796:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002798:	2b87b703          	ld	a4,696(a5)
    8000279c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000279e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800027a2:	0000f517          	auipc	a0,0xf
    800027a6:	a9650513          	add	a0,a0,-1386 # 80011238 <bcache>
    800027aa:	00004097          	auipc	ra,0x4
    800027ae:	ea6080e7          	jalr	-346(ra) # 80006650 <release>
}
    800027b2:	60e2                	ld	ra,24(sp)
    800027b4:	6442                	ld	s0,16(sp)
    800027b6:	64a2                	ld	s1,8(sp)
    800027b8:	6902                	ld	s2,0(sp)
    800027ba:	6105                	add	sp,sp,32
    800027bc:	8082                	ret
    panic("brelse");
    800027be:	00006517          	auipc	a0,0x6
    800027c2:	cfa50513          	add	a0,a0,-774 # 800084b8 <etext+0x4b8>
    800027c6:	00004097          	auipc	ra,0x4
    800027ca:	85c080e7          	jalr	-1956(ra) # 80006022 <panic>

00000000800027ce <bpin>:

void
bpin(struct buf *b) {
    800027ce:	1101                	add	sp,sp,-32
    800027d0:	ec06                	sd	ra,24(sp)
    800027d2:	e822                	sd	s0,16(sp)
    800027d4:	e426                	sd	s1,8(sp)
    800027d6:	1000                	add	s0,sp,32
    800027d8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027da:	0000f517          	auipc	a0,0xf
    800027de:	a5e50513          	add	a0,a0,-1442 # 80011238 <bcache>
    800027e2:	00004097          	auipc	ra,0x4
    800027e6:	dba080e7          	jalr	-582(ra) # 8000659c <acquire>
  b->refcnt++;
    800027ea:	40bc                	lw	a5,64(s1)
    800027ec:	2785                	addw	a5,a5,1
    800027ee:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027f0:	0000f517          	auipc	a0,0xf
    800027f4:	a4850513          	add	a0,a0,-1464 # 80011238 <bcache>
    800027f8:	00004097          	auipc	ra,0x4
    800027fc:	e58080e7          	jalr	-424(ra) # 80006650 <release>
}
    80002800:	60e2                	ld	ra,24(sp)
    80002802:	6442                	ld	s0,16(sp)
    80002804:	64a2                	ld	s1,8(sp)
    80002806:	6105                	add	sp,sp,32
    80002808:	8082                	ret

000000008000280a <bunpin>:

void
bunpin(struct buf *b) {
    8000280a:	1101                	add	sp,sp,-32
    8000280c:	ec06                	sd	ra,24(sp)
    8000280e:	e822                	sd	s0,16(sp)
    80002810:	e426                	sd	s1,8(sp)
    80002812:	1000                	add	s0,sp,32
    80002814:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002816:	0000f517          	auipc	a0,0xf
    8000281a:	a2250513          	add	a0,a0,-1502 # 80011238 <bcache>
    8000281e:	00004097          	auipc	ra,0x4
    80002822:	d7e080e7          	jalr	-642(ra) # 8000659c <acquire>
  b->refcnt--;
    80002826:	40bc                	lw	a5,64(s1)
    80002828:	37fd                	addw	a5,a5,-1
    8000282a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000282c:	0000f517          	auipc	a0,0xf
    80002830:	a0c50513          	add	a0,a0,-1524 # 80011238 <bcache>
    80002834:	00004097          	auipc	ra,0x4
    80002838:	e1c080e7          	jalr	-484(ra) # 80006650 <release>
}
    8000283c:	60e2                	ld	ra,24(sp)
    8000283e:	6442                	ld	s0,16(sp)
    80002840:	64a2                	ld	s1,8(sp)
    80002842:	6105                	add	sp,sp,32
    80002844:	8082                	ret

0000000080002846 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002846:	1101                	add	sp,sp,-32
    80002848:	ec06                	sd	ra,24(sp)
    8000284a:	e822                	sd	s0,16(sp)
    8000284c:	e426                	sd	s1,8(sp)
    8000284e:	e04a                	sd	s2,0(sp)
    80002850:	1000                	add	s0,sp,32
    80002852:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002854:	00d5d59b          	srlw	a1,a1,0xd
    80002858:	00017797          	auipc	a5,0x17
    8000285c:	0bc7a783          	lw	a5,188(a5) # 80019914 <sb+0x1c>
    80002860:	9dbd                	addw	a1,a1,a5
    80002862:	00000097          	auipc	ra,0x0
    80002866:	da0080e7          	jalr	-608(ra) # 80002602 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000286a:	0074f713          	and	a4,s1,7
    8000286e:	4785                	li	a5,1
    80002870:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002874:	14ce                	sll	s1,s1,0x33
    80002876:	90d9                	srl	s1,s1,0x36
    80002878:	00950733          	add	a4,a0,s1
    8000287c:	05874703          	lbu	a4,88(a4)
    80002880:	00e7f6b3          	and	a3,a5,a4
    80002884:	c69d                	beqz	a3,800028b2 <bfree+0x6c>
    80002886:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002888:	94aa                	add	s1,s1,a0
    8000288a:	fff7c793          	not	a5,a5
    8000288e:	8f7d                	and	a4,a4,a5
    80002890:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002894:	00001097          	auipc	ra,0x1
    80002898:	148080e7          	jalr	328(ra) # 800039dc <log_write>
  brelse(bp);
    8000289c:	854a                	mv	a0,s2
    8000289e:	00000097          	auipc	ra,0x0
    800028a2:	e94080e7          	jalr	-364(ra) # 80002732 <brelse>
}
    800028a6:	60e2                	ld	ra,24(sp)
    800028a8:	6442                	ld	s0,16(sp)
    800028aa:	64a2                	ld	s1,8(sp)
    800028ac:	6902                	ld	s2,0(sp)
    800028ae:	6105                	add	sp,sp,32
    800028b0:	8082                	ret
    panic("freeing free block");
    800028b2:	00006517          	auipc	a0,0x6
    800028b6:	c0e50513          	add	a0,a0,-1010 # 800084c0 <etext+0x4c0>
    800028ba:	00003097          	auipc	ra,0x3
    800028be:	768080e7          	jalr	1896(ra) # 80006022 <panic>

00000000800028c2 <balloc>:
{
    800028c2:	711d                	add	sp,sp,-96
    800028c4:	ec86                	sd	ra,88(sp)
    800028c6:	e8a2                	sd	s0,80(sp)
    800028c8:	e4a6                	sd	s1,72(sp)
    800028ca:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800028cc:	00017797          	auipc	a5,0x17
    800028d0:	0307a783          	lw	a5,48(a5) # 800198fc <sb+0x4>
    800028d4:	10078f63          	beqz	a5,800029f2 <balloc+0x130>
    800028d8:	e0ca                	sd	s2,64(sp)
    800028da:	fc4e                	sd	s3,56(sp)
    800028dc:	f852                	sd	s4,48(sp)
    800028de:	f456                	sd	s5,40(sp)
    800028e0:	f05a                	sd	s6,32(sp)
    800028e2:	ec5e                	sd	s7,24(sp)
    800028e4:	e862                	sd	s8,16(sp)
    800028e6:	e466                	sd	s9,8(sp)
    800028e8:	8baa                	mv	s7,a0
    800028ea:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800028ec:	00017b17          	auipc	s6,0x17
    800028f0:	00cb0b13          	add	s6,s6,12 # 800198f8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028f4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800028f6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028f8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800028fa:	6c89                	lui	s9,0x2
    800028fc:	a061                	j	80002984 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028fe:	97ca                	add	a5,a5,s2
    80002900:	8e55                	or	a2,a2,a3
    80002902:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002906:	854a                	mv	a0,s2
    80002908:	00001097          	auipc	ra,0x1
    8000290c:	0d4080e7          	jalr	212(ra) # 800039dc <log_write>
        brelse(bp);
    80002910:	854a                	mv	a0,s2
    80002912:	00000097          	auipc	ra,0x0
    80002916:	e20080e7          	jalr	-480(ra) # 80002732 <brelse>
  bp = bread(dev, bno);
    8000291a:	85a6                	mv	a1,s1
    8000291c:	855e                	mv	a0,s7
    8000291e:	00000097          	auipc	ra,0x0
    80002922:	ce4080e7          	jalr	-796(ra) # 80002602 <bread>
    80002926:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002928:	40000613          	li	a2,1024
    8000292c:	4581                	li	a1,0
    8000292e:	05850513          	add	a0,a0,88
    80002932:	ffffe097          	auipc	ra,0xffffe
    80002936:	848080e7          	jalr	-1976(ra) # 8000017a <memset>
  log_write(bp);
    8000293a:	854a                	mv	a0,s2
    8000293c:	00001097          	auipc	ra,0x1
    80002940:	0a0080e7          	jalr	160(ra) # 800039dc <log_write>
  brelse(bp);
    80002944:	854a                	mv	a0,s2
    80002946:	00000097          	auipc	ra,0x0
    8000294a:	dec080e7          	jalr	-532(ra) # 80002732 <brelse>
}
    8000294e:	6906                	ld	s2,64(sp)
    80002950:	79e2                	ld	s3,56(sp)
    80002952:	7a42                	ld	s4,48(sp)
    80002954:	7aa2                	ld	s5,40(sp)
    80002956:	7b02                	ld	s6,32(sp)
    80002958:	6be2                	ld	s7,24(sp)
    8000295a:	6c42                	ld	s8,16(sp)
    8000295c:	6ca2                	ld	s9,8(sp)
}
    8000295e:	8526                	mv	a0,s1
    80002960:	60e6                	ld	ra,88(sp)
    80002962:	6446                	ld	s0,80(sp)
    80002964:	64a6                	ld	s1,72(sp)
    80002966:	6125                	add	sp,sp,96
    80002968:	8082                	ret
    brelse(bp);
    8000296a:	854a                	mv	a0,s2
    8000296c:	00000097          	auipc	ra,0x0
    80002970:	dc6080e7          	jalr	-570(ra) # 80002732 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002974:	015c87bb          	addw	a5,s9,s5
    80002978:	00078a9b          	sext.w	s5,a5
    8000297c:	004b2703          	lw	a4,4(s6)
    80002980:	06eaf163          	bgeu	s5,a4,800029e2 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    80002984:	41fad79b          	sraw	a5,s5,0x1f
    80002988:	0137d79b          	srlw	a5,a5,0x13
    8000298c:	015787bb          	addw	a5,a5,s5
    80002990:	40d7d79b          	sraw	a5,a5,0xd
    80002994:	01cb2583          	lw	a1,28(s6)
    80002998:	9dbd                	addw	a1,a1,a5
    8000299a:	855e                	mv	a0,s7
    8000299c:	00000097          	auipc	ra,0x0
    800029a0:	c66080e7          	jalr	-922(ra) # 80002602 <bread>
    800029a4:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029a6:	004b2503          	lw	a0,4(s6)
    800029aa:	000a849b          	sext.w	s1,s5
    800029ae:	8762                	mv	a4,s8
    800029b0:	faa4fde3          	bgeu	s1,a0,8000296a <balloc+0xa8>
      m = 1 << (bi % 8);
    800029b4:	00777693          	and	a3,a4,7
    800029b8:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800029bc:	41f7579b          	sraw	a5,a4,0x1f
    800029c0:	01d7d79b          	srlw	a5,a5,0x1d
    800029c4:	9fb9                	addw	a5,a5,a4
    800029c6:	4037d79b          	sraw	a5,a5,0x3
    800029ca:	00f90633          	add	a2,s2,a5
    800029ce:	05864603          	lbu	a2,88(a2)
    800029d2:	00c6f5b3          	and	a1,a3,a2
    800029d6:	d585                	beqz	a1,800028fe <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029d8:	2705                	addw	a4,a4,1
    800029da:	2485                	addw	s1,s1,1
    800029dc:	fd471ae3          	bne	a4,s4,800029b0 <balloc+0xee>
    800029e0:	b769                	j	8000296a <balloc+0xa8>
    800029e2:	6906                	ld	s2,64(sp)
    800029e4:	79e2                	ld	s3,56(sp)
    800029e6:	7a42                	ld	s4,48(sp)
    800029e8:	7aa2                	ld	s5,40(sp)
    800029ea:	7b02                	ld	s6,32(sp)
    800029ec:	6be2                	ld	s7,24(sp)
    800029ee:	6c42                	ld	s8,16(sp)
    800029f0:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800029f2:	00006517          	auipc	a0,0x6
    800029f6:	ae650513          	add	a0,a0,-1306 # 800084d8 <etext+0x4d8>
    800029fa:	00003097          	auipc	ra,0x3
    800029fe:	672080e7          	jalr	1650(ra) # 8000606c <printf>
  return 0;
    80002a02:	4481                	li	s1,0
    80002a04:	bfa9                	j	8000295e <balloc+0x9c>

0000000080002a06 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002a06:	7179                	add	sp,sp,-48
    80002a08:	f406                	sd	ra,40(sp)
    80002a0a:	f022                	sd	s0,32(sp)
    80002a0c:	ec26                	sd	s1,24(sp)
    80002a0e:	e84a                	sd	s2,16(sp)
    80002a10:	e44e                	sd	s3,8(sp)
    80002a12:	1800                	add	s0,sp,48
    80002a14:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002a16:	47ad                	li	a5,11
    80002a18:	02b7e863          	bltu	a5,a1,80002a48 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002a1c:	02059793          	sll	a5,a1,0x20
    80002a20:	01e7d593          	srl	a1,a5,0x1e
    80002a24:	00b504b3          	add	s1,a0,a1
    80002a28:	0504a903          	lw	s2,80(s1)
    80002a2c:	08091263          	bnez	s2,80002ab0 <bmap+0xaa>
      addr = balloc(ip->dev);
    80002a30:	4108                	lw	a0,0(a0)
    80002a32:	00000097          	auipc	ra,0x0
    80002a36:	e90080e7          	jalr	-368(ra) # 800028c2 <balloc>
    80002a3a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002a3e:	06090963          	beqz	s2,80002ab0 <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    80002a42:	0524a823          	sw	s2,80(s1)
    80002a46:	a0ad                	j	80002ab0 <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002a48:	ff45849b          	addw	s1,a1,-12
    80002a4c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002a50:	0ff00793          	li	a5,255
    80002a54:	08e7e863          	bltu	a5,a4,80002ae4 <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002a58:	08052903          	lw	s2,128(a0)
    80002a5c:	00091f63          	bnez	s2,80002a7a <bmap+0x74>
      addr = balloc(ip->dev);
    80002a60:	4108                	lw	a0,0(a0)
    80002a62:	00000097          	auipc	ra,0x0
    80002a66:	e60080e7          	jalr	-416(ra) # 800028c2 <balloc>
    80002a6a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002a6e:	04090163          	beqz	s2,80002ab0 <bmap+0xaa>
    80002a72:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002a74:	0929a023          	sw	s2,128(s3)
    80002a78:	a011                	j	80002a7c <bmap+0x76>
    80002a7a:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002a7c:	85ca                	mv	a1,s2
    80002a7e:	0009a503          	lw	a0,0(s3)
    80002a82:	00000097          	auipc	ra,0x0
    80002a86:	b80080e7          	jalr	-1152(ra) # 80002602 <bread>
    80002a8a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a8c:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80002a90:	02049713          	sll	a4,s1,0x20
    80002a94:	01e75593          	srl	a1,a4,0x1e
    80002a98:	00b784b3          	add	s1,a5,a1
    80002a9c:	0004a903          	lw	s2,0(s1)
    80002aa0:	02090063          	beqz	s2,80002ac0 <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002aa4:	8552                	mv	a0,s4
    80002aa6:	00000097          	auipc	ra,0x0
    80002aaa:	c8c080e7          	jalr	-884(ra) # 80002732 <brelse>
    return addr;
    80002aae:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002ab0:	854a                	mv	a0,s2
    80002ab2:	70a2                	ld	ra,40(sp)
    80002ab4:	7402                	ld	s0,32(sp)
    80002ab6:	64e2                	ld	s1,24(sp)
    80002ab8:	6942                	ld	s2,16(sp)
    80002aba:	69a2                	ld	s3,8(sp)
    80002abc:	6145                	add	sp,sp,48
    80002abe:	8082                	ret
      addr = balloc(ip->dev);
    80002ac0:	0009a503          	lw	a0,0(s3)
    80002ac4:	00000097          	auipc	ra,0x0
    80002ac8:	dfe080e7          	jalr	-514(ra) # 800028c2 <balloc>
    80002acc:	0005091b          	sext.w	s2,a0
      if(addr){
    80002ad0:	fc090ae3          	beqz	s2,80002aa4 <bmap+0x9e>
        a[bn] = addr;
    80002ad4:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002ad8:	8552                	mv	a0,s4
    80002ada:	00001097          	auipc	ra,0x1
    80002ade:	f02080e7          	jalr	-254(ra) # 800039dc <log_write>
    80002ae2:	b7c9                	j	80002aa4 <bmap+0x9e>
    80002ae4:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002ae6:	00006517          	auipc	a0,0x6
    80002aea:	a0a50513          	add	a0,a0,-1526 # 800084f0 <etext+0x4f0>
    80002aee:	00003097          	auipc	ra,0x3
    80002af2:	534080e7          	jalr	1332(ra) # 80006022 <panic>

0000000080002af6 <iget>:
{
    80002af6:	7179                	add	sp,sp,-48
    80002af8:	f406                	sd	ra,40(sp)
    80002afa:	f022                	sd	s0,32(sp)
    80002afc:	ec26                	sd	s1,24(sp)
    80002afe:	e84a                	sd	s2,16(sp)
    80002b00:	e44e                	sd	s3,8(sp)
    80002b02:	e052                	sd	s4,0(sp)
    80002b04:	1800                	add	s0,sp,48
    80002b06:	89aa                	mv	s3,a0
    80002b08:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002b0a:	00017517          	auipc	a0,0x17
    80002b0e:	e0e50513          	add	a0,a0,-498 # 80019918 <itable>
    80002b12:	00004097          	auipc	ra,0x4
    80002b16:	a8a080e7          	jalr	-1398(ra) # 8000659c <acquire>
  empty = 0;
    80002b1a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b1c:	00017497          	auipc	s1,0x17
    80002b20:	e1448493          	add	s1,s1,-492 # 80019930 <itable+0x18>
    80002b24:	00019697          	auipc	a3,0x19
    80002b28:	89c68693          	add	a3,a3,-1892 # 8001b3c0 <log>
    80002b2c:	a039                	j	80002b3a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b2e:	02090b63          	beqz	s2,80002b64 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b32:	08848493          	add	s1,s1,136
    80002b36:	02d48a63          	beq	s1,a3,80002b6a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002b3a:	449c                	lw	a5,8(s1)
    80002b3c:	fef059e3          	blez	a5,80002b2e <iget+0x38>
    80002b40:	4098                	lw	a4,0(s1)
    80002b42:	ff3716e3          	bne	a4,s3,80002b2e <iget+0x38>
    80002b46:	40d8                	lw	a4,4(s1)
    80002b48:	ff4713e3          	bne	a4,s4,80002b2e <iget+0x38>
      ip->ref++;
    80002b4c:	2785                	addw	a5,a5,1
    80002b4e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b50:	00017517          	auipc	a0,0x17
    80002b54:	dc850513          	add	a0,a0,-568 # 80019918 <itable>
    80002b58:	00004097          	auipc	ra,0x4
    80002b5c:	af8080e7          	jalr	-1288(ra) # 80006650 <release>
      return ip;
    80002b60:	8926                	mv	s2,s1
    80002b62:	a03d                	j	80002b90 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b64:	f7f9                	bnez	a5,80002b32 <iget+0x3c>
      empty = ip;
    80002b66:	8926                	mv	s2,s1
    80002b68:	b7e9                	j	80002b32 <iget+0x3c>
  if(empty == 0)
    80002b6a:	02090c63          	beqz	s2,80002ba2 <iget+0xac>
  ip->dev = dev;
    80002b6e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b72:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b76:	4785                	li	a5,1
    80002b78:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b7c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002b80:	00017517          	auipc	a0,0x17
    80002b84:	d9850513          	add	a0,a0,-616 # 80019918 <itable>
    80002b88:	00004097          	auipc	ra,0x4
    80002b8c:	ac8080e7          	jalr	-1336(ra) # 80006650 <release>
}
    80002b90:	854a                	mv	a0,s2
    80002b92:	70a2                	ld	ra,40(sp)
    80002b94:	7402                	ld	s0,32(sp)
    80002b96:	64e2                	ld	s1,24(sp)
    80002b98:	6942                	ld	s2,16(sp)
    80002b9a:	69a2                	ld	s3,8(sp)
    80002b9c:	6a02                	ld	s4,0(sp)
    80002b9e:	6145                	add	sp,sp,48
    80002ba0:	8082                	ret
    panic("iget: no inodes");
    80002ba2:	00006517          	auipc	a0,0x6
    80002ba6:	96650513          	add	a0,a0,-1690 # 80008508 <etext+0x508>
    80002baa:	00003097          	auipc	ra,0x3
    80002bae:	478080e7          	jalr	1144(ra) # 80006022 <panic>

0000000080002bb2 <fsinit>:
fsinit(int dev) {
    80002bb2:	7179                	add	sp,sp,-48
    80002bb4:	f406                	sd	ra,40(sp)
    80002bb6:	f022                	sd	s0,32(sp)
    80002bb8:	ec26                	sd	s1,24(sp)
    80002bba:	e84a                	sd	s2,16(sp)
    80002bbc:	e44e                	sd	s3,8(sp)
    80002bbe:	1800                	add	s0,sp,48
    80002bc0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002bc2:	4585                	li	a1,1
    80002bc4:	00000097          	auipc	ra,0x0
    80002bc8:	a3e080e7          	jalr	-1474(ra) # 80002602 <bread>
    80002bcc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002bce:	00017997          	auipc	s3,0x17
    80002bd2:	d2a98993          	add	s3,s3,-726 # 800198f8 <sb>
    80002bd6:	02000613          	li	a2,32
    80002bda:	05850593          	add	a1,a0,88
    80002bde:	854e                	mv	a0,s3
    80002be0:	ffffd097          	auipc	ra,0xffffd
    80002be4:	5f6080e7          	jalr	1526(ra) # 800001d6 <memmove>
  brelse(bp);
    80002be8:	8526                	mv	a0,s1
    80002bea:	00000097          	auipc	ra,0x0
    80002bee:	b48080e7          	jalr	-1208(ra) # 80002732 <brelse>
  if(sb.magic != FSMAGIC)
    80002bf2:	0009a703          	lw	a4,0(s3)
    80002bf6:	102037b7          	lui	a5,0x10203
    80002bfa:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002bfe:	02f71263          	bne	a4,a5,80002c22 <fsinit+0x70>
  initlog(dev, &sb);
    80002c02:	00017597          	auipc	a1,0x17
    80002c06:	cf658593          	add	a1,a1,-778 # 800198f8 <sb>
    80002c0a:	854a                	mv	a0,s2
    80002c0c:	00001097          	auipc	ra,0x1
    80002c10:	b60080e7          	jalr	-1184(ra) # 8000376c <initlog>
}
    80002c14:	70a2                	ld	ra,40(sp)
    80002c16:	7402                	ld	s0,32(sp)
    80002c18:	64e2                	ld	s1,24(sp)
    80002c1a:	6942                	ld	s2,16(sp)
    80002c1c:	69a2                	ld	s3,8(sp)
    80002c1e:	6145                	add	sp,sp,48
    80002c20:	8082                	ret
    panic("invalid file system");
    80002c22:	00006517          	auipc	a0,0x6
    80002c26:	8f650513          	add	a0,a0,-1802 # 80008518 <etext+0x518>
    80002c2a:	00003097          	auipc	ra,0x3
    80002c2e:	3f8080e7          	jalr	1016(ra) # 80006022 <panic>

0000000080002c32 <iinit>:
{
    80002c32:	7179                	add	sp,sp,-48
    80002c34:	f406                	sd	ra,40(sp)
    80002c36:	f022                	sd	s0,32(sp)
    80002c38:	ec26                	sd	s1,24(sp)
    80002c3a:	e84a                	sd	s2,16(sp)
    80002c3c:	e44e                	sd	s3,8(sp)
    80002c3e:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c40:	00006597          	auipc	a1,0x6
    80002c44:	8f058593          	add	a1,a1,-1808 # 80008530 <etext+0x530>
    80002c48:	00017517          	auipc	a0,0x17
    80002c4c:	cd050513          	add	a0,a0,-816 # 80019918 <itable>
    80002c50:	00004097          	auipc	ra,0x4
    80002c54:	8bc080e7          	jalr	-1860(ra) # 8000650c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c58:	00017497          	auipc	s1,0x17
    80002c5c:	ce848493          	add	s1,s1,-792 # 80019940 <itable+0x28>
    80002c60:	00018997          	auipc	s3,0x18
    80002c64:	77098993          	add	s3,s3,1904 # 8001b3d0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c68:	00006917          	auipc	s2,0x6
    80002c6c:	8d090913          	add	s2,s2,-1840 # 80008538 <etext+0x538>
    80002c70:	85ca                	mv	a1,s2
    80002c72:	8526                	mv	a0,s1
    80002c74:	00001097          	auipc	ra,0x1
    80002c78:	e4c080e7          	jalr	-436(ra) # 80003ac0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002c7c:	08848493          	add	s1,s1,136
    80002c80:	ff3498e3          	bne	s1,s3,80002c70 <iinit+0x3e>
}
    80002c84:	70a2                	ld	ra,40(sp)
    80002c86:	7402                	ld	s0,32(sp)
    80002c88:	64e2                	ld	s1,24(sp)
    80002c8a:	6942                	ld	s2,16(sp)
    80002c8c:	69a2                	ld	s3,8(sp)
    80002c8e:	6145                	add	sp,sp,48
    80002c90:	8082                	ret

0000000080002c92 <ialloc>:
{
    80002c92:	7139                	add	sp,sp,-64
    80002c94:	fc06                	sd	ra,56(sp)
    80002c96:	f822                	sd	s0,48(sp)
    80002c98:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c9a:	00017717          	auipc	a4,0x17
    80002c9e:	c6a72703          	lw	a4,-918(a4) # 80019904 <sb+0xc>
    80002ca2:	4785                	li	a5,1
    80002ca4:	06e7f463          	bgeu	a5,a4,80002d0c <ialloc+0x7a>
    80002ca8:	f426                	sd	s1,40(sp)
    80002caa:	f04a                	sd	s2,32(sp)
    80002cac:	ec4e                	sd	s3,24(sp)
    80002cae:	e852                	sd	s4,16(sp)
    80002cb0:	e456                	sd	s5,8(sp)
    80002cb2:	e05a                	sd	s6,0(sp)
    80002cb4:	8aaa                	mv	s5,a0
    80002cb6:	8b2e                	mv	s6,a1
    80002cb8:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002cba:	00017a17          	auipc	s4,0x17
    80002cbe:	c3ea0a13          	add	s4,s4,-962 # 800198f8 <sb>
    80002cc2:	00495593          	srl	a1,s2,0x4
    80002cc6:	018a2783          	lw	a5,24(s4)
    80002cca:	9dbd                	addw	a1,a1,a5
    80002ccc:	8556                	mv	a0,s5
    80002cce:	00000097          	auipc	ra,0x0
    80002cd2:	934080e7          	jalr	-1740(ra) # 80002602 <bread>
    80002cd6:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002cd8:	05850993          	add	s3,a0,88
    80002cdc:	00f97793          	and	a5,s2,15
    80002ce0:	079a                	sll	a5,a5,0x6
    80002ce2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002ce4:	00099783          	lh	a5,0(s3)
    80002ce8:	cf9d                	beqz	a5,80002d26 <ialloc+0x94>
    brelse(bp);
    80002cea:	00000097          	auipc	ra,0x0
    80002cee:	a48080e7          	jalr	-1464(ra) # 80002732 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002cf2:	0905                	add	s2,s2,1
    80002cf4:	00ca2703          	lw	a4,12(s4)
    80002cf8:	0009079b          	sext.w	a5,s2
    80002cfc:	fce7e3e3          	bltu	a5,a4,80002cc2 <ialloc+0x30>
    80002d00:	74a2                	ld	s1,40(sp)
    80002d02:	7902                	ld	s2,32(sp)
    80002d04:	69e2                	ld	s3,24(sp)
    80002d06:	6a42                	ld	s4,16(sp)
    80002d08:	6aa2                	ld	s5,8(sp)
    80002d0a:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002d0c:	00006517          	auipc	a0,0x6
    80002d10:	83450513          	add	a0,a0,-1996 # 80008540 <etext+0x540>
    80002d14:	00003097          	auipc	ra,0x3
    80002d18:	358080e7          	jalr	856(ra) # 8000606c <printf>
  return 0;
    80002d1c:	4501                	li	a0,0
}
    80002d1e:	70e2                	ld	ra,56(sp)
    80002d20:	7442                	ld	s0,48(sp)
    80002d22:	6121                	add	sp,sp,64
    80002d24:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002d26:	04000613          	li	a2,64
    80002d2a:	4581                	li	a1,0
    80002d2c:	854e                	mv	a0,s3
    80002d2e:	ffffd097          	auipc	ra,0xffffd
    80002d32:	44c080e7          	jalr	1100(ra) # 8000017a <memset>
      dip->type = type;
    80002d36:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002d3a:	8526                	mv	a0,s1
    80002d3c:	00001097          	auipc	ra,0x1
    80002d40:	ca0080e7          	jalr	-864(ra) # 800039dc <log_write>
      brelse(bp);
    80002d44:	8526                	mv	a0,s1
    80002d46:	00000097          	auipc	ra,0x0
    80002d4a:	9ec080e7          	jalr	-1556(ra) # 80002732 <brelse>
      return iget(dev, inum);
    80002d4e:	0009059b          	sext.w	a1,s2
    80002d52:	8556                	mv	a0,s5
    80002d54:	00000097          	auipc	ra,0x0
    80002d58:	da2080e7          	jalr	-606(ra) # 80002af6 <iget>
    80002d5c:	74a2                	ld	s1,40(sp)
    80002d5e:	7902                	ld	s2,32(sp)
    80002d60:	69e2                	ld	s3,24(sp)
    80002d62:	6a42                	ld	s4,16(sp)
    80002d64:	6aa2                	ld	s5,8(sp)
    80002d66:	6b02                	ld	s6,0(sp)
    80002d68:	bf5d                	j	80002d1e <ialloc+0x8c>

0000000080002d6a <iupdate>:
{
    80002d6a:	1101                	add	sp,sp,-32
    80002d6c:	ec06                	sd	ra,24(sp)
    80002d6e:	e822                	sd	s0,16(sp)
    80002d70:	e426                	sd	s1,8(sp)
    80002d72:	e04a                	sd	s2,0(sp)
    80002d74:	1000                	add	s0,sp,32
    80002d76:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d78:	415c                	lw	a5,4(a0)
    80002d7a:	0047d79b          	srlw	a5,a5,0x4
    80002d7e:	00017597          	auipc	a1,0x17
    80002d82:	b925a583          	lw	a1,-1134(a1) # 80019910 <sb+0x18>
    80002d86:	9dbd                	addw	a1,a1,a5
    80002d88:	4108                	lw	a0,0(a0)
    80002d8a:	00000097          	auipc	ra,0x0
    80002d8e:	878080e7          	jalr	-1928(ra) # 80002602 <bread>
    80002d92:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d94:	05850793          	add	a5,a0,88
    80002d98:	40d8                	lw	a4,4(s1)
    80002d9a:	8b3d                	and	a4,a4,15
    80002d9c:	071a                	sll	a4,a4,0x6
    80002d9e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002da0:	04449703          	lh	a4,68(s1)
    80002da4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002da8:	04649703          	lh	a4,70(s1)
    80002dac:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002db0:	04849703          	lh	a4,72(s1)
    80002db4:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002db8:	04a49703          	lh	a4,74(s1)
    80002dbc:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002dc0:	44f8                	lw	a4,76(s1)
    80002dc2:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002dc4:	03400613          	li	a2,52
    80002dc8:	05048593          	add	a1,s1,80
    80002dcc:	00c78513          	add	a0,a5,12
    80002dd0:	ffffd097          	auipc	ra,0xffffd
    80002dd4:	406080e7          	jalr	1030(ra) # 800001d6 <memmove>
  log_write(bp);
    80002dd8:	854a                	mv	a0,s2
    80002dda:	00001097          	auipc	ra,0x1
    80002dde:	c02080e7          	jalr	-1022(ra) # 800039dc <log_write>
  brelse(bp);
    80002de2:	854a                	mv	a0,s2
    80002de4:	00000097          	auipc	ra,0x0
    80002de8:	94e080e7          	jalr	-1714(ra) # 80002732 <brelse>
}
    80002dec:	60e2                	ld	ra,24(sp)
    80002dee:	6442                	ld	s0,16(sp)
    80002df0:	64a2                	ld	s1,8(sp)
    80002df2:	6902                	ld	s2,0(sp)
    80002df4:	6105                	add	sp,sp,32
    80002df6:	8082                	ret

0000000080002df8 <idup>:
{
    80002df8:	1101                	add	sp,sp,-32
    80002dfa:	ec06                	sd	ra,24(sp)
    80002dfc:	e822                	sd	s0,16(sp)
    80002dfe:	e426                	sd	s1,8(sp)
    80002e00:	1000                	add	s0,sp,32
    80002e02:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e04:	00017517          	auipc	a0,0x17
    80002e08:	b1450513          	add	a0,a0,-1260 # 80019918 <itable>
    80002e0c:	00003097          	auipc	ra,0x3
    80002e10:	790080e7          	jalr	1936(ra) # 8000659c <acquire>
  ip->ref++;
    80002e14:	449c                	lw	a5,8(s1)
    80002e16:	2785                	addw	a5,a5,1
    80002e18:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e1a:	00017517          	auipc	a0,0x17
    80002e1e:	afe50513          	add	a0,a0,-1282 # 80019918 <itable>
    80002e22:	00004097          	auipc	ra,0x4
    80002e26:	82e080e7          	jalr	-2002(ra) # 80006650 <release>
}
    80002e2a:	8526                	mv	a0,s1
    80002e2c:	60e2                	ld	ra,24(sp)
    80002e2e:	6442                	ld	s0,16(sp)
    80002e30:	64a2                	ld	s1,8(sp)
    80002e32:	6105                	add	sp,sp,32
    80002e34:	8082                	ret

0000000080002e36 <ilock>:
{
    80002e36:	1101                	add	sp,sp,-32
    80002e38:	ec06                	sd	ra,24(sp)
    80002e3a:	e822                	sd	s0,16(sp)
    80002e3c:	e426                	sd	s1,8(sp)
    80002e3e:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002e40:	c10d                	beqz	a0,80002e62 <ilock+0x2c>
    80002e42:	84aa                	mv	s1,a0
    80002e44:	451c                	lw	a5,8(a0)
    80002e46:	00f05e63          	blez	a5,80002e62 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002e4a:	0541                	add	a0,a0,16
    80002e4c:	00001097          	auipc	ra,0x1
    80002e50:	cae080e7          	jalr	-850(ra) # 80003afa <acquiresleep>
  if(ip->valid == 0){
    80002e54:	40bc                	lw	a5,64(s1)
    80002e56:	cf99                	beqz	a5,80002e74 <ilock+0x3e>
}
    80002e58:	60e2                	ld	ra,24(sp)
    80002e5a:	6442                	ld	s0,16(sp)
    80002e5c:	64a2                	ld	s1,8(sp)
    80002e5e:	6105                	add	sp,sp,32
    80002e60:	8082                	ret
    80002e62:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002e64:	00005517          	auipc	a0,0x5
    80002e68:	6f450513          	add	a0,a0,1780 # 80008558 <etext+0x558>
    80002e6c:	00003097          	auipc	ra,0x3
    80002e70:	1b6080e7          	jalr	438(ra) # 80006022 <panic>
    80002e74:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e76:	40dc                	lw	a5,4(s1)
    80002e78:	0047d79b          	srlw	a5,a5,0x4
    80002e7c:	00017597          	auipc	a1,0x17
    80002e80:	a945a583          	lw	a1,-1388(a1) # 80019910 <sb+0x18>
    80002e84:	9dbd                	addw	a1,a1,a5
    80002e86:	4088                	lw	a0,0(s1)
    80002e88:	fffff097          	auipc	ra,0xfffff
    80002e8c:	77a080e7          	jalr	1914(ra) # 80002602 <bread>
    80002e90:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e92:	05850593          	add	a1,a0,88
    80002e96:	40dc                	lw	a5,4(s1)
    80002e98:	8bbd                	and	a5,a5,15
    80002e9a:	079a                	sll	a5,a5,0x6
    80002e9c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e9e:	00059783          	lh	a5,0(a1)
    80002ea2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002ea6:	00259783          	lh	a5,2(a1)
    80002eaa:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002eae:	00459783          	lh	a5,4(a1)
    80002eb2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002eb6:	00659783          	lh	a5,6(a1)
    80002eba:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002ebe:	459c                	lw	a5,8(a1)
    80002ec0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002ec2:	03400613          	li	a2,52
    80002ec6:	05b1                	add	a1,a1,12
    80002ec8:	05048513          	add	a0,s1,80
    80002ecc:	ffffd097          	auipc	ra,0xffffd
    80002ed0:	30a080e7          	jalr	778(ra) # 800001d6 <memmove>
    brelse(bp);
    80002ed4:	854a                	mv	a0,s2
    80002ed6:	00000097          	auipc	ra,0x0
    80002eda:	85c080e7          	jalr	-1956(ra) # 80002732 <brelse>
    ip->valid = 1;
    80002ede:	4785                	li	a5,1
    80002ee0:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002ee2:	04449783          	lh	a5,68(s1)
    80002ee6:	c399                	beqz	a5,80002eec <ilock+0xb6>
    80002ee8:	6902                	ld	s2,0(sp)
    80002eea:	b7bd                	j	80002e58 <ilock+0x22>
      panic("ilock: no type");
    80002eec:	00005517          	auipc	a0,0x5
    80002ef0:	67450513          	add	a0,a0,1652 # 80008560 <etext+0x560>
    80002ef4:	00003097          	auipc	ra,0x3
    80002ef8:	12e080e7          	jalr	302(ra) # 80006022 <panic>

0000000080002efc <iunlock>:
{
    80002efc:	1101                	add	sp,sp,-32
    80002efe:	ec06                	sd	ra,24(sp)
    80002f00:	e822                	sd	s0,16(sp)
    80002f02:	e426                	sd	s1,8(sp)
    80002f04:	e04a                	sd	s2,0(sp)
    80002f06:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002f08:	c905                	beqz	a0,80002f38 <iunlock+0x3c>
    80002f0a:	84aa                	mv	s1,a0
    80002f0c:	01050913          	add	s2,a0,16
    80002f10:	854a                	mv	a0,s2
    80002f12:	00001097          	auipc	ra,0x1
    80002f16:	c82080e7          	jalr	-894(ra) # 80003b94 <holdingsleep>
    80002f1a:	cd19                	beqz	a0,80002f38 <iunlock+0x3c>
    80002f1c:	449c                	lw	a5,8(s1)
    80002f1e:	00f05d63          	blez	a5,80002f38 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002f22:	854a                	mv	a0,s2
    80002f24:	00001097          	auipc	ra,0x1
    80002f28:	c2c080e7          	jalr	-980(ra) # 80003b50 <releasesleep>
}
    80002f2c:	60e2                	ld	ra,24(sp)
    80002f2e:	6442                	ld	s0,16(sp)
    80002f30:	64a2                	ld	s1,8(sp)
    80002f32:	6902                	ld	s2,0(sp)
    80002f34:	6105                	add	sp,sp,32
    80002f36:	8082                	ret
    panic("iunlock");
    80002f38:	00005517          	auipc	a0,0x5
    80002f3c:	63850513          	add	a0,a0,1592 # 80008570 <etext+0x570>
    80002f40:	00003097          	auipc	ra,0x3
    80002f44:	0e2080e7          	jalr	226(ra) # 80006022 <panic>

0000000080002f48 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002f48:	7179                	add	sp,sp,-48
    80002f4a:	f406                	sd	ra,40(sp)
    80002f4c:	f022                	sd	s0,32(sp)
    80002f4e:	ec26                	sd	s1,24(sp)
    80002f50:	e84a                	sd	s2,16(sp)
    80002f52:	e44e                	sd	s3,8(sp)
    80002f54:	1800                	add	s0,sp,48
    80002f56:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002f58:	05050493          	add	s1,a0,80
    80002f5c:	08050913          	add	s2,a0,128
    80002f60:	a021                	j	80002f68 <itrunc+0x20>
    80002f62:	0491                	add	s1,s1,4
    80002f64:	01248d63          	beq	s1,s2,80002f7e <itrunc+0x36>
    if(ip->addrs[i]){
    80002f68:	408c                	lw	a1,0(s1)
    80002f6a:	dde5                	beqz	a1,80002f62 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002f6c:	0009a503          	lw	a0,0(s3)
    80002f70:	00000097          	auipc	ra,0x0
    80002f74:	8d6080e7          	jalr	-1834(ra) # 80002846 <bfree>
      ip->addrs[i] = 0;
    80002f78:	0004a023          	sw	zero,0(s1)
    80002f7c:	b7dd                	j	80002f62 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f7e:	0809a583          	lw	a1,128(s3)
    80002f82:	ed99                	bnez	a1,80002fa0 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f84:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002f88:	854e                	mv	a0,s3
    80002f8a:	00000097          	auipc	ra,0x0
    80002f8e:	de0080e7          	jalr	-544(ra) # 80002d6a <iupdate>
}
    80002f92:	70a2                	ld	ra,40(sp)
    80002f94:	7402                	ld	s0,32(sp)
    80002f96:	64e2                	ld	s1,24(sp)
    80002f98:	6942                	ld	s2,16(sp)
    80002f9a:	69a2                	ld	s3,8(sp)
    80002f9c:	6145                	add	sp,sp,48
    80002f9e:	8082                	ret
    80002fa0:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002fa2:	0009a503          	lw	a0,0(s3)
    80002fa6:	fffff097          	auipc	ra,0xfffff
    80002faa:	65c080e7          	jalr	1628(ra) # 80002602 <bread>
    80002fae:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002fb0:	05850493          	add	s1,a0,88
    80002fb4:	45850913          	add	s2,a0,1112
    80002fb8:	a021                	j	80002fc0 <itrunc+0x78>
    80002fba:	0491                	add	s1,s1,4
    80002fbc:	01248b63          	beq	s1,s2,80002fd2 <itrunc+0x8a>
      if(a[j])
    80002fc0:	408c                	lw	a1,0(s1)
    80002fc2:	dde5                	beqz	a1,80002fba <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002fc4:	0009a503          	lw	a0,0(s3)
    80002fc8:	00000097          	auipc	ra,0x0
    80002fcc:	87e080e7          	jalr	-1922(ra) # 80002846 <bfree>
    80002fd0:	b7ed                	j	80002fba <itrunc+0x72>
    brelse(bp);
    80002fd2:	8552                	mv	a0,s4
    80002fd4:	fffff097          	auipc	ra,0xfffff
    80002fd8:	75e080e7          	jalr	1886(ra) # 80002732 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002fdc:	0809a583          	lw	a1,128(s3)
    80002fe0:	0009a503          	lw	a0,0(s3)
    80002fe4:	00000097          	auipc	ra,0x0
    80002fe8:	862080e7          	jalr	-1950(ra) # 80002846 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002fec:	0809a023          	sw	zero,128(s3)
    80002ff0:	6a02                	ld	s4,0(sp)
    80002ff2:	bf49                	j	80002f84 <itrunc+0x3c>

0000000080002ff4 <iput>:
{
    80002ff4:	1101                	add	sp,sp,-32
    80002ff6:	ec06                	sd	ra,24(sp)
    80002ff8:	e822                	sd	s0,16(sp)
    80002ffa:	e426                	sd	s1,8(sp)
    80002ffc:	1000                	add	s0,sp,32
    80002ffe:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003000:	00017517          	auipc	a0,0x17
    80003004:	91850513          	add	a0,a0,-1768 # 80019918 <itable>
    80003008:	00003097          	auipc	ra,0x3
    8000300c:	594080e7          	jalr	1428(ra) # 8000659c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003010:	4498                	lw	a4,8(s1)
    80003012:	4785                	li	a5,1
    80003014:	02f70263          	beq	a4,a5,80003038 <iput+0x44>
  ip->ref--;
    80003018:	449c                	lw	a5,8(s1)
    8000301a:	37fd                	addw	a5,a5,-1
    8000301c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000301e:	00017517          	auipc	a0,0x17
    80003022:	8fa50513          	add	a0,a0,-1798 # 80019918 <itable>
    80003026:	00003097          	auipc	ra,0x3
    8000302a:	62a080e7          	jalr	1578(ra) # 80006650 <release>
}
    8000302e:	60e2                	ld	ra,24(sp)
    80003030:	6442                	ld	s0,16(sp)
    80003032:	64a2                	ld	s1,8(sp)
    80003034:	6105                	add	sp,sp,32
    80003036:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003038:	40bc                	lw	a5,64(s1)
    8000303a:	dff9                	beqz	a5,80003018 <iput+0x24>
    8000303c:	04a49783          	lh	a5,74(s1)
    80003040:	ffe1                	bnez	a5,80003018 <iput+0x24>
    80003042:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003044:	01048913          	add	s2,s1,16
    80003048:	854a                	mv	a0,s2
    8000304a:	00001097          	auipc	ra,0x1
    8000304e:	ab0080e7          	jalr	-1360(ra) # 80003afa <acquiresleep>
    release(&itable.lock);
    80003052:	00017517          	auipc	a0,0x17
    80003056:	8c650513          	add	a0,a0,-1850 # 80019918 <itable>
    8000305a:	00003097          	auipc	ra,0x3
    8000305e:	5f6080e7          	jalr	1526(ra) # 80006650 <release>
    itrunc(ip);
    80003062:	8526                	mv	a0,s1
    80003064:	00000097          	auipc	ra,0x0
    80003068:	ee4080e7          	jalr	-284(ra) # 80002f48 <itrunc>
    ip->type = 0;
    8000306c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003070:	8526                	mv	a0,s1
    80003072:	00000097          	auipc	ra,0x0
    80003076:	cf8080e7          	jalr	-776(ra) # 80002d6a <iupdate>
    ip->valid = 0;
    8000307a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000307e:	854a                	mv	a0,s2
    80003080:	00001097          	auipc	ra,0x1
    80003084:	ad0080e7          	jalr	-1328(ra) # 80003b50 <releasesleep>
    acquire(&itable.lock);
    80003088:	00017517          	auipc	a0,0x17
    8000308c:	89050513          	add	a0,a0,-1904 # 80019918 <itable>
    80003090:	00003097          	auipc	ra,0x3
    80003094:	50c080e7          	jalr	1292(ra) # 8000659c <acquire>
    80003098:	6902                	ld	s2,0(sp)
    8000309a:	bfbd                	j	80003018 <iput+0x24>

000000008000309c <iunlockput>:
{
    8000309c:	1101                	add	sp,sp,-32
    8000309e:	ec06                	sd	ra,24(sp)
    800030a0:	e822                	sd	s0,16(sp)
    800030a2:	e426                	sd	s1,8(sp)
    800030a4:	1000                	add	s0,sp,32
    800030a6:	84aa                	mv	s1,a0
  iunlock(ip);
    800030a8:	00000097          	auipc	ra,0x0
    800030ac:	e54080e7          	jalr	-428(ra) # 80002efc <iunlock>
  iput(ip);
    800030b0:	8526                	mv	a0,s1
    800030b2:	00000097          	auipc	ra,0x0
    800030b6:	f42080e7          	jalr	-190(ra) # 80002ff4 <iput>
}
    800030ba:	60e2                	ld	ra,24(sp)
    800030bc:	6442                	ld	s0,16(sp)
    800030be:	64a2                	ld	s1,8(sp)
    800030c0:	6105                	add	sp,sp,32
    800030c2:	8082                	ret

00000000800030c4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800030c4:	1141                	add	sp,sp,-16
    800030c6:	e422                	sd	s0,8(sp)
    800030c8:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    800030ca:	411c                	lw	a5,0(a0)
    800030cc:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800030ce:	415c                	lw	a5,4(a0)
    800030d0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800030d2:	04451783          	lh	a5,68(a0)
    800030d6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800030da:	04a51783          	lh	a5,74(a0)
    800030de:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800030e2:	04c56783          	lwu	a5,76(a0)
    800030e6:	e99c                	sd	a5,16(a1)
}
    800030e8:	6422                	ld	s0,8(sp)
    800030ea:	0141                	add	sp,sp,16
    800030ec:	8082                	ret

00000000800030ee <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030ee:	457c                	lw	a5,76(a0)
    800030f0:	10d7e563          	bltu	a5,a3,800031fa <readi+0x10c>
{
    800030f4:	7159                	add	sp,sp,-112
    800030f6:	f486                	sd	ra,104(sp)
    800030f8:	f0a2                	sd	s0,96(sp)
    800030fa:	eca6                	sd	s1,88(sp)
    800030fc:	e0d2                	sd	s4,64(sp)
    800030fe:	fc56                	sd	s5,56(sp)
    80003100:	f85a                	sd	s6,48(sp)
    80003102:	f45e                	sd	s7,40(sp)
    80003104:	1880                	add	s0,sp,112
    80003106:	8b2a                	mv	s6,a0
    80003108:	8bae                	mv	s7,a1
    8000310a:	8a32                	mv	s4,a2
    8000310c:	84b6                	mv	s1,a3
    8000310e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003110:	9f35                	addw	a4,a4,a3
    return 0;
    80003112:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003114:	0cd76a63          	bltu	a4,a3,800031e8 <readi+0xfa>
    80003118:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000311a:	00e7f463          	bgeu	a5,a4,80003122 <readi+0x34>
    n = ip->size - off;
    8000311e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003122:	0a0a8963          	beqz	s5,800031d4 <readi+0xe6>
    80003126:	e8ca                	sd	s2,80(sp)
    80003128:	f062                	sd	s8,32(sp)
    8000312a:	ec66                	sd	s9,24(sp)
    8000312c:	e86a                	sd	s10,16(sp)
    8000312e:	e46e                	sd	s11,8(sp)
    80003130:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003132:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003136:	5c7d                	li	s8,-1
    80003138:	a82d                	j	80003172 <readi+0x84>
    8000313a:	020d1d93          	sll	s11,s10,0x20
    8000313e:	020ddd93          	srl	s11,s11,0x20
    80003142:	05890613          	add	a2,s2,88
    80003146:	86ee                	mv	a3,s11
    80003148:	963a                	add	a2,a2,a4
    8000314a:	85d2                	mv	a1,s4
    8000314c:	855e                	mv	a0,s7
    8000314e:	fffff097          	auipc	ra,0xfffff
    80003152:	9da080e7          	jalr	-1574(ra) # 80001b28 <either_copyout>
    80003156:	05850d63          	beq	a0,s8,800031b0 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000315a:	854a                	mv	a0,s2
    8000315c:	fffff097          	auipc	ra,0xfffff
    80003160:	5d6080e7          	jalr	1494(ra) # 80002732 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003164:	013d09bb          	addw	s3,s10,s3
    80003168:	009d04bb          	addw	s1,s10,s1
    8000316c:	9a6e                	add	s4,s4,s11
    8000316e:	0559fd63          	bgeu	s3,s5,800031c8 <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    80003172:	00a4d59b          	srlw	a1,s1,0xa
    80003176:	855a                	mv	a0,s6
    80003178:	00000097          	auipc	ra,0x0
    8000317c:	88e080e7          	jalr	-1906(ra) # 80002a06 <bmap>
    80003180:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003184:	c9b1                	beqz	a1,800031d8 <readi+0xea>
    bp = bread(ip->dev, addr);
    80003186:	000b2503          	lw	a0,0(s6)
    8000318a:	fffff097          	auipc	ra,0xfffff
    8000318e:	478080e7          	jalr	1144(ra) # 80002602 <bread>
    80003192:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003194:	3ff4f713          	and	a4,s1,1023
    80003198:	40ec87bb          	subw	a5,s9,a4
    8000319c:	413a86bb          	subw	a3,s5,s3
    800031a0:	8d3e                	mv	s10,a5
    800031a2:	2781                	sext.w	a5,a5
    800031a4:	0006861b          	sext.w	a2,a3
    800031a8:	f8f679e3          	bgeu	a2,a5,8000313a <readi+0x4c>
    800031ac:	8d36                	mv	s10,a3
    800031ae:	b771                	j	8000313a <readi+0x4c>
      brelse(bp);
    800031b0:	854a                	mv	a0,s2
    800031b2:	fffff097          	auipc	ra,0xfffff
    800031b6:	580080e7          	jalr	1408(ra) # 80002732 <brelse>
      tot = -1;
    800031ba:	59fd                	li	s3,-1
      break;
    800031bc:	6946                	ld	s2,80(sp)
    800031be:	7c02                	ld	s8,32(sp)
    800031c0:	6ce2                	ld	s9,24(sp)
    800031c2:	6d42                	ld	s10,16(sp)
    800031c4:	6da2                	ld	s11,8(sp)
    800031c6:	a831                	j	800031e2 <readi+0xf4>
    800031c8:	6946                	ld	s2,80(sp)
    800031ca:	7c02                	ld	s8,32(sp)
    800031cc:	6ce2                	ld	s9,24(sp)
    800031ce:	6d42                	ld	s10,16(sp)
    800031d0:	6da2                	ld	s11,8(sp)
    800031d2:	a801                	j	800031e2 <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800031d4:	89d6                	mv	s3,s5
    800031d6:	a031                	j	800031e2 <readi+0xf4>
    800031d8:	6946                	ld	s2,80(sp)
    800031da:	7c02                	ld	s8,32(sp)
    800031dc:	6ce2                	ld	s9,24(sp)
    800031de:	6d42                	ld	s10,16(sp)
    800031e0:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800031e2:	0009851b          	sext.w	a0,s3
    800031e6:	69a6                	ld	s3,72(sp)
}
    800031e8:	70a6                	ld	ra,104(sp)
    800031ea:	7406                	ld	s0,96(sp)
    800031ec:	64e6                	ld	s1,88(sp)
    800031ee:	6a06                	ld	s4,64(sp)
    800031f0:	7ae2                	ld	s5,56(sp)
    800031f2:	7b42                	ld	s6,48(sp)
    800031f4:	7ba2                	ld	s7,40(sp)
    800031f6:	6165                	add	sp,sp,112
    800031f8:	8082                	ret
    return 0;
    800031fa:	4501                	li	a0,0
}
    800031fc:	8082                	ret

00000000800031fe <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800031fe:	457c                	lw	a5,76(a0)
    80003200:	10d7ee63          	bltu	a5,a3,8000331c <writei+0x11e>
{
    80003204:	7159                	add	sp,sp,-112
    80003206:	f486                	sd	ra,104(sp)
    80003208:	f0a2                	sd	s0,96(sp)
    8000320a:	e8ca                	sd	s2,80(sp)
    8000320c:	e0d2                	sd	s4,64(sp)
    8000320e:	fc56                	sd	s5,56(sp)
    80003210:	f85a                	sd	s6,48(sp)
    80003212:	f45e                	sd	s7,40(sp)
    80003214:	1880                	add	s0,sp,112
    80003216:	8aaa                	mv	s5,a0
    80003218:	8bae                	mv	s7,a1
    8000321a:	8a32                	mv	s4,a2
    8000321c:	8936                	mv	s2,a3
    8000321e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003220:	00e687bb          	addw	a5,a3,a4
    80003224:	0ed7ee63          	bltu	a5,a3,80003320 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003228:	00043737          	lui	a4,0x43
    8000322c:	0ef76c63          	bltu	a4,a5,80003324 <writei+0x126>
    80003230:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003232:	0c0b0d63          	beqz	s6,8000330c <writei+0x10e>
    80003236:	eca6                	sd	s1,88(sp)
    80003238:	f062                	sd	s8,32(sp)
    8000323a:	ec66                	sd	s9,24(sp)
    8000323c:	e86a                	sd	s10,16(sp)
    8000323e:	e46e                	sd	s11,8(sp)
    80003240:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003242:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003246:	5c7d                	li	s8,-1
    80003248:	a091                	j	8000328c <writei+0x8e>
    8000324a:	020d1d93          	sll	s11,s10,0x20
    8000324e:	020ddd93          	srl	s11,s11,0x20
    80003252:	05848513          	add	a0,s1,88
    80003256:	86ee                	mv	a3,s11
    80003258:	8652                	mv	a2,s4
    8000325a:	85de                	mv	a1,s7
    8000325c:	953a                	add	a0,a0,a4
    8000325e:	fffff097          	auipc	ra,0xfffff
    80003262:	920080e7          	jalr	-1760(ra) # 80001b7e <either_copyin>
    80003266:	07850263          	beq	a0,s8,800032ca <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000326a:	8526                	mv	a0,s1
    8000326c:	00000097          	auipc	ra,0x0
    80003270:	770080e7          	jalr	1904(ra) # 800039dc <log_write>
    brelse(bp);
    80003274:	8526                	mv	a0,s1
    80003276:	fffff097          	auipc	ra,0xfffff
    8000327a:	4bc080e7          	jalr	1212(ra) # 80002732 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000327e:	013d09bb          	addw	s3,s10,s3
    80003282:	012d093b          	addw	s2,s10,s2
    80003286:	9a6e                	add	s4,s4,s11
    80003288:	0569f663          	bgeu	s3,s6,800032d4 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    8000328c:	00a9559b          	srlw	a1,s2,0xa
    80003290:	8556                	mv	a0,s5
    80003292:	fffff097          	auipc	ra,0xfffff
    80003296:	774080e7          	jalr	1908(ra) # 80002a06 <bmap>
    8000329a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000329e:	c99d                	beqz	a1,800032d4 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800032a0:	000aa503          	lw	a0,0(s5)
    800032a4:	fffff097          	auipc	ra,0xfffff
    800032a8:	35e080e7          	jalr	862(ra) # 80002602 <bread>
    800032ac:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800032ae:	3ff97713          	and	a4,s2,1023
    800032b2:	40ec87bb          	subw	a5,s9,a4
    800032b6:	413b06bb          	subw	a3,s6,s3
    800032ba:	8d3e                	mv	s10,a5
    800032bc:	2781                	sext.w	a5,a5
    800032be:	0006861b          	sext.w	a2,a3
    800032c2:	f8f674e3          	bgeu	a2,a5,8000324a <writei+0x4c>
    800032c6:	8d36                	mv	s10,a3
    800032c8:	b749                	j	8000324a <writei+0x4c>
      brelse(bp);
    800032ca:	8526                	mv	a0,s1
    800032cc:	fffff097          	auipc	ra,0xfffff
    800032d0:	466080e7          	jalr	1126(ra) # 80002732 <brelse>
  }

  if(off > ip->size)
    800032d4:	04caa783          	lw	a5,76(s5)
    800032d8:	0327fc63          	bgeu	a5,s2,80003310 <writei+0x112>
    ip->size = off;
    800032dc:	052aa623          	sw	s2,76(s5)
    800032e0:	64e6                	ld	s1,88(sp)
    800032e2:	7c02                	ld	s8,32(sp)
    800032e4:	6ce2                	ld	s9,24(sp)
    800032e6:	6d42                	ld	s10,16(sp)
    800032e8:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800032ea:	8556                	mv	a0,s5
    800032ec:	00000097          	auipc	ra,0x0
    800032f0:	a7e080e7          	jalr	-1410(ra) # 80002d6a <iupdate>

  return tot;
    800032f4:	0009851b          	sext.w	a0,s3
    800032f8:	69a6                	ld	s3,72(sp)
}
    800032fa:	70a6                	ld	ra,104(sp)
    800032fc:	7406                	ld	s0,96(sp)
    800032fe:	6946                	ld	s2,80(sp)
    80003300:	6a06                	ld	s4,64(sp)
    80003302:	7ae2                	ld	s5,56(sp)
    80003304:	7b42                	ld	s6,48(sp)
    80003306:	7ba2                	ld	s7,40(sp)
    80003308:	6165                	add	sp,sp,112
    8000330a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000330c:	89da                	mv	s3,s6
    8000330e:	bff1                	j	800032ea <writei+0xec>
    80003310:	64e6                	ld	s1,88(sp)
    80003312:	7c02                	ld	s8,32(sp)
    80003314:	6ce2                	ld	s9,24(sp)
    80003316:	6d42                	ld	s10,16(sp)
    80003318:	6da2                	ld	s11,8(sp)
    8000331a:	bfc1                	j	800032ea <writei+0xec>
    return -1;
    8000331c:	557d                	li	a0,-1
}
    8000331e:	8082                	ret
    return -1;
    80003320:	557d                	li	a0,-1
    80003322:	bfe1                	j	800032fa <writei+0xfc>
    return -1;
    80003324:	557d                	li	a0,-1
    80003326:	bfd1                	j	800032fa <writei+0xfc>

0000000080003328 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003328:	1141                	add	sp,sp,-16
    8000332a:	e406                	sd	ra,8(sp)
    8000332c:	e022                	sd	s0,0(sp)
    8000332e:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003330:	4639                	li	a2,14
    80003332:	ffffd097          	auipc	ra,0xffffd
    80003336:	f18080e7          	jalr	-232(ra) # 8000024a <strncmp>
}
    8000333a:	60a2                	ld	ra,8(sp)
    8000333c:	6402                	ld	s0,0(sp)
    8000333e:	0141                	add	sp,sp,16
    80003340:	8082                	ret

0000000080003342 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003342:	7139                	add	sp,sp,-64
    80003344:	fc06                	sd	ra,56(sp)
    80003346:	f822                	sd	s0,48(sp)
    80003348:	f426                	sd	s1,40(sp)
    8000334a:	f04a                	sd	s2,32(sp)
    8000334c:	ec4e                	sd	s3,24(sp)
    8000334e:	e852                	sd	s4,16(sp)
    80003350:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003352:	04451703          	lh	a4,68(a0)
    80003356:	4785                	li	a5,1
    80003358:	00f71a63          	bne	a4,a5,8000336c <dirlookup+0x2a>
    8000335c:	892a                	mv	s2,a0
    8000335e:	89ae                	mv	s3,a1
    80003360:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003362:	457c                	lw	a5,76(a0)
    80003364:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003366:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003368:	e79d                	bnez	a5,80003396 <dirlookup+0x54>
    8000336a:	a8a5                	j	800033e2 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000336c:	00005517          	auipc	a0,0x5
    80003370:	20c50513          	add	a0,a0,524 # 80008578 <etext+0x578>
    80003374:	00003097          	auipc	ra,0x3
    80003378:	cae080e7          	jalr	-850(ra) # 80006022 <panic>
      panic("dirlookup read");
    8000337c:	00005517          	auipc	a0,0x5
    80003380:	21450513          	add	a0,a0,532 # 80008590 <etext+0x590>
    80003384:	00003097          	auipc	ra,0x3
    80003388:	c9e080e7          	jalr	-866(ra) # 80006022 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000338c:	24c1                	addw	s1,s1,16
    8000338e:	04c92783          	lw	a5,76(s2)
    80003392:	04f4f763          	bgeu	s1,a5,800033e0 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003396:	4741                	li	a4,16
    80003398:	86a6                	mv	a3,s1
    8000339a:	fc040613          	add	a2,s0,-64
    8000339e:	4581                	li	a1,0
    800033a0:	854a                	mv	a0,s2
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	d4c080e7          	jalr	-692(ra) # 800030ee <readi>
    800033aa:	47c1                	li	a5,16
    800033ac:	fcf518e3          	bne	a0,a5,8000337c <dirlookup+0x3a>
    if(de.inum == 0)
    800033b0:	fc045783          	lhu	a5,-64(s0)
    800033b4:	dfe1                	beqz	a5,8000338c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800033b6:	fc240593          	add	a1,s0,-62
    800033ba:	854e                	mv	a0,s3
    800033bc:	00000097          	auipc	ra,0x0
    800033c0:	f6c080e7          	jalr	-148(ra) # 80003328 <namecmp>
    800033c4:	f561                	bnez	a0,8000338c <dirlookup+0x4a>
      if(poff)
    800033c6:	000a0463          	beqz	s4,800033ce <dirlookup+0x8c>
        *poff = off;
    800033ca:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800033ce:	fc045583          	lhu	a1,-64(s0)
    800033d2:	00092503          	lw	a0,0(s2)
    800033d6:	fffff097          	auipc	ra,0xfffff
    800033da:	720080e7          	jalr	1824(ra) # 80002af6 <iget>
    800033de:	a011                	j	800033e2 <dirlookup+0xa0>
  return 0;
    800033e0:	4501                	li	a0,0
}
    800033e2:	70e2                	ld	ra,56(sp)
    800033e4:	7442                	ld	s0,48(sp)
    800033e6:	74a2                	ld	s1,40(sp)
    800033e8:	7902                	ld	s2,32(sp)
    800033ea:	69e2                	ld	s3,24(sp)
    800033ec:	6a42                	ld	s4,16(sp)
    800033ee:	6121                	add	sp,sp,64
    800033f0:	8082                	ret

00000000800033f2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800033f2:	711d                	add	sp,sp,-96
    800033f4:	ec86                	sd	ra,88(sp)
    800033f6:	e8a2                	sd	s0,80(sp)
    800033f8:	e4a6                	sd	s1,72(sp)
    800033fa:	e0ca                	sd	s2,64(sp)
    800033fc:	fc4e                	sd	s3,56(sp)
    800033fe:	f852                	sd	s4,48(sp)
    80003400:	f456                	sd	s5,40(sp)
    80003402:	f05a                	sd	s6,32(sp)
    80003404:	ec5e                	sd	s7,24(sp)
    80003406:	e862                	sd	s8,16(sp)
    80003408:	e466                	sd	s9,8(sp)
    8000340a:	1080                	add	s0,sp,96
    8000340c:	84aa                	mv	s1,a0
    8000340e:	8b2e                	mv	s6,a1
    80003410:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003412:	00054703          	lbu	a4,0(a0)
    80003416:	02f00793          	li	a5,47
    8000341a:	02f70263          	beq	a4,a5,8000343e <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000341e:	ffffe097          	auipc	ra,0xffffe
    80003422:	bd0080e7          	jalr	-1072(ra) # 80000fee <myproc>
    80003426:	15053503          	ld	a0,336(a0)
    8000342a:	00000097          	auipc	ra,0x0
    8000342e:	9ce080e7          	jalr	-1586(ra) # 80002df8 <idup>
    80003432:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003434:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003438:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000343a:	4b85                	li	s7,1
    8000343c:	a875                	j	800034f8 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000343e:	4585                	li	a1,1
    80003440:	4505                	li	a0,1
    80003442:	fffff097          	auipc	ra,0xfffff
    80003446:	6b4080e7          	jalr	1716(ra) # 80002af6 <iget>
    8000344a:	8a2a                	mv	s4,a0
    8000344c:	b7e5                	j	80003434 <namex+0x42>
      iunlockput(ip);
    8000344e:	8552                	mv	a0,s4
    80003450:	00000097          	auipc	ra,0x0
    80003454:	c4c080e7          	jalr	-948(ra) # 8000309c <iunlockput>
      return 0;
    80003458:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000345a:	8552                	mv	a0,s4
    8000345c:	60e6                	ld	ra,88(sp)
    8000345e:	6446                	ld	s0,80(sp)
    80003460:	64a6                	ld	s1,72(sp)
    80003462:	6906                	ld	s2,64(sp)
    80003464:	79e2                	ld	s3,56(sp)
    80003466:	7a42                	ld	s4,48(sp)
    80003468:	7aa2                	ld	s5,40(sp)
    8000346a:	7b02                	ld	s6,32(sp)
    8000346c:	6be2                	ld	s7,24(sp)
    8000346e:	6c42                	ld	s8,16(sp)
    80003470:	6ca2                	ld	s9,8(sp)
    80003472:	6125                	add	sp,sp,96
    80003474:	8082                	ret
      iunlock(ip);
    80003476:	8552                	mv	a0,s4
    80003478:	00000097          	auipc	ra,0x0
    8000347c:	a84080e7          	jalr	-1404(ra) # 80002efc <iunlock>
      return ip;
    80003480:	bfe9                	j	8000345a <namex+0x68>
      iunlockput(ip);
    80003482:	8552                	mv	a0,s4
    80003484:	00000097          	auipc	ra,0x0
    80003488:	c18080e7          	jalr	-1000(ra) # 8000309c <iunlockput>
      return 0;
    8000348c:	8a4e                	mv	s4,s3
    8000348e:	b7f1                	j	8000345a <namex+0x68>
  len = path - s;
    80003490:	40998633          	sub	a2,s3,s1
    80003494:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003498:	099c5863          	bge	s8,s9,80003528 <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000349c:	4639                	li	a2,14
    8000349e:	85a6                	mv	a1,s1
    800034a0:	8556                	mv	a0,s5
    800034a2:	ffffd097          	auipc	ra,0xffffd
    800034a6:	d34080e7          	jalr	-716(ra) # 800001d6 <memmove>
    800034aa:	84ce                	mv	s1,s3
  while(*path == '/')
    800034ac:	0004c783          	lbu	a5,0(s1)
    800034b0:	01279763          	bne	a5,s2,800034be <namex+0xcc>
    path++;
    800034b4:	0485                	add	s1,s1,1
  while(*path == '/')
    800034b6:	0004c783          	lbu	a5,0(s1)
    800034ba:	ff278de3          	beq	a5,s2,800034b4 <namex+0xc2>
    ilock(ip);
    800034be:	8552                	mv	a0,s4
    800034c0:	00000097          	auipc	ra,0x0
    800034c4:	976080e7          	jalr	-1674(ra) # 80002e36 <ilock>
    if(ip->type != T_DIR){
    800034c8:	044a1783          	lh	a5,68(s4)
    800034cc:	f97791e3          	bne	a5,s7,8000344e <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800034d0:	000b0563          	beqz	s6,800034da <namex+0xe8>
    800034d4:	0004c783          	lbu	a5,0(s1)
    800034d8:	dfd9                	beqz	a5,80003476 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800034da:	4601                	li	a2,0
    800034dc:	85d6                	mv	a1,s5
    800034de:	8552                	mv	a0,s4
    800034e0:	00000097          	auipc	ra,0x0
    800034e4:	e62080e7          	jalr	-414(ra) # 80003342 <dirlookup>
    800034e8:	89aa                	mv	s3,a0
    800034ea:	dd41                	beqz	a0,80003482 <namex+0x90>
    iunlockput(ip);
    800034ec:	8552                	mv	a0,s4
    800034ee:	00000097          	auipc	ra,0x0
    800034f2:	bae080e7          	jalr	-1106(ra) # 8000309c <iunlockput>
    ip = next;
    800034f6:	8a4e                	mv	s4,s3
  while(*path == '/')
    800034f8:	0004c783          	lbu	a5,0(s1)
    800034fc:	01279763          	bne	a5,s2,8000350a <namex+0x118>
    path++;
    80003500:	0485                	add	s1,s1,1
  while(*path == '/')
    80003502:	0004c783          	lbu	a5,0(s1)
    80003506:	ff278de3          	beq	a5,s2,80003500 <namex+0x10e>
  if(*path == 0)
    8000350a:	cb9d                	beqz	a5,80003540 <namex+0x14e>
  while(*path != '/' && *path != 0)
    8000350c:	0004c783          	lbu	a5,0(s1)
    80003510:	89a6                	mv	s3,s1
  len = path - s;
    80003512:	4c81                	li	s9,0
    80003514:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003516:	01278963          	beq	a5,s2,80003528 <namex+0x136>
    8000351a:	dbbd                	beqz	a5,80003490 <namex+0x9e>
    path++;
    8000351c:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    8000351e:	0009c783          	lbu	a5,0(s3)
    80003522:	ff279ce3          	bne	a5,s2,8000351a <namex+0x128>
    80003526:	b7ad                	j	80003490 <namex+0x9e>
    memmove(name, s, len);
    80003528:	2601                	sext.w	a2,a2
    8000352a:	85a6                	mv	a1,s1
    8000352c:	8556                	mv	a0,s5
    8000352e:	ffffd097          	auipc	ra,0xffffd
    80003532:	ca8080e7          	jalr	-856(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003536:	9cd6                	add	s9,s9,s5
    80003538:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000353c:	84ce                	mv	s1,s3
    8000353e:	b7bd                	j	800034ac <namex+0xba>
  if(nameiparent){
    80003540:	f00b0de3          	beqz	s6,8000345a <namex+0x68>
    iput(ip);
    80003544:	8552                	mv	a0,s4
    80003546:	00000097          	auipc	ra,0x0
    8000354a:	aae080e7          	jalr	-1362(ra) # 80002ff4 <iput>
    return 0;
    8000354e:	4a01                	li	s4,0
    80003550:	b729                	j	8000345a <namex+0x68>

0000000080003552 <dirlink>:
{
    80003552:	7139                	add	sp,sp,-64
    80003554:	fc06                	sd	ra,56(sp)
    80003556:	f822                	sd	s0,48(sp)
    80003558:	f04a                	sd	s2,32(sp)
    8000355a:	ec4e                	sd	s3,24(sp)
    8000355c:	e852                	sd	s4,16(sp)
    8000355e:	0080                	add	s0,sp,64
    80003560:	892a                	mv	s2,a0
    80003562:	8a2e                	mv	s4,a1
    80003564:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003566:	4601                	li	a2,0
    80003568:	00000097          	auipc	ra,0x0
    8000356c:	dda080e7          	jalr	-550(ra) # 80003342 <dirlookup>
    80003570:	ed25                	bnez	a0,800035e8 <dirlink+0x96>
    80003572:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003574:	04c92483          	lw	s1,76(s2)
    80003578:	c49d                	beqz	s1,800035a6 <dirlink+0x54>
    8000357a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000357c:	4741                	li	a4,16
    8000357e:	86a6                	mv	a3,s1
    80003580:	fc040613          	add	a2,s0,-64
    80003584:	4581                	li	a1,0
    80003586:	854a                	mv	a0,s2
    80003588:	00000097          	auipc	ra,0x0
    8000358c:	b66080e7          	jalr	-1178(ra) # 800030ee <readi>
    80003590:	47c1                	li	a5,16
    80003592:	06f51163          	bne	a0,a5,800035f4 <dirlink+0xa2>
    if(de.inum == 0)
    80003596:	fc045783          	lhu	a5,-64(s0)
    8000359a:	c791                	beqz	a5,800035a6 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000359c:	24c1                	addw	s1,s1,16
    8000359e:	04c92783          	lw	a5,76(s2)
    800035a2:	fcf4ede3          	bltu	s1,a5,8000357c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800035a6:	4639                	li	a2,14
    800035a8:	85d2                	mv	a1,s4
    800035aa:	fc240513          	add	a0,s0,-62
    800035ae:	ffffd097          	auipc	ra,0xffffd
    800035b2:	cd2080e7          	jalr	-814(ra) # 80000280 <strncpy>
  de.inum = inum;
    800035b6:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035ba:	4741                	li	a4,16
    800035bc:	86a6                	mv	a3,s1
    800035be:	fc040613          	add	a2,s0,-64
    800035c2:	4581                	li	a1,0
    800035c4:	854a                	mv	a0,s2
    800035c6:	00000097          	auipc	ra,0x0
    800035ca:	c38080e7          	jalr	-968(ra) # 800031fe <writei>
    800035ce:	1541                	add	a0,a0,-16
    800035d0:	00a03533          	snez	a0,a0
    800035d4:	40a00533          	neg	a0,a0
    800035d8:	74a2                	ld	s1,40(sp)
}
    800035da:	70e2                	ld	ra,56(sp)
    800035dc:	7442                	ld	s0,48(sp)
    800035de:	7902                	ld	s2,32(sp)
    800035e0:	69e2                	ld	s3,24(sp)
    800035e2:	6a42                	ld	s4,16(sp)
    800035e4:	6121                	add	sp,sp,64
    800035e6:	8082                	ret
    iput(ip);
    800035e8:	00000097          	auipc	ra,0x0
    800035ec:	a0c080e7          	jalr	-1524(ra) # 80002ff4 <iput>
    return -1;
    800035f0:	557d                	li	a0,-1
    800035f2:	b7e5                	j	800035da <dirlink+0x88>
      panic("dirlink read");
    800035f4:	00005517          	auipc	a0,0x5
    800035f8:	fac50513          	add	a0,a0,-84 # 800085a0 <etext+0x5a0>
    800035fc:	00003097          	auipc	ra,0x3
    80003600:	a26080e7          	jalr	-1498(ra) # 80006022 <panic>

0000000080003604 <namei>:

struct inode*
namei(char *path)
{
    80003604:	1101                	add	sp,sp,-32
    80003606:	ec06                	sd	ra,24(sp)
    80003608:	e822                	sd	s0,16(sp)
    8000360a:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000360c:	fe040613          	add	a2,s0,-32
    80003610:	4581                	li	a1,0
    80003612:	00000097          	auipc	ra,0x0
    80003616:	de0080e7          	jalr	-544(ra) # 800033f2 <namex>
}
    8000361a:	60e2                	ld	ra,24(sp)
    8000361c:	6442                	ld	s0,16(sp)
    8000361e:	6105                	add	sp,sp,32
    80003620:	8082                	ret

0000000080003622 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003622:	1141                	add	sp,sp,-16
    80003624:	e406                	sd	ra,8(sp)
    80003626:	e022                	sd	s0,0(sp)
    80003628:	0800                	add	s0,sp,16
    8000362a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000362c:	4585                	li	a1,1
    8000362e:	00000097          	auipc	ra,0x0
    80003632:	dc4080e7          	jalr	-572(ra) # 800033f2 <namex>
}
    80003636:	60a2                	ld	ra,8(sp)
    80003638:	6402                	ld	s0,0(sp)
    8000363a:	0141                	add	sp,sp,16
    8000363c:	8082                	ret

000000008000363e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000363e:	1101                	add	sp,sp,-32
    80003640:	ec06                	sd	ra,24(sp)
    80003642:	e822                	sd	s0,16(sp)
    80003644:	e426                	sd	s1,8(sp)
    80003646:	e04a                	sd	s2,0(sp)
    80003648:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000364a:	00018917          	auipc	s2,0x18
    8000364e:	d7690913          	add	s2,s2,-650 # 8001b3c0 <log>
    80003652:	01892583          	lw	a1,24(s2)
    80003656:	02892503          	lw	a0,40(s2)
    8000365a:	fffff097          	auipc	ra,0xfffff
    8000365e:	fa8080e7          	jalr	-88(ra) # 80002602 <bread>
    80003662:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003664:	02c92603          	lw	a2,44(s2)
    80003668:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000366a:	00c05f63          	blez	a2,80003688 <write_head+0x4a>
    8000366e:	00018717          	auipc	a4,0x18
    80003672:	d8270713          	add	a4,a4,-638 # 8001b3f0 <log+0x30>
    80003676:	87aa                	mv	a5,a0
    80003678:	060a                	sll	a2,a2,0x2
    8000367a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000367c:	4314                	lw	a3,0(a4)
    8000367e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003680:	0711                	add	a4,a4,4
    80003682:	0791                	add	a5,a5,4
    80003684:	fec79ce3          	bne	a5,a2,8000367c <write_head+0x3e>
  }
  bwrite(buf);
    80003688:	8526                	mv	a0,s1
    8000368a:	fffff097          	auipc	ra,0xfffff
    8000368e:	06a080e7          	jalr	106(ra) # 800026f4 <bwrite>
  brelse(buf);
    80003692:	8526                	mv	a0,s1
    80003694:	fffff097          	auipc	ra,0xfffff
    80003698:	09e080e7          	jalr	158(ra) # 80002732 <brelse>
}
    8000369c:	60e2                	ld	ra,24(sp)
    8000369e:	6442                	ld	s0,16(sp)
    800036a0:	64a2                	ld	s1,8(sp)
    800036a2:	6902                	ld	s2,0(sp)
    800036a4:	6105                	add	sp,sp,32
    800036a6:	8082                	ret

00000000800036a8 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800036a8:	00018797          	auipc	a5,0x18
    800036ac:	d447a783          	lw	a5,-700(a5) # 8001b3ec <log+0x2c>
    800036b0:	0af05d63          	blez	a5,8000376a <install_trans+0xc2>
{
    800036b4:	7139                	add	sp,sp,-64
    800036b6:	fc06                	sd	ra,56(sp)
    800036b8:	f822                	sd	s0,48(sp)
    800036ba:	f426                	sd	s1,40(sp)
    800036bc:	f04a                	sd	s2,32(sp)
    800036be:	ec4e                	sd	s3,24(sp)
    800036c0:	e852                	sd	s4,16(sp)
    800036c2:	e456                	sd	s5,8(sp)
    800036c4:	e05a                	sd	s6,0(sp)
    800036c6:	0080                	add	s0,sp,64
    800036c8:	8b2a                	mv	s6,a0
    800036ca:	00018a97          	auipc	s5,0x18
    800036ce:	d26a8a93          	add	s5,s5,-730 # 8001b3f0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036d2:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036d4:	00018997          	auipc	s3,0x18
    800036d8:	cec98993          	add	s3,s3,-788 # 8001b3c0 <log>
    800036dc:	a00d                	j	800036fe <install_trans+0x56>
    brelse(lbuf);
    800036de:	854a                	mv	a0,s2
    800036e0:	fffff097          	auipc	ra,0xfffff
    800036e4:	052080e7          	jalr	82(ra) # 80002732 <brelse>
    brelse(dbuf);
    800036e8:	8526                	mv	a0,s1
    800036ea:	fffff097          	auipc	ra,0xfffff
    800036ee:	048080e7          	jalr	72(ra) # 80002732 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036f2:	2a05                	addw	s4,s4,1
    800036f4:	0a91                	add	s5,s5,4
    800036f6:	02c9a783          	lw	a5,44(s3)
    800036fa:	04fa5e63          	bge	s4,a5,80003756 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036fe:	0189a583          	lw	a1,24(s3)
    80003702:	014585bb          	addw	a1,a1,s4
    80003706:	2585                	addw	a1,a1,1
    80003708:	0289a503          	lw	a0,40(s3)
    8000370c:	fffff097          	auipc	ra,0xfffff
    80003710:	ef6080e7          	jalr	-266(ra) # 80002602 <bread>
    80003714:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003716:	000aa583          	lw	a1,0(s5)
    8000371a:	0289a503          	lw	a0,40(s3)
    8000371e:	fffff097          	auipc	ra,0xfffff
    80003722:	ee4080e7          	jalr	-284(ra) # 80002602 <bread>
    80003726:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003728:	40000613          	li	a2,1024
    8000372c:	05890593          	add	a1,s2,88
    80003730:	05850513          	add	a0,a0,88
    80003734:	ffffd097          	auipc	ra,0xffffd
    80003738:	aa2080e7          	jalr	-1374(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000373c:	8526                	mv	a0,s1
    8000373e:	fffff097          	auipc	ra,0xfffff
    80003742:	fb6080e7          	jalr	-74(ra) # 800026f4 <bwrite>
    if(recovering == 0)
    80003746:	f80b1ce3          	bnez	s6,800036de <install_trans+0x36>
      bunpin(dbuf);
    8000374a:	8526                	mv	a0,s1
    8000374c:	fffff097          	auipc	ra,0xfffff
    80003750:	0be080e7          	jalr	190(ra) # 8000280a <bunpin>
    80003754:	b769                	j	800036de <install_trans+0x36>
}
    80003756:	70e2                	ld	ra,56(sp)
    80003758:	7442                	ld	s0,48(sp)
    8000375a:	74a2                	ld	s1,40(sp)
    8000375c:	7902                	ld	s2,32(sp)
    8000375e:	69e2                	ld	s3,24(sp)
    80003760:	6a42                	ld	s4,16(sp)
    80003762:	6aa2                	ld	s5,8(sp)
    80003764:	6b02                	ld	s6,0(sp)
    80003766:	6121                	add	sp,sp,64
    80003768:	8082                	ret
    8000376a:	8082                	ret

000000008000376c <initlog>:
{
    8000376c:	7179                	add	sp,sp,-48
    8000376e:	f406                	sd	ra,40(sp)
    80003770:	f022                	sd	s0,32(sp)
    80003772:	ec26                	sd	s1,24(sp)
    80003774:	e84a                	sd	s2,16(sp)
    80003776:	e44e                	sd	s3,8(sp)
    80003778:	1800                	add	s0,sp,48
    8000377a:	892a                	mv	s2,a0
    8000377c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000377e:	00018497          	auipc	s1,0x18
    80003782:	c4248493          	add	s1,s1,-958 # 8001b3c0 <log>
    80003786:	00005597          	auipc	a1,0x5
    8000378a:	e2a58593          	add	a1,a1,-470 # 800085b0 <etext+0x5b0>
    8000378e:	8526                	mv	a0,s1
    80003790:	00003097          	auipc	ra,0x3
    80003794:	d7c080e7          	jalr	-644(ra) # 8000650c <initlock>
  log.start = sb->logstart;
    80003798:	0149a583          	lw	a1,20(s3)
    8000379c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000379e:	0109a783          	lw	a5,16(s3)
    800037a2:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800037a4:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800037a8:	854a                	mv	a0,s2
    800037aa:	fffff097          	auipc	ra,0xfffff
    800037ae:	e58080e7          	jalr	-424(ra) # 80002602 <bread>
  log.lh.n = lh->n;
    800037b2:	4d30                	lw	a2,88(a0)
    800037b4:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800037b6:	00c05f63          	blez	a2,800037d4 <initlog+0x68>
    800037ba:	87aa                	mv	a5,a0
    800037bc:	00018717          	auipc	a4,0x18
    800037c0:	c3470713          	add	a4,a4,-972 # 8001b3f0 <log+0x30>
    800037c4:	060a                	sll	a2,a2,0x2
    800037c6:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800037c8:	4ff4                	lw	a3,92(a5)
    800037ca:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800037cc:	0791                	add	a5,a5,4
    800037ce:	0711                	add	a4,a4,4
    800037d0:	fec79ce3          	bne	a5,a2,800037c8 <initlog+0x5c>
  brelse(buf);
    800037d4:	fffff097          	auipc	ra,0xfffff
    800037d8:	f5e080e7          	jalr	-162(ra) # 80002732 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800037dc:	4505                	li	a0,1
    800037de:	00000097          	auipc	ra,0x0
    800037e2:	eca080e7          	jalr	-310(ra) # 800036a8 <install_trans>
  log.lh.n = 0;
    800037e6:	00018797          	auipc	a5,0x18
    800037ea:	c007a323          	sw	zero,-1018(a5) # 8001b3ec <log+0x2c>
  write_head(); // clear the log
    800037ee:	00000097          	auipc	ra,0x0
    800037f2:	e50080e7          	jalr	-432(ra) # 8000363e <write_head>
}
    800037f6:	70a2                	ld	ra,40(sp)
    800037f8:	7402                	ld	s0,32(sp)
    800037fa:	64e2                	ld	s1,24(sp)
    800037fc:	6942                	ld	s2,16(sp)
    800037fe:	69a2                	ld	s3,8(sp)
    80003800:	6145                	add	sp,sp,48
    80003802:	8082                	ret

0000000080003804 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003804:	1101                	add	sp,sp,-32
    80003806:	ec06                	sd	ra,24(sp)
    80003808:	e822                	sd	s0,16(sp)
    8000380a:	e426                	sd	s1,8(sp)
    8000380c:	e04a                	sd	s2,0(sp)
    8000380e:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80003810:	00018517          	auipc	a0,0x18
    80003814:	bb050513          	add	a0,a0,-1104 # 8001b3c0 <log>
    80003818:	00003097          	auipc	ra,0x3
    8000381c:	d84080e7          	jalr	-636(ra) # 8000659c <acquire>
  while(1){
    if(log.committing){
    80003820:	00018497          	auipc	s1,0x18
    80003824:	ba048493          	add	s1,s1,-1120 # 8001b3c0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003828:	4979                	li	s2,30
    8000382a:	a039                	j	80003838 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000382c:	85a6                	mv	a1,s1
    8000382e:	8526                	mv	a0,s1
    80003830:	ffffe097          	auipc	ra,0xffffe
    80003834:	ef0080e7          	jalr	-272(ra) # 80001720 <sleep>
    if(log.committing){
    80003838:	50dc                	lw	a5,36(s1)
    8000383a:	fbed                	bnez	a5,8000382c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000383c:	5098                	lw	a4,32(s1)
    8000383e:	2705                	addw	a4,a4,1
    80003840:	0027179b          	sllw	a5,a4,0x2
    80003844:	9fb9                	addw	a5,a5,a4
    80003846:	0017979b          	sllw	a5,a5,0x1
    8000384a:	54d4                	lw	a3,44(s1)
    8000384c:	9fb5                	addw	a5,a5,a3
    8000384e:	00f95963          	bge	s2,a5,80003860 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003852:	85a6                	mv	a1,s1
    80003854:	8526                	mv	a0,s1
    80003856:	ffffe097          	auipc	ra,0xffffe
    8000385a:	eca080e7          	jalr	-310(ra) # 80001720 <sleep>
    8000385e:	bfe9                	j	80003838 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003860:	00018517          	auipc	a0,0x18
    80003864:	b6050513          	add	a0,a0,-1184 # 8001b3c0 <log>
    80003868:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000386a:	00003097          	auipc	ra,0x3
    8000386e:	de6080e7          	jalr	-538(ra) # 80006650 <release>
      break;
    }
  }
}
    80003872:	60e2                	ld	ra,24(sp)
    80003874:	6442                	ld	s0,16(sp)
    80003876:	64a2                	ld	s1,8(sp)
    80003878:	6902                	ld	s2,0(sp)
    8000387a:	6105                	add	sp,sp,32
    8000387c:	8082                	ret

000000008000387e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000387e:	7139                	add	sp,sp,-64
    80003880:	fc06                	sd	ra,56(sp)
    80003882:	f822                	sd	s0,48(sp)
    80003884:	f426                	sd	s1,40(sp)
    80003886:	f04a                	sd	s2,32(sp)
    80003888:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000388a:	00018497          	auipc	s1,0x18
    8000388e:	b3648493          	add	s1,s1,-1226 # 8001b3c0 <log>
    80003892:	8526                	mv	a0,s1
    80003894:	00003097          	auipc	ra,0x3
    80003898:	d08080e7          	jalr	-760(ra) # 8000659c <acquire>
  log.outstanding -= 1;
    8000389c:	509c                	lw	a5,32(s1)
    8000389e:	37fd                	addw	a5,a5,-1
    800038a0:	0007891b          	sext.w	s2,a5
    800038a4:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800038a6:	50dc                	lw	a5,36(s1)
    800038a8:	e7b9                	bnez	a5,800038f6 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800038aa:	06091163          	bnez	s2,8000390c <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800038ae:	00018497          	auipc	s1,0x18
    800038b2:	b1248493          	add	s1,s1,-1262 # 8001b3c0 <log>
    800038b6:	4785                	li	a5,1
    800038b8:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800038ba:	8526                	mv	a0,s1
    800038bc:	00003097          	auipc	ra,0x3
    800038c0:	d94080e7          	jalr	-620(ra) # 80006650 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800038c4:	54dc                	lw	a5,44(s1)
    800038c6:	06f04763          	bgtz	a5,80003934 <end_op+0xb6>
    acquire(&log.lock);
    800038ca:	00018497          	auipc	s1,0x18
    800038ce:	af648493          	add	s1,s1,-1290 # 8001b3c0 <log>
    800038d2:	8526                	mv	a0,s1
    800038d4:	00003097          	auipc	ra,0x3
    800038d8:	cc8080e7          	jalr	-824(ra) # 8000659c <acquire>
    log.committing = 0;
    800038dc:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800038e0:	8526                	mv	a0,s1
    800038e2:	ffffe097          	auipc	ra,0xffffe
    800038e6:	ea2080e7          	jalr	-350(ra) # 80001784 <wakeup>
    release(&log.lock);
    800038ea:	8526                	mv	a0,s1
    800038ec:	00003097          	auipc	ra,0x3
    800038f0:	d64080e7          	jalr	-668(ra) # 80006650 <release>
}
    800038f4:	a815                	j	80003928 <end_op+0xaa>
    800038f6:	ec4e                	sd	s3,24(sp)
    800038f8:	e852                	sd	s4,16(sp)
    800038fa:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800038fc:	00005517          	auipc	a0,0x5
    80003900:	cbc50513          	add	a0,a0,-836 # 800085b8 <etext+0x5b8>
    80003904:	00002097          	auipc	ra,0x2
    80003908:	71e080e7          	jalr	1822(ra) # 80006022 <panic>
    wakeup(&log);
    8000390c:	00018497          	auipc	s1,0x18
    80003910:	ab448493          	add	s1,s1,-1356 # 8001b3c0 <log>
    80003914:	8526                	mv	a0,s1
    80003916:	ffffe097          	auipc	ra,0xffffe
    8000391a:	e6e080e7          	jalr	-402(ra) # 80001784 <wakeup>
  release(&log.lock);
    8000391e:	8526                	mv	a0,s1
    80003920:	00003097          	auipc	ra,0x3
    80003924:	d30080e7          	jalr	-720(ra) # 80006650 <release>
}
    80003928:	70e2                	ld	ra,56(sp)
    8000392a:	7442                	ld	s0,48(sp)
    8000392c:	74a2                	ld	s1,40(sp)
    8000392e:	7902                	ld	s2,32(sp)
    80003930:	6121                	add	sp,sp,64
    80003932:	8082                	ret
    80003934:	ec4e                	sd	s3,24(sp)
    80003936:	e852                	sd	s4,16(sp)
    80003938:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000393a:	00018a97          	auipc	s5,0x18
    8000393e:	ab6a8a93          	add	s5,s5,-1354 # 8001b3f0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003942:	00018a17          	auipc	s4,0x18
    80003946:	a7ea0a13          	add	s4,s4,-1410 # 8001b3c0 <log>
    8000394a:	018a2583          	lw	a1,24(s4)
    8000394e:	012585bb          	addw	a1,a1,s2
    80003952:	2585                	addw	a1,a1,1
    80003954:	028a2503          	lw	a0,40(s4)
    80003958:	fffff097          	auipc	ra,0xfffff
    8000395c:	caa080e7          	jalr	-854(ra) # 80002602 <bread>
    80003960:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003962:	000aa583          	lw	a1,0(s5)
    80003966:	028a2503          	lw	a0,40(s4)
    8000396a:	fffff097          	auipc	ra,0xfffff
    8000396e:	c98080e7          	jalr	-872(ra) # 80002602 <bread>
    80003972:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003974:	40000613          	li	a2,1024
    80003978:	05850593          	add	a1,a0,88
    8000397c:	05848513          	add	a0,s1,88
    80003980:	ffffd097          	auipc	ra,0xffffd
    80003984:	856080e7          	jalr	-1962(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003988:	8526                	mv	a0,s1
    8000398a:	fffff097          	auipc	ra,0xfffff
    8000398e:	d6a080e7          	jalr	-662(ra) # 800026f4 <bwrite>
    brelse(from);
    80003992:	854e                	mv	a0,s3
    80003994:	fffff097          	auipc	ra,0xfffff
    80003998:	d9e080e7          	jalr	-610(ra) # 80002732 <brelse>
    brelse(to);
    8000399c:	8526                	mv	a0,s1
    8000399e:	fffff097          	auipc	ra,0xfffff
    800039a2:	d94080e7          	jalr	-620(ra) # 80002732 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800039a6:	2905                	addw	s2,s2,1
    800039a8:	0a91                	add	s5,s5,4
    800039aa:	02ca2783          	lw	a5,44(s4)
    800039ae:	f8f94ee3          	blt	s2,a5,8000394a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800039b2:	00000097          	auipc	ra,0x0
    800039b6:	c8c080e7          	jalr	-884(ra) # 8000363e <write_head>
    install_trans(0); // Now install writes to home locations
    800039ba:	4501                	li	a0,0
    800039bc:	00000097          	auipc	ra,0x0
    800039c0:	cec080e7          	jalr	-788(ra) # 800036a8 <install_trans>
    log.lh.n = 0;
    800039c4:	00018797          	auipc	a5,0x18
    800039c8:	a207a423          	sw	zero,-1496(a5) # 8001b3ec <log+0x2c>
    write_head();    // Erase the transaction from the log
    800039cc:	00000097          	auipc	ra,0x0
    800039d0:	c72080e7          	jalr	-910(ra) # 8000363e <write_head>
    800039d4:	69e2                	ld	s3,24(sp)
    800039d6:	6a42                	ld	s4,16(sp)
    800039d8:	6aa2                	ld	s5,8(sp)
    800039da:	bdc5                	j	800038ca <end_op+0x4c>

00000000800039dc <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800039dc:	1101                	add	sp,sp,-32
    800039de:	ec06                	sd	ra,24(sp)
    800039e0:	e822                	sd	s0,16(sp)
    800039e2:	e426                	sd	s1,8(sp)
    800039e4:	e04a                	sd	s2,0(sp)
    800039e6:	1000                	add	s0,sp,32
    800039e8:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800039ea:	00018917          	auipc	s2,0x18
    800039ee:	9d690913          	add	s2,s2,-1578 # 8001b3c0 <log>
    800039f2:	854a                	mv	a0,s2
    800039f4:	00003097          	auipc	ra,0x3
    800039f8:	ba8080e7          	jalr	-1112(ra) # 8000659c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800039fc:	02c92603          	lw	a2,44(s2)
    80003a00:	47f5                	li	a5,29
    80003a02:	06c7c563          	blt	a5,a2,80003a6c <log_write+0x90>
    80003a06:	00018797          	auipc	a5,0x18
    80003a0a:	9d67a783          	lw	a5,-1578(a5) # 8001b3dc <log+0x1c>
    80003a0e:	37fd                	addw	a5,a5,-1
    80003a10:	04f65e63          	bge	a2,a5,80003a6c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003a14:	00018797          	auipc	a5,0x18
    80003a18:	9cc7a783          	lw	a5,-1588(a5) # 8001b3e0 <log+0x20>
    80003a1c:	06f05063          	blez	a5,80003a7c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003a20:	4781                	li	a5,0
    80003a22:	06c05563          	blez	a2,80003a8c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a26:	44cc                	lw	a1,12(s1)
    80003a28:	00018717          	auipc	a4,0x18
    80003a2c:	9c870713          	add	a4,a4,-1592 # 8001b3f0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003a30:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a32:	4314                	lw	a3,0(a4)
    80003a34:	04b68c63          	beq	a3,a1,80003a8c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003a38:	2785                	addw	a5,a5,1
    80003a3a:	0711                	add	a4,a4,4
    80003a3c:	fef61be3          	bne	a2,a5,80003a32 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003a40:	0621                	add	a2,a2,8
    80003a42:	060a                	sll	a2,a2,0x2
    80003a44:	00018797          	auipc	a5,0x18
    80003a48:	97c78793          	add	a5,a5,-1668 # 8001b3c0 <log>
    80003a4c:	97b2                	add	a5,a5,a2
    80003a4e:	44d8                	lw	a4,12(s1)
    80003a50:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003a52:	8526                	mv	a0,s1
    80003a54:	fffff097          	auipc	ra,0xfffff
    80003a58:	d7a080e7          	jalr	-646(ra) # 800027ce <bpin>
    log.lh.n++;
    80003a5c:	00018717          	auipc	a4,0x18
    80003a60:	96470713          	add	a4,a4,-1692 # 8001b3c0 <log>
    80003a64:	575c                	lw	a5,44(a4)
    80003a66:	2785                	addw	a5,a5,1
    80003a68:	d75c                	sw	a5,44(a4)
    80003a6a:	a82d                	j	80003aa4 <log_write+0xc8>
    panic("too big a transaction");
    80003a6c:	00005517          	auipc	a0,0x5
    80003a70:	b5c50513          	add	a0,a0,-1188 # 800085c8 <etext+0x5c8>
    80003a74:	00002097          	auipc	ra,0x2
    80003a78:	5ae080e7          	jalr	1454(ra) # 80006022 <panic>
    panic("log_write outside of trans");
    80003a7c:	00005517          	auipc	a0,0x5
    80003a80:	b6450513          	add	a0,a0,-1180 # 800085e0 <etext+0x5e0>
    80003a84:	00002097          	auipc	ra,0x2
    80003a88:	59e080e7          	jalr	1438(ra) # 80006022 <panic>
  log.lh.block[i] = b->blockno;
    80003a8c:	00878693          	add	a3,a5,8
    80003a90:	068a                	sll	a3,a3,0x2
    80003a92:	00018717          	auipc	a4,0x18
    80003a96:	92e70713          	add	a4,a4,-1746 # 8001b3c0 <log>
    80003a9a:	9736                	add	a4,a4,a3
    80003a9c:	44d4                	lw	a3,12(s1)
    80003a9e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003aa0:	faf609e3          	beq	a2,a5,80003a52 <log_write+0x76>
  }
  release(&log.lock);
    80003aa4:	00018517          	auipc	a0,0x18
    80003aa8:	91c50513          	add	a0,a0,-1764 # 8001b3c0 <log>
    80003aac:	00003097          	auipc	ra,0x3
    80003ab0:	ba4080e7          	jalr	-1116(ra) # 80006650 <release>
}
    80003ab4:	60e2                	ld	ra,24(sp)
    80003ab6:	6442                	ld	s0,16(sp)
    80003ab8:	64a2                	ld	s1,8(sp)
    80003aba:	6902                	ld	s2,0(sp)
    80003abc:	6105                	add	sp,sp,32
    80003abe:	8082                	ret

0000000080003ac0 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003ac0:	1101                	add	sp,sp,-32
    80003ac2:	ec06                	sd	ra,24(sp)
    80003ac4:	e822                	sd	s0,16(sp)
    80003ac6:	e426                	sd	s1,8(sp)
    80003ac8:	e04a                	sd	s2,0(sp)
    80003aca:	1000                	add	s0,sp,32
    80003acc:	84aa                	mv	s1,a0
    80003ace:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003ad0:	00005597          	auipc	a1,0x5
    80003ad4:	b3058593          	add	a1,a1,-1232 # 80008600 <etext+0x600>
    80003ad8:	0521                	add	a0,a0,8
    80003ada:	00003097          	auipc	ra,0x3
    80003ade:	a32080e7          	jalr	-1486(ra) # 8000650c <initlock>
  lk->name = name;
    80003ae2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003ae6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003aea:	0204a423          	sw	zero,40(s1)
}
    80003aee:	60e2                	ld	ra,24(sp)
    80003af0:	6442                	ld	s0,16(sp)
    80003af2:	64a2                	ld	s1,8(sp)
    80003af4:	6902                	ld	s2,0(sp)
    80003af6:	6105                	add	sp,sp,32
    80003af8:	8082                	ret

0000000080003afa <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003afa:	1101                	add	sp,sp,-32
    80003afc:	ec06                	sd	ra,24(sp)
    80003afe:	e822                	sd	s0,16(sp)
    80003b00:	e426                	sd	s1,8(sp)
    80003b02:	e04a                	sd	s2,0(sp)
    80003b04:	1000                	add	s0,sp,32
    80003b06:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b08:	00850913          	add	s2,a0,8
    80003b0c:	854a                	mv	a0,s2
    80003b0e:	00003097          	auipc	ra,0x3
    80003b12:	a8e080e7          	jalr	-1394(ra) # 8000659c <acquire>
  while (lk->locked) {
    80003b16:	409c                	lw	a5,0(s1)
    80003b18:	cb89                	beqz	a5,80003b2a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003b1a:	85ca                	mv	a1,s2
    80003b1c:	8526                	mv	a0,s1
    80003b1e:	ffffe097          	auipc	ra,0xffffe
    80003b22:	c02080e7          	jalr	-1022(ra) # 80001720 <sleep>
  while (lk->locked) {
    80003b26:	409c                	lw	a5,0(s1)
    80003b28:	fbed                	bnez	a5,80003b1a <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003b2a:	4785                	li	a5,1
    80003b2c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003b2e:	ffffd097          	auipc	ra,0xffffd
    80003b32:	4c0080e7          	jalr	1216(ra) # 80000fee <myproc>
    80003b36:	591c                	lw	a5,48(a0)
    80003b38:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003b3a:	854a                	mv	a0,s2
    80003b3c:	00003097          	auipc	ra,0x3
    80003b40:	b14080e7          	jalr	-1260(ra) # 80006650 <release>
}
    80003b44:	60e2                	ld	ra,24(sp)
    80003b46:	6442                	ld	s0,16(sp)
    80003b48:	64a2                	ld	s1,8(sp)
    80003b4a:	6902                	ld	s2,0(sp)
    80003b4c:	6105                	add	sp,sp,32
    80003b4e:	8082                	ret

0000000080003b50 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003b50:	1101                	add	sp,sp,-32
    80003b52:	ec06                	sd	ra,24(sp)
    80003b54:	e822                	sd	s0,16(sp)
    80003b56:	e426                	sd	s1,8(sp)
    80003b58:	e04a                	sd	s2,0(sp)
    80003b5a:	1000                	add	s0,sp,32
    80003b5c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b5e:	00850913          	add	s2,a0,8
    80003b62:	854a                	mv	a0,s2
    80003b64:	00003097          	auipc	ra,0x3
    80003b68:	a38080e7          	jalr	-1480(ra) # 8000659c <acquire>
  lk->locked = 0;
    80003b6c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b70:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003b74:	8526                	mv	a0,s1
    80003b76:	ffffe097          	auipc	ra,0xffffe
    80003b7a:	c0e080e7          	jalr	-1010(ra) # 80001784 <wakeup>
  release(&lk->lk);
    80003b7e:	854a                	mv	a0,s2
    80003b80:	00003097          	auipc	ra,0x3
    80003b84:	ad0080e7          	jalr	-1328(ra) # 80006650 <release>
}
    80003b88:	60e2                	ld	ra,24(sp)
    80003b8a:	6442                	ld	s0,16(sp)
    80003b8c:	64a2                	ld	s1,8(sp)
    80003b8e:	6902                	ld	s2,0(sp)
    80003b90:	6105                	add	sp,sp,32
    80003b92:	8082                	ret

0000000080003b94 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003b94:	7179                	add	sp,sp,-48
    80003b96:	f406                	sd	ra,40(sp)
    80003b98:	f022                	sd	s0,32(sp)
    80003b9a:	ec26                	sd	s1,24(sp)
    80003b9c:	e84a                	sd	s2,16(sp)
    80003b9e:	1800                	add	s0,sp,48
    80003ba0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003ba2:	00850913          	add	s2,a0,8
    80003ba6:	854a                	mv	a0,s2
    80003ba8:	00003097          	auipc	ra,0x3
    80003bac:	9f4080e7          	jalr	-1548(ra) # 8000659c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bb0:	409c                	lw	a5,0(s1)
    80003bb2:	ef91                	bnez	a5,80003bce <holdingsleep+0x3a>
    80003bb4:	4481                	li	s1,0
  release(&lk->lk);
    80003bb6:	854a                	mv	a0,s2
    80003bb8:	00003097          	auipc	ra,0x3
    80003bbc:	a98080e7          	jalr	-1384(ra) # 80006650 <release>
  return r;
}
    80003bc0:	8526                	mv	a0,s1
    80003bc2:	70a2                	ld	ra,40(sp)
    80003bc4:	7402                	ld	s0,32(sp)
    80003bc6:	64e2                	ld	s1,24(sp)
    80003bc8:	6942                	ld	s2,16(sp)
    80003bca:	6145                	add	sp,sp,48
    80003bcc:	8082                	ret
    80003bce:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bd0:	0284a983          	lw	s3,40(s1)
    80003bd4:	ffffd097          	auipc	ra,0xffffd
    80003bd8:	41a080e7          	jalr	1050(ra) # 80000fee <myproc>
    80003bdc:	5904                	lw	s1,48(a0)
    80003bde:	413484b3          	sub	s1,s1,s3
    80003be2:	0014b493          	seqz	s1,s1
    80003be6:	69a2                	ld	s3,8(sp)
    80003be8:	b7f9                	j	80003bb6 <holdingsleep+0x22>

0000000080003bea <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003bea:	1141                	add	sp,sp,-16
    80003bec:	e406                	sd	ra,8(sp)
    80003bee:	e022                	sd	s0,0(sp)
    80003bf0:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003bf2:	00005597          	auipc	a1,0x5
    80003bf6:	a1e58593          	add	a1,a1,-1506 # 80008610 <etext+0x610>
    80003bfa:	00018517          	auipc	a0,0x18
    80003bfe:	90e50513          	add	a0,a0,-1778 # 8001b508 <ftable>
    80003c02:	00003097          	auipc	ra,0x3
    80003c06:	90a080e7          	jalr	-1782(ra) # 8000650c <initlock>
}
    80003c0a:	60a2                	ld	ra,8(sp)
    80003c0c:	6402                	ld	s0,0(sp)
    80003c0e:	0141                	add	sp,sp,16
    80003c10:	8082                	ret

0000000080003c12 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003c12:	1101                	add	sp,sp,-32
    80003c14:	ec06                	sd	ra,24(sp)
    80003c16:	e822                	sd	s0,16(sp)
    80003c18:	e426                	sd	s1,8(sp)
    80003c1a:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003c1c:	00018517          	auipc	a0,0x18
    80003c20:	8ec50513          	add	a0,a0,-1812 # 8001b508 <ftable>
    80003c24:	00003097          	auipc	ra,0x3
    80003c28:	978080e7          	jalr	-1672(ra) # 8000659c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c2c:	00018497          	auipc	s1,0x18
    80003c30:	8f448493          	add	s1,s1,-1804 # 8001b520 <ftable+0x18>
    80003c34:	00019717          	auipc	a4,0x19
    80003c38:	88c70713          	add	a4,a4,-1908 # 8001c4c0 <disk>
    if(f->ref == 0){
    80003c3c:	40dc                	lw	a5,4(s1)
    80003c3e:	cf99                	beqz	a5,80003c5c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c40:	02848493          	add	s1,s1,40
    80003c44:	fee49ce3          	bne	s1,a4,80003c3c <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003c48:	00018517          	auipc	a0,0x18
    80003c4c:	8c050513          	add	a0,a0,-1856 # 8001b508 <ftable>
    80003c50:	00003097          	auipc	ra,0x3
    80003c54:	a00080e7          	jalr	-1536(ra) # 80006650 <release>
  return 0;
    80003c58:	4481                	li	s1,0
    80003c5a:	a819                	j	80003c70 <filealloc+0x5e>
      f->ref = 1;
    80003c5c:	4785                	li	a5,1
    80003c5e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c60:	00018517          	auipc	a0,0x18
    80003c64:	8a850513          	add	a0,a0,-1880 # 8001b508 <ftable>
    80003c68:	00003097          	auipc	ra,0x3
    80003c6c:	9e8080e7          	jalr	-1560(ra) # 80006650 <release>
}
    80003c70:	8526                	mv	a0,s1
    80003c72:	60e2                	ld	ra,24(sp)
    80003c74:	6442                	ld	s0,16(sp)
    80003c76:	64a2                	ld	s1,8(sp)
    80003c78:	6105                	add	sp,sp,32
    80003c7a:	8082                	ret

0000000080003c7c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003c7c:	1101                	add	sp,sp,-32
    80003c7e:	ec06                	sd	ra,24(sp)
    80003c80:	e822                	sd	s0,16(sp)
    80003c82:	e426                	sd	s1,8(sp)
    80003c84:	1000                	add	s0,sp,32
    80003c86:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c88:	00018517          	auipc	a0,0x18
    80003c8c:	88050513          	add	a0,a0,-1920 # 8001b508 <ftable>
    80003c90:	00003097          	auipc	ra,0x3
    80003c94:	90c080e7          	jalr	-1780(ra) # 8000659c <acquire>
  if(f->ref < 1)
    80003c98:	40dc                	lw	a5,4(s1)
    80003c9a:	02f05263          	blez	a5,80003cbe <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003c9e:	2785                	addw	a5,a5,1
    80003ca0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ca2:	00018517          	auipc	a0,0x18
    80003ca6:	86650513          	add	a0,a0,-1946 # 8001b508 <ftable>
    80003caa:	00003097          	auipc	ra,0x3
    80003cae:	9a6080e7          	jalr	-1626(ra) # 80006650 <release>
  return f;
}
    80003cb2:	8526                	mv	a0,s1
    80003cb4:	60e2                	ld	ra,24(sp)
    80003cb6:	6442                	ld	s0,16(sp)
    80003cb8:	64a2                	ld	s1,8(sp)
    80003cba:	6105                	add	sp,sp,32
    80003cbc:	8082                	ret
    panic("filedup");
    80003cbe:	00005517          	auipc	a0,0x5
    80003cc2:	95a50513          	add	a0,a0,-1702 # 80008618 <etext+0x618>
    80003cc6:	00002097          	auipc	ra,0x2
    80003cca:	35c080e7          	jalr	860(ra) # 80006022 <panic>

0000000080003cce <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003cce:	7139                	add	sp,sp,-64
    80003cd0:	fc06                	sd	ra,56(sp)
    80003cd2:	f822                	sd	s0,48(sp)
    80003cd4:	f426                	sd	s1,40(sp)
    80003cd6:	0080                	add	s0,sp,64
    80003cd8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003cda:	00018517          	auipc	a0,0x18
    80003cde:	82e50513          	add	a0,a0,-2002 # 8001b508 <ftable>
    80003ce2:	00003097          	auipc	ra,0x3
    80003ce6:	8ba080e7          	jalr	-1862(ra) # 8000659c <acquire>
  if(f->ref < 1)
    80003cea:	40dc                	lw	a5,4(s1)
    80003cec:	04f05c63          	blez	a5,80003d44 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003cf0:	37fd                	addw	a5,a5,-1
    80003cf2:	0007871b          	sext.w	a4,a5
    80003cf6:	c0dc                	sw	a5,4(s1)
    80003cf8:	06e04263          	bgtz	a4,80003d5c <fileclose+0x8e>
    80003cfc:	f04a                	sd	s2,32(sp)
    80003cfe:	ec4e                	sd	s3,24(sp)
    80003d00:	e852                	sd	s4,16(sp)
    80003d02:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003d04:	0004a903          	lw	s2,0(s1)
    80003d08:	0094ca83          	lbu	s5,9(s1)
    80003d0c:	0104ba03          	ld	s4,16(s1)
    80003d10:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003d14:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003d18:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003d1c:	00017517          	auipc	a0,0x17
    80003d20:	7ec50513          	add	a0,a0,2028 # 8001b508 <ftable>
    80003d24:	00003097          	auipc	ra,0x3
    80003d28:	92c080e7          	jalr	-1748(ra) # 80006650 <release>

  if(ff.type == FD_PIPE){
    80003d2c:	4785                	li	a5,1
    80003d2e:	04f90463          	beq	s2,a5,80003d76 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003d32:	3979                	addw	s2,s2,-2
    80003d34:	4785                	li	a5,1
    80003d36:	0527fb63          	bgeu	a5,s2,80003d8c <fileclose+0xbe>
    80003d3a:	7902                	ld	s2,32(sp)
    80003d3c:	69e2                	ld	s3,24(sp)
    80003d3e:	6a42                	ld	s4,16(sp)
    80003d40:	6aa2                	ld	s5,8(sp)
    80003d42:	a02d                	j	80003d6c <fileclose+0x9e>
    80003d44:	f04a                	sd	s2,32(sp)
    80003d46:	ec4e                	sd	s3,24(sp)
    80003d48:	e852                	sd	s4,16(sp)
    80003d4a:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003d4c:	00005517          	auipc	a0,0x5
    80003d50:	8d450513          	add	a0,a0,-1836 # 80008620 <etext+0x620>
    80003d54:	00002097          	auipc	ra,0x2
    80003d58:	2ce080e7          	jalr	718(ra) # 80006022 <panic>
    release(&ftable.lock);
    80003d5c:	00017517          	auipc	a0,0x17
    80003d60:	7ac50513          	add	a0,a0,1964 # 8001b508 <ftable>
    80003d64:	00003097          	auipc	ra,0x3
    80003d68:	8ec080e7          	jalr	-1812(ra) # 80006650 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003d6c:	70e2                	ld	ra,56(sp)
    80003d6e:	7442                	ld	s0,48(sp)
    80003d70:	74a2                	ld	s1,40(sp)
    80003d72:	6121                	add	sp,sp,64
    80003d74:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d76:	85d6                	mv	a1,s5
    80003d78:	8552                	mv	a0,s4
    80003d7a:	00000097          	auipc	ra,0x0
    80003d7e:	3a2080e7          	jalr	930(ra) # 8000411c <pipeclose>
    80003d82:	7902                	ld	s2,32(sp)
    80003d84:	69e2                	ld	s3,24(sp)
    80003d86:	6a42                	ld	s4,16(sp)
    80003d88:	6aa2                	ld	s5,8(sp)
    80003d8a:	b7cd                	j	80003d6c <fileclose+0x9e>
    begin_op();
    80003d8c:	00000097          	auipc	ra,0x0
    80003d90:	a78080e7          	jalr	-1416(ra) # 80003804 <begin_op>
    iput(ff.ip);
    80003d94:	854e                	mv	a0,s3
    80003d96:	fffff097          	auipc	ra,0xfffff
    80003d9a:	25e080e7          	jalr	606(ra) # 80002ff4 <iput>
    end_op();
    80003d9e:	00000097          	auipc	ra,0x0
    80003da2:	ae0080e7          	jalr	-1312(ra) # 8000387e <end_op>
    80003da6:	7902                	ld	s2,32(sp)
    80003da8:	69e2                	ld	s3,24(sp)
    80003daa:	6a42                	ld	s4,16(sp)
    80003dac:	6aa2                	ld	s5,8(sp)
    80003dae:	bf7d                	j	80003d6c <fileclose+0x9e>

0000000080003db0 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003db0:	715d                	add	sp,sp,-80
    80003db2:	e486                	sd	ra,72(sp)
    80003db4:	e0a2                	sd	s0,64(sp)
    80003db6:	fc26                	sd	s1,56(sp)
    80003db8:	f44e                	sd	s3,40(sp)
    80003dba:	0880                	add	s0,sp,80
    80003dbc:	84aa                	mv	s1,a0
    80003dbe:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003dc0:	ffffd097          	auipc	ra,0xffffd
    80003dc4:	22e080e7          	jalr	558(ra) # 80000fee <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003dc8:	409c                	lw	a5,0(s1)
    80003dca:	37f9                	addw	a5,a5,-2
    80003dcc:	4705                	li	a4,1
    80003dce:	04f76863          	bltu	a4,a5,80003e1e <filestat+0x6e>
    80003dd2:	f84a                	sd	s2,48(sp)
    80003dd4:	892a                	mv	s2,a0
    ilock(f->ip);
    80003dd6:	6c88                	ld	a0,24(s1)
    80003dd8:	fffff097          	auipc	ra,0xfffff
    80003ddc:	05e080e7          	jalr	94(ra) # 80002e36 <ilock>
    stati(f->ip, &st);
    80003de0:	fb840593          	add	a1,s0,-72
    80003de4:	6c88                	ld	a0,24(s1)
    80003de6:	fffff097          	auipc	ra,0xfffff
    80003dea:	2de080e7          	jalr	734(ra) # 800030c4 <stati>
    iunlock(f->ip);
    80003dee:	6c88                	ld	a0,24(s1)
    80003df0:	fffff097          	auipc	ra,0xfffff
    80003df4:	10c080e7          	jalr	268(ra) # 80002efc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003df8:	46e1                	li	a3,24
    80003dfa:	fb840613          	add	a2,s0,-72
    80003dfe:	85ce                	mv	a1,s3
    80003e00:	05093503          	ld	a0,80(s2)
    80003e04:	ffffd097          	auipc	ra,0xffffd
    80003e08:	e34080e7          	jalr	-460(ra) # 80000c38 <copyout>
    80003e0c:	41f5551b          	sraw	a0,a0,0x1f
    80003e10:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003e12:	60a6                	ld	ra,72(sp)
    80003e14:	6406                	ld	s0,64(sp)
    80003e16:	74e2                	ld	s1,56(sp)
    80003e18:	79a2                	ld	s3,40(sp)
    80003e1a:	6161                	add	sp,sp,80
    80003e1c:	8082                	ret
  return -1;
    80003e1e:	557d                	li	a0,-1
    80003e20:	bfcd                	j	80003e12 <filestat+0x62>

0000000080003e22 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003e22:	7179                	add	sp,sp,-48
    80003e24:	f406                	sd	ra,40(sp)
    80003e26:	f022                	sd	s0,32(sp)
    80003e28:	e84a                	sd	s2,16(sp)
    80003e2a:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003e2c:	00854783          	lbu	a5,8(a0)
    80003e30:	cbc5                	beqz	a5,80003ee0 <fileread+0xbe>
    80003e32:	ec26                	sd	s1,24(sp)
    80003e34:	e44e                	sd	s3,8(sp)
    80003e36:	84aa                	mv	s1,a0
    80003e38:	89ae                	mv	s3,a1
    80003e3a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e3c:	411c                	lw	a5,0(a0)
    80003e3e:	4705                	li	a4,1
    80003e40:	04e78963          	beq	a5,a4,80003e92 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e44:	470d                	li	a4,3
    80003e46:	04e78f63          	beq	a5,a4,80003ea4 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e4a:	4709                	li	a4,2
    80003e4c:	08e79263          	bne	a5,a4,80003ed0 <fileread+0xae>
    ilock(f->ip);
    80003e50:	6d08                	ld	a0,24(a0)
    80003e52:	fffff097          	auipc	ra,0xfffff
    80003e56:	fe4080e7          	jalr	-28(ra) # 80002e36 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003e5a:	874a                	mv	a4,s2
    80003e5c:	5094                	lw	a3,32(s1)
    80003e5e:	864e                	mv	a2,s3
    80003e60:	4585                	li	a1,1
    80003e62:	6c88                	ld	a0,24(s1)
    80003e64:	fffff097          	auipc	ra,0xfffff
    80003e68:	28a080e7          	jalr	650(ra) # 800030ee <readi>
    80003e6c:	892a                	mv	s2,a0
    80003e6e:	00a05563          	blez	a0,80003e78 <fileread+0x56>
      f->off += r;
    80003e72:	509c                	lw	a5,32(s1)
    80003e74:	9fa9                	addw	a5,a5,a0
    80003e76:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e78:	6c88                	ld	a0,24(s1)
    80003e7a:	fffff097          	auipc	ra,0xfffff
    80003e7e:	082080e7          	jalr	130(ra) # 80002efc <iunlock>
    80003e82:	64e2                	ld	s1,24(sp)
    80003e84:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003e86:	854a                	mv	a0,s2
    80003e88:	70a2                	ld	ra,40(sp)
    80003e8a:	7402                	ld	s0,32(sp)
    80003e8c:	6942                	ld	s2,16(sp)
    80003e8e:	6145                	add	sp,sp,48
    80003e90:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003e92:	6908                	ld	a0,16(a0)
    80003e94:	00000097          	auipc	ra,0x0
    80003e98:	400080e7          	jalr	1024(ra) # 80004294 <piperead>
    80003e9c:	892a                	mv	s2,a0
    80003e9e:	64e2                	ld	s1,24(sp)
    80003ea0:	69a2                	ld	s3,8(sp)
    80003ea2:	b7d5                	j	80003e86 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003ea4:	02451783          	lh	a5,36(a0)
    80003ea8:	03079693          	sll	a3,a5,0x30
    80003eac:	92c1                	srl	a3,a3,0x30
    80003eae:	4725                	li	a4,9
    80003eb0:	02d76a63          	bltu	a4,a3,80003ee4 <fileread+0xc2>
    80003eb4:	0792                	sll	a5,a5,0x4
    80003eb6:	00017717          	auipc	a4,0x17
    80003eba:	5b270713          	add	a4,a4,1458 # 8001b468 <devsw>
    80003ebe:	97ba                	add	a5,a5,a4
    80003ec0:	639c                	ld	a5,0(a5)
    80003ec2:	c78d                	beqz	a5,80003eec <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003ec4:	4505                	li	a0,1
    80003ec6:	9782                	jalr	a5
    80003ec8:	892a                	mv	s2,a0
    80003eca:	64e2                	ld	s1,24(sp)
    80003ecc:	69a2                	ld	s3,8(sp)
    80003ece:	bf65                	j	80003e86 <fileread+0x64>
    panic("fileread");
    80003ed0:	00004517          	auipc	a0,0x4
    80003ed4:	76050513          	add	a0,a0,1888 # 80008630 <etext+0x630>
    80003ed8:	00002097          	auipc	ra,0x2
    80003edc:	14a080e7          	jalr	330(ra) # 80006022 <panic>
    return -1;
    80003ee0:	597d                	li	s2,-1
    80003ee2:	b755                	j	80003e86 <fileread+0x64>
      return -1;
    80003ee4:	597d                	li	s2,-1
    80003ee6:	64e2                	ld	s1,24(sp)
    80003ee8:	69a2                	ld	s3,8(sp)
    80003eea:	bf71                	j	80003e86 <fileread+0x64>
    80003eec:	597d                	li	s2,-1
    80003eee:	64e2                	ld	s1,24(sp)
    80003ef0:	69a2                	ld	s3,8(sp)
    80003ef2:	bf51                	j	80003e86 <fileread+0x64>

0000000080003ef4 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003ef4:	00954783          	lbu	a5,9(a0)
    80003ef8:	12078963          	beqz	a5,8000402a <filewrite+0x136>
{
    80003efc:	715d                	add	sp,sp,-80
    80003efe:	e486                	sd	ra,72(sp)
    80003f00:	e0a2                	sd	s0,64(sp)
    80003f02:	f84a                	sd	s2,48(sp)
    80003f04:	f052                	sd	s4,32(sp)
    80003f06:	e85a                	sd	s6,16(sp)
    80003f08:	0880                	add	s0,sp,80
    80003f0a:	892a                	mv	s2,a0
    80003f0c:	8b2e                	mv	s6,a1
    80003f0e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003f10:	411c                	lw	a5,0(a0)
    80003f12:	4705                	li	a4,1
    80003f14:	02e78763          	beq	a5,a4,80003f42 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f18:	470d                	li	a4,3
    80003f1a:	02e78a63          	beq	a5,a4,80003f4e <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f1e:	4709                	li	a4,2
    80003f20:	0ee79863          	bne	a5,a4,80004010 <filewrite+0x11c>
    80003f24:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003f26:	0cc05463          	blez	a2,80003fee <filewrite+0xfa>
    80003f2a:	fc26                	sd	s1,56(sp)
    80003f2c:	ec56                	sd	s5,24(sp)
    80003f2e:	e45e                	sd	s7,8(sp)
    80003f30:	e062                	sd	s8,0(sp)
    int i = 0;
    80003f32:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003f34:	6b85                	lui	s7,0x1
    80003f36:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003f3a:	6c05                	lui	s8,0x1
    80003f3c:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003f40:	a851                	j	80003fd4 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003f42:	6908                	ld	a0,16(a0)
    80003f44:	00000097          	auipc	ra,0x0
    80003f48:	248080e7          	jalr	584(ra) # 8000418c <pipewrite>
    80003f4c:	a85d                	j	80004002 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003f4e:	02451783          	lh	a5,36(a0)
    80003f52:	03079693          	sll	a3,a5,0x30
    80003f56:	92c1                	srl	a3,a3,0x30
    80003f58:	4725                	li	a4,9
    80003f5a:	0cd76a63          	bltu	a4,a3,8000402e <filewrite+0x13a>
    80003f5e:	0792                	sll	a5,a5,0x4
    80003f60:	00017717          	auipc	a4,0x17
    80003f64:	50870713          	add	a4,a4,1288 # 8001b468 <devsw>
    80003f68:	97ba                	add	a5,a5,a4
    80003f6a:	679c                	ld	a5,8(a5)
    80003f6c:	c3f9                	beqz	a5,80004032 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003f6e:	4505                	li	a0,1
    80003f70:	9782                	jalr	a5
    80003f72:	a841                	j	80004002 <filewrite+0x10e>
      if(n1 > max)
    80003f74:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003f78:	00000097          	auipc	ra,0x0
    80003f7c:	88c080e7          	jalr	-1908(ra) # 80003804 <begin_op>
      ilock(f->ip);
    80003f80:	01893503          	ld	a0,24(s2)
    80003f84:	fffff097          	auipc	ra,0xfffff
    80003f88:	eb2080e7          	jalr	-334(ra) # 80002e36 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003f8c:	8756                	mv	a4,s5
    80003f8e:	02092683          	lw	a3,32(s2)
    80003f92:	01698633          	add	a2,s3,s6
    80003f96:	4585                	li	a1,1
    80003f98:	01893503          	ld	a0,24(s2)
    80003f9c:	fffff097          	auipc	ra,0xfffff
    80003fa0:	262080e7          	jalr	610(ra) # 800031fe <writei>
    80003fa4:	84aa                	mv	s1,a0
    80003fa6:	00a05763          	blez	a0,80003fb4 <filewrite+0xc0>
        f->off += r;
    80003faa:	02092783          	lw	a5,32(s2)
    80003fae:	9fa9                	addw	a5,a5,a0
    80003fb0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003fb4:	01893503          	ld	a0,24(s2)
    80003fb8:	fffff097          	auipc	ra,0xfffff
    80003fbc:	f44080e7          	jalr	-188(ra) # 80002efc <iunlock>
      end_op();
    80003fc0:	00000097          	auipc	ra,0x0
    80003fc4:	8be080e7          	jalr	-1858(ra) # 8000387e <end_op>

      if(r != n1){
    80003fc8:	029a9563          	bne	s5,s1,80003ff2 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003fcc:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003fd0:	0149da63          	bge	s3,s4,80003fe4 <filewrite+0xf0>
      int n1 = n - i;
    80003fd4:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003fd8:	0004879b          	sext.w	a5,s1
    80003fdc:	f8fbdce3          	bge	s7,a5,80003f74 <filewrite+0x80>
    80003fe0:	84e2                	mv	s1,s8
    80003fe2:	bf49                	j	80003f74 <filewrite+0x80>
    80003fe4:	74e2                	ld	s1,56(sp)
    80003fe6:	6ae2                	ld	s5,24(sp)
    80003fe8:	6ba2                	ld	s7,8(sp)
    80003fea:	6c02                	ld	s8,0(sp)
    80003fec:	a039                	j	80003ffa <filewrite+0x106>
    int i = 0;
    80003fee:	4981                	li	s3,0
    80003ff0:	a029                	j	80003ffa <filewrite+0x106>
    80003ff2:	74e2                	ld	s1,56(sp)
    80003ff4:	6ae2                	ld	s5,24(sp)
    80003ff6:	6ba2                	ld	s7,8(sp)
    80003ff8:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003ffa:	033a1e63          	bne	s4,s3,80004036 <filewrite+0x142>
    80003ffe:	8552                	mv	a0,s4
    80004000:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004002:	60a6                	ld	ra,72(sp)
    80004004:	6406                	ld	s0,64(sp)
    80004006:	7942                	ld	s2,48(sp)
    80004008:	7a02                	ld	s4,32(sp)
    8000400a:	6b42                	ld	s6,16(sp)
    8000400c:	6161                	add	sp,sp,80
    8000400e:	8082                	ret
    80004010:	fc26                	sd	s1,56(sp)
    80004012:	f44e                	sd	s3,40(sp)
    80004014:	ec56                	sd	s5,24(sp)
    80004016:	e45e                	sd	s7,8(sp)
    80004018:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000401a:	00004517          	auipc	a0,0x4
    8000401e:	62650513          	add	a0,a0,1574 # 80008640 <etext+0x640>
    80004022:	00002097          	auipc	ra,0x2
    80004026:	000080e7          	jalr	ra # 80006022 <panic>
    return -1;
    8000402a:	557d                	li	a0,-1
}
    8000402c:	8082                	ret
      return -1;
    8000402e:	557d                	li	a0,-1
    80004030:	bfc9                	j	80004002 <filewrite+0x10e>
    80004032:	557d                	li	a0,-1
    80004034:	b7f9                	j	80004002 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80004036:	557d                	li	a0,-1
    80004038:	79a2                	ld	s3,40(sp)
    8000403a:	b7e1                	j	80004002 <filewrite+0x10e>

000000008000403c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000403c:	7179                	add	sp,sp,-48
    8000403e:	f406                	sd	ra,40(sp)
    80004040:	f022                	sd	s0,32(sp)
    80004042:	ec26                	sd	s1,24(sp)
    80004044:	e052                	sd	s4,0(sp)
    80004046:	1800                	add	s0,sp,48
    80004048:	84aa                	mv	s1,a0
    8000404a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000404c:	0005b023          	sd	zero,0(a1)
    80004050:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004054:	00000097          	auipc	ra,0x0
    80004058:	bbe080e7          	jalr	-1090(ra) # 80003c12 <filealloc>
    8000405c:	e088                	sd	a0,0(s1)
    8000405e:	cd49                	beqz	a0,800040f8 <pipealloc+0xbc>
    80004060:	00000097          	auipc	ra,0x0
    80004064:	bb2080e7          	jalr	-1102(ra) # 80003c12 <filealloc>
    80004068:	00aa3023          	sd	a0,0(s4)
    8000406c:	c141                	beqz	a0,800040ec <pipealloc+0xb0>
    8000406e:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004070:	ffffc097          	auipc	ra,0xffffc
    80004074:	0aa080e7          	jalr	170(ra) # 8000011a <kalloc>
    80004078:	892a                	mv	s2,a0
    8000407a:	c13d                	beqz	a0,800040e0 <pipealloc+0xa4>
    8000407c:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000407e:	4985                	li	s3,1
    80004080:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004084:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004088:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000408c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004090:	00004597          	auipc	a1,0x4
    80004094:	5c058593          	add	a1,a1,1472 # 80008650 <etext+0x650>
    80004098:	00002097          	auipc	ra,0x2
    8000409c:	474080e7          	jalr	1140(ra) # 8000650c <initlock>
  (*f0)->type = FD_PIPE;
    800040a0:	609c                	ld	a5,0(s1)
    800040a2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800040a6:	609c                	ld	a5,0(s1)
    800040a8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800040ac:	609c                	ld	a5,0(s1)
    800040ae:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800040b2:	609c                	ld	a5,0(s1)
    800040b4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800040b8:	000a3783          	ld	a5,0(s4)
    800040bc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800040c0:	000a3783          	ld	a5,0(s4)
    800040c4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800040c8:	000a3783          	ld	a5,0(s4)
    800040cc:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800040d0:	000a3783          	ld	a5,0(s4)
    800040d4:	0127b823          	sd	s2,16(a5)
  return 0;
    800040d8:	4501                	li	a0,0
    800040da:	6942                	ld	s2,16(sp)
    800040dc:	69a2                	ld	s3,8(sp)
    800040de:	a03d                	j	8000410c <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800040e0:	6088                	ld	a0,0(s1)
    800040e2:	c119                	beqz	a0,800040e8 <pipealloc+0xac>
    800040e4:	6942                	ld	s2,16(sp)
    800040e6:	a029                	j	800040f0 <pipealloc+0xb4>
    800040e8:	6942                	ld	s2,16(sp)
    800040ea:	a039                	j	800040f8 <pipealloc+0xbc>
    800040ec:	6088                	ld	a0,0(s1)
    800040ee:	c50d                	beqz	a0,80004118 <pipealloc+0xdc>
    fileclose(*f0);
    800040f0:	00000097          	auipc	ra,0x0
    800040f4:	bde080e7          	jalr	-1058(ra) # 80003cce <fileclose>
  if(*f1)
    800040f8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800040fc:	557d                	li	a0,-1
  if(*f1)
    800040fe:	c799                	beqz	a5,8000410c <pipealloc+0xd0>
    fileclose(*f1);
    80004100:	853e                	mv	a0,a5
    80004102:	00000097          	auipc	ra,0x0
    80004106:	bcc080e7          	jalr	-1076(ra) # 80003cce <fileclose>
  return -1;
    8000410a:	557d                	li	a0,-1
}
    8000410c:	70a2                	ld	ra,40(sp)
    8000410e:	7402                	ld	s0,32(sp)
    80004110:	64e2                	ld	s1,24(sp)
    80004112:	6a02                	ld	s4,0(sp)
    80004114:	6145                	add	sp,sp,48
    80004116:	8082                	ret
  return -1;
    80004118:	557d                	li	a0,-1
    8000411a:	bfcd                	j	8000410c <pipealloc+0xd0>

000000008000411c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000411c:	1101                	add	sp,sp,-32
    8000411e:	ec06                	sd	ra,24(sp)
    80004120:	e822                	sd	s0,16(sp)
    80004122:	e426                	sd	s1,8(sp)
    80004124:	e04a                	sd	s2,0(sp)
    80004126:	1000                	add	s0,sp,32
    80004128:	84aa                	mv	s1,a0
    8000412a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000412c:	00002097          	auipc	ra,0x2
    80004130:	470080e7          	jalr	1136(ra) # 8000659c <acquire>
  if(writable){
    80004134:	02090d63          	beqz	s2,8000416e <pipeclose+0x52>
    pi->writeopen = 0;
    80004138:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000413c:	21848513          	add	a0,s1,536
    80004140:	ffffd097          	auipc	ra,0xffffd
    80004144:	644080e7          	jalr	1604(ra) # 80001784 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004148:	2204b783          	ld	a5,544(s1)
    8000414c:	eb95                	bnez	a5,80004180 <pipeclose+0x64>
    release(&pi->lock);
    8000414e:	8526                	mv	a0,s1
    80004150:	00002097          	auipc	ra,0x2
    80004154:	500080e7          	jalr	1280(ra) # 80006650 <release>
    kfree((char*)pi);
    80004158:	8526                	mv	a0,s1
    8000415a:	ffffc097          	auipc	ra,0xffffc
    8000415e:	ec2080e7          	jalr	-318(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004162:	60e2                	ld	ra,24(sp)
    80004164:	6442                	ld	s0,16(sp)
    80004166:	64a2                	ld	s1,8(sp)
    80004168:	6902                	ld	s2,0(sp)
    8000416a:	6105                	add	sp,sp,32
    8000416c:	8082                	ret
    pi->readopen = 0;
    8000416e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004172:	21c48513          	add	a0,s1,540
    80004176:	ffffd097          	auipc	ra,0xffffd
    8000417a:	60e080e7          	jalr	1550(ra) # 80001784 <wakeup>
    8000417e:	b7e9                	j	80004148 <pipeclose+0x2c>
    release(&pi->lock);
    80004180:	8526                	mv	a0,s1
    80004182:	00002097          	auipc	ra,0x2
    80004186:	4ce080e7          	jalr	1230(ra) # 80006650 <release>
}
    8000418a:	bfe1                	j	80004162 <pipeclose+0x46>

000000008000418c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000418c:	711d                	add	sp,sp,-96
    8000418e:	ec86                	sd	ra,88(sp)
    80004190:	e8a2                	sd	s0,80(sp)
    80004192:	e4a6                	sd	s1,72(sp)
    80004194:	e0ca                	sd	s2,64(sp)
    80004196:	fc4e                	sd	s3,56(sp)
    80004198:	f852                	sd	s4,48(sp)
    8000419a:	f456                	sd	s5,40(sp)
    8000419c:	1080                	add	s0,sp,96
    8000419e:	84aa                	mv	s1,a0
    800041a0:	8aae                	mv	s5,a1
    800041a2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800041a4:	ffffd097          	auipc	ra,0xffffd
    800041a8:	e4a080e7          	jalr	-438(ra) # 80000fee <myproc>
    800041ac:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800041ae:	8526                	mv	a0,s1
    800041b0:	00002097          	auipc	ra,0x2
    800041b4:	3ec080e7          	jalr	1004(ra) # 8000659c <acquire>
  while(i < n){
    800041b8:	0d405863          	blez	s4,80004288 <pipewrite+0xfc>
    800041bc:	f05a                	sd	s6,32(sp)
    800041be:	ec5e                	sd	s7,24(sp)
    800041c0:	e862                	sd	s8,16(sp)
  int i = 0;
    800041c2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041c4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800041c6:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800041ca:	21c48b93          	add	s7,s1,540
    800041ce:	a089                	j	80004210 <pipewrite+0x84>
      release(&pi->lock);
    800041d0:	8526                	mv	a0,s1
    800041d2:	00002097          	auipc	ra,0x2
    800041d6:	47e080e7          	jalr	1150(ra) # 80006650 <release>
      return -1;
    800041da:	597d                	li	s2,-1
    800041dc:	7b02                	ld	s6,32(sp)
    800041de:	6be2                	ld	s7,24(sp)
    800041e0:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800041e2:	854a                	mv	a0,s2
    800041e4:	60e6                	ld	ra,88(sp)
    800041e6:	6446                	ld	s0,80(sp)
    800041e8:	64a6                	ld	s1,72(sp)
    800041ea:	6906                	ld	s2,64(sp)
    800041ec:	79e2                	ld	s3,56(sp)
    800041ee:	7a42                	ld	s4,48(sp)
    800041f0:	7aa2                	ld	s5,40(sp)
    800041f2:	6125                	add	sp,sp,96
    800041f4:	8082                	ret
      wakeup(&pi->nread);
    800041f6:	8562                	mv	a0,s8
    800041f8:	ffffd097          	auipc	ra,0xffffd
    800041fc:	58c080e7          	jalr	1420(ra) # 80001784 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004200:	85a6                	mv	a1,s1
    80004202:	855e                	mv	a0,s7
    80004204:	ffffd097          	auipc	ra,0xffffd
    80004208:	51c080e7          	jalr	1308(ra) # 80001720 <sleep>
  while(i < n){
    8000420c:	05495f63          	bge	s2,s4,8000426a <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    80004210:	2204a783          	lw	a5,544(s1)
    80004214:	dfd5                	beqz	a5,800041d0 <pipewrite+0x44>
    80004216:	854e                	mv	a0,s3
    80004218:	ffffd097          	auipc	ra,0xffffd
    8000421c:	7b0080e7          	jalr	1968(ra) # 800019c8 <killed>
    80004220:	f945                	bnez	a0,800041d0 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004222:	2184a783          	lw	a5,536(s1)
    80004226:	21c4a703          	lw	a4,540(s1)
    8000422a:	2007879b          	addw	a5,a5,512
    8000422e:	fcf704e3          	beq	a4,a5,800041f6 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004232:	4685                	li	a3,1
    80004234:	01590633          	add	a2,s2,s5
    80004238:	faf40593          	add	a1,s0,-81
    8000423c:	0509b503          	ld	a0,80(s3)
    80004240:	ffffd097          	auipc	ra,0xffffd
    80004244:	ad6080e7          	jalr	-1322(ra) # 80000d16 <copyin>
    80004248:	05650263          	beq	a0,s6,8000428c <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000424c:	21c4a783          	lw	a5,540(s1)
    80004250:	0017871b          	addw	a4,a5,1
    80004254:	20e4ae23          	sw	a4,540(s1)
    80004258:	1ff7f793          	and	a5,a5,511
    8000425c:	97a6                	add	a5,a5,s1
    8000425e:	faf44703          	lbu	a4,-81(s0)
    80004262:	00e78c23          	sb	a4,24(a5)
      i++;
    80004266:	2905                	addw	s2,s2,1
    80004268:	b755                	j	8000420c <pipewrite+0x80>
    8000426a:	7b02                	ld	s6,32(sp)
    8000426c:	6be2                	ld	s7,24(sp)
    8000426e:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004270:	21848513          	add	a0,s1,536
    80004274:	ffffd097          	auipc	ra,0xffffd
    80004278:	510080e7          	jalr	1296(ra) # 80001784 <wakeup>
  release(&pi->lock);
    8000427c:	8526                	mv	a0,s1
    8000427e:	00002097          	auipc	ra,0x2
    80004282:	3d2080e7          	jalr	978(ra) # 80006650 <release>
  return i;
    80004286:	bfb1                	j	800041e2 <pipewrite+0x56>
  int i = 0;
    80004288:	4901                	li	s2,0
    8000428a:	b7dd                	j	80004270 <pipewrite+0xe4>
    8000428c:	7b02                	ld	s6,32(sp)
    8000428e:	6be2                	ld	s7,24(sp)
    80004290:	6c42                	ld	s8,16(sp)
    80004292:	bff9                	j	80004270 <pipewrite+0xe4>

0000000080004294 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004294:	715d                	add	sp,sp,-80
    80004296:	e486                	sd	ra,72(sp)
    80004298:	e0a2                	sd	s0,64(sp)
    8000429a:	fc26                	sd	s1,56(sp)
    8000429c:	f84a                	sd	s2,48(sp)
    8000429e:	f44e                	sd	s3,40(sp)
    800042a0:	f052                	sd	s4,32(sp)
    800042a2:	ec56                	sd	s5,24(sp)
    800042a4:	0880                	add	s0,sp,80
    800042a6:	84aa                	mv	s1,a0
    800042a8:	892e                	mv	s2,a1
    800042aa:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800042ac:	ffffd097          	auipc	ra,0xffffd
    800042b0:	d42080e7          	jalr	-702(ra) # 80000fee <myproc>
    800042b4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800042b6:	8526                	mv	a0,s1
    800042b8:	00002097          	auipc	ra,0x2
    800042bc:	2e4080e7          	jalr	740(ra) # 8000659c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042c0:	2184a703          	lw	a4,536(s1)
    800042c4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042c8:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042cc:	02f71963          	bne	a4,a5,800042fe <piperead+0x6a>
    800042d0:	2244a783          	lw	a5,548(s1)
    800042d4:	cf95                	beqz	a5,80004310 <piperead+0x7c>
    if(killed(pr)){
    800042d6:	8552                	mv	a0,s4
    800042d8:	ffffd097          	auipc	ra,0xffffd
    800042dc:	6f0080e7          	jalr	1776(ra) # 800019c8 <killed>
    800042e0:	e10d                	bnez	a0,80004302 <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042e2:	85a6                	mv	a1,s1
    800042e4:	854e                	mv	a0,s3
    800042e6:	ffffd097          	auipc	ra,0xffffd
    800042ea:	43a080e7          	jalr	1082(ra) # 80001720 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042ee:	2184a703          	lw	a4,536(s1)
    800042f2:	21c4a783          	lw	a5,540(s1)
    800042f6:	fcf70de3          	beq	a4,a5,800042d0 <piperead+0x3c>
    800042fa:	e85a                	sd	s6,16(sp)
    800042fc:	a819                	j	80004312 <piperead+0x7e>
    800042fe:	e85a                	sd	s6,16(sp)
    80004300:	a809                	j	80004312 <piperead+0x7e>
      release(&pi->lock);
    80004302:	8526                	mv	a0,s1
    80004304:	00002097          	auipc	ra,0x2
    80004308:	34c080e7          	jalr	844(ra) # 80006650 <release>
      return -1;
    8000430c:	59fd                	li	s3,-1
    8000430e:	a0a5                	j	80004376 <piperead+0xe2>
    80004310:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004312:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004314:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004316:	05505463          	blez	s5,8000435e <piperead+0xca>
    if(pi->nread == pi->nwrite)
    8000431a:	2184a783          	lw	a5,536(s1)
    8000431e:	21c4a703          	lw	a4,540(s1)
    80004322:	02f70e63          	beq	a4,a5,8000435e <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004326:	0017871b          	addw	a4,a5,1
    8000432a:	20e4ac23          	sw	a4,536(s1)
    8000432e:	1ff7f793          	and	a5,a5,511
    80004332:	97a6                	add	a5,a5,s1
    80004334:	0187c783          	lbu	a5,24(a5)
    80004338:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000433c:	4685                	li	a3,1
    8000433e:	fbf40613          	add	a2,s0,-65
    80004342:	85ca                	mv	a1,s2
    80004344:	050a3503          	ld	a0,80(s4)
    80004348:	ffffd097          	auipc	ra,0xffffd
    8000434c:	8f0080e7          	jalr	-1808(ra) # 80000c38 <copyout>
    80004350:	01650763          	beq	a0,s6,8000435e <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004354:	2985                	addw	s3,s3,1
    80004356:	0905                	add	s2,s2,1
    80004358:	fd3a91e3          	bne	s5,s3,8000431a <piperead+0x86>
    8000435c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000435e:	21c48513          	add	a0,s1,540
    80004362:	ffffd097          	auipc	ra,0xffffd
    80004366:	422080e7          	jalr	1058(ra) # 80001784 <wakeup>
  release(&pi->lock);
    8000436a:	8526                	mv	a0,s1
    8000436c:	00002097          	auipc	ra,0x2
    80004370:	2e4080e7          	jalr	740(ra) # 80006650 <release>
    80004374:	6b42                	ld	s6,16(sp)
  return i;
}
    80004376:	854e                	mv	a0,s3
    80004378:	60a6                	ld	ra,72(sp)
    8000437a:	6406                	ld	s0,64(sp)
    8000437c:	74e2                	ld	s1,56(sp)
    8000437e:	7942                	ld	s2,48(sp)
    80004380:	79a2                	ld	s3,40(sp)
    80004382:	7a02                	ld	s4,32(sp)
    80004384:	6ae2                	ld	s5,24(sp)
    80004386:	6161                	add	sp,sp,80
    80004388:	8082                	ret

000000008000438a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000438a:	1141                	add	sp,sp,-16
    8000438c:	e422                	sd	s0,8(sp)
    8000438e:	0800                	add	s0,sp,16
    80004390:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004392:	8905                	and	a0,a0,1
    80004394:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004396:	8b89                	and	a5,a5,2
    80004398:	c399                	beqz	a5,8000439e <flags2perm+0x14>
      perm |= PTE_W;
    8000439a:	00456513          	or	a0,a0,4
    return perm;
}
    8000439e:	6422                	ld	s0,8(sp)
    800043a0:	0141                	add	sp,sp,16
    800043a2:	8082                	ret

00000000800043a4 <exec>:

int
exec(char *path, char **argv)
{
    800043a4:	df010113          	add	sp,sp,-528
    800043a8:	20113423          	sd	ra,520(sp)
    800043ac:	20813023          	sd	s0,512(sp)
    800043b0:	ffa6                	sd	s1,504(sp)
    800043b2:	fbca                	sd	s2,496(sp)
    800043b4:	0c00                	add	s0,sp,528
    800043b6:	892a                	mv	s2,a0
    800043b8:	dea43c23          	sd	a0,-520(s0)
    800043bc:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800043c0:	ffffd097          	auipc	ra,0xffffd
    800043c4:	c2e080e7          	jalr	-978(ra) # 80000fee <myproc>
    800043c8:	84aa                	mv	s1,a0

  begin_op();
    800043ca:	fffff097          	auipc	ra,0xfffff
    800043ce:	43a080e7          	jalr	1082(ra) # 80003804 <begin_op>

  if((ip = namei(path)) == 0){
    800043d2:	854a                	mv	a0,s2
    800043d4:	fffff097          	auipc	ra,0xfffff
    800043d8:	230080e7          	jalr	560(ra) # 80003604 <namei>
    800043dc:	c135                	beqz	a0,80004440 <exec+0x9c>
    800043de:	f3d2                	sd	s4,480(sp)
    800043e0:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800043e2:	fffff097          	auipc	ra,0xfffff
    800043e6:	a54080e7          	jalr	-1452(ra) # 80002e36 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800043ea:	04000713          	li	a4,64
    800043ee:	4681                	li	a3,0
    800043f0:	e5040613          	add	a2,s0,-432
    800043f4:	4581                	li	a1,0
    800043f6:	8552                	mv	a0,s4
    800043f8:	fffff097          	auipc	ra,0xfffff
    800043fc:	cf6080e7          	jalr	-778(ra) # 800030ee <readi>
    80004400:	04000793          	li	a5,64
    80004404:	00f51a63          	bne	a0,a5,80004418 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004408:	e5042703          	lw	a4,-432(s0)
    8000440c:	464c47b7          	lui	a5,0x464c4
    80004410:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004414:	02f70c63          	beq	a4,a5,8000444c <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004418:	8552                	mv	a0,s4
    8000441a:	fffff097          	auipc	ra,0xfffff
    8000441e:	c82080e7          	jalr	-894(ra) # 8000309c <iunlockput>
    end_op();
    80004422:	fffff097          	auipc	ra,0xfffff
    80004426:	45c080e7          	jalr	1116(ra) # 8000387e <end_op>
  }
  return -1;
    8000442a:	557d                	li	a0,-1
    8000442c:	7a1e                	ld	s4,480(sp)
}
    8000442e:	20813083          	ld	ra,520(sp)
    80004432:	20013403          	ld	s0,512(sp)
    80004436:	74fe                	ld	s1,504(sp)
    80004438:	795e                	ld	s2,496(sp)
    8000443a:	21010113          	add	sp,sp,528
    8000443e:	8082                	ret
    end_op();
    80004440:	fffff097          	auipc	ra,0xfffff
    80004444:	43e080e7          	jalr	1086(ra) # 8000387e <end_op>
    return -1;
    80004448:	557d                	li	a0,-1
    8000444a:	b7d5                	j	8000442e <exec+0x8a>
    8000444c:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000444e:	8526                	mv	a0,s1
    80004450:	ffffd097          	auipc	ra,0xffffd
    80004454:	c66080e7          	jalr	-922(ra) # 800010b6 <proc_pagetable>
    80004458:	8b2a                	mv	s6,a0
    8000445a:	32050b63          	beqz	a0,80004790 <exec+0x3ec>
    8000445e:	f7ce                	sd	s3,488(sp)
    80004460:	efd6                	sd	s5,472(sp)
    80004462:	e7de                	sd	s7,456(sp)
    80004464:	e3e2                	sd	s8,448(sp)
    80004466:	ff66                	sd	s9,440(sp)
    80004468:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000446a:	e7042d03          	lw	s10,-400(s0)
    8000446e:	e8845783          	lhu	a5,-376(s0)
    80004472:	14078d63          	beqz	a5,800045cc <exec+0x228>
    80004476:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004478:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000447a:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    8000447c:	6c85                	lui	s9,0x1
    8000447e:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004482:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004486:	6a85                	lui	s5,0x1
    80004488:	a0b5                	j	800044f4 <exec+0x150>
      panic("loadseg: address should exist");
    8000448a:	00004517          	auipc	a0,0x4
    8000448e:	1ce50513          	add	a0,a0,462 # 80008658 <etext+0x658>
    80004492:	00002097          	auipc	ra,0x2
    80004496:	b90080e7          	jalr	-1136(ra) # 80006022 <panic>
    if(sz - i < PGSIZE)
    8000449a:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000449c:	8726                	mv	a4,s1
    8000449e:	012c06bb          	addw	a3,s8,s2
    800044a2:	4581                	li	a1,0
    800044a4:	8552                	mv	a0,s4
    800044a6:	fffff097          	auipc	ra,0xfffff
    800044aa:	c48080e7          	jalr	-952(ra) # 800030ee <readi>
    800044ae:	2501                	sext.w	a0,a0
    800044b0:	2aa49463          	bne	s1,a0,80004758 <exec+0x3b4>
  for(i = 0; i < sz; i += PGSIZE){
    800044b4:	012a893b          	addw	s2,s5,s2
    800044b8:	03397563          	bgeu	s2,s3,800044e2 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800044bc:	02091593          	sll	a1,s2,0x20
    800044c0:	9181                	srl	a1,a1,0x20
    800044c2:	95de                	add	a1,a1,s7
    800044c4:	855a                	mv	a0,s6
    800044c6:	ffffc097          	auipc	ra,0xffffc
    800044ca:	036080e7          	jalr	54(ra) # 800004fc <walkaddr>
    800044ce:	862a                	mv	a2,a0
    if(pa == 0)
    800044d0:	dd4d                	beqz	a0,8000448a <exec+0xe6>
    if(sz - i < PGSIZE)
    800044d2:	412984bb          	subw	s1,s3,s2
    800044d6:	0004879b          	sext.w	a5,s1
    800044da:	fcfcf0e3          	bgeu	s9,a5,8000449a <exec+0xf6>
    800044de:	84d6                	mv	s1,s5
    800044e0:	bf6d                	j	8000449a <exec+0xf6>
    sz = sz1;
    800044e2:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044e6:	2d85                	addw	s11,s11,1
    800044e8:	038d0d1b          	addw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    800044ec:	e8845783          	lhu	a5,-376(s0)
    800044f0:	08fdd663          	bge	s11,a5,8000457c <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044f4:	2d01                	sext.w	s10,s10
    800044f6:	03800713          	li	a4,56
    800044fa:	86ea                	mv	a3,s10
    800044fc:	e1840613          	add	a2,s0,-488
    80004500:	4581                	li	a1,0
    80004502:	8552                	mv	a0,s4
    80004504:	fffff097          	auipc	ra,0xfffff
    80004508:	bea080e7          	jalr	-1046(ra) # 800030ee <readi>
    8000450c:	03800793          	li	a5,56
    80004510:	20f51c63          	bne	a0,a5,80004728 <exec+0x384>
    if(ph.type != ELF_PROG_LOAD)
    80004514:	e1842783          	lw	a5,-488(s0)
    80004518:	4705                	li	a4,1
    8000451a:	fce796e3          	bne	a5,a4,800044e6 <exec+0x142>
    if(ph.memsz < ph.filesz)
    8000451e:	e4043483          	ld	s1,-448(s0)
    80004522:	e3843783          	ld	a5,-456(s0)
    80004526:	20f4e563          	bltu	s1,a5,80004730 <exec+0x38c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000452a:	e2843783          	ld	a5,-472(s0)
    8000452e:	94be                	add	s1,s1,a5
    80004530:	20f4e463          	bltu	s1,a5,80004738 <exec+0x394>
    if(ph.vaddr % PGSIZE != 0)
    80004534:	df043703          	ld	a4,-528(s0)
    80004538:	8ff9                	and	a5,a5,a4
    8000453a:	20079363          	bnez	a5,80004740 <exec+0x39c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000453e:	e1c42503          	lw	a0,-484(s0)
    80004542:	00000097          	auipc	ra,0x0
    80004546:	e48080e7          	jalr	-440(ra) # 8000438a <flags2perm>
    8000454a:	86aa                	mv	a3,a0
    8000454c:	8626                	mv	a2,s1
    8000454e:	85ca                	mv	a1,s2
    80004550:	855a                	mv	a0,s6
    80004552:	ffffc097          	auipc	ra,0xffffc
    80004556:	392080e7          	jalr	914(ra) # 800008e4 <uvmalloc>
    8000455a:	e0a43423          	sd	a0,-504(s0)
    8000455e:	1e050563          	beqz	a0,80004748 <exec+0x3a4>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004562:	e2843b83          	ld	s7,-472(s0)
    80004566:	e2042c03          	lw	s8,-480(s0)
    8000456a:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000456e:	00098463          	beqz	s3,80004576 <exec+0x1d2>
    80004572:	4901                	li	s2,0
    80004574:	b7a1                	j	800044bc <exec+0x118>
    sz = sz1;
    80004576:	e0843903          	ld	s2,-504(s0)
    8000457a:	b7b5                	j	800044e6 <exec+0x142>
    8000457c:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000457e:	8552                	mv	a0,s4
    80004580:	fffff097          	auipc	ra,0xfffff
    80004584:	b1c080e7          	jalr	-1252(ra) # 8000309c <iunlockput>
  end_op();
    80004588:	fffff097          	auipc	ra,0xfffff
    8000458c:	2f6080e7          	jalr	758(ra) # 8000387e <end_op>
  p = myproc();
    80004590:	ffffd097          	auipc	ra,0xffffd
    80004594:	a5e080e7          	jalr	-1442(ra) # 80000fee <myproc>
    80004598:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000459a:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000459e:	6985                	lui	s3,0x1
    800045a0:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    800045a2:	99ca                	add	s3,s3,s2
    800045a4:	77fd                	lui	a5,0xfffff
    800045a6:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800045aa:	4691                	li	a3,4
    800045ac:	6609                	lui	a2,0x2
    800045ae:	964e                	add	a2,a2,s3
    800045b0:	85ce                	mv	a1,s3
    800045b2:	855a                	mv	a0,s6
    800045b4:	ffffc097          	auipc	ra,0xffffc
    800045b8:	330080e7          	jalr	816(ra) # 800008e4 <uvmalloc>
    800045bc:	892a                	mv	s2,a0
    800045be:	e0a43423          	sd	a0,-504(s0)
    800045c2:	e519                	bnez	a0,800045d0 <exec+0x22c>
  if(pagetable)
    800045c4:	e1343423          	sd	s3,-504(s0)
    800045c8:	4a01                	li	s4,0
    800045ca:	aa41                	j	8000475a <exec+0x3b6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800045cc:	4901                	li	s2,0
    800045ce:	bf45                	j	8000457e <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    800045d0:	75f9                	lui	a1,0xffffe
    800045d2:	95aa                	add	a1,a1,a0
    800045d4:	855a                	mv	a0,s6
    800045d6:	ffffc097          	auipc	ra,0xffffc
    800045da:	630080e7          	jalr	1584(ra) # 80000c06 <uvmclear>
  stackbase = sp - PGSIZE;
    800045de:	7bfd                	lui	s7,0xfffff
    800045e0:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800045e2:	e0043783          	ld	a5,-512(s0)
    800045e6:	6388                	ld	a0,0(a5)
    800045e8:	c52d                	beqz	a0,80004652 <exec+0x2ae>
    800045ea:	e9040993          	add	s3,s0,-368
    800045ee:	f9040c13          	add	s8,s0,-112
    800045f2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800045f4:	ffffc097          	auipc	ra,0xffffc
    800045f8:	cfa080e7          	jalr	-774(ra) # 800002ee <strlen>
    800045fc:	0015079b          	addw	a5,a0,1
    80004600:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004604:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004608:	15796463          	bltu	s2,s7,80004750 <exec+0x3ac>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000460c:	e0043d03          	ld	s10,-512(s0)
    80004610:	000d3a03          	ld	s4,0(s10)
    80004614:	8552                	mv	a0,s4
    80004616:	ffffc097          	auipc	ra,0xffffc
    8000461a:	cd8080e7          	jalr	-808(ra) # 800002ee <strlen>
    8000461e:	0015069b          	addw	a3,a0,1
    80004622:	8652                	mv	a2,s4
    80004624:	85ca                	mv	a1,s2
    80004626:	855a                	mv	a0,s6
    80004628:	ffffc097          	auipc	ra,0xffffc
    8000462c:	610080e7          	jalr	1552(ra) # 80000c38 <copyout>
    80004630:	12054263          	bltz	a0,80004754 <exec+0x3b0>
    ustack[argc] = sp;
    80004634:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004638:	0485                	add	s1,s1,1
    8000463a:	008d0793          	add	a5,s10,8
    8000463e:	e0f43023          	sd	a5,-512(s0)
    80004642:	008d3503          	ld	a0,8(s10)
    80004646:	c909                	beqz	a0,80004658 <exec+0x2b4>
    if(argc >= MAXARG)
    80004648:	09a1                	add	s3,s3,8
    8000464a:	fb8995e3          	bne	s3,s8,800045f4 <exec+0x250>
  ip = 0;
    8000464e:	4a01                	li	s4,0
    80004650:	a229                	j	8000475a <exec+0x3b6>
  sp = sz;
    80004652:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004656:	4481                	li	s1,0
  ustack[argc] = 0;
    80004658:	00349793          	sll	a5,s1,0x3
    8000465c:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffda750>
    80004660:	97a2                	add	a5,a5,s0
    80004662:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004666:	00148693          	add	a3,s1,1
    8000466a:	068e                	sll	a3,a3,0x3
    8000466c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004670:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80004674:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004678:	f57966e3          	bltu	s2,s7,800045c4 <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000467c:	e9040613          	add	a2,s0,-368
    80004680:	85ca                	mv	a1,s2
    80004682:	855a                	mv	a0,s6
    80004684:	ffffc097          	auipc	ra,0xffffc
    80004688:	5b4080e7          	jalr	1460(ra) # 80000c38 <copyout>
    8000468c:	10054463          	bltz	a0,80004794 <exec+0x3f0>
  p->trapframe->a1 = sp;
    80004690:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004694:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004698:	df843783          	ld	a5,-520(s0)
    8000469c:	0007c703          	lbu	a4,0(a5)
    800046a0:	cf11                	beqz	a4,800046bc <exec+0x318>
    800046a2:	0785                	add	a5,a5,1
    if(*s == '/')
    800046a4:	02f00693          	li	a3,47
    800046a8:	a039                	j	800046b6 <exec+0x312>
      last = s+1;
    800046aa:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800046ae:	0785                	add	a5,a5,1
    800046b0:	fff7c703          	lbu	a4,-1(a5)
    800046b4:	c701                	beqz	a4,800046bc <exec+0x318>
    if(*s == '/')
    800046b6:	fed71ce3          	bne	a4,a3,800046ae <exec+0x30a>
    800046ba:	bfc5                	j	800046aa <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    800046bc:	4641                	li	a2,16
    800046be:	df843583          	ld	a1,-520(s0)
    800046c2:	158a8513          	add	a0,s5,344
    800046c6:	ffffc097          	auipc	ra,0xffffc
    800046ca:	bf6080e7          	jalr	-1034(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    800046ce:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800046d2:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800046d6:	e0843783          	ld	a5,-504(s0)
    800046da:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800046de:	058ab783          	ld	a5,88(s5)
    800046e2:	e6843703          	ld	a4,-408(s0)
    800046e6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800046e8:	058ab783          	ld	a5,88(s5)
    800046ec:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800046f0:	85e6                	mv	a1,s9
    800046f2:	ffffd097          	auipc	ra,0xffffd
    800046f6:	ace080e7          	jalr	-1330(ra) # 800011c0 <proc_freepagetable>
  if(p->pid==1) vmprint(p->pagetable);  // print the first process's page table
    800046fa:	030aa703          	lw	a4,48(s5)
    800046fe:	4785                	li	a5,1
    80004700:	00f70d63          	beq	a4,a5,8000471a <exec+0x376>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004704:	0004851b          	sext.w	a0,s1
    80004708:	79be                	ld	s3,488(sp)
    8000470a:	7a1e                	ld	s4,480(sp)
    8000470c:	6afe                	ld	s5,472(sp)
    8000470e:	6b5e                	ld	s6,464(sp)
    80004710:	6bbe                	ld	s7,456(sp)
    80004712:	6c1e                	ld	s8,448(sp)
    80004714:	7cfa                	ld	s9,440(sp)
    80004716:	7d5a                	ld	s10,432(sp)
    80004718:	bb19                	j	8000442e <exec+0x8a>
  if(p->pid==1) vmprint(p->pagetable);  // print the first process's page table
    8000471a:	050ab503          	ld	a0,80(s5)
    8000471e:	ffffc097          	auipc	ra,0xffffc
    80004722:	2f0080e7          	jalr	752(ra) # 80000a0e <vmprint>
    80004726:	bff9                	j	80004704 <exec+0x360>
    80004728:	e1243423          	sd	s2,-504(s0)
    8000472c:	7dba                	ld	s11,424(sp)
    8000472e:	a035                	j	8000475a <exec+0x3b6>
    80004730:	e1243423          	sd	s2,-504(s0)
    80004734:	7dba                	ld	s11,424(sp)
    80004736:	a015                	j	8000475a <exec+0x3b6>
    80004738:	e1243423          	sd	s2,-504(s0)
    8000473c:	7dba                	ld	s11,424(sp)
    8000473e:	a831                	j	8000475a <exec+0x3b6>
    80004740:	e1243423          	sd	s2,-504(s0)
    80004744:	7dba                	ld	s11,424(sp)
    80004746:	a811                	j	8000475a <exec+0x3b6>
    80004748:	e1243423          	sd	s2,-504(s0)
    8000474c:	7dba                	ld	s11,424(sp)
    8000474e:	a031                	j	8000475a <exec+0x3b6>
  ip = 0;
    80004750:	4a01                	li	s4,0
    80004752:	a021                	j	8000475a <exec+0x3b6>
    80004754:	4a01                	li	s4,0
  if(pagetable)
    80004756:	a011                	j	8000475a <exec+0x3b6>
    80004758:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    8000475a:	e0843583          	ld	a1,-504(s0)
    8000475e:	855a                	mv	a0,s6
    80004760:	ffffd097          	auipc	ra,0xffffd
    80004764:	a60080e7          	jalr	-1440(ra) # 800011c0 <proc_freepagetable>
  return -1;
    80004768:	557d                	li	a0,-1
  if(ip){
    8000476a:	000a1b63          	bnez	s4,80004780 <exec+0x3dc>
    8000476e:	79be                	ld	s3,488(sp)
    80004770:	7a1e                	ld	s4,480(sp)
    80004772:	6afe                	ld	s5,472(sp)
    80004774:	6b5e                	ld	s6,464(sp)
    80004776:	6bbe                	ld	s7,456(sp)
    80004778:	6c1e                	ld	s8,448(sp)
    8000477a:	7cfa                	ld	s9,440(sp)
    8000477c:	7d5a                	ld	s10,432(sp)
    8000477e:	b945                	j	8000442e <exec+0x8a>
    80004780:	79be                	ld	s3,488(sp)
    80004782:	6afe                	ld	s5,472(sp)
    80004784:	6b5e                	ld	s6,464(sp)
    80004786:	6bbe                	ld	s7,456(sp)
    80004788:	6c1e                	ld	s8,448(sp)
    8000478a:	7cfa                	ld	s9,440(sp)
    8000478c:	7d5a                	ld	s10,432(sp)
    8000478e:	b169                	j	80004418 <exec+0x74>
    80004790:	6b5e                	ld	s6,464(sp)
    80004792:	b159                	j	80004418 <exec+0x74>
  sz = sz1;
    80004794:	e0843983          	ld	s3,-504(s0)
    80004798:	b535                	j	800045c4 <exec+0x220>

000000008000479a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000479a:	7179                	add	sp,sp,-48
    8000479c:	f406                	sd	ra,40(sp)
    8000479e:	f022                	sd	s0,32(sp)
    800047a0:	ec26                	sd	s1,24(sp)
    800047a2:	e84a                	sd	s2,16(sp)
    800047a4:	1800                	add	s0,sp,48
    800047a6:	892e                	mv	s2,a1
    800047a8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800047aa:	fdc40593          	add	a1,s0,-36
    800047ae:	ffffe097          	auipc	ra,0xffffe
    800047b2:	9e8080e7          	jalr	-1560(ra) # 80002196 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800047b6:	fdc42703          	lw	a4,-36(s0)
    800047ba:	47bd                	li	a5,15
    800047bc:	02e7eb63          	bltu	a5,a4,800047f2 <argfd+0x58>
    800047c0:	ffffd097          	auipc	ra,0xffffd
    800047c4:	82e080e7          	jalr	-2002(ra) # 80000fee <myproc>
    800047c8:	fdc42703          	lw	a4,-36(s0)
    800047cc:	01a70793          	add	a5,a4,26
    800047d0:	078e                	sll	a5,a5,0x3
    800047d2:	953e                	add	a0,a0,a5
    800047d4:	611c                	ld	a5,0(a0)
    800047d6:	c385                	beqz	a5,800047f6 <argfd+0x5c>
    return -1;
  if(pfd)
    800047d8:	00090463          	beqz	s2,800047e0 <argfd+0x46>
    *pfd = fd;
    800047dc:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800047e0:	4501                	li	a0,0
  if(pf)
    800047e2:	c091                	beqz	s1,800047e6 <argfd+0x4c>
    *pf = f;
    800047e4:	e09c                	sd	a5,0(s1)
}
    800047e6:	70a2                	ld	ra,40(sp)
    800047e8:	7402                	ld	s0,32(sp)
    800047ea:	64e2                	ld	s1,24(sp)
    800047ec:	6942                	ld	s2,16(sp)
    800047ee:	6145                	add	sp,sp,48
    800047f0:	8082                	ret
    return -1;
    800047f2:	557d                	li	a0,-1
    800047f4:	bfcd                	j	800047e6 <argfd+0x4c>
    800047f6:	557d                	li	a0,-1
    800047f8:	b7fd                	j	800047e6 <argfd+0x4c>

00000000800047fa <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800047fa:	1101                	add	sp,sp,-32
    800047fc:	ec06                	sd	ra,24(sp)
    800047fe:	e822                	sd	s0,16(sp)
    80004800:	e426                	sd	s1,8(sp)
    80004802:	1000                	add	s0,sp,32
    80004804:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004806:	ffffc097          	auipc	ra,0xffffc
    8000480a:	7e8080e7          	jalr	2024(ra) # 80000fee <myproc>
    8000480e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004810:	0d050793          	add	a5,a0,208
    80004814:	4501                	li	a0,0
    80004816:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004818:	6398                	ld	a4,0(a5)
    8000481a:	cb19                	beqz	a4,80004830 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000481c:	2505                	addw	a0,a0,1
    8000481e:	07a1                	add	a5,a5,8
    80004820:	fed51ce3          	bne	a0,a3,80004818 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004824:	557d                	li	a0,-1
}
    80004826:	60e2                	ld	ra,24(sp)
    80004828:	6442                	ld	s0,16(sp)
    8000482a:	64a2                	ld	s1,8(sp)
    8000482c:	6105                	add	sp,sp,32
    8000482e:	8082                	ret
      p->ofile[fd] = f;
    80004830:	01a50793          	add	a5,a0,26
    80004834:	078e                	sll	a5,a5,0x3
    80004836:	963e                	add	a2,a2,a5
    80004838:	e204                	sd	s1,0(a2)
      return fd;
    8000483a:	b7f5                	j	80004826 <fdalloc+0x2c>

000000008000483c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000483c:	715d                	add	sp,sp,-80
    8000483e:	e486                	sd	ra,72(sp)
    80004840:	e0a2                	sd	s0,64(sp)
    80004842:	fc26                	sd	s1,56(sp)
    80004844:	f84a                	sd	s2,48(sp)
    80004846:	f44e                	sd	s3,40(sp)
    80004848:	ec56                	sd	s5,24(sp)
    8000484a:	e85a                	sd	s6,16(sp)
    8000484c:	0880                	add	s0,sp,80
    8000484e:	8b2e                	mv	s6,a1
    80004850:	89b2                	mv	s3,a2
    80004852:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004854:	fb040593          	add	a1,s0,-80
    80004858:	fffff097          	auipc	ra,0xfffff
    8000485c:	dca080e7          	jalr	-566(ra) # 80003622 <nameiparent>
    80004860:	84aa                	mv	s1,a0
    80004862:	14050e63          	beqz	a0,800049be <create+0x182>
    return 0;

  ilock(dp);
    80004866:	ffffe097          	auipc	ra,0xffffe
    8000486a:	5d0080e7          	jalr	1488(ra) # 80002e36 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000486e:	4601                	li	a2,0
    80004870:	fb040593          	add	a1,s0,-80
    80004874:	8526                	mv	a0,s1
    80004876:	fffff097          	auipc	ra,0xfffff
    8000487a:	acc080e7          	jalr	-1332(ra) # 80003342 <dirlookup>
    8000487e:	8aaa                	mv	s5,a0
    80004880:	c539                	beqz	a0,800048ce <create+0x92>
    iunlockput(dp);
    80004882:	8526                	mv	a0,s1
    80004884:	fffff097          	auipc	ra,0xfffff
    80004888:	818080e7          	jalr	-2024(ra) # 8000309c <iunlockput>
    ilock(ip);
    8000488c:	8556                	mv	a0,s5
    8000488e:	ffffe097          	auipc	ra,0xffffe
    80004892:	5a8080e7          	jalr	1448(ra) # 80002e36 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004896:	4789                	li	a5,2
    80004898:	02fb1463          	bne	s6,a5,800048c0 <create+0x84>
    8000489c:	044ad783          	lhu	a5,68(s5)
    800048a0:	37f9                	addw	a5,a5,-2
    800048a2:	17c2                	sll	a5,a5,0x30
    800048a4:	93c1                	srl	a5,a5,0x30
    800048a6:	4705                	li	a4,1
    800048a8:	00f76c63          	bltu	a4,a5,800048c0 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800048ac:	8556                	mv	a0,s5
    800048ae:	60a6                	ld	ra,72(sp)
    800048b0:	6406                	ld	s0,64(sp)
    800048b2:	74e2                	ld	s1,56(sp)
    800048b4:	7942                	ld	s2,48(sp)
    800048b6:	79a2                	ld	s3,40(sp)
    800048b8:	6ae2                	ld	s5,24(sp)
    800048ba:	6b42                	ld	s6,16(sp)
    800048bc:	6161                	add	sp,sp,80
    800048be:	8082                	ret
    iunlockput(ip);
    800048c0:	8556                	mv	a0,s5
    800048c2:	ffffe097          	auipc	ra,0xffffe
    800048c6:	7da080e7          	jalr	2010(ra) # 8000309c <iunlockput>
    return 0;
    800048ca:	4a81                	li	s5,0
    800048cc:	b7c5                	j	800048ac <create+0x70>
    800048ce:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800048d0:	85da                	mv	a1,s6
    800048d2:	4088                	lw	a0,0(s1)
    800048d4:	ffffe097          	auipc	ra,0xffffe
    800048d8:	3be080e7          	jalr	958(ra) # 80002c92 <ialloc>
    800048dc:	8a2a                	mv	s4,a0
    800048de:	c531                	beqz	a0,8000492a <create+0xee>
  ilock(ip);
    800048e0:	ffffe097          	auipc	ra,0xffffe
    800048e4:	556080e7          	jalr	1366(ra) # 80002e36 <ilock>
  ip->major = major;
    800048e8:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800048ec:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800048f0:	4905                	li	s2,1
    800048f2:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800048f6:	8552                	mv	a0,s4
    800048f8:	ffffe097          	auipc	ra,0xffffe
    800048fc:	472080e7          	jalr	1138(ra) # 80002d6a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004900:	032b0d63          	beq	s6,s2,8000493a <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004904:	004a2603          	lw	a2,4(s4)
    80004908:	fb040593          	add	a1,s0,-80
    8000490c:	8526                	mv	a0,s1
    8000490e:	fffff097          	auipc	ra,0xfffff
    80004912:	c44080e7          	jalr	-956(ra) # 80003552 <dirlink>
    80004916:	08054163          	bltz	a0,80004998 <create+0x15c>
  iunlockput(dp);
    8000491a:	8526                	mv	a0,s1
    8000491c:	ffffe097          	auipc	ra,0xffffe
    80004920:	780080e7          	jalr	1920(ra) # 8000309c <iunlockput>
  return ip;
    80004924:	8ad2                	mv	s5,s4
    80004926:	7a02                	ld	s4,32(sp)
    80004928:	b751                	j	800048ac <create+0x70>
    iunlockput(dp);
    8000492a:	8526                	mv	a0,s1
    8000492c:	ffffe097          	auipc	ra,0xffffe
    80004930:	770080e7          	jalr	1904(ra) # 8000309c <iunlockput>
    return 0;
    80004934:	8ad2                	mv	s5,s4
    80004936:	7a02                	ld	s4,32(sp)
    80004938:	bf95                	j	800048ac <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000493a:	004a2603          	lw	a2,4(s4)
    8000493e:	00004597          	auipc	a1,0x4
    80004942:	d3a58593          	add	a1,a1,-710 # 80008678 <etext+0x678>
    80004946:	8552                	mv	a0,s4
    80004948:	fffff097          	auipc	ra,0xfffff
    8000494c:	c0a080e7          	jalr	-1014(ra) # 80003552 <dirlink>
    80004950:	04054463          	bltz	a0,80004998 <create+0x15c>
    80004954:	40d0                	lw	a2,4(s1)
    80004956:	00004597          	auipc	a1,0x4
    8000495a:	d2a58593          	add	a1,a1,-726 # 80008680 <etext+0x680>
    8000495e:	8552                	mv	a0,s4
    80004960:	fffff097          	auipc	ra,0xfffff
    80004964:	bf2080e7          	jalr	-1038(ra) # 80003552 <dirlink>
    80004968:	02054863          	bltz	a0,80004998 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    8000496c:	004a2603          	lw	a2,4(s4)
    80004970:	fb040593          	add	a1,s0,-80
    80004974:	8526                	mv	a0,s1
    80004976:	fffff097          	auipc	ra,0xfffff
    8000497a:	bdc080e7          	jalr	-1060(ra) # 80003552 <dirlink>
    8000497e:	00054d63          	bltz	a0,80004998 <create+0x15c>
    dp->nlink++;  // for ".."
    80004982:	04a4d783          	lhu	a5,74(s1)
    80004986:	2785                	addw	a5,a5,1
    80004988:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000498c:	8526                	mv	a0,s1
    8000498e:	ffffe097          	auipc	ra,0xffffe
    80004992:	3dc080e7          	jalr	988(ra) # 80002d6a <iupdate>
    80004996:	b751                	j	8000491a <create+0xde>
  ip->nlink = 0;
    80004998:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000499c:	8552                	mv	a0,s4
    8000499e:	ffffe097          	auipc	ra,0xffffe
    800049a2:	3cc080e7          	jalr	972(ra) # 80002d6a <iupdate>
  iunlockput(ip);
    800049a6:	8552                	mv	a0,s4
    800049a8:	ffffe097          	auipc	ra,0xffffe
    800049ac:	6f4080e7          	jalr	1780(ra) # 8000309c <iunlockput>
  iunlockput(dp);
    800049b0:	8526                	mv	a0,s1
    800049b2:	ffffe097          	auipc	ra,0xffffe
    800049b6:	6ea080e7          	jalr	1770(ra) # 8000309c <iunlockput>
  return 0;
    800049ba:	7a02                	ld	s4,32(sp)
    800049bc:	bdc5                	j	800048ac <create+0x70>
    return 0;
    800049be:	8aaa                	mv	s5,a0
    800049c0:	b5f5                	j	800048ac <create+0x70>

00000000800049c2 <sys_dup>:
{
    800049c2:	7179                	add	sp,sp,-48
    800049c4:	f406                	sd	ra,40(sp)
    800049c6:	f022                	sd	s0,32(sp)
    800049c8:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800049ca:	fd840613          	add	a2,s0,-40
    800049ce:	4581                	li	a1,0
    800049d0:	4501                	li	a0,0
    800049d2:	00000097          	auipc	ra,0x0
    800049d6:	dc8080e7          	jalr	-568(ra) # 8000479a <argfd>
    return -1;
    800049da:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800049dc:	02054763          	bltz	a0,80004a0a <sys_dup+0x48>
    800049e0:	ec26                	sd	s1,24(sp)
    800049e2:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800049e4:	fd843903          	ld	s2,-40(s0)
    800049e8:	854a                	mv	a0,s2
    800049ea:	00000097          	auipc	ra,0x0
    800049ee:	e10080e7          	jalr	-496(ra) # 800047fa <fdalloc>
    800049f2:	84aa                	mv	s1,a0
    return -1;
    800049f4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800049f6:	00054f63          	bltz	a0,80004a14 <sys_dup+0x52>
  filedup(f);
    800049fa:	854a                	mv	a0,s2
    800049fc:	fffff097          	auipc	ra,0xfffff
    80004a00:	280080e7          	jalr	640(ra) # 80003c7c <filedup>
  return fd;
    80004a04:	87a6                	mv	a5,s1
    80004a06:	64e2                	ld	s1,24(sp)
    80004a08:	6942                	ld	s2,16(sp)
}
    80004a0a:	853e                	mv	a0,a5
    80004a0c:	70a2                	ld	ra,40(sp)
    80004a0e:	7402                	ld	s0,32(sp)
    80004a10:	6145                	add	sp,sp,48
    80004a12:	8082                	ret
    80004a14:	64e2                	ld	s1,24(sp)
    80004a16:	6942                	ld	s2,16(sp)
    80004a18:	bfcd                	j	80004a0a <sys_dup+0x48>

0000000080004a1a <sys_read>:
{
    80004a1a:	7179                	add	sp,sp,-48
    80004a1c:	f406                	sd	ra,40(sp)
    80004a1e:	f022                	sd	s0,32(sp)
    80004a20:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004a22:	fd840593          	add	a1,s0,-40
    80004a26:	4505                	li	a0,1
    80004a28:	ffffd097          	auipc	ra,0xffffd
    80004a2c:	78e080e7          	jalr	1934(ra) # 800021b6 <argaddr>
  argint(2, &n);
    80004a30:	fe440593          	add	a1,s0,-28
    80004a34:	4509                	li	a0,2
    80004a36:	ffffd097          	auipc	ra,0xffffd
    80004a3a:	760080e7          	jalr	1888(ra) # 80002196 <argint>
  if(argfd(0, 0, &f) < 0)
    80004a3e:	fe840613          	add	a2,s0,-24
    80004a42:	4581                	li	a1,0
    80004a44:	4501                	li	a0,0
    80004a46:	00000097          	auipc	ra,0x0
    80004a4a:	d54080e7          	jalr	-684(ra) # 8000479a <argfd>
    80004a4e:	87aa                	mv	a5,a0
    return -1;
    80004a50:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a52:	0007cc63          	bltz	a5,80004a6a <sys_read+0x50>
  return fileread(f, p, n);
    80004a56:	fe442603          	lw	a2,-28(s0)
    80004a5a:	fd843583          	ld	a1,-40(s0)
    80004a5e:	fe843503          	ld	a0,-24(s0)
    80004a62:	fffff097          	auipc	ra,0xfffff
    80004a66:	3c0080e7          	jalr	960(ra) # 80003e22 <fileread>
}
    80004a6a:	70a2                	ld	ra,40(sp)
    80004a6c:	7402                	ld	s0,32(sp)
    80004a6e:	6145                	add	sp,sp,48
    80004a70:	8082                	ret

0000000080004a72 <sys_write>:
{
    80004a72:	7179                	add	sp,sp,-48
    80004a74:	f406                	sd	ra,40(sp)
    80004a76:	f022                	sd	s0,32(sp)
    80004a78:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004a7a:	fd840593          	add	a1,s0,-40
    80004a7e:	4505                	li	a0,1
    80004a80:	ffffd097          	auipc	ra,0xffffd
    80004a84:	736080e7          	jalr	1846(ra) # 800021b6 <argaddr>
  argint(2, &n);
    80004a88:	fe440593          	add	a1,s0,-28
    80004a8c:	4509                	li	a0,2
    80004a8e:	ffffd097          	auipc	ra,0xffffd
    80004a92:	708080e7          	jalr	1800(ra) # 80002196 <argint>
  if(argfd(0, 0, &f) < 0)
    80004a96:	fe840613          	add	a2,s0,-24
    80004a9a:	4581                	li	a1,0
    80004a9c:	4501                	li	a0,0
    80004a9e:	00000097          	auipc	ra,0x0
    80004aa2:	cfc080e7          	jalr	-772(ra) # 8000479a <argfd>
    80004aa6:	87aa                	mv	a5,a0
    return -1;
    80004aa8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004aaa:	0007cc63          	bltz	a5,80004ac2 <sys_write+0x50>
  return filewrite(f, p, n);
    80004aae:	fe442603          	lw	a2,-28(s0)
    80004ab2:	fd843583          	ld	a1,-40(s0)
    80004ab6:	fe843503          	ld	a0,-24(s0)
    80004aba:	fffff097          	auipc	ra,0xfffff
    80004abe:	43a080e7          	jalr	1082(ra) # 80003ef4 <filewrite>
}
    80004ac2:	70a2                	ld	ra,40(sp)
    80004ac4:	7402                	ld	s0,32(sp)
    80004ac6:	6145                	add	sp,sp,48
    80004ac8:	8082                	ret

0000000080004aca <sys_close>:
{
    80004aca:	1101                	add	sp,sp,-32
    80004acc:	ec06                	sd	ra,24(sp)
    80004ace:	e822                	sd	s0,16(sp)
    80004ad0:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004ad2:	fe040613          	add	a2,s0,-32
    80004ad6:	fec40593          	add	a1,s0,-20
    80004ada:	4501                	li	a0,0
    80004adc:	00000097          	auipc	ra,0x0
    80004ae0:	cbe080e7          	jalr	-834(ra) # 8000479a <argfd>
    return -1;
    80004ae4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004ae6:	02054463          	bltz	a0,80004b0e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004aea:	ffffc097          	auipc	ra,0xffffc
    80004aee:	504080e7          	jalr	1284(ra) # 80000fee <myproc>
    80004af2:	fec42783          	lw	a5,-20(s0)
    80004af6:	07e9                	add	a5,a5,26
    80004af8:	078e                	sll	a5,a5,0x3
    80004afa:	953e                	add	a0,a0,a5
    80004afc:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004b00:	fe043503          	ld	a0,-32(s0)
    80004b04:	fffff097          	auipc	ra,0xfffff
    80004b08:	1ca080e7          	jalr	458(ra) # 80003cce <fileclose>
  return 0;
    80004b0c:	4781                	li	a5,0
}
    80004b0e:	853e                	mv	a0,a5
    80004b10:	60e2                	ld	ra,24(sp)
    80004b12:	6442                	ld	s0,16(sp)
    80004b14:	6105                	add	sp,sp,32
    80004b16:	8082                	ret

0000000080004b18 <sys_fstat>:
{
    80004b18:	1101                	add	sp,sp,-32
    80004b1a:	ec06                	sd	ra,24(sp)
    80004b1c:	e822                	sd	s0,16(sp)
    80004b1e:	1000                	add	s0,sp,32
  argaddr(1, &st);
    80004b20:	fe040593          	add	a1,s0,-32
    80004b24:	4505                	li	a0,1
    80004b26:	ffffd097          	auipc	ra,0xffffd
    80004b2a:	690080e7          	jalr	1680(ra) # 800021b6 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004b2e:	fe840613          	add	a2,s0,-24
    80004b32:	4581                	li	a1,0
    80004b34:	4501                	li	a0,0
    80004b36:	00000097          	auipc	ra,0x0
    80004b3a:	c64080e7          	jalr	-924(ra) # 8000479a <argfd>
    80004b3e:	87aa                	mv	a5,a0
    return -1;
    80004b40:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b42:	0007ca63          	bltz	a5,80004b56 <sys_fstat+0x3e>
  return filestat(f, st);
    80004b46:	fe043583          	ld	a1,-32(s0)
    80004b4a:	fe843503          	ld	a0,-24(s0)
    80004b4e:	fffff097          	auipc	ra,0xfffff
    80004b52:	262080e7          	jalr	610(ra) # 80003db0 <filestat>
}
    80004b56:	60e2                	ld	ra,24(sp)
    80004b58:	6442                	ld	s0,16(sp)
    80004b5a:	6105                	add	sp,sp,32
    80004b5c:	8082                	ret

0000000080004b5e <sys_link>:
{
    80004b5e:	7169                	add	sp,sp,-304
    80004b60:	f606                	sd	ra,296(sp)
    80004b62:	f222                	sd	s0,288(sp)
    80004b64:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b66:	08000613          	li	a2,128
    80004b6a:	ed040593          	add	a1,s0,-304
    80004b6e:	4501                	li	a0,0
    80004b70:	ffffd097          	auipc	ra,0xffffd
    80004b74:	666080e7          	jalr	1638(ra) # 800021d6 <argstr>
    return -1;
    80004b78:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b7a:	12054663          	bltz	a0,80004ca6 <sys_link+0x148>
    80004b7e:	08000613          	li	a2,128
    80004b82:	f5040593          	add	a1,s0,-176
    80004b86:	4505                	li	a0,1
    80004b88:	ffffd097          	auipc	ra,0xffffd
    80004b8c:	64e080e7          	jalr	1614(ra) # 800021d6 <argstr>
    return -1;
    80004b90:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b92:	10054a63          	bltz	a0,80004ca6 <sys_link+0x148>
    80004b96:	ee26                	sd	s1,280(sp)
  begin_op();
    80004b98:	fffff097          	auipc	ra,0xfffff
    80004b9c:	c6c080e7          	jalr	-916(ra) # 80003804 <begin_op>
  if((ip = namei(old)) == 0){
    80004ba0:	ed040513          	add	a0,s0,-304
    80004ba4:	fffff097          	auipc	ra,0xfffff
    80004ba8:	a60080e7          	jalr	-1440(ra) # 80003604 <namei>
    80004bac:	84aa                	mv	s1,a0
    80004bae:	c949                	beqz	a0,80004c40 <sys_link+0xe2>
  ilock(ip);
    80004bb0:	ffffe097          	auipc	ra,0xffffe
    80004bb4:	286080e7          	jalr	646(ra) # 80002e36 <ilock>
  if(ip->type == T_DIR){
    80004bb8:	04449703          	lh	a4,68(s1)
    80004bbc:	4785                	li	a5,1
    80004bbe:	08f70863          	beq	a4,a5,80004c4e <sys_link+0xf0>
    80004bc2:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004bc4:	04a4d783          	lhu	a5,74(s1)
    80004bc8:	2785                	addw	a5,a5,1
    80004bca:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004bce:	8526                	mv	a0,s1
    80004bd0:	ffffe097          	auipc	ra,0xffffe
    80004bd4:	19a080e7          	jalr	410(ra) # 80002d6a <iupdate>
  iunlock(ip);
    80004bd8:	8526                	mv	a0,s1
    80004bda:	ffffe097          	auipc	ra,0xffffe
    80004bde:	322080e7          	jalr	802(ra) # 80002efc <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004be2:	fd040593          	add	a1,s0,-48
    80004be6:	f5040513          	add	a0,s0,-176
    80004bea:	fffff097          	auipc	ra,0xfffff
    80004bee:	a38080e7          	jalr	-1480(ra) # 80003622 <nameiparent>
    80004bf2:	892a                	mv	s2,a0
    80004bf4:	cd35                	beqz	a0,80004c70 <sys_link+0x112>
  ilock(dp);
    80004bf6:	ffffe097          	auipc	ra,0xffffe
    80004bfa:	240080e7          	jalr	576(ra) # 80002e36 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004bfe:	00092703          	lw	a4,0(s2)
    80004c02:	409c                	lw	a5,0(s1)
    80004c04:	06f71163          	bne	a4,a5,80004c66 <sys_link+0x108>
    80004c08:	40d0                	lw	a2,4(s1)
    80004c0a:	fd040593          	add	a1,s0,-48
    80004c0e:	854a                	mv	a0,s2
    80004c10:	fffff097          	auipc	ra,0xfffff
    80004c14:	942080e7          	jalr	-1726(ra) # 80003552 <dirlink>
    80004c18:	04054763          	bltz	a0,80004c66 <sys_link+0x108>
  iunlockput(dp);
    80004c1c:	854a                	mv	a0,s2
    80004c1e:	ffffe097          	auipc	ra,0xffffe
    80004c22:	47e080e7          	jalr	1150(ra) # 8000309c <iunlockput>
  iput(ip);
    80004c26:	8526                	mv	a0,s1
    80004c28:	ffffe097          	auipc	ra,0xffffe
    80004c2c:	3cc080e7          	jalr	972(ra) # 80002ff4 <iput>
  end_op();
    80004c30:	fffff097          	auipc	ra,0xfffff
    80004c34:	c4e080e7          	jalr	-946(ra) # 8000387e <end_op>
  return 0;
    80004c38:	4781                	li	a5,0
    80004c3a:	64f2                	ld	s1,280(sp)
    80004c3c:	6952                	ld	s2,272(sp)
    80004c3e:	a0a5                	j	80004ca6 <sys_link+0x148>
    end_op();
    80004c40:	fffff097          	auipc	ra,0xfffff
    80004c44:	c3e080e7          	jalr	-962(ra) # 8000387e <end_op>
    return -1;
    80004c48:	57fd                	li	a5,-1
    80004c4a:	64f2                	ld	s1,280(sp)
    80004c4c:	a8a9                	j	80004ca6 <sys_link+0x148>
    iunlockput(ip);
    80004c4e:	8526                	mv	a0,s1
    80004c50:	ffffe097          	auipc	ra,0xffffe
    80004c54:	44c080e7          	jalr	1100(ra) # 8000309c <iunlockput>
    end_op();
    80004c58:	fffff097          	auipc	ra,0xfffff
    80004c5c:	c26080e7          	jalr	-986(ra) # 8000387e <end_op>
    return -1;
    80004c60:	57fd                	li	a5,-1
    80004c62:	64f2                	ld	s1,280(sp)
    80004c64:	a089                	j	80004ca6 <sys_link+0x148>
    iunlockput(dp);
    80004c66:	854a                	mv	a0,s2
    80004c68:	ffffe097          	auipc	ra,0xffffe
    80004c6c:	434080e7          	jalr	1076(ra) # 8000309c <iunlockput>
  ilock(ip);
    80004c70:	8526                	mv	a0,s1
    80004c72:	ffffe097          	auipc	ra,0xffffe
    80004c76:	1c4080e7          	jalr	452(ra) # 80002e36 <ilock>
  ip->nlink--;
    80004c7a:	04a4d783          	lhu	a5,74(s1)
    80004c7e:	37fd                	addw	a5,a5,-1
    80004c80:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c84:	8526                	mv	a0,s1
    80004c86:	ffffe097          	auipc	ra,0xffffe
    80004c8a:	0e4080e7          	jalr	228(ra) # 80002d6a <iupdate>
  iunlockput(ip);
    80004c8e:	8526                	mv	a0,s1
    80004c90:	ffffe097          	auipc	ra,0xffffe
    80004c94:	40c080e7          	jalr	1036(ra) # 8000309c <iunlockput>
  end_op();
    80004c98:	fffff097          	auipc	ra,0xfffff
    80004c9c:	be6080e7          	jalr	-1050(ra) # 8000387e <end_op>
  return -1;
    80004ca0:	57fd                	li	a5,-1
    80004ca2:	64f2                	ld	s1,280(sp)
    80004ca4:	6952                	ld	s2,272(sp)
}
    80004ca6:	853e                	mv	a0,a5
    80004ca8:	70b2                	ld	ra,296(sp)
    80004caa:	7412                	ld	s0,288(sp)
    80004cac:	6155                	add	sp,sp,304
    80004cae:	8082                	ret

0000000080004cb0 <sys_unlink>:
{
    80004cb0:	7151                	add	sp,sp,-240
    80004cb2:	f586                	sd	ra,232(sp)
    80004cb4:	f1a2                	sd	s0,224(sp)
    80004cb6:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004cb8:	08000613          	li	a2,128
    80004cbc:	f3040593          	add	a1,s0,-208
    80004cc0:	4501                	li	a0,0
    80004cc2:	ffffd097          	auipc	ra,0xffffd
    80004cc6:	514080e7          	jalr	1300(ra) # 800021d6 <argstr>
    80004cca:	1a054a63          	bltz	a0,80004e7e <sys_unlink+0x1ce>
    80004cce:	eda6                	sd	s1,216(sp)
  begin_op();
    80004cd0:	fffff097          	auipc	ra,0xfffff
    80004cd4:	b34080e7          	jalr	-1228(ra) # 80003804 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004cd8:	fb040593          	add	a1,s0,-80
    80004cdc:	f3040513          	add	a0,s0,-208
    80004ce0:	fffff097          	auipc	ra,0xfffff
    80004ce4:	942080e7          	jalr	-1726(ra) # 80003622 <nameiparent>
    80004ce8:	84aa                	mv	s1,a0
    80004cea:	cd71                	beqz	a0,80004dc6 <sys_unlink+0x116>
  ilock(dp);
    80004cec:	ffffe097          	auipc	ra,0xffffe
    80004cf0:	14a080e7          	jalr	330(ra) # 80002e36 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004cf4:	00004597          	auipc	a1,0x4
    80004cf8:	98458593          	add	a1,a1,-1660 # 80008678 <etext+0x678>
    80004cfc:	fb040513          	add	a0,s0,-80
    80004d00:	ffffe097          	auipc	ra,0xffffe
    80004d04:	628080e7          	jalr	1576(ra) # 80003328 <namecmp>
    80004d08:	14050c63          	beqz	a0,80004e60 <sys_unlink+0x1b0>
    80004d0c:	00004597          	auipc	a1,0x4
    80004d10:	97458593          	add	a1,a1,-1676 # 80008680 <etext+0x680>
    80004d14:	fb040513          	add	a0,s0,-80
    80004d18:	ffffe097          	auipc	ra,0xffffe
    80004d1c:	610080e7          	jalr	1552(ra) # 80003328 <namecmp>
    80004d20:	14050063          	beqz	a0,80004e60 <sys_unlink+0x1b0>
    80004d24:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004d26:	f2c40613          	add	a2,s0,-212
    80004d2a:	fb040593          	add	a1,s0,-80
    80004d2e:	8526                	mv	a0,s1
    80004d30:	ffffe097          	auipc	ra,0xffffe
    80004d34:	612080e7          	jalr	1554(ra) # 80003342 <dirlookup>
    80004d38:	892a                	mv	s2,a0
    80004d3a:	12050263          	beqz	a0,80004e5e <sys_unlink+0x1ae>
  ilock(ip);
    80004d3e:	ffffe097          	auipc	ra,0xffffe
    80004d42:	0f8080e7          	jalr	248(ra) # 80002e36 <ilock>
  if(ip->nlink < 1)
    80004d46:	04a91783          	lh	a5,74(s2)
    80004d4a:	08f05563          	blez	a5,80004dd4 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004d4e:	04491703          	lh	a4,68(s2)
    80004d52:	4785                	li	a5,1
    80004d54:	08f70963          	beq	a4,a5,80004de6 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004d58:	4641                	li	a2,16
    80004d5a:	4581                	li	a1,0
    80004d5c:	fc040513          	add	a0,s0,-64
    80004d60:	ffffb097          	auipc	ra,0xffffb
    80004d64:	41a080e7          	jalr	1050(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d68:	4741                	li	a4,16
    80004d6a:	f2c42683          	lw	a3,-212(s0)
    80004d6e:	fc040613          	add	a2,s0,-64
    80004d72:	4581                	li	a1,0
    80004d74:	8526                	mv	a0,s1
    80004d76:	ffffe097          	auipc	ra,0xffffe
    80004d7a:	488080e7          	jalr	1160(ra) # 800031fe <writei>
    80004d7e:	47c1                	li	a5,16
    80004d80:	0af51b63          	bne	a0,a5,80004e36 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004d84:	04491703          	lh	a4,68(s2)
    80004d88:	4785                	li	a5,1
    80004d8a:	0af70f63          	beq	a4,a5,80004e48 <sys_unlink+0x198>
  iunlockput(dp);
    80004d8e:	8526                	mv	a0,s1
    80004d90:	ffffe097          	auipc	ra,0xffffe
    80004d94:	30c080e7          	jalr	780(ra) # 8000309c <iunlockput>
  ip->nlink--;
    80004d98:	04a95783          	lhu	a5,74(s2)
    80004d9c:	37fd                	addw	a5,a5,-1
    80004d9e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004da2:	854a                	mv	a0,s2
    80004da4:	ffffe097          	auipc	ra,0xffffe
    80004da8:	fc6080e7          	jalr	-58(ra) # 80002d6a <iupdate>
  iunlockput(ip);
    80004dac:	854a                	mv	a0,s2
    80004dae:	ffffe097          	auipc	ra,0xffffe
    80004db2:	2ee080e7          	jalr	750(ra) # 8000309c <iunlockput>
  end_op();
    80004db6:	fffff097          	auipc	ra,0xfffff
    80004dba:	ac8080e7          	jalr	-1336(ra) # 8000387e <end_op>
  return 0;
    80004dbe:	4501                	li	a0,0
    80004dc0:	64ee                	ld	s1,216(sp)
    80004dc2:	694e                	ld	s2,208(sp)
    80004dc4:	a84d                	j	80004e76 <sys_unlink+0x1c6>
    end_op();
    80004dc6:	fffff097          	auipc	ra,0xfffff
    80004dca:	ab8080e7          	jalr	-1352(ra) # 8000387e <end_op>
    return -1;
    80004dce:	557d                	li	a0,-1
    80004dd0:	64ee                	ld	s1,216(sp)
    80004dd2:	a055                	j	80004e76 <sys_unlink+0x1c6>
    80004dd4:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004dd6:	00004517          	auipc	a0,0x4
    80004dda:	8b250513          	add	a0,a0,-1870 # 80008688 <etext+0x688>
    80004dde:	00001097          	auipc	ra,0x1
    80004de2:	244080e7          	jalr	580(ra) # 80006022 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004de6:	04c92703          	lw	a4,76(s2)
    80004dea:	02000793          	li	a5,32
    80004dee:	f6e7f5e3          	bgeu	a5,a4,80004d58 <sys_unlink+0xa8>
    80004df2:	e5ce                	sd	s3,200(sp)
    80004df4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004df8:	4741                	li	a4,16
    80004dfa:	86ce                	mv	a3,s3
    80004dfc:	f1840613          	add	a2,s0,-232
    80004e00:	4581                	li	a1,0
    80004e02:	854a                	mv	a0,s2
    80004e04:	ffffe097          	auipc	ra,0xffffe
    80004e08:	2ea080e7          	jalr	746(ra) # 800030ee <readi>
    80004e0c:	47c1                	li	a5,16
    80004e0e:	00f51c63          	bne	a0,a5,80004e26 <sys_unlink+0x176>
    if(de.inum != 0)
    80004e12:	f1845783          	lhu	a5,-232(s0)
    80004e16:	e7b5                	bnez	a5,80004e82 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e18:	29c1                	addw	s3,s3,16
    80004e1a:	04c92783          	lw	a5,76(s2)
    80004e1e:	fcf9ede3          	bltu	s3,a5,80004df8 <sys_unlink+0x148>
    80004e22:	69ae                	ld	s3,200(sp)
    80004e24:	bf15                	j	80004d58 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004e26:	00004517          	auipc	a0,0x4
    80004e2a:	87a50513          	add	a0,a0,-1926 # 800086a0 <etext+0x6a0>
    80004e2e:	00001097          	auipc	ra,0x1
    80004e32:	1f4080e7          	jalr	500(ra) # 80006022 <panic>
    80004e36:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004e38:	00004517          	auipc	a0,0x4
    80004e3c:	88050513          	add	a0,a0,-1920 # 800086b8 <etext+0x6b8>
    80004e40:	00001097          	auipc	ra,0x1
    80004e44:	1e2080e7          	jalr	482(ra) # 80006022 <panic>
    dp->nlink--;
    80004e48:	04a4d783          	lhu	a5,74(s1)
    80004e4c:	37fd                	addw	a5,a5,-1
    80004e4e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004e52:	8526                	mv	a0,s1
    80004e54:	ffffe097          	auipc	ra,0xffffe
    80004e58:	f16080e7          	jalr	-234(ra) # 80002d6a <iupdate>
    80004e5c:	bf0d                	j	80004d8e <sys_unlink+0xde>
    80004e5e:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004e60:	8526                	mv	a0,s1
    80004e62:	ffffe097          	auipc	ra,0xffffe
    80004e66:	23a080e7          	jalr	570(ra) # 8000309c <iunlockput>
  end_op();
    80004e6a:	fffff097          	auipc	ra,0xfffff
    80004e6e:	a14080e7          	jalr	-1516(ra) # 8000387e <end_op>
  return -1;
    80004e72:	557d                	li	a0,-1
    80004e74:	64ee                	ld	s1,216(sp)
}
    80004e76:	70ae                	ld	ra,232(sp)
    80004e78:	740e                	ld	s0,224(sp)
    80004e7a:	616d                	add	sp,sp,240
    80004e7c:	8082                	ret
    return -1;
    80004e7e:	557d                	li	a0,-1
    80004e80:	bfdd                	j	80004e76 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004e82:	854a                	mv	a0,s2
    80004e84:	ffffe097          	auipc	ra,0xffffe
    80004e88:	218080e7          	jalr	536(ra) # 8000309c <iunlockput>
    goto bad;
    80004e8c:	694e                	ld	s2,208(sp)
    80004e8e:	69ae                	ld	s3,200(sp)
    80004e90:	bfc1                	j	80004e60 <sys_unlink+0x1b0>

0000000080004e92 <sys_open>:

uint64
sys_open(void)
{
    80004e92:	7131                	add	sp,sp,-192
    80004e94:	fd06                	sd	ra,184(sp)
    80004e96:	f922                	sd	s0,176(sp)
    80004e98:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004e9a:	f4c40593          	add	a1,s0,-180
    80004e9e:	4505                	li	a0,1
    80004ea0:	ffffd097          	auipc	ra,0xffffd
    80004ea4:	2f6080e7          	jalr	758(ra) # 80002196 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ea8:	08000613          	li	a2,128
    80004eac:	f5040593          	add	a1,s0,-176
    80004eb0:	4501                	li	a0,0
    80004eb2:	ffffd097          	auipc	ra,0xffffd
    80004eb6:	324080e7          	jalr	804(ra) # 800021d6 <argstr>
    80004eba:	87aa                	mv	a5,a0
    return -1;
    80004ebc:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ebe:	0a07ce63          	bltz	a5,80004f7a <sys_open+0xe8>
    80004ec2:	f526                	sd	s1,168(sp)

  begin_op();
    80004ec4:	fffff097          	auipc	ra,0xfffff
    80004ec8:	940080e7          	jalr	-1728(ra) # 80003804 <begin_op>

  if(omode & O_CREATE){
    80004ecc:	f4c42783          	lw	a5,-180(s0)
    80004ed0:	2007f793          	and	a5,a5,512
    80004ed4:	cfd5                	beqz	a5,80004f90 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ed6:	4681                	li	a3,0
    80004ed8:	4601                	li	a2,0
    80004eda:	4589                	li	a1,2
    80004edc:	f5040513          	add	a0,s0,-176
    80004ee0:	00000097          	auipc	ra,0x0
    80004ee4:	95c080e7          	jalr	-1700(ra) # 8000483c <create>
    80004ee8:	84aa                	mv	s1,a0
    if(ip == 0){
    80004eea:	cd41                	beqz	a0,80004f82 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004eec:	04449703          	lh	a4,68(s1)
    80004ef0:	478d                	li	a5,3
    80004ef2:	00f71763          	bne	a4,a5,80004f00 <sys_open+0x6e>
    80004ef6:	0464d703          	lhu	a4,70(s1)
    80004efa:	47a5                	li	a5,9
    80004efc:	0ee7e163          	bltu	a5,a4,80004fde <sys_open+0x14c>
    80004f00:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004f02:	fffff097          	auipc	ra,0xfffff
    80004f06:	d10080e7          	jalr	-752(ra) # 80003c12 <filealloc>
    80004f0a:	892a                	mv	s2,a0
    80004f0c:	c97d                	beqz	a0,80005002 <sys_open+0x170>
    80004f0e:	ed4e                	sd	s3,152(sp)
    80004f10:	00000097          	auipc	ra,0x0
    80004f14:	8ea080e7          	jalr	-1814(ra) # 800047fa <fdalloc>
    80004f18:	89aa                	mv	s3,a0
    80004f1a:	0c054e63          	bltz	a0,80004ff6 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004f1e:	04449703          	lh	a4,68(s1)
    80004f22:	478d                	li	a5,3
    80004f24:	0ef70c63          	beq	a4,a5,8000501c <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004f28:	4789                	li	a5,2
    80004f2a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004f2e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004f32:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004f36:	f4c42783          	lw	a5,-180(s0)
    80004f3a:	0017c713          	xor	a4,a5,1
    80004f3e:	8b05                	and	a4,a4,1
    80004f40:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f44:	0037f713          	and	a4,a5,3
    80004f48:	00e03733          	snez	a4,a4
    80004f4c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004f50:	4007f793          	and	a5,a5,1024
    80004f54:	c791                	beqz	a5,80004f60 <sys_open+0xce>
    80004f56:	04449703          	lh	a4,68(s1)
    80004f5a:	4789                	li	a5,2
    80004f5c:	0cf70763          	beq	a4,a5,8000502a <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004f60:	8526                	mv	a0,s1
    80004f62:	ffffe097          	auipc	ra,0xffffe
    80004f66:	f9a080e7          	jalr	-102(ra) # 80002efc <iunlock>
  end_op();
    80004f6a:	fffff097          	auipc	ra,0xfffff
    80004f6e:	914080e7          	jalr	-1772(ra) # 8000387e <end_op>

  return fd;
    80004f72:	854e                	mv	a0,s3
    80004f74:	74aa                	ld	s1,168(sp)
    80004f76:	790a                	ld	s2,160(sp)
    80004f78:	69ea                	ld	s3,152(sp)
}
    80004f7a:	70ea                	ld	ra,184(sp)
    80004f7c:	744a                	ld	s0,176(sp)
    80004f7e:	6129                	add	sp,sp,192
    80004f80:	8082                	ret
      end_op();
    80004f82:	fffff097          	auipc	ra,0xfffff
    80004f86:	8fc080e7          	jalr	-1796(ra) # 8000387e <end_op>
      return -1;
    80004f8a:	557d                	li	a0,-1
    80004f8c:	74aa                	ld	s1,168(sp)
    80004f8e:	b7f5                	j	80004f7a <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80004f90:	f5040513          	add	a0,s0,-176
    80004f94:	ffffe097          	auipc	ra,0xffffe
    80004f98:	670080e7          	jalr	1648(ra) # 80003604 <namei>
    80004f9c:	84aa                	mv	s1,a0
    80004f9e:	c90d                	beqz	a0,80004fd0 <sys_open+0x13e>
    ilock(ip);
    80004fa0:	ffffe097          	auipc	ra,0xffffe
    80004fa4:	e96080e7          	jalr	-362(ra) # 80002e36 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004fa8:	04449703          	lh	a4,68(s1)
    80004fac:	4785                	li	a5,1
    80004fae:	f2f71fe3          	bne	a4,a5,80004eec <sys_open+0x5a>
    80004fb2:	f4c42783          	lw	a5,-180(s0)
    80004fb6:	d7a9                	beqz	a5,80004f00 <sys_open+0x6e>
      iunlockput(ip);
    80004fb8:	8526                	mv	a0,s1
    80004fba:	ffffe097          	auipc	ra,0xffffe
    80004fbe:	0e2080e7          	jalr	226(ra) # 8000309c <iunlockput>
      end_op();
    80004fc2:	fffff097          	auipc	ra,0xfffff
    80004fc6:	8bc080e7          	jalr	-1860(ra) # 8000387e <end_op>
      return -1;
    80004fca:	557d                	li	a0,-1
    80004fcc:	74aa                	ld	s1,168(sp)
    80004fce:	b775                	j	80004f7a <sys_open+0xe8>
      end_op();
    80004fd0:	fffff097          	auipc	ra,0xfffff
    80004fd4:	8ae080e7          	jalr	-1874(ra) # 8000387e <end_op>
      return -1;
    80004fd8:	557d                	li	a0,-1
    80004fda:	74aa                	ld	s1,168(sp)
    80004fdc:	bf79                	j	80004f7a <sys_open+0xe8>
    iunlockput(ip);
    80004fde:	8526                	mv	a0,s1
    80004fe0:	ffffe097          	auipc	ra,0xffffe
    80004fe4:	0bc080e7          	jalr	188(ra) # 8000309c <iunlockput>
    end_op();
    80004fe8:	fffff097          	auipc	ra,0xfffff
    80004fec:	896080e7          	jalr	-1898(ra) # 8000387e <end_op>
    return -1;
    80004ff0:	557d                	li	a0,-1
    80004ff2:	74aa                	ld	s1,168(sp)
    80004ff4:	b759                	j	80004f7a <sys_open+0xe8>
      fileclose(f);
    80004ff6:	854a                	mv	a0,s2
    80004ff8:	fffff097          	auipc	ra,0xfffff
    80004ffc:	cd6080e7          	jalr	-810(ra) # 80003cce <fileclose>
    80005000:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005002:	8526                	mv	a0,s1
    80005004:	ffffe097          	auipc	ra,0xffffe
    80005008:	098080e7          	jalr	152(ra) # 8000309c <iunlockput>
    end_op();
    8000500c:	fffff097          	auipc	ra,0xfffff
    80005010:	872080e7          	jalr	-1934(ra) # 8000387e <end_op>
    return -1;
    80005014:	557d                	li	a0,-1
    80005016:	74aa                	ld	s1,168(sp)
    80005018:	790a                	ld	s2,160(sp)
    8000501a:	b785                	j	80004f7a <sys_open+0xe8>
    f->type = FD_DEVICE;
    8000501c:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005020:	04649783          	lh	a5,70(s1)
    80005024:	02f91223          	sh	a5,36(s2)
    80005028:	b729                	j	80004f32 <sys_open+0xa0>
    itrunc(ip);
    8000502a:	8526                	mv	a0,s1
    8000502c:	ffffe097          	auipc	ra,0xffffe
    80005030:	f1c080e7          	jalr	-228(ra) # 80002f48 <itrunc>
    80005034:	b735                	j	80004f60 <sys_open+0xce>

0000000080005036 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005036:	7175                	add	sp,sp,-144
    80005038:	e506                	sd	ra,136(sp)
    8000503a:	e122                	sd	s0,128(sp)
    8000503c:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000503e:	ffffe097          	auipc	ra,0xffffe
    80005042:	7c6080e7          	jalr	1990(ra) # 80003804 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005046:	08000613          	li	a2,128
    8000504a:	f7040593          	add	a1,s0,-144
    8000504e:	4501                	li	a0,0
    80005050:	ffffd097          	auipc	ra,0xffffd
    80005054:	186080e7          	jalr	390(ra) # 800021d6 <argstr>
    80005058:	02054963          	bltz	a0,8000508a <sys_mkdir+0x54>
    8000505c:	4681                	li	a3,0
    8000505e:	4601                	li	a2,0
    80005060:	4585                	li	a1,1
    80005062:	f7040513          	add	a0,s0,-144
    80005066:	fffff097          	auipc	ra,0xfffff
    8000506a:	7d6080e7          	jalr	2006(ra) # 8000483c <create>
    8000506e:	cd11                	beqz	a0,8000508a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005070:	ffffe097          	auipc	ra,0xffffe
    80005074:	02c080e7          	jalr	44(ra) # 8000309c <iunlockput>
  end_op();
    80005078:	fffff097          	auipc	ra,0xfffff
    8000507c:	806080e7          	jalr	-2042(ra) # 8000387e <end_op>
  return 0;
    80005080:	4501                	li	a0,0
}
    80005082:	60aa                	ld	ra,136(sp)
    80005084:	640a                	ld	s0,128(sp)
    80005086:	6149                	add	sp,sp,144
    80005088:	8082                	ret
    end_op();
    8000508a:	ffffe097          	auipc	ra,0xffffe
    8000508e:	7f4080e7          	jalr	2036(ra) # 8000387e <end_op>
    return -1;
    80005092:	557d                	li	a0,-1
    80005094:	b7fd                	j	80005082 <sys_mkdir+0x4c>

0000000080005096 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005096:	7135                	add	sp,sp,-160
    80005098:	ed06                	sd	ra,152(sp)
    8000509a:	e922                	sd	s0,144(sp)
    8000509c:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000509e:	ffffe097          	auipc	ra,0xffffe
    800050a2:	766080e7          	jalr	1894(ra) # 80003804 <begin_op>
  argint(1, &major);
    800050a6:	f6c40593          	add	a1,s0,-148
    800050aa:	4505                	li	a0,1
    800050ac:	ffffd097          	auipc	ra,0xffffd
    800050b0:	0ea080e7          	jalr	234(ra) # 80002196 <argint>
  argint(2, &minor);
    800050b4:	f6840593          	add	a1,s0,-152
    800050b8:	4509                	li	a0,2
    800050ba:	ffffd097          	auipc	ra,0xffffd
    800050be:	0dc080e7          	jalr	220(ra) # 80002196 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800050c2:	08000613          	li	a2,128
    800050c6:	f7040593          	add	a1,s0,-144
    800050ca:	4501                	li	a0,0
    800050cc:	ffffd097          	auipc	ra,0xffffd
    800050d0:	10a080e7          	jalr	266(ra) # 800021d6 <argstr>
    800050d4:	02054b63          	bltz	a0,8000510a <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800050d8:	f6841683          	lh	a3,-152(s0)
    800050dc:	f6c41603          	lh	a2,-148(s0)
    800050e0:	458d                	li	a1,3
    800050e2:	f7040513          	add	a0,s0,-144
    800050e6:	fffff097          	auipc	ra,0xfffff
    800050ea:	756080e7          	jalr	1878(ra) # 8000483c <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800050ee:	cd11                	beqz	a0,8000510a <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050f0:	ffffe097          	auipc	ra,0xffffe
    800050f4:	fac080e7          	jalr	-84(ra) # 8000309c <iunlockput>
  end_op();
    800050f8:	ffffe097          	auipc	ra,0xffffe
    800050fc:	786080e7          	jalr	1926(ra) # 8000387e <end_op>
  return 0;
    80005100:	4501                	li	a0,0
}
    80005102:	60ea                	ld	ra,152(sp)
    80005104:	644a                	ld	s0,144(sp)
    80005106:	610d                	add	sp,sp,160
    80005108:	8082                	ret
    end_op();
    8000510a:	ffffe097          	auipc	ra,0xffffe
    8000510e:	774080e7          	jalr	1908(ra) # 8000387e <end_op>
    return -1;
    80005112:	557d                	li	a0,-1
    80005114:	b7fd                	j	80005102 <sys_mknod+0x6c>

0000000080005116 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005116:	7135                	add	sp,sp,-160
    80005118:	ed06                	sd	ra,152(sp)
    8000511a:	e922                	sd	s0,144(sp)
    8000511c:	e14a                	sd	s2,128(sp)
    8000511e:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005120:	ffffc097          	auipc	ra,0xffffc
    80005124:	ece080e7          	jalr	-306(ra) # 80000fee <myproc>
    80005128:	892a                	mv	s2,a0
  
  begin_op();
    8000512a:	ffffe097          	auipc	ra,0xffffe
    8000512e:	6da080e7          	jalr	1754(ra) # 80003804 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005132:	08000613          	li	a2,128
    80005136:	f6040593          	add	a1,s0,-160
    8000513a:	4501                	li	a0,0
    8000513c:	ffffd097          	auipc	ra,0xffffd
    80005140:	09a080e7          	jalr	154(ra) # 800021d6 <argstr>
    80005144:	04054d63          	bltz	a0,8000519e <sys_chdir+0x88>
    80005148:	e526                	sd	s1,136(sp)
    8000514a:	f6040513          	add	a0,s0,-160
    8000514e:	ffffe097          	auipc	ra,0xffffe
    80005152:	4b6080e7          	jalr	1206(ra) # 80003604 <namei>
    80005156:	84aa                	mv	s1,a0
    80005158:	c131                	beqz	a0,8000519c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000515a:	ffffe097          	auipc	ra,0xffffe
    8000515e:	cdc080e7          	jalr	-804(ra) # 80002e36 <ilock>
  if(ip->type != T_DIR){
    80005162:	04449703          	lh	a4,68(s1)
    80005166:	4785                	li	a5,1
    80005168:	04f71163          	bne	a4,a5,800051aa <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000516c:	8526                	mv	a0,s1
    8000516e:	ffffe097          	auipc	ra,0xffffe
    80005172:	d8e080e7          	jalr	-626(ra) # 80002efc <iunlock>
  iput(p->cwd);
    80005176:	15093503          	ld	a0,336(s2)
    8000517a:	ffffe097          	auipc	ra,0xffffe
    8000517e:	e7a080e7          	jalr	-390(ra) # 80002ff4 <iput>
  end_op();
    80005182:	ffffe097          	auipc	ra,0xffffe
    80005186:	6fc080e7          	jalr	1788(ra) # 8000387e <end_op>
  p->cwd = ip;
    8000518a:	14993823          	sd	s1,336(s2)
  return 0;
    8000518e:	4501                	li	a0,0
    80005190:	64aa                	ld	s1,136(sp)
}
    80005192:	60ea                	ld	ra,152(sp)
    80005194:	644a                	ld	s0,144(sp)
    80005196:	690a                	ld	s2,128(sp)
    80005198:	610d                	add	sp,sp,160
    8000519a:	8082                	ret
    8000519c:	64aa                	ld	s1,136(sp)
    end_op();
    8000519e:	ffffe097          	auipc	ra,0xffffe
    800051a2:	6e0080e7          	jalr	1760(ra) # 8000387e <end_op>
    return -1;
    800051a6:	557d                	li	a0,-1
    800051a8:	b7ed                	j	80005192 <sys_chdir+0x7c>
    iunlockput(ip);
    800051aa:	8526                	mv	a0,s1
    800051ac:	ffffe097          	auipc	ra,0xffffe
    800051b0:	ef0080e7          	jalr	-272(ra) # 8000309c <iunlockput>
    end_op();
    800051b4:	ffffe097          	auipc	ra,0xffffe
    800051b8:	6ca080e7          	jalr	1738(ra) # 8000387e <end_op>
    return -1;
    800051bc:	557d                	li	a0,-1
    800051be:	64aa                	ld	s1,136(sp)
    800051c0:	bfc9                	j	80005192 <sys_chdir+0x7c>

00000000800051c2 <sys_exec>:

uint64
sys_exec(void)
{
    800051c2:	7121                	add	sp,sp,-448
    800051c4:	ff06                	sd	ra,440(sp)
    800051c6:	fb22                	sd	s0,432(sp)
    800051c8:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800051ca:	e4840593          	add	a1,s0,-440
    800051ce:	4505                	li	a0,1
    800051d0:	ffffd097          	auipc	ra,0xffffd
    800051d4:	fe6080e7          	jalr	-26(ra) # 800021b6 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800051d8:	08000613          	li	a2,128
    800051dc:	f5040593          	add	a1,s0,-176
    800051e0:	4501                	li	a0,0
    800051e2:	ffffd097          	auipc	ra,0xffffd
    800051e6:	ff4080e7          	jalr	-12(ra) # 800021d6 <argstr>
    800051ea:	87aa                	mv	a5,a0
    return -1;
    800051ec:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800051ee:	0e07c263          	bltz	a5,800052d2 <sys_exec+0x110>
    800051f2:	f726                	sd	s1,424(sp)
    800051f4:	f34a                	sd	s2,416(sp)
    800051f6:	ef4e                	sd	s3,408(sp)
    800051f8:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800051fa:	10000613          	li	a2,256
    800051fe:	4581                	li	a1,0
    80005200:	e5040513          	add	a0,s0,-432
    80005204:	ffffb097          	auipc	ra,0xffffb
    80005208:	f76080e7          	jalr	-138(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000520c:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005210:	89a6                	mv	s3,s1
    80005212:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005214:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005218:	00391513          	sll	a0,s2,0x3
    8000521c:	e4040593          	add	a1,s0,-448
    80005220:	e4843783          	ld	a5,-440(s0)
    80005224:	953e                	add	a0,a0,a5
    80005226:	ffffd097          	auipc	ra,0xffffd
    8000522a:	ed2080e7          	jalr	-302(ra) # 800020f8 <fetchaddr>
    8000522e:	02054a63          	bltz	a0,80005262 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005232:	e4043783          	ld	a5,-448(s0)
    80005236:	c7b9                	beqz	a5,80005284 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005238:	ffffb097          	auipc	ra,0xffffb
    8000523c:	ee2080e7          	jalr	-286(ra) # 8000011a <kalloc>
    80005240:	85aa                	mv	a1,a0
    80005242:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005246:	cd11                	beqz	a0,80005262 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005248:	6605                	lui	a2,0x1
    8000524a:	e4043503          	ld	a0,-448(s0)
    8000524e:	ffffd097          	auipc	ra,0xffffd
    80005252:	efc080e7          	jalr	-260(ra) # 8000214a <fetchstr>
    80005256:	00054663          	bltz	a0,80005262 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    8000525a:	0905                	add	s2,s2,1
    8000525c:	09a1                	add	s3,s3,8
    8000525e:	fb491de3          	bne	s2,s4,80005218 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005262:	f5040913          	add	s2,s0,-176
    80005266:	6088                	ld	a0,0(s1)
    80005268:	c125                	beqz	a0,800052c8 <sys_exec+0x106>
    kfree(argv[i]);
    8000526a:	ffffb097          	auipc	ra,0xffffb
    8000526e:	db2080e7          	jalr	-590(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005272:	04a1                	add	s1,s1,8
    80005274:	ff2499e3          	bne	s1,s2,80005266 <sys_exec+0xa4>
  return -1;
    80005278:	557d                	li	a0,-1
    8000527a:	74ba                	ld	s1,424(sp)
    8000527c:	791a                	ld	s2,416(sp)
    8000527e:	69fa                	ld	s3,408(sp)
    80005280:	6a5a                	ld	s4,400(sp)
    80005282:	a881                	j	800052d2 <sys_exec+0x110>
      argv[i] = 0;
    80005284:	0009079b          	sext.w	a5,s2
    80005288:	078e                	sll	a5,a5,0x3
    8000528a:	fd078793          	add	a5,a5,-48
    8000528e:	97a2                	add	a5,a5,s0
    80005290:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005294:	e5040593          	add	a1,s0,-432
    80005298:	f5040513          	add	a0,s0,-176
    8000529c:	fffff097          	auipc	ra,0xfffff
    800052a0:	108080e7          	jalr	264(ra) # 800043a4 <exec>
    800052a4:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052a6:	f5040993          	add	s3,s0,-176
    800052aa:	6088                	ld	a0,0(s1)
    800052ac:	c901                	beqz	a0,800052bc <sys_exec+0xfa>
    kfree(argv[i]);
    800052ae:	ffffb097          	auipc	ra,0xffffb
    800052b2:	d6e080e7          	jalr	-658(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052b6:	04a1                	add	s1,s1,8
    800052b8:	ff3499e3          	bne	s1,s3,800052aa <sys_exec+0xe8>
  return ret;
    800052bc:	854a                	mv	a0,s2
    800052be:	74ba                	ld	s1,424(sp)
    800052c0:	791a                	ld	s2,416(sp)
    800052c2:	69fa                	ld	s3,408(sp)
    800052c4:	6a5a                	ld	s4,400(sp)
    800052c6:	a031                	j	800052d2 <sys_exec+0x110>
  return -1;
    800052c8:	557d                	li	a0,-1
    800052ca:	74ba                	ld	s1,424(sp)
    800052cc:	791a                	ld	s2,416(sp)
    800052ce:	69fa                	ld	s3,408(sp)
    800052d0:	6a5a                	ld	s4,400(sp)
}
    800052d2:	70fa                	ld	ra,440(sp)
    800052d4:	745a                	ld	s0,432(sp)
    800052d6:	6139                	add	sp,sp,448
    800052d8:	8082                	ret

00000000800052da <sys_pipe>:

uint64
sys_pipe(void)
{
    800052da:	7139                	add	sp,sp,-64
    800052dc:	fc06                	sd	ra,56(sp)
    800052de:	f822                	sd	s0,48(sp)
    800052e0:	f426                	sd	s1,40(sp)
    800052e2:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800052e4:	ffffc097          	auipc	ra,0xffffc
    800052e8:	d0a080e7          	jalr	-758(ra) # 80000fee <myproc>
    800052ec:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800052ee:	fd840593          	add	a1,s0,-40
    800052f2:	4501                	li	a0,0
    800052f4:	ffffd097          	auipc	ra,0xffffd
    800052f8:	ec2080e7          	jalr	-318(ra) # 800021b6 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800052fc:	fc840593          	add	a1,s0,-56
    80005300:	fd040513          	add	a0,s0,-48
    80005304:	fffff097          	auipc	ra,0xfffff
    80005308:	d38080e7          	jalr	-712(ra) # 8000403c <pipealloc>
    return -1;
    8000530c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000530e:	0c054463          	bltz	a0,800053d6 <sys_pipe+0xfc>
  fd0 = -1;
    80005312:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005316:	fd043503          	ld	a0,-48(s0)
    8000531a:	fffff097          	auipc	ra,0xfffff
    8000531e:	4e0080e7          	jalr	1248(ra) # 800047fa <fdalloc>
    80005322:	fca42223          	sw	a0,-60(s0)
    80005326:	08054b63          	bltz	a0,800053bc <sys_pipe+0xe2>
    8000532a:	fc843503          	ld	a0,-56(s0)
    8000532e:	fffff097          	auipc	ra,0xfffff
    80005332:	4cc080e7          	jalr	1228(ra) # 800047fa <fdalloc>
    80005336:	fca42023          	sw	a0,-64(s0)
    8000533a:	06054863          	bltz	a0,800053aa <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000533e:	4691                	li	a3,4
    80005340:	fc440613          	add	a2,s0,-60
    80005344:	fd843583          	ld	a1,-40(s0)
    80005348:	68a8                	ld	a0,80(s1)
    8000534a:	ffffc097          	auipc	ra,0xffffc
    8000534e:	8ee080e7          	jalr	-1810(ra) # 80000c38 <copyout>
    80005352:	02054063          	bltz	a0,80005372 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005356:	4691                	li	a3,4
    80005358:	fc040613          	add	a2,s0,-64
    8000535c:	fd843583          	ld	a1,-40(s0)
    80005360:	0591                	add	a1,a1,4
    80005362:	68a8                	ld	a0,80(s1)
    80005364:	ffffc097          	auipc	ra,0xffffc
    80005368:	8d4080e7          	jalr	-1836(ra) # 80000c38 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000536c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000536e:	06055463          	bgez	a0,800053d6 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005372:	fc442783          	lw	a5,-60(s0)
    80005376:	07e9                	add	a5,a5,26
    80005378:	078e                	sll	a5,a5,0x3
    8000537a:	97a6                	add	a5,a5,s1
    8000537c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005380:	fc042783          	lw	a5,-64(s0)
    80005384:	07e9                	add	a5,a5,26
    80005386:	078e                	sll	a5,a5,0x3
    80005388:	94be                	add	s1,s1,a5
    8000538a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000538e:	fd043503          	ld	a0,-48(s0)
    80005392:	fffff097          	auipc	ra,0xfffff
    80005396:	93c080e7          	jalr	-1732(ra) # 80003cce <fileclose>
    fileclose(wf);
    8000539a:	fc843503          	ld	a0,-56(s0)
    8000539e:	fffff097          	auipc	ra,0xfffff
    800053a2:	930080e7          	jalr	-1744(ra) # 80003cce <fileclose>
    return -1;
    800053a6:	57fd                	li	a5,-1
    800053a8:	a03d                	j	800053d6 <sys_pipe+0xfc>
    if(fd0 >= 0)
    800053aa:	fc442783          	lw	a5,-60(s0)
    800053ae:	0007c763          	bltz	a5,800053bc <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800053b2:	07e9                	add	a5,a5,26
    800053b4:	078e                	sll	a5,a5,0x3
    800053b6:	97a6                	add	a5,a5,s1
    800053b8:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800053bc:	fd043503          	ld	a0,-48(s0)
    800053c0:	fffff097          	auipc	ra,0xfffff
    800053c4:	90e080e7          	jalr	-1778(ra) # 80003cce <fileclose>
    fileclose(wf);
    800053c8:	fc843503          	ld	a0,-56(s0)
    800053cc:	fffff097          	auipc	ra,0xfffff
    800053d0:	902080e7          	jalr	-1790(ra) # 80003cce <fileclose>
    return -1;
    800053d4:	57fd                	li	a5,-1
}
    800053d6:	853e                	mv	a0,a5
    800053d8:	70e2                	ld	ra,56(sp)
    800053da:	7442                	ld	s0,48(sp)
    800053dc:	74a2                	ld	s1,40(sp)
    800053de:	6121                	add	sp,sp,64
    800053e0:	8082                	ret
	...

00000000800053f0 <kernelvec>:
    800053f0:	7111                	add	sp,sp,-256
    800053f2:	e006                	sd	ra,0(sp)
    800053f4:	e40a                	sd	sp,8(sp)
    800053f6:	e80e                	sd	gp,16(sp)
    800053f8:	ec12                	sd	tp,24(sp)
    800053fa:	f016                	sd	t0,32(sp)
    800053fc:	f41a                	sd	t1,40(sp)
    800053fe:	f81e                	sd	t2,48(sp)
    80005400:	fc22                	sd	s0,56(sp)
    80005402:	e0a6                	sd	s1,64(sp)
    80005404:	e4aa                	sd	a0,72(sp)
    80005406:	e8ae                	sd	a1,80(sp)
    80005408:	ecb2                	sd	a2,88(sp)
    8000540a:	f0b6                	sd	a3,96(sp)
    8000540c:	f4ba                	sd	a4,104(sp)
    8000540e:	f8be                	sd	a5,112(sp)
    80005410:	fcc2                	sd	a6,120(sp)
    80005412:	e146                	sd	a7,128(sp)
    80005414:	e54a                	sd	s2,136(sp)
    80005416:	e94e                	sd	s3,144(sp)
    80005418:	ed52                	sd	s4,152(sp)
    8000541a:	f156                	sd	s5,160(sp)
    8000541c:	f55a                	sd	s6,168(sp)
    8000541e:	f95e                	sd	s7,176(sp)
    80005420:	fd62                	sd	s8,184(sp)
    80005422:	e1e6                	sd	s9,192(sp)
    80005424:	e5ea                	sd	s10,200(sp)
    80005426:	e9ee                	sd	s11,208(sp)
    80005428:	edf2                	sd	t3,216(sp)
    8000542a:	f1f6                	sd	t4,224(sp)
    8000542c:	f5fa                	sd	t5,232(sp)
    8000542e:	f9fe                	sd	t6,240(sp)
    80005430:	b95fc0ef          	jal	80001fc4 <kerneltrap>
    80005434:	6082                	ld	ra,0(sp)
    80005436:	6122                	ld	sp,8(sp)
    80005438:	61c2                	ld	gp,16(sp)
    8000543a:	7282                	ld	t0,32(sp)
    8000543c:	7322                	ld	t1,40(sp)
    8000543e:	73c2                	ld	t2,48(sp)
    80005440:	7462                	ld	s0,56(sp)
    80005442:	6486                	ld	s1,64(sp)
    80005444:	6526                	ld	a0,72(sp)
    80005446:	65c6                	ld	a1,80(sp)
    80005448:	6666                	ld	a2,88(sp)
    8000544a:	7686                	ld	a3,96(sp)
    8000544c:	7726                	ld	a4,104(sp)
    8000544e:	77c6                	ld	a5,112(sp)
    80005450:	7866                	ld	a6,120(sp)
    80005452:	688a                	ld	a7,128(sp)
    80005454:	692a                	ld	s2,136(sp)
    80005456:	69ca                	ld	s3,144(sp)
    80005458:	6a6a                	ld	s4,152(sp)
    8000545a:	7a8a                	ld	s5,160(sp)
    8000545c:	7b2a                	ld	s6,168(sp)
    8000545e:	7bca                	ld	s7,176(sp)
    80005460:	7c6a                	ld	s8,184(sp)
    80005462:	6c8e                	ld	s9,192(sp)
    80005464:	6d2e                	ld	s10,200(sp)
    80005466:	6dce                	ld	s11,208(sp)
    80005468:	6e6e                	ld	t3,216(sp)
    8000546a:	7e8e                	ld	t4,224(sp)
    8000546c:	7f2e                	ld	t5,232(sp)
    8000546e:	7fce                	ld	t6,240(sp)
    80005470:	6111                	add	sp,sp,256
    80005472:	10200073          	sret
    80005476:	00000013          	nop
    8000547a:	00000013          	nop
    8000547e:	0001                	nop

0000000080005480 <timervec>:
    80005480:	34051573          	csrrw	a0,mscratch,a0
    80005484:	e10c                	sd	a1,0(a0)
    80005486:	e510                	sd	a2,8(a0)
    80005488:	e914                	sd	a3,16(a0)
    8000548a:	6d0c                	ld	a1,24(a0)
    8000548c:	7110                	ld	a2,32(a0)
    8000548e:	6194                	ld	a3,0(a1)
    80005490:	96b2                	add	a3,a3,a2
    80005492:	e194                	sd	a3,0(a1)
    80005494:	4589                	li	a1,2
    80005496:	14459073          	csrw	sip,a1
    8000549a:	6914                	ld	a3,16(a0)
    8000549c:	6510                	ld	a2,8(a0)
    8000549e:	610c                	ld	a1,0(a0)
    800054a0:	34051573          	csrrw	a0,mscratch,a0
    800054a4:	30200073          	mret
	...

00000000800054aa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800054aa:	1141                	add	sp,sp,-16
    800054ac:	e422                	sd	s0,8(sp)
    800054ae:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800054b0:	0c0007b7          	lui	a5,0xc000
    800054b4:	4705                	li	a4,1
    800054b6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800054b8:	0c0007b7          	lui	a5,0xc000
    800054bc:	c3d8                	sw	a4,4(a5)
}
    800054be:	6422                	ld	s0,8(sp)
    800054c0:	0141                	add	sp,sp,16
    800054c2:	8082                	ret

00000000800054c4 <plicinithart>:

void
plicinithart(void)
{
    800054c4:	1141                	add	sp,sp,-16
    800054c6:	e406                	sd	ra,8(sp)
    800054c8:	e022                	sd	s0,0(sp)
    800054ca:	0800                	add	s0,sp,16
  int hart = cpuid();
    800054cc:	ffffc097          	auipc	ra,0xffffc
    800054d0:	af6080e7          	jalr	-1290(ra) # 80000fc2 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800054d4:	0085171b          	sllw	a4,a0,0x8
    800054d8:	0c0027b7          	lui	a5,0xc002
    800054dc:	97ba                	add	a5,a5,a4
    800054de:	40200713          	li	a4,1026
    800054e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800054e6:	00d5151b          	sllw	a0,a0,0xd
    800054ea:	0c2017b7          	lui	a5,0xc201
    800054ee:	97aa                	add	a5,a5,a0
    800054f0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800054f4:	60a2                	ld	ra,8(sp)
    800054f6:	6402                	ld	s0,0(sp)
    800054f8:	0141                	add	sp,sp,16
    800054fa:	8082                	ret

00000000800054fc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800054fc:	1141                	add	sp,sp,-16
    800054fe:	e406                	sd	ra,8(sp)
    80005500:	e022                	sd	s0,0(sp)
    80005502:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005504:	ffffc097          	auipc	ra,0xffffc
    80005508:	abe080e7          	jalr	-1346(ra) # 80000fc2 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000550c:	00d5151b          	sllw	a0,a0,0xd
    80005510:	0c2017b7          	lui	a5,0xc201
    80005514:	97aa                	add	a5,a5,a0
  return irq;
}
    80005516:	43c8                	lw	a0,4(a5)
    80005518:	60a2                	ld	ra,8(sp)
    8000551a:	6402                	ld	s0,0(sp)
    8000551c:	0141                	add	sp,sp,16
    8000551e:	8082                	ret

0000000080005520 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005520:	1101                	add	sp,sp,-32
    80005522:	ec06                	sd	ra,24(sp)
    80005524:	e822                	sd	s0,16(sp)
    80005526:	e426                	sd	s1,8(sp)
    80005528:	1000                	add	s0,sp,32
    8000552a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000552c:	ffffc097          	auipc	ra,0xffffc
    80005530:	a96080e7          	jalr	-1386(ra) # 80000fc2 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005534:	00d5151b          	sllw	a0,a0,0xd
    80005538:	0c2017b7          	lui	a5,0xc201
    8000553c:	97aa                	add	a5,a5,a0
    8000553e:	c3c4                	sw	s1,4(a5)
}
    80005540:	60e2                	ld	ra,24(sp)
    80005542:	6442                	ld	s0,16(sp)
    80005544:	64a2                	ld	s1,8(sp)
    80005546:	6105                	add	sp,sp,32
    80005548:	8082                	ret

000000008000554a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000554a:	1141                	add	sp,sp,-16
    8000554c:	e406                	sd	ra,8(sp)
    8000554e:	e022                	sd	s0,0(sp)
    80005550:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005552:	479d                	li	a5,7
    80005554:	04a7cc63          	blt	a5,a0,800055ac <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005558:	00017797          	auipc	a5,0x17
    8000555c:	f6878793          	add	a5,a5,-152 # 8001c4c0 <disk>
    80005560:	97aa                	add	a5,a5,a0
    80005562:	0187c783          	lbu	a5,24(a5)
    80005566:	ebb9                	bnez	a5,800055bc <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005568:	00451693          	sll	a3,a0,0x4
    8000556c:	00017797          	auipc	a5,0x17
    80005570:	f5478793          	add	a5,a5,-172 # 8001c4c0 <disk>
    80005574:	6398                	ld	a4,0(a5)
    80005576:	9736                	add	a4,a4,a3
    80005578:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000557c:	6398                	ld	a4,0(a5)
    8000557e:	9736                	add	a4,a4,a3
    80005580:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005584:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005588:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000558c:	97aa                	add	a5,a5,a0
    8000558e:	4705                	li	a4,1
    80005590:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005594:	00017517          	auipc	a0,0x17
    80005598:	f4450513          	add	a0,a0,-188 # 8001c4d8 <disk+0x18>
    8000559c:	ffffc097          	auipc	ra,0xffffc
    800055a0:	1e8080e7          	jalr	488(ra) # 80001784 <wakeup>
}
    800055a4:	60a2                	ld	ra,8(sp)
    800055a6:	6402                	ld	s0,0(sp)
    800055a8:	0141                	add	sp,sp,16
    800055aa:	8082                	ret
    panic("free_desc 1");
    800055ac:	00003517          	auipc	a0,0x3
    800055b0:	11c50513          	add	a0,a0,284 # 800086c8 <etext+0x6c8>
    800055b4:	00001097          	auipc	ra,0x1
    800055b8:	a6e080e7          	jalr	-1426(ra) # 80006022 <panic>
    panic("free_desc 2");
    800055bc:	00003517          	auipc	a0,0x3
    800055c0:	11c50513          	add	a0,a0,284 # 800086d8 <etext+0x6d8>
    800055c4:	00001097          	auipc	ra,0x1
    800055c8:	a5e080e7          	jalr	-1442(ra) # 80006022 <panic>

00000000800055cc <virtio_disk_init>:
{
    800055cc:	1101                	add	sp,sp,-32
    800055ce:	ec06                	sd	ra,24(sp)
    800055d0:	e822                	sd	s0,16(sp)
    800055d2:	e426                	sd	s1,8(sp)
    800055d4:	e04a                	sd	s2,0(sp)
    800055d6:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800055d8:	00003597          	auipc	a1,0x3
    800055dc:	11058593          	add	a1,a1,272 # 800086e8 <etext+0x6e8>
    800055e0:	00017517          	auipc	a0,0x17
    800055e4:	00850513          	add	a0,a0,8 # 8001c5e8 <disk+0x128>
    800055e8:	00001097          	auipc	ra,0x1
    800055ec:	f24080e7          	jalr	-220(ra) # 8000650c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055f0:	100017b7          	lui	a5,0x10001
    800055f4:	4398                	lw	a4,0(a5)
    800055f6:	2701                	sext.w	a4,a4
    800055f8:	747277b7          	lui	a5,0x74727
    800055fc:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005600:	18f71c63          	bne	a4,a5,80005798 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005604:	100017b7          	lui	a5,0x10001
    80005608:	0791                	add	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000560a:	439c                	lw	a5,0(a5)
    8000560c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000560e:	4709                	li	a4,2
    80005610:	18e79463          	bne	a5,a4,80005798 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005614:	100017b7          	lui	a5,0x10001
    80005618:	07a1                	add	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000561a:	439c                	lw	a5,0(a5)
    8000561c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000561e:	16e79d63          	bne	a5,a4,80005798 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005622:	100017b7          	lui	a5,0x10001
    80005626:	47d8                	lw	a4,12(a5)
    80005628:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000562a:	554d47b7          	lui	a5,0x554d4
    8000562e:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005632:	16f71363          	bne	a4,a5,80005798 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005636:	100017b7          	lui	a5,0x10001
    8000563a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000563e:	4705                	li	a4,1
    80005640:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005642:	470d                	li	a4,3
    80005644:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005646:	10001737          	lui	a4,0x10001
    8000564a:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000564c:	c7ffe737          	lui	a4,0xc7ffe
    80005650:	75f70713          	add	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9f1f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005654:	8ef9                	and	a3,a3,a4
    80005656:	10001737          	lui	a4,0x10001
    8000565a:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000565c:	472d                	li	a4,11
    8000565e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005660:	07078793          	add	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005664:	439c                	lw	a5,0(a5)
    80005666:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000566a:	8ba1                	and	a5,a5,8
    8000566c:	12078e63          	beqz	a5,800057a8 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005670:	100017b7          	lui	a5,0x10001
    80005674:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005678:	100017b7          	lui	a5,0x10001
    8000567c:	04478793          	add	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005680:	439c                	lw	a5,0(a5)
    80005682:	2781                	sext.w	a5,a5
    80005684:	12079a63          	bnez	a5,800057b8 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005688:	100017b7          	lui	a5,0x10001
    8000568c:	03478793          	add	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005690:	439c                	lw	a5,0(a5)
    80005692:	2781                	sext.w	a5,a5
  if(max == 0)
    80005694:	12078a63          	beqz	a5,800057c8 <virtio_disk_init+0x1fc>
  if(max < NUM)
    80005698:	471d                	li	a4,7
    8000569a:	12f77f63          	bgeu	a4,a5,800057d8 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    8000569e:	ffffb097          	auipc	ra,0xffffb
    800056a2:	a7c080e7          	jalr	-1412(ra) # 8000011a <kalloc>
    800056a6:	00017497          	auipc	s1,0x17
    800056aa:	e1a48493          	add	s1,s1,-486 # 8001c4c0 <disk>
    800056ae:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800056b0:	ffffb097          	auipc	ra,0xffffb
    800056b4:	a6a080e7          	jalr	-1430(ra) # 8000011a <kalloc>
    800056b8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800056ba:	ffffb097          	auipc	ra,0xffffb
    800056be:	a60080e7          	jalr	-1440(ra) # 8000011a <kalloc>
    800056c2:	87aa                	mv	a5,a0
    800056c4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800056c6:	6088                	ld	a0,0(s1)
    800056c8:	12050063          	beqz	a0,800057e8 <virtio_disk_init+0x21c>
    800056cc:	00017717          	auipc	a4,0x17
    800056d0:	dfc73703          	ld	a4,-516(a4) # 8001c4c8 <disk+0x8>
    800056d4:	10070a63          	beqz	a4,800057e8 <virtio_disk_init+0x21c>
    800056d8:	10078863          	beqz	a5,800057e8 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    800056dc:	6605                	lui	a2,0x1
    800056de:	4581                	li	a1,0
    800056e0:	ffffb097          	auipc	ra,0xffffb
    800056e4:	a9a080e7          	jalr	-1382(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    800056e8:	00017497          	auipc	s1,0x17
    800056ec:	dd848493          	add	s1,s1,-552 # 8001c4c0 <disk>
    800056f0:	6605                	lui	a2,0x1
    800056f2:	4581                	li	a1,0
    800056f4:	6488                	ld	a0,8(s1)
    800056f6:	ffffb097          	auipc	ra,0xffffb
    800056fa:	a84080e7          	jalr	-1404(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    800056fe:	6605                	lui	a2,0x1
    80005700:	4581                	li	a1,0
    80005702:	6888                	ld	a0,16(s1)
    80005704:	ffffb097          	auipc	ra,0xffffb
    80005708:	a76080e7          	jalr	-1418(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000570c:	100017b7          	lui	a5,0x10001
    80005710:	4721                	li	a4,8
    80005712:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005714:	4098                	lw	a4,0(s1)
    80005716:	100017b7          	lui	a5,0x10001
    8000571a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000571e:	40d8                	lw	a4,4(s1)
    80005720:	100017b7          	lui	a5,0x10001
    80005724:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005728:	649c                	ld	a5,8(s1)
    8000572a:	0007869b          	sext.w	a3,a5
    8000572e:	10001737          	lui	a4,0x10001
    80005732:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005736:	9781                	sra	a5,a5,0x20
    80005738:	10001737          	lui	a4,0x10001
    8000573c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005740:	689c                	ld	a5,16(s1)
    80005742:	0007869b          	sext.w	a3,a5
    80005746:	10001737          	lui	a4,0x10001
    8000574a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000574e:	9781                	sra	a5,a5,0x20
    80005750:	10001737          	lui	a4,0x10001
    80005754:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005758:	10001737          	lui	a4,0x10001
    8000575c:	4785                	li	a5,1
    8000575e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005760:	00f48c23          	sb	a5,24(s1)
    80005764:	00f48ca3          	sb	a5,25(s1)
    80005768:	00f48d23          	sb	a5,26(s1)
    8000576c:	00f48da3          	sb	a5,27(s1)
    80005770:	00f48e23          	sb	a5,28(s1)
    80005774:	00f48ea3          	sb	a5,29(s1)
    80005778:	00f48f23          	sb	a5,30(s1)
    8000577c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005780:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005784:	100017b7          	lui	a5,0x10001
    80005788:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000578c:	60e2                	ld	ra,24(sp)
    8000578e:	6442                	ld	s0,16(sp)
    80005790:	64a2                	ld	s1,8(sp)
    80005792:	6902                	ld	s2,0(sp)
    80005794:	6105                	add	sp,sp,32
    80005796:	8082                	ret
    panic("could not find virtio disk");
    80005798:	00003517          	auipc	a0,0x3
    8000579c:	f6050513          	add	a0,a0,-160 # 800086f8 <etext+0x6f8>
    800057a0:	00001097          	auipc	ra,0x1
    800057a4:	882080e7          	jalr	-1918(ra) # 80006022 <panic>
    panic("virtio disk FEATURES_OK unset");
    800057a8:	00003517          	auipc	a0,0x3
    800057ac:	f7050513          	add	a0,a0,-144 # 80008718 <etext+0x718>
    800057b0:	00001097          	auipc	ra,0x1
    800057b4:	872080e7          	jalr	-1934(ra) # 80006022 <panic>
    panic("virtio disk should not be ready");
    800057b8:	00003517          	auipc	a0,0x3
    800057bc:	f8050513          	add	a0,a0,-128 # 80008738 <etext+0x738>
    800057c0:	00001097          	auipc	ra,0x1
    800057c4:	862080e7          	jalr	-1950(ra) # 80006022 <panic>
    panic("virtio disk has no queue 0");
    800057c8:	00003517          	auipc	a0,0x3
    800057cc:	f9050513          	add	a0,a0,-112 # 80008758 <etext+0x758>
    800057d0:	00001097          	auipc	ra,0x1
    800057d4:	852080e7          	jalr	-1966(ra) # 80006022 <panic>
    panic("virtio disk max queue too short");
    800057d8:	00003517          	auipc	a0,0x3
    800057dc:	fa050513          	add	a0,a0,-96 # 80008778 <etext+0x778>
    800057e0:	00001097          	auipc	ra,0x1
    800057e4:	842080e7          	jalr	-1982(ra) # 80006022 <panic>
    panic("virtio disk kalloc");
    800057e8:	00003517          	auipc	a0,0x3
    800057ec:	fb050513          	add	a0,a0,-80 # 80008798 <etext+0x798>
    800057f0:	00001097          	auipc	ra,0x1
    800057f4:	832080e7          	jalr	-1998(ra) # 80006022 <panic>

00000000800057f8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800057f8:	7159                	add	sp,sp,-112
    800057fa:	f486                	sd	ra,104(sp)
    800057fc:	f0a2                	sd	s0,96(sp)
    800057fe:	eca6                	sd	s1,88(sp)
    80005800:	e8ca                	sd	s2,80(sp)
    80005802:	e4ce                	sd	s3,72(sp)
    80005804:	e0d2                	sd	s4,64(sp)
    80005806:	fc56                	sd	s5,56(sp)
    80005808:	f85a                	sd	s6,48(sp)
    8000580a:	f45e                	sd	s7,40(sp)
    8000580c:	f062                	sd	s8,32(sp)
    8000580e:	ec66                	sd	s9,24(sp)
    80005810:	1880                	add	s0,sp,112
    80005812:	8a2a                	mv	s4,a0
    80005814:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005816:	00c52c83          	lw	s9,12(a0)
    8000581a:	001c9c9b          	sllw	s9,s9,0x1
    8000581e:	1c82                	sll	s9,s9,0x20
    80005820:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005824:	00017517          	auipc	a0,0x17
    80005828:	dc450513          	add	a0,a0,-572 # 8001c5e8 <disk+0x128>
    8000582c:	00001097          	auipc	ra,0x1
    80005830:	d70080e7          	jalr	-656(ra) # 8000659c <acquire>
  for(int i = 0; i < 3; i++){
    80005834:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005836:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005838:	00017b17          	auipc	s6,0x17
    8000583c:	c88b0b13          	add	s6,s6,-888 # 8001c4c0 <disk>
  for(int i = 0; i < 3; i++){
    80005840:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005842:	00017c17          	auipc	s8,0x17
    80005846:	da6c0c13          	add	s8,s8,-602 # 8001c5e8 <disk+0x128>
    8000584a:	a0ad                	j	800058b4 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    8000584c:	00fb0733          	add	a4,s6,a5
    80005850:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005854:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005856:	0207c563          	bltz	a5,80005880 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000585a:	2905                	addw	s2,s2,1
    8000585c:	0611                	add	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000585e:	05590f63          	beq	s2,s5,800058bc <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80005862:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005864:	00017717          	auipc	a4,0x17
    80005868:	c5c70713          	add	a4,a4,-932 # 8001c4c0 <disk>
    8000586c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000586e:	01874683          	lbu	a3,24(a4)
    80005872:	fee9                	bnez	a3,8000584c <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80005874:	2785                	addw	a5,a5,1
    80005876:	0705                	add	a4,a4,1
    80005878:	fe979be3          	bne	a5,s1,8000586e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000587c:	57fd                	li	a5,-1
    8000587e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005880:	03205163          	blez	s2,800058a2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80005884:	f9042503          	lw	a0,-112(s0)
    80005888:	00000097          	auipc	ra,0x0
    8000588c:	cc2080e7          	jalr	-830(ra) # 8000554a <free_desc>
      for(int j = 0; j < i; j++)
    80005890:	4785                	li	a5,1
    80005892:	0127d863          	bge	a5,s2,800058a2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80005896:	f9442503          	lw	a0,-108(s0)
    8000589a:	00000097          	auipc	ra,0x0
    8000589e:	cb0080e7          	jalr	-848(ra) # 8000554a <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800058a2:	85e2                	mv	a1,s8
    800058a4:	00017517          	auipc	a0,0x17
    800058a8:	c3450513          	add	a0,a0,-972 # 8001c4d8 <disk+0x18>
    800058ac:	ffffc097          	auipc	ra,0xffffc
    800058b0:	e74080e7          	jalr	-396(ra) # 80001720 <sleep>
  for(int i = 0; i < 3; i++){
    800058b4:	f9040613          	add	a2,s0,-112
    800058b8:	894e                	mv	s2,s3
    800058ba:	b765                	j	80005862 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058bc:	f9042503          	lw	a0,-112(s0)
    800058c0:	00451693          	sll	a3,a0,0x4

  if(write)
    800058c4:	00017797          	auipc	a5,0x17
    800058c8:	bfc78793          	add	a5,a5,-1028 # 8001c4c0 <disk>
    800058cc:	00a50713          	add	a4,a0,10
    800058d0:	0712                	sll	a4,a4,0x4
    800058d2:	973e                	add	a4,a4,a5
    800058d4:	01703633          	snez	a2,s7
    800058d8:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800058da:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800058de:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800058e2:	6398                	ld	a4,0(a5)
    800058e4:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058e6:	0a868613          	add	a2,a3,168
    800058ea:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800058ec:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800058ee:	6390                	ld	a2,0(a5)
    800058f0:	00d605b3          	add	a1,a2,a3
    800058f4:	4741                	li	a4,16
    800058f6:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800058f8:	4805                	li	a6,1
    800058fa:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800058fe:	f9442703          	lw	a4,-108(s0)
    80005902:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005906:	0712                	sll	a4,a4,0x4
    80005908:	963a                	add	a2,a2,a4
    8000590a:	058a0593          	add	a1,s4,88
    8000590e:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005910:	0007b883          	ld	a7,0(a5)
    80005914:	9746                	add	a4,a4,a7
    80005916:	40000613          	li	a2,1024
    8000591a:	c710                	sw	a2,8(a4)
  if(write)
    8000591c:	001bb613          	seqz	a2,s7
    80005920:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005924:	00166613          	or	a2,a2,1
    80005928:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    8000592c:	f9842583          	lw	a1,-104(s0)
    80005930:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005934:	00250613          	add	a2,a0,2
    80005938:	0612                	sll	a2,a2,0x4
    8000593a:	963e                	add	a2,a2,a5
    8000593c:	577d                	li	a4,-1
    8000593e:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005942:	0592                	sll	a1,a1,0x4
    80005944:	98ae                	add	a7,a7,a1
    80005946:	03068713          	add	a4,a3,48
    8000594a:	973e                	add	a4,a4,a5
    8000594c:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005950:	6398                	ld	a4,0(a5)
    80005952:	972e                	add	a4,a4,a1
    80005954:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005958:	4689                	li	a3,2
    8000595a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000595e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005962:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005966:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000596a:	6794                	ld	a3,8(a5)
    8000596c:	0026d703          	lhu	a4,2(a3)
    80005970:	8b1d                	and	a4,a4,7
    80005972:	0706                	sll	a4,a4,0x1
    80005974:	96ba                	add	a3,a3,a4
    80005976:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000597a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000597e:	6798                	ld	a4,8(a5)
    80005980:	00275783          	lhu	a5,2(a4)
    80005984:	2785                	addw	a5,a5,1
    80005986:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000598a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000598e:	100017b7          	lui	a5,0x10001
    80005992:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005996:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    8000599a:	00017917          	auipc	s2,0x17
    8000599e:	c4e90913          	add	s2,s2,-946 # 8001c5e8 <disk+0x128>
  while(b->disk == 1) {
    800059a2:	4485                	li	s1,1
    800059a4:	01079c63          	bne	a5,a6,800059bc <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800059a8:	85ca                	mv	a1,s2
    800059aa:	8552                	mv	a0,s4
    800059ac:	ffffc097          	auipc	ra,0xffffc
    800059b0:	d74080e7          	jalr	-652(ra) # 80001720 <sleep>
  while(b->disk == 1) {
    800059b4:	004a2783          	lw	a5,4(s4)
    800059b8:	fe9788e3          	beq	a5,s1,800059a8 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800059bc:	f9042903          	lw	s2,-112(s0)
    800059c0:	00290713          	add	a4,s2,2
    800059c4:	0712                	sll	a4,a4,0x4
    800059c6:	00017797          	auipc	a5,0x17
    800059ca:	afa78793          	add	a5,a5,-1286 # 8001c4c0 <disk>
    800059ce:	97ba                	add	a5,a5,a4
    800059d0:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800059d4:	00017997          	auipc	s3,0x17
    800059d8:	aec98993          	add	s3,s3,-1300 # 8001c4c0 <disk>
    800059dc:	00491713          	sll	a4,s2,0x4
    800059e0:	0009b783          	ld	a5,0(s3)
    800059e4:	97ba                	add	a5,a5,a4
    800059e6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800059ea:	854a                	mv	a0,s2
    800059ec:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800059f0:	00000097          	auipc	ra,0x0
    800059f4:	b5a080e7          	jalr	-1190(ra) # 8000554a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800059f8:	8885                	and	s1,s1,1
    800059fa:	f0ed                	bnez	s1,800059dc <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800059fc:	00017517          	auipc	a0,0x17
    80005a00:	bec50513          	add	a0,a0,-1044 # 8001c5e8 <disk+0x128>
    80005a04:	00001097          	auipc	ra,0x1
    80005a08:	c4c080e7          	jalr	-948(ra) # 80006650 <release>
}
    80005a0c:	70a6                	ld	ra,104(sp)
    80005a0e:	7406                	ld	s0,96(sp)
    80005a10:	64e6                	ld	s1,88(sp)
    80005a12:	6946                	ld	s2,80(sp)
    80005a14:	69a6                	ld	s3,72(sp)
    80005a16:	6a06                	ld	s4,64(sp)
    80005a18:	7ae2                	ld	s5,56(sp)
    80005a1a:	7b42                	ld	s6,48(sp)
    80005a1c:	7ba2                	ld	s7,40(sp)
    80005a1e:	7c02                	ld	s8,32(sp)
    80005a20:	6ce2                	ld	s9,24(sp)
    80005a22:	6165                	add	sp,sp,112
    80005a24:	8082                	ret

0000000080005a26 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005a26:	1101                	add	sp,sp,-32
    80005a28:	ec06                	sd	ra,24(sp)
    80005a2a:	e822                	sd	s0,16(sp)
    80005a2c:	e426                	sd	s1,8(sp)
    80005a2e:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005a30:	00017497          	auipc	s1,0x17
    80005a34:	a9048493          	add	s1,s1,-1392 # 8001c4c0 <disk>
    80005a38:	00017517          	auipc	a0,0x17
    80005a3c:	bb050513          	add	a0,a0,-1104 # 8001c5e8 <disk+0x128>
    80005a40:	00001097          	auipc	ra,0x1
    80005a44:	b5c080e7          	jalr	-1188(ra) # 8000659c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005a48:	100017b7          	lui	a5,0x10001
    80005a4c:	53b8                	lw	a4,96(a5)
    80005a4e:	8b0d                	and	a4,a4,3
    80005a50:	100017b7          	lui	a5,0x10001
    80005a54:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005a56:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005a5a:	689c                	ld	a5,16(s1)
    80005a5c:	0204d703          	lhu	a4,32(s1)
    80005a60:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005a64:	04f70863          	beq	a4,a5,80005ab4 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80005a68:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a6c:	6898                	ld	a4,16(s1)
    80005a6e:	0204d783          	lhu	a5,32(s1)
    80005a72:	8b9d                	and	a5,a5,7
    80005a74:	078e                	sll	a5,a5,0x3
    80005a76:	97ba                	add	a5,a5,a4
    80005a78:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005a7a:	00278713          	add	a4,a5,2
    80005a7e:	0712                	sll	a4,a4,0x4
    80005a80:	9726                	add	a4,a4,s1
    80005a82:	01074703          	lbu	a4,16(a4)
    80005a86:	e721                	bnez	a4,80005ace <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a88:	0789                	add	a5,a5,2
    80005a8a:	0792                	sll	a5,a5,0x4
    80005a8c:	97a6                	add	a5,a5,s1
    80005a8e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005a90:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005a94:	ffffc097          	auipc	ra,0xffffc
    80005a98:	cf0080e7          	jalr	-784(ra) # 80001784 <wakeup>

    disk.used_idx += 1;
    80005a9c:	0204d783          	lhu	a5,32(s1)
    80005aa0:	2785                	addw	a5,a5,1
    80005aa2:	17c2                	sll	a5,a5,0x30
    80005aa4:	93c1                	srl	a5,a5,0x30
    80005aa6:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005aaa:	6898                	ld	a4,16(s1)
    80005aac:	00275703          	lhu	a4,2(a4)
    80005ab0:	faf71ce3          	bne	a4,a5,80005a68 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80005ab4:	00017517          	auipc	a0,0x17
    80005ab8:	b3450513          	add	a0,a0,-1228 # 8001c5e8 <disk+0x128>
    80005abc:	00001097          	auipc	ra,0x1
    80005ac0:	b94080e7          	jalr	-1132(ra) # 80006650 <release>
}
    80005ac4:	60e2                	ld	ra,24(sp)
    80005ac6:	6442                	ld	s0,16(sp)
    80005ac8:	64a2                	ld	s1,8(sp)
    80005aca:	6105                	add	sp,sp,32
    80005acc:	8082                	ret
      panic("virtio_disk_intr status");
    80005ace:	00003517          	auipc	a0,0x3
    80005ad2:	ce250513          	add	a0,a0,-798 # 800087b0 <etext+0x7b0>
    80005ad6:	00000097          	auipc	ra,0x0
    80005ada:	54c080e7          	jalr	1356(ra) # 80006022 <panic>

0000000080005ade <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005ade:	1141                	add	sp,sp,-16
    80005ae0:	e422                	sd	s0,8(sp)
    80005ae2:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005ae4:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005ae8:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005aec:	0037979b          	sllw	a5,a5,0x3
    80005af0:	02004737          	lui	a4,0x2004
    80005af4:	97ba                	add	a5,a5,a4
    80005af6:	0200c737          	lui	a4,0x200c
    80005afa:	1761                	add	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    80005afc:	6318                	ld	a4,0(a4)
    80005afe:	000f4637          	lui	a2,0xf4
    80005b02:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005b06:	9732                	add	a4,a4,a2
    80005b08:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005b0a:	00259693          	sll	a3,a1,0x2
    80005b0e:	96ae                	add	a3,a3,a1
    80005b10:	068e                	sll	a3,a3,0x3
    80005b12:	00017717          	auipc	a4,0x17
    80005b16:	aee70713          	add	a4,a4,-1298 # 8001c600 <timer_scratch>
    80005b1a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005b1c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005b1e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005b20:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005b24:	00000797          	auipc	a5,0x0
    80005b28:	95c78793          	add	a5,a5,-1700 # 80005480 <timervec>
    80005b2c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b30:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005b34:	0087e793          	or	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b38:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005b3c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005b40:	0807e793          	or	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005b44:	30479073          	csrw	mie,a5
}
    80005b48:	6422                	ld	s0,8(sp)
    80005b4a:	0141                	add	sp,sp,16
    80005b4c:	8082                	ret

0000000080005b4e <start>:
{
    80005b4e:	1141                	add	sp,sp,-16
    80005b50:	e406                	sd	ra,8(sp)
    80005b52:	e022                	sd	s0,0(sp)
    80005b54:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b56:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005b5a:	7779                	lui	a4,0xffffe
    80005b5c:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9fbf>
    80005b60:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005b62:	6705                	lui	a4,0x1
    80005b64:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005b68:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b6a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005b6e:	ffffa797          	auipc	a5,0xffffa
    80005b72:	7aa78793          	add	a5,a5,1962 # 80000318 <main>
    80005b76:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005b7a:	4781                	li	a5,0
    80005b7c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005b80:	67c1                	lui	a5,0x10
    80005b82:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005b84:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005b88:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005b8c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005b90:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005b94:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005b98:	57fd                	li	a5,-1
    80005b9a:	83a9                	srl	a5,a5,0xa
    80005b9c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005ba0:	47bd                	li	a5,15
    80005ba2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005ba6:	00000097          	auipc	ra,0x0
    80005baa:	f38080e7          	jalr	-200(ra) # 80005ade <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005bae:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005bb2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005bb4:	823e                	mv	tp,a5
  asm volatile("mret");
    80005bb6:	30200073          	mret
}
    80005bba:	60a2                	ld	ra,8(sp)
    80005bbc:	6402                	ld	s0,0(sp)
    80005bbe:	0141                	add	sp,sp,16
    80005bc0:	8082                	ret

0000000080005bc2 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005bc2:	715d                	add	sp,sp,-80
    80005bc4:	e486                	sd	ra,72(sp)
    80005bc6:	e0a2                	sd	s0,64(sp)
    80005bc8:	f84a                	sd	s2,48(sp)
    80005bca:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005bcc:	04c05663          	blez	a2,80005c18 <consolewrite+0x56>
    80005bd0:	fc26                	sd	s1,56(sp)
    80005bd2:	f44e                	sd	s3,40(sp)
    80005bd4:	f052                	sd	s4,32(sp)
    80005bd6:	ec56                	sd	s5,24(sp)
    80005bd8:	8a2a                	mv	s4,a0
    80005bda:	84ae                	mv	s1,a1
    80005bdc:	89b2                	mv	s3,a2
    80005bde:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005be0:	5afd                	li	s5,-1
    80005be2:	4685                	li	a3,1
    80005be4:	8626                	mv	a2,s1
    80005be6:	85d2                	mv	a1,s4
    80005be8:	fbf40513          	add	a0,s0,-65
    80005bec:	ffffc097          	auipc	ra,0xffffc
    80005bf0:	f92080e7          	jalr	-110(ra) # 80001b7e <either_copyin>
    80005bf4:	03550463          	beq	a0,s5,80005c1c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005bf8:	fbf44503          	lbu	a0,-65(s0)
    80005bfc:	00000097          	auipc	ra,0x0
    80005c00:	7e4080e7          	jalr	2020(ra) # 800063e0 <uartputc>
  for(i = 0; i < n; i++){
    80005c04:	2905                	addw	s2,s2,1
    80005c06:	0485                	add	s1,s1,1
    80005c08:	fd299de3          	bne	s3,s2,80005be2 <consolewrite+0x20>
    80005c0c:	894e                	mv	s2,s3
    80005c0e:	74e2                	ld	s1,56(sp)
    80005c10:	79a2                	ld	s3,40(sp)
    80005c12:	7a02                	ld	s4,32(sp)
    80005c14:	6ae2                	ld	s5,24(sp)
    80005c16:	a039                	j	80005c24 <consolewrite+0x62>
    80005c18:	4901                	li	s2,0
    80005c1a:	a029                	j	80005c24 <consolewrite+0x62>
    80005c1c:	74e2                	ld	s1,56(sp)
    80005c1e:	79a2                	ld	s3,40(sp)
    80005c20:	7a02                	ld	s4,32(sp)
    80005c22:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005c24:	854a                	mv	a0,s2
    80005c26:	60a6                	ld	ra,72(sp)
    80005c28:	6406                	ld	s0,64(sp)
    80005c2a:	7942                	ld	s2,48(sp)
    80005c2c:	6161                	add	sp,sp,80
    80005c2e:	8082                	ret

0000000080005c30 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005c30:	711d                	add	sp,sp,-96
    80005c32:	ec86                	sd	ra,88(sp)
    80005c34:	e8a2                	sd	s0,80(sp)
    80005c36:	e4a6                	sd	s1,72(sp)
    80005c38:	e0ca                	sd	s2,64(sp)
    80005c3a:	fc4e                	sd	s3,56(sp)
    80005c3c:	f852                	sd	s4,48(sp)
    80005c3e:	f456                	sd	s5,40(sp)
    80005c40:	f05a                	sd	s6,32(sp)
    80005c42:	1080                	add	s0,sp,96
    80005c44:	8aaa                	mv	s5,a0
    80005c46:	8a2e                	mv	s4,a1
    80005c48:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005c4a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005c4e:	0001f517          	auipc	a0,0x1f
    80005c52:	af250513          	add	a0,a0,-1294 # 80024740 <cons>
    80005c56:	00001097          	auipc	ra,0x1
    80005c5a:	946080e7          	jalr	-1722(ra) # 8000659c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005c5e:	0001f497          	auipc	s1,0x1f
    80005c62:	ae248493          	add	s1,s1,-1310 # 80024740 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005c66:	0001f917          	auipc	s2,0x1f
    80005c6a:	b7290913          	add	s2,s2,-1166 # 800247d8 <cons+0x98>
  while(n > 0){
    80005c6e:	0d305763          	blez	s3,80005d3c <consoleread+0x10c>
    while(cons.r == cons.w){
    80005c72:	0984a783          	lw	a5,152(s1)
    80005c76:	09c4a703          	lw	a4,156(s1)
    80005c7a:	0af71c63          	bne	a4,a5,80005d32 <consoleread+0x102>
      if(killed(myproc())){
    80005c7e:	ffffb097          	auipc	ra,0xffffb
    80005c82:	370080e7          	jalr	880(ra) # 80000fee <myproc>
    80005c86:	ffffc097          	auipc	ra,0xffffc
    80005c8a:	d42080e7          	jalr	-702(ra) # 800019c8 <killed>
    80005c8e:	e52d                	bnez	a0,80005cf8 <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    80005c90:	85a6                	mv	a1,s1
    80005c92:	854a                	mv	a0,s2
    80005c94:	ffffc097          	auipc	ra,0xffffc
    80005c98:	a8c080e7          	jalr	-1396(ra) # 80001720 <sleep>
    while(cons.r == cons.w){
    80005c9c:	0984a783          	lw	a5,152(s1)
    80005ca0:	09c4a703          	lw	a4,156(s1)
    80005ca4:	fcf70de3          	beq	a4,a5,80005c7e <consoleread+0x4e>
    80005ca8:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005caa:	0001f717          	auipc	a4,0x1f
    80005cae:	a9670713          	add	a4,a4,-1386 # 80024740 <cons>
    80005cb2:	0017869b          	addw	a3,a5,1
    80005cb6:	08d72c23          	sw	a3,152(a4)
    80005cba:	07f7f693          	and	a3,a5,127
    80005cbe:	9736                	add	a4,a4,a3
    80005cc0:	01874703          	lbu	a4,24(a4)
    80005cc4:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005cc8:	4691                	li	a3,4
    80005cca:	04db8a63          	beq	s7,a3,80005d1e <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005cce:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005cd2:	4685                	li	a3,1
    80005cd4:	faf40613          	add	a2,s0,-81
    80005cd8:	85d2                	mv	a1,s4
    80005cda:	8556                	mv	a0,s5
    80005cdc:	ffffc097          	auipc	ra,0xffffc
    80005ce0:	e4c080e7          	jalr	-436(ra) # 80001b28 <either_copyout>
    80005ce4:	57fd                	li	a5,-1
    80005ce6:	04f50a63          	beq	a0,a5,80005d3a <consoleread+0x10a>
      break;

    dst++;
    80005cea:	0a05                	add	s4,s4,1
    --n;
    80005cec:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    80005cee:	47a9                	li	a5,10
    80005cf0:	06fb8163          	beq	s7,a5,80005d52 <consoleread+0x122>
    80005cf4:	6be2                	ld	s7,24(sp)
    80005cf6:	bfa5                	j	80005c6e <consoleread+0x3e>
        release(&cons.lock);
    80005cf8:	0001f517          	auipc	a0,0x1f
    80005cfc:	a4850513          	add	a0,a0,-1464 # 80024740 <cons>
    80005d00:	00001097          	auipc	ra,0x1
    80005d04:	950080e7          	jalr	-1712(ra) # 80006650 <release>
        return -1;
    80005d08:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005d0a:	60e6                	ld	ra,88(sp)
    80005d0c:	6446                	ld	s0,80(sp)
    80005d0e:	64a6                	ld	s1,72(sp)
    80005d10:	6906                	ld	s2,64(sp)
    80005d12:	79e2                	ld	s3,56(sp)
    80005d14:	7a42                	ld	s4,48(sp)
    80005d16:	7aa2                	ld	s5,40(sp)
    80005d18:	7b02                	ld	s6,32(sp)
    80005d1a:	6125                	add	sp,sp,96
    80005d1c:	8082                	ret
      if(n < target){
    80005d1e:	0009871b          	sext.w	a4,s3
    80005d22:	01677a63          	bgeu	a4,s6,80005d36 <consoleread+0x106>
        cons.r--;
    80005d26:	0001f717          	auipc	a4,0x1f
    80005d2a:	aaf72923          	sw	a5,-1358(a4) # 800247d8 <cons+0x98>
    80005d2e:	6be2                	ld	s7,24(sp)
    80005d30:	a031                	j	80005d3c <consoleread+0x10c>
    80005d32:	ec5e                	sd	s7,24(sp)
    80005d34:	bf9d                	j	80005caa <consoleread+0x7a>
    80005d36:	6be2                	ld	s7,24(sp)
    80005d38:	a011                	j	80005d3c <consoleread+0x10c>
    80005d3a:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005d3c:	0001f517          	auipc	a0,0x1f
    80005d40:	a0450513          	add	a0,a0,-1532 # 80024740 <cons>
    80005d44:	00001097          	auipc	ra,0x1
    80005d48:	90c080e7          	jalr	-1780(ra) # 80006650 <release>
  return target - n;
    80005d4c:	413b053b          	subw	a0,s6,s3
    80005d50:	bf6d                	j	80005d0a <consoleread+0xda>
    80005d52:	6be2                	ld	s7,24(sp)
    80005d54:	b7e5                	j	80005d3c <consoleread+0x10c>

0000000080005d56 <consputc>:
{
    80005d56:	1141                	add	sp,sp,-16
    80005d58:	e406                	sd	ra,8(sp)
    80005d5a:	e022                	sd	s0,0(sp)
    80005d5c:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    80005d5e:	10000793          	li	a5,256
    80005d62:	00f50a63          	beq	a0,a5,80005d76 <consputc+0x20>
    uartputc_sync(c);
    80005d66:	00000097          	auipc	ra,0x0
    80005d6a:	59c080e7          	jalr	1436(ra) # 80006302 <uartputc_sync>
}
    80005d6e:	60a2                	ld	ra,8(sp)
    80005d70:	6402                	ld	s0,0(sp)
    80005d72:	0141                	add	sp,sp,16
    80005d74:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005d76:	4521                	li	a0,8
    80005d78:	00000097          	auipc	ra,0x0
    80005d7c:	58a080e7          	jalr	1418(ra) # 80006302 <uartputc_sync>
    80005d80:	02000513          	li	a0,32
    80005d84:	00000097          	auipc	ra,0x0
    80005d88:	57e080e7          	jalr	1406(ra) # 80006302 <uartputc_sync>
    80005d8c:	4521                	li	a0,8
    80005d8e:	00000097          	auipc	ra,0x0
    80005d92:	574080e7          	jalr	1396(ra) # 80006302 <uartputc_sync>
    80005d96:	bfe1                	j	80005d6e <consputc+0x18>

0000000080005d98 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005d98:	1101                	add	sp,sp,-32
    80005d9a:	ec06                	sd	ra,24(sp)
    80005d9c:	e822                	sd	s0,16(sp)
    80005d9e:	e426                	sd	s1,8(sp)
    80005da0:	1000                	add	s0,sp,32
    80005da2:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005da4:	0001f517          	auipc	a0,0x1f
    80005da8:	99c50513          	add	a0,a0,-1636 # 80024740 <cons>
    80005dac:	00000097          	auipc	ra,0x0
    80005db0:	7f0080e7          	jalr	2032(ra) # 8000659c <acquire>

  switch(c){
    80005db4:	47d5                	li	a5,21
    80005db6:	0af48563          	beq	s1,a5,80005e60 <consoleintr+0xc8>
    80005dba:	0297c963          	blt	a5,s1,80005dec <consoleintr+0x54>
    80005dbe:	47a1                	li	a5,8
    80005dc0:	0ef48c63          	beq	s1,a5,80005eb8 <consoleintr+0x120>
    80005dc4:	47c1                	li	a5,16
    80005dc6:	10f49f63          	bne	s1,a5,80005ee4 <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005dca:	ffffc097          	auipc	ra,0xffffc
    80005dce:	e0a080e7          	jalr	-502(ra) # 80001bd4 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005dd2:	0001f517          	auipc	a0,0x1f
    80005dd6:	96e50513          	add	a0,a0,-1682 # 80024740 <cons>
    80005dda:	00001097          	auipc	ra,0x1
    80005dde:	876080e7          	jalr	-1930(ra) # 80006650 <release>
}
    80005de2:	60e2                	ld	ra,24(sp)
    80005de4:	6442                	ld	s0,16(sp)
    80005de6:	64a2                	ld	s1,8(sp)
    80005de8:	6105                	add	sp,sp,32
    80005dea:	8082                	ret
  switch(c){
    80005dec:	07f00793          	li	a5,127
    80005df0:	0cf48463          	beq	s1,a5,80005eb8 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005df4:	0001f717          	auipc	a4,0x1f
    80005df8:	94c70713          	add	a4,a4,-1716 # 80024740 <cons>
    80005dfc:	0a072783          	lw	a5,160(a4)
    80005e00:	09872703          	lw	a4,152(a4)
    80005e04:	9f99                	subw	a5,a5,a4
    80005e06:	07f00713          	li	a4,127
    80005e0a:	fcf764e3          	bltu	a4,a5,80005dd2 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005e0e:	47b5                	li	a5,13
    80005e10:	0cf48d63          	beq	s1,a5,80005eea <consoleintr+0x152>
      consputc(c);
    80005e14:	8526                	mv	a0,s1
    80005e16:	00000097          	auipc	ra,0x0
    80005e1a:	f40080e7          	jalr	-192(ra) # 80005d56 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005e1e:	0001f797          	auipc	a5,0x1f
    80005e22:	92278793          	add	a5,a5,-1758 # 80024740 <cons>
    80005e26:	0a07a683          	lw	a3,160(a5)
    80005e2a:	0016871b          	addw	a4,a3,1
    80005e2e:	0007061b          	sext.w	a2,a4
    80005e32:	0ae7a023          	sw	a4,160(a5)
    80005e36:	07f6f693          	and	a3,a3,127
    80005e3a:	97b6                	add	a5,a5,a3
    80005e3c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005e40:	47a9                	li	a5,10
    80005e42:	0cf48b63          	beq	s1,a5,80005f18 <consoleintr+0x180>
    80005e46:	4791                	li	a5,4
    80005e48:	0cf48863          	beq	s1,a5,80005f18 <consoleintr+0x180>
    80005e4c:	0001f797          	auipc	a5,0x1f
    80005e50:	98c7a783          	lw	a5,-1652(a5) # 800247d8 <cons+0x98>
    80005e54:	9f1d                	subw	a4,a4,a5
    80005e56:	08000793          	li	a5,128
    80005e5a:	f6f71ce3          	bne	a4,a5,80005dd2 <consoleintr+0x3a>
    80005e5e:	a86d                	j	80005f18 <consoleintr+0x180>
    80005e60:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005e62:	0001f717          	auipc	a4,0x1f
    80005e66:	8de70713          	add	a4,a4,-1826 # 80024740 <cons>
    80005e6a:	0a072783          	lw	a5,160(a4)
    80005e6e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e72:	0001f497          	auipc	s1,0x1f
    80005e76:	8ce48493          	add	s1,s1,-1842 # 80024740 <cons>
    while(cons.e != cons.w &&
    80005e7a:	4929                	li	s2,10
    80005e7c:	02f70a63          	beq	a4,a5,80005eb0 <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e80:	37fd                	addw	a5,a5,-1
    80005e82:	07f7f713          	and	a4,a5,127
    80005e86:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005e88:	01874703          	lbu	a4,24(a4)
    80005e8c:	03270463          	beq	a4,s2,80005eb4 <consoleintr+0x11c>
      cons.e--;
    80005e90:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005e94:	10000513          	li	a0,256
    80005e98:	00000097          	auipc	ra,0x0
    80005e9c:	ebe080e7          	jalr	-322(ra) # 80005d56 <consputc>
    while(cons.e != cons.w &&
    80005ea0:	0a04a783          	lw	a5,160(s1)
    80005ea4:	09c4a703          	lw	a4,156(s1)
    80005ea8:	fcf71ce3          	bne	a4,a5,80005e80 <consoleintr+0xe8>
    80005eac:	6902                	ld	s2,0(sp)
    80005eae:	b715                	j	80005dd2 <consoleintr+0x3a>
    80005eb0:	6902                	ld	s2,0(sp)
    80005eb2:	b705                	j	80005dd2 <consoleintr+0x3a>
    80005eb4:	6902                	ld	s2,0(sp)
    80005eb6:	bf31                	j	80005dd2 <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005eb8:	0001f717          	auipc	a4,0x1f
    80005ebc:	88870713          	add	a4,a4,-1912 # 80024740 <cons>
    80005ec0:	0a072783          	lw	a5,160(a4)
    80005ec4:	09c72703          	lw	a4,156(a4)
    80005ec8:	f0f705e3          	beq	a4,a5,80005dd2 <consoleintr+0x3a>
      cons.e--;
    80005ecc:	37fd                	addw	a5,a5,-1
    80005ece:	0001f717          	auipc	a4,0x1f
    80005ed2:	90f72923          	sw	a5,-1774(a4) # 800247e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005ed6:	10000513          	li	a0,256
    80005eda:	00000097          	auipc	ra,0x0
    80005ede:	e7c080e7          	jalr	-388(ra) # 80005d56 <consputc>
    80005ee2:	bdc5                	j	80005dd2 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ee4:	ee0487e3          	beqz	s1,80005dd2 <consoleintr+0x3a>
    80005ee8:	b731                	j	80005df4 <consoleintr+0x5c>
      consputc(c);
    80005eea:	4529                	li	a0,10
    80005eec:	00000097          	auipc	ra,0x0
    80005ef0:	e6a080e7          	jalr	-406(ra) # 80005d56 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ef4:	0001f797          	auipc	a5,0x1f
    80005ef8:	84c78793          	add	a5,a5,-1972 # 80024740 <cons>
    80005efc:	0a07a703          	lw	a4,160(a5)
    80005f00:	0017069b          	addw	a3,a4,1
    80005f04:	0006861b          	sext.w	a2,a3
    80005f08:	0ad7a023          	sw	a3,160(a5)
    80005f0c:	07f77713          	and	a4,a4,127
    80005f10:	97ba                	add	a5,a5,a4
    80005f12:	4729                	li	a4,10
    80005f14:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005f18:	0001f797          	auipc	a5,0x1f
    80005f1c:	8cc7a223          	sw	a2,-1852(a5) # 800247dc <cons+0x9c>
        wakeup(&cons.r);
    80005f20:	0001f517          	auipc	a0,0x1f
    80005f24:	8b850513          	add	a0,a0,-1864 # 800247d8 <cons+0x98>
    80005f28:	ffffc097          	auipc	ra,0xffffc
    80005f2c:	85c080e7          	jalr	-1956(ra) # 80001784 <wakeup>
    80005f30:	b54d                	j	80005dd2 <consoleintr+0x3a>

0000000080005f32 <consoleinit>:

void
consoleinit(void)
{
    80005f32:	1141                	add	sp,sp,-16
    80005f34:	e406                	sd	ra,8(sp)
    80005f36:	e022                	sd	s0,0(sp)
    80005f38:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80005f3a:	00003597          	auipc	a1,0x3
    80005f3e:	88e58593          	add	a1,a1,-1906 # 800087c8 <etext+0x7c8>
    80005f42:	0001e517          	auipc	a0,0x1e
    80005f46:	7fe50513          	add	a0,a0,2046 # 80024740 <cons>
    80005f4a:	00000097          	auipc	ra,0x0
    80005f4e:	5c2080e7          	jalr	1474(ra) # 8000650c <initlock>

  uartinit();
    80005f52:	00000097          	auipc	ra,0x0
    80005f56:	354080e7          	jalr	852(ra) # 800062a6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005f5a:	00015797          	auipc	a5,0x15
    80005f5e:	50e78793          	add	a5,a5,1294 # 8001b468 <devsw>
    80005f62:	00000717          	auipc	a4,0x0
    80005f66:	cce70713          	add	a4,a4,-818 # 80005c30 <consoleread>
    80005f6a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005f6c:	00000717          	auipc	a4,0x0
    80005f70:	c5670713          	add	a4,a4,-938 # 80005bc2 <consolewrite>
    80005f74:	ef98                	sd	a4,24(a5)
}
    80005f76:	60a2                	ld	ra,8(sp)
    80005f78:	6402                	ld	s0,0(sp)
    80005f7a:	0141                	add	sp,sp,16
    80005f7c:	8082                	ret

0000000080005f7e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005f7e:	7179                	add	sp,sp,-48
    80005f80:	f406                	sd	ra,40(sp)
    80005f82:	f022                	sd	s0,32(sp)
    80005f84:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005f86:	c219                	beqz	a2,80005f8c <printint+0xe>
    80005f88:	08054963          	bltz	a0,8000601a <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005f8c:	2501                	sext.w	a0,a0
    80005f8e:	4881                	li	a7,0
    80005f90:	fd040693          	add	a3,s0,-48

  i = 0;
    80005f94:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005f96:	2581                	sext.w	a1,a1
    80005f98:	00003617          	auipc	a2,0x3
    80005f9c:	9d860613          	add	a2,a2,-1576 # 80008970 <digits>
    80005fa0:	883a                	mv	a6,a4
    80005fa2:	2705                	addw	a4,a4,1
    80005fa4:	02b577bb          	remuw	a5,a0,a1
    80005fa8:	1782                	sll	a5,a5,0x20
    80005faa:	9381                	srl	a5,a5,0x20
    80005fac:	97b2                	add	a5,a5,a2
    80005fae:	0007c783          	lbu	a5,0(a5)
    80005fb2:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005fb6:	0005079b          	sext.w	a5,a0
    80005fba:	02b5553b          	divuw	a0,a0,a1
    80005fbe:	0685                	add	a3,a3,1
    80005fc0:	feb7f0e3          	bgeu	a5,a1,80005fa0 <printint+0x22>

  if(sign)
    80005fc4:	00088c63          	beqz	a7,80005fdc <printint+0x5e>
    buf[i++] = '-';
    80005fc8:	fe070793          	add	a5,a4,-32
    80005fcc:	00878733          	add	a4,a5,s0
    80005fd0:	02d00793          	li	a5,45
    80005fd4:	fef70823          	sb	a5,-16(a4)
    80005fd8:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    80005fdc:	02e05b63          	blez	a4,80006012 <printint+0x94>
    80005fe0:	ec26                	sd	s1,24(sp)
    80005fe2:	e84a                	sd	s2,16(sp)
    80005fe4:	fd040793          	add	a5,s0,-48
    80005fe8:	00e784b3          	add	s1,a5,a4
    80005fec:	fff78913          	add	s2,a5,-1
    80005ff0:	993a                	add	s2,s2,a4
    80005ff2:	377d                	addw	a4,a4,-1
    80005ff4:	1702                	sll	a4,a4,0x20
    80005ff6:	9301                	srl	a4,a4,0x20
    80005ff8:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005ffc:	fff4c503          	lbu	a0,-1(s1)
    80006000:	00000097          	auipc	ra,0x0
    80006004:	d56080e7          	jalr	-682(ra) # 80005d56 <consputc>
  while(--i >= 0)
    80006008:	14fd                	add	s1,s1,-1
    8000600a:	ff2499e3          	bne	s1,s2,80005ffc <printint+0x7e>
    8000600e:	64e2                	ld	s1,24(sp)
    80006010:	6942                	ld	s2,16(sp)
}
    80006012:	70a2                	ld	ra,40(sp)
    80006014:	7402                	ld	s0,32(sp)
    80006016:	6145                	add	sp,sp,48
    80006018:	8082                	ret
    x = -xx;
    8000601a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000601e:	4885                	li	a7,1
    x = -xx;
    80006020:	bf85                	j	80005f90 <printint+0x12>

0000000080006022 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006022:	1101                	add	sp,sp,-32
    80006024:	ec06                	sd	ra,24(sp)
    80006026:	e822                	sd	s0,16(sp)
    80006028:	e426                	sd	s1,8(sp)
    8000602a:	1000                	add	s0,sp,32
    8000602c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000602e:	0001e797          	auipc	a5,0x1e
    80006032:	7c07a923          	sw	zero,2002(a5) # 80024800 <pr+0x18>
  printf("panic: ");
    80006036:	00002517          	auipc	a0,0x2
    8000603a:	79a50513          	add	a0,a0,1946 # 800087d0 <etext+0x7d0>
    8000603e:	00000097          	auipc	ra,0x0
    80006042:	02e080e7          	jalr	46(ra) # 8000606c <printf>
  printf(s);
    80006046:	8526                	mv	a0,s1
    80006048:	00000097          	auipc	ra,0x0
    8000604c:	024080e7          	jalr	36(ra) # 8000606c <printf>
  printf("\n");
    80006050:	00002517          	auipc	a0,0x2
    80006054:	fc850513          	add	a0,a0,-56 # 80008018 <etext+0x18>
    80006058:	00000097          	auipc	ra,0x0
    8000605c:	014080e7          	jalr	20(ra) # 8000606c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006060:	4785                	li	a5,1
    80006062:	00005717          	auipc	a4,0x5
    80006066:	34f72d23          	sw	a5,858(a4) # 8000b3bc <panicked>
  for(;;)
    8000606a:	a001                	j	8000606a <panic+0x48>

000000008000606c <printf>:
{
    8000606c:	7131                	add	sp,sp,-192
    8000606e:	fc86                	sd	ra,120(sp)
    80006070:	f8a2                	sd	s0,112(sp)
    80006072:	e8d2                	sd	s4,80(sp)
    80006074:	f06a                	sd	s10,32(sp)
    80006076:	0100                	add	s0,sp,128
    80006078:	8a2a                	mv	s4,a0
    8000607a:	e40c                	sd	a1,8(s0)
    8000607c:	e810                	sd	a2,16(s0)
    8000607e:	ec14                	sd	a3,24(s0)
    80006080:	f018                	sd	a4,32(s0)
    80006082:	f41c                	sd	a5,40(s0)
    80006084:	03043823          	sd	a6,48(s0)
    80006088:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    8000608c:	0001ed17          	auipc	s10,0x1e
    80006090:	774d2d03          	lw	s10,1908(s10) # 80024800 <pr+0x18>
  if(locking)
    80006094:	040d1463          	bnez	s10,800060dc <printf+0x70>
  if (fmt == 0)
    80006098:	040a0b63          	beqz	s4,800060ee <printf+0x82>
  va_start(ap, fmt);
    8000609c:	00840793          	add	a5,s0,8
    800060a0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800060a4:	000a4503          	lbu	a0,0(s4)
    800060a8:	18050b63          	beqz	a0,8000623e <printf+0x1d2>
    800060ac:	f4a6                	sd	s1,104(sp)
    800060ae:	f0ca                	sd	s2,96(sp)
    800060b0:	ecce                	sd	s3,88(sp)
    800060b2:	e4d6                	sd	s5,72(sp)
    800060b4:	e0da                	sd	s6,64(sp)
    800060b6:	fc5e                	sd	s7,56(sp)
    800060b8:	f862                	sd	s8,48(sp)
    800060ba:	f466                	sd	s9,40(sp)
    800060bc:	ec6e                	sd	s11,24(sp)
    800060be:	4981                	li	s3,0
    if(c != '%'){
    800060c0:	02500b13          	li	s6,37
    switch(c){
    800060c4:	07000b93          	li	s7,112
  consputc('x');
    800060c8:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800060ca:	00003a97          	auipc	s5,0x3
    800060ce:	8a6a8a93          	add	s5,s5,-1882 # 80008970 <digits>
    switch(c){
    800060d2:	07300c13          	li	s8,115
    800060d6:	06400d93          	li	s11,100
    800060da:	a0b1                	j	80006126 <printf+0xba>
    acquire(&pr.lock);
    800060dc:	0001e517          	auipc	a0,0x1e
    800060e0:	70c50513          	add	a0,a0,1804 # 800247e8 <pr>
    800060e4:	00000097          	auipc	ra,0x0
    800060e8:	4b8080e7          	jalr	1208(ra) # 8000659c <acquire>
    800060ec:	b775                	j	80006098 <printf+0x2c>
    800060ee:	f4a6                	sd	s1,104(sp)
    800060f0:	f0ca                	sd	s2,96(sp)
    800060f2:	ecce                	sd	s3,88(sp)
    800060f4:	e4d6                	sd	s5,72(sp)
    800060f6:	e0da                	sd	s6,64(sp)
    800060f8:	fc5e                	sd	s7,56(sp)
    800060fa:	f862                	sd	s8,48(sp)
    800060fc:	f466                	sd	s9,40(sp)
    800060fe:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80006100:	00002517          	auipc	a0,0x2
    80006104:	6e050513          	add	a0,a0,1760 # 800087e0 <etext+0x7e0>
    80006108:	00000097          	auipc	ra,0x0
    8000610c:	f1a080e7          	jalr	-230(ra) # 80006022 <panic>
      consputc(c);
    80006110:	00000097          	auipc	ra,0x0
    80006114:	c46080e7          	jalr	-954(ra) # 80005d56 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006118:	2985                	addw	s3,s3,1
    8000611a:	013a07b3          	add	a5,s4,s3
    8000611e:	0007c503          	lbu	a0,0(a5)
    80006122:	10050563          	beqz	a0,8000622c <printf+0x1c0>
    if(c != '%'){
    80006126:	ff6515e3          	bne	a0,s6,80006110 <printf+0xa4>
    c = fmt[++i] & 0xff;
    8000612a:	2985                	addw	s3,s3,1
    8000612c:	013a07b3          	add	a5,s4,s3
    80006130:	0007c783          	lbu	a5,0(a5)
    80006134:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006138:	10078b63          	beqz	a5,8000624e <printf+0x1e2>
    switch(c){
    8000613c:	05778a63          	beq	a5,s7,80006190 <printf+0x124>
    80006140:	02fbf663          	bgeu	s7,a5,8000616c <printf+0x100>
    80006144:	09878863          	beq	a5,s8,800061d4 <printf+0x168>
    80006148:	07800713          	li	a4,120
    8000614c:	0ce79563          	bne	a5,a4,80006216 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80006150:	f8843783          	ld	a5,-120(s0)
    80006154:	00878713          	add	a4,a5,8
    80006158:	f8e43423          	sd	a4,-120(s0)
    8000615c:	4605                	li	a2,1
    8000615e:	85e6                	mv	a1,s9
    80006160:	4388                	lw	a0,0(a5)
    80006162:	00000097          	auipc	ra,0x0
    80006166:	e1c080e7          	jalr	-484(ra) # 80005f7e <printint>
      break;
    8000616a:	b77d                	j	80006118 <printf+0xac>
    switch(c){
    8000616c:	09678f63          	beq	a5,s6,8000620a <printf+0x19e>
    80006170:	0bb79363          	bne	a5,s11,80006216 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80006174:	f8843783          	ld	a5,-120(s0)
    80006178:	00878713          	add	a4,a5,8
    8000617c:	f8e43423          	sd	a4,-120(s0)
    80006180:	4605                	li	a2,1
    80006182:	45a9                	li	a1,10
    80006184:	4388                	lw	a0,0(a5)
    80006186:	00000097          	auipc	ra,0x0
    8000618a:	df8080e7          	jalr	-520(ra) # 80005f7e <printint>
      break;
    8000618e:	b769                	j	80006118 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80006190:	f8843783          	ld	a5,-120(s0)
    80006194:	00878713          	add	a4,a5,8
    80006198:	f8e43423          	sd	a4,-120(s0)
    8000619c:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800061a0:	03000513          	li	a0,48
    800061a4:	00000097          	auipc	ra,0x0
    800061a8:	bb2080e7          	jalr	-1102(ra) # 80005d56 <consputc>
  consputc('x');
    800061ac:	07800513          	li	a0,120
    800061b0:	00000097          	auipc	ra,0x0
    800061b4:	ba6080e7          	jalr	-1114(ra) # 80005d56 <consputc>
    800061b8:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800061ba:	03c95793          	srl	a5,s2,0x3c
    800061be:	97d6                	add	a5,a5,s5
    800061c0:	0007c503          	lbu	a0,0(a5)
    800061c4:	00000097          	auipc	ra,0x0
    800061c8:	b92080e7          	jalr	-1134(ra) # 80005d56 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800061cc:	0912                	sll	s2,s2,0x4
    800061ce:	34fd                	addw	s1,s1,-1
    800061d0:	f4ed                	bnez	s1,800061ba <printf+0x14e>
    800061d2:	b799                	j	80006118 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    800061d4:	f8843783          	ld	a5,-120(s0)
    800061d8:	00878713          	add	a4,a5,8
    800061dc:	f8e43423          	sd	a4,-120(s0)
    800061e0:	6384                	ld	s1,0(a5)
    800061e2:	cc89                	beqz	s1,800061fc <printf+0x190>
      for(; *s; s++)
    800061e4:	0004c503          	lbu	a0,0(s1)
    800061e8:	d905                	beqz	a0,80006118 <printf+0xac>
        consputc(*s);
    800061ea:	00000097          	auipc	ra,0x0
    800061ee:	b6c080e7          	jalr	-1172(ra) # 80005d56 <consputc>
      for(; *s; s++)
    800061f2:	0485                	add	s1,s1,1
    800061f4:	0004c503          	lbu	a0,0(s1)
    800061f8:	f96d                	bnez	a0,800061ea <printf+0x17e>
    800061fa:	bf39                	j	80006118 <printf+0xac>
        s = "(null)";
    800061fc:	00002497          	auipc	s1,0x2
    80006200:	5dc48493          	add	s1,s1,1500 # 800087d8 <etext+0x7d8>
      for(; *s; s++)
    80006204:	02800513          	li	a0,40
    80006208:	b7cd                	j	800061ea <printf+0x17e>
      consputc('%');
    8000620a:	855a                	mv	a0,s6
    8000620c:	00000097          	auipc	ra,0x0
    80006210:	b4a080e7          	jalr	-1206(ra) # 80005d56 <consputc>
      break;
    80006214:	b711                	j	80006118 <printf+0xac>
      consputc('%');
    80006216:	855a                	mv	a0,s6
    80006218:	00000097          	auipc	ra,0x0
    8000621c:	b3e080e7          	jalr	-1218(ra) # 80005d56 <consputc>
      consputc(c);
    80006220:	8526                	mv	a0,s1
    80006222:	00000097          	auipc	ra,0x0
    80006226:	b34080e7          	jalr	-1228(ra) # 80005d56 <consputc>
      break;
    8000622a:	b5fd                	j	80006118 <printf+0xac>
    8000622c:	74a6                	ld	s1,104(sp)
    8000622e:	7906                	ld	s2,96(sp)
    80006230:	69e6                	ld	s3,88(sp)
    80006232:	6aa6                	ld	s5,72(sp)
    80006234:	6b06                	ld	s6,64(sp)
    80006236:	7be2                	ld	s7,56(sp)
    80006238:	7c42                	ld	s8,48(sp)
    8000623a:	7ca2                	ld	s9,40(sp)
    8000623c:	6de2                	ld	s11,24(sp)
  if(locking)
    8000623e:	020d1263          	bnez	s10,80006262 <printf+0x1f6>
}
    80006242:	70e6                	ld	ra,120(sp)
    80006244:	7446                	ld	s0,112(sp)
    80006246:	6a46                	ld	s4,80(sp)
    80006248:	7d02                	ld	s10,32(sp)
    8000624a:	6129                	add	sp,sp,192
    8000624c:	8082                	ret
    8000624e:	74a6                	ld	s1,104(sp)
    80006250:	7906                	ld	s2,96(sp)
    80006252:	69e6                	ld	s3,88(sp)
    80006254:	6aa6                	ld	s5,72(sp)
    80006256:	6b06                	ld	s6,64(sp)
    80006258:	7be2                	ld	s7,56(sp)
    8000625a:	7c42                	ld	s8,48(sp)
    8000625c:	7ca2                	ld	s9,40(sp)
    8000625e:	6de2                	ld	s11,24(sp)
    80006260:	bff9                	j	8000623e <printf+0x1d2>
    release(&pr.lock);
    80006262:	0001e517          	auipc	a0,0x1e
    80006266:	58650513          	add	a0,a0,1414 # 800247e8 <pr>
    8000626a:	00000097          	auipc	ra,0x0
    8000626e:	3e6080e7          	jalr	998(ra) # 80006650 <release>
}
    80006272:	bfc1                	j	80006242 <printf+0x1d6>

0000000080006274 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006274:	1101                	add	sp,sp,-32
    80006276:	ec06                	sd	ra,24(sp)
    80006278:	e822                	sd	s0,16(sp)
    8000627a:	e426                	sd	s1,8(sp)
    8000627c:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    8000627e:	0001e497          	auipc	s1,0x1e
    80006282:	56a48493          	add	s1,s1,1386 # 800247e8 <pr>
    80006286:	00002597          	auipc	a1,0x2
    8000628a:	56a58593          	add	a1,a1,1386 # 800087f0 <etext+0x7f0>
    8000628e:	8526                	mv	a0,s1
    80006290:	00000097          	auipc	ra,0x0
    80006294:	27c080e7          	jalr	636(ra) # 8000650c <initlock>
  pr.locking = 1;
    80006298:	4785                	li	a5,1
    8000629a:	cc9c                	sw	a5,24(s1)
}
    8000629c:	60e2                	ld	ra,24(sp)
    8000629e:	6442                	ld	s0,16(sp)
    800062a0:	64a2                	ld	s1,8(sp)
    800062a2:	6105                	add	sp,sp,32
    800062a4:	8082                	ret

00000000800062a6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800062a6:	1141                	add	sp,sp,-16
    800062a8:	e406                	sd	ra,8(sp)
    800062aa:	e022                	sd	s0,0(sp)
    800062ac:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800062ae:	100007b7          	lui	a5,0x10000
    800062b2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800062b6:	10000737          	lui	a4,0x10000
    800062ba:	f8000693          	li	a3,-128
    800062be:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800062c2:	468d                	li	a3,3
    800062c4:	10000637          	lui	a2,0x10000
    800062c8:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800062cc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800062d0:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800062d4:	10000737          	lui	a4,0x10000
    800062d8:	461d                	li	a2,7
    800062da:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800062de:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800062e2:	00002597          	auipc	a1,0x2
    800062e6:	51658593          	add	a1,a1,1302 # 800087f8 <etext+0x7f8>
    800062ea:	0001e517          	auipc	a0,0x1e
    800062ee:	51e50513          	add	a0,a0,1310 # 80024808 <uart_tx_lock>
    800062f2:	00000097          	auipc	ra,0x0
    800062f6:	21a080e7          	jalr	538(ra) # 8000650c <initlock>
}
    800062fa:	60a2                	ld	ra,8(sp)
    800062fc:	6402                	ld	s0,0(sp)
    800062fe:	0141                	add	sp,sp,16
    80006300:	8082                	ret

0000000080006302 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006302:	1101                	add	sp,sp,-32
    80006304:	ec06                	sd	ra,24(sp)
    80006306:	e822                	sd	s0,16(sp)
    80006308:	e426                	sd	s1,8(sp)
    8000630a:	1000                	add	s0,sp,32
    8000630c:	84aa                	mv	s1,a0
  push_off();
    8000630e:	00000097          	auipc	ra,0x0
    80006312:	242080e7          	jalr	578(ra) # 80006550 <push_off>

  if(panicked){
    80006316:	00005797          	auipc	a5,0x5
    8000631a:	0a67a783          	lw	a5,166(a5) # 8000b3bc <panicked>
    8000631e:	eb85                	bnez	a5,8000634e <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006320:	10000737          	lui	a4,0x10000
    80006324:	0715                	add	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006326:	00074783          	lbu	a5,0(a4)
    8000632a:	0207f793          	and	a5,a5,32
    8000632e:	dfe5                	beqz	a5,80006326 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006330:	0ff4f513          	zext.b	a0,s1
    80006334:	100007b7          	lui	a5,0x10000
    80006338:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000633c:	00000097          	auipc	ra,0x0
    80006340:	2b4080e7          	jalr	692(ra) # 800065f0 <pop_off>
}
    80006344:	60e2                	ld	ra,24(sp)
    80006346:	6442                	ld	s0,16(sp)
    80006348:	64a2                	ld	s1,8(sp)
    8000634a:	6105                	add	sp,sp,32
    8000634c:	8082                	ret
    for(;;)
    8000634e:	a001                	j	8000634e <uartputc_sync+0x4c>

0000000080006350 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006350:	00005797          	auipc	a5,0x5
    80006354:	0707b783          	ld	a5,112(a5) # 8000b3c0 <uart_tx_r>
    80006358:	00005717          	auipc	a4,0x5
    8000635c:	07073703          	ld	a4,112(a4) # 8000b3c8 <uart_tx_w>
    80006360:	06f70f63          	beq	a4,a5,800063de <uartstart+0x8e>
{
    80006364:	7139                	add	sp,sp,-64
    80006366:	fc06                	sd	ra,56(sp)
    80006368:	f822                	sd	s0,48(sp)
    8000636a:	f426                	sd	s1,40(sp)
    8000636c:	f04a                	sd	s2,32(sp)
    8000636e:	ec4e                	sd	s3,24(sp)
    80006370:	e852                	sd	s4,16(sp)
    80006372:	e456                	sd	s5,8(sp)
    80006374:	e05a                	sd	s6,0(sp)
    80006376:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006378:	10000937          	lui	s2,0x10000
    8000637c:	0915                	add	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000637e:	0001ea97          	auipc	s5,0x1e
    80006382:	48aa8a93          	add	s5,s5,1162 # 80024808 <uart_tx_lock>
    uart_tx_r += 1;
    80006386:	00005497          	auipc	s1,0x5
    8000638a:	03a48493          	add	s1,s1,58 # 8000b3c0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    8000638e:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80006392:	00005997          	auipc	s3,0x5
    80006396:	03698993          	add	s3,s3,54 # 8000b3c8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000639a:	00094703          	lbu	a4,0(s2)
    8000639e:	02077713          	and	a4,a4,32
    800063a2:	c705                	beqz	a4,800063ca <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800063a4:	01f7f713          	and	a4,a5,31
    800063a8:	9756                	add	a4,a4,s5
    800063aa:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800063ae:	0785                	add	a5,a5,1
    800063b0:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800063b2:	8526                	mv	a0,s1
    800063b4:	ffffb097          	auipc	ra,0xffffb
    800063b8:	3d0080e7          	jalr	976(ra) # 80001784 <wakeup>
    WriteReg(THR, c);
    800063bc:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800063c0:	609c                	ld	a5,0(s1)
    800063c2:	0009b703          	ld	a4,0(s3)
    800063c6:	fcf71ae3          	bne	a4,a5,8000639a <uartstart+0x4a>
  }
}
    800063ca:	70e2                	ld	ra,56(sp)
    800063cc:	7442                	ld	s0,48(sp)
    800063ce:	74a2                	ld	s1,40(sp)
    800063d0:	7902                	ld	s2,32(sp)
    800063d2:	69e2                	ld	s3,24(sp)
    800063d4:	6a42                	ld	s4,16(sp)
    800063d6:	6aa2                	ld	s5,8(sp)
    800063d8:	6b02                	ld	s6,0(sp)
    800063da:	6121                	add	sp,sp,64
    800063dc:	8082                	ret
    800063de:	8082                	ret

00000000800063e0 <uartputc>:
{
    800063e0:	7179                	add	sp,sp,-48
    800063e2:	f406                	sd	ra,40(sp)
    800063e4:	f022                	sd	s0,32(sp)
    800063e6:	ec26                	sd	s1,24(sp)
    800063e8:	e84a                	sd	s2,16(sp)
    800063ea:	e44e                	sd	s3,8(sp)
    800063ec:	e052                	sd	s4,0(sp)
    800063ee:	1800                	add	s0,sp,48
    800063f0:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800063f2:	0001e517          	auipc	a0,0x1e
    800063f6:	41650513          	add	a0,a0,1046 # 80024808 <uart_tx_lock>
    800063fa:	00000097          	auipc	ra,0x0
    800063fe:	1a2080e7          	jalr	418(ra) # 8000659c <acquire>
  if(panicked){
    80006402:	00005797          	auipc	a5,0x5
    80006406:	fba7a783          	lw	a5,-70(a5) # 8000b3bc <panicked>
    8000640a:	e7c9                	bnez	a5,80006494 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000640c:	00005717          	auipc	a4,0x5
    80006410:	fbc73703          	ld	a4,-68(a4) # 8000b3c8 <uart_tx_w>
    80006414:	00005797          	auipc	a5,0x5
    80006418:	fac7b783          	ld	a5,-84(a5) # 8000b3c0 <uart_tx_r>
    8000641c:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006420:	0001e997          	auipc	s3,0x1e
    80006424:	3e898993          	add	s3,s3,1000 # 80024808 <uart_tx_lock>
    80006428:	00005497          	auipc	s1,0x5
    8000642c:	f9848493          	add	s1,s1,-104 # 8000b3c0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006430:	00005917          	auipc	s2,0x5
    80006434:	f9890913          	add	s2,s2,-104 # 8000b3c8 <uart_tx_w>
    80006438:	00e79f63          	bne	a5,a4,80006456 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000643c:	85ce                	mv	a1,s3
    8000643e:	8526                	mv	a0,s1
    80006440:	ffffb097          	auipc	ra,0xffffb
    80006444:	2e0080e7          	jalr	736(ra) # 80001720 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006448:	00093703          	ld	a4,0(s2)
    8000644c:	609c                	ld	a5,0(s1)
    8000644e:	02078793          	add	a5,a5,32
    80006452:	fee785e3          	beq	a5,a4,8000643c <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006456:	0001e497          	auipc	s1,0x1e
    8000645a:	3b248493          	add	s1,s1,946 # 80024808 <uart_tx_lock>
    8000645e:	01f77793          	and	a5,a4,31
    80006462:	97a6                	add	a5,a5,s1
    80006464:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006468:	0705                	add	a4,a4,1
    8000646a:	00005797          	auipc	a5,0x5
    8000646e:	f4e7bf23          	sd	a4,-162(a5) # 8000b3c8 <uart_tx_w>
  uartstart();
    80006472:	00000097          	auipc	ra,0x0
    80006476:	ede080e7          	jalr	-290(ra) # 80006350 <uartstart>
  release(&uart_tx_lock);
    8000647a:	8526                	mv	a0,s1
    8000647c:	00000097          	auipc	ra,0x0
    80006480:	1d4080e7          	jalr	468(ra) # 80006650 <release>
}
    80006484:	70a2                	ld	ra,40(sp)
    80006486:	7402                	ld	s0,32(sp)
    80006488:	64e2                	ld	s1,24(sp)
    8000648a:	6942                	ld	s2,16(sp)
    8000648c:	69a2                	ld	s3,8(sp)
    8000648e:	6a02                	ld	s4,0(sp)
    80006490:	6145                	add	sp,sp,48
    80006492:	8082                	ret
    for(;;)
    80006494:	a001                	j	80006494 <uartputc+0xb4>

0000000080006496 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006496:	1141                	add	sp,sp,-16
    80006498:	e422                	sd	s0,8(sp)
    8000649a:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000649c:	100007b7          	lui	a5,0x10000
    800064a0:	0795                	add	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800064a2:	0007c783          	lbu	a5,0(a5)
    800064a6:	8b85                	and	a5,a5,1
    800064a8:	cb81                	beqz	a5,800064b8 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800064aa:	100007b7          	lui	a5,0x10000
    800064ae:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800064b2:	6422                	ld	s0,8(sp)
    800064b4:	0141                	add	sp,sp,16
    800064b6:	8082                	ret
    return -1;
    800064b8:	557d                	li	a0,-1
    800064ba:	bfe5                	j	800064b2 <uartgetc+0x1c>

00000000800064bc <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800064bc:	1101                	add	sp,sp,-32
    800064be:	ec06                	sd	ra,24(sp)
    800064c0:	e822                	sd	s0,16(sp)
    800064c2:	e426                	sd	s1,8(sp)
    800064c4:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800064c6:	54fd                	li	s1,-1
    800064c8:	a029                	j	800064d2 <uartintr+0x16>
      break;
    consoleintr(c);
    800064ca:	00000097          	auipc	ra,0x0
    800064ce:	8ce080e7          	jalr	-1842(ra) # 80005d98 <consoleintr>
    int c = uartgetc();
    800064d2:	00000097          	auipc	ra,0x0
    800064d6:	fc4080e7          	jalr	-60(ra) # 80006496 <uartgetc>
    if(c == -1)
    800064da:	fe9518e3          	bne	a0,s1,800064ca <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800064de:	0001e497          	auipc	s1,0x1e
    800064e2:	32a48493          	add	s1,s1,810 # 80024808 <uart_tx_lock>
    800064e6:	8526                	mv	a0,s1
    800064e8:	00000097          	auipc	ra,0x0
    800064ec:	0b4080e7          	jalr	180(ra) # 8000659c <acquire>
  uartstart();
    800064f0:	00000097          	auipc	ra,0x0
    800064f4:	e60080e7          	jalr	-416(ra) # 80006350 <uartstart>
  release(&uart_tx_lock);
    800064f8:	8526                	mv	a0,s1
    800064fa:	00000097          	auipc	ra,0x0
    800064fe:	156080e7          	jalr	342(ra) # 80006650 <release>
}
    80006502:	60e2                	ld	ra,24(sp)
    80006504:	6442                	ld	s0,16(sp)
    80006506:	64a2                	ld	s1,8(sp)
    80006508:	6105                	add	sp,sp,32
    8000650a:	8082                	ret

000000008000650c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000650c:	1141                	add	sp,sp,-16
    8000650e:	e422                	sd	s0,8(sp)
    80006510:	0800                	add	s0,sp,16
  lk->name = name;
    80006512:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006514:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006518:	00053823          	sd	zero,16(a0)
}
    8000651c:	6422                	ld	s0,8(sp)
    8000651e:	0141                	add	sp,sp,16
    80006520:	8082                	ret

0000000080006522 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006522:	411c                	lw	a5,0(a0)
    80006524:	e399                	bnez	a5,8000652a <holding+0x8>
    80006526:	4501                	li	a0,0
  return r;
}
    80006528:	8082                	ret
{
    8000652a:	1101                	add	sp,sp,-32
    8000652c:	ec06                	sd	ra,24(sp)
    8000652e:	e822                	sd	s0,16(sp)
    80006530:	e426                	sd	s1,8(sp)
    80006532:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006534:	6904                	ld	s1,16(a0)
    80006536:	ffffb097          	auipc	ra,0xffffb
    8000653a:	a9c080e7          	jalr	-1380(ra) # 80000fd2 <mycpu>
    8000653e:	40a48533          	sub	a0,s1,a0
    80006542:	00153513          	seqz	a0,a0
}
    80006546:	60e2                	ld	ra,24(sp)
    80006548:	6442                	ld	s0,16(sp)
    8000654a:	64a2                	ld	s1,8(sp)
    8000654c:	6105                	add	sp,sp,32
    8000654e:	8082                	ret

0000000080006550 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006550:	1101                	add	sp,sp,-32
    80006552:	ec06                	sd	ra,24(sp)
    80006554:	e822                	sd	s0,16(sp)
    80006556:	e426                	sd	s1,8(sp)
    80006558:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000655a:	100024f3          	csrr	s1,sstatus
    8000655e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006562:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006564:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006568:	ffffb097          	auipc	ra,0xffffb
    8000656c:	a6a080e7          	jalr	-1430(ra) # 80000fd2 <mycpu>
    80006570:	5d3c                	lw	a5,120(a0)
    80006572:	cf89                	beqz	a5,8000658c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006574:	ffffb097          	auipc	ra,0xffffb
    80006578:	a5e080e7          	jalr	-1442(ra) # 80000fd2 <mycpu>
    8000657c:	5d3c                	lw	a5,120(a0)
    8000657e:	2785                	addw	a5,a5,1
    80006580:	dd3c                	sw	a5,120(a0)
}
    80006582:	60e2                	ld	ra,24(sp)
    80006584:	6442                	ld	s0,16(sp)
    80006586:	64a2                	ld	s1,8(sp)
    80006588:	6105                	add	sp,sp,32
    8000658a:	8082                	ret
    mycpu()->intena = old;
    8000658c:	ffffb097          	auipc	ra,0xffffb
    80006590:	a46080e7          	jalr	-1466(ra) # 80000fd2 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006594:	8085                	srl	s1,s1,0x1
    80006596:	8885                	and	s1,s1,1
    80006598:	dd64                	sw	s1,124(a0)
    8000659a:	bfe9                	j	80006574 <push_off+0x24>

000000008000659c <acquire>:
{
    8000659c:	1101                	add	sp,sp,-32
    8000659e:	ec06                	sd	ra,24(sp)
    800065a0:	e822                	sd	s0,16(sp)
    800065a2:	e426                	sd	s1,8(sp)
    800065a4:	1000                	add	s0,sp,32
    800065a6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800065a8:	00000097          	auipc	ra,0x0
    800065ac:	fa8080e7          	jalr	-88(ra) # 80006550 <push_off>
  if(holding(lk))
    800065b0:	8526                	mv	a0,s1
    800065b2:	00000097          	auipc	ra,0x0
    800065b6:	f70080e7          	jalr	-144(ra) # 80006522 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800065ba:	4705                	li	a4,1
  if(holding(lk))
    800065bc:	e115                	bnez	a0,800065e0 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800065be:	87ba                	mv	a5,a4
    800065c0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800065c4:	2781                	sext.w	a5,a5
    800065c6:	ffe5                	bnez	a5,800065be <acquire+0x22>
  __sync_synchronize();
    800065c8:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800065cc:	ffffb097          	auipc	ra,0xffffb
    800065d0:	a06080e7          	jalr	-1530(ra) # 80000fd2 <mycpu>
    800065d4:	e888                	sd	a0,16(s1)
}
    800065d6:	60e2                	ld	ra,24(sp)
    800065d8:	6442                	ld	s0,16(sp)
    800065da:	64a2                	ld	s1,8(sp)
    800065dc:	6105                	add	sp,sp,32
    800065de:	8082                	ret
    panic("acquire");
    800065e0:	00002517          	auipc	a0,0x2
    800065e4:	22050513          	add	a0,a0,544 # 80008800 <etext+0x800>
    800065e8:	00000097          	auipc	ra,0x0
    800065ec:	a3a080e7          	jalr	-1478(ra) # 80006022 <panic>

00000000800065f0 <pop_off>:

void
pop_off(void)
{
    800065f0:	1141                	add	sp,sp,-16
    800065f2:	e406                	sd	ra,8(sp)
    800065f4:	e022                	sd	s0,0(sp)
    800065f6:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    800065f8:	ffffb097          	auipc	ra,0xffffb
    800065fc:	9da080e7          	jalr	-1574(ra) # 80000fd2 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006600:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006604:	8b89                	and	a5,a5,2
  if(intr_get())
    80006606:	e78d                	bnez	a5,80006630 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006608:	5d3c                	lw	a5,120(a0)
    8000660a:	02f05b63          	blez	a5,80006640 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000660e:	37fd                	addw	a5,a5,-1
    80006610:	0007871b          	sext.w	a4,a5
    80006614:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006616:	eb09                	bnez	a4,80006628 <pop_off+0x38>
    80006618:	5d7c                	lw	a5,124(a0)
    8000661a:	c799                	beqz	a5,80006628 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000661c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006620:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006624:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006628:	60a2                	ld	ra,8(sp)
    8000662a:	6402                	ld	s0,0(sp)
    8000662c:	0141                	add	sp,sp,16
    8000662e:	8082                	ret
    panic("pop_off - interruptible");
    80006630:	00002517          	auipc	a0,0x2
    80006634:	1d850513          	add	a0,a0,472 # 80008808 <etext+0x808>
    80006638:	00000097          	auipc	ra,0x0
    8000663c:	9ea080e7          	jalr	-1558(ra) # 80006022 <panic>
    panic("pop_off");
    80006640:	00002517          	auipc	a0,0x2
    80006644:	1e050513          	add	a0,a0,480 # 80008820 <etext+0x820>
    80006648:	00000097          	auipc	ra,0x0
    8000664c:	9da080e7          	jalr	-1574(ra) # 80006022 <panic>

0000000080006650 <release>:
{
    80006650:	1101                	add	sp,sp,-32
    80006652:	ec06                	sd	ra,24(sp)
    80006654:	e822                	sd	s0,16(sp)
    80006656:	e426                	sd	s1,8(sp)
    80006658:	1000                	add	s0,sp,32
    8000665a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000665c:	00000097          	auipc	ra,0x0
    80006660:	ec6080e7          	jalr	-314(ra) # 80006522 <holding>
    80006664:	c115                	beqz	a0,80006688 <release+0x38>
  lk->cpu = 0;
    80006666:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000666a:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    8000666e:	0310000f          	fence	rw,w
    80006672:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006676:	00000097          	auipc	ra,0x0
    8000667a:	f7a080e7          	jalr	-134(ra) # 800065f0 <pop_off>
}
    8000667e:	60e2                	ld	ra,24(sp)
    80006680:	6442                	ld	s0,16(sp)
    80006682:	64a2                	ld	s1,8(sp)
    80006684:	6105                	add	sp,sp,32
    80006686:	8082                	ret
    panic("release");
    80006688:	00002517          	auipc	a0,0x2
    8000668c:	1a050513          	add	a0,a0,416 # 80008828 <etext+0x828>
    80006690:	00000097          	auipc	ra,0x0
    80006694:	992080e7          	jalr	-1646(ra) # 80006022 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	sll	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	sll	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
