# STAGE 1: Build
# i'm using an official Go-image to compile the code.

FROM golang:1.21-alpine AS builder

WORKDIR /app

#copy go.mod (created with 'go mod init')
COPY go.mod ./
# If you have external librariesl, run: RUN go mod download

#copy sourcecode (main.go)
COPY main.go .

#compile application to a static binary file.
#CGO_ENABLED=0 makes it so it does not need external C-libraries (important for alpine/scratch)
RUN CGO_ENABLED=0 GOOS=linux go build -o network-probe main.go

#STAGE 2: Run
#i'm swapping to Alpine linux for the last image (weighs only ~5MB)
FROM alpine:latest

#Install ca-cert så we can make HTTPS-calls (important for API's)
RUN apk --no-cache add ca-certificates

WORKDIR /root/

#Copy ONLY the finnished binary from the builder-stage
COPY --from=builder /app/network-probe .

#Run the program
CMD ["./network-probe"]
