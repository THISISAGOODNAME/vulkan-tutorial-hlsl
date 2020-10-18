include_directories(../3rd_party/imgui)
list(APPEND IMGUI_FILES
        ../3rd_party/imgui/imgui.cpp
        ../3rd_party/imgui/imgui_demo.cpp
        ../3rd_party/imgui/imgui_draw.cpp
        ../3rd_party/imgui/imgui_impl_glfw.cpp
        ../3rd_party/imgui/imgui_impl_vulkan.cpp
        ../3rd_party/imgui/imgui_widgets.cpp
        )
add_executable(hello_imgui hello_imgui.cpp ${IMGUI_FILES})
target_link_libraries(hello_imgui ${LIBS})

include_directories(imgui_markdown)
include_directories(IconFontCppHeaders)
add_executable(hello_imgui_markdown hello_imgui_markdown.cpp ${IMGUI_FILES})
target_link_libraries(hello_imgui_markdown ${LIBS})
