#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных
Перем СтрокаСообщенияОбОшибке Экспорт;
Перем СтрокаСообщенияОбОшибкеЖР Экспорт;

Перем СообщенияОшибок; // Соответствие с сообщениями ошибок обработки.
Перем ИмяОбъекта; // имя объекта метаданных

Перем ВременныйФайлСообщенияОбмена; // временный файл сообщения обмена для выгрузки/загрузки данных.
Перем ВременныйКаталогСообщенийОбмена; // Временный каталог для сообщений обмена.
Перем КаталогОбменаИнформацией; // Сетевой каталог для обмена сообщениями.
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции.

// Создает временный каталог в каталоге временных файлов пользователя операционной системы.
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина - удалось выполнить функцию, Ложь - произошла ошибка.
// 
Функция ВыполнитьДействияПередОбработкойСообщения() Экспорт
	
	ИнициализацияСообщений();
	
	Возврат СоздатьВременныйКаталогСообщенийОбмена();
	
КонецФункции

// Выполняет отправку сообщения обмена на заданный ресурс из временного каталога сообщения обмена.
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина - удалось выполнить функцию, Ложь - произошла ошибка.
// 
Функция ОтправитьСообщение() Экспорт
	
	Результат = Истина;
	
	ИнициализацияСообщений();
	
	Попытка
		
		Если ИспользоватьВременныйКаталогДляОтправкиИПриемаСообщений Тогда
			
			Результат = ОтправитьСообщениеОбмена();
			
		КонецЕсли;
		
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Получает сообщение обмена с заданного ресурса во временный каталог сообщения обмена.
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина - удалось выполнить функцию, Ложь - произошла ошибка.
// 
Функция ПолучитьСообщение() Экспорт
	
	ИнициализацияСообщений();
	
	Попытка
		Результат = ПолучитьСообщениеОбмена();
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
КонецФункции

// Удаляет временный каталог сообщений обмена после выполнения выгрузки или загрузки данных.
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина
//
Функция ВыполнитьДействияПослеОбработкиСообщения() Экспорт
	
	ИнициализацияСообщений();
	
	Если ИспользоватьВременныйКаталогДляОтправкиИПриемаСообщений Тогда
		
		УдалитьВременныйКаталогСообщенийОбмена();
		
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

// Выполняет инициализацию свойств обработки начальными значениями и константами.
//
// Параметры:
//  Нет.
// 
Процедура Инициализация() Экспорт
	
	КаталогОбменаИнформацией = Новый Файл(FILEКаталогОбменаИнформацией);
	
КонецПроцедуры

// Выполняет проверку возможности установки подключения к заданному ресурсу.
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина - подключение может быть установлено; Ложь - нет.
//
Функция ПодключениеУстановлено() Экспорт
	
	ИнициализацияСообщений();
	
	Если ПустаяСтрока(FILEКаталогОбменаИнформацией) Тогда
		
		ПолучитьСообщениеОбОшибке(1);
		Возврат Ложь;
		
	ИначеЕсли Не КаталогОбменаИнформацией.Существует() Тогда
		
		ПолучитьСообщениеОбОшибке(2);
		Возврат Ложь;
		
	ИначеЕсли Не СоздатьФайлПроверки() Тогда
		
		ПолучитьСообщениеОбОшибке(8);
		Возврат Ложь;
		
	ИначеЕсли Не УдалитьФайлПроверки() Тогда
		
		ПолучитьСообщениеОбОшибке(9);
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Функции-свойства

// Функция-свойство: полное имя файла сообщения обмена.
//
// Возвращаемое значение:
//  Строка - полное имя файла сообщения обмена.
//
Функция ИмяФайлаСообщенияОбмена() Экспорт
	
	Имя = "";
	
	Если ТипЗнч(ВременныйФайлСообщенияОбмена) = Тип("Файл") Тогда
		
		Имя = ВременныйФайлСообщенияОбмена.ПолноеИмя;
		
	КонецЕсли;
	
	Возврат Имя;
	
КонецФункции

// Функция-свойство: полное имя каталога сообщения обмена.
//
// Возвращаемое значение:
//  Строка - полное имя каталога сообщения обмена.
//
Функция ИмяКаталогаСообщенияОбмена() Экспорт
	
	Имя = "";
	
	Если ТипЗнч(ВременныйКаталогСообщенийОбмена) = Тип("Файл") Тогда
		
		Имя = ВременныйКаталогСообщенийОбмена.ПолноеИмя;
		
	КонецЕсли;
	
	Возврат Имя;
	
