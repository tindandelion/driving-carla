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

Remember also that the simulator's command package contains a pair of fields `next_x` and `next_y` that should contain the trajectory points to display. So the task seems pretty straightforward: take the waypoint data from the telemetry, and put them into the command package. There's one caveat though: waypoints in the telemetry package are in *global* coordinate frame, but the command package expects the trajectory coordinates in *vehicle* coordinate frame. In order to display the planned trajectory correctly, our controller needs to transform the coordinates between those two frames. 

## Coordinate frames

A *world*, or *global*, or *inertial* coordinate frame is a fixed frame, attached to the Earth. Often we represent it as *East North Up (ENU)*, where X axis points to the East, Y axis points to the North, and Z axis goes up, and we discard the Earth's curvature. The origin is some arbitrary fixed reference point nearby. 

Another commonly used global coordinate frame is *Earth-Centered, Earth Fixed (ECEF)* coordinate frame, which places the origin at the Earth's center, +X axis passes through the intersection of Equator and Prime Meridian, +Z goes though the North Pole, and +Y is orthogonal to +X and +Z. This coordinate frame is used as a primary system in GPS. 

The vehicle coordinate frame is attached to the vehicle, with the origin at some important point of the vehicle, e.g. the center of gravity, with +X axis pointing forward from the vehicle, +Z going up.

Notice that in such coordinate systems there are 2 ways to orient Y axis respective to X and Z axes: *right-handed* and *left-handed*. The choice is somewhat arbitrary; conventionally [right-handed][right-hand-rule] is more common. 

## Coordinate transformations

Let's now see how we can transform the coordinates from the global coordinate frame to the vehicle's frame. Let's assume that the origin of the vehicle frame is placed to its center of gravity $$\mathbf{c}_g$$, and the direction is given as an angle $$ \psi $$ relative to the global X axis:

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/vehicle-coord-frame.png %}" alt="Vehicle coordinate frame">
</p>

In order to transform a point $$\mathbf{p}$$ from global coordinates into vehicle coordinates $$\mathbf{p}'$$, we need to translate by $$-\mathbf{c}_g$$ and then rotate by angle $$\psi$$ clockwise. Note that the order of transformations is important! "Translate then rotate" will give a different result than "rotate then translate". We first want to move the coordinate frame to the new origin, and then rotate around that new origin. 

These elementary transformations can be represented in a matrix form as follows: 

$$
\mathbf{R} = 
    \begin{pmatrix}
        \cos{\psi} & \sin{\psi}  \\
        -\sin{\psi} & \cos{\psi}  \\
    \end{pmatrix} \qquad
\mathbf{t} = -\mathbf{c}_g = 
    \begin{pmatrix}
        -c_x \\
        -c_y \\
    \end{pmatrix} \qquad
$$

and so the complete transformation looks quite compact in the vector form: 
$$\mathbf{p}' = \mathbf{R}(\mathbf{p} + \mathbf{t}) $$

## The problem with translation

The formula above works perfectly well for our purposes, but I'd like to go one step further and dive a bit deeper into geometric transformations. 

Most common geometric transformation, such as rotation, scaling, shear, and stretching/squeezing, can be represented in a matrix form, similar to the rotation matrix above. Having them in the matrix form is very useful, since composite transformations (like, rotate by &pi;/4 and scale up by 2) effectively become matrix multiplications: 
$$\mathbf{B}(\mathbf{Ax}) = (\mathbf{BA})\mathbf{x}$$. Also, a transformation can be "undone" by applying its inverse matrix. 

That's true for most geometric transformations, except translation, which breaks that nice uniformity. Fortunately, there's a neat trick that can solve that problem: homogeneous coordinate space.

## Homogeneous coordinates

We convert from regular 2D coordinates to homogeneous coordinates by introducing a fictitious third dimension, where the third coordinate is always 1: $$\mathbf{p} = [x, y, 1]^T$$. Similarly, transformation matrices are extended by one column and one row, where the diagonal element is 1, and others are zeros. Interestingly, in that coordinate space translation is also represented by a matrix (it actually becomes a shear transformation in 3D homogeneous space):

$$
\mathbf{R} = 
    \begin{pmatrix}
        \cos{\psi} & \sin{\psi} & 0 \\
        -\sin{\psi} & \cos{\psi} & 0 \\
        0 & 0 & 1 \\
    \end{pmatrix} \qquad
\mathbf{T} = 
    \begin{pmatrix}
        1 & 0 & -c_x \\
        0 & 1 & -c_y \\
        0 & 0 & 1 \\
    \end{pmatrix}
$$

So now translation can be combined with other transformations by means of matrix multiplication, and our composite transformation becomes compact and uniform: $$\mathbf{p}' = \mathbf{RTp}$$

## Putting it all together

To summarize what I do in this exercise: 
* I receive waypoints `ptsx`, `ptsy` in the telemetry package. I also get vehicle coordinates (`x`, `y`), and orientation angle `psi`;
* I apply the transformation to the waypoints, from global coordinate frame to vehicle frame;
* I send the result back to the simulator in the command package in arrays `next_x` and `next_y`.

The source code for this exercise is located [here][simulator-0.0.3].

Having the planned trajectory in the command package, we can now see it as a yellow line in the simulator:

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/visualize-trajectory.gif %}" alt="Visualize trajectory">
</p>

[right-hand-rule]: https://en.wikipedia.org/wiki/Right-hand_rule
[simulator-0.0.3]: https://github.com/tindandelion/driving-carla/blob/0.0.3/udacity_simulator.ipynb