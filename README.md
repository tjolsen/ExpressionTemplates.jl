# ExpressionTemplates

Linux, OSX: [![Build Status](https://api.travis-ci.org/tjolsen/ExpressionTemplates.jl.svg?branch=master)](https://travis-ci.org/tjolsen/ExpressionTemplates.jl)

This package provides Julia with deferred evaluation of array expressions using a C++-style Expression Template framework.
The purpose of the package is to greatly accelerate the evaluation of
vectorized expressions by eliminating allocation of intermediate calculations.
For example, for scalar a, b, c, d, and length-N vectors A, B, C, D, the expression
**R = a\*A + b\*B + c\*C + d\*D**
requires the construction of *seven* temporary arrays.
A more optimal way to compute this is to allocate an output array
and compute the result index-by-index.
Expression templates exploit the language's type system to do precisely this, thus
avoiding the overhead of intermediate array allocations.

For this model problem, I have found peak speedups of 5.25x over the native array evaluation,
while a simple hand-coded loop, such as the one described above, only achieves 4x (on my machine).
The benchmark showing the speedup of expression templates vs a hand-coded loop is shown in the image.

![Performance Benchmark](benchmark.png)

# Installing the package

Right now, the package is not in the main Julia package management system.
I'm still writing tests and ensuring that everything is robust prior to publishing it there.
To get it now, just clone this repository and ensure that wherever you put it has the src/
directory on your LOAD_PATH (see http://docs.julialang.org/en/release-0.4/manual/modules/ for clarification).
One easy way to ensure that this works (on *nix systems at least) is to put this into 
the ~/.julia/v0.4/ directory, as all subdirectories of this folder are automatically added to LOAD_PATH.

# Using the package

As far as users are concerned, this package provides one thing: the @et macro.
This macro can be put at the beginning of a line or expression to trigger the usage
of expression templates.

```julia

N = 10000
A = rand(N)
B = rand(N)
C = rand(N)
D = rand(N)
a = rand()
b = rand()
c = rand()
d = rand()

result = a*A + b*B + c*C + d*D # <---native arrays are slow!

@et result2 = a*A + b*B + c*C + d*D # <--- expression templates are fast!

```

