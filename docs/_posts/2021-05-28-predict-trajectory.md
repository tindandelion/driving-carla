---
layout: post
title:  "Coding trajectory prediction"
math: true
---
Now having come up with [the equations][kinematic-bicycle-model] suitable for predicting the trajectory of the car, it's time to put it into our Python notebook and see how it works out in the simulator. But first, let's discuss the variation of the model that Udacity course suggests. 

## Simplified model from Udacity

In the Udacity course, they come up with a slightly simpler model than what we did in the previous posts. Here's their version of state update equations: 

$$
\begin{cases}
x_{k+1} = x_k + v \cdot \cos{\psi_k} \cdot dt \\
y_{k+1} = y_k + v \cdot \sin{\psi_k} \cdot dt \\
\psi_{k+1} = \psi_k + \frac{v}{L} \cdot \delta \cdot dt \\
\end{cases}
$$

As you may notice, their model resembles that we came up in the [last post][kinematic-bicycle-model], when the reference point is placed at the rear axle. They also simplified the equation for $$\psi$$, implying that $$\tan(\delta) \approx \delta$$ for small $$\delta$$. 

I should note that in their course they don't go through the details of model derivation, simply suggesting the formulas from above, so I can only guess their train of thought. 

Regarding the vehicle length *L*, they found it empirically, by running the car in the simulator and keeping the velocity the steering angle constant. Under such conditions, the car would drive in a circle. They kept adjusting the value of *L* until the predicted circular trajectory matched the actual, arriving at the final value of *L = 2.67*. 

## Putting it all in code

As I described in the post about [communicating with the simulator][simulator-communication], the simulator expects to receive the predicted trajectory points' coordinates in arrays `mpc_x` and `mpc_y`. Similar to the [planned trajectory][trajectory-visualization], those points should also be in the vehicle's coordinate system. That actually makes our task easier, since in the vehicle coordinates the predicted trajectory always starts at point $$x_0 = [0, 0]$$ with the heading $$\psi_0 = 0$$ as well. 

In the [Python notebook][github-link], the class `BicycleModel` does all the job of producing an array of predicted points, given the car's current velocity and steering angle. The plumbing is done in the `SimulatorClient` class, that takes the predicted trajectory from `BicycleModel` and feeds it to the simulator in the `steer` command. 

The code for this exercise is [available on GitHub][github-link], as always.

Finally, we can see the predicted trajectory as a line of connected <span style="color: green;">green dots</span> in the simulator! Remember that we still run the car with the constant throttle and steering angle. In the small demo video below, you can see how it stretches out as our car accelerates, and also bends to the left, according to the steering command. 

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/predicted-trajectory.gif %}" alt="Predict car's trajectory">
</p>

## Coming next

Let's quickly recap what we've done so far: 

* We can receive the telemetry from the simulator and send back the steering commands;
* We read the planned trajectory, and we visualize it in the simulator;
* We can predict the actual car's trajectory, given current velocity and steering angle. 

Now it's time to turn our attention to the controls and start sending the commands that should make the car follow the planned trajectory! In the next post, we'll talk about the errors in the car's position that we want to minimize, and how to calculate them. 

[kinematic-bicycle-model]: {{ site.baseurl }}{% post_url 2021-05-26-kinematic-bicycle-model %}#special-reference-points
[simulator-communication]: {{ site.baseurl }}{% post_url 2021-05-06-submit-simple-command %}
[trajectory-visualization]: {{ site.baseurl }}{% post_url 2021-05-11-trajectory-visualization %}
[github-link]: https://github.com/tindandelion/driving-carla/blob/0.0.4/udacity_simulator.ipynb