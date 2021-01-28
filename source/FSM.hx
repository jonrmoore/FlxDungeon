package;

class FSM
{
    public var activeState:Float->Void;

    public function new(initialState:Float->Void):Void
    {
        activeState = initialState;
    }

    public function update(elapsed:Float):Void
    {
        activeState(elapsed);
    }
}