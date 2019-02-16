////////////////////////////////////////////////////////////////////////////////
//  Методы, позволяющие начать и закончить замер времени выполнения ключевой операции.
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

#Область ПрограммныйИнтерфейсОценкаПроизводительности

// Устарела. Будет удалена в следующей редакции библиотеки.
// Необходимо использовать процедуру
//		ОценкаПроизводительности.СоздатьКлючевыеОперации
// Создает ключевые операции в случае их отсутствия.
//
// Параметры:
//  КлючевыеОперации - Массив ключевых операций
//		КлючеваяОперация - Структура("ИмяКлючевойОперации, ЦелевоеВремя)
//
#Если Сервер Тогда
Процедура СоздатьКлючевыеОперации(КлючевыеОперации) Экспорт
	ОценкаПроизводительности.СоздатьКлючевыеОперации(КлючевыеОперации);	
КонецПроцедуры
#КонецЕсли

// Устарела. Будет удалена в следующей редакции библиотеки.
// Необходимо использовать
//		на сервере - ОценкаПроизводительности.НачатьЗамерВремени.
//		на клиенте - ОценкаПроизводительностиКлиент.НачатьЗамерВремени.
//
// Активизирует замер времени выполнения ключевой операции.
// Может вызываться как с клиента, так и с сервера.
// Результат замера будет записан в <РегистрСведений.ЗамерыВремени>.
//
// В случае вызова с клиента, заканчивать замер не нужно, время завершения замера зафиксируется
// через глобальный обработчик ожидания <ЗакончитьЗамерВремениАвто>.
// Возвращает время начала замера.
//
// В случае вызова с сервера функция только возвращает время начала
// Закончить замер нужно явно вызовом процедуры
// <ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачала, Комментарий = Неопределено)>
//
// Параметры:
//  КлючеваяОперация - СправочникСсылка.КлючевыеОперации - ключевая операция
//						либо Строка - название ключевой операции
//  При вызове с сервера аргумент игнорируется.
//
// Возвращаемое значение:
//  Число - время начала с точностью до миллисекунд.
//
Функция НачатьЗамерВремени(КлючеваяОперация = Неопределено) Экспорт
	Параметры = Новый Структура;
	Параметры.Вставить("КлючеваяОперация", КлючеваяОперация);
	
	ВремяНачала = НачатьЗамерВремениСлужебный(Параметры);
		
	Возврат ВремяНачала;
КонецФункции

// Устарела. Будет удалена в следующей редакции библиотеки.
// НеобходимоИспользовать
//		на сервере - 	ОценкаПроизводительности.НачатьЗамерВремени.
//		на клиенте - 	ОценкаПроизводительностиКлиент.НачатьЗамерВремени.
//		на клиенте - 	для установки комментария замера необходимо использовать
//						процедуру ОценкаПроизводительностиКлиент.УстановитьКомментарийЗамера.
//
// Активизирует замер времени выполнения ключевой операции с произвольным комментарием.
// Может вызываться как с клиента, так и с сервера.
// Результат замера будет записан в регистр сведений ЗамерыВремени.
//
// В случае вызова с клиента, заканчивать замер не нужно, время завершения замера зафиксируется
// через глобальный обработчик ожидания ЗакончитьЗамерВремениАвто.
// Возвращает время начала замера.
//
// В случае вызова с сервера функция только возвращает время начала
// закончить замер нужно явно вызовом процедуры общего
// модуля ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени.
//
// Параметры:
// КлючеваяОперация - 	СправочникСсылка.КлючевыеОперации - ключевая операция,
//						либо Строка - название ключевой операции.
//  					При вызове с сервера аргумент игнорируется.
// Комментарий - 		Строка(256) для записи произвольной информации
//						при выполнении замера.
//  					При вызове с сервера аргумент игнорируется.
//
// Возвращаемое значение:
//  Число - время начала с точностью до миллисекунд.
//
Функция НачатьЗамерВремениСКомментарием(КлючеваяОперация, Комментарий) Экспорт
	Параметры = Новый Структура;
	Параметры.Вставить("КлючеваяОперация", КлючеваяОперация);
	Параметры.Вставить("Комментарий", Комментарий);
	
	ВремяНачала = НачатьЗамерВремениСлужебный(Параметры);
	
	Возврат ВремяНачала;
КонецФункции

#Если Сервер Тогда
// Устарела. Будет удалена в следующей редакции библиотеки.
//	Необходимо использовать
//		ОценкаПроизводительности.ЗакончитьЗамерВремени
//
// Процедура завершает замер времени ключевой операции на сервере
// и записывает результат на сервере в <РегистрСведений.ЗамерыВремени>
// Вызывается только с сервера.
//
// Параметры:
// КлючеваяОперация -	СправочникСсылка.КлючевыеОперации - ключевая операция
//						либо Строка - название ключевой операции
// ВремяНачала - 		Число (Формат ТекущаяУниверсальнаяДатаВМиллисекундах()/1000) или Дата начала замера
// Комментарий - 		Строка(256) для записи произвольной информации
//						при выполнении замера.
Процедура ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачала, Комментарий = Неопределено) Экспорт
	ОценкаПроизводительности.ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачала * 1000, 1, Комментарий);
