{% embed "snipplets/page-header.tpl" with {'breadcrumbs': true} %}
    {% block page_header_text %}{{ "Carrito de Compras" | translate }}{% endblock page_header_text %}
{% endembed %}

<div id="shoppingCartPage" class="container mt-5" data-minimum="{{ settings.cart_minimum_value }}">
    <form action="{{ store.cart_url }}" method="post" class="cart-body" data-store="cart-form" data-component="cart">
        <div class="cart-body">

            {# Cart alerts #}

            {% if error.add %}
                <div class="alert alert-warning">
                    {{ "¡Uy! No tenemos más stock de este producto para agregarlo al carrito. Si querés podés" | translate }}<a href="{{ store.products_url }}" class="btn-link ml-1">{{ "ver otros acá" | translate }}</a>
                </div>
            {% endif %}
            {% for error in error.update %}
                <div class="alert alert-warning">{{ "No podemos ofrecerte {1} unidades de {2}. Solamente tenemos {3} unidades." | translate(error.requested, error.item.name, error.stock) }}</div>
            {% endfor %}
            {% if cart.items %}

                {# Cart header #}
                
                <div class="cart-row mb-4">
                    <div class="row">
                        <div class="col-12 col-md-1">
                            <span class="js-cart-products-heading-plural" {% if cart.items_count == 1 %}style="display: none;"{% endif %}>{{ 'Productos' | translate }}</span>
                            <span class="js-cart-products-heading-singular" {% if cart.items_count > 1 %}style="display: none;"{% endif %}>{{ 'Producto' | translate }}</span>
                        </div>
                        <div class="col-md-10 d-none d-md-block">
                            <div class="row">
                                <div class="col-md-3 offset-5 text-center">{{ 'Cantidad' | translate }}</div>
                                <div class="col-md-2 text-center">{{ 'Precio' | translate }}</div>
                                <div class="col-md-2 text-center">{{ 'Subtotal' | translate }}</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="js-ajax-cart-list cart-row">

                    {# Cart items #}

                    {% if cart.items %}
                      {% for item in cart.items %}
                        {% include "snipplets/cart-item-ajax.tpl" with {'cart_page': true} %}
                      {% endfor %}
                    {% endif %}
                </div>
            {% else %}

                {#  Empty cart  #}

                <div class="alert alert-info">
                    {% if error %}
                        {{ "¡Uy! No tenemos más stock de este producto para agregarlo al carrito. Si querés podés" | translate }}
                        <a href="{{ store.products_url }}" class="btn btn-link p-none">{{ "ver otros acá" | translate }}</a>
                    {% else %}
                        {{ "El carrito de compras está vacío." | translate }}
                    {% endif %}
                    {{ ("Ver más productos" | translate ~ " »") | a_tag(store.products_url) }}
                </div>
            {% endif %}
            <div id="error-ajax-stock" style="display: none;">
                <div class="alert alert-warning">
                    {{ "¡Uy! No tenemos más stock de este producto para agregarlo al carrito. Si querés podés" | translate }}<a href="{{ store.products_url }}" class="btn-link ml-1">{{ "ver otros acá" | translate }}</a>
                </div>
            </div>
            <div class="cart-row">
                {% include "snipplets/cart-totals.tpl" with {'cart_page': true} %}
            </div>
        </div>
    </form>
    <div id="store-curr" class="hidden">{{ cart.currency }}</div>
</div>

