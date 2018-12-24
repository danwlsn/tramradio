#!/bin/sh

APPLICATION="tramradio-fe"
ENVIRONMENT="dev"

ARTIFACT="upload.zip"
BUILD_NUMBER=$( date +"%Y%m%d%H%M" )

echo "Building JS"
yarn build

echo "Building reqs.txt"
pipenv lock -r > requirements.txt


echo "Build zip file"
zip ./${ARTIFACT} . -x node_modules/\* -x src/\* -x README.md -x deploy.sh -x package.json -x Pipfile* -x yarn.lock -r

echo "Uploading build"
aws s3 cp ${ARTIFACT} s3://elasticbeanstalk-eu-west-1-847878515230/versions/${APPLICATION}/${BUILD_NUMBER}.zip

echo "Creating new application version: ${BUILD_NUMBER}"
aws elasticbeanstalk create-application-version \
    --region "eu-west-1" \
    --application-name "${APPLICATION}" \
    --version-label "${BUILD_NUMBER}" \
    --source-bundle S3Bucket="elasticbeanstalk-eu-west-1-847878515230",S3Key="versions/${APPLICATION}/${BUILD_NUMBER}.zip" \


echo "Updated application with version: ${BUILD_NUMBER}"
aws elasticbeanstalk update-environment \
    --region "eu-west-1" \
    --environment-name "${APPLICATION}-${ENVIRONMENT}" \
    --version-label "${BUILD_NUMBER}"
