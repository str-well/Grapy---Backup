{# /*============================================================================
  #Page header
==============================================================================*/

#Properties

#Title

#Breadcrumbs

#}

<section class="page-header" data-store="page-title">
	{% if template != 'product' or template != 'contact' %}
		<div class="container">
			<div class="row">
			{% endif %}
			<div class="{% if template != 'product' %}col text-center{% endif %} {% if template == 'category' %}col-lg-8 offset-lg-2{% endif %}">
				{% if template == 'product' or template == 'account.orders' or template == 'account.order' %}
					{% include 'snipplets/breadcrumbs.tpl' %}
				{% endif %}
				<h1 style="color: #C05726;" class="{% if template == 'product' %}js-product-name{% else %}text-center{% endif %} h2 h1-md {% if template == 'contact' %} text-md-left{% endif %}{% if settings.theme_rounded and template != 'product' %} text-primary{% endif %}" {% if template == "product" %} data-store="product-name-{{ product.id }}" {% endif %}> {% block page_header_text %}{% endblock %}
					</h1>
					{% if template == 'category' and category.description %}
						<p class="font-small font-md-normal text-center mb-0 mb-md-4">{{ category.description }}</p>
					{% endif %}
				</div>
				{% if template != 'product' %}
				</div>
			</div>
		{% endif %}
	</section>
