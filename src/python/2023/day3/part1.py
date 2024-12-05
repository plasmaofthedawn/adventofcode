print(sum(sum(
    [[m[2] for m in zip(*l) if m[0] and not (m[1] and m[2] == m[3]) and m[2] != -1] for l in
        list(map(lambda x, y: (x, [False] + x, y, [-1] + y),
            [[sum(n) > 0 for n in zip(*m)] for m in zip(
                *list(map(lambda x: [
                        [[False] + q for q in [[False] * len(x[0])] + x], [[False] * len(x[0])] + x, [q[1:] + [False] for q in [[False] * len(x[0])] + x],
                        [[False] + q for q in x], x, [q[1:] + [False] for q in x],
                        [[False] + q for q in x[1:] + [[False] * len(x[0])]],  x[1:] + [[False] * len(x[0])], [q[1:] + [False] for q in x[1:] + [[False] * len(x[0])]]],
                    [[[x not in '0123456789.' for x in l] for l in open("resources/2023/day3.txt").read().split("\n")]] # array of True when a symbol
                ))[0]
            )], # array of True when next to a symbol
            [[max(a) if a[1] != -1 else -1 for a in zip(*b)] for b in zip(
                *list(map(lambda x: [[[-1] + q for q in x], x, [q[1:] + [-1] for q in x]],
                    [[[int("".join(c).strip('.!@#$%^&*()_+-=/')) if c[1] in '0123456789' else -1 for c in zip('.' + l, l, l[1:] + '.')] for l in open("resources/2023/day3.txt").read().split("\n")]]
                ))[0]
            )] # array of -1, or the number.
        ))
    ], []
)))

# sum(sum([[m[2] for m in zip(*l) if m[0] and not (m[1] and m[2] == m[3]) and m[2] != -1] for l in list(map(lambda x, y: (x, [False] + x, y, [-1] + y), [[sum(n) > 0 for n in zip(*m)] for m in zip(*list(map(lambda x: [[[False] + q for q in [[False] * len(x[0])] + x], [[False] * len(x[0])] + x, [q[1:] + [False] for q in [[False] * len(x[0])] + x], [[False] + q for q in x], x, [q[1:] + [False] for q in x], [[False] + q for q in x[1:] + [[False] * len(x[0])]],  x[1:] + [[False] * len(x[0])], [q[1:] + [False] for q in x[1:] + [[False] * len(x[0])]]], [[[x not in '0123456789.' for x in l] for l in open("resources/2023/day3.txt").read().split("\n")]]))[0])], [[max(a) if a[1] != -1 else -1 for a in zip(*b)] for b in zip(*list(map(lambda x: [[[-1] + q for q in x], x, [q[1:] + [-1] for q in x]], [[[int("".join(c).strip('.!@#$%^&*()_+-=/')) if c[1] in '0123456789' else -1 for c in zip('.' + l, l, l[1:] + '.')] for l in open("resources/2023/day3.txt").read().split("\n")]]))[0])]))], []))
