print(
    min(
        [
            [
                [
                    max(f) if max(f) != -1 else h
                    for f in [[g(h) for g in m[6]]] # final map
                ][0] for h in [
                    [
                        max(f) if max(f) != -1 else h
                        for f in [[g(h) for g in m[5]]] # sixth map
                    ][0] for h in [
                        [
                            max(f) if max(f) != -1 else h
                            for f in [[g(h) for g in m[4]]] # fifth map
                        ][0] for h in [
                            [
                                max(f) if max(f) != -1 else h
                                for f in [[g(h) for g in m[3]]] # fourth map
                            ][0] for h in [
                                [
                                    max(f) if max(f) != -1 else h
                                    for f in [[g(h) for g in m[2]]] # third map
                                ][0] for h in [
                                    [
                                        max(f) if max(f) != -1 else h
                                        for f in [[g(h) for g in m[1]]] # second map
                                    ][0] for h in [
                                        [
                                            max(f) if max(f) != -1 else h
                                            for f in [[g(h) for g in m[0]]] # first map
                                        ][0] for h in [
                                            int(x) for x in open("resources/2023/day5.txt").readlines()[0].split(":")[1].strip().split(" ") # seeds
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ] for m in [[
                list(map(
                        lambda d: lambda e: e + d[0] - d[1] if e >= d[1] and e < d[1] + d[2] else -1, 
                        [[int(a) for a in b.split(" ")] for b in c.strip().split("\n")[1:]] # bullshit to get maps
                ))
                for c in open("resources/2023/day5.txt").read().split("\n\n")[1:] # maps
            ]]
        ][0]
    )
)

#min([[[max(f) if max(f) != -1 else h for f in [[g(h) for g in m[6]]]][0] for h in [[max(f) if max(f) != -1 else h for f in [[g(h) for g in m[5]]]][0] for h in [[max(f) if max(f) != -1 else h for f in [[g(h) for g in m[4]]]][0] for h in [[max(f) if max(f) != -1 else h for f in [[g(h) for g in m[3]]]][0] for h in [[max(f) if max(f) != -1 else h for f in [[g(h) for g in m[2]]]][0] for h in [[max(f) if max(f) != -1 else h for f in [[g(h) for g in m[1]]]][0] for h in [[max(f) if max(f) != -1 else h for f in [[g(h) for g in m[0]]]][0] for h in [int(x) for x in open("resources/2023/day5.txt").readlines()[0].split(":")[1].strip().split(" ")]]]]]]]] for m in [[list(map(lambda d: lambda e: e + d[0] - d[1] if e >= d[1] and e < d[1] + d[2] else -1, [[int(a) for a in b.split(" ")] for b in c.strip().split("\n")[1:]])) for c in open("resources/2023/day5.txt").read().split("\n\n")[1:]]]][0])

