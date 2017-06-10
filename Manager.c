#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "Manager.h"


Program_status *init ( Program_status *status )
{
    int i;
    status->addresspointer = 0;
}

int atribute_adress_for_var ( Program_status *status )
{
    int address;

    if ( status==NULL )
        return -1;

    address = status->addresspointer;
    status->addresspointer++;
    return address;
}

int atribute_adress_for_array ( Program_status *status, int size )
{
    int address=0;

    if ( status==NULL )
        return -1;

    address = status->addresspointer;
    status->addresspointer++;
    status->addresspointer+= ( size-1 );
    return address;
}


int check_type ( Type a, Type b )
{
    return a == b;
}




int add_Variable ( Program_status *status, char *key, Type type, Class id_class, Level level )
{
    Entry *entry = NULL;
    int address = -1;

    if ( status==NULL )
        return -1;

    address = atribute_adress_for_var ( status );

    if ( address==-1 )
        return -1;

    entry  = new_entry_variable ( address, type, id_class, level );

    if ( entry==NULL )
        return -1;

    add_key ( key, entry );
    return 0;
}

int add_Array ( Program_status *status, char *key, Type type, Class id_class, int size, Level level )
{
    Entry *entry = NULL;
    int address = -1;

    if ( status==NULL )
        return -1;

    address = atribute_adress_for_array ( status, size );

    if ( address==-1 )
        return -1;

    entry  = new_entry_array ( address, type, id_class, size, level );

    if ( entry==NULL )
        return -1;

    add_key ( key, entry );
    return 0;
}

int add_Array2D ( Program_status *status, char *key,Class id_class, int sizex, int sizey)
{
    Entry *entry = NULL;
    int address = -1;

    if ( status==NULL )
        return -1;

    address = atribute_adress_for_array ( status, sizex );

    if ( address==-1 )
        return -1;

    entry  = new_entry_array2D ( address, id_class,sizex, sizey );

    if ( entry==NULL )
        return -1;

    add_key ( key, entry );
    return 0;
}

Entry *find_identifier ( Program_status *status, char *key )
{
    Entry *entry = NULL;

    if ( status==NULL )
        return NULL;

    entry = find_key ( key );
    return entry;
}

void delete_identifier ( Program_status *status, char *key )
{
    Entry *entry = NULL;

    if ( status==NULL )
        return;

    entry = find_key ( key );

    if ( entry )
        delete_key ( key );
}

void delete_all_identifiers ( Program_status *status )
{
    if ( status==NULL )
        return;

    delete_all();
}

void destroy_status ( Program_status *status )
{
    delete_all_identifiers ( status );
    free ( status );
    status = NULL;
}
