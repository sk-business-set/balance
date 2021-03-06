#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	ФорматДаты = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	
	СрокИсполнения = СхемаКомпоновкиДанных.НаборыДанных[0].Поля.Найти("СрокИсполнения");
	СрокИсполнения.Оформление.УстановитьЗначениеПараметра("Формат", ФорматДаты);
	
	ДатаИсполнения = СхемаКомпоновкиДанных.НаборыДанных[0].Поля.Найти("ДатаИсполнения");
	ДатаИсполнения.Оформление.УстановитьЗначениеПараметра("Формат", ФорматДаты);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли