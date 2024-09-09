# Notes

- Widgets like `PopupMenu` and `ModalBottomSheet` don't rebuild when the stateful parent widget re-renders. To counter this, these widgets can be captured within a Stateful widget.

- The lifecycle of a Stateful widget comprises of a `didUpdateWidget` method, which can be useful for use-cases that involve comparing the previous state variable values with the updated ones, in order to perform an action.

- After adding firebase dependencies into your flutter project, and updating your gradle files as instructed in the google documentation, make sure to run the following command from the android directory:

`./gradlew :app:dependencies`

- The list of all gradle commands can be found in [Gradle Commands](https://docs.gradle.org/current/userguide/command_line_interface_basics.html).