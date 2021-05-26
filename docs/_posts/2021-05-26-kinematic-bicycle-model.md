---
layout: post
title:  "Kinematic bicycle model"
math: true
---
Now that we are equipped with the knowledge, it's time to get to the derivation of a kinematic model for a car. That will require a bit of geometry and basic trigonometry, but nothing over the top. 

## Model assumptions

Since modeling car's behavior is a task that get very complicated very fast, a couple simplifications need to be made. First is a *kinematic assumption*. This assumption implies that the wheels of a car only move in their rolling direction, in other words the *tyre side slip* does not occur. This is a reasonable condition at low velocities. Under this no-slip condition the velocity vector matches precisely the wheel orientation.

The second is a simplification of a four-wheel model. The two rear wheels and the two front wheels are lumped together into a pair of imaginary rear and front wheel, essentially turning a car into a bicycle. The advantage of this model is that we need to deal with only one steering angle for the front wheel. However, such model will behave exactly as a four-wheel model, as long as the kinematic assumption holds. 

## Equations of motion

Let's now get to deriving the equations for the bicycle model. Consider our imaginary bicycle in motion:

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/bicycle-model.png %}" alt="Kinematic bicycle model">
</p>

The front wheel has a steering angle $$\delta$$, which makes the bicycle turn around the instantaneous center of rotation *O* with some angular velocity $$\omega$$. As we discussed in the [previous post][more-angular-velocity], the velocity vectors of the front and rear wheel will be orthogonal to lines $$OW_f$$ and $$OW_r$$, respectively.

We choose a reference point *C* on the bicycle frame. That point divides the whole vehicle length into front and rear parts, $$l_f$$ and $$l_r$$ respectively. These dimensions will be important later. 

Notice also that the overall direction in which the point *C* is moving is slightly sideways with respect to the vehicle heading $$\psi$$, with a slip angle $$\beta$$. Still, its linear velocity vector is orthogonal to line *OC*. 

By analogy with the [unicycle model][unicycle-model], and with the knowledge about [angular velocity][angular-velocity] we can derive base equations for point *C* motion: 

$$
\begin{cases}
\dot{x} = v \cos(\psi + \beta) \\
\dot{y} = v \sin(\psi + \beta) \\
\dot{\psi} = \omega = \frac v R \\
\end{cases}
$$

There are 2 unknowns in the system above: the rotation radius $$R$$ and the slip angle $$\beta$$. We'll need to use a bit of geometry to derive them from already known values. 

To find $$\beta$$, let's look closely at 2 triangles from the picture above, the big $$W_rOW_f$$ and the small $$W_rOC$$. First, we can show that angle at vertex *O*, $$\angle W_rOW_f = \delta$$. Indeed, if we consider the angle at the vertex $$W_f$$, we can see from the picture that : $$\angle W_rW_fO= \frac \pi 2 - \delta$$. Since the angle at vertex $$W_r$$ is right, we derive that $$\angle W_rOW_f = \pi - \left(\frac{\pi}{2} + \frac{\pi}{2} + \delta \right) = \delta$$.

With the similar reasoning for the small triangle $$W_rOC$$ we can show that the angle at vertex O: $$\angle W_rOC = \beta$$.

Using these triangles, let's find $$\beta$$. Since both are right triangles that share the side $$OW_r= R_1$$, we can derive that: 

$$
\begin{align}
   & \tan \beta = \frac{l_r}{R_1} \\
   & \tan \delta = \frac{l_f + l_r}{R_1} \implies \frac{1}{R_1} = \frac{\tan \delta}{l_f + l_r} \\
\end{align}
\implies
\bbox[10px, lightgray]{ \tan \beta = \frac{l_r}{l_f + l_r} \tan \delta }
$$

Next, let's find the rotation radius $$R$$. Looking at the small triangle $$W_rOC$$ we can see that $$R$$, $$R_1$$ and $$\beta$$ are related so that $$\cos \beta = \frac{R_1}{R}$$. Since we already have equations for $$\beta$$ and $$R_1$$ from previous equations, solve for $$\frac{1}{R}$$: 

$$
\cos \beta = \frac{R_1}{R} \implies 
\bbox[10px, lightgray] {
\frac{1}{R} = \frac{1}{R_1} \cos \beta = \frac{\tan \delta}{l_f + l_r} \cos \beta
}
$$

Now we can substitute $$\frac{1}{R}$$ into the equation for $$\dot{\psi}$$ and get the complete set of differential equations for our bicycle model: 

$$
\bbox[10px, lightgray]{
\begin{cases}
\dot{x} = v \cos(\psi + \beta) \\
\dot{y} = v \sin(\psi + \beta) \\
\dot{\psi} = \frac{v}{l_f + l_r} \cos \beta \tan \delta \\
\end{cases}

\quad \text{where} \quad

\beta = \tan^{-1}\left( \frac{l_r}{l_f + l_r} \tan \delta \right)
}
$$

## Special reference points

The equations above allow us to choose the reference point *C* anywhere on the vehicle axis. There are two specific locations where the angle $$\beta$$ basically goes away and the equations become much simpler. In particular, when we choose to put a reference point to the rear axle, $$\beta$$ becomes 0. Similarly, for the front axle, $$\beta$$ becomes equal to the steering angle $$\delta$$. That allows for a few simplifications to the model: 

$$
\text{Rear axle } (\beta = 0)  \qquad
\begin{cases} 
\dot{x} = v \cos \psi \\
\dot{y} = v \sin \psi \\
\dot{\psi} = \frac{v}{L} \tan \delta \\
\end{cases} 
$$


$$
\text{Front axle } (\beta = \delta)  \qquad
\begin{cases}
\dot{x} = v \cos(\psi + \delta) \\
\dot{y} = v \sin(\psi + \delta) \\
\dot{\psi} = \frac{v}{L} \sin \delta \\
\end{cases}
$$

Here, *L* is the total length of the vehicle frame, no need to account for rear and front parts separately. 

## What's next

Okay, so now we have a set of state equations that describe a kinematic bicycle model. Now it's time to put them into use and see if we can predict the car's trajectory. Stay tuned for the next exercise! 

[unicycle-model]: {{ site.baseurl }}{% post_url 2021-05-18-2d-kinematic-modelling %}
[angular-velocity]: {{ site.baseurl }}{% post_url 2021-05-20-angular-velocity %}
[more-angular-velocity]: {{ site.baseurl }}{% post_url 2021-05-22-more-about-angular-motion %}