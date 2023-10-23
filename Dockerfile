FROM ruby:3.2.2
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo

RUN curl -sL https://deb.nodesource.com/setup_19.x | bash - \
&& wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
&& apt-get update -qq \
&& apt-get install -y build-essential libpq-dev nodejs yarn libvips libvips-dev \
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