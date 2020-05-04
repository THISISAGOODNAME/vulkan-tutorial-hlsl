add_executable(hello_windows hello_glfw.cpp)
target_link_libraries(hello_windows ${LIBS})

add_executable(hello_triangle hello_triangle.cpp)
target_link_libraries(hello_triangle ${LIBS})
