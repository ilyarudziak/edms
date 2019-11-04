﻿#Область СлужебныйПрограммныйИнтерфейс

// Получает полную роль делопроизводителя подразделения, осуществляющего делопроизводство по документу.
//
// Параметры:
//  Документ - СправочникСсылка	 - ссылка на документ
// 
// Возвращаемое значение:
//  СправочникСсылка.ПолныеРоли - .
//
Функция ПолучитьДелопроизводителяПодразделенияДокумента(Знач Документ) Экспорт
	// TODO: в дальнейшем - Справочники.РолиИсполнителей.ДелопроизводительПодразделения;
	Роль = Справочники.РолиИсполнителей.НайтиСоздатьРоль_ДелопроизводительПодразделения();
	Возврат ПолучитьПолнуюРольСОбъектамиАдресацииПоДокументу(Роль, Документ);
КонецФункции

// Получает полную роль регистратора переписки подразделения.
// По данным адресата документа определяет его подразделение.
// Затем проверяет наличие исполнителей роли "Регистратор переписки" для этого подразделения.
// Если не находит такой полной роли или её исполнителей, тогда переходит
// к вышестоящему подразделению. И так - до самого верха.
// Если не находит и для подразделения верхнего уровня - генерирует исключение.
//
// Параметры:
//  Документ - СправочникСсылка	 - ссылка на документ
// 
// Возвращаемое значение:
//  СправочникСсылка.ПолныеРоли - .
//
Функция ПолучитьРегистратораПерепискиАдресата(Знач Документ) Экспорт
	// TODO: в дальнейшем - Справочники.РолиИсполнителей.РегистраторПерепискиПодразделения;
	Роль = Справочники.РолиИсполнителей.НайтиСоздатьРоль_РегистраторПерепискиПодразделения();
	Возврат ПолучитьПолнуюРольСОбъектамиАдресацииПоАдресатуДокументу(Роль, Документ);
КонецФункции

// Получает полную роль регистратора переписки подразделения, указанного в карточке исходящего документа.
// Затем проверяет наличие исполнителей роли "Регистратор переписки" для этого подразделения.
// Если не находит такой полной роли или её исполнителей, тогда переходит
// к вышестоящему подразделению. И так - до самого верха.
// Если не находит и для подразделения верхнего уровня - генерирует исключение.
//
// Параметры:
//  Документ - СправочникСсылка	 - ссылка на документ
// 
// Возвращаемое значение:
//  СправочникСсылка.ПолныеРоли - .
//
Функция ПолучитьРегистратораПерепискиОтправителя(Знач Документ) Экспорт
	// TODO: в дальнейшем - Справочники.РолиИсполнителей.РегистраторПерепискиПодразделения;
	Роль = Справочники.РолиИсполнителей.НайтиСоздатьРоль_РегистраторПерепискиПодразделения();
	Возврат ПолучитьПолнуюРольСОбъектамиАдресацииПоДокументу(Роль, Документ);
КонецФункции

// Получает полную роль руководителя подразделения, осуществляющего делопроизводство по документу.
//
// Параметры:
//  Документ - СправочникСсылка	 - ссылка на документ
// 
// Возвращаемое значение:
//  СправочникСсылка.ПолныеРоли, СправочникСсылка.Пользователи - 
//
Функция ПолучитьРуководителяПодразделенияДокумента(Знач Документ) Экспорт
	
	// TODO: в дальнейшем - Справочники.РолиИсполнителей.РуководительПодразделения;
	Роль = Справочники.РолиИсполнителей.НайтиСоздатьРоль_РуководительПодразделения();
	ПолнаяРольРуководителяПодразделения = ПолучитьПолнуюРольСОбъектамиАдресацииПоДокументу(Роль, Документ);
	
	Если БизнесПроцессыИЗадачиСервер.ЕстьИсполнителиРоли(ПолнаяРольРуководителяПодразделения) Тогда
		Возврат ПолнаяРольРуководителяПодразделения;
	Иначе
		Руководитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "Подразделение.Руководитель");
		Возврат Руководитель;
	КонецЕсли;

КонецФункции

