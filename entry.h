
#ifndef ENTRY_H_INCLUDED
#define ENTRY_H_INCLUDED
#include "types.h"

typedef struct entry Entry;
/* entry.c */
Entry *init_entry(void);
Class get_class(Entry *it);
int get_address(Entry *it);
int get_sizex(Entry *it);
int set_class(Entry *it, Class id_class);
int set_address(Entry *it, int address);
int set_sizex(Entry *it, int sx);
int set_sizey(Entry *it, int sy);
void delete_entry(Entry *t);
Entry *new_entry_variable(int address, Class id_class);
Entry *new_entry_array(int address, Class id_class, int size);
Entry *new_entry_matrix(int address, Class id_class, int sizex, int sizey);




#endif // ENTRY_H_INCLUDED
