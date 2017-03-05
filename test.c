/* 
 * File:   test.c
 * Author: kritpal
 
 * Created on 11 April, 2016, 12:05 PM
 */
#include "libDBM.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/time.h>

#define DBNAME   "book"

int main(int argc, char **argv) {
    
    char name[500][50];        //name is the key for database element

    //data structure element
    struct data {
        char number[50];
        char address[50];
        int i;
        float j;
    } rec[500], *val;

    char *key;
    DEPOT *depot;
    int i;

    struct timeval tv1, tv2;

    srand(time(NULL));

    //    while (1) {

    gettimeofday(&tv1, NULL);

    //opening database
    if (!(depot = dpopen(DBNAME, DP_OWRITER | DP_OCREAT | DP_OSPARSE, 1))) {
        fprintf(stderr, "dpopen: %s\n", dperrmsg(dpecode));
        return 1;
    }

    for (i = 0; i < 1000; i++) {
        /* store the record */
        sprintf(name[i], "record %d", i);
        sprintf(rec[i].number, "number %d %d", rand(), i);
        sprintf(rec[i].address, "address %d", i);
        rec[i].i = i;
        rec[i].j = i + 0.5;

        //adding elements to database DP_OVER replaces the rexisting element with new if key is same
        if (!dpput(depot, name[i], -1, (char*) &rec[i], sizeof (struct data), DP_DOVER)) {
            fprintf(stderr, "dpput: %s\n", dperrmsg(dpecode));
        }
        //        printf("%s %s %s %d %f\n", name[i], rec[i].number, rec[i].address, rec[i].i, rec[i].j);
    }

    //iterating whole database
    if (!dpiterinit(depot)) {
        fprintf(stderr, "dpiterinit: %s\n", dperrmsg(dpecode));
    }  
    while ((key = dpiternext(depot, NULL)) != NULL) {
        if (!(val = (struct data*) dpget(depot, key, -1, 0, sizeof (struct data), NULL))) {
            fprintf(stderr, "dpget: %s\n", dperrmsg(dpecode));
            free(key);
            break;
        }
        printf("%s %s %s %d %f\n", key, val->number, val->address, val->i, val->j, key);
        free(val);
        free(key);
    }
    
    //getting element from database
    if (!(val = (struct data*) dpget(depot, name[900], -1, 0, sizeof (struct data), NULL))) {
        fprintf(stderr, "dpget: %s\n", dperrmsg(dpecode));
    }
    printf("%s %s %s %d %f out of %d\n", name[900], val->number, val->address, val->i, val->j, dprnum(depot));
    free(val);


    //closing database
    if (!dpclose(depot)) {
        fprintf(stderr, "dpclose: %s\n", dperrmsg(dpecode));
        return 1;
    }

    gettimeofday(&tv2, NULL);

    //        sleep(2);
    //    }

    printf("Total time = %f seconds\n", (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 + (double) (tv2.tv_sec - tv1.tv_sec));

    return 0;
}

