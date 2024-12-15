import re
a = open("temp").read().split("\n\n")[:-1]
#a = open("resources/2024/day13.txt").readlines()

def solve(a, b, c, d, e, f):
    y = ((a * f) - (c * d))/(a * e - b * d)
    x = (c - b * y) / a 
    return (x, y)



for i in a:
    ba, bb, bp = i.split("\n")

    a, d = [int(re.sub(r'\D+', '', x)) for x in ba.split(", ")]
    b, e = [int(re.sub(r'\D+', '', x)) for x in bb.split(", ")]
    c, f = [int(re.sub(r'\D+', '', x)) for x in bp.split(", ")]
    
    x_s, y_s = solve(a, b, c, d, e, f)
    x_10000, y_10000 = solve(a, b, 10000, d, e, 10000)

    print(a, b, c, d, e, f)
    print(x_s + x_10000 * 1000000000, y_s + y_10000 * 1000000000)

    
