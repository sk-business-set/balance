////////////////////////////////////////////////////////////////////////////////
// Подсистема "Отправка SMS"
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Отправляет SMS через настроенного поставщика услуги, возвращает идентификатор сообщения.
//
// Параметры:
//  НомераПолучателей  - Массив - массив строк номеров получателей в формате +7ХХХХХХХХХХ;
//  Текст              - Строка - текст сообщения, максимальная длина у операторов может быть разной;
//  ИмяОтправителя     - Строка - имя отправителя, которое будет отображаться вместо номера у получателей.
//  ПеревестиВТранслит - Булево - Истина, если требуется переводить текст сообщения в транслит перед отправкой.
//
// Возвращаемое значение:
//  Структура:
//    * ОтправленныеСообщения - Массив - массив структур:
//      ** НомерПолучателя - Строка.
//      ** ИдентификаторСообщения - Строка.
//    * ОписаниеОшибки - Строка - пользовательское представление ошибки, если пустая строка,
//                                то ошибки нет.
Функция ОтправитьSMS(НомераПолучателей, Знач Текст, ИмяОтправителя = Неопределено, ПеревестиВТранслит = Ложь) Экспорт
	
	ПроверитьПрава();
	
	Результат = Новый Структура("ОтправленныеСообщения,ОписаниеОшибки", Новый Массив, "");
	
	Если ПеревестиВТранслит Тогда
		Текст = СтроковыеФункцииКлиентСервер.СтрокаЛатиницей(Текст);
	КонецЕсли;
	
	Если Не НастройкаОтправкиSMSВыполнена() Тогда
		Результат.ОписаниеОшибки = НСтр("ru = 'Неверно заданы настройки провайдера для отправки SMS.'");
		Возврат Результат;
	КонецЕсли;
	
	НастройкиОтправкиSMS = ОтправкаSMSПовтИсп.НастройкиОтправкиSMS();
	Если ИмяОтправителя = Неопределено Тогда
		ИмяОтправителя = НастройкиОтправкиSMS.ИмяОтправителя;
	КонецЕсли;
	
	Если НастройкиОтправкиSMS.Провайдер = Перечисления.ПровайдерыSMS.МТС Тогда // МТС
		Результат = ОтправкаSMSЧерезМТС.ОтправитьSMS(НомераПолучателей, Текст, ИмяОтправителя,
			НастройкиОтправкиSMS.Логин, НастройкиОтправкиSMS.Пароль);
	ИначеЕсли НастройкиОтправкиSMS.Провайдер = Перечисления.ПровайдерыSMS.Билайн Тогда // Билайн
		Результат = ОтправкаSMSЧерезБилайн.ОтправитьSMS(НомераПолучателей, Текст, ИмяОтправителя,
			НастройкиОтправкиSMS.Логин, НастройкиОтправкиSMS.Пароль);
	ИначеЕсли НастройкиОтправкиSMS.Провайдер = Перечисления.ПровайдерыSMS.SMSRU Тогда // SMS.RU
		Результат = ОтправкаSMSЧерезSMSRU.ОтправитьSMS(НомераПолучателей, Текст, ИмяОтправителя,
			НастройкиОтправкиSMS.Логин, НастройкиОтправкиSMS.Пароль);
	ИначеЕсли НастройкиОтправкиSMS.Провайдер = Перечисления.ПровайдерыSMS.SMSЦЕНТР Тогда // SMS-ЦЕНТР
		Результат = ОтправкаSMSЧерезSMSЦЕНТР.ОтправитьSMS(НомераПолучателей, Текст, ИмяОтправителя,
			НастройкиОтправкиSMS.Логин, НастройкиОтправкиSMS.Пароль);
	ИначеЕсли НастройкиОтправкиSMS.Провайдер = Перечисления.ПровайдерыSMS.СМСУслуги Тогда // СМС-услуги
		Результат = ОтправкаSMSЧерезСМСУслуги.ОтправитьSMS(НомераПолучателей, Текст, ИмяОтправителя,
			НастройкиОтправкиSMS.Логин, НастройкиОтправкиSMS.Пароль);
	ИначеЕсли НастройкиОтправкиSMS.Провайдер = Перечисления.ПровайдерыSMS.GSMINFORM Тогда // GSM-INFORM
		Результат = ОтправкаSMSЧерезGSMINFORM.ОтправитьSMS(НомераПолучателей, Текст, ИмяОтправителя,
			НастройкиОтправкиSMS.Логин, НастройкиОтправкиSMS.Пароль);
	ИначеЕсли ЗначениеЗаполнено(НастройкиОтправкиSMS.Провайдер) Тогда // Другой
		ПараметрыОтправки = Новый Структура;
		ПараметрыОтправки.Вставить("НомераПолучателей", НомераПолучателей);
		ПараметрыОтправки.Вставить("Текст", Текст);
		ПараметрыОтправки.Вставить("ИмяОтправителя", ИмяОтправителя);
		ПараметрыОтправки.Вставить("Логин", НастройкиОтправкиSMS.Логин);
		ПараметрыОтправки.Вставить("Пароль", НастройкиОтправкиSMS.Пароль);
		ПараметрыОтправки.Вставить("Провайдер", НастройкиОтправкиSMS.Провайдер);
		
		ОтправкаSMSПереопределяемый.ОтправитьSMS(ПараметрыОтправки, Результат);
		
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
			"ОтправкаSMSПереопределяемый.ОтправитьSMS",
			"Результат",
			Результат,
			Тип("Структура"),
			Новый Структура("ОтправленныеСообщения,ОписаниеОшибки", Тип("Массив"), Тип("Строка")));
		Если Результат.ОтправленныеСообщения.Количество() > 0 Тогда
			ОбщегоНазначенияКлиентСервер.Проверить(
				ТипЗнч(Результат.ОтправленныеСообщения[0]) = Тип("Структура"),
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Неверный тип значения в коллекции Результат.ОтправленныеСообщения:
						|ожидается тип ""Структура"", передан тип ""%1""'"),
						ТипЗнч(Результат.ОтправленныеСообщения[0])),
				"ОтправкаSMSПереопределяемый.ОтправитьSMS");
			Для Индекс = 0 По Результат.ОтправленныеСообщения.Количество() - 1 Цикл
				ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
					"ОтправкаSMSПереопределяемый.ОтправитьSMS",
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Результат.ОтправленныеСообщения[%1]", Формат(Индекс, "ЧН=; ЧГ=0")),
					Результат.ОтправленныеСообщения[Индекс],
					Тип("Структура"),
					Новый Структура("НомерПолучателя,ИдентификаторСообщения", Тип("Строка"), Тип("Строка")));
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Запрашивает статус доставки сообщения у поставщика услуг.
//
// Параметры:
//  ИдентификаторСообщения - Строка - идентификатор, присвоенный SMS при отправке;
//
// Возвращаемое значение:
//  Строка - статус доставки сообщения, который вернул поставщик услуг:
//           "НеОтправлялось" - сообщение еще не было обработано поставщиком услуг (в очереди);
//           "Отправляется"   - сообщение стоит в очереди на отправку у провайдера;
//           "Отправлено"     - сообщение отправлено, ожидается подтверждение о доставке;
//           "НеОтправлено"   - сообщение не отправлено (недостаточно средств на счете, перегружена сеть оператора);
//           "Доставлено"     - сообщение доставлено адресату;
//           "НеДоставлено"   - сообщение не удалось доставить (абонент недоступен, время ожидания подтверждения
//                              доставки от абонента истекло);
//           "Ошибка"         - не удалось получить статус у поставщика услуг (статус неизвестен).
//
Функция СтатусДоставки(Знач ИдентификаторСообщения) Экспорт
	
	ПроверитьПрава();
	
	Если ПустаяСтрока(ИдентификаторСообщения) Тогда
		Возврат "НеОтправлялось";
	КонецЕсли;
	
	НастройкиОтправкиSMS = ОтправкаSMSПовтИсп.НастройкиОтправкиSMS();
	
	Если НастройкиОтправкиSMS.Провайдер = Перечисления.ПровайдерыSMS.СМСУслуги Тогда
		ЧастиИдентификатора = СтрРазделить(ИдентификаторСообщения, "/", Истина);
		НомерПолучателя = ЧастиИдентификатора[0];
		ИдентификаторСообщения = ЧастиИдентификатора[1];
	КонецЕсли;
	
	Результат = ОтправкаSMSПовтИсп.СтатусДоставки(ИдентификаторСообщения);
	Если ТипЗнч(Результат) = Тип("Соответствие") Тогда
		Результат = Результат[НомерПолучателя];
		Если Результат = Неопределено Тогда
			Результат = "НеОтправлялось";
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Проверяет правильность сохраненных настроек отправки SMS.
Функция НастройкаОтправкиSMSВыполнена() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Истина;
	
	НастройкиОтправкиSMS = ОтправкаSMSПовтИсп.НастройкиОтправкиSMS();
	Провайдер = НастройкиОтправкиSMS.Провайдер;
	Если Провайдер = Перечисления.ПровайдерыSMS.МТС Или Провайдер = Перечисления.ПровайдерыSMS.Билайн Тогда
		Результат = Не ПустаяСтрока(НастройкиОтправкиSMS.Логин) И Не ПустаяСтрока(НастройкиОтправкиSMS.Пароль);
	ИначеЕсли ЗначениеЗаполнено(НастройкиОтправкиSMS.Провайдер) Тогда
		Отказ = Ложь;
		ОтправкаSMSПереопределяемый.ПриПроверкеНастроекОтправкиSMS(НастройкиОтправкиSMS, Отказ);
		Результат = Не Отказ;
	Иначе
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Проверяет возможность отправки SMS для текущего пользователя.
Функция ДоступнаОтправкаSMS() Экспорт
	Возврат Пользователи.РолиДоступны("ОтправкаSMS") И НастройкаОтправкиSMSВыполнена() Или Пользователи.ЭтоПолноправныйПользователь();
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиента"].Добавить(
		"ОтправкаSMS");
	
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам"].Добавить(
		"ОтправкаSMS");
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обновление ИБ.

