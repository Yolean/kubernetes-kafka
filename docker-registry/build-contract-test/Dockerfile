FROM alpine:3.8@sha256:7043076348bf5040220df6ad703798fd8593a0918d06d3ce30c6c93be117e430

# Something that keeps running and prints whatever
ENTRYPOINT [ "tail", "-f", "/etc/hostname" ]

ARG GitCommit
LABEL se.yolean.build.git.ref=$GitCommit
