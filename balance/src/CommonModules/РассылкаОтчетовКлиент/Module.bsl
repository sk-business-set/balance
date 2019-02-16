////////////////////////////////////////////////////////////////////////////////
// Подсистема "Рассылка отчетов" (клиент, переопределяемый).
//
// Выполняется на клиенте, изменяется под специфику прикладной конфигурации,
// но предназначен для использования только данной подсистемой.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов.

// Обработчик команды формы отчета.
//
// Параметры:
//   Форма     - УправляемаяФорма - Форма отчета.
//   Команда   - КомандаФормы     - Команда, которая была вызвана.
//   Результат - Булево           - Истина, если вызов команды обработан.
//
// Места использования:
//   ОбщаяФорма.ФормаОтчета.Подключаемый_Команда().
//
Процедура ФормаОтчетаОбработчикКоманды(Форма, Команда, Результат) Экспорт
	
	Если Результат = Истина Тогда
		
		// Действие не требуется
		
	ИначеЕсли Команда.Имя = "РассылкаОтчетовСоздатьНовую" Тогда
		
		ОткрытьРассылкуИзФормыОтчета(Форма);
		
		Результат = Истина;
		
	ИначеЕсли Команда.Имя = "РассылкаОтчетовПрисоединитьКСуществующей" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
		ПараметрыФормы.Вставить("МножественныйВыбор", Ложь);
		
		ОткрытьФорму("Справочник.РассылкиОтчетов.ФормаВыбора", ПараметрыФормы, Форма);
		
		Результат = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик выбора формы отчета.
//
// Параметры:
//   Форма             - УправляемаяФорма - Форма отчета.
//   ВыбранноеЗначение - Произвольный     - Результат выбора в подчиненной форме.
//   ИсточникВыбора    - УправляемаяФорма - Форма, где осуществлен выбор.
//   Результат         - Булево           - Истина, если результат выбора обработан.
//
// Места использования:
//   ОбщаяФорма.ФормаОтчета.ОбработкаВыбора().
//
Процедура ФормаОтчетаОбработкаВыбора(Форма, ВыбранноеЗначение, ИсточникВыбора, Результат) Экспорт
	
	Если Результат = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.РассылкиОтчетов") Тогда
		
		ОткрытьРассылкуИзФормыОтчета(Форма, ВыбранноеЗначение);
		
		Результат = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует список получателей рассылки, предлагает пользователю выбрать
