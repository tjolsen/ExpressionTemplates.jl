# open up a block to limit scope and lifetime of everything to 
# ensure no cross-talk between tests
begin
    
    N = 500    
    
    A = rand(N)
    a = rand()
    
    #addition
    @et add_et = a + A + a
    add_native = a + A + a
    
    @test add_native == add_et

    #subtraction
    @et sub_et = A - a
    sub_native = A - a
    
    @test sub_native == sub_et

    #multiplication
    @et mult_et = a*A*a
    mult_native = a*A*a
    
    @test mult_native == mult_et

    #division
    @et div_et = A/a
    div_native = A/a
    
    @test div_native == div_et
    
end