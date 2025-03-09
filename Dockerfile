FROM node:22-alpine AS node

WORKDIR /app

COPY web ./web

RUN cd web && npm install && npm run build

FROM python:3.10.13-slim

WORKDIR /app

COPY . .

COPY --from=node /app/web/dist ./web/dist

RUN apt update \
    && apt install gcc -y \
    && python -m pip install -r requirements.txt \
    && touch /.dockerenv

# Expose the application ports
EXPOSE 2280
EXPOSE 5300

CMD [ "python", "main.py" ]