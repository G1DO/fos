/*
 * paging_helpers.h
 *
 *  Created on: Sep 30, 2022
 *      Author: HP
 */

#ifndef KERN_MEM_PAGING_HELPERS_H_
#define KERN_MEM_PAGING_HELPERS_H_

/*[1] PAGE TABLE ENTRIES MANIPULATION */
 void pt_clear_page_table_entry(uint32* page_directory, uint32 virtual_address);
 void pt_set_page_permissions(uint32* page_directory, uint32 virtual_address, uint32 permissions_to_set, uint32 permissions_to_clear);
 int pt_get_page_permissions(uint32* page_directory, uint32 virtual_address );

/*[2] PAGING HELPERS */
 uint32 virtual_to_physical(uint32* page_directory, uint32 va);
 uint32 physical_to_virtual(uint32* page_directory, uint32 physical_address);
 uint32 num_of_references(uint32 physical_address);
 int alloc_page(uint32* page_directory, uint32 va, uint32 perms, bool set_to_zero);
 int alloc_shared_page(uint32* page_dir1, uint32 va1,uint32* page_dir2, uint32 va2, uint32 perms);
 void del_page_table(uint32* page_dir, uint32 va);


/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
/* PAGE DIR ENTRIES MANIPULATION */
 uint32 pd_is_table_used(uint32* page_directory, uint32 virtual_address);
 void pd_set_table_unused(uint32* page_directory, uint32 virtual_address);
 void pd_clear_page_dir_entry(uint32* page_directory, uint32 virtual_address);

#endif /* KERN_MEM_PAGING_HELPERS_H_ */
