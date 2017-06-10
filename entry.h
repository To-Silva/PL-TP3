
#ifndef ENTRY_H_INCLUDED
#define ENTRY_H_INCLUDED
#include "types.h"


typedef struct entry *Entry;
/* entry.c */
Type get_type(const Entry it);
int get_address(const Entry it);
int get_sizex(const Entry it);
void delete_entry(const Entry t);
Entry new_entry_variable(const int address,const Type type);
Entry new_entry_array(const int address,const Type type,const int size);
Entry new_entry_matrix(const int address, const type,const int sizex,const int sizey);




#endif // ENTRY_H_INCLUDED
