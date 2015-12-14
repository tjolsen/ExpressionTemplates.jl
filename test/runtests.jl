using ExpressionTemplates
using Base.Test

println("Testing vvops")
include("vvop_tests.jl")

println("Testing vsops")
include("vsop_tests.jl")

println("Testing vfuncs")
include("vfunc_tests.jl")