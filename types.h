#ifndef TYPES_H_INCLUDED
#define TYPES_H_INCLUDED

//X macro pattern
//The values are defined via a map which calls a given macro which is defined later
#define JMP_ENUM_MAP(JMPABLE) \
      JMPABLE(If)    \
      JMPABLE(Else)   \
      JMPABLE(While) \
      JMPABLE(DoWhile) \

//Using the map for the enum decl
#define JMPABLE(n) n,
typedef enum jmp {
    JMP_ENUM_MAP(JMPABLE)
} Jumpable;
#undef JMPABLE

//For the count of values
#define JMPABLE(n) + 1
#define NUM_JMPABLES  0 + JMP_ENUM_MAP(JMPABLE)

typedef enum typ
{
    intVar,
    Array,
    Array2D,
    Error
}Type;

#endif // TYPES_H_INCLUDED
