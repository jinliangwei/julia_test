function map_values_func(values::Vector)::Tuple{Vector{Int64}, Vector{Float32}}
    @time map_values_func_helper(values)
end

function map_values_func_helper(values::Vector)::Tuple{Vector{Int64}, Vector{Float32}}
    output_keys = Vector{Int64}()
    output_values = Vector{Float32}()
    println("length = ", length(values))
    for i = 1:length(values)
        if i % 10000 == 0
            println(i)
        end
        push!(output_values, values[i] / 10)
    end
    println("num_of_output_values = ", length(output_values))
    return (output_keys, output_values)
end

#values = randn(800000 * 20)
#map_values_func(values, Float32)
#println(values[10])