КонецПроцедуры
#КонецЕсли

#Если Клиент Тогда
// Устарела. Будет удалена в следующей редакции библиотеки.
//	Необходимо использовать
//		ОценкаПроизводительностиКлиент.НачатьЗамерВремени
//
// Активизирует замер времени выполнения ключевой операции. Для завершения замера необходимо
// явно вызвать в общем модуле <ОценкаПроизводительностиГлобальный>
// процедуру <Процедура ЗакончитьРучнойЗамерВремени(УИДЗамера)>, необходимо передать точно такой же
// УИДЗамера, как и в данной функции.
// Результат замера будет записан в <РегистрСведений.ЗамерыВремени>.
//
// Параметры:
// КлючеваяОперация -	СправочникСсылка.КлючевыеОперации - ключевая операция
//						либо Строка - название ключевой операции.
// УИДЗамера -			Тип("УникальныйИдентификатор") - уникальный идентификатор замера
//						должен обеспечивать уникальность замера, например использовать
//						уникальный идентификатор формы.
// Комментарий - 		Строка(256) для записи произвольной информации
//						при выполнении замера.
//
Функция НачатьРучнойЗамерВремени(КлючеваяОперация, УИДЗамера = Неопределено, Комментарий = Неопределено) Экспорт
	Если УИДЗамера = Неопределено Тогда
		УИДЗамера = Новый УникальныйИдентификатор();
	КонецЕсли;	
		
	Параметры = Новый Структура;
	Параметры.Вставить("КлючеваяОперация", КлючеваяОперация);
	Параметры.Вставить("УИДЗамера", УИДЗамера);
	Параметры.Вставить("Комментарий", Комментарий);
	Параметры.Вставить("АвтоЗавершения", Ложь);
	
	НачатьЗамерВремениСлужебный(Параметры);
	
	Возврат УИДЗамера;
КонецФункции
#КонецЕсли

#Если Клиент Тогда
// Устарела. Будет удалена в следующей редакции библиотеки.
//	Необходимо использовать
//		ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени
//
// Процедура завершает ручной замер времени ключевой операции
// Вызывается только на клиенте.
//
// Параметры:
// УИДЗамера -	УникальныйИдентификатор.
//
Процедура ЗакончитьРучнойЗамерВремени(УИДЗамера) Экспорт
	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(УИДЗамера);
КонецПроцедуры
#КонецЕсли

#КонецОбласти

#Область ПрограммныйИнтерфейсОценкаПроизводительностиТехнологическая

// Устарела. Будет удалена в следующей редакции библиотеки.
//	НеобходимоИспользовать
//		на сервере - ОценкаПроизводительности.НачатьЗамерВремениНаСервере
//		на клиенте - ОценкаПроизводительностиКлиент.НачатьЗамерВремениТехнологическийНаКлиенте
// Активизирует замер времени выполнения технологической ключевой операции.
// Может вызываться как с клиента, так и с сервера.
// Результат замера будет записан в <РегистрСведений.ЗамерыВремениТехнологические>.
//
// В случае вызова с клиента, заканчивать замер не нужно, время завершения замера зафиксируется
// через глобальный обработчик ожидания <ЗакончитьЗамерВремениАвто>.
// Возвращает время начала.
//
// В случае вызова с сервера функция только возвращает время начала
// Закончить замер нужно явно вызовом процедуры <ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачала, Комментарий = Неопределено)>.
//
// Параметры:
//  КлючеваяОперация - СправочникСсылка.КлючевыеОперации - ключевая операция
//						либо Строка - название ключевой операции
//  При вызове с сервера аргумент игнорируется.
//	Комментарий - 	Строка(256) для записи произвольной информации
//					при выполнении замера.
//
// Возвращаемое значение:
//  Дата или число - время начала с точностью до миллисекунд или секунд в зависимости от версии платформы.
//
Функция НачатьЗамерВремениТехнологический(КлючеваяОперация, Комментарий = Неопределено) Экспорт
	Параметры = Новый Структура;
	Параметры.Вставить("КлючеваяОперация", КлючеваяОперация);
	Параметры.Вставить("Комментарий", Комментарий);
	Параметры.Вставить("Технологический", Истина);
	
	ВремяНачала = НачатьЗамерВремениСлужебный(Параметры);
		
	Возврат ВремяНачала;
КонецФункции

#Если Сервер Тогда
// Устарела. Будет удалена в следующей редакции библиотеки.
//	Необходимо использовать
//		ОценкаПроизводительности.ЗакончитьЗамерВремениТехнологическийНаСервере
// Процедура завершает замер времени технологической ключевой операции на сервере
// и записывает результат на сервере в <РегистрСведений.ЗамерыВремениТехнологические>
// Вызывается только с сервера.
//
// Параметры:
// КлючеваяОперация -	СправочникСсылка.КлючевыеОперации - ключевая операция
//						либо Строка - название ключевой операции
// ВремяНачала - 		Число (Формат ТекущаяУниверсальнаяДатаВМиллисекундах()/1000) или Дата начала замера
// Комментарий - 		Строка(256) для записи произвольной информации
//						при выполнении замера.
Процедура ЗакончитьЗамерВремениТехнологический(КлючеваяОперация, ВремяНачала, Комментарий = Неопределено) Экспорт
	ОценкаПроизводительности.ЗакончитьЗамерВремениТехнологический(КлючеваяОперация, ВремяНачала * 1000, Комментарий);
