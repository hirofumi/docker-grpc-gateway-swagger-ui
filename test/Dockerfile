FROM selenium/node-chrome:3.141.59-20200525

VOLUME /test
WORKDIR /test

COPY Pipfile Pipfile.lock ./

RUN sudo apt-get -y update \
    && sudo apt-get -y install python3-setuptools \
    && curl https://raw.githubusercontent.com/pypa/pipenv/master/get-pipenv.py | sudo -H python3 \
    && pipenv install

CMD pipenv run python3 -m unittest test.py
