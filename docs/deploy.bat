@echo off
chcp 65001 >nul
echo 🚀 正在生成更新日志 (已过滤 PicGo 提交)...
git log --grep="PicGo" --invert-grep --date=short --pretty=format:"### %%ad %%n- %%s (%%h)" > CHANGELOG.md



echo 🎉 CHANGELOG编写成功！。
pause