КонецПроцедуры
#КонецЕсли

// Устарела. Будет удалена в следующей редакции библиотеки.
//	Необходимо использовать
//		ОценкаПроизводительностиКлиент.НачатьЗамерВремениТехнологическийНаКлиенте
// Активизирует замер времени выполнения технологической ключевой операции с явным завершением времени
// длительности ключевой операции. Вызывается только с клиента.
// Для завершения замера необходимо вызвать в общем модуле <ОценкаПроизводительностиГлобальный>
// процедуру <Процедура ЗакончитьРучнойЗамерВремени(УИДЗамера)>, необходимо передать точно такой же
// УИДЗамера, как и в данную процедуру.
// Результат замера будет записан в <РегистрСведений.ЗамерыВремениТехнологические>.
//
// Параметры:
// КлючеваяОперация -	СправочникСсылка.КлючевыеОперации - ключевая операция
//						либо Строка - название ключевой операции.
// УИДЗамера -			Тип("УникальныйИдентификатор") - уникальный идентификатор замера
//						должен обеспечивать уникальность замера, например использовать
//						уникальный идентификатор формы.
// Комментарий - 		Строка(256) для записи произвольной информации
//						при выполнении замера.
//
#Если Клиент Тогда
Функция НачатьРучнойЗамерВремениТехнологический(КлючеваяОперация, УИДЗамера = Неопределено, Комментарий = Неопределено) Экспорт
	Если УИДЗамера = Неопределено Тогда
		УИДЗамера = Новый УникальныйИдентификатор();
	КонецЕсли;
		
	Параметры = Новый Структура;
	Параметры.Вставить("КлючеваяОперация", КлючеваяОперация);
	Параметры.Вставить("УИДЗамера", УИДЗамера);
	Параметры.Вставить("Комментарий", Комментарий);
	Параметры.Вставить("АвтоЗавершения", Ложь);
	Параметры.Вставить("Технологический", Истина);
	
	НачатьЗамерВремениСлужебный(Параметры);
КонецФункции
#КонецЕсли

#Если Клиент Тогда
// Устарела. Будет удалена в следующей редакции библиотеки.
//	Необходимо использовать
//		ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремениНаКлиенте
// Процедура завершает ручной технологический замер времени ключевой операции
// Вызывается только на клиенте.
//
// Параметры:
// УИДЗамера -	УникальныйИдентификатор.
//
Процедура ЗакончитьРучнойЗамерВремениТехнологический(УИДЗамера) Экспорт
	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(УИДЗамера);
КонецПроцедуры
#КонецЕсли

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НачатьЗамерВремениСлужебный(Параметры)
	Если Параметры.Свойство("КлючеваяОперация") Тогда
		КлючеваяОперация = Параметры.КлючеваяОперация;
	Иначе
		КлючеваяОперация = Неопределено;
	КонецЕсли;
	
	Если Параметры.Свойство("УИДЗамера") И Параметры.УИДЗамера <> Неопределено Тогда
		УИДЗамераВходящий = Параметры.УИДЗамера;
	Иначе
		УИДЗамераВходящий = Неопределено;
	КонецЕсли;
	
	Если Параметры.Свойство("Комментарий") Тогда
		Комментарий = Параметры.Комментарий;
	Иначе
		Комментарий = Неопределено;
	КонецЕсли;
	
	Если Параметры.Свойство("АвтоЗавершение") И Параметры.АвтоЗавершение <> Неопределено Тогда
		АвтоЗавершение = Параметры.АвтоЗавершение;
	Иначе
		АвтоЗавершение = Истина;
	КонецЕсли;
	
	Если Параметры.Свойство("Технологический") Тогда
		Технологический = Параметры.Технологический;
	Иначе
		Технологический = Ложь;
	КонецЕсли;
	
	ВремяНачала = 0;
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		#Если Клиент И ТолстыйКлиентУправляемоеПриложение И Сервер Тогда
			Если Не ЗначениеЗаполнено(КлючеваяОперация) Тогда
				// Считаем, что вызов пришел с сервера. Возвращаем начало замера
				Возврат ОценкаПроизводительности.НачатьЗамерВремени()/1000;
			КонецЕсли;
		#КонецЕсли
		
		#Если Клиент Тогда
			
			Если Не ЗначениеЗаполнено(КлючеваяОперация) Тогда
				ВызватьИсключение НСтр("ru = 'Не указана ключевая операция.'");
			КонецЕсли;
			
			Если НЕ Технологический Тогда
				УИДЗамера = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(АвтоЗавершение, КлючеваяОперация);
			Иначе
				УИДЗамера = ОценкаПроизводительностиКлиент.НачатьЗамерВремениТехнологический(АвтоЗавершение, КлючеваяОперация);
			КонецЕсли;
			
			ОценкаПроизводительностиКлиент.УстановитьКомментарийЗамера(УИДЗамера, Комментарий);
			Если НЕ АвтоЗавершение И УИДЗамераВходящий <> Неопределено Тогда
				ОценкаПроизводительностиКлиент.ИзменитьУИДЗамера(УИДЗамера, УИДЗамераВходящий);
			КонецЕсли;
						
		#КонецЕсли
	КонецЕсли;
	
	Возврат ТекущаяУниверсальнаяДатаВМиллисекундах()/1000;
	
