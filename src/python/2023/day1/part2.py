
print(
    sum(
        [a[0]*10 + a[-1] for a in 
            [
                [int(b) for b in c.replace("eight", "e8t").replace("two", "2o").replace("one", "1").replace("five", "5").replace("seven", "7n")
                                  .replace("nine", "9").replace("six", '6').replace("four", "4").replace("three", "3") if b.isnumeric()
                ] for c in open('resources/2023/day1.txt').read().split("\n")[:-1]
            ]
        ]
    )
)

 # sum([a[0]*10 + a[-1] for a in [[int(b) for b in c.replace("eight", "e8t").replace("two", "2o").replace("one", "1").replace("five", "5").replace("seven", "7n").replace("nine", "9").replace("six", '6').replace("four", "4").replace("three", "3") if b.isnumeric()] for c in open('resources/2023/day1.txt').read().split("\n")[:-1]]])