#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Запись Из ЭтотОбъект Цикл	
		Запись.ПредставлениеИсточника = ОбщегоНазначения.ПредметСтрокой(Запись.Источник);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#КонецЕсли