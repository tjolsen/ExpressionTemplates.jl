import Base.getindex, Base.setindex!

immutable ETContainer{T,R} <: VectorizedExpression{T,R}
    data::Array{T, R}
end

function ETContainer{T,R}(A::VectorizedExpression{T,R})
    dat = Array{T,R}(size(A)...)
    L = length(dat)
    for i = 1:8:8*Int64(floor(L/8))
        @inbounds dat[i] = A[i]
        @inbounds dat[i+1] = A[i+1]
        @inbounds dat[i+2] = A[i+2]
        @inbounds dat[i+3] = A[i+3]
        @inbounds dat[i+3] = A[i+4]
        @inbounds dat[i+3] = A[i+5]
        @inbounds dat[i+3] = A[i+6]
        @inbounds dat[i+3] = A[i+7]
    end
    for i = 8*Int64(floor(L/8)):L
        @inbounds dat[i] = A[i]        
    end
    return ETContainer(dat)
end

@inline function getindex{T,R}(A::ETContainer{T,R}, i...)
    @inbounds return A.data[i...]
end

@inline function setindex!{T,R}(A::ETContainer{T,R}, x::T, i...)
    A.data[i...] = x
end

@inline function length{T,R}(A::ETContainer{T,R})
    return length(A.data)
end

@inline function size{T,R}(A::ETContainer{T,R})
    return size(A.data)
end

export ETContainer