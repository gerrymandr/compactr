# compactr

Compactness scores in R for district shapes

Package dependencies:

* sf
* lwgeom (for Minimum Bounding Circle)

## Shape index compactness measures.

A shape index expresses a ratio of area to perimeter. It is scaled
so that the most compact shape, a circle, has a score of 1,
with less compact shapes declining toward 0. Two commonly used measures
are Polsby-Popper and Schwartzberg. Polsby-Popper is conceptualized as the
ratio of the area of the district to the area of a circle with an equal
circumference. It is calculated as:

\deqn{\frac{4 \pi Area }{Perimeter^{2} } }

Schwartzberg is conceptualized as the ratio of the perimeter of the district
to the circumference of a circle with an equal area. Although the formula
is usually expressed distinctly, it is equivalent to the square root of
Polsby-Popper, and that is how it is calculated in this function.

Shape indexes will be lower for
"skinny" shapes, those that are wider in one direction than another. The
score will also be lower for more convoluted perimters. The score is
therefore impacted by the coastline paradox, and will also vary with the
degree of generalization of the input data, i.e. more highly generalized
(smoother) polygons will produce higher compactness scores.

For lat-long coordinates, this function relies upon the behavior of
`st_area` and `st_length`, which will calculate geodetic areas and lengths.


