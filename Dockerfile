FROM ruby:2.5

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -qq -y build-essential nodejs wait-for-it yarn \
    libpq-dev \
    postgresql-client  \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install

COPY app/ app/
COPY bin/ bin/
COPY config/ config/
COPY db/ db/
COPY lib/ lib/
COPY log/ log/
COPY public/ public/
COPY spec/ spec/
COPY tmp/ tmp/
COPY vendor/ vendor/

COPY *.yml ./
COPY .ruby-version .
COPY app.json .
COPY babel.config.js .
COPY config.ru .
COPY package.json .
COPY postcss.config.js .
COPY Procfile .
COPY Rakefile .
COPY yarn.lock .
COPY .env .

COPY bin/* /usr/bin/

RUN bundle install && \
  yarn install && \
  bundle exec rails assets:precompile

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh && chmod 755 /usr/src/app/* && chmod 755 /usr/bin/*

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
