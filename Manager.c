#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "Manager.h"
#include "Stack.h"

struct manager
{
    int addresspointer;
    Stack jump_labels[NUM_JMPABLES];
    int curr_label[NUM_JMPABLES];
};

Manager create_manager(const int stack_cap)
{
    int i = 0;
    Manager s=malloc(sizeof *s);
    if(s) {
      do
      {
        s->jump_labels[i] = create_stack(sizeof(int),stack_cap);
        s->curr_label[i] = 0;
        i++;
      }
      while (i<NUM_JMPABLES && s->jump_labels[i-1]);
      if(s->jump_labels[NUM_JMPABLES-1])
      {
        s->addresspointer = 0;
      }
      else
      {
        for(i--;i>=0;i--)
        {
          free(s->jump_labels[i]);
        }
        free(s);
        s=NULL;
      }
    }
    return s;
}

void push_label(Manager m,const Jumpable j)
{
  push(m->jump_labels[j],&m->curr_label[j]);
  m->curr_label[j]++;
}

void pop_label(Manager m,const Jumpable j)
{
  pop(m->jump_labels[j]);
}

int top_label(Manager m,const Jumpable j)
{
  return *((int *)top(m->jump_labels[j]));
}


int new_int ( Manager m)
{
    return m->addresspointer++;
}

int new_array ( Manager m,const int size)
{
    int res = m->addresspointer;
    m->addresspointer += size;
    return res;
}

int new_matrix ( Manager m,const int sizex,const int sizey)
{
    int res = m->addresspointer;
    m->addresspointer += sizex*sizey;
    return res;
}
