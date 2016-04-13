using ExpressionTemplates
using PyPlot

Niters = 1000
NN = collect(1:.0625/2:7.25)

et_times = zeros(length(NN))
native_times = zeros(length(NN))
loop_times = zeros(length(NN))


function loop_kernel(w,a,x,b,y,c,z,d,N)
    res = zeros(N)
    for j = 1:N
        @inbounds res[j] = w*a[j] + x*b[j] + y*c[j] + z*d[j]
    end
end

for Ni = 1:length(NN)
    N = Int64(floor(10^NN[Ni]))
    
    println(N)

    a = rand(N)
    b = rand(N)
    c = rand(N)
    d = rand(N)
        
    w = rand()-.5
    x = rand()-.5
    y = rand()-.5
    z = rand()-.5
    
    tmp_et_times = zeros(Niters)
    tmp_nat_times = zeros(Niters)
    tmp_loop_times = zeros(Niters)
    for iter = 1:Niters
        
        #Disable garbage collection so it doesn't fire in the middle of a timed test
        gc_enable(false)
        tmp_et_times[iter] = @elapsed res = @et w*a + x*b + y*c + z*d
        tmp_nat_times[iter] = @elapsed res = w*a + x*b + y*c + z*d
        tmp_loop_times[iter] = @elapsed loop_kernel(w,a,x,b,y,c,z,d,N)
        gc_enable(true); #re-enable GC to clean up after the native array expression
    end
    
    et_times[Ni] = mean(tmp_et_times)
    native_times[Ni] = mean(tmp_nat_times)
    loop_times[Ni] = mean(tmp_loop_times)
end

println(et_times)
println(native_times)
println(loop_times)

table = zeros(length(NN),3)

table[:,1] = NN
table[:,2] = native_times./et_times
table[:,3] = native_times./loop_times

println()
println(table)

semilogx(floor(10.^table[:,1]), table[:,2])
semilogx(floor(10.^table[:,1]), table[:,3])
title("Speedup")
xlabel("N")
ylabel("Speedup = T_native / T")
legend(["Expression Templates", "Hand Loops"], "upper left")
savefig("speedup.svg")
