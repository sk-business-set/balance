
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	 Если Параметры.Ключ.Пустая() Тогда
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
		Объект.ПодразделениеОткуда = ПараметрыСеанса.ПодразделениеПользователя;
		Объект.ПодразделениеКуда = ПараметрыСеанса.ПодразделениеПользователя;
	КонецЕсли;
	Валюты=Константы.МультивалютныйУчет.Получить();	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Если ПараметрыЗаписи.РежимЗаписи=РежимЗаписиДокумента.Проведение тогда
		Оповестить("ДобавленоДвижение",Объект.Дата);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДвиженияОткудаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//СтандартнаяОбработка = Ложь;
	//ФормаВыбораСтатей(Элемент, ДанныеВыбора,, Объект.ПодразделениеОткуда);
	////ФормаВыбораНужныхСтатей.Открыть();
	СтандартнаяОбработка = Ложь;
	ПараметрыВ = Новый Структура();
	ПараметрыВ.Вставить("НашиСтатьи",Истина);//Элемент.ТекущиеДанные.Подразделение);
	Форма = ПолучитьФорму("Справочник.СтатьиДвижения.ФормаВыбора",ПараметрыВ);
	Форма.Открыть();

КонецПроцедуры

&НаКлиенте
Процедура СтатьяДвиженияКудаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//СтандартнаяОбработка = Ложь;
	//ФормаВыбораСтатей(Элемент, ДанныеВыбора, Объект.ПодразделениеКуда);
	//ФормаВыбораНужныхСтатей.Открыть();
	СтандартнаяОбработка = Ложь;
	ПараметрыВ = Новый Структура();
	ПараметрыВ.Вставить("НашиСтатьи",Истина);//Элемент.ТекущиеДанные.Подразделение);
	Форма = ПолучитьФорму("Справочник.СтатьиДвижения.ФормаВыбора",ПараметрыВ);
	Форма.Открыть();

КонецПроцедуры

&НаКлиенте
Процедура ФормаВыбораСтатей(Элемент, ДанныеВыбора, НужноеПодразделение)
	ФормаВыбора = ПолучитьФорму("Справочник.СтатьиДвижения.ФормаВыбора",,Элемент);
	//Если ЗначениеЗаполнено(НужноеПодразделение) Тогда
	//	Список = ФормаВыбора.Список;
	//    ЭлементОформления = Список.УсловноеОформление.Элементы.Добавить();
	//    ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	//    ЭлементОформления = Список.УсловноеОформление.Элементы.Добавить();
	//    ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Истина );
	//    ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Отображать",Истина );
	//    
	//	ГруппаОтбора = Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных")); 
	//	ГруппаОтбора.Использование = Истина; 
	//	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли; 
	//	ГруппаОтбора.Представление = "Отбор по подразделению";

	//    ОтборПоГруппе = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//    ОтборПоГруппе.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подразделение");
	//    ОтборПоГруппе.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
	//    ОтборПоГруппе.ПравоеЗначение = НужноеПодразделение;
	//    ОтборПоГруппе = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//    ОтборПоГруппе.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подразделение");
	//    ОтборПоГруппе.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	//    ОтборПоГруппе.ПравоеЗначение = РаботаСДаннымиСервер.ПустаяСсылкаСправочника("Подразделения");
	//КонецЕсли;
	ФормаВыбора.Открыть();
КонецПроцедуры	


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Валюты тогда
		Если ЗначениеЗаполнено(Объект.СтатьяДвиженияОткуда) И НЕ ЗначениеЗаполнено(Объект.Курс) тогда
			РассчитатьРуб();
		КонецЕсли;
		ОбновитьСуммаКурс();
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОбменныйКурс(текДата,текОткуда,текКуда)
	ОткудаКурс=РаботаСВалютой.ПолучитьКурс(текДата,текОткуда.Валюта).Курс;
	КудаКурс=РаботаСВалютой.ПолучитьКурс(текДата,текКуда.Валюта).Курс;
	Возврат Окр(ОткудаКурс/КудаКурс,4);
КонецФункции

&НаСервере
Процедура РассчитатьРуб(ОбратныйРасчет=Ложь)
	Если ОбратныйРасчет тогда
		текКурс=РаботаСВалютой.ПолучитьКурс(Объект.Дата,ПолучитьВалюту(Объект.СтатьяДвиженияКуда));
		//Объект.Курс=текКурс.Курс;
		Объект.СуммаРуб=Окр(Объект.СуммаКуда/текКурс.Кратность*текКурс.Курс,2);
	Иначе
		текКурс=РаботаСВалютой.ПолучитьКурс(Объект.Дата,ПолучитьВалюту(Объект.СтатьяДвиженияОткуда));
		Объект.Курс=текКурс.Курс;
		Объект.СуммаРуб=Окр(Объект.Сумма/текКурс.Кратность*Объект.Курс,2);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция РассчитатьВалюта(текСтатья,вхКурс=0)
	Если вхКурс=0 тогда
		текКурс=РаботаСВалютой.ПолучитьКурс(Объект.Дата,ПолучитьВалюту(текСтатья));
		текСумма=Объект.СуммаРуб/текКурс.Курс*текКурс.Кратность;
	Иначе
		текСумма=Объект.СуммаРуб/вхКурс;
	КонецЕсли;
	Возврат текСумма;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьВалюту(текСтатья)
	Если текСтатья.Валюта.Пустая() тогда
		текВалюта=Константы.ОсновнаяВалюта.Получить();
		Если текВалюта.Пустая() тогда
			текВалюта=РаботаСВалютой.ПолучитьВалютуПоКоду("643");
		КонецЕсли;
		Возврат текВалюта;
	Иначе
		Возврат текСтатья.Валюта;
	КонецЕсли;
