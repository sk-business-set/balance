////////////////////////////////////////////////////////////////////////////////
// Подсистема "Защита персональных данных".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура выполняет подготовку формы настройки системы
// для управления областями персональных данных,
// а также считывает текущее состояние использования события "Доступ. Доступ".
//
// В форме должны быть созданы:
//	- реквизит типа дерево значений, имя которого - "ОбластиПерсональныхДанных",
//	- таблица формы, связанная с этим реквизитом, 
//		имя которой так же - "ОбластиПерсональныхДанных".
//
// Параметры:
//	Форма - форма настройки системы.
//
Процедура ПриСозданииФормыНастройкиРегистрацииСобытий(Форма) Экспорт
	
	Если Не ФормаНастройкиПодготовленаКорректно(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяДереваОбластей = ИмяРеквизитаДеревоОбластей();
	
	// Добавление колонок реквизита "ОбластиПерсональныхДанных".
	ДобавляемыеРеквизиты = Новый Массив;
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Использование", Новый ОписаниеТипов("Булево"), ИмяДереваОбластей));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Имя", Новый ОписаниеТипов("Строка"), ИмяДереваОбластей));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Представление", Новый ОписаниеТипов("Строка"), ИмяДереваОбластей));
	
	Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	// Добавляем поля формы
	ГруппаПолей = Форма.Элементы.Добавить(ИмяДереваОбластей + "ГруппаИспользование", Тип("ГруппаФормы"), Форма.Элементы[ИмяДереваОбластей]);
	ГруппаПолей.Группировка = ГруппировкаКолонок.ВЯчейке;
	
	ФлажокИспользование = Форма.Элементы.Добавить(ИмяДереваОбластей + "Использование", Тип("ПолеФормы"), ГруппаПолей);
	ФлажокИспользование.ПутьКДанным = ИмяДереваОбластей + ".Использование";
	ФлажокИспользование.Вид = ВидПоляФормы.ПолеФлажка;
	
	ПолеПредставление = Форма.Элементы.Добавить(ИмяДереваОбластей + "Представление", Тип("ПолеФормы"), ГруппаПолей);
	ПолеПредставление.ПутьКДанным = ИмяДереваОбластей + ".Представление";
	ПолеПредставление.Вид = ВидПоляФормы.ПолеНадписи;
	
	// Настройка элементов управления.
	Форма.Элементы[ИмяДереваОбластей].ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
	Форма.Элементы[ИмяДереваОбластей].ИзменятьСоставСтрок = Ложь;
	Форма.Элементы[ИмяДереваОбластей].ИзменятьПорядокСтрок = Ложь;
	Форма.Элементы[ИмяДереваОбластей].Шапка = Ложь;
	Форма.Элементы[ИмяДереваОбластей].НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВсеУровни;
	Форма.Элементы[ИмяДереваОбластей].ГоризонтальныеЛинии = Ложь;
	Форма.Элементы[ИмяДереваОбластей].ВертикальныеЛинии = Ложь;
	Форма.Элементы[ИмяДереваОбластей].РежимВыделенияСтроки = РежимВыделенияСтрокиТаблицы.Строка;
	
	ЗначениеВДанныеФормы(ПолучитьИспользованиеСобытияДоступ(), Форма[ИмяДереваОбластей]);
	
КонецПроцедуры

