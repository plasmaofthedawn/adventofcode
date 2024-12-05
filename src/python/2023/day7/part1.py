print( 
    sum([a * (c + 1) for c, (_, a) in enumerate(sorted(  # sort by hand value and payout bets according to rank
        [(sum([  # total hand value
            [max(
                13**5 * 6 if 5 in d else 0, # five of a kind
                13**5 * 5 if 4 in d else 0, # four of a kind
                13**5 * 4 if 3 in d and 2 in d else 0, # full house
                13**5 * 3 if 3 in d else 0, # three of a kind 
                13**5 * 2 if list(d).count(2) == 2 else 0, # two pair
                13**5 if 2 in d else 0 # pair
            ) for d in [{k: b.count(k) for k in b}.values()]][0], # total type value (value from the type of hand)
            sum([13**(4 - e) * '23456789TJQKA'.index(a) for e, a in enumerate(b)]) # total card value (value from the type of card)
        ]), int(v)) # makes an array of form (total hand value, bet)
            for b, v in [x.split(' ') for x in open('resources/2023/day7.txt').read().split("\n")] # reads file split on \n
        ] 
    ))])
)

#sum([a * (c + 1) for c, (_, a) in enumerate(sorted([(sum([[max(13**5 * 6 if 5 in d else 0, 13**5 * 5 if 4 in d else 0, 13**5 * 4 if 3 in d and 2 in d else 0, 13**5 * 3 if 3 in d else 0, 13**5 * 2 if list(d).count(2) == 2 else 0, 13**5 if 2 in d else 0) for d in [{k: b.count(k) for k in b}.values()]][0], sum([13**(4 - e) * '23456789TJQKA'.index(a) for e, a in enumerate(b)])]), int(v)) for b, v in [x.split(' ') for x in open('resources/2023/day7.txt').read().split("\n")]]))])