---
layout: post
title:  "Visualize the trajectory"
math: true
---
Our next task will be showing the car's planned trajectory. We seem to have all necessary data at hand.
Remember that a few next waypoints from the planned trajectory are received in the telemetry package as `ptsx` and `ptsy` arrays: 

{% highlight json %}
{
    // ... 
    'ptsx': [-32.16173, -43.49173, -61.09, -78.29172, -93.05002, -107.7717], 
    'ptsy': [113.361, 105.941, 92.88499, 78.73102, 65.34102, 50.57938], 
    // ...
}
{% endhighlight %}

Also remember that the simulator's command package contains a pair of fields `next_x` and `next_y` that should contain the trajectory points to display. So the task seems pretty straightforward: take the waypoint data from the telemetry, and put them into the command package. There's one caveat though: waypoints in the telemetry package are in *global* coordinate frame, but the command package expects the trajectory coordinates in *vehicle* coordinate frame. In order to display the planned trajectory correctly, our controller needs to transform the coordinates between those two frames. 

## Coordinate frames

The *world*, or *global*, or *inertial* coordinate frame is a fixed frame, attached to the Earth. Often we represent it as *East North Up (ENU)*, where X axis points to the East, Y axis points to the North, and Z axis goes up, and we discard the Earth's curvature. The origin is some arbitrary fixed reference point nearby. 

Another commonly used global coordinate frame is *Earth-Centered, Earth Fixed (ECEF)* coordinate frame, which places the origin at the Earth's center, +X axis passes through the intersection of Equator and Prime Meridian, +Z goes though the North Pole, and +Y is orthogonal to +X and +Z. This coordinate system is used as a primary system in GPS. 

The vehicle coordinate frame is attached to the vehicle, with the origin at some important point of the vehicle, e.g. the center of gravity, with +X axis pointing forward from the vehicle, +Z going up.

Notice that in such coordinate systems there are 2 ways to orient Y axis respective to X and Z axes: *right-handed* and *left-handed*. The choice is somewhat arbitrary, conventionally [right-handed][right-hand-rule] is more common. 

## Coordinate transformations

Let's now see how we can transform the coordinates from the global coordinate frame to the vehicle's frame. Let's assume that the origin of the vehicle frame is placed to its center of gravity $$ \pmb{c}_g $$, and the direction is given as an angle $$ \psi $$ relative to the global X axis:

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/vehicle-coord-frame.png %}" alt="Vehicle coordinate frame">
</p>



### Homogeneous coordinate system

$$
\mathbf{R}(\psi) = 
    \begin{pmatrix}
        \cos{\psi} & \sin{\psi} & 0 \\
        -\sin{\psi} & \cos{\psi} & 0 \\
        0 & 0 & 1 \\
    \end{pmatrix} \qquad
\mathbf{T}(\vec{c}) = 
    \begin{pmatrix}
        1 & 0 & -c_x \\
        0 & 1 & -c_y \\
        0 & 0 & 1 \\
    \end{pmatrix}
$$

## Putting it all together

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/visualize-trajectory.gif %}" alt="Visualize trajectory">
</p>

[right-hand-rule]: https://en.wikipedia.org/wiki/Right-hand_rule