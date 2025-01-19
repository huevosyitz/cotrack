set repo="F:\huevosyitz.github.io\cotrack"
flutter build web  --dart-define-from-file=.env --base-href /cotrack/ --release && ^
move /y build\web\*.* %repo% && ^
cd %repo% && ^
git add . && ^
git commit -m "deploy" && ^
git push -f origin main