КонецФункции

// Функция-свойство: полное имя каталога обмена информацией (сетевой или локальный ресурс).
//
// Возвращаемое значение:
//  Строка - полное имя каталога обмена информацией (сетевой или локальный ресурс).
//
Функция ИмяКаталогаОбменаИнформацией() Экспорт
	
	Имя = "";
	
	Если ТипЗнч(КаталогОбменаИнформацией) = Тип("Файл") Тогда
		
		Имя = КаталогОбменаИнформацией.ПолноеИмя;
		
	КонецЕсли;
	
	Возврат Имя;
	
КонецФункции

// Функция-свойство: время изменения файла сообщения обмена.
//
// Возвращаемое значение:
//  Дата - время изменения файла сообщения обмена.
//
Функция ДатаФайлаСообщенияОбмена() Экспорт
	
	Результат = Неопределено;
	
	Если ТипЗнч(ВременныйФайлСообщенияОбмена) = Тип("Файл") Тогда
		
		Если ВременныйФайлСообщенияОбмена.Существует() Тогда
			
			Результат = ВременныйФайлСообщенияОбмена.ПолучитьВремяИзменения();
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Локальные служебные процедуры и функции.

Функция СоздатьВременныйКаталогСообщенийОбмена()
	
	Если ИспользоватьВременныйКаталогДляОтправкиИПриемаСообщений Тогда
		
		// Создаем временный каталог для сообщений обмена.
		Попытка
			ИмяВременногоКаталога = ОбменДаннымиСервер.СоздатьВременныйКаталогСообщенийОбмена();
		Исключение
			ПолучитьСообщениеОбОшибке(6);
			ДополнитьСообщениеОбОшибке(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат Ложь;
		КонецПопытки;
		
		ВременныйКаталогСообщенийОбмена = Новый Файл(ИмяВременногоКаталога);
		
	Иначе
		
		ВременныйКаталогСообщенийОбмена = Новый Файл(ИмяКаталогаОбменаИнформацией());
		
	КонецЕсли;
	
	ИмяФайлаСообщения = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ИмяКаталогаСообщенияОбмена(), ШаблонИмениФайлаСообщения + ".xml");
	
	ВременныйФайлСообщенияОбмена = Новый Файл(ИмяФайлаСообщения);
	
	Возврат Истина;
КонецФункции

Функция УдалитьВременныйКаталогСообщенийОбмена()
	
	Попытка
		
		Если Не ПустаяСтрока(ИмяКаталогаСообщенияОбмена()) Тогда
			
			УдалитьФайлы(ИмяКаталогаСообщенияОбмена());
			
			ВременныйКаталогСообщенийОбмена = Неопределено;
			
		КонецЕсли;
		
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
КонецФункции

