#include <stdio.h>
#include <string.h>

#define BOARD_SIZE 71
#define NUM_BYTES 1024

#define WALL 10005

#define IN_BOUND(x, y) (x < BOARD_SIZE && x >= 0 && y < BOARD_SIZE && y >= 0)
#define MIN(a,b) (((a)<(b))?(a):(b))

struct coordinate {

    int x, y;

};


struct coordinate queue[10000];
int queue_len;
int queue_start;

char map[BOARD_SIZE][BOARD_SIZE];
int values[BOARD_SIZE][BOARD_SIZE];


int queue_pop(struct coordinate *coord) {

    if (queue_len == 0) {
        return -1;
    }

    memcpy(coord, &queue[queue_start], sizeof(struct coordinate));

    queue_start++;
    queue_len--;

    return 0;

}


void queue_push(struct coordinate *coord) {

    
    //printf("%d, %da\n", coord->x, coord->y);

    memcpy(&queue[queue_start + queue_len], coord, sizeof(struct coordinate));
    queue_len++;

}


void check_and_push(struct coordinate *coord, int depth) {

    //printf("%d\n", depth);

    if (!IN_BOUND(coord->x, coord->y) || values[coord->x][coord->y] == WALL) {
        return;
    }

    if (values[coord->x][coord->y] == 100000) {
        //printf("%d\n", depth);
        values[coord->x][coord->y] = depth + 1;
        queue_push(coord);

    }


}

int dfs(struct coordinate coord) {

    queue_push(&coord);
    values[coord.x][coord.y] = 0;

    while (!queue_pop(&coord)) {

        int value = values[coord.x][coord.y];

        //printf("%d, %d: %d\n", coord.x, coord.y, values[coord.x][coord.y]);

        if (coord.x == BOARD_SIZE - 1 && coord.y == BOARD_SIZE - 1) {
            break;
        }

        coord.x++;
        check_and_push(&coord, value);
        coord.x -= 2;
        check_and_push(&coord, value);
        coord.x++;

        coord.y++;
        check_and_push(&coord, value);
        coord.y -= 2;
        check_and_push(&coord, value);
        coord.y++;


    }

    return values[BOARD_SIZE - 1][BOARD_SIZE - 1];
}



int main() {

    char *line_buf = NULL;
    size_t buffer_size = 100;

    for (int i = 0; i < BOARD_SIZE; i++) {
        for (int j = 0; j < BOARD_SIZE; j++) {
            map[i][j] = '.';
            values[i][j] = 100000;
        }
    }

    struct coordinate coords[10000];
    int num_cords = 0;

    while (getline(&line_buf, &buffer_size, stdin) > 0) {    

        sscanf(line_buf, "%d,%d\n", &coords[num_cords].x, &coords[num_cords].y);
        num_cords++;

    }

    for (int i = 0; i < NUM_BYTES; i++) {

        struct coordinate coord = coords[i];

        values[coords[i].x][coords[i].y] = WALL;

        //printf("%d, %dwa\n", coords[i].x, coords[i].y);
        //values[coord.x][coord.y] = 10000;

    }
    
    struct coordinate start;

    start.x = 0;
    start.y = 0;

    printf("res: %d\n", dfs(start));
}
