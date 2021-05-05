---
layout: post
title:  "Communicating with the simulator"
---
Communicating with the simulator is pretty straightforward. Most information can be gathered from a project template, accessible freely from the [Udacity GitHub][udacity-github]. 

The controller is supposed to set up a WebScoket server, listening for simulator events on port 4567. After connecting, the simulator sends the first telemetry package. The simulator sends back a control command with values for car's steering angle and throttle. Once received the command, the simulator applies it and sends back the updated telemetry package. 

One important note is that the controller is an orchestrator in this pairing. The simulator will only send back the telemetry as a response to the command from the latter, with the exception of the very first telemetry reading, so the controller is responsible for timing the communication.

The telemetry package and the command share a similar low level structure. It's a string, starting with the event code (for our purposes, the event code is always *42*), followed by a JSON array of 2 elements, where 1st element is a package type string, and the 2nd element is a JSON object, specific to that: 

```
42[<package_type>,<package_content>]
```
In our project, there are only 2 package types, `telemetry` for incoming telemetry packages, and `streer` or `manual` for commands that we send back. The most interesting part is, of course, the package content. Let's see what telemetry the simulator sends to us.

## Telemetry package structure

Here's the very first telemetry package that the simulator sends to our controller. 

{% highlight json %}
{
    'ptsx': [
        -32.16173,
        -43.49173,
        -61.09,
        -78.29172,
        -93.05002,
        -107.7717
    ], 
    'ptsy': [
        113.361,
        105.941,
        92.88499,
        78.73102,
        65.34102,
        50.57938
    ], 
    'psi_unity': 4.120315, 
    'psi': 3.733667, 
    'x': -40.62008, 
    'y': 108.7301, 
    'steering_angle': 0, 
    'throttle': 0, 
    'speed': 1.218817e-06
}
{% endhighlight %}

Most fields are quite self-explanatory:
* A few nearest trajectory waypoints. Their coordinates come as two separate arrays, `ptsx` and `ptsy`;
* Current car state: `psi` and `psi_unity` (see below) for the heading angle; `x` and `y` for current coordinates; `speed` for speed.
* Current values of actuator values `steering_angle` and `throttle`.

The trickiest part is the measure units for speed and angles. It's always been a source of confusion even when I was implementing this project for Udacity's course:

| `psi`, `psi_unity` | Radians |
| `speed` | Miles per hour | 

The difference between `psi` and `psi_unity` is the coordinate system: 

`psi`
```
        90

  180        0/360

        270
```

`psi_unity`
```
      0/360
 
 270          90
 
       180
```

Let's talk about `throttle` and `steering_angle` separately.

## Command package structure 

There are 2 package types we can send back to the simulator: 
* `manual` to indicate that the car is in the manual driving mode, that is, there's no data passed from the controller;
* `steer` to actually pass the actuator signals to the simulator. 

One might wonder, why we need `manual` command at all? But remember, that the simulator will only send us the telemetry data *in response* to the command. So `manual` can be used as a "dummy" command to query simulator's updated telemetry. 

`steer` is an actual working horse for us. It should be loaded with a JSON object that contains actuator signal values and, optionally, trajectory waypoints for visualization. We'll talk about trajectory visualization in later posts, and for now let's focus on the actuator command fields: 

| throttle | Throttle value |
| steering_angle | Steering value | 

Both are floating point values that lie in the range [-1, 1]. For the throttle, 0 means no throttle, 1 is the maximum value. Negative values are used for active braking. Notably, when the throttle is kept at 0, the car is slowly decelerating on its won, so active braking might not be necessary for this project. 

Steering value of [-1, 1] range commands the car to acquire a desired steering angle. In absolute values, the steering angle can vary in the range up to 25 degrees left or right, which for the command need to be scaled into [-1, 1] interval. We'll need to figure out experimentally which direction is negative. 

## Putting it all together

Let's now put this all into code. I've set up a Jupyter notebook to act as a workplace for this project. For WebSocket server, I'm using a nice little package [simple-websocket-server][websocket-package], which does all network communication for us. 

This time, I don't bother sending actual steering commands to the simulator. To demonstrate that the communication works fine on a low level, it's enough to receive the telemetry package, and send `manual` command back. 


[udacity-github]: https://github.com/udacity/CarND-MPC-Project
[websocket-package]: https://github.com/dpallot/simple-websocket-server



