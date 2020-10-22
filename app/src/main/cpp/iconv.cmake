set(iconv_srcs
        libcharset/lib/localcharset.c
        lib/iconv.c
        lib/relocatable.c
        )

PREPEND(iconv_src_with_path "iconv" ${iconv_srcs})
add_library(iconv ${iconv_src_with_path})
target_compile_options(iconv PRIVATE -Wno-multichar -DANDROID -DLIBDIR="c" -DBUILDING_LIBICONV -DIN_LIBRARY)
target_include_directories(iconv PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/iconv/include"
        "${CMAKE_CURRENT_SOURCE_DIR}/iconv/libcharset"
        "${CMAKE_CURRENT_SOURCE_DIR}/iconv/lib"
        "${CMAKE_CURRENT_SOURCE_DIR}/iconv/libcharset/include"
        "${CMAKE_CURRENT_SOURCE_DIR}/iconv/srclib"
        )
