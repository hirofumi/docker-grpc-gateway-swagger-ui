FROM selenium/node-chrome:3.141.59-20200525

COPY requirements.txt .

RUN sudo apt-get -y update \
    && sudo apt-get -y install python3-pip \
    && sudo pip3 install -r requirements.txt \
    && sudo rm requirements.txt

VOLUME /test
WORKDIR /test
CMD python3 -m unittest /test/test.py
