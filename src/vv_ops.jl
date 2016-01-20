# This file uses metaprogramming to generate the types and operators for
# vector-vector elementwise operations (eg: addition)


vvops = [:+, :-, :.*, :./]
vvop_names = [:ET_vvplus, :ET_vvminus, :ET_vvdtimes, :ET_vvddivide]

for i = 1:length(vvops)
    op = vvops[i]
    opname = vvop_names[i]
    eval(quote
         immutable $opname{T,R, ET1<:VectorizedExpression, 
         ET2<:VectorizedExpression} <: VectorizedExpression{T,R}
         lhs::ET1
         rhs::ET2
         end
         
         @inline function getindex(A::$opname, i...)
         return $op(A.lhs[i...], A.rhs[i...])
         end
         
         @inline function length(A::$opname)
         return length(A.lhs)
         end
        
        @inline function size(A::$opname)
            return size(A.lhs)
        end
        
        @inline function ($op){T,R}(lhs::VectorizedExpression{T,R}, rhs::VectorizedExpression{T,R})
            return $opname{T,R,typeof(lhs), typeof(rhs)}(lhs,rhs)
        end
        export $op, $opname
    end)
end
