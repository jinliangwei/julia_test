#include <julia.h>
#include <glog/logging.h>
#include <vector>
#include <iostream>

const size_t kNumElements = 800000 * 10;

jl_function_t* GetFunction(jl_module_t* module,
            const char* func_name) {
  auto* func = jl_get_function(module, func_name);
  if (func == nullptr) {
    std::cout << "cannot find function " << func_name << std::endl;
    abort();
  }
  return func;
}


int main(int argc, char *argv[]) {
  std::cout << "hello world!" << std::endl;
  jl_init(NULL);
  jl_load("/home/ubuntu/test_julia/run_map.jl");
  //jl_gc_enable(0);
  std::vector<float> values(kNumElements, 0.1);

  jl_value_t *input_array_jl,
      *output_tuple_jl,
      *output_array_jl;

  JL_GC_PUSH3(&input_array_jl,
              &output_tuple_jl,
              &output_array_jl);
  jl_value_t *input_array_type = jl_apply_array_type(jl_float32_type, 1);
  input_array_jl = reinterpret_cast<jl_value_t*>(
      jl_ptr_to_array_1d(input_array_type, values.data(), kNumElements, 0));

  jl_function_t *mapper_func = GetFunction(jl_main_module, "map_values_func");
  output_tuple_jl = jl_call1(mapper_func, input_array_jl);
  output_array_jl = jl_get_nth_field(output_tuple_jl, 1);

  uint8_t *output_array = reinterpret_cast<uint8_t*>(jl_array_data(output_array_jl));
  float* output_values = reinterpret_cast<float*>(output_array);
  JL_GC_POP();
  jl_atexit_hook(0);
  std::cout << "values[10] = " << output_values[10] << std::endl;
}
