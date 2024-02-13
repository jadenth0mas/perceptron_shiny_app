# Perceptron Shiny Application

**Table of Contents:**<br>
-- [Tools Used](#item-one)<br>
-- [Problem Description](#item-two)<br>
-- [Application Description](#item-three)<br>
---- [Plot](#item-four)<br>
---- [Summary](#item-five)<br>
---- [Data](#item-six)<br>
---- [Iris Dataset](#item-seven)<br>
-- [Conclusion](#item-eight)<br>
-- [Sources](#item-nine)<br>


<a id="item-one"></a>

## Tools Used

The tools used for this project are R and RShiny.

The R library dependencies are shiny, tidyverse, shinythemes, geometry, and ggthemes.

<a id="item-two"></a>

## Problem Description

A shiny application was developed to visualize and show how perceptrons are used in binary classifiecation, with an example dataset, iris, and generated datasets. The perceptron model is fit on the data to classify it into two categories.

The formula is $$Y_i=f(w \cdot x_i)$$ Where $w=[\beta_0, \beta_1,...,\beta_p]$, the weights found for given predictors, and $x_i=[1, x_{1i}, x_{2i},...,x_{pi}]$, the p predictor variables and a bias term 1. The function $f(x)$ is the step function defined by $$f(x) = \left\{ \begin{array}{ll} 1 \quad x > 0 \\ -1 \quad x<0 \end{array} \right.$$

The perceptron model is trained to either until all points are classified correctly or a maximum number of learning iterations is reached.

The weights are updated by the formula $$w=w*\ell*(y_i-\tilde{y_i})*x_i$$ Where $\ell$ is the learning rate, $\tilde{y}\in (-1, 1)$ is the predicted value, and $w$ and $x$ are defined the same as before.

This model can be used for binary classification by labeling one category $1$ and the other $-1$, and using the predictors $x$ to classify an observation.

<a id="item-three"></a>

## Application Description


<a id="item-four"></a>

### Plot

The first page either lets a user view the example model trained on the Iris dataset or create a random dataset to train a model on. 

The created dataset is made by randomly generating a user inputted $n$ observations from a $x_i\sim Unif(-1,1)$ distribution in R using the runif() function and inputted seed as the random seed to set before the numbers are generated. The function creates a dataset with 2 predictors, a linearily seperable response variable, found by randomly generating an intercept and slope from the same uniform distribution. The function can be found in the perceptron.r file.


<a id="item-five"></a>

### Summary

The summary page shows how many training iterations happened until the model either classified all training points correctly or the maximum number of iterations was reached. It also shows the contingency table between the predicted and test categories. The left side also allows for predictions to be made off of the two predictor variables, showing the prediction on the button click.

<a id="item-six"></a>

### Data

The data page shows the actual full dataframe on which the model is trained, and the test cases are a part of. It shows all predictors, even those not used in the model.


<a id="item-seven"></a>

### Iris dataset

The dataset used for the example was Edgar Anderson's Iris data, which includes 150 rows and 5 variables named Sepal.Length, Sepal.Width, Petal.Length, Petal.Width, and Species. The original dataset had three species in it, <i>Iris setosa</i>, <i>versicolor</i>, and <i>virginica</i>. <i>Iris setosa</i> and <i>versicolor</i> were used as the two classes for the perceptron model, with Sepal.Length and Petal.Length being the predictors.

![Iris flower](iris.jpg)

<a id="item-eight"></a>

## Conclusion

As seen, perceptron works very well with separable data. Extensions and future development of this application will focus on implementing more example datasets, and more options to be able to add user entered datasets, such as from csv files. Another important thing would be to test the application with non-separable and to evaluate the model with more metrics.

## Sources

https://link.springer.com/article/10.1007/BF02478259 <br>
https://onlinelibrary.wiley.com/doi/10.1111/j.1469-1809.1936.tb02137.x <br>
https://www.jstor.org/stable/2394164?origin=crossref <br>
https://www.sciencedirect.com/topics/mathematics/virginica <br>