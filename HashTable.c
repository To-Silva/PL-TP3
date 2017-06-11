 #include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "uthash.h"
#include "HashTable.h"

typedef struct item {
    char *key;
    Entry value;
    UT_hash_handle hh;
} Item;




int add_key (HashTable *hashtable,const char *key,const Entry entry )
{
    int success=0;
    Item *s;
    HASH_FIND_STR ( *hashtable, key, s );

    if ( s==NULL ) {
        s = malloc (sizeof *s) ;
        s->key = strdup ( key );
        s->value = entry;
        HASH_ADD_KEYPTR ( hh,  *hashtable, s->key, strlen ( s->key ), s );
        success=-1;
    }
    return success;
}

Entry find_key (const HashTable hashtable,const char *key )
{
    ITEM *s;
    HASH_FIND_STR ( hashtable, key, s );
    return ( s?s->value: NULL );
}

void delete_key (HashTable *hashtable,const char *key )
{
    ITEM *s;
    HASH_FIND_STR ( *hashtable, key, s );
    if (s)
    {
      HASH_DEL ( *hashtable, s );
      free ( s->value );
      free ( s->key );
      free ( key );
    }
}

void delete_all(HashTable *hashtable)
{
    ITEM *item1, *tmp1;
    HASH_ITER ( hh, *hashtable, item1, tmp1 ) {
        HASH_DEL ( *hashtable, item1 );
        free ( item1->value );
        free ( item1->key );
        free ( item1 );
    }
}



int total_items(const HashTable hashtable)
{
    unsigned int num_items;
    num_items = HASH_COUNT ( hashtable );
    return num_items;
}
