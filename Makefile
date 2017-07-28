

ANNOTATION_NAMESPACE = yolean.se/kubernetes-kafka/
GIT_START_REV = $(shell git rev-parse --short HEAD)
GIT_START_STATUS =

start:
	git status -s
	[ -z $(git status --untracked-files=no -s) ]
	#override GIT_START_REV := $($())
	echo "A start"

annotate:
	echo "A end $(GIT_START_REV) $(ANNOTATION_NAMESPACE)"

prod-merge-yolean:
	echo "A prod"

yolean: start prod-merge-yolean annotate
