FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Java
RUN apt-get update && apt-get install -y openjdk-11-jdk wget unzip

# Download and install Android SDK
ENV ANDROID_SDK_ROOT=/opt/android-sdk
RUN mkdir -p ${ANDROID_SDK_ROOT} && \
    cd ${ANDROID_SDK_ROOT} && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip && \
    mkdir -p cmdline-tools/latest && \
    mv cmdline-tools/bin cmdline-tools/lib cmdline-tools/NOTICE.txt cmdline-tools/source.properties cmdline-tools/latest/ 2>/dev/null || true && \
    yes | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --licenses && \
    ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager "platforms;android-30" "build-tools;30.0.3"

ENV PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"

WORKDIR /app
COPY . .

RUN chmod +x gradlew
RUN ./gradlew assembleRelease

CMD ["cp", "app/build/outputs/apk/release/app-release-unsigned.apk", "/output/vmq-v1.8.2.apk"]
