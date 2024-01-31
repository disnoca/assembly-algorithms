#ifndef DYNAMIC_ARRAY
#define DYNAMIC_ARRAY

/* ---------------- Structs ---------------- */

typedef struct {
	int* arr;
	int size, capacity;
} DynamicArray;

/* ---------------- Functions ---------------- */

DynamicArray* da_create(int capacity);

void da_add(DynamicArray* da, int data);

void da_add_at(DynamicArray* da, int data, int pos);

int da_remove_last(DynamicArray* da);

int da_remove_at(DynamicArray* da, int pos);

bool da_remove(DynamicArray* da, int data);

int da_get(DynamicArray* da, int pos);

int da_set(DynamicArray* da, int data, int pos);

int da_index_of(DynamicArray* da, int data);

bool da_contains(DynamicArray* da, int data);

void da_clear(DynamicArray* da);

void da_destroy(DynamicArray* da);

#endif
