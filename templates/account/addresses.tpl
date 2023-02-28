<section class="container mb-4 text-center">
    <div class="row">
        <div class="col-12">
            {% include "snipplets/breadcrumbs.tpl" %}
        </div>
    </div>
</section>

{% embed "snipplets/page-header.tpl" %}
    {% block page_header_text %}{{ "Mis direcciones" | translate }}{% endblock page_header_text %}
{% endembed %}

<section class="account-page mb-0">
    <div class="container">
        <div class="row justify-content-md-center">      
            {% for address in customer.addresses %}

                {# User addresses listed - Main Address #}

                {% if loop.first %}
                    <div class="col-md-4 col-12">
                        <div class="box p-3"> 
                            <h5 class="mt-1">{{ 'Principal' | translate }}</h5>

                {# User addresses listed - Other Addresses #}

                {% elseif loop.index == 2 %}
                    <div class="col-md-4 col-12">
                        <div class="box p-3"> 
                            <h5 class="mt-1">{{ 'Otras direcciones' | translate }}</h5>

                {% endif %}

                            <h6 class="mb-0">{{ address.name }} {{ 'Editar' | translate | a_tag(store.customer_address_url(address), '', 'btn-link btn-link-primary font-small float-right') }}</h6>
                            <div class="divider mx-0 mt-1 mb-2"></div>
                            <p class="font-small">{{ address | format_address }}</p>

                {% if loop.first %} 
                            <a class="btn-link btn-link-primary font-small" href="{{ store.customer_new_address_url }}"> {{ 'Agregar una nueva dirección' | translate }}</a>
                        </div>
                    </div>
                {% elseif loop.last %}
                        </div>
                    </div>
                {% endif %}            
            {% endfor %}                
        </div>
    </div>
</section>