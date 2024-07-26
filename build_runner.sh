#!/bin/bash

# پیام خوشامدگویی
echo "Welcome to the Build Runner Wizard!"

# نمایش گزینه‌ها به کاربر
echo "Please select an option:"
echo "1. Automatic Execution"
echo "2. Manual Execution"
echo "3. Re-Build Translations Files"
echo "4. Re-Generate Asset Files"

# خواندن ورودی از کاربر
read -p "Enter your choice (1, 2 , 3 or 4): " choice

# بررسی گزینه انتخابی و اجرای دستورات مربوطه
case $choice in
    1)
        echo "* You selected Automatic Execution."
        # اجرای دستور اتوماتیک

        # مرحله بازسازی فایل‌های ترجمه
        dart run easy_localization:generate --source-dir=assets/localizations --output-dir=lib/core/utils/gen/localization
        dart run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir=assets/localizations --output-dir=lib/core/utils/gen/localization
        dart run build_runner build  --delete-conflicting-outputs --build-filter="lib\core\constants\localization\*.dart"

        # مرحله اجرای دستور بیلد رانر اتوماتیک
        dart run build_runner build --delete-conflicting-outputs
        ;;
    2)
        echo "* You selected Manual Execution."
        # خواندن متن مورد نظر از کاربر
        read -p "Enter your text (comma-separated list for multiple items): " text

        # تبدیل متن ورودی به آرایه با استفاده از ',' به عنوان جداکننده
        IFS=',' read -r -a text_array <<< "$text"

        # حلقه برای اجرای دستور برای هر مورد در آرایه
        for item in "${text_array[@]}"
        do
            # جایگزینی '/' با '\' در متن ورودی
            text_with_backslashes=$(echo "$item" | sed 's/\//\\/g')
            # جایگزینی متن مورد نظر در دستور و اجرای آن
            dart run build_runner build --delete-conflicting-outputs --build-filter="$text_with_backslashes\*.dart"
        done
        ;;
    3)
        echo "* You selected Re-Build Translations Files."
        # اجرای دستورات مربوط به بازسازی فایل‌های ترجمه
        dart run easy_localization:generate --source-dir=assets/translations --output-dir=lib/src/core/utils/gen/localization
        dart run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir=assets/translations --output-dir=lib/src/core/utils/gen/localization
        dart run build_runner build  --delete-conflicting-outputs --build-filter="lib\src\core\constants\localization\*.dart"
        ;;
    4)
        echo "* You selected Re-Generate Asset Files."
        # اجرای دستورات مربوط به بازسازی فایل‌های اسست
        dart run build_runner build  --delete-conflicting-outputs --build-filter="lib\src\core\utils\gen\assets\*.dart"
        ;;
    *)
        echo "* Invalid choice. Please enter 1, 2, 3,or 4."
        ;;
esac