КонецФункции

// Получает имя дополнительного свойства не проверять приоритеты при записи ключевой операции.
//
// Возвращаемое значение:
//  Строка - имя дополнительного свойства.
//
Функция НеПроверятьПриоритет() Экспорт
	
	Возврат "НеПроверятьПриоритет";
	
КонецФункции

#Если Сервер Тогда
// Процедура записывает данные в журнал регистрации
//
// Параметры:
//  ИмяСобытия - Строка
//  Уровень - УровеньЖурналаРегистрации
//  ТекстСообщения - Строка.
//
Процедура ЗаписатьВЖурналРегистрации(ИмяСобытия, Уровень, ТекстСообщения) Экспорт
	
	ЗаписьЖурналаРегистрации(ИмяСобытия,
		Уровень,
		,
		НСтр("ru = 'Оценка производительности'"),
		ТекстСообщения);
	
КонецПроцедуры
#КонецЕсли

// Ключ параметра регламентного задания, соответствующий локальному каталогу экспорта.
//
Функция ЛокальныйКаталогЭкспортаКлючЗадания() Экспорт
	
	Возврат "ЛокальныйКаталогЭкспорта";
	
КонецФункции

// Ключ параметра регламентного задания, соответствующий ftp каталогу экспорта
//
Функция FTPКаталогЭкспортаКлючЗадания() Экспорт
	
	Возврат "FTPКаталогЭкспорта";
	
КонецФункции

#Область ОбщегоНазначенияКлиентСерверКопия

// Разбирает строку URI на составные части и возвращает в виде структуры.
// На основе RFC 3986.
//
// Параметры:
//     СтрокаURI - Строка - ссылка на ресурс в формате:
//                          <схема>://<логин>:<пароль>@<хост>:<порт>/<путь>?<параметры>#<якорь>.
//
// Возвращаемое значение:
//     Структура - составные части URI согласно формату:
//         * Схема         - Строка.
//         * Логин         - Строка.
//         * Пароль        - Строка.
//         * ИмяСервера    - Строка - часть <хост>:<порт> входного параметра.
//         * Хост          - Строка.
//         * Порт          - Строка.
//         * ПутьНаСервере - Строка - часть <путь>?<параметры>#<якорь> входного параметра.
//
Функция СтруктураURI(Знач СтрокаURI) Экспорт
	
	СтрокаURI = СокрЛП(СтрокаURI);
	
	// схема
	Схема = "";
	Позиция = СтрНайти(СтрокаURI, "://");
	Если Позиция > 0 Тогда
		Схема = НРег(Лев(СтрокаURI, Позиция - 1));
		СтрокаURI = Сред(СтрокаURI, Позиция + 3);
	КонецЕсли;

	// Строка соединения и путь на сервере.
	СтрокаСоединения = СтрокаURI;
	ПутьНаСервере = "";
	Позиция = СтрНайти(СтрокаСоединения, "/");
	Если Позиция > 0 Тогда
		ПутьНаСервере = Сред(СтрокаСоединения, Позиция + 1);
		СтрокаСоединения = Лев(СтрокаСоединения, Позиция - 1);
	КонецЕсли;
		
	// Информация пользователя и имя сервера.
	СтрокаАвторизации = "";
	ИмяСервера = СтрокаСоединения;
	Позиция = СтрНайти(СтрокаСоединения, "@");
	Если Позиция > 0 Тогда
		СтрокаАвторизации = Лев(СтрокаСоединения, Позиция - 1);
		ИмяСервера = Сред(СтрокаСоединения, Позиция + 1);
	КонецЕсли;
	
	// логин и пароль
	Логин = СтрокаАвторизации;
	Пароль = "";
	Позиция = СтрНайти(СтрокаАвторизации, ":");
	Если Позиция > 0 Тогда
		Логин = Лев(СтрокаАвторизации, Позиция - 1);
		Пароль = Сред(СтрокаАвторизации, Позиция + 1);
	КонецЕсли;
	
	// хост и порт
	Хост = ИмяСервера;
	Порт = "";
	Позиция = СтрНайти(ИмяСервера, ":");
	Если Позиция > 0 Тогда
		Хост = Лев(ИмяСервера, Позиция - 1);
		Порт = Сред(ИмяСервера, Позиция + 1);
		Если Не ТолькоЦифрыВСтроке(Порт) Тогда
			Порт = "";
		КонецЕсли;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Схема", Схема);
	Результат.Вставить("Логин", Логин);
	Результат.Вставить("Пароль", Пароль);
	Результат.Вставить("ИмяСервера", ИмяСервера);
	Результат.Вставить("Хост", Хост);
	Результат.Вставить("Порт", ?(ПустаяСтрока(Порт), Неопределено, Число(Порт)));
	Результат.Вставить("ПутьНаСервере", ПутьНаСервере);
	
	Возврат Результат;
	
