#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int numeric_id(char* string) {

    return string[0] * 65536 + string[1] * 256 + string[2];

}

int number(char* string) {

    return (string[1] - 48) * 10 + string[2] - 48;
    
}


int number_from_id(int id) {

    return ((id / 256 % 256) - 48) * 10 + (id % 256 - 48);

}

int operator_to_id(char* str){

    if (strcmp(str, "AND") == 0) { 
        return 1;
    } else if (strcmp(str, "OR") == 0) {
        return 2;
    } else if (strcmp(str, "XOR") == 0) {
        return 3;
    }

    printf("Bad operator: %s\n", str);
    exit(-1);

}

int zvalue_to_id(int znum) {

    return 'z' * 65536 + (znum / 10 + 48) * 256 + znum % 10 + 48;

}

int apply_operator(int v1, int op, int v2) {

    if (op == 1) {

        return v1 & v2;

    } else if (op == 2) {

        return v1 | v2;

    } else if (op == 3) {
    
        return v1 ^ v2;

    }

    printf("Bad operator id: %d\n", op);
    exit(-1);

}

struct rule {
    int op1;
    int op2;
    int operator;
    int result;
};

struct value {
    int key;
    int value;
};


struct value values[1000];
struct rule rules[1000];

int num_values = 0;
int num_rules = 0; 


int add_value(int key, int value) {

    values[num_values].value = value;
    values[num_values].key = key;

    num_values++;

}

int get_value(int id) {

    for (int i = 0; i < num_values; i++) {
        
        if (values[i].key == id) {
            return values[i].value;
        }
    }

    return -1;

}



int main() {

    int max_z = 0;


    // reading junk
    size_t buffer_size = 100;
    char *line_buf = NULL;
    char buffer[buffer_size];
    char op1[buffer_size];
    char op2[buffer_size];
    char operator[buffer_size];
    char end_goal[buffer_size];

    int value;

    while (getline(&line_buf, &buffer_size, stdin) > 1) {

        sscanf(line_buf, "%3s: %d\n", buffer, &value); 

        add_value(numeric_id(buffer), value);
    } 


    while (getline(&line_buf, &buffer_size, stdin) > 0) {
        sscanf(line_buf, "%3s %3s %3s -> %3s", op1, operator, op2, end_goal);

        if (end_goal[0] == 'z') {
            if (number(end_goal) > max_z) {
                max_z = number(end_goal);
            }
        }

        rules[num_rules].op1 = numeric_id(op1);
        rules[num_rules].op2 = numeric_id(op2);
        rules[num_rules].operator = operator_to_id(operator);
        rules[num_rules].result = numeric_id(end_goal);

        num_rules++;
    }

    int found_zs[max_z];
    max_z++;
    int rule_applied[num_rules];

    for (int i = 0; i < num_rules; i++) {

        rule_applied[i] = 0;

    }

    for (int i = 0; i < max_z; i++) {

        found_zs[i] = 0;

    }

    printf("Read %d values and %d rules, trying to find %d zs\n", num_values, num_rules, max_z);

    for (;;) {

        for (int i = 0; i < num_rules; i++) {  

            int v1, v2;

            if (rule_applied[i]) {
                continue;
            }

            if ((v1 = get_value(rules[i].op1)) >= 0 && (v2 = get_value(rules[i].op2)) >= 0) {

                int res = apply_operator(v1, rules[i].operator, v2);

                //printf("%d: %d\n", rules[i].result, res);
                
                add_value(rules[i].result, res);

                if (rules[i].result / 65536 == 'z') {

                    found_zs[number_from_id(rules[i].result)] = 1;
                    printf("Found z%d\n", number_from_id(rules[i].result)); 
                    //printf("%x", rules[i].result);

                }

                rule_applied[i] = 1;

            }

            //printf("%d, %d\n", v1, v2);

        }

        int finished = 1;
        for (int i = 0; i < max_z; i++) {

            if (found_zs[i] == 0) {

                finished = 0;
                break;

            }

        }

        if (finished) {

            break;

        }
        
    }

    long out = 0;
    for (int i = max_z - 1; i >= 0; i--) {

        out *= 2;
        int n = get_value(zvalue_to_id(i));
        printf("%d", n);
        out += n;

        //printf("%x\n", zvalue_to_id(i));
    }

    printf("\nres: %ld\n", out);
}
