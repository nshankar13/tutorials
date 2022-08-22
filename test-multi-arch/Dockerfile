ARG base_image

FROM ${base_image}

ARG TARGETARCH
ARG TARGETOS

ENV helm_version 3.9.3

RUN echo "I'm building for $TARGETARCH on $TARGETOS"

RUN clean-install curl ca-certificates 

RUN curl https://get.helm.sh/helm-v${helm_version}-${TARGETOS}-${TARGETARCH}.tar.gz -o helm.tar.gz && \
    tar -xvf helm.tar.gz && \
    rm helm.tar.gz && \
    mv ${TARGETOS}-${TARGETARCH}/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm