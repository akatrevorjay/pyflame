FROM trevorj/boilerplate
MAINTAINER Trevor Joynson <github@trevor.joynson.io>

RUN lazy-apt \
    # Runtime deps
    python python3 \
    # Compile time deps.
    # Could lazy-apt-with to not keep them around, but they're not too big in the scheme of things.
    python-dev python3-dev \
    build-essential \
    autoconf autoconf-archive pkg-config automake m4 libtool \
    git \
    # Test deps
    python-virtualenv \
 && :

COPY m4 m4
COPY utils utils
COPY travis travis
COPY tests tests
COPY src src
COPY debian debian
COPY .git .git
COPY \
     Makefile.am \
     LICENSE \
     autogen.sh \
     pyflame.man \
     runtests.sh \
     configure.ac \
     README.md \
     ./

COPY image image

RUN ./autogen.sh \
 && ./configure \
 && make -j4 \
 && cp -av src/pyflame image/bin/pyflame \
 && make clean \
 ## Let's allow those tests to run even though we're mrclean
 && ln -sf ../image/bin/pyflame src/ \
 && :