// Получает массив исполнителей всех незавершённых задач по документу для процессов исполнения,
//  рассмотрения, ознакомления.
//
// Параметры:
//  Документ - СправочникСсылка	 - ссылка на документ
// 
// Возвращаемое значение:
//  Массив - массив исполнителей
//
Функция ПолучитьИсполнителейДокументаАктивных(Знач Документ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗадачаИсполнителя.Ссылка КАК Ссылка,
		|	ЗадачаИсполнителя.ТекущийИсполнитель КАК ТекущийИсполнитель
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|		ЛЕВОЕ СОЕДИНЕНИЕ Задача.ЗадачаИсполнителя.Предметы КАК ЗадачаИсполнителяПредметы
		|		ПО ЗадачаИсполнителя.Ссылка = ЗадачаИсполнителяПредметы.Ссылка
		|ГДЕ
		|	ЗадачаИсполнителя.Выполнена = ЛОЖЬ
		|	И ЗадачаИсполнителя.ПометкаУдаления = ЛОЖЬ
		|	И (
		|		(ЗадачаИсполнителя.БизнесПроцесс ссылка БизнесПроцесс.Исполнение)
		|		ИЛИ (ЗадачаИсполнителя.БизнесПроцесс ссылка БизнесПроцесс.Ознакомление)
		|		ИЛИ (ЗадачаИсполнителя.БизнесПроцесс ссылка БизнесПроцесс.Рассмотрение)
		|	)
		|	И ЗадачаИсполнителя.СостояниеБизнесПроцесса <> ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Прерван)
		|	И ЗадачаИсполнителя.ТекущийИсполнитель <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
		|	И ЗадачаИсполнителя.ТекущийИсполнитель <> ЗНАЧЕНИЕ(Справочник.ПолныеРоли.ПустаяСсылка)
		|	И ЗадачаИсполнителя.ТекущийИсполнитель <> НЕОПРЕДЕЛЕНО
		|	И ЗадачаИсполнителяПредметы.РольПредмета = ЗНАЧЕНИЕ(Перечисление.РолиПредметов.Основной)
		|	И ЗадачаИсполнителя.Предметы.Предмет = &Предмет";
		
	Запрос.УстановитьПараметр("Предмет", Документ);
	
	Выборка = Запрос.Выполнить();
	АктивныеИсполнители = Выборка.Выгрузить().ВыгрузитьКолонку("ТекущийИсполнитель");
	
	Возврат АктивныеИсполнители;
		
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_АвтоПодстановкиДляПроцессов

// Получает полную роль делопроизводителя подразделения, осуществляющего делопроизводство по документу.
//
// Параметры:
//  БизнесПроцессОбъект	 - БизнесПроцессОбъект.<Тип бизнес процесса> - процесс, для которого
//  							вычисляется автоподстановка
//  ИмяПредмета			 - СправочникСсылка.ИменаПредметов	 - имя предмета в процессе
// 
// Возвращаемое значение:
//  СправочникСсылка.ПолныеРоли - .
//
Функция ДелопроизводительПодразделенияДокумента(Знач БизнесПроцессОбъект, Знач ИмяПредмета) Экспорт
	ДокументСсылка = ПолучитьДокументИзПредметаПроцесса(БизнесПроцессОбъект, ИмяПредмета);
	ПолнаяРольДелопроизводителя = ПолучитьДелопроизводителяПодразделенияДокумента(ДокументСсылка);
	Возврат ПолнаяРольДелопроизводителя;
КонецФункции

// Получает полную роль регистратора переписки подразделения.
// По данным адресата документа определяет его подразделение.
// Затем проверяет наличие исполнителей роли "Регистратор переписки" для этого подразделения.
// Если не находит такой полной роли или её исполнителей, тогда переходит
// к вышестоящему подразделению. И так - до самого верха.
// Если не находит и для подразделения верхнего уровня - генерирует исключение.
//
// Параметры:
//  БизнесПроцессОбъект	 - БизнесПроцессОбъект.<Тип бизнес процесса> - процесс, для которого
//  							вычисляется автоподстановка
//  ИмяПредмета			 - СправочникСсылка.ИменаПредметов	 - имя предмета в процессе
// 
// Возвращаемое значение:
//  СправочникСсылка.ПолныеРоли - .
//
Функция РегистраторПерепискиАдресата(Знач БизнесПроцессОбъект, Знач ИмяПредмета) Экспорт
	ДокументСсылка = ПолучитьДокументИзПредметаПроцесса(БизнесПроцессОбъект, ИмяПредмета);
	ПолнаяРольРегистратора = ПолучитьРегистратораПерепискиАдресата(ДокументСсылка);
	Возврат ПолнаяРольРегистратора;
КонецФункции

