#ifndef MANAGER_H_INCLUDED
#define MANAGER_H_INCLUDED
#define JUMP_LABELS_MAX 65534


/* program_status.c */
typedef struct manager *Manager;

Manager create_manager(const int stack_cap);
int new_int ( Manager status);
int new_array ( Manager status, int size);
int new_matrix ( Manager status, int sizex, int sizey);




#endif // PROGRAM_STATUS_H_INCLUDED
