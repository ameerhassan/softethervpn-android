set(readline_srcs
    bind.c
    callback.c
    colors.c
    compat.c
    complete.c
    display.c
    funmap.c
    histexpand.c
    histfile.c
    history.c
    histsearch.c
    input.c
    isearch.c
    keymaps.c
    kill.c
    macro.c
    mbutil.c
    misc.c
    nls.c
    parens.c
    parse-colors.c
    readline.c
    rltty.c
    savestring.c
    search.c
    shell.c
    signals.c
    terminal.c
    text.c
    tilde.c
    undo.c
    util.c
    vi_mode.c
    xfree.c
    xmalloc.c)

PREPEND(readline_src_with_path "readline" ${readline_srcs})
add_library(readline ${readline_src_with_path})
target_compile_options(readline PRIVATE -ansi -Wall -Wshadow -Wpointer-arith -Wcast-qual -Wwrite-strings -Wstrict-prototypes -Wmissing-prototypes -Wno-implicit -pedantic -std=gnu89)
target_link_libraries(readline ncurses)
target_compile_definitions(readline PRIVATE
        -DHAVE_CONFIG_H
        )
target_compile_definitions(readline PUBLIC
        -DREADLINE_LIBRARY
        -DRL_LIBRARY_VERSION='"8.0"'
        )
target_include_directories(readline PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/readline"
        )
