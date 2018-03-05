set( EXAMPLE_DIR ${PSYCLONE_SOURCEDIR}/examples/gocean )

set( KERNELS
    ${EXAMPLE_DIR}/compute_cu_mod.f90
    ${EXAMPLE_DIR}/compute_cv_mod.f90
    ${EXAMPLE_DIR}/compute_h_mod.f90
    ${EXAMPLE_DIR}/compute_pnew_mod.f90
    ${EXAMPLE_DIR}/compute_unew_mod.f90
    ${EXAMPLE_DIR}/compute_vnew_mod.f90
    ${EXAMPLE_DIR}/compute_z_mod.f90
    ${EXAMPLE_DIR}/infrastructure_mod.f90
    ${EXAMPLE_DIR}/time_smooth_mod.f90
    )

set( ALGORITHMS
    ${EXAMPLE_DIR}/shallow_alg.f90
    )

include(CMakeParseArguments)
function(psyclone)
    cmake_parse_arguments(
        PSYCLONE
        ""
        "OUTPUT;API;KERNEL_DIR"
        "ALGORITHMS;KERNELS"
        ${ARGN}
        )
    message("output ${PSYCLONE_OUTPUT}")
    message("api ${PSYCLONE_API}")
    message("kernel_dir ${PSYCLONE_KERNEL_DIR}")
    message("algs ${PSYCLONE_ALGORITHMS}")
    message("kerns ${PSYCLONE_KERNELS}")

    foreach(SOURCE ${PSYCLONE_ALGORITHMS})
        message("proc ${SOURCE}")

        get_filename_component(BASE ${SOURCE} NAME)
        add_custom_command(
            OUTPUT
                psyalg_${BASE}
                psypsy_${BASE}
            COMMAND
                psyclone
                    -oalg psyalg_${BASE}
                    -opsy psypsy_${BASE}
                    -api ${PSYCLONE_API}
                    ${SOURCE}
                    --directory ${PSYCLONE_KERNEL_DIR}
                    --limit
            DEPENDS
                ${SOURCE}
                ${PSYCLONE_KERNELS}
            )
        list(APPEND OUT_SOURCES psyalg_${BASE} psypsy_${BASE})
    endforeach(SOURCE)

    set(${PSYCLONE_OUTPUT} ${OUT_SOURCES} PARENT_SCOPE)
    message("out_sources" ${OUT_SOURCES})
    message("psy_out" ${PSYCLONE_OUTPUT})
    message("algs" ${PSYCLONE_ALGORITHM})
endfunction(psyclone)

psyclone(
    OUTPUT
        PSY_SOURCES
    API
        gocean1.0
    ALGORITHMS
        ${ALGORITHMS}
    KERNELS
        ${KERNELS}
    KERNEL_DIR
        ${EXAMPLE_DIR}
    )

message("psy_output" ${PSY_SOURCES})
add_library(shallow
    ${PSY_SOURCES}
    ${KERNELS}
    )
target_link_libraries(shallow
    gocean_api
    )
