/*
 * rb.h
 *
 * red black binary tree
 *
 * MIT License (see: LICENSE)
 * copyright (c) 2022 tomaz stih
 *
 * 21.12.2022   tstih
 *
 */
#include <stdlib.h>

#include <jiti/rb.h>

/* tree root node */
rb_node_t *rb_root = NULL;

/* create new node, used internally by other functions */
rb_node_t *_rb_create_node(uint16_t start, uint16_t end, uint16_t data)
{
    rb_node_t *node;
    node = (rb_node_t *)malloc(sizeof(rb_node_t));
    node->start = start;
    node->end = end;
    node->data = data;
    node->color = RED;
    node->link[0] = node->link[1] = NULL;
    return node;
}

/* insert node */
int rb_insert_node(uint16_t start, uint16_t end, uint16_t data)
{
    rb_node_t *stack[98], *ptr, *node, *px, *py;
    int dir[98], ht = 0, index = 0;

    if (!rb_root)
    {
        rb_root = _rb_create_node(start, end, data);
        return RB_SUCCESS;
    }

    stack[ht] = ptr = rb_root;
    dir[ht++] = 0;
    while (ptr != NULL)
    {
        if (ptr->start == start)
            return RB_E_DUPLICATE;
        index = (start - ptr->start) > 0 ? 1 : 0;
        stack[ht] = ptr;
        ptr = ptr->link[index];
        dir[ht++] = index;
    }
    stack[ht - 1]->link[index] = node = _rb_create_node(start, end, data);
    while ((ht >= 3) && (stack[ht - 1]->color == RED))
    {
        if (dir[ht - 2] == 0)
        {
            py = stack[ht - 2]->link[1];
            if (py != NULL && py->color == RED)
            {
                stack[ht - 2]->color = RED;
                stack[ht - 1]->color = py->color = BLACK;
                ht = ht - 2;
            }
            else
            {
                if (dir[ht - 1] == 0)
                {
                    py = stack[ht - 1];
                }
                else
                {
                    px = stack[ht - 1];
                    py = px->link[1];
                    px->link[1] = py->link[0];
                    py->link[0] = px;
                    stack[ht - 2]->link[0] = py;
                }
                px = stack[ht - 2];
                px->color = RED;
                py->color = BLACK;
                px->link[0] = py->link[1];
                py->link[1] = px;
                if (px == rb_root)
                {
                    rb_root = py;
                }
                else
                {
                    stack[ht - 3]->link[dir[ht - 3]] = py;
                }
                break;
            }
        }
        else
        {
            py = stack[ht - 2]->link[0];
            if ((py != NULL) && (py->color == RED))
            {
                stack[ht - 2]->color = RED;
                stack[ht - 1]->color = py->color = BLACK;
                ht = ht - 2;
            }
            else
            {
                if (dir[ht - 1] == 1)
                {
                    py = stack[ht - 1];
                }
                else
                {
                    px = stack[ht - 1];
                    py = px->link[0];
                    px->link[0] = py->link[1];
                    py->link[1] = px;
                    stack[ht - 2]->link[1] = py;
                }
                px = stack[ht - 2];
                py->color = BLACK;
                px->color = RED;
                px->link[1] = py->link[0];
                py->link[0] = px;
                if (px == rb_root)
                {
                    rb_root = py;
                }
                else
                {
                    stack[ht - 3]->link[dir[ht - 3]] = py;
                }
                break;
            }
        }
    }
    rb_root->color = BLACK;
    return RB_SUCCESS;
}

