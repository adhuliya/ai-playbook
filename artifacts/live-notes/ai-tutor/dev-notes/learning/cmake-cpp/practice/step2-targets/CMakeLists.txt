cmake_minimum_required(VERSION 3.21)
# project(app)
project(step2_greeter LANGUAGES CXX)

add_library(greeter STATIC greeter.cpp)
add_executable(app main.cpp)
target_link_libraries(app PRIVATE greeter)

