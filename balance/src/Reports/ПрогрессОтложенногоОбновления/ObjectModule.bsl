#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ТаблицаРезультата = ЗарегистрированныеОбъекты();
	
	СтандартнаяОбработка = Ложь;
	НастройкиКД = КомпоновщикНастроек.ПолучитьНастройки();
	ВнешниеНаборыДанных = Новый Структура("ТаблицаРезультата", ТаблицаРезультата);
	
	КомпоновщикМакетаКД = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКД = КомпоновщикМакетаКД.Выполнить(СхемаКомпоновкиДанных, НастройкиКД, ДанныеРасшифровки);
	
	ПроцессорКД = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКД.Инициализировать(МакетКД, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	ПроцессорВыводаРезультатаКД = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаРезультатаКД.УстановитьДокумент(ДокументРезультат);
	ПроцессорВыводаРезультатаКД.Вывести(ПроцессорКД);
	
	ДокументРезультат.ПоказатьУровеньГруппировокСтрок(2);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗарегистрированныеОбъекты()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ОбновлениеИнформационнойБазы.Ссылка КАК Ссылка
		|ИЗ
		|	ПланОбмена.ОбновлениеИнформационнойБазы КАК ОбновлениеИнформационнойБазы";
	Результат = Запрос.Выполнить().Выгрузить();
	МассивУзлов = Результат.ВыгрузитьКолонку("Ссылка");
	СписокУзлов = Новый СписокЗначений;
	СписокУзлов.ЗагрузитьЗначения(МассивУзлов);
	
	ТаблицаРезультата = Новый ТаблицаЗначений;
	ТаблицаРезультата.Колонки.Добавить("СинонимКонфигурации");
	ТаблицаРезультата.Колонки.Добавить("ПолноеИмя");
	ТаблицаРезультата.Колонки.Добавить("ТипОбъекта");
	ТаблицаРезультата.Колонки.Добавить("Представление");
	ТаблицаРезультата.Колонки.Добавить("ТипМетаданных");
	ТаблицаРезультата.Колонки.Добавить("КоличествоОбъектов");
	ТаблицаРезультата.Колонки.Добавить("Очередь");
	ТаблицаРезультата.Колонки.Добавить("ОбработчикОбновления");
	ТаблицаРезультата.Колонки.Добавить("ВсегоОбъектов", Новый ОписаниеТипов("Число"));
	
	СоставПланаОбмена = Метаданные.ПланыОбмена.ОбновлениеИнформационнойБазы.Состав;
	СоответствиеПредставлений = Новый Соответствие;
	
	СинонимКонфигурации = Метаданные.Синоним;
	ТекстЗапроса = "";
	Запрос       = Новый Запрос;
	Запрос.УстановитьПараметр("СписокУзлов", СписокУзлов);
	Ограничение  = 0;
	Для Каждого ЭлементПланаОбмена Из СоставПланаОбмена Цикл
		ОбъектМетаданных = ЭлементПланаОбмена.Метаданные;
		Если Не ПравоДоступа("Чтение", ОбъектМетаданных) Тогда
			Продолжить;
		КонецЕсли;
		Представление    = ОбъектМетаданных.Представление();
		ПолноеИмя        = ОбъектМетаданных.ПолноеИмя();
		Если СтрНайти(ПолноеИмя, ".Перерасчет.") > 0 Тогда
			ПолноеИмя = СтрЗаменить(ПолноеИмя, "Перерасчет.", "");
		КонецЕсли;
		ПолноеИмяЧастями = СтрРазделить(ПолноеИмя, ".");
		
		ТекстЗапроса = ТекстЗапроса + ?(ТекстЗапроса = "", "", "ОБЪЕДИНИТЬ ВСЕ") + "
			|ВЫБРАТЬ
			|	""" + ПредставлениеТипаМетаданных(ПолноеИмяЧастями[0]) + """ КАК ТипМетаданных,
			|	""" + ПолноеИмяЧастями[1] + """ КАК ТипОбъекта,
			|	""" + ПолноеИмя + """ КАК ПолноеИмя,
			|	Узел.Очередь КАК Очередь,
			|	КОЛИЧЕСТВО(*) КАК КоличествоОбъектов
			|ИЗ
			|	" + ПолноеИмя + ".Изменения
			|ГДЕ
			|	Узел В (&СписокУзлов)
			|СГРУППИРОВАТЬ ПО
			|	Узел
			|";
		
		Ограничение = Ограничение + 1;
		СоответствиеПредставлений.Вставить(ПолноеИмяЧастями[1], Представление);
		Если Ограничение = 200 Тогда
			Запрос.Текст = ТекстЗапроса;
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				Строка = ТаблицаРезультата.Добавить();
				ЗаполнитьЗначенияСвойств(Строка, Выборка);
				Строка.СинонимКонфигурации = СинонимКонфигурации;
				Строка.Представление = СоответствиеПредставлений[Строка.ТипОбъекта];
			КонецЦикла;
			Ограничение  = 0;
			ТекстЗапроса = "";
			СоответствиеПредставлений = Новый Соответствие;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТекстЗапроса <> "" Тогда
		Запрос.Текст = ТекстЗапроса;
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Строка = ТаблицаРезультата.Добавить();
			ЗаполнитьЗначенияСвойств(Строка, Выборка);
			Строка.СинонимКонфигурации = СинонимКонфигурации;
			Строка.Представление = СоответствиеПредставлений[Строка.ТипОбъекта];
		КонецЦикла;
	КонецЕсли;
	
	ДанныеПоОбработчикам = ОбработчикиОбновления();
	Для Каждого ДанныеПоОбработчику Из ДанныеПоОбработчикам Цикл
		ИмяОбработчика = ДанныеПоОбработчику.Ключ;
		Для Каждого ДанныеПоОбъекту Из ДанныеПоОбработчику.Значение Цикл
			ПолноеИмяОбъекта = ДанныеПоОбъекту.Ключ;
			Очередь    = ДанныеПоОбъекту.Значение.Очередь;
			Количество = ДанныеПоОбъекту.Значение.Количество;
			
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("ПолноеИмя", ПолноеИмяОбъекта);
			ПараметрыОтбора.Вставить("Очередь", Очередь);
			Строки = ТаблицаРезультата.НайтиСтроки(ПараметрыОтбора);
			Для Каждого Строка Из Строки Цикл
				Если Не ЗначениеЗаполнено(Строка.ОбработчикОбновления) Тогда
					Строка.ОбработчикОбновления = ИмяОбработчика;
				Иначе
					Строка.ОбработчикОбновления = Строка.ОбработчикОбновления + "," + Символы.ПС + ИмяОбработчика;
				КонецЕсли;
				Строка.ВсегоОбъектов = Строка.ВсегоОбъектов + Количество;
			КонецЦикла;
			
			// Объект полностью обработан.
			Если Строки.Количество() = 0 Тогда
				Строка = ТаблицаРезультата.Добавить();
				ПолноеИмяЧастями = СтрРазделить(ПолноеИмяОбъекта, ".");
				
				Строка.СинонимКонфигурации = СинонимКонфигурации;
				Строка.ПолноеИмя     = ПолноеИмяОбъекта;
				Строка.ТипОбъекта    = ПолноеИмяЧастями[1];
				Строка.Представление = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъекта).Представление();
				Строка.ТипМетаданных = ПредставлениеТипаМетаданных(ПолноеИмяЧастями[0]);
				Строка.Очередь       = Очередь;
				Строка.ОбработчикОбновления = ИмяОбработчика;
				Строка.ВсегоОбъектов = Строка.ВсегоОбъектов + Количество;
				Строка.КоличествоОбъектов = 0;
			КонецЕсли;
			
		КонецЦикла;
	КонецЦикла;
	
	Возврат ТаблицаРезультата;
	