КонецФункции

&НаСервере
Процедура ОбновитьСуммаКурс(ОбновитьКуда=Ложь)
	Элементы.Сумма.Заголовок="Сумма, "+ПолучитьВалюту(Объект.СтатьяДвиженияОткуда).Наименование;
	Если ПолучитьВалюту(Объект.СтатьяДвиженияОткуда)=ПолучитьВалюту(Объект.СтатьяДвиженияКуда) тогда
		Элементы.ГруппаСуммаКурс.Видимость=ЛОЖЬ;
	ИначеЕсли Валюты тогда
		Элементы.ГруппаСуммаКурс.Видимость=Истина;
		Элементы.НадписьСумма.Заголовок="Сумма, "+ПолучитьВалюту(Объект.СтатьяДвиженияКуда).Наименование;
		Если ОбновитьКуда ИЛИ НЕ ЗначениеЗаполнено(Объект.СуммаКуда) тогда
			Объект.СуммаКуда=РассчитатьВалюта(Объект.СтатьяДвиженияКуда,Объект.КурсКуда);
		КонецЕсли;
		//Если ОбновитьКурс тогда
		//	НадписьКурс=ПолучитьОбменныйКурс(Объект.Дата,Объект.СтатьяДвиженияОткуда,Объект.СтатьяДвиженияКуда);
		//КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДвиженияОткудаПриИзменении(Элемент)
	Если Валюты тогда
		РассчитатьРуб();
		ОбновитьСуммаКурс(Истина);
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	Если Валюты тогда
		РассчитатьРуб();
		НадписьКурс=Неопределено;
		ПересчетПриИзменении(Элементы.Сумма);
		//ОбновитьСуммаКурс();
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	Если Валюты тогда
		ПересчетПриИзменении(Элемент);
		РассчитатьРуб();
		//ОбновитьСуммаКурс();
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура СтатьяДвиженияКудаПриИзменении(Элемент)
	Если Валюты тогда
		ОбновитьСуммаКурс();
		НадписьКурс=Неопределено;
		ПересчетПриИзменении(Элементы.Сумма);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПересчетПриИзменении(текЭлемент)
	Если текЭлемент=Элементы.Сумма И НЕ ЗначениеЗаполнено(НадписьКурс) тогда
		НадписьКурс=ПолучитьОбменныйКурс(Объект.Дата,Объект.СтатьяДвиженияОткуда,Объект.СтатьяДвиженияКуда);
		Объект.СуммаКуда=Объект.Сумма*НадписьКурс;
	ИначеЕсли текЭлемент=Элементы.Сумма И ЗначениеЗаполнено(НадписьКурс) тогда
		Объект.СуммаКуда=Объект.Сумма*НадписьКурс;
	ИначеЕсли текЭлемент=Элементы.НадписьКурс тогда
		Объект.СуммаКуда=Объект.Сумма*НадписьКурс;
	ИначеЕсли текЭлемент=Элементы.НадписьСумма тогда
		Объект.Сумма=Объект.СуммаКуда/НадписьКурс;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НадписьКурсПриИзменении(Элемент)
	Если Валюты тогда
		ПересчетПриИзменении(Элемент);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НадписьСуммаПриИзменении(Элемент)
	Если Валюты тогда
		ПересчетПриИзменении(Элемент);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если НЕ Валюты тогда
		Объект.СуммаРуб=Объект.Сумма;
		Объект.СуммаКуда=Объект.Сумма;
		Объект.Курс=1.0;
		Объект.КурсКуда=1.0;
	Иначе
		Если ПолучитьВалюту(объект.СтатьяДвиженияОткуда).Наименование="RUB" И ПолучитьВалюту(объект.СтатьяДвиженияОткуда).Наименование="RUB" тогда
			Объект.СуммаРуб=Объект.Сумма;
			Объект.СуммаКуда=Объект.Сумма;
			Объект.Курс=1.0;
			Объект.КурсКуда=1.0;
		ИначеЕсли ПолучитьВалюту(объект.СтатьяДвиженияОткуда)=ПолучитьВалюту(объект.СтатьяДвиженияОткуда) тогда
			Объект.СуммаКуда=Объект.Сумма;
			Объект.КурсКуда=Объект.Курс;
		ИначеЕсли ПолучитьВалюту(объект.СтатьяДвиженияОткуда).Наименование="RUB" тогда
			Объект.СуммаРуб=Объект.Сумма;
			Объект.Курс=1.0;
			Объект.КурсКуда=Объект.СуммаРуб/Объект.СуммаКуда;
		ИначеЕсли ПолучитьВалюту(объект.СтатьяДвиженияКуда).Наименование="RUB" тогда
			Объект.СуммаРуб=Объект.СуммаКуда;
			Объект.Курс=НадписьКурс;
			Объект.КурсКуда=1.0;
		Иначе
			Объект.КурсКуда=Объект.СуммаРуб/Объект.СуммаКуда;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПодразделениеОткудаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	//СтандартнаяОбработка = Ложь;
	//ПараметрыВ = Новый Структура();
	// ПараметрыВ.Вставить("НашеПодразделение",Истина);//Элемент.ТекущиеДанные.Подразделение);
	//Форма = ПолучитьФорму("Справочник.Подразделения.ФормаВыбора",ПараметрыВ);
	//Форма.Открыть();

КонецПроцедуры


