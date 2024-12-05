// i wrote this but i didn't use it
// might be useful for the future;

var
    queue: array[0..1000] of Tnode;
    queue_start, queue_length: int32;

procedure enqueue(node: Tnode);
begin
    queue[queue_start + queue_length] := node;
    inc(queue_length);
end;

function dequeue(): Tnode;
begin
    dequeue := queue[queue_start];
    inc(queue_start);
    dec(queue_length);
end;

var

    a, b: Tnode;