// Процедура выполняет преобразование данных формы настройки системы
// и установку использования события доступ для отмеченных областей.
//
// В форме должны быть созданы:
//	- реквизит типа дерево значений, имя которого - "ОбластиПерсональныхДанных",
//	- таблица формы, связанная с этим реквизитом, 
//		имя которой так же - "ОбластиПерсональныхДанных".
//
// Параметры:
//	Форма - форма настройки системы.
//
Процедура ПриЗаписиФормыНастройкиРегистрацииСобытий(Форма) Экспорт
	
	Если Не ФормаНастройкиПодготовленаКорректно(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	ДеревоОбластей = ДанныеФормыВЗначение(Форма[ИмяРеквизитаДеревоОбластей()], Тип("ДеревоЗначений"));
	
	ОбластиИспользования = Новый Массив;
	
	ОтмеченныеСтроки = ДеревоОбластей.Строки.НайтиСтроки(Новый Структура("Использование", Истина), Истина);
	Для Каждого ОтмеченнаяСтрока Из ОтмеченныеСтроки Цикл
		ОбластиИспользования.Добавить(ОтмеченнаяСтрока.Имя);
	КонецЦикла;
	
	УстановитьИспользованиеСобытияДоступ(ОбластиИспользования.Количество() > 0, ОбластиИспользования);
	
КонецПроцедуры

// Процедура устанавливает режим использования события "Доступ. Доступ"
// журнала регистрации, контроль которого предусмотрен требованиями.
// Федерального закона от 27.07.2006 N152-ФЗ "О персональных данных" 
// и подзаконных актов.
// Использование события устанавливается для областей персональных данных, 
// сведения о которых заполняются в потребителе.
//
// Параметры:
//		Использование - булево, если Истина - события будут регистрироваться.
//		ОбластиИспользования - массив областей персональных данных, 
//			для которых производится установка использования (необязательный).
//
Процедура УстановитьИспользованиеСобытияДоступ(Использование, ОбластиИспользования = Неопределено) Экспорт
	
	// Таблица сведений о персональных данных.
	ТаблицаСведений = СведенияОПерсональныхДанных();
	
	ИспользованиеОбластейДанных = Новый Соответствие;
	
	// Составление описания использования события.
	ОписанияИспользования = Новый Массив;
	Для Каждого СтрокаСведений Из ТаблицаСведений Цикл
		// Добавление области данных в набор.
		ИспользованиеОбластейДанных.Вставить(СтрокаСведений.ОбластьДанных);
		Если ОбластиИспользования <> Неопределено 
			И ОбластиИспользования.Найти(СтрокаСведений.ОбластьДанных) = Неопределено Тогда
			// Если указаны области данных, то устанавливаем использование только для них.
			Продолжить;
		КонецЕсли;
		ИспользованиеОбластейДанных[СтрокаСведений.ОбластьДанных] = Использование;
		// Составление описания использования события.
		ПоляРегистрации = СтрРазделить(СтрокаСведений.ПоляРегистрации, ",");
		Для Индекс = 0 По ПоляРегистрации.ВГраница() Цикл
			// Если требуется составить массив полей.
			Если СтрНайти(ПоляРегистрации[Индекс], "|") > 0 Тогда
				ПоляРегистрации[Индекс] = СтрРазделить(ПоляРегистрации[Индекс], "|");
			КонецЕсли;
		КонецЦикла;
		ОписаниеИспользованияСобытияДоступа = Новый ОписаниеИспользованияСобытияДоступЖурналаРегистрации(СтрокаСведений.Объект);
		ОписаниеИспользованияСобытияДоступа.ПоляДоступа		= СтрРазделить(СтрокаСведений.ПоляДоступа, ",");
		ОписаниеИспользованияСобытияДоступа.ПоляРегистрации	= ПоляРегистрации;
		ОписанияИспользования.Добавить(ОписаниеИспользованияСобытияДоступа);
	КонецЦикла;
	
	// "Включение" ("Выключение") использования события "Доступ. Доступ"
	// журнала регистрации по созданному описанию.
	ИспользованиеСобытияДоступ = Новый ИспользованиеСобытияЖурналаРегистрации;
	ИспользованиеСобытияДоступ.Использование = Использование;
	ИспользованиеСобытияДоступ.ОписаниеИспользования = ОписанияИспользования;
	
	// Сохранение использования областей данных.
	ОбластиДанныхНаборЗаписей = РегистрыСведений.ОбластиПерсональныхДанных.СоздатьНаборЗаписей();
	Для Каждого КлючИЗначение Из ИспользованиеОбластейДанных Цикл
		СтрокаНабора = ОбластиДанныхНаборЗаписей.Добавить();
		СтрокаНабора.ИмяОбласти = КлючИЗначение.Ключ;
		СтрокаНабора.ИспользованиеСобытийЖурналаРегистрации = КлючИЗначение.Значение;
	КонецЦикла;
	
	НачатьТранзакцию();
	Попытка
		УстановитьИспользованиеСобытияЖурналаРегистрации("_$Access$_.Access", ИспользованиеСобытияДоступ);
		// Запись областей персональных данных.
		ОбластиДанныхНаборЗаписей.Записать();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Функция составляет дерево используемых областей персональных данных.
//
// Параметры:
//		нет
//
// Возвращаемое значение
//		Дерево значений - дерево областей данных с колонками:
//			Имя - строка, идентификатор области персональных данных.
//			Представление - строка, пользовательское представление области данных.
//			Использование - булево, признак того, что для области данных
//					установлена регистрация события "Доступ. Доступ".
//
Функция ПолучитьИспользованиеСобытияДоступ() Экспорт
	
	// Создание дерева областей
	ДеревоОбластейДанных = ДеревоОбластейПерсональныхДанных();
	
	// Расстановка пометок использования по данным регистра.
	ОбластиДанныхНаборЗаписей = РегистрыСведений.ОбластиПерсональныхДанных.СоздатьНаборЗаписей();
	ОбластиДанныхНаборЗаписей.Прочитать();
	
	Для Каждого СтрокаНабора Из ОбластиДанныхНаборЗаписей Цикл
		СтрокаДерева = ДеревоОбластейДанных.Строки.Найти(СтрокаНабора.ИмяОбласти, "Имя", Истина);
		Если СтрокаДерева <> Неопределено Тогда
			СтрокаДерева.Использование = СтрокаНабора.ИспользованиеСобытийЖурналаРегистрации;
		КонецЕсли;
	КонецЦикла;

	Возврат ДеревоОбластейДанных;
	
КонецФункции

// Процедура предназначена для использования из метода ДобавитьКомандыПечати 
// стандартной подсистемы Печать в объектах, являющимися субъектами персональных данных.
// Добавляет в список команд печати команду перехода к подготовке согласия на обработку персональных данных субъекта.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандуПечатиСогласияНаОбработкуПерсональныхДанных(КомандыПечати) Экспорт
	
	Если Не ПравоДоступа("ИнтерактивноеДобавление", Метаданные.Документы.СогласиеНаОбработкуПерсональныхДанных) Тогда
		Возврат;
	КонецЕсли; 
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СогласиеНаОбработкуПерсональныхДанных";
	КомандаПечати.Представление = НСтр("ru = 'Согласие на обработку ПДн...'");
	КомандаПечати.Обработчик = "ЗащитаПерсональныхДанныхКлиент.ОткрытьФормуСогласиеНаОбработкуПерсональныхДанных";
	
КонецПроцедуры

// Функция получает сведения о действующем на указанную дату согласии субъекта на обработку персональных данных.
// Получение сведений производится в привилегированном режиме.
//
// Параметры:
//	Субъект - тип ОпределяемыйТип.СубъектПерсональныхДанных, субъект, наличие согласия которого определяется,
//	Организация - тип СправочникСсылка.Организации, оператор персональных данных, которому предоставлено согласие,
//	Дата - (необязательный), тип Дата, дата, на которую запрашивается состояние, если не указана, выбирается последняя запись.
//	ИсключаемыйРегистратор - (необязательный), тип ДокументСсылка, текущий документ, 
//		передается для того, чтобы при поиске согласия игнорировать выполненные текущим документом движения.
//
// Возвращаемое значение - если обнаружено действующее согласие, тип Структура с полями ДатаПолучения, СрокДействия, ДокументОснование.
//	Неопределено, если согласие не предоставлялось, или срок действия предоставленного согласия истек.
//
Функция ДействующееСогласиеНаОбработкуПерсональныхДанных(Субъект, Организация, Знач Дата = Неопределено, ИсключаемыйРегистратор = Неопределено) Экспорт
	
	Если Дата = Неопределено Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Согласия.Период КАК ДатаПолучения,
		|	Согласия.Регистратор КАК ДокументОснование,
		|	Согласия.Организация,
		|	Согласия.Субъект,
		|	Согласия.Действует,
		|	Согласия.СрокДействия
		|ПОМЕСТИТЬ ВТСогласия
		|ИЗ
		|	РегистрСведений.СогласияНаОбработкуПерсональныхДанных.СрезПоследних(
		|			&Дата,
		|			Организация = &Организация
		|				И Субъект = &Субъект
		|				И Регистратор <> &ИсключаемыйРегистратор) КАК Согласия
		|ГДЕ
		|	Согласия.Действует = ИСТИНА
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Согласия.ДатаПолучения,
		|	Согласия.ДокументОснование,
		|	Согласия.Организация,
		|	Согласия.Субъект,
		|	Согласия.Действует,
		|	Согласия.СрокДействия
		|ИЗ
		|	ВТСогласия КАК Согласия
		|ГДЕ
		|	Согласия.СрокДействия = ДАТАВРЕМЯ(1, 1, 1)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Согласия.ДатаПолучения,
		|	Согласия.ДокументОснование,
		|	Согласия.Организация,
		|	Согласия.Субъект,
		|	Согласия.Действует,
		|	Согласия.СрокДействия
		|ИЗ
		|	ВТСогласия КАК Согласия
		|ГДЕ
		|	Согласия.СрокДействия <> ДАТАВРЕМЯ(1, 1, 1)
		|	И Согласия.СрокДействия >= &Дата";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Субъект", Субъект);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("ИсключаемыйРегистратор", ИсключаемыйРегистратор);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Согласие = Новый Структура(
		"ДатаПолучения, 
		|СрокДействия,
		|ДокументОснование");
		
	ЗаполнитьЗначенияСвойств(Согласие, Выборка);
	
	Возврат Согласие;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
//
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	СерверныеОбработчики["СтандартныеПодсистемы.Печать\ПриОпределенииОбъектовСКомандамиПечати"].Добавить("ЗащитаПерсональныхДанных");
	
	// Текущие дела.
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ТекущиеДела") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.ТекущиеДела\ПриЗаполненииСпискаТекущихДел"].Добавить(
			"ЗащитаПерсональныхДанных");
	КонецЕсли;
	
