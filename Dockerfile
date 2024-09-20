FROM golang:1.19 
WORKDIR /app
COPY myapp .
RUN groupadd -r appgroup && useradd -r -g appgroup appuser && chown -R appuser:appgroup /app
EXPOSE 8080
USER appuser
ENV DB_HOST=172.17.0.3 \
    DB_USER=myuser \
    DB_PASSWORD=mypassword \
    DB_NAME=mydb \
    DB_PORT=5432 \
    ALLOWED_ORIGINS=*
CMD ["./myapp"]
