print(
    sum(
        [
            max([int(x.split(" ")[0]) for x in z.split(": ")[1][:-1].replace(";", ",").split(", ") if 'red' in x]) * 
            max([int(x.split(" ")[0]) for x in z.split(": ")[1][:-1].replace(";", ",").split(", ") if 'green' in x]) *
            max([int(x.split(" ")[0]) for x in z.split(": ")[1][:-1].replace(";", ",").split(", ") if 'blue' in x])
            for z in open('resources/2023/day2.txt').readlines()
        ]
    )
)

# sum([max([int(x.split(" ")[0]) for x in z.split(": ")[1][:-1].replace(";", ",").split(", ") if 'red' in x]) * max([int(x.split(" ")[0]) for x in z.split(": ")[1][:-1].replace(";", ",").split(", ") if 'green' in x]) * max([int(x.split(" ")[0]) for x in z.split(": ")[1][:-1].replace(";", ",").split(", ") if 'blue' in x]) for z in open('resources/2023/day2.txt').readlines()])