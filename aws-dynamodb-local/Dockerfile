FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    software-properties-common \
    python-software-properties \
    python-pip \
    curl

# install oracle java (http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html)
RUN apt-add-repository -y ppa:webupd8team/java \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
    && apt-get update && apt-get install -y oracle-java8-installer oracle-java8-set-default

# install aws cli
RUN pip install awscli

# install dynamodb local
RUN mkdir -p /opt/dynamodb-local \
    && curl -SL http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest.tar.gz \
    | tar zx -C /opt/dynamodb-local
COPY run.sh /opt/dynamodb-local

RUN mkdir -p /bootstrap
EXPOSE 8000

CMD /opt/dynamodb-local/run.sh
