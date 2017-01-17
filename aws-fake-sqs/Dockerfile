FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    ruby \
    python-pip

# install aws cli
RUN pip install awscli

# install fake sqs
RUN gem install fake_sqs \
    && mkdir -p /opt/fakesqs
COPY run.sh /opt/fakesqs

RUN mkdir -p /bootstrap
EXPOSE 4568

CMD /opt/fakesqs/run.sh