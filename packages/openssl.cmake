ExternalProject_Add(openssl
    DEPENDS
        zlib
        zstd
        brotli

    GIT_REPOSITORY https://github.com/openssl/openssl.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !test"
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    PATCH_COMMAND ${EXEC} git am --3way ${CMAKE_CURRENT_SOURCE_DIR}/openssl-*.patch

    CONFIGURE_COMMAND ${EXEC} mkdir -p apps/include
    COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/Configure
        --cross-compile-prefix=${TARGET_ARCH}-
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=lib
        --release

        no-autoload-config
        ${openssl_target}
        ${openssl_ec_opt}

        # Sicuri
        no-ssl3
        no-ssl3-method
        no-whirlpool
        no-camellia
        no-idea
        no-cast
        no-seed
        no-aria
        no-md4
        no-mdc2
        no-bf
        no-rc2
        no-rc4
        no-srp
        no-sm2
        no-sm3
        no-sm4
        no-capieng

        # Compressioni
        enable-brotli
        enable-zstd
        zlib

        # Build pulita
        no-tests
        no-docs
        no-apps
        threads

        # ⚠️ RIMOSSI i flag che rompono la build:
        # no-dh
        # no-dsa
        # no-err
        # no-dso
        # no-module
        # no-legacy
        # no-ocsp
        # no-cms
        # no-cmp
        # no-filenames
        # no-rmd160

    BUILD_COMMAND ${MAKE} build_sw
    INSTALL_COMMAND ${MAKE} install_sw

    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(openssl)
cleanup(openssl install)
