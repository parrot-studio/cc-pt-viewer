FROM ruby:2.6
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn
RUN gem install bundler -v 1.17.3 && gem install foreman

RUN mkdir /home/ccpts
WORKDIR /home/ccpts

COPY Gemfile /home/ccpts/Gemfile
COPY Gemfile.lock /home/ccpts/Gemfile.lock
RUN bundle install
