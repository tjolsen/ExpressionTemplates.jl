# open up a block to limit scope and lifetime of everything to 
# ensure no cross-talk between tests
begin
    
    N = 500
    
    A = rand(N)
    B = rand(N)
    C = rand(N)
    
    # addition
    @et add_et = A + B + C
    add_native = A + B + C
    
    @test add_et == add_native;

    #subtraction
    @et sub_et = A - B - C
    sub_native = A - B - C
    
    @test sub_et == sub_native;
    
    # elementwise mult
    @et dottimes_et = A .* B .* C
    dottimes_native = A .* B .* C
    
    @test dottimes_et == dottimes_native;

    # elementwise div
    @et dotdiv_et = A ./ B ./ C
    dotdiv_native = A ./ B ./ C
    
    @test dotdiv_et == dotdiv_native;
    
end


begin

    N = 50
    
    A = rand(N,N)
    B = rand(N,N)
    C = rand(N,N)

    #test order-2 arrays
    @et res_et = A+B+C
    res_native = A+B+C
    
    @test res_et == res_native


end


begin

    N = 15
    
    A = rand(N,N,N)
    B = rand(N,N,N)
    C = rand(N,N,N)

    #test order-3 arrays
    @et res_et = A+B+C
    res_native = A+B+C
    
    @test res_et == res_native

    # test .* and ./
    @et res_et = A.*B./C
    res_native = A.*B./C
    
    @test res_et == res_native
end