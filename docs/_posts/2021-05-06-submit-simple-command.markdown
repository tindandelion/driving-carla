---
layout: post
title:  "Submit commands to the simlator"
---
Okay, so now we know how to communicate with the simulator on the low level, and how to read the telemetry updates. It's time we started to actually control the car with the `steer` command. Let's start with the simplest possible example: drive the car with constant throttle and steering angle. But first, let's explore the anatomy of that command.

## Steering command anatomy

`steer` command has just a few fields, some for supplying the actuator signals, and some are used for advanced visualization. Let's check out our very first example: 

{% highlight json %}
{
    'throttle': 0.05, 
    'steering_angle': -0.05, 
    'next_x': [],
    'next_y': [],
    'mpc_x': [],
    'mpc_y': []
}
{% endhighlight %}

The actuator part of the command, `throttle` and `steering_angle` fields, are quite self-explanatory, and I described them in the [previous post]({{ site.baseurl }}{% post_url 2021-05-05-simulator-basic-communication %}). I've chosen to use a negative value for the steering angle command now, since I'd like to find out in which direction the car would be turning with negative values. 

A few other fields, `next_*` and `mpc_*` are used for visualizing car's trajectory. The simulator can display two trajectory lines in different colors: green an yellow. We'll tap into trajectory visualization in later posts, but for now we can simply provide empty arrays here. You may wonder where the prefix `mpc_` comes from. This abbreviation stands for **M**odel **P**rediction **C**ontrol, because originally this simulator is used in Udacity's MPC project. 

Note that all fields must be present in the command payload, even though we don't use some of them now. As I've found out experimentally, when any field is missing, the simulator just stops responding. 

## Let's drive!

So now we can submit that simple command to the simulator and see what happens (source code [here][controller-code])! And indeed, the car starts moving forward with acceleration, and also is steering slightly to the left. At least, we've now learned that negative values in `steering_angle` will steer the car to the left. 

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/constant-throttle.gif %}" alt="Constant throttle">
</p>

## What's next

Next, we'll touch trajectory visualization: how to calculate the car trajectory using its current state, and also how to display that data in the simulator.

[controller-code]: https://github.com/tindandelion/driving-carla/blob/0.0.2/udacity_simulator.ipynb