КонецФункции

// Формирует и выводит сообщение, которое может быть связано с элементом 
// управления формы.
//
//  Параметры
//  ТекстСообщенияПользователю - Строка - текст сообщения.
//  КлючДанных                 - ЛюбаяСсылка - на объект информационной базы.
//                               Ссылка на объект информационной базы, к которому это сообщение относится,
//                               или ключ записи.
//  Поле                       - Строка - наименование реквизита формы.
//  ПутьКДанным                - Строка - путь к данным (путь к реквизиту формы).
//  Отказ                      - Булево - Выходной параметр.
//                               Всегда устанавливается в значение Истина.
//
//	Пример:
//
//	1. Для вывода сообщения у поля управляемой формы, связанного с реквизитом объекта:
//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//		НСтр("ru = 'Сообщение об ошибке.'"), ,
//		"ПолеВРеквизитеФормыОбъект",
//		"Объект");
//
//	Альтернативный вариант использования в форме объекта:
//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//		НСтр("ru = 'Сообщение об ошибке.'"), ,
//		"Объект.ПолеВРеквизитеФормыОбъект");
//
//	2. Для вывода сообщения рядом с полем управляемой формы, связанным с реквизитом формы:
//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//		НСтр("ru = 'Сообщение об ошибке.'"), ,
//		"ИмяРеквизитаФормы");
//
//	3. Для вывода сообщения связанного с объектом информационной базы.
//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//		НСтр("ru = 'Сообщение об ошибке.'"), ОбъектИнформационнойБазы, "Ответственный",,Отказ);
//
// 4. Для вывода сообщения по ссылке на объект информационной базы.
//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//		НСтр("ru = 'Сообщение об ошибке.'"), Ссылка, , , Отказ);
//
// Случаи некорректного использования:
//  1. Передача одновременно параметров КлючДанных и ПутьКДанным.
//  2. Передача в параметре КлючДанных значения типа отличного от допустимых.
//  3. Установка ссылки без установки поля (и/или пути к данным).
//
Процедура СообщитьПользователю(
		Знач ТекстСообщенияПользователю,
		Знач КлючДанных = Неопределено,
		Знач Поле = "",
		Знач ПутьКДанным = "",
		Отказ = Ложь) Экспорт
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщенияПользователю;
	Сообщение.Поле = Поле;
	
	ЭтоОбъект = Ложь;
	
#Если НЕ ТонкийКлиент И НЕ ВебКлиент Тогда
	Если КлючДанных <> Неопределено
	   И XMLТипЗнч(КлючДанных) <> Неопределено Тогда
		ТипЗначенияСтрокой = XMLТипЗнч(КлючДанных).ИмяТипа;
		ЭтоОбъект = СтрНайти(ТипЗначенияСтрокой, "Object.") > 0;
	КонецЕсли;
#КонецЕсли
	
	Если ЭтоОбъект Тогда
		Сообщение.УстановитьДанные(КлючДанных);
	Иначе
		Сообщение.КлючДанных = КлючДанных;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ПутьКДанным) Тогда
		Сообщение.ПутьКДанным = ПутьКДанным;
	КонецЕсли;
		
	Сообщение.Сообщить();
	
	Отказ = Истина;
	
КонецПроцедуры

// Добавить элемент компоновки в контейнер элементов компоновки.
//
// Параметры:
//  ОбластьДобавления - контейнер с элементами и группами отбора, например.
//                  Список.Отбор или группа в отборе.
//  ИмяПоля                 - Строка - имя поля компоновки данных (заполняется всегда).
//  ПравоеЗначение          - произвольный - сравниваемое значение.
//  ВидСравнения            - ВидСравненияКомпоновкиДанных - вид сравнения.
//  Представление           - Строка - представление элемента компоновки данных.
//  Использование           - Булево - использование элемента.
//  РежимОтображения        - РежимОтображенияЭлементаНастройкиКомпоновкиДанных - режим отображения.
//  ИдентификаторПользовательскойНастройки - Строка - см. ОтборКомпоновкиДанных.ИдентификаторПользовательскойНастройки
//                                                    в синтакс-помощнике.
//
Функция ДобавитьЭлементКомпоновки(ОбластьДобавления,
									Знач ИмяПоля,
									Знач ВидСравнения,
									Знач ПравоеЗначение = Неопределено,
									Знач Представление  = Неопределено,
									Знач Использование  = Неопределено,
									знач РежимОтображения = Неопределено,
									знач ИдентификаторПользовательскойНастройки = Неопределено)
	
	Элемент = ОбластьДобавления.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоля);
	Элемент.ВидСравнения = ВидСравнения;
	
	Если РежимОтображения = Неопределено Тогда
		Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	Иначе
		Элемент.РежимОтображения = РежимОтображения;
	КонецЕсли;
	
	Если ПравоеЗначение <> Неопределено Тогда
		Элемент.ПравоеЗначение = ПравоеЗначение;
	КонецЕсли;
	
	Если Представление <> Неопределено Тогда
		Элемент.Представление = Представление;
	КонецЕсли;
	
	Если Использование <> Неопределено Тогда
		Элемент.Использование = Использование;
	КонецЕсли;
	
	// Важно: установка идентификатора должна выполняться
	// в конце настройки элемента, иначе он будет скопирован
	// в пользовательские настройки частично заполненным.
	Если ИдентификаторПользовательскойНастройки <> Неопределено Тогда
		Элемент.ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки;
	ИначеЕсли Элемент.РежимОтображения <> РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
		Элемент.ИдентификаторПользовательскойНастройки = ИмяПоля;
	КонецЕсли;
	
	Возврат Элемент;
	
