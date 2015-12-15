begin
    

    # Test matrix multiplication
    N = 20
    
    A = rand(N,N)
    B = rand(N,N)
    C = rand(N,N)
    D = rand(N,N)
    a = rand(N)
    b = rand(N)
    c = rand(N)
    d = rand(N)
    
    @et res_et = (A+B+C+D)*(C+D)
    res_native = (A+B+C+D)*(C+D)
    
    @test res_et == res_native
    
    
    #test matrix-vector multiplication
    @et res_et = (A+B+C+D)*(a+b+c+d)
    res_native = (A+B+C+D)*(a+b+c+d)
    
    @test res_et == res_native


    # Ensure memory allocation is lower for @et case
    mem_et = @allocated (@et (A+B+C+D)*(a+b+c+d))
    mem_native = @allocated  (A+B+C+D)*(a+b+c+d)
    
    @test mem_et < mem_native
end


