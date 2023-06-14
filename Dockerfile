FROM python:3.7-buster
LABEL maintainer="Chris Wieringa <chris@wieringafamily.com>"

# Set versions and platforms
ARG TZ=US/Michigan
ARG TF_BINARY_URL=https://files.pythonhosted.org/packages/1d/56/0dbdae2a3c527a119bec0d5cf441655fe030ce1daa6fa6b9542f7dbd8664/tensorflow-2.1.0-cp37-cp37m-manylinux2010_x86_64.whl

# Do all run commands with bash
SHELL ["/bin/bash", "-c"] 

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo "$TZ" > /etc/timezone

# add required programs
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \  
    locales \
    git \
    gpg \
    tcpdump \
    wget \  
    software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# clone the DoHlyzer github
RUN mkdir -p /code && cd /code && git clone --depth 1 https://github.com/ahlashkari/DoHlyzer

# make misc changes/fixups to the code
COPY --chmod=0644 inc/setup.py /code/DoHlyzer/
COPY --chmod=0644 inc/packet_direction.py /code/DoHlyzer/meter/features/context/packet_direction.py

# Install all required pip modules/etc
RUN pip3 install numpy==1.18 && \
    pip3 install scapy==2.4.3 && \
    pip3 install --ignore-installed --upgrade $TF_BINARY_URL && \
    pip3 install pandas && \
    pip3 install -r /code/DoHlyzer/requirements.txt && \
    cd /code/DoHlyzer && \
    pip3 install .


# Locale configuration
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV TERM xterm-256color
ENV TZ=US/Michigan

# Force set the TZ variable
COPY --chmod=0755 inc/timezone.sh /etc/profile.d/timezone.sh

# Copy into the container some pre-captured CSV files and and a script to add labels
RUN mkdir -p /code/test/
COPY inc/ds*.csv /code/test/
COPY inc/add-labels.py /code/test/

# Cleanup misc files
RUN rm -f /var/log/*.log && \
    rm -f /var/log/faillog

# set CMD and workdir
WORKDIR "/code/DoHlyzer"
CMD /bin/bash