КонецПроцедуры

// Определяет объекты, в которых есть процедура ДобавитьКомандыПечати().
//
// Параметры:
//  СписокОбъектов - Массив - список менеджеров объектов.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	СписокОбъектов.Добавить(Документы.СогласиеНаОбработкуПерсональныхДанных);
	
КонецПроцедуры

// Заполняет список текущих дел пользователя.
//
// Параметры:
//     ТекущиеДела - ТаблицаЗначений - описание дел - таблица значений с колонками:
//         * Идентификатор - Строка    - Внутренний идентификатор дела, используемый механизмом "Текущие дела".
//         * ЕстьДела      - Булево    - Если Истина, дело выводится в списке текущих дел пользователя.
//         * Важное        - Булево    - Если Истина, дело будет выделено красным цветом.
//         * Представление - Строка    - Представление дела, выводимое пользователю.
//         * Количество    - Число     - Количественный показатель дела, выводится в строке заголовка дела.
//         * Форма         - Строка    - Полный путь к форме, которую необходимо открыть при нажатии на гиперссылку
//                                       дела на панели "Текущие дела".
//         * ПараметрыФормы- Структура - Параметры, с которыми нужно открывать форму показателя.
//         * Владелец      - Строка, ОбъектМетаданных - Строковый идентификатор дела, которое будет владельцем для
//                           текущего или объект метаданных подсистема.
//         * Подсказка     - Строка    - Текст подсказки.
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат; // Модель сервиса.
	КонецЕсли;
	
	Если Не ПравоДоступа("Изменение", Метаданные.Документы.СогласиеНаОбработкуПерсональныхДанных) Тогда
		Возврат; // Нет прав.
	КонецЕсли;
	
	МодульТекущиеДелаСервер = ОбщегоНазначения.ОбщийМодуль("ТекущиеДелаСервер");
	
	Разделы = МодульТекущиеДелаСервер.РазделыДляОбъекта("ЖурналДокументов.СогласияНаОбработкуПерсональныхДанных");
	Если Разделы.Количество() = 0 Тогда
		// Не вынесены в командный интерфейс.
		РазделАдминистрирование = Метаданные.Подсистемы.Найти("Администрирование");
		Если РазделАдминистрирование = Неопределено Тогда
			Возврат;
		КонецЕсли;
		Разделы.Добавить(РазделАдминистрирование);
	КонецЕсли;
	
	ИстекшиеСогласия = ИстекшиеСогласияНаОбработкуПерсональныхДанных();
	Для Каждого Раздел Из Разделы Цикл
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор  = "ИстекшиеСогласияНаОбработкуПерсональныхДанных";
		Дело.ЕстьДела       = ИстекшиеСогласия.Количество() > 0;
		Дело.Важное         = Истина;
		Дело.Владелец       = Раздел;
		Дело.Представление  = НСтр("ru = 'Согласия на обработку ПДн'");
		Дело.Количество     = ИстекшиеСогласия.Количество();
		Дело.Подсказка      = НСтр("ru = 'Истекли согласия на обработку персональных данных (ПДн). Необходимо прекратить обработку ПДн или запросить у субъекта продление согласия на обработку.'");
		Дело.ПараметрыФормы = Новый Структура("ИстекшиеСогласия", ИстекшиеСогласия);
		Дело.Форма          = "ЖурналДокументов.СогласияНаОбработкуПерсональныхДанных.Форма.ФормаСписка";
	КонецЦикла;
	
