# *【Visualization for Jazz Musicians】*



## Abstract

****

## Table of Contents

* 1  Introduction

  +  1.1 Motivation

  + 1.2 Jazz Musicians

* 2  The Data
  
  + 2.1 Collection
  + 2.2 Text-Mining 
  + 2.3 One Hot Encoding
  + 2.4 The Data
  
* 3  Formulations

  * 3.1 The Data Matrices

  + 3.2 Multi-value Classification
    - 3.2.1 Cluster
    - 3.2.2 Three Primary Colors
  + 3.3 Affinity Matrix
    + 3.3.1 Jaccard
    + 3.3.2 LDA
  + 3.4 Dimension Reduction
    + PCA
    + t-SNE

* 4  Results and Discussions

  * 4.1 Affinity Matrices
    + 4.1.1 Jaccard
    + 4.1.2 Combination

  + 4.2 Dimension Reduction
    - 4.2.1 PCA
    - 4.2.2 t-SNE

  + 4.3 Visualizing
    - Main Plot
    - Zoom-in
    - Weight
      - Instruments
      - Active Years
      - Record Labels
      - Genres

* 6  Conclusions -- Review and Remark

* References

* Appendix 

  * Python Code

  * R Code

  * Combination with Jaccard

****

## 1  Introduction

### 1.1 Motivation

On the website Linked Jazz, They visualized the relationship between jazz musicians by network plot, then we were curious about the algorithm of the plot and the distance between two musicians. However, we couldn't find the method of constructing the plot, Even the distance doesn't illustrate the relationship between musicians. Thus, we decide to use statistical methods to visualize the map similar to linked jazz.

### 1.2 Jazz Musicians

It is too many to collect all of the musicians in Linked Jazz, thus we started with Wynton Marsalis and Roy Hargrove at the suggestion of Prof. Guang-Hao Wei from the Department of Music at National Dong Hwa University. For constructing the musicians' name list, we considered starting with the property called "associatedMusicalArtist" on their information page on DBpedia. Wynton Marsalis and Roy Hargrove are the "initial points", and the musicians that showed on their "associatedMusicalArtist" are the first layer. The musicians collected from the "associatedMusicalArtist" of the musicians in the first layer are in the second layer. The union of the first and second layers constructs a complete musicians' name list that includes Wynton Marsalis and Roy Hargrove.

* fig-DBpedia: "associatedMusicalArtist" 

****

## 2  The Data

This section will display the data of the musicians in the list we created in the last section collected from DBpedia. The method that the original categorical data becomes the numerical data matrices.

### 2.1 Collection

It is really simple to collect the data by python crawler. We constructed a simple python code to take the data from the website and save the data into the matrix we created. The matrix includes  229 rows of musicians and 4 columns the information about musicians including instruments, genres, active years, and record labels. For the matrix, we turned it into 4 parts of information and cleaned each part.

* fig-data matrix with four information

### 2.2 Text Mining 

Text mining significantly is a powerful technique to clean text data. Especially in our data, text mining is good at dealing with tokens and characters. However, we only use text mining to split the tokens from the collection of words. For example in our data for only instrument information, there is a musician called Wynton Marsalis who is a composer and trumpeter, so the "composer" and "trumpeter" is in Wynton Marsalis' row for the same column. Hence, we should split out these two tokens from a column, and save them.

(1) A column called "instrument" in Wynton Marsalis' and Roy Hargrove's row

|                 | Instrument                                  |
| --------------- | ------------------------------------------- |
| Wynton Marsalis | "composer", "trumpeter"                     |
| Roy Hargrove    | "composer", "trumpeter", "vocalist", "horn" |

(2) Save them into a musicians' list
$$
Wynton\;Marsalis = \{composer, trumpeter\}\\
Roy\;Hargrove = \{composer, trumpeter, vocalist, horn\}
$$
Then we have the information for all 229 musicians.

### 2.3 One Hot Encoding

The main work that switches the categorical data to numerical data is one-hot encoding. Continuing the example from the last subsection, we will take the union of the member in the musicians' list as a column and the union of the musicians as a row for the instrument's matrix. If the musician can play the instrument then we put "1", and if not then put "0".

(1) The union of list
$$
Instrument = \{composer, trumpeter, vocalist, horn\}
$$
(2) 0-1 matrix by One-hot encoding

|                 | composer | trumpeter | vocalist | horn |
| --------------- | -------- | --------- | -------- | ---- |
| Wynton Marsalis | 1        | 1         | 0        | 0    |
| Roy Hargrove    | 1        | 1         | 1        | 1    |

### 2.4 The Data

By text mining and one hot encoding, we got four matrices with different information. 

* Instruments matrix
* Genres matrix
* Record labels matrix
* Active years matrix

****

## 3  Formulations

In this section, we show the techniques for multi-value classification problems, constructing affinity matrix, and visualizing. 

### 3.1 The Data Matrices

Completing the data matrices after using text mining and one-hot encoding, we have four data with different information. The instruments, active years, record labels, and genres are the information of data matrices.

### 3.2 Multi-value Classification