/* delete a node, no need for the end address! */
int rb_delete_node(uint16_t start)
{
    rb_node_t *stack[98], *ptr, *px, *py;
    rb_node_t *pp, *qp, *rp;
    int dir[98], ht = 0, diff, i;
    rb_color_t color;

    if (!rb_root)
    {
        return RB_E_NOTREE;
    }

    ptr = rb_root;
    while (ptr != NULL)
    {
        if ((start - ptr->start) == 0)
            break;
        diff = (start - ptr->start) > 0 ? 1 : 0;
        stack[ht] = ptr;
        dir[ht++] = diff;
        ptr = ptr->link[diff];
    }

    if (ptr->link[1] == NULL)
    {
        if ((ptr == rb_root) && (ptr->link[0] == NULL))
        {
            free(ptr);
            rb_root = NULL;
        }
        else if (ptr == rb_root)
        {
            rb_root = ptr->link[0];
            free(ptr);
        }
        else
        {
            stack[ht - 1]->link[dir[ht - 1]] = ptr->link[0];
        }
    }
    else
    {
        px = ptr->link[1];
        if (px->link[0] == NULL)
        {
            px->link[0] = ptr->link[0];
            color = px->color;
            px->color = ptr->color;
            ptr->color = color;

            if (ptr == rb_root)
            {
                rb_root = px;
            }
            else
            {
                stack[ht - 1]->link[dir[ht - 1]] = px;
            }

            dir[ht] = 1;
            stack[ht++] = px;
        }
        else
        {
            i = ht++;
            while (1)
            {
                dir[ht] = 0;
                stack[ht++] = px;
                py = px->link[0];
                if (!py->link[0])
                    break;
                px = py;
            }

            dir[i] = 1;
            stack[i] = py;
            if (i > 0)
                stack[i - 1]->link[dir[i - 1]] = py;

            py->link[0] = ptr->link[0];

            px->link[0] = py->link[1];
            py->link[1] = ptr->link[1];

            if (ptr == rb_root)
            {
                rb_root = py;
            }

            color = py->color;
            py->color = ptr->color;
            ptr->color = color;
        }
    }

    if (ht < 1)
        return RB_SUCCESS;

    if (ptr->color == BLACK)
    {
        while (1)
        {
            pp = stack[ht - 1]->link[dir[ht - 1]];
            if (pp && pp->color == RED)
            {
                pp->color = BLACK;
                break;
            }

            if (ht < 2)
                break;

            if (dir[ht - 2] == 0)
            {
                rp = stack[ht - 1]->link[1];

                if (!rp)
                    break;

                if (rp->color == RED)
                {
                    stack[ht - 1]->color = RED;
                    rp->color = BLACK;
                    stack[ht - 1]->link[1] = rp->link[0];
                    rp->link[0] = stack[ht - 1];

                    if (stack[ht - 1] == rb_root)
                    {
                        rb_root = rp;
                    }
                    else
                    {
                        stack[ht - 2]->link[dir[ht - 2]] = rp;
                    }
                    dir[ht] = 0;
                    stack[ht] = stack[ht - 1];
                    stack[ht - 1] = rp;
                    ht++;

                    rp = stack[ht - 1]->link[1];
                }

                if ((!rp->link[0] || rp->link[0]->color == BLACK) &&
                    (!rp->link[1] || rp->link[1]->color == BLACK))
                {
                    rp->color = RED;
                }
                else
                {
                    if (!rp->link[1] || rp->link[1]->color == BLACK)
                    {
                        qp = rp->link[0];
                        rp->color = RED;
                        qp->color = BLACK;
                        rp->link[0] = qp->link[1];
                        qp->link[1] = rp;
                        rp = stack[ht - 1]->link[1] = qp;
                    }
                    rp->color = stack[ht - 1]->color;
                    stack[ht - 1]->color = BLACK;
                    rp->link[1]->color = BLACK;
                    stack[ht - 1]->link[1] = rp->link[0];
                    rp->link[0] = stack[ht - 1];
                    if (stack[ht - 1] == rb_root)
                    {
                        rb_root = rp;
                    }
                    else
                    {
                        stack[ht - 2]->link[dir[ht - 2]] = rp;
                    }
                    break;
                }
            }
            else
            {
                rp = stack[ht - 1]->link[0];
                if (!rp)
                    break;

                if (rp->color == RED)
                {
                    stack[ht - 1]->color = RED;
                    rp->color = BLACK;
                    stack[ht - 1]->link[0] = rp->link[1];
                    rp->link[1] = stack[ht - 1];

                    if (stack[ht - 1] == rb_root)
                    {
                        rb_root = rp;
                    }
                    else
                    {
                        stack[ht - 2]->link[dir[ht - 2]] = rp;
                    }
                    dir[ht] = 1;
                    stack[ht] = stack[ht - 1];
                    stack[ht - 1] = rp;
                    ht++;

                    rp = stack[ht - 1]->link[0];
                }
                if ((!rp->link[0] || rp->link[0]->color == BLACK) &&
                    (!rp->link[1] || rp->link[1]->color == BLACK))
                {
                    rp->color = RED;
                }
                else
                {
                    if (!rp->link[0] || rp->link[0]->color == BLACK)
                    {
                        qp = rp->link[1];
                        rp->color = RED;
                        qp->color = BLACK;
                        rp->link[1] = qp->link[0];
                        qp->link[0] = rp;
                        rp = stack[ht - 1]->link[0] = qp;
                    }
                    rp->color = stack[ht - 1]->color;
                    stack[ht - 1]->color = BLACK;
                    rp->link[0]->color = BLACK;
                    stack[ht - 1]->link[0] = rp->link[1];
                    rp->link[1] = stack[ht - 1];
                    if (stack[ht - 1] == rb_root)
                    {
                        rb_root = rp;
                    }
                    else
                    {
                        stack[ht - 2]->link[dir[ht - 2]] = rp;
                    }
                    break;
                }
            }
            ht--;
        }
    }
    return RB_SUCCESS;
}