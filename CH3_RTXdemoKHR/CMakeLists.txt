list(APPEND COMMON_FILES
        framework/camera.cpp
        framework/vulkanapp.cpp
        framework/vulkanhelpers.cpp
        ../3rd_party/volk/volk.c)

add_executable(hello_rtx_khr hello_rtx_khr.cpp rtxApp.cpp ${COMMON_FILES} )
target_link_libraries(hello_rtx_khr ${LIBS})
