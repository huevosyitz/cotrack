rmdir /s /q "build/web" && ^
flutter build web  --dart-define-from-file=.env --base-href /cotrack/ --release && ^
cd build/web && ^
git init && ^
git add . && ^
git commit -m "deploy" && ^
git branch -M main && ^
git remote add origin https://github.com/huevosyitz/cotrack.git && ^
git push -u -f origin main