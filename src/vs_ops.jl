# This file uses metaprogramming techniques to implement vector-scalar and scalar-vector
# operations (eg: scaling)

vsops = [:*, :+, :-, :/, :./, :.*]
vsopnames_l = [:ET_vsltimes, :ET_vslplus, :ET_lminus, :ET_ldiv, :ET_lddiv, :ET_ldtimes]
vsopnames_r = [:ET_vsrtimes, :ET_vsrplus, :ET_rminus, :ET_rdiv, :ET_rddiv, :ET_rdtimes]

# generate rhs ops
for i = 1:length(vsops)
    op = vsops[i]
    opname = vsopnames_l[i]
    
    eval(quote
         immutable $opname{T,R,ET1<:VectorizedExpression, ET2<:Number} <: VectorizedExpression{T,R}
         lhs::ET1
         rhs::ET2
         end
         
         @inline function getindex(A::$opname, i...)
         return $op(A.lhs[i...], A.rhs)
         end
         
         @inline function length(A::$opname)
         return length(A.lhs)
         end
         
         @inline function size(A::$opname)
             return size(A.lhs)
         end
        
        
        @inline function ($op){T,R}(lhs::VectorizedExpression{T,R}, rhs::Number)
            return $opname{typeof($op(T(0),rhs)),R,typeof(lhs), typeof(rhs)}(lhs, rhs)
        end
        
        export $op, $opname
    end)
end

#generate lhs ops
for i = 1:length(vsops)
    op = vsops[i]
    opname = vsopnames_r[i]
    
    eval(quote
         immutable $opname{T,R,ET1<:Number, ET2<:VectorizedExpression} <: VectorizedExpression{T,R}
         lhs::ET1
         rhs::ET2
         end
         
         @inline function getindex(A::$opname, i...)
         return $op(A.lhs, A.rhs[i...])
         end
         
         @inline function length(A::$opname)
         return length(A.rhs)
         end
         
         @inline function size(A::$opname)
             return size(A.rhs)
         end
        
        @inline function ($op){T,R}(lhs::Number, rhs::VectorizedExpression{T,R})
            return $opname{typeof($op(T(0),lhs)) ,R,typeof(lhs), typeof(rhs)}(lhs, rhs)
        end
        
        export $op, $opname
    end
    )
end
