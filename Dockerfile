FROM swift:5.1.3
RUN apt-get update
RUN apt-get install -y libssl-dev zlib1g-dev
RUN mkdir /app
COPY . /app
WORKDIR /app

RUN swift build -c release

ENTRYPOINT "$(swift build -c release --show-bin-path)/Run" serve --hostname 0.0.0.0 --port 8080
