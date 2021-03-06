
&НаКлиенте
Процедура ЗагрузитьКурсы(Команда)
	ПолучитьКурсыВалют(Объект.ТипЗагрузки);
КонецПроцедуры

&НаКлиенте
Функция ПолучитьКурсыВалют(ТипЗагрузки)
	
	//Сервер
	Сервер = "www.cbr.ru";
	
	//Курс всех валют на последнюю дату
	Если ТипЗагрузки = 1 Тогда
	Адрес = "scripts/XML_daily.asp";
	НаДату="?date_req="+Формат(ТекуЩаяДата(),"ДФ=dd/MM/yyyy");
ИначеЕсли ТипЗагрузки = 2 Тогда
	
	//Курс всех валют определенную дату
	//Адрес = "scripts/XML_daily.asp?date_req=24/08/2016";
	
	//Курс Евро за период
	//Valute ID="R01235"
	//="R01239"
	Адрес = "scripts/XML_daily.asp";
	НаДату="?date_req1="+Формат(Объект.ДатаНачала,"ДФ=dd/MM/yyyy")+"&date_req2="+Формат(Объект.ДатаОкончания,"ДФ=dd/MM/yyyy");	
КонецЕсли;

	Попытка
		HTTP = Новый HTTPСоединение(Сервер);
	Исключение
		Сообщить("Не удалось подключиться");
		Возврат Ложь;
	КонецПопытки;
	
	HTTPЗапрос = Новый HTTPЗапрос(Адрес+НаДату); 
	HTTPОтвет = HTTP.Получить(HTTPЗапрос);
	Текст = HTTPОтвет.ПолучитьТелоКакСтроку("windows-1251");
		
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(Текст);
	
	Валюта=Новый Структура("NumCode,CharCode,Nominal,Value");
	Пока ЧтениеXML.Прочитать() Цикл
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			Если ЧтениеXML.Имя = "Valute" Тогда
				Валюта.NumCode = Неопределено;
				Валюта.CharCode = Неопределено;
				Валюта.Nominal = Неопределено;
				Валюта.Value = Неопределено;
			Иначе
				текЭлем=ЧтениеXML.Имя;
			КонецЕсли;
		ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
			Если Валюта.Свойство(текЭлем) Тогда
				Валюта.Вставить(текЭлем, XMLЗначение(Тип("Строка"), ЧтениеXML.Значение));
			КонецЕсли;
		ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			Если ЧтениеXML.Имя = "Valute" Тогда
				Сообщить(Валюта.NumCode+" \ "+Валюта.CharCode+" \ "+Валюта.Nominal+" \ "+Валюта.Value);
				
			КонецЕсли;
		КонецЕсли;
	
	КонецЦикла;
	
КонецФункции

&НаКлиенте
Процедура ТипЗагрузкиПриИзменении(Элемент)
	ПолучитьКурсыВалют(Объект.ТипЗагрузки)	
КонецПроцедуры                             
