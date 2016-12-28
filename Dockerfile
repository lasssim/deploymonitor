FROM hypriot/rpi-ruby

RUN apt-get update
RUN apt-get -y install build-essential vim git unzip

ADD https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip /ngrok.zip
RUN set -x \
 && unzip -o /ngrok.zip -d /bin \
 && rm -f /ngrok.zip

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install --deployment

COPY . /usr/src/app

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "8080"]

