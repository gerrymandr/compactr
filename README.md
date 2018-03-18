# compactr

Compactness scores in R for district shapes

Package dependencies:

* sf
* lwgeom (for Minimum Bounding Circle)

## Shape index compactness measures

A shape index expresses a ratio of area to perimeter. It is scaled
so that the most compact shape, a circle, has a score of 1,
with less compact shapes declining toward 0. Two commonly used measures
are Polsby-Popper and Schwartzberg. Polsby-Popper is conceptualized as the
ratio of the area of the district to the area of a circle with an equal
circumference. It is calculated as:

<!--\deqn{\frac{4 \pi Area }{Perimeter^{2} } }-->

![Polsby-Popper formula](images/polsby-popper-formula.png)

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

## Area-based compactness measures

Compactness may be expressed as the ratio of the area of a shape to the
area of some larger, enclosing shape. Two common measures are the
Minimum Convex Polygon and the Reock scores. Minimum Convex Polygon is the
ratio of the area of a shape to its convex hull. Reock is the ratio of the
area of a shape to its minimum bounding circle.

If the tested polygon is strictly convex, the area of the shape and its
convex hull will be equal and `area_convex_hull` will return 1. As the
minimum bounding circle always contains the convex hull, the Reock score
must be smaller than the Minimum Convex Polygon score, unless the shape is
a circle, in which case both scores will equal 1. For certain shapes, the
scores will diverge wildly. An eccentric but convex or nearly convex shape,
such as a cigar, will have a high (1 or near 1) Minimum Convex Polygon score
but a low (< 0.1) Reock score.

Convex Hulls and Minimum Bounding Circles should be created in a projected
coordinate system using a conformal projection. In practice, creating
convex hulls in geographic (lat-long) coordinate systems will introduce
minimal errors:

![](demo/convex_hull_demo.png)

Calculating Reock, which relies on Minimum Bounding Circles,
will be widly incorrect, and the direction of the error is unpredictable:

![](reock_demo.png)

