/*
 * Translated default messages for the jQuery validation plugin.
 * Locale: PT (Portuguese; português)
 * Region: BR (Brazil)
 */
(function ($) {
	$.extend($.validator.messages, {
		required: "Este campo é obrigatório.",
		remote: "Por favor, corrija este campo.",
		email: "Por favor, forneça um email válido.",
		url: "Por favor, forneça uma URL válida.",
		date: "Por favor, forneça uma data válida.",
		dateISO: "Por favor, forneça uma data válida (ISO).",
		number: "Por favor, forneça um número válido.",
		digits: "Por favor, forneça somente dígitos.",
		creditcard: "Por favor, forneça um cartão de crédito válido.",
		equalTo: "Por favor, forneça o mesmo valor novamente.",
		accept: "Por favor, forneça um arquivo com uma extensão válida.",
		maxlength: $.validator.format("Por favor, não forneça mais que {0} caracteres."),
		minlength: $.validator.format("Por favor, forneça ao menos {0} caracteres."),
		rangelength: $.validator.format("Por favor, forneça um valor entre {0} e {1} caracteres de comprimento."),
		range: $.validator.format("Por favor, forneça um valor entre {0} e {1}."),
		max: $.validator.format("Por favor, forneça um valor menor ou igual a {0}."),
		min: $.validator.format("Por favor, forneça um valor maior ou igual a {0}.")
	});
}(jQuery));
