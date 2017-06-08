clean: 
	rm -rf public

######################
# Serve site locally #
######################

serve:
	R -e "blogdown::serve_site()"

#################################
# Build the site using blogdown #
#################################

build:
	R -e "blogdown::build_site()"

#########################
# Deploy site to GitHub #
#########################

deploy: clean build
	GIT_DEPLOY_DIR=public GIT_DEPLOY_BRANCH=master ./deploy.sh
