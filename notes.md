# Notes

- Widgets like `PopupMenu` and `ModalBottomSheet` don't rebuild when the stateful parent widget re-renders. To counter this, these widgets can be captured within a Stateful widget.

- The lifecycle of a Stateful widget comprises of a `didUpdateWidget` method, which can be useful for use-cases that involve comparing the previous state variable values with the updated ones, in order to perform an action.