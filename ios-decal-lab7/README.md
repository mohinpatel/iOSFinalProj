# Lab 7 : Calculator #

## Due Date ##
Tuesday, April 25th at 11:59 pm

## Overview ##

In today's lab, you'll be adding functionality to a very simple calculator app written in Objective C (*no Swift! - Try it, it won't work :)*). By the end of this lab, you will have a feel not only for how objective c is written but also how different it is from swift. Below is an example of what we are looking for in your submissions.

![](/README-images/README-1.png)

## Getting Started ##

To begin the lab, clone the repository onto your personal computer (After you've forked it of course).
	
	git clone https://github.com/YOUR-USERNAME/ios-decal-lab7

To push your changes for the lab, run the following commands in your lab-7 folder.

	git add .
	git commit -m "Finished lab 7"
	git push origin master
	
Once you have done this, you can view the files you pushed at https://github.com/YOUR-USERNAME/ios-decal-lab7. You can then use this repository to submit via Gradescope when you are finished (see the **Submission** section below).
## Lab Overview: Add a custom function to the calculator. ##
If you run the project, you can see that there is indeed a fully functional calculator application. However, it might not have all the functions you use on a daily basis here at Berkeley! Therefore, we have left a button blank (It is colored blue) so that you can add your own custom function! For example, right next to the AC (All Clear) button, there is a "tan" button that takes tan(x) where x is the current value displayed. Your custom function should be implemented in a similar way!
The project files are outlined below; if you're feeling confident, you can skip over those and start the implementation. Be sure you understand the starter code though.

## Part 1: Understanding the code ##

A large portion of this lab will be understanding what the heck is going on! As usual, this lab follows MVC, which will make it a lot easier to see what is happening. Here are the important files:
 - `Main.storyboard` - All the autolayout has been done for you so the blue colored button's label text will be the only thing you should be changing to indicate what your function is to the user.
 - `ViewController.m` - This takes care of updating the view that you see on the screen - notice how all the actual calculation tasks have been abstracted away to `_Cbrain`: The calculator brain. You will have to modify this file by adding your own methods - refrain from making instance variables though as this violates the abstraction.
 - `CalculatorBrain.m` - This, as the name indicates, is the brain of the calculator. There are many functions here and you'll notice right away that this file could have been 1/4 the length if we did it in swift. However, while objective c is known for being verbose, this adds a lot of clarity and a lower-level understanding of what the code is doing, so that's why we still use it. You can create as many instance variables and methods as you'd like in this class. Remember, if you need to reference the properties and methods from `ViewController`, make sure to add declarations of these in the interface file.
 - `.h files` - These are interface files, meaning they are what are used in import statements and have the ability to make other methods available outside that particular class.
## Part 2: Implementing your own feature ##

You can implement any function of your choice as long as it either works like:
 - `tan(x)` - Takes in one operand and updates the `calculationView` accordingly.
 - `add/multiply/subtract(x,y)` - Takes the first operand, waits for action to be pressed, and then takes the second operand and then updates `calculationView` only when the `=` button is presed.
## Grading ##
Once you have finished, please submit your files to [Gradescope](https://gradescope.com/courses/5482). You will need to submit files EVEN if you are being checked off. We have enabled group submission for this assignment, so make sure to include your partner's name if you only worked on one computer.

To submit, please upload your code to either GitHub or Bitbucket, and use the "Github" or "Bitbucket" submission feature on Gradescope. Please check out the [slides in Lecture 3](http://iosdecal.com/Lectures/Lecture3.pdf) for step-by-step submission instructions if you're confused about how to do this (or ask a TA!)

Checkoff Form for  Akilesh's Lab - https://goo.gl/forms/0x2P8vpGRWar7nIX2

Checkoff Form for Paige's Lab - https://goo.gl/forms/pyEZRbaMXjTnFgas2
