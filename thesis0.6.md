# *【Visualization for Jazz Musicians】*



## Abstract



****

## 1  Introduction

### 1.1 Motivation

On the website Linked Jazz, They visualize the relationship between jazz musicians by network plot, then we were curious about the algorithm of the plot and the distance between two musicians. However, we couldn't find the method by that they construct the plot. Even the distance in the plot doesn't illustrate the relation between musicians.

### 1.2 Jazz Musicians

It is too large to collect all of the musicians in Linked Jazz, thus we started with Wynton Marsalis and Roy Hargrove at the suggestion of Prof. Guang-Hao Wei from the Department of Music at National Dong Hwa University.

****



## 2  Data Matrices

This section will display the data that was collected from the database DBpedia on the website Linked Jazz.

### 2.1 Collection

It is really simple to collect the data by python crawler.

The matrix includes  229 rows as musicians and 4 columns the information about musicians including instrument, genre, active years, and record label.

### 2.2 Text-Mining 

Text mining significantly is a powerful technique to clean text data.

### 2.3 One Hot Encoding

### 2.4 The Data

By text mining and one hot encoding, we got four matrices with different information.

****



## 3  Multi-value Classification

In this section, we present a solution for the Multi-value (also called Multi-label) classification problem. However, The Multi-value makes the data hard to classify. For example, if a jazz musician can play more than one instrument, then he/she couldn't be classified by any category. Thus it also leads to difficulty with coloring figures.

### 3.1 The data

These four data matrices from the last section are multi-value.

### 3.2 Methods

#### 3.2.1 Cluster

#### 3.2.2 Three Primary Colors

****



## 4  Visualization

### 4.1 Affinity Matrices

#### 4.1.1 Jaccard

Jaccard is a technique for making an affinity matrix.

#### 4.1.2 Combination

### 4.2 Dimension Reduction

#### 4.2.1 PCA

#### 4.2.2 t-SNE

### 4.3 Visualizing

* Main Plot

* Zoom-in

* Weight

  + Instruments

  + Active Years

  + Record Labels

  + Genres


****



## 5  Conclusions



****



## 6  Discussions



****



## References



****



## Appendix 

* Python Code
* R Code
* Combination with Jaccard

