# This file generates types and function overloads for specified functions acting on VectorizedExpressions
# The list of functions is not complete, and is restricted to those that naturally operate
# index-by-index on an an expression.

import Base.exp, Base.expm1, Base.log, Base.log10, Base.log1p, Base.sqrt, Base.cbrt, Base.exponent
import Base.significand, Base.sin, Base.sinpi, Base.cos, Base.cospi, Base.tan, Base.sec, Base.cot, Base.csc
import Base.sinh, Base.cosh, Base.tanh, Base.coth, Base.sech, Base.csch
import Base.asin, Base.acos, Base.atan, Base.acot, Base.asec, Base.acsc
import Base.asinh, Base.acosh, Base.atanh, Base.acoth, Base.asech, Base.acsch, Base.sinc, Base.cosc

# single-argument functions
univar_funcs = [:exp, :expm1, :log, :log10, :log1p, :sqrt, :cbrt, :exponent, :significand,
         :sin, :sinpi, :cos, :cospi, :tan, :sec, :cot, :csc, 
         :sinh, :cosh, :tanh, :coth, :sech, :csch,
         :asin, :acos, :atan, :acot, :asec, :acsc,
         :asinh, :acosh, :atanh, :acoth, :asech, :acsch, :sinc, :cosc]


immutable ET_univar_func{T, R, ET<:VectorizedExpression} <: VectorizedExpression{T,R}
    VE::ET
    f::Function
end

@inline function getindex(A::ET_univar_func, i...)
    return A.f(A.VE[i...])
end

@inline function length(A::ET_univar_func)
    return length(A.VE)
end

@inline function size(A::ET_univar_func)
    return size(A.VE)
end

export ET_univar_func

# Generate overloaded methods for all functions
macro gen_univar_funcs()

    for i = 1:length(univar_funcs)

        local op = univar_funcs[i]
        
        eval(quote
             
             @inline function ($op){T,R}(v::VectorizedExpression{T,R})
             return ET_univar_func{T,R, typeof(v)}(v, $op)
             end
             
             export $op
             end)
        

    end

end

@gen_univar_funcs