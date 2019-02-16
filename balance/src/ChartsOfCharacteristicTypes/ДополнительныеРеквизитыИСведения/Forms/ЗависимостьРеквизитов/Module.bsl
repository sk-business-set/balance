#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	НастраиваемоеСвойство = Параметры.НастраиваемоеСвойство;
	
	СвойстваОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.ДополнительныйРеквизит, "Заголовок");
	
	Заголовок = НСтр("ru = '%1 дополнительного реквизита ""%2""'");
	Если НастраиваемоеСвойство = "Доступен" Тогда
		ПредставлениеСвойства = НСтр("ru = 'Доступность'");
	ИначеЕсли НастраиваемоеСвойство = "ЗаполнятьОбязательно" Тогда
		ПредставлениеСвойства = НСтр("ru = 'Обязательность заполнения'");
	Иначе
		ПредставлениеСвойства = НСтр("ru = 'Видимость'");
	КонецЕсли;
	Заголовок = СтрЗаменить(Заголовок, "%1", ПредставлениеСвойства);
	Заголовок = СтрЗаменить(Заголовок, "%2", СвойстваОбъекта.Заголовок);
	
	Если Не ЗначениеЗаполнено(СвойстваОбъекта.Заголовок)  Тогда
		Заголовок = СтрЗаменить(Заголовок, """", "");
	КонецЕсли;
	
	НаборСвойств = Параметры.Набор;
	Пока ЗначениеЗаполнено(НаборСвойств.Родитель) Цикл
		НаборСвойств = НаборСвойств.Родитель;
	КонецЦикла;
	
	НаборДополнительныхРеквизитов = НаборСвойств.ДополнительныеРеквизиты;
	
	ИмяПредопределенныхДанных = НаборСвойств.ИмяПредопределенныхДанных;
	ПозицияЗаменяемогоСимвола = СтрНайти(ИмяПредопределенныхДанных, "_");
	ПолноеИмяОбъектаМетаданных = Лев(ИмяПредопределенныхДанных, ПозицияЗаменяемогоСимвола - 1)
		                       + "."
		                       + Сред(ИмяПредопределенныхДанных, ПозицияЗаменяемогоСимвола + 1);
	
	РеквизитыОбъекта = СписокРеквизитовДляОтбора(ПолноеИмяОбъектаМетаданных, НаборДополнительныхРеквизитов);
	
	ЗависимостиДополнительныхРеквизитов = Параметры.ЗависимостиРеквизитов;
	Для Каждого СтрокаТабличнойЧасти Из ЗависимостиДополнительныхРеквизитов Цикл
		Если СтрокаТабличнойЧасти.ЗависимоеСвойство = НастраиваемоеСвойство Тогда
			СтрокаОтбора = ЗависимостиРеквизитов.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаОтбора, СтрокаТабличнойЧасти);
			
			ОписаниеРеквизита = РеквизитыОбъекта.Найти(СтрокаОтбора.Реквизит, "Реквизит");
			Если ОписаниеРеквизита = Неопределено Тогда
				Продолжить; // Реквизит объекта не найден.
			КонецЕсли;
			СтрокаОтбора.Представление = ОписаниеРеквизита.Представление;
			СтрокаОтбора.ТипЗначения   = ОписаниеРеквизита.ТипЗначения;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормы

&НаКлиенте
Процедура ЗависимостиРеквизитовРеквизитНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуВыбораРеквизита();
КонецПроцедуры

&НаКлиенте
Процедура ЗависимостиРеквизитовПередНачаломИзменения(Элемент, Отказ)
	ЗависимостиРеквизитовУстановитьОграничениеТиповДляЗначения();
КонецПроцедуры

&НаКлиенте
Процедура ЗависимостиРеквизитовВидСравненияПриИзменении(Элемент)
	ТекущаяСтрока = ЗависимостиРеквизитов.НайтиПоИдентификатору(Элементы.ЗависимостиРеквизитов.ТекущаяСтрока);
	ТекущаяСтрока.Значение = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура ЗависимостиРеквизитовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Не ДобавлениеСтроки Тогда
		Отказ = Истина;
	Иначе
		ОткрытьФормуВыбораРеквизита();
		ДобавлениеСтроки = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораРеквизита()
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РеквизитыОбъекта", РеквизитыОбъектаВХранилище);
	ОткрытьФорму("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Форма.ВыборРеквизита", ПараметрыФормы);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьУсловие(Команда)
	ДобавлениеСтроки = Истина;
	Элементы.ЗависимостиРеквизитов.ДобавитьСтроку();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОк(Команда)
	Результат = Новый Структура;
	Результат.Вставить(НастраиваемоеСвойство, НастройкиОтбораВХранилищеЗначений());
	Оповестить("Свойства_УстановленаЗависимостьРеквизита", Результат);
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция НастройкиОтбораВХранилищеЗначений()
	
	Если ЗависимостиРеквизитов.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТаблицаЗависимостей = РеквизитФормыВЗначение("ЗависимостиРеквизитов");
	КопияТаблицы = ТаблицаЗависимостей.Скопировать();
	КопияТаблицы.Колонки.Удалить("Представление");
	КопияТаблицы.Колонки.Удалить("ТипЗначения");
	
	Возврат Новый ХранилищеЗначения(КопияТаблицы);
	
КонецФункции

&НаСервере
Функция СписокРеквизитовДляОтбора(ПолноеИмяОбъектаМетаданных, НаборДополнительныхРеквизитов)
	
	РеквизитыОбъекта = Новый ТаблицаЗначений;
	РеквизитыОбъекта.Колонки.Добавить("Реквизит");
	РеквизитыОбъекта.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	РеквизитыОбъекта.Колонки.Добавить("ТипЗначения", Новый ОписаниеТипов);
	РеквизитыОбъекта.Колонки.Добавить("НомерКартинки", Новый ОписаниеТипов("Число"));
	РеквизитыОбъекта.Колонки.Добавить("РежимВыбора", Новый ОписаниеТипов("ИспользованиеГруппИЭлементов"));
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъектаМетаданных);
	
	Для Каждого ДополнительныйРеквизит Из НаборДополнительныхРеквизитов Цикл
		СвойстваОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДополнительныйРеквизит.Свойство, "Наименование, ТипЗначения");
		СтрокаРеквизит = РеквизитыОбъекта.Добавить();
		СтрокаРеквизит.Реквизит = ДополнительныйРеквизит.Свойство;
		СтрокаРеквизит.Представление = СвойстваОбъекта.Наименование;
		СтрокаРеквизит.НомерКартинки  = 2;
		СтрокаРеквизит.ТипЗначения = СвойстваОбъекта.ТипЗначения;
	КонецЦикла;
	
	Для Каждого Реквизит Из ОбъектМетаданных.СтандартныеРеквизиты Цикл
		ДобавитьРеквизитВТаблицу(РеквизитыОбъекта, Реквизит, Истина);
	КонецЦикла;
	
	Для Каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
		ДобавитьРеквизитВТаблицу(РеквизитыОбъекта, Реквизит, Ложь);
	КонецЦикла;
	
	РеквизитыОбъекта.Сортировать("Представление Возр");
	
	РеквизитыОбъектаВХранилище = ПоместитьВоВременноеХранилище(РеквизитыОбъекта, УникальныйИдентификатор);
	
	Возврат РеквизитыОбъекта;
	
КонецФункции

&НаСервере
Процедура ДобавитьРеквизитВТаблицу(РеквизитыОбъекта, Реквизит, Стандартный)
	СтрокаРеквизит = РеквизитыОбъекта.Добавить();
	СтрокаРеквизит.Реквизит = Реквизит.Имя;
	СтрокаРеквизит.Представление = Реквизит.Представление();
	СтрокаРеквизит.НомерКартинки  = 1;
	СтрокаРеквизит.ТипЗначения = Реквизит.Тип;
	Если Стандартный Тогда
		СтрокаРеквизит.РежимВыбора = ?(Реквизит.Имя = "Родитель", ИспользованиеГруппИЭлементов.Группы, Неопределено);
	Иначе
		СтрокаРеквизит.РежимВыбора = Реквизит.ВыборГруппИЭлементов;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Свойства_ВыборРеквизитаОбъекта" Тогда
		ТекущаяСтрока = ЗависимостиРеквизитов.НайтиПоИдентификатору(Элементы.ЗависимостиРеквизитов.ТекущаяСтрока);
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, Параметр);
		ЗависимостиРеквизитовУстановитьОграничениеТиповДляЗначения();
		ТекущаяСтрока.ЗависимоеСвойство = НастраиваемоеСвойство;
		ТекущаяСтрока.Условие   = "Равно";
		ТекущаяСтрока.Значение = ТекущаяСтрока.ТипЗначения.ПривестиЗначение(Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗависимостиРеквизитовУстановитьОграничениеТиповДляЗначения()
	
	ТаблицаФормы = Элементы.ЗависимостиРеквизитов;
	ПолеВвода    = Элементы.ЗависимостиРеквизитовПравоеЗначение;
	
	ПараметрыВыбораМассив = Новый Массив;
	Если ТипЗнч(ТаблицаФормы.ТекущиеДанные.Реквизит) <> Тип("Строка") Тогда
		ПараметрыВыбораМассив.Добавить(Новый ПараметрВыбора("Отбор.Владелец", ТаблицаФормы.ТекущиеДанные.Реквизит));
	КонецЕсли;
	
	РежимВыбора = ТаблицаФормы.ТекущиеДанные.РежимВыбора;
	Если РежимВыбора = ИспользованиеГруппИЭлементов.Группы Тогда
		ПолеВвода.ВыборГруппИЭлементов = ГруппыИЭлементы.Группы;
	ИначеЕсли РежимВыбора = ИспользованиеГруппИЭлементов.Элементы Тогда
		ПолеВвода.ВыборГруппИЭлементов = ГруппыИЭлементы.Элементы;
	ИначеЕсли РежимВыбора = ИспользованиеГруппИЭлементов.ГруппыИЭлементы Тогда
		ПолеВвода.ВыборГруппИЭлементов = ГруппыИЭлементы.ГруппыИЭлементы;
	КонецЕсли;
	
	ПолеВвода.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораМассив);
	ПолеВвода.ОграничениеТипа = ТаблицаФормы.ТекущиеДанные.ТипЗначения;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементДоступность = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Доступность");
	ЭлементДоступность.Значение = Ложь;
	ЭлементДоступность.Использование = Истина;
	
	ЗначенияСравнения = Новый СписокЗначений;
	ЗначенияСравнения.Добавить("Заполнено");
	ЗначенияСравнения.Добавить("Не заполнено"); // исключение, является идентификатором.
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗависимостиРеквизитов.Условие");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбораДанных.ПравоеЗначение = ЗначенияСравнения;
	ЭлементОтбораДанных.Использование  = Истина;
	
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("ЗависимостиРеквизитовПравоеЗначение");
	ЭлементОформляемогоПоля.Использование = Истина;
	
КонецПроцедуры

#КонецОбласти
