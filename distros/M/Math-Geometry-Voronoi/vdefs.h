#ifndef __VDEFS_H
#define __VDEFS_H

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef NULL
#define NULL 0
#endif

#define DELETED -2

typedef struct tagFreenode
    {
    struct tagFreenode * nextfree;
    } Freenode ;


typedef struct tagFreelist
    {
    Freenode * head;
    int nodesize;
    } Freelist ;

typedef struct tagPoint
    {
    double x ;
    double y ;
    } Point ;

/* structure used both for sites and for vertices */

typedef struct tagSite
    {
    Point coord ;
    int sitenbr ;
    int refcnt ;
    } Site ;


typedef struct tagEdge
    {
    double a, b, c ;
    Site * ep[2] ;
    Site * reg[2] ;
    int edgenbr ;
    } Edge ;

#define le 0
#define re 1

typedef struct tagHalfedge
    {
    struct tagHalfedge * ELleft ;
    struct tagHalfedge * ELright ;
    Edge * ELedge ;
    int ELrefcnt ;
    char ELpm ;
    Site * vertex ;
    double ystar ;
    struct tagHalfedge * PQnext ;
    } Halfedge ;

/* edgelist.c */
void ELinitialize(void) ;
Halfedge * HEcreate(Edge *, int) ;
void ELinsert(Halfedge *, Halfedge *) ;
Halfedge * ELgethash(int) ;
Halfedge * ELleftbnd(Point *) ;
void ELdelete(Halfedge *) ;
Halfedge * ELright(Halfedge *) ;
Halfedge * ELleft(Halfedge *) ;
Site * leftreg(Halfedge *) ;
Site * rightreg(Halfedge *) ;
extern int ELhashsize ;
extern Site * bottomsite ;
extern Freelist hfl ;
extern Halfedge * ELleftend, * ELrightend, **ELhash ;

/* geometry.c */
void geominit(void) ;
Edge * bisect(Site *, Site *) ;
Site * intersect(Halfedge *, Halfedge *) ;
int right_of(Halfedge *, Point *) ;
void endpoint(Edge *, int, Site *) ;
double dist(Site *, Site *) ;
void makevertex(Site *) ;
void deref(Site *) ;
void ref(Site *) ;
extern double deltax, deltay ;
extern int nsites, nedges, sqrt_nsites, nvertices ;
extern Freelist sfl, efl ;

/* heap.c */
void PQinsert(Halfedge *, Site *, double) ;
void PQdelete(Halfedge *) ;
int PQbucket(Halfedge *) ;
int PQempty(void) ;
Point PQ_min(void) ;
Halfedge * PQextractmin(void) ;
void PQinitialize(void) ;
extern int PQmin, PQcount, PQhashsize ;
extern Halfedge * PQhash ;

/* main.c */
extern int sorted, triangulate, plot, debug, nsites, siteidx ;
extern double xmin, xmax, ymin, ymax ;
extern Site * sites ;
extern Freelist sfl ;
extern AV *lines_out, *edges_out, *vertices_out;
int compute_voronoi(Site *, int, double, double, double, double, int, AV*, AV*, AV*);

/* getopt.c */
extern int getopt(int, char *const *, const char *);

/* memory.c */
void freeinit(Freelist *, int) ;
char *getfree(Freelist *) ;
void makefree(Freenode *, Freelist *) ;
char *myalloc(unsigned) ;
void free_all(void);

/* output.c */
void openpl(void) ;
void line(double, double, double, double) ;
void circle(double, double, double) ;
void range(double, double, double, double) ;
void out_bisector(Edge *) ;
void out_ep(Edge *) ;
void out_vertex(Site *) ;
void out_site(Site *) ;
void out_triple(Site *, Site *, Site *) ;
void plotinit(void) ;
void clip_line(Edge *) ;

/* voronoi.c */
void voronoi(Site *(*)()) ;

#endif  


