---
layout: post
title:  "Car simulators for this project"
---
In this post, I'd like to describe in greater details which self-driving cars simulators I'm going to be using throughout the project, and why. There are two of them I've known so far: one general-purpose open-source simulator named [CARLA][carla-home], and another one developed by Udacity learning platform specifically for their [Self-Driving Car Engineer Nanodegree][udacity-sdce-nanodegree]. 

Since my end goal is to accomplish a final project at Coursera's [Introduction to Self-Driving Cars][coursera-link], eventually I will have to use CARLA simulator. However, for reasons described below I'll be using Udacity's simulator along the way.

## CARLA simulator 

[CARLA][carla-home] is an open-source project, developed by a team with members from the industry's leaders, such as Intel and Toyota. It is an ultimate Swiss Army knife of a simulator software, which basically creates the entire virtual worlds inside with the use of Unreal game engine. It allows you to simulate and test various tasks, from computer vision to localization to actual driving. The simulation can be controlled with an external client that can be used to send commands to the vehicle, record data and automatically execute various scenarios. 

However, there's one major drawback to all that beauty: it lacks Mac OS support. There are versions for Windows and Linux, but not for Mac. Worse, due to its hardware requirements - video card, basically - virtualization is not an option either. At least, for me it refused to start under VirtualBox and VMWare Fusion. 

There's a way to run Carla on GPU-powered instances in AWS, though, thanks to [this instruction][carla-aws]. But still, using that setup as a primary development environment is very inconvenient, let alone it's quite expensive: the cost of running that type of EC2 instance is about $1 per hour. 

Since I don't have access to a suitable Windows or Linux workstation, and using dual-boot on my Mac is not an option for various reasons, I had to turn to another simulator I'd known about: the one from Udacity. 

## Udacity simulator

Udacity developed their own set of simulator applications for students participating in their [Self-Driving Car Engineer Nanodegree][udacity-sdce-nanodegree] which, humbly mentioning, I [successfully completed][my-sdce-certificate] a few years ago. Unlike CARLA, their simulators are much simpler and basically tailored to the needs of that nanodegree's specific projects. There are Mac versions, also. I remembered that in one particular project, Model Predictive Control, we used a simulator that could suit me as a "working horse" in my current project as well. 

Although the nanodegree itself is behind a paywall, the simulator is freely available to [download][udacity-simulator]. There's also source code for Model Predictive Control project template, [available on GitHub][mpc-project]. Using that startup code as a reference, essentially anyone can develop their own controllers to drive the car inside the simulator. 

Eventually, I decided to use Udacity's simulator in my experiments and develop a controller in Python. Once I've developed the version that successfully runs the car inside that simulator, I'll port the solution to CARLA simulator and use an Amazon EC2 instance for final tests and to collect the report to submit to Coursera. 

It's going to be fun to see how it all works out!


[carla-home]: https://carla.org/
[udacity-sdce-nanodegree]: https://www.udacity.com/course/self-driving-car-engineer-nanodegree--nd013
[coursera-link]: https://www.coursera.org/learn/intro-self-driving-cars
[carla-aws]: https://github.com/jbnunn/CARLADesktop
[my-sdce-certificate]: https://confirm.udacity.com/P2NTNJSZ
[mpc-project]: https://github.com/udacity/CarND-MPC-Project
[udacity-simulator]: https://github.com/udacity/self-driving-car-sim/releases/tag/v1.45

