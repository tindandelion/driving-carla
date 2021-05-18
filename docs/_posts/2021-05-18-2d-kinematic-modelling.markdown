---
layout: post
title:  "Kinematic modeling in 2D"
math: true
---
Our next task will be to predict car's trajectory, given its current settings. That predicted trajectory will be passed to the simulator and displayed along with the planned trajectory. Put formally, we need to develop a *vehicle motion model* that could help us solve the following task: 

    Given car's current velocity and steering angle, 
    predict it's position at any time.

Let's dive into how this problem can be solved.

## Types of vehicle models

Generally, there are 2 types of vehicle motion models:

* **Kinematic models**. These models are a pure geometry. They deal with car dimensions and the constraints they put on movement. These models do a good job modeling car behavior at low speeds, when the accelerations are not significant. They are relatively simple and don't require a lot of calculations.

* **Dynamic models**. These models take into consideration forces and moments that act on a vehicle. They predict car motion using Newton's laws of motion. These models are more complicated than kinematic models, but they estimate vehicle motion more accurately in a wider range of conditions. 

In this project, we'll only deal with kinematic modeling. 

## State-based model of a unicycle

Let's take a look at the simplest possible wheeled vehicle: a *unicycle*. This vehicle can move forward with the velocity $$v$$ at the heading $$\theta$$. It can can turn left or right with some angular velocity $$\omega$$. By geometric constraints, $$v$$ is always tangential to its trajectory.

<p  style="text-align: center;">
    <img src="{{ site.baseurl }}{% link images/unicycle-model.png %}" alt="Unicycle model">
</p>

Such type of model is called *a state-space model*. A *state* is a set of variables that fully describe the system at the current time. The state can change over time, and it can also be affected by external factors, which act as *inputs* to the model. The model describes how the state evolves with time in response to the inputs. These laws of change are represented by the very specific form of first order differential equations:

$$
\begin{cases}
\dot{x}_1 = f_1(x_1, x_2, \ldots, x_n, u_1, u_2, \ldots, u_m) \\
\dot{x}_2 = f_2(x_1, x_2, \ldots, x_n, u_1, u_2, \ldots, u_m) \\
... \\
\dot{x}_n = f_n(x_1, x_2, \ldots, x_n, u_1, u_2, \ldots, u_m) \\
\end{cases}
$$

where $$\mathbf{x} = [x_1, x_2, \ldots, x_n]$$ is a state vector, and $$\mathbf{u} = [u_1, u_2, \ldots, u_m]$$ is a vector of inputs. We have the derivatives on the left side, and functions of current state and inputs on the right side. 

In case of the unicycle model, the state vector is coordinates and heading $$[x, y, \theta]$$; the input vector is velocities $$[v, \omega]$$.

#### From continuous to discrete time

One very convenient property of having a vehicle model in a space-state form is that it can easily be transformed into a set of equations once we move to the discrete time domain. For example, for the unicycle model from above we can easily derive the equations to calculate its trajectory: 

$$
\begin{cases}
x_{k+1} = x_k + v \cdot \cos{\theta_k} \cdot dt \\
y_{k+1} = y_k + v \cdot \sin{\theta_k} \cdot dt \\
\theta_{k+1} = \theta_k + \omega \cdot dt \\
\end{cases}
$$

And that becomes the basis for the next step: deriving the kinematic vehicle model in our project.