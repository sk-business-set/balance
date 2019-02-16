
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РежимРаботы = Константы.РежимИспользованияИнформационнойБазы.Получить();
	Если РежимРаботы = Перечисления.РежимыИспользованияИнформационнойБазы.Демонстрационный Тогда
		ВызватьИсключение(НСтр("ru = 'В демонстрационном режиме не доступно добавление новых пользователей'"));
	КонецЕсли;
	
	// Форма недоступна пока подготовка не закончена.
	Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПарольПользователяСервиса = Неопределено Тогда
		Отказ = Истина;
		ПодключитьОбработчикОжидания("ЗапроситьПарольДляАутентификацииВСервисе", 0.1, Истина);
	Иначе
		ПодготовитьФорму();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьВсе(Команда)
	
	Для каждого СтрокаТаблицы Из ПользователиСервиса Цикл
		Если СтрокаТаблицы.Доступ Тогда
			Продолжить;
		КонецЕсли;
		СтрокаТаблицы.Добавить = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	Для каждого СтрокаТаблицы Из ПользователиСервиса Цикл
		СтрокаТаблицы.Добавить = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВыбранныхПользователей(Команда)
	
	ДобавитьВыбранныхПользователейНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПользователиСервисаДобавить.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПользователиСервиса.Доступ");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПользователиСервисаДобавить.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПользователиСервисаИмя.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПользователиСервисаПолноеИмя.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПользователиСервисаДоступ.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПользователиСервиса.Доступ");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);

КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьПарольДляАутентификацииВСервисе()
	
	СтандартныеПодсистемыКлиент.ПриЗапросеПароляДляАутентификацииВСервисе(
		Новый ОписаниеОповещения("ПриОткрытииПродолжение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииПродолжение(НовыйПарольПользователяСервиса, Неопределен) Экспорт
	
	Если НовыйПарольПользователяСервиса <> Неопределено Тогда
		ПарольПользователяСервиса = НовыйПарольПользователяСервиса;
		Открыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФорму()
	
	ПользователиСлужебныйВМоделиСервиса.ПолучитьДействияСПользователемСервиса(
		Справочники.Пользователи.ПустаяСсылка());
		
	ТаблицаПользователей = ПользователиСлужебныйВМоделиСервиса.ПолучитьПользователейСервиса(
		ПарольПользователяСервиса);
		
	Для каждого ИнформацияОПользователе Из ТаблицаПользователей Цикл
		СтрокаПользователя = ПользователиСервиса.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПользователя, ИнформацияОПользователе);
	КонецЦикла;
	
	Доступность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВыбранныхПользователейНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Счетчик = 0;
	КоличествоСтрок = ПользователиСервиса.Количество();
	Для Счетчик = 1 По КоличествоСтрок Цикл
		СтрокаТаблицы = ПользователиСервиса[КоличествоСтрок - Счетчик];
		Если НЕ СтрокаТаблицы.Добавить Тогда
			Продолжить;
		КонецЕсли;
		
		ПользователиСлужебныйВМоделиСервиса.ПредоставитьДоступПользователюСервиса(
			СтрокаТаблицы.Идентификатор, ПарольПользователяСервиса);
		
		ПользователиСервиса.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