// Получает полную роль регистратора переписки подразделения.
// Подразделение - указанное в карточке исходящего документа.
// Проверяет наличие исполнителей роли "Регистратор переписки" для этого подразделения.
// Если не находит такой полной роли или её исполнителей, тогда переходит
// к вышестоящему подразделению. И так - до самого верха.
// Если не находит и для подразделения верхнего уровня - генерирует исключение.
//
// Параметры:
//  БизнесПроцессОбъект	 - БизнесПроцессОбъект.<Тип бизнес процесса> - процесс, для которого
//  							вычисляется автоподстановка
//  ИмяПредмета			 - СправочникСсылка.ИменаПредметов	 - имя предмета в процессе
// 
// Возвращаемое значение:
//  СправочникСсылка.ПолныеРоли - .
//
Функция РегистраторПерепискиОтправителя(Знач БизнесПроцессОбъект, Знач ИмяПредмета) Экспорт
	ДокументСсылка = ПолучитьДокументИзПредметаПроцесса(БизнесПроцессОбъект, ИмяПредмета);
	ПолнаяРольРегистратора = ПолучитьРегистратораПерепискиОтправителя(ДокументСсылка);
	Возврат ПолнаяРольРегистратора;
КонецФункции

// Получает полную роль руководителя подразделения, осуществляющего делопроизводство по документу.
//
// Параметры:
//  БизнесПроцессОбъект	 - БизнесПроцессОбъект.<Тип бизнес процесса> - процесс, для которого
//  							вычисляется автоподстановка
//  ИмяПредмета			 - СправочникСсылка.ИменаПредметов	 - имя предмета в процессе
// 
// Возвращаемое значение:
//  СправочникСсылка.ПолныеРоли, СправочникСсылка.Пользователи - 
//
Функция РуководительПодразделенияДокумента(Знач БизнесПроцессОбъект, Знач ИмяПредмета) Экспорт
	ДокументСсылка = ПолучитьДокументИзПредметаПроцесса(БизнесПроцессОбъект, ИмяПредмета);
	РуководительПодразделения = ПолучитьРуководителяПодразделенияДокумента(ДокументСсылка);
	Возврат РуководительПодразделения;
КонецФункции

// Получает массив исполнителей всех незавершённых задач по документу для процессов исполнения,
//  рассмотрения, ознакомления.
//
// Параметры:
//  БизнесПроцессОбъект	 - БизнесПроцессОбъект.<Тип бизнес процесса> - процесс, для которого
//  							вычисляется автоподстановка
//  ИмяПредмета			 - СправочникСсылка.ИменаПредметов	 - имя предмета в процессе
// 
// Возвращаемое значение:
//  Массив - массив исполнителей
//
Функция ИсполнителиДокументаАктивные(Знач БизнесПроцессОбъект, Знач ИмяПредмета) Экспорт
	ДокументСсылка = ПолучитьДокументИзПредметаПроцесса(БизнесПроцессОбъект, ИмяПредмета);
	АктивныеИсполнители = ПолучитьИсполнителейДокументаАктивных(ДокументСсылка);
	Возврат АктивныеИсполнители;
КонецФункции

