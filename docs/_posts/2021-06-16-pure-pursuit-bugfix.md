---
layout: post
title:  "Bug found, bug fixed"
---
I've just realized I made a bug in my [last exercise][prev-post], and I stand corrected. 

Remember a few posts ago I described [the steer command content][steer-command-anatomy]? Well, I should have revisited it before I implemented the pure pursuit controller. I've just realized that all that time I was feeding the actual steering angle value to the simulator: 

{% highlight python %}
class SteerPackage: 
    def __init__(self, throttle):
        self.throttle = throttle
        self.steering_angle = 0
        self.planned_trajectory = [(0, 0)]
        self.predicted_trajectory = [(0, 0)]
        
    def to_json(self):
        next_x, next_y = self._unzip(self.planned_trajectory)
        mpc_x, mpc_y = self._unzip(self.predicted_trajectory)
        return json.dumps({
            'throttle': self.throttle, 
            'steering_angle': -self.steering_angle, 
            'mpc_x': mpc_x,
            'mpc_y': mpc_y,
            'next_x': next_x, 
            'next_y': next_y
        })
    
    def _unzip(self, tuples):
        return tuple(zip(*tuples))
{% endhighlight %}

See that I'm passing the raw value in `steering_angle` field? That's wrong. As I explained in [the post about command structure][steer-command-anatomy], `steering_angle` should be a normalized value in the range *[-1, 1]*, where boundary value of &plusmn;1 corresponds to &plusmn;25&deg;. So the correct way will be to scale the `steering_angle` value to that range, and also not forget that `steering_angle` comes in radians: 

{% highlight python %}
class SteerPackage: 
    steering_angle_bound = np.deg2rad(25.0)

    ...         
    def data(self):
        next_x, next_y = self._unzip(self.planned_trajectory)
        mpc_x, mpc_y = self._unzip(self.predicted_trajectory)
        return {
            'throttle': self.throttle, 
            'steering_angle': -self._calc_steering_value(), 
            'mpc_x': mpc_x,
            'mpc_y': mpc_y,
            'next_x': next_x, 
            'next_y': next_y }
        
    def _calc_steering_value(self):
        value = self.steering_angle / self.steering_angle_bound
        return np.sign(value) * min(abs(value), 1)

    ...
    
{% endhighlight %}

Now the CTE values appear to be much smaller than before, so the effect of this bug was that the controller was under-performing, supplying too small values in the steering command. This is especially noticeable with the version without path interpolation:

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/cross-track-error-bugfix.png %}" alt="Cross Track Error">
</p>

Now the difference in performance with and without path interpolation is not that dramatic, but still significant. Finally, the video of the car rolling around the full track: 

<center><iframe width="560" height="315" src="https://www.youtube.com/embed/10nTen-q5zM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></center>

The source code is [on GitHub][github-link], as always. 

[prev-post]: {{ site.baseurl }}{% post_url 2021-06-15-path-interploation %}
[steer-command-anatomy]: {{ site.baseurl }}{% post_url 2021-05-05-simulator-basic-communication %}#command-package-structure
[github-link]: https://github.com/tindandelion/driving-carla/blob/0.0.8/udacity_simulator.ipynb