//   конкретного получателя или всех получателей рассылки и возвращает
//   результат выбора пользователя.
// Вызывается из формы элемента.
//
Процедура ВыбратьПолучателя(ОбработчикРезультата, Объект, МножественныйВыбор, ВозвращатьСоответствие) Экспорт
	
	Если Объект.Личная = Истина Тогда
		НаборПараметров = "Ссылка, ВидПочтовогоАдресаПолучателей, Личная, Автор";
	Иначе
		НаборПараметров = "Ссылка, ВидПочтовогоАдресаПолучателей, Личная, ТипПолучателейРассылки, Получатели";
	КонецЕсли;
	
	ПараметрыПолучателей = Новый Структура(НаборПараметров);
	ЗаполнитьЗначенияСвойств(ПараметрыПолучателей, Объект);
	РезультатВыполнения = РассылкаОтчетовВызовСервера.СформироватьСписокПолучателейРассылки(ПараметрыПолучателей);
	
	Если РезультатВыполнения.БылиКритичныеОшибки Тогда
		СтандартныеПодсистемыКлиент.ВывестиПредупреждение(Неопределено, РезультатВыполнения, ОбработчикРезультата);
		Возврат;
	КонецЕсли;
	
	Получатели = РезультатВыполнения.Получатели;
	Если Получатели.Количество() = 1 Тогда
		Результат = Получатели;
		Если Не ВозвращатьСоответствие Тогда
			Для Каждого КлючИЗначение Из Получатели Цикл
				Результат = Новый Структура("Получатель, ПочтовыйАдрес", КлючИЗначение.Ключ, КлючИЗначение.Значение);
			КонецЦикла;
		КонецЕсли;
		ВыполнитьОбработкуОповещения(ОбработчикРезультата, Результат);
		Возврат;
	КонецЕсли;
	
	ВозможныеПолучатели = Новый СписокЗначений;
	Для Каждого КлючИЗначение Из Получатели Цикл
		ВозможныеПолучатели.Добавить(КлючИЗначение.Ключ, Строка(КлючИЗначение.Ключ) +" <"+ КлючИЗначение.Значение +">");
	КонецЦикла;
	Если МножественныйВыбор Тогда
		ВозможныеПолучатели.Вставить(0, Неопределено, НСтр("ru = 'Всем получателям'"));
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОбработчикРезультата", ОбработчикРезультата);
	ДополнительныеПараметры.Вставить("Получатели", Получатели);
	ДополнительныеПараметры.Вставить("ВозвращатьСоответствие", ВозвращатьСоответствие);
	
	Обработчик = Новый ОписаниеОповещения("ВыбратьПолучателяЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ВозможныеПолучатели.ПоказатьВыборЭлемента(Обработчик, НСтр("ru = 'Выбор получателя'"));
КонецПроцедуры

// Обработчик результата работы процедуры ВыбратьПолучателя.
Процедура ВыбратьПолучателяЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	Если ВыбранныйЭлемент = Неопределено Тогда
		Результат = Неопределено;
	Иначе
		Если ДополнительныеПараметры.ВозвращатьСоответствие Тогда
			Если ВыбранныйЭлемент.Значение = Неопределено Тогда
				Результат = ДополнительныеПараметры.Получатели;
			Иначе
				Результат = Новый Соответствие;
				Результат.Вставить(ВыбранныйЭлемент.Значение, ДополнительныеПараметры.Получатели[ВыбранныйЭлемент.Значение]);
			КонецЕсли;
		Иначе
			Результат = Новый Структура("Получатель, ПочтовыйАдрес", ВыбранныйЭлемент.Значение, ДополнительныеПараметры.Получатели[ВыбранныйЭлемент.Значение]);
		КонецЕсли;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОбработчикРезультата, Результат);
КонецПроцедуры

// Выполняет рассылки в фоне.
Процедура ВыполнитьСейчас(Параметры) Экспорт
	Обработчик = Новый ОписаниеОповещения("ЗапускФоновогоЗадания", ЭтотОбъект, Параметры);
	Если Параметры.ЭтоФормаЭлемента Тогда
		Объект = Параметры.Форма.Объект;
		Если Не Объект.Подготовлена Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Рассылка не подготовлена'"));
			Возврат;
		КонецЕсли;
		Если Объект.ИспользоватьЭлектроннуюПочту Тогда
			ВыбратьПолучателя(Обработчик, Параметры.Форма.Объект, Истина, Истина);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	ВыполнитьОбработкуОповещения(Обработчик, Неопределено);
КонецПроцедуры

// Запускает фоновое задание, вызывается когда все параметры уже готовы.
Процедура ЗапускФоновогоЗадания(Получатели, Параметры) Экспорт
	ПредварительныеНастройки = Неопределено;
	Если Параметры.ЭтоФормаЭлемента Тогда
		Если Параметры.Форма.Объект.ИспользоватьЭлектроннуюПочту Тогда
			Если Получатели = Неопределено Тогда
				Возврат;
			КонецЕсли;
			ПредварительныеНастройки = Новый Структура("Получатели", Получатели);
		КонецЕсли;
		ТекстСостояния = НСтр("ru = 'Выполняется рассылка отчетов'");
	Иначе
		ТекстСостояния = НСтр("ru = 'Выполняются рассылки отчетов'");
	КонецЕсли;
	
	Состояние(ТекстСостояния);
	
	ПараметрыМетода = Новый Структура;
	ПараметрыМетода.Вставить("МассивРассылок", Параметры.МассивРассылок);
	ПараметрыМетода.Вставить("ПредварительныеНастройки", ПредварительныеНастройки);
	
	Задание = РассылкаОтчетовВызовСервера.ЗапуститьФоновоеЗадание(ПараметрыМетода, Параметры.Форма.УникальныйИдентификатор);
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Параметры.Форма);
	НастройкиОжидания.ВыводитьОкноОжидания = Истина;
	НастройкиОжидания.ТекстСообщения = ТекстСостояния;
	НастройкиОжидания.ПолучатьРезультат = Истина;
	
	Обработчик = Новый ОписаниеОповещения("ПослеЗавершенияФоновогоЗадания", ЭтотОбъект, Параметры);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Задание, Обработчик, НастройкиОжидания);
