def print2d(x):
    print("\n".join([str(xx) for xx in x]))

a = [sum(
    [[b in x[0] for b in x[1]] for x in [
        [[int(y) for y in x.strip().split(" ") if len(y) != 0] for x in l.split(':')[1].split("|")]
    ]][0]
) for l in open("resources/2023/day4.txt").readlines()]

# print(a)

b = [
    [d[x] for x in range(20) for d in [a]]
]


e = [2, 1, 1, 0, 0]

# [1, 2, 4, 5, 1]

# [0, 1, 1, 0, 0]
# [0, 0, 1, 0, 0]
# [0, 0, 0, 1, 0]
# [0, 0, 0, 0, 0]
# [0, 0, 0, 0, 0]

p = [[1 if x > c and x < c + 1 + i  else 0 for x in range(5)] for c, i in enumerate(e)]

print2d(p)
print(p)

print([
    [sum([p[x][y] for x in range(5)]) for y in range(5)]
])