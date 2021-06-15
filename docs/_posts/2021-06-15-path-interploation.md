---
layout: post
title:  "Refining pure pursuit: path interpolation"
math: true
---
Before we proceed to fine-tune the controller, let's talk about an important metric, called *Cross Track Error (CTE)*. Cross track error is defined as the distance between the vehicle and the reference path. We'll use that metric to evaluate how accurately the controller drives our car along the path. The source code for the exercise described in this article is [available on GitHub][github-link], as always. 

## Reference path and cross track error calculation

In our project, the reference path for the car is determined by a set of waypoints. Generally speaking, a path that goes through the waypoints should be a curve, but for sake of simplicity let's assume that the waypoints are connected by straight line segments. It simplifies the calculations, since at each moment we take for granted that the car should follow a straight line, and so it's quite commonly used in autonomous car controllers. 

The calculation of CTE in this case is essentially finding the distance between a point $$(x_0, y_0)$$, and a straight line, when the line is defined by two points $$(x_1, y_1)$$ and $$(x_2, y_2)$$: 

$$
cte(x_0, y_0) = \frac{(x_2 - x_1)(y_1 - y_0) - (y_2 - y_1)(x_1 - x_0)}{\sqrt{(x_2 - x_1)^2 + (y_2 - y_1)^2}}
$$

Remember that previously we agreed that we convert the reference waypoints into the vehicle's coordinate frame. This conversion makes the formula a bit easier, since in the vehicle's frame the reference point is always $$(x_0, y_0) = (0, 0)$$, and so the formula is simplified to: 

$$
cte(0, 0) = \frac{(x_2 - x_1) \cdot y_1  - (y_2 - y_1) \cdot x_1}{\sqrt{(x_2 - x_1)^2 + (y_2 - y_1)^2}}
$$

To estimate the overall controller performance, we can use an integral metric called *Root Mean Squared Error (RMSE)*:

$$
RMSE = \sqrt{\frac{1}{N} \sum_{i=1}^N{cte_i^2}}
$$

Let's now see how well our controller performs over the first 100 seconds of the drive:

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/cte-graph-no-interp.png %}" alt="Cross track error without interpolation">
</p>

## Reference path interpolation

One obvious improvement we can make right away is make the reference path denser. The original waypoints that come from the simulator are rather sparse, tens of meters apart from each other. Even though we are now using a hard-coded value of 5 meters ahead, the next waypoint may well be 20 or even 30 meters away. By the nature of pure pursuit controller, the farther away the look-ahead point, the smaller the steering angle will be. So most of the time, the look-ahead points are too far away from each other to provide accurate guidance for the controller.  

Lucky for us, this situation is very easy to improve. What we can do is create a denser path by filling the gaps between the original waypoints with interpolated values. With more waypoints, the controller will be able to pick lookahead points  closer to the intended look-ahead distance. Overall, that will allow the controller follow the path more accurately. 

In Python, this is very easy to implement, using [numpy.interp()][interp-doc] function. This function does exactly what we need: it uses linear interpolation to fill the gaps between the reference points. Using this function, we can easily create a reference path where waypoints are much closer to one another; for example, 1 meter apart by *X* coordinate: 

{% highlight python %}
def _interpolate(self, trajectory):
    xp, yp = tuple(zip(*trajectory))
    xx = list(range(50))
    yy = np.interp(xx, xp, yp)
    return zip(xx, yy)
{% endhighlight %}

Now, using the interpolated waypoints, the controller is able to follow the reference path much more accurately: 

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/cte-graph-with-interp.png %}" alt="Cross track error with interpolation">
</p>

Notice that the RMSE dropped from 0.62 meters to 0.19 meters. Not bad for such a small change! Also visually it's noticeable that the control is now much smoother, and the car stays on the path most of the time:

<center><iframe width="560" height="315" src="https://www.youtube.com/embed/HruqL5nHEBY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></center>

## What's next

Now that we have more precise control, we're going to explore how the look-ahead distance affects the performance of the controller. We'll also experiment with increasing the speed of our car. 

[github-link]: https://github.com/tindandelion/driving-carla/blob/0.0.7/udacity_simulator.ipynb
[interp-doc]: https://numpy.org/doc/stable/reference/generated/numpy.interp.html

