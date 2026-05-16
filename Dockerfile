FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt update && apt install -y \
    qemu-system-x86 \
    novnc \
    websockify \
    x11vnc \
    xvfb \
    wget \
    tzdata \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /vm

RUN wget -O tinycore.iso \
    http://tinycorelinux.net/15.x/x86/release/Core-current.iso

EXPOSE 8080

CMD bash -c "\
Xvfb :1 -screen 0 1024x768x16 & \
export DISPLAY=:1 && \
x11vnc -display :1 -nopw -forever -shared -rfbport 5900 & \
websockify --web=/usr/share/novnc 8080 localhost:5900 & \
sleep 2 && \
qemu-system-i386 \
  -m 64M \
  -cdrom /vm/tinycore.iso \
  -boot d \
  -vnc :0 \
  -net nic -net user \
  -display none"