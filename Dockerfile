FROM ubuntu:20.04
ENV LANG en_US.UTF8
ENV TZ=Europe/Helsinki

EXPOSE 4000

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y ruby ruby ruby-dev make gcc g++ zlib1g-dev git imagemagick
RUN gem install github-pages minima:'~> 2.5' jekyll-feed:'~> 0.12'
CMD jekyll serve -s /app -H 0.0.0.0




