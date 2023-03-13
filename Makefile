ARCH ?= $(shell uname -m)
MELANGE_DIR ?= ../melange
MELANGE ?= ${MELANGE_DIR}/melange
KEY ?= local-melange.rsa
REPO ?= $(shell pwd)/packages
SOURCE_DATE_EPOCH ?= 0
CACHE_DIR ?= gs://wolfi-sources/

WOLFI_SIGNING_PUBKEY ?= https://packages.wolfi.dev/os/wolfi-signing.rsa.pub
WOLFI_PROD ?= https://packages.wolfi.dev/os

MELANGE_OPTS += --repository-append ${REPO}
MELANGE_OPTS += --keyring-append ${KEY}.pub
MELANGE_OPTS += --signing-key ${KEY}
MELANGE_OPTS += --pipeline-dir ${MELANGE_DIR}/pipelines
MELANGE_OPTS += --arch ${ARCH}
MELANGE_OPTS += --env-file build-${ARCH}.env
MELANGE_OPTS += --cache-dir ${CACHE_DIR}
MELANGE_OPTS += --namespace wolfi
MELANGE_OPTS += --generate-index false
MELANGE_OPTS += ${MELANGE_EXTRA_OPTS}

ifeq (${BUILDWORLD}, no)
MELANGE_OPTS += -k ${WOLFI_SIGNING_PUBKEY}
MELANGE_OPTS += -r ${WOLFI_PROD}
endif

define build-package

packages/$(1): packages/${ARCH}/$(1)-$(2).apk
packages/${ARCH}/$(1)-$(2).apk: ${KEY}
	mkdir -p ./$(1)/
	SOURCE_DATE_EPOCH=${SOURCE_DATE_EPOCH} ${MELANGE} build $(1).yaml ${MELANGE_OPTS} --source-dir ./$(if $(3),$(3),$(1))/

PACKAGES += packages/${ARCH}/$(1)-$(2).apk

endef

all: ${KEY} .build-packages

${KEY}:
	${MELANGE} keygen ${KEY}

clean:
	rm -rf packages/${ARCH}

