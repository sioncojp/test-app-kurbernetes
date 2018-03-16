FROM scratch

EXPOSE 8000

COPY test-app-kurbernetes /
CMD ["/test-app-kurbernetes"]
