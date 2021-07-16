FROM sparrowdata/backend:2.0.0.beta11

RUN apk add --no-cache \
  build-base \
  cmake \
  bash \
  boost-dev \
  autoconf \
  zlib-dev \
  flex \
  bison

RUN pip install --no-cache-dir six pytest cython

ARG ARROW_VERSION=0.12.0
ARG ARROW_SHA1=2ede75769e12df972f0acdfddd53ab15d11e0ac2
ARG ARROW_BUILD_TYPE=release

ENV ARROW_HOME=/usr/local \
  PARQUET_HOME=/usr/local

#Download and build apache-arrow
RUN mkdir /arrow \
  && apk add --no-cache curl \
  && curl -o /tmp/apache-arrow.tar.gz -SL https://github.com/apache/arrow/archive/apache-arrow-${ARROW_VERSION}.tar.gz \
  && echo "$ARROW_SHA1 *apache-arrow.tar.gz" | sha1sum /tmp/apache-arrow.tar.gz \
  && tar -xvf /tmp/apache-arrow.tar.gz -C /arrow --strip-components 1 \
  && mkdir -p /arrow/cpp/build \
  && cd /arrow/cpp/build \
  && cmake -DCMAKE_BUILD_TYPE=$ARROW_BUILD_TYPE \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_INSTALL_PREFIX=$ARROW_HOME \
  -DARROW_PARQUET=on \
  -DARROW_PYTHON=on \
  -DARROW_PLASMA=on \
  -DARROW_BUILD_TESTS=OFF \
  .. \
  && make -j$(nproc) \
  && make install \
  && cd /arrow/python \
  && python setup.py build_ext --build-type=$ARROW_BUILD_TYPE --with-parquet \
  && python setup.py install \
  && rm -rf /arrow /tmp/apache-arrow.tar.gz