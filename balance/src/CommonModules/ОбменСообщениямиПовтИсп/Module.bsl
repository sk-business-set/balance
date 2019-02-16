////////////////////////////////////////////////////////////////////////////////
// ОбменСообщениямиПовтИсп: механизм обмена сообщениями.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает ссылку на объект WSПрокси для заданного узла обмена.
//
// Параметры:
// КонечнаяТочка - ПланОбменаСсылка.
//
Функция WSПроксиКонечнойТочки(КонечнаяТочка, Таймаут) Экспорт
	
	СтруктураНастроек = РегистрыСведений.НастройкиТранспортаОбмена.НастройкиТранспортаWS(КонечнаяТочка);
	
	СтрокаСообщенияОбОшибке = "";
	
	Результат = ОбменСообщениямиВнутренний.ПолучитьWSПрокси(СтруктураНастроек, СтрокаСообщенияОбОшибке, Таймаут);
	
	Если Результат = Неопределено Тогда
		ВызватьИсключение СтрокаСообщенияОбОшибке;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Возвращает массив менеджеров справочников, которые могут использоваться для хранения
// сообщений.
//
Функция ПолучитьСправочникиСообщений() Экспорт
	
	МассивСправочников = Новый Массив();
	
	Если ОбщегоНазначенияПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
		МодульСообщенияВМоделиСервисаРазделениеДанных = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервисаРазделениеДанных");
		МодульСообщенияВМоделиСервисаРазделениеДанных.ПриЗаполненииСправочниковСообщений(МассивСправочников);
	КонецЕсли;
	
	МассивСправочников.Добавить(Справочники.СообщенияСистемы);
	
	Возврат МассивСправочников;
	
КонецФункции

#КонецОбласти