КонецФункции

Функция ПредставлениеТипаМетаданных(ТипМетаданных)
	
	Соответствие = Новый Соответствие;
	Соответствие.Вставить("Константа", НСтр("ru = 'Константы'"));
	Соответствие.Вставить("Справочник", НСтр("ru = 'Справочники'"));
	Соответствие.Вставить("Документ", НСтр("ru = 'Документы'"));
	Соответствие.Вставить("ПланВидовХарактеристик", НСтр("ru = 'Планы видов характеристик'"));
	Соответствие.Вставить("ПланСчетов", НСтр("ru = 'Планы счетов'"));
	Соответствие.Вставить("ПланВидовРасчета", НСтр("ru = 'Планы видов расчета'"));
	Соответствие.Вставить("РегистрСведений", НСтр("ru = 'Регистры сведений'"));
	Соответствие.Вставить("РегистрНакопления", НСтр("ru = 'Регистры накопления'"));
	Соответствие.Вставить("РегистрБухгалтерии", НСтр("ru = 'Регистры бухгалтерии'"));
	Соответствие.Вставить("РегистрРасчета", НСтр("ru = 'Регистры расчета'"));
	Соответствие.Вставить("БизнесПроцесс", НСтр("ru = 'Бизнес процессы'"));
	Соответствие.Вставить("Задача", НСтр("ru = 'Задачи'"));
	
	Возврат Соответствие[ТипМетаданных];
	
КонецФункции

Функция ОбработчикиОбновления()
	
	СведенияОбОбновлении = ОбновлениеИнформационнойБазыСлужебный.СведенияОбОбновленииИнформационнойБазы();
	ОбрабатываемыеДанные = СведенияОбОбновлении.ОбрабатываемыеДанные;
	
	Возврат ОбрабатываемыеДанные;
	
КонецФункции

#КонецОбласти

#КонецЕсли

