#include "Stack.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct stack {
    void *data;
    int size;
    size_t elem_size;
    size_t stack_max;
};



Stack create_stack(const size_t elem_size,const int stack_max_cap)
{
    Stack s = malloc (sizeof *s);
    if (s)
    {
      s->elem_size=elem_size;
      s->size = 0;
      s->stack_max=stack_max_cap;
      s->data = malloc( s->elem_size*s->stack_max);
      if(!s->data)
      {
        free(s);
        s=NULL;
      }
    }
    return s;
}

void *top(const Stack s)
{
    if (s->size == 0) {
        fprintf(stderr, "Error: stack empty\n");
        return NULL;
    }

    return s->data+((s->size-1)*s->elem_size);
}

void push(Stack s, void *elem)
{
    if (s->size < s->stack_max)
    {
      memcpy(s->data+(s->size*s->elem_size),elem,s->elem_size);
      s->size++;
    }
    else
        fprintf(stderr, "Error: stack full\n");
}

void pop(const Stack s)
{
    if (s->size == 0)
        fprintf(stderr, "Error: stack empty\n");
    else
        s->size--;
}
