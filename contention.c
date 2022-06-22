#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <unistd.h>

#include "ntime.h"
#include "utils.h"

#define N 200
#define LOOP_NUM 20000000

int thread_timings[N];

pthread_barrier_t barrier;

void loopFunc() {
        int x = 0;
        int i;
        for (i = 0; i < LOOP_NUM; i++) {
                x++;
        }
        return;
}

void* threadLoopFunc(void* args) {
        pthread_barrier_wait(&barrier);
        uint64_t st = get_time_in_nsecs();
        loopFunc();
        uint64_t ed = get_time_in_nsecs();
        int el = (int) ((ed-st) / (uint64_t) 1000000);
        *(int *)args = el;
        return NULL;
}

int main() {
        int j;
        for (j = 0; j < 5; j++) loopFunc();
        uint64_t st = get_time_in_nsecs();
        loopFunc();
        uint64_t ed = get_time_in_nsecs();
        int el = (int)(ed-st) / 1000000;
        printf("Took %d msecs with only 1 thread running\n", el);

        pthread_barrier_init(&barrier, N);
        pthread_t threads[N];
        int i;
        for (i = 0; i < N; i++) {
                pthread_create(&threads[i], NULL, threadLoopFunc, &thread_timings[i]);
        }
        for (i = 0; i < N; i++) {
                pthread_join(threads[i], NULL);
        }
        int total_msecs = 0;
        for (i = 0; i < N; i++) {
                total_msecs += thread_timings[i];
        }
        printf("Took %d msecs with %d threads", total_msecs / N, N);
        return 0;
}

