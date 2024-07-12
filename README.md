# godot-gdshader.rock-n-roller
A Godot shader to Rock, Roll, Bounce & Fade a Material

## Usage

Drag `rock_n_roller.gdshader` onto a Material, enable settings as desired

![Shader Settings](https://github.com/scawp/godot-gdshader.rock-n-roller/blob/main/images/Shader%20Settings.png?raw=true "Shader Settings")

## Advanced Usage

Drag scene `rock_n_roller_controller.tscn` as a child of the node containing the `rock_n_roller.gdshader` material, this will expose the following settings:

![Controller Settings](https://github.com/scawp/godot-gdshader.rock-n-roller/blob/main/images/Controller%20Settings.png?raw=true "Shader Settings")

### Note: Flags are default settings and can be overritten via signals

### Controling via Signals

By adding arguments to a signal you can override the default behaviour and add a callback signal

![Signal Settings](https://github.com/scawp/godot-gdshader.rock-n-roller/blob/main/images/signal%20Settings.png?raw=true "Signal Settings")

Argument 1 is a bitmask 0 - 15 representing flags for (combine for multiple):

0000 - off
0001 - fade
0010 - rock
0100 - roll
1000 - bounce

Argument 2 is to set a callback signal on finish named `rock_n_roller_finished()` see `duck.gd` for example usage (on complete delete the duck from the scene)

# Example

![Example](https://github.com/scawp/godot-gdshader.rock-n-roller/blob/main/images/example1.gif?raw=true "example")


# this is a Work in Progress!
