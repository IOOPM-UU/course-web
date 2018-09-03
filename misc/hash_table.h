#pragma once

#include <stdbool.h>
#include <stddef.h>

typedef struct hash_table ioopm_hash_table_t;

typedef int (*ioopm_hash_function)(elem_t);
typedef bool (*ioopm_eq_function)(elem_t, elem_t);
typedef bool (*ioopm_apply_function)(elem_t, void *);

ioopm_hash_table_t *ioopm_hash_table_create(size_t size, ioopm_hash_function hash_fun, ioopm_eq_function key_eq_fun);
void ioopm_hash_table_destroy(ioopm_hash_table_t *h);
elem_t ioopm_hash_table_insert(ioopm_hash_table_t *h, elem_t key, elem_t value);
elem_t ioopm_hash_table_lookup(ioopm_hash_table_t *h, elem_t key);
elem_t ioopm_hash_table_remove(ioopm_hash_table_t *h, elem_t key);
elem_t *ioopm_hash_table_keys(ioopm_hash_table_t *h);
elem_t *ioopm_hash_table_values(ioopm_hash_table_t *h);
void ioopm_hash_table_resize(ioopm_hash_table_t *h, int size);
void ioopm_hash_table_clear(ioopm_hash_table_t *h);
size_t ioopm_hash_table_size(ioopm_hash_table_t *h);
bool ioopm_hash_table_is_empty(ioopm_hash_table_t *h);
bool ioopm_hash_table_has_key(ioopm_hash_table_t *h, elem_t key, ioopm_eq_function key_eq_fun);
bool ioopm_hash_table_has_value(ioopm_hash_table_t *h, elem_t value, ioopm_eq_function value_eq_fun);
bool ioopm_hash_table_all(ioopm_hash_table_t *h, ioopm_apply_function apply_fun, elem_t arg);
bool ioopm_hash_table_any(ioopm_hash_table_t *h, ioopm_apply_function apply_fun, elem_t arg);
void ioopm_hash_table_apply_to_all(ioopm_hash_table_t *h, ioopm_apply_function apply_fun, void *arg);
