FROM ruby:3.2.2
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo

RUN curl -fsSLO --compressed "https://nodejs.org/dist/v16.20.2/node-v16.20.2-linux-arm64.tar.xz" \
    && tar -xJf "node-v16.20.2-linux-arm64.tar.xz" -C /usr/local --strip-components=1 \
    && rm "node-v16.20.2-linux-arm64.tar.xz"

RUN wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y build-essential libpq-dev yarn libvips libvips-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /myapp
WORKDIR /myapp

RUN gem install bundler:2.3.17
RUN gem install rails
RUN echo $PATH
RUN which rails
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
COPY yarn.lock /myapp/yarn.lock

RUN bundle install
RUN yarn install

COPY . /myapp