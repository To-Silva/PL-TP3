#ifndef HASH_TABLE_H_INCLUDED
#define HASH_TABLE_H_INCLUDED
#include "entry.h"
/* simple_hashtable.c */

typedef struct item *HashTable;
void add_key(HashTable *hashtable,const char *key,const Entry *entry);
Entry *find_key(const HashTable hashtable,const char *key);
void delete_key(HashTable *hashtable,const char *key);
void delete_all(HashTable *hashtable);
int total_items(const HashTable hashtable);



#endif // HASH_TABLE_H_INCLUDED
