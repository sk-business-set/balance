#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	ПутьКФайлу = Интеграция1СБухфонВызовСервера.РасположениеИсполняемогоФайла(ИдентификаторКлиента);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если НЕ ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Для работы с приложением необходима операционная система Microsoft Windows.'"));
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Оповещение = Новый ОписаниеОповещения("ПутьКФайлуНачалоВыбораЗавершение", ЭтотОбъект);
	Интеграция1СБухфонКлиент.ВыбратьФайл1СБухфон(Оповещение, ПутьКФайлу);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	ИдентификаторКлиента = Интеграция1СБухфонКлиент.ИдентификаторКлиента();
	// Записывает путь к исполняемому файлу в регистр сведений.
	НовыйПутьКИсполняемомуФайлу(ИдентификаторКлиента, ПутьКФайлу); 
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбораЗавершение(НовыйПутьКФайлу, ДополнительныеПараметры) Экспорт
	Если НовыйПутьКФайлу <> "" Тогда
		ПутьКФайлу = НовыйПутьКФайлу;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура НовыйПутьКИсполняемомуФайлу(ИдентификаторКлиента, ПутьКФайлу)
	Интеграция1СБухфон.СохранитьРасположениеИсполняемогоФайла1СБухфон(ИдентификаторКлиента, ПутьКФайлу);
КонецПроцедуры 

#КонецОбласти





