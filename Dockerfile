FROM swift:6.2 AS swiftbuilder

RUN apt-get -q update && \
    apt-get -q install -y libz-dev curl unzip npm

ARG PROTOC_VERSION=33.5
ARG SWIFT_PROTOBUF_VERSION=1.28.2

# Install protoc
RUN curl -O -L https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip && \
    unzip protoc-${PROTOC_VERSION}-linux-x86_64.zip -d /usr

# Build and install protoc-gen-swift
WORKDIR /tmp/swift-protobuf-build
RUN git clone https://github.com/apple/swift-protobuf && \
    cd swift-protobuf && \
    git checkout tags/${SWIFT_PROTOBUF_VERSION} && \
    swift build -c release --product protoc-gen-swift

RUN ln -s /tmp/swift-protobuf-build/swift-protobuf/.build/release/protoc-gen-swift /usr/local/bin/

# Install buf
RUN npm install @bufbuild/buf -g

# Generate code using buf
WORKDIR /workspace

CMD buf generate
