FROM gcr.io/gcp-runtimes/ubuntu_16_0_4:latest

RUN apt-get update && apt-get install -q -y --force-yes \
    build-essential \
    cron \
    python-pip \
    python-dev \
    python-virtualenv 

# create crons
# ADD whitelabel_automator_cron /etc/cron.d/whitelabel_automator_cron
# RUN chmod 644 /etc/cron.d/whitelabel_automator_cron

ADD config.yaml /etc/secrets/config.yaml
RUN chmod 644 /etc/secrets/config.yaml

ADD mailchimp.html /etc/secrets/mailchimp.html
RUN chmod 644 /etc/secrets/mailchimp.html

WORKDIR /opt/whitelabel_automator
COPY requirements.txt /opt/whitelabel_automator

RUN virtualenv /opt/whitelabel_automator/venv

RUN /opt/whitelabel_automator/venv/bin/pip install -U pip

# install requirements
RUN /opt/whitelabel_automator/venv/bin/pip install -r requirements.txt

# install app
COPY dist/whitelabel_automator-*.tar.gz /tmp/
RUN /opt/whitelabel_automator/venv/bin/pip install /tmp/whitelabel_automator-*.tar.gz

# start cron and wait; cron will start script
CMD wait
