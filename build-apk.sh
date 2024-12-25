if [ ! -n "$1" ]
then
	echo "$0 - require build number"
else
  echo $1
  flutter build apk --build-number=$1
  cp build/app/outputs/flutter-apk/app-dev-release.apk ~/Desktop/hit_moment_1.0.0_$1.apk
fi