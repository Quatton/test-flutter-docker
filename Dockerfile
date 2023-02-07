ARG android_sdk_ver=30
FROM cirrusci/android-sdk:${android_sdk_ver}

RUN useradd -ms /bin/bash developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER developer
WORKDIR /home/developer

ARG flutter_version=3.7.1

ENV HOME=/home/developer
ENV FLUTTER_HOME=$HOME/sdks/flutter \
    FLUTTER_VERSION=$flutter_version
ENV FLUTTER_ROOT=$FLUTTER_HOME

ENV PATH ${PATH}:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin

RUN git clone --depth 1 --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git -b stable ${FLUTTER_HOME}

RUN yes | flutter doctor --android-licenses \
    && flutter doctor \
    && chown -R developer ${FLUTTER_HOME}

RUN flutter config --no-analytics \
    && flutter config --enable-android \
    && flutter precache