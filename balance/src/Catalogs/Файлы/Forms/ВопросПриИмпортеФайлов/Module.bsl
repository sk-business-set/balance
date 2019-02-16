
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ФайлыБольшие = Параметры.ФайлыБольшие;
	
	МаксимальныйРазмерФайла = Цел(ФайловыеФункции.МаксимальныйРазмерФайла() / (1024 * 1024));
	
	Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	    НСтр("ru = 'Некоторые файлы превышают предельный размер (%1 Мб) и не будут добавлены в хранилище.
	               |Продолжить импорт?'"),
	    Строка(МаксимальныйРазмерФайла) );
	
	Заголовок = Параметры.Заголовок;
	
КонецПроцедуры

#КонецОбласти
