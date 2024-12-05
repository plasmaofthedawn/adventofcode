program day5part1;
uses sysutils;

type
    SState = (ToColon, WasteSpace, ReadSeeds, NewLine);
    MState = (Seed, WaitMap, ReadMap);


var

    race_times: array of int32 = (57, 72, 69, 92);
    race_distances: array of int32 = (291, 1172, 1176, 2026);
    valid: array of int32 = (0, 0, 0, 0);

    i, j: int32;

begin

    for i := 0 to 3 do
    begin
        writeln(race_times[i]);
        writeln(race_distances[i]);

        for j := 1 to race_times[i] do
        begin

            if (race_times[i] - j) * j > race_distances[i] then
                valid[i] := valid[i] + 1

        end;
    end;

    writeln(valid[0] * valid[1] * valid[2] * valid[3])

end.