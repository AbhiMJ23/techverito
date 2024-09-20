FROM golang:1.19-slim
WORKDIR /app
COPY ./backend/myapp .
RUN groupadd -r appgroup && useradd -r -g appgroup appuser && chown -R appuser:appgroup /app
EXPOSE 8080
USER appuser
ENV DB_HOST=172.17.0.2 \
    DB_USER=myuser \
    DB_PASSWORD=mypassword \
    DB_NAME=mydb \
    DB_PORT=5432 \
    ALLOWED_ORIGINS=*
CMD ["./myapp"]
