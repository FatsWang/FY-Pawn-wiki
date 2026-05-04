@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

:: =================配置区=================
:: 设置获取最近几天的日志（建议设为 3，防止漏掉跨天更新）
set DAYS_AGO=3
:: 设置文件名
set TARGET_FILE=CHANGELOG.md
set TEMP_NEW=NEW_LOGS.tmp
set TEMP_FINAL=FINAL.tmp
:: ========================================

echo 🔍 正在检索最近 %DAYS_AGO% 天的更新记录...

:: 1. 获取最近 X 天的日志并排除 PicGo 提交，存入临时文件
:: 注意：这里只抓取最近的，不会抓取到你已经删除的 4-10 之前的历史
git log --since="%DAYS_AGO%.days.ago" --grep="PicGo" --invert-grep --date=short --pretty=format:"### %%ad %%n- %%s (%%h)%%n" > %TEMP_NEW%

:: 2. 检查是否有新内容生成
for /f "usebackq" %%A in ('%TEMP_NEW%') do set size=%%~zA

if %size% GTR 0 (
    echo ✨ 发现新动态，正在追加到顶部...
    
    :: 3. 核心步骤：将新日志和旧文件内容合并 (新在前，旧在后)
    :: 使用 copy /b 是为了确保编码（如 UTF-8）在合并时不损坏
    copy /b %TEMP_NEW% + %TARGET_FILE% %TEMP_FINAL% >nul
    
    :: 4. 覆盖原文件
    move /y %TEMP_FINAL% %TARGET_FILE% >nul
    
    echo ✅ %TARGET_FILE% 已更新。
) else (
    echo ℹ️ 最近 %DAYS_AGO% 天没有新的非 PicGo 提交记录。
)

:: 5. 清理残留
if exist %TEMP_NEW% del %TEMP_NEW%

pause