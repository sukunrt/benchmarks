#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <fcntl.h>

#include "ntime.h"


#define BLOCK_SIZE 4*1000

char buf[BLOCK_SIZE];

void fill_buff() {
    int i;
    for (i = 0; i < BLOCK_SIZE; i++) {
        buf[i] = 'A' + i % 26;
    }
}

int main() {
    fill_buff();
    srand(time(NULL));
    char c[] = "disk_test.out";
    int f = open(c, O_CREAT | O_WRONLY | O_APPEND);
    int iters = 1000;
    int N = iters * BLOCK_SIZE;

    int i;
    for (i = 0; i < iters; i++) {
        write(f, buf, BLOCK_SIZE);
    }
    fdatasync(f);
    long long t = 0;
    uint64_t sst = get_time_in_nsecs();
    for (i = 0; i < iters; i++) {
        int r = rand() % (N - BLOCK_SIZE);
        uint64_t st = get_time_in_nsecs();
        lseek(f, (long)r, SEEK_SET);
        write(f, buf, BLOCK_SIZE);
        fdatasync(f);
        uint64_t ed = get_time_in_nsecs();
        t += (long long)(ed - st);
    }
    uint64_t ed = get_time_in_nsecs();
    printf("Time per write %lld msecs\n", t / ((long long)iters * (long long)1000000));
    printf("Total write time %lld msecs\n", (long long)(ed-sst) / (long long) 1000000);
}

