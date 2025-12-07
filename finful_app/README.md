# finful_app

Android build
1. them file key.properties trong finful_app/android/key.properties

trong file key.properties them:

storePassword=123456finful
keyPassword=123456finful
keyAlias=finfulreleasekey
storeFile=../../Certificates/release-keystore.jks

2. sua build tu debug -> release
signingConfig = signingConfigs.getByName("release")


