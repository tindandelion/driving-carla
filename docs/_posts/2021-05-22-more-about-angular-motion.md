---
layout: post
title:  "More about angular motion"
math: true
---
There's still a few more things about kinematics I'd like to talk about before we move on to actual model derivation. 

## Car as a physical body

In the [previous post][angular-velocity-post] I was talking about angular velocity of an abstract point. But, moving closer to reality, a car is not exactly a "point". Rather, it's a quite tangible physical object with specific geometric properties, e.g. the length and the width. Let's now take a closer look at angular motion of a physical body with dimensions. 

Imagine a car making a circle with some constant speed, and consider points *A* and *B* on each side:

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/physical-body-motion.png %}" alt="Physical body motion">
</p>

Since the car moves as a whole rigid body, both points will have the same angular velocity $$\omega$$. However, because our car has a non-zero width (it's called a *track* in autonomous vehicle terminology), linear velocities of points A and B will be different. Precisely, the point A will be moving more slowly, because it's closer to the center of rotation. Also, since the direction of the linear velocity vector is orthogonal to the line from *O* to *A*, as well as from *O* to *B*, the directions of the velocity vectors at these points will be slightly different too. 

## Instantaneous center of rotation

Let's now perform a somewhat reverse mental experiment. Imagine now a car moving along a complex curved path, so there's both a linear and a rotational component to its movement. However, since the path is an arbitrary curve, there's no fixed center of rotation. 

Now let's imagine that we can take a momentary snapshot of a car at some moment *t* and visualize the velocity vectors of its few points. From each point, we draw a line that's orthogonal to the velocity vector. These lines will all cross at a single point, which is called *Instantaneous Center of Rotation (ICR)*. Its position varies with time (hence it is "instantaneous"), yet there's such point at any fixed moment, with the following properties: 

* The whole car moves with angular velocity $$\omega$$ around IRC; 
* At any point in the car's body, the linear velocity vector at this point is orthogonal to the line between the point and ICR. 

These facts will be very useful when we derive the equations for a kinematic model of vehicle's movement (stay tuned). 

[angular-velocity-post]: {{ site.baseurl }}{% post_url 2021-05-20-angular-velocity %}