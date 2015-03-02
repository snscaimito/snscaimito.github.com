---
layout: post
title: Java o PHP para desarrollar una aplicación web
tags:
- es
categories:
- software-development
status: publish
type: post
published: true
meta: {}
---
<p>Inspirado por la discusi&oacute;n con un cliente quiero publicar mis pensamientos sobre la cuesti&oacute;n "Java o PHP para desarrollar una aplicaci&oacute;n web". Aqu&iacute; en Panam&aacute; y aparentemente en otros pa&iacute;ses de Am&eacute;rica Latina PHP es mas famoso que Java. Hay muchas empresas peque&ntilde;as que se dedican a la creaci&oacute;n de paginas web y ellos usan PHP para a&ntilde;adir funciones de interacci&oacute;n a las paginas. Todo esto me hace recordar la situaci&oacute;n en Alemania hace como 8 anos atr&aacute;s.</p>

<p>Creo que es importante que se comparan manzanas con manzanas.</p>

<blockquote><p><strong>PHP</strong> es principalmente una tecnol&oacute;gica para paginas web.</p>

<p><strong>Java</strong> es un lenguaje como C/C++ o Smalltalk para realizar cualquier aplicaci&oacute;n que se puede programar. Paginas web solamente son una forma de user interface. Con Java puedo crear aplicaciones desktop para diferente plataformas con Swing o RCP. Puedo crear applets para el browser. Y uso OOP (object-oriented programming) juntos con una cantidad de otras t&eacute;cnicas para crear un producto de calidad.</p>
</blockquote>

<p>Java no se debe comparar con PHP. Mas bien con Microsoft .NET y alla con C# que es como el Java de Microsoft.</p>

<p>Veamos TDD (test driven development). No solamente ayuda eso para dise&ntilde;ar las clases - los objetos que se usan en el c&oacute;digo - pero tambi&eacute;n puedo comprobar que el c&oacute;digo no tiene errores. Herramientas como Cobertura, EMMA y Clover reportan la coberatura por unit tests. Un buen ejemplo es el reporte de <a href="http://tapestry.apache.org/tapestry5/tapestry-core/cobertura/index.html">Cobertura para el proyecto open source Tapestry</a>.

<p>Con una herramienta como <a href="http://www.openqa.org/selenium">Selenium</a> puedo comprobar el user interface - o sea las paginas - de manera autom&aacute;tica como si un robot seria usando toda la aplicaci&oacute;n m&uacute;ltiples veces al d&iacute;a. Si se hace alg&uacute;n error, ya se lo ve dentro de una hora en el pr&oacute;ximo build.</p>

<p>PHP frameworks como <a href="http://www.oracle.com/technology/pub/articles/jansch_atk.html">ATK</a> y <a href="http://smarty.php.net/">Smarty</a> no solucionan el problema mayor de PHP: no hay <a href="http://www.microsoft.com/spanish/msdn/articulos/archivo/271106/voices/NPALayering.mspx">separaci&oacute;n</a> <a href="http://www.dsic.upv.es/workshops/dsdm04/files/02-Amaya-pres.pdf">de</a> <a href="http://en.wikipedia.org/wiki/Separation_of_concerns">asuntos</a>. La separaci&oacute;n de asuntos me permite de desarrollar c&oacute;digo que atiende los asuntos asignados a la capa en que reside.</p>

<p>Una clase en la capa de infraestructura comunica con la base de datos y retorna objetos de valores que se pasan a la capa de negocio. Yo puedo comprobar la funcionalidad de esa clase en aislamiento antes que se desarrolla el resto de la aplicaci&oacute;n.</p>

<p>Una clase en la capa de negocio que requiere datos de una base de datos para poder trabajar se puede correr en un test con una simulaci&oacute;n de la infraestructura, porque no depende directamente del c&oacute;digo en la capa de infraestructura. Le puedo pasar un <a href="http://en.wikipedia.org/wiki/Mock_object">mock object</a> que tiene la misma interfaz que el objeto real, pero act&uacute;a como defino en mi test.</p>

<p>Con <a href="http://en.wikipedia.org/wiki/Test-driven_development">TDD</a> puedo verificar la funci&oacute;n correcta de cada hielo en el c&oacute;digo, porque me permite de usar cada linea de c&oacute;digo en una forma de laboratorio. Y si hago cualquier cambio siempre y autom&aacute;ticamente se comprueba todo el c&oacute;digo de nuevo.</p>

<p>Claro ideas como TDD, <a href="http://www.martinfowler.com/articles/continuousIntegration.html">continuous integration</a>, <a href="http://martinfowler.com/articles/injection.html">dependency injection</a> y otras no son algo exclusivo para Java. Se puede usarlas con C, C++ y con PHP tambi&eacute;n. Pero porque la historia de PHP (scripting language para paginas web) dudo mucho que los que usan PHP tienen mucho experiencia con eso. Para la mayor&iacute;a de los programadores Java tambi&eacute;n es algo nuevo - aunque la idea existe desde mucho tiempo.</p>

<p>Nosotros usamos la metodolog&iacute;a <a href="/2007/01/31/1170302593849.html">Scrum</a> y usamos t&eacute;cnicas generales como <a href="/2006/12/08/1165587482609.html">DDD</a>, TDD y CI. Usamos Java porque es un lenguaje universal que nos permite aplicar eso en cualquier proyecto para cualquier plataforma y no nos limite a proyectos web. Tambi&eacute;n usamos Java porque es un lenguaje OOP (object-oriented programming) y por este hecho nos ayuda dise&ntilde;ar en una manera limpia. OOP fue inventado como antes de 20 anos y hay muy buena experiencia con eso.</p>

<p>En PHP se ha cambiado mucho &uacute;ltimamente. Se ha extendido PHP para poder programar con objetos. Pero sin embargo en <a href="http://www.php.net">http://www.php.net</a> se dice: "PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML." Wikipedia tiene una buena definici&oacute;n para <a href="http://en.wikipedia.org/wiki/Scripting_language">"scripting language"</a>.</p>
