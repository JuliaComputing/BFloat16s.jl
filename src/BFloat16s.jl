module BFloat16s

    export BFloat16, NaNB16, InfB16,
            LowPrecArray

    include("bfloat16.jl")
    include("lowprecarrays.jl")
    include("printf.jl")

end
