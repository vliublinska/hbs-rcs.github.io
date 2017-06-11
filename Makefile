clean: 
	rm -rf public

#######################################
# Serve site locally, includes drafts #
#######################################

serve:
	R -e "blogdown::serve_site()"

#########################################
# Build the site, no drafts             #
# To preview the site use `hugo server` #
#########################################

build:
	R -e "library(blogdown)" -e "build_site(local = TRUE)" -e "hugo_build(local = FALSE)"

#########################
# Deploy site to GitHub #
#########################

deploy: clean build
	GIT_DEPLOY_DIR=public GIT_DEPLOY_BRANCH=master ./deploy.sh
