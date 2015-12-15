# This file contains special cases that help make the library more useful


# Matrix-matrix multiplication
function *{T}(lhs::VectorizedExpression{T,2}, rhs::VectorizedExpression{T,2})
    return ETContainer( (ETContainer(lhs).data)*(ETContainer(rhs).data) )
end

# Matrix-vector multiplication
function *{T}(lhs::VectorizedExpression{T,2}, rhs::VectorizedExpression{T,1})
    return ETContainer( (ETContainer(lhs).data)*(ETContainer(rhs).data) )
end

export *