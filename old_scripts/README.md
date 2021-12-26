# Upgrade BigBlueButton 2.2 to 2.4
1) first_script_upgared_os.sh<br />
   Удаляет старый BigBlueButton и обновляет Ubuntu до 18.04
2) second_script_update_and_upgrade.sh<br />
   Добавляет репозитории и обновляет пакеты с последующей перезагрузкой
3) third_script_install_new_bbb.sh<br />
   Устанавливает bbb
   
   Аргументы:<br />
   -s Домен сервера <br />
   -v Версия BigBlueButton <br />
   -e Email<br />
   
   Пример:<br />
   chmopd +x ./third_script_install_new_bbb.sh<br />
   ./third_script_install_new_bbb.sh -s example.mydomain.com -e exmaple@domain.com -v bionic-240
