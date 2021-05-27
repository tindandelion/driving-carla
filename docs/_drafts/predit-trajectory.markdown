---
layout: post
title:  "Coding trajectory prediction"
math: true
---
Now having come up with [the equations][kinematic-bicycle-model] suitable for predicting the trajectory of the car, it's time to put it into our Python notebook and see how it works out in the simulator. But first, let's discuss the variation of the model that Udacity course suggests. 

## Approximate model from Udacity

In the Udacity course, they come up with a slightly simpler model than we did in the previous posts. Here's their version of state update equations: 

$$
\begin{cases}
x_{k+1} = x_k + v \cdot \cos{\psi_k} \cdot dt \\
y_{k+1} = y_k + v \cdot \sin{\psi_k} \cdot dt \\
\psi_{k+1} = \psi_k + \frac{v}{L} \cdot \delta \cdot dt \\
\end{cases}
$$

As you may notice, their model resembles that we came up in the [last post][kinematic-bicycle-model], when the reference point is placed at the rear axle. They also simplified the equation for $$\psi$$, implying that $$\tan \delta \approx \delta$$ for small values of $$\delta$$. 

I should note that in their course they don't go through the details of model derivation, simply suggesting the formulas from above, so I can only guess their train of thought. 

Regarding the vehicle length *L*, they found it empirically, by running the car in the simulator and keeping the velocity the steering angle constant. Under such conditions, the car would drive in a circle. They kept adjusting the value of *L* until the predicted circular trajectory matched the actual, arriving at the final value of *L = 2.67*. 

## Putting it all in code

As I described in the post about [communicating with the simulator][simulator-communication], the simulator expects to receive the predicted trajectory points in 2 arrays `mpc_x` and `mpc_y`. Similar to the [planned trajectory][trajectory-visualization], those points should also be in the vehicle's coordinate system. That actually makes our task easier, since in the vehicle coordinates the predicted trajectory always starts at point $$x_0 = [0, 0]$$ with the heading $$\psi = 0$$ as well. 

In the Python notebook, the class `BicycleModel` does all the job of producing an array of predicted points, given the car's current velocity and steering angle. 

The plumbing is done in the `SimulatorClient` class that takes the predicted trajectory from `BicycleModel` and feeds it to the simulator in the `steer` command. 

The code for this exercise is [available on GitHub][github-link], as always.

Finally, we can see the predicted trajectory as a line of connected green dots in the simulator! 

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/predicted-trajectory.gif %}" alt="Predict car's trajectory">
</p>



[kinematic-bicycle-model]: {{ site.baseurl }}{% post_url 2021-05-26-kinematic-bicycle-model %}