КонецФункции

// Изменить элемент отбора с заданным именем поля или представлением.
//
// Параметры:
//  ИмяПоля                 - Строка - имя поля компоновки данных (заполняется всегда).
//  Представление           - Строка - представление элемента компоновки данных.
//  ПравоеЗначение          - произвольный - сравниваемое значение.
//  ВидСравнения            - ВидСравненияКомпоновкиДанных - вид сравнения.
//  Использование           - Булево - использование элемента.
//  РежимОтображения        - РежимОтображенияЭлементаНастройкиКомпоновкиДанных - режим отображения.
//
Функция ИзменитьЭлементыОтбора(ОбластьПоиска,
								Знач ИмяПоля = Неопределено,
								Знач Представление = Неопределено,
								Знач ПравоеЗначение = Неопределено,
								Знач ВидСравнения = Неопределено,
								Знач Использование = Неопределено,
								Знач РежимОтображения = Неопределено,
								Знач ИдентификаторПользовательскойНастройки = Неопределено)
	
	Если ЗначениеЗаполнено(ИмяПоля) Тогда
		ЗначениеПоиска = Новый ПолеКомпоновкиДанных(ИмяПоля);
		СпособПоиска = 1;
	Иначе
		СпособПоиска = 2;
		ЗначениеПоиска = Представление;
	КонецЕсли;
	
	МассивЭлементов = Новый Массив;
	
	НайтиРекурсивно(ОбластьПоиска.Элементы, МассивЭлементов, СпособПоиска, ЗначениеПоиска);
	
	Для Каждого Элемент Из МассивЭлементов Цикл
		Если ИмяПоля <> Неопределено Тогда
			Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоля);
		КонецЕсли;
		Если Представление <> Неопределено Тогда
			Элемент.Представление = Представление;
		КонецЕсли;
		Если Использование <> Неопределено Тогда
			Элемент.Использование = Использование;
		КонецЕсли;
		Если ВидСравнения <> Неопределено Тогда
			Элемент.ВидСравнения = ВидСравнения;
		КонецЕсли;
		Если ПравоеЗначение <> Неопределено Тогда
			Элемент.ПравоеЗначение = ПравоеЗначение;
		КонецЕсли;
		Если РежимОтображения <> Неопределено Тогда
			Элемент.РежимОтображения = РежимОтображения;
		КонецЕсли;
		Если ИдентификаторПользовательскойНастройки <> Неопределено Тогда
			Элемент.ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки;
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивЭлементов.Количество();
	
КонецФункции

// Добавить или заменить существующий элемент отбора.
//
// Параметры:
//  ОбластьПоискаДобавления - контейнер с элементами и группами отбора, например.
//                  Список.Отбор или группа в отборе.
//  ИмяПоля                 - Строка - имя поля компоновки данных (заполняется всегда).
//  ПравоеЗначение          - произвольный - сравниваемое значение.
//  ВидСравнения            - ВидСравненияКомпоновкиДанных - вид сравнения.
//  Представление           - Строка - представление элемента компоновки данных.
//  Использование           - Булево - использование элемента.
//  РежимОтображения        - РежимОтображенияЭлементаНастройкиКомпоновкиДанных - режим отображения.
//  ИдентификаторПользовательскойНастройки - Строка - см. ОтборКомпоновкиДанных.ИдентификаторПользовательскойНастройки
//                                                    в синтакс-помощнике.
//
Процедура УстановитьЭлементОтбора(ОбластьПоискаДобавления,
								Знач ИмяПоля,
								Знач ПравоеЗначение = Неопределено,
								Знач ВидСравнения = Неопределено,
								Знач Представление = Неопределено,
								Знач Использование = Неопределено,
								Знач РежимОтображения = Неопределено,
								Знач ИдентификаторПользовательскойНастройки = Неопределено) Экспорт
	
	ЧислоИзмененных = ИзменитьЭлементыОтбора(ОбластьПоискаДобавления, ИмяПоля, Представление,
							ПравоеЗначение, ВидСравнения, Использование, РежимОтображения, ИдентификаторПользовательскойНастройки);
	
	Если ЧислоИзмененных = 0 Тогда
		Если ВидСравнения = Неопределено Тогда
			Если ТипЗнч(ПравоеЗначение) = Тип("Массив")
				Или ТипЗнч(ПравоеЗначение) = Тип("ФиксированныйМассив")
				Или ТипЗнч(ПравоеЗначение) = Тип("СписокЗначений") Тогда
				ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			Иначе
				ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			КонецЕсли;
		КонецЕсли;
		Если РежимОтображения = Неопределено Тогда
			РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		КонецЕсли;
		ДобавитьЭлементКомпоновки(ОбластьПоискаДобавления, ИмяПоля, ВидСравнения,
								ПравоеЗначение, Представление, Использование, РежимОтображения, ИдентификаторПользовательскойНастройки);
	КонецЕсли;
	
