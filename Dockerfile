FROM ncbi/blast:2.10.0

ARG USER=cabana
ARG CABANA_USER_ID=1000
ARG CABANA_GROUP_ID=1000
ENV HOME /home/$USER

USER root

# Creates work user.
RUN set -xe; \
    \
    groupadd -g "${CABANA_USER_ID}" $USER; \
    adduser --gid "${CABANA_GROUP_ID}" --uid "${CABANA_USER_ID}" $USER;

# Sets working directory.
WORKDIR $HOME

# Creates the tools folder.
RUN mkdir data tools

# Sets ownership.
RUN chown -R $USER:$USER $HOME

# Downloads compiled libraries.
RUN set -xe; \
    \
    mkdir -p $HOME/tools/bmtagger && \
    curl ftp://ftp.ncbi.nlm.nih.gov/pub/agarwala/bmtagger/bmtagger.sh > $HOME/tools/bmtagger/bmtagger.sh  && \
    curl ftp://ftp.ncbi.nlm.nih.gov/pub/agarwala/bmtagger/bmtool > $HOME/tools/bmtagger/bmtool && \
    curl ftp://ftp.ncbi.nlm.nih.gov/pub/agarwala/bmtagger/bmfilter > $HOME/tools/bmtagger/bmfilter && \
    curl ftp://ftp.ncbi.nlm.nih.gov/pub/agarwala/bmtagger/extract_fullseq > $HOME/tools/bmtagger/extract_fullseq && \
    curl ftp://ftp.ncbi.nlm.nih.gov/pub/agarwala/bmtagger/srprism > $HOME/tools/bmtagger/srprism && \
    chmod +x $HOME/tools/bmtagger/*

ENV PATH "$PATH:$HOME/tools/bmtagger"
ENV PATH "$PATH:/blast/bin"

# Changes to work user.
USER $USER

# Entrypoint to keep the container running.
ENTRYPOINT ["tail", "-f", "/dev/null"]