Therefore, We present a solution for the Multi-value (also called Multi-label) classification problem. However, The Multi-value makes the data harder to classify. For example, if a jazz musician can play more than one instrument, then he/she couldn't be classified by any category. Thus it also leads to difficulty with coloring figures. In this subsection, we will use the principle component analysis (PCA) to compress the information and view the clusters on the PCA map. If we can classify the categories of information into 3 groups, then it is easy to use a color system to color the point on the maps. 

#### 3.2.1 Cluster

First, we need to compress the data into lower dimensions, maybe those information columns could be classified into a few classes. We use another version of the principle component analysis (PCA)

#### 3.2.2 Three Primary Colors

The CMYK is a kind of color system and also a normal color system, it uses cyan, magenta, and yellow to tone all of the colors. There are 3 groups with 3 different colors, we compute the percentage of each color by the numbers in a group. It means when the original data is p-dimensional. For example, there is data x_1= (1, 0, 0, 1, 1, 0, 1, 1, 1) with nine variables, and we classify them into 3 groups by PCA map in the last little subsection. The first three variables (v1, v2, v3) are the first group (group1), and so does the middle three and the last three. 

(1) Original 9-dimensional data

|   |v1|v2|v3|v4|v5|v6|v7|v8|v9|
|---|--|--|--|--|--|--|--|--|--|
|X_1| 1| 0| 0| 1| 1| 0| 1| 1| 1|

* v1, v2, v3: group1, and group1 = v1+v2+v3
* v4, v5, v6: group2, and group2 = v4+v5+v6
* v7, v8, v9: group3, and group3 = v7+v8+v9

(2) Three groups of data

|   |group1|group2|group3|
|---|------|------|------|
|x_1|      1|     2|    3|

From group data to a color system, we construct really simple computing, dividing the sum of rows.

(3) Percentage of three primary colors in CMYK color system

|      | Cyan         | magenta      | yellow    |
| ---- | ------------ | ------------ | --------- |
| x_1  | 1/6 = 0.1666 | 2/6 = 0.3333 | 3/6 = 0.5 |

The percentage of three primary colors, could show the information of clusters on the map clearly.

### 3.3 Affinity matrix

#### 3.3.1 Jaccard

Jaccard is a technique for computing the similarity between two vectors. Since we have the similarity value, it's easy to complete the affinity matrix by this technique. 

* similarity Jaccard
   $$
   Let\;x=(x_1,\cdots,x_p),y=(y_1,\cdots,y_p)\in\mathbb{R^p},\\
   x_i,\;y_i=0,1,\;\forall\;i=1,\cdots,p\\
   sim(x,y)=\cfrac{\#(x\cap{y})}{\#(x\cup{y})}
   $$

* affinity matrix Jaccard
   $$
   Let\;\mathbb{X}=\begin{pmatrix}
   x_{1}\\
   x_{2}\\
   \vdots\\
   x_{n}
   \end{pmatrix},\;{x}_{i}\in\mathbb{R}^p\;\forall\;i=1,\cdots,n\\
   \\
   affin(\mathbb{X})=\begin{pmatrix}
    1 & sim(x_1,x_2)&\cdots &  sim(x_1,x_n)\\
    sim(x_2,x_1)&1&\cdots &   sim(x_2,x_n)\\
   \vdots & \vdots & \ddots & \vdots \\
    sim(x_n,x_1) & sim(x_n,x_2)& \cdots & 1
   \end{pmatrix}
   $$

#### 3.3.2 LDA

### 3.4 Dimension Reduction

After finishing the affinity matrices, we got the pairwise similarity of those musicians, and dimensional reduction is the method to plot on a 2D or 3D map. Dimension reduction is a kind of visualization method, the core component is turning the high dimension data into 2 or 3-dimension because we couldn't illustrate with the data that is more than 3-dimension. Hence, we will introduce a traditional dimension reduction method called the principle component analysis (PCA) and another statistical visualization method called t-distributed stochastic neighbor embedding (t-SNE).

#### 3.4.1 PCA

#### 3.4.2 t-SNE

****

## 4  Results and Discussions

The results section will present the progress from the data matrix to the visualizing plots in the last section, that's the core structure of this thesis. 

### 4.1 Affinity Matrices

#### 4.1.1 Jaccard

In the formulation section, we introduce how to compute the affinity matrix by Jaccard, and now our data become a matrix with similarity. Hence, we finally get the four information affinity matrices that include instruments, genres, record labels, and active years.

#### 4.1.2 Combination

To combine the information on instruments, genres, record labels, and active years, we took the square root of the sum of squares, and let it become an affinity matrix with all information. 

$$
\mathcal{X}_{all}=\sqrt{\mathcal{X}_{Inst}^2+\mathcal{X}_{Gen}^2+\mathcal{X}_{AYs}^2+\mathcal{X}_{RecLa}^2}
$$

### 4.2 Dimension Reduction

For visualizing, there are too many methods. In fact, dimension reduction is also a kind of visualization method, because when we compress the dimension to two or three, we could easily make a plot by those data in 2-D or 3-D mapping.

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

## References

****

## Appendix 

* Python Code
* R Code
* Combination with Jaccard

 
