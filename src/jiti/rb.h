/*
 * rb.h
 *
 * red black binary tree herader
 *
 * MIT License (see: LICENSE)
 * copyright (c) 2022 tomaz stih
 *
 * 21.12.2022   tstih
 *
 */
#ifndef __RB_H__
#define __RB_H__

#include <stdint.h>

typedef enum rb_color_e {
  RED,
  BLACK
} rb_color_t;

typedef struct rb_node_s {
  uint16_t start;
  uint16_t end;
  uint16_t data;
  rb_color_t color;
  struct rb_node_s *link[2];
} rb_node_t;

#define RB_SUCCESS          0
#define RB_E_DUPLICATE      -1  /* you're trying to insert a duplicate*/
#define RB_E_NOTREE         -2  /* there is no tree to delete from */

extern int rb_insert_node(uint16_t start, uint16_t end, uint16_t data);
extern int rb_delete_node(uint16_t start);

#endif /* __RB_H__ */