// Возвращает всех руководителей метрологических подразделений.
// Отбор метрологических подразделений осуществляется по дополнительному реквизиту
// "Направление деятельности", по значению "Метрология".
//
// Параметры:
//   БизнесПроцессОбъект - БизнесПроцессОбъект.<Тип бизнес процесса> - процесс, для которого
//                         вычисляется автоподстановка
//
// Возвращаемое значение:
//   Массив
//     - СправочникСсылка.Пользователи
//
Функция ВсеРуководителиМетрологическихПодразделений(Знач БизнесПроцессОбъект) Экспорт 
	
	Контекст = "ИТГ_ШаблоныБизнесПроцессов.ВсеРуководителиМетрологическихПодразделений";
	
	МассивРуководителей = Новый Массив;
	
	Свойство_НаправлениеДеятельности = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиСоздатьСвойство_НаправлениеДеятельности();
	НаправлениеДеятельности_Метрология = Справочники.ЗначенияСвойствОбъектовИерархия.НайтиСоздатьЗначениеСвойства_НаправлениеДеятельности_Метрология();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДополнительныеРеквизиты.Ссылка КАК Подразделение,
		|	ДополнительныеРеквизиты.Ссылка.Наименование КАК Наименование,
		|	ДополнительныеРеквизиты.Ссылка.Руководитель КАК Руководитель,
		|	ДополнительныеРеквизиты.Ссылка.Руководитель.Недействителен КАК РуководительНедействителен
		|ИЗ
		|	Справочник.СтруктураПредприятия.ДополнительныеРеквизиты КАК ДополнительныеРеквизиты
		|ГДЕ
		|	ДополнительныеРеквизиты.Свойство = &Свойство
		|	И ДополнительныеРеквизиты.Значение = &НаправлениеДеятельности";
	
	Запрос.УстановитьПараметр("Свойство", Свойство_НаправлениеДеятельности);
	Запрос.УстановитьПараметр("НаправлениеДеятельности", НаправлениеДеятельности_Метрология);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаМетрологическихПодразделений = РезультатЗапроса.Выбрать();
	
	// TODO: в дальнейшем - Справочники.РолиИсполнителей.РуководительПодразделения;
	РольРуководителя = Справочники.РолиИсполнителей.НайтиСоздатьРоль_РуководительПодразделения();
		
	Пока ВыборкаМетрологическихПодразделений.Следующий() Цикл
		
		ПолнаяРольРуководителяМетрологическогоПодразделения = Справочники.ПолныеРоли.НайтиСоздатьПолнуюРоль(
			РольРуководителя,
			ВыборкаМетрологическихПодразделений.Подразделение);

		Если БизнесПроцессыИЗадачиСервер.ЕстьИсполнителиРоли(ПолнаяРольРуководителяМетрологическогоПодразделения) Тогда
			МассивРуководителей.Добавить(ПолнаяРольРуководителяМетрологическогоПодразделения);
		Иначе
			Руководитель = ВыборкаМетрологическихПодразделений.Руководитель;
			Если ЗначениеЗаполнено(Руководитель) 
				И Не ВыборкаМетрологическихПодразделений.РуководительНедействителен
				И МассивРуководителей.Найти(Руководитель) = Неопределено Тогда
				МассивРуководителей.Добавить(Руководитель);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивРуководителей;
	
КонецФункции

// Возвращает всех сотрудников метрологических подразделений.
// Отбор метрологических подразделений осуществляется по дополнительному реквизиту
// "Направление деятельности", по значению "Метрология".
//
// Параметры:
//   БизнесПроцессОбъект - БизнесПроцессОбъект.<Тип бизнес процесса> - процесс, для которого
//                         вычисляется автоподстановка
//
// Возвращаемое значение:
//   Массив
//     - СправочникСсылка.Пользователи
//
Функция ВсеСотрудникиМетрологическихПодразделений(Знач БизнесПроцессОбъект) Экспорт 
	
	Контекст = "ИТГ_ШаблоныБизнесПроцессов.ВсеСотрудникиМетрологическихПодразделений";
	
	Свойство_НаправлениеДеятельности = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиСоздатьСвойство_НаправлениеДеятельности();
	НаправлениеДеятельности_Метрология = Справочники.ЗначенияСвойствОбъектовИерархия.НайтиСоздатьЗначениеСвойства_НаправлениеДеятельности_Метрология();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Пользователи.Ссылка КАК Сотрудник
		|ИЗ
		|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|		ПО СтруктураПредприятия.Ссылка = Пользователи.Подразделение
		|ГДЕ
		|	НЕ Пользователи.Недействителен
		|	И СтруктураПредприятия.ДополнительныеРеквизиты.Свойство = &Свойство
		|	И СтруктураПредприятия.ДополнительныеРеквизиты.Значение = &НаправлениеДеятельности";
	
	Запрос.УстановитьПараметр("Свойство", Свойство_НаправлениеДеятельности);
	Запрос.УстановитьПараметр("НаправлениеДеятельности", НаправлениеДеятельности_Метрология);
	
	МассивСотрудников = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Сотрудник");
	
	Возврат МассивСотрудников;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает полную роль, заполняя объекты адресации (организация, подразделение) данными документа.
//
// Параметры:
//  Роль - СправочникСсылка.РолиИсполнителей - ссылка на роль, для которой требуется получить полную роль
//  Документ - СправочникСсылка	 - ссылка на документ
// 
// Возвращаемое значение:
//  СправочникСсылка.ПолныеРоли - .
//
Функция ПолучитьПолнуюРольСОбъектамиАдресацииПоДокументу(Знач Роль, Знач Документ) 
	
	Контекст = "ИТГ_ШаблоныБизнесПроцессов.ПолучитьПолнуюРольСОбъектамиАдресацииПоДокументу";
	
	МассивРеквизитовДокумента = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Подразделение");
	
	ИспользоватьУчетПоОрганизациям = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям");
	Если ИспользоватьУчетПоОрганизациям Тогда
		МассивРеквизитовДокумента.Добавить("Организация");
	КонецЕсли;
	
	РеквизитыДокумента = ИТГ_Делопроизводство.ЗначенияРеквизитовДокумента(Документ, МассивРеквизитовДокумента);
	
	ПолнаяРоль = Справочники.ПолныеРоли.НайтиСоздатьПолнуюРольПоРеквизитамОбъекта(Роль,
		РеквизитыДокумента, Истина, Истина);
	
	Возврат ПолнаяРоль;
	
