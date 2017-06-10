#include <stdlib.h>
#include "entry.h"
#include "types.h"


typedef struct entry {
    Class class;
    int address;
    int sizex;
    int sizey;
} ENTRY;


Entry *init_entry()
{
    Entry *var = ( Entry * ) malloc ( sizeof ( struct entry ) );

    if ( var==NULL )
        return NULL;

    var->class=0;
    var->address = -1;
    var->sizex = 0;
    var->sizey = 0;
    return var;
}

Class get_class ( Entry *var )
{
    if ( var )
        return var->id_class;

    return Nothing;
}

int get_address ( Entry *var )
{
    if ( var )
        return var->address;

    return -1;
}

int get_sizex ( Entry *it )
{
    if ( it )
        return it->sizex;

    else return -1;
}
int get_sizey ( Entry *it )
{
    if ( it )
        return it->sizey;

    else return -1;
}

/****************************/
int set_sizex ( Entry *it, int sx )
{
    if ( it==NULL )
        return -1;

    it->sizex = sx;
    return 0;
}
int set_sizey ( Entry *it, int sy )
{
    if ( it==NULL )
        return -1;

    it->sizey = sy;
    return 0;
}

int set_address ( Entry *var, int address )
{
    if ( var == NULL )
        return -1;

    var->address = address;
    return -1;
}


void delete_entry ( Entry *t )
{
    if ( t ) {
        free ( t );
        t=NULL;
    }
}


Entry *new_entry_variable ( int address, Class id_class )
{
    Entry *var = init_entry();

    if ( var==NULL )
        return NULL;

    set_class ( var, id_class );
    set_address ( var, address );
    return var;
}

Entry *new_entry_array ( int address, Class id_class, int size)
{
    Entry *var = init_entry();

    if ( var==NULL )
        return NULL;

    set_class ( var, id_class );
    set_sizex ( var, size );
    set_address ( var, address );
    return var;
}

Entry *new_entry_array2D ( int address, Class id_class, int sizex, int sizey)
{
    Entry *var = init_entry();

    if ( var==NULL )
        return NULL;

    set_class ( var, id_class );
    set_sizex ( var, size );
    set_sizey ( var, nrows );
    set_address ( var, address );
    return var;
}
