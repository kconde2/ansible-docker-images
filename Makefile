PROVISION=kabaconde/ansible-docker:provision
DEPLOYMENT=kabaconde/ansible-docker:deployment

bpush-provision:
	docker build --squash --tag $(PROVISION) --file `pwd`/docker/python/Dockerfile `pwd` --build-arg IS_DEPLOYMENT=false
	docker push $(PROVISION)

bpush-deployment:
	docker build --squash --tag $(DEPLOYMENT) --file `pwd`/docker/python/Dockerfile `pwd`
	docker push $(DEPLOYMENT)
