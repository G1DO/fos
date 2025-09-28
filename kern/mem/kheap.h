#ifndef FOS_KERN_KHEAP_H_
#define FOS_KERN_KHEAP_H_

#ifndef FOS_KERNEL
# error "This is a FOS kernel header; user programs should not #include it"
#endif

#include <inc/types.h>


/*2017*/
uint32 _KHeapPlacementStrategy;
//Values for user heap placement strategy
#define KHP_PLACE_CONTALLOC 0x0
#define KHP_PLACE_FIRSTFIT 	0x1
#define KHP_PLACE_BESTFIT 	0x2
#define KHP_PLACE_NEXTFIT 	0x3
#define KHP_PLACE_WORSTFIT 	0x4

static  void setKHeapPlacementStrategyCONTALLOC(){_KHeapPlacementStrategy = KHP_PLACE_CONTALLOC;}
static  void setKHeapPlacementStrategyFIRSTFIT(){_KHeapPlacementStrategy = KHP_PLACE_FIRSTFIT;}
static  void setKHeapPlacementStrategyBESTFIT(){_KHeapPlacementStrategy = KHP_PLACE_BESTFIT;}
static  void setKHeapPlacementStrategyNEXTFIT(){_KHeapPlacementStrategy = KHP_PLACE_NEXTFIT;}
static  void setKHeapPlacementStrategyWORSTFIT(){_KHeapPlacementStrategy = KHP_PLACE_WORSTFIT;}

static  uint8 isKHeapPlacementStrategyCONTALLOC(){if(_KHeapPlacementStrategy == KHP_PLACE_CONTALLOC) return 1; return 0;}
static  uint8 isKHeapPlacementStrategyFIRSTFIT(){if(_KHeapPlacementStrategy == KHP_PLACE_FIRSTFIT) return 1; return 0;}
static  uint8 isKHeapPlacementStrategyBESTFIT(){if(_KHeapPlacementStrategy == KHP_PLACE_BESTFIT) return 1; return 0;}
static  uint8 isKHeapPlacementStrategyNEXTFIT(){if(_KHeapPlacementStrategy == KHP_PLACE_NEXTFIT) return 1; return 0;}
static  uint8 isKHeapPlacementStrategyWORSTFIT(){if(_KHeapPlacementStrategy == KHP_PLACE_WORSTFIT) return 1; return 0;}

//***********************************

void* kmalloc(unsigned int size);
void kfree(void* virtual_address);
void *krealloc(void *virtual_address, unsigned int new_size);

unsigned int kheap_virtual_address(unsigned int physical_address);
unsigned int kheap_physical_address(unsigned int virtual_address);

int numOfKheapVACalls ;

#endif // FOS_KERN_KHEAP_H_
