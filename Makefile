clean: 
	rm -rf public

#################################
# Build the site using blogdown #
#################################

build:
	R -e "blogdown::build_site()"

######################
# Serve site locally #
######################

serve:
	R -e "blogdown::serve_site()"

#########################
# Deploy site to GitHub #
#########################

deploy: build
	GIT_DEPLOY_DIR=public GIT_DEPLOY_BRANCH=master ./deploy.sh
