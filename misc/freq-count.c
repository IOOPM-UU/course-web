#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#define Delimiters "+-#@()[]{}.,:;!? \t\n\r"

/// Fixme: remove when hash_table.h is included
typedef void hash_table_t;

static int cmpstringp(const void *p1, const void *p2)
{
  return strcmp(* (char * const *) p1, * (char * const *) p2);
}

void sort_keys(char *keys[], size_t no_keys)
{
  qsort(keys, no_keys, sizeof(char *), cmpstringp);
}

void process_word(char *word, hash_table_t *ht)
{
  printf("%s\n", word);
}

void process_file(char *filename, hash_table_t *ht)
{
  FILE *f = fopen(filename, "r");

  while (true) 
    {
      char *buf = NULL;
      size_t len = 0;
      getline(&buf, &len, f);

      if (feof(f))
        {
          free(buf);
          break;
        }
      
      for (char *word = strtok(buf, Delimiters);
           word && *word;
           word = strtok(NULL, Delimiters)
           )
        {
          process_word(word, ht);
        }

      free(buf);
    }
  
  fclose(f);
}

int main(int argc, char *argv[])
{
  hash_table_t *ht = NULL; /// FIXME: initialise with your hash_table
  
  if (argc > 1)
    {
      for (int i = 1; i < argc; ++i)
        {
          process_file(argv[i], ht);
        }

      /// FIXME: obtain an array of keys to sort them
      char *keys[] = { "Bb", "Dd", "Aa", "Cc", "Hh", "Ff", "Gg" };
      sort_keys(keys, 7);
      for (int i = 0; i < 7; ++i) puts(keys[i]);
    }
  else
    {
      puts("Usage: freq-count file1 ... filen");
    }
}
