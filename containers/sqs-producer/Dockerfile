FROM python:3.11-slim-bullseye

WORKDIR /usr/src/app

COPY . .

ARG USER=sqs_producer
ARG GROUP=sqs_producer

RUN apt-get update \
    && apt-get upgrade -y \
	&& rm -rf /var/lib/apt/lists/* \
    && useradd -rm -d /home/$USER -s /bin/bash $USER \
    && chown -R $USER:$GROUP /usr/src/app \
    && chmod +x ./entrypoint.sh

EXPOSE 8080

USER sqs_producer

ENV PATH $PATH:/home/$USER/.local/bin

RUN pip install --no-cache-dir -r requirements.txt

CMD ["sh", "entrypoint.sh" ]
