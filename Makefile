# The make file

# load the various configurations from config file
cnf ?=config.env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


upload_files: ## upload yaml to stage $(SS_STAGE)
	snowsql --config ./demo-account-config -q " \
		PUT file://./streamlit_main.py @$(SS_DB).$(SS_SCHEMA).$(SS_STAGE) overwrite=true auto_compress=false; \
		PUT file://./environment.yml @$(SS_DB).$(SS_SCHEMA).$(SS_STAGE) overwrite=true auto_compress=false; \
		PUT file://./pages/data_frame_demo.py @$(SS_DB).$(SS_SCHEMA).$(SS_STAGE)/pages/ overwrite=true auto_compress=false; \
		PUT file://./pages/plot_demo.py @$(SS_DB).$(SS_SCHEMA).$(SS_STAGE)/pages/ overwrite=true auto_compress=false; \
		PUT file://./pages/admin.py @$(SS_DB).$(SS_SCHEMA).$(SS_STAGE)/pages/ overwrite=true auto_compress=false; \
		"
######################## COMPOSITE TARGETS ######################

all:upload_files