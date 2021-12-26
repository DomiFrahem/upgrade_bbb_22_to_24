#Upgrade BigBlueButton 2.2 to 2.4

ARGS:
-D      Удаляет полность BigBlueButton
-S      Стадия обновления
        Первая стадия:
        <span>./script.sh -S 1</span>
        Удаляет полность BigBlueButton и обновляет до Ubuntu 18.04
        Вторая стадия:
        ./script.sh -S 2
        Обновляет репозитори, обновляет пакеты и перегружает систему
        Третья стадия:
        Установка BigBlueButton
        ./script.sh -s example.mydomain.com -e exmaple@domain.com -v bionic-240 -g
        -s Наименования домена
        -e Email: Default = exmaple@domain.com
        -v Версия BigBlueButton: Default = bionic-240
        -g Устанавить greenlight
-h      Вызов этого сообщения