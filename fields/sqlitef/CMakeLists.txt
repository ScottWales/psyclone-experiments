
add_library(sqlitef
    sqlite_c_mod.f90
    sqlite_mod.f90
    sqlite_helper.c
    )

include_directories(${SQLITE_INCLUDE_DIR})
target_link_libraries(sqlitef ${SQLITE_LIBRARY})

add_executable(test_sqlitef
    test_sqlite.F90
    )
target_link_libraries(test_sqlitef
    sqlitef
    )
