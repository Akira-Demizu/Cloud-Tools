FROM almalinux:9

RUN dnf -y update && \
    dnf -y install epel-release && \
    dnf -y install --allowerasing bash curl vim nkf zip unzip && \
    dnf clean all

WORKDIR /scripts
CMD ["/bin/bash"]