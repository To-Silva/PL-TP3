#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "Manager.h"
#include "Stack.h"

struct manager
{
    int addresspointer;
    Stack jump_labels;
};

Manager create_manager(const int stack_cap)
{
    Manager s=malloc(sizeof *s);
    s->jump_labels = create_stack(sizeof(int),stack_cap);
    s->addresspointer = 0;
    return s;
}






int new_int ( Manager status)
{
    return status->addresspointer++;
}

int new_array ( Manager status, int size)
{
    int res = status->addresspointer;
    status->addresspointer += size;
    return res;
}

int new_matrix ( Manager status, int sizex, int sizey)
{
    int res = status->addresspointer;
    status->addresspointer += sizex*sizey;
    return res;
}
