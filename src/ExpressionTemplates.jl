module ExpressionTemplates

abstract VectorizedExpression{T,R}

# import some functions to overload
import Base.+, Base.-, Base.(.*), Base.*, Base.(./), Base./
import Base.length, Base.size

# include definition of ETContainer type
include("ETContainer.jl")

# include vector-vector operations
include("vv_ops.jl")

#include vector-scalar operations
include("vs_ops.jl")

#include vector functions
include("v_funcs.jl")

export VectorizedExpression

end # end module


#------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------
# Macro that does all of the magic! Just use the @et macro in front of expressions
#------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------
macro et(expr)
    if (typeof(expr) == Expr)
        if (expr.head == :call)
            local e = handle_expr(expr)
            return :(ETContainer($e).data)
        elseif (expr.head == :(=))
            return esc(:($(expr.args[1]) = ETContainer($(handle_expr(expr.args[2]))).data ))
        end
    end
end


# private recursive function to convert arrays into ETVectors, and let Julia + multiple dispatch run from there
function handle_expr(expr)
    
    if (typeof(expr) == Symbol)
        return :(__symbol_wrapper($expr))
        
    elseif (typeof(expr) == Expr)
        
        for i = 2:length(expr.args)
            expr.args[i] = handle_expr(expr.args[i])
        end
        return expr
        
    else
        return expr
    end
end

@generated function __symbol_wrapper{T,R}(x::Array{T,R})
    return :(ETContainer{T,R}(x))
end

@generated function __symbol_wrapper(x)
    return :x
end

#------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------
