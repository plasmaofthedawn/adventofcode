#include <stdio.h>

struct lockkey {

    int positions[5];

};


int main() {




    size_t buffer_size = 100;
    char* line_buf = NULL;

    struct lockkey locks[1000];
    struct lockkey keys[1000];

    int num_locks, num_keys;

    int is_key;

    while (getline(&line_buf, &buffer_size, stdin) > 0) {

        struct lockkey *current;

        if (line_buf[0] == '.') {
            current = &keys[num_keys];
            num_keys++;
            printf("Read key: ");
        } else {
            current = &locks[num_locks];
            num_locks++;
            printf("Read lock: ");
        }

        for (int i = 0; i < 5; i++) {

            current->positions[i] = 0;

        }

        for (int i = 0; i < 5; i++) {
            getline(&line_buf, &buffer_size, stdin);
            for (int j = 0; j < 5; j++) {
                if (line_buf[j] == '#') {
                    current->positions[j]++;
                }
            }
        }


        printf("%d,%d,%d,%d,%d\n", current->positions[0], current->positions[1], current->positions[2], current->positions[3], current->positions[4]);

        getline(&line_buf, &buffer_size, stdin);
        getline(&line_buf, &buffer_size, stdin);
    }

    long out = 0;
    for (int i = 0; i < num_locks; i++) {
        for (int j = 0; j < num_keys; j++) {

            int ok = 1;
            for (int k = 0; k < 5; k++) {

                if (locks[i].positions[k] + keys[j].positions[k] > 5) {
                    ok = 0;
                    break;
                }

            }

            if (ok) {
                out++;
            }
        }
    }

    printf("res: %ld\n", out);

}
