FROM golang:1.19-slim
WORKDIR /app
COPY ./backend/myapp .
RUN groupadd -r appgroup && useradd -r -g appgroup appuser && chown -R appuser:appgroup /app
EXPOSE 8080
USER appuser
CMD ["./myapp"]
