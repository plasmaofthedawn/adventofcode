print(
    sum([a[0]*10 + a[-1] for a in [[int(b) for b in c if b.isnumeric()] for c in open('resources/2023/day1.txt').read().split("\n")[:-1]]])
)

# sum([a[0]*10 + a[-1] for a in [[int(b) for b in c if b.isnumeric()] for c in open('resources/2023/day1.txt').read().split("\n")[:-1]]])