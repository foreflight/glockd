FROM ubuntu:12.04

# Mercurial
RUN echo 'deb http://ppa.launchpad.net/mercurial-ppa/releases/ubuntu precise main' > /etc/apt/sources.list.d/mercurial.list
RUN echo 'deb-src http://ppa.launchpad.net/mercurial-ppa/releases/ubuntu precise main' >> /etc/apt/sources.list.d/mercurial.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 323293EE

# So that Go get works properly with everything
RUN apt-get update
RUN apt-get install -y curl git bzr mercurial

# Install Go
RUN curl -s https://storage.googleapis.com/golang/go1.2.2.linux-amd64.tar.gz | tar -v -C /usr/local/ -xz

# Environment variables for Go
ENV PATH  /usr/local/go/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
ENV GOPATH  /go
ENV GOROOT  /usr/local/go

# Install glockd
WORKDIR /go/src/github.com/apokalyptik/glockd
ADD . /go/src/github.com/apokalyptik/glockd
RUN go get
RUN go build

EXPOSE 3030
EXPOSE 9998
EXPOSE 9999

ENTRYPOINT [ "./glockd", "-pidfile=/var/run/glockd.pid" ]