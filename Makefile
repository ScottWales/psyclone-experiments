BUILD_DIR = build

all: | ${BUILD_DIR}
	${MAKE} -C ${BUILD_DIR}

clean:
	${RM} -r ${BUILD_DIR}

${BUILD_DIR}:
	mkdir $@
	cd $@ && cmake ${CURDIR}