КонецПроцедуры

// Добавить или заменить существующий элемент отбора динамического списка.
//
// Параметры:
//   ДинамическийСписок - ДинамическийСписок - Список, в котором требуется установить отбор.
//   ИмяПоля            - Строка - Поле, по которому необходимо установить отбор.
//   ПравоеЗначение     - Произвольный - Значение отбора.
//       Необязательный. Значение по умолчанию: Неопределено.
//       Внимание! Если передать Неопределено, то значение не будет изменено.
//   ВидСравнения  - ВидСравненияКомпоновкиДанных - Условие отбора.
//   Представление - Строка - Представление элемента компоновки данных.
//       Необязательный. Значение по умолчанию: Неопределено.
//       Если указано, то выводится только флажок использования с указанным представлением (значение не выводится).
//       Для очистки (чтобы значение снова выводилось) следует передать пустую строку.
//   Использование - Булево - Флажок использования этого отбора.
//       Необязательный. Значение по умолчанию: Неопределено.
//   РежимОтображения - РежимОтображенияЭлементаНастройкиКомпоновкиДанных - Способ отображения этого отбора
//                                                                          пользователю.
//       * РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ - В группе быстрых настроек над списком.
//       * РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный       - В настройка списка (в подменю Еще).
//       * РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный   - Запретить пользователю менять этот отбор.
//   ИдентификаторПользовательскойНастройки - Строка - Уникальный идентификатор этого отбора.
//       Используется для связи с пользовательскими настройками.
//
// См. также:
//   Одноименные свойства объекта "ЭлементОтбораКомпоновкиДанных" в синтакс-помощнике.
//
Процедура УстановитьЭлементОтбораДинамическогоСписка(ДинамическийСписок, ИмяПоля,
	ПравоеЗначение = Неопределено,
	ВидСравнения = Неопределено,
	Представление = Неопределено,
	Использование = Неопределено,
	РежимОтображения = Неопределено,
	ИдентификаторПользовательскойНастройки = Неопределено) Экспорт
	
	Если РежимОтображения = Неопределено Тогда
		РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	КонецЕсли;
	
	Если РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
		ОтборДинамическогоСписка = ДинамическийСписок.КомпоновщикНастроек.ФиксированныеНастройки.Отбор;
	Иначе
		ОтборДинамическогоСписка = ДинамическийСписок.КомпоновщикНастроек.Настройки.Отбор;
	КонецЕсли;
	
	УстановитьЭлементОтбора(
		ОтборДинамическогоСписка,
		ИмяПоля,
		ПравоеЗначение,
		ВидСравнения,
		Представление,
		Использование,
		РежимОтображения,
		ИдентификаторПользовательскойНастройки);
	
КонецПроцедуры

Процедура НайтиРекурсивно(КоллекцияЭлементов, МассивЭлементов, СпособПоиска, ЗначениеПоиска)
	
	Для каждого ЭлементОтбора Из КоллекцияЭлементов Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			
			Если СпособПоиска = 1 Тогда
				Если ЭлементОтбора.ЛевоеЗначение = ЗначениеПоиска Тогда
					МассивЭлементов.Добавить(ЭлементОтбора);
				КонецЕсли;
			ИначеЕсли СпособПоиска = 2 Тогда
				Если ЭлементОтбора.Представление = ЗначениеПоиска Тогда
					МассивЭлементов.Добавить(ЭлементОтбора);
				КонецЕсли;
			КонецЕсли;
		Иначе
			
			НайтиРекурсивно(ЭлементОтбора.Элементы, МассивЭлементов, СпособПоиска, ЗначениеПоиска);
			
			Если СпособПоиска = 2 И ЭлементОтбора.Представление = ЗначениеПоиска Тогда
				МассивЭлементов.Добавить(ЭлементОтбора);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СтроковыеФункцииКлиентСерверКопия

// Проверяет, содержит ли строка только цифры.
//
// Параметры:
//  СтрокаПроверки          - Строка - Строка для проверки.
//  УчитыватьЛидирующиеНули - Булево - Флаг учета лидирующих нулей, если Истина, то ведущие нули пропускаются.
//  УчитыватьПробелы        - Булево - Флаг учета пробелов, если Истина, то пробелы при проверке игнорируются.
//
// Возвращаемое значение:
//   Булево - Истина - строка содержит только цифры или пустая, Ложь - строка содержит иные символы.
//
Функция ТолькоЦифрыВСтроке(Знач СтрокаПроверки, Знач УчитыватьЛидирующиеНули = Истина, Знач УчитыватьПробелы = Истина)
	
	Если ТипЗнч(СтрокаПроверки) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не УчитыватьПробелы Тогда
		СтрокаПроверки = СтрЗаменить(СтрокаПроверки, " ", "");
	КонецЕсли;
		
	Если ПустаяСтрока(СтрокаПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если Не УчитыватьЛидирующиеНули Тогда
		Позиция = 1;
		// Взятие символа за границей строки возвращает пустую строку.
		Пока Сред(СтрокаПроверки, Позиция, 1) = "0" Цикл
			Позиция = Позиция + 1;
		КонецЦикла;
		СтрокаПроверки = Сред(СтрокаПроверки, Позиция);
	КонецЕсли;
	
	// Если содержит только цифры, то в результате замен должна быть получена пустая строка.
	// Проверять при помощи ПустаяСтрока нельзя, так как в исходной строке могут быть пробельные символы.
	Возврат СтрДлина(
		СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить(
		СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( 
			СтрокаПроверки, "0", ""), "1", ""), "2", ""), "3", ""), "4", ""), "5", ""), "6", ""), "7", ""), "8", ""), "9", "")) = 0;
	
