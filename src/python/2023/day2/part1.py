
print(
    sum([
        (y+1) * (0 if 
        (
            sum([int(x.split(" ")[0]) > 12 for x in z.split(": ")[1][:-1].replace(";", ",").split(", ") if 'red' in x]) + 
            sum([int(x.split(" ")[0]) > 13 for x in z.split(": ")[1][:-1].replace(";", ",").split(", ") if 'green' in x]) +
            sum([int(x.split(" ")[0]) > 14 for x in z.split(": ")[1][:-1].replace(";", ",").split(", ") if 'blue' in x])
        ) > 0 else 1)
        for y, z in enumerate(open('resources/2023/day2.txt').readlines())
    ])
)

#  sum([(y+1) * (0 if (sum([int(x.split(" ")[0]) > 12 for x in z.split(": ")[1][:-1].replace(";", ",").split(", ") if 'red' in x]) + sum([int(x.split(" ")[0]) > 13 for x in z.split(": ")[1][:-1].replace(";", ",").split(", ") if 'green' in x]) + sum([int(x.split(" ")[0]) > 14 for x in z.split(": ")[1][:-1].replace(";", ",").split(", ") if 'blue' in x])) > 0 else 1) for y, z in enumerate(open('resources/2023/day2.txt').readlines())])