{% if settings.video_embed %}
	<section class="section-video-home" data-store="video-home">
		<div class="container{% if settings.video_full %}-fluid p-0{% endif %}" style="max-width: 976px;">
			<div class="row no-gutters">
				{% if settings.video_title or settings.video_text %}
					<div class="col-md-8 offset-md-2 text-center">
						{% if settings.video_title %}
							<h2 class="h1{% if settings.theme_rounded %} text-primary{% endif %}">
								{{ settings.video_title }}
							</h2>
						{% endif %}
						{% if settings.video_text %}
							<p class="mb-5">{{ settings.video_text }}</p>
						{% endif %}
					</div>
				{% endif %}
				<div class="col-12">{% include 'snipplets/video-item.tpl' %}</div>
			</div>
		</div>
		<!DOCTYPE html>
		<html lang="en">
			<head>
				<meta charset="UTF-8"/>
				<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
				<meta http-equiv="X-UA-Compatible" content="ie=edge"/>
				<link rel="stylesheet" type="text/css" href="/style.css"/>
			</head>
			<body>
				<div class="grid-container">
					<div class="parent">
						<div class="container-card div1">
							<img src="https://grapy.com.br/wp-content/uploads/2019/09/h1-custom-icon-1.png" alt="Imagem 1"/>
							<h5 class="title-card">
								<span style="font-weight: 500; font-size: 19px">Convidativa</span>
							</h5>
							<p style="opacity: 0.7; font-size: 13px">
								Deixando as regras e alguns conceitos de lado, para nós a melhor
								              forma de consumir um vinho é se aventurando, experimentando e
								              percebendo o SEU próprio gosto.
							</p>
						</div>
						<div class="container-card div2">
							<img src="https://grapy.com.br/wp-content/uploads/2019/09/h1-custom-icon-1.png" alt="Imagem 2"/>
							<h5 class="title-card">
								<span style="font-weight: 500; font-size: 19px">Moderna</span>
							</h5>
							<p style="opacity: 0.7; font-size: 13px">
								Com uma linguagem mais jovem, queremos aproximar as pessoas ao
								              vinho através de sugestões de consumo casuais e experiências
								              divertidas que conectem o consumidor e o vinho.
							</p>
						</div>
						<div class="container-card div3">
							<img src="https://grapy.com.br/wp-content/uploads/2019/09/h1-custom-icon-1.png" alt="Imagem 3"/>
							<h5 class="title-card">
								<span style="font-weight: 500; font-size: 19px">Prática</span>
							</h5>
							<p style="opacity: 0.7; font-size: 13px">
								O vinho mais caro não é necessariamente o melhor. Buscamos
								              facilitar a vida de quem quer comprar um vinho e está em dúvida
								              utilizando um guia com 3 passos: ocasião, valor e referência.
							</p>
						</div>
					</div>
					<div class="right-side">
						<div class="top-right">
							<h3 class="right-cards-title">Rótulos Grapy</h3>
							<h4 class="right-cards-subtitle">
								Para todos os bolsos e momentos. Vinhos da nossa curadoria
							</h4>
							<div>
								<p style="opacity: 0.7; font-size: 13px">
									Nossa seleção de vinhos conta com rótulos de distribuição
									                exclusiva GRAPY e de outros parceiros. A escolha desses rótulos
									                foi feita de forma dedicada e cuidadosa, para conseguirmos
									                chegar em um mix perfeito de regiões, uvas e valores divididos
									                em marcas conhecidas e consolidadas no mercado com outras novas
									                opções também de muita qualidade e que podem surpreender muito.
								</p>

								<p style="opacity: 0.7; font-size: 13px">
									Com distribuição exclusiva, selecionamos a dedo as vinícolas
									                parceiras que representamos. Consideramos a sua história,
									                dedicação dos produtores e claro a qualidade dos vinhos
									                produzidos. Começamos por Portugal, mas em breve teremos
									                representantes de outros países.
								</p>
							</div>
						</div>
						<div class="bottom-right">
							<h3 class="right-cards-title">Regiões</h3>
							<p style="padding-top: 1.5rem; opacity: 0.7; font-size: 13px">
								Como incentivadores de novas experiências trouxemos vinhos de duas
								              regiões menos “tradicionais”: BEIRA INTERIOR e TRÁS-OS-MONTES.
								              Seguindo a nossa filosofia de mesclar rótulos clássicos e o
								              modernos, a nossa escolha clássica foi na mais clássica região de
								              Portugal: DOURO.
							</p>
						</div>
					</div>
				</div>
				<section class="parent-story">
					<div class="container-left">
						<h2 class="title-left">Nossa História</h2>
						<div class="text-left2">
							<p style="margin-top: 1.5rem">
								A GRAPY surgiu da paixão de dois amigos pelo vinho e a vontade de
								              apresentar esse mundo tão interessante de forma convidativa,
								              moderna e prática.
							</p>
						</div>
						<div class="text-left2">
							<p>
								Nossa seleção de vinhos conta com rótulos de distribuição
								              exclusiva GRAPY.
								<br/>A escolha desses rótulos foi feita de forma dedicada e
								              cuidadosa, conseguirmos apresentar vinhos exclusivos e singulares.
								<br/>
								Consideramos a sua história, dedicação dos produtores e claro
								              acima de tudo a qualidade dos vinhos produzidos.
							</p>
						</div>
						<a href="https://grapy.lojavirtualnuvem.com.br/produtores/" target="_self">
							<button class="btn-buy-now2">Comprar Agora</button>
						</a>
					</div>
					<div class="container-right2">
						<div class="img-right">
							<img src="https://uploaddeimagens.com.br/images/004/348/483/full/Convidativa_._Moderna_e_Pr%C3%A1tica_._..png?1675971958" alt="Grapy Sócios" class="img-story"/>
						</div>
					</div>
				</section>
			</body>
		</html>
	</section>
{% endif %}
