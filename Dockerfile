FROM alpine
WORKDIR /app/build
#COPY ./ympd /app
RUN apk add --no-cache g++ make cmake libmpdclient-dev openssl-dev curl tar
RUN curl -Sl "https://codeload.github.com/notandy/ympd/tar.gz/refs/tags/v1.3.0" | tar xz -C /app --strpi-components=1
RUN cmake ..
RUN make

FROM alpine
RUN apk add  --no-cache libmpdclient openssl
COPY --from=0 /app/build/ympd /usr/bin/ympd
COPY --from=0 /app/build/mkdata /usr/bin/mkdata

ENV MPD_SERVER=localhost
ENV MPD_PORT=6600

EXPOSE 8080
CMD ympd -h $MPD_SERVER -p $MPD_PORT -w 8080
