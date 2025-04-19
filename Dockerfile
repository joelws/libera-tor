FROM debian:bookworm-slim

LABEL org.opencontainers.image.source=https://github.com/joelws/libera-tor

RUN apt update && apt install -y tor curl && apt clean

COPY torrc /etc/tor/torrc

EXPOSE 9050

CMD ["tor", "-f", "/etc/tor/torrc"]
