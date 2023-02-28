{# Check if store has free shipping without regions or categories #}

{% set has_free_shipping = cart.free_shipping.cart_has_free_shipping or cart.free_shipping.min_price_free_shipping.min_price %}

{# Free shipping visibility variables #}

{% if product_detail and store.has_free_shipping_progress and cart.free_shipping.min_price_free_shipping.min_price %}

	{# Calculate if adding one more product free shipping is achieved #}

	{% set free_shipping_product_threashold = cart.free_shipping.min_price_free_shipping.min_price_raw - (cart.total + product.price) %}

	{% set hide_free_shipping_minimum = (cart.free_shipping.cart_has_free_shipping or not cart.free_shipping.min_price_free_shipping.min_price) or free_shipping_product_threashold <= 0 %}

{% else %}

	{% set hide_free_shipping_minimum = cart.free_shipping.cart_has_free_shipping or not cart.free_shipping.min_price_free_shipping.min_price %}

{% endif %}

{% set free_shipping_minimum_label_changes_visibility = not store.has_free_shipping_progress or (store.has_free_shipping_progress and product_detail and has_free_shipping and cart.free_shipping.min_price_free_shipping.min_price_raw > 0) %}

{% set free_shipping_messages_visible = (has_free_shipping and not store.has_free_shipping_progress) or (store.has_free_shipping_progress and product_detail and has_free_shipping) or (store.has_free_shipping_progress and not product_detail and has_free_shipping and cart.free_shipping.min_price_free_shipping.min_price_raw == 0) %}

{% set hide_cart_free_shipping_message = store.has_free_shipping_progress and not product_detail and has_free_shipping and cart.free_shipping.min_price_free_shipping.min_price_raw > 0 %}

{% if product_detail %}
	{% set cart_zipcode = false %}
{% else %}
	{% set cart_zipcode = cart.shipping_zipcode %}
{% endif %}

{% if product_detail %}
<div class="row">
{% endif %}
<div class="mb-2 col-12" data-store="shipping-calculator">

	<div class="js-shipping-calculator-head shipping-calculator-head position-relative transition-soft {% if cart_zipcode %}with-zip{% else %}with-form{% endif %} {% if free_shipping_messages_visible %}with-free-shipping{% endif %}">
		<div class="js-shipping-calculator-with-zipcode {% if cart_zipcode %}js-cart-saved-zipcode transition-up-active{% endif %} mb-4 w-100 transition-up position-absolute">
			{% if free_shipping_messages_visible %}

				{# Free shipping labels when calcualtor is hidden #}

				<div class="free-shipping-title {% if product_detail %}text-left{% else %}text-center{% endif %} transition-soft">

					{# Free shipping achieved label #}

					<div class="js-free-shipping-title position-absolute transition-up w-100 h4 {% if cart.free_shipping.cart_has_free_shipping %}transition-up-active{% endif %}">
						<span class="font-weight-bold text-accent">{{ "¡Genial! Tenés envío gratis" | translate }}</span>
					</div>

					{# Free shipping with min price label #}

					{% if store.has_free_shipping_progress and cart.free_shipping.min_price_free_shipping.min_price_raw > 0 and product_detail %}

						{% include "snipplets/shipping/shipping-free-rest.tpl" with {'calculator_label': false, 'product_detail': true} %}

					{% endif %}


					<div class="js-free-shipping-title-min-cost position-absolute transition-up w-100 h5 {% if not hide_free_shipping_minimum %}transition-up-active{% endif %}">
						{{ "<strong class='text-accent'>Envío gratis</strong> superando los" | translate }} <span>{{ cart.free_shipping.min_price_free_shipping.min_price }}</span>
					</div>
				</div>

			{% endif %}
			<div class="container p-0">
				<div class="row align-items-center">
					<span class="col pr-0">
						<span class="font-small align-bottom">
							<span>{{ "Entregas para el CP:" | translate }}</span>
							<strong class="js-shipping-calculator-current-zip">{{ cart_zipcode }}</strong>
						</span>
					</span>
					<div class="col-auto pl-0">
						<a class="js-shipping-calculator-change-zipcode btn btn-secondary btn-small float-right py-1 px-2 px-sm-3" href="#">{{ "Cambiar CP" | translate }}</a>
					</div>
				</div>
			</div>
		</div>

		<div class="js-shipping-calculator-form shipping-calculator-form transition-up position-absolute">

			{# Shipping calcualtor input #}

			{% embed "snipplets/forms/form-input.tpl" with{type_tel: true, input_value: cart_zipcode, input_name: 'zipcode', input_custom_class: 'js-shipping-input', input_placeholder: "Tu código postal" | translate, input_aria_label: 'Tu código postal' | translate, input_label: false, input_append_content: true, input_group_custom_class: 'form-row form-group-inline align-items-center mb-3', form_control_container_custom_class: 'col-6 col-lg-7 pr-0'} %}
				{% block input_prepend_content %}
					<div class="col-12 mb-2 form-label">

						{% include "snipplets/svg/truck.tpl" with {svg_custom_class: "icon-inline icon-lg svg-icon-text mr-2 align-text-bottom"} %}
						<span class="align-middle">

								{# Free shipping with min price label #}

								<span class="{% if free_shipping_minimum_label_changes_visibility %}js-shipping-calculator-label{% endif %}" {% if hide_free_shipping_minimum or hide_cart_free_shipping_message %}style="display: none;"{% endif %}>
									{{ "<strong class='text-accent'>Envío gratis</strong> superando los" | translate }} <span>{{ cart.free_shipping.min_price_free_shipping.min_price }}</span>
								</span>

								{% if store.has_free_shipping_progress and cart.free_shipping.min_price_free_shipping.min_price_raw > 0 and product_detail %}

									{% include "snipplets/shipping/shipping-free-rest.tpl" with {'calculator_label': true, 'product_detail': true} %}

								{% endif %}

								{# Free shipping achieved calculator label #}

								<span class="{% if free_shipping_minimum_label_changes_visibility %}js-free-shipping-message{% endif %} text-accent" {% if not cart.free_shipping.cart_has_free_shipping or hide_cart_free_shipping_message %}style="display: none;"{% endif %}>
									{{ "¡Genial! Tenés envío gratis" | translate }}
								</span>

								
								{# Shipping default label #}

								<span {% if not store.has_free_shipping_progress %}class="js-shipping-calculator-label-default"{% endif %} {% if free_shipping_messages_visible or (store.has_free_shipping_progress and cart.free_shipping.min_price_free_shipping.min_price_raw == 0 and has_free_shipping) %}style="display: none;"{% endif %}>

									{# Regular shipping calculator label #}
									
									{{ "Medios de envío" | translate }}
								</span>
						</span>
					</div>
				{% endblock input_prepend_content %}
				{% block input_append_content %}
				<div class="col-6 col-lg-5 pl-0">
					<button class="js-calculate-shipping btn btn-secondary btn-block" aria-label="{{ 'Calcular envío' | translate }}">	
						<span class="js-calculate-shipping-wording">{{ "Calcular" | translate }}</span>
						<span class="js-calculating-shipping-wording" style="display: none;">{{ "Calculando" | translate }}</span>
						<span class="float-right loading" style="display: none;">
							{% include "snipplets/svg/circle-notch.tpl" with {svg_custom_class: "icon-inline icon-smd icon-spin svg-icon-primary"} %}
						</span>
					</button>
				</div>
			{% endblock input_append_content %}
				{% block input_form_alert %}
				{% if store.country == 'BR' or 'AR' or 'MX' %}
					{% set zipcode_help_ar = 'https://www.correoargentino.com.ar/formularios/cpa' %}
					{% set zipcode_help_br = 'http://www.buscacep.correios.com.br/sistemas/buscacep/' %}
					{% set zipcode_help_mx = 'https://www.correosdemexico.gob.mx/datosabiertos/gobmx/gobmx_Descarga.html' %}
					<div class="col-12">

						{% if product_detail and not customer %}
							<a data-toggle="#quick-login" class="js-product-quick-login js-modal-open font-small text-primary mt-2 mb-2 d-block" href="#">{{ '<strong>Iniciá sesión</strong> y usá tus datos de entrega' | translate }}</a>
						{% endif %}

						<a class="font-small text-primary mt-2 mb-2 d-block {% if product_detail %} js-shipping-zipcode-help {% endif %}" href="{% if store.country == 'AR' %}{{ zipcode_help_ar }}{% elseif store.country == 'BR' %}{{ zipcode_help_br }}{% elseif store.country == 'MX' %}{{ zipcode_help_mx }}{% endif %}" target="_blank">{{ "No sé mi código postal" | translate }}</a>
					</div>
				{% endif %}
				<div class="col-12">
					<div class="js-ship-calculator-error invalid-zipcode alert alert-danger" style="display: none;">
						
						{# Specific error message considering if store has multiple languages #}

						{% for language in languages %}
							{% if language.active %}
								{% if languages | length > 1 %}
									{% set wrong_zipcode_wording = ' para ' | translate ~ language.country_name ~ '. Podés intentar con otro o' | translate %}
								{% else %}
									{% set wrong_zipcode_wording = '. ¿Está bien escrito?' | translate %}
								{% endif %}
								{{ "No encontramos este código postal{1}" | translate(wrong_zipcode_wording) }}

								{% if languages | length > 1 %}
									<a href="#" data-toggle="#{% if product_detail %}product{% else %}cart{% endif %}-shipping-country" class="js-modal-open btn-link btn-link-primary text-lowercase">
										{{ 'cambiar tu país de entrega' | translate }}
									</a>
								{% endif %}
							{% endif %}
						{% endfor %}
					</div>
					<div class="js-ship-calculator-error js-ship-calculator-common-error alert alert-danger" style="display: none;">{{ "Ocurrió un error al calcular el envío. Por favor intentá de nuevo en unos segundos." | translate }}</div>
					<div class="js-ship-calculator-error js-ship-calculator-external-error alert alert-danger" style="display: none;">{{ "El calculo falló por un problema con el medio de envío. Por favor intentá de nuevo en unos segundos." | translate }}</div>
				</div>
				{% endblock input_form_alert %}
				{% block input_add_on %}
					{% if shipping_calculator_variant %}
						<input type="hidden" name="variant_id" id="shipping-variant-id" value="{{ shipping_calculator_variant.id }}">
					{% endif %}
				{% endblock input_add_on %}
			{% endembed %}
		</div>
	</div>
	<div class="js-shipping-calculator-spinner shipping-spinner-container mb-3 float-left w-100 transition-soft text-center" style="display: none;"><div class="spinner-ellipsis"><div class="point"></div><div class="point"></div><div class="point"></div><div class="point"></div></div></div>
	<div class="js-shipping-calculator-response mb-3 float-left w-100 transition-soft {% if product_detail %}list {% else %} radio-buttons-group{% endif %}" style="display: none;"></div>
</div>
{% if product_detail %}
</div>
{% endif %}

{# Shipping country modal #}

{% if languages | length > 1 %}

	{% if product_detail %}
		{% set country_modal_id = 'product-shipping-country' %}
	{% else %}
		{% set country_modal_id = 'cart-shipping-country' %}
	{% endif %}

	{% embed "snipplets/modal.tpl" with{modal_id: country_modal_id, modal_class: 'bottom modal-centered-small js-modal-shipping-country', modal_position: 'center', modal_transition: 'slide', modal_header: true, modal_footer: true, modal_width: 'centered', modal_zindex_top: true} %}
		{% block modal_head %}
		    {{ 'País de entrega' | translate }}
		{% endblock %}
		{% block modal_body %}
		    {% embed "snipplets/forms/form-select.tpl" with{select_label: true, select_label_name: 'País donde entregaremos tu compra' | translate, select_aria_label: 'País donde entregaremos tu compra' | translate, select_custom_class: 'js-shipping-country-select', select_group_custom_class: 'mt-4' } %}
				{% block select_options %}
					{% for language in languages %}
						<option value="{{ language.country }}" data-country-url="{{ language.url }}" {% if language.active %}selected{% endif %}>{{ language.country_name }}</option>
					{% endfor %}
				{% endblock select_options%}
			{% endembed %}
		{% endblock %}
		{% block modal_foot %}
			<a href="#" class="js-save-shipping-country btn btn-primary float-right">{{ 'Aplicar' | translate }}</a>
		{% endblock %}
	{% endembed %}
{% endif %}
