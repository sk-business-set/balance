
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВидОтчета = "АнализОтветов";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаОтчетаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Расшифровка.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный") Тогда
		
		СтруктураОткрытия = Новый Структура;
		СтруктураОткрытия.Вставить("Опрос", Опрос);
		СтруктураОткрытия.Вставить("ВопросШаблонаАнкеты", Расшифровка.ВопросШаблона);
		СтруктураОткрытия.Вставить("ПолныйКод", Расшифровка.ПолныйКод);
		СтруктураОткрытия.Вставить("НаименованиеОпроса", НаименованиеОпроса);
		СтруктураОткрытия.Вставить("ДатаОпроса", ДатаОпроса);
		
		ОткрытьФорму("Отчет.АнализОпроса.Форма.РасшифровкаТабличныхВопросов", СтруктураОткрытия, ЭтотОбъект);
		
	Иначе
		
		СтруктураОткрытия = Новый Структура;
		СтруктураОткрытия.Вставить("Опрос", Опрос);
		СтруктураОткрытия.Вставить("ВопросШаблонаАнкеты", Расшифровка.ВопросШаблона);
		СтруктураОткрытия.Вставить("ВариантОтчета", "Респонденты");
		СтруктураОткрытия.Вставить("ПолныйКод", Расшифровка.ПолныйКод);
		СтруктураОткрытия.Вставить("НаименованиеОпроса", НаименованиеОпроса);
		СтруктураОткрытия.Вставить("ДатаОпроса", ДатаОпроса);
		
		ОткрытьФорму("Отчет.АнализОпроса.Форма.РасшифровкаПростыхОтветов", СтруктураОткрытия, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СформироватьОтчет();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьОтчет()
	
	РеквизитФормыВЗначение("Отчет").СформироватьОтчет(ТаблицаОтчета, Опрос, ВидОтчета);
	РеквизитыОпрос     = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Опрос,"Наименование, Дата");
	НаименованиеОпроса = РеквизитыОпрос.Наименование;
	ДатаОпроса         = РеквизитыОпрос.Дата;
	
КонецПроцедуры

#КонецОбласти
