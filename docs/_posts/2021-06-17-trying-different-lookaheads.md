---
layout: post
title:  "Refining pure pursuit: look-ahead distances"
math: true
---
Now that we have the implementation for pure pursuit controller in place, let's play a little bit with different values for the look-ahead distance and see how it affects the controller performance. 

Recall that the formula to calculate the steering angle looks like this: 

$$
\delta = \tan^{-1}\left({\frac{2 L}{l_d^2}} P_y\right)
$$

Look-ahead distance $$l_d$$ appears in the denominator of the equation, so it's reasonable to assume that larger values will result in smaller steering angles and, in theory, longer times for the car to get back to the path. Let's see how it looks in practice. 

I've conducted [a few experiments][github-link] with different look-ahead values. In each experiment, I let the car run for 90 seconds, and I recorded the values for CTE and the steering angles. Let's take a look at the CTE values for different look-ahead distances: 

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/cte-errors-diff-lookahead.png %}" alt="Cross Track Error">
</p>

Indeed, we can see that the farther ahead we look, the longer it takes for the car to get back on track. Not surprisingly, the best results in terms of following the path we've got when the look-ahead distance is 0: effectively we're using the closest available waypoint for tracking. So what does it mean, should we always look at the closest waypoint to achieve best results? Well, not so fast. 

Let's also take a look at the steering angle values that we submit to the car:

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/steering-angles-diff-lookahead.png %}" alt="Steering Angles">
</p>

As you can see from these graphs, short look-ahead distances result in abrupt changes to the steering angle. Effectively, the car starts to behave more "jerky" on the road, which is very uncomfortable for the passengers! I don't think anyone would enjoy the ride in a car that behaves that the one on the last graph! In practice, steep changes to the steering angle values may also lead to the car becoming unstable. 

All in all, choosing a good value for the look-ahead distance is a trade-off. Personally, I like the value of 10 meters: it gives us a smooth ride and follows the path quite nicely. Take a look: 

<center><iframe width="560" height="315" src="https://www.youtube.com/embed/epFsNGSm8pk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></center>

## What's next 

The code for this exercise is available on [GitHub][github-link]. For now, I feel quite satisfied with how our car follows the path with the controller we've developed. 

Next, we're going to switch the subject and pay closer attention at the speed control. By now, we've been simply supplying the constant value to the throttle control. It's time we got more accurate about that!

[github-link]: https://github.com/tindandelion/driving-carla/blob/0.1.0/udacity_simulator.ipynb





