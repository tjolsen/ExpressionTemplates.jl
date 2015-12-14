begin

    N = 100
    
    A = rand(N)
    
    #stack up some functions
    @et res_et = exp(cos(sin(A)))
    res_native = exp(cos(sin(A)))
    
    @test res_et == res_native
end