КонецПроцедуры

// Содержит описание таблиц и полей объектов для проверки запретов изменения данных.
//
// Параметры:
//  ИсточникиДанных - ТаблицаЗначений - с колонками:
//   * Таблица     - Строка - полное имя объекта метаданных,
//                   например, Метаданные.Документы.ПриходнаяНакладная.ПолноеИмя().
//   * ПолеДаты    - Строка - имя реквизита объекта или табличной части,
//                   например "Дата", "Товары.ДатаОтгрузки".
//   * Раздел      - Строка - имя предопределенного элемента
//                   "ПланВидовХарактеристикСсылка.РазделыДатЗапрета".
//   * ПолеОбъекта - Строка - имя реквизита объекта или реквизита табличной части,
//                   например "Организация", "Товары.Склад".
//
//  Для добавления строки имеется процедура ДобавитьСтроку в общем модуле ДатыЗапретаИзменения.
//
Процедура ПриЗаполненииИсточниковДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения") Тогда
		МодульДатыЗапретаИзменения = ОбщегоНазначения.ОбщийМодуль("ДатыЗапретаИзменения");
		МодульДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных,
			Метаданные.Документы.СогласиеНаОбработкуПерсональныхДанных.ПолноеИмя(),
			"ДатаПолучения", "ОбработкаПерсональныхДанных");
		МодульДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных,
			Метаданные.Документы.ОтзывСогласияНаОбработкуПерсональныхДанных.ПолноеИмя(),
			"ДатаОтзыва", "ОбработкаПерсональныхДанных");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	// Загрузка при обмене данными проверяется внутри вызова.
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения") Тогда
		МодульДатыЗапретаИзменения = ОбщегоНазначения.ОбщийМодуль("ДатыЗапретаИзменения");
		МодульДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(Источник,
			Отказ, РежимЗаписи, РежимПроведения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьДатуЗапретаИзмененияПередУдалением(Источник, Отказ) Экспорт
	
	// Загрузка при обмене данными проверяется внутри вызова.
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения") Тогда
		МодульДатыЗапретаИзменения = ОбщегоНазначения.ОбщийМодуль("ДатыЗапретаИзменения");
		МодульДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередУдалением(Источник, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Функция СведенияОПерсональныхДанных()
	
	// Таблица сведений о персональных данных.
	ТаблицаСведений = Новый ТаблицаЗначений;
	ТаблицаСведений.Колонки.Добавить("Объект", 			Новый ОписаниеТипов("Строка"));
	ТаблицаСведений.Колонки.Добавить("ПоляРегистрации", Новый ОписаниеТипов("Строка"));
	ТаблицаСведений.Колонки.Добавить("ПоляДоступа", 	Новый ОписаниеТипов("Строка"));
	ТаблицаСведений.Колонки.Добавить("ОбластьДанных", 	Новый ОписаниеТипов("Строка"));
	
	// Сведения о персональных данных в самой подсистеме.
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.СогласиеНаОбработкуПерсональныхДанных";
	НовыеСведения.ПоляРегистрации	= "Субъект,ФИОСубъекта";
	НовыеСведения.ПоляДоступа		= "ФИОСубъекта,АдресСубъекта,ПаспортныеДанные,СрокДействия";
	НовыеСведения.ОбластьДанных		= "ОбработкаПерсональныхДанных";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "РегистрСведений.СогласияНаОбработкуПерсональныхДанных";
	НовыеСведения.ПоляРегистрации	= "Субъект";
	НовыеСведения.ПоляДоступа		= "СрокДействия";
	НовыеСведения.ОбластьДанных		= "ОбработкаПерсональныхДанных";
	
	// Заполнение таблицы сведений потребителями.
	ЗащитаПерсональныхДанныхПереопределяемый.ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений);

	Возврат ТаблицаСведений;
	
КонецФункции

Функция ОбластиПерсональныхДанных()
	
	// Соответствие идентификаторов областей и их пользовательских представлений.
	ОбластиДанных = Новый ТаблицаЗначений;
	ОбластиДанных.Колонки.Добавить("Имя", 			Новый ОписаниеТипов("Строка"));
	ОбластиДанных.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	ОбластиДанных.Колонки.Добавить("Родитель", 		Новый ОписаниеТипов("Строка"));
	
	НоваяОбласть = ОбластиДанных.Добавить();
	НоваяОбласть.Имя = "ОбработкаПерсональныхДанных";
	НоваяОбласть.Представление = НСтр("ru = 'Обработка ПДн'");
	
	// Заполнение областей потребителями.
	ЗащитаПерсональныхДанныхПереопределяемый.ЗаполнитьОбластиПерсональныхДанных(ОбластиДанных);
	
	Возврат ОбластиДанных;
	
КонецФункции

Функция ФормаНастройкиПодготовленаКорректно(Форма)
	
	ИмяДереваОбластей = ИмяРеквизитаДеревоОбластей();
	
	// Поиск реквизита формы
	РеквизитФормыДеревоОбластей = Неопределено;
	РеквизитыФормы = Форма.ПолучитьРеквизиты();
	Для Каждого РеквизитФормы Из РеквизитыФормы Цикл
		Если РеквизитФормы.Имя = ИмяДереваОбластей Тогда
			РеквизитФормыДеревоОбластей = РеквизитФормы;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если РеквизитФормыДеревоОбластей = Неопределено 
		Или Форма.Элементы.Найти(ИмяДереваОбластей) = Неопределено Тогда
		// В форме не обнаружен реквизит для дерева областей.
		Возврат Ложь;
	КонецЕсли;

	Возврат Истина;
	
КонецФункции

Функция ОписаниеДанныхОрганизации() Экспорт
		
	ДанныеОрганизации = Новый Структура(
		"АдресОрганизации, 
		|ОтветственныйЗаОбработкуПерсональныхДанных");
		
	Возврат ДанныеОрганизации;

КонецФункции

Функция ОписаниеДанныхСубъекта() Экспорт
	
	ДанныеСубъекта = Новый Структура(
		"Субъект,
		|ФИО,
		|Адрес,
		|ПаспортныеДанные");
		
	Возврат ДанныеСубъекта;

КонецФункции

Функция ОписаниеРегистрацииСогласияНаОбработкуПерсональныхДанных() Экспорт
	
	Описание = Новый Структура(
		"Организация, 
		|Субъект, 
		|ДатаРегистрации, 
		|Действует, 
		|СрокДействия");
	
	Возврат Описание;
	
КонецФункции

Процедура ЗарегистрироватьСведенияОСогласииНаОбработкуПерсональныхДанных(Движения, ОписаниеРегистрации) Экспорт
	
	НоваяЗапись = Движения.СогласияНаОбработкуПерсональныхДанных.Добавить();
	
	ЗаполнитьЗначенияСвойств(НоваяЗапись, ОписаниеРегистрации);
	НоваяЗапись.Период = ОписаниеРегистрации.ДатаРегистрации;
	
	Движения.СогласияНаОбработкуПерсональныхДанных.Записывать = Истина;
	
КонецПроцедуры

Функция ИстекшиеСогласияНаОбработкуПерсональныхДанных(ДатаОценки = Неопределено)
	
	ИстекшиеСогласия = Новый Массив;
	
	Если ДатаОценки = Неопределено Тогда
		ДатаОценки = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Согласия.Период КАК ДатаПолучения,
		|	Согласия.Регистратор КАК ДокументОснование,
		|	Согласия.Организация,
		|	Согласия.Субъект,
		|	Согласия.СрокДействия
		|ИЗ
		|	РегистрСведений.СогласияНаОбработкуПерсональныхДанных.СрезПоследних(&ДатаОценки, ) КАК Согласия
		|ГДЕ
		|	Согласия.СрокДействия <> ДАТАВРЕМЯ(1, 1, 1)
		|	И Согласия.СрокДействия <= &ДатаОценки");
		
	Запрос.УстановитьПараметр("ДатаОценки", ДатаОценки);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ИстекшиеСогласия.Добавить(Выборка.ДокументОснование);
	КонецЦикла;
	
	Возврат ИстекшиеСогласия;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с деревом областей персональных данных.
//

Функция ИмяРеквизитаДеревоОбластей()
	Возврат "ОбластиПерсональныхДанных";
КонецФункции

Функция ДеревоОбластейПерсональныхДанных()
	
	ДеревоОбластейДанных = Новый ДеревоЗначений;
	ДеревоОбластейДанных.Колонки.Добавить("Использование", Новый ОписаниеТипов("Булево"));
	ДеревоОбластейДанных.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка"));
	ДеревоОбластейДанных.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	
	ОбластиДанных = ОбластиПерсональныхДанных();
	
	// Заполнение дерева областей
	Для Каждого ОбластьДанных Из ОбластиДанных Цикл
		ДобавитьОбластьДанныхВДерево(ДеревоОбластейДанных, ОбластиДанных, ОбластьДанных);
	КонецЦикла;
	
	// Если области данных не определены для всех сведений 
	// или для отдельных - добавляем область данных по умолчанию.
	ТаблицаСведений = СведенияОПерсональныхДанных();
	Если ОбластиДанных.Количество() = 0 
		Или ТаблицаСведений.НайтиСтроки(Новый Структура("ОбластьДанных", "")).Количество() > 0 Тогда
		ДобавитьОбластьДанныхВДерево(ДеревоОбластейДанных, ОбластиДанных, Новый Структура("Имя, Представление, Родитель", "", НСтр("ru = 'Персональные данные'")));
	КонецЕсли;
	
	Возврат ДеревоОбластейДанных;
	
КонецФункции

Функция ДобавитьОбластьДанныхВДерево(ДеревоОбластей, ОбластиДанных, ОбластьДанных)
	
	// Поиск области в дереве значений.
	НайденнаяОбласть = ДеревоОбластей.Строки.Найти(ОбластьДанных.Имя, "Имя", Истина);
	Если НайденнаяОбласть <> Неопределено Тогда
		Возврат НайденнаяОбласть;
	КонецЕсли;
	
	// Добавление в "корень" дерева.
	Родитель = ДеревоОбластей;
	Если ЗначениеЗаполнено(ОбластьДанных.Родитель) Тогда
		ОбластьРодитель = ОбластиДанных.Найти(ОбластьДанных.Родитель, "Имя");
		Если ОбластьРодитель <> Неопределено Тогда
			Родитель = ДобавитьОбластьДанныхВДерево(ДеревоОбластей, ОбластиДанных, ОбластьРодитель);
		КонецЕсли;
	КонецЕсли;
	
	// Добавление области
	НоваяОбласть = Родитель.Строки.Добавить();
	НоваяОбласть.Имя = ОбластьДанных.Имя;
	НоваяОбласть.Представление = ОбластьДанных.Представление;
	
	Возврат НоваяОбласть;
	
КонецФункции

Функция ОбрабатываемыеМетаданные() Экспорт
	
	Структура = Новый Структура;
	Структура.Вставить("Константы", НСтр("ru = 'Константы'"));
	Структура.Вставить("Справочники", НСтр("ru = 'Справочники'"));
	Структура.Вставить("Документы", НСтр("ru = 'Документы'"));
	Структура.Вставить("ПланыВидовХарактеристик", НСтр("ru = 'Планы видов характеристик'"));
	Структура.Вставить("ПланыСчетов", НСтр("ru = 'Планы счетов'"));
	Структура.Вставить("ПланыВидовРасчета", НСтр("ru = 'Планы видов расчета'"));
	Структура.Вставить("РегистрыСведений", НСтр("ru = 'Регистры сведений'"));
	Структура.Вставить("РегистрыНакопления", НСтр("ru = 'Регистры накопления'"));
	Структура.Вставить("РегистрыБухгалтерии", НСтр("ru = 'Регистры бухгалтерии'"));
	Структура.Вставить("РегистрыРасчета", НСтр("ru = 'Регистры расчета'"));
	Структура.Вставить("БизнесПроцессы", НСтр("ru = 'Бизнес процессы'"));
	Структура.Вставить("Задачи", НСтр("ru = 'Задачи'"));
	
	Возврат Структура;
	
КонецФункции

#КонецОбласти
