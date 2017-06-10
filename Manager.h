#ifndef MANAGER_H_INCLUDED
#define MANAGER_H_INCLUDED
#include "types.h"
/*
#define MAX_LABEL_STACK 1024
#define MAX_LABEL 1024
#define MAX_CONDITION_ROW 4
*/

/* program_status.c */
typedef struct manager
{
    int addresspointer;
} *Program_Manager;

Program_status *init(Program_status * status);
int push_label_stack(Program_status *status, CompoundInstruction cpd);
int pop_label_stack(Program_status *status, CompoundInstruction cpd);
int top_label_stack(Program_status *status, CompoundInstruction cpd);
int reset_label_stack(Program_status *status, CompoundInstruction cpd);
int increment_top_label_stack(Program_status *status, CompoundInstruction cpd);
char *get_label(Program_status *status, CompoundInstruction cpd);
char *push_label(Program_status *status, CompoundInstruction cpd);
int pop_label(Program_status *status, CompoundInstruction cpd);
int atribute_adress_for_var(Program_status *status);
int atribute_adress_for_array(Program_status *status, int size);
int check_type(Type a, Type b);
int add_Variable(Program_status *status, char *key, Class id_class);
int add_Array(Program_status *status, char *key, Class id_class, int size);
int add_Array2D(Program_status *status, char *key, Class id_class, int size, int ncols);
Entry *find_identifier(Program_status *status, char *key);
void delete_identifier(Program_status *status, char *key);
void delete_all_identifiers(Program_status *status);
void destroy_status(Program_status *status);




#endif // PROGRAM_STATUS_H_INCLUDED