// Предназначена для перевода паролей в безопасное хранилище.
// Используется в обработчике обновления ИБ.
Процедура ПеренестиПаролиВБезопасноеХранилище() Экспорт
	ЛогинДляОтправкиSMS = Константы.УдалитьЛогинДляОтправкиSMS.Получить();
	ПарольДляОтправкиSMS = Константы.УдалитьПарольДляОтправкиSMS.Получить();
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Константа.ПровайдерSMS");
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, ПарольДляОтправкиSMS);
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, ЛогинДляОтправкиSMS, "Логин");
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет перечень запросов внешних разрешений, которые обязательно должны быть предоставлены
// при создании информационной базы или обновлении программы.
//
// Параметры:
//  ЗапросыРазрешений - Массив - список значений, возвращенных функцией.
//                      РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов().
//
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	ЗапросыРазрешений.Добавить(
		РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(ОтправкаSMSЧерезБилайн.Разрешения()));
	
	ЗапросыРазрешений.Добавить(
		РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(ОтправкаSMSЧерезМТС.Разрешения()));
	
	ЗапросыРазрешений.Добавить(
		РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(ОтправкаSMSЧерезSMSRU.Разрешения()));

	ЗапросыРазрешений.Добавить(
		РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(ОтправкаSMSЧерезSMSЦЕНТР.Разрешения()));
		
	ЗапросыРазрешений.Добавить(
		РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(ОтправкаSMSЧерезСМСУслуги.Разрешения()));
		
	ЗапросыРазрешений.Добавить(
		РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(ОтправкаSMSЧерезGSMINFORM.Разрешения()));
		
	ЗапросыРазрешений.Добавить(
		РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(ДополнительныеРазрешения()));
	
КонецПроцедуры

Функция ДополнительныеРазрешения()
	Разрешения = Новый Массив;
	ОтправкаSMSПереопределяемый.ПриПолученииРазрешений(Разрешения);
	
	Возврат Разрешения;
КонецФункции

// Заполняет структуру параметров, необходимых для работы клиентского кода
// конфигурации.
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	Параметры.Вставить("ДоступнаОтправкаSMS", ДоступнаОтправкаSMS());
КонецПроцедуры

Процедура ПроверитьПрава() Экспорт
	Если Не Пользователи.РолиДоступны("ОтправкаSMS") Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для выполнения операции.'");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
