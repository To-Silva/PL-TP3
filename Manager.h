#ifndef MANAGER_H_INCLUDED
#define MANAGER_H_INCLUDED
//How many levels of nesting to allow for a given Jumpble expression
#define JUMP_LABELS_MAX 512
#include "Types.h"

/* program_status.c */
typedef struct manager *Manager;

Manager create_manager(const int stack_cap);
void push_label(Manager manager,const Jumpable j);
void pop_label(Manager manager,const Jumpable j);
int top_label(Manager manager,const Jumpable j);
int new_int ( Manager manager);
int new_array ( Manager manager, int size);
int new_matrix ( Manager manager, int sizex, int sizey);




#endif // PROGRAM_STATUS_H_INCLUDED
