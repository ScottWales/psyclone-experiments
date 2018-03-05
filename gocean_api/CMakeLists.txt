
set( GOCEAN_SOURCES
    ${GOCEAN_API_SOURCEDIR}/argument_mod.F90
    ${GOCEAN_API_SOURCEDIR}/field_mod.f90
    ${GOCEAN_API_SOURCEDIR}/global_parameters_mod.F90
    ${GOCEAN_API_SOURCEDIR}/gocean_mod.F90
    ${GOCEAN_API_SOURCEDIR}/grid_mod.f90
    ${GOCEAN_API_SOURCEDIR}/halo_mod.f90
    ${GOCEAN_API_SOURCEDIR}/infrastructure_mod.f90
    ${GOCEAN_API_SOURCEDIR}/kernel_mod.F90
    ${GOCEAN_API_SOURCEDIR}/kind_params_mod.f90
    ${GOCEAN_API_SOURCEDIR}/Makefile
    ${GOCEAN_API_SOURCEDIR}/region_mod.f90
    # ${GOCEAN_API_SOURCEDIR}/topology_mod.f90
    )

add_library(gocean_api ${GOCEAN_SOURCES})
target_include_directories(gocean_api
    PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
    $<INSTALL_INTERFACE:include>
    )
