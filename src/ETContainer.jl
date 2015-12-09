import Base.getindex, Base.setindex!

immutable ETContainer{T,R} <: VectorizedExpression{T,R}
    data::Array{T, R}
end

function ETContainer{T,R}(A::VectorizedExpression{T,R})
    dat = Array{T,R}(size(A)...)
    @inbounds for i = 1:length(dat)
        dat[i] = A[i]
    end
    return ETContainer(dat)
end

@inline function getindex{T,R}(A::ETContainer{T,R}, i...)
    return A.data[i...]
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