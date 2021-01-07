unit module random-walker;

use NativeCall;

sub decode_data(Pointer[uint8], int32, uint32 is rw, uint32 is rw) returns Pointer[uint8] is native("./png/lodepng") { * }

sub print_map($data) {
    my uint32 $width;
    my uint32 $height;
    my $pointer = nativecast(Pointer[uint8], $data);
    my $image = decode_data($pointer, $data.elems, $width, $height);
    my @items = [];
    my $tile = 32;
    for 0..^$height / $tile -> $i {
        my $i1 = $i * $tile + $tile / 2;
        for 0..^$width / $tile -> $j {
            my $j1 = $j * $tile + $tile / 2;
            my $n = $i1 * $width + $j1;
            my $item1 = $image[$n * 4 + 0].Str;
            my $item2 = $image[$n * 4 + 1].Str;
            my $item3 = $image[$n * 4 + 2].Str;
            my $item = "$item1 $item2 $item3";
            my $c = -1;
            for 0..^@items.elems -> $idx {
                if @items[$idx] ~~ $item {
                    $c = $idx;
                    last;
                }
            }
            if $c == -1 {
                $c = @items.elems;
                @items.push: $item;
            }
            print "$c ";
        }
        say "";
    }
}

sub nextAction($data) is export {
    print_map($data);
    return ["left", "right", "jump"][3.rand.Int];
}
