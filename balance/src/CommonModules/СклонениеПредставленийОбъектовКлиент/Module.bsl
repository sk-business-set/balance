
////////////////////////////////////////////////////////////////////////////////
// Подсистема "СклоненияПредставленийОбъектов".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик события ПриИзменении элемента формы, подлежащего склонению.
// 
// Параметры:
// 	Форма - Управляемая форма - форма, содержащая элемент, подлежащий склонению.
//
Процедура ПриИзмененииПредставления(Форма) Экспорт
	
	Форма.ИзмененоПредставление = Истина;
	Форма.ПодключитьОбработчикОжидания("Подключаемый_ПросклонятьПредставлениеПоВсемПадежам", 2, Истина);
		
КонецПроцедуры

// Склоняет переданную фразу по всем падежам.
//
// Параметры:
//  Форма 			- Управляемая форма - форма объекта склонения.
//  Представление   - Строка - Строка для склонения.
//  ЭтоФИО       	- Булево - Признак склонения ФИО.
//	Пол				- Число	- Пол физического лица (в случае склонения ФИО)
//							1 - мужской 
//							2 - женский.
//  ПоказыватьСообщения - Булево - Признак, определяющий нужно ли показывать пользователю сообщения об ошибках.
//
Процедура ПросклонятьПредставлениеПоВсемПадежам(Форма, Представление, ЭтоФИО = Ложь, Пол = Неопределено, ПоказыватьСообщения = Ложь) Экспорт

	Если Форма.ИзмененоПредставление Или Форма.Склонения = Неопределено Тогда
		СклонениеПредставленийОбъектовВызовСервера.ПросклонятьПредставлениеПоВсемПадежам(Представление, Форма.Склонения, ЭтоФИО, Пол, ПоказыватьСообщения);
		Форма.ИзмененоПредставление = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик команды "Склонения" формы объекта склонения.
//
// Параметры:
//  Форма 			- Управляемая форма - форма объекта склонения.
//  Представление   - Строка - Строка для склонения.
//  ЭтоФИО       	- Булево - Признак склонения ФИО.
//	Пол				- Число	- Пол физического лица (в случае склонения ФИО)
//							1 - мужской 
//							2 - женский.
//
Процедура ОбработатьКомандуСклонения(Форма, Представление, ЭтоФИО = Ложь, Пол = Неопределено) Экспорт
			
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);

	Оповещение = Новый ОписаниеОповещения("ОткрытьФормуСклоненияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Склонения", Форма.Склонения);
	СтруктураПараметров.Вставить("ЭтоФИО", ЭтоФИО);
	СтруктураПараметров.Вставить("Пол", Пол);
	СтруктураПараметров.Вставить("Представление", Представление);
	СтруктураПараметров.Вставить("ИзмененоПредставление", Форма.ИзмененоПредставление);
		
	ОткрытьФорму("ОбщаяФорма.Склонения", СтруктураПараметров, Форма, , , , Оповещение);
	
	Форма.ОтключитьОбработчикОжидания("Подключаемый_ПросклонятьПредставлениеПоВсемПадежам");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Завершение процедуры ОбработатьКомандуСклонения.
//
Процедура ОткрытьФормуСклоненияЗавершение(РезультатРедактирования, ДополнительныеПараметры) Экспорт

	Форма = ДополнительныеПараметры.Форма;
	Если РезультатРедактирования <> Неопределено Тогда
		
		Форма.Склонения = Новый ФиксированнаяСтруктура(РезультатРедактирования);
		Форма.Модифицированность = Истина;
		Форма.ИзмененоПредставление = Ложь;
		
	КонецЕсли;	

КонецПроцедуры

#КонецОбласти