print(sum([
    v[0] * v[1] for v in  # sums all asterisks with > 2
    [
        [sum([g[w, a] for a in range(140) if abs(w - a*140) < 280], []) for w in range(140**2)] for g in # coagulate the dictionaries
            [{
                (r*140 + p, r): [m[2] for m in zip(*l) if m[0] and not (m[1] and m[2] == m[3]) and m[2] != -1 and r*140 + p in m[0]]  # find adjacent numbers
                    for p in range(-280, 280) for r, l in enumerate( # from part 1.
                        list(map(lambda x, y: (x, [-1] + x, y, [-1] + y), 
                            [[[l for l in n if l > 0] for n in zip(*m)] for m in zip(
                                *list(map(lambda x: [
                                        [[False] + q for q in [[False] * len(x[0])] + x], [[False] * len(x[0])] + x, [q[1:] + [False] for q in [[False] * len(x[0])] + x],
                                        [[False] + q for q in x], x, [q[1:] + [False] for q in x],
                                        [[False] + q for q in x[1:] + [[False] * len(x[0])]],  x[1:] + [[False] * len(x[0])], [q[1:] + [False] for q in x[1:] + [[False] * len(x[0])]]],
                                    [[[i * 140 + j if b == "*" else -1 for j, b in enumerate(a)] for i, a in enumerate(open("resources/2023/day3.txt").read().split("\n"))]] # array of asterisk ids, or -1
                                ))[0]
                            )], # array of nearby asterissks + id
                            [[max(a) if a[1] != -1 else -1 for a in zip(*b)] for b in zip(
                                *list(map(lambda x: [[[-1] + q for q in x], x, [q[1:] + [-1] for q in x]],
                                    [[[int("".join(c).strip('.!@#$%^&*()_+-=/')) if c[1] in '0123456789' else -1 for c in zip('.' + l, l, l[1:] + '.')] for l in open("resources/2023/day3.txt").read().split("\n")]]
                                ))[0]
                            )] # array of -1, or the number.
                        ))
                    )
            }] 
    ][0] if len(v) >= 2 
]))

# sum([v[0] * v[1] for v in [[sum([g[w, a] for a in range(140) if abs(w - a*140) < 280], []) for w in range(140**2)] for g in [{(r*140 + p, r): [m[2] for m in zip(*l) if m[0] and not (m[1] and m[2] == m[3]) and m[2] != -1 and r*140 + p in m[0]] for p in range(-280, 280) for r, l in enumerate(list(map(lambda x, y: (x, [-1] + x, y, [-1] + y), [[[l for l in n if l > 0] for n in zip(*m)] for m in zip(*list(map(lambda x: [[[False] + q for q in [[False] * len(x[0])] + x], [[False] * len(x[0])] + x, [q[1:] + [False] for q in [[False] * len(x[0])] + x],[[False] + q for q in x], x, [q[1:] + [False] for q in x], [[False] + q for q in x[1:] + [[False] * len(x[0])]],  x[1:] + [[False] * len(x[0])], [q[1:] + [False] for q in x[1:] + [[False] * len(x[0])]]], [[[i * 140 + j if b == "*" else -1 for j, b in enumerate(a)] for i, a in enumerate(open("resources/2023/day3.txt").read().split("\n"))]]))[0])], [[max(a) if a[1] != -1 else -1 for a in zip(*b)] for b in zip(*list(map(lambda x: [[[-1] + q for q in x], x, [q[1:] + [-1] for q in x]], [[[int("".join(c).strip('.!@#$%^&*()_+-=/')) if c[1] in '0123456789' else -1 for c in zip('.' + l, l, l[1:] + '.')] for l in open("resources/2023/day3.txt").read().split("\n")]]))[0])])))}]][0] if len(v) >= 2])
