FROM instructure/ruby-passenger:3.1

USER root

RUN apt-get update -qq \
&& apt-get install -y curl build-essential libpq-dev postgresql-client git &&\
  curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y nodejs yarn

ADD . /app
WORKDIR /app

RUN chown -R docker .

USER docker

RUN bundle install
RUN yarn install

EXPOSE 3000
CMD ["bash"]
