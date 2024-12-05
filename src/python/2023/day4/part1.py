print(
    sum([[0, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512][p] for p in 
        [sum(
            [[b in x[0] for b in x[1]] for x in [
                [[int(y) for y in x.strip().split(" ") if len(y) != 0] for x in l.split(':')[1].split("|")]
            ]][0]
        ) for l in open("resources/2023/day4.txt").readlines()]
    ])
)

# sum([[0, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512][p] for p in [sum([[b in x[0] for b in x[1]] for x in [[[int(y) for y in x.strip().split(" ") if len(y) != 0] for x in l.split(':')[1].split("|")]]][0]) for l in open("resources/2023/day4.txt").readlines()]])