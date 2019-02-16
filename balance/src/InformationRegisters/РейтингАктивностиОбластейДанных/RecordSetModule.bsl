#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	// Проверка значения свойства ОбменДанными.Загрузка отсутствует по причине того, что ограничения,
	// накладываемые данным кодом, не должны обходить установкой этого свойства равным Истина
	// (на стороне кода, который выполняет попытку записи в данный регистр).
	//
	// Данный регистр не должен входить в любые обмены или операции выгрузки / загрузки данных при включенном
	// разделении по областям данных.
	
	Если Не ОбщегоНазначенияПовтИсп.СеансЗапущенБезРазделителей() Тогда
		
		ВызватьИсключение НСтр("ru = 'Нарушение прав доступа!'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли