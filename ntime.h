#include<time.h>
#include<stdlib.h>
#include<stdint.h>


uint64_t get_time_in_nsecs() {
        struct timespec tp;
        clock_gettime(CLOCK_REALTIME, &tp);
        uint64_t nsecs = (uint64_t) tp.tv_sec * 1000000000 + (uint64_t) tp.tv_nsec;
        return nsecs;
}
