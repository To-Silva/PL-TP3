#include <stdlib.h>
#include "Entry.h"


struct entry {
    Type type;
    int address;
    int sizex;
    int sizey;
};

Entry create_entry(void);

Entry create_entry()
{
    Entry var = malloc ( sizeof *var );
    return var;
}

Type get_type (const Entry var )
{
    if ( var )
        return var->type;

    return Error;
}

int get_address (const Entry var )
{
    if ( var )
        return var->address;

    return -1;
}

int get_sizex (const Entry var )
{
    if ( var )
        return var->sizex;

    else return -1;
}
int get_sizexy (const Entry var )
{
    if ( var )
        return var->sizex * var->sizey;

    else return -1;
}


void delete_entry ( Entry t )
{
    if ( t ) {
        free ( t );
        t=NULL;
    }
}


Entry new_entry_variable (const int address,const Type type )
{
    Entry var = create_entry();

    if ( var )
    {
      var->type=type;
      var->address=address;
    }

    return var;
}

Entry new_entry_array (const int address,const Type type,const int size)
{
  Entry var = create_entry();

  if ( var )
  {
    var->type=type;
    var->address=address;
    var->sizex=size;
  }
    return var;
}

Entry new_entry_array2D (const int address,const Type type,const int sizex,const int sizey)
{
  Entry var = create_entry();

  if ( var )
  {
    var->type=type;
    var->address=address;
    var->sizex=sizex;
    var->sizey=sizey;
  }
    return var;
}
