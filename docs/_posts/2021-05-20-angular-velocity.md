---
layout: post
title:  "Clarifying angular velocity"
math: true
---
Before we move on to more advanced topics, I'd like to cover a few basic things, one being *angular velocity*. It's used extensively in models, and surprisingly I missed a few facts about it.

## What's the deal with radians?

Have you ever wondered why *radians* (rad) are such a strange measure? For one, 1 rad = 57.3&deg;. Also, the full circle of 360&deg; is 2&pi; in radians. I never gave it much thought, just accepting it as it is. Turns out, there's a good reason for radians which makes them quite useful. 

Radians make sense when we consider arcs of a circle. An angle of 1 rad corresponds to an arc, whose length $$l$$ is equal to the radius of the circle *R*: 

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/one-radian.png %}" alt="One radian angle">
</p>


Therefore, for an arbitrary arc its angle $$\theta$$ in radians is equal to $$\theta = \frac{l}{R}$$. Consequently, if we know the angle in radians and the circle radius *R*, we can easily find the length of the arc defined by that angle: $$l = \theta R$$. That's a pretty neat fact that's going to be useful later. 

By the way, that explains why the angle of 360&deg; is equal to 2&pi; in radians: $$\theta = \frac{l}{R} = \frac{2 \pi R}{R} = 2 \pi$$

## Defining angular velocity

When reasoning about angular velocity in general, things get pretty complicated pretty fast. To keep things simpler, let's only consider the case of circular motion in 2 dimensions. 

Consider an object *P* moving around a center of rotation *C*. *Angular velocity* will be a measure of its rotation rate, that is how fast the object makes a full circle. For example, when we say that the object makes 10 circles per minute, we're actually talking about its angular velocity. 

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/angular-velocity-definition.png %}" alt="Angular velocity definition">
</p>

Formally, angular velocity $$\omega$$ is measured as a rate of change of the angle $$\theta$$ over time: 

$$\omega = \frac{d \theta}{dt}$$

Since usually $$\theta$$ is measured in radians, the measure of angular velocity is *radians per seconds*, rad/s. Sometimes, however, the units of angular velocity is denoted as $$s^{-1}$$, since technically a radian is a dimensionless quantity, therefore $$\frac{1}{s} = s^{-1}$$. 

Angular velocity is a signed value. By convention, positive values indicate counter-clockwise rotation, negatives are clockwise. 

### Relation to linear velocity

How is angular velocity $$\omega$$ related to linear velocity $$v$$? Well, here the properties of radians come in quite handy. Recall that if $$\theta$$ is measured in radians, then $$\theta(t) = \frac{l(t)}{R}$$. Substituting it to the previous equation: 

$$ \omega = \frac{d \theta}{dt} = \frac{1}{R} \frac{d l}{dt} $$

Since the length of the arc $$l$$ is essentially *the distance* traveled by our object, its derivative $$\frac{d l}{dt}$$ is, by definition, its linear velocity! Continuing our train of expressions, we can see that 

$$ \omega = \frac{1}{R} \frac{d l}{dt} = \frac{v}{R} $$

And so we established the relation between object's linear and angular velocities. 

### Linear velocity vector angle

One more fact before we move on. Since linear velocity $$v$$ of our object is actually a vector, let's contemplate the properties of this vector, specifically, its angle relative to *X* axis, $$\beta$$. Here, a bit more geometry: 

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/linear-velocity-angle.png %}" alt="Linear velocity angle">
</p>

From this picture we can see that $$\beta$$ is related to $$\theta$$: $$ \beta = \theta + \frac{\pi}{2} $$. Therefore, contemplating the change of $$\beta$$ over time: 

$$ \frac{d \beta}{dt} = \frac{d}{dt} \left(\theta + \frac{\pi}{2} \right) = \frac{d \theta}{dt} = \omega $$

So the angle of linear velocity vector changes over time with the same rate $$\omega$$ as our object moves around the center! That's a quite useful fact worth remembering. 

## Conclusions

Let's summarize a few main takeaways from this exercise:

* Angular velocity is a rate of object's motion around the center of rotation $$\omega = \frac{d \theta}{dt}$$;
* Angular and linear velocities in circular motion are related as $$ \omega =  \frac{v}{R} $$;
* The angle of $$v$$ changes with the same rate $$\omega$$.