# The list of packages to be built.
#
# Use the `build-package` macro for packages which require a source
# directory, like `glibc/` or `busybox/`.
# arg 1 = package name
# arg 2 = package version
# arg 3 = override source directory, defaults to package name, useful if you want to reuse the same subfolder for multiple packages
$(eval $(call build-package,gmp,6.2.1-r6))
$(eval $(call build-package,mpfr,4.2.0-r2))
$(eval $(call build-package,mpc,1.2.1-r4))
$(eval $(call build-package,isl,0.24-r5))
$(eval $(call build-package,zlib,1.2.13-r3))
$(eval $(call build-package,flex,2.6.4-r4))
$(eval $(call build-package,glibc,2.37-r3))
$(eval $(call build-package,build-base,1-r5))
$(eval $(call build-package,gcc,12.2.0-r9))
$(eval $(call build-package,openssl,3.0.8-r0))
$(eval $(call build-package,binutils,2.40-r2))
$(eval $(call build-package,bison,3.8.2-r3))
$(eval $(call build-package,etcd,3.5.7-r2))
$(eval $(call build-package,pax-utils,1.3.4-r4))
$(eval $(call build-package,texinfo,7.0.2-r2))
$(eval $(call build-package,gzip,1.12-r3))
$(eval $(call build-package,busybox,1.36.0-r0))
$(eval $(call build-package,make,4.3-r3))
$(eval $(call build-package,sed,4.9-r2))
$(eval $(call build-package,mpdecimal,2.5.1-r3))
$(eval $(call build-package,libffi,3.4.4-r2))
$(eval $(call build-package,linux-headers,5.19.17-r2))
$(eval $(call build-package,gdbm,1.23-r3))
$(eval $(call build-package,grep,3.9-r0))
$(eval $(call build-package,gawk,5.2.1-r2))
$(eval $(call build-package,strace,6.1-r2))
$(eval $(call build-package,file,5.44-r2))
$(eval $(call build-package,expat,2.5.0-r2))
$(eval $(call build-package,m4,1.4.19-r4))
$(eval $(call build-package,bzip2,1.0.8-r4))
$(eval $(call build-package,perl,5.36.0-r3))
$(eval $(call build-package,ca-certificates,20220614-r4))
$(eval $(call build-package,autoconf,2.71-r2))
$(eval $(call build-package,automake,1.16.5-r2))
$(eval $(call build-package,help2man,1.49.3-r2))
$(eval $(call build-package,libtool,2.4.7-r2))
$(eval $(call build-package,libsodium,1.0.18-r2))
$(eval $(call build-package,patch,2.7.6-r5))
$(eval $(call build-package,ncurses,6.4-r2))
$(eval $(call build-package,pkgconf,1.9.4-r2))
$(eval $(call build-package,readline,8.2-r2))
$(eval $(call build-package,sqlite,3.40.1-r3))
$(eval $(call build-package,xz,5.4.1-r2))
$(eval $(call build-package,python-3.11,3.11.1-r8))
$(eval $(call build-package,scdoc,1.11.2-r3))
$(eval $(call build-package,linenoise,1.0-r2))
$(eval $(call build-package,lua5.3,5.3.6-r4))
$(eval $(call build-package,lua5.3-lzlib,0.4.3-r2))
$(eval $(call build-package,luajit,2.1_p20210510-r2))
$(eval $(call build-package,lua5.4,5.4.4-r2))
$(eval $(call build-package,apk-tools,2.12.11-r2))
$(eval $(call build-package,wget,1.21.3-r4))
$(eval $(call build-package,wolfi-keys,1-r5))
$(eval $(call build-package,wolfi-baselayout,20230201-r0))
$(eval $(call build-package,wolfi-base,1-r3))
$(eval $(call build-package,oniguruma,6.9.8-r2))
$(eval $(call build-package,jq,1.6-r2))
$(eval $(call build-package,brotli,1.0.9-r2))
$(eval $(call build-package,libev,4.33-r3))
$(eval $(call build-package,c-ares,1.19.0-r0))
$(eval $(call build-package,nghttp2,1.52.0-r1))
$(eval $(call build-package,curl,7.88.1-r0))
$(eval $(call build-package,attr,2.5.1-r2))
$(eval $(call build-package,acl,2.3.1-r2))
$(eval $(call build-package,coreutils,9.1-r2))
$(eval $(call build-package,diffutils,3.9-r2))
$(eval $(call build-package,findutils,4.9.0-r2))
$(eval $(call build-package,procps,4.0.3-r0))
$(eval $(call build-package,samurai,1.2-r2))
$(eval $(call build-package,lz4,1.9.4-r2))
$(eval $(call build-package,zstd,1.5.4-r0))
$(eval $(call build-package,libarchive,3.6.2-r2))
$(eval $(call build-package,libuv,1.44.2-r3))
$(eval $(call build-package,rhash,1.4.3-r3))
$(eval $(call build-package,cmake,3.24.2-r2))
$(eval $(call build-package,py3-appdirs,1.4.4-r3))
$(eval $(call build-package,py3-ordered-set,4.0.2-r3))
$(eval $(call build-package,py3.11-setuptools,67.5.1-r0))
$(eval $(call build-package,py3.10-setuptools,67.5.1-r0))
$(eval $(call build-package,py3.10-installer,0.5.1-r0))
$(eval $(call build-package,py3.11-installer,0.5.1-r0))
$(eval $(call build-package,py3-tomli,2.0.1-r2))
$(eval $(call build-package,py3-gpep517,13-r3))
$(eval $(call build-package,py3-flit-core,3.8.0-r3))
$(eval $(call build-package,py3-parsing,3.0.9-r3))
$(eval $(call build-package,py3-packaging,21.3-r3))
$(eval $(call build-package,py3-more-itertools,9.1.0-r0))
$(eval $(call build-package,py3-pep517,0.13.0-r2))
$(eval $(call build-package,py3-six,1.16.0-r3))
$(eval $(call build-package,py3-retrying,1.3.4-r2))
$(eval $(call build-package,py3-contextlib2,21.6.0-r2))
$(eval $(call build-package,py3.11-pip,23.0.1-r0))
$(eval $(call build-package,py3.10-pip,23.0.1-r0))
$(eval $(call build-package,py3-docutils,0.19-r3))
$(eval $(call build-package,py3-pygments,2.14.0-r2))
$(eval $(call build-package,py3-magic,0.4.27-r2))
$(eval $(call build-package,libedit,3.1-r2))
$(eval $(call build-package,tiff,4.5.0-r2))
$(eval $(call build-package,pcre2,10.42-r2))
$(eval $(call build-package,git,2.39.2-r1))
$(eval $(call build-package,bash,5.2.15-r2))
$(eval $(call build-package,go-stage0,1.19.1-r2))
$(eval $(call build-package,go-1.19,1.19.7-r0))
$(eval $(call build-package,go-1.20,1.20.2-r0))
$(eval $(call build-package,git-lfs,3.3.0-r6))
$(eval $(call build-package,openssh,9.2_p1-r0))
$(eval $(call build-package,skalibs,2.13.1.0-r0))
$(eval $(call build-package,execline,2.9.2.1-r0))
$(eval $(call build-package,s6,2.11.3.0-r0))
$(eval $(call build-package,libretls,3.5.2-r2))
$(eval $(call build-package,grype,0.59.1-r1))
$(eval $(call build-package,trivy,0.38.2-r1))
$(eval $(call build-package,ruby-3.0,3.0.5-r0))
$(eval $(call build-package,ruby-3.1,3.1.3-r4))
$(eval $(call build-package,ruby-3.2,3.2.1-r0))
$(eval $(call build-package,rust-stage0,1.65.0-r2))
$(eval $(call build-package,http-parser,2.9.4-r2))
$(eval $(call build-package,libssh2,1.10.0-r2))
$(eval $(call build-package,libgit2,1.6.2-r0))
$(eval $(call build-package,meson,1.0.1-r0))
$(eval $(call build-package,wasi-libc,0.20220525-r2))
$(eval $(call build-package,rust,1.68.0-r0))
$(eval $(call build-package,deno,1.31.2-r0))
$(eval $(call build-package,rustup,1.25.2-r0))
$(eval $(call build-package,libcap,2.26-r2))
$(eval $(call build-package,tree,2.1.0-r2))
$(eval $(call build-package,bubblewrap,0.8.0-r0))
$(eval $(call build-package,gperf,3.1-r2))
$(eval $(call build-package,libpthread-stubs,0.4-r2))
$(eval $(call build-package,libmd,1.0.4-r2))
$(eval $(call build-package,libbsd,0.11.7-r2))
$(eval $(call build-package,util-macros,1.19.3-r2))
$(eval $(call build-package,xorgproto,2022.2-r2))
$(eval $(call build-package,libgpg-error,1.46-r2))
$(eval $(call build-package,libgcrypt,1.10.1-r3))
$(eval $(call build-package,libxml2,2.10.3-r3))
$(eval $(call build-package,perl-test-pod,1.52-r2))
$(eval $(call build-package,perl-yaml-syck,1.34-r2))
$(eval $(call build-package,prometheus,2.42.0-r3))
$(eval $(call build-package,libxslt,1.1.37-r2))
$(eval $(call build-package,docbook-xml,4.5-r2))
$(eval $(call build-package,xmlto,0.0.28-r3))
$(eval $(call build-package,libxau,1.0.11-r2))
$(eval $(call build-package,xtrans,1.4.0-r2))
$(eval $(call build-package,libxdmcp,1.1.4-r2))
$(eval $(call build-package,xcb-proto,1.15.2-r2))
$(eval $(call build-package,libxcb,1.15-r2))
$(eval $(call build-package,libx11,1.8.4-r0))
$(eval $(call build-package,libxext,1.3.5-r2))
$(eval $(call build-package,libxrender,0.9.11-r2))
$(eval $(call build-package,libxrandr,1.5.3-r2))
$(eval $(call build-package,libxfixes,6.0.0-r2))
$(eval $(call build-package,libxi,1.8-r2))
$(eval $(call build-package,libxtst,1.2.4-r3))
$(eval $(call build-package,rarian,0.8.1-r2))
$(eval $(call build-package,check,0.15.2-r2))
$(eval $(call build-package,libice,1.0.10-r2))
$(eval $(call build-package,libsm,1.2.3-r2))
$(eval $(call build-package,icu,71.1-r2))
$(eval $(call build-package,py3-markupsafe,2.1.2-r2))
$(eval $(call build-package,py3-jinja2,3.1.2-r2))
$(eval $(call build-package,nano,7.2-r0))
$(eval $(call build-package,nodejs-16,16.19.1-r0))
$(eval $(call build-package,nodejs-18,18.15.0-r1))
$(eval $(call build-package,nodejs-19,19.7.0-r0))
$(eval $(call build-package,yarn,1.22.19-r3))
$(eval $(call build-package,libxt,1.2.1-r2))
$(eval $(call build-package,libusb,1.0.26-r2))
$(eval $(call build-package,libevent,2.1.12-r2))
$(eval $(call build-package,dbus,1.15.2-r2))
$(eval $(call build-package,libpaper,1.1.28-r2))
$(eval $(call build-package,cups,2.4.2-r2))
$(eval $(call build-package,alsa-lib,1.2.8-r2))
$(eval $(call build-package,zip,3.0-r2))
$(eval $(call build-package,libpng,1.6.39-r2))
$(eval $(call build-package,freetype,2.13.0-r0))
$(eval $(call build-package,fontconfig,2.14.2-r0))
$(eval $(call build-package,giflib,5.2.1-r2))
$(eval $(call build-package,libjpeg,2.1.91-r1))
$(eval $(call build-package,lcms2,2.14-r2))
$(eval $(call build-package,openjdk-11,11.0.18-r1))
$(eval $(call build-package,openjdk-17,17.0.6-r1))
$(eval $(call build-package,su-exec,0.2-r1))
$(eval $(call build-package,llvm15,15.0.6-r1))
$(eval $(call build-package,postgresql-11,11.19-r0,postgresql))
$(eval $(call build-package,postgresql-12,12.14-r0,postgresql))
$(eval $(call build-package,postgresql-13,13.10-r0,postgresql))
$(eval $(call build-package,postgresql-14,14.7-r0,postgresql))
$(eval $(call build-package,postgresql-15,15.2-r0,postgresql))
$(eval $(call build-package,tzdata,2022g-r1))
$(eval $(call build-package,maven,3.9.0-r0))
$(eval $(call build-package,tini,0.19.0-r1))
$(eval $(call build-package,font-util,1.4.0-r0))
$(eval $(call build-package,libfontenc,1.1.7-r1))
$(eval $(call build-package,mkfontscale,1.2.2-r1))
$(eval $(call build-package,encodings,1.0.7-r0))
$(eval $(call build-package,ttf-dejavu,2.37-r1))
$(eval $(call build-package,bazel-5,5.4.0-r2,bazel))
$(eval $(call build-package,bazel-6,6.0.0-r3,bazel))
$(eval $(call build-package,libmaxminddb,1.7.1-r1))
$(eval $(call build-package,clang-15,15.0.6-r1))
$(eval $(call build-package,jenkins,2.394-r0))
$(eval $(call build-package,cosign,2.0.0-r1))
$(eval $(call build-package,yasm,1.3.0-r0))
$(eval $(call build-package,crane,0.13.0-r2))
$(eval $(call build-package,geoip,1.6.12-r0))
$(eval $(call build-package,pcre,8.45-r0))
$(eval $(call build-package,go-bindata,3.1.3-r3))
$(eval $(call build-package,popt,1.19-r0))
$(eval $(call build-package,rsync,3.2.7-r0))
$(eval $(call build-package,zeromq,4.3.4-r0))
$(eval $(call build-package,kubectl,1.26.1-r2))
$(eval $(call build-package,regclient,0.4.5-r3))
$(eval $(call build-package,libwebp,1.2.4-r0))
$(eval $(call build-package,skopeo,1.11.1-r1))
$(eval $(call build-package,llvm-libunwind,15.0.7-r0))
$(eval $(call build-package,llvm-lld,15.0.7-r0))
$(eval $(call build-package,mimalloc2,2.0.7-r0))
$(eval $(call build-package,libtbb,2021.7.0-r0))
$(eval $(call build-package,mold,1.10.1-r0))
$(eval $(call build-package,dumb-init,1.2.5-r0))
$(eval $(call build-package,envoy,1.25.1-r0))
$(eval $(call build-package,redis,7.0.9-r0))
$(eval $(call build-package,mailcap,2.1.53-r0))
$(eval $(call build-package,php,8.2.3-r0))
$(eval $(call build-package,composer,2.5.1-r0))
$(eval $(call build-package,yaml,0.2.5-r0))
$(eval $(call build-package,docker-credential-ecr-login,0.6.0-r3))
$(eval $(call build-package,pwgen,2.08-r1))
$(eval $(call build-package,mariadb,10.6.12-r1,mariadb))
$(eval $(call build-package,wait-for-it,0.20200823-r1))
$(eval $(call build-package,argon2,20190702-r0))
$(eval $(call build-package,haproxy,2.6.9-r1))
$(eval $(call build-package,vault,1.12.3-r1))
$(eval $(call build-package,libunistring,1.1-r1))
$(eval $(call build-package,gettext,0.21.1-r0))
$(eval $(call build-package,libcap-ng,0.8.3-r0))
$(eval $(call build-package,libseccomp,2.5.4-r0))
$(eval $(call build-package,libeconf,0.5.0-r0))
$(eval $(call build-package,zig,0.10.1-r0))
$(eval $(call build-package,linux-pam,1.5.2-r0))
$(eval $(call build-package,cython,0.29.32-r0))
$(eval $(call build-package,util-linux,2.38.1-r0))
$(eval $(call build-package,glib,2.74.3-r2))
$(eval $(call build-package,jansson,2.14-r0))
$(eval $(call build-package,msmtp,1.8.22-r0))
$(eval $(call build-package,nasm,2.16.01-r0))
$(eval $(call build-package,libxpm,3.5.15-r0))
$(eval $(call build-package,dav1d,1.0.0-r0))
$(eval $(call build-package,aom,3.6.0-r0))
$(eval $(call build-package,libavif,0.11.1-r0))
$(eval $(call build-package,erlang,25.2-r0))
$(eval $(call build-package,elixir,1.14.2-r0))
$(eval $(call build-package,rabbitmq-server,3.11.10-r0))
$(eval $(call build-package,gd,2.3.3-r0))
$(eval $(call build-package,kyverno-cli,1.8.5-r1))
$(eval $(call build-package,py3-sphinx,6.0.0-r0))
$(eval $(call build-package,heimdal,7.8.0-r0))
$(eval $(call build-package,cyrus-sasl,2.1.28-r0))
$(eval $(call build-package,e2fsprogs,1.46.5-r0))
$(eval $(call build-package,unixodbc,2.3.11-r0))
$(eval $(call build-package,cjson,1.7.15-r0))
$(eval $(call build-package,libwebsockets,4.3.2-r0))
$(eval $(call build-package,mosquitto,2.0.15-r0))
$(eval $(call build-package,memcached,1.6.18-r0))
$(eval $(call build-package,groff,1.22.4-r0))
$(eval $(call build-package,db,5.3.28-r0))
$(eval $(call build-package,openldap,2.6.3-r0))
$(eval $(call build-package,ko,0.13.0-r1))
$(eval $(call build-package,apko,0.7.1-r1))
$(eval $(call build-package,melange,0.2.0-r1))
$(eval $(call build-package,goreleaser,1.15.2-r1))
$(eval $(call build-package,nerdctl,1.2.0-r1))
$(eval $(call build-package,tkn,0.28.0-r1))
$(eval $(call build-package,bom,0.4.1-r2))
$(eval $(call build-package,libverto,0.3.2-r0))
$(eval $(call build-package,keyutils,1.6.3-r0))
$(eval $(call build-package,krb5-conf,1.0-r0))
$(eval $(call build-package,krb5,1.20.1-r1))
$(eval $(call build-package,libtirpc,1.3.3-r0))
$(eval $(call build-package,rustls-ffi,0.8.2-r1))
$(eval $(call build-package,spire-server,1.5.5-r1))
$(eval $(call build-package,kustomize,5.0.0-r2))
$(eval $(call build-package,alpine-keys,2.4-r1))
$(eval $(call build-package,xcb-util,0.4.1-r0))
$(eval $(call build-package,pixman,0.42.2-r0))
$(eval $(call build-package,cairo,1.17.6-r0))
$(eval $(call build-package,gobject-introspection,1.74.0-r0))
$(eval $(call build-package,kmod,30-r0))
$(eval $(call build-package,eudev,3.2.11-r0))
$(eval $(call build-package,fuse3,3.12.0-r0))
$(eval $(call build-package,libxft,2.3.7-r0))
$(eval $(call build-package,graphite2,1.3.14-r0))
$(eval $(call build-package,harfbuzz,6.0.0-r0))
$(eval $(call build-package,fribidi,1.0.12-r0))
$(eval $(call build-package,gc,8.2.2-r0))
$(eval $(call build-package,tcl,8.6.13-r0))
$(eval $(call build-package,libxmu,1.1.4-r0))
$(eval $(call build-package,libxaw,1.0.14-r0))
$(eval $(call build-package,pango,1.50.12-r0))
$(eval $(call build-package,guile,3.0.8-r0))
$(eval $(call build-package,swig,4.1.1-r0))
$(eval $(call build-package,graphviz,7.0.6-r0))
$(eval $(call build-package,vala,0.56.3-r0))
$(eval $(call build-package,libsecret,0.20.5-r0))
$(eval $(call build-package,libtasn1,4.19.0-r0))
$(eval $(call build-package,p11-kit,0.24.1-r0))
$(eval $(call build-package,wayland,1.21.0-r0))
$(eval $(call build-package,wayland-protocols,1.31-r0))
$(eval $(call build-package,at-spi2-core,2.46.0-r0))
$(eval $(call build-package,itstool,2.0.7-r0))
$(eval $(call build-package,shared-mime-info,2.2-r0))
$(eval $(call build-package,scorecard,4.10.2-r2))
$(eval $(call build-package,libkcapi,1.4.0-r0))
$(eval $(call build-package,libidn2,2.3.4-r0))
$(eval $(call build-package,libksba,1.6.3-r0))
$(eval $(call build-package,libassuan,2.5.5-r0))
$(eval $(call build-package,npth,1.6-r0))
$(eval $(call build-package,nettle,3.8.1-r0))
$(eval $(call build-package,gnutls,3.7.8-r0))
$(eval $(call build-package,gnupg,2.2.41-r0))
$(eval $(call build-package,dnssec-root,20190225-r0))
$(eval $(call build-package,dns-root-hints,2022062901-r0))
$(eval $(call build-package,protobuf,3.21.12-r0))
$(eval $(call build-package,protobuf-c,1.4.1-r0))
$(eval $(call build-package,fstrm,0.6.1-r0))
$(eval $(call build-package,bind,9.18.11-r0))
$(eval $(call build-package,py3-botocore,1.21.49-r0))
$(eval $(call build-package,py3-asn1,0.4.8-r0))
$(eval $(call build-package,py3-dateutil,2.8.2-r1))
$(eval $(call build-package,py3-hatchling,1.11.1-r0))
$(eval $(call build-package,py3-jmespath,0.10.0-r0))
$(eval $(call build-package,py3-pathspec,0.10.3-r0))
$(eval $(call build-package,py3-pluggy,1.0.0-r0))
$(eval $(call build-package,py3-colorama,0.4.6-r0))
$(eval $(call build-package,py3-rsa,4.9-r0))
$(eval $(call build-package,py3-s3transfer,0.5.1-r0))
$(eval $(call build-package,py3-urllib3,1.26.13-r0))
$(eval $(call build-package,py3-yaml,6.0-r0))
$(eval $(call build-package,nginx,1.23.3-r1))
$(eval $(call build-package,python-3.10,3.10.9-r3))
$(eval $(call build-package,aws-cli,1.27.38-r0))
$(eval $(call build-package,helm,3.11.2-r0))
$(eval $(call build-package,kubescape,2.0.183-r2))
$(eval $(call build-package,s3cmd,2.3.0-r0))
$(eval $(call build-package,kubevela,1.7.0-r2))
$(eval $(call build-package,fluent-bit,2.0.8-r0))
$(eval $(call build-package,sbom-scorecard,0.0.5-r1))
$(eval $(call build-package,libaio,0.3.113-r1))
$(eval $(call build-package,flux,0.41.1-r1))
$(eval $(call build-package,libunwind,1.6.2-r0))
$(eval $(call build-package,userspace-rcu,0.13.2-r0))
$(eval $(call build-package,lttng-ust,2.13.5-r0))
$(eval $(call build-package,jemalloc,5.3.0-r0))
$(eval $(call build-package,traefik,2.9.8-r2))
$(eval $(call build-package,snappy,1.1.9-r0))
$(eval $(call build-package,gitsign,0.5.2-r1))
$(eval $(call build-package,kind,0.17.0-r2))
$(eval $(call build-package,vim,9.0.1378-r0))
$(eval $(call build-package,policy-controller,0.7.0-r1))
$(eval $(call build-package,syft,0.70.0-r1))
$(eval $(call build-package,uutils,0.0.17-r0))
$(eval $(call build-package,yq,4.30.8-r1))
$(eval $(call build-package,delve,1.20.1-r2))
$(eval $(call build-package,oras,0.16.0-r1))
$(eval $(call build-package,step,0.23.1-r1))
$(eval $(call build-package,netcat-openbsd,1.219-r0))
$(eval $(call build-package,gnutar,1.34-r0))
$(eval $(call build-package,dpkg,1.20.12-r0))
$(eval $(call build-package,calicoctl,3.25.0-r1))
$(eval $(call build-package,container-entrypoint,0.1.0-r0))
$(eval $(call build-package,gomplate,3.11.4-r1))
$(eval $(call build-package,dex,2.35.3-r2))
$(eval $(call build-package,ruby3.2-bundler,2.4.7-r1))
$(eval $(call build-package,ruby3.2-async-io,1.34.3-r0))
$(eval $(call build-package,ruby3.2-cool.io,1.7.1-r0))
$(eval $(call build-package,ruby3.2-fiber-local,1.0.0-r0))
$(eval $(call build-package,ruby3.2-fluentd,1.15.3-r1))
$(eval $(call build-package,ruby3.2-msgpack,1.6.0-r0))
$(eval $(call build-package,ruby3.2-oj,3.14.2-r0))
$(eval $(call build-package,ruby3.2-rexml,3.2.5-r0))
$(eval $(call build-package,ruby3.2-serverengine,2.3.1-r0))
$(eval $(call build-package,ruby3.2-sigdump,0.2.4-r0))
$(eval $(call build-package,ruby3.2-strptime,0.2.5-r0))
$(eval $(call build-package,ruby3.2-tzinfo-data,1.2022.7-r0))
$(eval $(call build-package,ruby3.2-tzinfo,2.0.6-r0))
$(eval $(call build-package,ruby3.2-webrick,1.7.0-r0))
$(eval $(call build-package,ruby3.2-async-http,0.60.1-r0))
$(eval $(call build-package,ruby3.2-async-pool,0.3.12-r0))
$(eval $(call build-package,ruby3.2-async,2.3.1-r0))
$(eval $(call build-package,ruby3.2-console,1.16.2-r0))
$(eval $(call build-package,ruby3.2-io-event,1.1.6-r0))
$(eval $(call build-package,ruby3.2-protocol-http1,0.15.0-r0))
$(eval $(call build-package,ruby3.2-protocol-http2,0.15.1-r0))
$(eval $(call build-package,ruby3.2-protocol-http,0.24.1-r0))
$(eval $(call build-package,ruby3.2-timers,4.3.5-r0))
$(eval $(call build-package,ruby3.2-traces,0.8.0-r0))
$(eval $(call build-package,ruby3.2-concurrent-ruby,1.2.0-r0))
$(eval $(call build-package,ruby3.2-http_parser.rb,0.8.0-r0))
$(eval $(call build-package,ruby3.2-protocol-hpack,1.4.2-r0))
$(eval $(call build-package,ruby3.2-yajl-ruby,1.4.3-r0))
$(eval $(call build-package,gradle-stage0,8.0.1-r0))
$(eval $(call build-package,gradle-8,8.0.1-r0))
$(eval $(call build-package,python-3.12,3.12.0_alpha6-r0))
$(eval $(call build-package,golangci-lint,1.51.1-r1))
$(eval $(call build-package,doxygen,1.9.6-r0))
$(eval $(call build-package,jbig2dec,0.19-r0))
$(eval $(call build-package,dataplaneapi,2.7.2-r1))
$(eval $(call build-package,wasmtime,6.0.0-r0))
$(eval $(call build-package,poetry,1.3.2-r0))
$(eval $(call build-package,zot,1.4.3-r1))
$(eval $(call build-package,terraform,1.3.9-r2))
$(eval $(call build-package,prometheus-node-exporter,1.5.0-r2))
$(eval $(call build-package,prometheus-alertmanager,0.25.0-r1))
$(eval $(call build-package,prometheus-mysqld-exporter,0.14.0-r1))
$(eval $(call build-package,sbt-stage0,1.8.2-r0))
$(eval $(call build-package,sbt,1.8.2-r0))
$(eval $(call build-package,kafka,3.4.0-r0))
$(eval $(call build-package,ctop,0.7.7-r0))
$(eval $(call build-package,dhcping,1.2-r0))
$(eval $(call build-package,grpcurl,1.8.7-r0))
$(eval $(call build-package,iperf,2.1.8-r0))
$(eval $(call build-package,iperf3,3.13-r0))
$(eval $(call build-package,libmnl,1.0.5-r0))
$(eval $(call build-package,libnet,1.2-r0))
$(eval $(call build-package,libpcap,1.10.3-r0))
$(eval $(call build-package,libssh,0.10.4-r0))
$(eval $(call build-package,zookeeper,3.8.1-r0))

.build-packages: ${PACKAGES}

dev-container:
	docker run --privileged --rm -it -v "${PWD}:${PWD}" -w "${PWD}" cgr.dev/chainguard/sdk:latest
