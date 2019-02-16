&НаКлиенте
Перем ОтветПередЗакрытием;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Инициализация формы
	Для НомерМесяца = 1 По 12 Цикл
		Элементы.МесяцФормированияЕжегодныхКопий.СписокВыбора.Добавить(НомерМесяца, 
			Формат(Дата(2, НомерМесяца, 1), "ДФ=MMMM"));
	КонецЦикла;
	
	УстановитьШиринуПодписей();
	
	ПрименитьОграниченияНастроек();
	
	ЗаполнитьФормуПоНастройкам(Параметры.ДанныеНастроек);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЕжедневныхКопийПриИзменении(Элемент)
	
	ПодписьКоличестваЕжедневных = ПодписьКоличестваКопий(КоличествоЕжедневныхКопий);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЕжемесячныхКопийПриИзменении(Элемент)
	
	ПодписьКоличестваЕжемесячных = ПодписьКоличестваКопий(КоличествоЕжемесячныхКопий);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЕжегодныхКопийПриИзменении(Элемент)
	
	ПодписьКоличестваЕжегодных = ПодписьКоличестваКопий(КоличествоЕжегодныхКопий);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Если ОтветПередЗакрытием = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Данные были изменены. Сохранить изменения?'"), 
		РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
		
КонецПроцедуры
		
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Перечитать(Команда)
	
	ПеречитатьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьНовыеНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНовыеНастройки();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтандартныеНастройки(Команда)
	
	УстановитьСтандартныеНастройкиНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПеречитатьНаСервере()
	
	ЗаполнитьФормуПоНастройкам(
		РезервноеКопированиеОбластейДанныхДанныеФормИнтерфейс.ПолучитьНастройкиОбласти(Параметры.ОбластьДанных));
		
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуПоНастройкам(Знач ДанныеНастроек, Знач ОбновлятьИсходныеНастройки = Истина)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеНастроек);
	
	Если ОбновлятьИсходныеНастройки Тогда
		ИсходныеНастройки = ДанныеНастроек;
	КонецЕсли;
	
	УстановитьПодписиВсехКоличеств();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьШиринуПодписей()
	
	МаксимальнаяШирина = 0;
	
	ЧислаДляПроверки = Новый Массив;
	ЧислаДляПроверки.Добавить(1);
	ЧислаДляПроверки.Добавить(2);
	ЧислаДляПроверки.Добавить(5);
	
	Для Каждого Число Из ЧислаДляПроверки Цикл
		ШиринаНадписи = СтрДлина(ПодписьКоличестваКопий(Число));
		Если ШиринаНадписи > МаксимальнаяШирина Тогда
			МаксимальнаяШирина = ШиринаНадписи;
		КонецЕсли;
	КонецЦикла;
	
	ЭлементыПодписей = Новый Массив;
	ЭлементыПодписей.Добавить(Элементы.ПодписьКоличестваЕжедневных);
	ЭлементыПодписей.Добавить(Элементы.ПодписьКоличестваЕжемесячных);
	ЭлементыПодписей.Добавить(Элементы.ПодписьКоличестваЕжегодных);
	
	Для каждого ЭлементПодписи Из ЭлементыПодписей Цикл
		ЭлементПодписи.Ширина = МаксимальнаяШирина;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПрименитьОграниченияНастроек()
	
	ОграниченияНастроек = Параметры.ОграниченияНастроек;
	
	ШаблонПодсказки = НСтр("ru = 'Максимум %1'");
	
	ЭлементыОграничений = Новый Структура;
	ЭлементыОграничений.Вставить("КоличествоЕжедневныхКопий", "МаксимумЕжедневныхКопий");
	ЭлементыОграничений.Вставить("КоличествоЕжемесячныхКопий", "МаксимумЕжемесячныхКопий");
	ЭлементыОграничений.Вставить("КоличествоЕжегодныхКопий", "МаксимумЕжегодныхКопий");
	
	Для каждого КлючИЗначение Из ЭлементыОграничений Цикл
		Элемент = Элементы[КлючИЗначение.Ключ];
		Элемент.МаксимальноеЗначение = ОграниченияНастроек[КлючИЗначение.Значение];
		Элемент.Подсказка = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПодсказки, 
				ОграниченияНастроек[КлючИЗначение.Значение]);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПодписиВсехКоличеств()
	
	ПодписьКоличестваЕжедневных = ПодписьКоличестваКопий(КоличествоЕжедневныхКопий);
	ПодписьКоличестваЕжемесячных = ПодписьКоличестваКопий(КоличествоЕжемесячныхКопий);
	ПодписьКоличестваЕжегодных = ПодписьКоличестваКопий(КоличествоЕжегодныхКопий);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПодписьКоличестваКопий(Знач Количество)

	МассивПредставлений = Новый Массив;
	МассивПредставлений.Добавить(НСтр("ru = 'последнюю копию'"));
	МассивПредставлений.Добавить(НСтр("ru = 'последние копии'"));
	МассивПредставлений.Добавить(НСтр("ru = 'последних копий'"));
	
	Если Количество >= 100 Тогда
		Количество = Количество - Цел(Количество / 100)*100;
	КонецЕсли;
	
	Если Количество > 20 Тогда
		Количество = Количество - Цел(Количество/10)*10;
	КонецЕсли;
	
	Если Количество = 1 Тогда
		Результат = МассивПредставлений[0];
	ИначеЕсли Количество > 1 И Количество < 5 Тогда
		Результат = МассивПредставлений[1];
	Иначе
		Результат = МассивПредставлений[2];
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаписатьНовыеНастройки()
	
	НовыеНастройки = Новый Структура;
	Для каждого КлючИЗначение Из ИсходныеНастройки Цикл
		НовыеНастройки.Вставить(КлючИЗначение.Ключ, ЭтотОбъект[КлючИЗначение.Ключ]);
	КонецЦикла;
	
	НовыеНастройки = Новый ФиксированнаяСтруктура(НовыеНастройки);
	
	РезервноеКопированиеОбластейДанныхДанныеФормИнтерфейс.УстановитьНастройкиОбласти(
		Параметры.ОбластьДанных,
		НовыеНастройки,
		ИсходныеНастройки);
		
	Модифицированность = Ложь;
	ИсходныеНастройки = НовыеНастройки;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСтандартныеНастройкиНаСервере()
	
	ЗаполнитьФормуПоНастройкам(
		РезервноеКопированиеОбластейДанныхДанныеФормИнтерфейс.ПолучитьСтандартныеНастройки(),
		Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт	
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗаписатьНовыеНастройки();
	КонецЕсли;
	ОтветПередЗакрытием = Истина;
    Закрыть();
	
КонецПроцедуры

#КонецОбласти
