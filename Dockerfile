# https://hub.docker.com/r/cirrusci/android-sdk
# https://github.com/cirruslabs/docker-images-android/blob/master/sdk/33/Dockerfile
ARG android_sdk_ver=33
FROM cirrusci/android-sdk:${android_sdk_ver}

RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

ARG flutter_version=3.7.1

ENV FLUTTER_HOME=/home/developer/sdks/flutter \
    FLUTTER_VERSION=${flutter_version}
ENV FLUTTER_ROOT=$FLUTTER_HOME

ENV PATH ${PATH}:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin

RUN git clone --depth 1 --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git -b stable ${FLUTTER_HOME} \
    && flutter precache \
    && flutter config --no-analytics \
    && flutter config --enable-web \
    && flutter config --enable-linux-desktop \
    && flutter config --enable-windows-desktop \
    && flutter config --enable-macos-desktop \
    && flutter config --enable-android \
    && flutter config --enable-ios \
    && flutter doctor

RUN yes | flutter doctor --android-licenses

RUN flutter doctor