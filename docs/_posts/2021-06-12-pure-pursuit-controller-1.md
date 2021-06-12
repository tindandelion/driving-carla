---
layout: post
title:  "Steering control: pure pursuit controller"
math: true
---
We are now equipped with enough knowledge to take on an actual control task. This time, we're going to implement a path tracking controller, called *Pure Pursuit*, also known under a telling name *Follow the Carrot*. 

## The idea of the algorithm

Similar to the [bicycle model][bicycle-model-post], pure pursuit is a geometric path tracking controller. It means it only deals with the geometry of vehicle kinematics and the reference path, and it ignores the dynamic forces that may affect the vehicle movement. It makes it suitable when the car operates under "normal" conditions, that is not very high speeds and not very steep steering angles. 

The concept of pure pursuit controller is very simple. At every moment, we pick a point on the reference path at some distance ahead of the car. Then we observe the current car position and, given the knowledge of the car's kinematic model, we calculate the steering angle that would drive us from our current position to that look-ahead point. Finally, we apply that steering angle, and repeat the same process at the next time tick. 

In summary, at every moment we strive to reach some point on a reference path, ahead of our current position: 

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/pure-pursuit-concept.png %}" alt="Pure Pursuit concept">
</p>

Let's now go through some maths to calculate the steering angle. 

## The geometry of pure pursuit

I've found that it's easier to understand the geometry of pure pursuit controller if we simplify the picture a little bit. Let's put our car's reference point to the coordinate frame origin *(0, 0)*, and assume that it moves along the *X* axis. In other words, we transform our coordinates from the global inertial frame to the vehicle frame (recall the description of [coordinate frames][coordinate-frames-post]). It's a simple transformation that doesn't affect the results, but it makes the picture a bit clearer, and easier to implement in the code. 

To construct the pure pursuit law, we need to once again turn to the concept of an [Instantaneous Center of Rotation][icr-post] and apply a bit of geometry to derive the steering command formula. Let's see the picture: 

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/pure-pursuit-geometry.png %}" alt="Pure Pursuit geometry">
</p>

Here in the picture, we use the center of the rear axle as a reference point, and we focus on the look-ahead point $$P$$. We'll refer to the distance to that point as $$l_d$$, and the angle $$\alpha$$ between its direction and the current heading direction. 

In order to reach $$P$$ the car need to perform a steering maneuver with the radius $$R$$. The center of rotation $$O$$, car's reference point $$C$$, and the look-ahead point $$P$$ make an *isosceles triangle* with two sides of length $$R$$, and the base of length $$l_d$$. The angles of this triangle can also be derived from the picture:

$$
\angle OCP = \angle CPO = \frac{\pi}{2} - \alpha 
$$

$$
\angle COP = \pi - 2 \cdot \angle OCP = 2\alpha
$$

By applying the [law of sines][law-of-sines], we will arrive at the following equation:

$$
\frac{l_d}{\sin 2\alpha} = \frac{R}{\sin \left(\frac{\pi}{2} - \alpha \right)}
$$

Then, using some more trigonometric identities, we further simplify the equation and isolate $$R$$:

$$
\frac{l_d}{2 \sin \alpha \cos \alpha} = \frac{R}{\cos \alpha}
$$

$$
R = \frac{l_d}{2 \sin \alpha}
$$

Okay, so now as we arrived at the equation to calculate the radius of rotation $$R$$, we need to connect it to the steering angle $$\delta$$. Recall that we've already done a similar task when we were deriving the equations for the [bicycle model][bicycle-model-post]:

$$
\frac{1}{R} = \frac{\tan \delta}{L}
$$

where $$L$$ is the vehicle frame length. Finally, combining last 2 equations, we can arrive at the final equation to calculate the steering angle $$\delta$$:

$$
\delta = \tan^{-1}\left({\frac{2 L \sin \alpha}{l_d}}\right)
$$

Since we agreed that we operate in the vehicle's coordinate system, we can make one step further in calculating of $$\sin \alpha $$:

$$
\sin \alpha = \frac{P_y}{l_d} \implies 
\bbox[10px, lightgray]{\delta = \tan^{-1}\left({\frac{2 L P_y}{l_d^2}}\right)}
$$

where $$P_y$$ is the y-coordinate of the look-ahead point P. Finally, we've arrived at the control law for the steering angle that can be directly implemented in code!

## The implementation, proof of concept

Let's now put this formula into the code and see how it manages to control the car. The source code of the entire implementation is available [here on GitHub][github-link].

{% highlight python %}
class PurePursuitController: 
    lookahead_distance = 5
    
    def __init__(self, frame_length):
        self.frame_length = frame_length
    
    def process(self, telemetry):
        lookahead_point = self._get_lookahead_point(telemetry.trajectory)
        steer_angle = self._steer_to(lookahead_point)
        return SteerPackage(throttle=0.1, steering_angle=-steer_angle)
    
    def _steer_to(self, pt): 
        x, y = pt
        tangent_steer = 2 * self.frame_length * y / squared_distance_to(x, y)
        return np.arctan(tangent_steer)
    
    def _get_lookahead_point(self, trajectory):
        points_ahead = [(x, y) for x, y in trajectory if self._is_beyond_lookahead(x, y)]
        return points_ahead[0]
    
    def _is_beyond_lookahead(self, x, y):
        distance = math.sqrt(squared_distance_to(x, y))
        return x > 0 and distance > self.lookahead_distance
{% endhighlight %}

The implementation, as you can see, is very straightforward. `_steer_to()` function implements the control law formula. 
The code in `_get_lookahead_point()` picks the first waypoint on the trajectory that's further than 5 meters ahead. This might result in a bumpy ride, because the waypoints we receive from the simulator are quite sparse, but it should at least show us that we're on a right path (no pun intended). 

Finally, as we run the simulator with this version of the controller, we can more or less successfully drive the car along the entire track: 

<center><iframe width="560" height="315" src="https://www.youtube.com/embed/yldMBet65xQ" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></center>

## What's next

The controller behaves surprisingly well already, but there's still room for improvement. One thing that's obvious is that it's quite "jumpy" at times. This is because the trajectory that we receive from the simulator is too sparse, so when the controller switches between the waypoints, it results in a too strong change in parameters. We're going to fix it in the next exercise.

[bicycle-model-post]: {{ site.baseurl }}{% post_url 2021-05-26-kinematic-bicycle-model %}
[coordinate-frames-post]: {{ site.baseurl }}{% post_url 2021-05-11-trajectory-visualization %}#coordinate-frames
[icr-post]: {{ site.baseurl }}{% post_url 2021-05-22-more-about-angular-motion %}#instantaneous-center-of-rotation
[law-of-sines]: https://en.wikipedia.org/wiki/Law_of_sines
[github-link]: https://github.com/tindandelion/driving-carla/blob/0.0.5/udacity_simulator.ipynb

