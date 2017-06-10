#ifndef STACK_H_INCLUDED
#define STACK_H_INCLUDED

typedef struct stack *Stack;

Stack create_stack(const size_t elem_size,const int stack_max_cap)
void *top(const Stack s)
void push(Stack s, void *elem)
void pop(const Stack s)

#endif
