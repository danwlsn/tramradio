#!/bin/sh

ARTIFACT="upload.zip"
VERSION=$1

echo "Building JS"
yarn build


echo "Build zip file"
cd build
zip ../${ARTIFACT} -r *
cd ../

echo "Uploading build"
aws s3 cp ${ARTIFACT} s3://elasticbeanstalk-eu-west-1-847878515230/versions/tramradio/${VERSION}.zip
sleep 2

echo "Creating new application version: ${VERSION}"
aws elasticbeanstalk create-application-version \
    --region "eu-west-1" \
    --application-name "tramradio" \
    --version-label "${VERSION}" \
    --source-bundle S3Bucket="elasticbeanstalk-eu-west-1-847878515230",S3Key="versions/tramradio/${VERSION}.zip" \


echo "Updated application with version: ${VERSION}"
aws elasticbeanstalk update-environment \
    --region "eu-west-1" \
    --environment-name "tramradio-dev" \
    --version-label "${VERSION}"
