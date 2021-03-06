/** monotonic_clock/src/monotonic_clock.c
 *
 *  By Thomas Habets <thomas@habets.pp.se> 2010
 *
 * get monotonic clock with clock_gettime(CLOCK_MONOTONIC,)
 */
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include<time.h>
#include<stdio.h>
#include<errno.h>
#include<string.h>
#include<sys/time.h>

#include"monotonic_clock.h"

const char* monotonic_clock_name      = "clock_gettime";

/**
 * return 1 if clock is actually monotonic, otherwise return 0
 */
int
monotonic_clock_is_monotonic()
{
        struct timespec ts;

        if (clock_gettime(CLOCK_MONOTONIC, &ts)) {
                return 0;
        }
        return 1;
}

/**
 *
 */
double
clock_get_dbl()
{
        struct timespec ts;

        /* try clock_gettime() */
        if (0 == clock_gettime(CLOCK_MONOTONIC, &ts)) {
                return ts.tv_sec + ts.tv_nsec / 1000000000.0;
        }

        if (/* DEBUG */ 0) {
                fprintf(stderr,
                        "clock_gettime(CLOCK_MONOTONIC,): %s\n",
                        strerror(errno));
        }

        return clock_get_dbl_fallback();
}

/* ---- Emacs Variables ----
 * Local Variables:
 * c-basic-offset: 8
 * indent-tabs-mode: nil
 * End:
 */
