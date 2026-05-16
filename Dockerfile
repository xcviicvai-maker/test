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
    net-tools \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /vm

# SliTaz ISO (stable mirror)
RUN wget -O slitaz.iso \
    http://mirror.slitaz.org/iso/rolling/slitaz-rolling.iso

EXPOSE 8080

CMD bash -c "\
websockify --web=/usr/share/novnc 8080 localhost:5900 & \
sleep 2 && \
qemu-system-i386 \
  -m 256M \
  -cdrom /vm/slitaz.iso \
  -boot d \
  -vnc :0 \
  -cpu pentium \
  -net nic -net user \
  -display none"