Функция ОтправитьСообщениеОбмена()
	
	Результат = Истина;
	
	Расширение = ?(СжиматьФайлИсходящегоСообщения(), "zip", "xml");
	
	ИмяФайлаИсходящегоСообщения = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ИмяКаталогаОбменаИнформацией(), ШаблонИмениФайлаСообщения + "." + Расширение);
	
	Если СжиматьФайлИсходящегоСообщения() Тогда
		
		// Получаем имя для временного файла архива.
		ИмяВременногоФайлаАрхива = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ИмяКаталогаСообщенияОбмена(), ШаблонИмениФайлаСообщения + ".zip");
		
		Попытка
			
			Архиватор = Новый ЗаписьZipФайла(ИмяВременногоФайлаАрхива, ПарольАрхиваСообщенияОбмена, НСтр("ru = 'Файл сообщения обмена'"));
			Архиватор.Добавить(ИмяФайлаСообщенияОбмена());
			Архиватор.Записать();
			
		Исключение
			Результат = Ложь;
			ПолучитьСообщениеОбОшибке(5);
			ДополнитьСообщениеОбОшибке(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
		Архиватор = Неопределено;
		
		Если Результат Тогда
			
			// Копируем файл архива в каталог обмена информацией.
			Если Не ВыполнитьКопированиеФайла(ИмяВременногоФайлаАрхива, ИмяФайлаИсходящегоСообщения) Тогда
				Результат = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		// Копируем файл сообщения в каталог обмена информацией.
		Если Не ВыполнитьКопированиеФайла(ИмяФайлаСообщенияОбмена(), ИмяФайлаИсходящегоСообщения) Тогда
			Результат = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСообщениеОбмена()
	
	ТаблицаФайловСообщенийОбмена = Новый ТаблицаЗначений;
	ТаблицаФайловСообщенийОбмена.Колонки.Добавить("Файл", Новый ОписаниеТипов("Файл"));
	ТаблицаФайловСообщенийОбмена.Колонки.Добавить("ВремяИзменения");
	
	МассивНайденныхФайлов = НайтиФайлы(ИмяКаталогаОбменаИнформацией(), ШаблонИмениФайлаСообщения + ".*", Ложь);
	
	Для Каждого ТекущийФайл Из МассивНайденныхФайлов Цикл
		
		// Проверяем нужное расширение.
		Если ((ВРег(ТекущийФайл.Расширение) <> ".ZIP")
			И (ВРег(ТекущийФайл.Расширение) <> ".XML")) Тогда
			
			Продолжить;
			
		// Проверяем что это файл, а не каталог.
		ИначеЕсли НЕ ТекущийФайл.ЭтоФайл() Тогда
			
			Продолжить;
			
		// Проверяем ненулевой размер файла.
		ИначеЕсли (ТекущийФайл.Размер() = 0) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		// Файл является требуемым сообщением обмена; добавляем его в таблицу.
		СтрокаТаблицы = ТаблицаФайловСообщенийОбмена.Добавить();
		СтрокаТаблицы.Файл           = ТекущийФайл;
		СтрокаТаблицы.ВремяИзменения = ТекущийФайл.ПолучитьВремяИзменения();
		
	КонецЦикла;
	
	Если ТаблицаФайловСообщенийОбмена.Количество() = 0 Тогда
		
		ПолучитьСообщениеОбОшибке(3);
		
		СтрокаСообщения = НСтр("ru = 'Каталог обмена информацией: ""%1""'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ИмяКаталогаОбменаИнформацией());
		ДополнитьСообщениеОбОшибке(СтрокаСообщения);
		
		СтрокаСообщения = НСтр("ru = 'Имя файла сообщения обмена: ""%1"" или ""%2""'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ШаблонИмениФайлаСообщения + ".xml", ШаблонИмениФайлаСообщения + ".zip");
		ДополнитьСообщениеОбОшибке(СтрокаСообщения);
		
		Возврат Ложь;
		
	Иначе
		
		ТаблицаФайловСообщенийОбмена.Сортировать("ВремяИзменения Убыв");
		
		// Получаем из таблицы самый "свежий" файл сообщения обмена.
		ФайлВходящегоСообщения = ТаблицаФайловСообщенийОбмена[0].Файл;
		
		ФайлЗапакован = (ВРег(ФайлВходящегоСообщения.Расширение) = ".ZIP");
		
		Если ФайлЗапакован Тогда
			
			// Получаем имя для временного файла архива.
			ИмяВременногоФайлаАрхива = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ИмяКаталогаСообщенияОбмена(), ШаблонИмениФайлаСообщения + ".zip");
			
			// Копируем файл архива из сетевого каталога во временный.
			Если Не ВыполнитьКопированиеФайла(ФайлВходящегоСообщения.ПолноеИмя, ИмяВременногоФайлаАрхива) Тогда
				Возврат Ложь;
			КонецЕсли;
			
			// Распаковываем временный файл архива.
			УспешноРаспаковано = ОбменДаннымиСервер.РаспаковатьZipФайл(ИмяВременногоФайлаАрхива, ИмяКаталогаСообщенияОбмена(), ПарольАрхиваСообщенияОбмена);
			
			Если Не УспешноРаспаковано Тогда
				ПолучитьСообщениеОбОшибке(4);
				Возврат Ложь;
			КонецЕсли;
			
			// Проверка на существование файла сообщения.
			Файл = Новый Файл(ИмяФайлаСообщенияОбмена());
			
			Если Не Файл.Существует() Тогда
				
				ПолучитьСообщениеОбОшибке(7);
				Возврат Ложь;
				
			КонецЕсли;
			
		Иначе
			
			// Просто копируем файл входящего сообщения из каталога обмена в каталог временных файлов.
			Если ИспользоватьВременныйКаталогДляОтправкиИПриемаСообщений И Не ВыполнитьКопированиеФайла(ФайлВходящегоСообщения.ПолноеИмя, ИмяФайлаСообщенияОбмена()) Тогда
				
				Возврат Ложь;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

Функция СоздатьФайлПроверки()
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.ДобавитьСтроку(НСтр("ru = 'Временный файл проверки'"));
	
	Попытка
		
		ТекстовыйДокумент.Записать(ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ИмяКаталогаОбменаИнформацией(), ИмяВременногоФайлаФлага()));
		
	Исключение
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными(), УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
КонецФункции

Функция УдалитьФайлПроверки()
	
	Попытка
		
		УдалитьФайлы(ИмяКаталогаОбменаИнформацией(), ИмяВременногоФайлаФлага());
		
	Исключение
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными(), УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
КонецФункции

Функция ВыполнитьКопированиеФайла(Знач ИмяФайлаИсточника, Знач ИмяФайлаПриемника)
	
	Попытка
		
		УдалитьФайлы(ИмяФайлаПриемника);
		КопироватьФайл(ИмяФайлаИсточника, ИмяФайлаПриемника);
		
	Исключение
		
		СтрокаСообщения = НСтр("ru = 'Ошибка при копировании файла из %1 в %2. Описание ошибки: %3'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения,
							ИмяФайлаИсточника,
							ИмяФайлаПриемника,
							КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		УстановитьСтрокуСообщенияОбОшибке(СтрокаСообщения);
		
		Возврат Ложь
		
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Процедура ПолучитьСообщениеОбОшибке(НомерСообщения)
	
	УстановитьСтрокуСообщенияОбОшибке(СообщенияОшибок[НомерСообщения])
	
КонецПроцедуры

Процедура УстановитьСтрокуСообщенияОбОшибке(Знач Сообщение)
	
	Если Сообщение = Неопределено Тогда
		Сообщение = НСтр("ru = 'Внутренняя ошибка'");
	КонецЕсли;
	
	СтрокаСообщенияОбОшибке   = Сообщение;
	СтрокаСообщенияОбОшибкеЖР = ИмяОбъекта + ": " + Сообщение;
	
КонецПроцедуры

Процедура ДополнитьСообщениеОбОшибке(Сообщение)
	
	СтрокаСообщенияОбОшибкеЖР = СтрокаСообщенияОбОшибкеЖР + Символы.ПС + Сообщение;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Функции-свойства

Функция СжиматьФайлИсходящегоСообщения()
	
	Возврат FILEСжиматьФайлИсходящегоСообщения;
	
КонецФункции

Функция ИмяВременногоФайлаФлага()
	
	Возврат "flag.tmp";
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Инициализация

Процедура ИнициализацияСообщений()
	
	СтрокаСообщенияОбОшибке   = "";
	СтрокаСообщенияОбОшибкеЖР = "";
	
КонецПроцедуры

Процедура ИнициализацияСообщенийОшибок()
	
	СообщенияОшибок = Новый Соответствие;
	СообщенияОшибок.Вставить(1, НСтр("ru = 'Ошибка подключения: Не указан каталог обмена информацией.'"));
	СообщенияОшибок.Вставить(2, НСтр("ru = 'Ошибка подключения: Каталог обмена информацией не существует.'"));
	
	СообщенияОшибок.Вставить(3, НСтр("ru = 'В каталоге обмена информацией не был обнаружен файл сообщения с данными.'"));
	СообщенияОшибок.Вставить(4, НСтр("ru = 'Ошибка при распаковке сжатого файла сообщения.'"));
	СообщенияОшибок.Вставить(5, НСтр("ru = 'Ошибка при сжатии файла сообщения обмена.'"));
	СообщенияОшибок.Вставить(6, НСтр("ru = 'Ошибка при создании временного каталога'"));
	СообщенияОшибок.Вставить(7, НСтр("ru = 'Архив не содержит файл сообщения обмена'"));
	
	СообщенияОшибок.Вставить(8, НСтр("ru = 'Ошибка записи файла в каталог обмена информацией. Проверьте права пользователя на доступ к каталогу.'"));
	СообщенияОшибок.Вставить(9, НСтр("ru = 'Ошибка удаления файла из каталога обмена информацией. Проверьте права пользователя на доступ к каталогу.'"));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Операторы основной программы.

ИнициализацияСообщений();
ИнициализацияСообщенийОшибок();

ВременныйКаталогСообщенийОбмена = Неопределено;
ВременныйФайлСообщенияОбмена    = Неопределено;

ИмяОбъекта = НСтр("ru = 'Обработка: %1'");
ИмяОбъекта = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ИмяОбъекта, Метаданные().Имя);

#КонецОбласти

#КонецЕсли
