program day5part1;
uses sysutils;

type
    SState = (ToColon, WasteSpace, ReadSeeds, NewLine);
    MState = (Seed, WaitMap, ReadMap);


var

    race_time: int64 = 57726992;
    race_distance: int64 = 291117211762026;
    valid: int64 = 0;

    i, j: int32;

begin

    writeln(race_time);
    writeln(race_distance);

    for j := 1 to race_time do
    begin

        if (race_time - j) * j > race_distance then
            valid := valid + 1

    end;

    writeln(valid);

end.