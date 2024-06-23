
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	3d013103          	ld	sp,976(sp) # 8000b3d0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	add	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	309050ef          	jal	80005b1e <start>

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
    80000034:	86078793          	add	a5,a5,-1952 # 80024890 <end>
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
    8000004c:	17c080e7          	jalr	380(ra) # 800001c4 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	0000b917          	auipc	s2,0xb
    80000054:	3d090913          	add	s2,s2,976 # 8000b420 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	512080e7          	jalr	1298(ra) # 8000656c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	5b2080e7          	jalr	1458(ra) # 80006620 <release>
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
    8000008e:	f68080e7          	jalr	-152(ra) # 80005ff2 <panic>

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
    800000f2:	33250513          	add	a0,a0,818 # 8000b420 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	3e6080e7          	jalr	998(ra) # 800064dc <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	sll	a1,a1,0x1b
    80000102:	00024517          	auipc	a0,0x24
    80000106:	78e50513          	add	a0,a0,1934 # 80024890 <end>
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
    80000128:	2fc48493          	add	s1,s1,764 # 8000b420 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	43e080e7          	jalr	1086(ra) # 8000656c <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	0000b517          	auipc	a0,0xb
    80000140:	2e450513          	add	a0,a0,740 # 8000b420 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	4da080e7          	jalr	1242(ra) # 80006620 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	070080e7          	jalr	112(ra) # 800001c4 <memset>
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
    8000016c:	2b850513          	add	a0,a0,696 # 8000b420 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	4b0080e7          	jalr	1200(ra) # 80006620 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <fmem>:

uint64 fmem(void){
    8000017a:	1101                	add	sp,sp,-32
    8000017c:	ec06                	sd	ra,24(sp)
    8000017e:	e822                	sd	s0,16(sp)
    80000180:	e426                	sd	s1,8(sp)
    80000182:	1000                	add	s0,sp,32
    struct run *cur;
    uint64 count = 0;

    acquire(&kmem.lock);
    80000184:	0000b497          	auipc	s1,0xb
    80000188:	29c48493          	add	s1,s1,668 # 8000b420 <kmem>
    8000018c:	8526                	mv	a0,s1
    8000018e:	00006097          	auipc	ra,0x6
    80000192:	3de080e7          	jalr	990(ra) # 8000656c <acquire>
    cur = kmem.freelist;
    80000196:	6c9c                	ld	a5,24(s1)
    while(cur) {
    80000198:	c785                	beqz	a5,800001c0 <fmem+0x46>
    uint64 count = 0;
    8000019a:	4481                	li	s1,0
      cur = cur->next;
    8000019c:	639c                	ld	a5,0(a5)
      count++;
    8000019e:	0485                	add	s1,s1,1
    while(cur) {
    800001a0:	fff5                	bnez	a5,8000019c <fmem+0x22>
    }
    release(&kmem.lock);
    800001a2:	0000b517          	auipc	a0,0xb
    800001a6:	27e50513          	add	a0,a0,638 # 8000b420 <kmem>
    800001aa:	00006097          	auipc	ra,0x6
    800001ae:	476080e7          	jalr	1142(ra) # 80006620 <release>

    return (count << 12);
}
    800001b2:	00c49513          	sll	a0,s1,0xc
    800001b6:	60e2                	ld	ra,24(sp)
    800001b8:	6442                	ld	s0,16(sp)
    800001ba:	64a2                	ld	s1,8(sp)
    800001bc:	6105                	add	sp,sp,32
    800001be:	8082                	ret
    uint64 count = 0;
    800001c0:	4481                	li	s1,0
    800001c2:	b7c5                	j	800001a2 <fmem+0x28>

00000000800001c4 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c4:	1141                	add	sp,sp,-16
    800001c6:	e422                	sd	s0,8(sp)
    800001c8:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001ca:	ca19                	beqz	a2,800001e0 <memset+0x1c>
    800001cc:	87aa                	mv	a5,a0
    800001ce:	1602                	sll	a2,a2,0x20
    800001d0:	9201                	srl	a2,a2,0x20
    800001d2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001da:	0785                	add	a5,a5,1
    800001dc:	fee79de3          	bne	a5,a4,800001d6 <memset+0x12>
  }
  return dst;
}
    800001e0:	6422                	ld	s0,8(sp)
    800001e2:	0141                	add	sp,sp,16
    800001e4:	8082                	ret

00000000800001e6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e6:	1141                	add	sp,sp,-16
    800001e8:	e422                	sd	s0,8(sp)
    800001ea:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ec:	ca05                	beqz	a2,8000021c <memcmp+0x36>
    800001ee:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001f2:	1682                	sll	a3,a3,0x20
    800001f4:	9281                	srl	a3,a3,0x20
    800001f6:	0685                	add	a3,a3,1
    800001f8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fa:	00054783          	lbu	a5,0(a0)
    800001fe:	0005c703          	lbu	a4,0(a1)
    80000202:	00e79863          	bne	a5,a4,80000212 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000206:	0505                	add	a0,a0,1
    80000208:	0585                	add	a1,a1,1
  while(n-- > 0){
    8000020a:	fed518e3          	bne	a0,a3,800001fa <memcmp+0x14>
  }

  return 0;
    8000020e:	4501                	li	a0,0
    80000210:	a019                	j	80000216 <memcmp+0x30>
      return *s1 - *s2;
    80000212:	40e7853b          	subw	a0,a5,a4
}
    80000216:	6422                	ld	s0,8(sp)
    80000218:	0141                	add	sp,sp,16
    8000021a:	8082                	ret
  return 0;
    8000021c:	4501                	li	a0,0
    8000021e:	bfe5                	j	80000216 <memcmp+0x30>

0000000080000220 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000220:	1141                	add	sp,sp,-16
    80000222:	e422                	sd	s0,8(sp)
    80000224:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000226:	c205                	beqz	a2,80000246 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000228:	02a5e263          	bltu	a1,a0,8000024c <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000022c:	1602                	sll	a2,a2,0x20
    8000022e:	9201                	srl	a2,a2,0x20
    80000230:	00c587b3          	add	a5,a1,a2
{
    80000234:	872a                	mv	a4,a0
      *d++ = *s++;
    80000236:	0585                	add	a1,a1,1
    80000238:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffda771>
    8000023a:	fff5c683          	lbu	a3,-1(a1)
    8000023e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000242:	feb79ae3          	bne	a5,a1,80000236 <memmove+0x16>

  return dst;
}
    80000246:	6422                	ld	s0,8(sp)
    80000248:	0141                	add	sp,sp,16
    8000024a:	8082                	ret
  if(s < d && s + n > d){
    8000024c:	02061693          	sll	a3,a2,0x20
    80000250:	9281                	srl	a3,a3,0x20
    80000252:	00d58733          	add	a4,a1,a3
    80000256:	fce57be3          	bgeu	a0,a4,8000022c <memmove+0xc>
    d += n;
    8000025a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000025c:	fff6079b          	addw	a5,a2,-1
    80000260:	1782                	sll	a5,a5,0x20
    80000262:	9381                	srl	a5,a5,0x20
    80000264:	fff7c793          	not	a5,a5
    80000268:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000026a:	177d                	add	a4,a4,-1
    8000026c:	16fd                	add	a3,a3,-1
    8000026e:	00074603          	lbu	a2,0(a4)
    80000272:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000276:	fef71ae3          	bne	a4,a5,8000026a <memmove+0x4a>
    8000027a:	b7f1                	j	80000246 <memmove+0x26>

000000008000027c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000027c:	1141                	add	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    80000284:	00000097          	auipc	ra,0x0
    80000288:	f9c080e7          	jalr	-100(ra) # 80000220 <memmove>
}
    8000028c:	60a2                	ld	ra,8(sp)
    8000028e:	6402                	ld	s0,0(sp)
    80000290:	0141                	add	sp,sp,16
    80000292:	8082                	ret

0000000080000294 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000294:	1141                	add	sp,sp,-16
    80000296:	e422                	sd	s0,8(sp)
    80000298:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000029a:	ce11                	beqz	a2,800002b6 <strncmp+0x22>
    8000029c:	00054783          	lbu	a5,0(a0)
    800002a0:	cf89                	beqz	a5,800002ba <strncmp+0x26>
    800002a2:	0005c703          	lbu	a4,0(a1)
    800002a6:	00f71a63          	bne	a4,a5,800002ba <strncmp+0x26>
    n--, p++, q++;
    800002aa:	367d                	addw	a2,a2,-1
    800002ac:	0505                	add	a0,a0,1
    800002ae:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b0:	f675                	bnez	a2,8000029c <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b2:	4501                	li	a0,0
    800002b4:	a801                	j	800002c4 <strncmp+0x30>
    800002b6:	4501                	li	a0,0
    800002b8:	a031                	j	800002c4 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    800002ba:	00054503          	lbu	a0,0(a0)
    800002be:	0005c783          	lbu	a5,0(a1)
    800002c2:	9d1d                	subw	a0,a0,a5
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	add	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002ca:	1141                	add	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002d0:	87aa                	mv	a5,a0
    800002d2:	86b2                	mv	a3,a2
    800002d4:	367d                	addw	a2,a2,-1
    800002d6:	02d05563          	blez	a3,80000300 <strncpy+0x36>
    800002da:	0785                	add	a5,a5,1
    800002dc:	0005c703          	lbu	a4,0(a1)
    800002e0:	fee78fa3          	sb	a4,-1(a5)
    800002e4:	0585                	add	a1,a1,1
    800002e6:	f775                	bnez	a4,800002d2 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002e8:	873e                	mv	a4,a5
    800002ea:	9fb5                	addw	a5,a5,a3
    800002ec:	37fd                	addw	a5,a5,-1
    800002ee:	00c05963          	blez	a2,80000300 <strncpy+0x36>
    *s++ = 0;
    800002f2:	0705                	add	a4,a4,1
    800002f4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002f8:	40e786bb          	subw	a3,a5,a4
    800002fc:	fed04be3          	bgtz	a3,800002f2 <strncpy+0x28>
  return os;
}
    80000300:	6422                	ld	s0,8(sp)
    80000302:	0141                	add	sp,sp,16
    80000304:	8082                	ret

0000000080000306 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000306:	1141                	add	sp,sp,-16
    80000308:	e422                	sd	s0,8(sp)
    8000030a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000030c:	02c05363          	blez	a2,80000332 <safestrcpy+0x2c>
    80000310:	fff6069b          	addw	a3,a2,-1
    80000314:	1682                	sll	a3,a3,0x20
    80000316:	9281                	srl	a3,a3,0x20
    80000318:	96ae                	add	a3,a3,a1
    8000031a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000031c:	00d58963          	beq	a1,a3,8000032e <safestrcpy+0x28>
    80000320:	0585                	add	a1,a1,1
    80000322:	0785                	add	a5,a5,1
    80000324:	fff5c703          	lbu	a4,-1(a1)
    80000328:	fee78fa3          	sb	a4,-1(a5)
    8000032c:	fb65                	bnez	a4,8000031c <safestrcpy+0x16>
    ;
  *s = 0;
    8000032e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000332:	6422                	ld	s0,8(sp)
    80000334:	0141                	add	sp,sp,16
    80000336:	8082                	ret

0000000080000338 <strlen>:

int
strlen(const char *s)
{
    80000338:	1141                	add	sp,sp,-16
    8000033a:	e422                	sd	s0,8(sp)
    8000033c:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000033e:	00054783          	lbu	a5,0(a0)
    80000342:	cf91                	beqz	a5,8000035e <strlen+0x26>
    80000344:	0505                	add	a0,a0,1
    80000346:	87aa                	mv	a5,a0
    80000348:	86be                	mv	a3,a5
    8000034a:	0785                	add	a5,a5,1
    8000034c:	fff7c703          	lbu	a4,-1(a5)
    80000350:	ff65                	bnez	a4,80000348 <strlen+0x10>
    80000352:	40a6853b          	subw	a0,a3,a0
    80000356:	2505                	addw	a0,a0,1
    ;
  return n;
}
    80000358:	6422                	ld	s0,8(sp)
    8000035a:	0141                	add	sp,sp,16
    8000035c:	8082                	ret
  for(n = 0; s[n]; n++)
    8000035e:	4501                	li	a0,0
    80000360:	bfe5                	j	80000358 <strlen+0x20>

0000000080000362 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000362:	1141                	add	sp,sp,-16
    80000364:	e406                	sd	ra,8(sp)
    80000366:	e022                	sd	s0,0(sp)
    80000368:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    8000036a:	00001097          	auipc	ra,0x1
    8000036e:	bba080e7          	jalr	-1094(ra) # 80000f24 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000372:	0000b717          	auipc	a4,0xb
    80000376:	07e70713          	add	a4,a4,126 # 8000b3f0 <started>
  if(cpuid() == 0){
    8000037a:	c139                	beqz	a0,800003c0 <main+0x5e>
    while(started == 0)
    8000037c:	431c                	lw	a5,0(a4)
    8000037e:	2781                	sext.w	a5,a5
    80000380:	dff5                	beqz	a5,8000037c <main+0x1a>
      ;
    __sync_synchronize();
    80000382:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000386:	00001097          	auipc	ra,0x1
    8000038a:	b9e080e7          	jalr	-1122(ra) # 80000f24 <cpuid>
    8000038e:	85aa                	mv	a1,a0
    80000390:	00008517          	auipc	a0,0x8
    80000394:	ca850513          	add	a0,a0,-856 # 80008038 <etext+0x38>
    80000398:	00006097          	auipc	ra,0x6
    8000039c:	ca4080e7          	jalr	-860(ra) # 8000603c <printf>
    kvminithart();    // turn on paging
    800003a0:	00000097          	auipc	ra,0x0
    800003a4:	0d8080e7          	jalr	216(ra) # 80000478 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003a8:	00002097          	auipc	ra,0x2
    800003ac:	882080e7          	jalr	-1918(ra) # 80001c2a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003b0:	00005097          	auipc	ra,0x5
    800003b4:	0e4080e7          	jalr	228(ra) # 80005494 <plicinithart>
  }

  scheduler();        
    800003b8:	00001097          	auipc	ra,0x1
    800003bc:	09c080e7          	jalr	156(ra) # 80001454 <scheduler>
    consoleinit();
    800003c0:	00006097          	auipc	ra,0x6
    800003c4:	b42080e7          	jalr	-1214(ra) # 80005f02 <consoleinit>
    printfinit();
    800003c8:	00006097          	auipc	ra,0x6
    800003cc:	e7c080e7          	jalr	-388(ra) # 80006244 <printfinit>
    printf("\n");
    800003d0:	00008517          	auipc	a0,0x8
    800003d4:	c4850513          	add	a0,a0,-952 # 80008018 <etext+0x18>
    800003d8:	00006097          	auipc	ra,0x6
    800003dc:	c64080e7          	jalr	-924(ra) # 8000603c <printf>
    printf("xv6 kernel is booting\n");
    800003e0:	00008517          	auipc	a0,0x8
    800003e4:	c4050513          	add	a0,a0,-960 # 80008020 <etext+0x20>
    800003e8:	00006097          	auipc	ra,0x6
    800003ec:	c54080e7          	jalr	-940(ra) # 8000603c <printf>
    printf("\n");
    800003f0:	00008517          	auipc	a0,0x8
    800003f4:	c2850513          	add	a0,a0,-984 # 80008018 <etext+0x18>
    800003f8:	00006097          	auipc	ra,0x6
    800003fc:	c44080e7          	jalr	-956(ra) # 8000603c <printf>
    kinit();         // physical page allocator
    80000400:	00000097          	auipc	ra,0x0
    80000404:	cde080e7          	jalr	-802(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    80000408:	00000097          	auipc	ra,0x0
    8000040c:	34a080e7          	jalr	842(ra) # 80000752 <kvminit>
    kvminithart();   // turn on paging
    80000410:	00000097          	auipc	ra,0x0
    80000414:	068080e7          	jalr	104(ra) # 80000478 <kvminithart>
    procinit();      // process table
    80000418:	00001097          	auipc	ra,0x1
    8000041c:	a4a080e7          	jalr	-1462(ra) # 80000e62 <procinit>
    trapinit();      // trap vectors
    80000420:	00001097          	auipc	ra,0x1
    80000424:	7e2080e7          	jalr	2018(ra) # 80001c02 <trapinit>
    trapinithart();  // install kernel trap vector
    80000428:	00002097          	auipc	ra,0x2
    8000042c:	802080e7          	jalr	-2046(ra) # 80001c2a <trapinithart>
    plicinit();      // set up interrupt controller
    80000430:	00005097          	auipc	ra,0x5
    80000434:	04a080e7          	jalr	74(ra) # 8000547a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000438:	00005097          	auipc	ra,0x5
    8000043c:	05c080e7          	jalr	92(ra) # 80005494 <plicinithart>
    binit();         // buffer cache
    80000440:	00002097          	auipc	ra,0x2
    80000444:	120080e7          	jalr	288(ra) # 80002560 <binit>
    iinit();         // inode table
    80000448:	00002097          	auipc	ra,0x2
    8000044c:	7d6080e7          	jalr	2006(ra) # 80002c1e <iinit>
    fileinit();      // file table
    80000450:	00003097          	auipc	ra,0x3
    80000454:	786080e7          	jalr	1926(ra) # 80003bd6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000458:	00005097          	auipc	ra,0x5
    8000045c:	144080e7          	jalr	324(ra) # 8000559c <virtio_disk_init>
    userinit();      // first user process
    80000460:	00001097          	auipc	ra,0x1
    80000464:	dcc080e7          	jalr	-564(ra) # 8000122c <userinit>
    __sync_synchronize();
    80000468:	0330000f          	fence	rw,rw
    started = 1;
    8000046c:	4785                	li	a5,1
    8000046e:	0000b717          	auipc	a4,0xb
    80000472:	f8f72123          	sw	a5,-126(a4) # 8000b3f0 <started>
    80000476:	b789                	j	800003b8 <main+0x56>

0000000080000478 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000478:	1141                	add	sp,sp,-16
    8000047a:	e422                	sd	s0,8(sp)
    8000047c:	0800                	add	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000047e:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000482:	0000b797          	auipc	a5,0xb
    80000486:	f767b783          	ld	a5,-138(a5) # 8000b3f8 <kernel_pagetable>
    8000048a:	83b1                	srl	a5,a5,0xc
    8000048c:	577d                	li	a4,-1
    8000048e:	177e                	sll	a4,a4,0x3f
    80000490:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000492:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000496:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000049a:	6422                	ld	s0,8(sp)
    8000049c:	0141                	add	sp,sp,16
    8000049e:	8082                	ret

00000000800004a0 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004a0:	7139                	add	sp,sp,-64
    800004a2:	fc06                	sd	ra,56(sp)
    800004a4:	f822                	sd	s0,48(sp)
    800004a6:	f426                	sd	s1,40(sp)
    800004a8:	f04a                	sd	s2,32(sp)
    800004aa:	ec4e                	sd	s3,24(sp)
    800004ac:	e852                	sd	s4,16(sp)
    800004ae:	e456                	sd	s5,8(sp)
    800004b0:	e05a                	sd	s6,0(sp)
    800004b2:	0080                	add	s0,sp,64
    800004b4:	84aa                	mv	s1,a0
    800004b6:	89ae                	mv	s3,a1
    800004b8:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004ba:	57fd                	li	a5,-1
    800004bc:	83e9                	srl	a5,a5,0x1a
    800004be:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004c0:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004c2:	04b7f263          	bgeu	a5,a1,80000506 <walk+0x66>
    panic("walk");
    800004c6:	00008517          	auipc	a0,0x8
    800004ca:	b8a50513          	add	a0,a0,-1142 # 80008050 <etext+0x50>
    800004ce:	00006097          	auipc	ra,0x6
    800004d2:	b24080e7          	jalr	-1244(ra) # 80005ff2 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004d6:	060a8663          	beqz	s5,80000542 <walk+0xa2>
    800004da:	00000097          	auipc	ra,0x0
    800004de:	c40080e7          	jalr	-960(ra) # 8000011a <kalloc>
    800004e2:	84aa                	mv	s1,a0
    800004e4:	c529                	beqz	a0,8000052e <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004e6:	6605                	lui	a2,0x1
    800004e8:	4581                	li	a1,0
    800004ea:	00000097          	auipc	ra,0x0
    800004ee:	cda080e7          	jalr	-806(ra) # 800001c4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004f2:	00c4d793          	srl	a5,s1,0xc
    800004f6:	07aa                	sll	a5,a5,0xa
    800004f8:	0017e793          	or	a5,a5,1
    800004fc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000500:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffda767>
    80000502:	036a0063          	beq	s4,s6,80000522 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000506:	0149d933          	srl	s2,s3,s4
    8000050a:	1ff97913          	and	s2,s2,511
    8000050e:	090e                	sll	s2,s2,0x3
    80000510:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000512:	00093483          	ld	s1,0(s2)
    80000516:	0014f793          	and	a5,s1,1
    8000051a:	dfd5                	beqz	a5,800004d6 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000051c:	80a9                	srl	s1,s1,0xa
    8000051e:	04b2                	sll	s1,s1,0xc
    80000520:	b7c5                	j	80000500 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000522:	00c9d513          	srl	a0,s3,0xc
    80000526:	1ff57513          	and	a0,a0,511
    8000052a:	050e                	sll	a0,a0,0x3
    8000052c:	9526                	add	a0,a0,s1
}
    8000052e:	70e2                	ld	ra,56(sp)
    80000530:	7442                	ld	s0,48(sp)
    80000532:	74a2                	ld	s1,40(sp)
    80000534:	7902                	ld	s2,32(sp)
    80000536:	69e2                	ld	s3,24(sp)
    80000538:	6a42                	ld	s4,16(sp)
    8000053a:	6aa2                	ld	s5,8(sp)
    8000053c:	6b02                	ld	s6,0(sp)
    8000053e:	6121                	add	sp,sp,64
    80000540:	8082                	ret
        return 0;
    80000542:	4501                	li	a0,0
    80000544:	b7ed                	j	8000052e <walk+0x8e>

0000000080000546 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000546:	57fd                	li	a5,-1
    80000548:	83e9                	srl	a5,a5,0x1a
    8000054a:	00b7f463          	bgeu	a5,a1,80000552 <walkaddr+0xc>
    return 0;
    8000054e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000550:	8082                	ret
{
    80000552:	1141                	add	sp,sp,-16
    80000554:	e406                	sd	ra,8(sp)
    80000556:	e022                	sd	s0,0(sp)
    80000558:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000055a:	4601                	li	a2,0
    8000055c:	00000097          	auipc	ra,0x0
    80000560:	f44080e7          	jalr	-188(ra) # 800004a0 <walk>
  if(pte == 0)
    80000564:	c105                	beqz	a0,80000584 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000566:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000568:	0117f693          	and	a3,a5,17
    8000056c:	4745                	li	a4,17
    return 0;
    8000056e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000570:	00e68663          	beq	a3,a4,8000057c <walkaddr+0x36>
}
    80000574:	60a2                	ld	ra,8(sp)
    80000576:	6402                	ld	s0,0(sp)
    80000578:	0141                	add	sp,sp,16
    8000057a:	8082                	ret
  pa = PTE2PA(*pte);
    8000057c:	83a9                	srl	a5,a5,0xa
    8000057e:	00c79513          	sll	a0,a5,0xc
  return pa;
    80000582:	bfcd                	j	80000574 <walkaddr+0x2e>
    return 0;
    80000584:	4501                	li	a0,0
    80000586:	b7fd                	j	80000574 <walkaddr+0x2e>

0000000080000588 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000588:	715d                	add	sp,sp,-80
    8000058a:	e486                	sd	ra,72(sp)
    8000058c:	e0a2                	sd	s0,64(sp)
    8000058e:	fc26                	sd	s1,56(sp)
    80000590:	f84a                	sd	s2,48(sp)
    80000592:	f44e                	sd	s3,40(sp)
    80000594:	f052                	sd	s4,32(sp)
    80000596:	ec56                	sd	s5,24(sp)
    80000598:	e85a                	sd	s6,16(sp)
    8000059a:	e45e                	sd	s7,8(sp)
    8000059c:	0880                	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000059e:	03459793          	sll	a5,a1,0x34
    800005a2:	e7b9                	bnez	a5,800005f0 <mappages+0x68>
    800005a4:	8aaa                	mv	s5,a0
    800005a6:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800005a8:	03461793          	sll	a5,a2,0x34
    800005ac:	ebb1                	bnez	a5,80000600 <mappages+0x78>
    panic("mappages: size not aligned");

  if(size == 0)
    800005ae:	c22d                	beqz	a2,80000610 <mappages+0x88>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800005b0:	77fd                	lui	a5,0xfffff
    800005b2:	963e                	add	a2,a2,a5
    800005b4:	00b609b3          	add	s3,a2,a1
  a = va;
    800005b8:	892e                	mv	s2,a1
    800005ba:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005be:	6b85                	lui	s7,0x1
    800005c0:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800005c4:	4605                	li	a2,1
    800005c6:	85ca                	mv	a1,s2
    800005c8:	8556                	mv	a0,s5
    800005ca:	00000097          	auipc	ra,0x0
    800005ce:	ed6080e7          	jalr	-298(ra) # 800004a0 <walk>
    800005d2:	cd39                	beqz	a0,80000630 <mappages+0xa8>
    if(*pte & PTE_V)
    800005d4:	611c                	ld	a5,0(a0)
    800005d6:	8b85                	and	a5,a5,1
    800005d8:	e7a1                	bnez	a5,80000620 <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005da:	80b1                	srl	s1,s1,0xc
    800005dc:	04aa                	sll	s1,s1,0xa
    800005de:	0164e4b3          	or	s1,s1,s6
    800005e2:	0014e493          	or	s1,s1,1
    800005e6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005e8:	07390063          	beq	s2,s3,80000648 <mappages+0xc0>
    a += PGSIZE;
    800005ec:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ee:	bfc9                	j	800005c0 <mappages+0x38>
    panic("mappages: va not aligned");
    800005f0:	00008517          	auipc	a0,0x8
    800005f4:	a6850513          	add	a0,a0,-1432 # 80008058 <etext+0x58>
    800005f8:	00006097          	auipc	ra,0x6
    800005fc:	9fa080e7          	jalr	-1542(ra) # 80005ff2 <panic>
    panic("mappages: size not aligned");
    80000600:	00008517          	auipc	a0,0x8
    80000604:	a7850513          	add	a0,a0,-1416 # 80008078 <etext+0x78>
    80000608:	00006097          	auipc	ra,0x6
    8000060c:	9ea080e7          	jalr	-1558(ra) # 80005ff2 <panic>
    panic("mappages: size");
    80000610:	00008517          	auipc	a0,0x8
    80000614:	a8850513          	add	a0,a0,-1400 # 80008098 <etext+0x98>
    80000618:	00006097          	auipc	ra,0x6
    8000061c:	9da080e7          	jalr	-1574(ra) # 80005ff2 <panic>
      panic("mappages: remap");
    80000620:	00008517          	auipc	a0,0x8
    80000624:	a8850513          	add	a0,a0,-1400 # 800080a8 <etext+0xa8>
    80000628:	00006097          	auipc	ra,0x6
    8000062c:	9ca080e7          	jalr	-1590(ra) # 80005ff2 <panic>
      return -1;
    80000630:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000632:	60a6                	ld	ra,72(sp)
    80000634:	6406                	ld	s0,64(sp)
    80000636:	74e2                	ld	s1,56(sp)
    80000638:	7942                	ld	s2,48(sp)
    8000063a:	79a2                	ld	s3,40(sp)
    8000063c:	7a02                	ld	s4,32(sp)
    8000063e:	6ae2                	ld	s5,24(sp)
    80000640:	6b42                	ld	s6,16(sp)
    80000642:	6ba2                	ld	s7,8(sp)
    80000644:	6161                	add	sp,sp,80
    80000646:	8082                	ret
  return 0;
    80000648:	4501                	li	a0,0
    8000064a:	b7e5                	j	80000632 <mappages+0xaa>

000000008000064c <kvmmap>:
{
    8000064c:	1141                	add	sp,sp,-16
    8000064e:	e406                	sd	ra,8(sp)
    80000650:	e022                	sd	s0,0(sp)
    80000652:	0800                	add	s0,sp,16
    80000654:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000656:	86b2                	mv	a3,a2
    80000658:	863e                	mv	a2,a5
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	f2e080e7          	jalr	-210(ra) # 80000588 <mappages>
    80000662:	e509                	bnez	a0,8000066c <kvmmap+0x20>
}
    80000664:	60a2                	ld	ra,8(sp)
    80000666:	6402                	ld	s0,0(sp)
    80000668:	0141                	add	sp,sp,16
    8000066a:	8082                	ret
    panic("kvmmap");
    8000066c:	00008517          	auipc	a0,0x8
    80000670:	a4c50513          	add	a0,a0,-1460 # 800080b8 <etext+0xb8>
    80000674:	00006097          	auipc	ra,0x6
    80000678:	97e080e7          	jalr	-1666(ra) # 80005ff2 <panic>

000000008000067c <kvmmake>:
{
    8000067c:	1101                	add	sp,sp,-32
    8000067e:	ec06                	sd	ra,24(sp)
    80000680:	e822                	sd	s0,16(sp)
    80000682:	e426                	sd	s1,8(sp)
    80000684:	e04a                	sd	s2,0(sp)
    80000686:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000688:	00000097          	auipc	ra,0x0
    8000068c:	a92080e7          	jalr	-1390(ra) # 8000011a <kalloc>
    80000690:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000692:	6605                	lui	a2,0x1
    80000694:	4581                	li	a1,0
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	b2e080e7          	jalr	-1234(ra) # 800001c4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000069e:	4719                	li	a4,6
    800006a0:	6685                	lui	a3,0x1
    800006a2:	10000637          	lui	a2,0x10000
    800006a6:	100005b7          	lui	a1,0x10000
    800006aa:	8526                	mv	a0,s1
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	fa0080e7          	jalr	-96(ra) # 8000064c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800006b4:	4719                	li	a4,6
    800006b6:	6685                	lui	a3,0x1
    800006b8:	10001637          	lui	a2,0x10001
    800006bc:	100015b7          	lui	a1,0x10001
    800006c0:	8526                	mv	a0,s1
    800006c2:	00000097          	auipc	ra,0x0
    800006c6:	f8a080e7          	jalr	-118(ra) # 8000064c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006ca:	4719                	li	a4,6
    800006cc:	004006b7          	lui	a3,0x400
    800006d0:	0c000637          	lui	a2,0xc000
    800006d4:	0c0005b7          	lui	a1,0xc000
    800006d8:	8526                	mv	a0,s1
    800006da:	00000097          	auipc	ra,0x0
    800006de:	f72080e7          	jalr	-142(ra) # 8000064c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006e2:	00008917          	auipc	s2,0x8
    800006e6:	91e90913          	add	s2,s2,-1762 # 80008000 <etext>
    800006ea:	4729                	li	a4,10
    800006ec:	80008697          	auipc	a3,0x80008
    800006f0:	91468693          	add	a3,a3,-1772 # 8000 <_entry-0x7fff8000>
    800006f4:	4605                	li	a2,1
    800006f6:	067e                	sll	a2,a2,0x1f
    800006f8:	85b2                	mv	a1,a2
    800006fa:	8526                	mv	a0,s1
    800006fc:	00000097          	auipc	ra,0x0
    80000700:	f50080e7          	jalr	-176(ra) # 8000064c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000704:	46c5                	li	a3,17
    80000706:	06ee                	sll	a3,a3,0x1b
    80000708:	4719                	li	a4,6
    8000070a:	412686b3          	sub	a3,a3,s2
    8000070e:	864a                	mv	a2,s2
    80000710:	85ca                	mv	a1,s2
    80000712:	8526                	mv	a0,s1
    80000714:	00000097          	auipc	ra,0x0
    80000718:	f38080e7          	jalr	-200(ra) # 8000064c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000071c:	4729                	li	a4,10
    8000071e:	6685                	lui	a3,0x1
    80000720:	00007617          	auipc	a2,0x7
    80000724:	8e060613          	add	a2,a2,-1824 # 80007000 <_trampoline>
    80000728:	040005b7          	lui	a1,0x4000
    8000072c:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000072e:	05b2                	sll	a1,a1,0xc
    80000730:	8526                	mv	a0,s1
    80000732:	00000097          	auipc	ra,0x0
    80000736:	f1a080e7          	jalr	-230(ra) # 8000064c <kvmmap>
  proc_mapstacks(kpgtbl);
    8000073a:	8526                	mv	a0,s1
    8000073c:	00000097          	auipc	ra,0x0
    80000740:	682080e7          	jalr	1666(ra) # 80000dbe <proc_mapstacks>
}
    80000744:	8526                	mv	a0,s1
    80000746:	60e2                	ld	ra,24(sp)
    80000748:	6442                	ld	s0,16(sp)
    8000074a:	64a2                	ld	s1,8(sp)
    8000074c:	6902                	ld	s2,0(sp)
    8000074e:	6105                	add	sp,sp,32
    80000750:	8082                	ret

0000000080000752 <kvminit>:
{
    80000752:	1141                	add	sp,sp,-16
    80000754:	e406                	sd	ra,8(sp)
    80000756:	e022                	sd	s0,0(sp)
    80000758:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    8000075a:	00000097          	auipc	ra,0x0
    8000075e:	f22080e7          	jalr	-222(ra) # 8000067c <kvmmake>
    80000762:	0000b797          	auipc	a5,0xb
    80000766:	c8a7bb23          	sd	a0,-874(a5) # 8000b3f8 <kernel_pagetable>
}
    8000076a:	60a2                	ld	ra,8(sp)
    8000076c:	6402                	ld	s0,0(sp)
    8000076e:	0141                	add	sp,sp,16
    80000770:	8082                	ret

0000000080000772 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000772:	715d                	add	sp,sp,-80
    80000774:	e486                	sd	ra,72(sp)
    80000776:	e0a2                	sd	s0,64(sp)
    80000778:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000077a:	03459793          	sll	a5,a1,0x34
    8000077e:	e39d                	bnez	a5,800007a4 <uvmunmap+0x32>
    80000780:	f84a                	sd	s2,48(sp)
    80000782:	f44e                	sd	s3,40(sp)
    80000784:	f052                	sd	s4,32(sp)
    80000786:	ec56                	sd	s5,24(sp)
    80000788:	e85a                	sd	s6,16(sp)
    8000078a:	e45e                	sd	s7,8(sp)
    8000078c:	8a2a                	mv	s4,a0
    8000078e:	892e                	mv	s2,a1
    80000790:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000792:	0632                	sll	a2,a2,0xc
    80000794:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000798:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000079a:	6b05                	lui	s6,0x1
    8000079c:	0935fb63          	bgeu	a1,s3,80000832 <uvmunmap+0xc0>
    800007a0:	fc26                	sd	s1,56(sp)
    800007a2:	a8a9                	j	800007fc <uvmunmap+0x8a>
    800007a4:	fc26                	sd	s1,56(sp)
    800007a6:	f84a                	sd	s2,48(sp)
    800007a8:	f44e                	sd	s3,40(sp)
    800007aa:	f052                	sd	s4,32(sp)
    800007ac:	ec56                	sd	s5,24(sp)
    800007ae:	e85a                	sd	s6,16(sp)
    800007b0:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800007b2:	00008517          	auipc	a0,0x8
    800007b6:	90e50513          	add	a0,a0,-1778 # 800080c0 <etext+0xc0>
    800007ba:	00006097          	auipc	ra,0x6
    800007be:	838080e7          	jalr	-1992(ra) # 80005ff2 <panic>
      panic("uvmunmap: walk");
    800007c2:	00008517          	auipc	a0,0x8
    800007c6:	91650513          	add	a0,a0,-1770 # 800080d8 <etext+0xd8>
    800007ca:	00006097          	auipc	ra,0x6
    800007ce:	828080e7          	jalr	-2008(ra) # 80005ff2 <panic>
      panic("uvmunmap: not mapped");
    800007d2:	00008517          	auipc	a0,0x8
    800007d6:	91650513          	add	a0,a0,-1770 # 800080e8 <etext+0xe8>
    800007da:	00006097          	auipc	ra,0x6
    800007de:	818080e7          	jalr	-2024(ra) # 80005ff2 <panic>
      panic("uvmunmap: not a leaf");
    800007e2:	00008517          	auipc	a0,0x8
    800007e6:	91e50513          	add	a0,a0,-1762 # 80008100 <etext+0x100>
    800007ea:	00006097          	auipc	ra,0x6
    800007ee:	808080e7          	jalr	-2040(ra) # 80005ff2 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800007f2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007f6:	995a                	add	s2,s2,s6
    800007f8:	03397c63          	bgeu	s2,s3,80000830 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007fc:	4601                	li	a2,0
    800007fe:	85ca                	mv	a1,s2
    80000800:	8552                	mv	a0,s4
    80000802:	00000097          	auipc	ra,0x0
    80000806:	c9e080e7          	jalr	-866(ra) # 800004a0 <walk>
    8000080a:	84aa                	mv	s1,a0
    8000080c:	d95d                	beqz	a0,800007c2 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    8000080e:	6108                	ld	a0,0(a0)
    80000810:	00157793          	and	a5,a0,1
    80000814:	dfdd                	beqz	a5,800007d2 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000816:	3ff57793          	and	a5,a0,1023
    8000081a:	fd7784e3          	beq	a5,s7,800007e2 <uvmunmap+0x70>
    if(do_free){
    8000081e:	fc0a8ae3          	beqz	s5,800007f2 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80000822:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    80000824:	0532                	sll	a0,a0,0xc
    80000826:	fffff097          	auipc	ra,0xfffff
    8000082a:	7f6080e7          	jalr	2038(ra) # 8000001c <kfree>
    8000082e:	b7d1                	j	800007f2 <uvmunmap+0x80>
    80000830:	74e2                	ld	s1,56(sp)
    80000832:	7942                	ld	s2,48(sp)
    80000834:	79a2                	ld	s3,40(sp)
    80000836:	7a02                	ld	s4,32(sp)
    80000838:	6ae2                	ld	s5,24(sp)
    8000083a:	6b42                	ld	s6,16(sp)
    8000083c:	6ba2                	ld	s7,8(sp)
  }
}
    8000083e:	60a6                	ld	ra,72(sp)
    80000840:	6406                	ld	s0,64(sp)
    80000842:	6161                	add	sp,sp,80
    80000844:	8082                	ret

0000000080000846 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000846:	1101                	add	sp,sp,-32
    80000848:	ec06                	sd	ra,24(sp)
    8000084a:	e822                	sd	s0,16(sp)
    8000084c:	e426                	sd	s1,8(sp)
    8000084e:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000850:	00000097          	auipc	ra,0x0
    80000854:	8ca080e7          	jalr	-1846(ra) # 8000011a <kalloc>
    80000858:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000085a:	c519                	beqz	a0,80000868 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000085c:	6605                	lui	a2,0x1
    8000085e:	4581                	li	a1,0
    80000860:	00000097          	auipc	ra,0x0
    80000864:	964080e7          	jalr	-1692(ra) # 800001c4 <memset>
  return pagetable;
}
    80000868:	8526                	mv	a0,s1
    8000086a:	60e2                	ld	ra,24(sp)
    8000086c:	6442                	ld	s0,16(sp)
    8000086e:	64a2                	ld	s1,8(sp)
    80000870:	6105                	add	sp,sp,32
    80000872:	8082                	ret

0000000080000874 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000874:	7179                	add	sp,sp,-48
    80000876:	f406                	sd	ra,40(sp)
    80000878:	f022                	sd	s0,32(sp)
    8000087a:	ec26                	sd	s1,24(sp)
    8000087c:	e84a                	sd	s2,16(sp)
    8000087e:	e44e                	sd	s3,8(sp)
    80000880:	e052                	sd	s4,0(sp)
    80000882:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000884:	6785                	lui	a5,0x1
    80000886:	04f67863          	bgeu	a2,a5,800008d6 <uvmfirst+0x62>
    8000088a:	8a2a                	mv	s4,a0
    8000088c:	89ae                	mv	s3,a1
    8000088e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000890:	00000097          	auipc	ra,0x0
    80000894:	88a080e7          	jalr	-1910(ra) # 8000011a <kalloc>
    80000898:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000089a:	6605                	lui	a2,0x1
    8000089c:	4581                	li	a1,0
    8000089e:	00000097          	auipc	ra,0x0
    800008a2:	926080e7          	jalr	-1754(ra) # 800001c4 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800008a6:	4779                	li	a4,30
    800008a8:	86ca                	mv	a3,s2
    800008aa:	6605                	lui	a2,0x1
    800008ac:	4581                	li	a1,0
    800008ae:	8552                	mv	a0,s4
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	cd8080e7          	jalr	-808(ra) # 80000588 <mappages>
  memmove(mem, src, sz);
    800008b8:	8626                	mv	a2,s1
    800008ba:	85ce                	mv	a1,s3
    800008bc:	854a                	mv	a0,s2
    800008be:	00000097          	auipc	ra,0x0
    800008c2:	962080e7          	jalr	-1694(ra) # 80000220 <memmove>
}
    800008c6:	70a2                	ld	ra,40(sp)
    800008c8:	7402                	ld	s0,32(sp)
    800008ca:	64e2                	ld	s1,24(sp)
    800008cc:	6942                	ld	s2,16(sp)
    800008ce:	69a2                	ld	s3,8(sp)
    800008d0:	6a02                	ld	s4,0(sp)
    800008d2:	6145                	add	sp,sp,48
    800008d4:	8082                	ret
    panic("uvmfirst: more than a page");
    800008d6:	00008517          	auipc	a0,0x8
    800008da:	84250513          	add	a0,a0,-1982 # 80008118 <etext+0x118>
    800008de:	00005097          	auipc	ra,0x5
    800008e2:	714080e7          	jalr	1812(ra) # 80005ff2 <panic>

00000000800008e6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008e6:	1101                	add	sp,sp,-32
    800008e8:	ec06                	sd	ra,24(sp)
    800008ea:	e822                	sd	s0,16(sp)
    800008ec:	e426                	sd	s1,8(sp)
    800008ee:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008f0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008f2:	00b67d63          	bgeu	a2,a1,8000090c <uvmdealloc+0x26>
    800008f6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008f8:	6785                	lui	a5,0x1
    800008fa:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008fc:	00f60733          	add	a4,a2,a5
    80000900:	76fd                	lui	a3,0xfffff
    80000902:	8f75                	and	a4,a4,a3
    80000904:	97ae                	add	a5,a5,a1
    80000906:	8ff5                	and	a5,a5,a3
    80000908:	00f76863          	bltu	a4,a5,80000918 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000090c:	8526                	mv	a0,s1
    8000090e:	60e2                	ld	ra,24(sp)
    80000910:	6442                	ld	s0,16(sp)
    80000912:	64a2                	ld	s1,8(sp)
    80000914:	6105                	add	sp,sp,32
    80000916:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000918:	8f99                	sub	a5,a5,a4
    8000091a:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000091c:	4685                	li	a3,1
    8000091e:	0007861b          	sext.w	a2,a5
    80000922:	85ba                	mv	a1,a4
    80000924:	00000097          	auipc	ra,0x0
    80000928:	e4e080e7          	jalr	-434(ra) # 80000772 <uvmunmap>
    8000092c:	b7c5                	j	8000090c <uvmdealloc+0x26>

000000008000092e <uvmalloc>:
  if(newsz < oldsz)
    8000092e:	0ab66b63          	bltu	a2,a1,800009e4 <uvmalloc+0xb6>
{
    80000932:	7139                	add	sp,sp,-64
    80000934:	fc06                	sd	ra,56(sp)
    80000936:	f822                	sd	s0,48(sp)
    80000938:	ec4e                	sd	s3,24(sp)
    8000093a:	e852                	sd	s4,16(sp)
    8000093c:	e456                	sd	s5,8(sp)
    8000093e:	0080                	add	s0,sp,64
    80000940:	8aaa                	mv	s5,a0
    80000942:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000944:	6785                	lui	a5,0x1
    80000946:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000948:	95be                	add	a1,a1,a5
    8000094a:	77fd                	lui	a5,0xfffff
    8000094c:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000950:	08c9fc63          	bgeu	s3,a2,800009e8 <uvmalloc+0xba>
    80000954:	f426                	sd	s1,40(sp)
    80000956:	f04a                	sd	s2,32(sp)
    80000958:	e05a                	sd	s6,0(sp)
    8000095a:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000095c:	0126eb13          	or	s6,a3,18
    mem = kalloc();
    80000960:	fffff097          	auipc	ra,0xfffff
    80000964:	7ba080e7          	jalr	1978(ra) # 8000011a <kalloc>
    80000968:	84aa                	mv	s1,a0
    if(mem == 0){
    8000096a:	c915                	beqz	a0,8000099e <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    8000096c:	6605                	lui	a2,0x1
    8000096e:	4581                	li	a1,0
    80000970:	00000097          	auipc	ra,0x0
    80000974:	854080e7          	jalr	-1964(ra) # 800001c4 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000978:	875a                	mv	a4,s6
    8000097a:	86a6                	mv	a3,s1
    8000097c:	6605                	lui	a2,0x1
    8000097e:	85ca                	mv	a1,s2
    80000980:	8556                	mv	a0,s5
    80000982:	00000097          	auipc	ra,0x0
    80000986:	c06080e7          	jalr	-1018(ra) # 80000588 <mappages>
    8000098a:	ed05                	bnez	a0,800009c2 <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000098c:	6785                	lui	a5,0x1
    8000098e:	993e                	add	s2,s2,a5
    80000990:	fd4968e3          	bltu	s2,s4,80000960 <uvmalloc+0x32>
  return newsz;
    80000994:	8552                	mv	a0,s4
    80000996:	74a2                	ld	s1,40(sp)
    80000998:	7902                	ld	s2,32(sp)
    8000099a:	6b02                	ld	s6,0(sp)
    8000099c:	a821                	j	800009b4 <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    8000099e:	864e                	mv	a2,s3
    800009a0:	85ca                	mv	a1,s2
    800009a2:	8556                	mv	a0,s5
    800009a4:	00000097          	auipc	ra,0x0
    800009a8:	f42080e7          	jalr	-190(ra) # 800008e6 <uvmdealloc>
      return 0;
    800009ac:	4501                	li	a0,0
    800009ae:	74a2                	ld	s1,40(sp)
    800009b0:	7902                	ld	s2,32(sp)
    800009b2:	6b02                	ld	s6,0(sp)
}
    800009b4:	70e2                	ld	ra,56(sp)
    800009b6:	7442                	ld	s0,48(sp)
    800009b8:	69e2                	ld	s3,24(sp)
    800009ba:	6a42                	ld	s4,16(sp)
    800009bc:	6aa2                	ld	s5,8(sp)
    800009be:	6121                	add	sp,sp,64
    800009c0:	8082                	ret
      kfree(mem);
    800009c2:	8526                	mv	a0,s1
    800009c4:	fffff097          	auipc	ra,0xfffff
    800009c8:	658080e7          	jalr	1624(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009cc:	864e                	mv	a2,s3
    800009ce:	85ca                	mv	a1,s2
    800009d0:	8556                	mv	a0,s5
    800009d2:	00000097          	auipc	ra,0x0
    800009d6:	f14080e7          	jalr	-236(ra) # 800008e6 <uvmdealloc>
      return 0;
    800009da:	4501                	li	a0,0
    800009dc:	74a2                	ld	s1,40(sp)
    800009de:	7902                	ld	s2,32(sp)
    800009e0:	6b02                	ld	s6,0(sp)
    800009e2:	bfc9                	j	800009b4 <uvmalloc+0x86>
    return oldsz;
    800009e4:	852e                	mv	a0,a1
}
    800009e6:	8082                	ret
  return newsz;
    800009e8:	8532                	mv	a0,a2
    800009ea:	b7e9                	j	800009b4 <uvmalloc+0x86>

00000000800009ec <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009ec:	7179                	add	sp,sp,-48
    800009ee:	f406                	sd	ra,40(sp)
    800009f0:	f022                	sd	s0,32(sp)
    800009f2:	ec26                	sd	s1,24(sp)
    800009f4:	e84a                	sd	s2,16(sp)
    800009f6:	e44e                	sd	s3,8(sp)
    800009f8:	e052                	sd	s4,0(sp)
    800009fa:	1800                	add	s0,sp,48
    800009fc:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009fe:	84aa                	mv	s1,a0
    80000a00:	6905                	lui	s2,0x1
    80000a02:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a04:	4985                	li	s3,1
    80000a06:	a829                	j	80000a20 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a08:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000a0a:	00c79513          	sll	a0,a5,0xc
    80000a0e:	00000097          	auipc	ra,0x0
    80000a12:	fde080e7          	jalr	-34(ra) # 800009ec <freewalk>
      pagetable[i] = 0;
    80000a16:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000a1a:	04a1                	add	s1,s1,8
    80000a1c:	03248163          	beq	s1,s2,80000a3e <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000a20:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a22:	00f7f713          	and	a4,a5,15
    80000a26:	ff3701e3          	beq	a4,s3,80000a08 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a2a:	8b85                	and	a5,a5,1
    80000a2c:	d7fd                	beqz	a5,80000a1a <freewalk+0x2e>
      panic("freewalk: leaf");
    80000a2e:	00007517          	auipc	a0,0x7
    80000a32:	70a50513          	add	a0,a0,1802 # 80008138 <etext+0x138>
    80000a36:	00005097          	auipc	ra,0x5
    80000a3a:	5bc080e7          	jalr	1468(ra) # 80005ff2 <panic>
    }
  }
  kfree((void*)pagetable);
    80000a3e:	8552                	mv	a0,s4
    80000a40:	fffff097          	auipc	ra,0xfffff
    80000a44:	5dc080e7          	jalr	1500(ra) # 8000001c <kfree>
}
    80000a48:	70a2                	ld	ra,40(sp)
    80000a4a:	7402                	ld	s0,32(sp)
    80000a4c:	64e2                	ld	s1,24(sp)
    80000a4e:	6942                	ld	s2,16(sp)
    80000a50:	69a2                	ld	s3,8(sp)
    80000a52:	6a02                	ld	s4,0(sp)
    80000a54:	6145                	add	sp,sp,48
    80000a56:	8082                	ret

0000000080000a58 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a58:	1101                	add	sp,sp,-32
    80000a5a:	ec06                	sd	ra,24(sp)
    80000a5c:	e822                	sd	s0,16(sp)
    80000a5e:	e426                	sd	s1,8(sp)
    80000a60:	1000                	add	s0,sp,32
    80000a62:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a64:	e999                	bnez	a1,80000a7a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a66:	8526                	mv	a0,s1
    80000a68:	00000097          	auipc	ra,0x0
    80000a6c:	f84080e7          	jalr	-124(ra) # 800009ec <freewalk>
}
    80000a70:	60e2                	ld	ra,24(sp)
    80000a72:	6442                	ld	s0,16(sp)
    80000a74:	64a2                	ld	s1,8(sp)
    80000a76:	6105                	add	sp,sp,32
    80000a78:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a7a:	6785                	lui	a5,0x1
    80000a7c:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a7e:	95be                	add	a1,a1,a5
    80000a80:	4685                	li	a3,1
    80000a82:	00c5d613          	srl	a2,a1,0xc
    80000a86:	4581                	li	a1,0
    80000a88:	00000097          	auipc	ra,0x0
    80000a8c:	cea080e7          	jalr	-790(ra) # 80000772 <uvmunmap>
    80000a90:	bfd9                	j	80000a66 <uvmfree+0xe>

0000000080000a92 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a92:	c679                	beqz	a2,80000b60 <uvmcopy+0xce>
{
    80000a94:	715d                	add	sp,sp,-80
    80000a96:	e486                	sd	ra,72(sp)
    80000a98:	e0a2                	sd	s0,64(sp)
    80000a9a:	fc26                	sd	s1,56(sp)
    80000a9c:	f84a                	sd	s2,48(sp)
    80000a9e:	f44e                	sd	s3,40(sp)
    80000aa0:	f052                	sd	s4,32(sp)
    80000aa2:	ec56                	sd	s5,24(sp)
    80000aa4:	e85a                	sd	s6,16(sp)
    80000aa6:	e45e                	sd	s7,8(sp)
    80000aa8:	0880                	add	s0,sp,80
    80000aaa:	8b2a                	mv	s6,a0
    80000aac:	8aae                	mv	s5,a1
    80000aae:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000ab0:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000ab2:	4601                	li	a2,0
    80000ab4:	85ce                	mv	a1,s3
    80000ab6:	855a                	mv	a0,s6
    80000ab8:	00000097          	auipc	ra,0x0
    80000abc:	9e8080e7          	jalr	-1560(ra) # 800004a0 <walk>
    80000ac0:	c531                	beqz	a0,80000b0c <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000ac2:	6118                	ld	a4,0(a0)
    80000ac4:	00177793          	and	a5,a4,1
    80000ac8:	cbb1                	beqz	a5,80000b1c <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000aca:	00a75593          	srl	a1,a4,0xa
    80000ace:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000ad2:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000ad6:	fffff097          	auipc	ra,0xfffff
    80000ada:	644080e7          	jalr	1604(ra) # 8000011a <kalloc>
    80000ade:	892a                	mv	s2,a0
    80000ae0:	c939                	beqz	a0,80000b36 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000ae2:	6605                	lui	a2,0x1
    80000ae4:	85de                	mv	a1,s7
    80000ae6:	fffff097          	auipc	ra,0xfffff
    80000aea:	73a080e7          	jalr	1850(ra) # 80000220 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aee:	8726                	mv	a4,s1
    80000af0:	86ca                	mv	a3,s2
    80000af2:	6605                	lui	a2,0x1
    80000af4:	85ce                	mv	a1,s3
    80000af6:	8556                	mv	a0,s5
    80000af8:	00000097          	auipc	ra,0x0
    80000afc:	a90080e7          	jalr	-1392(ra) # 80000588 <mappages>
    80000b00:	e515                	bnez	a0,80000b2c <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000b02:	6785                	lui	a5,0x1
    80000b04:	99be                	add	s3,s3,a5
    80000b06:	fb49e6e3          	bltu	s3,s4,80000ab2 <uvmcopy+0x20>
    80000b0a:	a081                	j	80000b4a <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000b0c:	00007517          	auipc	a0,0x7
    80000b10:	63c50513          	add	a0,a0,1596 # 80008148 <etext+0x148>
    80000b14:	00005097          	auipc	ra,0x5
    80000b18:	4de080e7          	jalr	1246(ra) # 80005ff2 <panic>
      panic("uvmcopy: page not present");
    80000b1c:	00007517          	auipc	a0,0x7
    80000b20:	64c50513          	add	a0,a0,1612 # 80008168 <etext+0x168>
    80000b24:	00005097          	auipc	ra,0x5
    80000b28:	4ce080e7          	jalr	1230(ra) # 80005ff2 <panic>
      kfree(mem);
    80000b2c:	854a                	mv	a0,s2
    80000b2e:	fffff097          	auipc	ra,0xfffff
    80000b32:	4ee080e7          	jalr	1262(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b36:	4685                	li	a3,1
    80000b38:	00c9d613          	srl	a2,s3,0xc
    80000b3c:	4581                	li	a1,0
    80000b3e:	8556                	mv	a0,s5
    80000b40:	00000097          	auipc	ra,0x0
    80000b44:	c32080e7          	jalr	-974(ra) # 80000772 <uvmunmap>
  return -1;
    80000b48:	557d                	li	a0,-1
}
    80000b4a:	60a6                	ld	ra,72(sp)
    80000b4c:	6406                	ld	s0,64(sp)
    80000b4e:	74e2                	ld	s1,56(sp)
    80000b50:	7942                	ld	s2,48(sp)
    80000b52:	79a2                	ld	s3,40(sp)
    80000b54:	7a02                	ld	s4,32(sp)
    80000b56:	6ae2                	ld	s5,24(sp)
    80000b58:	6b42                	ld	s6,16(sp)
    80000b5a:	6ba2                	ld	s7,8(sp)
    80000b5c:	6161                	add	sp,sp,80
    80000b5e:	8082                	ret
  return 0;
    80000b60:	4501                	li	a0,0
}
    80000b62:	8082                	ret

0000000080000b64 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b64:	1141                	add	sp,sp,-16
    80000b66:	e406                	sd	ra,8(sp)
    80000b68:	e022                	sd	s0,0(sp)
    80000b6a:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b6c:	4601                	li	a2,0
    80000b6e:	00000097          	auipc	ra,0x0
    80000b72:	932080e7          	jalr	-1742(ra) # 800004a0 <walk>
  if(pte == 0)
    80000b76:	c901                	beqz	a0,80000b86 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b78:	611c                	ld	a5,0(a0)
    80000b7a:	9bbd                	and	a5,a5,-17
    80000b7c:	e11c                	sd	a5,0(a0)
}
    80000b7e:	60a2                	ld	ra,8(sp)
    80000b80:	6402                	ld	s0,0(sp)
    80000b82:	0141                	add	sp,sp,16
    80000b84:	8082                	ret
    panic("uvmclear");
    80000b86:	00007517          	auipc	a0,0x7
    80000b8a:	60250513          	add	a0,a0,1538 # 80008188 <etext+0x188>
    80000b8e:	00005097          	auipc	ra,0x5
    80000b92:	464080e7          	jalr	1124(ra) # 80005ff2 <panic>

0000000080000b96 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000b96:	ced1                	beqz	a3,80000c32 <copyout+0x9c>
{
    80000b98:	711d                	add	sp,sp,-96
    80000b9a:	ec86                	sd	ra,88(sp)
    80000b9c:	e8a2                	sd	s0,80(sp)
    80000b9e:	e4a6                	sd	s1,72(sp)
    80000ba0:	fc4e                	sd	s3,56(sp)
    80000ba2:	f456                	sd	s5,40(sp)
    80000ba4:	f05a                	sd	s6,32(sp)
    80000ba6:	ec5e                	sd	s7,24(sp)
    80000ba8:	1080                	add	s0,sp,96
    80000baa:	8baa                	mv	s7,a0
    80000bac:	8aae                	mv	s5,a1
    80000bae:	8b32                	mv	s6,a2
    80000bb0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000bb2:	74fd                	lui	s1,0xfffff
    80000bb4:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000bb6:	57fd                	li	a5,-1
    80000bb8:	83e9                	srl	a5,a5,0x1a
    80000bba:	0697ee63          	bltu	a5,s1,80000c36 <copyout+0xa0>
    80000bbe:	e0ca                	sd	s2,64(sp)
    80000bc0:	f852                	sd	s4,48(sp)
    80000bc2:	e862                	sd	s8,16(sp)
    80000bc4:	e466                	sd	s9,8(sp)
    80000bc6:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000bc8:	4cd5                	li	s9,21
    80000bca:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000bcc:	8c3e                	mv	s8,a5
    80000bce:	a035                	j	80000bfa <copyout+0x64>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000bd0:	83a9                	srl	a5,a5,0xa
    80000bd2:	07b2                	sll	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000bd4:	409a8533          	sub	a0,s5,s1
    80000bd8:	0009061b          	sext.w	a2,s2
    80000bdc:	85da                	mv	a1,s6
    80000bde:	953e                	add	a0,a0,a5
    80000be0:	fffff097          	auipc	ra,0xfffff
    80000be4:	640080e7          	jalr	1600(ra) # 80000220 <memmove>

    len -= n;
    80000be8:	412989b3          	sub	s3,s3,s2
    src += n;
    80000bec:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000bee:	02098b63          	beqz	s3,80000c24 <copyout+0x8e>
    if(va0 >= MAXVA)
    80000bf2:	054c6463          	bltu	s8,s4,80000c3a <copyout+0xa4>
    80000bf6:	84d2                	mv	s1,s4
    80000bf8:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000bfa:	4601                	li	a2,0
    80000bfc:	85a6                	mv	a1,s1
    80000bfe:	855e                	mv	a0,s7
    80000c00:	00000097          	auipc	ra,0x0
    80000c04:	8a0080e7          	jalr	-1888(ra) # 800004a0 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000c08:	c121                	beqz	a0,80000c48 <copyout+0xb2>
    80000c0a:	611c                	ld	a5,0(a0)
    80000c0c:	0157f713          	and	a4,a5,21
    80000c10:	05971b63          	bne	a4,s9,80000c66 <copyout+0xd0>
    n = PGSIZE - (dstva - va0);
    80000c14:	01a48a33          	add	s4,s1,s10
    80000c18:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000c1c:	fb29fae3          	bgeu	s3,s2,80000bd0 <copyout+0x3a>
    80000c20:	894e                	mv	s2,s3
    80000c22:	b77d                	j	80000bd0 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000c24:	4501                	li	a0,0
    80000c26:	6906                	ld	s2,64(sp)
    80000c28:	7a42                	ld	s4,48(sp)
    80000c2a:	6c42                	ld	s8,16(sp)
    80000c2c:	6ca2                	ld	s9,8(sp)
    80000c2e:	6d02                	ld	s10,0(sp)
    80000c30:	a015                	j	80000c54 <copyout+0xbe>
    80000c32:	4501                	li	a0,0
}
    80000c34:	8082                	ret
      return -1;
    80000c36:	557d                	li	a0,-1
    80000c38:	a831                	j	80000c54 <copyout+0xbe>
    80000c3a:	557d                	li	a0,-1
    80000c3c:	6906                	ld	s2,64(sp)
    80000c3e:	7a42                	ld	s4,48(sp)
    80000c40:	6c42                	ld	s8,16(sp)
    80000c42:	6ca2                	ld	s9,8(sp)
    80000c44:	6d02                	ld	s10,0(sp)
    80000c46:	a039                	j	80000c54 <copyout+0xbe>
      return -1;
    80000c48:	557d                	li	a0,-1
    80000c4a:	6906                	ld	s2,64(sp)
    80000c4c:	7a42                	ld	s4,48(sp)
    80000c4e:	6c42                	ld	s8,16(sp)
    80000c50:	6ca2                	ld	s9,8(sp)
    80000c52:	6d02                	ld	s10,0(sp)
}
    80000c54:	60e6                	ld	ra,88(sp)
    80000c56:	6446                	ld	s0,80(sp)
    80000c58:	64a6                	ld	s1,72(sp)
    80000c5a:	79e2                	ld	s3,56(sp)
    80000c5c:	7aa2                	ld	s5,40(sp)
    80000c5e:	7b02                	ld	s6,32(sp)
    80000c60:	6be2                	ld	s7,24(sp)
    80000c62:	6125                	add	sp,sp,96
    80000c64:	8082                	ret
      return -1;
    80000c66:	557d                	li	a0,-1
    80000c68:	6906                	ld	s2,64(sp)
    80000c6a:	7a42                	ld	s4,48(sp)
    80000c6c:	6c42                	ld	s8,16(sp)
    80000c6e:	6ca2                	ld	s9,8(sp)
    80000c70:	6d02                	ld	s10,0(sp)
    80000c72:	b7cd                	j	80000c54 <copyout+0xbe>

0000000080000c74 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c74:	caa5                	beqz	a3,80000ce4 <copyin+0x70>
{
    80000c76:	715d                	add	sp,sp,-80
    80000c78:	e486                	sd	ra,72(sp)
    80000c7a:	e0a2                	sd	s0,64(sp)
    80000c7c:	fc26                	sd	s1,56(sp)
    80000c7e:	f84a                	sd	s2,48(sp)
    80000c80:	f44e                	sd	s3,40(sp)
    80000c82:	f052                	sd	s4,32(sp)
    80000c84:	ec56                	sd	s5,24(sp)
    80000c86:	e85a                	sd	s6,16(sp)
    80000c88:	e45e                	sd	s7,8(sp)
    80000c8a:	e062                	sd	s8,0(sp)
    80000c8c:	0880                	add	s0,sp,80
    80000c8e:	8b2a                	mv	s6,a0
    80000c90:	8a2e                	mv	s4,a1
    80000c92:	8c32                	mv	s8,a2
    80000c94:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c96:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c98:	6a85                	lui	s5,0x1
    80000c9a:	a01d                	j	80000cc0 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c9c:	018505b3          	add	a1,a0,s8
    80000ca0:	0004861b          	sext.w	a2,s1
    80000ca4:	412585b3          	sub	a1,a1,s2
    80000ca8:	8552                	mv	a0,s4
    80000caa:	fffff097          	auipc	ra,0xfffff
    80000cae:	576080e7          	jalr	1398(ra) # 80000220 <memmove>

    len -= n;
    80000cb2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000cb6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000cb8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000cbc:	02098263          	beqz	s3,80000ce0 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000cc0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000cc4:	85ca                	mv	a1,s2
    80000cc6:	855a                	mv	a0,s6
    80000cc8:	00000097          	auipc	ra,0x0
    80000ccc:	87e080e7          	jalr	-1922(ra) # 80000546 <walkaddr>
    if(pa0 == 0)
    80000cd0:	cd01                	beqz	a0,80000ce8 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000cd2:	418904b3          	sub	s1,s2,s8
    80000cd6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000cd8:	fc99f2e3          	bgeu	s3,s1,80000c9c <copyin+0x28>
    80000cdc:	84ce                	mv	s1,s3
    80000cde:	bf7d                	j	80000c9c <copyin+0x28>
  }
  return 0;
    80000ce0:	4501                	li	a0,0
    80000ce2:	a021                	j	80000cea <copyin+0x76>
    80000ce4:	4501                	li	a0,0
}
    80000ce6:	8082                	ret
      return -1;
    80000ce8:	557d                	li	a0,-1
}
    80000cea:	60a6                	ld	ra,72(sp)
    80000cec:	6406                	ld	s0,64(sp)
    80000cee:	74e2                	ld	s1,56(sp)
    80000cf0:	7942                	ld	s2,48(sp)
    80000cf2:	79a2                	ld	s3,40(sp)
    80000cf4:	7a02                	ld	s4,32(sp)
    80000cf6:	6ae2                	ld	s5,24(sp)
    80000cf8:	6b42                	ld	s6,16(sp)
    80000cfa:	6ba2                	ld	s7,8(sp)
    80000cfc:	6c02                	ld	s8,0(sp)
    80000cfe:	6161                	add	sp,sp,80
    80000d00:	8082                	ret

0000000080000d02 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d02:	cacd                	beqz	a3,80000db4 <copyinstr+0xb2>
{
    80000d04:	715d                	add	sp,sp,-80
    80000d06:	e486                	sd	ra,72(sp)
    80000d08:	e0a2                	sd	s0,64(sp)
    80000d0a:	fc26                	sd	s1,56(sp)
    80000d0c:	f84a                	sd	s2,48(sp)
    80000d0e:	f44e                	sd	s3,40(sp)
    80000d10:	f052                	sd	s4,32(sp)
    80000d12:	ec56                	sd	s5,24(sp)
    80000d14:	e85a                	sd	s6,16(sp)
    80000d16:	e45e                	sd	s7,8(sp)
    80000d18:	0880                	add	s0,sp,80
    80000d1a:	8a2a                	mv	s4,a0
    80000d1c:	8b2e                	mv	s6,a1
    80000d1e:	8bb2                	mv	s7,a2
    80000d20:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000d22:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d24:	6985                	lui	s3,0x1
    80000d26:	a825                	j	80000d5e <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000d28:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d2c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000d2e:	37fd                	addw	a5,a5,-1
    80000d30:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d34:	60a6                	ld	ra,72(sp)
    80000d36:	6406                	ld	s0,64(sp)
    80000d38:	74e2                	ld	s1,56(sp)
    80000d3a:	7942                	ld	s2,48(sp)
    80000d3c:	79a2                	ld	s3,40(sp)
    80000d3e:	7a02                	ld	s4,32(sp)
    80000d40:	6ae2                	ld	s5,24(sp)
    80000d42:	6b42                	ld	s6,16(sp)
    80000d44:	6ba2                	ld	s7,8(sp)
    80000d46:	6161                	add	sp,sp,80
    80000d48:	8082                	ret
    80000d4a:	fff90713          	add	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000d4e:	9742                	add	a4,a4,a6
      --max;
    80000d50:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000d54:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000d58:	04e58663          	beq	a1,a4,80000da4 <copyinstr+0xa2>
{
    80000d5c:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000d5e:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d62:	85a6                	mv	a1,s1
    80000d64:	8552                	mv	a0,s4
    80000d66:	fffff097          	auipc	ra,0xfffff
    80000d6a:	7e0080e7          	jalr	2016(ra) # 80000546 <walkaddr>
    if(pa0 == 0)
    80000d6e:	cd0d                	beqz	a0,80000da8 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000d70:	417486b3          	sub	a3,s1,s7
    80000d74:	96ce                	add	a3,a3,s3
    if(n > max)
    80000d76:	00d97363          	bgeu	s2,a3,80000d7c <copyinstr+0x7a>
    80000d7a:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000d7c:	955e                	add	a0,a0,s7
    80000d7e:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000d80:	c695                	beqz	a3,80000dac <copyinstr+0xaa>
    80000d82:	87da                	mv	a5,s6
    80000d84:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000d86:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000d8a:	96da                	add	a3,a3,s6
    80000d8c:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000d8e:	00f60733          	add	a4,a2,a5
    80000d92:	00074703          	lbu	a4,0(a4)
    80000d96:	db49                	beqz	a4,80000d28 <copyinstr+0x26>
        *dst = *p;
    80000d98:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d9c:	0785                	add	a5,a5,1
    while(n > 0){
    80000d9e:	fed797e3          	bne	a5,a3,80000d8c <copyinstr+0x8a>
    80000da2:	b765                	j	80000d4a <copyinstr+0x48>
    80000da4:	4781                	li	a5,0
    80000da6:	b761                	j	80000d2e <copyinstr+0x2c>
      return -1;
    80000da8:	557d                	li	a0,-1
    80000daa:	b769                	j	80000d34 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000dac:	6b85                	lui	s7,0x1
    80000dae:	9ba6                	add	s7,s7,s1
    80000db0:	87da                	mv	a5,s6
    80000db2:	b76d                	j	80000d5c <copyinstr+0x5a>
  int got_null = 0;
    80000db4:	4781                	li	a5,0
  if(got_null){
    80000db6:	37fd                	addw	a5,a5,-1
    80000db8:	0007851b          	sext.w	a0,a5
}
    80000dbc:	8082                	ret

0000000080000dbe <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000dbe:	7139                	add	sp,sp,-64
    80000dc0:	fc06                	sd	ra,56(sp)
    80000dc2:	f822                	sd	s0,48(sp)
    80000dc4:	f426                	sd	s1,40(sp)
    80000dc6:	f04a                	sd	s2,32(sp)
    80000dc8:	ec4e                	sd	s3,24(sp)
    80000dca:	e852                	sd	s4,16(sp)
    80000dcc:	e456                	sd	s5,8(sp)
    80000dce:	e05a                	sd	s6,0(sp)
    80000dd0:	0080                	add	s0,sp,64
    80000dd2:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd4:	0000b497          	auipc	s1,0xb
    80000dd8:	a9c48493          	add	s1,s1,-1380 # 8000b870 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000ddc:	8b26                	mv	s6,s1
    80000dde:	04fa5937          	lui	s2,0x4fa5
    80000de2:	fa590913          	add	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000de6:	0932                	sll	s2,s2,0xc
    80000de8:	fa590913          	add	s2,s2,-91
    80000dec:	0932                	sll	s2,s2,0xc
    80000dee:	fa590913          	add	s2,s2,-91
    80000df2:	0932                	sll	s2,s2,0xc
    80000df4:	fa590913          	add	s2,s2,-91
    80000df8:	040009b7          	lui	s3,0x4000
    80000dfc:	19fd                	add	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000dfe:	09b2                	sll	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e00:	00010a97          	auipc	s5,0x10
    80000e04:	470a8a93          	add	s5,s5,1136 # 80011270 <tickslock>
    char *pa = kalloc();
    80000e08:	fffff097          	auipc	ra,0xfffff
    80000e0c:	312080e7          	jalr	786(ra) # 8000011a <kalloc>
    80000e10:	862a                	mv	a2,a0
    if(pa == 0)
    80000e12:	c121                	beqz	a0,80000e52 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000e14:	416485b3          	sub	a1,s1,s6
    80000e18:	858d                	sra	a1,a1,0x3
    80000e1a:	032585b3          	mul	a1,a1,s2
    80000e1e:	2585                	addw	a1,a1,1
    80000e20:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e24:	4719                	li	a4,6
    80000e26:	6685                	lui	a3,0x1
    80000e28:	40b985b3          	sub	a1,s3,a1
    80000e2c:	8552                	mv	a0,s4
    80000e2e:	00000097          	auipc	ra,0x0
    80000e32:	81e080e7          	jalr	-2018(ra) # 8000064c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e36:	16848493          	add	s1,s1,360
    80000e3a:	fd5497e3          	bne	s1,s5,80000e08 <proc_mapstacks+0x4a>
  }
}
    80000e3e:	70e2                	ld	ra,56(sp)
    80000e40:	7442                	ld	s0,48(sp)
    80000e42:	74a2                	ld	s1,40(sp)
    80000e44:	7902                	ld	s2,32(sp)
    80000e46:	69e2                	ld	s3,24(sp)
    80000e48:	6a42                	ld	s4,16(sp)
    80000e4a:	6aa2                	ld	s5,8(sp)
    80000e4c:	6b02                	ld	s6,0(sp)
    80000e4e:	6121                	add	sp,sp,64
    80000e50:	8082                	ret
      panic("kalloc");
    80000e52:	00007517          	auipc	a0,0x7
    80000e56:	34650513          	add	a0,a0,838 # 80008198 <etext+0x198>
    80000e5a:	00005097          	auipc	ra,0x5
    80000e5e:	198080e7          	jalr	408(ra) # 80005ff2 <panic>

0000000080000e62 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e62:	7139                	add	sp,sp,-64
    80000e64:	fc06                	sd	ra,56(sp)
    80000e66:	f822                	sd	s0,48(sp)
    80000e68:	f426                	sd	s1,40(sp)
    80000e6a:	f04a                	sd	s2,32(sp)
    80000e6c:	ec4e                	sd	s3,24(sp)
    80000e6e:	e852                	sd	s4,16(sp)
    80000e70:	e456                	sd	s5,8(sp)
    80000e72:	e05a                	sd	s6,0(sp)
    80000e74:	0080                	add	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e76:	00007597          	auipc	a1,0x7
    80000e7a:	32a58593          	add	a1,a1,810 # 800081a0 <etext+0x1a0>
    80000e7e:	0000a517          	auipc	a0,0xa
    80000e82:	5c250513          	add	a0,a0,1474 # 8000b440 <pid_lock>
    80000e86:	00005097          	auipc	ra,0x5
    80000e8a:	656080e7          	jalr	1622(ra) # 800064dc <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e8e:	00007597          	auipc	a1,0x7
    80000e92:	31a58593          	add	a1,a1,794 # 800081a8 <etext+0x1a8>
    80000e96:	0000a517          	auipc	a0,0xa
    80000e9a:	5c250513          	add	a0,a0,1474 # 8000b458 <wait_lock>
    80000e9e:	00005097          	auipc	ra,0x5
    80000ea2:	63e080e7          	jalr	1598(ra) # 800064dc <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ea6:	0000b497          	auipc	s1,0xb
    80000eaa:	9ca48493          	add	s1,s1,-1590 # 8000b870 <proc>
      initlock(&p->lock, "proc");
    80000eae:	00007b17          	auipc	s6,0x7
    80000eb2:	30ab0b13          	add	s6,s6,778 # 800081b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000eb6:	8aa6                	mv	s5,s1
    80000eb8:	04fa5937          	lui	s2,0x4fa5
    80000ebc:	fa590913          	add	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000ec0:	0932                	sll	s2,s2,0xc
    80000ec2:	fa590913          	add	s2,s2,-91
    80000ec6:	0932                	sll	s2,s2,0xc
    80000ec8:	fa590913          	add	s2,s2,-91
    80000ecc:	0932                	sll	s2,s2,0xc
    80000ece:	fa590913          	add	s2,s2,-91
    80000ed2:	040009b7          	lui	s3,0x4000
    80000ed6:	19fd                	add	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000ed8:	09b2                	sll	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eda:	00010a17          	auipc	s4,0x10
    80000ede:	396a0a13          	add	s4,s4,918 # 80011270 <tickslock>
      initlock(&p->lock, "proc");
    80000ee2:	85da                	mv	a1,s6
    80000ee4:	8526                	mv	a0,s1
    80000ee6:	00005097          	auipc	ra,0x5
    80000eea:	5f6080e7          	jalr	1526(ra) # 800064dc <initlock>
      p->state = UNUSED;
    80000eee:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000ef2:	415487b3          	sub	a5,s1,s5
    80000ef6:	878d                	sra	a5,a5,0x3
    80000ef8:	032787b3          	mul	a5,a5,s2
    80000efc:	2785                	addw	a5,a5,1
    80000efe:	00d7979b          	sllw	a5,a5,0xd
    80000f02:	40f987b3          	sub	a5,s3,a5
    80000f06:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f08:	16848493          	add	s1,s1,360
    80000f0c:	fd449be3          	bne	s1,s4,80000ee2 <procinit+0x80>
  }
}
    80000f10:	70e2                	ld	ra,56(sp)
    80000f12:	7442                	ld	s0,48(sp)
    80000f14:	74a2                	ld	s1,40(sp)
    80000f16:	7902                	ld	s2,32(sp)
    80000f18:	69e2                	ld	s3,24(sp)
    80000f1a:	6a42                	ld	s4,16(sp)
    80000f1c:	6aa2                	ld	s5,8(sp)
    80000f1e:	6b02                	ld	s6,0(sp)
    80000f20:	6121                	add	sp,sp,64
    80000f22:	8082                	ret

0000000080000f24 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f24:	1141                	add	sp,sp,-16
    80000f26:	e422                	sd	s0,8(sp)
    80000f28:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f2a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f2c:	2501                	sext.w	a0,a0
    80000f2e:	6422                	ld	s0,8(sp)
    80000f30:	0141                	add	sp,sp,16
    80000f32:	8082                	ret

0000000080000f34 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000f34:	1141                	add	sp,sp,-16
    80000f36:	e422                	sd	s0,8(sp)
    80000f38:	0800                	add	s0,sp,16
    80000f3a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f3c:	2781                	sext.w	a5,a5
    80000f3e:	079e                	sll	a5,a5,0x7
  return c;
}
    80000f40:	0000a517          	auipc	a0,0xa
    80000f44:	53050513          	add	a0,a0,1328 # 8000b470 <cpus>
    80000f48:	953e                	add	a0,a0,a5
    80000f4a:	6422                	ld	s0,8(sp)
    80000f4c:	0141                	add	sp,sp,16
    80000f4e:	8082                	ret

0000000080000f50 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f50:	1101                	add	sp,sp,-32
    80000f52:	ec06                	sd	ra,24(sp)
    80000f54:	e822                	sd	s0,16(sp)
    80000f56:	e426                	sd	s1,8(sp)
    80000f58:	1000                	add	s0,sp,32
  push_off();
    80000f5a:	00005097          	auipc	ra,0x5
    80000f5e:	5c6080e7          	jalr	1478(ra) # 80006520 <push_off>
    80000f62:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f64:	2781                	sext.w	a5,a5
    80000f66:	079e                	sll	a5,a5,0x7
    80000f68:	0000a717          	auipc	a4,0xa
    80000f6c:	4d870713          	add	a4,a4,1240 # 8000b440 <pid_lock>
    80000f70:	97ba                	add	a5,a5,a4
    80000f72:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f74:	00005097          	auipc	ra,0x5
    80000f78:	64c080e7          	jalr	1612(ra) # 800065c0 <pop_off>
  return p;
}
    80000f7c:	8526                	mv	a0,s1
    80000f7e:	60e2                	ld	ra,24(sp)
    80000f80:	6442                	ld	s0,16(sp)
    80000f82:	64a2                	ld	s1,8(sp)
    80000f84:	6105                	add	sp,sp,32
    80000f86:	8082                	ret

0000000080000f88 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f88:	1141                	add	sp,sp,-16
    80000f8a:	e406                	sd	ra,8(sp)
    80000f8c:	e022                	sd	s0,0(sp)
    80000f8e:	0800                	add	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f90:	00000097          	auipc	ra,0x0
    80000f94:	fc0080e7          	jalr	-64(ra) # 80000f50 <myproc>
    80000f98:	00005097          	auipc	ra,0x5
    80000f9c:	688080e7          	jalr	1672(ra) # 80006620 <release>

  if (first) {
    80000fa0:	0000a797          	auipc	a5,0xa
    80000fa4:	3e07a783          	lw	a5,992(a5) # 8000b380 <first.1>
    80000fa8:	eb89                	bnez	a5,80000fba <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000faa:	00001097          	auipc	ra,0x1
    80000fae:	c98080e7          	jalr	-872(ra) # 80001c42 <usertrapret>
}
    80000fb2:	60a2                	ld	ra,8(sp)
    80000fb4:	6402                	ld	s0,0(sp)
    80000fb6:	0141                	add	sp,sp,16
    80000fb8:	8082                	ret
    fsinit(ROOTDEV);
    80000fba:	4505                	li	a0,1
    80000fbc:	00002097          	auipc	ra,0x2
    80000fc0:	be2080e7          	jalr	-1054(ra) # 80002b9e <fsinit>
    first = 0;
    80000fc4:	0000a797          	auipc	a5,0xa
    80000fc8:	3a07ae23          	sw	zero,956(a5) # 8000b380 <first.1>
    __sync_synchronize();
    80000fcc:	0330000f          	fence	rw,rw
    80000fd0:	bfe9                	j	80000faa <forkret+0x22>

0000000080000fd2 <allocpid>:
{
    80000fd2:	1101                	add	sp,sp,-32
    80000fd4:	ec06                	sd	ra,24(sp)
    80000fd6:	e822                	sd	s0,16(sp)
    80000fd8:	e426                	sd	s1,8(sp)
    80000fda:	e04a                	sd	s2,0(sp)
    80000fdc:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80000fde:	0000a917          	auipc	s2,0xa
    80000fe2:	46290913          	add	s2,s2,1122 # 8000b440 <pid_lock>
    80000fe6:	854a                	mv	a0,s2
    80000fe8:	00005097          	auipc	ra,0x5
    80000fec:	584080e7          	jalr	1412(ra) # 8000656c <acquire>
  pid = nextpid;
    80000ff0:	0000a797          	auipc	a5,0xa
    80000ff4:	39478793          	add	a5,a5,916 # 8000b384 <nextpid>
    80000ff8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ffa:	0014871b          	addw	a4,s1,1
    80000ffe:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001000:	854a                	mv	a0,s2
    80001002:	00005097          	auipc	ra,0x5
    80001006:	61e080e7          	jalr	1566(ra) # 80006620 <release>
}
    8000100a:	8526                	mv	a0,s1
    8000100c:	60e2                	ld	ra,24(sp)
    8000100e:	6442                	ld	s0,16(sp)
    80001010:	64a2                	ld	s1,8(sp)
    80001012:	6902                	ld	s2,0(sp)
    80001014:	6105                	add	sp,sp,32
    80001016:	8082                	ret

0000000080001018 <proc_pagetable>:
{
    80001018:	1101                	add	sp,sp,-32
    8000101a:	ec06                	sd	ra,24(sp)
    8000101c:	e822                	sd	s0,16(sp)
    8000101e:	e426                	sd	s1,8(sp)
    80001020:	e04a                	sd	s2,0(sp)
    80001022:	1000                	add	s0,sp,32
    80001024:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001026:	00000097          	auipc	ra,0x0
    8000102a:	820080e7          	jalr	-2016(ra) # 80000846 <uvmcreate>
    8000102e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001030:	c121                	beqz	a0,80001070 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001032:	4729                	li	a4,10
    80001034:	00006697          	auipc	a3,0x6
    80001038:	fcc68693          	add	a3,a3,-52 # 80007000 <_trampoline>
    8000103c:	6605                	lui	a2,0x1
    8000103e:	040005b7          	lui	a1,0x4000
    80001042:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001044:	05b2                	sll	a1,a1,0xc
    80001046:	fffff097          	auipc	ra,0xfffff
    8000104a:	542080e7          	jalr	1346(ra) # 80000588 <mappages>
    8000104e:	02054863          	bltz	a0,8000107e <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001052:	4719                	li	a4,6
    80001054:	05893683          	ld	a3,88(s2)
    80001058:	6605                	lui	a2,0x1
    8000105a:	020005b7          	lui	a1,0x2000
    8000105e:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001060:	05b6                	sll	a1,a1,0xd
    80001062:	8526                	mv	a0,s1
    80001064:	fffff097          	auipc	ra,0xfffff
    80001068:	524080e7          	jalr	1316(ra) # 80000588 <mappages>
    8000106c:	02054163          	bltz	a0,8000108e <proc_pagetable+0x76>
}
    80001070:	8526                	mv	a0,s1
    80001072:	60e2                	ld	ra,24(sp)
    80001074:	6442                	ld	s0,16(sp)
    80001076:	64a2                	ld	s1,8(sp)
    80001078:	6902                	ld	s2,0(sp)
    8000107a:	6105                	add	sp,sp,32
    8000107c:	8082                	ret
    uvmfree(pagetable, 0);
    8000107e:	4581                	li	a1,0
    80001080:	8526                	mv	a0,s1
    80001082:	00000097          	auipc	ra,0x0
    80001086:	9d6080e7          	jalr	-1578(ra) # 80000a58 <uvmfree>
    return 0;
    8000108a:	4481                	li	s1,0
    8000108c:	b7d5                	j	80001070 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000108e:	4681                	li	a3,0
    80001090:	4605                	li	a2,1
    80001092:	040005b7          	lui	a1,0x4000
    80001096:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001098:	05b2                	sll	a1,a1,0xc
    8000109a:	8526                	mv	a0,s1
    8000109c:	fffff097          	auipc	ra,0xfffff
    800010a0:	6d6080e7          	jalr	1750(ra) # 80000772 <uvmunmap>
    uvmfree(pagetable, 0);
    800010a4:	4581                	li	a1,0
    800010a6:	8526                	mv	a0,s1
    800010a8:	00000097          	auipc	ra,0x0
    800010ac:	9b0080e7          	jalr	-1616(ra) # 80000a58 <uvmfree>
    return 0;
    800010b0:	4481                	li	s1,0
    800010b2:	bf7d                	j	80001070 <proc_pagetable+0x58>

00000000800010b4 <proc_freepagetable>:
{
    800010b4:	1101                	add	sp,sp,-32
    800010b6:	ec06                	sd	ra,24(sp)
    800010b8:	e822                	sd	s0,16(sp)
    800010ba:	e426                	sd	s1,8(sp)
    800010bc:	e04a                	sd	s2,0(sp)
    800010be:	1000                	add	s0,sp,32
    800010c0:	84aa                	mv	s1,a0
    800010c2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010c4:	4681                	li	a3,0
    800010c6:	4605                	li	a2,1
    800010c8:	040005b7          	lui	a1,0x4000
    800010cc:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010ce:	05b2                	sll	a1,a1,0xc
    800010d0:	fffff097          	auipc	ra,0xfffff
    800010d4:	6a2080e7          	jalr	1698(ra) # 80000772 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010d8:	4681                	li	a3,0
    800010da:	4605                	li	a2,1
    800010dc:	020005b7          	lui	a1,0x2000
    800010e0:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010e2:	05b6                	sll	a1,a1,0xd
    800010e4:	8526                	mv	a0,s1
    800010e6:	fffff097          	auipc	ra,0xfffff
    800010ea:	68c080e7          	jalr	1676(ra) # 80000772 <uvmunmap>
  uvmfree(pagetable, sz);
    800010ee:	85ca                	mv	a1,s2
    800010f0:	8526                	mv	a0,s1
    800010f2:	00000097          	auipc	ra,0x0
    800010f6:	966080e7          	jalr	-1690(ra) # 80000a58 <uvmfree>
}
    800010fa:	60e2                	ld	ra,24(sp)
    800010fc:	6442                	ld	s0,16(sp)
    800010fe:	64a2                	ld	s1,8(sp)
    80001100:	6902                	ld	s2,0(sp)
    80001102:	6105                	add	sp,sp,32
    80001104:	8082                	ret

0000000080001106 <freeproc>:
{
    80001106:	1101                	add	sp,sp,-32
    80001108:	ec06                	sd	ra,24(sp)
    8000110a:	e822                	sd	s0,16(sp)
    8000110c:	e426                	sd	s1,8(sp)
    8000110e:	1000                	add	s0,sp,32
    80001110:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001112:	6d28                	ld	a0,88(a0)
    80001114:	c509                	beqz	a0,8000111e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001116:	fffff097          	auipc	ra,0xfffff
    8000111a:	f06080e7          	jalr	-250(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000111e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001122:	68a8                	ld	a0,80(s1)
    80001124:	c511                	beqz	a0,80001130 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001126:	64ac                	ld	a1,72(s1)
    80001128:	00000097          	auipc	ra,0x0
    8000112c:	f8c080e7          	jalr	-116(ra) # 800010b4 <proc_freepagetable>
  p->pagetable = 0;
    80001130:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001134:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001138:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000113c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001140:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001144:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001148:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000114c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001150:	0004ac23          	sw	zero,24(s1)
}
    80001154:	60e2                	ld	ra,24(sp)
    80001156:	6442                	ld	s0,16(sp)
    80001158:	64a2                	ld	s1,8(sp)
    8000115a:	6105                	add	sp,sp,32
    8000115c:	8082                	ret

000000008000115e <allocproc>:
{
    8000115e:	1101                	add	sp,sp,-32
    80001160:	ec06                	sd	ra,24(sp)
    80001162:	e822                	sd	s0,16(sp)
    80001164:	e426                	sd	s1,8(sp)
    80001166:	e04a                	sd	s2,0(sp)
    80001168:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000116a:	0000a497          	auipc	s1,0xa
    8000116e:	70648493          	add	s1,s1,1798 # 8000b870 <proc>
    80001172:	00010917          	auipc	s2,0x10
    80001176:	0fe90913          	add	s2,s2,254 # 80011270 <tickslock>
    acquire(&p->lock);
    8000117a:	8526                	mv	a0,s1
    8000117c:	00005097          	auipc	ra,0x5
    80001180:	3f0080e7          	jalr	1008(ra) # 8000656c <acquire>
    if(p->state == UNUSED) {
    80001184:	4c9c                	lw	a5,24(s1)
    80001186:	cf81                	beqz	a5,8000119e <allocproc+0x40>
      release(&p->lock);
    80001188:	8526                	mv	a0,s1
    8000118a:	00005097          	auipc	ra,0x5
    8000118e:	496080e7          	jalr	1174(ra) # 80006620 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001192:	16848493          	add	s1,s1,360
    80001196:	ff2492e3          	bne	s1,s2,8000117a <allocproc+0x1c>
  return 0;
    8000119a:	4481                	li	s1,0
    8000119c:	a889                	j	800011ee <allocproc+0x90>
  p->pid = allocpid();
    8000119e:	00000097          	auipc	ra,0x0
    800011a2:	e34080e7          	jalr	-460(ra) # 80000fd2 <allocpid>
    800011a6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800011a8:	4785                	li	a5,1
    800011aa:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011ac:	fffff097          	auipc	ra,0xfffff
    800011b0:	f6e080e7          	jalr	-146(ra) # 8000011a <kalloc>
    800011b4:	892a                	mv	s2,a0
    800011b6:	eca8                	sd	a0,88(s1)
    800011b8:	c131                	beqz	a0,800011fc <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800011ba:	8526                	mv	a0,s1
    800011bc:	00000097          	auipc	ra,0x0
    800011c0:	e5c080e7          	jalr	-420(ra) # 80001018 <proc_pagetable>
    800011c4:	892a                	mv	s2,a0
    800011c6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800011c8:	c531                	beqz	a0,80001214 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800011ca:	07000613          	li	a2,112
    800011ce:	4581                	li	a1,0
    800011d0:	06048513          	add	a0,s1,96
    800011d4:	fffff097          	auipc	ra,0xfffff
    800011d8:	ff0080e7          	jalr	-16(ra) # 800001c4 <memset>
  p->context.ra = (uint64)forkret;
    800011dc:	00000797          	auipc	a5,0x0
    800011e0:	dac78793          	add	a5,a5,-596 # 80000f88 <forkret>
    800011e4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800011e6:	60bc                	ld	a5,64(s1)
    800011e8:	6705                	lui	a4,0x1
    800011ea:	97ba                	add	a5,a5,a4
    800011ec:	f4bc                	sd	a5,104(s1)
}
    800011ee:	8526                	mv	a0,s1
    800011f0:	60e2                	ld	ra,24(sp)
    800011f2:	6442                	ld	s0,16(sp)
    800011f4:	64a2                	ld	s1,8(sp)
    800011f6:	6902                	ld	s2,0(sp)
    800011f8:	6105                	add	sp,sp,32
    800011fa:	8082                	ret
    freeproc(p);
    800011fc:	8526                	mv	a0,s1
    800011fe:	00000097          	auipc	ra,0x0
    80001202:	f08080e7          	jalr	-248(ra) # 80001106 <freeproc>
    release(&p->lock);
    80001206:	8526                	mv	a0,s1
    80001208:	00005097          	auipc	ra,0x5
    8000120c:	418080e7          	jalr	1048(ra) # 80006620 <release>
    return 0;
    80001210:	84ca                	mv	s1,s2
    80001212:	bff1                	j	800011ee <allocproc+0x90>
    freeproc(p);
    80001214:	8526                	mv	a0,s1
    80001216:	00000097          	auipc	ra,0x0
    8000121a:	ef0080e7          	jalr	-272(ra) # 80001106 <freeproc>
    release(&p->lock);
    8000121e:	8526                	mv	a0,s1
    80001220:	00005097          	auipc	ra,0x5
    80001224:	400080e7          	jalr	1024(ra) # 80006620 <release>
    return 0;
    80001228:	84ca                	mv	s1,s2
    8000122a:	b7d1                	j	800011ee <allocproc+0x90>

000000008000122c <userinit>:
{
    8000122c:	1101                	add	sp,sp,-32
    8000122e:	ec06                	sd	ra,24(sp)
    80001230:	e822                	sd	s0,16(sp)
    80001232:	e426                	sd	s1,8(sp)
    80001234:	1000                	add	s0,sp,32
  p = allocproc();
    80001236:	00000097          	auipc	ra,0x0
    8000123a:	f28080e7          	jalr	-216(ra) # 8000115e <allocproc>
    8000123e:	84aa                	mv	s1,a0
  initproc = p;
    80001240:	0000a797          	auipc	a5,0xa
    80001244:	1ca7b023          	sd	a0,448(a5) # 8000b400 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001248:	03400613          	li	a2,52
    8000124c:	0000a597          	auipc	a1,0xa
    80001250:	14458593          	add	a1,a1,324 # 8000b390 <initcode>
    80001254:	6928                	ld	a0,80(a0)
    80001256:	fffff097          	auipc	ra,0xfffff
    8000125a:	61e080e7          	jalr	1566(ra) # 80000874 <uvmfirst>
  p->sz = PGSIZE;
    8000125e:	6785                	lui	a5,0x1
    80001260:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001262:	6cb8                	ld	a4,88(s1)
    80001264:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001268:	6cb8                	ld	a4,88(s1)
    8000126a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000126c:	4641                	li	a2,16
    8000126e:	00007597          	auipc	a1,0x7
    80001272:	f5258593          	add	a1,a1,-174 # 800081c0 <etext+0x1c0>
    80001276:	15848513          	add	a0,s1,344
    8000127a:	fffff097          	auipc	ra,0xfffff
    8000127e:	08c080e7          	jalr	140(ra) # 80000306 <safestrcpy>
  p->cwd = namei("/");
    80001282:	00007517          	auipc	a0,0x7
    80001286:	f4e50513          	add	a0,a0,-178 # 800081d0 <etext+0x1d0>
    8000128a:	00002097          	auipc	ra,0x2
    8000128e:	366080e7          	jalr	870(ra) # 800035f0 <namei>
    80001292:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001296:	478d                	li	a5,3
    80001298:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000129a:	8526                	mv	a0,s1
    8000129c:	00005097          	auipc	ra,0x5
    800012a0:	384080e7          	jalr	900(ra) # 80006620 <release>
}
    800012a4:	60e2                	ld	ra,24(sp)
    800012a6:	6442                	ld	s0,16(sp)
    800012a8:	64a2                	ld	s1,8(sp)
    800012aa:	6105                	add	sp,sp,32
    800012ac:	8082                	ret

00000000800012ae <growproc>:
{
    800012ae:	1101                	add	sp,sp,-32
    800012b0:	ec06                	sd	ra,24(sp)
    800012b2:	e822                	sd	s0,16(sp)
    800012b4:	e426                	sd	s1,8(sp)
    800012b6:	e04a                	sd	s2,0(sp)
    800012b8:	1000                	add	s0,sp,32
    800012ba:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800012bc:	00000097          	auipc	ra,0x0
    800012c0:	c94080e7          	jalr	-876(ra) # 80000f50 <myproc>
    800012c4:	84aa                	mv	s1,a0
  sz = p->sz;
    800012c6:	652c                	ld	a1,72(a0)
  if(n > 0){
    800012c8:	01204c63          	bgtz	s2,800012e0 <growproc+0x32>
  } else if(n < 0){
    800012cc:	02094663          	bltz	s2,800012f8 <growproc+0x4a>
  p->sz = sz;
    800012d0:	e4ac                	sd	a1,72(s1)
  return 0;
    800012d2:	4501                	li	a0,0
}
    800012d4:	60e2                	ld	ra,24(sp)
    800012d6:	6442                	ld	s0,16(sp)
    800012d8:	64a2                	ld	s1,8(sp)
    800012da:	6902                	ld	s2,0(sp)
    800012dc:	6105                	add	sp,sp,32
    800012de:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800012e0:	4691                	li	a3,4
    800012e2:	00b90633          	add	a2,s2,a1
    800012e6:	6928                	ld	a0,80(a0)
    800012e8:	fffff097          	auipc	ra,0xfffff
    800012ec:	646080e7          	jalr	1606(ra) # 8000092e <uvmalloc>
    800012f0:	85aa                	mv	a1,a0
    800012f2:	fd79                	bnez	a0,800012d0 <growproc+0x22>
      return -1;
    800012f4:	557d                	li	a0,-1
    800012f6:	bff9                	j	800012d4 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800012f8:	00b90633          	add	a2,s2,a1
    800012fc:	6928                	ld	a0,80(a0)
    800012fe:	fffff097          	auipc	ra,0xfffff
    80001302:	5e8080e7          	jalr	1512(ra) # 800008e6 <uvmdealloc>
    80001306:	85aa                	mv	a1,a0
    80001308:	b7e1                	j	800012d0 <growproc+0x22>

000000008000130a <fork>:
{
    8000130a:	7139                	add	sp,sp,-64
    8000130c:	fc06                	sd	ra,56(sp)
    8000130e:	f822                	sd	s0,48(sp)
    80001310:	f04a                	sd	s2,32(sp)
    80001312:	e456                	sd	s5,8(sp)
    80001314:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001316:	00000097          	auipc	ra,0x0
    8000131a:	c3a080e7          	jalr	-966(ra) # 80000f50 <myproc>
    8000131e:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001320:	00000097          	auipc	ra,0x0
    80001324:	e3e080e7          	jalr	-450(ra) # 8000115e <allocproc>
    80001328:	12050463          	beqz	a0,80001450 <fork+0x146>
    8000132c:	ec4e                	sd	s3,24(sp)
    8000132e:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001330:	048ab603          	ld	a2,72(s5)
    80001334:	692c                	ld	a1,80(a0)
    80001336:	050ab503          	ld	a0,80(s5)
    8000133a:	fffff097          	auipc	ra,0xfffff
    8000133e:	758080e7          	jalr	1880(ra) # 80000a92 <uvmcopy>
    80001342:	04054a63          	bltz	a0,80001396 <fork+0x8c>
    80001346:	f426                	sd	s1,40(sp)
    80001348:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    8000134a:	048ab783          	ld	a5,72(s5)
    8000134e:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001352:	058ab683          	ld	a3,88(s5)
    80001356:	87b6                	mv	a5,a3
    80001358:	0589b703          	ld	a4,88(s3)
    8000135c:	12068693          	add	a3,a3,288
    80001360:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001364:	6788                	ld	a0,8(a5)
    80001366:	6b8c                	ld	a1,16(a5)
    80001368:	6f90                	ld	a2,24(a5)
    8000136a:	01073023          	sd	a6,0(a4)
    8000136e:	e708                	sd	a0,8(a4)
    80001370:	eb0c                	sd	a1,16(a4)
    80001372:	ef10                	sd	a2,24(a4)
    80001374:	02078793          	add	a5,a5,32
    80001378:	02070713          	add	a4,a4,32
    8000137c:	fed792e3          	bne	a5,a3,80001360 <fork+0x56>
  np->trapframe->a0 = 0;
    80001380:	0589b783          	ld	a5,88(s3)
    80001384:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001388:	0d0a8493          	add	s1,s5,208
    8000138c:	0d098913          	add	s2,s3,208
    80001390:	150a8a13          	add	s4,s5,336
    80001394:	a015                	j	800013b8 <fork+0xae>
    freeproc(np);
    80001396:	854e                	mv	a0,s3
    80001398:	00000097          	auipc	ra,0x0
    8000139c:	d6e080e7          	jalr	-658(ra) # 80001106 <freeproc>
    release(&np->lock);
    800013a0:	854e                	mv	a0,s3
    800013a2:	00005097          	auipc	ra,0x5
    800013a6:	27e080e7          	jalr	638(ra) # 80006620 <release>
    return -1;
    800013aa:	597d                	li	s2,-1
    800013ac:	69e2                	ld	s3,24(sp)
    800013ae:	a851                	j	80001442 <fork+0x138>
  for(i = 0; i < NOFILE; i++)
    800013b0:	04a1                	add	s1,s1,8
    800013b2:	0921                	add	s2,s2,8
    800013b4:	01448b63          	beq	s1,s4,800013ca <fork+0xc0>
    if(p->ofile[i])
    800013b8:	6088                	ld	a0,0(s1)
    800013ba:	d97d                	beqz	a0,800013b0 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800013bc:	00003097          	auipc	ra,0x3
    800013c0:	8ac080e7          	jalr	-1876(ra) # 80003c68 <filedup>
    800013c4:	00a93023          	sd	a0,0(s2)
    800013c8:	b7e5                	j	800013b0 <fork+0xa6>
  np->cwd = idup(p->cwd);
    800013ca:	150ab503          	ld	a0,336(s5)
    800013ce:	00002097          	auipc	ra,0x2
    800013d2:	a16080e7          	jalr	-1514(ra) # 80002de4 <idup>
    800013d6:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800013da:	4641                	li	a2,16
    800013dc:	158a8593          	add	a1,s5,344
    800013e0:	15898513          	add	a0,s3,344
    800013e4:	fffff097          	auipc	ra,0xfffff
    800013e8:	f22080e7          	jalr	-222(ra) # 80000306 <safestrcpy>
  pid = np->pid;
    800013ec:	0309a903          	lw	s2,48(s3)
  np->mask = p->mask;
    800013f0:	034aa783          	lw	a5,52(s5)
    800013f4:	02f9aa23          	sw	a5,52(s3)
  release(&np->lock);
    800013f8:	854e                	mv	a0,s3
    800013fa:	00005097          	auipc	ra,0x5
    800013fe:	226080e7          	jalr	550(ra) # 80006620 <release>
  acquire(&wait_lock);
    80001402:	0000a497          	auipc	s1,0xa
    80001406:	05648493          	add	s1,s1,86 # 8000b458 <wait_lock>
    8000140a:	8526                	mv	a0,s1
    8000140c:	00005097          	auipc	ra,0x5
    80001410:	160080e7          	jalr	352(ra) # 8000656c <acquire>
  np->parent = p;
    80001414:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001418:	8526                	mv	a0,s1
    8000141a:	00005097          	auipc	ra,0x5
    8000141e:	206080e7          	jalr	518(ra) # 80006620 <release>
  acquire(&np->lock);
    80001422:	854e                	mv	a0,s3
    80001424:	00005097          	auipc	ra,0x5
    80001428:	148080e7          	jalr	328(ra) # 8000656c <acquire>
  np->state = RUNNABLE;
    8000142c:	478d                	li	a5,3
    8000142e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001432:	854e                	mv	a0,s3
    80001434:	00005097          	auipc	ra,0x5
    80001438:	1ec080e7          	jalr	492(ra) # 80006620 <release>
  return pid;
    8000143c:	74a2                	ld	s1,40(sp)
    8000143e:	69e2                	ld	s3,24(sp)
    80001440:	6a42                	ld	s4,16(sp)
}
    80001442:	854a                	mv	a0,s2
    80001444:	70e2                	ld	ra,56(sp)
    80001446:	7442                	ld	s0,48(sp)
    80001448:	7902                	ld	s2,32(sp)
    8000144a:	6aa2                	ld	s5,8(sp)
    8000144c:	6121                	add	sp,sp,64
    8000144e:	8082                	ret
    return -1;
    80001450:	597d                	li	s2,-1
    80001452:	bfc5                	j	80001442 <fork+0x138>

0000000080001454 <scheduler>:
{
    80001454:	7139                	add	sp,sp,-64
    80001456:	fc06                	sd	ra,56(sp)
    80001458:	f822                	sd	s0,48(sp)
    8000145a:	f426                	sd	s1,40(sp)
    8000145c:	f04a                	sd	s2,32(sp)
    8000145e:	ec4e                	sd	s3,24(sp)
    80001460:	e852                	sd	s4,16(sp)
    80001462:	e456                	sd	s5,8(sp)
    80001464:	e05a                	sd	s6,0(sp)
    80001466:	0080                	add	s0,sp,64
    80001468:	8792                	mv	a5,tp
  int id = r_tp();
    8000146a:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000146c:	00779a93          	sll	s5,a5,0x7
    80001470:	0000a717          	auipc	a4,0xa
    80001474:	fd070713          	add	a4,a4,-48 # 8000b440 <pid_lock>
    80001478:	9756                	add	a4,a4,s5
    8000147a:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000147e:	0000a717          	auipc	a4,0xa
    80001482:	ffa70713          	add	a4,a4,-6 # 8000b478 <cpus+0x8>
    80001486:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001488:	498d                	li	s3,3
        p->state = RUNNING;
    8000148a:	4b11                	li	s6,4
        c->proc = p;
    8000148c:	079e                	sll	a5,a5,0x7
    8000148e:	0000aa17          	auipc	s4,0xa
    80001492:	fb2a0a13          	add	s4,s4,-78 # 8000b440 <pid_lock>
    80001496:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001498:	00010917          	auipc	s2,0x10
    8000149c:	dd890913          	add	s2,s2,-552 # 80011270 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014a0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800014a4:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800014a8:	10079073          	csrw	sstatus,a5
    800014ac:	0000a497          	auipc	s1,0xa
    800014b0:	3c448493          	add	s1,s1,964 # 8000b870 <proc>
    800014b4:	a811                	j	800014c8 <scheduler+0x74>
      release(&p->lock);
    800014b6:	8526                	mv	a0,s1
    800014b8:	00005097          	auipc	ra,0x5
    800014bc:	168080e7          	jalr	360(ra) # 80006620 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800014c0:	16848493          	add	s1,s1,360
    800014c4:	fd248ee3          	beq	s1,s2,800014a0 <scheduler+0x4c>
      acquire(&p->lock);
    800014c8:	8526                	mv	a0,s1
    800014ca:	00005097          	auipc	ra,0x5
    800014ce:	0a2080e7          	jalr	162(ra) # 8000656c <acquire>
      if(p->state == RUNNABLE) {
    800014d2:	4c9c                	lw	a5,24(s1)
    800014d4:	ff3791e3          	bne	a5,s3,800014b6 <scheduler+0x62>
        p->state = RUNNING;
    800014d8:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800014dc:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800014e0:	06048593          	add	a1,s1,96
    800014e4:	8556                	mv	a0,s5
    800014e6:	00000097          	auipc	ra,0x0
    800014ea:	6b2080e7          	jalr	1714(ra) # 80001b98 <swtch>
        c->proc = 0;
    800014ee:	020a3823          	sd	zero,48(s4)
    800014f2:	b7d1                	j	800014b6 <scheduler+0x62>

00000000800014f4 <sched>:
{
    800014f4:	7179                	add	sp,sp,-48
    800014f6:	f406                	sd	ra,40(sp)
    800014f8:	f022                	sd	s0,32(sp)
    800014fa:	ec26                	sd	s1,24(sp)
    800014fc:	e84a                	sd	s2,16(sp)
    800014fe:	e44e                	sd	s3,8(sp)
    80001500:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80001502:	00000097          	auipc	ra,0x0
    80001506:	a4e080e7          	jalr	-1458(ra) # 80000f50 <myproc>
    8000150a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000150c:	00005097          	auipc	ra,0x5
    80001510:	fe6080e7          	jalr	-26(ra) # 800064f2 <holding>
    80001514:	c93d                	beqz	a0,8000158a <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001516:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001518:	2781                	sext.w	a5,a5
    8000151a:	079e                	sll	a5,a5,0x7
    8000151c:	0000a717          	auipc	a4,0xa
    80001520:	f2470713          	add	a4,a4,-220 # 8000b440 <pid_lock>
    80001524:	97ba                	add	a5,a5,a4
    80001526:	0a87a703          	lw	a4,168(a5)
    8000152a:	4785                	li	a5,1
    8000152c:	06f71763          	bne	a4,a5,8000159a <sched+0xa6>
  if(p->state == RUNNING)
    80001530:	4c98                	lw	a4,24(s1)
    80001532:	4791                	li	a5,4
    80001534:	06f70b63          	beq	a4,a5,800015aa <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001538:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000153c:	8b89                	and	a5,a5,2
  if(intr_get())
    8000153e:	efb5                	bnez	a5,800015ba <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001540:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001542:	0000a917          	auipc	s2,0xa
    80001546:	efe90913          	add	s2,s2,-258 # 8000b440 <pid_lock>
    8000154a:	2781                	sext.w	a5,a5
    8000154c:	079e                	sll	a5,a5,0x7
    8000154e:	97ca                	add	a5,a5,s2
    80001550:	0ac7a983          	lw	s3,172(a5)
    80001554:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001556:	2781                	sext.w	a5,a5
    80001558:	079e                	sll	a5,a5,0x7
    8000155a:	0000a597          	auipc	a1,0xa
    8000155e:	f1e58593          	add	a1,a1,-226 # 8000b478 <cpus+0x8>
    80001562:	95be                	add	a1,a1,a5
    80001564:	06048513          	add	a0,s1,96
    80001568:	00000097          	auipc	ra,0x0
    8000156c:	630080e7          	jalr	1584(ra) # 80001b98 <swtch>
    80001570:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001572:	2781                	sext.w	a5,a5
    80001574:	079e                	sll	a5,a5,0x7
    80001576:	993e                	add	s2,s2,a5
    80001578:	0b392623          	sw	s3,172(s2)
}
    8000157c:	70a2                	ld	ra,40(sp)
    8000157e:	7402                	ld	s0,32(sp)
    80001580:	64e2                	ld	s1,24(sp)
    80001582:	6942                	ld	s2,16(sp)
    80001584:	69a2                	ld	s3,8(sp)
    80001586:	6145                	add	sp,sp,48
    80001588:	8082                	ret
    panic("sched p->lock");
    8000158a:	00007517          	auipc	a0,0x7
    8000158e:	c4e50513          	add	a0,a0,-946 # 800081d8 <etext+0x1d8>
    80001592:	00005097          	auipc	ra,0x5
    80001596:	a60080e7          	jalr	-1440(ra) # 80005ff2 <panic>
    panic("sched locks");
    8000159a:	00007517          	auipc	a0,0x7
    8000159e:	c4e50513          	add	a0,a0,-946 # 800081e8 <etext+0x1e8>
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	a50080e7          	jalr	-1456(ra) # 80005ff2 <panic>
    panic("sched running");
    800015aa:	00007517          	auipc	a0,0x7
    800015ae:	c4e50513          	add	a0,a0,-946 # 800081f8 <etext+0x1f8>
    800015b2:	00005097          	auipc	ra,0x5
    800015b6:	a40080e7          	jalr	-1472(ra) # 80005ff2 <panic>
    panic("sched interruptible");
    800015ba:	00007517          	auipc	a0,0x7
    800015be:	c4e50513          	add	a0,a0,-946 # 80008208 <etext+0x208>
    800015c2:	00005097          	auipc	ra,0x5
    800015c6:	a30080e7          	jalr	-1488(ra) # 80005ff2 <panic>

00000000800015ca <yield>:
{
    800015ca:	1101                	add	sp,sp,-32
    800015cc:	ec06                	sd	ra,24(sp)
    800015ce:	e822                	sd	s0,16(sp)
    800015d0:	e426                	sd	s1,8(sp)
    800015d2:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    800015d4:	00000097          	auipc	ra,0x0
    800015d8:	97c080e7          	jalr	-1668(ra) # 80000f50 <myproc>
    800015dc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015de:	00005097          	auipc	ra,0x5
    800015e2:	f8e080e7          	jalr	-114(ra) # 8000656c <acquire>
  p->state = RUNNABLE;
    800015e6:	478d                	li	a5,3
    800015e8:	cc9c                	sw	a5,24(s1)
  sched();
    800015ea:	00000097          	auipc	ra,0x0
    800015ee:	f0a080e7          	jalr	-246(ra) # 800014f4 <sched>
  release(&p->lock);
    800015f2:	8526                	mv	a0,s1
    800015f4:	00005097          	auipc	ra,0x5
    800015f8:	02c080e7          	jalr	44(ra) # 80006620 <release>
}
    800015fc:	60e2                	ld	ra,24(sp)
    800015fe:	6442                	ld	s0,16(sp)
    80001600:	64a2                	ld	s1,8(sp)
    80001602:	6105                	add	sp,sp,32
    80001604:	8082                	ret

0000000080001606 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001606:	7179                	add	sp,sp,-48
    80001608:	f406                	sd	ra,40(sp)
    8000160a:	f022                	sd	s0,32(sp)
    8000160c:	ec26                	sd	s1,24(sp)
    8000160e:	e84a                	sd	s2,16(sp)
    80001610:	e44e                	sd	s3,8(sp)
    80001612:	1800                	add	s0,sp,48
    80001614:	89aa                	mv	s3,a0
    80001616:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001618:	00000097          	auipc	ra,0x0
    8000161c:	938080e7          	jalr	-1736(ra) # 80000f50 <myproc>
    80001620:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001622:	00005097          	auipc	ra,0x5
    80001626:	f4a080e7          	jalr	-182(ra) # 8000656c <acquire>
  release(lk);
    8000162a:	854a                	mv	a0,s2
    8000162c:	00005097          	auipc	ra,0x5
    80001630:	ff4080e7          	jalr	-12(ra) # 80006620 <release>

  // Go to sleep.
  p->chan = chan;
    80001634:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001638:	4789                	li	a5,2
    8000163a:	cc9c                	sw	a5,24(s1)

  sched();
    8000163c:	00000097          	auipc	ra,0x0
    80001640:	eb8080e7          	jalr	-328(ra) # 800014f4 <sched>

  // Tidy up.
  p->chan = 0;
    80001644:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001648:	8526                	mv	a0,s1
    8000164a:	00005097          	auipc	ra,0x5
    8000164e:	fd6080e7          	jalr	-42(ra) # 80006620 <release>
  acquire(lk);
    80001652:	854a                	mv	a0,s2
    80001654:	00005097          	auipc	ra,0x5
    80001658:	f18080e7          	jalr	-232(ra) # 8000656c <acquire>
}
    8000165c:	70a2                	ld	ra,40(sp)
    8000165e:	7402                	ld	s0,32(sp)
    80001660:	64e2                	ld	s1,24(sp)
    80001662:	6942                	ld	s2,16(sp)
    80001664:	69a2                	ld	s3,8(sp)
    80001666:	6145                	add	sp,sp,48
    80001668:	8082                	ret

000000008000166a <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000166a:	7139                	add	sp,sp,-64
    8000166c:	fc06                	sd	ra,56(sp)
    8000166e:	f822                	sd	s0,48(sp)
    80001670:	f426                	sd	s1,40(sp)
    80001672:	f04a                	sd	s2,32(sp)
    80001674:	ec4e                	sd	s3,24(sp)
    80001676:	e852                	sd	s4,16(sp)
    80001678:	e456                	sd	s5,8(sp)
    8000167a:	0080                	add	s0,sp,64
    8000167c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000167e:	0000a497          	auipc	s1,0xa
    80001682:	1f248493          	add	s1,s1,498 # 8000b870 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001686:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001688:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000168a:	00010917          	auipc	s2,0x10
    8000168e:	be690913          	add	s2,s2,-1050 # 80011270 <tickslock>
    80001692:	a811                	j	800016a6 <wakeup+0x3c>
      }
      release(&p->lock);
    80001694:	8526                	mv	a0,s1
    80001696:	00005097          	auipc	ra,0x5
    8000169a:	f8a080e7          	jalr	-118(ra) # 80006620 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000169e:	16848493          	add	s1,s1,360
    800016a2:	03248663          	beq	s1,s2,800016ce <wakeup+0x64>
    if(p != myproc()){
    800016a6:	00000097          	auipc	ra,0x0
    800016aa:	8aa080e7          	jalr	-1878(ra) # 80000f50 <myproc>
    800016ae:	fea488e3          	beq	s1,a0,8000169e <wakeup+0x34>
      acquire(&p->lock);
    800016b2:	8526                	mv	a0,s1
    800016b4:	00005097          	auipc	ra,0x5
    800016b8:	eb8080e7          	jalr	-328(ra) # 8000656c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016bc:	4c9c                	lw	a5,24(s1)
    800016be:	fd379be3          	bne	a5,s3,80001694 <wakeup+0x2a>
    800016c2:	709c                	ld	a5,32(s1)
    800016c4:	fd4798e3          	bne	a5,s4,80001694 <wakeup+0x2a>
        p->state = RUNNABLE;
    800016c8:	0154ac23          	sw	s5,24(s1)
    800016cc:	b7e1                	j	80001694 <wakeup+0x2a>
    }
  }
}
    800016ce:	70e2                	ld	ra,56(sp)
    800016d0:	7442                	ld	s0,48(sp)
    800016d2:	74a2                	ld	s1,40(sp)
    800016d4:	7902                	ld	s2,32(sp)
    800016d6:	69e2                	ld	s3,24(sp)
    800016d8:	6a42                	ld	s4,16(sp)
    800016da:	6aa2                	ld	s5,8(sp)
    800016dc:	6121                	add	sp,sp,64
    800016de:	8082                	ret

00000000800016e0 <reparent>:
{
    800016e0:	7179                	add	sp,sp,-48
    800016e2:	f406                	sd	ra,40(sp)
    800016e4:	f022                	sd	s0,32(sp)
    800016e6:	ec26                	sd	s1,24(sp)
    800016e8:	e84a                	sd	s2,16(sp)
    800016ea:	e44e                	sd	s3,8(sp)
    800016ec:	e052                	sd	s4,0(sp)
    800016ee:	1800                	add	s0,sp,48
    800016f0:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800016f2:	0000a497          	auipc	s1,0xa
    800016f6:	17e48493          	add	s1,s1,382 # 8000b870 <proc>
      pp->parent = initproc;
    800016fa:	0000aa17          	auipc	s4,0xa
    800016fe:	d06a0a13          	add	s4,s4,-762 # 8000b400 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001702:	00010997          	auipc	s3,0x10
    80001706:	b6e98993          	add	s3,s3,-1170 # 80011270 <tickslock>
    8000170a:	a029                	j	80001714 <reparent+0x34>
    8000170c:	16848493          	add	s1,s1,360
    80001710:	01348d63          	beq	s1,s3,8000172a <reparent+0x4a>
    if(pp->parent == p){
    80001714:	7c9c                	ld	a5,56(s1)
    80001716:	ff279be3          	bne	a5,s2,8000170c <reparent+0x2c>
      pp->parent = initproc;
    8000171a:	000a3503          	ld	a0,0(s4)
    8000171e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001720:	00000097          	auipc	ra,0x0
    80001724:	f4a080e7          	jalr	-182(ra) # 8000166a <wakeup>
    80001728:	b7d5                	j	8000170c <reparent+0x2c>
}
    8000172a:	70a2                	ld	ra,40(sp)
    8000172c:	7402                	ld	s0,32(sp)
    8000172e:	64e2                	ld	s1,24(sp)
    80001730:	6942                	ld	s2,16(sp)
    80001732:	69a2                	ld	s3,8(sp)
    80001734:	6a02                	ld	s4,0(sp)
    80001736:	6145                	add	sp,sp,48
    80001738:	8082                	ret

000000008000173a <exit>:
{
    8000173a:	7179                	add	sp,sp,-48
    8000173c:	f406                	sd	ra,40(sp)
    8000173e:	f022                	sd	s0,32(sp)
    80001740:	ec26                	sd	s1,24(sp)
    80001742:	e84a                	sd	s2,16(sp)
    80001744:	e44e                	sd	s3,8(sp)
    80001746:	e052                	sd	s4,0(sp)
    80001748:	1800                	add	s0,sp,48
    8000174a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000174c:	00000097          	auipc	ra,0x0
    80001750:	804080e7          	jalr	-2044(ra) # 80000f50 <myproc>
    80001754:	89aa                	mv	s3,a0
  if(p == initproc)
    80001756:	0000a797          	auipc	a5,0xa
    8000175a:	caa7b783          	ld	a5,-854(a5) # 8000b400 <initproc>
    8000175e:	0d050493          	add	s1,a0,208
    80001762:	15050913          	add	s2,a0,336
    80001766:	02a79363          	bne	a5,a0,8000178c <exit+0x52>
    panic("init exiting");
    8000176a:	00007517          	auipc	a0,0x7
    8000176e:	ab650513          	add	a0,a0,-1354 # 80008220 <etext+0x220>
    80001772:	00005097          	auipc	ra,0x5
    80001776:	880080e7          	jalr	-1920(ra) # 80005ff2 <panic>
      fileclose(f);
    8000177a:	00002097          	auipc	ra,0x2
    8000177e:	540080e7          	jalr	1344(ra) # 80003cba <fileclose>
      p->ofile[fd] = 0;
    80001782:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001786:	04a1                	add	s1,s1,8
    80001788:	01248563          	beq	s1,s2,80001792 <exit+0x58>
    if(p->ofile[fd]){
    8000178c:	6088                	ld	a0,0(s1)
    8000178e:	f575                	bnez	a0,8000177a <exit+0x40>
    80001790:	bfdd                	j	80001786 <exit+0x4c>
  begin_op();
    80001792:	00002097          	auipc	ra,0x2
    80001796:	05e080e7          	jalr	94(ra) # 800037f0 <begin_op>
  iput(p->cwd);
    8000179a:	1509b503          	ld	a0,336(s3)
    8000179e:	00002097          	auipc	ra,0x2
    800017a2:	842080e7          	jalr	-1982(ra) # 80002fe0 <iput>
  end_op();
    800017a6:	00002097          	auipc	ra,0x2
    800017aa:	0c4080e7          	jalr	196(ra) # 8000386a <end_op>
  p->cwd = 0;
    800017ae:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017b2:	0000a497          	auipc	s1,0xa
    800017b6:	ca648493          	add	s1,s1,-858 # 8000b458 <wait_lock>
    800017ba:	8526                	mv	a0,s1
    800017bc:	00005097          	auipc	ra,0x5
    800017c0:	db0080e7          	jalr	-592(ra) # 8000656c <acquire>
  reparent(p);
    800017c4:	854e                	mv	a0,s3
    800017c6:	00000097          	auipc	ra,0x0
    800017ca:	f1a080e7          	jalr	-230(ra) # 800016e0 <reparent>
  wakeup(p->parent);
    800017ce:	0389b503          	ld	a0,56(s3)
    800017d2:	00000097          	auipc	ra,0x0
    800017d6:	e98080e7          	jalr	-360(ra) # 8000166a <wakeup>
  acquire(&p->lock);
    800017da:	854e                	mv	a0,s3
    800017dc:	00005097          	auipc	ra,0x5
    800017e0:	d90080e7          	jalr	-624(ra) # 8000656c <acquire>
  p->xstate = status;
    800017e4:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800017e8:	4795                	li	a5,5
    800017ea:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800017ee:	8526                	mv	a0,s1
    800017f0:	00005097          	auipc	ra,0x5
    800017f4:	e30080e7          	jalr	-464(ra) # 80006620 <release>
  sched();
    800017f8:	00000097          	auipc	ra,0x0
    800017fc:	cfc080e7          	jalr	-772(ra) # 800014f4 <sched>
  panic("zombie exit");
    80001800:	00007517          	auipc	a0,0x7
    80001804:	a3050513          	add	a0,a0,-1488 # 80008230 <etext+0x230>
    80001808:	00004097          	auipc	ra,0x4
    8000180c:	7ea080e7          	jalr	2026(ra) # 80005ff2 <panic>

0000000080001810 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001810:	7179                	add	sp,sp,-48
    80001812:	f406                	sd	ra,40(sp)
    80001814:	f022                	sd	s0,32(sp)
    80001816:	ec26                	sd	s1,24(sp)
    80001818:	e84a                	sd	s2,16(sp)
    8000181a:	e44e                	sd	s3,8(sp)
    8000181c:	1800                	add	s0,sp,48
    8000181e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001820:	0000a497          	auipc	s1,0xa
    80001824:	05048493          	add	s1,s1,80 # 8000b870 <proc>
    80001828:	00010997          	auipc	s3,0x10
    8000182c:	a4898993          	add	s3,s3,-1464 # 80011270 <tickslock>
    acquire(&p->lock);
    80001830:	8526                	mv	a0,s1
    80001832:	00005097          	auipc	ra,0x5
    80001836:	d3a080e7          	jalr	-710(ra) # 8000656c <acquire>
    if(p->pid == pid){
    8000183a:	589c                	lw	a5,48(s1)
    8000183c:	01278d63          	beq	a5,s2,80001856 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001840:	8526                	mv	a0,s1
    80001842:	00005097          	auipc	ra,0x5
    80001846:	dde080e7          	jalr	-546(ra) # 80006620 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000184a:	16848493          	add	s1,s1,360
    8000184e:	ff3491e3          	bne	s1,s3,80001830 <kill+0x20>
  }
  return -1;
    80001852:	557d                	li	a0,-1
    80001854:	a829                	j	8000186e <kill+0x5e>
      p->killed = 1;
    80001856:	4785                	li	a5,1
    80001858:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000185a:	4c98                	lw	a4,24(s1)
    8000185c:	4789                	li	a5,2
    8000185e:	00f70f63          	beq	a4,a5,8000187c <kill+0x6c>
      release(&p->lock);
    80001862:	8526                	mv	a0,s1
    80001864:	00005097          	auipc	ra,0x5
    80001868:	dbc080e7          	jalr	-580(ra) # 80006620 <release>
      return 0;
    8000186c:	4501                	li	a0,0
}
    8000186e:	70a2                	ld	ra,40(sp)
    80001870:	7402                	ld	s0,32(sp)
    80001872:	64e2                	ld	s1,24(sp)
    80001874:	6942                	ld	s2,16(sp)
    80001876:	69a2                	ld	s3,8(sp)
    80001878:	6145                	add	sp,sp,48
    8000187a:	8082                	ret
        p->state = RUNNABLE;
    8000187c:	478d                	li	a5,3
    8000187e:	cc9c                	sw	a5,24(s1)
    80001880:	b7cd                	j	80001862 <kill+0x52>

0000000080001882 <setkilled>:

void
setkilled(struct proc *p)
{
    80001882:	1101                	add	sp,sp,-32
    80001884:	ec06                	sd	ra,24(sp)
    80001886:	e822                	sd	s0,16(sp)
    80001888:	e426                	sd	s1,8(sp)
    8000188a:	1000                	add	s0,sp,32
    8000188c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000188e:	00005097          	auipc	ra,0x5
    80001892:	cde080e7          	jalr	-802(ra) # 8000656c <acquire>
  p->killed = 1;
    80001896:	4785                	li	a5,1
    80001898:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000189a:	8526                	mv	a0,s1
    8000189c:	00005097          	auipc	ra,0x5
    800018a0:	d84080e7          	jalr	-636(ra) # 80006620 <release>
}
    800018a4:	60e2                	ld	ra,24(sp)
    800018a6:	6442                	ld	s0,16(sp)
    800018a8:	64a2                	ld	s1,8(sp)
    800018aa:	6105                	add	sp,sp,32
    800018ac:	8082                	ret

00000000800018ae <killed>:

int
killed(struct proc *p)
{
    800018ae:	1101                	add	sp,sp,-32
    800018b0:	ec06                	sd	ra,24(sp)
    800018b2:	e822                	sd	s0,16(sp)
    800018b4:	e426                	sd	s1,8(sp)
    800018b6:	e04a                	sd	s2,0(sp)
    800018b8:	1000                	add	s0,sp,32
    800018ba:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800018bc:	00005097          	auipc	ra,0x5
    800018c0:	cb0080e7          	jalr	-848(ra) # 8000656c <acquire>
  k = p->killed;
    800018c4:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800018c8:	8526                	mv	a0,s1
    800018ca:	00005097          	auipc	ra,0x5
    800018ce:	d56080e7          	jalr	-682(ra) # 80006620 <release>
  return k;
}
    800018d2:	854a                	mv	a0,s2
    800018d4:	60e2                	ld	ra,24(sp)
    800018d6:	6442                	ld	s0,16(sp)
    800018d8:	64a2                	ld	s1,8(sp)
    800018da:	6902                	ld	s2,0(sp)
    800018dc:	6105                	add	sp,sp,32
    800018de:	8082                	ret

00000000800018e0 <wait>:
{
    800018e0:	715d                	add	sp,sp,-80
    800018e2:	e486                	sd	ra,72(sp)
    800018e4:	e0a2                	sd	s0,64(sp)
    800018e6:	fc26                	sd	s1,56(sp)
    800018e8:	f84a                	sd	s2,48(sp)
    800018ea:	f44e                	sd	s3,40(sp)
    800018ec:	f052                	sd	s4,32(sp)
    800018ee:	ec56                	sd	s5,24(sp)
    800018f0:	e85a                	sd	s6,16(sp)
    800018f2:	e45e                	sd	s7,8(sp)
    800018f4:	e062                	sd	s8,0(sp)
    800018f6:	0880                	add	s0,sp,80
    800018f8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800018fa:	fffff097          	auipc	ra,0xfffff
    800018fe:	656080e7          	jalr	1622(ra) # 80000f50 <myproc>
    80001902:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001904:	0000a517          	auipc	a0,0xa
    80001908:	b5450513          	add	a0,a0,-1196 # 8000b458 <wait_lock>
    8000190c:	00005097          	auipc	ra,0x5
    80001910:	c60080e7          	jalr	-928(ra) # 8000656c <acquire>
    havekids = 0;
    80001914:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001916:	4a15                	li	s4,5
        havekids = 1;
    80001918:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000191a:	00010997          	auipc	s3,0x10
    8000191e:	95698993          	add	s3,s3,-1706 # 80011270 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001922:	0000ac17          	auipc	s8,0xa
    80001926:	b36c0c13          	add	s8,s8,-1226 # 8000b458 <wait_lock>
    8000192a:	a0d1                	j	800019ee <wait+0x10e>
          pid = pp->pid;
    8000192c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001930:	000b0e63          	beqz	s6,8000194c <wait+0x6c>
    80001934:	4691                	li	a3,4
    80001936:	02c48613          	add	a2,s1,44
    8000193a:	85da                	mv	a1,s6
    8000193c:	05093503          	ld	a0,80(s2)
    80001940:	fffff097          	auipc	ra,0xfffff
    80001944:	256080e7          	jalr	598(ra) # 80000b96 <copyout>
    80001948:	04054163          	bltz	a0,8000198a <wait+0xaa>
          freeproc(pp);
    8000194c:	8526                	mv	a0,s1
    8000194e:	fffff097          	auipc	ra,0xfffff
    80001952:	7b8080e7          	jalr	1976(ra) # 80001106 <freeproc>
          release(&pp->lock);
    80001956:	8526                	mv	a0,s1
    80001958:	00005097          	auipc	ra,0x5
    8000195c:	cc8080e7          	jalr	-824(ra) # 80006620 <release>
          release(&wait_lock);
    80001960:	0000a517          	auipc	a0,0xa
    80001964:	af850513          	add	a0,a0,-1288 # 8000b458 <wait_lock>
    80001968:	00005097          	auipc	ra,0x5
    8000196c:	cb8080e7          	jalr	-840(ra) # 80006620 <release>
}
    80001970:	854e                	mv	a0,s3
    80001972:	60a6                	ld	ra,72(sp)
    80001974:	6406                	ld	s0,64(sp)
    80001976:	74e2                	ld	s1,56(sp)
    80001978:	7942                	ld	s2,48(sp)
    8000197a:	79a2                	ld	s3,40(sp)
    8000197c:	7a02                	ld	s4,32(sp)
    8000197e:	6ae2                	ld	s5,24(sp)
    80001980:	6b42                	ld	s6,16(sp)
    80001982:	6ba2                	ld	s7,8(sp)
    80001984:	6c02                	ld	s8,0(sp)
    80001986:	6161                	add	sp,sp,80
    80001988:	8082                	ret
            release(&pp->lock);
    8000198a:	8526                	mv	a0,s1
    8000198c:	00005097          	auipc	ra,0x5
    80001990:	c94080e7          	jalr	-876(ra) # 80006620 <release>
            release(&wait_lock);
    80001994:	0000a517          	auipc	a0,0xa
    80001998:	ac450513          	add	a0,a0,-1340 # 8000b458 <wait_lock>
    8000199c:	00005097          	auipc	ra,0x5
    800019a0:	c84080e7          	jalr	-892(ra) # 80006620 <release>
            return -1;
    800019a4:	59fd                	li	s3,-1
    800019a6:	b7e9                	j	80001970 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019a8:	16848493          	add	s1,s1,360
    800019ac:	03348463          	beq	s1,s3,800019d4 <wait+0xf4>
      if(pp->parent == p){
    800019b0:	7c9c                	ld	a5,56(s1)
    800019b2:	ff279be3          	bne	a5,s2,800019a8 <wait+0xc8>
        acquire(&pp->lock);
    800019b6:	8526                	mv	a0,s1
    800019b8:	00005097          	auipc	ra,0x5
    800019bc:	bb4080e7          	jalr	-1100(ra) # 8000656c <acquire>
        if(pp->state == ZOMBIE){
    800019c0:	4c9c                	lw	a5,24(s1)
    800019c2:	f74785e3          	beq	a5,s4,8000192c <wait+0x4c>
        release(&pp->lock);
    800019c6:	8526                	mv	a0,s1
    800019c8:	00005097          	auipc	ra,0x5
    800019cc:	c58080e7          	jalr	-936(ra) # 80006620 <release>
        havekids = 1;
    800019d0:	8756                	mv	a4,s5
    800019d2:	bfd9                	j	800019a8 <wait+0xc8>
    if(!havekids || killed(p)){
    800019d4:	c31d                	beqz	a4,800019fa <wait+0x11a>
    800019d6:	854a                	mv	a0,s2
    800019d8:	00000097          	auipc	ra,0x0
    800019dc:	ed6080e7          	jalr	-298(ra) # 800018ae <killed>
    800019e0:	ed09                	bnez	a0,800019fa <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800019e2:	85e2                	mv	a1,s8
    800019e4:	854a                	mv	a0,s2
    800019e6:	00000097          	auipc	ra,0x0
    800019ea:	c20080e7          	jalr	-992(ra) # 80001606 <sleep>
    havekids = 0;
    800019ee:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019f0:	0000a497          	auipc	s1,0xa
    800019f4:	e8048493          	add	s1,s1,-384 # 8000b870 <proc>
    800019f8:	bf65                	j	800019b0 <wait+0xd0>
      release(&wait_lock);
    800019fa:	0000a517          	auipc	a0,0xa
    800019fe:	a5e50513          	add	a0,a0,-1442 # 8000b458 <wait_lock>
    80001a02:	00005097          	auipc	ra,0x5
    80001a06:	c1e080e7          	jalr	-994(ra) # 80006620 <release>
      return -1;
    80001a0a:	59fd                	li	s3,-1
    80001a0c:	b795                	j	80001970 <wait+0x90>

0000000080001a0e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a0e:	7179                	add	sp,sp,-48
    80001a10:	f406                	sd	ra,40(sp)
    80001a12:	f022                	sd	s0,32(sp)
    80001a14:	ec26                	sd	s1,24(sp)
    80001a16:	e84a                	sd	s2,16(sp)
    80001a18:	e44e                	sd	s3,8(sp)
    80001a1a:	e052                	sd	s4,0(sp)
    80001a1c:	1800                	add	s0,sp,48
    80001a1e:	84aa                	mv	s1,a0
    80001a20:	892e                	mv	s2,a1
    80001a22:	89b2                	mv	s3,a2
    80001a24:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a26:	fffff097          	auipc	ra,0xfffff
    80001a2a:	52a080e7          	jalr	1322(ra) # 80000f50 <myproc>
  if(user_dst){
    80001a2e:	c08d                	beqz	s1,80001a50 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a30:	86d2                	mv	a3,s4
    80001a32:	864e                	mv	a2,s3
    80001a34:	85ca                	mv	a1,s2
    80001a36:	6928                	ld	a0,80(a0)
    80001a38:	fffff097          	auipc	ra,0xfffff
    80001a3c:	15e080e7          	jalr	350(ra) # 80000b96 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a40:	70a2                	ld	ra,40(sp)
    80001a42:	7402                	ld	s0,32(sp)
    80001a44:	64e2                	ld	s1,24(sp)
    80001a46:	6942                	ld	s2,16(sp)
    80001a48:	69a2                	ld	s3,8(sp)
    80001a4a:	6a02                	ld	s4,0(sp)
    80001a4c:	6145                	add	sp,sp,48
    80001a4e:	8082                	ret
    memmove((char *)dst, src, len);
    80001a50:	000a061b          	sext.w	a2,s4
    80001a54:	85ce                	mv	a1,s3
    80001a56:	854a                	mv	a0,s2
    80001a58:	ffffe097          	auipc	ra,0xffffe
    80001a5c:	7c8080e7          	jalr	1992(ra) # 80000220 <memmove>
    return 0;
    80001a60:	8526                	mv	a0,s1
    80001a62:	bff9                	j	80001a40 <either_copyout+0x32>

0000000080001a64 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a64:	7179                	add	sp,sp,-48
    80001a66:	f406                	sd	ra,40(sp)
    80001a68:	f022                	sd	s0,32(sp)
    80001a6a:	ec26                	sd	s1,24(sp)
    80001a6c:	e84a                	sd	s2,16(sp)
    80001a6e:	e44e                	sd	s3,8(sp)
    80001a70:	e052                	sd	s4,0(sp)
    80001a72:	1800                	add	s0,sp,48
    80001a74:	892a                	mv	s2,a0
    80001a76:	84ae                	mv	s1,a1
    80001a78:	89b2                	mv	s3,a2
    80001a7a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a7c:	fffff097          	auipc	ra,0xfffff
    80001a80:	4d4080e7          	jalr	1236(ra) # 80000f50 <myproc>
  if(user_src){
    80001a84:	c08d                	beqz	s1,80001aa6 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a86:	86d2                	mv	a3,s4
    80001a88:	864e                	mv	a2,s3
    80001a8a:	85ca                	mv	a1,s2
    80001a8c:	6928                	ld	a0,80(a0)
    80001a8e:	fffff097          	auipc	ra,0xfffff
    80001a92:	1e6080e7          	jalr	486(ra) # 80000c74 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a96:	70a2                	ld	ra,40(sp)
    80001a98:	7402                	ld	s0,32(sp)
    80001a9a:	64e2                	ld	s1,24(sp)
    80001a9c:	6942                	ld	s2,16(sp)
    80001a9e:	69a2                	ld	s3,8(sp)
    80001aa0:	6a02                	ld	s4,0(sp)
    80001aa2:	6145                	add	sp,sp,48
    80001aa4:	8082                	ret
    memmove(dst, (char*)src, len);
    80001aa6:	000a061b          	sext.w	a2,s4
    80001aaa:	85ce                	mv	a1,s3
    80001aac:	854a                	mv	a0,s2
    80001aae:	ffffe097          	auipc	ra,0xffffe
    80001ab2:	772080e7          	jalr	1906(ra) # 80000220 <memmove>
    return 0;
    80001ab6:	8526                	mv	a0,s1
    80001ab8:	bff9                	j	80001a96 <either_copyin+0x32>

0000000080001aba <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001aba:	715d                	add	sp,sp,-80
    80001abc:	e486                	sd	ra,72(sp)
    80001abe:	e0a2                	sd	s0,64(sp)
    80001ac0:	fc26                	sd	s1,56(sp)
    80001ac2:	f84a                	sd	s2,48(sp)
    80001ac4:	f44e                	sd	s3,40(sp)
    80001ac6:	f052                	sd	s4,32(sp)
    80001ac8:	ec56                	sd	s5,24(sp)
    80001aca:	e85a                	sd	s6,16(sp)
    80001acc:	e45e                	sd	s7,8(sp)
    80001ace:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001ad0:	00006517          	auipc	a0,0x6
    80001ad4:	54850513          	add	a0,a0,1352 # 80008018 <etext+0x18>
    80001ad8:	00004097          	auipc	ra,0x4
    80001adc:	564080e7          	jalr	1380(ra) # 8000603c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ae0:	0000a497          	auipc	s1,0xa
    80001ae4:	ee848493          	add	s1,s1,-280 # 8000b9c8 <proc+0x158>
    80001ae8:	00010917          	auipc	s2,0x10
    80001aec:	8e090913          	add	s2,s2,-1824 # 800113c8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001af0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001af2:	00006997          	auipc	s3,0x6
    80001af6:	74e98993          	add	s3,s3,1870 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001afa:	00006a97          	auipc	s5,0x6
    80001afe:	74ea8a93          	add	s5,s5,1870 # 80008248 <etext+0x248>
    printf("\n");
    80001b02:	00006a17          	auipc	s4,0x6
    80001b06:	516a0a13          	add	s4,s4,1302 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b0a:	00007b97          	auipc	s7,0x7
    80001b0e:	d2eb8b93          	add	s7,s7,-722 # 80008838 <states.0>
    80001b12:	a00d                	j	80001b34 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b14:	ed86a583          	lw	a1,-296(a3)
    80001b18:	8556                	mv	a0,s5
    80001b1a:	00004097          	auipc	ra,0x4
    80001b1e:	522080e7          	jalr	1314(ra) # 8000603c <printf>
    printf("\n");
    80001b22:	8552                	mv	a0,s4
    80001b24:	00004097          	auipc	ra,0x4
    80001b28:	518080e7          	jalr	1304(ra) # 8000603c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b2c:	16848493          	add	s1,s1,360
    80001b30:	03248263          	beq	s1,s2,80001b54 <procdump+0x9a>
    if(p->state == UNUSED)
    80001b34:	86a6                	mv	a3,s1
    80001b36:	ec04a783          	lw	a5,-320(s1)
    80001b3a:	dbed                	beqz	a5,80001b2c <procdump+0x72>
      state = "???";
    80001b3c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b3e:	fcfb6be3          	bltu	s6,a5,80001b14 <procdump+0x5a>
    80001b42:	02079713          	sll	a4,a5,0x20
    80001b46:	01d75793          	srl	a5,a4,0x1d
    80001b4a:	97de                	add	a5,a5,s7
    80001b4c:	6390                	ld	a2,0(a5)
    80001b4e:	f279                	bnez	a2,80001b14 <procdump+0x5a>
      state = "???";
    80001b50:	864e                	mv	a2,s3
    80001b52:	b7c9                	j	80001b14 <procdump+0x5a>
  }
}
    80001b54:	60a6                	ld	ra,72(sp)
    80001b56:	6406                	ld	s0,64(sp)
    80001b58:	74e2                	ld	s1,56(sp)
    80001b5a:	7942                	ld	s2,48(sp)
    80001b5c:	79a2                	ld	s3,40(sp)
    80001b5e:	7a02                	ld	s4,32(sp)
    80001b60:	6ae2                	ld	s5,24(sp)
    80001b62:	6b42                	ld	s6,16(sp)
    80001b64:	6ba2                	ld	s7,8(sp)
    80001b66:	6161                	add	sp,sp,80
    80001b68:	8082                	ret

0000000080001b6a <numofproc>:

uint64 numofproc(void){
    80001b6a:	1141                	add	sp,sp,-16
    80001b6c:	e422                	sd	s0,8(sp)
    80001b6e:	0800                	add	s0,sp,16
  struct proc *p;
  uint64 count = 0;
    80001b70:	4501                	li	a0,0

  for(p = proc; p < &proc[NPROC]; p++) {
    80001b72:	0000a797          	auipc	a5,0xa
    80001b76:	cfe78793          	add	a5,a5,-770 # 8000b870 <proc>
    80001b7a:	0000f697          	auipc	a3,0xf
    80001b7e:	6f668693          	add	a3,a3,1782 # 80011270 <tickslock>
    if(p->state != UNUSED)
    80001b82:	4f98                	lw	a4,24(a5)
      count++;
    80001b84:	00e03733          	snez	a4,a4
    80001b88:	953a                	add	a0,a0,a4
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b8a:	16878793          	add	a5,a5,360
    80001b8e:	fed79ae3          	bne	a5,a3,80001b82 <numofproc+0x18>
  }

  return count;
}
    80001b92:	6422                	ld	s0,8(sp)
    80001b94:	0141                	add	sp,sp,16
    80001b96:	8082                	ret

0000000080001b98 <swtch>:
    80001b98:	00153023          	sd	ra,0(a0)
    80001b9c:	00253423          	sd	sp,8(a0)
    80001ba0:	e900                	sd	s0,16(a0)
    80001ba2:	ed04                	sd	s1,24(a0)
    80001ba4:	03253023          	sd	s2,32(a0)
    80001ba8:	03353423          	sd	s3,40(a0)
    80001bac:	03453823          	sd	s4,48(a0)
    80001bb0:	03553c23          	sd	s5,56(a0)
    80001bb4:	05653023          	sd	s6,64(a0)
    80001bb8:	05753423          	sd	s7,72(a0)
    80001bbc:	05853823          	sd	s8,80(a0)
    80001bc0:	05953c23          	sd	s9,88(a0)
    80001bc4:	07a53023          	sd	s10,96(a0)
    80001bc8:	07b53423          	sd	s11,104(a0)
    80001bcc:	0005b083          	ld	ra,0(a1)
    80001bd0:	0085b103          	ld	sp,8(a1)
    80001bd4:	6980                	ld	s0,16(a1)
    80001bd6:	6d84                	ld	s1,24(a1)
    80001bd8:	0205b903          	ld	s2,32(a1)
    80001bdc:	0285b983          	ld	s3,40(a1)
    80001be0:	0305ba03          	ld	s4,48(a1)
    80001be4:	0385ba83          	ld	s5,56(a1)
    80001be8:	0405bb03          	ld	s6,64(a1)
    80001bec:	0485bb83          	ld	s7,72(a1)
    80001bf0:	0505bc03          	ld	s8,80(a1)
    80001bf4:	0585bc83          	ld	s9,88(a1)
    80001bf8:	0605bd03          	ld	s10,96(a1)
    80001bfc:	0685bd83          	ld	s11,104(a1)
    80001c00:	8082                	ret

0000000080001c02 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c02:	1141                	add	sp,sp,-16
    80001c04:	e406                	sd	ra,8(sp)
    80001c06:	e022                	sd	s0,0(sp)
    80001c08:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80001c0a:	00006597          	auipc	a1,0x6
    80001c0e:	67e58593          	add	a1,a1,1662 # 80008288 <etext+0x288>
    80001c12:	0000f517          	auipc	a0,0xf
    80001c16:	65e50513          	add	a0,a0,1630 # 80011270 <tickslock>
    80001c1a:	00005097          	auipc	ra,0x5
    80001c1e:	8c2080e7          	jalr	-1854(ra) # 800064dc <initlock>
}
    80001c22:	60a2                	ld	ra,8(sp)
    80001c24:	6402                	ld	s0,0(sp)
    80001c26:	0141                	add	sp,sp,16
    80001c28:	8082                	ret

0000000080001c2a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c2a:	1141                	add	sp,sp,-16
    80001c2c:	e422                	sd	s0,8(sp)
    80001c2e:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c30:	00003797          	auipc	a5,0x3
    80001c34:	79078793          	add	a5,a5,1936 # 800053c0 <kernelvec>
    80001c38:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c3c:	6422                	ld	s0,8(sp)
    80001c3e:	0141                	add	sp,sp,16
    80001c40:	8082                	ret

0000000080001c42 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c42:	1141                	add	sp,sp,-16
    80001c44:	e406                	sd	ra,8(sp)
    80001c46:	e022                	sd	s0,0(sp)
    80001c48:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80001c4a:	fffff097          	auipc	ra,0xfffff
    80001c4e:	306080e7          	jalr	774(ra) # 80000f50 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c52:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c56:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c58:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001c5c:	00005697          	auipc	a3,0x5
    80001c60:	3a468693          	add	a3,a3,932 # 80007000 <_trampoline>
    80001c64:	00005717          	auipc	a4,0x5
    80001c68:	39c70713          	add	a4,a4,924 # 80007000 <_trampoline>
    80001c6c:	8f15                	sub	a4,a4,a3
    80001c6e:	040007b7          	lui	a5,0x4000
    80001c72:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c74:	07b2                	sll	a5,a5,0xc
    80001c76:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c78:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c7c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c7e:	18002673          	csrr	a2,satp
    80001c82:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c84:	6d30                	ld	a2,88(a0)
    80001c86:	6138                	ld	a4,64(a0)
    80001c88:	6585                	lui	a1,0x1
    80001c8a:	972e                	add	a4,a4,a1
    80001c8c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c8e:	6d38                	ld	a4,88(a0)
    80001c90:	00000617          	auipc	a2,0x0
    80001c94:	13860613          	add	a2,a2,312 # 80001dc8 <usertrap>
    80001c98:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c9a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c9c:	8612                	mv	a2,tp
    80001c9e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ca0:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001ca4:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001ca8:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cac:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001cb0:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cb2:	6f18                	ld	a4,24(a4)
    80001cb4:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001cb8:	6928                	ld	a0,80(a0)
    80001cba:	8131                	srl	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001cbc:	00005717          	auipc	a4,0x5
    80001cc0:	3e070713          	add	a4,a4,992 # 8000709c <userret>
    80001cc4:	8f15                	sub	a4,a4,a3
    80001cc6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001cc8:	577d                	li	a4,-1
    80001cca:	177e                	sll	a4,a4,0x3f
    80001ccc:	8d59                	or	a0,a0,a4
    80001cce:	9782                	jalr	a5
}
    80001cd0:	60a2                	ld	ra,8(sp)
    80001cd2:	6402                	ld	s0,0(sp)
    80001cd4:	0141                	add	sp,sp,16
    80001cd6:	8082                	ret

0000000080001cd8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001cd8:	1101                	add	sp,sp,-32
    80001cda:	ec06                	sd	ra,24(sp)
    80001cdc:	e822                	sd	s0,16(sp)
    80001cde:	e426                	sd	s1,8(sp)
    80001ce0:	1000                	add	s0,sp,32
  acquire(&tickslock);
    80001ce2:	0000f497          	auipc	s1,0xf
    80001ce6:	58e48493          	add	s1,s1,1422 # 80011270 <tickslock>
    80001cea:	8526                	mv	a0,s1
    80001cec:	00005097          	auipc	ra,0x5
    80001cf0:	880080e7          	jalr	-1920(ra) # 8000656c <acquire>
  ticks++;
    80001cf4:	00009517          	auipc	a0,0x9
    80001cf8:	71450513          	add	a0,a0,1812 # 8000b408 <ticks>
    80001cfc:	411c                	lw	a5,0(a0)
    80001cfe:	2785                	addw	a5,a5,1
    80001d00:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d02:	00000097          	auipc	ra,0x0
    80001d06:	968080e7          	jalr	-1688(ra) # 8000166a <wakeup>
  release(&tickslock);
    80001d0a:	8526                	mv	a0,s1
    80001d0c:	00005097          	auipc	ra,0x5
    80001d10:	914080e7          	jalr	-1772(ra) # 80006620 <release>
}
    80001d14:	60e2                	ld	ra,24(sp)
    80001d16:	6442                	ld	s0,16(sp)
    80001d18:	64a2                	ld	s1,8(sp)
    80001d1a:	6105                	add	sp,sp,32
    80001d1c:	8082                	ret

0000000080001d1e <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d1e:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d22:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001d24:	0a07d163          	bgez	a5,80001dc6 <devintr+0xa8>
{
    80001d28:	1101                	add	sp,sp,-32
    80001d2a:	ec06                	sd	ra,24(sp)
    80001d2c:	e822                	sd	s0,16(sp)
    80001d2e:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    80001d30:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001d34:	46a5                	li	a3,9
    80001d36:	00d70c63          	beq	a4,a3,80001d4e <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001d3a:	577d                	li	a4,-1
    80001d3c:	177e                	sll	a4,a4,0x3f
    80001d3e:	0705                	add	a4,a4,1
    return 0;
    80001d40:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d42:	06e78163          	beq	a5,a4,80001da4 <devintr+0x86>
  }
}
    80001d46:	60e2                	ld	ra,24(sp)
    80001d48:	6442                	ld	s0,16(sp)
    80001d4a:	6105                	add	sp,sp,32
    80001d4c:	8082                	ret
    80001d4e:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001d50:	00003097          	auipc	ra,0x3
    80001d54:	77c080e7          	jalr	1916(ra) # 800054cc <plic_claim>
    80001d58:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d5a:	47a9                	li	a5,10
    80001d5c:	00f50963          	beq	a0,a5,80001d6e <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001d60:	4785                	li	a5,1
    80001d62:	00f50b63          	beq	a0,a5,80001d78 <devintr+0x5a>
    return 1;
    80001d66:	4505                	li	a0,1
    } else if(irq){
    80001d68:	ec89                	bnez	s1,80001d82 <devintr+0x64>
    80001d6a:	64a2                	ld	s1,8(sp)
    80001d6c:	bfe9                	j	80001d46 <devintr+0x28>
      uartintr();
    80001d6e:	00004097          	auipc	ra,0x4
    80001d72:	71e080e7          	jalr	1822(ra) # 8000648c <uartintr>
    if(irq)
    80001d76:	a839                	j	80001d94 <devintr+0x76>
      virtio_disk_intr();
    80001d78:	00004097          	auipc	ra,0x4
    80001d7c:	c7e080e7          	jalr	-898(ra) # 800059f6 <virtio_disk_intr>
    if(irq)
    80001d80:	a811                	j	80001d94 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d82:	85a6                	mv	a1,s1
    80001d84:	00006517          	auipc	a0,0x6
    80001d88:	50c50513          	add	a0,a0,1292 # 80008290 <etext+0x290>
    80001d8c:	00004097          	auipc	ra,0x4
    80001d90:	2b0080e7          	jalr	688(ra) # 8000603c <printf>
      plic_complete(irq);
    80001d94:	8526                	mv	a0,s1
    80001d96:	00003097          	auipc	ra,0x3
    80001d9a:	75a080e7          	jalr	1882(ra) # 800054f0 <plic_complete>
    return 1;
    80001d9e:	4505                	li	a0,1
    80001da0:	64a2                	ld	s1,8(sp)
    80001da2:	b755                	j	80001d46 <devintr+0x28>
    if(cpuid() == 0){
    80001da4:	fffff097          	auipc	ra,0xfffff
    80001da8:	180080e7          	jalr	384(ra) # 80000f24 <cpuid>
    80001dac:	c901                	beqz	a0,80001dbc <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001dae:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001db2:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001db4:	14479073          	csrw	sip,a5
    return 2;
    80001db8:	4509                	li	a0,2
    80001dba:	b771                	j	80001d46 <devintr+0x28>
      clockintr();
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	f1c080e7          	jalr	-228(ra) # 80001cd8 <clockintr>
    80001dc4:	b7ed                	j	80001dae <devintr+0x90>
}
    80001dc6:	8082                	ret

0000000080001dc8 <usertrap>:
{
    80001dc8:	1101                	add	sp,sp,-32
    80001dca:	ec06                	sd	ra,24(sp)
    80001dcc:	e822                	sd	s0,16(sp)
    80001dce:	e426                	sd	s1,8(sp)
    80001dd0:	e04a                	sd	s2,0(sp)
    80001dd2:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dd4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001dd8:	1007f793          	and	a5,a5,256
    80001ddc:	e3b1                	bnez	a5,80001e20 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001dde:	00003797          	auipc	a5,0x3
    80001de2:	5e278793          	add	a5,a5,1506 # 800053c0 <kernelvec>
    80001de6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001dea:	fffff097          	auipc	ra,0xfffff
    80001dee:	166080e7          	jalr	358(ra) # 80000f50 <myproc>
    80001df2:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001df4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001df6:	14102773          	csrr	a4,sepc
    80001dfa:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dfc:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e00:	47a1                	li	a5,8
    80001e02:	02f70763          	beq	a4,a5,80001e30 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001e06:	00000097          	auipc	ra,0x0
    80001e0a:	f18080e7          	jalr	-232(ra) # 80001d1e <devintr>
    80001e0e:	892a                	mv	s2,a0
    80001e10:	c151                	beqz	a0,80001e94 <usertrap+0xcc>
  if(killed(p))
    80001e12:	8526                	mv	a0,s1
    80001e14:	00000097          	auipc	ra,0x0
    80001e18:	a9a080e7          	jalr	-1382(ra) # 800018ae <killed>
    80001e1c:	c929                	beqz	a0,80001e6e <usertrap+0xa6>
    80001e1e:	a099                	j	80001e64 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001e20:	00006517          	auipc	a0,0x6
    80001e24:	49050513          	add	a0,a0,1168 # 800082b0 <etext+0x2b0>
    80001e28:	00004097          	auipc	ra,0x4
    80001e2c:	1ca080e7          	jalr	458(ra) # 80005ff2 <panic>
    if(killed(p))
    80001e30:	00000097          	auipc	ra,0x0
    80001e34:	a7e080e7          	jalr	-1410(ra) # 800018ae <killed>
    80001e38:	e921                	bnez	a0,80001e88 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001e3a:	6cb8                	ld	a4,88(s1)
    80001e3c:	6f1c                	ld	a5,24(a4)
    80001e3e:	0791                	add	a5,a5,4
    80001e40:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e42:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e46:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e4a:	10079073          	csrw	sstatus,a5
    syscall();
    80001e4e:	00000097          	auipc	ra,0x0
    80001e52:	3e6080e7          	jalr	998(ra) # 80002234 <syscall>
  if(killed(p))
    80001e56:	8526                	mv	a0,s1
    80001e58:	00000097          	auipc	ra,0x0
    80001e5c:	a56080e7          	jalr	-1450(ra) # 800018ae <killed>
    80001e60:	c911                	beqz	a0,80001e74 <usertrap+0xac>
    80001e62:	4901                	li	s2,0
    exit(-1);
    80001e64:	557d                	li	a0,-1
    80001e66:	00000097          	auipc	ra,0x0
    80001e6a:	8d4080e7          	jalr	-1836(ra) # 8000173a <exit>
  if(which_dev == 2)
    80001e6e:	4789                	li	a5,2
    80001e70:	04f90f63          	beq	s2,a5,80001ece <usertrap+0x106>
  usertrapret();
    80001e74:	00000097          	auipc	ra,0x0
    80001e78:	dce080e7          	jalr	-562(ra) # 80001c42 <usertrapret>
}
    80001e7c:	60e2                	ld	ra,24(sp)
    80001e7e:	6442                	ld	s0,16(sp)
    80001e80:	64a2                	ld	s1,8(sp)
    80001e82:	6902                	ld	s2,0(sp)
    80001e84:	6105                	add	sp,sp,32
    80001e86:	8082                	ret
      exit(-1);
    80001e88:	557d                	li	a0,-1
    80001e8a:	00000097          	auipc	ra,0x0
    80001e8e:	8b0080e7          	jalr	-1872(ra) # 8000173a <exit>
    80001e92:	b765                	j	80001e3a <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e94:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e98:	5890                	lw	a2,48(s1)
    80001e9a:	00006517          	auipc	a0,0x6
    80001e9e:	43650513          	add	a0,a0,1078 # 800082d0 <etext+0x2d0>
    80001ea2:	00004097          	auipc	ra,0x4
    80001ea6:	19a080e7          	jalr	410(ra) # 8000603c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001eaa:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001eae:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001eb2:	00006517          	auipc	a0,0x6
    80001eb6:	44e50513          	add	a0,a0,1102 # 80008300 <etext+0x300>
    80001eba:	00004097          	auipc	ra,0x4
    80001ebe:	182080e7          	jalr	386(ra) # 8000603c <printf>
    setkilled(p);
    80001ec2:	8526                	mv	a0,s1
    80001ec4:	00000097          	auipc	ra,0x0
    80001ec8:	9be080e7          	jalr	-1602(ra) # 80001882 <setkilled>
    80001ecc:	b769                	j	80001e56 <usertrap+0x8e>
    yield();
    80001ece:	fffff097          	auipc	ra,0xfffff
    80001ed2:	6fc080e7          	jalr	1788(ra) # 800015ca <yield>
    80001ed6:	bf79                	j	80001e74 <usertrap+0xac>

0000000080001ed8 <kerneltrap>:
{
    80001ed8:	7179                	add	sp,sp,-48
    80001eda:	f406                	sd	ra,40(sp)
    80001edc:	f022                	sd	s0,32(sp)
    80001ede:	ec26                	sd	s1,24(sp)
    80001ee0:	e84a                	sd	s2,16(sp)
    80001ee2:	e44e                	sd	s3,8(sp)
    80001ee4:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ee6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eea:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001eee:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001ef2:	1004f793          	and	a5,s1,256
    80001ef6:	cb85                	beqz	a5,80001f26 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ef8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001efc:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80001efe:	ef85                	bnez	a5,80001f36 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f00:	00000097          	auipc	ra,0x0
    80001f04:	e1e080e7          	jalr	-482(ra) # 80001d1e <devintr>
    80001f08:	cd1d                	beqz	a0,80001f46 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f0a:	4789                	li	a5,2
    80001f0c:	06f50a63          	beq	a0,a5,80001f80 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f10:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f14:	10049073          	csrw	sstatus,s1
}
    80001f18:	70a2                	ld	ra,40(sp)
    80001f1a:	7402                	ld	s0,32(sp)
    80001f1c:	64e2                	ld	s1,24(sp)
    80001f1e:	6942                	ld	s2,16(sp)
    80001f20:	69a2                	ld	s3,8(sp)
    80001f22:	6145                	add	sp,sp,48
    80001f24:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f26:	00006517          	auipc	a0,0x6
    80001f2a:	3fa50513          	add	a0,a0,1018 # 80008320 <etext+0x320>
    80001f2e:	00004097          	auipc	ra,0x4
    80001f32:	0c4080e7          	jalr	196(ra) # 80005ff2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f36:	00006517          	auipc	a0,0x6
    80001f3a:	41250513          	add	a0,a0,1042 # 80008348 <etext+0x348>
    80001f3e:	00004097          	auipc	ra,0x4
    80001f42:	0b4080e7          	jalr	180(ra) # 80005ff2 <panic>
    printf("scause %p\n", scause);
    80001f46:	85ce                	mv	a1,s3
    80001f48:	00006517          	auipc	a0,0x6
    80001f4c:	42050513          	add	a0,a0,1056 # 80008368 <etext+0x368>
    80001f50:	00004097          	auipc	ra,0x4
    80001f54:	0ec080e7          	jalr	236(ra) # 8000603c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f58:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f5c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f60:	00006517          	auipc	a0,0x6
    80001f64:	41850513          	add	a0,a0,1048 # 80008378 <etext+0x378>
    80001f68:	00004097          	auipc	ra,0x4
    80001f6c:	0d4080e7          	jalr	212(ra) # 8000603c <printf>
    panic("kerneltrap");
    80001f70:	00006517          	auipc	a0,0x6
    80001f74:	42050513          	add	a0,a0,1056 # 80008390 <etext+0x390>
    80001f78:	00004097          	auipc	ra,0x4
    80001f7c:	07a080e7          	jalr	122(ra) # 80005ff2 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f80:	fffff097          	auipc	ra,0xfffff
    80001f84:	fd0080e7          	jalr	-48(ra) # 80000f50 <myproc>
    80001f88:	d541                	beqz	a0,80001f10 <kerneltrap+0x38>
    80001f8a:	fffff097          	auipc	ra,0xfffff
    80001f8e:	fc6080e7          	jalr	-58(ra) # 80000f50 <myproc>
    80001f92:	4d18                	lw	a4,24(a0)
    80001f94:	4791                	li	a5,4
    80001f96:	f6f71de3          	bne	a4,a5,80001f10 <kerneltrap+0x38>
    yield();
    80001f9a:	fffff097          	auipc	ra,0xfffff
    80001f9e:	630080e7          	jalr	1584(ra) # 800015ca <yield>
    80001fa2:	b7bd                	j	80001f10 <kerneltrap+0x38>

0000000080001fa4 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fa4:	1101                	add	sp,sp,-32
    80001fa6:	ec06                	sd	ra,24(sp)
    80001fa8:	e822                	sd	s0,16(sp)
    80001faa:	e426                	sd	s1,8(sp)
    80001fac:	1000                	add	s0,sp,32
    80001fae:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fb0:	fffff097          	auipc	ra,0xfffff
    80001fb4:	fa0080e7          	jalr	-96(ra) # 80000f50 <myproc>
  switch (n) {
    80001fb8:	4795                	li	a5,5
    80001fba:	0497e163          	bltu	a5,s1,80001ffc <argraw+0x58>
    80001fbe:	048a                	sll	s1,s1,0x2
    80001fc0:	00007717          	auipc	a4,0x7
    80001fc4:	8a870713          	add	a4,a4,-1880 # 80008868 <states.0+0x30>
    80001fc8:	94ba                	add	s1,s1,a4
    80001fca:	409c                	lw	a5,0(s1)
    80001fcc:	97ba                	add	a5,a5,a4
    80001fce:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fd0:	6d3c                	ld	a5,88(a0)
    80001fd2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fd4:	60e2                	ld	ra,24(sp)
    80001fd6:	6442                	ld	s0,16(sp)
    80001fd8:	64a2                	ld	s1,8(sp)
    80001fda:	6105                	add	sp,sp,32
    80001fdc:	8082                	ret
    return p->trapframe->a1;
    80001fde:	6d3c                	ld	a5,88(a0)
    80001fe0:	7fa8                	ld	a0,120(a5)
    80001fe2:	bfcd                	j	80001fd4 <argraw+0x30>
    return p->trapframe->a2;
    80001fe4:	6d3c                	ld	a5,88(a0)
    80001fe6:	63c8                	ld	a0,128(a5)
    80001fe8:	b7f5                	j	80001fd4 <argraw+0x30>
    return p->trapframe->a3;
    80001fea:	6d3c                	ld	a5,88(a0)
    80001fec:	67c8                	ld	a0,136(a5)
    80001fee:	b7dd                	j	80001fd4 <argraw+0x30>
    return p->trapframe->a4;
    80001ff0:	6d3c                	ld	a5,88(a0)
    80001ff2:	6bc8                	ld	a0,144(a5)
    80001ff4:	b7c5                	j	80001fd4 <argraw+0x30>
    return p->trapframe->a5;
    80001ff6:	6d3c                	ld	a5,88(a0)
    80001ff8:	6fc8                	ld	a0,152(a5)
    80001ffa:	bfe9                	j	80001fd4 <argraw+0x30>
  panic("argraw");
    80001ffc:	00006517          	auipc	a0,0x6
    80002000:	3a450513          	add	a0,a0,932 # 800083a0 <etext+0x3a0>
    80002004:	00004097          	auipc	ra,0x4
    80002008:	fee080e7          	jalr	-18(ra) # 80005ff2 <panic>

000000008000200c <fetchaddr>:
{
    8000200c:	1101                	add	sp,sp,-32
    8000200e:	ec06                	sd	ra,24(sp)
    80002010:	e822                	sd	s0,16(sp)
    80002012:	e426                	sd	s1,8(sp)
    80002014:	e04a                	sd	s2,0(sp)
    80002016:	1000                	add	s0,sp,32
    80002018:	84aa                	mv	s1,a0
    8000201a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000201c:	fffff097          	auipc	ra,0xfffff
    80002020:	f34080e7          	jalr	-204(ra) # 80000f50 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002024:	653c                	ld	a5,72(a0)
    80002026:	02f4f863          	bgeu	s1,a5,80002056 <fetchaddr+0x4a>
    8000202a:	00848713          	add	a4,s1,8
    8000202e:	02e7e663          	bltu	a5,a4,8000205a <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002032:	46a1                	li	a3,8
    80002034:	8626                	mv	a2,s1
    80002036:	85ca                	mv	a1,s2
    80002038:	6928                	ld	a0,80(a0)
    8000203a:	fffff097          	auipc	ra,0xfffff
    8000203e:	c3a080e7          	jalr	-966(ra) # 80000c74 <copyin>
    80002042:	00a03533          	snez	a0,a0
    80002046:	40a00533          	neg	a0,a0
}
    8000204a:	60e2                	ld	ra,24(sp)
    8000204c:	6442                	ld	s0,16(sp)
    8000204e:	64a2                	ld	s1,8(sp)
    80002050:	6902                	ld	s2,0(sp)
    80002052:	6105                	add	sp,sp,32
    80002054:	8082                	ret
    return -1;
    80002056:	557d                	li	a0,-1
    80002058:	bfcd                	j	8000204a <fetchaddr+0x3e>
    8000205a:	557d                	li	a0,-1
    8000205c:	b7fd                	j	8000204a <fetchaddr+0x3e>

000000008000205e <fetchstr>:
{
    8000205e:	7179                	add	sp,sp,-48
    80002060:	f406                	sd	ra,40(sp)
    80002062:	f022                	sd	s0,32(sp)
    80002064:	ec26                	sd	s1,24(sp)
    80002066:	e84a                	sd	s2,16(sp)
    80002068:	e44e                	sd	s3,8(sp)
    8000206a:	1800                	add	s0,sp,48
    8000206c:	892a                	mv	s2,a0
    8000206e:	84ae                	mv	s1,a1
    80002070:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002072:	fffff097          	auipc	ra,0xfffff
    80002076:	ede080e7          	jalr	-290(ra) # 80000f50 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000207a:	86ce                	mv	a3,s3
    8000207c:	864a                	mv	a2,s2
    8000207e:	85a6                	mv	a1,s1
    80002080:	6928                	ld	a0,80(a0)
    80002082:	fffff097          	auipc	ra,0xfffff
    80002086:	c80080e7          	jalr	-896(ra) # 80000d02 <copyinstr>
    8000208a:	00054e63          	bltz	a0,800020a6 <fetchstr+0x48>
  return strlen(buf);
    8000208e:	8526                	mv	a0,s1
    80002090:	ffffe097          	auipc	ra,0xffffe
    80002094:	2a8080e7          	jalr	680(ra) # 80000338 <strlen>
}
    80002098:	70a2                	ld	ra,40(sp)
    8000209a:	7402                	ld	s0,32(sp)
    8000209c:	64e2                	ld	s1,24(sp)
    8000209e:	6942                	ld	s2,16(sp)
    800020a0:	69a2                	ld	s3,8(sp)
    800020a2:	6145                	add	sp,sp,48
    800020a4:	8082                	ret
    return -1;
    800020a6:	557d                	li	a0,-1
    800020a8:	bfc5                	j	80002098 <fetchstr+0x3a>

00000000800020aa <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800020aa:	1101                	add	sp,sp,-32
    800020ac:	ec06                	sd	ra,24(sp)
    800020ae:	e822                	sd	s0,16(sp)
    800020b0:	e426                	sd	s1,8(sp)
    800020b2:	1000                	add	s0,sp,32
    800020b4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020b6:	00000097          	auipc	ra,0x0
    800020ba:	eee080e7          	jalr	-274(ra) # 80001fa4 <argraw>
    800020be:	c088                	sw	a0,0(s1)
}
    800020c0:	60e2                	ld	ra,24(sp)
    800020c2:	6442                	ld	s0,16(sp)
    800020c4:	64a2                	ld	s1,8(sp)
    800020c6:	6105                	add	sp,sp,32
    800020c8:	8082                	ret

00000000800020ca <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800020ca:	1101                	add	sp,sp,-32
    800020cc:	ec06                	sd	ra,24(sp)
    800020ce:	e822                	sd	s0,16(sp)
    800020d0:	e426                	sd	s1,8(sp)
    800020d2:	1000                	add	s0,sp,32
    800020d4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020d6:	00000097          	auipc	ra,0x0
    800020da:	ece080e7          	jalr	-306(ra) # 80001fa4 <argraw>
    800020de:	e088                	sd	a0,0(s1)
}
    800020e0:	60e2                	ld	ra,24(sp)
    800020e2:	6442                	ld	s0,16(sp)
    800020e4:	64a2                	ld	s1,8(sp)
    800020e6:	6105                	add	sp,sp,32
    800020e8:	8082                	ret

00000000800020ea <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020ea:	7179                	add	sp,sp,-48
    800020ec:	f406                	sd	ra,40(sp)
    800020ee:	f022                	sd	s0,32(sp)
    800020f0:	ec26                	sd	s1,24(sp)
    800020f2:	e84a                	sd	s2,16(sp)
    800020f4:	1800                	add	s0,sp,48
    800020f6:	84ae                	mv	s1,a1
    800020f8:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800020fa:	fd840593          	add	a1,s0,-40
    800020fe:	00000097          	auipc	ra,0x0
    80002102:	fcc080e7          	jalr	-52(ra) # 800020ca <argaddr>
  return fetchstr(addr, buf, max);
    80002106:	864a                	mv	a2,s2
    80002108:	85a6                	mv	a1,s1
    8000210a:	fd843503          	ld	a0,-40(s0)
    8000210e:	00000097          	auipc	ra,0x0
    80002112:	f50080e7          	jalr	-176(ra) # 8000205e <fetchstr>
}
    80002116:	70a2                	ld	ra,40(sp)
    80002118:	7402                	ld	s0,32(sp)
    8000211a:	64e2                	ld	s1,24(sp)
    8000211c:	6942                	ld	s2,16(sp)
    8000211e:	6145                	add	sp,sp,48
    80002120:	8082                	ret

0000000080002122 <SysNumToName>:
[SYS_close]   sys_close,
[SYS_trace]   sys_trace,
[SYS_sysinfo] sys_sysinfo,
};

const char* SysNumToName(int value) {
    80002122:	1141                	add	sp,sp,-16
    80002124:	e422                	sd	s0,8(sp)
    80002126:	0800                	add	s0,sp,16
    switch (value) {
    80002128:	47dd                	li	a5,23
    8000212a:	0ea7eb63          	bltu	a5,a0,80002220 <SysNumToName+0xfe>
    8000212e:	050a                	sll	a0,a0,0x2
    80002130:	00006717          	auipc	a4,0x6
    80002134:	75070713          	add	a4,a4,1872 # 80008880 <states.0+0x48>
    80002138:	953a                	add	a0,a0,a4
    8000213a:	411c                	lw	a5,0(a0)
    8000213c:	97ba                	add	a5,a5,a4
    8000213e:	8782                	jr	a5
        case SYS_fork:
            return "fork";
    80002140:	00006517          	auipc	a0,0x6
    80002144:	26850513          	add	a0,a0,616 # 800083a8 <etext+0x3a8>
        case SYS_sysinfo:
            return "sysinfo";
        default:
            return "Unknown";
    }
}
    80002148:	6422                	ld	s0,8(sp)
    8000214a:	0141                	add	sp,sp,16
    8000214c:	8082                	ret
            return "wait";
    8000214e:	00006517          	auipc	a0,0x6
    80002152:	26a50513          	add	a0,a0,618 # 800083b8 <etext+0x3b8>
    80002156:	bfcd                	j	80002148 <SysNumToName+0x26>
            return "pipe";
    80002158:	00006517          	auipc	a0,0x6
    8000215c:	26850513          	add	a0,a0,616 # 800083c0 <etext+0x3c0>
    80002160:	b7e5                	j	80002148 <SysNumToName+0x26>
            return "read";
    80002162:	00006517          	auipc	a0,0x6
    80002166:	45650513          	add	a0,a0,1110 # 800085b8 <etext+0x5b8>
    8000216a:	bff9                	j	80002148 <SysNumToName+0x26>
            return "kill";
    8000216c:	00006517          	auipc	a0,0x6
    80002170:	25c50513          	add	a0,a0,604 # 800083c8 <etext+0x3c8>
    80002174:	bfd1                	j	80002148 <SysNumToName+0x26>
            return "exec";
    80002176:	00006517          	auipc	a0,0x6
    8000217a:	25a50513          	add	a0,a0,602 # 800083d0 <etext+0x3d0>
    8000217e:	b7e9                	j	80002148 <SysNumToName+0x26>
            return "fstat";
    80002180:	00006517          	auipc	a0,0x6
    80002184:	25850513          	add	a0,a0,600 # 800083d8 <etext+0x3d8>
    80002188:	b7c1                	j	80002148 <SysNumToName+0x26>
            return "chdir";
    8000218a:	00006517          	auipc	a0,0x6
    8000218e:	25650513          	add	a0,a0,598 # 800083e0 <etext+0x3e0>
    80002192:	bf5d                	j	80002148 <SysNumToName+0x26>
            return "dup";
    80002194:	00006517          	auipc	a0,0x6
    80002198:	25450513          	add	a0,a0,596 # 800083e8 <etext+0x3e8>
    8000219c:	b775                	j	80002148 <SysNumToName+0x26>
            return "getpid";
    8000219e:	00006517          	auipc	a0,0x6
    800021a2:	25250513          	add	a0,a0,594 # 800083f0 <etext+0x3f0>
    800021a6:	b74d                	j	80002148 <SysNumToName+0x26>
            return "sbrk";
    800021a8:	00006517          	auipc	a0,0x6
    800021ac:	25050513          	add	a0,a0,592 # 800083f8 <etext+0x3f8>
    800021b0:	bf61                	j	80002148 <SysNumToName+0x26>
            return "sleep";
    800021b2:	00006517          	auipc	a0,0x6
    800021b6:	24e50513          	add	a0,a0,590 # 80008400 <etext+0x400>
    800021ba:	b779                	j	80002148 <SysNumToName+0x26>
            return "uptime";
    800021bc:	00006517          	auipc	a0,0x6
    800021c0:	24c50513          	add	a0,a0,588 # 80008408 <etext+0x408>
    800021c4:	b751                	j	80002148 <SysNumToName+0x26>
            return "open";
    800021c6:	00006517          	auipc	a0,0x6
    800021ca:	24a50513          	add	a0,a0,586 # 80008410 <etext+0x410>
    800021ce:	bfad                	j	80002148 <SysNumToName+0x26>
            return "write";
    800021d0:	00006517          	auipc	a0,0x6
    800021d4:	24850513          	add	a0,a0,584 # 80008418 <etext+0x418>
    800021d8:	bf85                	j	80002148 <SysNumToName+0x26>
            return "mknod";
    800021da:	00006517          	auipc	a0,0x6
    800021de:	24650513          	add	a0,a0,582 # 80008420 <etext+0x420>
    800021e2:	b79d                	j	80002148 <SysNumToName+0x26>
            return "unlink";
    800021e4:	00006517          	auipc	a0,0x6
    800021e8:	24450513          	add	a0,a0,580 # 80008428 <etext+0x428>
    800021ec:	bfb1                	j	80002148 <SysNumToName+0x26>
            return "link";
    800021ee:	00006517          	auipc	a0,0x6
    800021f2:	24250513          	add	a0,a0,578 # 80008430 <etext+0x430>
    800021f6:	bf89                	j	80002148 <SysNumToName+0x26>
            return "mkdir";
    800021f8:	00006517          	auipc	a0,0x6
    800021fc:	24050513          	add	a0,a0,576 # 80008438 <etext+0x438>
    80002200:	b7a1                	j	80002148 <SysNumToName+0x26>
            return "close";
    80002202:	00006517          	auipc	a0,0x6
    80002206:	23e50513          	add	a0,a0,574 # 80008440 <etext+0x440>
    8000220a:	bf3d                	j	80002148 <SysNumToName+0x26>
            return "trace";
    8000220c:	00006517          	auipc	a0,0x6
    80002210:	23c50513          	add	a0,a0,572 # 80008448 <etext+0x448>
    80002214:	bf15                	j	80002148 <SysNumToName+0x26>
            return "sysinfo";
    80002216:	00006517          	auipc	a0,0x6
    8000221a:	23a50513          	add	a0,a0,570 # 80008450 <etext+0x450>
    8000221e:	b72d                	j	80002148 <SysNumToName+0x26>
            return "Unknown";
    80002220:	00006517          	auipc	a0,0x6
    80002224:	23850513          	add	a0,a0,568 # 80008458 <etext+0x458>
    80002228:	b705                	j	80002148 <SysNumToName+0x26>
    switch (value) {
    8000222a:	00006517          	auipc	a0,0x6
    8000222e:	18650513          	add	a0,a0,390 # 800083b0 <etext+0x3b0>
    80002232:	bf19                	j	80002148 <SysNumToName+0x26>

0000000080002234 <syscall>:

void
syscall(void)
{
    80002234:	7179                	add	sp,sp,-48
    80002236:	f406                	sd	ra,40(sp)
    80002238:	f022                	sd	s0,32(sp)
    8000223a:	ec26                	sd	s1,24(sp)
    8000223c:	e84a                	sd	s2,16(sp)
    8000223e:	e44e                	sd	s3,8(sp)
    80002240:	1800                	add	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002242:	fffff097          	auipc	ra,0xfffff
    80002246:	d0e080e7          	jalr	-754(ra) # 80000f50 <myproc>
    8000224a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000224c:	05853983          	ld	s3,88(a0)
    80002250:	0a89b783          	ld	a5,168(s3)
    80002254:	0007891b          	sext.w	s2,a5
  // num = * (int * ) 0;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002258:	37fd                	addw	a5,a5,-1
    8000225a:	4759                	li	a4,22
    8000225c:	04f76d63          	bltu	a4,a5,800022b6 <syscall+0x82>
    80002260:	00391713          	sll	a4,s2,0x3
    80002264:	00006797          	auipc	a5,0x6
    80002268:	67c78793          	add	a5,a5,1660 # 800088e0 <syscalls>
    8000226c:	97ba                	add	a5,a5,a4
    8000226e:	639c                	ld	a5,0(a5)
    80002270:	c3b9                	beqz	a5,800022b6 <syscall+0x82>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002272:	9782                	jalr	a5
    80002274:	06a9b823          	sd	a0,112(s3)

    int t = (p->mask >> num) % 2;
    80002278:	58d8                	lw	a4,52(s1)
    8000227a:	412757bb          	sraw	a5,a4,s2
    8000227e:	01f7571b          	srlw	a4,a4,0x1f
    80002282:	9fb9                	addw	a5,a5,a4
    80002284:	8b85                	and	a5,a5,1
    if(t == 1) {
    80002286:	9f99                	subw	a5,a5,a4
    80002288:	4705                	li	a4,1
    8000228a:	04e79563          	bne	a5,a4,800022d4 <syscall+0xa0>
      printf("%d: syscall %s -> %d\n", p->pid, SysNumToName(num), p->trapframe->a0);
    8000228e:	0304a983          	lw	s3,48(s1)
    80002292:	854a                	mv	a0,s2
    80002294:	00000097          	auipc	ra,0x0
    80002298:	e8e080e7          	jalr	-370(ra) # 80002122 <SysNumToName>
    8000229c:	862a                	mv	a2,a0
    8000229e:	6cbc                	ld	a5,88(s1)
    800022a0:	7bb4                	ld	a3,112(a5)
    800022a2:	85ce                	mv	a1,s3
    800022a4:	00006517          	auipc	a0,0x6
    800022a8:	1bc50513          	add	a0,a0,444 # 80008460 <etext+0x460>
    800022ac:	00004097          	auipc	ra,0x4
    800022b0:	d90080e7          	jalr	-624(ra) # 8000603c <printf>
    800022b4:	a005                	j	800022d4 <syscall+0xa0>
    }

  } else {
    printf("%d %s: unknown sys call %d\n",
    800022b6:	86ca                	mv	a3,s2
    800022b8:	15848613          	add	a2,s1,344
    800022bc:	588c                	lw	a1,48(s1)
    800022be:	00006517          	auipc	a0,0x6
    800022c2:	1ba50513          	add	a0,a0,442 # 80008478 <etext+0x478>
    800022c6:	00004097          	auipc	ra,0x4
    800022ca:	d76080e7          	jalr	-650(ra) # 8000603c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800022ce:	6cbc                	ld	a5,88(s1)
    800022d0:	577d                	li	a4,-1
    800022d2:	fbb8                	sd	a4,112(a5)
  }
}
    800022d4:	70a2                	ld	ra,40(sp)
    800022d6:	7402                	ld	s0,32(sp)
    800022d8:	64e2                	ld	s1,24(sp)
    800022da:	6942                	ld	s2,16(sp)
    800022dc:	69a2                	ld	s3,8(sp)
    800022de:	6145                	add	sp,sp,48
    800022e0:	8082                	ret

00000000800022e2 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    800022e2:	1101                	add	sp,sp,-32
    800022e4:	ec06                	sd	ra,24(sp)
    800022e6:	e822                	sd	s0,16(sp)
    800022e8:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    800022ea:	fec40593          	add	a1,s0,-20
    800022ee:	4501                	li	a0,0
    800022f0:	00000097          	auipc	ra,0x0
    800022f4:	dba080e7          	jalr	-582(ra) # 800020aa <argint>
  exit(n);
    800022f8:	fec42503          	lw	a0,-20(s0)
    800022fc:	fffff097          	auipc	ra,0xfffff
    80002300:	43e080e7          	jalr	1086(ra) # 8000173a <exit>
  return 0;  // not reached
}
    80002304:	4501                	li	a0,0
    80002306:	60e2                	ld	ra,24(sp)
    80002308:	6442                	ld	s0,16(sp)
    8000230a:	6105                	add	sp,sp,32
    8000230c:	8082                	ret

000000008000230e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000230e:	1141                	add	sp,sp,-16
    80002310:	e406                	sd	ra,8(sp)
    80002312:	e022                	sd	s0,0(sp)
    80002314:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002316:	fffff097          	auipc	ra,0xfffff
    8000231a:	c3a080e7          	jalr	-966(ra) # 80000f50 <myproc>
}
    8000231e:	5908                	lw	a0,48(a0)
    80002320:	60a2                	ld	ra,8(sp)
    80002322:	6402                	ld	s0,0(sp)
    80002324:	0141                	add	sp,sp,16
    80002326:	8082                	ret

0000000080002328 <sys_fork>:

uint64
sys_fork(void)
{
    80002328:	1141                	add	sp,sp,-16
    8000232a:	e406                	sd	ra,8(sp)
    8000232c:	e022                	sd	s0,0(sp)
    8000232e:	0800                	add	s0,sp,16
  return fork();
    80002330:	fffff097          	auipc	ra,0xfffff
    80002334:	fda080e7          	jalr	-38(ra) # 8000130a <fork>
}
    80002338:	60a2                	ld	ra,8(sp)
    8000233a:	6402                	ld	s0,0(sp)
    8000233c:	0141                	add	sp,sp,16
    8000233e:	8082                	ret

0000000080002340 <sys_wait>:

uint64
sys_wait(void)
{
    80002340:	1101                	add	sp,sp,-32
    80002342:	ec06                	sd	ra,24(sp)
    80002344:	e822                	sd	s0,16(sp)
    80002346:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002348:	fe840593          	add	a1,s0,-24
    8000234c:	4501                	li	a0,0
    8000234e:	00000097          	auipc	ra,0x0
    80002352:	d7c080e7          	jalr	-644(ra) # 800020ca <argaddr>
  return wait(p);
    80002356:	fe843503          	ld	a0,-24(s0)
    8000235a:	fffff097          	auipc	ra,0xfffff
    8000235e:	586080e7          	jalr	1414(ra) # 800018e0 <wait>
}
    80002362:	60e2                	ld	ra,24(sp)
    80002364:	6442                	ld	s0,16(sp)
    80002366:	6105                	add	sp,sp,32
    80002368:	8082                	ret

000000008000236a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000236a:	7179                	add	sp,sp,-48
    8000236c:	f406                	sd	ra,40(sp)
    8000236e:	f022                	sd	s0,32(sp)
    80002370:	ec26                	sd	s1,24(sp)
    80002372:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002374:	fdc40593          	add	a1,s0,-36
    80002378:	4501                	li	a0,0
    8000237a:	00000097          	auipc	ra,0x0
    8000237e:	d30080e7          	jalr	-720(ra) # 800020aa <argint>
  addr = myproc()->sz;
    80002382:	fffff097          	auipc	ra,0xfffff
    80002386:	bce080e7          	jalr	-1074(ra) # 80000f50 <myproc>
    8000238a:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000238c:	fdc42503          	lw	a0,-36(s0)
    80002390:	fffff097          	auipc	ra,0xfffff
    80002394:	f1e080e7          	jalr	-226(ra) # 800012ae <growproc>
    80002398:	00054863          	bltz	a0,800023a8 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    8000239c:	8526                	mv	a0,s1
    8000239e:	70a2                	ld	ra,40(sp)
    800023a0:	7402                	ld	s0,32(sp)
    800023a2:	64e2                	ld	s1,24(sp)
    800023a4:	6145                	add	sp,sp,48
    800023a6:	8082                	ret
    return -1;
    800023a8:	54fd                	li	s1,-1
    800023aa:	bfcd                	j	8000239c <sys_sbrk+0x32>

00000000800023ac <sys_sleep>:

uint64
sys_sleep(void)
{
    800023ac:	7139                	add	sp,sp,-64
    800023ae:	fc06                	sd	ra,56(sp)
    800023b0:	f822                	sd	s0,48(sp)
    800023b2:	f04a                	sd	s2,32(sp)
    800023b4:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800023b6:	fcc40593          	add	a1,s0,-52
    800023ba:	4501                	li	a0,0
    800023bc:	00000097          	auipc	ra,0x0
    800023c0:	cee080e7          	jalr	-786(ra) # 800020aa <argint>
  if(n < 0)
    800023c4:	fcc42783          	lw	a5,-52(s0)
    800023c8:	0807c163          	bltz	a5,8000244a <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800023cc:	0000f517          	auipc	a0,0xf
    800023d0:	ea450513          	add	a0,a0,-348 # 80011270 <tickslock>
    800023d4:	00004097          	auipc	ra,0x4
    800023d8:	198080e7          	jalr	408(ra) # 8000656c <acquire>
  ticks0 = ticks;
    800023dc:	00009917          	auipc	s2,0x9
    800023e0:	02c92903          	lw	s2,44(s2) # 8000b408 <ticks>
  while(ticks - ticks0 < n){
    800023e4:	fcc42783          	lw	a5,-52(s0)
    800023e8:	c3b9                	beqz	a5,8000242e <sys_sleep+0x82>
    800023ea:	f426                	sd	s1,40(sp)
    800023ec:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800023ee:	0000f997          	auipc	s3,0xf
    800023f2:	e8298993          	add	s3,s3,-382 # 80011270 <tickslock>
    800023f6:	00009497          	auipc	s1,0x9
    800023fa:	01248493          	add	s1,s1,18 # 8000b408 <ticks>
    if(killed(myproc())){
    800023fe:	fffff097          	auipc	ra,0xfffff
    80002402:	b52080e7          	jalr	-1198(ra) # 80000f50 <myproc>
    80002406:	fffff097          	auipc	ra,0xfffff
    8000240a:	4a8080e7          	jalr	1192(ra) # 800018ae <killed>
    8000240e:	e129                	bnez	a0,80002450 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002410:	85ce                	mv	a1,s3
    80002412:	8526                	mv	a0,s1
    80002414:	fffff097          	auipc	ra,0xfffff
    80002418:	1f2080e7          	jalr	498(ra) # 80001606 <sleep>
  while(ticks - ticks0 < n){
    8000241c:	409c                	lw	a5,0(s1)
    8000241e:	412787bb          	subw	a5,a5,s2
    80002422:	fcc42703          	lw	a4,-52(s0)
    80002426:	fce7ece3          	bltu	a5,a4,800023fe <sys_sleep+0x52>
    8000242a:	74a2                	ld	s1,40(sp)
    8000242c:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000242e:	0000f517          	auipc	a0,0xf
    80002432:	e4250513          	add	a0,a0,-446 # 80011270 <tickslock>
    80002436:	00004097          	auipc	ra,0x4
    8000243a:	1ea080e7          	jalr	490(ra) # 80006620 <release>
  return 0;
    8000243e:	4501                	li	a0,0
}
    80002440:	70e2                	ld	ra,56(sp)
    80002442:	7442                	ld	s0,48(sp)
    80002444:	7902                	ld	s2,32(sp)
    80002446:	6121                	add	sp,sp,64
    80002448:	8082                	ret
    n = 0;
    8000244a:	fc042623          	sw	zero,-52(s0)
    8000244e:	bfbd                	j	800023cc <sys_sleep+0x20>
      release(&tickslock);
    80002450:	0000f517          	auipc	a0,0xf
    80002454:	e2050513          	add	a0,a0,-480 # 80011270 <tickslock>
    80002458:	00004097          	auipc	ra,0x4
    8000245c:	1c8080e7          	jalr	456(ra) # 80006620 <release>
      return -1;
    80002460:	557d                	li	a0,-1
    80002462:	74a2                	ld	s1,40(sp)
    80002464:	69e2                	ld	s3,24(sp)
    80002466:	bfe9                	j	80002440 <sys_sleep+0x94>

0000000080002468 <sys_kill>:

uint64
sys_kill(void)
{
    80002468:	1101                	add	sp,sp,-32
    8000246a:	ec06                	sd	ra,24(sp)
    8000246c:	e822                	sd	s0,16(sp)
    8000246e:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    80002470:	fec40593          	add	a1,s0,-20
    80002474:	4501                	li	a0,0
    80002476:	00000097          	auipc	ra,0x0
    8000247a:	c34080e7          	jalr	-972(ra) # 800020aa <argint>
  return kill(pid);
    8000247e:	fec42503          	lw	a0,-20(s0)
    80002482:	fffff097          	auipc	ra,0xfffff
    80002486:	38e080e7          	jalr	910(ra) # 80001810 <kill>
}
    8000248a:	60e2                	ld	ra,24(sp)
    8000248c:	6442                	ld	s0,16(sp)
    8000248e:	6105                	add	sp,sp,32
    80002490:	8082                	ret

0000000080002492 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002492:	1101                	add	sp,sp,-32
    80002494:	ec06                	sd	ra,24(sp)
    80002496:	e822                	sd	s0,16(sp)
    80002498:	e426                	sd	s1,8(sp)
    8000249a:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000249c:	0000f517          	auipc	a0,0xf
    800024a0:	dd450513          	add	a0,a0,-556 # 80011270 <tickslock>
    800024a4:	00004097          	auipc	ra,0x4
    800024a8:	0c8080e7          	jalr	200(ra) # 8000656c <acquire>
  xticks = ticks;
    800024ac:	00009497          	auipc	s1,0x9
    800024b0:	f5c4a483          	lw	s1,-164(s1) # 8000b408 <ticks>
  release(&tickslock);
    800024b4:	0000f517          	auipc	a0,0xf
    800024b8:	dbc50513          	add	a0,a0,-580 # 80011270 <tickslock>
    800024bc:	00004097          	auipc	ra,0x4
    800024c0:	164080e7          	jalr	356(ra) # 80006620 <release>
  return xticks;
}
    800024c4:	02049513          	sll	a0,s1,0x20
    800024c8:	9101                	srl	a0,a0,0x20
    800024ca:	60e2                	ld	ra,24(sp)
    800024cc:	6442                	ld	s0,16(sp)
    800024ce:	64a2                	ld	s1,8(sp)
    800024d0:	6105                	add	sp,sp,32
    800024d2:	8082                	ret

00000000800024d4 <sys_trace>:


uint64
sys_trace(void)
{
    800024d4:	7179                	add	sp,sp,-48
    800024d6:	f406                	sd	ra,40(sp)
    800024d8:	f022                	sd	s0,32(sp)
    800024da:	ec26                	sd	s1,24(sp)
    800024dc:	1800                	add	s0,sp,48
  int num;
  argint(0, &num);
    800024de:	fdc40593          	add	a1,s0,-36
    800024e2:	4501                	li	a0,0
    800024e4:	00000097          	auipc	ra,0x0
    800024e8:	bc6080e7          	jalr	-1082(ra) # 800020aa <argint>

  int t = num;
    800024ec:	fdc42483          	lw	s1,-36(s0)
  struct proc *p = myproc();
    800024f0:	fffff097          	auipc	ra,0xfffff
    800024f4:	a60080e7          	jalr	-1440(ra) # 80000f50 <myproc>
  p->mask = t;
    800024f8:	d944                	sw	s1,52(a0)
  }
  else {
      printf("trace mask set failed!");
      return -1;
  }
}
    800024fa:	4501                	li	a0,0
    800024fc:	70a2                	ld	ra,40(sp)
    800024fe:	7402                	ld	s0,32(sp)
    80002500:	64e2                	ld	s1,24(sp)
    80002502:	6145                	add	sp,sp,48
    80002504:	8082                	ret

0000000080002506 <sys_sysinfo>:

uint64
sys_sysinfo(void){
    80002506:	7139                	add	sp,sp,-64
    80002508:	fc06                	sd	ra,56(sp)
    8000250a:	f822                	sd	s0,48(sp)
    8000250c:	f426                	sd	s1,40(sp)
    8000250e:	0080                	add	s0,sp,64
    struct proc *p = myproc();
    80002510:	fffff097          	auipc	ra,0xfffff
    80002514:	a40080e7          	jalr	-1472(ra) # 80000f50 <myproc>
    80002518:	84aa                	mv	s1,a0
    struct sysinfo info;

    uint64 addr;
    argaddr(0, &addr);
    8000251a:	fc840593          	add	a1,s0,-56
    8000251e:	4501                	li	a0,0
    80002520:	00000097          	auipc	ra,0x0
    80002524:	baa080e7          	jalr	-1110(ra) # 800020ca <argaddr>

    info.freemem = fmem();
    80002528:	ffffe097          	auipc	ra,0xffffe
    8000252c:	c52080e7          	jalr	-942(ra) # 8000017a <fmem>
    80002530:	fca43823          	sd	a0,-48(s0)
    info.nproc = numofproc();
    80002534:	fffff097          	auipc	ra,0xfffff
    80002538:	636080e7          	jalr	1590(ra) # 80001b6a <numofproc>
    8000253c:	fca43c23          	sd	a0,-40(s0)

    if(copyout(p->pagetable, addr, (char *)&info, sizeof(info)) < 0)
    80002540:	46c1                	li	a3,16
    80002542:	fd040613          	add	a2,s0,-48
    80002546:	fc843583          	ld	a1,-56(s0)
    8000254a:	68a8                	ld	a0,80(s1)
    8000254c:	ffffe097          	auipc	ra,0xffffe
    80002550:	64a080e7          	jalr	1610(ra) # 80000b96 <copyout>
      return -1;
    return 0;

}
    80002554:	957d                	sra	a0,a0,0x3f
    80002556:	70e2                	ld	ra,56(sp)
    80002558:	7442                	ld	s0,48(sp)
    8000255a:	74a2                	ld	s1,40(sp)
    8000255c:	6121                	add	sp,sp,64
    8000255e:	8082                	ret

0000000080002560 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002560:	7179                	add	sp,sp,-48
    80002562:	f406                	sd	ra,40(sp)
    80002564:	f022                	sd	s0,32(sp)
    80002566:	ec26                	sd	s1,24(sp)
    80002568:	e84a                	sd	s2,16(sp)
    8000256a:	e44e                	sd	s3,8(sp)
    8000256c:	e052                	sd	s4,0(sp)
    8000256e:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002570:	00006597          	auipc	a1,0x6
    80002574:	f2858593          	add	a1,a1,-216 # 80008498 <etext+0x498>
    80002578:	0000f517          	auipc	a0,0xf
    8000257c:	d1050513          	add	a0,a0,-752 # 80011288 <bcache>
    80002580:	00004097          	auipc	ra,0x4
    80002584:	f5c080e7          	jalr	-164(ra) # 800064dc <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002588:	00017797          	auipc	a5,0x17
    8000258c:	d0078793          	add	a5,a5,-768 # 80019288 <bcache+0x8000>
    80002590:	00017717          	auipc	a4,0x17
    80002594:	f6070713          	add	a4,a4,-160 # 800194f0 <bcache+0x8268>
    80002598:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000259c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800025a0:	0000f497          	auipc	s1,0xf
    800025a4:	d0048493          	add	s1,s1,-768 # 800112a0 <bcache+0x18>
    b->next = bcache.head.next;
    800025a8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800025aa:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800025ac:	00006a17          	auipc	s4,0x6
    800025b0:	ef4a0a13          	add	s4,s4,-268 # 800084a0 <etext+0x4a0>
    b->next = bcache.head.next;
    800025b4:	2b893783          	ld	a5,696(s2)
    800025b8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800025ba:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800025be:	85d2                	mv	a1,s4
    800025c0:	01048513          	add	a0,s1,16
    800025c4:	00001097          	auipc	ra,0x1
    800025c8:	4e8080e7          	jalr	1256(ra) # 80003aac <initsleeplock>
    bcache.head.next->prev = b;
    800025cc:	2b893783          	ld	a5,696(s2)
    800025d0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800025d2:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800025d6:	45848493          	add	s1,s1,1112
    800025da:	fd349de3          	bne	s1,s3,800025b4 <binit+0x54>
  }
}
    800025de:	70a2                	ld	ra,40(sp)
    800025e0:	7402                	ld	s0,32(sp)
    800025e2:	64e2                	ld	s1,24(sp)
    800025e4:	6942                	ld	s2,16(sp)
    800025e6:	69a2                	ld	s3,8(sp)
    800025e8:	6a02                	ld	s4,0(sp)
    800025ea:	6145                	add	sp,sp,48
    800025ec:	8082                	ret

00000000800025ee <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800025ee:	7179                	add	sp,sp,-48
    800025f0:	f406                	sd	ra,40(sp)
    800025f2:	f022                	sd	s0,32(sp)
    800025f4:	ec26                	sd	s1,24(sp)
    800025f6:	e84a                	sd	s2,16(sp)
    800025f8:	e44e                	sd	s3,8(sp)
    800025fa:	1800                	add	s0,sp,48
    800025fc:	892a                	mv	s2,a0
    800025fe:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002600:	0000f517          	auipc	a0,0xf
    80002604:	c8850513          	add	a0,a0,-888 # 80011288 <bcache>
    80002608:	00004097          	auipc	ra,0x4
    8000260c:	f64080e7          	jalr	-156(ra) # 8000656c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002610:	00017497          	auipc	s1,0x17
    80002614:	f304b483          	ld	s1,-208(s1) # 80019540 <bcache+0x82b8>
    80002618:	00017797          	auipc	a5,0x17
    8000261c:	ed878793          	add	a5,a5,-296 # 800194f0 <bcache+0x8268>
    80002620:	02f48f63          	beq	s1,a5,8000265e <bread+0x70>
    80002624:	873e                	mv	a4,a5
    80002626:	a021                	j	8000262e <bread+0x40>
    80002628:	68a4                	ld	s1,80(s1)
    8000262a:	02e48a63          	beq	s1,a4,8000265e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000262e:	449c                	lw	a5,8(s1)
    80002630:	ff279ce3          	bne	a5,s2,80002628 <bread+0x3a>
    80002634:	44dc                	lw	a5,12(s1)
    80002636:	ff3799e3          	bne	a5,s3,80002628 <bread+0x3a>
      b->refcnt++;
    8000263a:	40bc                	lw	a5,64(s1)
    8000263c:	2785                	addw	a5,a5,1
    8000263e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002640:	0000f517          	auipc	a0,0xf
    80002644:	c4850513          	add	a0,a0,-952 # 80011288 <bcache>
    80002648:	00004097          	auipc	ra,0x4
    8000264c:	fd8080e7          	jalr	-40(ra) # 80006620 <release>
      acquiresleep(&b->lock);
    80002650:	01048513          	add	a0,s1,16
    80002654:	00001097          	auipc	ra,0x1
    80002658:	492080e7          	jalr	1170(ra) # 80003ae6 <acquiresleep>
      return b;
    8000265c:	a8b9                	j	800026ba <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000265e:	00017497          	auipc	s1,0x17
    80002662:	eda4b483          	ld	s1,-294(s1) # 80019538 <bcache+0x82b0>
    80002666:	00017797          	auipc	a5,0x17
    8000266a:	e8a78793          	add	a5,a5,-374 # 800194f0 <bcache+0x8268>
    8000266e:	00f48863          	beq	s1,a5,8000267e <bread+0x90>
    80002672:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002674:	40bc                	lw	a5,64(s1)
    80002676:	cf81                	beqz	a5,8000268e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002678:	64a4                	ld	s1,72(s1)
    8000267a:	fee49de3          	bne	s1,a4,80002674 <bread+0x86>
  panic("bget: no buffers");
    8000267e:	00006517          	auipc	a0,0x6
    80002682:	e2a50513          	add	a0,a0,-470 # 800084a8 <etext+0x4a8>
    80002686:	00004097          	auipc	ra,0x4
    8000268a:	96c080e7          	jalr	-1684(ra) # 80005ff2 <panic>
      b->dev = dev;
    8000268e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002692:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002696:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000269a:	4785                	li	a5,1
    8000269c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000269e:	0000f517          	auipc	a0,0xf
    800026a2:	bea50513          	add	a0,a0,-1046 # 80011288 <bcache>
    800026a6:	00004097          	auipc	ra,0x4
    800026aa:	f7a080e7          	jalr	-134(ra) # 80006620 <release>
      acquiresleep(&b->lock);
    800026ae:	01048513          	add	a0,s1,16
    800026b2:	00001097          	auipc	ra,0x1
    800026b6:	434080e7          	jalr	1076(ra) # 80003ae6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800026ba:	409c                	lw	a5,0(s1)
    800026bc:	cb89                	beqz	a5,800026ce <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800026be:	8526                	mv	a0,s1
    800026c0:	70a2                	ld	ra,40(sp)
    800026c2:	7402                	ld	s0,32(sp)
    800026c4:	64e2                	ld	s1,24(sp)
    800026c6:	6942                	ld	s2,16(sp)
    800026c8:	69a2                	ld	s3,8(sp)
    800026ca:	6145                	add	sp,sp,48
    800026cc:	8082                	ret
    virtio_disk_rw(b, 0);
    800026ce:	4581                	li	a1,0
    800026d0:	8526                	mv	a0,s1
    800026d2:	00003097          	auipc	ra,0x3
    800026d6:	0f6080e7          	jalr	246(ra) # 800057c8 <virtio_disk_rw>
    b->valid = 1;
    800026da:	4785                	li	a5,1
    800026dc:	c09c                	sw	a5,0(s1)
  return b;
    800026de:	b7c5                	j	800026be <bread+0xd0>

00000000800026e0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800026e0:	1101                	add	sp,sp,-32
    800026e2:	ec06                	sd	ra,24(sp)
    800026e4:	e822                	sd	s0,16(sp)
    800026e6:	e426                	sd	s1,8(sp)
    800026e8:	1000                	add	s0,sp,32
    800026ea:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026ec:	0541                	add	a0,a0,16
    800026ee:	00001097          	auipc	ra,0x1
    800026f2:	492080e7          	jalr	1170(ra) # 80003b80 <holdingsleep>
    800026f6:	cd01                	beqz	a0,8000270e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800026f8:	4585                	li	a1,1
    800026fa:	8526                	mv	a0,s1
    800026fc:	00003097          	auipc	ra,0x3
    80002700:	0cc080e7          	jalr	204(ra) # 800057c8 <virtio_disk_rw>
}
    80002704:	60e2                	ld	ra,24(sp)
    80002706:	6442                	ld	s0,16(sp)
    80002708:	64a2                	ld	s1,8(sp)
    8000270a:	6105                	add	sp,sp,32
    8000270c:	8082                	ret
    panic("bwrite");
    8000270e:	00006517          	auipc	a0,0x6
    80002712:	db250513          	add	a0,a0,-590 # 800084c0 <etext+0x4c0>
    80002716:	00004097          	auipc	ra,0x4
    8000271a:	8dc080e7          	jalr	-1828(ra) # 80005ff2 <panic>

000000008000271e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000271e:	1101                	add	sp,sp,-32
    80002720:	ec06                	sd	ra,24(sp)
    80002722:	e822                	sd	s0,16(sp)
    80002724:	e426                	sd	s1,8(sp)
    80002726:	e04a                	sd	s2,0(sp)
    80002728:	1000                	add	s0,sp,32
    8000272a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000272c:	01050913          	add	s2,a0,16
    80002730:	854a                	mv	a0,s2
    80002732:	00001097          	auipc	ra,0x1
    80002736:	44e080e7          	jalr	1102(ra) # 80003b80 <holdingsleep>
    8000273a:	c925                	beqz	a0,800027aa <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000273c:	854a                	mv	a0,s2
    8000273e:	00001097          	auipc	ra,0x1
    80002742:	3fe080e7          	jalr	1022(ra) # 80003b3c <releasesleep>

  acquire(&bcache.lock);
    80002746:	0000f517          	auipc	a0,0xf
    8000274a:	b4250513          	add	a0,a0,-1214 # 80011288 <bcache>
    8000274e:	00004097          	auipc	ra,0x4
    80002752:	e1e080e7          	jalr	-482(ra) # 8000656c <acquire>
  b->refcnt--;
    80002756:	40bc                	lw	a5,64(s1)
    80002758:	37fd                	addw	a5,a5,-1
    8000275a:	0007871b          	sext.w	a4,a5
    8000275e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002760:	e71d                	bnez	a4,8000278e <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002762:	68b8                	ld	a4,80(s1)
    80002764:	64bc                	ld	a5,72(s1)
    80002766:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002768:	68b8                	ld	a4,80(s1)
    8000276a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000276c:	00017797          	auipc	a5,0x17
    80002770:	b1c78793          	add	a5,a5,-1252 # 80019288 <bcache+0x8000>
    80002774:	2b87b703          	ld	a4,696(a5)
    80002778:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000277a:	00017717          	auipc	a4,0x17
    8000277e:	d7670713          	add	a4,a4,-650 # 800194f0 <bcache+0x8268>
    80002782:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002784:	2b87b703          	ld	a4,696(a5)
    80002788:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000278a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000278e:	0000f517          	auipc	a0,0xf
    80002792:	afa50513          	add	a0,a0,-1286 # 80011288 <bcache>
    80002796:	00004097          	auipc	ra,0x4
    8000279a:	e8a080e7          	jalr	-374(ra) # 80006620 <release>
}
    8000279e:	60e2                	ld	ra,24(sp)
    800027a0:	6442                	ld	s0,16(sp)
    800027a2:	64a2                	ld	s1,8(sp)
    800027a4:	6902                	ld	s2,0(sp)
    800027a6:	6105                	add	sp,sp,32
    800027a8:	8082                	ret
    panic("brelse");
    800027aa:	00006517          	auipc	a0,0x6
    800027ae:	d1e50513          	add	a0,a0,-738 # 800084c8 <etext+0x4c8>
    800027b2:	00004097          	auipc	ra,0x4
    800027b6:	840080e7          	jalr	-1984(ra) # 80005ff2 <panic>

00000000800027ba <bpin>:

void
bpin(struct buf *b) {
    800027ba:	1101                	add	sp,sp,-32
    800027bc:	ec06                	sd	ra,24(sp)
    800027be:	e822                	sd	s0,16(sp)
    800027c0:	e426                	sd	s1,8(sp)
    800027c2:	1000                	add	s0,sp,32
    800027c4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027c6:	0000f517          	auipc	a0,0xf
    800027ca:	ac250513          	add	a0,a0,-1342 # 80011288 <bcache>
    800027ce:	00004097          	auipc	ra,0x4
    800027d2:	d9e080e7          	jalr	-610(ra) # 8000656c <acquire>
  b->refcnt++;
    800027d6:	40bc                	lw	a5,64(s1)
    800027d8:	2785                	addw	a5,a5,1
    800027da:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027dc:	0000f517          	auipc	a0,0xf
    800027e0:	aac50513          	add	a0,a0,-1364 # 80011288 <bcache>
    800027e4:	00004097          	auipc	ra,0x4
    800027e8:	e3c080e7          	jalr	-452(ra) # 80006620 <release>
}
    800027ec:	60e2                	ld	ra,24(sp)
    800027ee:	6442                	ld	s0,16(sp)
    800027f0:	64a2                	ld	s1,8(sp)
    800027f2:	6105                	add	sp,sp,32
    800027f4:	8082                	ret

00000000800027f6 <bunpin>:

void
bunpin(struct buf *b) {
    800027f6:	1101                	add	sp,sp,-32
    800027f8:	ec06                	sd	ra,24(sp)
    800027fa:	e822                	sd	s0,16(sp)
    800027fc:	e426                	sd	s1,8(sp)
    800027fe:	1000                	add	s0,sp,32
    80002800:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002802:	0000f517          	auipc	a0,0xf
    80002806:	a8650513          	add	a0,a0,-1402 # 80011288 <bcache>
    8000280a:	00004097          	auipc	ra,0x4
    8000280e:	d62080e7          	jalr	-670(ra) # 8000656c <acquire>
  b->refcnt--;
    80002812:	40bc                	lw	a5,64(s1)
    80002814:	37fd                	addw	a5,a5,-1
    80002816:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002818:	0000f517          	auipc	a0,0xf
    8000281c:	a7050513          	add	a0,a0,-1424 # 80011288 <bcache>
    80002820:	00004097          	auipc	ra,0x4
    80002824:	e00080e7          	jalr	-512(ra) # 80006620 <release>
}
    80002828:	60e2                	ld	ra,24(sp)
    8000282a:	6442                	ld	s0,16(sp)
    8000282c:	64a2                	ld	s1,8(sp)
    8000282e:	6105                	add	sp,sp,32
    80002830:	8082                	ret

0000000080002832 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002832:	1101                	add	sp,sp,-32
    80002834:	ec06                	sd	ra,24(sp)
    80002836:	e822                	sd	s0,16(sp)
    80002838:	e426                	sd	s1,8(sp)
    8000283a:	e04a                	sd	s2,0(sp)
    8000283c:	1000                	add	s0,sp,32
    8000283e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002840:	00d5d59b          	srlw	a1,a1,0xd
    80002844:	00017797          	auipc	a5,0x17
    80002848:	1207a783          	lw	a5,288(a5) # 80019964 <sb+0x1c>
    8000284c:	9dbd                	addw	a1,a1,a5
    8000284e:	00000097          	auipc	ra,0x0
    80002852:	da0080e7          	jalr	-608(ra) # 800025ee <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002856:	0074f713          	and	a4,s1,7
    8000285a:	4785                	li	a5,1
    8000285c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002860:	14ce                	sll	s1,s1,0x33
    80002862:	90d9                	srl	s1,s1,0x36
    80002864:	00950733          	add	a4,a0,s1
    80002868:	05874703          	lbu	a4,88(a4)
    8000286c:	00e7f6b3          	and	a3,a5,a4
    80002870:	c69d                	beqz	a3,8000289e <bfree+0x6c>
    80002872:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002874:	94aa                	add	s1,s1,a0
    80002876:	fff7c793          	not	a5,a5
    8000287a:	8f7d                	and	a4,a4,a5
    8000287c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002880:	00001097          	auipc	ra,0x1
    80002884:	148080e7          	jalr	328(ra) # 800039c8 <log_write>
  brelse(bp);
    80002888:	854a                	mv	a0,s2
    8000288a:	00000097          	auipc	ra,0x0
    8000288e:	e94080e7          	jalr	-364(ra) # 8000271e <brelse>
}
    80002892:	60e2                	ld	ra,24(sp)
    80002894:	6442                	ld	s0,16(sp)
    80002896:	64a2                	ld	s1,8(sp)
    80002898:	6902                	ld	s2,0(sp)
    8000289a:	6105                	add	sp,sp,32
    8000289c:	8082                	ret
    panic("freeing free block");
    8000289e:	00006517          	auipc	a0,0x6
    800028a2:	c3250513          	add	a0,a0,-974 # 800084d0 <etext+0x4d0>
    800028a6:	00003097          	auipc	ra,0x3
    800028aa:	74c080e7          	jalr	1868(ra) # 80005ff2 <panic>

00000000800028ae <balloc>:
{
    800028ae:	711d                	add	sp,sp,-96
    800028b0:	ec86                	sd	ra,88(sp)
    800028b2:	e8a2                	sd	s0,80(sp)
    800028b4:	e4a6                	sd	s1,72(sp)
    800028b6:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800028b8:	00017797          	auipc	a5,0x17
    800028bc:	0947a783          	lw	a5,148(a5) # 8001994c <sb+0x4>
    800028c0:	10078f63          	beqz	a5,800029de <balloc+0x130>
    800028c4:	e0ca                	sd	s2,64(sp)
    800028c6:	fc4e                	sd	s3,56(sp)
    800028c8:	f852                	sd	s4,48(sp)
    800028ca:	f456                	sd	s5,40(sp)
    800028cc:	f05a                	sd	s6,32(sp)
    800028ce:	ec5e                	sd	s7,24(sp)
    800028d0:	e862                	sd	s8,16(sp)
    800028d2:	e466                	sd	s9,8(sp)
    800028d4:	8baa                	mv	s7,a0
    800028d6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800028d8:	00017b17          	auipc	s6,0x17
    800028dc:	070b0b13          	add	s6,s6,112 # 80019948 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028e0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800028e2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028e4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800028e6:	6c89                	lui	s9,0x2
    800028e8:	a061                	j	80002970 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028ea:	97ca                	add	a5,a5,s2
    800028ec:	8e55                	or	a2,a2,a3
    800028ee:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800028f2:	854a                	mv	a0,s2
    800028f4:	00001097          	auipc	ra,0x1
    800028f8:	0d4080e7          	jalr	212(ra) # 800039c8 <log_write>
        brelse(bp);
    800028fc:	854a                	mv	a0,s2
    800028fe:	00000097          	auipc	ra,0x0
    80002902:	e20080e7          	jalr	-480(ra) # 8000271e <brelse>
  bp = bread(dev, bno);
    80002906:	85a6                	mv	a1,s1
    80002908:	855e                	mv	a0,s7
    8000290a:	00000097          	auipc	ra,0x0
    8000290e:	ce4080e7          	jalr	-796(ra) # 800025ee <bread>
    80002912:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002914:	40000613          	li	a2,1024
    80002918:	4581                	li	a1,0
    8000291a:	05850513          	add	a0,a0,88
    8000291e:	ffffe097          	auipc	ra,0xffffe
    80002922:	8a6080e7          	jalr	-1882(ra) # 800001c4 <memset>
  log_write(bp);
    80002926:	854a                	mv	a0,s2
    80002928:	00001097          	auipc	ra,0x1
    8000292c:	0a0080e7          	jalr	160(ra) # 800039c8 <log_write>
  brelse(bp);
    80002930:	854a                	mv	a0,s2
    80002932:	00000097          	auipc	ra,0x0
    80002936:	dec080e7          	jalr	-532(ra) # 8000271e <brelse>
}
    8000293a:	6906                	ld	s2,64(sp)
    8000293c:	79e2                	ld	s3,56(sp)
    8000293e:	7a42                	ld	s4,48(sp)
    80002940:	7aa2                	ld	s5,40(sp)
    80002942:	7b02                	ld	s6,32(sp)
    80002944:	6be2                	ld	s7,24(sp)
    80002946:	6c42                	ld	s8,16(sp)
    80002948:	6ca2                	ld	s9,8(sp)
}
    8000294a:	8526                	mv	a0,s1
    8000294c:	60e6                	ld	ra,88(sp)
    8000294e:	6446                	ld	s0,80(sp)
    80002950:	64a6                	ld	s1,72(sp)
    80002952:	6125                	add	sp,sp,96
    80002954:	8082                	ret
    brelse(bp);
    80002956:	854a                	mv	a0,s2
    80002958:	00000097          	auipc	ra,0x0
    8000295c:	dc6080e7          	jalr	-570(ra) # 8000271e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002960:	015c87bb          	addw	a5,s9,s5
    80002964:	00078a9b          	sext.w	s5,a5
    80002968:	004b2703          	lw	a4,4(s6)
    8000296c:	06eaf163          	bgeu	s5,a4,800029ce <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    80002970:	41fad79b          	sraw	a5,s5,0x1f
    80002974:	0137d79b          	srlw	a5,a5,0x13
    80002978:	015787bb          	addw	a5,a5,s5
    8000297c:	40d7d79b          	sraw	a5,a5,0xd
    80002980:	01cb2583          	lw	a1,28(s6)
    80002984:	9dbd                	addw	a1,a1,a5
    80002986:	855e                	mv	a0,s7
    80002988:	00000097          	auipc	ra,0x0
    8000298c:	c66080e7          	jalr	-922(ra) # 800025ee <bread>
    80002990:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002992:	004b2503          	lw	a0,4(s6)
    80002996:	000a849b          	sext.w	s1,s5
    8000299a:	8762                	mv	a4,s8
    8000299c:	faa4fde3          	bgeu	s1,a0,80002956 <balloc+0xa8>
      m = 1 << (bi % 8);
    800029a0:	00777693          	and	a3,a4,7
    800029a4:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800029a8:	41f7579b          	sraw	a5,a4,0x1f
    800029ac:	01d7d79b          	srlw	a5,a5,0x1d
    800029b0:	9fb9                	addw	a5,a5,a4
    800029b2:	4037d79b          	sraw	a5,a5,0x3
    800029b6:	00f90633          	add	a2,s2,a5
    800029ba:	05864603          	lbu	a2,88(a2)
    800029be:	00c6f5b3          	and	a1,a3,a2
    800029c2:	d585                	beqz	a1,800028ea <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029c4:	2705                	addw	a4,a4,1
    800029c6:	2485                	addw	s1,s1,1
    800029c8:	fd471ae3          	bne	a4,s4,8000299c <balloc+0xee>
    800029cc:	b769                	j	80002956 <balloc+0xa8>
    800029ce:	6906                	ld	s2,64(sp)
    800029d0:	79e2                	ld	s3,56(sp)
    800029d2:	7a42                	ld	s4,48(sp)
    800029d4:	7aa2                	ld	s5,40(sp)
    800029d6:	7b02                	ld	s6,32(sp)
    800029d8:	6be2                	ld	s7,24(sp)
    800029da:	6c42                	ld	s8,16(sp)
    800029dc:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800029de:	00006517          	auipc	a0,0x6
    800029e2:	b0a50513          	add	a0,a0,-1270 # 800084e8 <etext+0x4e8>
    800029e6:	00003097          	auipc	ra,0x3
    800029ea:	656080e7          	jalr	1622(ra) # 8000603c <printf>
  return 0;
    800029ee:	4481                	li	s1,0
    800029f0:	bfa9                	j	8000294a <balloc+0x9c>

00000000800029f2 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800029f2:	7179                	add	sp,sp,-48
    800029f4:	f406                	sd	ra,40(sp)
    800029f6:	f022                	sd	s0,32(sp)
    800029f8:	ec26                	sd	s1,24(sp)
    800029fa:	e84a                	sd	s2,16(sp)
    800029fc:	e44e                	sd	s3,8(sp)
    800029fe:	1800                	add	s0,sp,48
    80002a00:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002a02:	47ad                	li	a5,11
    80002a04:	02b7e863          	bltu	a5,a1,80002a34 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002a08:	02059793          	sll	a5,a1,0x20
    80002a0c:	01e7d593          	srl	a1,a5,0x1e
    80002a10:	00b504b3          	add	s1,a0,a1
    80002a14:	0504a903          	lw	s2,80(s1)
    80002a18:	08091263          	bnez	s2,80002a9c <bmap+0xaa>
      addr = balloc(ip->dev);
    80002a1c:	4108                	lw	a0,0(a0)
    80002a1e:	00000097          	auipc	ra,0x0
    80002a22:	e90080e7          	jalr	-368(ra) # 800028ae <balloc>
    80002a26:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002a2a:	06090963          	beqz	s2,80002a9c <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    80002a2e:	0524a823          	sw	s2,80(s1)
    80002a32:	a0ad                	j	80002a9c <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002a34:	ff45849b          	addw	s1,a1,-12
    80002a38:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002a3c:	0ff00793          	li	a5,255
    80002a40:	08e7e863          	bltu	a5,a4,80002ad0 <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002a44:	08052903          	lw	s2,128(a0)
    80002a48:	00091f63          	bnez	s2,80002a66 <bmap+0x74>
      addr = balloc(ip->dev);
    80002a4c:	4108                	lw	a0,0(a0)
    80002a4e:	00000097          	auipc	ra,0x0
    80002a52:	e60080e7          	jalr	-416(ra) # 800028ae <balloc>
    80002a56:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002a5a:	04090163          	beqz	s2,80002a9c <bmap+0xaa>
    80002a5e:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002a60:	0929a023          	sw	s2,128(s3)
    80002a64:	a011                	j	80002a68 <bmap+0x76>
    80002a66:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002a68:	85ca                	mv	a1,s2
    80002a6a:	0009a503          	lw	a0,0(s3)
    80002a6e:	00000097          	auipc	ra,0x0
    80002a72:	b80080e7          	jalr	-1152(ra) # 800025ee <bread>
    80002a76:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a78:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80002a7c:	02049713          	sll	a4,s1,0x20
    80002a80:	01e75593          	srl	a1,a4,0x1e
    80002a84:	00b784b3          	add	s1,a5,a1
    80002a88:	0004a903          	lw	s2,0(s1)
    80002a8c:	02090063          	beqz	s2,80002aac <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002a90:	8552                	mv	a0,s4
    80002a92:	00000097          	auipc	ra,0x0
    80002a96:	c8c080e7          	jalr	-884(ra) # 8000271e <brelse>
    return addr;
    80002a9a:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002a9c:	854a                	mv	a0,s2
    80002a9e:	70a2                	ld	ra,40(sp)
    80002aa0:	7402                	ld	s0,32(sp)
    80002aa2:	64e2                	ld	s1,24(sp)
    80002aa4:	6942                	ld	s2,16(sp)
    80002aa6:	69a2                	ld	s3,8(sp)
    80002aa8:	6145                	add	sp,sp,48
    80002aaa:	8082                	ret
      addr = balloc(ip->dev);
    80002aac:	0009a503          	lw	a0,0(s3)
    80002ab0:	00000097          	auipc	ra,0x0
    80002ab4:	dfe080e7          	jalr	-514(ra) # 800028ae <balloc>
    80002ab8:	0005091b          	sext.w	s2,a0
      if(addr){
    80002abc:	fc090ae3          	beqz	s2,80002a90 <bmap+0x9e>
        a[bn] = addr;
    80002ac0:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002ac4:	8552                	mv	a0,s4
    80002ac6:	00001097          	auipc	ra,0x1
    80002aca:	f02080e7          	jalr	-254(ra) # 800039c8 <log_write>
    80002ace:	b7c9                	j	80002a90 <bmap+0x9e>
    80002ad0:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002ad2:	00006517          	auipc	a0,0x6
    80002ad6:	a2e50513          	add	a0,a0,-1490 # 80008500 <etext+0x500>
    80002ada:	00003097          	auipc	ra,0x3
    80002ade:	518080e7          	jalr	1304(ra) # 80005ff2 <panic>

0000000080002ae2 <iget>:
{
    80002ae2:	7179                	add	sp,sp,-48
    80002ae4:	f406                	sd	ra,40(sp)
    80002ae6:	f022                	sd	s0,32(sp)
    80002ae8:	ec26                	sd	s1,24(sp)
    80002aea:	e84a                	sd	s2,16(sp)
    80002aec:	e44e                	sd	s3,8(sp)
    80002aee:	e052                	sd	s4,0(sp)
    80002af0:	1800                	add	s0,sp,48
    80002af2:	89aa                	mv	s3,a0
    80002af4:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002af6:	00017517          	auipc	a0,0x17
    80002afa:	e7250513          	add	a0,a0,-398 # 80019968 <itable>
    80002afe:	00004097          	auipc	ra,0x4
    80002b02:	a6e080e7          	jalr	-1426(ra) # 8000656c <acquire>
  empty = 0;
    80002b06:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b08:	00017497          	auipc	s1,0x17
    80002b0c:	e7848493          	add	s1,s1,-392 # 80019980 <itable+0x18>
    80002b10:	00019697          	auipc	a3,0x19
    80002b14:	90068693          	add	a3,a3,-1792 # 8001b410 <log>
    80002b18:	a039                	j	80002b26 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b1a:	02090b63          	beqz	s2,80002b50 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b1e:	08848493          	add	s1,s1,136
    80002b22:	02d48a63          	beq	s1,a3,80002b56 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002b26:	449c                	lw	a5,8(s1)
    80002b28:	fef059e3          	blez	a5,80002b1a <iget+0x38>
    80002b2c:	4098                	lw	a4,0(s1)
    80002b2e:	ff3716e3          	bne	a4,s3,80002b1a <iget+0x38>
    80002b32:	40d8                	lw	a4,4(s1)
    80002b34:	ff4713e3          	bne	a4,s4,80002b1a <iget+0x38>
      ip->ref++;
    80002b38:	2785                	addw	a5,a5,1
    80002b3a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b3c:	00017517          	auipc	a0,0x17
    80002b40:	e2c50513          	add	a0,a0,-468 # 80019968 <itable>
    80002b44:	00004097          	auipc	ra,0x4
    80002b48:	adc080e7          	jalr	-1316(ra) # 80006620 <release>
      return ip;
    80002b4c:	8926                	mv	s2,s1
    80002b4e:	a03d                	j	80002b7c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b50:	f7f9                	bnez	a5,80002b1e <iget+0x3c>
      empty = ip;
    80002b52:	8926                	mv	s2,s1
    80002b54:	b7e9                	j	80002b1e <iget+0x3c>
  if(empty == 0)
    80002b56:	02090c63          	beqz	s2,80002b8e <iget+0xac>
  ip->dev = dev;
    80002b5a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b5e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b62:	4785                	li	a5,1
    80002b64:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b68:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002b6c:	00017517          	auipc	a0,0x17
    80002b70:	dfc50513          	add	a0,a0,-516 # 80019968 <itable>
    80002b74:	00004097          	auipc	ra,0x4
    80002b78:	aac080e7          	jalr	-1364(ra) # 80006620 <release>
}
    80002b7c:	854a                	mv	a0,s2
    80002b7e:	70a2                	ld	ra,40(sp)
    80002b80:	7402                	ld	s0,32(sp)
    80002b82:	64e2                	ld	s1,24(sp)
    80002b84:	6942                	ld	s2,16(sp)
    80002b86:	69a2                	ld	s3,8(sp)
    80002b88:	6a02                	ld	s4,0(sp)
    80002b8a:	6145                	add	sp,sp,48
    80002b8c:	8082                	ret
    panic("iget: no inodes");
    80002b8e:	00006517          	auipc	a0,0x6
    80002b92:	98a50513          	add	a0,a0,-1654 # 80008518 <etext+0x518>
    80002b96:	00003097          	auipc	ra,0x3
    80002b9a:	45c080e7          	jalr	1116(ra) # 80005ff2 <panic>

0000000080002b9e <fsinit>:
fsinit(int dev) {
    80002b9e:	7179                	add	sp,sp,-48
    80002ba0:	f406                	sd	ra,40(sp)
    80002ba2:	f022                	sd	s0,32(sp)
    80002ba4:	ec26                	sd	s1,24(sp)
    80002ba6:	e84a                	sd	s2,16(sp)
    80002ba8:	e44e                	sd	s3,8(sp)
    80002baa:	1800                	add	s0,sp,48
    80002bac:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002bae:	4585                	li	a1,1
    80002bb0:	00000097          	auipc	ra,0x0
    80002bb4:	a3e080e7          	jalr	-1474(ra) # 800025ee <bread>
    80002bb8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002bba:	00017997          	auipc	s3,0x17
    80002bbe:	d8e98993          	add	s3,s3,-626 # 80019948 <sb>
    80002bc2:	02000613          	li	a2,32
    80002bc6:	05850593          	add	a1,a0,88
    80002bca:	854e                	mv	a0,s3
    80002bcc:	ffffd097          	auipc	ra,0xffffd
    80002bd0:	654080e7          	jalr	1620(ra) # 80000220 <memmove>
  brelse(bp);
    80002bd4:	8526                	mv	a0,s1
    80002bd6:	00000097          	auipc	ra,0x0
    80002bda:	b48080e7          	jalr	-1208(ra) # 8000271e <brelse>
  if(sb.magic != FSMAGIC)
    80002bde:	0009a703          	lw	a4,0(s3)
    80002be2:	102037b7          	lui	a5,0x10203
    80002be6:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002bea:	02f71263          	bne	a4,a5,80002c0e <fsinit+0x70>
  initlog(dev, &sb);
    80002bee:	00017597          	auipc	a1,0x17
    80002bf2:	d5a58593          	add	a1,a1,-678 # 80019948 <sb>
    80002bf6:	854a                	mv	a0,s2
    80002bf8:	00001097          	auipc	ra,0x1
    80002bfc:	b60080e7          	jalr	-1184(ra) # 80003758 <initlog>
}
    80002c00:	70a2                	ld	ra,40(sp)
    80002c02:	7402                	ld	s0,32(sp)
    80002c04:	64e2                	ld	s1,24(sp)
    80002c06:	6942                	ld	s2,16(sp)
    80002c08:	69a2                	ld	s3,8(sp)
    80002c0a:	6145                	add	sp,sp,48
    80002c0c:	8082                	ret
    panic("invalid file system");
    80002c0e:	00006517          	auipc	a0,0x6
    80002c12:	91a50513          	add	a0,a0,-1766 # 80008528 <etext+0x528>
    80002c16:	00003097          	auipc	ra,0x3
    80002c1a:	3dc080e7          	jalr	988(ra) # 80005ff2 <panic>

0000000080002c1e <iinit>:
{
    80002c1e:	7179                	add	sp,sp,-48
    80002c20:	f406                	sd	ra,40(sp)
    80002c22:	f022                	sd	s0,32(sp)
    80002c24:	ec26                	sd	s1,24(sp)
    80002c26:	e84a                	sd	s2,16(sp)
    80002c28:	e44e                	sd	s3,8(sp)
    80002c2a:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c2c:	00006597          	auipc	a1,0x6
    80002c30:	91458593          	add	a1,a1,-1772 # 80008540 <etext+0x540>
    80002c34:	00017517          	auipc	a0,0x17
    80002c38:	d3450513          	add	a0,a0,-716 # 80019968 <itable>
    80002c3c:	00004097          	auipc	ra,0x4
    80002c40:	8a0080e7          	jalr	-1888(ra) # 800064dc <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c44:	00017497          	auipc	s1,0x17
    80002c48:	d4c48493          	add	s1,s1,-692 # 80019990 <itable+0x28>
    80002c4c:	00018997          	auipc	s3,0x18
    80002c50:	7d498993          	add	s3,s3,2004 # 8001b420 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c54:	00006917          	auipc	s2,0x6
    80002c58:	8f490913          	add	s2,s2,-1804 # 80008548 <etext+0x548>
    80002c5c:	85ca                	mv	a1,s2
    80002c5e:	8526                	mv	a0,s1
    80002c60:	00001097          	auipc	ra,0x1
    80002c64:	e4c080e7          	jalr	-436(ra) # 80003aac <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002c68:	08848493          	add	s1,s1,136
    80002c6c:	ff3498e3          	bne	s1,s3,80002c5c <iinit+0x3e>
}
    80002c70:	70a2                	ld	ra,40(sp)
    80002c72:	7402                	ld	s0,32(sp)
    80002c74:	64e2                	ld	s1,24(sp)
    80002c76:	6942                	ld	s2,16(sp)
    80002c78:	69a2                	ld	s3,8(sp)
    80002c7a:	6145                	add	sp,sp,48
    80002c7c:	8082                	ret

0000000080002c7e <ialloc>:
{
    80002c7e:	7139                	add	sp,sp,-64
    80002c80:	fc06                	sd	ra,56(sp)
    80002c82:	f822                	sd	s0,48(sp)
    80002c84:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c86:	00017717          	auipc	a4,0x17
    80002c8a:	cce72703          	lw	a4,-818(a4) # 80019954 <sb+0xc>
    80002c8e:	4785                	li	a5,1
    80002c90:	06e7f463          	bgeu	a5,a4,80002cf8 <ialloc+0x7a>
    80002c94:	f426                	sd	s1,40(sp)
    80002c96:	f04a                	sd	s2,32(sp)
    80002c98:	ec4e                	sd	s3,24(sp)
    80002c9a:	e852                	sd	s4,16(sp)
    80002c9c:	e456                	sd	s5,8(sp)
    80002c9e:	e05a                	sd	s6,0(sp)
    80002ca0:	8aaa                	mv	s5,a0
    80002ca2:	8b2e                	mv	s6,a1
    80002ca4:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002ca6:	00017a17          	auipc	s4,0x17
    80002caa:	ca2a0a13          	add	s4,s4,-862 # 80019948 <sb>
    80002cae:	00495593          	srl	a1,s2,0x4
    80002cb2:	018a2783          	lw	a5,24(s4)
    80002cb6:	9dbd                	addw	a1,a1,a5
    80002cb8:	8556                	mv	a0,s5
    80002cba:	00000097          	auipc	ra,0x0
    80002cbe:	934080e7          	jalr	-1740(ra) # 800025ee <bread>
    80002cc2:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002cc4:	05850993          	add	s3,a0,88
    80002cc8:	00f97793          	and	a5,s2,15
    80002ccc:	079a                	sll	a5,a5,0x6
    80002cce:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002cd0:	00099783          	lh	a5,0(s3)
    80002cd4:	cf9d                	beqz	a5,80002d12 <ialloc+0x94>
    brelse(bp);
    80002cd6:	00000097          	auipc	ra,0x0
    80002cda:	a48080e7          	jalr	-1464(ra) # 8000271e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002cde:	0905                	add	s2,s2,1
    80002ce0:	00ca2703          	lw	a4,12(s4)
    80002ce4:	0009079b          	sext.w	a5,s2
    80002ce8:	fce7e3e3          	bltu	a5,a4,80002cae <ialloc+0x30>
    80002cec:	74a2                	ld	s1,40(sp)
    80002cee:	7902                	ld	s2,32(sp)
    80002cf0:	69e2                	ld	s3,24(sp)
    80002cf2:	6a42                	ld	s4,16(sp)
    80002cf4:	6aa2                	ld	s5,8(sp)
    80002cf6:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002cf8:	00006517          	auipc	a0,0x6
    80002cfc:	85850513          	add	a0,a0,-1960 # 80008550 <etext+0x550>
    80002d00:	00003097          	auipc	ra,0x3
    80002d04:	33c080e7          	jalr	828(ra) # 8000603c <printf>
  return 0;
    80002d08:	4501                	li	a0,0
}
    80002d0a:	70e2                	ld	ra,56(sp)
    80002d0c:	7442                	ld	s0,48(sp)
    80002d0e:	6121                	add	sp,sp,64
    80002d10:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002d12:	04000613          	li	a2,64
    80002d16:	4581                	li	a1,0
    80002d18:	854e                	mv	a0,s3
    80002d1a:	ffffd097          	auipc	ra,0xffffd
    80002d1e:	4aa080e7          	jalr	1194(ra) # 800001c4 <memset>
      dip->type = type;
    80002d22:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002d26:	8526                	mv	a0,s1
    80002d28:	00001097          	auipc	ra,0x1
    80002d2c:	ca0080e7          	jalr	-864(ra) # 800039c8 <log_write>
      brelse(bp);
    80002d30:	8526                	mv	a0,s1
    80002d32:	00000097          	auipc	ra,0x0
    80002d36:	9ec080e7          	jalr	-1556(ra) # 8000271e <brelse>
      return iget(dev, inum);
    80002d3a:	0009059b          	sext.w	a1,s2
    80002d3e:	8556                	mv	a0,s5
    80002d40:	00000097          	auipc	ra,0x0
    80002d44:	da2080e7          	jalr	-606(ra) # 80002ae2 <iget>
    80002d48:	74a2                	ld	s1,40(sp)
    80002d4a:	7902                	ld	s2,32(sp)
    80002d4c:	69e2                	ld	s3,24(sp)
    80002d4e:	6a42                	ld	s4,16(sp)
    80002d50:	6aa2                	ld	s5,8(sp)
    80002d52:	6b02                	ld	s6,0(sp)
    80002d54:	bf5d                	j	80002d0a <ialloc+0x8c>

0000000080002d56 <iupdate>:
{
    80002d56:	1101                	add	sp,sp,-32
    80002d58:	ec06                	sd	ra,24(sp)
    80002d5a:	e822                	sd	s0,16(sp)
    80002d5c:	e426                	sd	s1,8(sp)
    80002d5e:	e04a                	sd	s2,0(sp)
    80002d60:	1000                	add	s0,sp,32
    80002d62:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d64:	415c                	lw	a5,4(a0)
    80002d66:	0047d79b          	srlw	a5,a5,0x4
    80002d6a:	00017597          	auipc	a1,0x17
    80002d6e:	bf65a583          	lw	a1,-1034(a1) # 80019960 <sb+0x18>
    80002d72:	9dbd                	addw	a1,a1,a5
    80002d74:	4108                	lw	a0,0(a0)
    80002d76:	00000097          	auipc	ra,0x0
    80002d7a:	878080e7          	jalr	-1928(ra) # 800025ee <bread>
    80002d7e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d80:	05850793          	add	a5,a0,88
    80002d84:	40d8                	lw	a4,4(s1)
    80002d86:	8b3d                	and	a4,a4,15
    80002d88:	071a                	sll	a4,a4,0x6
    80002d8a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002d8c:	04449703          	lh	a4,68(s1)
    80002d90:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002d94:	04649703          	lh	a4,70(s1)
    80002d98:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002d9c:	04849703          	lh	a4,72(s1)
    80002da0:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002da4:	04a49703          	lh	a4,74(s1)
    80002da8:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002dac:	44f8                	lw	a4,76(s1)
    80002dae:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002db0:	03400613          	li	a2,52
    80002db4:	05048593          	add	a1,s1,80
    80002db8:	00c78513          	add	a0,a5,12
    80002dbc:	ffffd097          	auipc	ra,0xffffd
    80002dc0:	464080e7          	jalr	1124(ra) # 80000220 <memmove>
  log_write(bp);
    80002dc4:	854a                	mv	a0,s2
    80002dc6:	00001097          	auipc	ra,0x1
    80002dca:	c02080e7          	jalr	-1022(ra) # 800039c8 <log_write>
  brelse(bp);
    80002dce:	854a                	mv	a0,s2
    80002dd0:	00000097          	auipc	ra,0x0
    80002dd4:	94e080e7          	jalr	-1714(ra) # 8000271e <brelse>
}
    80002dd8:	60e2                	ld	ra,24(sp)
    80002dda:	6442                	ld	s0,16(sp)
    80002ddc:	64a2                	ld	s1,8(sp)
    80002dde:	6902                	ld	s2,0(sp)
    80002de0:	6105                	add	sp,sp,32
    80002de2:	8082                	ret

0000000080002de4 <idup>:
{
    80002de4:	1101                	add	sp,sp,-32
    80002de6:	ec06                	sd	ra,24(sp)
    80002de8:	e822                	sd	s0,16(sp)
    80002dea:	e426                	sd	s1,8(sp)
    80002dec:	1000                	add	s0,sp,32
    80002dee:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002df0:	00017517          	auipc	a0,0x17
    80002df4:	b7850513          	add	a0,a0,-1160 # 80019968 <itable>
    80002df8:	00003097          	auipc	ra,0x3
    80002dfc:	774080e7          	jalr	1908(ra) # 8000656c <acquire>
  ip->ref++;
    80002e00:	449c                	lw	a5,8(s1)
    80002e02:	2785                	addw	a5,a5,1
    80002e04:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e06:	00017517          	auipc	a0,0x17
    80002e0a:	b6250513          	add	a0,a0,-1182 # 80019968 <itable>
    80002e0e:	00004097          	auipc	ra,0x4
    80002e12:	812080e7          	jalr	-2030(ra) # 80006620 <release>
}
    80002e16:	8526                	mv	a0,s1
    80002e18:	60e2                	ld	ra,24(sp)
    80002e1a:	6442                	ld	s0,16(sp)
    80002e1c:	64a2                	ld	s1,8(sp)
    80002e1e:	6105                	add	sp,sp,32
    80002e20:	8082                	ret

0000000080002e22 <ilock>:
{
    80002e22:	1101                	add	sp,sp,-32
    80002e24:	ec06                	sd	ra,24(sp)
    80002e26:	e822                	sd	s0,16(sp)
    80002e28:	e426                	sd	s1,8(sp)
    80002e2a:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002e2c:	c10d                	beqz	a0,80002e4e <ilock+0x2c>
    80002e2e:	84aa                	mv	s1,a0
    80002e30:	451c                	lw	a5,8(a0)
    80002e32:	00f05e63          	blez	a5,80002e4e <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002e36:	0541                	add	a0,a0,16
    80002e38:	00001097          	auipc	ra,0x1
    80002e3c:	cae080e7          	jalr	-850(ra) # 80003ae6 <acquiresleep>
  if(ip->valid == 0){
    80002e40:	40bc                	lw	a5,64(s1)
    80002e42:	cf99                	beqz	a5,80002e60 <ilock+0x3e>
}
    80002e44:	60e2                	ld	ra,24(sp)
    80002e46:	6442                	ld	s0,16(sp)
    80002e48:	64a2                	ld	s1,8(sp)
    80002e4a:	6105                	add	sp,sp,32
    80002e4c:	8082                	ret
    80002e4e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002e50:	00005517          	auipc	a0,0x5
    80002e54:	71850513          	add	a0,a0,1816 # 80008568 <etext+0x568>
    80002e58:	00003097          	auipc	ra,0x3
    80002e5c:	19a080e7          	jalr	410(ra) # 80005ff2 <panic>
    80002e60:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e62:	40dc                	lw	a5,4(s1)
    80002e64:	0047d79b          	srlw	a5,a5,0x4
    80002e68:	00017597          	auipc	a1,0x17
    80002e6c:	af85a583          	lw	a1,-1288(a1) # 80019960 <sb+0x18>
    80002e70:	9dbd                	addw	a1,a1,a5
    80002e72:	4088                	lw	a0,0(s1)
    80002e74:	fffff097          	auipc	ra,0xfffff
    80002e78:	77a080e7          	jalr	1914(ra) # 800025ee <bread>
    80002e7c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e7e:	05850593          	add	a1,a0,88
    80002e82:	40dc                	lw	a5,4(s1)
    80002e84:	8bbd                	and	a5,a5,15
    80002e86:	079a                	sll	a5,a5,0x6
    80002e88:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e8a:	00059783          	lh	a5,0(a1)
    80002e8e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002e92:	00259783          	lh	a5,2(a1)
    80002e96:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002e9a:	00459783          	lh	a5,4(a1)
    80002e9e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ea2:	00659783          	lh	a5,6(a1)
    80002ea6:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002eaa:	459c                	lw	a5,8(a1)
    80002eac:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002eae:	03400613          	li	a2,52
    80002eb2:	05b1                	add	a1,a1,12
    80002eb4:	05048513          	add	a0,s1,80
    80002eb8:	ffffd097          	auipc	ra,0xffffd
    80002ebc:	368080e7          	jalr	872(ra) # 80000220 <memmove>
    brelse(bp);
    80002ec0:	854a                	mv	a0,s2
    80002ec2:	00000097          	auipc	ra,0x0
    80002ec6:	85c080e7          	jalr	-1956(ra) # 8000271e <brelse>
    ip->valid = 1;
    80002eca:	4785                	li	a5,1
    80002ecc:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002ece:	04449783          	lh	a5,68(s1)
    80002ed2:	c399                	beqz	a5,80002ed8 <ilock+0xb6>
    80002ed4:	6902                	ld	s2,0(sp)
    80002ed6:	b7bd                	j	80002e44 <ilock+0x22>
      panic("ilock: no type");
    80002ed8:	00005517          	auipc	a0,0x5
    80002edc:	69850513          	add	a0,a0,1688 # 80008570 <etext+0x570>
    80002ee0:	00003097          	auipc	ra,0x3
    80002ee4:	112080e7          	jalr	274(ra) # 80005ff2 <panic>

0000000080002ee8 <iunlock>:
{
    80002ee8:	1101                	add	sp,sp,-32
    80002eea:	ec06                	sd	ra,24(sp)
    80002eec:	e822                	sd	s0,16(sp)
    80002eee:	e426                	sd	s1,8(sp)
    80002ef0:	e04a                	sd	s2,0(sp)
    80002ef2:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ef4:	c905                	beqz	a0,80002f24 <iunlock+0x3c>
    80002ef6:	84aa                	mv	s1,a0
    80002ef8:	01050913          	add	s2,a0,16
    80002efc:	854a                	mv	a0,s2
    80002efe:	00001097          	auipc	ra,0x1
    80002f02:	c82080e7          	jalr	-894(ra) # 80003b80 <holdingsleep>
    80002f06:	cd19                	beqz	a0,80002f24 <iunlock+0x3c>
    80002f08:	449c                	lw	a5,8(s1)
    80002f0a:	00f05d63          	blez	a5,80002f24 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002f0e:	854a                	mv	a0,s2
    80002f10:	00001097          	auipc	ra,0x1
    80002f14:	c2c080e7          	jalr	-980(ra) # 80003b3c <releasesleep>
}
    80002f18:	60e2                	ld	ra,24(sp)
    80002f1a:	6442                	ld	s0,16(sp)
    80002f1c:	64a2                	ld	s1,8(sp)
    80002f1e:	6902                	ld	s2,0(sp)
    80002f20:	6105                	add	sp,sp,32
    80002f22:	8082                	ret
    panic("iunlock");
    80002f24:	00005517          	auipc	a0,0x5
    80002f28:	65c50513          	add	a0,a0,1628 # 80008580 <etext+0x580>
    80002f2c:	00003097          	auipc	ra,0x3
    80002f30:	0c6080e7          	jalr	198(ra) # 80005ff2 <panic>

0000000080002f34 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002f34:	7179                	add	sp,sp,-48
    80002f36:	f406                	sd	ra,40(sp)
    80002f38:	f022                	sd	s0,32(sp)
    80002f3a:	ec26                	sd	s1,24(sp)
    80002f3c:	e84a                	sd	s2,16(sp)
    80002f3e:	e44e                	sd	s3,8(sp)
    80002f40:	1800                	add	s0,sp,48
    80002f42:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002f44:	05050493          	add	s1,a0,80
    80002f48:	08050913          	add	s2,a0,128
    80002f4c:	a021                	j	80002f54 <itrunc+0x20>
    80002f4e:	0491                	add	s1,s1,4
    80002f50:	01248d63          	beq	s1,s2,80002f6a <itrunc+0x36>
    if(ip->addrs[i]){
    80002f54:	408c                	lw	a1,0(s1)
    80002f56:	dde5                	beqz	a1,80002f4e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002f58:	0009a503          	lw	a0,0(s3)
    80002f5c:	00000097          	auipc	ra,0x0
    80002f60:	8d6080e7          	jalr	-1834(ra) # 80002832 <bfree>
      ip->addrs[i] = 0;
    80002f64:	0004a023          	sw	zero,0(s1)
    80002f68:	b7dd                	j	80002f4e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f6a:	0809a583          	lw	a1,128(s3)
    80002f6e:	ed99                	bnez	a1,80002f8c <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f70:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002f74:	854e                	mv	a0,s3
    80002f76:	00000097          	auipc	ra,0x0
    80002f7a:	de0080e7          	jalr	-544(ra) # 80002d56 <iupdate>
}
    80002f7e:	70a2                	ld	ra,40(sp)
    80002f80:	7402                	ld	s0,32(sp)
    80002f82:	64e2                	ld	s1,24(sp)
    80002f84:	6942                	ld	s2,16(sp)
    80002f86:	69a2                	ld	s3,8(sp)
    80002f88:	6145                	add	sp,sp,48
    80002f8a:	8082                	ret
    80002f8c:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f8e:	0009a503          	lw	a0,0(s3)
    80002f92:	fffff097          	auipc	ra,0xfffff
    80002f96:	65c080e7          	jalr	1628(ra) # 800025ee <bread>
    80002f9a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f9c:	05850493          	add	s1,a0,88
    80002fa0:	45850913          	add	s2,a0,1112
    80002fa4:	a021                	j	80002fac <itrunc+0x78>
    80002fa6:	0491                	add	s1,s1,4
    80002fa8:	01248b63          	beq	s1,s2,80002fbe <itrunc+0x8a>
      if(a[j])
    80002fac:	408c                	lw	a1,0(s1)
    80002fae:	dde5                	beqz	a1,80002fa6 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002fb0:	0009a503          	lw	a0,0(s3)
    80002fb4:	00000097          	auipc	ra,0x0
    80002fb8:	87e080e7          	jalr	-1922(ra) # 80002832 <bfree>
    80002fbc:	b7ed                	j	80002fa6 <itrunc+0x72>
    brelse(bp);
    80002fbe:	8552                	mv	a0,s4
    80002fc0:	fffff097          	auipc	ra,0xfffff
    80002fc4:	75e080e7          	jalr	1886(ra) # 8000271e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002fc8:	0809a583          	lw	a1,128(s3)
    80002fcc:	0009a503          	lw	a0,0(s3)
    80002fd0:	00000097          	auipc	ra,0x0
    80002fd4:	862080e7          	jalr	-1950(ra) # 80002832 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002fd8:	0809a023          	sw	zero,128(s3)
    80002fdc:	6a02                	ld	s4,0(sp)
    80002fde:	bf49                	j	80002f70 <itrunc+0x3c>

0000000080002fe0 <iput>:
{
    80002fe0:	1101                	add	sp,sp,-32
    80002fe2:	ec06                	sd	ra,24(sp)
    80002fe4:	e822                	sd	s0,16(sp)
    80002fe6:	e426                	sd	s1,8(sp)
    80002fe8:	1000                	add	s0,sp,32
    80002fea:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002fec:	00017517          	auipc	a0,0x17
    80002ff0:	97c50513          	add	a0,a0,-1668 # 80019968 <itable>
    80002ff4:	00003097          	auipc	ra,0x3
    80002ff8:	578080e7          	jalr	1400(ra) # 8000656c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ffc:	4498                	lw	a4,8(s1)
    80002ffe:	4785                	li	a5,1
    80003000:	02f70263          	beq	a4,a5,80003024 <iput+0x44>
  ip->ref--;
    80003004:	449c                	lw	a5,8(s1)
    80003006:	37fd                	addw	a5,a5,-1
    80003008:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000300a:	00017517          	auipc	a0,0x17
    8000300e:	95e50513          	add	a0,a0,-1698 # 80019968 <itable>
    80003012:	00003097          	auipc	ra,0x3
    80003016:	60e080e7          	jalr	1550(ra) # 80006620 <release>
}
    8000301a:	60e2                	ld	ra,24(sp)
    8000301c:	6442                	ld	s0,16(sp)
    8000301e:	64a2                	ld	s1,8(sp)
    80003020:	6105                	add	sp,sp,32
    80003022:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003024:	40bc                	lw	a5,64(s1)
    80003026:	dff9                	beqz	a5,80003004 <iput+0x24>
    80003028:	04a49783          	lh	a5,74(s1)
    8000302c:	ffe1                	bnez	a5,80003004 <iput+0x24>
    8000302e:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003030:	01048913          	add	s2,s1,16
    80003034:	854a                	mv	a0,s2
    80003036:	00001097          	auipc	ra,0x1
    8000303a:	ab0080e7          	jalr	-1360(ra) # 80003ae6 <acquiresleep>
    release(&itable.lock);
    8000303e:	00017517          	auipc	a0,0x17
    80003042:	92a50513          	add	a0,a0,-1750 # 80019968 <itable>
    80003046:	00003097          	auipc	ra,0x3
    8000304a:	5da080e7          	jalr	1498(ra) # 80006620 <release>
    itrunc(ip);
    8000304e:	8526                	mv	a0,s1
    80003050:	00000097          	auipc	ra,0x0
    80003054:	ee4080e7          	jalr	-284(ra) # 80002f34 <itrunc>
    ip->type = 0;
    80003058:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000305c:	8526                	mv	a0,s1
    8000305e:	00000097          	auipc	ra,0x0
    80003062:	cf8080e7          	jalr	-776(ra) # 80002d56 <iupdate>
    ip->valid = 0;
    80003066:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000306a:	854a                	mv	a0,s2
    8000306c:	00001097          	auipc	ra,0x1
    80003070:	ad0080e7          	jalr	-1328(ra) # 80003b3c <releasesleep>
    acquire(&itable.lock);
    80003074:	00017517          	auipc	a0,0x17
    80003078:	8f450513          	add	a0,a0,-1804 # 80019968 <itable>
    8000307c:	00003097          	auipc	ra,0x3
    80003080:	4f0080e7          	jalr	1264(ra) # 8000656c <acquire>
    80003084:	6902                	ld	s2,0(sp)
    80003086:	bfbd                	j	80003004 <iput+0x24>

0000000080003088 <iunlockput>:
{
    80003088:	1101                	add	sp,sp,-32
    8000308a:	ec06                	sd	ra,24(sp)
    8000308c:	e822                	sd	s0,16(sp)
    8000308e:	e426                	sd	s1,8(sp)
    80003090:	1000                	add	s0,sp,32
    80003092:	84aa                	mv	s1,a0
  iunlock(ip);
    80003094:	00000097          	auipc	ra,0x0
    80003098:	e54080e7          	jalr	-428(ra) # 80002ee8 <iunlock>
  iput(ip);
    8000309c:	8526                	mv	a0,s1
    8000309e:	00000097          	auipc	ra,0x0
    800030a2:	f42080e7          	jalr	-190(ra) # 80002fe0 <iput>
}
    800030a6:	60e2                	ld	ra,24(sp)
    800030a8:	6442                	ld	s0,16(sp)
    800030aa:	64a2                	ld	s1,8(sp)
    800030ac:	6105                	add	sp,sp,32
    800030ae:	8082                	ret

00000000800030b0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800030b0:	1141                	add	sp,sp,-16
    800030b2:	e422                	sd	s0,8(sp)
    800030b4:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    800030b6:	411c                	lw	a5,0(a0)
    800030b8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800030ba:	415c                	lw	a5,4(a0)
    800030bc:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800030be:	04451783          	lh	a5,68(a0)
    800030c2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800030c6:	04a51783          	lh	a5,74(a0)
    800030ca:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800030ce:	04c56783          	lwu	a5,76(a0)
    800030d2:	e99c                	sd	a5,16(a1)
}
    800030d4:	6422                	ld	s0,8(sp)
    800030d6:	0141                	add	sp,sp,16
    800030d8:	8082                	ret

00000000800030da <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030da:	457c                	lw	a5,76(a0)
    800030dc:	10d7e563          	bltu	a5,a3,800031e6 <readi+0x10c>
{
    800030e0:	7159                	add	sp,sp,-112
    800030e2:	f486                	sd	ra,104(sp)
    800030e4:	f0a2                	sd	s0,96(sp)
    800030e6:	eca6                	sd	s1,88(sp)
    800030e8:	e0d2                	sd	s4,64(sp)
    800030ea:	fc56                	sd	s5,56(sp)
    800030ec:	f85a                	sd	s6,48(sp)
    800030ee:	f45e                	sd	s7,40(sp)
    800030f0:	1880                	add	s0,sp,112
    800030f2:	8b2a                	mv	s6,a0
    800030f4:	8bae                	mv	s7,a1
    800030f6:	8a32                	mv	s4,a2
    800030f8:	84b6                	mv	s1,a3
    800030fa:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800030fc:	9f35                	addw	a4,a4,a3
    return 0;
    800030fe:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003100:	0cd76a63          	bltu	a4,a3,800031d4 <readi+0xfa>
    80003104:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003106:	00e7f463          	bgeu	a5,a4,8000310e <readi+0x34>
    n = ip->size - off;
    8000310a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000310e:	0a0a8963          	beqz	s5,800031c0 <readi+0xe6>
    80003112:	e8ca                	sd	s2,80(sp)
    80003114:	f062                	sd	s8,32(sp)
    80003116:	ec66                	sd	s9,24(sp)
    80003118:	e86a                	sd	s10,16(sp)
    8000311a:	e46e                	sd	s11,8(sp)
    8000311c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000311e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003122:	5c7d                	li	s8,-1
    80003124:	a82d                	j	8000315e <readi+0x84>
    80003126:	020d1d93          	sll	s11,s10,0x20
    8000312a:	020ddd93          	srl	s11,s11,0x20
    8000312e:	05890613          	add	a2,s2,88
    80003132:	86ee                	mv	a3,s11
    80003134:	963a                	add	a2,a2,a4
    80003136:	85d2                	mv	a1,s4
    80003138:	855e                	mv	a0,s7
    8000313a:	fffff097          	auipc	ra,0xfffff
    8000313e:	8d4080e7          	jalr	-1836(ra) # 80001a0e <either_copyout>
    80003142:	05850d63          	beq	a0,s8,8000319c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003146:	854a                	mv	a0,s2
    80003148:	fffff097          	auipc	ra,0xfffff
    8000314c:	5d6080e7          	jalr	1494(ra) # 8000271e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003150:	013d09bb          	addw	s3,s10,s3
    80003154:	009d04bb          	addw	s1,s10,s1
    80003158:	9a6e                	add	s4,s4,s11
    8000315a:	0559fd63          	bgeu	s3,s5,800031b4 <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    8000315e:	00a4d59b          	srlw	a1,s1,0xa
    80003162:	855a                	mv	a0,s6
    80003164:	00000097          	auipc	ra,0x0
    80003168:	88e080e7          	jalr	-1906(ra) # 800029f2 <bmap>
    8000316c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003170:	c9b1                	beqz	a1,800031c4 <readi+0xea>
    bp = bread(ip->dev, addr);
    80003172:	000b2503          	lw	a0,0(s6)
    80003176:	fffff097          	auipc	ra,0xfffff
    8000317a:	478080e7          	jalr	1144(ra) # 800025ee <bread>
    8000317e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003180:	3ff4f713          	and	a4,s1,1023
    80003184:	40ec87bb          	subw	a5,s9,a4
    80003188:	413a86bb          	subw	a3,s5,s3
    8000318c:	8d3e                	mv	s10,a5
    8000318e:	2781                	sext.w	a5,a5
    80003190:	0006861b          	sext.w	a2,a3
    80003194:	f8f679e3          	bgeu	a2,a5,80003126 <readi+0x4c>
    80003198:	8d36                	mv	s10,a3
    8000319a:	b771                	j	80003126 <readi+0x4c>
      brelse(bp);
    8000319c:	854a                	mv	a0,s2
    8000319e:	fffff097          	auipc	ra,0xfffff
    800031a2:	580080e7          	jalr	1408(ra) # 8000271e <brelse>
      tot = -1;
    800031a6:	59fd                	li	s3,-1
      break;
    800031a8:	6946                	ld	s2,80(sp)
    800031aa:	7c02                	ld	s8,32(sp)
    800031ac:	6ce2                	ld	s9,24(sp)
    800031ae:	6d42                	ld	s10,16(sp)
    800031b0:	6da2                	ld	s11,8(sp)
    800031b2:	a831                	j	800031ce <readi+0xf4>
    800031b4:	6946                	ld	s2,80(sp)
    800031b6:	7c02                	ld	s8,32(sp)
    800031b8:	6ce2                	ld	s9,24(sp)
    800031ba:	6d42                	ld	s10,16(sp)
    800031bc:	6da2                	ld	s11,8(sp)
    800031be:	a801                	j	800031ce <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800031c0:	89d6                	mv	s3,s5
    800031c2:	a031                	j	800031ce <readi+0xf4>
    800031c4:	6946                	ld	s2,80(sp)
    800031c6:	7c02                	ld	s8,32(sp)
    800031c8:	6ce2                	ld	s9,24(sp)
    800031ca:	6d42                	ld	s10,16(sp)
    800031cc:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800031ce:	0009851b          	sext.w	a0,s3
    800031d2:	69a6                	ld	s3,72(sp)
}
    800031d4:	70a6                	ld	ra,104(sp)
    800031d6:	7406                	ld	s0,96(sp)
    800031d8:	64e6                	ld	s1,88(sp)
    800031da:	6a06                	ld	s4,64(sp)
    800031dc:	7ae2                	ld	s5,56(sp)
    800031de:	7b42                	ld	s6,48(sp)
    800031e0:	7ba2                	ld	s7,40(sp)
    800031e2:	6165                	add	sp,sp,112
    800031e4:	8082                	ret
    return 0;
    800031e6:	4501                	li	a0,0
}
    800031e8:	8082                	ret

00000000800031ea <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800031ea:	457c                	lw	a5,76(a0)
    800031ec:	10d7ee63          	bltu	a5,a3,80003308 <writei+0x11e>
{
    800031f0:	7159                	add	sp,sp,-112
    800031f2:	f486                	sd	ra,104(sp)
    800031f4:	f0a2                	sd	s0,96(sp)
    800031f6:	e8ca                	sd	s2,80(sp)
    800031f8:	e0d2                	sd	s4,64(sp)
    800031fa:	fc56                	sd	s5,56(sp)
    800031fc:	f85a                	sd	s6,48(sp)
    800031fe:	f45e                	sd	s7,40(sp)
    80003200:	1880                	add	s0,sp,112
    80003202:	8aaa                	mv	s5,a0
    80003204:	8bae                	mv	s7,a1
    80003206:	8a32                	mv	s4,a2
    80003208:	8936                	mv	s2,a3
    8000320a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000320c:	00e687bb          	addw	a5,a3,a4
    80003210:	0ed7ee63          	bltu	a5,a3,8000330c <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003214:	00043737          	lui	a4,0x43
    80003218:	0ef76c63          	bltu	a4,a5,80003310 <writei+0x126>
    8000321c:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000321e:	0c0b0d63          	beqz	s6,800032f8 <writei+0x10e>
    80003222:	eca6                	sd	s1,88(sp)
    80003224:	f062                	sd	s8,32(sp)
    80003226:	ec66                	sd	s9,24(sp)
    80003228:	e86a                	sd	s10,16(sp)
    8000322a:	e46e                	sd	s11,8(sp)
    8000322c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000322e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003232:	5c7d                	li	s8,-1
    80003234:	a091                	j	80003278 <writei+0x8e>
    80003236:	020d1d93          	sll	s11,s10,0x20
    8000323a:	020ddd93          	srl	s11,s11,0x20
    8000323e:	05848513          	add	a0,s1,88
    80003242:	86ee                	mv	a3,s11
    80003244:	8652                	mv	a2,s4
    80003246:	85de                	mv	a1,s7
    80003248:	953a                	add	a0,a0,a4
    8000324a:	fffff097          	auipc	ra,0xfffff
    8000324e:	81a080e7          	jalr	-2022(ra) # 80001a64 <either_copyin>
    80003252:	07850263          	beq	a0,s8,800032b6 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003256:	8526                	mv	a0,s1
    80003258:	00000097          	auipc	ra,0x0
    8000325c:	770080e7          	jalr	1904(ra) # 800039c8 <log_write>
    brelse(bp);
    80003260:	8526                	mv	a0,s1
    80003262:	fffff097          	auipc	ra,0xfffff
    80003266:	4bc080e7          	jalr	1212(ra) # 8000271e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000326a:	013d09bb          	addw	s3,s10,s3
    8000326e:	012d093b          	addw	s2,s10,s2
    80003272:	9a6e                	add	s4,s4,s11
    80003274:	0569f663          	bgeu	s3,s6,800032c0 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003278:	00a9559b          	srlw	a1,s2,0xa
    8000327c:	8556                	mv	a0,s5
    8000327e:	fffff097          	auipc	ra,0xfffff
    80003282:	774080e7          	jalr	1908(ra) # 800029f2 <bmap>
    80003286:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000328a:	c99d                	beqz	a1,800032c0 <writei+0xd6>
    bp = bread(ip->dev, addr);
    8000328c:	000aa503          	lw	a0,0(s5)
    80003290:	fffff097          	auipc	ra,0xfffff
    80003294:	35e080e7          	jalr	862(ra) # 800025ee <bread>
    80003298:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000329a:	3ff97713          	and	a4,s2,1023
    8000329e:	40ec87bb          	subw	a5,s9,a4
    800032a2:	413b06bb          	subw	a3,s6,s3
    800032a6:	8d3e                	mv	s10,a5
    800032a8:	2781                	sext.w	a5,a5
    800032aa:	0006861b          	sext.w	a2,a3
    800032ae:	f8f674e3          	bgeu	a2,a5,80003236 <writei+0x4c>
    800032b2:	8d36                	mv	s10,a3
    800032b4:	b749                	j	80003236 <writei+0x4c>
      brelse(bp);
    800032b6:	8526                	mv	a0,s1
    800032b8:	fffff097          	auipc	ra,0xfffff
    800032bc:	466080e7          	jalr	1126(ra) # 8000271e <brelse>
  }

  if(off > ip->size)
    800032c0:	04caa783          	lw	a5,76(s5)
    800032c4:	0327fc63          	bgeu	a5,s2,800032fc <writei+0x112>
    ip->size = off;
    800032c8:	052aa623          	sw	s2,76(s5)
    800032cc:	64e6                	ld	s1,88(sp)
    800032ce:	7c02                	ld	s8,32(sp)
    800032d0:	6ce2                	ld	s9,24(sp)
    800032d2:	6d42                	ld	s10,16(sp)
    800032d4:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800032d6:	8556                	mv	a0,s5
    800032d8:	00000097          	auipc	ra,0x0
    800032dc:	a7e080e7          	jalr	-1410(ra) # 80002d56 <iupdate>

  return tot;
    800032e0:	0009851b          	sext.w	a0,s3
    800032e4:	69a6                	ld	s3,72(sp)
}
    800032e6:	70a6                	ld	ra,104(sp)
    800032e8:	7406                	ld	s0,96(sp)
    800032ea:	6946                	ld	s2,80(sp)
    800032ec:	6a06                	ld	s4,64(sp)
    800032ee:	7ae2                	ld	s5,56(sp)
    800032f0:	7b42                	ld	s6,48(sp)
    800032f2:	7ba2                	ld	s7,40(sp)
    800032f4:	6165                	add	sp,sp,112
    800032f6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800032f8:	89da                	mv	s3,s6
    800032fa:	bff1                	j	800032d6 <writei+0xec>
    800032fc:	64e6                	ld	s1,88(sp)
    800032fe:	7c02                	ld	s8,32(sp)
    80003300:	6ce2                	ld	s9,24(sp)
    80003302:	6d42                	ld	s10,16(sp)
    80003304:	6da2                	ld	s11,8(sp)
    80003306:	bfc1                	j	800032d6 <writei+0xec>
    return -1;
    80003308:	557d                	li	a0,-1
}
    8000330a:	8082                	ret
    return -1;
    8000330c:	557d                	li	a0,-1
    8000330e:	bfe1                	j	800032e6 <writei+0xfc>
    return -1;
    80003310:	557d                	li	a0,-1
    80003312:	bfd1                	j	800032e6 <writei+0xfc>

0000000080003314 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003314:	1141                	add	sp,sp,-16
    80003316:	e406                	sd	ra,8(sp)
    80003318:	e022                	sd	s0,0(sp)
    8000331a:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000331c:	4639                	li	a2,14
    8000331e:	ffffd097          	auipc	ra,0xffffd
    80003322:	f76080e7          	jalr	-138(ra) # 80000294 <strncmp>
}
    80003326:	60a2                	ld	ra,8(sp)
    80003328:	6402                	ld	s0,0(sp)
    8000332a:	0141                	add	sp,sp,16
    8000332c:	8082                	ret

000000008000332e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000332e:	7139                	add	sp,sp,-64
    80003330:	fc06                	sd	ra,56(sp)
    80003332:	f822                	sd	s0,48(sp)
    80003334:	f426                	sd	s1,40(sp)
    80003336:	f04a                	sd	s2,32(sp)
    80003338:	ec4e                	sd	s3,24(sp)
    8000333a:	e852                	sd	s4,16(sp)
    8000333c:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000333e:	04451703          	lh	a4,68(a0)
    80003342:	4785                	li	a5,1
    80003344:	00f71a63          	bne	a4,a5,80003358 <dirlookup+0x2a>
    80003348:	892a                	mv	s2,a0
    8000334a:	89ae                	mv	s3,a1
    8000334c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000334e:	457c                	lw	a5,76(a0)
    80003350:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003352:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003354:	e79d                	bnez	a5,80003382 <dirlookup+0x54>
    80003356:	a8a5                	j	800033ce <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003358:	00005517          	auipc	a0,0x5
    8000335c:	23050513          	add	a0,a0,560 # 80008588 <etext+0x588>
    80003360:	00003097          	auipc	ra,0x3
    80003364:	c92080e7          	jalr	-878(ra) # 80005ff2 <panic>
      panic("dirlookup read");
    80003368:	00005517          	auipc	a0,0x5
    8000336c:	23850513          	add	a0,a0,568 # 800085a0 <etext+0x5a0>
    80003370:	00003097          	auipc	ra,0x3
    80003374:	c82080e7          	jalr	-894(ra) # 80005ff2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003378:	24c1                	addw	s1,s1,16
    8000337a:	04c92783          	lw	a5,76(s2)
    8000337e:	04f4f763          	bgeu	s1,a5,800033cc <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003382:	4741                	li	a4,16
    80003384:	86a6                	mv	a3,s1
    80003386:	fc040613          	add	a2,s0,-64
    8000338a:	4581                	li	a1,0
    8000338c:	854a                	mv	a0,s2
    8000338e:	00000097          	auipc	ra,0x0
    80003392:	d4c080e7          	jalr	-692(ra) # 800030da <readi>
    80003396:	47c1                	li	a5,16
    80003398:	fcf518e3          	bne	a0,a5,80003368 <dirlookup+0x3a>
    if(de.inum == 0)
    8000339c:	fc045783          	lhu	a5,-64(s0)
    800033a0:	dfe1                	beqz	a5,80003378 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800033a2:	fc240593          	add	a1,s0,-62
    800033a6:	854e                	mv	a0,s3
    800033a8:	00000097          	auipc	ra,0x0
    800033ac:	f6c080e7          	jalr	-148(ra) # 80003314 <namecmp>
    800033b0:	f561                	bnez	a0,80003378 <dirlookup+0x4a>
      if(poff)
    800033b2:	000a0463          	beqz	s4,800033ba <dirlookup+0x8c>
        *poff = off;
    800033b6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800033ba:	fc045583          	lhu	a1,-64(s0)
    800033be:	00092503          	lw	a0,0(s2)
    800033c2:	fffff097          	auipc	ra,0xfffff
    800033c6:	720080e7          	jalr	1824(ra) # 80002ae2 <iget>
    800033ca:	a011                	j	800033ce <dirlookup+0xa0>
  return 0;
    800033cc:	4501                	li	a0,0
}
    800033ce:	70e2                	ld	ra,56(sp)
    800033d0:	7442                	ld	s0,48(sp)
    800033d2:	74a2                	ld	s1,40(sp)
    800033d4:	7902                	ld	s2,32(sp)
    800033d6:	69e2                	ld	s3,24(sp)
    800033d8:	6a42                	ld	s4,16(sp)
    800033da:	6121                	add	sp,sp,64
    800033dc:	8082                	ret

00000000800033de <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800033de:	711d                	add	sp,sp,-96
    800033e0:	ec86                	sd	ra,88(sp)
    800033e2:	e8a2                	sd	s0,80(sp)
    800033e4:	e4a6                	sd	s1,72(sp)
    800033e6:	e0ca                	sd	s2,64(sp)
    800033e8:	fc4e                	sd	s3,56(sp)
    800033ea:	f852                	sd	s4,48(sp)
    800033ec:	f456                	sd	s5,40(sp)
    800033ee:	f05a                	sd	s6,32(sp)
    800033f0:	ec5e                	sd	s7,24(sp)
    800033f2:	e862                	sd	s8,16(sp)
    800033f4:	e466                	sd	s9,8(sp)
    800033f6:	1080                	add	s0,sp,96
    800033f8:	84aa                	mv	s1,a0
    800033fa:	8b2e                	mv	s6,a1
    800033fc:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800033fe:	00054703          	lbu	a4,0(a0)
    80003402:	02f00793          	li	a5,47
    80003406:	02f70263          	beq	a4,a5,8000342a <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000340a:	ffffe097          	auipc	ra,0xffffe
    8000340e:	b46080e7          	jalr	-1210(ra) # 80000f50 <myproc>
    80003412:	15053503          	ld	a0,336(a0)
    80003416:	00000097          	auipc	ra,0x0
    8000341a:	9ce080e7          	jalr	-1586(ra) # 80002de4 <idup>
    8000341e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003420:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003424:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003426:	4b85                	li	s7,1
    80003428:	a875                	j	800034e4 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000342a:	4585                	li	a1,1
    8000342c:	4505                	li	a0,1
    8000342e:	fffff097          	auipc	ra,0xfffff
    80003432:	6b4080e7          	jalr	1716(ra) # 80002ae2 <iget>
    80003436:	8a2a                	mv	s4,a0
    80003438:	b7e5                	j	80003420 <namex+0x42>
      iunlockput(ip);
    8000343a:	8552                	mv	a0,s4
    8000343c:	00000097          	auipc	ra,0x0
    80003440:	c4c080e7          	jalr	-948(ra) # 80003088 <iunlockput>
      return 0;
    80003444:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003446:	8552                	mv	a0,s4
    80003448:	60e6                	ld	ra,88(sp)
    8000344a:	6446                	ld	s0,80(sp)
    8000344c:	64a6                	ld	s1,72(sp)
    8000344e:	6906                	ld	s2,64(sp)
    80003450:	79e2                	ld	s3,56(sp)
    80003452:	7a42                	ld	s4,48(sp)
    80003454:	7aa2                	ld	s5,40(sp)
    80003456:	7b02                	ld	s6,32(sp)
    80003458:	6be2                	ld	s7,24(sp)
    8000345a:	6c42                	ld	s8,16(sp)
    8000345c:	6ca2                	ld	s9,8(sp)
    8000345e:	6125                	add	sp,sp,96
    80003460:	8082                	ret
      iunlock(ip);
    80003462:	8552                	mv	a0,s4
    80003464:	00000097          	auipc	ra,0x0
    80003468:	a84080e7          	jalr	-1404(ra) # 80002ee8 <iunlock>
      return ip;
    8000346c:	bfe9                	j	80003446 <namex+0x68>
      iunlockput(ip);
    8000346e:	8552                	mv	a0,s4
    80003470:	00000097          	auipc	ra,0x0
    80003474:	c18080e7          	jalr	-1000(ra) # 80003088 <iunlockput>
      return 0;
    80003478:	8a4e                	mv	s4,s3
    8000347a:	b7f1                	j	80003446 <namex+0x68>
  len = path - s;
    8000347c:	40998633          	sub	a2,s3,s1
    80003480:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003484:	099c5863          	bge	s8,s9,80003514 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003488:	4639                	li	a2,14
    8000348a:	85a6                	mv	a1,s1
    8000348c:	8556                	mv	a0,s5
    8000348e:	ffffd097          	auipc	ra,0xffffd
    80003492:	d92080e7          	jalr	-622(ra) # 80000220 <memmove>
    80003496:	84ce                	mv	s1,s3
  while(*path == '/')
    80003498:	0004c783          	lbu	a5,0(s1)
    8000349c:	01279763          	bne	a5,s2,800034aa <namex+0xcc>
    path++;
    800034a0:	0485                	add	s1,s1,1
  while(*path == '/')
    800034a2:	0004c783          	lbu	a5,0(s1)
    800034a6:	ff278de3          	beq	a5,s2,800034a0 <namex+0xc2>
    ilock(ip);
    800034aa:	8552                	mv	a0,s4
    800034ac:	00000097          	auipc	ra,0x0
    800034b0:	976080e7          	jalr	-1674(ra) # 80002e22 <ilock>
    if(ip->type != T_DIR){
    800034b4:	044a1783          	lh	a5,68(s4)
    800034b8:	f97791e3          	bne	a5,s7,8000343a <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800034bc:	000b0563          	beqz	s6,800034c6 <namex+0xe8>
    800034c0:	0004c783          	lbu	a5,0(s1)
    800034c4:	dfd9                	beqz	a5,80003462 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800034c6:	4601                	li	a2,0
    800034c8:	85d6                	mv	a1,s5
    800034ca:	8552                	mv	a0,s4
    800034cc:	00000097          	auipc	ra,0x0
    800034d0:	e62080e7          	jalr	-414(ra) # 8000332e <dirlookup>
    800034d4:	89aa                	mv	s3,a0
    800034d6:	dd41                	beqz	a0,8000346e <namex+0x90>
    iunlockput(ip);
    800034d8:	8552                	mv	a0,s4
    800034da:	00000097          	auipc	ra,0x0
    800034de:	bae080e7          	jalr	-1106(ra) # 80003088 <iunlockput>
    ip = next;
    800034e2:	8a4e                	mv	s4,s3
  while(*path == '/')
    800034e4:	0004c783          	lbu	a5,0(s1)
    800034e8:	01279763          	bne	a5,s2,800034f6 <namex+0x118>
    path++;
    800034ec:	0485                	add	s1,s1,1
  while(*path == '/')
    800034ee:	0004c783          	lbu	a5,0(s1)
    800034f2:	ff278de3          	beq	a5,s2,800034ec <namex+0x10e>
  if(*path == 0)
    800034f6:	cb9d                	beqz	a5,8000352c <namex+0x14e>
  while(*path != '/' && *path != 0)
    800034f8:	0004c783          	lbu	a5,0(s1)
    800034fc:	89a6                	mv	s3,s1
  len = path - s;
    800034fe:	4c81                	li	s9,0
    80003500:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003502:	01278963          	beq	a5,s2,80003514 <namex+0x136>
    80003506:	dbbd                	beqz	a5,8000347c <namex+0x9e>
    path++;
    80003508:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    8000350a:	0009c783          	lbu	a5,0(s3)
    8000350e:	ff279ce3          	bne	a5,s2,80003506 <namex+0x128>
    80003512:	b7ad                	j	8000347c <namex+0x9e>
    memmove(name, s, len);
    80003514:	2601                	sext.w	a2,a2
    80003516:	85a6                	mv	a1,s1
    80003518:	8556                	mv	a0,s5
    8000351a:	ffffd097          	auipc	ra,0xffffd
    8000351e:	d06080e7          	jalr	-762(ra) # 80000220 <memmove>
    name[len] = 0;
    80003522:	9cd6                	add	s9,s9,s5
    80003524:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003528:	84ce                	mv	s1,s3
    8000352a:	b7bd                	j	80003498 <namex+0xba>
  if(nameiparent){
    8000352c:	f00b0de3          	beqz	s6,80003446 <namex+0x68>
    iput(ip);
    80003530:	8552                	mv	a0,s4
    80003532:	00000097          	auipc	ra,0x0
    80003536:	aae080e7          	jalr	-1362(ra) # 80002fe0 <iput>
    return 0;
    8000353a:	4a01                	li	s4,0
    8000353c:	b729                	j	80003446 <namex+0x68>

000000008000353e <dirlink>:
{
    8000353e:	7139                	add	sp,sp,-64
    80003540:	fc06                	sd	ra,56(sp)
    80003542:	f822                	sd	s0,48(sp)
    80003544:	f04a                	sd	s2,32(sp)
    80003546:	ec4e                	sd	s3,24(sp)
    80003548:	e852                	sd	s4,16(sp)
    8000354a:	0080                	add	s0,sp,64
    8000354c:	892a                	mv	s2,a0
    8000354e:	8a2e                	mv	s4,a1
    80003550:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003552:	4601                	li	a2,0
    80003554:	00000097          	auipc	ra,0x0
    80003558:	dda080e7          	jalr	-550(ra) # 8000332e <dirlookup>
    8000355c:	ed25                	bnez	a0,800035d4 <dirlink+0x96>
    8000355e:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003560:	04c92483          	lw	s1,76(s2)
    80003564:	c49d                	beqz	s1,80003592 <dirlink+0x54>
    80003566:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003568:	4741                	li	a4,16
    8000356a:	86a6                	mv	a3,s1
    8000356c:	fc040613          	add	a2,s0,-64
    80003570:	4581                	li	a1,0
    80003572:	854a                	mv	a0,s2
    80003574:	00000097          	auipc	ra,0x0
    80003578:	b66080e7          	jalr	-1178(ra) # 800030da <readi>
    8000357c:	47c1                	li	a5,16
    8000357e:	06f51163          	bne	a0,a5,800035e0 <dirlink+0xa2>
    if(de.inum == 0)
    80003582:	fc045783          	lhu	a5,-64(s0)
    80003586:	c791                	beqz	a5,80003592 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003588:	24c1                	addw	s1,s1,16
    8000358a:	04c92783          	lw	a5,76(s2)
    8000358e:	fcf4ede3          	bltu	s1,a5,80003568 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003592:	4639                	li	a2,14
    80003594:	85d2                	mv	a1,s4
    80003596:	fc240513          	add	a0,s0,-62
    8000359a:	ffffd097          	auipc	ra,0xffffd
    8000359e:	d30080e7          	jalr	-720(ra) # 800002ca <strncpy>
  de.inum = inum;
    800035a2:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035a6:	4741                	li	a4,16
    800035a8:	86a6                	mv	a3,s1
    800035aa:	fc040613          	add	a2,s0,-64
    800035ae:	4581                	li	a1,0
    800035b0:	854a                	mv	a0,s2
    800035b2:	00000097          	auipc	ra,0x0
    800035b6:	c38080e7          	jalr	-968(ra) # 800031ea <writei>
    800035ba:	1541                	add	a0,a0,-16
    800035bc:	00a03533          	snez	a0,a0
    800035c0:	40a00533          	neg	a0,a0
    800035c4:	74a2                	ld	s1,40(sp)
}
    800035c6:	70e2                	ld	ra,56(sp)
    800035c8:	7442                	ld	s0,48(sp)
    800035ca:	7902                	ld	s2,32(sp)
    800035cc:	69e2                	ld	s3,24(sp)
    800035ce:	6a42                	ld	s4,16(sp)
    800035d0:	6121                	add	sp,sp,64
    800035d2:	8082                	ret
    iput(ip);
    800035d4:	00000097          	auipc	ra,0x0
    800035d8:	a0c080e7          	jalr	-1524(ra) # 80002fe0 <iput>
    return -1;
    800035dc:	557d                	li	a0,-1
    800035de:	b7e5                	j	800035c6 <dirlink+0x88>
      panic("dirlink read");
    800035e0:	00005517          	auipc	a0,0x5
    800035e4:	fd050513          	add	a0,a0,-48 # 800085b0 <etext+0x5b0>
    800035e8:	00003097          	auipc	ra,0x3
    800035ec:	a0a080e7          	jalr	-1526(ra) # 80005ff2 <panic>

00000000800035f0 <namei>:

struct inode*
namei(char *path)
{
    800035f0:	1101                	add	sp,sp,-32
    800035f2:	ec06                	sd	ra,24(sp)
    800035f4:	e822                	sd	s0,16(sp)
    800035f6:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800035f8:	fe040613          	add	a2,s0,-32
    800035fc:	4581                	li	a1,0
    800035fe:	00000097          	auipc	ra,0x0
    80003602:	de0080e7          	jalr	-544(ra) # 800033de <namex>
}
    80003606:	60e2                	ld	ra,24(sp)
    80003608:	6442                	ld	s0,16(sp)
    8000360a:	6105                	add	sp,sp,32
    8000360c:	8082                	ret

000000008000360e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000360e:	1141                	add	sp,sp,-16
    80003610:	e406                	sd	ra,8(sp)
    80003612:	e022                	sd	s0,0(sp)
    80003614:	0800                	add	s0,sp,16
    80003616:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003618:	4585                	li	a1,1
    8000361a:	00000097          	auipc	ra,0x0
    8000361e:	dc4080e7          	jalr	-572(ra) # 800033de <namex>
}
    80003622:	60a2                	ld	ra,8(sp)
    80003624:	6402                	ld	s0,0(sp)
    80003626:	0141                	add	sp,sp,16
    80003628:	8082                	ret

000000008000362a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000362a:	1101                	add	sp,sp,-32
    8000362c:	ec06                	sd	ra,24(sp)
    8000362e:	e822                	sd	s0,16(sp)
    80003630:	e426                	sd	s1,8(sp)
    80003632:	e04a                	sd	s2,0(sp)
    80003634:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003636:	00018917          	auipc	s2,0x18
    8000363a:	dda90913          	add	s2,s2,-550 # 8001b410 <log>
    8000363e:	01892583          	lw	a1,24(s2)
    80003642:	02892503          	lw	a0,40(s2)
    80003646:	fffff097          	auipc	ra,0xfffff
    8000364a:	fa8080e7          	jalr	-88(ra) # 800025ee <bread>
    8000364e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003650:	02c92603          	lw	a2,44(s2)
    80003654:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003656:	00c05f63          	blez	a2,80003674 <write_head+0x4a>
    8000365a:	00018717          	auipc	a4,0x18
    8000365e:	de670713          	add	a4,a4,-538 # 8001b440 <log+0x30>
    80003662:	87aa                	mv	a5,a0
    80003664:	060a                	sll	a2,a2,0x2
    80003666:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003668:	4314                	lw	a3,0(a4)
    8000366a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000366c:	0711                	add	a4,a4,4
    8000366e:	0791                	add	a5,a5,4
    80003670:	fec79ce3          	bne	a5,a2,80003668 <write_head+0x3e>
  }
  bwrite(buf);
    80003674:	8526                	mv	a0,s1
    80003676:	fffff097          	auipc	ra,0xfffff
    8000367a:	06a080e7          	jalr	106(ra) # 800026e0 <bwrite>
  brelse(buf);
    8000367e:	8526                	mv	a0,s1
    80003680:	fffff097          	auipc	ra,0xfffff
    80003684:	09e080e7          	jalr	158(ra) # 8000271e <brelse>
}
    80003688:	60e2                	ld	ra,24(sp)
    8000368a:	6442                	ld	s0,16(sp)
    8000368c:	64a2                	ld	s1,8(sp)
    8000368e:	6902                	ld	s2,0(sp)
    80003690:	6105                	add	sp,sp,32
    80003692:	8082                	ret

0000000080003694 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003694:	00018797          	auipc	a5,0x18
    80003698:	da87a783          	lw	a5,-600(a5) # 8001b43c <log+0x2c>
    8000369c:	0af05d63          	blez	a5,80003756 <install_trans+0xc2>
{
    800036a0:	7139                	add	sp,sp,-64
    800036a2:	fc06                	sd	ra,56(sp)
    800036a4:	f822                	sd	s0,48(sp)
    800036a6:	f426                	sd	s1,40(sp)
    800036a8:	f04a                	sd	s2,32(sp)
    800036aa:	ec4e                	sd	s3,24(sp)
    800036ac:	e852                	sd	s4,16(sp)
    800036ae:	e456                	sd	s5,8(sp)
    800036b0:	e05a                	sd	s6,0(sp)
    800036b2:	0080                	add	s0,sp,64
    800036b4:	8b2a                	mv	s6,a0
    800036b6:	00018a97          	auipc	s5,0x18
    800036ba:	d8aa8a93          	add	s5,s5,-630 # 8001b440 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036be:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036c0:	00018997          	auipc	s3,0x18
    800036c4:	d5098993          	add	s3,s3,-688 # 8001b410 <log>
    800036c8:	a00d                	j	800036ea <install_trans+0x56>
    brelse(lbuf);
    800036ca:	854a                	mv	a0,s2
    800036cc:	fffff097          	auipc	ra,0xfffff
    800036d0:	052080e7          	jalr	82(ra) # 8000271e <brelse>
    brelse(dbuf);
    800036d4:	8526                	mv	a0,s1
    800036d6:	fffff097          	auipc	ra,0xfffff
    800036da:	048080e7          	jalr	72(ra) # 8000271e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036de:	2a05                	addw	s4,s4,1
    800036e0:	0a91                	add	s5,s5,4
    800036e2:	02c9a783          	lw	a5,44(s3)
    800036e6:	04fa5e63          	bge	s4,a5,80003742 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036ea:	0189a583          	lw	a1,24(s3)
    800036ee:	014585bb          	addw	a1,a1,s4
    800036f2:	2585                	addw	a1,a1,1
    800036f4:	0289a503          	lw	a0,40(s3)
    800036f8:	fffff097          	auipc	ra,0xfffff
    800036fc:	ef6080e7          	jalr	-266(ra) # 800025ee <bread>
    80003700:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003702:	000aa583          	lw	a1,0(s5)
    80003706:	0289a503          	lw	a0,40(s3)
    8000370a:	fffff097          	auipc	ra,0xfffff
    8000370e:	ee4080e7          	jalr	-284(ra) # 800025ee <bread>
    80003712:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003714:	40000613          	li	a2,1024
    80003718:	05890593          	add	a1,s2,88
    8000371c:	05850513          	add	a0,a0,88
    80003720:	ffffd097          	auipc	ra,0xffffd
    80003724:	b00080e7          	jalr	-1280(ra) # 80000220 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003728:	8526                	mv	a0,s1
    8000372a:	fffff097          	auipc	ra,0xfffff
    8000372e:	fb6080e7          	jalr	-74(ra) # 800026e0 <bwrite>
    if(recovering == 0)
    80003732:	f80b1ce3          	bnez	s6,800036ca <install_trans+0x36>
      bunpin(dbuf);
    80003736:	8526                	mv	a0,s1
    80003738:	fffff097          	auipc	ra,0xfffff
    8000373c:	0be080e7          	jalr	190(ra) # 800027f6 <bunpin>
    80003740:	b769                	j	800036ca <install_trans+0x36>
}
    80003742:	70e2                	ld	ra,56(sp)
    80003744:	7442                	ld	s0,48(sp)
    80003746:	74a2                	ld	s1,40(sp)
    80003748:	7902                	ld	s2,32(sp)
    8000374a:	69e2                	ld	s3,24(sp)
    8000374c:	6a42                	ld	s4,16(sp)
    8000374e:	6aa2                	ld	s5,8(sp)
    80003750:	6b02                	ld	s6,0(sp)
    80003752:	6121                	add	sp,sp,64
    80003754:	8082                	ret
    80003756:	8082                	ret

0000000080003758 <initlog>:
{
    80003758:	7179                	add	sp,sp,-48
    8000375a:	f406                	sd	ra,40(sp)
    8000375c:	f022                	sd	s0,32(sp)
    8000375e:	ec26                	sd	s1,24(sp)
    80003760:	e84a                	sd	s2,16(sp)
    80003762:	e44e                	sd	s3,8(sp)
    80003764:	1800                	add	s0,sp,48
    80003766:	892a                	mv	s2,a0
    80003768:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000376a:	00018497          	auipc	s1,0x18
    8000376e:	ca648493          	add	s1,s1,-858 # 8001b410 <log>
    80003772:	00005597          	auipc	a1,0x5
    80003776:	e4e58593          	add	a1,a1,-434 # 800085c0 <etext+0x5c0>
    8000377a:	8526                	mv	a0,s1
    8000377c:	00003097          	auipc	ra,0x3
    80003780:	d60080e7          	jalr	-672(ra) # 800064dc <initlock>
  log.start = sb->logstart;
    80003784:	0149a583          	lw	a1,20(s3)
    80003788:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000378a:	0109a783          	lw	a5,16(s3)
    8000378e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003790:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003794:	854a                	mv	a0,s2
    80003796:	fffff097          	auipc	ra,0xfffff
    8000379a:	e58080e7          	jalr	-424(ra) # 800025ee <bread>
  log.lh.n = lh->n;
    8000379e:	4d30                	lw	a2,88(a0)
    800037a0:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800037a2:	00c05f63          	blez	a2,800037c0 <initlog+0x68>
    800037a6:	87aa                	mv	a5,a0
    800037a8:	00018717          	auipc	a4,0x18
    800037ac:	c9870713          	add	a4,a4,-872 # 8001b440 <log+0x30>
    800037b0:	060a                	sll	a2,a2,0x2
    800037b2:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800037b4:	4ff4                	lw	a3,92(a5)
    800037b6:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800037b8:	0791                	add	a5,a5,4
    800037ba:	0711                	add	a4,a4,4
    800037bc:	fec79ce3          	bne	a5,a2,800037b4 <initlog+0x5c>
  brelse(buf);
    800037c0:	fffff097          	auipc	ra,0xfffff
    800037c4:	f5e080e7          	jalr	-162(ra) # 8000271e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800037c8:	4505                	li	a0,1
    800037ca:	00000097          	auipc	ra,0x0
    800037ce:	eca080e7          	jalr	-310(ra) # 80003694 <install_trans>
  log.lh.n = 0;
    800037d2:	00018797          	auipc	a5,0x18
    800037d6:	c607a523          	sw	zero,-918(a5) # 8001b43c <log+0x2c>
  write_head(); // clear the log
    800037da:	00000097          	auipc	ra,0x0
    800037de:	e50080e7          	jalr	-432(ra) # 8000362a <write_head>
}
    800037e2:	70a2                	ld	ra,40(sp)
    800037e4:	7402                	ld	s0,32(sp)
    800037e6:	64e2                	ld	s1,24(sp)
    800037e8:	6942                	ld	s2,16(sp)
    800037ea:	69a2                	ld	s3,8(sp)
    800037ec:	6145                	add	sp,sp,48
    800037ee:	8082                	ret

00000000800037f0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800037f0:	1101                	add	sp,sp,-32
    800037f2:	ec06                	sd	ra,24(sp)
    800037f4:	e822                	sd	s0,16(sp)
    800037f6:	e426                	sd	s1,8(sp)
    800037f8:	e04a                	sd	s2,0(sp)
    800037fa:	1000                	add	s0,sp,32
  acquire(&log.lock);
    800037fc:	00018517          	auipc	a0,0x18
    80003800:	c1450513          	add	a0,a0,-1004 # 8001b410 <log>
    80003804:	00003097          	auipc	ra,0x3
    80003808:	d68080e7          	jalr	-664(ra) # 8000656c <acquire>
  while(1){
    if(log.committing){
    8000380c:	00018497          	auipc	s1,0x18
    80003810:	c0448493          	add	s1,s1,-1020 # 8001b410 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003814:	4979                	li	s2,30
    80003816:	a039                	j	80003824 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003818:	85a6                	mv	a1,s1
    8000381a:	8526                	mv	a0,s1
    8000381c:	ffffe097          	auipc	ra,0xffffe
    80003820:	dea080e7          	jalr	-534(ra) # 80001606 <sleep>
    if(log.committing){
    80003824:	50dc                	lw	a5,36(s1)
    80003826:	fbed                	bnez	a5,80003818 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003828:	5098                	lw	a4,32(s1)
    8000382a:	2705                	addw	a4,a4,1
    8000382c:	0027179b          	sllw	a5,a4,0x2
    80003830:	9fb9                	addw	a5,a5,a4
    80003832:	0017979b          	sllw	a5,a5,0x1
    80003836:	54d4                	lw	a3,44(s1)
    80003838:	9fb5                	addw	a5,a5,a3
    8000383a:	00f95963          	bge	s2,a5,8000384c <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000383e:	85a6                	mv	a1,s1
    80003840:	8526                	mv	a0,s1
    80003842:	ffffe097          	auipc	ra,0xffffe
    80003846:	dc4080e7          	jalr	-572(ra) # 80001606 <sleep>
    8000384a:	bfe9                	j	80003824 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000384c:	00018517          	auipc	a0,0x18
    80003850:	bc450513          	add	a0,a0,-1084 # 8001b410 <log>
    80003854:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003856:	00003097          	auipc	ra,0x3
    8000385a:	dca080e7          	jalr	-566(ra) # 80006620 <release>
      break;
    }
  }
}
    8000385e:	60e2                	ld	ra,24(sp)
    80003860:	6442                	ld	s0,16(sp)
    80003862:	64a2                	ld	s1,8(sp)
    80003864:	6902                	ld	s2,0(sp)
    80003866:	6105                	add	sp,sp,32
    80003868:	8082                	ret

000000008000386a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000386a:	7139                	add	sp,sp,-64
    8000386c:	fc06                	sd	ra,56(sp)
    8000386e:	f822                	sd	s0,48(sp)
    80003870:	f426                	sd	s1,40(sp)
    80003872:	f04a                	sd	s2,32(sp)
    80003874:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003876:	00018497          	auipc	s1,0x18
    8000387a:	b9a48493          	add	s1,s1,-1126 # 8001b410 <log>
    8000387e:	8526                	mv	a0,s1
    80003880:	00003097          	auipc	ra,0x3
    80003884:	cec080e7          	jalr	-788(ra) # 8000656c <acquire>
  log.outstanding -= 1;
    80003888:	509c                	lw	a5,32(s1)
    8000388a:	37fd                	addw	a5,a5,-1
    8000388c:	0007891b          	sext.w	s2,a5
    80003890:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003892:	50dc                	lw	a5,36(s1)
    80003894:	e7b9                	bnez	a5,800038e2 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80003896:	06091163          	bnez	s2,800038f8 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000389a:	00018497          	auipc	s1,0x18
    8000389e:	b7648493          	add	s1,s1,-1162 # 8001b410 <log>
    800038a2:	4785                	li	a5,1
    800038a4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800038a6:	8526                	mv	a0,s1
    800038a8:	00003097          	auipc	ra,0x3
    800038ac:	d78080e7          	jalr	-648(ra) # 80006620 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800038b0:	54dc                	lw	a5,44(s1)
    800038b2:	06f04763          	bgtz	a5,80003920 <end_op+0xb6>
    acquire(&log.lock);
    800038b6:	00018497          	auipc	s1,0x18
    800038ba:	b5a48493          	add	s1,s1,-1190 # 8001b410 <log>
    800038be:	8526                	mv	a0,s1
    800038c0:	00003097          	auipc	ra,0x3
    800038c4:	cac080e7          	jalr	-852(ra) # 8000656c <acquire>
    log.committing = 0;
    800038c8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800038cc:	8526                	mv	a0,s1
    800038ce:	ffffe097          	auipc	ra,0xffffe
    800038d2:	d9c080e7          	jalr	-612(ra) # 8000166a <wakeup>
    release(&log.lock);
    800038d6:	8526                	mv	a0,s1
    800038d8:	00003097          	auipc	ra,0x3
    800038dc:	d48080e7          	jalr	-696(ra) # 80006620 <release>
}
    800038e0:	a815                	j	80003914 <end_op+0xaa>
    800038e2:	ec4e                	sd	s3,24(sp)
    800038e4:	e852                	sd	s4,16(sp)
    800038e6:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800038e8:	00005517          	auipc	a0,0x5
    800038ec:	ce050513          	add	a0,a0,-800 # 800085c8 <etext+0x5c8>
    800038f0:	00002097          	auipc	ra,0x2
    800038f4:	702080e7          	jalr	1794(ra) # 80005ff2 <panic>
    wakeup(&log);
    800038f8:	00018497          	auipc	s1,0x18
    800038fc:	b1848493          	add	s1,s1,-1256 # 8001b410 <log>
    80003900:	8526                	mv	a0,s1
    80003902:	ffffe097          	auipc	ra,0xffffe
    80003906:	d68080e7          	jalr	-664(ra) # 8000166a <wakeup>
  release(&log.lock);
    8000390a:	8526                	mv	a0,s1
    8000390c:	00003097          	auipc	ra,0x3
    80003910:	d14080e7          	jalr	-748(ra) # 80006620 <release>
}
    80003914:	70e2                	ld	ra,56(sp)
    80003916:	7442                	ld	s0,48(sp)
    80003918:	74a2                	ld	s1,40(sp)
    8000391a:	7902                	ld	s2,32(sp)
    8000391c:	6121                	add	sp,sp,64
    8000391e:	8082                	ret
    80003920:	ec4e                	sd	s3,24(sp)
    80003922:	e852                	sd	s4,16(sp)
    80003924:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003926:	00018a97          	auipc	s5,0x18
    8000392a:	b1aa8a93          	add	s5,s5,-1254 # 8001b440 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000392e:	00018a17          	auipc	s4,0x18
    80003932:	ae2a0a13          	add	s4,s4,-1310 # 8001b410 <log>
    80003936:	018a2583          	lw	a1,24(s4)
    8000393a:	012585bb          	addw	a1,a1,s2
    8000393e:	2585                	addw	a1,a1,1
    80003940:	028a2503          	lw	a0,40(s4)
    80003944:	fffff097          	auipc	ra,0xfffff
    80003948:	caa080e7          	jalr	-854(ra) # 800025ee <bread>
    8000394c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000394e:	000aa583          	lw	a1,0(s5)
    80003952:	028a2503          	lw	a0,40(s4)
    80003956:	fffff097          	auipc	ra,0xfffff
    8000395a:	c98080e7          	jalr	-872(ra) # 800025ee <bread>
    8000395e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003960:	40000613          	li	a2,1024
    80003964:	05850593          	add	a1,a0,88
    80003968:	05848513          	add	a0,s1,88
    8000396c:	ffffd097          	auipc	ra,0xffffd
    80003970:	8b4080e7          	jalr	-1868(ra) # 80000220 <memmove>
    bwrite(to);  // write the log
    80003974:	8526                	mv	a0,s1
    80003976:	fffff097          	auipc	ra,0xfffff
    8000397a:	d6a080e7          	jalr	-662(ra) # 800026e0 <bwrite>
    brelse(from);
    8000397e:	854e                	mv	a0,s3
    80003980:	fffff097          	auipc	ra,0xfffff
    80003984:	d9e080e7          	jalr	-610(ra) # 8000271e <brelse>
    brelse(to);
    80003988:	8526                	mv	a0,s1
    8000398a:	fffff097          	auipc	ra,0xfffff
    8000398e:	d94080e7          	jalr	-620(ra) # 8000271e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003992:	2905                	addw	s2,s2,1
    80003994:	0a91                	add	s5,s5,4
    80003996:	02ca2783          	lw	a5,44(s4)
    8000399a:	f8f94ee3          	blt	s2,a5,80003936 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000399e:	00000097          	auipc	ra,0x0
    800039a2:	c8c080e7          	jalr	-884(ra) # 8000362a <write_head>
    install_trans(0); // Now install writes to home locations
    800039a6:	4501                	li	a0,0
    800039a8:	00000097          	auipc	ra,0x0
    800039ac:	cec080e7          	jalr	-788(ra) # 80003694 <install_trans>
    log.lh.n = 0;
    800039b0:	00018797          	auipc	a5,0x18
    800039b4:	a807a623          	sw	zero,-1396(a5) # 8001b43c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800039b8:	00000097          	auipc	ra,0x0
    800039bc:	c72080e7          	jalr	-910(ra) # 8000362a <write_head>
    800039c0:	69e2                	ld	s3,24(sp)
    800039c2:	6a42                	ld	s4,16(sp)
    800039c4:	6aa2                	ld	s5,8(sp)
    800039c6:	bdc5                	j	800038b6 <end_op+0x4c>

00000000800039c8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800039c8:	1101                	add	sp,sp,-32
    800039ca:	ec06                	sd	ra,24(sp)
    800039cc:	e822                	sd	s0,16(sp)
    800039ce:	e426                	sd	s1,8(sp)
    800039d0:	e04a                	sd	s2,0(sp)
    800039d2:	1000                	add	s0,sp,32
    800039d4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800039d6:	00018917          	auipc	s2,0x18
    800039da:	a3a90913          	add	s2,s2,-1478 # 8001b410 <log>
    800039de:	854a                	mv	a0,s2
    800039e0:	00003097          	auipc	ra,0x3
    800039e4:	b8c080e7          	jalr	-1140(ra) # 8000656c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800039e8:	02c92603          	lw	a2,44(s2)
    800039ec:	47f5                	li	a5,29
    800039ee:	06c7c563          	blt	a5,a2,80003a58 <log_write+0x90>
    800039f2:	00018797          	auipc	a5,0x18
    800039f6:	a3a7a783          	lw	a5,-1478(a5) # 8001b42c <log+0x1c>
    800039fa:	37fd                	addw	a5,a5,-1
    800039fc:	04f65e63          	bge	a2,a5,80003a58 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003a00:	00018797          	auipc	a5,0x18
    80003a04:	a307a783          	lw	a5,-1488(a5) # 8001b430 <log+0x20>
    80003a08:	06f05063          	blez	a5,80003a68 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003a0c:	4781                	li	a5,0
    80003a0e:	06c05563          	blez	a2,80003a78 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a12:	44cc                	lw	a1,12(s1)
    80003a14:	00018717          	auipc	a4,0x18
    80003a18:	a2c70713          	add	a4,a4,-1492 # 8001b440 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003a1c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a1e:	4314                	lw	a3,0(a4)
    80003a20:	04b68c63          	beq	a3,a1,80003a78 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003a24:	2785                	addw	a5,a5,1
    80003a26:	0711                	add	a4,a4,4
    80003a28:	fef61be3          	bne	a2,a5,80003a1e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003a2c:	0621                	add	a2,a2,8
    80003a2e:	060a                	sll	a2,a2,0x2
    80003a30:	00018797          	auipc	a5,0x18
    80003a34:	9e078793          	add	a5,a5,-1568 # 8001b410 <log>
    80003a38:	97b2                	add	a5,a5,a2
    80003a3a:	44d8                	lw	a4,12(s1)
    80003a3c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003a3e:	8526                	mv	a0,s1
    80003a40:	fffff097          	auipc	ra,0xfffff
    80003a44:	d7a080e7          	jalr	-646(ra) # 800027ba <bpin>
    log.lh.n++;
    80003a48:	00018717          	auipc	a4,0x18
    80003a4c:	9c870713          	add	a4,a4,-1592 # 8001b410 <log>
    80003a50:	575c                	lw	a5,44(a4)
    80003a52:	2785                	addw	a5,a5,1
    80003a54:	d75c                	sw	a5,44(a4)
    80003a56:	a82d                	j	80003a90 <log_write+0xc8>
    panic("too big a transaction");
    80003a58:	00005517          	auipc	a0,0x5
    80003a5c:	b8050513          	add	a0,a0,-1152 # 800085d8 <etext+0x5d8>
    80003a60:	00002097          	auipc	ra,0x2
    80003a64:	592080e7          	jalr	1426(ra) # 80005ff2 <panic>
    panic("log_write outside of trans");
    80003a68:	00005517          	auipc	a0,0x5
    80003a6c:	b8850513          	add	a0,a0,-1144 # 800085f0 <etext+0x5f0>
    80003a70:	00002097          	auipc	ra,0x2
    80003a74:	582080e7          	jalr	1410(ra) # 80005ff2 <panic>
  log.lh.block[i] = b->blockno;
    80003a78:	00878693          	add	a3,a5,8
    80003a7c:	068a                	sll	a3,a3,0x2
    80003a7e:	00018717          	auipc	a4,0x18
    80003a82:	99270713          	add	a4,a4,-1646 # 8001b410 <log>
    80003a86:	9736                	add	a4,a4,a3
    80003a88:	44d4                	lw	a3,12(s1)
    80003a8a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a8c:	faf609e3          	beq	a2,a5,80003a3e <log_write+0x76>
  }
  release(&log.lock);
    80003a90:	00018517          	auipc	a0,0x18
    80003a94:	98050513          	add	a0,a0,-1664 # 8001b410 <log>
    80003a98:	00003097          	auipc	ra,0x3
    80003a9c:	b88080e7          	jalr	-1144(ra) # 80006620 <release>
}
    80003aa0:	60e2                	ld	ra,24(sp)
    80003aa2:	6442                	ld	s0,16(sp)
    80003aa4:	64a2                	ld	s1,8(sp)
    80003aa6:	6902                	ld	s2,0(sp)
    80003aa8:	6105                	add	sp,sp,32
    80003aaa:	8082                	ret

0000000080003aac <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003aac:	1101                	add	sp,sp,-32
    80003aae:	ec06                	sd	ra,24(sp)
    80003ab0:	e822                	sd	s0,16(sp)
    80003ab2:	e426                	sd	s1,8(sp)
    80003ab4:	e04a                	sd	s2,0(sp)
    80003ab6:	1000                	add	s0,sp,32
    80003ab8:	84aa                	mv	s1,a0
    80003aba:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003abc:	00005597          	auipc	a1,0x5
    80003ac0:	b5458593          	add	a1,a1,-1196 # 80008610 <etext+0x610>
    80003ac4:	0521                	add	a0,a0,8
    80003ac6:	00003097          	auipc	ra,0x3
    80003aca:	a16080e7          	jalr	-1514(ra) # 800064dc <initlock>
  lk->name = name;
    80003ace:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003ad2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ad6:	0204a423          	sw	zero,40(s1)
}
    80003ada:	60e2                	ld	ra,24(sp)
    80003adc:	6442                	ld	s0,16(sp)
    80003ade:	64a2                	ld	s1,8(sp)
    80003ae0:	6902                	ld	s2,0(sp)
    80003ae2:	6105                	add	sp,sp,32
    80003ae4:	8082                	ret

0000000080003ae6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003ae6:	1101                	add	sp,sp,-32
    80003ae8:	ec06                	sd	ra,24(sp)
    80003aea:	e822                	sd	s0,16(sp)
    80003aec:	e426                	sd	s1,8(sp)
    80003aee:	e04a                	sd	s2,0(sp)
    80003af0:	1000                	add	s0,sp,32
    80003af2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003af4:	00850913          	add	s2,a0,8
    80003af8:	854a                	mv	a0,s2
    80003afa:	00003097          	auipc	ra,0x3
    80003afe:	a72080e7          	jalr	-1422(ra) # 8000656c <acquire>
  while (lk->locked) {
    80003b02:	409c                	lw	a5,0(s1)
    80003b04:	cb89                	beqz	a5,80003b16 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003b06:	85ca                	mv	a1,s2
    80003b08:	8526                	mv	a0,s1
    80003b0a:	ffffe097          	auipc	ra,0xffffe
    80003b0e:	afc080e7          	jalr	-1284(ra) # 80001606 <sleep>
  while (lk->locked) {
    80003b12:	409c                	lw	a5,0(s1)
    80003b14:	fbed                	bnez	a5,80003b06 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003b16:	4785                	li	a5,1
    80003b18:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003b1a:	ffffd097          	auipc	ra,0xffffd
    80003b1e:	436080e7          	jalr	1078(ra) # 80000f50 <myproc>
    80003b22:	591c                	lw	a5,48(a0)
    80003b24:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003b26:	854a                	mv	a0,s2
    80003b28:	00003097          	auipc	ra,0x3
    80003b2c:	af8080e7          	jalr	-1288(ra) # 80006620 <release>
}
    80003b30:	60e2                	ld	ra,24(sp)
    80003b32:	6442                	ld	s0,16(sp)
    80003b34:	64a2                	ld	s1,8(sp)
    80003b36:	6902                	ld	s2,0(sp)
    80003b38:	6105                	add	sp,sp,32
    80003b3a:	8082                	ret

0000000080003b3c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003b3c:	1101                	add	sp,sp,-32
    80003b3e:	ec06                	sd	ra,24(sp)
    80003b40:	e822                	sd	s0,16(sp)
    80003b42:	e426                	sd	s1,8(sp)
    80003b44:	e04a                	sd	s2,0(sp)
    80003b46:	1000                	add	s0,sp,32
    80003b48:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b4a:	00850913          	add	s2,a0,8
    80003b4e:	854a                	mv	a0,s2
    80003b50:	00003097          	auipc	ra,0x3
    80003b54:	a1c080e7          	jalr	-1508(ra) # 8000656c <acquire>
  lk->locked = 0;
    80003b58:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b5c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003b60:	8526                	mv	a0,s1
    80003b62:	ffffe097          	auipc	ra,0xffffe
    80003b66:	b08080e7          	jalr	-1272(ra) # 8000166a <wakeup>
  release(&lk->lk);
    80003b6a:	854a                	mv	a0,s2
    80003b6c:	00003097          	auipc	ra,0x3
    80003b70:	ab4080e7          	jalr	-1356(ra) # 80006620 <release>
}
    80003b74:	60e2                	ld	ra,24(sp)
    80003b76:	6442                	ld	s0,16(sp)
    80003b78:	64a2                	ld	s1,8(sp)
    80003b7a:	6902                	ld	s2,0(sp)
    80003b7c:	6105                	add	sp,sp,32
    80003b7e:	8082                	ret

0000000080003b80 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003b80:	7179                	add	sp,sp,-48
    80003b82:	f406                	sd	ra,40(sp)
    80003b84:	f022                	sd	s0,32(sp)
    80003b86:	ec26                	sd	s1,24(sp)
    80003b88:	e84a                	sd	s2,16(sp)
    80003b8a:	1800                	add	s0,sp,48
    80003b8c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003b8e:	00850913          	add	s2,a0,8
    80003b92:	854a                	mv	a0,s2
    80003b94:	00003097          	auipc	ra,0x3
    80003b98:	9d8080e7          	jalr	-1576(ra) # 8000656c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b9c:	409c                	lw	a5,0(s1)
    80003b9e:	ef91                	bnez	a5,80003bba <holdingsleep+0x3a>
    80003ba0:	4481                	li	s1,0
  release(&lk->lk);
    80003ba2:	854a                	mv	a0,s2
    80003ba4:	00003097          	auipc	ra,0x3
    80003ba8:	a7c080e7          	jalr	-1412(ra) # 80006620 <release>
  return r;
}
    80003bac:	8526                	mv	a0,s1
    80003bae:	70a2                	ld	ra,40(sp)
    80003bb0:	7402                	ld	s0,32(sp)
    80003bb2:	64e2                	ld	s1,24(sp)
    80003bb4:	6942                	ld	s2,16(sp)
    80003bb6:	6145                	add	sp,sp,48
    80003bb8:	8082                	ret
    80003bba:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bbc:	0284a983          	lw	s3,40(s1)
    80003bc0:	ffffd097          	auipc	ra,0xffffd
    80003bc4:	390080e7          	jalr	912(ra) # 80000f50 <myproc>
    80003bc8:	5904                	lw	s1,48(a0)
    80003bca:	413484b3          	sub	s1,s1,s3
    80003bce:	0014b493          	seqz	s1,s1
    80003bd2:	69a2                	ld	s3,8(sp)
    80003bd4:	b7f9                	j	80003ba2 <holdingsleep+0x22>

0000000080003bd6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003bd6:	1141                	add	sp,sp,-16
    80003bd8:	e406                	sd	ra,8(sp)
    80003bda:	e022                	sd	s0,0(sp)
    80003bdc:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003bde:	00005597          	auipc	a1,0x5
    80003be2:	a4258593          	add	a1,a1,-1470 # 80008620 <etext+0x620>
    80003be6:	00018517          	auipc	a0,0x18
    80003bea:	97250513          	add	a0,a0,-1678 # 8001b558 <ftable>
    80003bee:	00003097          	auipc	ra,0x3
    80003bf2:	8ee080e7          	jalr	-1810(ra) # 800064dc <initlock>
}
    80003bf6:	60a2                	ld	ra,8(sp)
    80003bf8:	6402                	ld	s0,0(sp)
    80003bfa:	0141                	add	sp,sp,16
    80003bfc:	8082                	ret

0000000080003bfe <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003bfe:	1101                	add	sp,sp,-32
    80003c00:	ec06                	sd	ra,24(sp)
    80003c02:	e822                	sd	s0,16(sp)
    80003c04:	e426                	sd	s1,8(sp)
    80003c06:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003c08:	00018517          	auipc	a0,0x18
    80003c0c:	95050513          	add	a0,a0,-1712 # 8001b558 <ftable>
    80003c10:	00003097          	auipc	ra,0x3
    80003c14:	95c080e7          	jalr	-1700(ra) # 8000656c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c18:	00018497          	auipc	s1,0x18
    80003c1c:	95848493          	add	s1,s1,-1704 # 8001b570 <ftable+0x18>
    80003c20:	00019717          	auipc	a4,0x19
    80003c24:	8f070713          	add	a4,a4,-1808 # 8001c510 <disk>
    if(f->ref == 0){
    80003c28:	40dc                	lw	a5,4(s1)
    80003c2a:	cf99                	beqz	a5,80003c48 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c2c:	02848493          	add	s1,s1,40
    80003c30:	fee49ce3          	bne	s1,a4,80003c28 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003c34:	00018517          	auipc	a0,0x18
    80003c38:	92450513          	add	a0,a0,-1756 # 8001b558 <ftable>
    80003c3c:	00003097          	auipc	ra,0x3
    80003c40:	9e4080e7          	jalr	-1564(ra) # 80006620 <release>
  return 0;
    80003c44:	4481                	li	s1,0
    80003c46:	a819                	j	80003c5c <filealloc+0x5e>
      f->ref = 1;
    80003c48:	4785                	li	a5,1
    80003c4a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c4c:	00018517          	auipc	a0,0x18
    80003c50:	90c50513          	add	a0,a0,-1780 # 8001b558 <ftable>
    80003c54:	00003097          	auipc	ra,0x3
    80003c58:	9cc080e7          	jalr	-1588(ra) # 80006620 <release>
}
    80003c5c:	8526                	mv	a0,s1
    80003c5e:	60e2                	ld	ra,24(sp)
    80003c60:	6442                	ld	s0,16(sp)
    80003c62:	64a2                	ld	s1,8(sp)
    80003c64:	6105                	add	sp,sp,32
    80003c66:	8082                	ret

0000000080003c68 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003c68:	1101                	add	sp,sp,-32
    80003c6a:	ec06                	sd	ra,24(sp)
    80003c6c:	e822                	sd	s0,16(sp)
    80003c6e:	e426                	sd	s1,8(sp)
    80003c70:	1000                	add	s0,sp,32
    80003c72:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c74:	00018517          	auipc	a0,0x18
    80003c78:	8e450513          	add	a0,a0,-1820 # 8001b558 <ftable>
    80003c7c:	00003097          	auipc	ra,0x3
    80003c80:	8f0080e7          	jalr	-1808(ra) # 8000656c <acquire>
  if(f->ref < 1)
    80003c84:	40dc                	lw	a5,4(s1)
    80003c86:	02f05263          	blez	a5,80003caa <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003c8a:	2785                	addw	a5,a5,1
    80003c8c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c8e:	00018517          	auipc	a0,0x18
    80003c92:	8ca50513          	add	a0,a0,-1846 # 8001b558 <ftable>
    80003c96:	00003097          	auipc	ra,0x3
    80003c9a:	98a080e7          	jalr	-1654(ra) # 80006620 <release>
  return f;
}
    80003c9e:	8526                	mv	a0,s1
    80003ca0:	60e2                	ld	ra,24(sp)
    80003ca2:	6442                	ld	s0,16(sp)
    80003ca4:	64a2                	ld	s1,8(sp)
    80003ca6:	6105                	add	sp,sp,32
    80003ca8:	8082                	ret
    panic("filedup");
    80003caa:	00005517          	auipc	a0,0x5
    80003cae:	97e50513          	add	a0,a0,-1666 # 80008628 <etext+0x628>
    80003cb2:	00002097          	auipc	ra,0x2
    80003cb6:	340080e7          	jalr	832(ra) # 80005ff2 <panic>

0000000080003cba <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003cba:	7139                	add	sp,sp,-64
    80003cbc:	fc06                	sd	ra,56(sp)
    80003cbe:	f822                	sd	s0,48(sp)
    80003cc0:	f426                	sd	s1,40(sp)
    80003cc2:	0080                	add	s0,sp,64
    80003cc4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003cc6:	00018517          	auipc	a0,0x18
    80003cca:	89250513          	add	a0,a0,-1902 # 8001b558 <ftable>
    80003cce:	00003097          	auipc	ra,0x3
    80003cd2:	89e080e7          	jalr	-1890(ra) # 8000656c <acquire>
  if(f->ref < 1)
    80003cd6:	40dc                	lw	a5,4(s1)
    80003cd8:	04f05c63          	blez	a5,80003d30 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003cdc:	37fd                	addw	a5,a5,-1
    80003cde:	0007871b          	sext.w	a4,a5
    80003ce2:	c0dc                	sw	a5,4(s1)
    80003ce4:	06e04263          	bgtz	a4,80003d48 <fileclose+0x8e>
    80003ce8:	f04a                	sd	s2,32(sp)
    80003cea:	ec4e                	sd	s3,24(sp)
    80003cec:	e852                	sd	s4,16(sp)
    80003cee:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003cf0:	0004a903          	lw	s2,0(s1)
    80003cf4:	0094ca83          	lbu	s5,9(s1)
    80003cf8:	0104ba03          	ld	s4,16(s1)
    80003cfc:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003d00:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003d04:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003d08:	00018517          	auipc	a0,0x18
    80003d0c:	85050513          	add	a0,a0,-1968 # 8001b558 <ftable>
    80003d10:	00003097          	auipc	ra,0x3
    80003d14:	910080e7          	jalr	-1776(ra) # 80006620 <release>

  if(ff.type == FD_PIPE){
    80003d18:	4785                	li	a5,1
    80003d1a:	04f90463          	beq	s2,a5,80003d62 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003d1e:	3979                	addw	s2,s2,-2
    80003d20:	4785                	li	a5,1
    80003d22:	0527fb63          	bgeu	a5,s2,80003d78 <fileclose+0xbe>
    80003d26:	7902                	ld	s2,32(sp)
    80003d28:	69e2                	ld	s3,24(sp)
    80003d2a:	6a42                	ld	s4,16(sp)
    80003d2c:	6aa2                	ld	s5,8(sp)
    80003d2e:	a02d                	j	80003d58 <fileclose+0x9e>
    80003d30:	f04a                	sd	s2,32(sp)
    80003d32:	ec4e                	sd	s3,24(sp)
    80003d34:	e852                	sd	s4,16(sp)
    80003d36:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003d38:	00005517          	auipc	a0,0x5
    80003d3c:	8f850513          	add	a0,a0,-1800 # 80008630 <etext+0x630>
    80003d40:	00002097          	auipc	ra,0x2
    80003d44:	2b2080e7          	jalr	690(ra) # 80005ff2 <panic>
    release(&ftable.lock);
    80003d48:	00018517          	auipc	a0,0x18
    80003d4c:	81050513          	add	a0,a0,-2032 # 8001b558 <ftable>
    80003d50:	00003097          	auipc	ra,0x3
    80003d54:	8d0080e7          	jalr	-1840(ra) # 80006620 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003d58:	70e2                	ld	ra,56(sp)
    80003d5a:	7442                	ld	s0,48(sp)
    80003d5c:	74a2                	ld	s1,40(sp)
    80003d5e:	6121                	add	sp,sp,64
    80003d60:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d62:	85d6                	mv	a1,s5
    80003d64:	8552                	mv	a0,s4
    80003d66:	00000097          	auipc	ra,0x0
    80003d6a:	3a2080e7          	jalr	930(ra) # 80004108 <pipeclose>
    80003d6e:	7902                	ld	s2,32(sp)
    80003d70:	69e2                	ld	s3,24(sp)
    80003d72:	6a42                	ld	s4,16(sp)
    80003d74:	6aa2                	ld	s5,8(sp)
    80003d76:	b7cd                	j	80003d58 <fileclose+0x9e>
    begin_op();
    80003d78:	00000097          	auipc	ra,0x0
    80003d7c:	a78080e7          	jalr	-1416(ra) # 800037f0 <begin_op>
    iput(ff.ip);
    80003d80:	854e                	mv	a0,s3
    80003d82:	fffff097          	auipc	ra,0xfffff
    80003d86:	25e080e7          	jalr	606(ra) # 80002fe0 <iput>
    end_op();
    80003d8a:	00000097          	auipc	ra,0x0
    80003d8e:	ae0080e7          	jalr	-1312(ra) # 8000386a <end_op>
    80003d92:	7902                	ld	s2,32(sp)
    80003d94:	69e2                	ld	s3,24(sp)
    80003d96:	6a42                	ld	s4,16(sp)
    80003d98:	6aa2                	ld	s5,8(sp)
    80003d9a:	bf7d                	j	80003d58 <fileclose+0x9e>

0000000080003d9c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003d9c:	715d                	add	sp,sp,-80
    80003d9e:	e486                	sd	ra,72(sp)
    80003da0:	e0a2                	sd	s0,64(sp)
    80003da2:	fc26                	sd	s1,56(sp)
    80003da4:	f44e                	sd	s3,40(sp)
    80003da6:	0880                	add	s0,sp,80
    80003da8:	84aa                	mv	s1,a0
    80003daa:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003dac:	ffffd097          	auipc	ra,0xffffd
    80003db0:	1a4080e7          	jalr	420(ra) # 80000f50 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003db4:	409c                	lw	a5,0(s1)
    80003db6:	37f9                	addw	a5,a5,-2
    80003db8:	4705                	li	a4,1
    80003dba:	04f76863          	bltu	a4,a5,80003e0a <filestat+0x6e>
    80003dbe:	f84a                	sd	s2,48(sp)
    80003dc0:	892a                	mv	s2,a0
    ilock(f->ip);
    80003dc2:	6c88                	ld	a0,24(s1)
    80003dc4:	fffff097          	auipc	ra,0xfffff
    80003dc8:	05e080e7          	jalr	94(ra) # 80002e22 <ilock>
    stati(f->ip, &st);
    80003dcc:	fb840593          	add	a1,s0,-72
    80003dd0:	6c88                	ld	a0,24(s1)
    80003dd2:	fffff097          	auipc	ra,0xfffff
    80003dd6:	2de080e7          	jalr	734(ra) # 800030b0 <stati>
    iunlock(f->ip);
    80003dda:	6c88                	ld	a0,24(s1)
    80003ddc:	fffff097          	auipc	ra,0xfffff
    80003de0:	10c080e7          	jalr	268(ra) # 80002ee8 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003de4:	46e1                	li	a3,24
    80003de6:	fb840613          	add	a2,s0,-72
    80003dea:	85ce                	mv	a1,s3
    80003dec:	05093503          	ld	a0,80(s2)
    80003df0:	ffffd097          	auipc	ra,0xffffd
    80003df4:	da6080e7          	jalr	-602(ra) # 80000b96 <copyout>
    80003df8:	41f5551b          	sraw	a0,a0,0x1f
    80003dfc:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003dfe:	60a6                	ld	ra,72(sp)
    80003e00:	6406                	ld	s0,64(sp)
    80003e02:	74e2                	ld	s1,56(sp)
    80003e04:	79a2                	ld	s3,40(sp)
    80003e06:	6161                	add	sp,sp,80
    80003e08:	8082                	ret
  return -1;
    80003e0a:	557d                	li	a0,-1
    80003e0c:	bfcd                	j	80003dfe <filestat+0x62>

0000000080003e0e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003e0e:	7179                	add	sp,sp,-48
    80003e10:	f406                	sd	ra,40(sp)
    80003e12:	f022                	sd	s0,32(sp)
    80003e14:	e84a                	sd	s2,16(sp)
    80003e16:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003e18:	00854783          	lbu	a5,8(a0)
    80003e1c:	cbc5                	beqz	a5,80003ecc <fileread+0xbe>
    80003e1e:	ec26                	sd	s1,24(sp)
    80003e20:	e44e                	sd	s3,8(sp)
    80003e22:	84aa                	mv	s1,a0
    80003e24:	89ae                	mv	s3,a1
    80003e26:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e28:	411c                	lw	a5,0(a0)
    80003e2a:	4705                	li	a4,1
    80003e2c:	04e78963          	beq	a5,a4,80003e7e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e30:	470d                	li	a4,3
    80003e32:	04e78f63          	beq	a5,a4,80003e90 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e36:	4709                	li	a4,2
    80003e38:	08e79263          	bne	a5,a4,80003ebc <fileread+0xae>
    ilock(f->ip);
    80003e3c:	6d08                	ld	a0,24(a0)
    80003e3e:	fffff097          	auipc	ra,0xfffff
    80003e42:	fe4080e7          	jalr	-28(ra) # 80002e22 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003e46:	874a                	mv	a4,s2
    80003e48:	5094                	lw	a3,32(s1)
    80003e4a:	864e                	mv	a2,s3
    80003e4c:	4585                	li	a1,1
    80003e4e:	6c88                	ld	a0,24(s1)
    80003e50:	fffff097          	auipc	ra,0xfffff
    80003e54:	28a080e7          	jalr	650(ra) # 800030da <readi>
    80003e58:	892a                	mv	s2,a0
    80003e5a:	00a05563          	blez	a0,80003e64 <fileread+0x56>
      f->off += r;
    80003e5e:	509c                	lw	a5,32(s1)
    80003e60:	9fa9                	addw	a5,a5,a0
    80003e62:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e64:	6c88                	ld	a0,24(s1)
    80003e66:	fffff097          	auipc	ra,0xfffff
    80003e6a:	082080e7          	jalr	130(ra) # 80002ee8 <iunlock>
    80003e6e:	64e2                	ld	s1,24(sp)
    80003e70:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003e72:	854a                	mv	a0,s2
    80003e74:	70a2                	ld	ra,40(sp)
    80003e76:	7402                	ld	s0,32(sp)
    80003e78:	6942                	ld	s2,16(sp)
    80003e7a:	6145                	add	sp,sp,48
    80003e7c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003e7e:	6908                	ld	a0,16(a0)
    80003e80:	00000097          	auipc	ra,0x0
    80003e84:	400080e7          	jalr	1024(ra) # 80004280 <piperead>
    80003e88:	892a                	mv	s2,a0
    80003e8a:	64e2                	ld	s1,24(sp)
    80003e8c:	69a2                	ld	s3,8(sp)
    80003e8e:	b7d5                	j	80003e72 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003e90:	02451783          	lh	a5,36(a0)
    80003e94:	03079693          	sll	a3,a5,0x30
    80003e98:	92c1                	srl	a3,a3,0x30
    80003e9a:	4725                	li	a4,9
    80003e9c:	02d76a63          	bltu	a4,a3,80003ed0 <fileread+0xc2>
    80003ea0:	0792                	sll	a5,a5,0x4
    80003ea2:	00017717          	auipc	a4,0x17
    80003ea6:	61670713          	add	a4,a4,1558 # 8001b4b8 <devsw>
    80003eaa:	97ba                	add	a5,a5,a4
    80003eac:	639c                	ld	a5,0(a5)
    80003eae:	c78d                	beqz	a5,80003ed8 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003eb0:	4505                	li	a0,1
    80003eb2:	9782                	jalr	a5
    80003eb4:	892a                	mv	s2,a0
    80003eb6:	64e2                	ld	s1,24(sp)
    80003eb8:	69a2                	ld	s3,8(sp)
    80003eba:	bf65                	j	80003e72 <fileread+0x64>
    panic("fileread");
    80003ebc:	00004517          	auipc	a0,0x4
    80003ec0:	78450513          	add	a0,a0,1924 # 80008640 <etext+0x640>
    80003ec4:	00002097          	auipc	ra,0x2
    80003ec8:	12e080e7          	jalr	302(ra) # 80005ff2 <panic>
    return -1;
    80003ecc:	597d                	li	s2,-1
    80003ece:	b755                	j	80003e72 <fileread+0x64>
      return -1;
    80003ed0:	597d                	li	s2,-1
    80003ed2:	64e2                	ld	s1,24(sp)
    80003ed4:	69a2                	ld	s3,8(sp)
    80003ed6:	bf71                	j	80003e72 <fileread+0x64>
    80003ed8:	597d                	li	s2,-1
    80003eda:	64e2                	ld	s1,24(sp)
    80003edc:	69a2                	ld	s3,8(sp)
    80003ede:	bf51                	j	80003e72 <fileread+0x64>

0000000080003ee0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003ee0:	00954783          	lbu	a5,9(a0)
    80003ee4:	12078963          	beqz	a5,80004016 <filewrite+0x136>
{
    80003ee8:	715d                	add	sp,sp,-80
    80003eea:	e486                	sd	ra,72(sp)
    80003eec:	e0a2                	sd	s0,64(sp)
    80003eee:	f84a                	sd	s2,48(sp)
    80003ef0:	f052                	sd	s4,32(sp)
    80003ef2:	e85a                	sd	s6,16(sp)
    80003ef4:	0880                	add	s0,sp,80
    80003ef6:	892a                	mv	s2,a0
    80003ef8:	8b2e                	mv	s6,a1
    80003efa:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003efc:	411c                	lw	a5,0(a0)
    80003efe:	4705                	li	a4,1
    80003f00:	02e78763          	beq	a5,a4,80003f2e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f04:	470d                	li	a4,3
    80003f06:	02e78a63          	beq	a5,a4,80003f3a <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f0a:	4709                	li	a4,2
    80003f0c:	0ee79863          	bne	a5,a4,80003ffc <filewrite+0x11c>
    80003f10:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003f12:	0cc05463          	blez	a2,80003fda <filewrite+0xfa>
    80003f16:	fc26                	sd	s1,56(sp)
    80003f18:	ec56                	sd	s5,24(sp)
    80003f1a:	e45e                	sd	s7,8(sp)
    80003f1c:	e062                	sd	s8,0(sp)
    int i = 0;
    80003f1e:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003f20:	6b85                	lui	s7,0x1
    80003f22:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003f26:	6c05                	lui	s8,0x1
    80003f28:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003f2c:	a851                	j	80003fc0 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003f2e:	6908                	ld	a0,16(a0)
    80003f30:	00000097          	auipc	ra,0x0
    80003f34:	248080e7          	jalr	584(ra) # 80004178 <pipewrite>
    80003f38:	a85d                	j	80003fee <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003f3a:	02451783          	lh	a5,36(a0)
    80003f3e:	03079693          	sll	a3,a5,0x30
    80003f42:	92c1                	srl	a3,a3,0x30
    80003f44:	4725                	li	a4,9
    80003f46:	0cd76a63          	bltu	a4,a3,8000401a <filewrite+0x13a>
    80003f4a:	0792                	sll	a5,a5,0x4
    80003f4c:	00017717          	auipc	a4,0x17
    80003f50:	56c70713          	add	a4,a4,1388 # 8001b4b8 <devsw>
    80003f54:	97ba                	add	a5,a5,a4
    80003f56:	679c                	ld	a5,8(a5)
    80003f58:	c3f9                	beqz	a5,8000401e <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003f5a:	4505                	li	a0,1
    80003f5c:	9782                	jalr	a5
    80003f5e:	a841                	j	80003fee <filewrite+0x10e>
      if(n1 > max)
    80003f60:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003f64:	00000097          	auipc	ra,0x0
    80003f68:	88c080e7          	jalr	-1908(ra) # 800037f0 <begin_op>
      ilock(f->ip);
    80003f6c:	01893503          	ld	a0,24(s2)
    80003f70:	fffff097          	auipc	ra,0xfffff
    80003f74:	eb2080e7          	jalr	-334(ra) # 80002e22 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003f78:	8756                	mv	a4,s5
    80003f7a:	02092683          	lw	a3,32(s2)
    80003f7e:	01698633          	add	a2,s3,s6
    80003f82:	4585                	li	a1,1
    80003f84:	01893503          	ld	a0,24(s2)
    80003f88:	fffff097          	auipc	ra,0xfffff
    80003f8c:	262080e7          	jalr	610(ra) # 800031ea <writei>
    80003f90:	84aa                	mv	s1,a0
    80003f92:	00a05763          	blez	a0,80003fa0 <filewrite+0xc0>
        f->off += r;
    80003f96:	02092783          	lw	a5,32(s2)
    80003f9a:	9fa9                	addw	a5,a5,a0
    80003f9c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003fa0:	01893503          	ld	a0,24(s2)
    80003fa4:	fffff097          	auipc	ra,0xfffff
    80003fa8:	f44080e7          	jalr	-188(ra) # 80002ee8 <iunlock>
      end_op();
    80003fac:	00000097          	auipc	ra,0x0
    80003fb0:	8be080e7          	jalr	-1858(ra) # 8000386a <end_op>

      if(r != n1){
    80003fb4:	029a9563          	bne	s5,s1,80003fde <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003fb8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003fbc:	0149da63          	bge	s3,s4,80003fd0 <filewrite+0xf0>
      int n1 = n - i;
    80003fc0:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003fc4:	0004879b          	sext.w	a5,s1
    80003fc8:	f8fbdce3          	bge	s7,a5,80003f60 <filewrite+0x80>
    80003fcc:	84e2                	mv	s1,s8
    80003fce:	bf49                	j	80003f60 <filewrite+0x80>
    80003fd0:	74e2                	ld	s1,56(sp)
    80003fd2:	6ae2                	ld	s5,24(sp)
    80003fd4:	6ba2                	ld	s7,8(sp)
    80003fd6:	6c02                	ld	s8,0(sp)
    80003fd8:	a039                	j	80003fe6 <filewrite+0x106>
    int i = 0;
    80003fda:	4981                	li	s3,0
    80003fdc:	a029                	j	80003fe6 <filewrite+0x106>
    80003fde:	74e2                	ld	s1,56(sp)
    80003fe0:	6ae2                	ld	s5,24(sp)
    80003fe2:	6ba2                	ld	s7,8(sp)
    80003fe4:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003fe6:	033a1e63          	bne	s4,s3,80004022 <filewrite+0x142>
    80003fea:	8552                	mv	a0,s4
    80003fec:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003fee:	60a6                	ld	ra,72(sp)
    80003ff0:	6406                	ld	s0,64(sp)
    80003ff2:	7942                	ld	s2,48(sp)
    80003ff4:	7a02                	ld	s4,32(sp)
    80003ff6:	6b42                	ld	s6,16(sp)
    80003ff8:	6161                	add	sp,sp,80
    80003ffa:	8082                	ret
    80003ffc:	fc26                	sd	s1,56(sp)
    80003ffe:	f44e                	sd	s3,40(sp)
    80004000:	ec56                	sd	s5,24(sp)
    80004002:	e45e                	sd	s7,8(sp)
    80004004:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004006:	00004517          	auipc	a0,0x4
    8000400a:	64a50513          	add	a0,a0,1610 # 80008650 <etext+0x650>
    8000400e:	00002097          	auipc	ra,0x2
    80004012:	fe4080e7          	jalr	-28(ra) # 80005ff2 <panic>
    return -1;
    80004016:	557d                	li	a0,-1
}
    80004018:	8082                	ret
      return -1;
    8000401a:	557d                	li	a0,-1
    8000401c:	bfc9                	j	80003fee <filewrite+0x10e>
    8000401e:	557d                	li	a0,-1
    80004020:	b7f9                	j	80003fee <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80004022:	557d                	li	a0,-1
    80004024:	79a2                	ld	s3,40(sp)
    80004026:	b7e1                	j	80003fee <filewrite+0x10e>

0000000080004028 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004028:	7179                	add	sp,sp,-48
    8000402a:	f406                	sd	ra,40(sp)
    8000402c:	f022                	sd	s0,32(sp)
    8000402e:	ec26                	sd	s1,24(sp)
    80004030:	e052                	sd	s4,0(sp)
    80004032:	1800                	add	s0,sp,48
    80004034:	84aa                	mv	s1,a0
    80004036:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004038:	0005b023          	sd	zero,0(a1)
    8000403c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004040:	00000097          	auipc	ra,0x0
    80004044:	bbe080e7          	jalr	-1090(ra) # 80003bfe <filealloc>
    80004048:	e088                	sd	a0,0(s1)
    8000404a:	cd49                	beqz	a0,800040e4 <pipealloc+0xbc>
    8000404c:	00000097          	auipc	ra,0x0
    80004050:	bb2080e7          	jalr	-1102(ra) # 80003bfe <filealloc>
    80004054:	00aa3023          	sd	a0,0(s4)
    80004058:	c141                	beqz	a0,800040d8 <pipealloc+0xb0>
    8000405a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000405c:	ffffc097          	auipc	ra,0xffffc
    80004060:	0be080e7          	jalr	190(ra) # 8000011a <kalloc>
    80004064:	892a                	mv	s2,a0
    80004066:	c13d                	beqz	a0,800040cc <pipealloc+0xa4>
    80004068:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000406a:	4985                	li	s3,1
    8000406c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004070:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004074:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004078:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000407c:	00004597          	auipc	a1,0x4
    80004080:	34458593          	add	a1,a1,836 # 800083c0 <etext+0x3c0>
    80004084:	00002097          	auipc	ra,0x2
    80004088:	458080e7          	jalr	1112(ra) # 800064dc <initlock>
  (*f0)->type = FD_PIPE;
    8000408c:	609c                	ld	a5,0(s1)
    8000408e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004092:	609c                	ld	a5,0(s1)
    80004094:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004098:	609c                	ld	a5,0(s1)
    8000409a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000409e:	609c                	ld	a5,0(s1)
    800040a0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800040a4:	000a3783          	ld	a5,0(s4)
    800040a8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800040ac:	000a3783          	ld	a5,0(s4)
    800040b0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800040b4:	000a3783          	ld	a5,0(s4)
    800040b8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800040bc:	000a3783          	ld	a5,0(s4)
    800040c0:	0127b823          	sd	s2,16(a5)
  return 0;
    800040c4:	4501                	li	a0,0
    800040c6:	6942                	ld	s2,16(sp)
    800040c8:	69a2                	ld	s3,8(sp)
    800040ca:	a03d                	j	800040f8 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800040cc:	6088                	ld	a0,0(s1)
    800040ce:	c119                	beqz	a0,800040d4 <pipealloc+0xac>
    800040d0:	6942                	ld	s2,16(sp)
    800040d2:	a029                	j	800040dc <pipealloc+0xb4>
    800040d4:	6942                	ld	s2,16(sp)
    800040d6:	a039                	j	800040e4 <pipealloc+0xbc>
    800040d8:	6088                	ld	a0,0(s1)
    800040da:	c50d                	beqz	a0,80004104 <pipealloc+0xdc>
    fileclose(*f0);
    800040dc:	00000097          	auipc	ra,0x0
    800040e0:	bde080e7          	jalr	-1058(ra) # 80003cba <fileclose>
  if(*f1)
    800040e4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800040e8:	557d                	li	a0,-1
  if(*f1)
    800040ea:	c799                	beqz	a5,800040f8 <pipealloc+0xd0>
    fileclose(*f1);
    800040ec:	853e                	mv	a0,a5
    800040ee:	00000097          	auipc	ra,0x0
    800040f2:	bcc080e7          	jalr	-1076(ra) # 80003cba <fileclose>
  return -1;
    800040f6:	557d                	li	a0,-1
}
    800040f8:	70a2                	ld	ra,40(sp)
    800040fa:	7402                	ld	s0,32(sp)
    800040fc:	64e2                	ld	s1,24(sp)
    800040fe:	6a02                	ld	s4,0(sp)
    80004100:	6145                	add	sp,sp,48
    80004102:	8082                	ret
  return -1;
    80004104:	557d                	li	a0,-1
    80004106:	bfcd                	j	800040f8 <pipealloc+0xd0>

0000000080004108 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004108:	1101                	add	sp,sp,-32
    8000410a:	ec06                	sd	ra,24(sp)
    8000410c:	e822                	sd	s0,16(sp)
    8000410e:	e426                	sd	s1,8(sp)
    80004110:	e04a                	sd	s2,0(sp)
    80004112:	1000                	add	s0,sp,32
    80004114:	84aa                	mv	s1,a0
    80004116:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004118:	00002097          	auipc	ra,0x2
    8000411c:	454080e7          	jalr	1108(ra) # 8000656c <acquire>
  if(writable){
    80004120:	02090d63          	beqz	s2,8000415a <pipeclose+0x52>
    pi->writeopen = 0;
    80004124:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004128:	21848513          	add	a0,s1,536
    8000412c:	ffffd097          	auipc	ra,0xffffd
    80004130:	53e080e7          	jalr	1342(ra) # 8000166a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004134:	2204b783          	ld	a5,544(s1)
    80004138:	eb95                	bnez	a5,8000416c <pipeclose+0x64>
    release(&pi->lock);
    8000413a:	8526                	mv	a0,s1
    8000413c:	00002097          	auipc	ra,0x2
    80004140:	4e4080e7          	jalr	1252(ra) # 80006620 <release>
    kfree((char*)pi);
    80004144:	8526                	mv	a0,s1
    80004146:	ffffc097          	auipc	ra,0xffffc
    8000414a:	ed6080e7          	jalr	-298(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000414e:	60e2                	ld	ra,24(sp)
    80004150:	6442                	ld	s0,16(sp)
    80004152:	64a2                	ld	s1,8(sp)
    80004154:	6902                	ld	s2,0(sp)
    80004156:	6105                	add	sp,sp,32
    80004158:	8082                	ret
    pi->readopen = 0;
    8000415a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000415e:	21c48513          	add	a0,s1,540
    80004162:	ffffd097          	auipc	ra,0xffffd
    80004166:	508080e7          	jalr	1288(ra) # 8000166a <wakeup>
    8000416a:	b7e9                	j	80004134 <pipeclose+0x2c>
    release(&pi->lock);
    8000416c:	8526                	mv	a0,s1
    8000416e:	00002097          	auipc	ra,0x2
    80004172:	4b2080e7          	jalr	1202(ra) # 80006620 <release>
}
    80004176:	bfe1                	j	8000414e <pipeclose+0x46>

0000000080004178 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004178:	711d                	add	sp,sp,-96
    8000417a:	ec86                	sd	ra,88(sp)
    8000417c:	e8a2                	sd	s0,80(sp)
    8000417e:	e4a6                	sd	s1,72(sp)
    80004180:	e0ca                	sd	s2,64(sp)
    80004182:	fc4e                	sd	s3,56(sp)
    80004184:	f852                	sd	s4,48(sp)
    80004186:	f456                	sd	s5,40(sp)
    80004188:	1080                	add	s0,sp,96
    8000418a:	84aa                	mv	s1,a0
    8000418c:	8aae                	mv	s5,a1
    8000418e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004190:	ffffd097          	auipc	ra,0xffffd
    80004194:	dc0080e7          	jalr	-576(ra) # 80000f50 <myproc>
    80004198:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000419a:	8526                	mv	a0,s1
    8000419c:	00002097          	auipc	ra,0x2
    800041a0:	3d0080e7          	jalr	976(ra) # 8000656c <acquire>
  while(i < n){
    800041a4:	0d405863          	blez	s4,80004274 <pipewrite+0xfc>
    800041a8:	f05a                	sd	s6,32(sp)
    800041aa:	ec5e                	sd	s7,24(sp)
    800041ac:	e862                	sd	s8,16(sp)
  int i = 0;
    800041ae:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041b0:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800041b2:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800041b6:	21c48b93          	add	s7,s1,540
    800041ba:	a089                	j	800041fc <pipewrite+0x84>
      release(&pi->lock);
    800041bc:	8526                	mv	a0,s1
    800041be:	00002097          	auipc	ra,0x2
    800041c2:	462080e7          	jalr	1122(ra) # 80006620 <release>
      return -1;
    800041c6:	597d                	li	s2,-1
    800041c8:	7b02                	ld	s6,32(sp)
    800041ca:	6be2                	ld	s7,24(sp)
    800041cc:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800041ce:	854a                	mv	a0,s2
    800041d0:	60e6                	ld	ra,88(sp)
    800041d2:	6446                	ld	s0,80(sp)
    800041d4:	64a6                	ld	s1,72(sp)
    800041d6:	6906                	ld	s2,64(sp)
    800041d8:	79e2                	ld	s3,56(sp)
    800041da:	7a42                	ld	s4,48(sp)
    800041dc:	7aa2                	ld	s5,40(sp)
    800041de:	6125                	add	sp,sp,96
    800041e0:	8082                	ret
      wakeup(&pi->nread);
    800041e2:	8562                	mv	a0,s8
    800041e4:	ffffd097          	auipc	ra,0xffffd
    800041e8:	486080e7          	jalr	1158(ra) # 8000166a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800041ec:	85a6                	mv	a1,s1
    800041ee:	855e                	mv	a0,s7
    800041f0:	ffffd097          	auipc	ra,0xffffd
    800041f4:	416080e7          	jalr	1046(ra) # 80001606 <sleep>
  while(i < n){
    800041f8:	05495f63          	bge	s2,s4,80004256 <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    800041fc:	2204a783          	lw	a5,544(s1)
    80004200:	dfd5                	beqz	a5,800041bc <pipewrite+0x44>
    80004202:	854e                	mv	a0,s3
    80004204:	ffffd097          	auipc	ra,0xffffd
    80004208:	6aa080e7          	jalr	1706(ra) # 800018ae <killed>
    8000420c:	f945                	bnez	a0,800041bc <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000420e:	2184a783          	lw	a5,536(s1)
    80004212:	21c4a703          	lw	a4,540(s1)
    80004216:	2007879b          	addw	a5,a5,512
    8000421a:	fcf704e3          	beq	a4,a5,800041e2 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000421e:	4685                	li	a3,1
    80004220:	01590633          	add	a2,s2,s5
    80004224:	faf40593          	add	a1,s0,-81
    80004228:	0509b503          	ld	a0,80(s3)
    8000422c:	ffffd097          	auipc	ra,0xffffd
    80004230:	a48080e7          	jalr	-1464(ra) # 80000c74 <copyin>
    80004234:	05650263          	beq	a0,s6,80004278 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004238:	21c4a783          	lw	a5,540(s1)
    8000423c:	0017871b          	addw	a4,a5,1
    80004240:	20e4ae23          	sw	a4,540(s1)
    80004244:	1ff7f793          	and	a5,a5,511
    80004248:	97a6                	add	a5,a5,s1
    8000424a:	faf44703          	lbu	a4,-81(s0)
    8000424e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004252:	2905                	addw	s2,s2,1
    80004254:	b755                	j	800041f8 <pipewrite+0x80>
    80004256:	7b02                	ld	s6,32(sp)
    80004258:	6be2                	ld	s7,24(sp)
    8000425a:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000425c:	21848513          	add	a0,s1,536
    80004260:	ffffd097          	auipc	ra,0xffffd
    80004264:	40a080e7          	jalr	1034(ra) # 8000166a <wakeup>
  release(&pi->lock);
    80004268:	8526                	mv	a0,s1
    8000426a:	00002097          	auipc	ra,0x2
    8000426e:	3b6080e7          	jalr	950(ra) # 80006620 <release>
  return i;
    80004272:	bfb1                	j	800041ce <pipewrite+0x56>
  int i = 0;
    80004274:	4901                	li	s2,0
    80004276:	b7dd                	j	8000425c <pipewrite+0xe4>
    80004278:	7b02                	ld	s6,32(sp)
    8000427a:	6be2                	ld	s7,24(sp)
    8000427c:	6c42                	ld	s8,16(sp)
    8000427e:	bff9                	j	8000425c <pipewrite+0xe4>

0000000080004280 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004280:	715d                	add	sp,sp,-80
    80004282:	e486                	sd	ra,72(sp)
    80004284:	e0a2                	sd	s0,64(sp)
    80004286:	fc26                	sd	s1,56(sp)
    80004288:	f84a                	sd	s2,48(sp)
    8000428a:	f44e                	sd	s3,40(sp)
    8000428c:	f052                	sd	s4,32(sp)
    8000428e:	ec56                	sd	s5,24(sp)
    80004290:	0880                	add	s0,sp,80
    80004292:	84aa                	mv	s1,a0
    80004294:	892e                	mv	s2,a1
    80004296:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004298:	ffffd097          	auipc	ra,0xffffd
    8000429c:	cb8080e7          	jalr	-840(ra) # 80000f50 <myproc>
    800042a0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800042a2:	8526                	mv	a0,s1
    800042a4:	00002097          	auipc	ra,0x2
    800042a8:	2c8080e7          	jalr	712(ra) # 8000656c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042ac:	2184a703          	lw	a4,536(s1)
    800042b0:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042b4:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042b8:	02f71963          	bne	a4,a5,800042ea <piperead+0x6a>
    800042bc:	2244a783          	lw	a5,548(s1)
    800042c0:	cf95                	beqz	a5,800042fc <piperead+0x7c>
    if(killed(pr)){
    800042c2:	8552                	mv	a0,s4
    800042c4:	ffffd097          	auipc	ra,0xffffd
    800042c8:	5ea080e7          	jalr	1514(ra) # 800018ae <killed>
    800042cc:	e10d                	bnez	a0,800042ee <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042ce:	85a6                	mv	a1,s1
    800042d0:	854e                	mv	a0,s3
    800042d2:	ffffd097          	auipc	ra,0xffffd
    800042d6:	334080e7          	jalr	820(ra) # 80001606 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042da:	2184a703          	lw	a4,536(s1)
    800042de:	21c4a783          	lw	a5,540(s1)
    800042e2:	fcf70de3          	beq	a4,a5,800042bc <piperead+0x3c>
    800042e6:	e85a                	sd	s6,16(sp)
    800042e8:	a819                	j	800042fe <piperead+0x7e>
    800042ea:	e85a                	sd	s6,16(sp)
    800042ec:	a809                	j	800042fe <piperead+0x7e>
      release(&pi->lock);
    800042ee:	8526                	mv	a0,s1
    800042f0:	00002097          	auipc	ra,0x2
    800042f4:	330080e7          	jalr	816(ra) # 80006620 <release>
      return -1;
    800042f8:	59fd                	li	s3,-1
    800042fa:	a0a5                	j	80004362 <piperead+0xe2>
    800042fc:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042fe:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004300:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004302:	05505463          	blez	s5,8000434a <piperead+0xca>
    if(pi->nread == pi->nwrite)
    80004306:	2184a783          	lw	a5,536(s1)
    8000430a:	21c4a703          	lw	a4,540(s1)
    8000430e:	02f70e63          	beq	a4,a5,8000434a <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004312:	0017871b          	addw	a4,a5,1
    80004316:	20e4ac23          	sw	a4,536(s1)
    8000431a:	1ff7f793          	and	a5,a5,511
    8000431e:	97a6                	add	a5,a5,s1
    80004320:	0187c783          	lbu	a5,24(a5)
    80004324:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004328:	4685                	li	a3,1
    8000432a:	fbf40613          	add	a2,s0,-65
    8000432e:	85ca                	mv	a1,s2
    80004330:	050a3503          	ld	a0,80(s4)
    80004334:	ffffd097          	auipc	ra,0xffffd
    80004338:	862080e7          	jalr	-1950(ra) # 80000b96 <copyout>
    8000433c:	01650763          	beq	a0,s6,8000434a <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004340:	2985                	addw	s3,s3,1
    80004342:	0905                	add	s2,s2,1
    80004344:	fd3a91e3          	bne	s5,s3,80004306 <piperead+0x86>
    80004348:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000434a:	21c48513          	add	a0,s1,540
    8000434e:	ffffd097          	auipc	ra,0xffffd
    80004352:	31c080e7          	jalr	796(ra) # 8000166a <wakeup>
  release(&pi->lock);
    80004356:	8526                	mv	a0,s1
    80004358:	00002097          	auipc	ra,0x2
    8000435c:	2c8080e7          	jalr	712(ra) # 80006620 <release>
    80004360:	6b42                	ld	s6,16(sp)
  return i;
}
    80004362:	854e                	mv	a0,s3
    80004364:	60a6                	ld	ra,72(sp)
    80004366:	6406                	ld	s0,64(sp)
    80004368:	74e2                	ld	s1,56(sp)
    8000436a:	7942                	ld	s2,48(sp)
    8000436c:	79a2                	ld	s3,40(sp)
    8000436e:	7a02                	ld	s4,32(sp)
    80004370:	6ae2                	ld	s5,24(sp)
    80004372:	6161                	add	sp,sp,80
    80004374:	8082                	ret

0000000080004376 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004376:	1141                	add	sp,sp,-16
    80004378:	e422                	sd	s0,8(sp)
    8000437a:	0800                	add	s0,sp,16
    8000437c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000437e:	8905                	and	a0,a0,1
    80004380:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004382:	8b89                	and	a5,a5,2
    80004384:	c399                	beqz	a5,8000438a <flags2perm+0x14>
      perm |= PTE_W;
    80004386:	00456513          	or	a0,a0,4
    return perm;
}
    8000438a:	6422                	ld	s0,8(sp)
    8000438c:	0141                	add	sp,sp,16
    8000438e:	8082                	ret

0000000080004390 <exec>:

int
exec(char *path, char **argv)
{
    80004390:	df010113          	add	sp,sp,-528
    80004394:	20113423          	sd	ra,520(sp)
    80004398:	20813023          	sd	s0,512(sp)
    8000439c:	ffa6                	sd	s1,504(sp)
    8000439e:	fbca                	sd	s2,496(sp)
    800043a0:	0c00                	add	s0,sp,528
    800043a2:	892a                	mv	s2,a0
    800043a4:	dea43c23          	sd	a0,-520(s0)
    800043a8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800043ac:	ffffd097          	auipc	ra,0xffffd
    800043b0:	ba4080e7          	jalr	-1116(ra) # 80000f50 <myproc>
    800043b4:	84aa                	mv	s1,a0

  begin_op();
    800043b6:	fffff097          	auipc	ra,0xfffff
    800043ba:	43a080e7          	jalr	1082(ra) # 800037f0 <begin_op>

  if((ip = namei(path)) == 0){
    800043be:	854a                	mv	a0,s2
    800043c0:	fffff097          	auipc	ra,0xfffff
    800043c4:	230080e7          	jalr	560(ra) # 800035f0 <namei>
    800043c8:	c135                	beqz	a0,8000442c <exec+0x9c>
    800043ca:	f3d2                	sd	s4,480(sp)
    800043cc:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800043ce:	fffff097          	auipc	ra,0xfffff
    800043d2:	a54080e7          	jalr	-1452(ra) # 80002e22 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800043d6:	04000713          	li	a4,64
    800043da:	4681                	li	a3,0
    800043dc:	e5040613          	add	a2,s0,-432
    800043e0:	4581                	li	a1,0
    800043e2:	8552                	mv	a0,s4
    800043e4:	fffff097          	auipc	ra,0xfffff
    800043e8:	cf6080e7          	jalr	-778(ra) # 800030da <readi>
    800043ec:	04000793          	li	a5,64
    800043f0:	00f51a63          	bne	a0,a5,80004404 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800043f4:	e5042703          	lw	a4,-432(s0)
    800043f8:	464c47b7          	lui	a5,0x464c4
    800043fc:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004400:	02f70c63          	beq	a4,a5,80004438 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004404:	8552                	mv	a0,s4
    80004406:	fffff097          	auipc	ra,0xfffff
    8000440a:	c82080e7          	jalr	-894(ra) # 80003088 <iunlockput>
    end_op();
    8000440e:	fffff097          	auipc	ra,0xfffff
    80004412:	45c080e7          	jalr	1116(ra) # 8000386a <end_op>
  }
  return -1;
    80004416:	557d                	li	a0,-1
    80004418:	7a1e                	ld	s4,480(sp)
}
    8000441a:	20813083          	ld	ra,520(sp)
    8000441e:	20013403          	ld	s0,512(sp)
    80004422:	74fe                	ld	s1,504(sp)
    80004424:	795e                	ld	s2,496(sp)
    80004426:	21010113          	add	sp,sp,528
    8000442a:	8082                	ret
    end_op();
    8000442c:	fffff097          	auipc	ra,0xfffff
    80004430:	43e080e7          	jalr	1086(ra) # 8000386a <end_op>
    return -1;
    80004434:	557d                	li	a0,-1
    80004436:	b7d5                	j	8000441a <exec+0x8a>
    80004438:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000443a:	8526                	mv	a0,s1
    8000443c:	ffffd097          	auipc	ra,0xffffd
    80004440:	bdc080e7          	jalr	-1060(ra) # 80001018 <proc_pagetable>
    80004444:	8b2a                	mv	s6,a0
    80004446:	30050f63          	beqz	a0,80004764 <exec+0x3d4>
    8000444a:	f7ce                	sd	s3,488(sp)
    8000444c:	efd6                	sd	s5,472(sp)
    8000444e:	e7de                	sd	s7,456(sp)
    80004450:	e3e2                	sd	s8,448(sp)
    80004452:	ff66                	sd	s9,440(sp)
    80004454:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004456:	e7042d03          	lw	s10,-400(s0)
    8000445a:	e8845783          	lhu	a5,-376(s0)
    8000445e:	14078d63          	beqz	a5,800045b8 <exec+0x228>
    80004462:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004464:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004466:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004468:	6c85                	lui	s9,0x1
    8000446a:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000446e:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004472:	6a85                	lui	s5,0x1
    80004474:	a0b5                	j	800044e0 <exec+0x150>
      panic("loadseg: address should exist");
    80004476:	00004517          	auipc	a0,0x4
    8000447a:	1ea50513          	add	a0,a0,490 # 80008660 <etext+0x660>
    8000447e:	00002097          	auipc	ra,0x2
    80004482:	b74080e7          	jalr	-1164(ra) # 80005ff2 <panic>
    if(sz - i < PGSIZE)
    80004486:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004488:	8726                	mv	a4,s1
    8000448a:	012c06bb          	addw	a3,s8,s2
    8000448e:	4581                	li	a1,0
    80004490:	8552                	mv	a0,s4
    80004492:	fffff097          	auipc	ra,0xfffff
    80004496:	c48080e7          	jalr	-952(ra) # 800030da <readi>
    8000449a:	2501                	sext.w	a0,a0
    8000449c:	28a49863          	bne	s1,a0,8000472c <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    800044a0:	012a893b          	addw	s2,s5,s2
    800044a4:	03397563          	bgeu	s2,s3,800044ce <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800044a8:	02091593          	sll	a1,s2,0x20
    800044ac:	9181                	srl	a1,a1,0x20
    800044ae:	95de                	add	a1,a1,s7
    800044b0:	855a                	mv	a0,s6
    800044b2:	ffffc097          	auipc	ra,0xffffc
    800044b6:	094080e7          	jalr	148(ra) # 80000546 <walkaddr>
    800044ba:	862a                	mv	a2,a0
    if(pa == 0)
    800044bc:	dd4d                	beqz	a0,80004476 <exec+0xe6>
    if(sz - i < PGSIZE)
    800044be:	412984bb          	subw	s1,s3,s2
    800044c2:	0004879b          	sext.w	a5,s1
    800044c6:	fcfcf0e3          	bgeu	s9,a5,80004486 <exec+0xf6>
    800044ca:	84d6                	mv	s1,s5
    800044cc:	bf6d                	j	80004486 <exec+0xf6>
    sz = sz1;
    800044ce:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044d2:	2d85                	addw	s11,s11,1
    800044d4:	038d0d1b          	addw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    800044d8:	e8845783          	lhu	a5,-376(s0)
    800044dc:	08fdd663          	bge	s11,a5,80004568 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044e0:	2d01                	sext.w	s10,s10
    800044e2:	03800713          	li	a4,56
    800044e6:	86ea                	mv	a3,s10
    800044e8:	e1840613          	add	a2,s0,-488
    800044ec:	4581                	li	a1,0
    800044ee:	8552                	mv	a0,s4
    800044f0:	fffff097          	auipc	ra,0xfffff
    800044f4:	bea080e7          	jalr	-1046(ra) # 800030da <readi>
    800044f8:	03800793          	li	a5,56
    800044fc:	20f51063          	bne	a0,a5,800046fc <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    80004500:	e1842783          	lw	a5,-488(s0)
    80004504:	4705                	li	a4,1
    80004506:	fce796e3          	bne	a5,a4,800044d2 <exec+0x142>
    if(ph.memsz < ph.filesz)
    8000450a:	e4043483          	ld	s1,-448(s0)
    8000450e:	e3843783          	ld	a5,-456(s0)
    80004512:	1ef4e963          	bltu	s1,a5,80004704 <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004516:	e2843783          	ld	a5,-472(s0)
    8000451a:	94be                	add	s1,s1,a5
    8000451c:	1ef4e863          	bltu	s1,a5,8000470c <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    80004520:	df043703          	ld	a4,-528(s0)
    80004524:	8ff9                	and	a5,a5,a4
    80004526:	1e079763          	bnez	a5,80004714 <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000452a:	e1c42503          	lw	a0,-484(s0)
    8000452e:	00000097          	auipc	ra,0x0
    80004532:	e48080e7          	jalr	-440(ra) # 80004376 <flags2perm>
    80004536:	86aa                	mv	a3,a0
    80004538:	8626                	mv	a2,s1
    8000453a:	85ca                	mv	a1,s2
    8000453c:	855a                	mv	a0,s6
    8000453e:	ffffc097          	auipc	ra,0xffffc
    80004542:	3f0080e7          	jalr	1008(ra) # 8000092e <uvmalloc>
    80004546:	e0a43423          	sd	a0,-504(s0)
    8000454a:	1c050963          	beqz	a0,8000471c <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000454e:	e2843b83          	ld	s7,-472(s0)
    80004552:	e2042c03          	lw	s8,-480(s0)
    80004556:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000455a:	00098463          	beqz	s3,80004562 <exec+0x1d2>
    8000455e:	4901                	li	s2,0
    80004560:	b7a1                	j	800044a8 <exec+0x118>
    sz = sz1;
    80004562:	e0843903          	ld	s2,-504(s0)
    80004566:	b7b5                	j	800044d2 <exec+0x142>
    80004568:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000456a:	8552                	mv	a0,s4
    8000456c:	fffff097          	auipc	ra,0xfffff
    80004570:	b1c080e7          	jalr	-1252(ra) # 80003088 <iunlockput>
  end_op();
    80004574:	fffff097          	auipc	ra,0xfffff
    80004578:	2f6080e7          	jalr	758(ra) # 8000386a <end_op>
  p = myproc();
    8000457c:	ffffd097          	auipc	ra,0xffffd
    80004580:	9d4080e7          	jalr	-1580(ra) # 80000f50 <myproc>
    80004584:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004586:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000458a:	6985                	lui	s3,0x1
    8000458c:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000458e:	99ca                	add	s3,s3,s2
    80004590:	77fd                	lui	a5,0xfffff
    80004592:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004596:	4691                	li	a3,4
    80004598:	6609                	lui	a2,0x2
    8000459a:	964e                	add	a2,a2,s3
    8000459c:	85ce                	mv	a1,s3
    8000459e:	855a                	mv	a0,s6
    800045a0:	ffffc097          	auipc	ra,0xffffc
    800045a4:	38e080e7          	jalr	910(ra) # 8000092e <uvmalloc>
    800045a8:	892a                	mv	s2,a0
    800045aa:	e0a43423          	sd	a0,-504(s0)
    800045ae:	e519                	bnez	a0,800045bc <exec+0x22c>
  if(pagetable)
    800045b0:	e1343423          	sd	s3,-504(s0)
    800045b4:	4a01                	li	s4,0
    800045b6:	aaa5                	j	8000472e <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800045b8:	4901                	li	s2,0
    800045ba:	bf45                	j	8000456a <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    800045bc:	75f9                	lui	a1,0xffffe
    800045be:	95aa                	add	a1,a1,a0
    800045c0:	855a                	mv	a0,s6
    800045c2:	ffffc097          	auipc	ra,0xffffc
    800045c6:	5a2080e7          	jalr	1442(ra) # 80000b64 <uvmclear>
  stackbase = sp - PGSIZE;
    800045ca:	7bfd                	lui	s7,0xfffff
    800045cc:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800045ce:	e0043783          	ld	a5,-512(s0)
    800045d2:	6388                	ld	a0,0(a5)
    800045d4:	c52d                	beqz	a0,8000463e <exec+0x2ae>
    800045d6:	e9040993          	add	s3,s0,-368
    800045da:	f9040c13          	add	s8,s0,-112
    800045de:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800045e0:	ffffc097          	auipc	ra,0xffffc
    800045e4:	d58080e7          	jalr	-680(ra) # 80000338 <strlen>
    800045e8:	0015079b          	addw	a5,a0,1
    800045ec:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800045f0:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    800045f4:	13796863          	bltu	s2,s7,80004724 <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800045f8:	e0043d03          	ld	s10,-512(s0)
    800045fc:	000d3a03          	ld	s4,0(s10)
    80004600:	8552                	mv	a0,s4
    80004602:	ffffc097          	auipc	ra,0xffffc
    80004606:	d36080e7          	jalr	-714(ra) # 80000338 <strlen>
    8000460a:	0015069b          	addw	a3,a0,1
    8000460e:	8652                	mv	a2,s4
    80004610:	85ca                	mv	a1,s2
    80004612:	855a                	mv	a0,s6
    80004614:	ffffc097          	auipc	ra,0xffffc
    80004618:	582080e7          	jalr	1410(ra) # 80000b96 <copyout>
    8000461c:	10054663          	bltz	a0,80004728 <exec+0x398>
    ustack[argc] = sp;
    80004620:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004624:	0485                	add	s1,s1,1
    80004626:	008d0793          	add	a5,s10,8
    8000462a:	e0f43023          	sd	a5,-512(s0)
    8000462e:	008d3503          	ld	a0,8(s10)
    80004632:	c909                	beqz	a0,80004644 <exec+0x2b4>
    if(argc >= MAXARG)
    80004634:	09a1                	add	s3,s3,8
    80004636:	fb8995e3          	bne	s3,s8,800045e0 <exec+0x250>
  ip = 0;
    8000463a:	4a01                	li	s4,0
    8000463c:	a8cd                	j	8000472e <exec+0x39e>
  sp = sz;
    8000463e:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004642:	4481                	li	s1,0
  ustack[argc] = 0;
    80004644:	00349793          	sll	a5,s1,0x3
    80004648:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffda700>
    8000464c:	97a2                	add	a5,a5,s0
    8000464e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004652:	00148693          	add	a3,s1,1
    80004656:	068e                	sll	a3,a3,0x3
    80004658:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000465c:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80004660:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004664:	f57966e3          	bltu	s2,s7,800045b0 <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004668:	e9040613          	add	a2,s0,-368
    8000466c:	85ca                	mv	a1,s2
    8000466e:	855a                	mv	a0,s6
    80004670:	ffffc097          	auipc	ra,0xffffc
    80004674:	526080e7          	jalr	1318(ra) # 80000b96 <copyout>
    80004678:	0e054863          	bltz	a0,80004768 <exec+0x3d8>
  p->trapframe->a1 = sp;
    8000467c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004680:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004684:	df843783          	ld	a5,-520(s0)
    80004688:	0007c703          	lbu	a4,0(a5)
    8000468c:	cf11                	beqz	a4,800046a8 <exec+0x318>
    8000468e:	0785                	add	a5,a5,1
    if(*s == '/')
    80004690:	02f00693          	li	a3,47
    80004694:	a039                	j	800046a2 <exec+0x312>
      last = s+1;
    80004696:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000469a:	0785                	add	a5,a5,1
    8000469c:	fff7c703          	lbu	a4,-1(a5)
    800046a0:	c701                	beqz	a4,800046a8 <exec+0x318>
    if(*s == '/')
    800046a2:	fed71ce3          	bne	a4,a3,8000469a <exec+0x30a>
    800046a6:	bfc5                	j	80004696 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    800046a8:	4641                	li	a2,16
    800046aa:	df843583          	ld	a1,-520(s0)
    800046ae:	158a8513          	add	a0,s5,344
    800046b2:	ffffc097          	auipc	ra,0xffffc
    800046b6:	c54080e7          	jalr	-940(ra) # 80000306 <safestrcpy>
  oldpagetable = p->pagetable;
    800046ba:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800046be:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800046c2:	e0843783          	ld	a5,-504(s0)
    800046c6:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800046ca:	058ab783          	ld	a5,88(s5)
    800046ce:	e6843703          	ld	a4,-408(s0)
    800046d2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800046d4:	058ab783          	ld	a5,88(s5)
    800046d8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800046dc:	85e6                	mv	a1,s9
    800046de:	ffffd097          	auipc	ra,0xffffd
    800046e2:	9d6080e7          	jalr	-1578(ra) # 800010b4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800046e6:	0004851b          	sext.w	a0,s1
    800046ea:	79be                	ld	s3,488(sp)
    800046ec:	7a1e                	ld	s4,480(sp)
    800046ee:	6afe                	ld	s5,472(sp)
    800046f0:	6b5e                	ld	s6,464(sp)
    800046f2:	6bbe                	ld	s7,456(sp)
    800046f4:	6c1e                	ld	s8,448(sp)
    800046f6:	7cfa                	ld	s9,440(sp)
    800046f8:	7d5a                	ld	s10,432(sp)
    800046fa:	b305                	j	8000441a <exec+0x8a>
    800046fc:	e1243423          	sd	s2,-504(s0)
    80004700:	7dba                	ld	s11,424(sp)
    80004702:	a035                	j	8000472e <exec+0x39e>
    80004704:	e1243423          	sd	s2,-504(s0)
    80004708:	7dba                	ld	s11,424(sp)
    8000470a:	a015                	j	8000472e <exec+0x39e>
    8000470c:	e1243423          	sd	s2,-504(s0)
    80004710:	7dba                	ld	s11,424(sp)
    80004712:	a831                	j	8000472e <exec+0x39e>
    80004714:	e1243423          	sd	s2,-504(s0)
    80004718:	7dba                	ld	s11,424(sp)
    8000471a:	a811                	j	8000472e <exec+0x39e>
    8000471c:	e1243423          	sd	s2,-504(s0)
    80004720:	7dba                	ld	s11,424(sp)
    80004722:	a031                	j	8000472e <exec+0x39e>
  ip = 0;
    80004724:	4a01                	li	s4,0
    80004726:	a021                	j	8000472e <exec+0x39e>
    80004728:	4a01                	li	s4,0
  if(pagetable)
    8000472a:	a011                	j	8000472e <exec+0x39e>
    8000472c:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    8000472e:	e0843583          	ld	a1,-504(s0)
    80004732:	855a                	mv	a0,s6
    80004734:	ffffd097          	auipc	ra,0xffffd
    80004738:	980080e7          	jalr	-1664(ra) # 800010b4 <proc_freepagetable>
  return -1;
    8000473c:	557d                	li	a0,-1
  if(ip){
    8000473e:	000a1b63          	bnez	s4,80004754 <exec+0x3c4>
    80004742:	79be                	ld	s3,488(sp)
    80004744:	7a1e                	ld	s4,480(sp)
    80004746:	6afe                	ld	s5,472(sp)
    80004748:	6b5e                	ld	s6,464(sp)
    8000474a:	6bbe                	ld	s7,456(sp)
    8000474c:	6c1e                	ld	s8,448(sp)
    8000474e:	7cfa                	ld	s9,440(sp)
    80004750:	7d5a                	ld	s10,432(sp)
    80004752:	b1e1                	j	8000441a <exec+0x8a>
    80004754:	79be                	ld	s3,488(sp)
    80004756:	6afe                	ld	s5,472(sp)
    80004758:	6b5e                	ld	s6,464(sp)
    8000475a:	6bbe                	ld	s7,456(sp)
    8000475c:	6c1e                	ld	s8,448(sp)
    8000475e:	7cfa                	ld	s9,440(sp)
    80004760:	7d5a                	ld	s10,432(sp)
    80004762:	b14d                	j	80004404 <exec+0x74>
    80004764:	6b5e                	ld	s6,464(sp)
    80004766:	b979                	j	80004404 <exec+0x74>
  sz = sz1;
    80004768:	e0843983          	ld	s3,-504(s0)
    8000476c:	b591                	j	800045b0 <exec+0x220>

000000008000476e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000476e:	7179                	add	sp,sp,-48
    80004770:	f406                	sd	ra,40(sp)
    80004772:	f022                	sd	s0,32(sp)
    80004774:	ec26                	sd	s1,24(sp)
    80004776:	e84a                	sd	s2,16(sp)
    80004778:	1800                	add	s0,sp,48
    8000477a:	892e                	mv	s2,a1
    8000477c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000477e:	fdc40593          	add	a1,s0,-36
    80004782:	ffffe097          	auipc	ra,0xffffe
    80004786:	928080e7          	jalr	-1752(ra) # 800020aa <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000478a:	fdc42703          	lw	a4,-36(s0)
    8000478e:	47bd                	li	a5,15
    80004790:	02e7eb63          	bltu	a5,a4,800047c6 <argfd+0x58>
    80004794:	ffffc097          	auipc	ra,0xffffc
    80004798:	7bc080e7          	jalr	1980(ra) # 80000f50 <myproc>
    8000479c:	fdc42703          	lw	a4,-36(s0)
    800047a0:	01a70793          	add	a5,a4,26
    800047a4:	078e                	sll	a5,a5,0x3
    800047a6:	953e                	add	a0,a0,a5
    800047a8:	611c                	ld	a5,0(a0)
    800047aa:	c385                	beqz	a5,800047ca <argfd+0x5c>
    return -1;
  if(pfd)
    800047ac:	00090463          	beqz	s2,800047b4 <argfd+0x46>
    *pfd = fd;
    800047b0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800047b4:	4501                	li	a0,0
  if(pf)
    800047b6:	c091                	beqz	s1,800047ba <argfd+0x4c>
    *pf = f;
    800047b8:	e09c                	sd	a5,0(s1)
}
    800047ba:	70a2                	ld	ra,40(sp)
    800047bc:	7402                	ld	s0,32(sp)
    800047be:	64e2                	ld	s1,24(sp)
    800047c0:	6942                	ld	s2,16(sp)
    800047c2:	6145                	add	sp,sp,48
    800047c4:	8082                	ret
    return -1;
    800047c6:	557d                	li	a0,-1
    800047c8:	bfcd                	j	800047ba <argfd+0x4c>
    800047ca:	557d                	li	a0,-1
    800047cc:	b7fd                	j	800047ba <argfd+0x4c>

00000000800047ce <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800047ce:	1101                	add	sp,sp,-32
    800047d0:	ec06                	sd	ra,24(sp)
    800047d2:	e822                	sd	s0,16(sp)
    800047d4:	e426                	sd	s1,8(sp)
    800047d6:	1000                	add	s0,sp,32
    800047d8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800047da:	ffffc097          	auipc	ra,0xffffc
    800047de:	776080e7          	jalr	1910(ra) # 80000f50 <myproc>
    800047e2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800047e4:	0d050793          	add	a5,a0,208
    800047e8:	4501                	li	a0,0
    800047ea:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800047ec:	6398                	ld	a4,0(a5)
    800047ee:	cb19                	beqz	a4,80004804 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800047f0:	2505                	addw	a0,a0,1
    800047f2:	07a1                	add	a5,a5,8
    800047f4:	fed51ce3          	bne	a0,a3,800047ec <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800047f8:	557d                	li	a0,-1
}
    800047fa:	60e2                	ld	ra,24(sp)
    800047fc:	6442                	ld	s0,16(sp)
    800047fe:	64a2                	ld	s1,8(sp)
    80004800:	6105                	add	sp,sp,32
    80004802:	8082                	ret
      p->ofile[fd] = f;
    80004804:	01a50793          	add	a5,a0,26
    80004808:	078e                	sll	a5,a5,0x3
    8000480a:	963e                	add	a2,a2,a5
    8000480c:	e204                	sd	s1,0(a2)
      return fd;
    8000480e:	b7f5                	j	800047fa <fdalloc+0x2c>

0000000080004810 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004810:	715d                	add	sp,sp,-80
    80004812:	e486                	sd	ra,72(sp)
    80004814:	e0a2                	sd	s0,64(sp)
    80004816:	fc26                	sd	s1,56(sp)
    80004818:	f84a                	sd	s2,48(sp)
    8000481a:	f44e                	sd	s3,40(sp)
    8000481c:	ec56                	sd	s5,24(sp)
    8000481e:	e85a                	sd	s6,16(sp)
    80004820:	0880                	add	s0,sp,80
    80004822:	8b2e                	mv	s6,a1
    80004824:	89b2                	mv	s3,a2
    80004826:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004828:	fb040593          	add	a1,s0,-80
    8000482c:	fffff097          	auipc	ra,0xfffff
    80004830:	de2080e7          	jalr	-542(ra) # 8000360e <nameiparent>
    80004834:	84aa                	mv	s1,a0
    80004836:	14050e63          	beqz	a0,80004992 <create+0x182>
    return 0;

  ilock(dp);
    8000483a:	ffffe097          	auipc	ra,0xffffe
    8000483e:	5e8080e7          	jalr	1512(ra) # 80002e22 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004842:	4601                	li	a2,0
    80004844:	fb040593          	add	a1,s0,-80
    80004848:	8526                	mv	a0,s1
    8000484a:	fffff097          	auipc	ra,0xfffff
    8000484e:	ae4080e7          	jalr	-1308(ra) # 8000332e <dirlookup>
    80004852:	8aaa                	mv	s5,a0
    80004854:	c539                	beqz	a0,800048a2 <create+0x92>
    iunlockput(dp);
    80004856:	8526                	mv	a0,s1
    80004858:	fffff097          	auipc	ra,0xfffff
    8000485c:	830080e7          	jalr	-2000(ra) # 80003088 <iunlockput>
    ilock(ip);
    80004860:	8556                	mv	a0,s5
    80004862:	ffffe097          	auipc	ra,0xffffe
    80004866:	5c0080e7          	jalr	1472(ra) # 80002e22 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000486a:	4789                	li	a5,2
    8000486c:	02fb1463          	bne	s6,a5,80004894 <create+0x84>
    80004870:	044ad783          	lhu	a5,68(s5)
    80004874:	37f9                	addw	a5,a5,-2
    80004876:	17c2                	sll	a5,a5,0x30
    80004878:	93c1                	srl	a5,a5,0x30
    8000487a:	4705                	li	a4,1
    8000487c:	00f76c63          	bltu	a4,a5,80004894 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004880:	8556                	mv	a0,s5
    80004882:	60a6                	ld	ra,72(sp)
    80004884:	6406                	ld	s0,64(sp)
    80004886:	74e2                	ld	s1,56(sp)
    80004888:	7942                	ld	s2,48(sp)
    8000488a:	79a2                	ld	s3,40(sp)
    8000488c:	6ae2                	ld	s5,24(sp)
    8000488e:	6b42                	ld	s6,16(sp)
    80004890:	6161                	add	sp,sp,80
    80004892:	8082                	ret
    iunlockput(ip);
    80004894:	8556                	mv	a0,s5
    80004896:	ffffe097          	auipc	ra,0xffffe
    8000489a:	7f2080e7          	jalr	2034(ra) # 80003088 <iunlockput>
    return 0;
    8000489e:	4a81                	li	s5,0
    800048a0:	b7c5                	j	80004880 <create+0x70>
    800048a2:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800048a4:	85da                	mv	a1,s6
    800048a6:	4088                	lw	a0,0(s1)
    800048a8:	ffffe097          	auipc	ra,0xffffe
    800048ac:	3d6080e7          	jalr	982(ra) # 80002c7e <ialloc>
    800048b0:	8a2a                	mv	s4,a0
    800048b2:	c531                	beqz	a0,800048fe <create+0xee>
  ilock(ip);
    800048b4:	ffffe097          	auipc	ra,0xffffe
    800048b8:	56e080e7          	jalr	1390(ra) # 80002e22 <ilock>
  ip->major = major;
    800048bc:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800048c0:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800048c4:	4905                	li	s2,1
    800048c6:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800048ca:	8552                	mv	a0,s4
    800048cc:	ffffe097          	auipc	ra,0xffffe
    800048d0:	48a080e7          	jalr	1162(ra) # 80002d56 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800048d4:	032b0d63          	beq	s6,s2,8000490e <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800048d8:	004a2603          	lw	a2,4(s4)
    800048dc:	fb040593          	add	a1,s0,-80
    800048e0:	8526                	mv	a0,s1
    800048e2:	fffff097          	auipc	ra,0xfffff
    800048e6:	c5c080e7          	jalr	-932(ra) # 8000353e <dirlink>
    800048ea:	08054163          	bltz	a0,8000496c <create+0x15c>
  iunlockput(dp);
    800048ee:	8526                	mv	a0,s1
    800048f0:	ffffe097          	auipc	ra,0xffffe
    800048f4:	798080e7          	jalr	1944(ra) # 80003088 <iunlockput>
  return ip;
    800048f8:	8ad2                	mv	s5,s4
    800048fa:	7a02                	ld	s4,32(sp)
    800048fc:	b751                	j	80004880 <create+0x70>
    iunlockput(dp);
    800048fe:	8526                	mv	a0,s1
    80004900:	ffffe097          	auipc	ra,0xffffe
    80004904:	788080e7          	jalr	1928(ra) # 80003088 <iunlockput>
    return 0;
    80004908:	8ad2                	mv	s5,s4
    8000490a:	7a02                	ld	s4,32(sp)
    8000490c:	bf95                	j	80004880 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000490e:	004a2603          	lw	a2,4(s4)
    80004912:	00004597          	auipc	a1,0x4
    80004916:	d6e58593          	add	a1,a1,-658 # 80008680 <etext+0x680>
    8000491a:	8552                	mv	a0,s4
    8000491c:	fffff097          	auipc	ra,0xfffff
    80004920:	c22080e7          	jalr	-990(ra) # 8000353e <dirlink>
    80004924:	04054463          	bltz	a0,8000496c <create+0x15c>
    80004928:	40d0                	lw	a2,4(s1)
    8000492a:	00004597          	auipc	a1,0x4
    8000492e:	d5e58593          	add	a1,a1,-674 # 80008688 <etext+0x688>
    80004932:	8552                	mv	a0,s4
    80004934:	fffff097          	auipc	ra,0xfffff
    80004938:	c0a080e7          	jalr	-1014(ra) # 8000353e <dirlink>
    8000493c:	02054863          	bltz	a0,8000496c <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004940:	004a2603          	lw	a2,4(s4)
    80004944:	fb040593          	add	a1,s0,-80
    80004948:	8526                	mv	a0,s1
    8000494a:	fffff097          	auipc	ra,0xfffff
    8000494e:	bf4080e7          	jalr	-1036(ra) # 8000353e <dirlink>
    80004952:	00054d63          	bltz	a0,8000496c <create+0x15c>
    dp->nlink++;  // for ".."
    80004956:	04a4d783          	lhu	a5,74(s1)
    8000495a:	2785                	addw	a5,a5,1
    8000495c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004960:	8526                	mv	a0,s1
    80004962:	ffffe097          	auipc	ra,0xffffe
    80004966:	3f4080e7          	jalr	1012(ra) # 80002d56 <iupdate>
    8000496a:	b751                	j	800048ee <create+0xde>
  ip->nlink = 0;
    8000496c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004970:	8552                	mv	a0,s4
    80004972:	ffffe097          	auipc	ra,0xffffe
    80004976:	3e4080e7          	jalr	996(ra) # 80002d56 <iupdate>
  iunlockput(ip);
    8000497a:	8552                	mv	a0,s4
    8000497c:	ffffe097          	auipc	ra,0xffffe
    80004980:	70c080e7          	jalr	1804(ra) # 80003088 <iunlockput>
  iunlockput(dp);
    80004984:	8526                	mv	a0,s1
    80004986:	ffffe097          	auipc	ra,0xffffe
    8000498a:	702080e7          	jalr	1794(ra) # 80003088 <iunlockput>
  return 0;
    8000498e:	7a02                	ld	s4,32(sp)
    80004990:	bdc5                	j	80004880 <create+0x70>
    return 0;
    80004992:	8aaa                	mv	s5,a0
    80004994:	b5f5                	j	80004880 <create+0x70>

0000000080004996 <sys_dup>:
{
    80004996:	7179                	add	sp,sp,-48
    80004998:	f406                	sd	ra,40(sp)
    8000499a:	f022                	sd	s0,32(sp)
    8000499c:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000499e:	fd840613          	add	a2,s0,-40
    800049a2:	4581                	li	a1,0
    800049a4:	4501                	li	a0,0
    800049a6:	00000097          	auipc	ra,0x0
    800049aa:	dc8080e7          	jalr	-568(ra) # 8000476e <argfd>
    return -1;
    800049ae:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800049b0:	02054763          	bltz	a0,800049de <sys_dup+0x48>
    800049b4:	ec26                	sd	s1,24(sp)
    800049b6:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800049b8:	fd843903          	ld	s2,-40(s0)
    800049bc:	854a                	mv	a0,s2
    800049be:	00000097          	auipc	ra,0x0
    800049c2:	e10080e7          	jalr	-496(ra) # 800047ce <fdalloc>
    800049c6:	84aa                	mv	s1,a0
    return -1;
    800049c8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800049ca:	00054f63          	bltz	a0,800049e8 <sys_dup+0x52>
  filedup(f);
    800049ce:	854a                	mv	a0,s2
    800049d0:	fffff097          	auipc	ra,0xfffff
    800049d4:	298080e7          	jalr	664(ra) # 80003c68 <filedup>
  return fd;
    800049d8:	87a6                	mv	a5,s1
    800049da:	64e2                	ld	s1,24(sp)
    800049dc:	6942                	ld	s2,16(sp)
}
    800049de:	853e                	mv	a0,a5
    800049e0:	70a2                	ld	ra,40(sp)
    800049e2:	7402                	ld	s0,32(sp)
    800049e4:	6145                	add	sp,sp,48
    800049e6:	8082                	ret
    800049e8:	64e2                	ld	s1,24(sp)
    800049ea:	6942                	ld	s2,16(sp)
    800049ec:	bfcd                	j	800049de <sys_dup+0x48>

00000000800049ee <sys_read>:
{
    800049ee:	7179                	add	sp,sp,-48
    800049f0:	f406                	sd	ra,40(sp)
    800049f2:	f022                	sd	s0,32(sp)
    800049f4:	1800                	add	s0,sp,48
  argaddr(1, &p);
    800049f6:	fd840593          	add	a1,s0,-40
    800049fa:	4505                	li	a0,1
    800049fc:	ffffd097          	auipc	ra,0xffffd
    80004a00:	6ce080e7          	jalr	1742(ra) # 800020ca <argaddr>
  argint(2, &n);
    80004a04:	fe440593          	add	a1,s0,-28
    80004a08:	4509                	li	a0,2
    80004a0a:	ffffd097          	auipc	ra,0xffffd
    80004a0e:	6a0080e7          	jalr	1696(ra) # 800020aa <argint>
  if(argfd(0, 0, &f) < 0)
    80004a12:	fe840613          	add	a2,s0,-24
    80004a16:	4581                	li	a1,0
    80004a18:	4501                	li	a0,0
    80004a1a:	00000097          	auipc	ra,0x0
    80004a1e:	d54080e7          	jalr	-684(ra) # 8000476e <argfd>
    80004a22:	87aa                	mv	a5,a0
    return -1;
    80004a24:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a26:	0007cc63          	bltz	a5,80004a3e <sys_read+0x50>
  return fileread(f, p, n);
    80004a2a:	fe442603          	lw	a2,-28(s0)
    80004a2e:	fd843583          	ld	a1,-40(s0)
    80004a32:	fe843503          	ld	a0,-24(s0)
    80004a36:	fffff097          	auipc	ra,0xfffff
    80004a3a:	3d8080e7          	jalr	984(ra) # 80003e0e <fileread>
}
    80004a3e:	70a2                	ld	ra,40(sp)
    80004a40:	7402                	ld	s0,32(sp)
    80004a42:	6145                	add	sp,sp,48
    80004a44:	8082                	ret

0000000080004a46 <sys_write>:
{
    80004a46:	7179                	add	sp,sp,-48
    80004a48:	f406                	sd	ra,40(sp)
    80004a4a:	f022                	sd	s0,32(sp)
    80004a4c:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004a4e:	fd840593          	add	a1,s0,-40
    80004a52:	4505                	li	a0,1
    80004a54:	ffffd097          	auipc	ra,0xffffd
    80004a58:	676080e7          	jalr	1654(ra) # 800020ca <argaddr>
  argint(2, &n);
    80004a5c:	fe440593          	add	a1,s0,-28
    80004a60:	4509                	li	a0,2
    80004a62:	ffffd097          	auipc	ra,0xffffd
    80004a66:	648080e7          	jalr	1608(ra) # 800020aa <argint>
  if(argfd(0, 0, &f) < 0)
    80004a6a:	fe840613          	add	a2,s0,-24
    80004a6e:	4581                	li	a1,0
    80004a70:	4501                	li	a0,0
    80004a72:	00000097          	auipc	ra,0x0
    80004a76:	cfc080e7          	jalr	-772(ra) # 8000476e <argfd>
    80004a7a:	87aa                	mv	a5,a0
    return -1;
    80004a7c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a7e:	0007cc63          	bltz	a5,80004a96 <sys_write+0x50>
  return filewrite(f, p, n);
    80004a82:	fe442603          	lw	a2,-28(s0)
    80004a86:	fd843583          	ld	a1,-40(s0)
    80004a8a:	fe843503          	ld	a0,-24(s0)
    80004a8e:	fffff097          	auipc	ra,0xfffff
    80004a92:	452080e7          	jalr	1106(ra) # 80003ee0 <filewrite>
}
    80004a96:	70a2                	ld	ra,40(sp)
    80004a98:	7402                	ld	s0,32(sp)
    80004a9a:	6145                	add	sp,sp,48
    80004a9c:	8082                	ret

0000000080004a9e <sys_close>:
{
    80004a9e:	1101                	add	sp,sp,-32
    80004aa0:	ec06                	sd	ra,24(sp)
    80004aa2:	e822                	sd	s0,16(sp)
    80004aa4:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004aa6:	fe040613          	add	a2,s0,-32
    80004aaa:	fec40593          	add	a1,s0,-20
    80004aae:	4501                	li	a0,0
    80004ab0:	00000097          	auipc	ra,0x0
    80004ab4:	cbe080e7          	jalr	-834(ra) # 8000476e <argfd>
    return -1;
    80004ab8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004aba:	02054463          	bltz	a0,80004ae2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004abe:	ffffc097          	auipc	ra,0xffffc
    80004ac2:	492080e7          	jalr	1170(ra) # 80000f50 <myproc>
    80004ac6:	fec42783          	lw	a5,-20(s0)
    80004aca:	07e9                	add	a5,a5,26
    80004acc:	078e                	sll	a5,a5,0x3
    80004ace:	953e                	add	a0,a0,a5
    80004ad0:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004ad4:	fe043503          	ld	a0,-32(s0)
    80004ad8:	fffff097          	auipc	ra,0xfffff
    80004adc:	1e2080e7          	jalr	482(ra) # 80003cba <fileclose>
  return 0;
    80004ae0:	4781                	li	a5,0
}
    80004ae2:	853e                	mv	a0,a5
    80004ae4:	60e2                	ld	ra,24(sp)
    80004ae6:	6442                	ld	s0,16(sp)
    80004ae8:	6105                	add	sp,sp,32
    80004aea:	8082                	ret

0000000080004aec <sys_fstat>:
{
    80004aec:	1101                	add	sp,sp,-32
    80004aee:	ec06                	sd	ra,24(sp)
    80004af0:	e822                	sd	s0,16(sp)
    80004af2:	1000                	add	s0,sp,32
  argaddr(1, &st);
    80004af4:	fe040593          	add	a1,s0,-32
    80004af8:	4505                	li	a0,1
    80004afa:	ffffd097          	auipc	ra,0xffffd
    80004afe:	5d0080e7          	jalr	1488(ra) # 800020ca <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004b02:	fe840613          	add	a2,s0,-24
    80004b06:	4581                	li	a1,0
    80004b08:	4501                	li	a0,0
    80004b0a:	00000097          	auipc	ra,0x0
    80004b0e:	c64080e7          	jalr	-924(ra) # 8000476e <argfd>
    80004b12:	87aa                	mv	a5,a0
    return -1;
    80004b14:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b16:	0007ca63          	bltz	a5,80004b2a <sys_fstat+0x3e>
  return filestat(f, st);
    80004b1a:	fe043583          	ld	a1,-32(s0)
    80004b1e:	fe843503          	ld	a0,-24(s0)
    80004b22:	fffff097          	auipc	ra,0xfffff
    80004b26:	27a080e7          	jalr	634(ra) # 80003d9c <filestat>
}
    80004b2a:	60e2                	ld	ra,24(sp)
    80004b2c:	6442                	ld	s0,16(sp)
    80004b2e:	6105                	add	sp,sp,32
    80004b30:	8082                	ret

0000000080004b32 <sys_link>:
{
    80004b32:	7169                	add	sp,sp,-304
    80004b34:	f606                	sd	ra,296(sp)
    80004b36:	f222                	sd	s0,288(sp)
    80004b38:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b3a:	08000613          	li	a2,128
    80004b3e:	ed040593          	add	a1,s0,-304
    80004b42:	4501                	li	a0,0
    80004b44:	ffffd097          	auipc	ra,0xffffd
    80004b48:	5a6080e7          	jalr	1446(ra) # 800020ea <argstr>
    return -1;
    80004b4c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b4e:	12054663          	bltz	a0,80004c7a <sys_link+0x148>
    80004b52:	08000613          	li	a2,128
    80004b56:	f5040593          	add	a1,s0,-176
    80004b5a:	4505                	li	a0,1
    80004b5c:	ffffd097          	auipc	ra,0xffffd
    80004b60:	58e080e7          	jalr	1422(ra) # 800020ea <argstr>
    return -1;
    80004b64:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b66:	10054a63          	bltz	a0,80004c7a <sys_link+0x148>
    80004b6a:	ee26                	sd	s1,280(sp)
  begin_op();
    80004b6c:	fffff097          	auipc	ra,0xfffff
    80004b70:	c84080e7          	jalr	-892(ra) # 800037f0 <begin_op>
  if((ip = namei(old)) == 0){
    80004b74:	ed040513          	add	a0,s0,-304
    80004b78:	fffff097          	auipc	ra,0xfffff
    80004b7c:	a78080e7          	jalr	-1416(ra) # 800035f0 <namei>
    80004b80:	84aa                	mv	s1,a0
    80004b82:	c949                	beqz	a0,80004c14 <sys_link+0xe2>
  ilock(ip);
    80004b84:	ffffe097          	auipc	ra,0xffffe
    80004b88:	29e080e7          	jalr	670(ra) # 80002e22 <ilock>
  if(ip->type == T_DIR){
    80004b8c:	04449703          	lh	a4,68(s1)
    80004b90:	4785                	li	a5,1
    80004b92:	08f70863          	beq	a4,a5,80004c22 <sys_link+0xf0>
    80004b96:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004b98:	04a4d783          	lhu	a5,74(s1)
    80004b9c:	2785                	addw	a5,a5,1
    80004b9e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ba2:	8526                	mv	a0,s1
    80004ba4:	ffffe097          	auipc	ra,0xffffe
    80004ba8:	1b2080e7          	jalr	434(ra) # 80002d56 <iupdate>
  iunlock(ip);
    80004bac:	8526                	mv	a0,s1
    80004bae:	ffffe097          	auipc	ra,0xffffe
    80004bb2:	33a080e7          	jalr	826(ra) # 80002ee8 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004bb6:	fd040593          	add	a1,s0,-48
    80004bba:	f5040513          	add	a0,s0,-176
    80004bbe:	fffff097          	auipc	ra,0xfffff
    80004bc2:	a50080e7          	jalr	-1456(ra) # 8000360e <nameiparent>
    80004bc6:	892a                	mv	s2,a0
    80004bc8:	cd35                	beqz	a0,80004c44 <sys_link+0x112>
  ilock(dp);
    80004bca:	ffffe097          	auipc	ra,0xffffe
    80004bce:	258080e7          	jalr	600(ra) # 80002e22 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004bd2:	00092703          	lw	a4,0(s2)
    80004bd6:	409c                	lw	a5,0(s1)
    80004bd8:	06f71163          	bne	a4,a5,80004c3a <sys_link+0x108>
    80004bdc:	40d0                	lw	a2,4(s1)
    80004bde:	fd040593          	add	a1,s0,-48
    80004be2:	854a                	mv	a0,s2
    80004be4:	fffff097          	auipc	ra,0xfffff
    80004be8:	95a080e7          	jalr	-1702(ra) # 8000353e <dirlink>
    80004bec:	04054763          	bltz	a0,80004c3a <sys_link+0x108>
  iunlockput(dp);
    80004bf0:	854a                	mv	a0,s2
    80004bf2:	ffffe097          	auipc	ra,0xffffe
    80004bf6:	496080e7          	jalr	1174(ra) # 80003088 <iunlockput>
  iput(ip);
    80004bfa:	8526                	mv	a0,s1
    80004bfc:	ffffe097          	auipc	ra,0xffffe
    80004c00:	3e4080e7          	jalr	996(ra) # 80002fe0 <iput>
  end_op();
    80004c04:	fffff097          	auipc	ra,0xfffff
    80004c08:	c66080e7          	jalr	-922(ra) # 8000386a <end_op>
  return 0;
    80004c0c:	4781                	li	a5,0
    80004c0e:	64f2                	ld	s1,280(sp)
    80004c10:	6952                	ld	s2,272(sp)
    80004c12:	a0a5                	j	80004c7a <sys_link+0x148>
    end_op();
    80004c14:	fffff097          	auipc	ra,0xfffff
    80004c18:	c56080e7          	jalr	-938(ra) # 8000386a <end_op>
    return -1;
    80004c1c:	57fd                	li	a5,-1
    80004c1e:	64f2                	ld	s1,280(sp)
    80004c20:	a8a9                	j	80004c7a <sys_link+0x148>
    iunlockput(ip);
    80004c22:	8526                	mv	a0,s1
    80004c24:	ffffe097          	auipc	ra,0xffffe
    80004c28:	464080e7          	jalr	1124(ra) # 80003088 <iunlockput>
    end_op();
    80004c2c:	fffff097          	auipc	ra,0xfffff
    80004c30:	c3e080e7          	jalr	-962(ra) # 8000386a <end_op>
    return -1;
    80004c34:	57fd                	li	a5,-1
    80004c36:	64f2                	ld	s1,280(sp)
    80004c38:	a089                	j	80004c7a <sys_link+0x148>
    iunlockput(dp);
    80004c3a:	854a                	mv	a0,s2
    80004c3c:	ffffe097          	auipc	ra,0xffffe
    80004c40:	44c080e7          	jalr	1100(ra) # 80003088 <iunlockput>
  ilock(ip);
    80004c44:	8526                	mv	a0,s1
    80004c46:	ffffe097          	auipc	ra,0xffffe
    80004c4a:	1dc080e7          	jalr	476(ra) # 80002e22 <ilock>
  ip->nlink--;
    80004c4e:	04a4d783          	lhu	a5,74(s1)
    80004c52:	37fd                	addw	a5,a5,-1
    80004c54:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c58:	8526                	mv	a0,s1
    80004c5a:	ffffe097          	auipc	ra,0xffffe
    80004c5e:	0fc080e7          	jalr	252(ra) # 80002d56 <iupdate>
  iunlockput(ip);
    80004c62:	8526                	mv	a0,s1
    80004c64:	ffffe097          	auipc	ra,0xffffe
    80004c68:	424080e7          	jalr	1060(ra) # 80003088 <iunlockput>
  end_op();
    80004c6c:	fffff097          	auipc	ra,0xfffff
    80004c70:	bfe080e7          	jalr	-1026(ra) # 8000386a <end_op>
  return -1;
    80004c74:	57fd                	li	a5,-1
    80004c76:	64f2                	ld	s1,280(sp)
    80004c78:	6952                	ld	s2,272(sp)
}
    80004c7a:	853e                	mv	a0,a5
    80004c7c:	70b2                	ld	ra,296(sp)
    80004c7e:	7412                	ld	s0,288(sp)
    80004c80:	6155                	add	sp,sp,304
    80004c82:	8082                	ret

0000000080004c84 <sys_unlink>:
{
    80004c84:	7151                	add	sp,sp,-240
    80004c86:	f586                	sd	ra,232(sp)
    80004c88:	f1a2                	sd	s0,224(sp)
    80004c8a:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004c8c:	08000613          	li	a2,128
    80004c90:	f3040593          	add	a1,s0,-208
    80004c94:	4501                	li	a0,0
    80004c96:	ffffd097          	auipc	ra,0xffffd
    80004c9a:	454080e7          	jalr	1108(ra) # 800020ea <argstr>
    80004c9e:	1a054a63          	bltz	a0,80004e52 <sys_unlink+0x1ce>
    80004ca2:	eda6                	sd	s1,216(sp)
  begin_op();
    80004ca4:	fffff097          	auipc	ra,0xfffff
    80004ca8:	b4c080e7          	jalr	-1204(ra) # 800037f0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004cac:	fb040593          	add	a1,s0,-80
    80004cb0:	f3040513          	add	a0,s0,-208
    80004cb4:	fffff097          	auipc	ra,0xfffff
    80004cb8:	95a080e7          	jalr	-1702(ra) # 8000360e <nameiparent>
    80004cbc:	84aa                	mv	s1,a0
    80004cbe:	cd71                	beqz	a0,80004d9a <sys_unlink+0x116>
  ilock(dp);
    80004cc0:	ffffe097          	auipc	ra,0xffffe
    80004cc4:	162080e7          	jalr	354(ra) # 80002e22 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004cc8:	00004597          	auipc	a1,0x4
    80004ccc:	9b858593          	add	a1,a1,-1608 # 80008680 <etext+0x680>
    80004cd0:	fb040513          	add	a0,s0,-80
    80004cd4:	ffffe097          	auipc	ra,0xffffe
    80004cd8:	640080e7          	jalr	1600(ra) # 80003314 <namecmp>
    80004cdc:	14050c63          	beqz	a0,80004e34 <sys_unlink+0x1b0>
    80004ce0:	00004597          	auipc	a1,0x4
    80004ce4:	9a858593          	add	a1,a1,-1624 # 80008688 <etext+0x688>
    80004ce8:	fb040513          	add	a0,s0,-80
    80004cec:	ffffe097          	auipc	ra,0xffffe
    80004cf0:	628080e7          	jalr	1576(ra) # 80003314 <namecmp>
    80004cf4:	14050063          	beqz	a0,80004e34 <sys_unlink+0x1b0>
    80004cf8:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004cfa:	f2c40613          	add	a2,s0,-212
    80004cfe:	fb040593          	add	a1,s0,-80
    80004d02:	8526                	mv	a0,s1
    80004d04:	ffffe097          	auipc	ra,0xffffe
    80004d08:	62a080e7          	jalr	1578(ra) # 8000332e <dirlookup>
    80004d0c:	892a                	mv	s2,a0
    80004d0e:	12050263          	beqz	a0,80004e32 <sys_unlink+0x1ae>
  ilock(ip);
    80004d12:	ffffe097          	auipc	ra,0xffffe
    80004d16:	110080e7          	jalr	272(ra) # 80002e22 <ilock>
  if(ip->nlink < 1)
    80004d1a:	04a91783          	lh	a5,74(s2)
    80004d1e:	08f05563          	blez	a5,80004da8 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004d22:	04491703          	lh	a4,68(s2)
    80004d26:	4785                	li	a5,1
    80004d28:	08f70963          	beq	a4,a5,80004dba <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004d2c:	4641                	li	a2,16
    80004d2e:	4581                	li	a1,0
    80004d30:	fc040513          	add	a0,s0,-64
    80004d34:	ffffb097          	auipc	ra,0xffffb
    80004d38:	490080e7          	jalr	1168(ra) # 800001c4 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d3c:	4741                	li	a4,16
    80004d3e:	f2c42683          	lw	a3,-212(s0)
    80004d42:	fc040613          	add	a2,s0,-64
    80004d46:	4581                	li	a1,0
    80004d48:	8526                	mv	a0,s1
    80004d4a:	ffffe097          	auipc	ra,0xffffe
    80004d4e:	4a0080e7          	jalr	1184(ra) # 800031ea <writei>
    80004d52:	47c1                	li	a5,16
    80004d54:	0af51b63          	bne	a0,a5,80004e0a <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004d58:	04491703          	lh	a4,68(s2)
    80004d5c:	4785                	li	a5,1
    80004d5e:	0af70f63          	beq	a4,a5,80004e1c <sys_unlink+0x198>
  iunlockput(dp);
    80004d62:	8526                	mv	a0,s1
    80004d64:	ffffe097          	auipc	ra,0xffffe
    80004d68:	324080e7          	jalr	804(ra) # 80003088 <iunlockput>
  ip->nlink--;
    80004d6c:	04a95783          	lhu	a5,74(s2)
    80004d70:	37fd                	addw	a5,a5,-1
    80004d72:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004d76:	854a                	mv	a0,s2
    80004d78:	ffffe097          	auipc	ra,0xffffe
    80004d7c:	fde080e7          	jalr	-34(ra) # 80002d56 <iupdate>
  iunlockput(ip);
    80004d80:	854a                	mv	a0,s2
    80004d82:	ffffe097          	auipc	ra,0xffffe
    80004d86:	306080e7          	jalr	774(ra) # 80003088 <iunlockput>
  end_op();
    80004d8a:	fffff097          	auipc	ra,0xfffff
    80004d8e:	ae0080e7          	jalr	-1312(ra) # 8000386a <end_op>
  return 0;
    80004d92:	4501                	li	a0,0
    80004d94:	64ee                	ld	s1,216(sp)
    80004d96:	694e                	ld	s2,208(sp)
    80004d98:	a84d                	j	80004e4a <sys_unlink+0x1c6>
    end_op();
    80004d9a:	fffff097          	auipc	ra,0xfffff
    80004d9e:	ad0080e7          	jalr	-1328(ra) # 8000386a <end_op>
    return -1;
    80004da2:	557d                	li	a0,-1
    80004da4:	64ee                	ld	s1,216(sp)
    80004da6:	a055                	j	80004e4a <sys_unlink+0x1c6>
    80004da8:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004daa:	00004517          	auipc	a0,0x4
    80004dae:	8e650513          	add	a0,a0,-1818 # 80008690 <etext+0x690>
    80004db2:	00001097          	auipc	ra,0x1
    80004db6:	240080e7          	jalr	576(ra) # 80005ff2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004dba:	04c92703          	lw	a4,76(s2)
    80004dbe:	02000793          	li	a5,32
    80004dc2:	f6e7f5e3          	bgeu	a5,a4,80004d2c <sys_unlink+0xa8>
    80004dc6:	e5ce                	sd	s3,200(sp)
    80004dc8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004dcc:	4741                	li	a4,16
    80004dce:	86ce                	mv	a3,s3
    80004dd0:	f1840613          	add	a2,s0,-232
    80004dd4:	4581                	li	a1,0
    80004dd6:	854a                	mv	a0,s2
    80004dd8:	ffffe097          	auipc	ra,0xffffe
    80004ddc:	302080e7          	jalr	770(ra) # 800030da <readi>
    80004de0:	47c1                	li	a5,16
    80004de2:	00f51c63          	bne	a0,a5,80004dfa <sys_unlink+0x176>
    if(de.inum != 0)
    80004de6:	f1845783          	lhu	a5,-232(s0)
    80004dea:	e7b5                	bnez	a5,80004e56 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004dec:	29c1                	addw	s3,s3,16
    80004dee:	04c92783          	lw	a5,76(s2)
    80004df2:	fcf9ede3          	bltu	s3,a5,80004dcc <sys_unlink+0x148>
    80004df6:	69ae                	ld	s3,200(sp)
    80004df8:	bf15                	j	80004d2c <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004dfa:	00004517          	auipc	a0,0x4
    80004dfe:	8ae50513          	add	a0,a0,-1874 # 800086a8 <etext+0x6a8>
    80004e02:	00001097          	auipc	ra,0x1
    80004e06:	1f0080e7          	jalr	496(ra) # 80005ff2 <panic>
    80004e0a:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004e0c:	00004517          	auipc	a0,0x4
    80004e10:	8b450513          	add	a0,a0,-1868 # 800086c0 <etext+0x6c0>
    80004e14:	00001097          	auipc	ra,0x1
    80004e18:	1de080e7          	jalr	478(ra) # 80005ff2 <panic>
    dp->nlink--;
    80004e1c:	04a4d783          	lhu	a5,74(s1)
    80004e20:	37fd                	addw	a5,a5,-1
    80004e22:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004e26:	8526                	mv	a0,s1
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	f2e080e7          	jalr	-210(ra) # 80002d56 <iupdate>
    80004e30:	bf0d                	j	80004d62 <sys_unlink+0xde>
    80004e32:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004e34:	8526                	mv	a0,s1
    80004e36:	ffffe097          	auipc	ra,0xffffe
    80004e3a:	252080e7          	jalr	594(ra) # 80003088 <iunlockput>
  end_op();
    80004e3e:	fffff097          	auipc	ra,0xfffff
    80004e42:	a2c080e7          	jalr	-1492(ra) # 8000386a <end_op>
  return -1;
    80004e46:	557d                	li	a0,-1
    80004e48:	64ee                	ld	s1,216(sp)
}
    80004e4a:	70ae                	ld	ra,232(sp)
    80004e4c:	740e                	ld	s0,224(sp)
    80004e4e:	616d                	add	sp,sp,240
    80004e50:	8082                	ret
    return -1;
    80004e52:	557d                	li	a0,-1
    80004e54:	bfdd                	j	80004e4a <sys_unlink+0x1c6>
    iunlockput(ip);
    80004e56:	854a                	mv	a0,s2
    80004e58:	ffffe097          	auipc	ra,0xffffe
    80004e5c:	230080e7          	jalr	560(ra) # 80003088 <iunlockput>
    goto bad;
    80004e60:	694e                	ld	s2,208(sp)
    80004e62:	69ae                	ld	s3,200(sp)
    80004e64:	bfc1                	j	80004e34 <sys_unlink+0x1b0>

0000000080004e66 <sys_open>:

uint64
sys_open(void)
{
    80004e66:	7131                	add	sp,sp,-192
    80004e68:	fd06                	sd	ra,184(sp)
    80004e6a:	f922                	sd	s0,176(sp)
    80004e6c:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004e6e:	f4c40593          	add	a1,s0,-180
    80004e72:	4505                	li	a0,1
    80004e74:	ffffd097          	auipc	ra,0xffffd
    80004e78:	236080e7          	jalr	566(ra) # 800020aa <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004e7c:	08000613          	li	a2,128
    80004e80:	f5040593          	add	a1,s0,-176
    80004e84:	4501                	li	a0,0
    80004e86:	ffffd097          	auipc	ra,0xffffd
    80004e8a:	264080e7          	jalr	612(ra) # 800020ea <argstr>
    80004e8e:	87aa                	mv	a5,a0
    return -1;
    80004e90:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004e92:	0a07ce63          	bltz	a5,80004f4e <sys_open+0xe8>
    80004e96:	f526                	sd	s1,168(sp)

  begin_op();
    80004e98:	fffff097          	auipc	ra,0xfffff
    80004e9c:	958080e7          	jalr	-1704(ra) # 800037f0 <begin_op>

  if(omode & O_CREATE){
    80004ea0:	f4c42783          	lw	a5,-180(s0)
    80004ea4:	2007f793          	and	a5,a5,512
    80004ea8:	cfd5                	beqz	a5,80004f64 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004eaa:	4681                	li	a3,0
    80004eac:	4601                	li	a2,0
    80004eae:	4589                	li	a1,2
    80004eb0:	f5040513          	add	a0,s0,-176
    80004eb4:	00000097          	auipc	ra,0x0
    80004eb8:	95c080e7          	jalr	-1700(ra) # 80004810 <create>
    80004ebc:	84aa                	mv	s1,a0
    if(ip == 0){
    80004ebe:	cd41                	beqz	a0,80004f56 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ec0:	04449703          	lh	a4,68(s1)
    80004ec4:	478d                	li	a5,3
    80004ec6:	00f71763          	bne	a4,a5,80004ed4 <sys_open+0x6e>
    80004eca:	0464d703          	lhu	a4,70(s1)
    80004ece:	47a5                	li	a5,9
    80004ed0:	0ee7e163          	bltu	a5,a4,80004fb2 <sys_open+0x14c>
    80004ed4:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ed6:	fffff097          	auipc	ra,0xfffff
    80004eda:	d28080e7          	jalr	-728(ra) # 80003bfe <filealloc>
    80004ede:	892a                	mv	s2,a0
    80004ee0:	c97d                	beqz	a0,80004fd6 <sys_open+0x170>
    80004ee2:	ed4e                	sd	s3,152(sp)
    80004ee4:	00000097          	auipc	ra,0x0
    80004ee8:	8ea080e7          	jalr	-1814(ra) # 800047ce <fdalloc>
    80004eec:	89aa                	mv	s3,a0
    80004eee:	0c054e63          	bltz	a0,80004fca <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ef2:	04449703          	lh	a4,68(s1)
    80004ef6:	478d                	li	a5,3
    80004ef8:	0ef70c63          	beq	a4,a5,80004ff0 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004efc:	4789                	li	a5,2
    80004efe:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004f02:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004f06:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004f0a:	f4c42783          	lw	a5,-180(s0)
    80004f0e:	0017c713          	xor	a4,a5,1
    80004f12:	8b05                	and	a4,a4,1
    80004f14:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f18:	0037f713          	and	a4,a5,3
    80004f1c:	00e03733          	snez	a4,a4
    80004f20:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004f24:	4007f793          	and	a5,a5,1024
    80004f28:	c791                	beqz	a5,80004f34 <sys_open+0xce>
    80004f2a:	04449703          	lh	a4,68(s1)
    80004f2e:	4789                	li	a5,2
    80004f30:	0cf70763          	beq	a4,a5,80004ffe <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004f34:	8526                	mv	a0,s1
    80004f36:	ffffe097          	auipc	ra,0xffffe
    80004f3a:	fb2080e7          	jalr	-78(ra) # 80002ee8 <iunlock>
  end_op();
    80004f3e:	fffff097          	auipc	ra,0xfffff
    80004f42:	92c080e7          	jalr	-1748(ra) # 8000386a <end_op>

  return fd;
    80004f46:	854e                	mv	a0,s3
    80004f48:	74aa                	ld	s1,168(sp)
    80004f4a:	790a                	ld	s2,160(sp)
    80004f4c:	69ea                	ld	s3,152(sp)
}
    80004f4e:	70ea                	ld	ra,184(sp)
    80004f50:	744a                	ld	s0,176(sp)
    80004f52:	6129                	add	sp,sp,192
    80004f54:	8082                	ret
      end_op();
    80004f56:	fffff097          	auipc	ra,0xfffff
    80004f5a:	914080e7          	jalr	-1772(ra) # 8000386a <end_op>
      return -1;
    80004f5e:	557d                	li	a0,-1
    80004f60:	74aa                	ld	s1,168(sp)
    80004f62:	b7f5                	j	80004f4e <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80004f64:	f5040513          	add	a0,s0,-176
    80004f68:	ffffe097          	auipc	ra,0xffffe
    80004f6c:	688080e7          	jalr	1672(ra) # 800035f0 <namei>
    80004f70:	84aa                	mv	s1,a0
    80004f72:	c90d                	beqz	a0,80004fa4 <sys_open+0x13e>
    ilock(ip);
    80004f74:	ffffe097          	auipc	ra,0xffffe
    80004f78:	eae080e7          	jalr	-338(ra) # 80002e22 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004f7c:	04449703          	lh	a4,68(s1)
    80004f80:	4785                	li	a5,1
    80004f82:	f2f71fe3          	bne	a4,a5,80004ec0 <sys_open+0x5a>
    80004f86:	f4c42783          	lw	a5,-180(s0)
    80004f8a:	d7a9                	beqz	a5,80004ed4 <sys_open+0x6e>
      iunlockput(ip);
    80004f8c:	8526                	mv	a0,s1
    80004f8e:	ffffe097          	auipc	ra,0xffffe
    80004f92:	0fa080e7          	jalr	250(ra) # 80003088 <iunlockput>
      end_op();
    80004f96:	fffff097          	auipc	ra,0xfffff
    80004f9a:	8d4080e7          	jalr	-1836(ra) # 8000386a <end_op>
      return -1;
    80004f9e:	557d                	li	a0,-1
    80004fa0:	74aa                	ld	s1,168(sp)
    80004fa2:	b775                	j	80004f4e <sys_open+0xe8>
      end_op();
    80004fa4:	fffff097          	auipc	ra,0xfffff
    80004fa8:	8c6080e7          	jalr	-1850(ra) # 8000386a <end_op>
      return -1;
    80004fac:	557d                	li	a0,-1
    80004fae:	74aa                	ld	s1,168(sp)
    80004fb0:	bf79                	j	80004f4e <sys_open+0xe8>
    iunlockput(ip);
    80004fb2:	8526                	mv	a0,s1
    80004fb4:	ffffe097          	auipc	ra,0xffffe
    80004fb8:	0d4080e7          	jalr	212(ra) # 80003088 <iunlockput>
    end_op();
    80004fbc:	fffff097          	auipc	ra,0xfffff
    80004fc0:	8ae080e7          	jalr	-1874(ra) # 8000386a <end_op>
    return -1;
    80004fc4:	557d                	li	a0,-1
    80004fc6:	74aa                	ld	s1,168(sp)
    80004fc8:	b759                	j	80004f4e <sys_open+0xe8>
      fileclose(f);
    80004fca:	854a                	mv	a0,s2
    80004fcc:	fffff097          	auipc	ra,0xfffff
    80004fd0:	cee080e7          	jalr	-786(ra) # 80003cba <fileclose>
    80004fd4:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004fd6:	8526                	mv	a0,s1
    80004fd8:	ffffe097          	auipc	ra,0xffffe
    80004fdc:	0b0080e7          	jalr	176(ra) # 80003088 <iunlockput>
    end_op();
    80004fe0:	fffff097          	auipc	ra,0xfffff
    80004fe4:	88a080e7          	jalr	-1910(ra) # 8000386a <end_op>
    return -1;
    80004fe8:	557d                	li	a0,-1
    80004fea:	74aa                	ld	s1,168(sp)
    80004fec:	790a                	ld	s2,160(sp)
    80004fee:	b785                	j	80004f4e <sys_open+0xe8>
    f->type = FD_DEVICE;
    80004ff0:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004ff4:	04649783          	lh	a5,70(s1)
    80004ff8:	02f91223          	sh	a5,36(s2)
    80004ffc:	b729                	j	80004f06 <sys_open+0xa0>
    itrunc(ip);
    80004ffe:	8526                	mv	a0,s1
    80005000:	ffffe097          	auipc	ra,0xffffe
    80005004:	f34080e7          	jalr	-204(ra) # 80002f34 <itrunc>
    80005008:	b735                	j	80004f34 <sys_open+0xce>

000000008000500a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000500a:	7175                	add	sp,sp,-144
    8000500c:	e506                	sd	ra,136(sp)
    8000500e:	e122                	sd	s0,128(sp)
    80005010:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005012:	ffffe097          	auipc	ra,0xffffe
    80005016:	7de080e7          	jalr	2014(ra) # 800037f0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000501a:	08000613          	li	a2,128
    8000501e:	f7040593          	add	a1,s0,-144
    80005022:	4501                	li	a0,0
    80005024:	ffffd097          	auipc	ra,0xffffd
    80005028:	0c6080e7          	jalr	198(ra) # 800020ea <argstr>
    8000502c:	02054963          	bltz	a0,8000505e <sys_mkdir+0x54>
    80005030:	4681                	li	a3,0
    80005032:	4601                	li	a2,0
    80005034:	4585                	li	a1,1
    80005036:	f7040513          	add	a0,s0,-144
    8000503a:	fffff097          	auipc	ra,0xfffff
    8000503e:	7d6080e7          	jalr	2006(ra) # 80004810 <create>
    80005042:	cd11                	beqz	a0,8000505e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005044:	ffffe097          	auipc	ra,0xffffe
    80005048:	044080e7          	jalr	68(ra) # 80003088 <iunlockput>
  end_op();
    8000504c:	fffff097          	auipc	ra,0xfffff
    80005050:	81e080e7          	jalr	-2018(ra) # 8000386a <end_op>
  return 0;
    80005054:	4501                	li	a0,0
}
    80005056:	60aa                	ld	ra,136(sp)
    80005058:	640a                	ld	s0,128(sp)
    8000505a:	6149                	add	sp,sp,144
    8000505c:	8082                	ret
    end_op();
    8000505e:	fffff097          	auipc	ra,0xfffff
    80005062:	80c080e7          	jalr	-2036(ra) # 8000386a <end_op>
    return -1;
    80005066:	557d                	li	a0,-1
    80005068:	b7fd                	j	80005056 <sys_mkdir+0x4c>

000000008000506a <sys_mknod>:

uint64
sys_mknod(void)
{
    8000506a:	7135                	add	sp,sp,-160
    8000506c:	ed06                	sd	ra,152(sp)
    8000506e:	e922                	sd	s0,144(sp)
    80005070:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005072:	ffffe097          	auipc	ra,0xffffe
    80005076:	77e080e7          	jalr	1918(ra) # 800037f0 <begin_op>
  argint(1, &major);
    8000507a:	f6c40593          	add	a1,s0,-148
    8000507e:	4505                	li	a0,1
    80005080:	ffffd097          	auipc	ra,0xffffd
    80005084:	02a080e7          	jalr	42(ra) # 800020aa <argint>
  argint(2, &minor);
    80005088:	f6840593          	add	a1,s0,-152
    8000508c:	4509                	li	a0,2
    8000508e:	ffffd097          	auipc	ra,0xffffd
    80005092:	01c080e7          	jalr	28(ra) # 800020aa <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005096:	08000613          	li	a2,128
    8000509a:	f7040593          	add	a1,s0,-144
    8000509e:	4501                	li	a0,0
    800050a0:	ffffd097          	auipc	ra,0xffffd
    800050a4:	04a080e7          	jalr	74(ra) # 800020ea <argstr>
    800050a8:	02054b63          	bltz	a0,800050de <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800050ac:	f6841683          	lh	a3,-152(s0)
    800050b0:	f6c41603          	lh	a2,-148(s0)
    800050b4:	458d                	li	a1,3
    800050b6:	f7040513          	add	a0,s0,-144
    800050ba:	fffff097          	auipc	ra,0xfffff
    800050be:	756080e7          	jalr	1878(ra) # 80004810 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800050c2:	cd11                	beqz	a0,800050de <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050c4:	ffffe097          	auipc	ra,0xffffe
    800050c8:	fc4080e7          	jalr	-60(ra) # 80003088 <iunlockput>
  end_op();
    800050cc:	ffffe097          	auipc	ra,0xffffe
    800050d0:	79e080e7          	jalr	1950(ra) # 8000386a <end_op>
  return 0;
    800050d4:	4501                	li	a0,0
}
    800050d6:	60ea                	ld	ra,152(sp)
    800050d8:	644a                	ld	s0,144(sp)
    800050da:	610d                	add	sp,sp,160
    800050dc:	8082                	ret
    end_op();
    800050de:	ffffe097          	auipc	ra,0xffffe
    800050e2:	78c080e7          	jalr	1932(ra) # 8000386a <end_op>
    return -1;
    800050e6:	557d                	li	a0,-1
    800050e8:	b7fd                	j	800050d6 <sys_mknod+0x6c>

00000000800050ea <sys_chdir>:

uint64
sys_chdir(void)
{
    800050ea:	7135                	add	sp,sp,-160
    800050ec:	ed06                	sd	ra,152(sp)
    800050ee:	e922                	sd	s0,144(sp)
    800050f0:	e14a                	sd	s2,128(sp)
    800050f2:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800050f4:	ffffc097          	auipc	ra,0xffffc
    800050f8:	e5c080e7          	jalr	-420(ra) # 80000f50 <myproc>
    800050fc:	892a                	mv	s2,a0
  
  begin_op();
    800050fe:	ffffe097          	auipc	ra,0xffffe
    80005102:	6f2080e7          	jalr	1778(ra) # 800037f0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005106:	08000613          	li	a2,128
    8000510a:	f6040593          	add	a1,s0,-160
    8000510e:	4501                	li	a0,0
    80005110:	ffffd097          	auipc	ra,0xffffd
    80005114:	fda080e7          	jalr	-38(ra) # 800020ea <argstr>
    80005118:	04054d63          	bltz	a0,80005172 <sys_chdir+0x88>
    8000511c:	e526                	sd	s1,136(sp)
    8000511e:	f6040513          	add	a0,s0,-160
    80005122:	ffffe097          	auipc	ra,0xffffe
    80005126:	4ce080e7          	jalr	1230(ra) # 800035f0 <namei>
    8000512a:	84aa                	mv	s1,a0
    8000512c:	c131                	beqz	a0,80005170 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000512e:	ffffe097          	auipc	ra,0xffffe
    80005132:	cf4080e7          	jalr	-780(ra) # 80002e22 <ilock>
  if(ip->type != T_DIR){
    80005136:	04449703          	lh	a4,68(s1)
    8000513a:	4785                	li	a5,1
    8000513c:	04f71163          	bne	a4,a5,8000517e <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005140:	8526                	mv	a0,s1
    80005142:	ffffe097          	auipc	ra,0xffffe
    80005146:	da6080e7          	jalr	-602(ra) # 80002ee8 <iunlock>
  iput(p->cwd);
    8000514a:	15093503          	ld	a0,336(s2)
    8000514e:	ffffe097          	auipc	ra,0xffffe
    80005152:	e92080e7          	jalr	-366(ra) # 80002fe0 <iput>
  end_op();
    80005156:	ffffe097          	auipc	ra,0xffffe
    8000515a:	714080e7          	jalr	1812(ra) # 8000386a <end_op>
  p->cwd = ip;
    8000515e:	14993823          	sd	s1,336(s2)
  return 0;
    80005162:	4501                	li	a0,0
    80005164:	64aa                	ld	s1,136(sp)
}
    80005166:	60ea                	ld	ra,152(sp)
    80005168:	644a                	ld	s0,144(sp)
    8000516a:	690a                	ld	s2,128(sp)
    8000516c:	610d                	add	sp,sp,160
    8000516e:	8082                	ret
    80005170:	64aa                	ld	s1,136(sp)
    end_op();
    80005172:	ffffe097          	auipc	ra,0xffffe
    80005176:	6f8080e7          	jalr	1784(ra) # 8000386a <end_op>
    return -1;
    8000517a:	557d                	li	a0,-1
    8000517c:	b7ed                	j	80005166 <sys_chdir+0x7c>
    iunlockput(ip);
    8000517e:	8526                	mv	a0,s1
    80005180:	ffffe097          	auipc	ra,0xffffe
    80005184:	f08080e7          	jalr	-248(ra) # 80003088 <iunlockput>
    end_op();
    80005188:	ffffe097          	auipc	ra,0xffffe
    8000518c:	6e2080e7          	jalr	1762(ra) # 8000386a <end_op>
    return -1;
    80005190:	557d                	li	a0,-1
    80005192:	64aa                	ld	s1,136(sp)
    80005194:	bfc9                	j	80005166 <sys_chdir+0x7c>

0000000080005196 <sys_exec>:

uint64
sys_exec(void)
{
    80005196:	7121                	add	sp,sp,-448
    80005198:	ff06                	sd	ra,440(sp)
    8000519a:	fb22                	sd	s0,432(sp)
    8000519c:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000519e:	e4840593          	add	a1,s0,-440
    800051a2:	4505                	li	a0,1
    800051a4:	ffffd097          	auipc	ra,0xffffd
    800051a8:	f26080e7          	jalr	-218(ra) # 800020ca <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800051ac:	08000613          	li	a2,128
    800051b0:	f5040593          	add	a1,s0,-176
    800051b4:	4501                	li	a0,0
    800051b6:	ffffd097          	auipc	ra,0xffffd
    800051ba:	f34080e7          	jalr	-204(ra) # 800020ea <argstr>
    800051be:	87aa                	mv	a5,a0
    return -1;
    800051c0:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800051c2:	0e07c263          	bltz	a5,800052a6 <sys_exec+0x110>
    800051c6:	f726                	sd	s1,424(sp)
    800051c8:	f34a                	sd	s2,416(sp)
    800051ca:	ef4e                	sd	s3,408(sp)
    800051cc:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800051ce:	10000613          	li	a2,256
    800051d2:	4581                	li	a1,0
    800051d4:	e5040513          	add	a0,s0,-432
    800051d8:	ffffb097          	auipc	ra,0xffffb
    800051dc:	fec080e7          	jalr	-20(ra) # 800001c4 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800051e0:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800051e4:	89a6                	mv	s3,s1
    800051e6:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800051e8:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800051ec:	00391513          	sll	a0,s2,0x3
    800051f0:	e4040593          	add	a1,s0,-448
    800051f4:	e4843783          	ld	a5,-440(s0)
    800051f8:	953e                	add	a0,a0,a5
    800051fa:	ffffd097          	auipc	ra,0xffffd
    800051fe:	e12080e7          	jalr	-494(ra) # 8000200c <fetchaddr>
    80005202:	02054a63          	bltz	a0,80005236 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005206:	e4043783          	ld	a5,-448(s0)
    8000520a:	c7b9                	beqz	a5,80005258 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000520c:	ffffb097          	auipc	ra,0xffffb
    80005210:	f0e080e7          	jalr	-242(ra) # 8000011a <kalloc>
    80005214:	85aa                	mv	a1,a0
    80005216:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000521a:	cd11                	beqz	a0,80005236 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000521c:	6605                	lui	a2,0x1
    8000521e:	e4043503          	ld	a0,-448(s0)
    80005222:	ffffd097          	auipc	ra,0xffffd
    80005226:	e3c080e7          	jalr	-452(ra) # 8000205e <fetchstr>
    8000522a:	00054663          	bltz	a0,80005236 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    8000522e:	0905                	add	s2,s2,1
    80005230:	09a1                	add	s3,s3,8
    80005232:	fb491de3          	bne	s2,s4,800051ec <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005236:	f5040913          	add	s2,s0,-176
    8000523a:	6088                	ld	a0,0(s1)
    8000523c:	c125                	beqz	a0,8000529c <sys_exec+0x106>
    kfree(argv[i]);
    8000523e:	ffffb097          	auipc	ra,0xffffb
    80005242:	dde080e7          	jalr	-546(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005246:	04a1                	add	s1,s1,8
    80005248:	ff2499e3          	bne	s1,s2,8000523a <sys_exec+0xa4>
  return -1;
    8000524c:	557d                	li	a0,-1
    8000524e:	74ba                	ld	s1,424(sp)
    80005250:	791a                	ld	s2,416(sp)
    80005252:	69fa                	ld	s3,408(sp)
    80005254:	6a5a                	ld	s4,400(sp)
    80005256:	a881                	j	800052a6 <sys_exec+0x110>
      argv[i] = 0;
    80005258:	0009079b          	sext.w	a5,s2
    8000525c:	078e                	sll	a5,a5,0x3
    8000525e:	fd078793          	add	a5,a5,-48
    80005262:	97a2                	add	a5,a5,s0
    80005264:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005268:	e5040593          	add	a1,s0,-432
    8000526c:	f5040513          	add	a0,s0,-176
    80005270:	fffff097          	auipc	ra,0xfffff
    80005274:	120080e7          	jalr	288(ra) # 80004390 <exec>
    80005278:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000527a:	f5040993          	add	s3,s0,-176
    8000527e:	6088                	ld	a0,0(s1)
    80005280:	c901                	beqz	a0,80005290 <sys_exec+0xfa>
    kfree(argv[i]);
    80005282:	ffffb097          	auipc	ra,0xffffb
    80005286:	d9a080e7          	jalr	-614(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000528a:	04a1                	add	s1,s1,8
    8000528c:	ff3499e3          	bne	s1,s3,8000527e <sys_exec+0xe8>
  return ret;
    80005290:	854a                	mv	a0,s2
    80005292:	74ba                	ld	s1,424(sp)
    80005294:	791a                	ld	s2,416(sp)
    80005296:	69fa                	ld	s3,408(sp)
    80005298:	6a5a                	ld	s4,400(sp)
    8000529a:	a031                	j	800052a6 <sys_exec+0x110>
  return -1;
    8000529c:	557d                	li	a0,-1
    8000529e:	74ba                	ld	s1,424(sp)
    800052a0:	791a                	ld	s2,416(sp)
    800052a2:	69fa                	ld	s3,408(sp)
    800052a4:	6a5a                	ld	s4,400(sp)
}
    800052a6:	70fa                	ld	ra,440(sp)
    800052a8:	745a                	ld	s0,432(sp)
    800052aa:	6139                	add	sp,sp,448
    800052ac:	8082                	ret

00000000800052ae <sys_pipe>:

uint64
sys_pipe(void)
{
    800052ae:	7139                	add	sp,sp,-64
    800052b0:	fc06                	sd	ra,56(sp)
    800052b2:	f822                	sd	s0,48(sp)
    800052b4:	f426                	sd	s1,40(sp)
    800052b6:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800052b8:	ffffc097          	auipc	ra,0xffffc
    800052bc:	c98080e7          	jalr	-872(ra) # 80000f50 <myproc>
    800052c0:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800052c2:	fd840593          	add	a1,s0,-40
    800052c6:	4501                	li	a0,0
    800052c8:	ffffd097          	auipc	ra,0xffffd
    800052cc:	e02080e7          	jalr	-510(ra) # 800020ca <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800052d0:	fc840593          	add	a1,s0,-56
    800052d4:	fd040513          	add	a0,s0,-48
    800052d8:	fffff097          	auipc	ra,0xfffff
    800052dc:	d50080e7          	jalr	-688(ra) # 80004028 <pipealloc>
    return -1;
    800052e0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800052e2:	0c054463          	bltz	a0,800053aa <sys_pipe+0xfc>
  fd0 = -1;
    800052e6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800052ea:	fd043503          	ld	a0,-48(s0)
    800052ee:	fffff097          	auipc	ra,0xfffff
    800052f2:	4e0080e7          	jalr	1248(ra) # 800047ce <fdalloc>
    800052f6:	fca42223          	sw	a0,-60(s0)
    800052fa:	08054b63          	bltz	a0,80005390 <sys_pipe+0xe2>
    800052fe:	fc843503          	ld	a0,-56(s0)
    80005302:	fffff097          	auipc	ra,0xfffff
    80005306:	4cc080e7          	jalr	1228(ra) # 800047ce <fdalloc>
    8000530a:	fca42023          	sw	a0,-64(s0)
    8000530e:	06054863          	bltz	a0,8000537e <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005312:	4691                	li	a3,4
    80005314:	fc440613          	add	a2,s0,-60
    80005318:	fd843583          	ld	a1,-40(s0)
    8000531c:	68a8                	ld	a0,80(s1)
    8000531e:	ffffc097          	auipc	ra,0xffffc
    80005322:	878080e7          	jalr	-1928(ra) # 80000b96 <copyout>
    80005326:	02054063          	bltz	a0,80005346 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000532a:	4691                	li	a3,4
    8000532c:	fc040613          	add	a2,s0,-64
    80005330:	fd843583          	ld	a1,-40(s0)
    80005334:	0591                	add	a1,a1,4
    80005336:	68a8                	ld	a0,80(s1)
    80005338:	ffffc097          	auipc	ra,0xffffc
    8000533c:	85e080e7          	jalr	-1954(ra) # 80000b96 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005340:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005342:	06055463          	bgez	a0,800053aa <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005346:	fc442783          	lw	a5,-60(s0)
    8000534a:	07e9                	add	a5,a5,26
    8000534c:	078e                	sll	a5,a5,0x3
    8000534e:	97a6                	add	a5,a5,s1
    80005350:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005354:	fc042783          	lw	a5,-64(s0)
    80005358:	07e9                	add	a5,a5,26
    8000535a:	078e                	sll	a5,a5,0x3
    8000535c:	94be                	add	s1,s1,a5
    8000535e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005362:	fd043503          	ld	a0,-48(s0)
    80005366:	fffff097          	auipc	ra,0xfffff
    8000536a:	954080e7          	jalr	-1708(ra) # 80003cba <fileclose>
    fileclose(wf);
    8000536e:	fc843503          	ld	a0,-56(s0)
    80005372:	fffff097          	auipc	ra,0xfffff
    80005376:	948080e7          	jalr	-1720(ra) # 80003cba <fileclose>
    return -1;
    8000537a:	57fd                	li	a5,-1
    8000537c:	a03d                	j	800053aa <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000537e:	fc442783          	lw	a5,-60(s0)
    80005382:	0007c763          	bltz	a5,80005390 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005386:	07e9                	add	a5,a5,26
    80005388:	078e                	sll	a5,a5,0x3
    8000538a:	97a6                	add	a5,a5,s1
    8000538c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005390:	fd043503          	ld	a0,-48(s0)
    80005394:	fffff097          	auipc	ra,0xfffff
    80005398:	926080e7          	jalr	-1754(ra) # 80003cba <fileclose>
    fileclose(wf);
    8000539c:	fc843503          	ld	a0,-56(s0)
    800053a0:	fffff097          	auipc	ra,0xfffff
    800053a4:	91a080e7          	jalr	-1766(ra) # 80003cba <fileclose>
    return -1;
    800053a8:	57fd                	li	a5,-1
}
    800053aa:	853e                	mv	a0,a5
    800053ac:	70e2                	ld	ra,56(sp)
    800053ae:	7442                	ld	s0,48(sp)
    800053b0:	74a2                	ld	s1,40(sp)
    800053b2:	6121                	add	sp,sp,64
    800053b4:	8082                	ret
	...

00000000800053c0 <kernelvec>:
    800053c0:	7111                	add	sp,sp,-256
    800053c2:	e006                	sd	ra,0(sp)
    800053c4:	e40a                	sd	sp,8(sp)
    800053c6:	e80e                	sd	gp,16(sp)
    800053c8:	ec12                	sd	tp,24(sp)
    800053ca:	f016                	sd	t0,32(sp)
    800053cc:	f41a                	sd	t1,40(sp)
    800053ce:	f81e                	sd	t2,48(sp)
    800053d0:	fc22                	sd	s0,56(sp)
    800053d2:	e0a6                	sd	s1,64(sp)
    800053d4:	e4aa                	sd	a0,72(sp)
    800053d6:	e8ae                	sd	a1,80(sp)
    800053d8:	ecb2                	sd	a2,88(sp)
    800053da:	f0b6                	sd	a3,96(sp)
    800053dc:	f4ba                	sd	a4,104(sp)
    800053de:	f8be                	sd	a5,112(sp)
    800053e0:	fcc2                	sd	a6,120(sp)
    800053e2:	e146                	sd	a7,128(sp)
    800053e4:	e54a                	sd	s2,136(sp)
    800053e6:	e94e                	sd	s3,144(sp)
    800053e8:	ed52                	sd	s4,152(sp)
    800053ea:	f156                	sd	s5,160(sp)
    800053ec:	f55a                	sd	s6,168(sp)
    800053ee:	f95e                	sd	s7,176(sp)
    800053f0:	fd62                	sd	s8,184(sp)
    800053f2:	e1e6                	sd	s9,192(sp)
    800053f4:	e5ea                	sd	s10,200(sp)
    800053f6:	e9ee                	sd	s11,208(sp)
    800053f8:	edf2                	sd	t3,216(sp)
    800053fa:	f1f6                	sd	t4,224(sp)
    800053fc:	f5fa                	sd	t5,232(sp)
    800053fe:	f9fe                	sd	t6,240(sp)
    80005400:	ad9fc0ef          	jal	80001ed8 <kerneltrap>
    80005404:	6082                	ld	ra,0(sp)
    80005406:	6122                	ld	sp,8(sp)
    80005408:	61c2                	ld	gp,16(sp)
    8000540a:	7282                	ld	t0,32(sp)
    8000540c:	7322                	ld	t1,40(sp)
    8000540e:	73c2                	ld	t2,48(sp)
    80005410:	7462                	ld	s0,56(sp)
    80005412:	6486                	ld	s1,64(sp)
    80005414:	6526                	ld	a0,72(sp)
    80005416:	65c6                	ld	a1,80(sp)
    80005418:	6666                	ld	a2,88(sp)
    8000541a:	7686                	ld	a3,96(sp)
    8000541c:	7726                	ld	a4,104(sp)
    8000541e:	77c6                	ld	a5,112(sp)
    80005420:	7866                	ld	a6,120(sp)
    80005422:	688a                	ld	a7,128(sp)
    80005424:	692a                	ld	s2,136(sp)
    80005426:	69ca                	ld	s3,144(sp)
    80005428:	6a6a                	ld	s4,152(sp)
    8000542a:	7a8a                	ld	s5,160(sp)
    8000542c:	7b2a                	ld	s6,168(sp)
    8000542e:	7bca                	ld	s7,176(sp)
    80005430:	7c6a                	ld	s8,184(sp)
    80005432:	6c8e                	ld	s9,192(sp)
    80005434:	6d2e                	ld	s10,200(sp)
    80005436:	6dce                	ld	s11,208(sp)
    80005438:	6e6e                	ld	t3,216(sp)
    8000543a:	7e8e                	ld	t4,224(sp)
    8000543c:	7f2e                	ld	t5,232(sp)
    8000543e:	7fce                	ld	t6,240(sp)
    80005440:	6111                	add	sp,sp,256
    80005442:	10200073          	sret
    80005446:	00000013          	nop
    8000544a:	00000013          	nop
    8000544e:	0001                	nop

0000000080005450 <timervec>:
    80005450:	34051573          	csrrw	a0,mscratch,a0
    80005454:	e10c                	sd	a1,0(a0)
    80005456:	e510                	sd	a2,8(a0)
    80005458:	e914                	sd	a3,16(a0)
    8000545a:	6d0c                	ld	a1,24(a0)
    8000545c:	7110                	ld	a2,32(a0)
    8000545e:	6194                	ld	a3,0(a1)
    80005460:	96b2                	add	a3,a3,a2
    80005462:	e194                	sd	a3,0(a1)
    80005464:	4589                	li	a1,2
    80005466:	14459073          	csrw	sip,a1
    8000546a:	6914                	ld	a3,16(a0)
    8000546c:	6510                	ld	a2,8(a0)
    8000546e:	610c                	ld	a1,0(a0)
    80005470:	34051573          	csrrw	a0,mscratch,a0
    80005474:	30200073          	mret
	...

000000008000547a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000547a:	1141                	add	sp,sp,-16
    8000547c:	e422                	sd	s0,8(sp)
    8000547e:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005480:	0c0007b7          	lui	a5,0xc000
    80005484:	4705                	li	a4,1
    80005486:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005488:	0c0007b7          	lui	a5,0xc000
    8000548c:	c3d8                	sw	a4,4(a5)
}
    8000548e:	6422                	ld	s0,8(sp)
    80005490:	0141                	add	sp,sp,16
    80005492:	8082                	ret

0000000080005494 <plicinithart>:

void
plicinithart(void)
{
    80005494:	1141                	add	sp,sp,-16
    80005496:	e406                	sd	ra,8(sp)
    80005498:	e022                	sd	s0,0(sp)
    8000549a:	0800                	add	s0,sp,16
  int hart = cpuid();
    8000549c:	ffffc097          	auipc	ra,0xffffc
    800054a0:	a88080e7          	jalr	-1400(ra) # 80000f24 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800054a4:	0085171b          	sllw	a4,a0,0x8
    800054a8:	0c0027b7          	lui	a5,0xc002
    800054ac:	97ba                	add	a5,a5,a4
    800054ae:	40200713          	li	a4,1026
    800054b2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800054b6:	00d5151b          	sllw	a0,a0,0xd
    800054ba:	0c2017b7          	lui	a5,0xc201
    800054be:	97aa                	add	a5,a5,a0
    800054c0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800054c4:	60a2                	ld	ra,8(sp)
    800054c6:	6402                	ld	s0,0(sp)
    800054c8:	0141                	add	sp,sp,16
    800054ca:	8082                	ret

00000000800054cc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800054cc:	1141                	add	sp,sp,-16
    800054ce:	e406                	sd	ra,8(sp)
    800054d0:	e022                	sd	s0,0(sp)
    800054d2:	0800                	add	s0,sp,16
  int hart = cpuid();
    800054d4:	ffffc097          	auipc	ra,0xffffc
    800054d8:	a50080e7          	jalr	-1456(ra) # 80000f24 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800054dc:	00d5151b          	sllw	a0,a0,0xd
    800054e0:	0c2017b7          	lui	a5,0xc201
    800054e4:	97aa                	add	a5,a5,a0
  return irq;
}
    800054e6:	43c8                	lw	a0,4(a5)
    800054e8:	60a2                	ld	ra,8(sp)
    800054ea:	6402                	ld	s0,0(sp)
    800054ec:	0141                	add	sp,sp,16
    800054ee:	8082                	ret

00000000800054f0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800054f0:	1101                	add	sp,sp,-32
    800054f2:	ec06                	sd	ra,24(sp)
    800054f4:	e822                	sd	s0,16(sp)
    800054f6:	e426                	sd	s1,8(sp)
    800054f8:	1000                	add	s0,sp,32
    800054fa:	84aa                	mv	s1,a0
  int hart = cpuid();
    800054fc:	ffffc097          	auipc	ra,0xffffc
    80005500:	a28080e7          	jalr	-1496(ra) # 80000f24 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005504:	00d5151b          	sllw	a0,a0,0xd
    80005508:	0c2017b7          	lui	a5,0xc201
    8000550c:	97aa                	add	a5,a5,a0
    8000550e:	c3c4                	sw	s1,4(a5)
}
    80005510:	60e2                	ld	ra,24(sp)
    80005512:	6442                	ld	s0,16(sp)
    80005514:	64a2                	ld	s1,8(sp)
    80005516:	6105                	add	sp,sp,32
    80005518:	8082                	ret

000000008000551a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000551a:	1141                	add	sp,sp,-16
    8000551c:	e406                	sd	ra,8(sp)
    8000551e:	e022                	sd	s0,0(sp)
    80005520:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005522:	479d                	li	a5,7
    80005524:	04a7cc63          	blt	a5,a0,8000557c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005528:	00017797          	auipc	a5,0x17
    8000552c:	fe878793          	add	a5,a5,-24 # 8001c510 <disk>
    80005530:	97aa                	add	a5,a5,a0
    80005532:	0187c783          	lbu	a5,24(a5)
    80005536:	ebb9                	bnez	a5,8000558c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005538:	00451693          	sll	a3,a0,0x4
    8000553c:	00017797          	auipc	a5,0x17
    80005540:	fd478793          	add	a5,a5,-44 # 8001c510 <disk>
    80005544:	6398                	ld	a4,0(a5)
    80005546:	9736                	add	a4,a4,a3
    80005548:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000554c:	6398                	ld	a4,0(a5)
    8000554e:	9736                	add	a4,a4,a3
    80005550:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005554:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005558:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000555c:	97aa                	add	a5,a5,a0
    8000555e:	4705                	li	a4,1
    80005560:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005564:	00017517          	auipc	a0,0x17
    80005568:	fc450513          	add	a0,a0,-60 # 8001c528 <disk+0x18>
    8000556c:	ffffc097          	auipc	ra,0xffffc
    80005570:	0fe080e7          	jalr	254(ra) # 8000166a <wakeup>
}
    80005574:	60a2                	ld	ra,8(sp)
    80005576:	6402                	ld	s0,0(sp)
    80005578:	0141                	add	sp,sp,16
    8000557a:	8082                	ret
    panic("free_desc 1");
    8000557c:	00003517          	auipc	a0,0x3
    80005580:	15450513          	add	a0,a0,340 # 800086d0 <etext+0x6d0>
    80005584:	00001097          	auipc	ra,0x1
    80005588:	a6e080e7          	jalr	-1426(ra) # 80005ff2 <panic>
    panic("free_desc 2");
    8000558c:	00003517          	auipc	a0,0x3
    80005590:	15450513          	add	a0,a0,340 # 800086e0 <etext+0x6e0>
    80005594:	00001097          	auipc	ra,0x1
    80005598:	a5e080e7          	jalr	-1442(ra) # 80005ff2 <panic>

000000008000559c <virtio_disk_init>:
{
    8000559c:	1101                	add	sp,sp,-32
    8000559e:	ec06                	sd	ra,24(sp)
    800055a0:	e822                	sd	s0,16(sp)
    800055a2:	e426                	sd	s1,8(sp)
    800055a4:	e04a                	sd	s2,0(sp)
    800055a6:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800055a8:	00003597          	auipc	a1,0x3
    800055ac:	14858593          	add	a1,a1,328 # 800086f0 <etext+0x6f0>
    800055b0:	00017517          	auipc	a0,0x17
    800055b4:	08850513          	add	a0,a0,136 # 8001c638 <disk+0x128>
    800055b8:	00001097          	auipc	ra,0x1
    800055bc:	f24080e7          	jalr	-220(ra) # 800064dc <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055c0:	100017b7          	lui	a5,0x10001
    800055c4:	4398                	lw	a4,0(a5)
    800055c6:	2701                	sext.w	a4,a4
    800055c8:	747277b7          	lui	a5,0x74727
    800055cc:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800055d0:	18f71c63          	bne	a4,a5,80005768 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800055d4:	100017b7          	lui	a5,0x10001
    800055d8:	0791                	add	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800055da:	439c                	lw	a5,0(a5)
    800055dc:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055de:	4709                	li	a4,2
    800055e0:	18e79463          	bne	a5,a4,80005768 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055e4:	100017b7          	lui	a5,0x10001
    800055e8:	07a1                	add	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800055ea:	439c                	lw	a5,0(a5)
    800055ec:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800055ee:	16e79d63          	bne	a5,a4,80005768 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800055f2:	100017b7          	lui	a5,0x10001
    800055f6:	47d8                	lw	a4,12(a5)
    800055f8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055fa:	554d47b7          	lui	a5,0x554d4
    800055fe:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005602:	16f71363          	bne	a4,a5,80005768 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005606:	100017b7          	lui	a5,0x10001
    8000560a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000560e:	4705                	li	a4,1
    80005610:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005612:	470d                	li	a4,3
    80005614:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005616:	10001737          	lui	a4,0x10001
    8000561a:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000561c:	c7ffe737          	lui	a4,0xc7ffe
    80005620:	75f70713          	add	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9ecf>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005624:	8ef9                	and	a3,a3,a4
    80005626:	10001737          	lui	a4,0x10001
    8000562a:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000562c:	472d                	li	a4,11
    8000562e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005630:	07078793          	add	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005634:	439c                	lw	a5,0(a5)
    80005636:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000563a:	8ba1                	and	a5,a5,8
    8000563c:	12078e63          	beqz	a5,80005778 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005640:	100017b7          	lui	a5,0x10001
    80005644:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005648:	100017b7          	lui	a5,0x10001
    8000564c:	04478793          	add	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005650:	439c                	lw	a5,0(a5)
    80005652:	2781                	sext.w	a5,a5
    80005654:	12079a63          	bnez	a5,80005788 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005658:	100017b7          	lui	a5,0x10001
    8000565c:	03478793          	add	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005660:	439c                	lw	a5,0(a5)
    80005662:	2781                	sext.w	a5,a5
  if(max == 0)
    80005664:	12078a63          	beqz	a5,80005798 <virtio_disk_init+0x1fc>
  if(max < NUM)
    80005668:	471d                	li	a4,7
    8000566a:	12f77f63          	bgeu	a4,a5,800057a8 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    8000566e:	ffffb097          	auipc	ra,0xffffb
    80005672:	aac080e7          	jalr	-1364(ra) # 8000011a <kalloc>
    80005676:	00017497          	auipc	s1,0x17
    8000567a:	e9a48493          	add	s1,s1,-358 # 8001c510 <disk>
    8000567e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005680:	ffffb097          	auipc	ra,0xffffb
    80005684:	a9a080e7          	jalr	-1382(ra) # 8000011a <kalloc>
    80005688:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000568a:	ffffb097          	auipc	ra,0xffffb
    8000568e:	a90080e7          	jalr	-1392(ra) # 8000011a <kalloc>
    80005692:	87aa                	mv	a5,a0
    80005694:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005696:	6088                	ld	a0,0(s1)
    80005698:	12050063          	beqz	a0,800057b8 <virtio_disk_init+0x21c>
    8000569c:	00017717          	auipc	a4,0x17
    800056a0:	e7c73703          	ld	a4,-388(a4) # 8001c518 <disk+0x8>
    800056a4:	10070a63          	beqz	a4,800057b8 <virtio_disk_init+0x21c>
    800056a8:	10078863          	beqz	a5,800057b8 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    800056ac:	6605                	lui	a2,0x1
    800056ae:	4581                	li	a1,0
    800056b0:	ffffb097          	auipc	ra,0xffffb
    800056b4:	b14080e7          	jalr	-1260(ra) # 800001c4 <memset>
  memset(disk.avail, 0, PGSIZE);
    800056b8:	00017497          	auipc	s1,0x17
    800056bc:	e5848493          	add	s1,s1,-424 # 8001c510 <disk>
    800056c0:	6605                	lui	a2,0x1
    800056c2:	4581                	li	a1,0
    800056c4:	6488                	ld	a0,8(s1)
    800056c6:	ffffb097          	auipc	ra,0xffffb
    800056ca:	afe080e7          	jalr	-1282(ra) # 800001c4 <memset>
  memset(disk.used, 0, PGSIZE);
    800056ce:	6605                	lui	a2,0x1
    800056d0:	4581                	li	a1,0
    800056d2:	6888                	ld	a0,16(s1)
    800056d4:	ffffb097          	auipc	ra,0xffffb
    800056d8:	af0080e7          	jalr	-1296(ra) # 800001c4 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800056dc:	100017b7          	lui	a5,0x10001
    800056e0:	4721                	li	a4,8
    800056e2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800056e4:	4098                	lw	a4,0(s1)
    800056e6:	100017b7          	lui	a5,0x10001
    800056ea:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800056ee:	40d8                	lw	a4,4(s1)
    800056f0:	100017b7          	lui	a5,0x10001
    800056f4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800056f8:	649c                	ld	a5,8(s1)
    800056fa:	0007869b          	sext.w	a3,a5
    800056fe:	10001737          	lui	a4,0x10001
    80005702:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005706:	9781                	sra	a5,a5,0x20
    80005708:	10001737          	lui	a4,0x10001
    8000570c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005710:	689c                	ld	a5,16(s1)
    80005712:	0007869b          	sext.w	a3,a5
    80005716:	10001737          	lui	a4,0x10001
    8000571a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000571e:	9781                	sra	a5,a5,0x20
    80005720:	10001737          	lui	a4,0x10001
    80005724:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005728:	10001737          	lui	a4,0x10001
    8000572c:	4785                	li	a5,1
    8000572e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005730:	00f48c23          	sb	a5,24(s1)
    80005734:	00f48ca3          	sb	a5,25(s1)
    80005738:	00f48d23          	sb	a5,26(s1)
    8000573c:	00f48da3          	sb	a5,27(s1)
    80005740:	00f48e23          	sb	a5,28(s1)
    80005744:	00f48ea3          	sb	a5,29(s1)
    80005748:	00f48f23          	sb	a5,30(s1)
    8000574c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005750:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005754:	100017b7          	lui	a5,0x10001
    80005758:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000575c:	60e2                	ld	ra,24(sp)
    8000575e:	6442                	ld	s0,16(sp)
    80005760:	64a2                	ld	s1,8(sp)
    80005762:	6902                	ld	s2,0(sp)
    80005764:	6105                	add	sp,sp,32
    80005766:	8082                	ret
    panic("could not find virtio disk");
    80005768:	00003517          	auipc	a0,0x3
    8000576c:	f9850513          	add	a0,a0,-104 # 80008700 <etext+0x700>
    80005770:	00001097          	auipc	ra,0x1
    80005774:	882080e7          	jalr	-1918(ra) # 80005ff2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005778:	00003517          	auipc	a0,0x3
    8000577c:	fa850513          	add	a0,a0,-88 # 80008720 <etext+0x720>
    80005780:	00001097          	auipc	ra,0x1
    80005784:	872080e7          	jalr	-1934(ra) # 80005ff2 <panic>
    panic("virtio disk should not be ready");
    80005788:	00003517          	auipc	a0,0x3
    8000578c:	fb850513          	add	a0,a0,-72 # 80008740 <etext+0x740>
    80005790:	00001097          	auipc	ra,0x1
    80005794:	862080e7          	jalr	-1950(ra) # 80005ff2 <panic>
    panic("virtio disk has no queue 0");
    80005798:	00003517          	auipc	a0,0x3
    8000579c:	fc850513          	add	a0,a0,-56 # 80008760 <etext+0x760>
    800057a0:	00001097          	auipc	ra,0x1
    800057a4:	852080e7          	jalr	-1966(ra) # 80005ff2 <panic>
    panic("virtio disk max queue too short");
    800057a8:	00003517          	auipc	a0,0x3
    800057ac:	fd850513          	add	a0,a0,-40 # 80008780 <etext+0x780>
    800057b0:	00001097          	auipc	ra,0x1
    800057b4:	842080e7          	jalr	-1982(ra) # 80005ff2 <panic>
    panic("virtio disk kalloc");
    800057b8:	00003517          	auipc	a0,0x3
    800057bc:	fe850513          	add	a0,a0,-24 # 800087a0 <etext+0x7a0>
    800057c0:	00001097          	auipc	ra,0x1
    800057c4:	832080e7          	jalr	-1998(ra) # 80005ff2 <panic>

00000000800057c8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800057c8:	7159                	add	sp,sp,-112
    800057ca:	f486                	sd	ra,104(sp)
    800057cc:	f0a2                	sd	s0,96(sp)
    800057ce:	eca6                	sd	s1,88(sp)
    800057d0:	e8ca                	sd	s2,80(sp)
    800057d2:	e4ce                	sd	s3,72(sp)
    800057d4:	e0d2                	sd	s4,64(sp)
    800057d6:	fc56                	sd	s5,56(sp)
    800057d8:	f85a                	sd	s6,48(sp)
    800057da:	f45e                	sd	s7,40(sp)
    800057dc:	f062                	sd	s8,32(sp)
    800057de:	ec66                	sd	s9,24(sp)
    800057e0:	1880                	add	s0,sp,112
    800057e2:	8a2a                	mv	s4,a0
    800057e4:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800057e6:	00c52c83          	lw	s9,12(a0)
    800057ea:	001c9c9b          	sllw	s9,s9,0x1
    800057ee:	1c82                	sll	s9,s9,0x20
    800057f0:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800057f4:	00017517          	auipc	a0,0x17
    800057f8:	e4450513          	add	a0,a0,-444 # 8001c638 <disk+0x128>
    800057fc:	00001097          	auipc	ra,0x1
    80005800:	d70080e7          	jalr	-656(ra) # 8000656c <acquire>
  for(int i = 0; i < 3; i++){
    80005804:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005806:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005808:	00017b17          	auipc	s6,0x17
    8000580c:	d08b0b13          	add	s6,s6,-760 # 8001c510 <disk>
  for(int i = 0; i < 3; i++){
    80005810:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005812:	00017c17          	auipc	s8,0x17
    80005816:	e26c0c13          	add	s8,s8,-474 # 8001c638 <disk+0x128>
    8000581a:	a0ad                	j	80005884 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    8000581c:	00fb0733          	add	a4,s6,a5
    80005820:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005824:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005826:	0207c563          	bltz	a5,80005850 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000582a:	2905                	addw	s2,s2,1
    8000582c:	0611                	add	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000582e:	05590f63          	beq	s2,s5,8000588c <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80005832:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005834:	00017717          	auipc	a4,0x17
    80005838:	cdc70713          	add	a4,a4,-804 # 8001c510 <disk>
    8000583c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000583e:	01874683          	lbu	a3,24(a4)
    80005842:	fee9                	bnez	a3,8000581c <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80005844:	2785                	addw	a5,a5,1
    80005846:	0705                	add	a4,a4,1
    80005848:	fe979be3          	bne	a5,s1,8000583e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000584c:	57fd                	li	a5,-1
    8000584e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005850:	03205163          	blez	s2,80005872 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80005854:	f9042503          	lw	a0,-112(s0)
    80005858:	00000097          	auipc	ra,0x0
    8000585c:	cc2080e7          	jalr	-830(ra) # 8000551a <free_desc>
      for(int j = 0; j < i; j++)
    80005860:	4785                	li	a5,1
    80005862:	0127d863          	bge	a5,s2,80005872 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80005866:	f9442503          	lw	a0,-108(s0)
    8000586a:	00000097          	auipc	ra,0x0
    8000586e:	cb0080e7          	jalr	-848(ra) # 8000551a <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005872:	85e2                	mv	a1,s8
    80005874:	00017517          	auipc	a0,0x17
    80005878:	cb450513          	add	a0,a0,-844 # 8001c528 <disk+0x18>
    8000587c:	ffffc097          	auipc	ra,0xffffc
    80005880:	d8a080e7          	jalr	-630(ra) # 80001606 <sleep>
  for(int i = 0; i < 3; i++){
    80005884:	f9040613          	add	a2,s0,-112
    80005888:	894e                	mv	s2,s3
    8000588a:	b765                	j	80005832 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000588c:	f9042503          	lw	a0,-112(s0)
    80005890:	00451693          	sll	a3,a0,0x4

  if(write)
    80005894:	00017797          	auipc	a5,0x17
    80005898:	c7c78793          	add	a5,a5,-900 # 8001c510 <disk>
    8000589c:	00a50713          	add	a4,a0,10
    800058a0:	0712                	sll	a4,a4,0x4
    800058a2:	973e                	add	a4,a4,a5
    800058a4:	01703633          	snez	a2,s7
    800058a8:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800058aa:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800058ae:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800058b2:	6398                	ld	a4,0(a5)
    800058b4:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058b6:	0a868613          	add	a2,a3,168
    800058ba:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800058bc:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800058be:	6390                	ld	a2,0(a5)
    800058c0:	00d605b3          	add	a1,a2,a3
    800058c4:	4741                	li	a4,16
    800058c6:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800058c8:	4805                	li	a6,1
    800058ca:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800058ce:	f9442703          	lw	a4,-108(s0)
    800058d2:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800058d6:	0712                	sll	a4,a4,0x4
    800058d8:	963a                	add	a2,a2,a4
    800058da:	058a0593          	add	a1,s4,88
    800058de:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800058e0:	0007b883          	ld	a7,0(a5)
    800058e4:	9746                	add	a4,a4,a7
    800058e6:	40000613          	li	a2,1024
    800058ea:	c710                	sw	a2,8(a4)
  if(write)
    800058ec:	001bb613          	seqz	a2,s7
    800058f0:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800058f4:	00166613          	or	a2,a2,1
    800058f8:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800058fc:	f9842583          	lw	a1,-104(s0)
    80005900:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005904:	00250613          	add	a2,a0,2
    80005908:	0612                	sll	a2,a2,0x4
    8000590a:	963e                	add	a2,a2,a5
    8000590c:	577d                	li	a4,-1
    8000590e:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005912:	0592                	sll	a1,a1,0x4
    80005914:	98ae                	add	a7,a7,a1
    80005916:	03068713          	add	a4,a3,48
    8000591a:	973e                	add	a4,a4,a5
    8000591c:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005920:	6398                	ld	a4,0(a5)
    80005922:	972e                	add	a4,a4,a1
    80005924:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005928:	4689                	li	a3,2
    8000592a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000592e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005932:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005936:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000593a:	6794                	ld	a3,8(a5)
    8000593c:	0026d703          	lhu	a4,2(a3)
    80005940:	8b1d                	and	a4,a4,7
    80005942:	0706                	sll	a4,a4,0x1
    80005944:	96ba                	add	a3,a3,a4
    80005946:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000594a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000594e:	6798                	ld	a4,8(a5)
    80005950:	00275783          	lhu	a5,2(a4)
    80005954:	2785                	addw	a5,a5,1
    80005956:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000595a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000595e:	100017b7          	lui	a5,0x10001
    80005962:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005966:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    8000596a:	00017917          	auipc	s2,0x17
    8000596e:	cce90913          	add	s2,s2,-818 # 8001c638 <disk+0x128>
  while(b->disk == 1) {
    80005972:	4485                	li	s1,1
    80005974:	01079c63          	bne	a5,a6,8000598c <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005978:	85ca                	mv	a1,s2
    8000597a:	8552                	mv	a0,s4
    8000597c:	ffffc097          	auipc	ra,0xffffc
    80005980:	c8a080e7          	jalr	-886(ra) # 80001606 <sleep>
  while(b->disk == 1) {
    80005984:	004a2783          	lw	a5,4(s4)
    80005988:	fe9788e3          	beq	a5,s1,80005978 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    8000598c:	f9042903          	lw	s2,-112(s0)
    80005990:	00290713          	add	a4,s2,2
    80005994:	0712                	sll	a4,a4,0x4
    80005996:	00017797          	auipc	a5,0x17
    8000599a:	b7a78793          	add	a5,a5,-1158 # 8001c510 <disk>
    8000599e:	97ba                	add	a5,a5,a4
    800059a0:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800059a4:	00017997          	auipc	s3,0x17
    800059a8:	b6c98993          	add	s3,s3,-1172 # 8001c510 <disk>
    800059ac:	00491713          	sll	a4,s2,0x4
    800059b0:	0009b783          	ld	a5,0(s3)
    800059b4:	97ba                	add	a5,a5,a4
    800059b6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800059ba:	854a                	mv	a0,s2
    800059bc:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800059c0:	00000097          	auipc	ra,0x0
    800059c4:	b5a080e7          	jalr	-1190(ra) # 8000551a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800059c8:	8885                	and	s1,s1,1
    800059ca:	f0ed                	bnez	s1,800059ac <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800059cc:	00017517          	auipc	a0,0x17
    800059d0:	c6c50513          	add	a0,a0,-916 # 8001c638 <disk+0x128>
    800059d4:	00001097          	auipc	ra,0x1
    800059d8:	c4c080e7          	jalr	-948(ra) # 80006620 <release>
}
    800059dc:	70a6                	ld	ra,104(sp)
    800059de:	7406                	ld	s0,96(sp)
    800059e0:	64e6                	ld	s1,88(sp)
    800059e2:	6946                	ld	s2,80(sp)
    800059e4:	69a6                	ld	s3,72(sp)
    800059e6:	6a06                	ld	s4,64(sp)
    800059e8:	7ae2                	ld	s5,56(sp)
    800059ea:	7b42                	ld	s6,48(sp)
    800059ec:	7ba2                	ld	s7,40(sp)
    800059ee:	7c02                	ld	s8,32(sp)
    800059f0:	6ce2                	ld	s9,24(sp)
    800059f2:	6165                	add	sp,sp,112
    800059f4:	8082                	ret

00000000800059f6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800059f6:	1101                	add	sp,sp,-32
    800059f8:	ec06                	sd	ra,24(sp)
    800059fa:	e822                	sd	s0,16(sp)
    800059fc:	e426                	sd	s1,8(sp)
    800059fe:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005a00:	00017497          	auipc	s1,0x17
    80005a04:	b1048493          	add	s1,s1,-1264 # 8001c510 <disk>
    80005a08:	00017517          	auipc	a0,0x17
    80005a0c:	c3050513          	add	a0,a0,-976 # 8001c638 <disk+0x128>
    80005a10:	00001097          	auipc	ra,0x1
    80005a14:	b5c080e7          	jalr	-1188(ra) # 8000656c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005a18:	100017b7          	lui	a5,0x10001
    80005a1c:	53b8                	lw	a4,96(a5)
    80005a1e:	8b0d                	and	a4,a4,3
    80005a20:	100017b7          	lui	a5,0x10001
    80005a24:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005a26:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005a2a:	689c                	ld	a5,16(s1)
    80005a2c:	0204d703          	lhu	a4,32(s1)
    80005a30:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005a34:	04f70863          	beq	a4,a5,80005a84 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80005a38:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a3c:	6898                	ld	a4,16(s1)
    80005a3e:	0204d783          	lhu	a5,32(s1)
    80005a42:	8b9d                	and	a5,a5,7
    80005a44:	078e                	sll	a5,a5,0x3
    80005a46:	97ba                	add	a5,a5,a4
    80005a48:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005a4a:	00278713          	add	a4,a5,2
    80005a4e:	0712                	sll	a4,a4,0x4
    80005a50:	9726                	add	a4,a4,s1
    80005a52:	01074703          	lbu	a4,16(a4)
    80005a56:	e721                	bnez	a4,80005a9e <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a58:	0789                	add	a5,a5,2
    80005a5a:	0792                	sll	a5,a5,0x4
    80005a5c:	97a6                	add	a5,a5,s1
    80005a5e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005a60:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005a64:	ffffc097          	auipc	ra,0xffffc
    80005a68:	c06080e7          	jalr	-1018(ra) # 8000166a <wakeup>

    disk.used_idx += 1;
    80005a6c:	0204d783          	lhu	a5,32(s1)
    80005a70:	2785                	addw	a5,a5,1
    80005a72:	17c2                	sll	a5,a5,0x30
    80005a74:	93c1                	srl	a5,a5,0x30
    80005a76:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005a7a:	6898                	ld	a4,16(s1)
    80005a7c:	00275703          	lhu	a4,2(a4)
    80005a80:	faf71ce3          	bne	a4,a5,80005a38 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80005a84:	00017517          	auipc	a0,0x17
    80005a88:	bb450513          	add	a0,a0,-1100 # 8001c638 <disk+0x128>
    80005a8c:	00001097          	auipc	ra,0x1
    80005a90:	b94080e7          	jalr	-1132(ra) # 80006620 <release>
}
    80005a94:	60e2                	ld	ra,24(sp)
    80005a96:	6442                	ld	s0,16(sp)
    80005a98:	64a2                	ld	s1,8(sp)
    80005a9a:	6105                	add	sp,sp,32
    80005a9c:	8082                	ret
      panic("virtio_disk_intr status");
    80005a9e:	00003517          	auipc	a0,0x3
    80005aa2:	d1a50513          	add	a0,a0,-742 # 800087b8 <etext+0x7b8>
    80005aa6:	00000097          	auipc	ra,0x0
    80005aaa:	54c080e7          	jalr	1356(ra) # 80005ff2 <panic>

0000000080005aae <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005aae:	1141                	add	sp,sp,-16
    80005ab0:	e422                	sd	s0,8(sp)
    80005ab2:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005ab4:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005ab8:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005abc:	0037979b          	sllw	a5,a5,0x3
    80005ac0:	02004737          	lui	a4,0x2004
    80005ac4:	97ba                	add	a5,a5,a4
    80005ac6:	0200c737          	lui	a4,0x200c
    80005aca:	1761                	add	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    80005acc:	6318                	ld	a4,0(a4)
    80005ace:	000f4637          	lui	a2,0xf4
    80005ad2:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005ad6:	9732                	add	a4,a4,a2
    80005ad8:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005ada:	00259693          	sll	a3,a1,0x2
    80005ade:	96ae                	add	a3,a3,a1
    80005ae0:	068e                	sll	a3,a3,0x3
    80005ae2:	00017717          	auipc	a4,0x17
    80005ae6:	b6e70713          	add	a4,a4,-1170 # 8001c650 <timer_scratch>
    80005aea:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005aec:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005aee:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005af0:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005af4:	00000797          	auipc	a5,0x0
    80005af8:	95c78793          	add	a5,a5,-1700 # 80005450 <timervec>
    80005afc:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b00:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005b04:	0087e793          	or	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b08:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005b0c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005b10:	0807e793          	or	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005b14:	30479073          	csrw	mie,a5
}
    80005b18:	6422                	ld	s0,8(sp)
    80005b1a:	0141                	add	sp,sp,16
    80005b1c:	8082                	ret

0000000080005b1e <start>:
{
    80005b1e:	1141                	add	sp,sp,-16
    80005b20:	e406                	sd	ra,8(sp)
    80005b22:	e022                	sd	s0,0(sp)
    80005b24:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b26:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005b2a:	7779                	lui	a4,0xffffe
    80005b2c:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9f6f>
    80005b30:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005b32:	6705                	lui	a4,0x1
    80005b34:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005b38:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b3a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005b3e:	ffffb797          	auipc	a5,0xffffb
    80005b42:	82478793          	add	a5,a5,-2012 # 80000362 <main>
    80005b46:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005b4a:	4781                	li	a5,0
    80005b4c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005b50:	67c1                	lui	a5,0x10
    80005b52:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005b54:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005b58:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005b5c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005b60:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005b64:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005b68:	57fd                	li	a5,-1
    80005b6a:	83a9                	srl	a5,a5,0xa
    80005b6c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005b70:	47bd                	li	a5,15
    80005b72:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005b76:	00000097          	auipc	ra,0x0
    80005b7a:	f38080e7          	jalr	-200(ra) # 80005aae <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b7e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005b82:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005b84:	823e                	mv	tp,a5
  asm volatile("mret");
    80005b86:	30200073          	mret
}
    80005b8a:	60a2                	ld	ra,8(sp)
    80005b8c:	6402                	ld	s0,0(sp)
    80005b8e:	0141                	add	sp,sp,16
    80005b90:	8082                	ret

0000000080005b92 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005b92:	715d                	add	sp,sp,-80
    80005b94:	e486                	sd	ra,72(sp)
    80005b96:	e0a2                	sd	s0,64(sp)
    80005b98:	f84a                	sd	s2,48(sp)
    80005b9a:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005b9c:	04c05663          	blez	a2,80005be8 <consolewrite+0x56>
    80005ba0:	fc26                	sd	s1,56(sp)
    80005ba2:	f44e                	sd	s3,40(sp)
    80005ba4:	f052                	sd	s4,32(sp)
    80005ba6:	ec56                	sd	s5,24(sp)
    80005ba8:	8a2a                	mv	s4,a0
    80005baa:	84ae                	mv	s1,a1
    80005bac:	89b2                	mv	s3,a2
    80005bae:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005bb0:	5afd                	li	s5,-1
    80005bb2:	4685                	li	a3,1
    80005bb4:	8626                	mv	a2,s1
    80005bb6:	85d2                	mv	a1,s4
    80005bb8:	fbf40513          	add	a0,s0,-65
    80005bbc:	ffffc097          	auipc	ra,0xffffc
    80005bc0:	ea8080e7          	jalr	-344(ra) # 80001a64 <either_copyin>
    80005bc4:	03550463          	beq	a0,s5,80005bec <consolewrite+0x5a>
      break;
    uartputc(c);
    80005bc8:	fbf44503          	lbu	a0,-65(s0)
    80005bcc:	00000097          	auipc	ra,0x0
    80005bd0:	7e4080e7          	jalr	2020(ra) # 800063b0 <uartputc>
  for(i = 0; i < n; i++){
    80005bd4:	2905                	addw	s2,s2,1
    80005bd6:	0485                	add	s1,s1,1
    80005bd8:	fd299de3          	bne	s3,s2,80005bb2 <consolewrite+0x20>
    80005bdc:	894e                	mv	s2,s3
    80005bde:	74e2                	ld	s1,56(sp)
    80005be0:	79a2                	ld	s3,40(sp)
    80005be2:	7a02                	ld	s4,32(sp)
    80005be4:	6ae2                	ld	s5,24(sp)
    80005be6:	a039                	j	80005bf4 <consolewrite+0x62>
    80005be8:	4901                	li	s2,0
    80005bea:	a029                	j	80005bf4 <consolewrite+0x62>
    80005bec:	74e2                	ld	s1,56(sp)
    80005bee:	79a2                	ld	s3,40(sp)
    80005bf0:	7a02                	ld	s4,32(sp)
    80005bf2:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005bf4:	854a                	mv	a0,s2
    80005bf6:	60a6                	ld	ra,72(sp)
    80005bf8:	6406                	ld	s0,64(sp)
    80005bfa:	7942                	ld	s2,48(sp)
    80005bfc:	6161                	add	sp,sp,80
    80005bfe:	8082                	ret

0000000080005c00 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005c00:	711d                	add	sp,sp,-96
    80005c02:	ec86                	sd	ra,88(sp)
    80005c04:	e8a2                	sd	s0,80(sp)
    80005c06:	e4a6                	sd	s1,72(sp)
    80005c08:	e0ca                	sd	s2,64(sp)
    80005c0a:	fc4e                	sd	s3,56(sp)
    80005c0c:	f852                	sd	s4,48(sp)
    80005c0e:	f456                	sd	s5,40(sp)
    80005c10:	f05a                	sd	s6,32(sp)
    80005c12:	1080                	add	s0,sp,96
    80005c14:	8aaa                	mv	s5,a0
    80005c16:	8a2e                	mv	s4,a1
    80005c18:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005c1a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005c1e:	0001f517          	auipc	a0,0x1f
    80005c22:	b7250513          	add	a0,a0,-1166 # 80024790 <cons>
    80005c26:	00001097          	auipc	ra,0x1
    80005c2a:	946080e7          	jalr	-1722(ra) # 8000656c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005c2e:	0001f497          	auipc	s1,0x1f
    80005c32:	b6248493          	add	s1,s1,-1182 # 80024790 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005c36:	0001f917          	auipc	s2,0x1f
    80005c3a:	bf290913          	add	s2,s2,-1038 # 80024828 <cons+0x98>
  while(n > 0){
    80005c3e:	0d305763          	blez	s3,80005d0c <consoleread+0x10c>
    while(cons.r == cons.w){
    80005c42:	0984a783          	lw	a5,152(s1)
    80005c46:	09c4a703          	lw	a4,156(s1)
    80005c4a:	0af71c63          	bne	a4,a5,80005d02 <consoleread+0x102>
      if(killed(myproc())){
    80005c4e:	ffffb097          	auipc	ra,0xffffb
    80005c52:	302080e7          	jalr	770(ra) # 80000f50 <myproc>
    80005c56:	ffffc097          	auipc	ra,0xffffc
    80005c5a:	c58080e7          	jalr	-936(ra) # 800018ae <killed>
    80005c5e:	e52d                	bnez	a0,80005cc8 <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    80005c60:	85a6                	mv	a1,s1
    80005c62:	854a                	mv	a0,s2
    80005c64:	ffffc097          	auipc	ra,0xffffc
    80005c68:	9a2080e7          	jalr	-1630(ra) # 80001606 <sleep>
    while(cons.r == cons.w){
    80005c6c:	0984a783          	lw	a5,152(s1)
    80005c70:	09c4a703          	lw	a4,156(s1)
    80005c74:	fcf70de3          	beq	a4,a5,80005c4e <consoleread+0x4e>
    80005c78:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005c7a:	0001f717          	auipc	a4,0x1f
    80005c7e:	b1670713          	add	a4,a4,-1258 # 80024790 <cons>
    80005c82:	0017869b          	addw	a3,a5,1
    80005c86:	08d72c23          	sw	a3,152(a4)
    80005c8a:	07f7f693          	and	a3,a5,127
    80005c8e:	9736                	add	a4,a4,a3
    80005c90:	01874703          	lbu	a4,24(a4)
    80005c94:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005c98:	4691                	li	a3,4
    80005c9a:	04db8a63          	beq	s7,a3,80005cee <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005c9e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005ca2:	4685                	li	a3,1
    80005ca4:	faf40613          	add	a2,s0,-81
    80005ca8:	85d2                	mv	a1,s4
    80005caa:	8556                	mv	a0,s5
    80005cac:	ffffc097          	auipc	ra,0xffffc
    80005cb0:	d62080e7          	jalr	-670(ra) # 80001a0e <either_copyout>
    80005cb4:	57fd                	li	a5,-1
    80005cb6:	04f50a63          	beq	a0,a5,80005d0a <consoleread+0x10a>
      break;

    dst++;
    80005cba:	0a05                	add	s4,s4,1
    --n;
    80005cbc:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    80005cbe:	47a9                	li	a5,10
    80005cc0:	06fb8163          	beq	s7,a5,80005d22 <consoleread+0x122>
    80005cc4:	6be2                	ld	s7,24(sp)
    80005cc6:	bfa5                	j	80005c3e <consoleread+0x3e>
        release(&cons.lock);
    80005cc8:	0001f517          	auipc	a0,0x1f
    80005ccc:	ac850513          	add	a0,a0,-1336 # 80024790 <cons>
    80005cd0:	00001097          	auipc	ra,0x1
    80005cd4:	950080e7          	jalr	-1712(ra) # 80006620 <release>
        return -1;
    80005cd8:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005cda:	60e6                	ld	ra,88(sp)
    80005cdc:	6446                	ld	s0,80(sp)
    80005cde:	64a6                	ld	s1,72(sp)
    80005ce0:	6906                	ld	s2,64(sp)
    80005ce2:	79e2                	ld	s3,56(sp)
    80005ce4:	7a42                	ld	s4,48(sp)
    80005ce6:	7aa2                	ld	s5,40(sp)
    80005ce8:	7b02                	ld	s6,32(sp)
    80005cea:	6125                	add	sp,sp,96
    80005cec:	8082                	ret
      if(n < target){
    80005cee:	0009871b          	sext.w	a4,s3
    80005cf2:	01677a63          	bgeu	a4,s6,80005d06 <consoleread+0x106>
        cons.r--;
    80005cf6:	0001f717          	auipc	a4,0x1f
    80005cfa:	b2f72923          	sw	a5,-1230(a4) # 80024828 <cons+0x98>
    80005cfe:	6be2                	ld	s7,24(sp)
    80005d00:	a031                	j	80005d0c <consoleread+0x10c>
    80005d02:	ec5e                	sd	s7,24(sp)
    80005d04:	bf9d                	j	80005c7a <consoleread+0x7a>
    80005d06:	6be2                	ld	s7,24(sp)
    80005d08:	a011                	j	80005d0c <consoleread+0x10c>
    80005d0a:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005d0c:	0001f517          	auipc	a0,0x1f
    80005d10:	a8450513          	add	a0,a0,-1404 # 80024790 <cons>
    80005d14:	00001097          	auipc	ra,0x1
    80005d18:	90c080e7          	jalr	-1780(ra) # 80006620 <release>
  return target - n;
    80005d1c:	413b053b          	subw	a0,s6,s3
    80005d20:	bf6d                	j	80005cda <consoleread+0xda>
    80005d22:	6be2                	ld	s7,24(sp)
    80005d24:	b7e5                	j	80005d0c <consoleread+0x10c>

0000000080005d26 <consputc>:
{
    80005d26:	1141                	add	sp,sp,-16
    80005d28:	e406                	sd	ra,8(sp)
    80005d2a:	e022                	sd	s0,0(sp)
    80005d2c:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    80005d2e:	10000793          	li	a5,256
    80005d32:	00f50a63          	beq	a0,a5,80005d46 <consputc+0x20>
    uartputc_sync(c);
    80005d36:	00000097          	auipc	ra,0x0
    80005d3a:	59c080e7          	jalr	1436(ra) # 800062d2 <uartputc_sync>
}
    80005d3e:	60a2                	ld	ra,8(sp)
    80005d40:	6402                	ld	s0,0(sp)
    80005d42:	0141                	add	sp,sp,16
    80005d44:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005d46:	4521                	li	a0,8
    80005d48:	00000097          	auipc	ra,0x0
    80005d4c:	58a080e7          	jalr	1418(ra) # 800062d2 <uartputc_sync>
    80005d50:	02000513          	li	a0,32
    80005d54:	00000097          	auipc	ra,0x0
    80005d58:	57e080e7          	jalr	1406(ra) # 800062d2 <uartputc_sync>
    80005d5c:	4521                	li	a0,8
    80005d5e:	00000097          	auipc	ra,0x0
    80005d62:	574080e7          	jalr	1396(ra) # 800062d2 <uartputc_sync>
    80005d66:	bfe1                	j	80005d3e <consputc+0x18>

0000000080005d68 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005d68:	1101                	add	sp,sp,-32
    80005d6a:	ec06                	sd	ra,24(sp)
    80005d6c:	e822                	sd	s0,16(sp)
    80005d6e:	e426                	sd	s1,8(sp)
    80005d70:	1000                	add	s0,sp,32
    80005d72:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005d74:	0001f517          	auipc	a0,0x1f
    80005d78:	a1c50513          	add	a0,a0,-1508 # 80024790 <cons>
    80005d7c:	00000097          	auipc	ra,0x0
    80005d80:	7f0080e7          	jalr	2032(ra) # 8000656c <acquire>

  switch(c){
    80005d84:	47d5                	li	a5,21
    80005d86:	0af48563          	beq	s1,a5,80005e30 <consoleintr+0xc8>
    80005d8a:	0297c963          	blt	a5,s1,80005dbc <consoleintr+0x54>
    80005d8e:	47a1                	li	a5,8
    80005d90:	0ef48c63          	beq	s1,a5,80005e88 <consoleintr+0x120>
    80005d94:	47c1                	li	a5,16
    80005d96:	10f49f63          	bne	s1,a5,80005eb4 <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005d9a:	ffffc097          	auipc	ra,0xffffc
    80005d9e:	d20080e7          	jalr	-736(ra) # 80001aba <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005da2:	0001f517          	auipc	a0,0x1f
    80005da6:	9ee50513          	add	a0,a0,-1554 # 80024790 <cons>
    80005daa:	00001097          	auipc	ra,0x1
    80005dae:	876080e7          	jalr	-1930(ra) # 80006620 <release>
}
    80005db2:	60e2                	ld	ra,24(sp)
    80005db4:	6442                	ld	s0,16(sp)
    80005db6:	64a2                	ld	s1,8(sp)
    80005db8:	6105                	add	sp,sp,32
    80005dba:	8082                	ret
  switch(c){
    80005dbc:	07f00793          	li	a5,127
    80005dc0:	0cf48463          	beq	s1,a5,80005e88 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005dc4:	0001f717          	auipc	a4,0x1f
    80005dc8:	9cc70713          	add	a4,a4,-1588 # 80024790 <cons>
    80005dcc:	0a072783          	lw	a5,160(a4)
    80005dd0:	09872703          	lw	a4,152(a4)
    80005dd4:	9f99                	subw	a5,a5,a4
    80005dd6:	07f00713          	li	a4,127
    80005dda:	fcf764e3          	bltu	a4,a5,80005da2 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005dde:	47b5                	li	a5,13
    80005de0:	0cf48d63          	beq	s1,a5,80005eba <consoleintr+0x152>
      consputc(c);
    80005de4:	8526                	mv	a0,s1
    80005de6:	00000097          	auipc	ra,0x0
    80005dea:	f40080e7          	jalr	-192(ra) # 80005d26 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005dee:	0001f797          	auipc	a5,0x1f
    80005df2:	9a278793          	add	a5,a5,-1630 # 80024790 <cons>
    80005df6:	0a07a683          	lw	a3,160(a5)
    80005dfa:	0016871b          	addw	a4,a3,1
    80005dfe:	0007061b          	sext.w	a2,a4
    80005e02:	0ae7a023          	sw	a4,160(a5)
    80005e06:	07f6f693          	and	a3,a3,127
    80005e0a:	97b6                	add	a5,a5,a3
    80005e0c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005e10:	47a9                	li	a5,10
    80005e12:	0cf48b63          	beq	s1,a5,80005ee8 <consoleintr+0x180>
    80005e16:	4791                	li	a5,4
    80005e18:	0cf48863          	beq	s1,a5,80005ee8 <consoleintr+0x180>
    80005e1c:	0001f797          	auipc	a5,0x1f
    80005e20:	a0c7a783          	lw	a5,-1524(a5) # 80024828 <cons+0x98>
    80005e24:	9f1d                	subw	a4,a4,a5
    80005e26:	08000793          	li	a5,128
    80005e2a:	f6f71ce3          	bne	a4,a5,80005da2 <consoleintr+0x3a>
    80005e2e:	a86d                	j	80005ee8 <consoleintr+0x180>
    80005e30:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005e32:	0001f717          	auipc	a4,0x1f
    80005e36:	95e70713          	add	a4,a4,-1698 # 80024790 <cons>
    80005e3a:	0a072783          	lw	a5,160(a4)
    80005e3e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e42:	0001f497          	auipc	s1,0x1f
    80005e46:	94e48493          	add	s1,s1,-1714 # 80024790 <cons>
    while(cons.e != cons.w &&
    80005e4a:	4929                	li	s2,10
    80005e4c:	02f70a63          	beq	a4,a5,80005e80 <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e50:	37fd                	addw	a5,a5,-1
    80005e52:	07f7f713          	and	a4,a5,127
    80005e56:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005e58:	01874703          	lbu	a4,24(a4)
    80005e5c:	03270463          	beq	a4,s2,80005e84 <consoleintr+0x11c>
      cons.e--;
    80005e60:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005e64:	10000513          	li	a0,256
    80005e68:	00000097          	auipc	ra,0x0
    80005e6c:	ebe080e7          	jalr	-322(ra) # 80005d26 <consputc>
    while(cons.e != cons.w &&
    80005e70:	0a04a783          	lw	a5,160(s1)
    80005e74:	09c4a703          	lw	a4,156(s1)
    80005e78:	fcf71ce3          	bne	a4,a5,80005e50 <consoleintr+0xe8>
    80005e7c:	6902                	ld	s2,0(sp)
    80005e7e:	b715                	j	80005da2 <consoleintr+0x3a>
    80005e80:	6902                	ld	s2,0(sp)
    80005e82:	b705                	j	80005da2 <consoleintr+0x3a>
    80005e84:	6902                	ld	s2,0(sp)
    80005e86:	bf31                	j	80005da2 <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005e88:	0001f717          	auipc	a4,0x1f
    80005e8c:	90870713          	add	a4,a4,-1784 # 80024790 <cons>
    80005e90:	0a072783          	lw	a5,160(a4)
    80005e94:	09c72703          	lw	a4,156(a4)
    80005e98:	f0f705e3          	beq	a4,a5,80005da2 <consoleintr+0x3a>
      cons.e--;
    80005e9c:	37fd                	addw	a5,a5,-1
    80005e9e:	0001f717          	auipc	a4,0x1f
    80005ea2:	98f72923          	sw	a5,-1646(a4) # 80024830 <cons+0xa0>
      consputc(BACKSPACE);
    80005ea6:	10000513          	li	a0,256
    80005eaa:	00000097          	auipc	ra,0x0
    80005eae:	e7c080e7          	jalr	-388(ra) # 80005d26 <consputc>
    80005eb2:	bdc5                	j	80005da2 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005eb4:	ee0487e3          	beqz	s1,80005da2 <consoleintr+0x3a>
    80005eb8:	b731                	j	80005dc4 <consoleintr+0x5c>
      consputc(c);
    80005eba:	4529                	li	a0,10
    80005ebc:	00000097          	auipc	ra,0x0
    80005ec0:	e6a080e7          	jalr	-406(ra) # 80005d26 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ec4:	0001f797          	auipc	a5,0x1f
    80005ec8:	8cc78793          	add	a5,a5,-1844 # 80024790 <cons>
    80005ecc:	0a07a703          	lw	a4,160(a5)
    80005ed0:	0017069b          	addw	a3,a4,1
    80005ed4:	0006861b          	sext.w	a2,a3
    80005ed8:	0ad7a023          	sw	a3,160(a5)
    80005edc:	07f77713          	and	a4,a4,127
    80005ee0:	97ba                	add	a5,a5,a4
    80005ee2:	4729                	li	a4,10
    80005ee4:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005ee8:	0001f797          	auipc	a5,0x1f
    80005eec:	94c7a223          	sw	a2,-1724(a5) # 8002482c <cons+0x9c>
        wakeup(&cons.r);
    80005ef0:	0001f517          	auipc	a0,0x1f
    80005ef4:	93850513          	add	a0,a0,-1736 # 80024828 <cons+0x98>
    80005ef8:	ffffb097          	auipc	ra,0xffffb
    80005efc:	772080e7          	jalr	1906(ra) # 8000166a <wakeup>
    80005f00:	b54d                	j	80005da2 <consoleintr+0x3a>

0000000080005f02 <consoleinit>:

void
consoleinit(void)
{
    80005f02:	1141                	add	sp,sp,-16
    80005f04:	e406                	sd	ra,8(sp)
    80005f06:	e022                	sd	s0,0(sp)
    80005f08:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80005f0a:	00003597          	auipc	a1,0x3
    80005f0e:	8c658593          	add	a1,a1,-1850 # 800087d0 <etext+0x7d0>
    80005f12:	0001f517          	auipc	a0,0x1f
    80005f16:	87e50513          	add	a0,a0,-1922 # 80024790 <cons>
    80005f1a:	00000097          	auipc	ra,0x0
    80005f1e:	5c2080e7          	jalr	1474(ra) # 800064dc <initlock>

  uartinit();
    80005f22:	00000097          	auipc	ra,0x0
    80005f26:	354080e7          	jalr	852(ra) # 80006276 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005f2a:	00015797          	auipc	a5,0x15
    80005f2e:	58e78793          	add	a5,a5,1422 # 8001b4b8 <devsw>
    80005f32:	00000717          	auipc	a4,0x0
    80005f36:	cce70713          	add	a4,a4,-818 # 80005c00 <consoleread>
    80005f3a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005f3c:	00000717          	auipc	a4,0x0
    80005f40:	c5670713          	add	a4,a4,-938 # 80005b92 <consolewrite>
    80005f44:	ef98                	sd	a4,24(a5)
}
    80005f46:	60a2                	ld	ra,8(sp)
    80005f48:	6402                	ld	s0,0(sp)
    80005f4a:	0141                	add	sp,sp,16
    80005f4c:	8082                	ret

0000000080005f4e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005f4e:	7179                	add	sp,sp,-48
    80005f50:	f406                	sd	ra,40(sp)
    80005f52:	f022                	sd	s0,32(sp)
    80005f54:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005f56:	c219                	beqz	a2,80005f5c <printint+0xe>
    80005f58:	08054963          	bltz	a0,80005fea <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005f5c:	2501                	sext.w	a0,a0
    80005f5e:	4881                	li	a7,0
    80005f60:	fd040693          	add	a3,s0,-48

  i = 0;
    80005f64:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005f66:	2581                	sext.w	a1,a1
    80005f68:	00003617          	auipc	a2,0x3
    80005f6c:	a3860613          	add	a2,a2,-1480 # 800089a0 <digits>
    80005f70:	883a                	mv	a6,a4
    80005f72:	2705                	addw	a4,a4,1
    80005f74:	02b577bb          	remuw	a5,a0,a1
    80005f78:	1782                	sll	a5,a5,0x20
    80005f7a:	9381                	srl	a5,a5,0x20
    80005f7c:	97b2                	add	a5,a5,a2
    80005f7e:	0007c783          	lbu	a5,0(a5)
    80005f82:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005f86:	0005079b          	sext.w	a5,a0
    80005f8a:	02b5553b          	divuw	a0,a0,a1
    80005f8e:	0685                	add	a3,a3,1
    80005f90:	feb7f0e3          	bgeu	a5,a1,80005f70 <printint+0x22>

  if(sign)
    80005f94:	00088c63          	beqz	a7,80005fac <printint+0x5e>
    buf[i++] = '-';
    80005f98:	fe070793          	add	a5,a4,-32
    80005f9c:	00878733          	add	a4,a5,s0
    80005fa0:	02d00793          	li	a5,45
    80005fa4:	fef70823          	sb	a5,-16(a4)
    80005fa8:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    80005fac:	02e05b63          	blez	a4,80005fe2 <printint+0x94>
    80005fb0:	ec26                	sd	s1,24(sp)
    80005fb2:	e84a                	sd	s2,16(sp)
    80005fb4:	fd040793          	add	a5,s0,-48
    80005fb8:	00e784b3          	add	s1,a5,a4
    80005fbc:	fff78913          	add	s2,a5,-1
    80005fc0:	993a                	add	s2,s2,a4
    80005fc2:	377d                	addw	a4,a4,-1
    80005fc4:	1702                	sll	a4,a4,0x20
    80005fc6:	9301                	srl	a4,a4,0x20
    80005fc8:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005fcc:	fff4c503          	lbu	a0,-1(s1)
    80005fd0:	00000097          	auipc	ra,0x0
    80005fd4:	d56080e7          	jalr	-682(ra) # 80005d26 <consputc>
  while(--i >= 0)
    80005fd8:	14fd                	add	s1,s1,-1
    80005fda:	ff2499e3          	bne	s1,s2,80005fcc <printint+0x7e>
    80005fde:	64e2                	ld	s1,24(sp)
    80005fe0:	6942                	ld	s2,16(sp)
}
    80005fe2:	70a2                	ld	ra,40(sp)
    80005fe4:	7402                	ld	s0,32(sp)
    80005fe6:	6145                	add	sp,sp,48
    80005fe8:	8082                	ret
    x = -xx;
    80005fea:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005fee:	4885                	li	a7,1
    x = -xx;
    80005ff0:	bf85                	j	80005f60 <printint+0x12>

0000000080005ff2 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005ff2:	1101                	add	sp,sp,-32
    80005ff4:	ec06                	sd	ra,24(sp)
    80005ff6:	e822                	sd	s0,16(sp)
    80005ff8:	e426                	sd	s1,8(sp)
    80005ffa:	1000                	add	s0,sp,32
    80005ffc:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005ffe:	0001f797          	auipc	a5,0x1f
    80006002:	8407a923          	sw	zero,-1966(a5) # 80024850 <pr+0x18>
  printf("panic: ");
    80006006:	00002517          	auipc	a0,0x2
    8000600a:	7d250513          	add	a0,a0,2002 # 800087d8 <etext+0x7d8>
    8000600e:	00000097          	auipc	ra,0x0
    80006012:	02e080e7          	jalr	46(ra) # 8000603c <printf>
  printf(s);
    80006016:	8526                	mv	a0,s1
    80006018:	00000097          	auipc	ra,0x0
    8000601c:	024080e7          	jalr	36(ra) # 8000603c <printf>
  printf("\n");
    80006020:	00002517          	auipc	a0,0x2
    80006024:	ff850513          	add	a0,a0,-8 # 80008018 <etext+0x18>
    80006028:	00000097          	auipc	ra,0x0
    8000602c:	014080e7          	jalr	20(ra) # 8000603c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006030:	4785                	li	a5,1
    80006032:	00005717          	auipc	a4,0x5
    80006036:	3cf72d23          	sw	a5,986(a4) # 8000b40c <panicked>
  for(;;)
    8000603a:	a001                	j	8000603a <panic+0x48>

000000008000603c <printf>:
{
    8000603c:	7131                	add	sp,sp,-192
    8000603e:	fc86                	sd	ra,120(sp)
    80006040:	f8a2                	sd	s0,112(sp)
    80006042:	e8d2                	sd	s4,80(sp)
    80006044:	f06a                	sd	s10,32(sp)
    80006046:	0100                	add	s0,sp,128
    80006048:	8a2a                	mv	s4,a0
    8000604a:	e40c                	sd	a1,8(s0)
    8000604c:	e810                	sd	a2,16(s0)
    8000604e:	ec14                	sd	a3,24(s0)
    80006050:	f018                	sd	a4,32(s0)
    80006052:	f41c                	sd	a5,40(s0)
    80006054:	03043823          	sd	a6,48(s0)
    80006058:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    8000605c:	0001ed17          	auipc	s10,0x1e
    80006060:	7f4d2d03          	lw	s10,2036(s10) # 80024850 <pr+0x18>
  if(locking)
    80006064:	040d1463          	bnez	s10,800060ac <printf+0x70>
  if (fmt == 0)
    80006068:	040a0b63          	beqz	s4,800060be <printf+0x82>
  va_start(ap, fmt);
    8000606c:	00840793          	add	a5,s0,8
    80006070:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006074:	000a4503          	lbu	a0,0(s4)
    80006078:	18050b63          	beqz	a0,8000620e <printf+0x1d2>
    8000607c:	f4a6                	sd	s1,104(sp)
    8000607e:	f0ca                	sd	s2,96(sp)
    80006080:	ecce                	sd	s3,88(sp)
    80006082:	e4d6                	sd	s5,72(sp)
    80006084:	e0da                	sd	s6,64(sp)
    80006086:	fc5e                	sd	s7,56(sp)
    80006088:	f862                	sd	s8,48(sp)
    8000608a:	f466                	sd	s9,40(sp)
    8000608c:	ec6e                	sd	s11,24(sp)
    8000608e:	4981                	li	s3,0
    if(c != '%'){
    80006090:	02500b13          	li	s6,37
    switch(c){
    80006094:	07000b93          	li	s7,112
  consputc('x');
    80006098:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000609a:	00003a97          	auipc	s5,0x3
    8000609e:	906a8a93          	add	s5,s5,-1786 # 800089a0 <digits>
    switch(c){
    800060a2:	07300c13          	li	s8,115
    800060a6:	06400d93          	li	s11,100
    800060aa:	a0b1                	j	800060f6 <printf+0xba>
    acquire(&pr.lock);
    800060ac:	0001e517          	auipc	a0,0x1e
    800060b0:	78c50513          	add	a0,a0,1932 # 80024838 <pr>
    800060b4:	00000097          	auipc	ra,0x0
    800060b8:	4b8080e7          	jalr	1208(ra) # 8000656c <acquire>
    800060bc:	b775                	j	80006068 <printf+0x2c>
    800060be:	f4a6                	sd	s1,104(sp)
    800060c0:	f0ca                	sd	s2,96(sp)
    800060c2:	ecce                	sd	s3,88(sp)
    800060c4:	e4d6                	sd	s5,72(sp)
    800060c6:	e0da                	sd	s6,64(sp)
    800060c8:	fc5e                	sd	s7,56(sp)
    800060ca:	f862                	sd	s8,48(sp)
    800060cc:	f466                	sd	s9,40(sp)
    800060ce:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    800060d0:	00002517          	auipc	a0,0x2
    800060d4:	71850513          	add	a0,a0,1816 # 800087e8 <etext+0x7e8>
    800060d8:	00000097          	auipc	ra,0x0
    800060dc:	f1a080e7          	jalr	-230(ra) # 80005ff2 <panic>
      consputc(c);
    800060e0:	00000097          	auipc	ra,0x0
    800060e4:	c46080e7          	jalr	-954(ra) # 80005d26 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800060e8:	2985                	addw	s3,s3,1
    800060ea:	013a07b3          	add	a5,s4,s3
    800060ee:	0007c503          	lbu	a0,0(a5)
    800060f2:	10050563          	beqz	a0,800061fc <printf+0x1c0>
    if(c != '%'){
    800060f6:	ff6515e3          	bne	a0,s6,800060e0 <printf+0xa4>
    c = fmt[++i] & 0xff;
    800060fa:	2985                	addw	s3,s3,1
    800060fc:	013a07b3          	add	a5,s4,s3
    80006100:	0007c783          	lbu	a5,0(a5)
    80006104:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006108:	10078b63          	beqz	a5,8000621e <printf+0x1e2>
    switch(c){
    8000610c:	05778a63          	beq	a5,s7,80006160 <printf+0x124>
    80006110:	02fbf663          	bgeu	s7,a5,8000613c <printf+0x100>
    80006114:	09878863          	beq	a5,s8,800061a4 <printf+0x168>
    80006118:	07800713          	li	a4,120
    8000611c:	0ce79563          	bne	a5,a4,800061e6 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80006120:	f8843783          	ld	a5,-120(s0)
    80006124:	00878713          	add	a4,a5,8
    80006128:	f8e43423          	sd	a4,-120(s0)
    8000612c:	4605                	li	a2,1
    8000612e:	85e6                	mv	a1,s9
    80006130:	4388                	lw	a0,0(a5)
    80006132:	00000097          	auipc	ra,0x0
    80006136:	e1c080e7          	jalr	-484(ra) # 80005f4e <printint>
      break;
    8000613a:	b77d                	j	800060e8 <printf+0xac>
    switch(c){
    8000613c:	09678f63          	beq	a5,s6,800061da <printf+0x19e>
    80006140:	0bb79363          	bne	a5,s11,800061e6 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80006144:	f8843783          	ld	a5,-120(s0)
    80006148:	00878713          	add	a4,a5,8
    8000614c:	f8e43423          	sd	a4,-120(s0)
    80006150:	4605                	li	a2,1
    80006152:	45a9                	li	a1,10
    80006154:	4388                	lw	a0,0(a5)
    80006156:	00000097          	auipc	ra,0x0
    8000615a:	df8080e7          	jalr	-520(ra) # 80005f4e <printint>
      break;
    8000615e:	b769                	j	800060e8 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80006160:	f8843783          	ld	a5,-120(s0)
    80006164:	00878713          	add	a4,a5,8
    80006168:	f8e43423          	sd	a4,-120(s0)
    8000616c:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006170:	03000513          	li	a0,48
    80006174:	00000097          	auipc	ra,0x0
    80006178:	bb2080e7          	jalr	-1102(ra) # 80005d26 <consputc>
  consputc('x');
    8000617c:	07800513          	li	a0,120
    80006180:	00000097          	auipc	ra,0x0
    80006184:	ba6080e7          	jalr	-1114(ra) # 80005d26 <consputc>
    80006188:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000618a:	03c95793          	srl	a5,s2,0x3c
    8000618e:	97d6                	add	a5,a5,s5
    80006190:	0007c503          	lbu	a0,0(a5)
    80006194:	00000097          	auipc	ra,0x0
    80006198:	b92080e7          	jalr	-1134(ra) # 80005d26 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000619c:	0912                	sll	s2,s2,0x4
    8000619e:	34fd                	addw	s1,s1,-1
    800061a0:	f4ed                	bnez	s1,8000618a <printf+0x14e>
    800061a2:	b799                	j	800060e8 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    800061a4:	f8843783          	ld	a5,-120(s0)
    800061a8:	00878713          	add	a4,a5,8
    800061ac:	f8e43423          	sd	a4,-120(s0)
    800061b0:	6384                	ld	s1,0(a5)
    800061b2:	cc89                	beqz	s1,800061cc <printf+0x190>
      for(; *s; s++)
    800061b4:	0004c503          	lbu	a0,0(s1)
    800061b8:	d905                	beqz	a0,800060e8 <printf+0xac>
        consputc(*s);
    800061ba:	00000097          	auipc	ra,0x0
    800061be:	b6c080e7          	jalr	-1172(ra) # 80005d26 <consputc>
      for(; *s; s++)
    800061c2:	0485                	add	s1,s1,1
    800061c4:	0004c503          	lbu	a0,0(s1)
    800061c8:	f96d                	bnez	a0,800061ba <printf+0x17e>
    800061ca:	bf39                	j	800060e8 <printf+0xac>
        s = "(null)";
    800061cc:	00002497          	auipc	s1,0x2
    800061d0:	61448493          	add	s1,s1,1556 # 800087e0 <etext+0x7e0>
      for(; *s; s++)
    800061d4:	02800513          	li	a0,40
    800061d8:	b7cd                	j	800061ba <printf+0x17e>
      consputc('%');
    800061da:	855a                	mv	a0,s6
    800061dc:	00000097          	auipc	ra,0x0
    800061e0:	b4a080e7          	jalr	-1206(ra) # 80005d26 <consputc>
      break;
    800061e4:	b711                	j	800060e8 <printf+0xac>
      consputc('%');
    800061e6:	855a                	mv	a0,s6
    800061e8:	00000097          	auipc	ra,0x0
    800061ec:	b3e080e7          	jalr	-1218(ra) # 80005d26 <consputc>
      consputc(c);
    800061f0:	8526                	mv	a0,s1
    800061f2:	00000097          	auipc	ra,0x0
    800061f6:	b34080e7          	jalr	-1228(ra) # 80005d26 <consputc>
      break;
    800061fa:	b5fd                	j	800060e8 <printf+0xac>
    800061fc:	74a6                	ld	s1,104(sp)
    800061fe:	7906                	ld	s2,96(sp)
    80006200:	69e6                	ld	s3,88(sp)
    80006202:	6aa6                	ld	s5,72(sp)
    80006204:	6b06                	ld	s6,64(sp)
    80006206:	7be2                	ld	s7,56(sp)
    80006208:	7c42                	ld	s8,48(sp)
    8000620a:	7ca2                	ld	s9,40(sp)
    8000620c:	6de2                	ld	s11,24(sp)
  if(locking)
    8000620e:	020d1263          	bnez	s10,80006232 <printf+0x1f6>
}
    80006212:	70e6                	ld	ra,120(sp)
    80006214:	7446                	ld	s0,112(sp)
    80006216:	6a46                	ld	s4,80(sp)
    80006218:	7d02                	ld	s10,32(sp)
    8000621a:	6129                	add	sp,sp,192
    8000621c:	8082                	ret
    8000621e:	74a6                	ld	s1,104(sp)
    80006220:	7906                	ld	s2,96(sp)
    80006222:	69e6                	ld	s3,88(sp)
    80006224:	6aa6                	ld	s5,72(sp)
    80006226:	6b06                	ld	s6,64(sp)
    80006228:	7be2                	ld	s7,56(sp)
    8000622a:	7c42                	ld	s8,48(sp)
    8000622c:	7ca2                	ld	s9,40(sp)
    8000622e:	6de2                	ld	s11,24(sp)
    80006230:	bff9                	j	8000620e <printf+0x1d2>
    release(&pr.lock);
    80006232:	0001e517          	auipc	a0,0x1e
    80006236:	60650513          	add	a0,a0,1542 # 80024838 <pr>
    8000623a:	00000097          	auipc	ra,0x0
    8000623e:	3e6080e7          	jalr	998(ra) # 80006620 <release>
}
    80006242:	bfc1                	j	80006212 <printf+0x1d6>

0000000080006244 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006244:	1101                	add	sp,sp,-32
    80006246:	ec06                	sd	ra,24(sp)
    80006248:	e822                	sd	s0,16(sp)
    8000624a:	e426                	sd	s1,8(sp)
    8000624c:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    8000624e:	0001e497          	auipc	s1,0x1e
    80006252:	5ea48493          	add	s1,s1,1514 # 80024838 <pr>
    80006256:	00002597          	auipc	a1,0x2
    8000625a:	5a258593          	add	a1,a1,1442 # 800087f8 <etext+0x7f8>
    8000625e:	8526                	mv	a0,s1
    80006260:	00000097          	auipc	ra,0x0
    80006264:	27c080e7          	jalr	636(ra) # 800064dc <initlock>
  pr.locking = 1;
    80006268:	4785                	li	a5,1
    8000626a:	cc9c                	sw	a5,24(s1)
}
    8000626c:	60e2                	ld	ra,24(sp)
    8000626e:	6442                	ld	s0,16(sp)
    80006270:	64a2                	ld	s1,8(sp)
    80006272:	6105                	add	sp,sp,32
    80006274:	8082                	ret

0000000080006276 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006276:	1141                	add	sp,sp,-16
    80006278:	e406                	sd	ra,8(sp)
    8000627a:	e022                	sd	s0,0(sp)
    8000627c:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000627e:	100007b7          	lui	a5,0x10000
    80006282:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006286:	10000737          	lui	a4,0x10000
    8000628a:	f8000693          	li	a3,-128
    8000628e:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006292:	468d                	li	a3,3
    80006294:	10000637          	lui	a2,0x10000
    80006298:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000629c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800062a0:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800062a4:	10000737          	lui	a4,0x10000
    800062a8:	461d                	li	a2,7
    800062aa:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800062ae:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800062b2:	00002597          	auipc	a1,0x2
    800062b6:	54e58593          	add	a1,a1,1358 # 80008800 <etext+0x800>
    800062ba:	0001e517          	auipc	a0,0x1e
    800062be:	59e50513          	add	a0,a0,1438 # 80024858 <uart_tx_lock>
    800062c2:	00000097          	auipc	ra,0x0
    800062c6:	21a080e7          	jalr	538(ra) # 800064dc <initlock>
}
    800062ca:	60a2                	ld	ra,8(sp)
    800062cc:	6402                	ld	s0,0(sp)
    800062ce:	0141                	add	sp,sp,16
    800062d0:	8082                	ret

00000000800062d2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800062d2:	1101                	add	sp,sp,-32
    800062d4:	ec06                	sd	ra,24(sp)
    800062d6:	e822                	sd	s0,16(sp)
    800062d8:	e426                	sd	s1,8(sp)
    800062da:	1000                	add	s0,sp,32
    800062dc:	84aa                	mv	s1,a0
  push_off();
    800062de:	00000097          	auipc	ra,0x0
    800062e2:	242080e7          	jalr	578(ra) # 80006520 <push_off>

  if(panicked){
    800062e6:	00005797          	auipc	a5,0x5
    800062ea:	1267a783          	lw	a5,294(a5) # 8000b40c <panicked>
    800062ee:	eb85                	bnez	a5,8000631e <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800062f0:	10000737          	lui	a4,0x10000
    800062f4:	0715                	add	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800062f6:	00074783          	lbu	a5,0(a4)
    800062fa:	0207f793          	and	a5,a5,32
    800062fe:	dfe5                	beqz	a5,800062f6 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006300:	0ff4f513          	zext.b	a0,s1
    80006304:	100007b7          	lui	a5,0x10000
    80006308:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000630c:	00000097          	auipc	ra,0x0
    80006310:	2b4080e7          	jalr	692(ra) # 800065c0 <pop_off>
}
    80006314:	60e2                	ld	ra,24(sp)
    80006316:	6442                	ld	s0,16(sp)
    80006318:	64a2                	ld	s1,8(sp)
    8000631a:	6105                	add	sp,sp,32
    8000631c:	8082                	ret
    for(;;)
    8000631e:	a001                	j	8000631e <uartputc_sync+0x4c>

0000000080006320 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006320:	00005797          	auipc	a5,0x5
    80006324:	0f07b783          	ld	a5,240(a5) # 8000b410 <uart_tx_r>
    80006328:	00005717          	auipc	a4,0x5
    8000632c:	0f073703          	ld	a4,240(a4) # 8000b418 <uart_tx_w>
    80006330:	06f70f63          	beq	a4,a5,800063ae <uartstart+0x8e>
{
    80006334:	7139                	add	sp,sp,-64
    80006336:	fc06                	sd	ra,56(sp)
    80006338:	f822                	sd	s0,48(sp)
    8000633a:	f426                	sd	s1,40(sp)
    8000633c:	f04a                	sd	s2,32(sp)
    8000633e:	ec4e                	sd	s3,24(sp)
    80006340:	e852                	sd	s4,16(sp)
    80006342:	e456                	sd	s5,8(sp)
    80006344:	e05a                	sd	s6,0(sp)
    80006346:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006348:	10000937          	lui	s2,0x10000
    8000634c:	0915                	add	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000634e:	0001ea97          	auipc	s5,0x1e
    80006352:	50aa8a93          	add	s5,s5,1290 # 80024858 <uart_tx_lock>
    uart_tx_r += 1;
    80006356:	00005497          	auipc	s1,0x5
    8000635a:	0ba48493          	add	s1,s1,186 # 8000b410 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    8000635e:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80006362:	00005997          	auipc	s3,0x5
    80006366:	0b698993          	add	s3,s3,182 # 8000b418 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000636a:	00094703          	lbu	a4,0(s2)
    8000636e:	02077713          	and	a4,a4,32
    80006372:	c705                	beqz	a4,8000639a <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006374:	01f7f713          	and	a4,a5,31
    80006378:	9756                	add	a4,a4,s5
    8000637a:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    8000637e:	0785                	add	a5,a5,1
    80006380:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80006382:	8526                	mv	a0,s1
    80006384:	ffffb097          	auipc	ra,0xffffb
    80006388:	2e6080e7          	jalr	742(ra) # 8000166a <wakeup>
    WriteReg(THR, c);
    8000638c:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80006390:	609c                	ld	a5,0(s1)
    80006392:	0009b703          	ld	a4,0(s3)
    80006396:	fcf71ae3          	bne	a4,a5,8000636a <uartstart+0x4a>
  }
}
    8000639a:	70e2                	ld	ra,56(sp)
    8000639c:	7442                	ld	s0,48(sp)
    8000639e:	74a2                	ld	s1,40(sp)
    800063a0:	7902                	ld	s2,32(sp)
    800063a2:	69e2                	ld	s3,24(sp)
    800063a4:	6a42                	ld	s4,16(sp)
    800063a6:	6aa2                	ld	s5,8(sp)
    800063a8:	6b02                	ld	s6,0(sp)
    800063aa:	6121                	add	sp,sp,64
    800063ac:	8082                	ret
    800063ae:	8082                	ret

00000000800063b0 <uartputc>:
{
    800063b0:	7179                	add	sp,sp,-48
    800063b2:	f406                	sd	ra,40(sp)
    800063b4:	f022                	sd	s0,32(sp)
    800063b6:	ec26                	sd	s1,24(sp)
    800063b8:	e84a                	sd	s2,16(sp)
    800063ba:	e44e                	sd	s3,8(sp)
    800063bc:	e052                	sd	s4,0(sp)
    800063be:	1800                	add	s0,sp,48
    800063c0:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800063c2:	0001e517          	auipc	a0,0x1e
    800063c6:	49650513          	add	a0,a0,1174 # 80024858 <uart_tx_lock>
    800063ca:	00000097          	auipc	ra,0x0
    800063ce:	1a2080e7          	jalr	418(ra) # 8000656c <acquire>
  if(panicked){
    800063d2:	00005797          	auipc	a5,0x5
    800063d6:	03a7a783          	lw	a5,58(a5) # 8000b40c <panicked>
    800063da:	e7c9                	bnez	a5,80006464 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063dc:	00005717          	auipc	a4,0x5
    800063e0:	03c73703          	ld	a4,60(a4) # 8000b418 <uart_tx_w>
    800063e4:	00005797          	auipc	a5,0x5
    800063e8:	02c7b783          	ld	a5,44(a5) # 8000b410 <uart_tx_r>
    800063ec:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800063f0:	0001e997          	auipc	s3,0x1e
    800063f4:	46898993          	add	s3,s3,1128 # 80024858 <uart_tx_lock>
    800063f8:	00005497          	auipc	s1,0x5
    800063fc:	01848493          	add	s1,s1,24 # 8000b410 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006400:	00005917          	auipc	s2,0x5
    80006404:	01890913          	add	s2,s2,24 # 8000b418 <uart_tx_w>
    80006408:	00e79f63          	bne	a5,a4,80006426 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000640c:	85ce                	mv	a1,s3
    8000640e:	8526                	mv	a0,s1
    80006410:	ffffb097          	auipc	ra,0xffffb
    80006414:	1f6080e7          	jalr	502(ra) # 80001606 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006418:	00093703          	ld	a4,0(s2)
    8000641c:	609c                	ld	a5,0(s1)
    8000641e:	02078793          	add	a5,a5,32
    80006422:	fee785e3          	beq	a5,a4,8000640c <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006426:	0001e497          	auipc	s1,0x1e
    8000642a:	43248493          	add	s1,s1,1074 # 80024858 <uart_tx_lock>
    8000642e:	01f77793          	and	a5,a4,31
    80006432:	97a6                	add	a5,a5,s1
    80006434:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006438:	0705                	add	a4,a4,1
    8000643a:	00005797          	auipc	a5,0x5
    8000643e:	fce7bf23          	sd	a4,-34(a5) # 8000b418 <uart_tx_w>
  uartstart();
    80006442:	00000097          	auipc	ra,0x0
    80006446:	ede080e7          	jalr	-290(ra) # 80006320 <uartstart>
  release(&uart_tx_lock);
    8000644a:	8526                	mv	a0,s1
    8000644c:	00000097          	auipc	ra,0x0
    80006450:	1d4080e7          	jalr	468(ra) # 80006620 <release>
}
    80006454:	70a2                	ld	ra,40(sp)
    80006456:	7402                	ld	s0,32(sp)
    80006458:	64e2                	ld	s1,24(sp)
    8000645a:	6942                	ld	s2,16(sp)
    8000645c:	69a2                	ld	s3,8(sp)
    8000645e:	6a02                	ld	s4,0(sp)
    80006460:	6145                	add	sp,sp,48
    80006462:	8082                	ret
    for(;;)
    80006464:	a001                	j	80006464 <uartputc+0xb4>

0000000080006466 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006466:	1141                	add	sp,sp,-16
    80006468:	e422                	sd	s0,8(sp)
    8000646a:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000646c:	100007b7          	lui	a5,0x10000
    80006470:	0795                	add	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80006472:	0007c783          	lbu	a5,0(a5)
    80006476:	8b85                	and	a5,a5,1
    80006478:	cb81                	beqz	a5,80006488 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    8000647a:	100007b7          	lui	a5,0x10000
    8000647e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006482:	6422                	ld	s0,8(sp)
    80006484:	0141                	add	sp,sp,16
    80006486:	8082                	ret
    return -1;
    80006488:	557d                	li	a0,-1
    8000648a:	bfe5                	j	80006482 <uartgetc+0x1c>

000000008000648c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000648c:	1101                	add	sp,sp,-32
    8000648e:	ec06                	sd	ra,24(sp)
    80006490:	e822                	sd	s0,16(sp)
    80006492:	e426                	sd	s1,8(sp)
    80006494:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006496:	54fd                	li	s1,-1
    80006498:	a029                	j	800064a2 <uartintr+0x16>
      break;
    consoleintr(c);
    8000649a:	00000097          	auipc	ra,0x0
    8000649e:	8ce080e7          	jalr	-1842(ra) # 80005d68 <consoleintr>
    int c = uartgetc();
    800064a2:	00000097          	auipc	ra,0x0
    800064a6:	fc4080e7          	jalr	-60(ra) # 80006466 <uartgetc>
    if(c == -1)
    800064aa:	fe9518e3          	bne	a0,s1,8000649a <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800064ae:	0001e497          	auipc	s1,0x1e
    800064b2:	3aa48493          	add	s1,s1,938 # 80024858 <uart_tx_lock>
    800064b6:	8526                	mv	a0,s1
    800064b8:	00000097          	auipc	ra,0x0
    800064bc:	0b4080e7          	jalr	180(ra) # 8000656c <acquire>
  uartstart();
    800064c0:	00000097          	auipc	ra,0x0
    800064c4:	e60080e7          	jalr	-416(ra) # 80006320 <uartstart>
  release(&uart_tx_lock);
    800064c8:	8526                	mv	a0,s1
    800064ca:	00000097          	auipc	ra,0x0
    800064ce:	156080e7          	jalr	342(ra) # 80006620 <release>
}
    800064d2:	60e2                	ld	ra,24(sp)
    800064d4:	6442                	ld	s0,16(sp)
    800064d6:	64a2                	ld	s1,8(sp)
    800064d8:	6105                	add	sp,sp,32
    800064da:	8082                	ret

00000000800064dc <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800064dc:	1141                	add	sp,sp,-16
    800064de:	e422                	sd	s0,8(sp)
    800064e0:	0800                	add	s0,sp,16
  lk->name = name;
    800064e2:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800064e4:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800064e8:	00053823          	sd	zero,16(a0)
}
    800064ec:	6422                	ld	s0,8(sp)
    800064ee:	0141                	add	sp,sp,16
    800064f0:	8082                	ret

00000000800064f2 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800064f2:	411c                	lw	a5,0(a0)
    800064f4:	e399                	bnez	a5,800064fa <holding+0x8>
    800064f6:	4501                	li	a0,0
  return r;
}
    800064f8:	8082                	ret
{
    800064fa:	1101                	add	sp,sp,-32
    800064fc:	ec06                	sd	ra,24(sp)
    800064fe:	e822                	sd	s0,16(sp)
    80006500:	e426                	sd	s1,8(sp)
    80006502:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006504:	6904                	ld	s1,16(a0)
    80006506:	ffffb097          	auipc	ra,0xffffb
    8000650a:	a2e080e7          	jalr	-1490(ra) # 80000f34 <mycpu>
    8000650e:	40a48533          	sub	a0,s1,a0
    80006512:	00153513          	seqz	a0,a0
}
    80006516:	60e2                	ld	ra,24(sp)
    80006518:	6442                	ld	s0,16(sp)
    8000651a:	64a2                	ld	s1,8(sp)
    8000651c:	6105                	add	sp,sp,32
    8000651e:	8082                	ret

0000000080006520 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006520:	1101                	add	sp,sp,-32
    80006522:	ec06                	sd	ra,24(sp)
    80006524:	e822                	sd	s0,16(sp)
    80006526:	e426                	sd	s1,8(sp)
    80006528:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000652a:	100024f3          	csrr	s1,sstatus
    8000652e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006532:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006534:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006538:	ffffb097          	auipc	ra,0xffffb
    8000653c:	9fc080e7          	jalr	-1540(ra) # 80000f34 <mycpu>
    80006540:	5d3c                	lw	a5,120(a0)
    80006542:	cf89                	beqz	a5,8000655c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006544:	ffffb097          	auipc	ra,0xffffb
    80006548:	9f0080e7          	jalr	-1552(ra) # 80000f34 <mycpu>
    8000654c:	5d3c                	lw	a5,120(a0)
    8000654e:	2785                	addw	a5,a5,1
    80006550:	dd3c                	sw	a5,120(a0)
}
    80006552:	60e2                	ld	ra,24(sp)
    80006554:	6442                	ld	s0,16(sp)
    80006556:	64a2                	ld	s1,8(sp)
    80006558:	6105                	add	sp,sp,32
    8000655a:	8082                	ret
    mycpu()->intena = old;
    8000655c:	ffffb097          	auipc	ra,0xffffb
    80006560:	9d8080e7          	jalr	-1576(ra) # 80000f34 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006564:	8085                	srl	s1,s1,0x1
    80006566:	8885                	and	s1,s1,1
    80006568:	dd64                	sw	s1,124(a0)
    8000656a:	bfe9                	j	80006544 <push_off+0x24>

000000008000656c <acquire>:
{
    8000656c:	1101                	add	sp,sp,-32
    8000656e:	ec06                	sd	ra,24(sp)
    80006570:	e822                	sd	s0,16(sp)
    80006572:	e426                	sd	s1,8(sp)
    80006574:	1000                	add	s0,sp,32
    80006576:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006578:	00000097          	auipc	ra,0x0
    8000657c:	fa8080e7          	jalr	-88(ra) # 80006520 <push_off>
  if(holding(lk))
    80006580:	8526                	mv	a0,s1
    80006582:	00000097          	auipc	ra,0x0
    80006586:	f70080e7          	jalr	-144(ra) # 800064f2 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000658a:	4705                	li	a4,1
  if(holding(lk))
    8000658c:	e115                	bnez	a0,800065b0 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000658e:	87ba                	mv	a5,a4
    80006590:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006594:	2781                	sext.w	a5,a5
    80006596:	ffe5                	bnez	a5,8000658e <acquire+0x22>
  __sync_synchronize();
    80006598:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    8000659c:	ffffb097          	auipc	ra,0xffffb
    800065a0:	998080e7          	jalr	-1640(ra) # 80000f34 <mycpu>
    800065a4:	e888                	sd	a0,16(s1)
}
    800065a6:	60e2                	ld	ra,24(sp)
    800065a8:	6442                	ld	s0,16(sp)
    800065aa:	64a2                	ld	s1,8(sp)
    800065ac:	6105                	add	sp,sp,32
    800065ae:	8082                	ret
    panic("acquire");
    800065b0:	00002517          	auipc	a0,0x2
    800065b4:	25850513          	add	a0,a0,600 # 80008808 <etext+0x808>
    800065b8:	00000097          	auipc	ra,0x0
    800065bc:	a3a080e7          	jalr	-1478(ra) # 80005ff2 <panic>

00000000800065c0 <pop_off>:

void
pop_off(void)
{
    800065c0:	1141                	add	sp,sp,-16
    800065c2:	e406                	sd	ra,8(sp)
    800065c4:	e022                	sd	s0,0(sp)
    800065c6:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    800065c8:	ffffb097          	auipc	ra,0xffffb
    800065cc:	96c080e7          	jalr	-1684(ra) # 80000f34 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065d0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800065d4:	8b89                	and	a5,a5,2
  if(intr_get())
    800065d6:	e78d                	bnez	a5,80006600 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800065d8:	5d3c                	lw	a5,120(a0)
    800065da:	02f05b63          	blez	a5,80006610 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800065de:	37fd                	addw	a5,a5,-1
    800065e0:	0007871b          	sext.w	a4,a5
    800065e4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800065e6:	eb09                	bnez	a4,800065f8 <pop_off+0x38>
    800065e8:	5d7c                	lw	a5,124(a0)
    800065ea:	c799                	beqz	a5,800065f8 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065ec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800065f0:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800065f4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800065f8:	60a2                	ld	ra,8(sp)
    800065fa:	6402                	ld	s0,0(sp)
    800065fc:	0141                	add	sp,sp,16
    800065fe:	8082                	ret
    panic("pop_off - interruptible");
    80006600:	00002517          	auipc	a0,0x2
    80006604:	21050513          	add	a0,a0,528 # 80008810 <etext+0x810>
    80006608:	00000097          	auipc	ra,0x0
    8000660c:	9ea080e7          	jalr	-1558(ra) # 80005ff2 <panic>
    panic("pop_off");
    80006610:	00002517          	auipc	a0,0x2
    80006614:	21850513          	add	a0,a0,536 # 80008828 <etext+0x828>
    80006618:	00000097          	auipc	ra,0x0
    8000661c:	9da080e7          	jalr	-1574(ra) # 80005ff2 <panic>

0000000080006620 <release>:
{
    80006620:	1101                	add	sp,sp,-32
    80006622:	ec06                	sd	ra,24(sp)
    80006624:	e822                	sd	s0,16(sp)
    80006626:	e426                	sd	s1,8(sp)
    80006628:	1000                	add	s0,sp,32
    8000662a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000662c:	00000097          	auipc	ra,0x0
    80006630:	ec6080e7          	jalr	-314(ra) # 800064f2 <holding>
    80006634:	c115                	beqz	a0,80006658 <release+0x38>
  lk->cpu = 0;
    80006636:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000663a:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    8000663e:	0310000f          	fence	rw,w
    80006642:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006646:	00000097          	auipc	ra,0x0
    8000664a:	f7a080e7          	jalr	-134(ra) # 800065c0 <pop_off>
}
    8000664e:	60e2                	ld	ra,24(sp)
    80006650:	6442                	ld	s0,16(sp)
    80006652:	64a2                	ld	s1,8(sp)
    80006654:	6105                	add	sp,sp,32
    80006656:	8082                	ret
    panic("release");
    80006658:	00002517          	auipc	a0,0x2
    8000665c:	1d850513          	add	a0,a0,472 # 80008830 <etext+0x830>
    80006660:	00000097          	auipc	ra,0x0
    80006664:	992080e7          	jalr	-1646(ra) # 80005ff2 <panic>
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