КонецФункции

// Проверяет, содержит ли строка только символы кириллического алфавита.
//
// Параметры:
//  УчитыватьРазделителиСлов - Булево - учитывать ли разделители слов или они являются исключением.
//  ДопустимыеСимволы - строка для проверки.
//
// Возвращаемое значение:
//  Булево - Истина, если строка содержит только кириллические (или допустимые) символы или пустая;
//           Ложь, если строка содержит иные символы.
//
Функция ТолькоКириллицаВСтроке(Знач СтрокаПроверки, Знач УчитыватьРазделителиСлов = Истина, ДопустимыеСимволы = "") Экспорт
	
	Если ТипЗнч(СтрокаПроверки) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтрокаПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	КодыДопустимыхСимволов = Новый Массив;
	КодыДопустимыхСимволов.Добавить(1105); // "ё"
	КодыДопустимыхСимволов.Добавить(1025); // "Ё"
	
	Для Индекс = 1 По СтрДлина(ДопустимыеСимволы) Цикл
		КодыДопустимыхСимволов.Добавить(КодСимвола(Сред(ДопустимыеСимволы, Индекс, 1)));
	КонецЦикла;
	
	Для Индекс = 1 По СтрДлина(СтрокаПроверки) Цикл
		КодСимвола = КодСимвола(Сред(СтрокаПроверки, Индекс, 1));
		Если ((КодСимвола < 1040) Или (КодСимвола > 1103)) 
			И (КодыДопустимыхСимволов.Найти(КодСимвола) = Неопределено) 
			И Не (Не УчитыватьРазделителиСлов И ЭтоРазделительСлов(КодСимвола)) Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Проверяет, содержит ли строка только символы латинского алфавита.
//
// Параметры:
//  УчитыватьРазделителиСлов - Булево - учитывать ли разделители слов или они являются исключением.
//  ДопустимыеСимволы - строка для проверки.
//
// Возвращаемое значение:
//  Булево - Истина, если строка содержит только латинские (или допустимые) символы;
//         - Ложь, если строка содержит иные символы.
//
Функция ТолькоЛатиницаВСтроке(Знач СтрокаПроверки, Знач УчитыватьРазделителиСлов = Истина, ДопустимыеСимволы = "") Экспорт
	
	Если ТипЗнч(СтрокаПроверки) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтрокаПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	КодыДопустимыхСимволов = Новый Массив;
	
	Для Индекс = 1 По СтрДлина(ДопустимыеСимволы) Цикл
		КодыДопустимыхСимволов.Добавить(КодСимвола(Сред(ДопустимыеСимволы, Индекс, 1)));
	КонецЦикла;
	
	Для Индекс = 1 По СтрДлина(СтрокаПроверки) Цикл
		КодСимвола = КодСимвола(Сред(СтрокаПроверки, Индекс, 1));
		Если ((КодСимвола < 65) Или (КодСимвола > 90 И КодСимвола < 97) Или (КодСимвола > 122))
			И (КодыДопустимыхСимволов.Найти(КодСимвола) = Неопределено) 
			И Не (Не УчитыватьРазделителиСлов И ЭтоРазделительСлов(КодСимвола)) Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Определяет, является ли символ разделителем.
//
// Параметры:
//  КодСимвола      - Число  - код проверяемого символа;
//  РазделителиСлов - Строка - символы разделителей.
//
// Возвращаемое значение:
//  Булево - истина, если символ является разделителем.
//
Функция ЭтоРазделительСлов(КодСимвола, РазделителиСлов = Неопределено)
	
	Если РазделителиСлов <> Неопределено Тогда
		Возврат СтрНайти(РазделителиСлов, Символ(КодСимвола)) > 0;
	КонецЕсли;
		
	Диапазоны = Новый Массив;
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 48, 57)); 		// цифры
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 65, 90)); 		// латиница большие
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 97, 122)); 		// латиница маленькие
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 1040, 1103)); 	// кириллица
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 1025, 1025)); 	// символ "Ё"
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 1105, 1105)); 	// символ "ё"
	Диапазоны.Добавить(Новый Структура("Мин,Макс", 95, 95)); 		// символ "_"
	
	Для Каждого Диапазон Из Диапазоны Цикл
		Если КодСимвола >= Диапазон.Мин И КодСимвола <= Диапазон.Макс Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецОбласти
