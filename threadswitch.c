#include <stdio.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/types.h>

int main()
{
    int f1[2], f2[2];
    int n = 1000000;
    pipe(f1);
    pipe(f2);
    pid_t childPid = fork();
    if (childPid == 0) {
        int i;
        for (i = 0; i < n; i++) {
            read(f1[0], &i, sizeof(i));
            write(f2[1], &i, sizeof(i));
        }
    } else {
        struct timeval tval_before, tval_after, tval_result;
        gettimeofday(&tval_before, NULL);
        int i;
        for (i = 0; i < n; i++) {
            write(f1[1], &i, sizeof(i));
            read(f2[0], &i, sizeof(i));
        }
        gettimeofday(&tval_after, NULL);

        timersub(&tval_after, &tval_before, &tval_result);

        printf("Time elapsed: %ld.%06ld\n", (long int)tval_result.tv_sec, (long int)tval_result.tv_usec);
    }
    return 0;
}