КонецФункции

// Получает полную роль, заполняя объекты адресации (организация, подразделение) данными документа.
// По данным адресата документа определяет его подразделение.
// Затем проверяет наличие исполнителей роли для этого подразделения.
// Если не находит такой полной роли или её исполнителей, тогда переходит
// к вышестоящему подразделению. И так - до самого верха.
// Если не находит и для подразделения верхнего уровня - генерирует исключение.
//
// Параметры:
//  Роль - СправочникСсылка.РолиИсполнителей - ссылка на роль, для которой требуется получить полную роль
//  Документ - СправочникСсылка	 - ссылка на документ
// 
// Возвращаемое значение:
//  СправочникСсылка.ПолныеРоли - .
//
Функция ПолучитьПолнуюРольСОбъектамиАдресацииПоАдресатуДокументу(Знач Роль, Знач Документ) 
	
	Контекст = "ИТГ_ШаблоныБизнесПроцессов.ПолучитьПолнуюРольСОбъектамиАдресацииПоАдресатуДокументу";
	
	МассивРеквизитовДокумента = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Адресат");
	
	ИспользоватьУчетПоОрганизациям = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям");
	Если ИспользоватьУчетПоОрганизациям Тогда
		МассивРеквизитовДокумента.Добавить("Организация");
	КонецЕсли;
	
	РеквизитыДокумента = ИТГ_Делопроизводство.ЗначенияРеквизитовДокумента(Документ, МассивРеквизитовДокумента);
	
	ОбъектыАдресации = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(РеквизитыДокумента);
	Подразделение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РеквизитыДокумента.Адресат, "Подразделение");
	ОбъектыАдресации.Вставить(ПланыВидовХарактеристик.ОбъектыАдресацииЗадач.Подразделение.Наименование, Подразделение);

	ПолнаяРоль = Справочники.ПолныеРоли.НайтиСоздатьПолнуюРольПоРеквизитамОбъекта(Роль,
		ОбъектыАдресации, Истина, Истина);
	
	Возврат ПолнаяРоль;
	
КонецФункции

// Получает ссылку на документ из указанного предмета указанного процесса.
//
// Параметры:
//  БизнесПроцессОбъект	 - БизнесПроцессОбъект.<Тип бизнес процесса> - процесс, для которого
//  							вычисляется автоподстановка
//  ИмяПредмета			 - СправочникСсылка.ИменаПредметов	 - имя предмета в процессе
// 
// Возвращаемое значение:
//  СправочникСсылка - ссылка на документ.
//
Функция ПолучитьДокументИзПредметаПроцесса(Знач БизнесПроцессОбъект, Знач ИмяПредмета)
	
	Контекст = "ИТГ_ШаблоныБизнесПроцессов.ПолучитьДокументИзПредметаПроцесса";
	
	СтрокаПредмета = БизнесПроцессОбъект.Предметы.Найти(ИмяПредмета, "ИмяПредмета");
	
	ОбщегоНазначенияКлиентСервер.Проверить(
		СтрокаПредмета <> Неопределено,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не найден предмет ""%1"" процесса'"),
			Строка(ИмяПредмета)),
		Контекст);
		
	ОбщегоНазначенияКлиентСервер.Проверить(
		ЗначениеЗаполнено(СтрокаПредмета.Предмет),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Автоподстановка не может быть выполнена, так как не указан предмет ""%1"" процесса'"),
			Строка(ИмяПредмета)),
		Контекст);
		
	ДокументСсылка = СтрокаПредмета.Предмет;
	
	ОбщегоНазначенияКлиентСервер.Проверить(
		ДелопроизводствоКлиентСервер.ЭтоСсылкаНаДокумент(ДокументСсылка),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Автоподстановка не может быть выполнена, так как предмет ""%1"" процесса не является документом'"),
			Строка(ИмяПредмета)),
		Контекст);
		
	Возврат ДокументСсылка;
		
КонецФункции

#КонецОбласти
