#include <chrono>
#include <cmath>
#include <iostream>
#include <random>
#include <tbb/tbb.h>
#include <vector>

inline double calculate_objective_value(double x) { return std::sin(x); }

inline double calculate_derivative_value(double x) { return std::cos(x); }

int main()
{
    std::random_device seed;
    std::default_random_engine engine(seed());
    std::uniform_real_distribution<double> uniform_dist(0.0, 10.0);

    constexpr int num_elements = 1000000;

    std::vector<double> x_optimal(num_elements);

    auto perform_gradient_descent = [&](int i) {
        constexpr double epsilon = 1e-15;
        constexpr double rate = 0.99;

        double a = 0.50;
        double x = uniform_dist(engine);

        while (true) {
            const double delta = a * calculate_derivative_value(x);

            x -= delta;
            a *= rate;

            if (delta < epsilon) {
                break;
            }
        }

        x_optimal[i] = x;
    };

    const auto t_0 = std::chrono::system_clock::now();

    tbb::parallel_for(0, num_elements, perform_gradient_descent);

    const auto t_1 = std::chrono::system_clock::now();

    for (int i = 0; i < num_elements; ++i) {
        perform_gradient_descent(i);
    }

    const auto t_2 = std::chrono::system_clock::now();

    const int elapsed_time_parallel = std::chrono::duration_cast<std::chrono::milliseconds>(t_1 - t_0).count();
    const int elapsed_time_serial = std::chrono::duration_cast<std::chrono::milliseconds>(t_2 - t_1).count();

    std::cout << "parallel: " << elapsed_time_parallel << " [ms]" << std::endl;
    std::cout << "serial:   " << elapsed_time_serial << " [ms]" << std::endl;

    // Clang-tidy: Use after move example
    // std::vector<float> vec{ 1, 2, 3 };

    // auto v = std::move(vec);

    // std::cout << "vec[0]: " << v[0];

    // modernize c-array, enable/disable rule
    // double c_array[] = { 1.0, 2.0, 3.0 };

    return 0;
}