КонецПроцедуры

// Принимает результат выполнения фонового задания.
Процедура ПослеЗавершенияФоновогоЗадания(Задание, Параметры) Экспорт
	Если Задание = Неопределено Тогда
		Возврат; // Отменено.
	КонецЕсли;
	Если Задание.Статус = "Выполнено" Тогда
		Результат = ПолучитьИзВременногоХранилища(Задание.АдресРезультата);
		КоличествоРассылок = Результат.Рассылки.Количество();
		Если КоличествоРассылок > 0 Тогда
			ОповеститьОбИзменении(?(КоличествоРассылок > 1, Тип("СправочникСсылка.РассылкиОтчетов"), Результат.Рассылки[0]));
		КонецЕсли;
		СтандартныеПодсистемыКлиент.ВывестиПредупреждение(ЭтотОбъект, Результат);
	Иначе
		Предупреждение = Новый Структура("Текст, Подробно");
		Предупреждение.Текст = НСтр("ru = 'Не удалось выполнить рассылки отчетов.'")
			+ Символы.ПС
			+ Задание.КраткоеПредставлениеОшибки;
		Предупреждение.Подробно = Задание.ПодробноеПредставлениеОшибки
			+ Символы.ПС
			+ НСтр("ru = 'Подробности см. в журнале регистрации.'");
		СтандартныеПодсистемыКлиент.ВывестиПредупреждение(ЭтотОбъект, Предупреждение);
	КонецЕсли;
КонецПроцедуры

// Открывает рассылку отчетов из формы отчета.
//
// Параметры:
//   Форма  - УправляемаяФорма - Форма отчета.
//   Ссылка - СправочникСсылка.РассылкиОтчетов - Необязательный. Ссылка рассылки отчетов.
//
Процедура ОткрытьРассылкуИзФормыОтчета(Форма, Ссылка = Неопределено)
	НастройкиОтчета = Форма.НастройкиОтчета;
	
	СтрокаОтчетыПараметры = Новый Структура("ОтчетПолноеИмя, КлючВарианта, ВариантСсылка, Настройки");
	СтрокаОтчетыПараметры.ОтчетПолноеИмя = НастройкиОтчета.ПолноеИмя;
	СтрокаОтчетыПараметры.КлючВарианта   = Форма.КлючТекущегоВарианта;
	СтрокаОтчетыПараметры.ВариантСсылка  = НастройкиОтчета.ВариантСсылка;
	Если Форма.РежимВариантаОтчета Тогда
		СтрокаОтчетыПараметры.Настройки = Форма.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки;
	КонецЕсли;
	
	ПрисоединяемыеОтчеты = Новый Массив;
	ПрисоединяемыеОтчеты.Добавить(СтрокаОтчетыПараметры);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПрисоединяемыеОтчеты", ПрисоединяемыеОтчеты);
	Если Ссылка <> Неопределено Тогда
		ПараметрыФормы.Вставить("Ключ", Ссылка);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.РассылкиОтчетов.ФормаОбъекта", ПараметрыФормы, , Строка(Форма.УникальныйИдентификатор) + ".ОткрытьРассылкуОтчетов");
	
КонецПроцедуры

#КонецОбласти
