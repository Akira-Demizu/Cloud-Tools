FROM almalinux:9

RUN dnf -y update && \
    dnf -y install --allowerasing bash curl vim && \
    dnf clean all

WORKDIR /scripts
CMD ["/bin/bash"]