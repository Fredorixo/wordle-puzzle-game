# Notes

- Widgets like `PopupMenu` and `ModalBottomSheet` don't rebuild when the stateful parent widget re-renders. To counter this, these widgets can be captured within a Stateful widget.