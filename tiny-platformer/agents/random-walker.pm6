unit module random-walker;

sub nextAction($image) is export {
    return ["left", "right", "jump"][3.rand.Int];
}
